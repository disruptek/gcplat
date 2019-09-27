
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Poly
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## The Poly API provides read access to assets hosted on <a href="https://poly.google.com">poly.google.com</a> to all, and upload access to <a href="https://poly.google.com">poly.google.com</a> for whitelisted accounts.
## 
## 
## https://developers.google.com/poly/
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "poly"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PolyAssetsList_593677 = ref object of OpenApiRestCall_593408
proc url_PolyAssetsList_593679(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PolyAssetsList_593678(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all public, remixable assets. These are assets with an access level
  ## of PUBLIC and published under the
  ## CC-By license.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   curated: JBool
  ##          : Return only assets that have been curated by the Poly team.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   keywords: JString
  ##           : One or more search terms to be matched against all text that Poly has
  ## indexed for assets, which includes display_name,
  ## description, and tags. Multiple keywords should be
  ## separated by spaces.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Specifies a continuation token from a previous search whose results were
  ## split into multiple pages. To get the next page, submit the same request
  ## specifying the value from
  ## next_page_token.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   orderBy: JString
  ##          : Specifies an ordering for assets. Acceptable values are:
  ## `BEST`, `NEWEST`, `OLDEST`. Defaults to `BEST`, which ranks assets
  ## based on a combination of popularity and other features.
  ##   maxComplexity: JString
  ##                : Returns assets that are of the specified complexity or less. Defaults to
  ## COMPLEX. For example, a request for
  ## MEDIUM assets also includes
  ## SIMPLE assets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of assets to be returned. This value must be between `1`
  ## and `100`. Defaults to `20`.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   format: JString
  ##         : Return only assets with the matching format. Acceptable values are:
  ## `BLOCKS`, `FBX`, `GLTF`, `GLTF2`, `OBJ`, `TILT`.
  ##   category: JString
  ##           : Filter assets based on the specified category. Supported values are:
  ## `animals`, `architecture`, `art`, `food`, `nature`, `objects`, `people`,
  ## `scenes`, `technology`, and `transport`.
  section = newJObject()
  var valid_593791 = query.getOrDefault("upload_protocol")
  valid_593791 = validateParameter(valid_593791, JString, required = false,
                                 default = nil)
  if valid_593791 != nil:
    section.add "upload_protocol", valid_593791
  var valid_593792 = query.getOrDefault("curated")
  valid_593792 = validateParameter(valid_593792, JBool, required = false, default = nil)
  if valid_593792 != nil:
    section.add "curated", valid_593792
  var valid_593793 = query.getOrDefault("fields")
  valid_593793 = validateParameter(valid_593793, JString, required = false,
                                 default = nil)
  if valid_593793 != nil:
    section.add "fields", valid_593793
  var valid_593794 = query.getOrDefault("keywords")
  valid_593794 = validateParameter(valid_593794, JString, required = false,
                                 default = nil)
  if valid_593794 != nil:
    section.add "keywords", valid_593794
  var valid_593795 = query.getOrDefault("quotaUser")
  valid_593795 = validateParameter(valid_593795, JString, required = false,
                                 default = nil)
  if valid_593795 != nil:
    section.add "quotaUser", valid_593795
  var valid_593796 = query.getOrDefault("pageToken")
  valid_593796 = validateParameter(valid_593796, JString, required = false,
                                 default = nil)
  if valid_593796 != nil:
    section.add "pageToken", valid_593796
  var valid_593810 = query.getOrDefault("alt")
  valid_593810 = validateParameter(valid_593810, JString, required = false,
                                 default = newJString("json"))
  if valid_593810 != nil:
    section.add "alt", valid_593810
  var valid_593811 = query.getOrDefault("oauth_token")
  valid_593811 = validateParameter(valid_593811, JString, required = false,
                                 default = nil)
  if valid_593811 != nil:
    section.add "oauth_token", valid_593811
  var valid_593812 = query.getOrDefault("callback")
  valid_593812 = validateParameter(valid_593812, JString, required = false,
                                 default = nil)
  if valid_593812 != nil:
    section.add "callback", valid_593812
  var valid_593813 = query.getOrDefault("access_token")
  valid_593813 = validateParameter(valid_593813, JString, required = false,
                                 default = nil)
  if valid_593813 != nil:
    section.add "access_token", valid_593813
  var valid_593814 = query.getOrDefault("uploadType")
  valid_593814 = validateParameter(valid_593814, JString, required = false,
                                 default = nil)
  if valid_593814 != nil:
    section.add "uploadType", valid_593814
  var valid_593815 = query.getOrDefault("orderBy")
  valid_593815 = validateParameter(valid_593815, JString, required = false,
                                 default = nil)
  if valid_593815 != nil:
    section.add "orderBy", valid_593815
  var valid_593816 = query.getOrDefault("maxComplexity")
  valid_593816 = validateParameter(valid_593816, JString, required = false,
                                 default = newJString("COMPLEXITY_UNSPECIFIED"))
  if valid_593816 != nil:
    section.add "maxComplexity", valid_593816
  var valid_593817 = query.getOrDefault("key")
  valid_593817 = validateParameter(valid_593817, JString, required = false,
                                 default = nil)
  if valid_593817 != nil:
    section.add "key", valid_593817
  var valid_593818 = query.getOrDefault("$.xgafv")
  valid_593818 = validateParameter(valid_593818, JString, required = false,
                                 default = newJString("1"))
  if valid_593818 != nil:
    section.add "$.xgafv", valid_593818
  var valid_593819 = query.getOrDefault("pageSize")
  valid_593819 = validateParameter(valid_593819, JInt, required = false, default = nil)
  if valid_593819 != nil:
    section.add "pageSize", valid_593819
  var valid_593820 = query.getOrDefault("prettyPrint")
  valid_593820 = validateParameter(valid_593820, JBool, required = false,
                                 default = newJBool(true))
  if valid_593820 != nil:
    section.add "prettyPrint", valid_593820
  var valid_593821 = query.getOrDefault("format")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = nil)
  if valid_593821 != nil:
    section.add "format", valid_593821
  var valid_593822 = query.getOrDefault("category")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "category", valid_593822
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593845: Call_PolyAssetsList_593677; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all public, remixable assets. These are assets with an access level
  ## of PUBLIC and published under the
  ## CC-By license.
  ## 
  let valid = call_593845.validator(path, query, header, formData, body)
  let scheme = call_593845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593845.url(scheme.get, call_593845.host, call_593845.base,
                         call_593845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593845, url, valid)

proc call*(call_593916: Call_PolyAssetsList_593677; uploadProtocol: string = "";
          curated: bool = false; fields: string = ""; keywords: string = "";
          quotaUser: string = ""; pageToken: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; orderBy: string = "";
          maxComplexity: string = "COMPLEXITY_UNSPECIFIED"; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          format: string = ""; category: string = ""): Recallable =
  ## polyAssetsList
  ## Lists all public, remixable assets. These are assets with an access level
  ## of PUBLIC and published under the
  ## CC-By license.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   curated: bool
  ##          : Return only assets that have been curated by the Poly team.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   keywords: string
  ##           : One or more search terms to be matched against all text that Poly has
  ## indexed for assets, which includes display_name,
  ## description, and tags. Multiple keywords should be
  ## separated by spaces.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Specifies a continuation token from a previous search whose results were
  ## split into multiple pages. To get the next page, submit the same request
  ## specifying the value from
  ## next_page_token.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   orderBy: string
  ##          : Specifies an ordering for assets. Acceptable values are:
  ## `BEST`, `NEWEST`, `OLDEST`. Defaults to `BEST`, which ranks assets
  ## based on a combination of popularity and other features.
  ##   maxComplexity: string
  ##                : Returns assets that are of the specified complexity or less. Defaults to
  ## COMPLEX. For example, a request for
  ## MEDIUM assets also includes
  ## SIMPLE assets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of assets to be returned. This value must be between `1`
  ## and `100`. Defaults to `20`.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   format: string
  ##         : Return only assets with the matching format. Acceptable values are:
  ## `BLOCKS`, `FBX`, `GLTF`, `GLTF2`, `OBJ`, `TILT`.
  ##   category: string
  ##           : Filter assets based on the specified category. Supported values are:
  ## `animals`, `architecture`, `art`, `food`, `nature`, `objects`, `people`,
  ## `scenes`, `technology`, and `transport`.
  var query_593917 = newJObject()
  add(query_593917, "upload_protocol", newJString(uploadProtocol))
  add(query_593917, "curated", newJBool(curated))
  add(query_593917, "fields", newJString(fields))
  add(query_593917, "keywords", newJString(keywords))
  add(query_593917, "quotaUser", newJString(quotaUser))
  add(query_593917, "pageToken", newJString(pageToken))
  add(query_593917, "alt", newJString(alt))
  add(query_593917, "oauth_token", newJString(oauthToken))
  add(query_593917, "callback", newJString(callback))
  add(query_593917, "access_token", newJString(accessToken))
  add(query_593917, "uploadType", newJString(uploadType))
  add(query_593917, "orderBy", newJString(orderBy))
  add(query_593917, "maxComplexity", newJString(maxComplexity))
  add(query_593917, "key", newJString(key))
  add(query_593917, "$.xgafv", newJString(Xgafv))
  add(query_593917, "pageSize", newJInt(pageSize))
  add(query_593917, "prettyPrint", newJBool(prettyPrint))
  add(query_593917, "format", newJString(format))
  add(query_593917, "category", newJString(category))
  result = call_593916.call(nil, query_593917, nil, nil, nil)

var polyAssetsList* = Call_PolyAssetsList_593677(name: "polyAssetsList",
    meth: HttpMethod.HttpGet, host: "poly.googleapis.com", route: "/v1/assets",
    validator: validate_PolyAssetsList_593678, base: "/", url: url_PolyAssetsList_593679,
    schemes: {Scheme.Https})
type
  Call_PolyAssetsGet_593957 = ref object of OpenApiRestCall_593408
proc url_PolyAssetsGet_593959(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolyAssetsGet_593958(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns detailed information about an asset given its name.
  ## PRIVATE assets are returned only if
  ##  the currently authenticated user (via OAuth token) is the author of the
  ##  asset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. An asset's name in the form `assets/{ASSET_ID}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_593974 = path.getOrDefault("name")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "name", valid_593974
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593975 = query.getOrDefault("upload_protocol")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "upload_protocol", valid_593975
  var valid_593976 = query.getOrDefault("fields")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "fields", valid_593976
  var valid_593977 = query.getOrDefault("quotaUser")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "quotaUser", valid_593977
  var valid_593978 = query.getOrDefault("alt")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = newJString("json"))
  if valid_593978 != nil:
    section.add "alt", valid_593978
  var valid_593979 = query.getOrDefault("oauth_token")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = nil)
  if valid_593979 != nil:
    section.add "oauth_token", valid_593979
  var valid_593980 = query.getOrDefault("callback")
  valid_593980 = validateParameter(valid_593980, JString, required = false,
                                 default = nil)
  if valid_593980 != nil:
    section.add "callback", valid_593980
  var valid_593981 = query.getOrDefault("access_token")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = nil)
  if valid_593981 != nil:
    section.add "access_token", valid_593981
  var valid_593982 = query.getOrDefault("uploadType")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "uploadType", valid_593982
  var valid_593983 = query.getOrDefault("key")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "key", valid_593983
  var valid_593984 = query.getOrDefault("$.xgafv")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = newJString("1"))
  if valid_593984 != nil:
    section.add "$.xgafv", valid_593984
  var valid_593985 = query.getOrDefault("prettyPrint")
  valid_593985 = validateParameter(valid_593985, JBool, required = false,
                                 default = newJBool(true))
  if valid_593985 != nil:
    section.add "prettyPrint", valid_593985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593986: Call_PolyAssetsGet_593957; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns detailed information about an asset given its name.
  ## PRIVATE assets are returned only if
  ##  the currently authenticated user (via OAuth token) is the author of the
  ##  asset.
  ## 
  let valid = call_593986.validator(path, query, header, formData, body)
  let scheme = call_593986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593986.url(scheme.get, call_593986.host, call_593986.base,
                         call_593986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593986, url, valid)

