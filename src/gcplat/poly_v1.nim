
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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "poly"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PolyAssetsList_578610 = ref object of OpenApiRestCall_578339
proc url_PolyAssetsList_578612(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PolyAssetsList_578611(path: JsonNode; query: JsonNode;
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   curated: JBool
  ##          : Return only assets that have been curated by the Poly team.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of assets to be returned. This value must be between `1`
  ## and `100`. Defaults to `20`.
  ##   keywords: JString
  ##           : One or more search terms to be matched against all text that Poly has
  ## indexed for assets, which includes display_name,
  ## description, and tags. Multiple keywords should be
  ## separated by spaces.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   maxComplexity: JString
  ##                : Returns assets that are of the specified complexity or less. Defaults to
  ## COMPLEX. For example, a request for
  ## MEDIUM assets also includes
  ## SIMPLE assets.
  ##   orderBy: JString
  ##          : Specifies an ordering for assets. Acceptable values are:
  ## `BEST`, `NEWEST`, `OLDEST`. Defaults to `BEST`, which ranks assets
  ## based on a combination of popularity and other features.
  ##   pageToken: JString
  ##            : Specifies a continuation token from a previous search whose results were
  ## split into multiple pages. To get the next page, submit the same request
  ## specifying the value from
  ## next_page_token.
  ##   callback: JString
  ##           : JSONP
  ##   category: JString
  ##           : Filter assets based on the specified category. Supported values are:
  ## `animals`, `architecture`, `art`, `food`, `nature`, `objects`, `people`,
  ## `scenes`, `technology`, and `transport`.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   format: JString
  ##         : Return only assets with the matching format. Acceptable values are:
  ## `BLOCKS`, `FBX`, `GLTF`, `GLTF2`, `OBJ`, `TILT`.
  section = newJObject()
  var valid_578724 = query.getOrDefault("key")
  valid_578724 = validateParameter(valid_578724, JString, required = false,
                                 default = nil)
  if valid_578724 != nil:
    section.add "key", valid_578724
  var valid_578738 = query.getOrDefault("prettyPrint")
  valid_578738 = validateParameter(valid_578738, JBool, required = false,
                                 default = newJBool(true))
  if valid_578738 != nil:
    section.add "prettyPrint", valid_578738
  var valid_578739 = query.getOrDefault("oauth_token")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "oauth_token", valid_578739
  var valid_578740 = query.getOrDefault("curated")
  valid_578740 = validateParameter(valid_578740, JBool, required = false, default = nil)
  if valid_578740 != nil:
    section.add "curated", valid_578740
  var valid_578741 = query.getOrDefault("$.xgafv")
  valid_578741 = validateParameter(valid_578741, JString, required = false,
                                 default = newJString("1"))
  if valid_578741 != nil:
    section.add "$.xgafv", valid_578741
  var valid_578742 = query.getOrDefault("pageSize")
  valid_578742 = validateParameter(valid_578742, JInt, required = false, default = nil)
  if valid_578742 != nil:
    section.add "pageSize", valid_578742
  var valid_578743 = query.getOrDefault("keywords")
  valid_578743 = validateParameter(valid_578743, JString, required = false,
                                 default = nil)
  if valid_578743 != nil:
    section.add "keywords", valid_578743
  var valid_578744 = query.getOrDefault("alt")
  valid_578744 = validateParameter(valid_578744, JString, required = false,
                                 default = newJString("json"))
  if valid_578744 != nil:
    section.add "alt", valid_578744
  var valid_578745 = query.getOrDefault("uploadType")
  valid_578745 = validateParameter(valid_578745, JString, required = false,
                                 default = nil)
  if valid_578745 != nil:
    section.add "uploadType", valid_578745
  var valid_578746 = query.getOrDefault("quotaUser")
  valid_578746 = validateParameter(valid_578746, JString, required = false,
                                 default = nil)
  if valid_578746 != nil:
    section.add "quotaUser", valid_578746
  var valid_578747 = query.getOrDefault("maxComplexity")
  valid_578747 = validateParameter(valid_578747, JString, required = false,
                                 default = newJString("COMPLEXITY_UNSPECIFIED"))
  if valid_578747 != nil:
    section.add "maxComplexity", valid_578747
  var valid_578748 = query.getOrDefault("orderBy")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "orderBy", valid_578748
  var valid_578749 = query.getOrDefault("pageToken")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = nil)
  if valid_578749 != nil:
    section.add "pageToken", valid_578749
  var valid_578750 = query.getOrDefault("callback")
  valid_578750 = validateParameter(valid_578750, JString, required = false,
                                 default = nil)
  if valid_578750 != nil:
    section.add "callback", valid_578750
  var valid_578751 = query.getOrDefault("category")
  valid_578751 = validateParameter(valid_578751, JString, required = false,
                                 default = nil)
  if valid_578751 != nil:
    section.add "category", valid_578751
  var valid_578752 = query.getOrDefault("fields")
  valid_578752 = validateParameter(valid_578752, JString, required = false,
                                 default = nil)
  if valid_578752 != nil:
    section.add "fields", valid_578752
  var valid_578753 = query.getOrDefault("access_token")
  valid_578753 = validateParameter(valid_578753, JString, required = false,
                                 default = nil)
  if valid_578753 != nil:
    section.add "access_token", valid_578753
  var valid_578754 = query.getOrDefault("upload_protocol")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "upload_protocol", valid_578754
  var valid_578755 = query.getOrDefault("format")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "format", valid_578755
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578778: Call_PolyAssetsList_578610; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all public, remixable assets. These are assets with an access level
  ## of PUBLIC and published under the
  ## CC-By license.
  ## 
  let valid = call_578778.validator(path, query, header, formData, body)
  let scheme = call_578778.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578778.url(scheme.get, call_578778.host, call_578778.base,
                         call_578778.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578778, url, valid)

proc call*(call_578849: Call_PolyAssetsList_578610; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; curated: bool = false;
          Xgafv: string = "1"; pageSize: int = 0; keywords: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          maxComplexity: string = "COMPLEXITY_UNSPECIFIED"; orderBy: string = "";
          pageToken: string = ""; callback: string = ""; category: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          format: string = ""): Recallable =
  ## polyAssetsList
  ## Lists all public, remixable assets. These are assets with an access level
  ## of PUBLIC and published under the
  ## CC-By license.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   curated: bool
  ##          : Return only assets that have been curated by the Poly team.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of assets to be returned. This value must be between `1`
  ## and `100`. Defaults to `20`.
  ##   keywords: string
  ##           : One or more search terms to be matched against all text that Poly has
  ## indexed for assets, which includes display_name,
  ## description, and tags. Multiple keywords should be
  ## separated by spaces.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   maxComplexity: string
  ##                : Returns assets that are of the specified complexity or less. Defaults to
  ## COMPLEX. For example, a request for
  ## MEDIUM assets also includes
  ## SIMPLE assets.
  ##   orderBy: string
  ##          : Specifies an ordering for assets. Acceptable values are:
  ## `BEST`, `NEWEST`, `OLDEST`. Defaults to `BEST`, which ranks assets
  ## based on a combination of popularity and other features.
  ##   pageToken: string
  ##            : Specifies a continuation token from a previous search whose results were
  ## split into multiple pages. To get the next page, submit the same request
  ## specifying the value from
  ## next_page_token.
  ##   callback: string
  ##           : JSONP
  ##   category: string
  ##           : Filter assets based on the specified category. Supported values are:
  ## `animals`, `architecture`, `art`, `food`, `nature`, `objects`, `people`,
  ## `scenes`, `technology`, and `transport`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   format: string
  ##         : Return only assets with the matching format. Acceptable values are:
  ## `BLOCKS`, `FBX`, `GLTF`, `GLTF2`, `OBJ`, `TILT`.
  var query_578850 = newJObject()
  add(query_578850, "key", newJString(key))
  add(query_578850, "prettyPrint", newJBool(prettyPrint))
  add(query_578850, "oauth_token", newJString(oauthToken))
  add(query_578850, "curated", newJBool(curated))
  add(query_578850, "$.xgafv", newJString(Xgafv))
  add(query_578850, "pageSize", newJInt(pageSize))
  add(query_578850, "keywords", newJString(keywords))
  add(query_578850, "alt", newJString(alt))
  add(query_578850, "uploadType", newJString(uploadType))
  add(query_578850, "quotaUser", newJString(quotaUser))
  add(query_578850, "maxComplexity", newJString(maxComplexity))
  add(query_578850, "orderBy", newJString(orderBy))
  add(query_578850, "pageToken", newJString(pageToken))
  add(query_578850, "callback", newJString(callback))
  add(query_578850, "category", newJString(category))
  add(query_578850, "fields", newJString(fields))
  add(query_578850, "access_token", newJString(accessToken))
  add(query_578850, "upload_protocol", newJString(uploadProtocol))
  add(query_578850, "format", newJString(format))
  result = call_578849.call(nil, query_578850, nil, nil, nil)

var polyAssetsList* = Call_PolyAssetsList_578610(name: "polyAssetsList",
    meth: HttpMethod.HttpGet, host: "poly.googleapis.com", route: "/v1/assets",
    validator: validate_PolyAssetsList_578611, base: "/", url: url_PolyAssetsList_578612,
    schemes: {Scheme.Https})
type
  Call_PolyAssetsGet_578890 = ref object of OpenApiRestCall_578339
proc url_PolyAssetsGet_578892(protocol: Scheme; host: string; base: string;
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

proc validate_PolyAssetsGet_578891(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_578907 = path.getOrDefault("name")
  valid_578907 = validateParameter(valid_578907, JString, required = true,
                                 default = nil)
  if valid_578907 != nil:
    section.add "name", valid_578907
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578908 = query.getOrDefault("key")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "key", valid_578908
  var valid_578909 = query.getOrDefault("prettyPrint")
  valid_578909 = validateParameter(valid_578909, JBool, required = false,
                                 default = newJBool(true))
  if valid_578909 != nil:
    section.add "prettyPrint", valid_578909
  var valid_578910 = query.getOrDefault("oauth_token")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "oauth_token", valid_578910
  var valid_578911 = query.getOrDefault("$.xgafv")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = newJString("1"))
  if valid_578911 != nil:
    section.add "$.xgafv", valid_578911
  var valid_578912 = query.getOrDefault("alt")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = newJString("json"))
  if valid_578912 != nil:
    section.add "alt", valid_578912
  var valid_578913 = query.getOrDefault("uploadType")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "uploadType", valid_578913
  var valid_578914 = query.getOrDefault("quotaUser")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "quotaUser", valid_578914
  var valid_578915 = query.getOrDefault("callback")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "callback", valid_578915
  var valid_578916 = query.getOrDefault("fields")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "fields", valid_578916
  var valid_578917 = query.getOrDefault("access_token")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "access_token", valid_578917
  var valid_578918 = query.getOrDefault("upload_protocol")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "upload_protocol", valid_578918
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578919: Call_PolyAssetsGet_578890; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns detailed information about an asset given its name.
  ## PRIVATE assets are returned only if
  ##  the currently authenticated user (via OAuth token) is the author of the
  ##  asset.
  ## 
  let valid = call_578919.validator(path, query, header, formData, body)
  let scheme = call_578919.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578919.url(scheme.get, call_578919.host, call_578919.base,
                         call_578919.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578919, url, valid)

proc call*(call_578920: Call_PolyAssetsGet_578890; name: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## polyAssetsGet
  ## Returns detailed information about an asset given its name.
  ## PRIVATE assets are returned only if
  ##  the currently authenticated user (via OAuth token) is the author of the
  ##  asset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. An asset's name in the form `assets/{ASSET_ID}`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578921 = newJObject()
  var query_578922 = newJObject()
  add(query_578922, "key", newJString(key))
  add(query_578922, "prettyPrint", newJBool(prettyPrint))
  add(query_578922, "oauth_token", newJString(oauthToken))
  add(query_578922, "$.xgafv", newJString(Xgafv))
  add(query_578922, "alt", newJString(alt))
  add(query_578922, "uploadType", newJString(uploadType))
  add(query_578922, "quotaUser", newJString(quotaUser))
  add(path_578921, "name", newJString(name))
  add(query_578922, "callback", newJString(callback))
  add(query_578922, "fields", newJString(fields))
  add(query_578922, "access_token", newJString(accessToken))
  add(query_578922, "upload_protocol", newJString(uploadProtocol))
  result = call_578920.call(path_578921, query_578922, nil, nil, nil)

var polyAssetsGet* = Call_PolyAssetsGet_578890(name: "polyAssetsGet",
    meth: HttpMethod.HttpGet, host: "poly.googleapis.com", route: "/v1/{name}",
    validator: validate_PolyAssetsGet_578891, base: "/", url: url_PolyAssetsGet_578892,
    schemes: {Scheme.Https})
type
  Call_PolyUsersAssetsList_578923 = ref object of OpenApiRestCall_578339
proc url_PolyUsersAssetsList_578925(protocol: Scheme; host: string; base: string;
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

proc validate_PolyUsersAssetsList_578924(path: JsonNode; query: JsonNode;
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
  var valid_578926 = path.getOrDefault("name")
  valid_578926 = validateParameter(valid_578926, JString, required = true,
                                 default = nil)
  if valid_578926 != nil:
    section.add "name", valid_578926
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of assets to be returned. This value must be between `1`
  ## and `100`. Defaults to `20`.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: JString
  ##          : Specifies an ordering for assets. Acceptable values are:
  ## `BEST`, `NEWEST`, `OLDEST`. Defaults to `BEST`, which ranks assets
  ## based on a combination of popularity and other features.
  ##   pageToken: JString
  ##            : Specifies a continuation token from a previous search whose results were
  ## split into multiple pages. To get the next page, submit the same request
  ## specifying the value from
  ## next_page_token.
  ##   visibility: JString
  ##             : The visibility of the assets to be returned.
  ## Defaults to
  ## VISIBILITY_UNSPECIFIED
  ## which returns all assets.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   format: JString
  ##         : Return only assets with the matching format. Acceptable values are:
  ## `BLOCKS`, `FBX`, `GLTF`, `GLTF2`, `OBJ`, and `TILT`.
  section = newJObject()
  var valid_578927 = query.getOrDefault("key")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "key", valid_578927
  var valid_578928 = query.getOrDefault("prettyPrint")
  valid_578928 = validateParameter(valid_578928, JBool, required = false,
                                 default = newJBool(true))
  if valid_578928 != nil:
    section.add "prettyPrint", valid_578928
  var valid_578929 = query.getOrDefault("oauth_token")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "oauth_token", valid_578929
  var valid_578930 = query.getOrDefault("$.xgafv")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = newJString("1"))
  if valid_578930 != nil:
    section.add "$.xgafv", valid_578930
  var valid_578931 = query.getOrDefault("pageSize")
  valid_578931 = validateParameter(valid_578931, JInt, required = false, default = nil)
  if valid_578931 != nil:
    section.add "pageSize", valid_578931
  var valid_578932 = query.getOrDefault("alt")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = newJString("json"))
  if valid_578932 != nil:
    section.add "alt", valid_578932
  var valid_578933 = query.getOrDefault("uploadType")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "uploadType", valid_578933
  var valid_578934 = query.getOrDefault("quotaUser")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "quotaUser", valid_578934
  var valid_578935 = query.getOrDefault("orderBy")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "orderBy", valid_578935
  var valid_578936 = query.getOrDefault("pageToken")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "pageToken", valid_578936
  var valid_578937 = query.getOrDefault("visibility")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = newJString("VISIBILITY_UNSPECIFIED"))
  if valid_578937 != nil:
    section.add "visibility", valid_578937
  var valid_578938 = query.getOrDefault("callback")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "callback", valid_578938
  var valid_578939 = query.getOrDefault("fields")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "fields", valid_578939
  var valid_578940 = query.getOrDefault("access_token")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "access_token", valid_578940
  var valid_578941 = query.getOrDefault("upload_protocol")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "upload_protocol", valid_578941
  var valid_578942 = query.getOrDefault("format")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "format", valid_578942
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578943: Call_PolyUsersAssetsList_578923; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists assets authored by the given user. Only the value 'me', representing
  ## the currently-authenticated user, is supported. May include assets with an
  ## access level of PRIVATE or
  ## UNLISTED and assets which are
  ## All Rights Reserved for the
  ## currently-authenticated user.
  ## 
  let valid = call_578943.validator(path, query, header, formData, body)
  let scheme = call_578943.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578943.url(scheme.get, call_578943.host, call_578943.base,
                         call_578943.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578943, url, valid)

proc call*(call_578944: Call_PolyUsersAssetsList_578923; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; orderBy: string = "";
          pageToken: string = ""; visibility: string = "VISIBILITY_UNSPECIFIED";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; format: string = ""): Recallable =
  ## polyUsersAssetsList
  ## Lists assets authored by the given user. Only the value 'me', representing
  ## the currently-authenticated user, is supported. May include assets with an
  ## access level of PRIVATE or
  ## UNLISTED and assets which are
  ## All Rights Reserved for the
  ## currently-authenticated user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of assets to be returned. This value must be between `1`
  ## and `100`. Defaults to `20`.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : A valid user id. Currently, only the special value 'me', representing the
  ## currently-authenticated user is supported. To use 'me', you must pass
  ## an OAuth token with the request.
  ##   orderBy: string
  ##          : Specifies an ordering for assets. Acceptable values are:
  ## `BEST`, `NEWEST`, `OLDEST`. Defaults to `BEST`, which ranks assets
  ## based on a combination of popularity and other features.
  ##   pageToken: string
  ##            : Specifies a continuation token from a previous search whose results were
  ## split into multiple pages. To get the next page, submit the same request
  ## specifying the value from
  ## next_page_token.
  ##   visibility: string
  ##             : The visibility of the assets to be returned.
  ## Defaults to
  ## VISIBILITY_UNSPECIFIED
  ## which returns all assets.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   format: string
  ##         : Return only assets with the matching format. Acceptable values are:
  ## `BLOCKS`, `FBX`, `GLTF`, `GLTF2`, `OBJ`, and `TILT`.
  var path_578945 = newJObject()
  var query_578946 = newJObject()
  add(query_578946, "key", newJString(key))
  add(query_578946, "prettyPrint", newJBool(prettyPrint))
  add(query_578946, "oauth_token", newJString(oauthToken))
  add(query_578946, "$.xgafv", newJString(Xgafv))
  add(query_578946, "pageSize", newJInt(pageSize))
  add(query_578946, "alt", newJString(alt))
  add(query_578946, "uploadType", newJString(uploadType))
  add(query_578946, "quotaUser", newJString(quotaUser))
  add(path_578945, "name", newJString(name))
  add(query_578946, "orderBy", newJString(orderBy))
  add(query_578946, "pageToken", newJString(pageToken))
  add(query_578946, "visibility", newJString(visibility))
  add(query_578946, "callback", newJString(callback))
  add(query_578946, "fields", newJString(fields))
  add(query_578946, "access_token", newJString(accessToken))
  add(query_578946, "upload_protocol", newJString(uploadProtocol))
  add(query_578946, "format", newJString(format))
  result = call_578944.call(path_578945, query_578946, nil, nil, nil)

var polyUsersAssetsList* = Call_PolyUsersAssetsList_578923(
    name: "polyUsersAssetsList", meth: HttpMethod.HttpGet,
    host: "poly.googleapis.com", route: "/v1/{name}/assets",
    validator: validate_PolyUsersAssetsList_578924, base: "/",
    url: url_PolyUsersAssetsList_578925, schemes: {Scheme.Https})
type
  Call_PolyUsersLikedassetsList_578947 = ref object of OpenApiRestCall_578339
proc url_PolyUsersLikedassetsList_578949(protocol: Scheme; host: string;
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

proc validate_PolyUsersLikedassetsList_578948(path: JsonNode; query: JsonNode;
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
  var valid_578950 = path.getOrDefault("name")
  valid_578950 = validateParameter(valid_578950, JString, required = true,
                                 default = nil)
  if valid_578950 != nil:
    section.add "name", valid_578950
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of assets to be returned. This value must be between `1`
  ## and `100`. Defaults to `20`.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: JString
  ##          : Specifies an ordering for assets. Acceptable values are:
  ## `BEST`, `NEWEST`, `OLDEST`, 'LIKED_TIME'. Defaults to `LIKED_TIME`, which
  ## ranks assets based on how recently they were liked.
  ##   pageToken: JString
  ##            : Specifies a continuation token from a previous search whose results were
  ## split into multiple pages. To get the next page, submit the same request
  ## specifying the value from
  ## next_page_token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   format: JString
  ##         : Return only assets with the matching format. Acceptable values are:
  ## `BLOCKS`, `FBX`, `GLTF`, `GLTF2`, `OBJ`, `TILT`.
  section = newJObject()
  var valid_578951 = query.getOrDefault("key")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "key", valid_578951
  var valid_578952 = query.getOrDefault("prettyPrint")
  valid_578952 = validateParameter(valid_578952, JBool, required = false,
                                 default = newJBool(true))
  if valid_578952 != nil:
    section.add "prettyPrint", valid_578952
  var valid_578953 = query.getOrDefault("oauth_token")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "oauth_token", valid_578953
  var valid_578954 = query.getOrDefault("$.xgafv")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = newJString("1"))
  if valid_578954 != nil:
    section.add "$.xgafv", valid_578954
  var valid_578955 = query.getOrDefault("pageSize")
  valid_578955 = validateParameter(valid_578955, JInt, required = false, default = nil)
  if valid_578955 != nil:
    section.add "pageSize", valid_578955
  var valid_578956 = query.getOrDefault("alt")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = newJString("json"))
  if valid_578956 != nil:
    section.add "alt", valid_578956
  var valid_578957 = query.getOrDefault("uploadType")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "uploadType", valid_578957
  var valid_578958 = query.getOrDefault("quotaUser")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "quotaUser", valid_578958
  var valid_578959 = query.getOrDefault("orderBy")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "orderBy", valid_578959
  var valid_578960 = query.getOrDefault("pageToken")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "pageToken", valid_578960
  var valid_578961 = query.getOrDefault("callback")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "callback", valid_578961
  var valid_578962 = query.getOrDefault("fields")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "fields", valid_578962
  var valid_578963 = query.getOrDefault("access_token")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "access_token", valid_578963
  var valid_578964 = query.getOrDefault("upload_protocol")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "upload_protocol", valid_578964
  var valid_578965 = query.getOrDefault("format")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "format", valid_578965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578966: Call_PolyUsersLikedassetsList_578947; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists assets that the user has liked. Only the value 'me', representing
  ## the currently-authenticated user, is supported. May include assets with an
  ## access level of UNLISTED.
  ## 
  let valid = call_578966.validator(path, query, header, formData, body)
  let scheme = call_578966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578966.url(scheme.get, call_578966.host, call_578966.base,
                         call_578966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578966, url, valid)

proc call*(call_578967: Call_PolyUsersLikedassetsList_578947; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; orderBy: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""; format: string = ""): Recallable =
  ## polyUsersLikedassetsList
  ## Lists assets that the user has liked. Only the value 'me', representing
  ## the currently-authenticated user, is supported. May include assets with an
  ## access level of UNLISTED.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of assets to be returned. This value must be between `1`
  ## and `100`. Defaults to `20`.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : A valid user id. Currently, only the special value 'me', representing the
  ## currently-authenticated user is supported. To use 'me', you must pass
  ## an OAuth token with the request.
  ##   orderBy: string
  ##          : Specifies an ordering for assets. Acceptable values are:
  ## `BEST`, `NEWEST`, `OLDEST`, 'LIKED_TIME'. Defaults to `LIKED_TIME`, which
  ## ranks assets based on how recently they were liked.
  ##   pageToken: string
  ##            : Specifies a continuation token from a previous search whose results were
  ## split into multiple pages. To get the next page, submit the same request
  ## specifying the value from
  ## next_page_token.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   format: string
  ##         : Return only assets with the matching format. Acceptable values are:
  ## `BLOCKS`, `FBX`, `GLTF`, `GLTF2`, `OBJ`, `TILT`.
  var path_578968 = newJObject()
  var query_578969 = newJObject()
  add(query_578969, "key", newJString(key))
  add(query_578969, "prettyPrint", newJBool(prettyPrint))
  add(query_578969, "oauth_token", newJString(oauthToken))
  add(query_578969, "$.xgafv", newJString(Xgafv))
  add(query_578969, "pageSize", newJInt(pageSize))
  add(query_578969, "alt", newJString(alt))
  add(query_578969, "uploadType", newJString(uploadType))
  add(query_578969, "quotaUser", newJString(quotaUser))
  add(path_578968, "name", newJString(name))
  add(query_578969, "orderBy", newJString(orderBy))
  add(query_578969, "pageToken", newJString(pageToken))
  add(query_578969, "callback", newJString(callback))
  add(query_578969, "fields", newJString(fields))
  add(query_578969, "access_token", newJString(accessToken))
  add(query_578969, "upload_protocol", newJString(uploadProtocol))
  add(query_578969, "format", newJString(format))
  result = call_578967.call(path_578968, query_578969, nil, nil, nil)

var polyUsersLikedassetsList* = Call_PolyUsersLikedassetsList_578947(
    name: "polyUsersLikedassetsList", meth: HttpMethod.HttpGet,
    host: "poly.googleapis.com", route: "/v1/{name}/likedassets",
    validator: validate_PolyUsersLikedassetsList_578948, base: "/",
    url: url_PolyUsersLikedassetsList_578949, schemes: {Scheme.Https})
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
