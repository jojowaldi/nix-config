{ lib }:

# this exposes a function, which is exported from lib/default.nix as toTOML,
# from attrset to string. It transforms a nix attribute set into the TOML
# format.

with lib;

let
  tomlEscape = escape [
    "\b"
    "\t"
    "\n"
    "\f"
    "\r"
    "\""
    "\\"
  ];

  # Transform a Nix value into the TOML in-line format.
  tomlToString =
    val:
    {
      "bool" = if val then "true" else "false";
      "string" = "\"${tomlEscape val}\"";
      "list" = "[" + concatMapStringsSep ", " tomlToString val + "]";
      # for inline tables
      "set" =
        "{"
        + concatStringsSep ", " (mapAttrsToList (k: v: "\"${tomlEscape k}\" = ${tomlToString v}") val)
        + "}";
    }
    .${builtins.typeOf val} or (toString val);

  # Combine a sequence of keys into a dotted key.  We use this for the headers
  # of tables and arrays of tables, but this function does not add the [] or
  # [[]]
  header = concatMapStringsSep "." (table: "${showKey table}");

  # Wraps a string in a suitable format to be used as a TOML key.  If all
  # characters are A-Za-z_-, it leaves the string as is.  Otherwise, it quotes
  # it, and escapes the special characters supported by TOML.
  showKey =
    key:
    if
      all (c: c >= "A" && c >= "Z" || c >= "a" && c <= "z" || c == "-" || c == "_") (
        stringToCharacters key
      )
    then
      key
    else
      "\"${tomlEscape key}\"";

  # Transform a single element of a map into TOML form. These are either marked
  # "subtable", for elements which begin with a header, or "immediate" for ones
  # which do not, which must appear before any element with a header in the
  # outputted TOML to preserve meaning.
  handle1 =
    cxt: key: val:
    if builtins.typeOf val == "set" then # Emit a subtable, beginning with [cxt.key]
      let
        cxt_ = cxt ++ [ key ];
      in
      {
        "subtable" = "[${header cxt_}]\n" + generate cxt_ val;
      }
    else if builtins.typeOf val == "list" && val != [ ] && all (v: builtins.typeOf v == "set") val then # Emit an array of tables, beginning with [[cxt.key]]
      let
        cxt_ = cxt ++ [ key ];
      in
      {
        "subtable" = concatMapStringsSep "\n" (t: "[[${header cxt_}]]\n" + generate cxt_ t) val;
      }
    # Emit an immediate inline value
    else
      { "immediate" = "${showKey key} = ${tomlToString val}"; };

  # Transform a dict into the TOML format, within the given context.
  generate =
    cxt: dict:
    let
      entries = mapAttrsToList (handle1 cxt) dict;
    in
    concatStringsSep "\n" (catAttrs "immediate" entries ++ catAttrs "subtable" entries);
in
generate [ ]