proc call*(call_593987: Call_PolyAssetsGet_593957; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## polyAssetsGet
  ## Returns detailed information about an asset given its name.
  ## PRIVATE assets are returned only if
  ##  the currently authenticated user (via OAuth token) is the author of the
  ##  asset.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. An asset's name in the form `assets/{ASSET_ID}`.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_593988 = newJObject()
  var query_593989 = newJObject()
  add(query_593989, "upload_protocol", newJString(uploadProtocol))
  add(query_593989, "fields", newJString(fields))
  add(query_593989, "quotaUser", newJString(quotaUser))
  add(path_593988, "name", newJString(name))
  add(query_593989, "alt", newJString(alt))
  add(query_593989, "oauth_token", newJString(oauthToken))
  add(query_593989, "callback", newJString(callback))
  add(query_593989, "access_token", newJString(accessToken))
  add(query_593989, "uploadType", newJString(uploadType))
  add(query_593989, "key", newJString(key))
  add(query_593989, "$.xgafv", newJString(Xgafv))
  add(query_593989, "prettyPrint", newJBool(prettyPrint))
  result = call_593987.call(path_593988, query_593989, nil, nil, nil)

var polyAssetsGet* = Call_PolyAssetsGet_593957(name: "polyAssetsGet",
    meth: HttpMethod.HttpGet, host: "poly.googleapis.com", route: "/v1/{name}",
    validator: validate_PolyAssetsGet_593958, base: "/", url: url_PolyAssetsGet_593959,
    schemes: {Scheme.Https})
type
  Call_PolyUsersAssetsList_593990 = ref object of OpenApiRestCall_593408
proc url_PolyUsersAssetsList_593992(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/assets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolyUsersAssetsList_593991(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lists assets authored by the given user. Only the value 'me', representing
  ## the currently-authenticated user, is supported. May include assets with an
  ## access level of PRIVATE or
  ## UNLISTED and assets which are
  ## All Rights Reserved for the
  ## currently-authenticated user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : A valid user id. Currently, only the special value 'me', representing the
  ## currently-authenticated user is supported. To use 'me', you must pass
  ## an OAuth token with the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_593993 = path.getOrDefault("name")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "name", valid_593993
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a continuation token from a previous search whose results were
  ## split into multiple pages. To get the next page, submit the same request
  ## specifying the value from
  ## next_page_token.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   orderBy: JString
  ##          : Specifies an ordering for assets. Acceptable values are:
  ## `BEST`, `NEWEST`, `OLDEST`. Defaults to `BEST`, which ranks assets
  ## based on a combination of popularity and other features.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of assets to be returned. This value must be between `1`
  ## and `100`. Defaults to `20`.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   format: JString
  ##         : Return only assets with the matching format. Acceptable values are:
  ## `BLOCKS`, `FBX`, `GLTF`, `GLTF2`, `OBJ`, and `TILT`.
  ##   visibility: JString
  ##             : The visibility of the assets to be returned.
  ## Defaults to
  ## VISIBILITY_UNSPECIFIED
  ## which returns all assets.
  section = newJObject()
  var valid_593994 = query.getOrDefault("upload_protocol")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "upload_protocol", valid_593994
  var valid_593995 = query.getOrDefault("fields")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "fields", valid_593995
  var valid_593996 = query.getOrDefault("pageToken")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "pageToken", valid_593996
  var valid_593997 = query.getOrDefault("quotaUser")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "quotaUser", valid_593997
  var valid_593998 = query.getOrDefault("alt")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = newJString("json"))
  if valid_593998 != nil:
    section.add "alt", valid_593998
  var valid_593999 = query.getOrDefault("oauth_token")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "oauth_token", valid_593999
  var valid_594000 = query.getOrDefault("callback")
  valid_594000 = validateParameter(valid_594000, JString, required = false,
                                 default = nil)
  if valid_594000 != nil:
    section.add "callback", valid_594000
  var valid_594001 = query.getOrDefault("access_token")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = nil)
  if valid_594001 != nil:
    section.add "access_token", valid_594001
  var valid_594002 = query.getOrDefault("uploadType")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "uploadType", valid_594002
  var valid_594003 = query.getOrDefault("orderBy")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = nil)
  if valid_594003 != nil:
    section.add "orderBy", valid_594003
  var valid_594004 = query.getOrDefault("key")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = nil)
  if valid_594004 != nil:
    section.add "key", valid_594004
  var valid_594005 = query.getOrDefault("$.xgafv")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = newJString("1"))
  if valid_594005 != nil:
    section.add "$.xgafv", valid_594005
  var valid_594006 = query.getOrDefault("pageSize")
  valid_594006 = validateParameter(valid_594006, JInt, required = false, default = nil)
  if valid_594006 != nil:
    section.add "pageSize", valid_594006
  var valid_594007 = query.getOrDefault("prettyPrint")
  valid_594007 = validateParameter(valid_594007, JBool, required = false,
                                 default = newJBool(true))
  if valid_594007 != nil:
    section.add "prettyPrint", valid_594007
  var valid_594008 = query.getOrDefault("format")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "format", valid_594008
  var valid_594009 = query.getOrDefault("visibility")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = newJString("VISIBILITY_UNSPECIFIED"))
  if valid_594009 != nil:
    section.add "visibility", valid_594009
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594010: Call_PolyUsersAssetsList_593990; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists assets authored by the given user. Only the value 'me', representing
  ## the currently-authenticated user, is supported. May include assets with an
  ## access level of PRIVATE or
  ## UNLISTED and assets which are
  ## All Rights Reserved for the
  ## currently-authenticated user.
  ## 
  let valid = call_594010.validator(path, query, header, formData, body)
  let scheme = call_594010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594010.url(scheme.get, call_594010.host, call_594010.base,
                         call_594010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594010, url, valid)

