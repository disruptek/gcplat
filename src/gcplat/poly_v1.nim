
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

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
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
  Call_PolyAssetsList_588710 = ref object of OpenApiRestCall_588441
proc url_PolyAssetsList_588712(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PolyAssetsList_588711(path: JsonNode; query: JsonNode;
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
  var valid_588824 = query.getOrDefault("upload_protocol")
  valid_588824 = validateParameter(valid_588824, JString, required = false,
                                 default = nil)
  if valid_588824 != nil:
    section.add "upload_protocol", valid_588824
  var valid_588825 = query.getOrDefault("curated")
  valid_588825 = validateParameter(valid_588825, JBool, required = false, default = nil)
  if valid_588825 != nil:
    section.add "curated", valid_588825
  var valid_588826 = query.getOrDefault("fields")
  valid_588826 = validateParameter(valid_588826, JString, required = false,
                                 default = nil)
  if valid_588826 != nil:
    section.add "fields", valid_588826
  var valid_588827 = query.getOrDefault("keywords")
  valid_588827 = validateParameter(valid_588827, JString, required = false,
                                 default = nil)
  if valid_588827 != nil:
    section.add "keywords", valid_588827
  var valid_588828 = query.getOrDefault("quotaUser")
  valid_588828 = validateParameter(valid_588828, JString, required = false,
                                 default = nil)
  if valid_588828 != nil:
    section.add "quotaUser", valid_588828
  var valid_588829 = query.getOrDefault("pageToken")
  valid_588829 = validateParameter(valid_588829, JString, required = false,
                                 default = nil)
  if valid_588829 != nil:
    section.add "pageToken", valid_588829
  var valid_588843 = query.getOrDefault("alt")
  valid_588843 = validateParameter(valid_588843, JString, required = false,
                                 default = newJString("json"))
  if valid_588843 != nil:
    section.add "alt", valid_588843
  var valid_588844 = query.getOrDefault("oauth_token")
  valid_588844 = validateParameter(valid_588844, JString, required = false,
                                 default = nil)
  if valid_588844 != nil:
    section.add "oauth_token", valid_588844
  var valid_588845 = query.getOrDefault("callback")
  valid_588845 = validateParameter(valid_588845, JString, required = false,
                                 default = nil)
  if valid_588845 != nil:
    section.add "callback", valid_588845
  var valid_588846 = query.getOrDefault("access_token")
  valid_588846 = validateParameter(valid_588846, JString, required = false,
                                 default = nil)
  if valid_588846 != nil:
    section.add "access_token", valid_588846
  var valid_588847 = query.getOrDefault("uploadType")
  valid_588847 = validateParameter(valid_588847, JString, required = false,
                                 default = nil)
  if valid_588847 != nil:
    section.add "uploadType", valid_588847
  var valid_588848 = query.getOrDefault("orderBy")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = nil)
  if valid_588848 != nil:
    section.add "orderBy", valid_588848
  var valid_588849 = query.getOrDefault("maxComplexity")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = newJString("COMPLEXITY_UNSPECIFIED"))
  if valid_588849 != nil:
    section.add "maxComplexity", valid_588849
  var valid_588850 = query.getOrDefault("key")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "key", valid_588850
  var valid_588851 = query.getOrDefault("$.xgafv")
  valid_588851 = validateParameter(valid_588851, JString, required = false,
                                 default = newJString("1"))
  if valid_588851 != nil:
    section.add "$.xgafv", valid_588851
  var valid_588852 = query.getOrDefault("pageSize")
  valid_588852 = validateParameter(valid_588852, JInt, required = false, default = nil)
  if valid_588852 != nil:
    section.add "pageSize", valid_588852
  var valid_588853 = query.getOrDefault("prettyPrint")
  valid_588853 = validateParameter(valid_588853, JBool, required = false,
                                 default = newJBool(true))
  if valid_588853 != nil:
    section.add "prettyPrint", valid_588853
  var valid_588854 = query.getOrDefault("format")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = nil)
  if valid_588854 != nil:
    section.add "format", valid_588854
  var valid_588855 = query.getOrDefault("category")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = nil)
  if valid_588855 != nil:
    section.add "category", valid_588855
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588878: Call_PolyAssetsList_588710; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all public, remixable assets. These are assets with an access level
  ## of PUBLIC and published under the
  ## CC-By license.
  ## 
  let valid = call_588878.validator(path, query, header, formData, body)
  let scheme = call_588878.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588878.url(scheme.get, call_588878.host, call_588878.base,
                         call_588878.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588878, url, valid)

