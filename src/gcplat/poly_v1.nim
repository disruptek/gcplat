
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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

  OpenApiRestCall_579408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579408): Option[Scheme] {.used.} =
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
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PolyAssetsList_579677 = ref object of OpenApiRestCall_579408
proc url_PolyAssetsList_579679(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PolyAssetsList_579678(path: JsonNode; query: JsonNode;
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
  var valid_579791 = query.getOrDefault("upload_protocol")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "upload_protocol", valid_579791
  var valid_579792 = query.getOrDefault("curated")
  valid_579792 = validateParameter(valid_579792, JBool, required = false, default = nil)
  if valid_579792 != nil:
    section.add "curated", valid_579792
  var valid_579793 = query.getOrDefault("fields")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = nil)
  if valid_579793 != nil:
    section.add "fields", valid_579793
  var valid_579794 = query.getOrDefault("keywords")
  valid_579794 = validateParameter(valid_579794, JString, required = false,
                                 default = nil)
  if valid_579794 != nil:
    section.add "keywords", valid_579794
  var valid_579795 = query.getOrDefault("quotaUser")
  valid_579795 = validateParameter(valid_579795, JString, required = false,
                                 default = nil)
  if valid_579795 != nil:
    section.add "quotaUser", valid_579795
  var valid_579796 = query.getOrDefault("pageToken")
  valid_579796 = validateParameter(valid_579796, JString, required = false,
                                 default = nil)
  if valid_579796 != nil:
    section.add "pageToken", valid_579796
  var valid_579810 = query.getOrDefault("alt")
  valid_579810 = validateParameter(valid_579810, JString, required = false,
                                 default = newJString("json"))
  if valid_579810 != nil:
    section.add "alt", valid_579810
  var valid_579811 = query.getOrDefault("oauth_token")
  valid_579811 = validateParameter(valid_579811, JString, required = false,
                                 default = nil)
  if valid_579811 != nil:
    section.add "oauth_token", valid_579811
  var valid_579812 = query.getOrDefault("callback")
  valid_579812 = validateParameter(valid_579812, JString, required = false,
                                 default = nil)
  if valid_579812 != nil:
    section.add "callback", valid_579812
  var valid_579813 = query.getOrDefault("access_token")
  valid_579813 = validateParameter(valid_579813, JString, required = false,
                                 default = nil)
  if valid_579813 != nil:
    section.add "access_token", valid_579813
  var valid_579814 = query.getOrDefault("uploadType")
  valid_579814 = validateParameter(valid_579814, JString, required = false,
                                 default = nil)
  if valid_579814 != nil:
    section.add "uploadType", valid_579814
  var valid_579815 = query.getOrDefault("orderBy")
  valid_579815 = validateParameter(valid_579815, JString, required = false,
                                 default = nil)
  if valid_579815 != nil:
    section.add "orderBy", valid_579815
  var valid_579816 = query.getOrDefault("maxComplexity")
  valid_579816 = validateParameter(valid_579816, JString, required = false,
                                 default = newJString("COMPLEXITY_UNSPECIFIED"))
  if valid_579816 != nil:
    section.add "maxComplexity", valid_579816
  var valid_579817 = query.getOrDefault("key")
  valid_579817 = validateParameter(valid_579817, JString, required = false,
                                 default = nil)
  if valid_579817 != nil:
    section.add "key", valid_579817
  var valid_579818 = query.getOrDefault("$.xgafv")
  valid_579818 = validateParameter(valid_579818, JString, required = false,
                                 default = newJString("1"))
  if valid_579818 != nil:
    section.add "$.xgafv", valid_579818
  var valid_579819 = query.getOrDefault("pageSize")
  valid_579819 = validateParameter(valid_579819, JInt, required = false, default = nil)
  if valid_579819 != nil:
    section.add "pageSize", valid_579819
  var valid_579820 = query.getOrDefault("prettyPrint")
  valid_579820 = validateParameter(valid_579820, JBool, required = false,
                                 default = newJBool(true))
  if valid_579820 != nil:
    section.add "prettyPrint", valid_579820
  var valid_579821 = query.getOrDefault("format")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "format", valid_579821
  var valid_579822 = query.getOrDefault("category")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "category", valid_579822
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579845: Call_PolyAssetsList_579677; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all public, remixable assets. These are assets with an access level
  ## of PUBLIC and published under the
  ## CC-By license.
  ## 
  let valid = call_579845.validator(path, query, header, formData, body)
  let scheme = call_579845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579845.url(scheme.get, call_579845.host, call_579845.base,
                         call_579845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579845, url, valid)

proc call*(call_579916: Call_PolyAssetsList_579677; uploadProtocol: string = "";
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
  var query_579917 = newJObject()
  add(query_579917, "upload_protocol", newJString(uploadProtocol))
  add(query_579917, "curated", newJBool(curated))
  add(query_579917, "fields", newJString(fields))
  add(query_579917, "keywords", newJString(keywords))
  add(query_579917, "quotaUser", newJString(quotaUser))
  add(query_579917, "pageToken", newJString(pageToken))
  add(query_579917, "alt", newJString(alt))
  add(query_579917, "oauth_token", newJString(oauthToken))
  add(query_579917, "callback", newJString(callback))
  add(query_579917, "access_token", newJString(accessToken))
  add(query_579917, "uploadType", newJString(uploadType))
  add(query_579917, "orderBy", newJString(orderBy))
  add(query_579917, "maxComplexity", newJString(maxComplexity))
  add(query_579917, "key", newJString(key))
  add(query_579917, "$.xgafv", newJString(Xgafv))
  add(query_579917, "pageSize", newJInt(pageSize))
  add(query_579917, "prettyPrint", newJBool(prettyPrint))
  add(query_579917, "format", newJString(format))
  add(query_579917, "category", newJString(category))
  result = call_579916.call(nil, query_579917, nil, nil, nil)

var polyAssetsList* = Call_PolyAssetsList_579677(name: "polyAssetsList",
    meth: HttpMethod.HttpGet, host: "poly.googleapis.com", route: "/v1/assets",
    validator: validate_PolyAssetsList_579678, base: "/", url: url_PolyAssetsList_579679,
    schemes: {Scheme.Https})
type
  Call_PolyAssetsGet_579957 = ref object of OpenApiRestCall_579408
proc url_PolyAssetsGet_579959(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolyAssetsGet_579958(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_579974 = path.getOrDefault("name")
  valid_579974 = validateParameter(valid_579974, JString, required = true,
                                 default = nil)
  if valid_579974 != nil:
    section.add "name", valid_579974
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
  var valid_579975 = query.getOrDefault("upload_protocol")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "upload_protocol", valid_579975
  var valid_579976 = query.getOrDefault("fields")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "fields", valid_579976
  var valid_579977 = query.getOrDefault("quotaUser")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "quotaUser", valid_579977
  var valid_579978 = query.getOrDefault("alt")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = newJString("json"))
  if valid_579978 != nil:
    section.add "alt", valid_579978
  var valid_579979 = query.getOrDefault("oauth_token")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "oauth_token", valid_579979
  var valid_579980 = query.getOrDefault("callback")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "callback", valid_579980
  var valid_579981 = query.getOrDefault("access_token")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "access_token", valid_579981
  var valid_579982 = query.getOrDefault("uploadType")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "uploadType", valid_579982
  var valid_579983 = query.getOrDefault("key")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "key", valid_579983
  var valid_579984 = query.getOrDefault("$.xgafv")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = newJString("1"))
  if valid_579984 != nil:
    section.add "$.xgafv", valid_579984
  var valid_579985 = query.getOrDefault("prettyPrint")
  valid_579985 = validateParameter(valid_579985, JBool, required = false,
                                 default = newJBool(true))
  if valid_579985 != nil:
    section.add "prettyPrint", valid_579985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579986: Call_PolyAssetsGet_579957; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns detailed information about an asset given its name.
  ## PRIVATE assets are returned only if
  ##  the currently authenticated user (via OAuth token) is the author of the
  ##  asset.
  ## 
  let valid = call_579986.validator(path, query, header, formData, body)
  let scheme = call_579986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579986.url(scheme.get, call_579986.host, call_579986.base,
                         call_579986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579986, url, valid)

proc call*(call_579987: Call_PolyAssetsGet_579957; name: string;
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
  var path_579988 = newJObject()
  var query_579989 = newJObject()
  add(query_579989, "upload_protocol", newJString(uploadProtocol))
  add(query_579989, "fields", newJString(fields))
  add(query_579989, "quotaUser", newJString(quotaUser))
  add(path_579988, "name", newJString(name))
  add(query_579989, "alt", newJString(alt))
  add(query_579989, "oauth_token", newJString(oauthToken))
  add(query_579989, "callback", newJString(callback))
  add(query_579989, "access_token", newJString(accessToken))
  add(query_579989, "uploadType", newJString(uploadType))
  add(query_579989, "key", newJString(key))
  add(query_579989, "$.xgafv", newJString(Xgafv))
  add(query_579989, "prettyPrint", newJBool(prettyPrint))
  result = call_579987.call(path_579988, query_579989, nil, nil, nil)

var polyAssetsGet* = Call_PolyAssetsGet_579957(name: "polyAssetsGet",
    meth: HttpMethod.HttpGet, host: "poly.googleapis.com", route: "/v1/{name}",
    validator: validate_PolyAssetsGet_579958, base: "/", url: url_PolyAssetsGet_579959,
    schemes: {Scheme.Https})
type
  Call_PolyUsersAssetsList_579990 = ref object of OpenApiRestCall_579408
proc url_PolyUsersAssetsList_579992(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_PolyUsersAssetsList_579991(path: JsonNode; query: JsonNode;
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
  var valid_579993 = path.getOrDefault("name")
  valid_579993 = validateParameter(valid_579993, JString, required = true,
                                 default = nil)
  if valid_579993 != nil:
    section.add "name", valid_579993
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
  var valid_579994 = query.getOrDefault("upload_protocol")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "upload_protocol", valid_579994
  var valid_579995 = query.getOrDefault("fields")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "fields", valid_579995
  var valid_579996 = query.getOrDefault("pageToken")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "pageToken", valid_579996
  var valid_579997 = query.getOrDefault("quotaUser")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "quotaUser", valid_579997
  var valid_579998 = query.getOrDefault("alt")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = newJString("json"))
  if valid_579998 != nil:
    section.add "alt", valid_579998
  var valid_579999 = query.getOrDefault("oauth_token")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "oauth_token", valid_579999
  var valid_580000 = query.getOrDefault("callback")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "callback", valid_580000
  var valid_580001 = query.getOrDefault("access_token")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "access_token", valid_580001
  var valid_580002 = query.getOrDefault("uploadType")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "uploadType", valid_580002
  var valid_580003 = query.getOrDefault("orderBy")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "orderBy", valid_580003
  var valid_580004 = query.getOrDefault("key")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "key", valid_580004
  var valid_580005 = query.getOrDefault("$.xgafv")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = newJString("1"))
  if valid_580005 != nil:
    section.add "$.xgafv", valid_580005
  var valid_580006 = query.getOrDefault("pageSize")
  valid_580006 = validateParameter(valid_580006, JInt, required = false, default = nil)
  if valid_580006 != nil:
    section.add "pageSize", valid_580006
  var valid_580007 = query.getOrDefault("prettyPrint")
  valid_580007 = validateParameter(valid_580007, JBool, required = false,
                                 default = newJBool(true))
  if valid_580007 != nil:
    section.add "prettyPrint", valid_580007
  var valid_580008 = query.getOrDefault("format")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "format", valid_580008
  var valid_580009 = query.getOrDefault("visibility")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = newJString("VISIBILITY_UNSPECIFIED"))
  if valid_580009 != nil:
    section.add "visibility", valid_580009
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580010: Call_PolyUsersAssetsList_579990; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists assets authored by the given user. Only the value 'me', representing
  ## the currently-authenticated user, is supported. May include assets with an
  ## access level of PRIVATE or
  ## UNLISTED and assets which are
  ## All Rights Reserved for the
  ## currently-authenticated user.
  ## 
  let valid = call_580010.validator(path, query, header, formData, body)
  let scheme = call_580010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580010.url(scheme.get, call_580010.host, call_580010.base,
                         call_580010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580010, url, valid)

proc call*(call_580011: Call_PolyUsersAssetsList_579990; name: string;
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
  var path_580012 = newJObject()
  var query_580013 = newJObject()
  add(query_580013, "upload_protocol", newJString(uploadProtocol))
  add(query_580013, "fields", newJString(fields))
  add(query_580013, "pageToken", newJString(pageToken))
  add(query_580013, "quotaUser", newJString(quotaUser))
  add(path_580012, "name", newJString(name))
  add(query_580013, "alt", newJString(alt))
  add(query_580013, "oauth_token", newJString(oauthToken))
  add(query_580013, "callback", newJString(callback))
  add(query_580013, "access_token", newJString(accessToken))
  add(query_580013, "uploadType", newJString(uploadType))
  add(query_580013, "orderBy", newJString(orderBy))
  add(query_580013, "key", newJString(key))
  add(query_580013, "$.xgafv", newJString(Xgafv))
  add(query_580013, "pageSize", newJInt(pageSize))
  add(query_580013, "prettyPrint", newJBool(prettyPrint))
  add(query_580013, "format", newJString(format))
  add(query_580013, "visibility", newJString(visibility))
  result = call_580011.call(path_580012, query_580013, nil, nil, nil)

var polyUsersAssetsList* = Call_PolyUsersAssetsList_579990(
    name: "polyUsersAssetsList", meth: HttpMethod.HttpGet,
    host: "poly.googleapis.com", route: "/v1/{name}/assets",
    validator: validate_PolyUsersAssetsList_579991, base: "/",
    url: url_PolyUsersAssetsList_579992, schemes: {Scheme.Https})
type
  Call_PolyUsersLikedassetsList_580014 = ref object of OpenApiRestCall_579408
proc url_PolyUsersLikedassetsList_580016(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_PolyUsersLikedassetsList_580015(path: JsonNode; query: JsonNode;
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
  var valid_580017 = path.getOrDefault("name")
  valid_580017 = validateParameter(valid_580017, JString, required = true,
                                 default = nil)
  if valid_580017 != nil:
    section.add "name", valid_580017
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
  var valid_580018 = query.getOrDefault("upload_protocol")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "upload_protocol", valid_580018
  var valid_580019 = query.getOrDefault("fields")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "fields", valid_580019
  var valid_580020 = query.getOrDefault("pageToken")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "pageToken", valid_580020
  var valid_580021 = query.getOrDefault("quotaUser")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "quotaUser", valid_580021
  var valid_580022 = query.getOrDefault("alt")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = newJString("json"))
  if valid_580022 != nil:
    section.add "alt", valid_580022
  var valid_580023 = query.getOrDefault("oauth_token")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "oauth_token", valid_580023
  var valid_580024 = query.getOrDefault("callback")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "callback", valid_580024
  var valid_580025 = query.getOrDefault("access_token")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "access_token", valid_580025
  var valid_580026 = query.getOrDefault("uploadType")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "uploadType", valid_580026
  var valid_580027 = query.getOrDefault("orderBy")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "orderBy", valid_580027
  var valid_580028 = query.getOrDefault("key")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "key", valid_580028
  var valid_580029 = query.getOrDefault("$.xgafv")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = newJString("1"))
  if valid_580029 != nil:
    section.add "$.xgafv", valid_580029
  var valid_580030 = query.getOrDefault("pageSize")
  valid_580030 = validateParameter(valid_580030, JInt, required = false, default = nil)
  if valid_580030 != nil:
    section.add "pageSize", valid_580030
  var valid_580031 = query.getOrDefault("prettyPrint")
  valid_580031 = validateParameter(valid_580031, JBool, required = false,
                                 default = newJBool(true))
  if valid_580031 != nil:
    section.add "prettyPrint", valid_580031
  var valid_580032 = query.getOrDefault("format")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "format", valid_580032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580033: Call_PolyUsersLikedassetsList_580014; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists assets that the user has liked. Only the value 'me', representing
  ## the currently-authenticated user, is supported. May include assets with an
  ## access level of UNLISTED.
  ## 
  let valid = call_580033.validator(path, query, header, formData, body)
  let scheme = call_580033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580033.url(scheme.get, call_580033.host, call_580033.base,
                         call_580033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580033, url, valid)

proc call*(call_580034: Call_PolyUsersLikedassetsList_580014; name: string;
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
  var path_580035 = newJObject()
  var query_580036 = newJObject()
  add(query_580036, "upload_protocol", newJString(uploadProtocol))
  add(query_580036, "fields", newJString(fields))
  add(query_580036, "pageToken", newJString(pageToken))
  add(query_580036, "quotaUser", newJString(quotaUser))
  add(path_580035, "name", newJString(name))
  add(query_580036, "alt", newJString(alt))
  add(query_580036, "oauth_token", newJString(oauthToken))
  add(query_580036, "callback", newJString(callback))
  add(query_580036, "access_token", newJString(accessToken))
  add(query_580036, "uploadType", newJString(uploadType))
  add(query_580036, "orderBy", newJString(orderBy))
  add(query_580036, "key", newJString(key))
  add(query_580036, "$.xgafv", newJString(Xgafv))
  add(query_580036, "pageSize", newJInt(pageSize))
  add(query_580036, "prettyPrint", newJBool(prettyPrint))
  add(query_580036, "format", newJString(format))
  result = call_580034.call(path_580035, query_580036, nil, nil, nil)

var polyUsersLikedassetsList* = Call_PolyUsersLikedassetsList_580014(
    name: "polyUsersLikedassetsList", meth: HttpMethod.HttpGet,
    host: "poly.googleapis.com", route: "/v1/{name}/likedassets",
    validator: validate_PolyUsersLikedassetsList_580015, base: "/",
    url: url_PolyUsersLikedassetsList_580016, schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