proc call*(call_594011: Call_PolyUsersAssetsList_593990; name: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          orderBy: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; format: string = "";
          visibility: string = "VISIBILITY_UNSPECIFIED"): Recallable =
  ## polyUsersAssetsList
  ## Lists assets authored by the given user. Only the value 'me', representing
  ## the currently-authenticated user, is supported. May include assets with an
  ## access level of PRIVATE or
  ## UNLISTED and assets which are
  ## All Rights Reserved for the
  ## currently-authenticated user.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a continuation token from a previous search whose results were
  ## split into multiple pages. To get the next page, submit the same request
  ## specifying the value from
  ## next_page_token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : A valid user id. Currently, only the special value 'me', representing the
  ## currently-authenticated user is supported. To use 'me', you must pass
  ## an OAuth token with the request.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   orderBy: string
  ##          : Specifies an ordering for assets. Acceptable values are:
  ## `BEST`, `NEWEST`, `OLDEST`. Defaults to `BEST`, which ranks assets
  ## based on a combination of popularity and other features.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of assets to be returned. This value must be between `1`
  ## and `100`. Defaults to `20`.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   format: string
  ##         : Return only assets with the matching format. Acceptable values are:
  ## `BLOCKS`, `FBX`, `GLTF`, `GLTF2`, `OBJ`, and `TILT`.
  ##   visibility: string
  ##             : The visibility of the assets to be returned.
  ## Defaults to
  ## VISIBILITY_UNSPECIFIED
  ## which returns all assets.
  var path_594012 = newJObject()
  var query_594013 = newJObject()
  add(query_594013, "upload_protocol", newJString(uploadProtocol))
  add(query_594013, "fields", newJString(fields))
  add(query_594013, "pageToken", newJString(pageToken))
  add(query_594013, "quotaUser", newJString(quotaUser))
  add(path_594012, "name", newJString(name))
  add(query_594013, "alt", newJString(alt))
  add(query_594013, "oauth_token", newJString(oauthToken))
  add(query_594013, "callback", newJString(callback))
  add(query_594013, "access_token", newJString(accessToken))
  add(query_594013, "uploadType", newJString(uploadType))
  add(query_594013, "orderBy", newJString(orderBy))
  add(query_594013, "key", newJString(key))
  add(query_594013, "$.xgafv", newJString(Xgafv))
  add(query_594013, "pageSize", newJInt(pageSize))
  add(query_594013, "prettyPrint", newJBool(prettyPrint))
  add(query_594013, "format", newJString(format))
  add(query_594013, "visibility", newJString(visibility))
  result = call_594011.call(path_594012, query_594013, nil, nil, nil)