proc call*(call_588949: Call_PolyAssetsList_588710; uploadProtocol: string = "";
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
  var query_588950 = newJObject()
  add(query_588950, "upload_protocol", newJString(uploadProtocol))
  add(query_588950, "curated", newJBool(curated))
  add(query_588950, "fields", newJString(fields))
  add(query_588950, "keywords", newJString(keywords))
  add(query_588950, "quotaUser", newJString(quotaUser))
  add(query_588950, "pageToken", newJString(pageToken))
  add(query_588950, "alt", newJString(alt))
  add(query_588950, "oauth_token", newJString(oauthToken))
  add(query_588950, "callback", newJString(callback))
  add(query_588950, "access_token", newJString(accessToken))
  add(query_588950, "uploadType", newJString(uploadType))
  add(query_588950, "orderBy", newJString(orderBy))
  add(query_588950, "maxComplexity", newJString(maxComplexity))
  add(query_588950, "key", newJString(key))
  add(query_588950, "$.xgafv", newJString(Xgafv))
  add(query_588950, "pageSize", newJInt(pageSize))
  add(query_588950, "prettyPrint", newJBool(prettyPrint))
  add(query_588950, "format", newJString(format))
  add(query_588950, "category", newJString(category))
  result = call_588949.call(nil, query_588950, nil, nil, nil)

var polyAssetsList* = Call_PolyAssetsList_588710(name: "polyAssetsList",
    meth: HttpMethod.HttpGet, host: "poly.googleapis.com", route: "/v1/assets",
    validator: validate_PolyAssetsList_588711, base: "/", url: url_PolyAssetsList_588712,
    schemes: {Scheme.Https})
type
  Call_PolyAssetsGet_588990 = ref object of OpenApiRestCall_588441
proc url_PolyAssetsGet_588992(protocol: Scheme; host: string; base: string;
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

proc validate_PolyAssetsGet_588991(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_589007 = path.getOrDefault("name")
  valid_589007 = validateParameter(valid_589007, JString, required = true,
                                 default = nil)
  if valid_589007 != nil:
    section.add "name", valid_589007
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
  var valid_589008 = query.getOrDefault("upload_protocol")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "upload_protocol", valid_589008
  var valid_589009 = query.getOrDefault("fields")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "fields", valid_589009
  var valid_589010 = query.getOrDefault("quotaUser")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "quotaUser", valid_589010
  var valid_589011 = query.getOrDefault("alt")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = newJString("json"))
  if valid_589011 != nil:
    section.add "alt", valid_589011
  var valid_589012 = query.getOrDefault("oauth_token")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "oauth_token", valid_589012
  var valid_589013 = query.getOrDefault("callback")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "callback", valid_589013
  var valid_589014 = query.getOrDefault("access_token")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "access_token", valid_589014
  var valid_589015 = query.getOrDefault("uploadType")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "uploadType", valid_589015
  var valid_589016 = query.getOrDefault("key")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "key", valid_589016
  var valid_589017 = query.getOrDefault("$.xgafv")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = newJString("1"))
  if valid_589017 != nil:
    section.add "$.xgafv", valid_589017
  var valid_589018 = query.getOrDefault("prettyPrint")
  valid_589018 = validateParameter(valid_589018, JBool, required = false,
                                 default = newJBool(true))
  if valid_589018 != nil:
    section.add "prettyPrint", valid_589018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589019: Call_PolyAssetsGet_588990; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns detailed information about an asset given its name.
  ## PRIVATE assets are returned only if
  ##  the currently authenticated user (via OAuth token) is the author of the
  ##  asset.
  ## 
  let valid = call_589019.validator(path, query, header, formData, body)
  let scheme = call_589019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589019.url(scheme.get, call_589019.host, call_589019.base,
                         call_589019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589019, url, valid)

proc call*(call_589020: Call_PolyAssetsGet_588990; name: string;
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
  var path_589021 = newJObject()
  var query_589022 = newJObject()
  add(query_589022, "upload_protocol", newJString(uploadProtocol))
  add(query_589022, "fields", newJString(fields))
  add(query_589022, "quotaUser", newJString(quotaUser))
  add(path_589021, "name", newJString(name))
  add(query_589022, "alt", newJString(alt))
  add(query_589022, "oauth_token", newJString(oauthToken))
  add(query_589022, "callback", newJString(callback))
  add(query_589022, "access_token", newJString(accessToken))
  add(query_589022, "uploadType", newJString(uploadType))
  add(query_589022, "key", newJString(key))
  add(query_589022, "$.xgafv", newJString(Xgafv))
  add(query_589022, "prettyPrint", newJBool(prettyPrint))
  result = call_589020.call(path_589021, query_589022, nil, nil, nil)

var polyAssetsGet* = Call_PolyAssetsGet_588990(name: "polyAssetsGet",
    meth: HttpMethod.HttpGet, host: "poly.googleapis.com", route: "/v1/{name}",
    validator: validate_PolyAssetsGet_588991, base: "/", url: url_PolyAssetsGet_588992,
    schemes: {Scheme.Https})
type
  Call_PolyUsersAssetsList_589023 = ref object of OpenApiRestCall_588441
proc url_PolyUsersAssetsList_589025(protocol: Scheme; host: string; base: string;
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

proc validate_PolyUsersAssetsList_589024(path: JsonNode; query: JsonNode;
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
  var valid_589026 = path.getOrDefault("name")
  valid_589026 = validateParameter(valid_589026, JString, required = true,
                                 default = nil)
  if valid_589026 != nil:
    section.add "name", valid_589026
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
  var valid_589027 = query.getOrDefault("upload_protocol")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "upload_protocol", valid_589027
  var valid_589028 = query.getOrDefault("fields")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "fields", valid_589028
  var valid_589029 = query.getOrDefault("pageToken")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "pageToken", valid_589029
  var valid_589030 = query.getOrDefault("quotaUser")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "quotaUser", valid_589030
  var valid_589031 = query.getOrDefault("alt")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = newJString("json"))
  if valid_589031 != nil:
    section.add "alt", valid_589031
  var valid_589032 = query.getOrDefault("oauth_token")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "oauth_token", valid_589032
  var valid_589033 = query.getOrDefault("callback")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "callback", valid_589033
  var valid_589034 = query.getOrDefault("access_token")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "access_token", valid_589034
  var valid_589035 = query.getOrDefault("uploadType")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "uploadType", valid_589035
  var valid_589036 = query.getOrDefault("orderBy")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "orderBy", valid_589036
  var valid_589037 = query.getOrDefault("key")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "key", valid_589037
  var valid_589038 = query.getOrDefault("$.xgafv")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = newJString("1"))
  if valid_589038 != nil:
    section.add "$.xgafv", valid_589038
  var valid_589039 = query.getOrDefault("pageSize")
  valid_589039 = validateParameter(valid_589039, JInt, required = false, default = nil)
  if valid_589039 != nil:
    section.add "pageSize", valid_589039
  var valid_589040 = query.getOrDefault("prettyPrint")
  valid_589040 = validateParameter(valid_589040, JBool, required = false,
                                 default = newJBool(true))
  if valid_589040 != nil:
    section.add "prettyPrint", valid_589040
  var valid_589041 = query.getOrDefault("format")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "format", valid_589041
  var valid_589042 = query.getOrDefault("visibility")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = newJString("VISIBILITY_UNSPECIFIED"))
  if valid_589042 != nil:
    section.add "visibility", valid_589042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589043: Call_PolyUsersAssetsList_589023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists assets authored by the given user. Only the value 'me', representing
  ## the currently-authenticated user, is supported. May include assets with an
  ## access level of PRIVATE or
  ## UNLISTED and assets which are
  ## All Rights Reserved for the
  ## currently-authenticated user.
  ## 
  let valid = call_589043.validator(path, query, header, formData, body)
  let scheme = call_589043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589043.url(scheme.get, call_589043.host, call_589043.base,
                         call_589043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589043, url, valid)

proc call*(call_589044: Call_PolyUsersAssetsList_589023; name: string;
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
  var path_589045 = newJObject()
  var query_589046 = newJObject()
  add(query_589046, "upload_protocol", newJString(uploadProtocol))
  add(query_589046, "fields", newJString(fields))
  add(query_589046, "pageToken", newJString(pageToken))
  add(query_589046, "quotaUser", newJString(quotaUser))
  add(path_589045, "name", newJString(name))
  add(query_589046, "alt", newJString(alt))
  add(query_589046, "oauth_token", newJString(oauthToken))
  add(query_589046, "callback", newJString(callback))
  add(query_589046, "access_token", newJString(accessToken))
  add(query_589046, "uploadType", newJString(uploadType))
  add(query_589046, "orderBy", newJString(orderBy))
  add(query_589046, "key", newJString(key))
  add(query_589046, "$.xgafv", newJString(Xgafv))
  add(query_589046, "pageSize", newJInt(pageSize))
  add(query_589046, "prettyPrint", newJBool(prettyPrint))
  add(query_589046, "format", newJString(format))
  add(query_589046, "visibility", newJString(visibility))
  result = call_589044.call(path_589045, query_589046, nil, nil, nil)

var polyUsersAssetsList* = Call_PolyUsersAssetsList_589023(
    name: "polyUsersAssetsList", meth: HttpMethod.HttpGet,
    host: "poly.googleapis.com", route: "/v1/{name}/assets",
    validator: validate_PolyUsersAssetsList_589024, base: "/",
    url: url_PolyUsersAssetsList_589025, schemes: {Scheme.Https})
type
  Call_PolyUsersLikedassetsList_589047 = ref object of OpenApiRestCall_588441
proc url_PolyUsersLikedassetsList_589049(protocol: Scheme; host: string;
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

proc validate_PolyUsersLikedassetsList_589048(path: JsonNode; query: JsonNode;
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
  var valid_589050 = path.getOrDefault("name")
  valid_589050 = validateParameter(valid_589050, JString, required = true,
                                 default = nil)
  if valid_589050 != nil:
    section.add "name", valid_589050
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
  var valid_589051 = query.getOrDefault("upload_protocol")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "upload_protocol", valid_589051
  var valid_589052 = query.getOrDefault("fields")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "fields", valid_589052
  var valid_589053 = query.getOrDefault("pageToken")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "pageToken", valid_589053
  var valid_589054 = query.getOrDefault("quotaUser")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "quotaUser", valid_589054
  var valid_589055 = query.getOrDefault("alt")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = newJString("json"))
  if valid_589055 != nil:
    section.add "alt", valid_589055
  var valid_589056 = query.getOrDefault("oauth_token")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "oauth_token", valid_589056
  var valid_589057 = query.getOrDefault("callback")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "callback", valid_589057
  var valid_589058 = query.getOrDefault("access_token")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "access_token", valid_589058
  var valid_589059 = query.getOrDefault("uploadType")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "uploadType", valid_589059
  var valid_589060 = query.getOrDefault("orderBy")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "orderBy", valid_589060
  var valid_589061 = query.getOrDefault("key")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "key", valid_589061
  var valid_589062 = query.getOrDefault("$.xgafv")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = newJString("1"))
  if valid_589062 != nil:
    section.add "$.xgafv", valid_589062
  var valid_589063 = query.getOrDefault("pageSize")
  valid_589063 = validateParameter(valid_589063, JInt, required = false, default = nil)
  if valid_589063 != nil:
    section.add "pageSize", valid_589063
  var valid_589064 = query.getOrDefault("prettyPrint")
  valid_589064 = validateParameter(valid_589064, JBool, required = false,
                                 default = newJBool(true))
  if valid_589064 != nil:
    section.add "prettyPrint", valid_589064
  var valid_589065 = query.getOrDefault("format")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "format", valid_589065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589066: Call_PolyUsersLikedassetsList_589047; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists assets that the user has liked. Only the value 'me', representing
  ## the currently-authenticated user, is supported. May include assets with an
  ## access level of UNLISTED.
  ## 
  let valid = call_589066.validator(path, query, header, formData, body)
  let scheme = call_589066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589066.url(scheme.get, call_589066.host, call_589066.base,
                         call_589066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589066, url, valid)

proc call*(call_589067: Call_PolyUsersLikedassetsList_589047; name: string;
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
  var path_589068 = newJObject()
  var query_589069 = newJObject()
  add(query_589069, "upload_protocol", newJString(uploadProtocol))
  add(query_589069, "fields", newJString(fields))
  add(query_589069, "pageToken", newJString(pageToken))
  add(query_589069, "quotaUser", newJString(quotaUser))
  add(path_589068, "name", newJString(name))
  add(query_589069, "alt", newJString(alt))
  add(query_589069, "oauth_token", newJString(oauthToken))
  add(query_589069, "callback", newJString(callback))
  add(query_589069, "access_token", newJString(accessToken))
  add(query_589069, "uploadType", newJString(uploadType))
  add(query_589069, "orderBy", newJString(orderBy))
  add(query_589069, "key", newJString(key))
  add(query_589069, "$.xgafv", newJString(Xgafv))
  add(query_589069, "pageSize", newJInt(pageSize))
  add(query_589069, "prettyPrint", newJBool(prettyPrint))
  add(query_589069, "format", newJString(format))
  result = call_589067.call(path_589068, query_589069, nil, nil, nil)

var polyUsersLikedassetsList* = Call_PolyUsersLikedassetsList_589047(
    name: "polyUsersLikedassetsList", meth: HttpMethod.HttpGet,
    host: "poly.googleapis.com", route: "/v1/{name}/likedassets",
    validator: validate_PolyUsersLikedassetsList_589048, base: "/",
    url: url_PolyUsersLikedassetsList_589049, schemes: {Scheme.Https})
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

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