var polyUsersAssetsList* = Call_PolyUsersAssetsList_593990(
    name: "polyUsersAssetsList", meth: HttpMethod.HttpGet,
    host: "poly.googleapis.com", route: "/v1/{name}/assets",
    validator: validate_PolyUsersAssetsList_593991, base: "/",
    url: url_PolyUsersAssetsList_593992, schemes: {Scheme.Https})
type
  Call_PolyUsersLikedassetsList_594014 = ref object of OpenApiRestCall_593408
proc url_PolyUsersLikedassetsList_594016(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/likedassets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolyUsersLikedassetsList_594015(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists assets that the user has liked. Only the value 'me', representing
  ## the currently-authenticated user, is supported. May include assets with an
  ## access level of UNLISTED.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : A valid user id. Currently, only the special value 'me', representing the
  ## currently-authenticated user is supported. To use 'me', you must pass
  ## an OAuth token with the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594017 = path.getOrDefault("name")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "name", valid_594017
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a continuation token from a previous search whose results were
  ## split into multiple pages. To get the next page, submit the same request
  ## specifying the value from
  ## next_page_token.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   orderBy: JString
  ##          : Specifies an ordering for assets. Acceptable values are:
  ## `BEST`, `NEWEST`, `OLDEST`, 'LIKED_TIME'. Defaults to `LIKED_TIME`, which
  ## ranks assets based on how recently they were liked.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of assets to be returned. This value must be between `1`
  ## and `100`. Defaults to `20`.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   format: JString
  ##         : Return only assets with the matching format. Acceptable values are:
  ## `BLOCKS`, `FBX`, `GLTF`, `GLTF2`, `OBJ`, `TILT`.
  section = newJObject()
  var valid_594018 = query.getOrDefault("upload_protocol")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "upload_protocol", valid_594018
  var valid_594019 = query.getOrDefault("fields")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "fields", valid_594019
  var valid_594020 = query.getOrDefault("pageToken")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = nil)
  if valid_594020 != nil:
    section.add "pageToken", valid_594020
  var valid_594021 = query.getOrDefault("quotaUser")
  valid_594021 = validateParameter(valid_594021, JString, required = false,
                                 default = nil)
  if valid_594021 != nil:
    section.add "quotaUser", valid_594021
  var valid_594022 = query.getOrDefault("alt")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = newJString("json"))
  if valid_594022 != nil:
    section.add "alt", valid_594022
  var valid_594023 = query.getOrDefault("oauth_token")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "oauth_token", valid_594023
  var valid_594024 = query.getOrDefault("callback")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "callback", valid_594024
  var valid_594025 = query.getOrDefault("access_token")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "access_token", valid_594025
  var valid_594026 = query.getOrDefault("uploadType")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "uploadType", valid_594026
  var valid_594027 = query.getOrDefault("orderBy")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "orderBy", valid_594027
  var valid_594028 = query.getOrDefault("key")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "key", valid_594028
  var valid_594029 = query.getOrDefault("$.xgafv")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = newJString("1"))
  if valid_594029 != nil:
    section.add "$.xgafv", valid_594029
  var valid_594030 = query.getOrDefault("pageSize")
  valid_594030 = validateParameter(valid_594030, JInt, required = false, default = nil)
  if valid_594030 != nil:
    section.add "pageSize", valid_594030
  var valid_594031 = query.getOrDefault("prettyPrint")
  valid_594031 = validateParameter(valid_594031, JBool, required = false,
                                 default = newJBool(true))
  if valid_594031 != nil:
    section.add "prettyPrint", valid_594031
  var valid_594032 = query.getOrDefault("format")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "format", valid_594032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594033: Call_PolyUsersLikedassetsList_594014; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists assets that the user has liked. Only the value 'me', representing
  ## the currently-authenticated user, is supported. May include assets with an
  ## access level of UNLISTED.
  ## 
  let valid = call_594033.validator(path, query, header, formData, body)
  let scheme = call_594033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594033.url(scheme.get, call_594033.host, call_594033.base,
                         call_594033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594033, url, valid)

proc call*(call_594034: Call_PolyUsersLikedassetsList_594014; name: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          orderBy: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; format: string = ""): Recallable =
  ## polyUsersLikedassetsList
  ## Lists assets that the user has liked. Only the value 'me', representing
  ## the currently-authenticated user, is supported. May include assets with an
  ## access level of UNLISTED.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a continuation token from a previous search whose results were
  ## split into multiple pages. To get the next page, submit the same request
  ## specifying the value from
  ## next_page_token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : A valid user id. Currently, only the special value 'me', representing the
  ## currently-authenticated user is supported. To use 'me', you must pass
  ## an OAuth token with the request.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   orderBy: string
  ##          : Specifies an ordering for assets. Acceptable values are:
  ## `BEST`, `NEWEST`, `OLDEST`, 'LIKED_TIME'. Defaults to `LIKED_TIME`, which
  ## ranks assets based on how recently they were liked.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of assets to be returned. This value must be between `1`
  ## and `100`. Defaults to `20`.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   format: string
  ##         : Return only assets with the matching format. Acceptable values are:
  ## `BLOCKS`, `FBX`, `GLTF`, `GLTF2`, `OBJ`, `TILT`.
  var path_594035 = newJObject()
  var query_594036 = newJObject()
  add(query_594036, "upload_protocol", newJString(uploadProtocol))
  add(query_594036, "fields", newJString(fields))
  add(query_594036, "pageToken", newJString(pageToken))
  add(query_594036, "quotaUser", newJString(quotaUser))
  add(path_594035, "name", newJString(name))
  add(query_594036, "alt", newJString(alt))
  add(query_594036, "oauth_token", newJString(oauthToken))
  add(query_594036, "callback", newJString(callback))
  add(query_594036, "access_token", newJString(accessToken))
  add(query_594036, "uploadType", newJString(uploadType))
  add(query_594036, "orderBy", newJString(orderBy))
  add(query_594036, "key", newJString(key))
  add(query_594036, "$.xgafv", newJString(Xgafv))
  add(query_594036, "pageSize", newJInt(pageSize))
  add(query_594036, "prettyPrint", newJBool(prettyPrint))
  add(query_594036, "format", newJString(format))
  result = call_594034.call(path_594035, query_594036, nil, nil, nil)

var polyUsersLikedassetsList* = Call_PolyUsersLikedassetsList_594014(
    name: "polyUsersLikedassetsList", meth: HttpMethod.HttpGet,
    host: "poly.googleapis.com", route: "/v1/{name}/likedassets",
    validator: validate_PolyUsersLikedassetsList_594015, base: "/",
    url: url_PolyUsersLikedassetsList_594016, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
