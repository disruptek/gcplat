
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Search
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Cloud Search provides cloud-based search capabilities over G Suite data.  The Cloud Search API allows indexing of non-G Suite data into Cloud Search.
## 
## https://developers.google.com/cloud-search/docs/guides/
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

  OpenApiRestCall_579373 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579373](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579373): Option[Scheme] {.used.} =
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
  gcpServiceName = "cloudsearch"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudsearchDebugDatasourcesItemsSearchByViewUrl_579644 = ref object of OpenApiRestCall_579373
proc url_CloudsearchDebugDatasourcesItemsSearchByViewUrl_579646(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/debug/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/items:searchByViewUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudsearchDebugDatasourcesItemsSearchByViewUrl_579645(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Fetches the item whose viewUrl exactly matches that of the URL provided
  ## in the request.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Source name, format:
  ## datasources/{source_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579772 = path.getOrDefault("name")
  valid_579772 = validateParameter(valid_579772, JString, required = true,
                                 default = nil)
  if valid_579772 != nil:
    section.add "name", valid_579772
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
  var valid_579773 = query.getOrDefault("key")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "key", valid_579773
  var valid_579787 = query.getOrDefault("prettyPrint")
  valid_579787 = validateParameter(valid_579787, JBool, required = false,
                                 default = newJBool(true))
  if valid_579787 != nil:
    section.add "prettyPrint", valid_579787
  var valid_579788 = query.getOrDefault("oauth_token")
  valid_579788 = validateParameter(valid_579788, JString, required = false,
                                 default = nil)
  if valid_579788 != nil:
    section.add "oauth_token", valid_579788
  var valid_579789 = query.getOrDefault("$.xgafv")
  valid_579789 = validateParameter(valid_579789, JString, required = false,
                                 default = newJString("1"))
  if valid_579789 != nil:
    section.add "$.xgafv", valid_579789
  var valid_579790 = query.getOrDefault("alt")
  valid_579790 = validateParameter(valid_579790, JString, required = false,
                                 default = newJString("json"))
  if valid_579790 != nil:
    section.add "alt", valid_579790
  var valid_579791 = query.getOrDefault("uploadType")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "uploadType", valid_579791
  var valid_579792 = query.getOrDefault("quotaUser")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "quotaUser", valid_579792
  var valid_579793 = query.getOrDefault("callback")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = nil)
  if valid_579793 != nil:
    section.add "callback", valid_579793
  var valid_579794 = query.getOrDefault("fields")
  valid_579794 = validateParameter(valid_579794, JString, required = false,
                                 default = nil)
  if valid_579794 != nil:
    section.add "fields", valid_579794
  var valid_579795 = query.getOrDefault("access_token")
  valid_579795 = validateParameter(valid_579795, JString, required = false,
                                 default = nil)
  if valid_579795 != nil:
    section.add "access_token", valid_579795
  var valid_579796 = query.getOrDefault("upload_protocol")
  valid_579796 = validateParameter(valid_579796, JString, required = false,
                                 default = nil)
  if valid_579796 != nil:
    section.add "upload_protocol", valid_579796
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579820: Call_CloudsearchDebugDatasourcesItemsSearchByViewUrl_579644;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches the item whose viewUrl exactly matches that of the URL provided
  ## in the request.
  ## 
  let valid = call_579820.validator(path, query, header, formData, body)
  let scheme = call_579820.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579820.url(scheme.get, call_579820.host, call_579820.base,
                         call_579820.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579820, url, valid)

proc call*(call_579891: Call_CloudsearchDebugDatasourcesItemsSearchByViewUrl_579644;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudsearchDebugDatasourcesItemsSearchByViewUrl
  ## Fetches the item whose viewUrl exactly matches that of the URL provided
  ## in the request.
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
  ##       : Source name, format:
  ## datasources/{source_id}
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579892 = newJObject()
  var query_579894 = newJObject()
  var body_579895 = newJObject()
  add(query_579894, "key", newJString(key))
  add(query_579894, "prettyPrint", newJBool(prettyPrint))
  add(query_579894, "oauth_token", newJString(oauthToken))
  add(query_579894, "$.xgafv", newJString(Xgafv))
  add(query_579894, "alt", newJString(alt))
  add(query_579894, "uploadType", newJString(uploadType))
  add(query_579894, "quotaUser", newJString(quotaUser))
  add(path_579892, "name", newJString(name))
  if body != nil:
    body_579895 = body
  add(query_579894, "callback", newJString(callback))
  add(query_579894, "fields", newJString(fields))
  add(query_579894, "access_token", newJString(accessToken))
  add(query_579894, "upload_protocol", newJString(uploadProtocol))
  result = call_579891.call(path_579892, query_579894, nil, nil, body_579895)

var cloudsearchDebugDatasourcesItemsSearchByViewUrl* = Call_CloudsearchDebugDatasourcesItemsSearchByViewUrl_579644(
    name: "cloudsearchDebugDatasourcesItemsSearchByViewUrl",
    meth: HttpMethod.HttpPost, host: "cloudsearch.googleapis.com",
    route: "/v1/debug/{name}/items:searchByViewUrl",
    validator: validate_CloudsearchDebugDatasourcesItemsSearchByViewUrl_579645,
    base: "/", url: url_CloudsearchDebugDatasourcesItemsSearchByViewUrl_579646,
    schemes: {Scheme.Https})
type
  Call_CloudsearchDebugDatasourcesItemsCheckAccess_579934 = ref object of OpenApiRestCall_579373
proc url_CloudsearchDebugDatasourcesItemsCheckAccess_579936(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/debug/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":checkAccess")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudsearchDebugDatasourcesItemsCheckAccess_579935(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether an item is accessible by specified principal.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Item name, format:
  ## datasources/{source_id}/items/{item_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579937 = path.getOrDefault("name")
  valid_579937 = validateParameter(valid_579937, JString, required = true,
                                 default = nil)
  if valid_579937 != nil:
    section.add "name", valid_579937
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   debugOptions.enableDebugging: JBool
  ##                               : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
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
  var valid_579938 = query.getOrDefault("key")
  valid_579938 = validateParameter(valid_579938, JString, required = false,
                                 default = nil)
  if valid_579938 != nil:
    section.add "key", valid_579938
  var valid_579939 = query.getOrDefault("debugOptions.enableDebugging")
  valid_579939 = validateParameter(valid_579939, JBool, required = false, default = nil)
  if valid_579939 != nil:
    section.add "debugOptions.enableDebugging", valid_579939
  var valid_579940 = query.getOrDefault("prettyPrint")
  valid_579940 = validateParameter(valid_579940, JBool, required = false,
                                 default = newJBool(true))
  if valid_579940 != nil:
    section.add "prettyPrint", valid_579940
  var valid_579941 = query.getOrDefault("oauth_token")
  valid_579941 = validateParameter(valid_579941, JString, required = false,
                                 default = nil)
  if valid_579941 != nil:
    section.add "oauth_token", valid_579941
  var valid_579942 = query.getOrDefault("$.xgafv")
  valid_579942 = validateParameter(valid_579942, JString, required = false,
                                 default = newJString("1"))
  if valid_579942 != nil:
    section.add "$.xgafv", valid_579942
  var valid_579943 = query.getOrDefault("alt")
  valid_579943 = validateParameter(valid_579943, JString, required = false,
                                 default = newJString("json"))
  if valid_579943 != nil:
    section.add "alt", valid_579943
  var valid_579944 = query.getOrDefault("uploadType")
  valid_579944 = validateParameter(valid_579944, JString, required = false,
                                 default = nil)
  if valid_579944 != nil:
    section.add "uploadType", valid_579944
  var valid_579945 = query.getOrDefault("quotaUser")
  valid_579945 = validateParameter(valid_579945, JString, required = false,
                                 default = nil)
  if valid_579945 != nil:
    section.add "quotaUser", valid_579945
  var valid_579946 = query.getOrDefault("callback")
  valid_579946 = validateParameter(valid_579946, JString, required = false,
                                 default = nil)
  if valid_579946 != nil:
    section.add "callback", valid_579946
  var valid_579947 = query.getOrDefault("fields")
  valid_579947 = validateParameter(valid_579947, JString, required = false,
                                 default = nil)
  if valid_579947 != nil:
    section.add "fields", valid_579947
  var valid_579948 = query.getOrDefault("access_token")
  valid_579948 = validateParameter(valid_579948, JString, required = false,
                                 default = nil)
  if valid_579948 != nil:
    section.add "access_token", valid_579948
  var valid_579949 = query.getOrDefault("upload_protocol")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = nil)
  if valid_579949 != nil:
    section.add "upload_protocol", valid_579949
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579951: Call_CloudsearchDebugDatasourcesItemsCheckAccess_579934;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether an item is accessible by specified principal.
  ## 
  let valid = call_579951.validator(path, query, header, formData, body)
  let scheme = call_579951.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579951.url(scheme.get, call_579951.host, call_579951.base,
                         call_579951.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579951, url, valid)

proc call*(call_579952: Call_CloudsearchDebugDatasourcesItemsCheckAccess_579934;
          name: string; key: string = ""; debugOptionsEnableDebugging: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudsearchDebugDatasourcesItemsCheckAccess
  ## Checks whether an item is accessible by specified principal.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   debugOptionsEnableDebugging: bool
  ##                              : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
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
  ##       : Item name, format:
  ## datasources/{source_id}/items/{item_id}
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579953 = newJObject()
  var query_579954 = newJObject()
  var body_579955 = newJObject()
  add(query_579954, "key", newJString(key))
  add(query_579954, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_579954, "prettyPrint", newJBool(prettyPrint))
  add(query_579954, "oauth_token", newJString(oauthToken))
  add(query_579954, "$.xgafv", newJString(Xgafv))
  add(query_579954, "alt", newJString(alt))
  add(query_579954, "uploadType", newJString(uploadType))
  add(query_579954, "quotaUser", newJString(quotaUser))
  add(path_579953, "name", newJString(name))
  if body != nil:
    body_579955 = body
  add(query_579954, "callback", newJString(callback))
  add(query_579954, "fields", newJString(fields))
  add(query_579954, "access_token", newJString(accessToken))
  add(query_579954, "upload_protocol", newJString(uploadProtocol))
  result = call_579952.call(path_579953, query_579954, nil, nil, body_579955)

var cloudsearchDebugDatasourcesItemsCheckAccess* = Call_CloudsearchDebugDatasourcesItemsCheckAccess_579934(
    name: "cloudsearchDebugDatasourcesItemsCheckAccess",
    meth: HttpMethod.HttpPost, host: "cloudsearch.googleapis.com",
    route: "/v1/debug/{name}:checkAccess",
    validator: validate_CloudsearchDebugDatasourcesItemsCheckAccess_579935,
    base: "/", url: url_CloudsearchDebugDatasourcesItemsCheckAccess_579936,
    schemes: {Scheme.Https})
type
  Call_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_579956 = ref object of OpenApiRestCall_579373
proc url_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_579958(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/debug/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/items:forunmappedidentity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_579957(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists names of items associated with an unmapped identity.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the identity source, in the following format:
  ## identitysources/{source_id}}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579959 = path.getOrDefault("parent")
  valid_579959 = validateParameter(valid_579959, JString, required = true,
                                 default = nil)
  if valid_579959 != nil:
    section.add "parent", valid_579959
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   debugOptions.enableDebugging: JBool
  ##                               : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum number of items to fetch in a request.
  ## Defaults to 100.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   groupResourceName: JString
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous List request, if any.
  ##   userResourceName: JString
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579960 = query.getOrDefault("key")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "key", valid_579960
  var valid_579961 = query.getOrDefault("debugOptions.enableDebugging")
  valid_579961 = validateParameter(valid_579961, JBool, required = false, default = nil)
  if valid_579961 != nil:
    section.add "debugOptions.enableDebugging", valid_579961
  var valid_579962 = query.getOrDefault("prettyPrint")
  valid_579962 = validateParameter(valid_579962, JBool, required = false,
                                 default = newJBool(true))
  if valid_579962 != nil:
    section.add "prettyPrint", valid_579962
  var valid_579963 = query.getOrDefault("oauth_token")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "oauth_token", valid_579963
  var valid_579964 = query.getOrDefault("$.xgafv")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = newJString("1"))
  if valid_579964 != nil:
    section.add "$.xgafv", valid_579964
  var valid_579965 = query.getOrDefault("pageSize")
  valid_579965 = validateParameter(valid_579965, JInt, required = false, default = nil)
  if valid_579965 != nil:
    section.add "pageSize", valid_579965
  var valid_579966 = query.getOrDefault("alt")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = newJString("json"))
  if valid_579966 != nil:
    section.add "alt", valid_579966
  var valid_579967 = query.getOrDefault("uploadType")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "uploadType", valid_579967
  var valid_579968 = query.getOrDefault("quotaUser")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "quotaUser", valid_579968
  var valid_579969 = query.getOrDefault("groupResourceName")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "groupResourceName", valid_579969
  var valid_579970 = query.getOrDefault("pageToken")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "pageToken", valid_579970
  var valid_579971 = query.getOrDefault("userResourceName")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "userResourceName", valid_579971
  var valid_579972 = query.getOrDefault("callback")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "callback", valid_579972
  var valid_579973 = query.getOrDefault("fields")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "fields", valid_579973
  var valid_579974 = query.getOrDefault("access_token")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "access_token", valid_579974
  var valid_579975 = query.getOrDefault("upload_protocol")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "upload_protocol", valid_579975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579976: Call_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_579956;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists names of items associated with an unmapped identity.
  ## 
  let valid = call_579976.validator(path, query, header, formData, body)
  let scheme = call_579976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579976.url(scheme.get, call_579976.host, call_579976.base,
                         call_579976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579976, url, valid)

proc call*(call_579977: Call_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_579956;
          parent: string; key: string = ""; debugOptionsEnableDebugging: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; groupResourceName: string = "";
          pageToken: string = ""; userResourceName: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudsearchDebugIdentitysourcesItemsListForunmappedidentity
  ## Lists names of items associated with an unmapped identity.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   debugOptionsEnableDebugging: bool
  ##                              : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of items to fetch in a request.
  ## Defaults to 100.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   groupResourceName: string
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous List request, if any.
  ##   userResourceName: string
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The name of the identity source, in the following format:
  ## identitysources/{source_id}}
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579978 = newJObject()
  var query_579979 = newJObject()
  add(query_579979, "key", newJString(key))
  add(query_579979, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_579979, "prettyPrint", newJBool(prettyPrint))
  add(query_579979, "oauth_token", newJString(oauthToken))
  add(query_579979, "$.xgafv", newJString(Xgafv))
  add(query_579979, "pageSize", newJInt(pageSize))
  add(query_579979, "alt", newJString(alt))
  add(query_579979, "uploadType", newJString(uploadType))
  add(query_579979, "quotaUser", newJString(quotaUser))
  add(query_579979, "groupResourceName", newJString(groupResourceName))
  add(query_579979, "pageToken", newJString(pageToken))
  add(query_579979, "userResourceName", newJString(userResourceName))
  add(query_579979, "callback", newJString(callback))
  add(path_579978, "parent", newJString(parent))
  add(query_579979, "fields", newJString(fields))
  add(query_579979, "access_token", newJString(accessToken))
  add(query_579979, "upload_protocol", newJString(uploadProtocol))
  result = call_579977.call(path_579978, query_579979, nil, nil, nil)

var cloudsearchDebugIdentitysourcesItemsListForunmappedidentity* = Call_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_579956(
    name: "cloudsearchDebugIdentitysourcesItemsListForunmappedidentity",
    meth: HttpMethod.HttpGet, host: "cloudsearch.googleapis.com",
    route: "/v1/debug/{parent}/items:forunmappedidentity", validator: validate_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_579957,
    base: "/",
    url: url_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_579958,
    schemes: {Scheme.Https})
type
  Call_CloudsearchDebugDatasourcesItemsUnmappedidsList_579980 = ref object of OpenApiRestCall_579373
proc url_CloudsearchDebugDatasourcesItemsUnmappedidsList_579982(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/debug/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/unmappedids")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudsearchDebugDatasourcesItemsUnmappedidsList_579981(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## List all unmapped identities for a specific item.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the item, in the following format:
  ## datasources/{source_id}/items/{ID}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579983 = path.getOrDefault("parent")
  valid_579983 = validateParameter(valid_579983, JString, required = true,
                                 default = nil)
  if valid_579983 != nil:
    section.add "parent", valid_579983
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   debugOptions.enableDebugging: JBool
  ##                               : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum number of items to fetch in a request.
  ## Defaults to 100.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous List request, if any.
  ##   callback: JString
  ##           : JSONP
  ##   resolutionStatusCode: JString
  ##                       : Limit users selection to this status.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579984 = query.getOrDefault("key")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "key", valid_579984
  var valid_579985 = query.getOrDefault("debugOptions.enableDebugging")
  valid_579985 = validateParameter(valid_579985, JBool, required = false, default = nil)
  if valid_579985 != nil:
    section.add "debugOptions.enableDebugging", valid_579985
  var valid_579986 = query.getOrDefault("prettyPrint")
  valid_579986 = validateParameter(valid_579986, JBool, required = false,
                                 default = newJBool(true))
  if valid_579986 != nil:
    section.add "prettyPrint", valid_579986
  var valid_579987 = query.getOrDefault("oauth_token")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "oauth_token", valid_579987
  var valid_579988 = query.getOrDefault("$.xgafv")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = newJString("1"))
  if valid_579988 != nil:
    section.add "$.xgafv", valid_579988
  var valid_579989 = query.getOrDefault("pageSize")
  valid_579989 = validateParameter(valid_579989, JInt, required = false, default = nil)
  if valid_579989 != nil:
    section.add "pageSize", valid_579989
  var valid_579990 = query.getOrDefault("alt")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = newJString("json"))
  if valid_579990 != nil:
    section.add "alt", valid_579990
  var valid_579991 = query.getOrDefault("uploadType")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "uploadType", valid_579991
  var valid_579992 = query.getOrDefault("quotaUser")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "quotaUser", valid_579992
  var valid_579993 = query.getOrDefault("pageToken")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "pageToken", valid_579993
  var valid_579994 = query.getOrDefault("callback")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "callback", valid_579994
  var valid_579995 = query.getOrDefault("resolutionStatusCode")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = newJString("CODE_UNSPECIFIED"))
  if valid_579995 != nil:
    section.add "resolutionStatusCode", valid_579995
  var valid_579996 = query.getOrDefault("fields")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "fields", valid_579996
  var valid_579997 = query.getOrDefault("access_token")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "access_token", valid_579997
  var valid_579998 = query.getOrDefault("upload_protocol")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "upload_protocol", valid_579998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579999: Call_CloudsearchDebugDatasourcesItemsUnmappedidsList_579980;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List all unmapped identities for a specific item.
  ## 
  let valid = call_579999.validator(path, query, header, formData, body)
  let scheme = call_579999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579999.url(scheme.get, call_579999.host, call_579999.base,
                         call_579999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579999, url, valid)

proc call*(call_580000: Call_CloudsearchDebugDatasourcesItemsUnmappedidsList_579980;
          parent: string; key: string = ""; debugOptionsEnableDebugging: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; pageToken: string = ""; callback: string = "";
          resolutionStatusCode: string = "CODE_UNSPECIFIED"; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudsearchDebugDatasourcesItemsUnmappedidsList
  ## List all unmapped identities for a specific item.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   debugOptionsEnableDebugging: bool
  ##                              : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of items to fetch in a request.
  ## Defaults to 100.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous List request, if any.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The name of the item, in the following format:
  ## datasources/{source_id}/items/{ID}
  ##   resolutionStatusCode: string
  ##                       : Limit users selection to this status.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580001 = newJObject()
  var query_580002 = newJObject()
  add(query_580002, "key", newJString(key))
  add(query_580002, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_580002, "prettyPrint", newJBool(prettyPrint))
  add(query_580002, "oauth_token", newJString(oauthToken))
  add(query_580002, "$.xgafv", newJString(Xgafv))
  add(query_580002, "pageSize", newJInt(pageSize))
  add(query_580002, "alt", newJString(alt))
  add(query_580002, "uploadType", newJString(uploadType))
  add(query_580002, "quotaUser", newJString(quotaUser))
  add(query_580002, "pageToken", newJString(pageToken))
  add(query_580002, "callback", newJString(callback))
  add(path_580001, "parent", newJString(parent))
  add(query_580002, "resolutionStatusCode", newJString(resolutionStatusCode))
  add(query_580002, "fields", newJString(fields))
  add(query_580002, "access_token", newJString(accessToken))
  add(query_580002, "upload_protocol", newJString(uploadProtocol))
  result = call_580000.call(path_580001, query_580002, nil, nil, nil)

var cloudsearchDebugDatasourcesItemsUnmappedidsList* = Call_CloudsearchDebugDatasourcesItemsUnmappedidsList_579980(
    name: "cloudsearchDebugDatasourcesItemsUnmappedidsList",
    meth: HttpMethod.HttpGet, host: "cloudsearch.googleapis.com",
    route: "/v1/debug/{parent}/unmappedids",
    validator: validate_CloudsearchDebugDatasourcesItemsUnmappedidsList_579981,
    base: "/", url: url_CloudsearchDebugDatasourcesItemsUnmappedidsList_579982,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsGet_580003 = ref object of OpenApiRestCall_579373
proc url_CloudsearchIndexingDatasourcesItemsGet_580005(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/indexing/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudsearchIndexingDatasourcesItemsGet_580004(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets Item resource by item name.
  ## 
  ## This API requires an admin or service account to execute.  The service
  ## account used is the one whitelisted in the corresponding data source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the item to get info.
  ## Format: datasources/{source_id}/items/{item_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580006 = path.getOrDefault("name")
  valid_580006 = validateParameter(valid_580006, JString, required = true,
                                 default = nil)
  if valid_580006 != nil:
    section.add "name", valid_580006
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   debugOptions.enableDebugging: JBool
  ##                               : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
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
  ##   connectorName: JString
  ##                : Name of connector making this call.
  ## <br />Format: datasources/{source_id}/connectors/{ID}
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580007 = query.getOrDefault("key")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "key", valid_580007
  var valid_580008 = query.getOrDefault("debugOptions.enableDebugging")
  valid_580008 = validateParameter(valid_580008, JBool, required = false, default = nil)
  if valid_580008 != nil:
    section.add "debugOptions.enableDebugging", valid_580008
  var valid_580009 = query.getOrDefault("prettyPrint")
  valid_580009 = validateParameter(valid_580009, JBool, required = false,
                                 default = newJBool(true))
  if valid_580009 != nil:
    section.add "prettyPrint", valid_580009
  var valid_580010 = query.getOrDefault("oauth_token")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "oauth_token", valid_580010
  var valid_580011 = query.getOrDefault("$.xgafv")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = newJString("1"))
  if valid_580011 != nil:
    section.add "$.xgafv", valid_580011
  var valid_580012 = query.getOrDefault("alt")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = newJString("json"))
  if valid_580012 != nil:
    section.add "alt", valid_580012
  var valid_580013 = query.getOrDefault("uploadType")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "uploadType", valid_580013
  var valid_580014 = query.getOrDefault("quotaUser")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "quotaUser", valid_580014
  var valid_580015 = query.getOrDefault("connectorName")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "connectorName", valid_580015
  var valid_580016 = query.getOrDefault("callback")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "callback", valid_580016
  var valid_580017 = query.getOrDefault("fields")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "fields", valid_580017
  var valid_580018 = query.getOrDefault("access_token")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "access_token", valid_580018
  var valid_580019 = query.getOrDefault("upload_protocol")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "upload_protocol", valid_580019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580020: Call_CloudsearchIndexingDatasourcesItemsGet_580003;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets Item resource by item name.
  ## 
  ## This API requires an admin or service account to execute.  The service
  ## account used is the one whitelisted in the corresponding data source.
  ## 
  let valid = call_580020.validator(path, query, header, formData, body)
  let scheme = call_580020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580020.url(scheme.get, call_580020.host, call_580020.base,
                         call_580020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580020, url, valid)

proc call*(call_580021: Call_CloudsearchIndexingDatasourcesItemsGet_580003;
          name: string; key: string = ""; debugOptionsEnableDebugging: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          connectorName: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudsearchIndexingDatasourcesItemsGet
  ## Gets Item resource by item name.
  ## 
  ## This API requires an admin or service account to execute.  The service
  ## account used is the one whitelisted in the corresponding data source.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   debugOptionsEnableDebugging: bool
  ##                              : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
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
  ##       : Name of the item to get info.
  ## Format: datasources/{source_id}/items/{item_id}
  ##   connectorName: string
  ##                : Name of connector making this call.
  ## <br />Format: datasources/{source_id}/connectors/{ID}
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580022 = newJObject()
  var query_580023 = newJObject()
  add(query_580023, "key", newJString(key))
  add(query_580023, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_580023, "prettyPrint", newJBool(prettyPrint))
  add(query_580023, "oauth_token", newJString(oauthToken))
  add(query_580023, "$.xgafv", newJString(Xgafv))
  add(query_580023, "alt", newJString(alt))
  add(query_580023, "uploadType", newJString(uploadType))
  add(query_580023, "quotaUser", newJString(quotaUser))
  add(path_580022, "name", newJString(name))
  add(query_580023, "connectorName", newJString(connectorName))
  add(query_580023, "callback", newJString(callback))
  add(query_580023, "fields", newJString(fields))
  add(query_580023, "access_token", newJString(accessToken))
  add(query_580023, "upload_protocol", newJString(uploadProtocol))
  result = call_580021.call(path_580022, query_580023, nil, nil, nil)

var cloudsearchIndexingDatasourcesItemsGet* = Call_CloudsearchIndexingDatasourcesItemsGet_580003(
    name: "cloudsearchIndexingDatasourcesItemsGet", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}",
    validator: validate_CloudsearchIndexingDatasourcesItemsGet_580004, base: "/",
    url: url_CloudsearchIndexingDatasourcesItemsGet_580005,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsDelete_580024 = ref object of OpenApiRestCall_579373
proc url_CloudsearchIndexingDatasourcesItemsDelete_580026(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/indexing/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudsearchIndexingDatasourcesItemsDelete_580025(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes Item resource for the
  ## specified resource name. This API requires an admin or service account
  ## to execute. The service account used is the one whitelisted in the
  ## corresponding data source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. Name of the item to delete.
  ## Format: datasources/{source_id}/items/{item_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580027 = path.getOrDefault("name")
  valid_580027 = validateParameter(valid_580027, JString, required = true,
                                 default = nil)
  if valid_580027 != nil:
    section.add "name", valid_580027
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   debugOptions.enableDebugging: JBool
  ##                               : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   mode: JString
  ##       : Required. The RequestMode for this request.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   version: JString
  ##          : Required. The incremented version of the item to delete from the index.
  ## The indexing system stores the version from the datasource as a
  ## byte string and compares the Item version in the index
  ## to the version of the queued Item using lexical ordering.
  ## <br /><br />
  ## Cloud Search Indexing won't delete any queued item with
  ## a version value that is less than or equal to
  ## the version of the currently indexed item.
  ## The maximum length for this field is 1024 bytes.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   connectorName: JString
  ##                : Name of connector making this call.
  ## <br />Format: datasources/{source_id}/connectors/{ID}
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580028 = query.getOrDefault("key")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "key", valid_580028
  var valid_580029 = query.getOrDefault("debugOptions.enableDebugging")
  valid_580029 = validateParameter(valid_580029, JBool, required = false, default = nil)
  if valid_580029 != nil:
    section.add "debugOptions.enableDebugging", valid_580029
  var valid_580030 = query.getOrDefault("prettyPrint")
  valid_580030 = validateParameter(valid_580030, JBool, required = false,
                                 default = newJBool(true))
  if valid_580030 != nil:
    section.add "prettyPrint", valid_580030
  var valid_580031 = query.getOrDefault("oauth_token")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "oauth_token", valid_580031
  var valid_580032 = query.getOrDefault("$.xgafv")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = newJString("1"))
  if valid_580032 != nil:
    section.add "$.xgafv", valid_580032
  var valid_580033 = query.getOrDefault("mode")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = newJString("UNSPECIFIED"))
  if valid_580033 != nil:
    section.add "mode", valid_580033
  var valid_580034 = query.getOrDefault("alt")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = newJString("json"))
  if valid_580034 != nil:
    section.add "alt", valid_580034
  var valid_580035 = query.getOrDefault("uploadType")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "uploadType", valid_580035
  var valid_580036 = query.getOrDefault("version")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "version", valid_580036
  var valid_580037 = query.getOrDefault("quotaUser")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "quotaUser", valid_580037
  var valid_580038 = query.getOrDefault("connectorName")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "connectorName", valid_580038
  var valid_580039 = query.getOrDefault("callback")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "callback", valid_580039
  var valid_580040 = query.getOrDefault("fields")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "fields", valid_580040
  var valid_580041 = query.getOrDefault("access_token")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "access_token", valid_580041
  var valid_580042 = query.getOrDefault("upload_protocol")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "upload_protocol", valid_580042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580043: Call_CloudsearchIndexingDatasourcesItemsDelete_580024;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes Item resource for the
  ## specified resource name. This API requires an admin or service account
  ## to execute. The service account used is the one whitelisted in the
  ## corresponding data source.
  ## 
  let valid = call_580043.validator(path, query, header, formData, body)
  let scheme = call_580043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580043.url(scheme.get, call_580043.host, call_580043.base,
                         call_580043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580043, url, valid)

proc call*(call_580044: Call_CloudsearchIndexingDatasourcesItemsDelete_580024;
          name: string; key: string = ""; debugOptionsEnableDebugging: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          mode: string = "UNSPECIFIED"; alt: string = "json"; uploadType: string = "";
          version: string = ""; quotaUser: string = ""; connectorName: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudsearchIndexingDatasourcesItemsDelete
  ## Deletes Item resource for the
  ## specified resource name. This API requires an admin or service account
  ## to execute. The service account used is the one whitelisted in the
  ## corresponding data source.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   debugOptionsEnableDebugging: bool
  ##                              : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   mode: string
  ##       : Required. The RequestMode for this request.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   version: string
  ##          : Required. The incremented version of the item to delete from the index.
  ## The indexing system stores the version from the datasource as a
  ## byte string and compares the Item version in the index
  ## to the version of the queued Item using lexical ordering.
  ## <br /><br />
  ## Cloud Search Indexing won't delete any queued item with
  ## a version value that is less than or equal to
  ## the version of the currently indexed item.
  ## The maximum length for this field is 1024 bytes.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. Name of the item to delete.
  ## Format: datasources/{source_id}/items/{item_id}
  ##   connectorName: string
  ##                : Name of connector making this call.
  ## <br />Format: datasources/{source_id}/connectors/{ID}
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580045 = newJObject()
  var query_580046 = newJObject()
  add(query_580046, "key", newJString(key))
  add(query_580046, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_580046, "prettyPrint", newJBool(prettyPrint))
  add(query_580046, "oauth_token", newJString(oauthToken))
  add(query_580046, "$.xgafv", newJString(Xgafv))
  add(query_580046, "mode", newJString(mode))
  add(query_580046, "alt", newJString(alt))
  add(query_580046, "uploadType", newJString(uploadType))
  add(query_580046, "version", newJString(version))
  add(query_580046, "quotaUser", newJString(quotaUser))
  add(path_580045, "name", newJString(name))
  add(query_580046, "connectorName", newJString(connectorName))
  add(query_580046, "callback", newJString(callback))
  add(query_580046, "fields", newJString(fields))
  add(query_580046, "access_token", newJString(accessToken))
  add(query_580046, "upload_protocol", newJString(uploadProtocol))
  result = call_580044.call(path_580045, query_580046, nil, nil, nil)

var cloudsearchIndexingDatasourcesItemsDelete* = Call_CloudsearchIndexingDatasourcesItemsDelete_580024(
    name: "cloudsearchIndexingDatasourcesItemsDelete",
    meth: HttpMethod.HttpDelete, host: "cloudsearch.googleapis.com",
    route: "/v1/indexing/{name}",
    validator: validate_CloudsearchIndexingDatasourcesItemsDelete_580025,
    base: "/", url: url_CloudsearchIndexingDatasourcesItemsDelete_580026,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsList_580047 = ref object of OpenApiRestCall_579373
proc url_CloudsearchIndexingDatasourcesItemsList_580049(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/indexing/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/items")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudsearchIndexingDatasourcesItemsList_580048(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all or a subset of Item resources.
  ## 
  ## This API requires an admin or service account to execute. The service
  ## account used is the one whitelisted in the corresponding data source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the Data Source to list Items.  Format:
  ## datasources/{source_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580050 = path.getOrDefault("name")
  valid_580050 = validateParameter(valid_580050, JString, required = true,
                                 default = nil)
  if valid_580050 != nil:
    section.add "name", valid_580050
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   debugOptions.enableDebugging: JBool
  ##                               : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum number of items to fetch in a request.
  ## The max value is 1000 when brief is true.  The max value is 10 if brief
  ## is false.
  ## <br />The default value is 10
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   connectorName: JString
  ##                : Name of connector making this call.
  ## <br />Format: datasources/{source_id}/connectors/{ID}
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous List request, if any.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   brief: JBool
  ##        : When set to true, the indexing system only populates the following fields:
  ## name,
  ## version,
  ## queue.
  ## metadata.hash,
  ## metadata.title,
  ## metadata.sourceRepositoryURL,
  ## metadata.objectType,
  ## metadata.createTime,
  ## metadata.updateTime,
  ## metadata.contentLanguage,
  ## metadata.mimeType,
  ## structured_data.hash,
  ## content.hash,
  ## itemType,
  ## itemStatus.code,
  ## itemStatus.processingError.code,
  ## itemStatus.repositoryError.type,
  ## <br />If this value is false, then all the fields are populated in Item.
  section = newJObject()
  var valid_580051 = query.getOrDefault("key")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "key", valid_580051
  var valid_580052 = query.getOrDefault("debugOptions.enableDebugging")
  valid_580052 = validateParameter(valid_580052, JBool, required = false, default = nil)
  if valid_580052 != nil:
    section.add "debugOptions.enableDebugging", valid_580052
  var valid_580053 = query.getOrDefault("prettyPrint")
  valid_580053 = validateParameter(valid_580053, JBool, required = false,
                                 default = newJBool(true))
  if valid_580053 != nil:
    section.add "prettyPrint", valid_580053
  var valid_580054 = query.getOrDefault("oauth_token")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "oauth_token", valid_580054
  var valid_580055 = query.getOrDefault("$.xgafv")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = newJString("1"))
  if valid_580055 != nil:
    section.add "$.xgafv", valid_580055
  var valid_580056 = query.getOrDefault("pageSize")
  valid_580056 = validateParameter(valid_580056, JInt, required = false, default = nil)
  if valid_580056 != nil:
    section.add "pageSize", valid_580056
  var valid_580057 = query.getOrDefault("alt")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = newJString("json"))
  if valid_580057 != nil:
    section.add "alt", valid_580057
  var valid_580058 = query.getOrDefault("uploadType")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "uploadType", valid_580058
  var valid_580059 = query.getOrDefault("quotaUser")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "quotaUser", valid_580059
  var valid_580060 = query.getOrDefault("connectorName")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "connectorName", valid_580060
  var valid_580061 = query.getOrDefault("pageToken")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "pageToken", valid_580061
  var valid_580062 = query.getOrDefault("callback")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "callback", valid_580062
  var valid_580063 = query.getOrDefault("fields")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "fields", valid_580063
  var valid_580064 = query.getOrDefault("access_token")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "access_token", valid_580064
  var valid_580065 = query.getOrDefault("upload_protocol")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "upload_protocol", valid_580065
  var valid_580066 = query.getOrDefault("brief")
  valid_580066 = validateParameter(valid_580066, JBool, required = false, default = nil)
  if valid_580066 != nil:
    section.add "brief", valid_580066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580067: Call_CloudsearchIndexingDatasourcesItemsList_580047;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all or a subset of Item resources.
  ## 
  ## This API requires an admin or service account to execute. The service
  ## account used is the one whitelisted in the corresponding data source.
  ## 
  let valid = call_580067.validator(path, query, header, formData, body)
  let scheme = call_580067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580067.url(scheme.get, call_580067.host, call_580067.base,
                         call_580067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580067, url, valid)

proc call*(call_580068: Call_CloudsearchIndexingDatasourcesItemsList_580047;
          name: string; key: string = ""; debugOptionsEnableDebugging: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; connectorName: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; brief: bool = false): Recallable =
  ## cloudsearchIndexingDatasourcesItemsList
  ## Lists all or a subset of Item resources.
  ## 
  ## This API requires an admin or service account to execute. The service
  ## account used is the one whitelisted in the corresponding data source.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   debugOptionsEnableDebugging: bool
  ##                              : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of items to fetch in a request.
  ## The max value is 1000 when brief is true.  The max value is 10 if brief
  ## is false.
  ## <br />The default value is 10
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the Data Source to list Items.  Format:
  ## datasources/{source_id}
  ##   connectorName: string
  ##                : Name of connector making this call.
  ## <br />Format: datasources/{source_id}/connectors/{ID}
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous List request, if any.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   brief: bool
  ##        : When set to true, the indexing system only populates the following fields:
  ## name,
  ## version,
  ## queue.
  ## metadata.hash,
  ## metadata.title,
  ## metadata.sourceRepositoryURL,
  ## metadata.objectType,
  ## metadata.createTime,
  ## metadata.updateTime,
  ## metadata.contentLanguage,
  ## metadata.mimeType,
  ## structured_data.hash,
  ## content.hash,
  ## itemType,
  ## itemStatus.code,
  ## itemStatus.processingError.code,
  ## itemStatus.repositoryError.type,
  ## <br />If this value is false, then all the fields are populated in Item.
  var path_580069 = newJObject()
  var query_580070 = newJObject()
  add(query_580070, "key", newJString(key))
  add(query_580070, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_580070, "prettyPrint", newJBool(prettyPrint))
  add(query_580070, "oauth_token", newJString(oauthToken))
  add(query_580070, "$.xgafv", newJString(Xgafv))
  add(query_580070, "pageSize", newJInt(pageSize))
  add(query_580070, "alt", newJString(alt))
  add(query_580070, "uploadType", newJString(uploadType))
  add(query_580070, "quotaUser", newJString(quotaUser))
  add(path_580069, "name", newJString(name))
  add(query_580070, "connectorName", newJString(connectorName))
  add(query_580070, "pageToken", newJString(pageToken))
  add(query_580070, "callback", newJString(callback))
  add(query_580070, "fields", newJString(fields))
  add(query_580070, "access_token", newJString(accessToken))
  add(query_580070, "upload_protocol", newJString(uploadProtocol))
  add(query_580070, "brief", newJBool(brief))
  result = call_580068.call(path_580069, query_580070, nil, nil, nil)

var cloudsearchIndexingDatasourcesItemsList* = Call_CloudsearchIndexingDatasourcesItemsList_580047(
    name: "cloudsearchIndexingDatasourcesItemsList", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}/items",
    validator: validate_CloudsearchIndexingDatasourcesItemsList_580048, base: "/",
    url: url_CloudsearchIndexingDatasourcesItemsList_580049,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_580071 = ref object of OpenApiRestCall_579373
proc url_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_580073(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/indexing/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/items:deleteQueueItems")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_580072(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes all items in a queue. This method is useful for deleting stale
  ## items.
  ## 
  ## This API requires an admin or service account to execute. The service
  ## account used is the one whitelisted in the corresponding data source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the Data Source to delete items in a queue.
  ## Format: datasources/{source_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580074 = path.getOrDefault("name")
  valid_580074 = validateParameter(valid_580074, JString, required = true,
                                 default = nil)
  if valid_580074 != nil:
    section.add "name", valid_580074
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
  var valid_580075 = query.getOrDefault("key")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "key", valid_580075
  var valid_580076 = query.getOrDefault("prettyPrint")
  valid_580076 = validateParameter(valid_580076, JBool, required = false,
                                 default = newJBool(true))
  if valid_580076 != nil:
    section.add "prettyPrint", valid_580076
  var valid_580077 = query.getOrDefault("oauth_token")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "oauth_token", valid_580077
  var valid_580078 = query.getOrDefault("$.xgafv")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = newJString("1"))
  if valid_580078 != nil:
    section.add "$.xgafv", valid_580078
  var valid_580079 = query.getOrDefault("alt")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = newJString("json"))
  if valid_580079 != nil:
    section.add "alt", valid_580079
  var valid_580080 = query.getOrDefault("uploadType")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "uploadType", valid_580080
  var valid_580081 = query.getOrDefault("quotaUser")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "quotaUser", valid_580081
  var valid_580082 = query.getOrDefault("callback")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "callback", valid_580082
  var valid_580083 = query.getOrDefault("fields")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "fields", valid_580083
  var valid_580084 = query.getOrDefault("access_token")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "access_token", valid_580084
  var valid_580085 = query.getOrDefault("upload_protocol")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "upload_protocol", valid_580085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580087: Call_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_580071;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all items in a queue. This method is useful for deleting stale
  ## items.
  ## 
  ## This API requires an admin or service account to execute. The service
  ## account used is the one whitelisted in the corresponding data source.
  ## 
  let valid = call_580087.validator(path, query, header, formData, body)
  let scheme = call_580087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580087.url(scheme.get, call_580087.host, call_580087.base,
                         call_580087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580087, url, valid)

proc call*(call_580088: Call_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_580071;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudsearchIndexingDatasourcesItemsDeleteQueueItems
  ## Deletes all items in a queue. This method is useful for deleting stale
  ## items.
  ## 
  ## This API requires an admin or service account to execute. The service
  ## account used is the one whitelisted in the corresponding data source.
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
  ##       : Name of the Data Source to delete items in a queue.
  ## Format: datasources/{source_id}
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580089 = newJObject()
  var query_580090 = newJObject()
  var body_580091 = newJObject()
  add(query_580090, "key", newJString(key))
  add(query_580090, "prettyPrint", newJBool(prettyPrint))
  add(query_580090, "oauth_token", newJString(oauthToken))
  add(query_580090, "$.xgafv", newJString(Xgafv))
  add(query_580090, "alt", newJString(alt))
  add(query_580090, "uploadType", newJString(uploadType))
  add(query_580090, "quotaUser", newJString(quotaUser))
  add(path_580089, "name", newJString(name))
  if body != nil:
    body_580091 = body
  add(query_580090, "callback", newJString(callback))
  add(query_580090, "fields", newJString(fields))
  add(query_580090, "access_token", newJString(accessToken))
  add(query_580090, "upload_protocol", newJString(uploadProtocol))
  result = call_580088.call(path_580089, query_580090, nil, nil, body_580091)

var cloudsearchIndexingDatasourcesItemsDeleteQueueItems* = Call_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_580071(
    name: "cloudsearchIndexingDatasourcesItemsDeleteQueueItems",
    meth: HttpMethod.HttpPost, host: "cloudsearch.googleapis.com",
    route: "/v1/indexing/{name}/items:deleteQueueItems",
    validator: validate_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_580072,
    base: "/", url: url_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_580073,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsPoll_580092 = ref object of OpenApiRestCall_579373
proc url_CloudsearchIndexingDatasourcesItemsPoll_580094(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/indexing/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/items:poll")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudsearchIndexingDatasourcesItemsPoll_580093(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Polls for unreserved items from the indexing queue and marks a
  ## set as reserved, starting with items that have
  ## the oldest timestamp from the highest priority
  ## ItemStatus.
  ## The priority order is as follows: <br />
  ## ERROR
  ## <br />
  ## MODIFIED
  ## <br />
  ## NEW_ITEM
  ## <br />
  ## ACCEPTED
  ## <br />
  ## Reserving items ensures that polling from other threads
  ## cannot create overlapping sets.
  ## 
  ## After handling the reserved items, the client should put items back
  ## into the unreserved state, either by calling
  ## index,
  ## or by calling
  ## push with
  ## the type REQUEUE.
  ## 
  ## Items automatically become available (unreserved) after 4 hours even if no
  ## update or push method is called.
  ## 
  ## This API requires an admin or service account to execute. The service
  ## account used is the one whitelisted in the corresponding data source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the Data Source to poll items.
  ## Format: datasources/{source_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580095 = path.getOrDefault("name")
  valid_580095 = validateParameter(valid_580095, JString, required = true,
                                 default = nil)
  if valid_580095 != nil:
    section.add "name", valid_580095
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
  var valid_580096 = query.getOrDefault("key")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "key", valid_580096
  var valid_580097 = query.getOrDefault("prettyPrint")
  valid_580097 = validateParameter(valid_580097, JBool, required = false,
                                 default = newJBool(true))
  if valid_580097 != nil:
    section.add "prettyPrint", valid_580097
  var valid_580098 = query.getOrDefault("oauth_token")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "oauth_token", valid_580098
  var valid_580099 = query.getOrDefault("$.xgafv")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = newJString("1"))
  if valid_580099 != nil:
    section.add "$.xgafv", valid_580099
  var valid_580100 = query.getOrDefault("alt")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = newJString("json"))
  if valid_580100 != nil:
    section.add "alt", valid_580100
  var valid_580101 = query.getOrDefault("uploadType")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "uploadType", valid_580101
  var valid_580102 = query.getOrDefault("quotaUser")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "quotaUser", valid_580102
  var valid_580103 = query.getOrDefault("callback")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "callback", valid_580103
  var valid_580104 = query.getOrDefault("fields")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "fields", valid_580104
  var valid_580105 = query.getOrDefault("access_token")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "access_token", valid_580105
  var valid_580106 = query.getOrDefault("upload_protocol")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "upload_protocol", valid_580106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580108: Call_CloudsearchIndexingDatasourcesItemsPoll_580092;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Polls for unreserved items from the indexing queue and marks a
  ## set as reserved, starting with items that have
  ## the oldest timestamp from the highest priority
  ## ItemStatus.
  ## The priority order is as follows: <br />
  ## ERROR
  ## <br />
  ## MODIFIED
  ## <br />
  ## NEW_ITEM
  ## <br />
  ## ACCEPTED
  ## <br />
  ## Reserving items ensures that polling from other threads
  ## cannot create overlapping sets.
  ## 
  ## After handling the reserved items, the client should put items back
  ## into the unreserved state, either by calling
  ## index,
  ## or by calling
  ## push with
  ## the type REQUEUE.
  ## 
  ## Items automatically become available (unreserved) after 4 hours even if no
  ## update or push method is called.
  ## 
  ## This API requires an admin or service account to execute. The service
  ## account used is the one whitelisted in the corresponding data source.
  ## 
  let valid = call_580108.validator(path, query, header, formData, body)
  let scheme = call_580108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580108.url(scheme.get, call_580108.host, call_580108.base,
                         call_580108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580108, url, valid)

proc call*(call_580109: Call_CloudsearchIndexingDatasourcesItemsPoll_580092;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudsearchIndexingDatasourcesItemsPoll
  ## Polls for unreserved items from the indexing queue and marks a
  ## set as reserved, starting with items that have
  ## the oldest timestamp from the highest priority
  ## ItemStatus.
  ## The priority order is as follows: <br />
  ## ERROR
  ## <br />
  ## MODIFIED
  ## <br />
  ## NEW_ITEM
  ## <br />
  ## ACCEPTED
  ## <br />
  ## Reserving items ensures that polling from other threads
  ## cannot create overlapping sets.
  ## 
  ## After handling the reserved items, the client should put items back
  ## into the unreserved state, either by calling
  ## index,
  ## or by calling
  ## push with
  ## the type REQUEUE.
  ## 
  ## Items automatically become available (unreserved) after 4 hours even if no
  ## update or push method is called.
  ## 
  ## This API requires an admin or service account to execute. The service
  ## account used is the one whitelisted in the corresponding data source.
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
  ##       : Name of the Data Source to poll items.
  ## Format: datasources/{source_id}
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580110 = newJObject()
  var query_580111 = newJObject()
  var body_580112 = newJObject()
  add(query_580111, "key", newJString(key))
  add(query_580111, "prettyPrint", newJBool(prettyPrint))
  add(query_580111, "oauth_token", newJString(oauthToken))
  add(query_580111, "$.xgafv", newJString(Xgafv))
  add(query_580111, "alt", newJString(alt))
  add(query_580111, "uploadType", newJString(uploadType))
  add(query_580111, "quotaUser", newJString(quotaUser))
  add(path_580110, "name", newJString(name))
  if body != nil:
    body_580112 = body
  add(query_580111, "callback", newJString(callback))
  add(query_580111, "fields", newJString(fields))
  add(query_580111, "access_token", newJString(accessToken))
  add(query_580111, "upload_protocol", newJString(uploadProtocol))
  result = call_580109.call(path_580110, query_580111, nil, nil, body_580112)

var cloudsearchIndexingDatasourcesItemsPoll* = Call_CloudsearchIndexingDatasourcesItemsPoll_580092(
    name: "cloudsearchIndexingDatasourcesItemsPoll", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}/items:poll",
    validator: validate_CloudsearchIndexingDatasourcesItemsPoll_580093, base: "/",
    url: url_CloudsearchIndexingDatasourcesItemsPoll_580094,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsUnreserve_580113 = ref object of OpenApiRestCall_579373
proc url_CloudsearchIndexingDatasourcesItemsUnreserve_580115(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/indexing/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/items:unreserve")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudsearchIndexingDatasourcesItemsUnreserve_580114(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Unreserves all items from a queue, making them all eligible to be
  ## polled.  This method is useful for resetting the indexing queue
  ## after a connector has been restarted.
  ## 
  ## This API requires an admin or service account to execute. The service
  ## account used is the one whitelisted in the corresponding data source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the Data Source to unreserve all items.
  ## Format: datasources/{source_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580116 = path.getOrDefault("name")
  valid_580116 = validateParameter(valid_580116, JString, required = true,
                                 default = nil)
  if valid_580116 != nil:
    section.add "name", valid_580116
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
  var valid_580117 = query.getOrDefault("key")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "key", valid_580117
  var valid_580118 = query.getOrDefault("prettyPrint")
  valid_580118 = validateParameter(valid_580118, JBool, required = false,
                                 default = newJBool(true))
  if valid_580118 != nil:
    section.add "prettyPrint", valid_580118
  var valid_580119 = query.getOrDefault("oauth_token")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "oauth_token", valid_580119
  var valid_580120 = query.getOrDefault("$.xgafv")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = newJString("1"))
  if valid_580120 != nil:
    section.add "$.xgafv", valid_580120
  var valid_580121 = query.getOrDefault("alt")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = newJString("json"))
  if valid_580121 != nil:
    section.add "alt", valid_580121
  var valid_580122 = query.getOrDefault("uploadType")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "uploadType", valid_580122
  var valid_580123 = query.getOrDefault("quotaUser")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "quotaUser", valid_580123
  var valid_580124 = query.getOrDefault("callback")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "callback", valid_580124
  var valid_580125 = query.getOrDefault("fields")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "fields", valid_580125
  var valid_580126 = query.getOrDefault("access_token")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "access_token", valid_580126
  var valid_580127 = query.getOrDefault("upload_protocol")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "upload_protocol", valid_580127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580129: Call_CloudsearchIndexingDatasourcesItemsUnreserve_580113;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unreserves all items from a queue, making them all eligible to be
  ## polled.  This method is useful for resetting the indexing queue
  ## after a connector has been restarted.
  ## 
  ## This API requires an admin or service account to execute. The service
  ## account used is the one whitelisted in the corresponding data source.
  ## 
  let valid = call_580129.validator(path, query, header, formData, body)
  let scheme = call_580129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580129.url(scheme.get, call_580129.host, call_580129.base,
                         call_580129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580129, url, valid)

proc call*(call_580130: Call_CloudsearchIndexingDatasourcesItemsUnreserve_580113;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudsearchIndexingDatasourcesItemsUnreserve
  ## Unreserves all items from a queue, making them all eligible to be
  ## polled.  This method is useful for resetting the indexing queue
  ## after a connector has been restarted.
  ## 
  ## This API requires an admin or service account to execute. The service
  ## account used is the one whitelisted in the corresponding data source.
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
  ##       : Name of the Data Source to unreserve all items.
  ## Format: datasources/{source_id}
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580131 = newJObject()
  var query_580132 = newJObject()
  var body_580133 = newJObject()
  add(query_580132, "key", newJString(key))
  add(query_580132, "prettyPrint", newJBool(prettyPrint))
  add(query_580132, "oauth_token", newJString(oauthToken))
  add(query_580132, "$.xgafv", newJString(Xgafv))
  add(query_580132, "alt", newJString(alt))
  add(query_580132, "uploadType", newJString(uploadType))
  add(query_580132, "quotaUser", newJString(quotaUser))
  add(path_580131, "name", newJString(name))
  if body != nil:
    body_580133 = body
  add(query_580132, "callback", newJString(callback))
  add(query_580132, "fields", newJString(fields))
  add(query_580132, "access_token", newJString(accessToken))
  add(query_580132, "upload_protocol", newJString(uploadProtocol))
  result = call_580130.call(path_580131, query_580132, nil, nil, body_580133)

var cloudsearchIndexingDatasourcesItemsUnreserve* = Call_CloudsearchIndexingDatasourcesItemsUnreserve_580113(
    name: "cloudsearchIndexingDatasourcesItemsUnreserve",
    meth: HttpMethod.HttpPost, host: "cloudsearch.googleapis.com",
    route: "/v1/indexing/{name}/items:unreserve",
    validator: validate_CloudsearchIndexingDatasourcesItemsUnreserve_580114,
    base: "/", url: url_CloudsearchIndexingDatasourcesItemsUnreserve_580115,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesUpdateSchema_580154 = ref object of OpenApiRestCall_579373
proc url_CloudsearchIndexingDatasourcesUpdateSchema_580156(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/indexing/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/schema")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudsearchIndexingDatasourcesUpdateSchema_580155(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the schema of a data source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the data source to update Schema.  Format:
  ## datasources/{source_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580157 = path.getOrDefault("name")
  valid_580157 = validateParameter(valid_580157, JString, required = true,
                                 default = nil)
  if valid_580157 != nil:
    section.add "name", valid_580157
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
  var valid_580158 = query.getOrDefault("key")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "key", valid_580158
  var valid_580159 = query.getOrDefault("prettyPrint")
  valid_580159 = validateParameter(valid_580159, JBool, required = false,
                                 default = newJBool(true))
  if valid_580159 != nil:
    section.add "prettyPrint", valid_580159
  var valid_580160 = query.getOrDefault("oauth_token")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "oauth_token", valid_580160
  var valid_580161 = query.getOrDefault("$.xgafv")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = newJString("1"))
  if valid_580161 != nil:
    section.add "$.xgafv", valid_580161
  var valid_580162 = query.getOrDefault("alt")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = newJString("json"))
  if valid_580162 != nil:
    section.add "alt", valid_580162
  var valid_580163 = query.getOrDefault("uploadType")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "uploadType", valid_580163
  var valid_580164 = query.getOrDefault("quotaUser")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "quotaUser", valid_580164
  var valid_580165 = query.getOrDefault("callback")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "callback", valid_580165
  var valid_580166 = query.getOrDefault("fields")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "fields", valid_580166
  var valid_580167 = query.getOrDefault("access_token")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "access_token", valid_580167
  var valid_580168 = query.getOrDefault("upload_protocol")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "upload_protocol", valid_580168
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580170: Call_CloudsearchIndexingDatasourcesUpdateSchema_580154;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the schema of a data source.
  ## 
  let valid = call_580170.validator(path, query, header, formData, body)
  let scheme = call_580170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580170.url(scheme.get, call_580170.host, call_580170.base,
                         call_580170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580170, url, valid)

proc call*(call_580171: Call_CloudsearchIndexingDatasourcesUpdateSchema_580154;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudsearchIndexingDatasourcesUpdateSchema
  ## Updates the schema of a data source.
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
  ##       : Name of the data source to update Schema.  Format:
  ## datasources/{source_id}
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580172 = newJObject()
  var query_580173 = newJObject()
  var body_580174 = newJObject()
  add(query_580173, "key", newJString(key))
  add(query_580173, "prettyPrint", newJBool(prettyPrint))
  add(query_580173, "oauth_token", newJString(oauthToken))
  add(query_580173, "$.xgafv", newJString(Xgafv))
  add(query_580173, "alt", newJString(alt))
  add(query_580173, "uploadType", newJString(uploadType))
  add(query_580173, "quotaUser", newJString(quotaUser))
  add(path_580172, "name", newJString(name))
  if body != nil:
    body_580174 = body
  add(query_580173, "callback", newJString(callback))
  add(query_580173, "fields", newJString(fields))
  add(query_580173, "access_token", newJString(accessToken))
  add(query_580173, "upload_protocol", newJString(uploadProtocol))
  result = call_580171.call(path_580172, query_580173, nil, nil, body_580174)

var cloudsearchIndexingDatasourcesUpdateSchema* = Call_CloudsearchIndexingDatasourcesUpdateSchema_580154(
    name: "cloudsearchIndexingDatasourcesUpdateSchema", meth: HttpMethod.HttpPut,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}/schema",
    validator: validate_CloudsearchIndexingDatasourcesUpdateSchema_580155,
    base: "/", url: url_CloudsearchIndexingDatasourcesUpdateSchema_580156,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesGetSchema_580134 = ref object of OpenApiRestCall_579373
proc url_CloudsearchIndexingDatasourcesGetSchema_580136(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/indexing/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/schema")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudsearchIndexingDatasourcesGetSchema_580135(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the schema of a data source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the data source to get Schema.  Format:
  ## datasources/{source_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580137 = path.getOrDefault("name")
  valid_580137 = validateParameter(valid_580137, JString, required = true,
                                 default = nil)
  if valid_580137 != nil:
    section.add "name", valid_580137
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   debugOptions.enableDebugging: JBool
  ##                               : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
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
  var valid_580138 = query.getOrDefault("key")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "key", valid_580138
  var valid_580139 = query.getOrDefault("debugOptions.enableDebugging")
  valid_580139 = validateParameter(valid_580139, JBool, required = false, default = nil)
  if valid_580139 != nil:
    section.add "debugOptions.enableDebugging", valid_580139
  var valid_580140 = query.getOrDefault("prettyPrint")
  valid_580140 = validateParameter(valid_580140, JBool, required = false,
                                 default = newJBool(true))
  if valid_580140 != nil:
    section.add "prettyPrint", valid_580140
  var valid_580141 = query.getOrDefault("oauth_token")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "oauth_token", valid_580141
  var valid_580142 = query.getOrDefault("$.xgafv")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = newJString("1"))
  if valid_580142 != nil:
    section.add "$.xgafv", valid_580142
  var valid_580143 = query.getOrDefault("alt")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = newJString("json"))
  if valid_580143 != nil:
    section.add "alt", valid_580143
  var valid_580144 = query.getOrDefault("uploadType")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "uploadType", valid_580144
  var valid_580145 = query.getOrDefault("quotaUser")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "quotaUser", valid_580145
  var valid_580146 = query.getOrDefault("callback")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "callback", valid_580146
  var valid_580147 = query.getOrDefault("fields")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "fields", valid_580147
  var valid_580148 = query.getOrDefault("access_token")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "access_token", valid_580148
  var valid_580149 = query.getOrDefault("upload_protocol")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "upload_protocol", valid_580149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580150: Call_CloudsearchIndexingDatasourcesGetSchema_580134;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the schema of a data source.
  ## 
  let valid = call_580150.validator(path, query, header, formData, body)
  let scheme = call_580150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580150.url(scheme.get, call_580150.host, call_580150.base,
                         call_580150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580150, url, valid)

proc call*(call_580151: Call_CloudsearchIndexingDatasourcesGetSchema_580134;
          name: string; key: string = ""; debugOptionsEnableDebugging: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudsearchIndexingDatasourcesGetSchema
  ## Gets the schema of a data source.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   debugOptionsEnableDebugging: bool
  ##                              : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
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
  ##       : Name of the data source to get Schema.  Format:
  ## datasources/{source_id}
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580152 = newJObject()
  var query_580153 = newJObject()
  add(query_580153, "key", newJString(key))
  add(query_580153, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_580153, "prettyPrint", newJBool(prettyPrint))
  add(query_580153, "oauth_token", newJString(oauthToken))
  add(query_580153, "$.xgafv", newJString(Xgafv))
  add(query_580153, "alt", newJString(alt))
  add(query_580153, "uploadType", newJString(uploadType))
  add(query_580153, "quotaUser", newJString(quotaUser))
  add(path_580152, "name", newJString(name))
  add(query_580153, "callback", newJString(callback))
  add(query_580153, "fields", newJString(fields))
  add(query_580153, "access_token", newJString(accessToken))
  add(query_580153, "upload_protocol", newJString(uploadProtocol))
  result = call_580151.call(path_580152, query_580153, nil, nil, nil)

var cloudsearchIndexingDatasourcesGetSchema* = Call_CloudsearchIndexingDatasourcesGetSchema_580134(
    name: "cloudsearchIndexingDatasourcesGetSchema", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}/schema",
    validator: validate_CloudsearchIndexingDatasourcesGetSchema_580135, base: "/",
    url: url_CloudsearchIndexingDatasourcesGetSchema_580136,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesDeleteSchema_580175 = ref object of OpenApiRestCall_579373
proc url_CloudsearchIndexingDatasourcesDeleteSchema_580177(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/indexing/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/schema")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudsearchIndexingDatasourcesDeleteSchema_580176(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the schema of a data source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the data source to delete Schema.  Format:
  ## datasources/{source_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580178 = path.getOrDefault("name")
  valid_580178 = validateParameter(valid_580178, JString, required = true,
                                 default = nil)
  if valid_580178 != nil:
    section.add "name", valid_580178
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   debugOptions.enableDebugging: JBool
  ##                               : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
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
  var valid_580179 = query.getOrDefault("key")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "key", valid_580179
  var valid_580180 = query.getOrDefault("debugOptions.enableDebugging")
  valid_580180 = validateParameter(valid_580180, JBool, required = false, default = nil)
  if valid_580180 != nil:
    section.add "debugOptions.enableDebugging", valid_580180
  var valid_580181 = query.getOrDefault("prettyPrint")
  valid_580181 = validateParameter(valid_580181, JBool, required = false,
                                 default = newJBool(true))
  if valid_580181 != nil:
    section.add "prettyPrint", valid_580181
  var valid_580182 = query.getOrDefault("oauth_token")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "oauth_token", valid_580182
  var valid_580183 = query.getOrDefault("$.xgafv")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = newJString("1"))
  if valid_580183 != nil:
    section.add "$.xgafv", valid_580183
  var valid_580184 = query.getOrDefault("alt")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = newJString("json"))
  if valid_580184 != nil:
    section.add "alt", valid_580184
  var valid_580185 = query.getOrDefault("uploadType")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "uploadType", valid_580185
  var valid_580186 = query.getOrDefault("quotaUser")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "quotaUser", valid_580186
  var valid_580187 = query.getOrDefault("callback")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "callback", valid_580187
  var valid_580188 = query.getOrDefault("fields")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "fields", valid_580188
  var valid_580189 = query.getOrDefault("access_token")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "access_token", valid_580189
  var valid_580190 = query.getOrDefault("upload_protocol")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "upload_protocol", valid_580190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580191: Call_CloudsearchIndexingDatasourcesDeleteSchema_580175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the schema of a data source.
  ## 
  let valid = call_580191.validator(path, query, header, formData, body)
  let scheme = call_580191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580191.url(scheme.get, call_580191.host, call_580191.base,
                         call_580191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580191, url, valid)

proc call*(call_580192: Call_CloudsearchIndexingDatasourcesDeleteSchema_580175;
          name: string; key: string = ""; debugOptionsEnableDebugging: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudsearchIndexingDatasourcesDeleteSchema
  ## Deletes the schema of a data source.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   debugOptionsEnableDebugging: bool
  ##                              : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
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
  ##       : Name of the data source to delete Schema.  Format:
  ## datasources/{source_id}
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580193 = newJObject()
  var query_580194 = newJObject()
  add(query_580194, "key", newJString(key))
  add(query_580194, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_580194, "prettyPrint", newJBool(prettyPrint))
  add(query_580194, "oauth_token", newJString(oauthToken))
  add(query_580194, "$.xgafv", newJString(Xgafv))
  add(query_580194, "alt", newJString(alt))
  add(query_580194, "uploadType", newJString(uploadType))
  add(query_580194, "quotaUser", newJString(quotaUser))
  add(path_580193, "name", newJString(name))
  add(query_580194, "callback", newJString(callback))
  add(query_580194, "fields", newJString(fields))
  add(query_580194, "access_token", newJString(accessToken))
  add(query_580194, "upload_protocol", newJString(uploadProtocol))
  result = call_580192.call(path_580193, query_580194, nil, nil, nil)

var cloudsearchIndexingDatasourcesDeleteSchema* = Call_CloudsearchIndexingDatasourcesDeleteSchema_580175(
    name: "cloudsearchIndexingDatasourcesDeleteSchema",
    meth: HttpMethod.HttpDelete, host: "cloudsearch.googleapis.com",
    route: "/v1/indexing/{name}/schema",
    validator: validate_CloudsearchIndexingDatasourcesDeleteSchema_580176,
    base: "/", url: url_CloudsearchIndexingDatasourcesDeleteSchema_580177,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsIndex_580195 = ref object of OpenApiRestCall_579373
proc url_CloudsearchIndexingDatasourcesItemsIndex_580197(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/indexing/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":index")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudsearchIndexingDatasourcesItemsIndex_580196(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates Item ACL, metadata, and
  ## content. It will insert the Item if it
  ## does not exist.
  ## This method does not support partial updates.  Fields with no provided
  ## values are cleared out in the Cloud Search index.
  ## 
  ## This API requires an admin or service account to execute. The service
  ## account used is the one whitelisted in the corresponding data source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the Item. Format:
  ## datasources/{source_id}/items/{item_id}
  ## <br />This is a required field.
  ## The maximum length is 1536 characters.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580198 = path.getOrDefault("name")
  valid_580198 = validateParameter(valid_580198, JString, required = true,
                                 default = nil)
  if valid_580198 != nil:
    section.add "name", valid_580198
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
  var valid_580199 = query.getOrDefault("key")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "key", valid_580199
  var valid_580200 = query.getOrDefault("prettyPrint")
  valid_580200 = validateParameter(valid_580200, JBool, required = false,
                                 default = newJBool(true))
  if valid_580200 != nil:
    section.add "prettyPrint", valid_580200
  var valid_580201 = query.getOrDefault("oauth_token")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "oauth_token", valid_580201
  var valid_580202 = query.getOrDefault("$.xgafv")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = newJString("1"))
  if valid_580202 != nil:
    section.add "$.xgafv", valid_580202
  var valid_580203 = query.getOrDefault("alt")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = newJString("json"))
  if valid_580203 != nil:
    section.add "alt", valid_580203
  var valid_580204 = query.getOrDefault("uploadType")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "uploadType", valid_580204
  var valid_580205 = query.getOrDefault("quotaUser")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "quotaUser", valid_580205
  var valid_580206 = query.getOrDefault("callback")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "callback", valid_580206
  var valid_580207 = query.getOrDefault("fields")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "fields", valid_580207
  var valid_580208 = query.getOrDefault("access_token")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "access_token", valid_580208
  var valid_580209 = query.getOrDefault("upload_protocol")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "upload_protocol", valid_580209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580211: Call_CloudsearchIndexingDatasourcesItemsIndex_580195;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates Item ACL, metadata, and
  ## content. It will insert the Item if it
  ## does not exist.
  ## This method does not support partial updates.  Fields with no provided
  ## values are cleared out in the Cloud Search index.
  ## 
  ## This API requires an admin or service account to execute. The service
  ## account used is the one whitelisted in the corresponding data source.
  ## 
  let valid = call_580211.validator(path, query, header, formData, body)
  let scheme = call_580211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580211.url(scheme.get, call_580211.host, call_580211.base,
                         call_580211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580211, url, valid)

proc call*(call_580212: Call_CloudsearchIndexingDatasourcesItemsIndex_580195;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudsearchIndexingDatasourcesItemsIndex
  ## Updates Item ACL, metadata, and
  ## content. It will insert the Item if it
  ## does not exist.
  ## This method does not support partial updates.  Fields with no provided
  ## values are cleared out in the Cloud Search index.
  ## 
  ## This API requires an admin or service account to execute. The service
  ## account used is the one whitelisted in the corresponding data source.
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
  ##       : Name of the Item. Format:
  ## datasources/{source_id}/items/{item_id}
  ## <br />This is a required field.
  ## The maximum length is 1536 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580213 = newJObject()
  var query_580214 = newJObject()
  var body_580215 = newJObject()
  add(query_580214, "key", newJString(key))
  add(query_580214, "prettyPrint", newJBool(prettyPrint))
  add(query_580214, "oauth_token", newJString(oauthToken))
  add(query_580214, "$.xgafv", newJString(Xgafv))
  add(query_580214, "alt", newJString(alt))
  add(query_580214, "uploadType", newJString(uploadType))
  add(query_580214, "quotaUser", newJString(quotaUser))
  add(path_580213, "name", newJString(name))
  if body != nil:
    body_580215 = body
  add(query_580214, "callback", newJString(callback))
  add(query_580214, "fields", newJString(fields))
  add(query_580214, "access_token", newJString(accessToken))
  add(query_580214, "upload_protocol", newJString(uploadProtocol))
  result = call_580212.call(path_580213, query_580214, nil, nil, body_580215)

var cloudsearchIndexingDatasourcesItemsIndex* = Call_CloudsearchIndexingDatasourcesItemsIndex_580195(
    name: "cloudsearchIndexingDatasourcesItemsIndex", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}:index",
    validator: validate_CloudsearchIndexingDatasourcesItemsIndex_580196,
    base: "/", url: url_CloudsearchIndexingDatasourcesItemsIndex_580197,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsPush_580216 = ref object of OpenApiRestCall_579373
proc url_CloudsearchIndexingDatasourcesItemsPush_580218(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/indexing/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":push")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudsearchIndexingDatasourcesItemsPush_580217(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Pushes an item onto a queue for later polling and updating.
  ## 
  ## This API requires an admin or service account to execute. The service
  ## account used is the one whitelisted in the corresponding data source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the item to
  ## push into the indexing queue.<br />
  ## Format: datasources/{source_id}/items/{ID}
  ## <br />This is a required field.
  ## The maximum length is 1536 characters.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580219 = path.getOrDefault("name")
  valid_580219 = validateParameter(valid_580219, JString, required = true,
                                 default = nil)
  if valid_580219 != nil:
    section.add "name", valid_580219
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
  var valid_580220 = query.getOrDefault("key")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "key", valid_580220
  var valid_580221 = query.getOrDefault("prettyPrint")
  valid_580221 = validateParameter(valid_580221, JBool, required = false,
                                 default = newJBool(true))
  if valid_580221 != nil:
    section.add "prettyPrint", valid_580221
  var valid_580222 = query.getOrDefault("oauth_token")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "oauth_token", valid_580222
  var valid_580223 = query.getOrDefault("$.xgafv")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = newJString("1"))
  if valid_580223 != nil:
    section.add "$.xgafv", valid_580223
  var valid_580224 = query.getOrDefault("alt")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = newJString("json"))
  if valid_580224 != nil:
    section.add "alt", valid_580224
  var valid_580225 = query.getOrDefault("uploadType")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "uploadType", valid_580225
  var valid_580226 = query.getOrDefault("quotaUser")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "quotaUser", valid_580226
  var valid_580227 = query.getOrDefault("callback")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "callback", valid_580227
  var valid_580228 = query.getOrDefault("fields")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "fields", valid_580228
  var valid_580229 = query.getOrDefault("access_token")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "access_token", valid_580229
  var valid_580230 = query.getOrDefault("upload_protocol")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "upload_protocol", valid_580230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580232: Call_CloudsearchIndexingDatasourcesItemsPush_580216;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Pushes an item onto a queue for later polling and updating.
  ## 
  ## This API requires an admin or service account to execute. The service
  ## account used is the one whitelisted in the corresponding data source.
  ## 
  let valid = call_580232.validator(path, query, header, formData, body)
  let scheme = call_580232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580232.url(scheme.get, call_580232.host, call_580232.base,
                         call_580232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580232, url, valid)

proc call*(call_580233: Call_CloudsearchIndexingDatasourcesItemsPush_580216;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudsearchIndexingDatasourcesItemsPush
  ## Pushes an item onto a queue for later polling and updating.
  ## 
  ## This API requires an admin or service account to execute. The service
  ## account used is the one whitelisted in the corresponding data source.
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
  ##       : Name of the item to
  ## push into the indexing queue.<br />
  ## Format: datasources/{source_id}/items/{ID}
  ## <br />This is a required field.
  ## The maximum length is 1536 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580234 = newJObject()
  var query_580235 = newJObject()
  var body_580236 = newJObject()
  add(query_580235, "key", newJString(key))
  add(query_580235, "prettyPrint", newJBool(prettyPrint))
  add(query_580235, "oauth_token", newJString(oauthToken))
  add(query_580235, "$.xgafv", newJString(Xgafv))
  add(query_580235, "alt", newJString(alt))
  add(query_580235, "uploadType", newJString(uploadType))
  add(query_580235, "quotaUser", newJString(quotaUser))
  add(path_580234, "name", newJString(name))
  if body != nil:
    body_580236 = body
  add(query_580235, "callback", newJString(callback))
  add(query_580235, "fields", newJString(fields))
  add(query_580235, "access_token", newJString(accessToken))
  add(query_580235, "upload_protocol", newJString(uploadProtocol))
  result = call_580233.call(path_580234, query_580235, nil, nil, body_580236)

var cloudsearchIndexingDatasourcesItemsPush* = Call_CloudsearchIndexingDatasourcesItemsPush_580216(
    name: "cloudsearchIndexingDatasourcesItemsPush", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}:push",
    validator: validate_CloudsearchIndexingDatasourcesItemsPush_580217, base: "/",
    url: url_CloudsearchIndexingDatasourcesItemsPush_580218,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsUpload_580237 = ref object of OpenApiRestCall_579373
proc url_CloudsearchIndexingDatasourcesItemsUpload_580239(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/indexing/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":upload")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudsearchIndexingDatasourcesItemsUpload_580238(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an upload session for uploading item content. For items smaller
  ## than 100 KB, it's easier to embed the content
  ## inline within
  ## an index request.
  ## 
  ## This API requires an admin or service account to execute. The service
  ## account used is the one whitelisted in the corresponding data source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the Item to start a resumable upload.
  ## Format: datasources/{source_id}/items/{item_id}.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580240 = path.getOrDefault("name")
  valid_580240 = validateParameter(valid_580240, JString, required = true,
                                 default = nil)
  if valid_580240 != nil:
    section.add "name", valid_580240
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
  var valid_580241 = query.getOrDefault("key")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "key", valid_580241
  var valid_580242 = query.getOrDefault("prettyPrint")
  valid_580242 = validateParameter(valid_580242, JBool, required = false,
                                 default = newJBool(true))
  if valid_580242 != nil:
    section.add "prettyPrint", valid_580242
  var valid_580243 = query.getOrDefault("oauth_token")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "oauth_token", valid_580243
  var valid_580244 = query.getOrDefault("$.xgafv")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = newJString("1"))
  if valid_580244 != nil:
    section.add "$.xgafv", valid_580244
  var valid_580245 = query.getOrDefault("alt")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = newJString("json"))
  if valid_580245 != nil:
    section.add "alt", valid_580245
  var valid_580246 = query.getOrDefault("uploadType")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "uploadType", valid_580246
  var valid_580247 = query.getOrDefault("quotaUser")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "quotaUser", valid_580247
  var valid_580248 = query.getOrDefault("callback")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "callback", valid_580248
  var valid_580249 = query.getOrDefault("fields")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "fields", valid_580249
  var valid_580250 = query.getOrDefault("access_token")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "access_token", valid_580250
  var valid_580251 = query.getOrDefault("upload_protocol")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "upload_protocol", valid_580251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580253: Call_CloudsearchIndexingDatasourcesItemsUpload_580237;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an upload session for uploading item content. For items smaller
  ## than 100 KB, it's easier to embed the content
  ## inline within
  ## an index request.
  ## 
  ## This API requires an admin or service account to execute. The service
  ## account used is the one whitelisted in the corresponding data source.
  ## 
  let valid = call_580253.validator(path, query, header, formData, body)
  let scheme = call_580253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580253.url(scheme.get, call_580253.host, call_580253.base,
                         call_580253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580253, url, valid)

proc call*(call_580254: Call_CloudsearchIndexingDatasourcesItemsUpload_580237;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudsearchIndexingDatasourcesItemsUpload
  ## Creates an upload session for uploading item content. For items smaller
  ## than 100 KB, it's easier to embed the content
  ## inline within
  ## an index request.
  ## 
  ## This API requires an admin or service account to execute. The service
  ## account used is the one whitelisted in the corresponding data source.
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
  ##       : Name of the Item to start a resumable upload.
  ## Format: datasources/{source_id}/items/{item_id}.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580255 = newJObject()
  var query_580256 = newJObject()
  var body_580257 = newJObject()
  add(query_580256, "key", newJString(key))
  add(query_580256, "prettyPrint", newJBool(prettyPrint))
  add(query_580256, "oauth_token", newJString(oauthToken))
  add(query_580256, "$.xgafv", newJString(Xgafv))
  add(query_580256, "alt", newJString(alt))
  add(query_580256, "uploadType", newJString(uploadType))
  add(query_580256, "quotaUser", newJString(quotaUser))
  add(path_580255, "name", newJString(name))
  if body != nil:
    body_580257 = body
  add(query_580256, "callback", newJString(callback))
  add(query_580256, "fields", newJString(fields))
  add(query_580256, "access_token", newJString(accessToken))
  add(query_580256, "upload_protocol", newJString(uploadProtocol))
  result = call_580254.call(path_580255, query_580256, nil, nil, body_580257)

var cloudsearchIndexingDatasourcesItemsUpload* = Call_CloudsearchIndexingDatasourcesItemsUpload_580237(
    name: "cloudsearchIndexingDatasourcesItemsUpload", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}:upload",
    validator: validate_CloudsearchIndexingDatasourcesItemsUpload_580238,
    base: "/", url: url_CloudsearchIndexingDatasourcesItemsUpload_580239,
    schemes: {Scheme.Https})
type
  Call_CloudsearchMediaUpload_580258 = ref object of OpenApiRestCall_579373
proc url_CloudsearchMediaUpload_580260(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/media/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudsearchMediaUpload_580259(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads media for indexing.
  ## 
  ## The upload endpoint supports direct and resumable upload protocols and
  ## is intended for large items that can not be
  ## [inlined during index requests](https://developers.google.com/cloud-search/docs/reference/rest/v1/indexing.datasources.items#itemcontent).
  ## To index large content:
  ## 
  ## 1. Call
  ##    indexing.datasources.items.upload
  ##    with the resource name to begin an upload session and retrieve the
  ##    UploadItemRef.
  ## 1. Call media.upload to upload the content using the same resource name from step 1.
  ## 1. Call indexing.datasources.items.index
  ##    to index the item. Populate the
  ##    [ItemContent](/cloud-search/docs/reference/rest/v1/indexing.datasources.items#ItemContent)
  ##    with the UploadItemRef from step 1.
  ## 
  ## 
  ## For additional information, see
  ## [Create a content connector using the REST API](https://developers.google.com/cloud-search/docs/guides/content-connector#rest).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceName: JString (required)
  ##               : Name of the media that is being downloaded.  See
  ## ReadRequest.resource_name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceName` field"
  var valid_580261 = path.getOrDefault("resourceName")
  valid_580261 = validateParameter(valid_580261, JString, required = true,
                                 default = nil)
  if valid_580261 != nil:
    section.add "resourceName", valid_580261
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
  var valid_580262 = query.getOrDefault("key")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "key", valid_580262
  var valid_580263 = query.getOrDefault("prettyPrint")
  valid_580263 = validateParameter(valid_580263, JBool, required = false,
                                 default = newJBool(true))
  if valid_580263 != nil:
    section.add "prettyPrint", valid_580263
  var valid_580264 = query.getOrDefault("oauth_token")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "oauth_token", valid_580264
  var valid_580265 = query.getOrDefault("$.xgafv")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = newJString("1"))
  if valid_580265 != nil:
    section.add "$.xgafv", valid_580265
  var valid_580266 = query.getOrDefault("alt")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = newJString("json"))
  if valid_580266 != nil:
    section.add "alt", valid_580266
  var valid_580267 = query.getOrDefault("uploadType")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "uploadType", valid_580267
  var valid_580268 = query.getOrDefault("quotaUser")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "quotaUser", valid_580268
  var valid_580269 = query.getOrDefault("callback")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "callback", valid_580269
  var valid_580270 = query.getOrDefault("fields")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "fields", valid_580270
  var valid_580271 = query.getOrDefault("access_token")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "access_token", valid_580271
  var valid_580272 = query.getOrDefault("upload_protocol")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "upload_protocol", valid_580272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580274: Call_CloudsearchMediaUpload_580258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads media for indexing.
  ## 
  ## The upload endpoint supports direct and resumable upload protocols and
  ## is intended for large items that can not be
  ## [inlined during index requests](https://developers.google.com/cloud-search/docs/reference/rest/v1/indexing.datasources.items#itemcontent).
  ## To index large content:
  ## 
  ## 1. Call
  ##    indexing.datasources.items.upload
  ##    with the resource name to begin an upload session and retrieve the
  ##    UploadItemRef.
  ## 1. Call media.upload to upload the content using the same resource name from step 1.
  ## 1. Call indexing.datasources.items.index
  ##    to index the item. Populate the
  ##    [ItemContent](/cloud-search/docs/reference/rest/v1/indexing.datasources.items#ItemContent)
  ##    with the UploadItemRef from step 1.
  ## 
  ## 
  ## For additional information, see
  ## [Create a content connector using the REST API](https://developers.google.com/cloud-search/docs/guides/content-connector#rest).
  ## 
  let valid = call_580274.validator(path, query, header, formData, body)
  let scheme = call_580274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580274.url(scheme.get, call_580274.host, call_580274.base,
                         call_580274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580274, url, valid)

proc call*(call_580275: Call_CloudsearchMediaUpload_580258; resourceName: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudsearchMediaUpload
  ## Uploads media for indexing.
  ## 
  ## The upload endpoint supports direct and resumable upload protocols and
  ## is intended for large items that can not be
  ## [inlined during index requests](https://developers.google.com/cloud-search/docs/reference/rest/v1/indexing.datasources.items#itemcontent).
  ## To index large content:
  ## 
  ## 1. Call
  ##    indexing.datasources.items.upload
  ##    with the resource name to begin an upload session and retrieve the
  ##    UploadItemRef.
  ## 1. Call media.upload to upload the content using the same resource name from step 1.
  ## 1. Call indexing.datasources.items.index
  ##    to index the item. Populate the
  ##    [ItemContent](/cloud-search/docs/reference/rest/v1/indexing.datasources.items#ItemContent)
  ##    with the UploadItemRef from step 1.
  ## 
  ## 
  ## For additional information, see
  ## [Create a content connector using the REST API](https://developers.google.com/cloud-search/docs/guides/content-connector#rest).
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
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   resourceName: string (required)
  ##               : Name of the media that is being downloaded.  See
  ## ReadRequest.resource_name.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580276 = newJObject()
  var query_580277 = newJObject()
  var body_580278 = newJObject()
  add(query_580277, "key", newJString(key))
  add(query_580277, "prettyPrint", newJBool(prettyPrint))
  add(query_580277, "oauth_token", newJString(oauthToken))
  add(query_580277, "$.xgafv", newJString(Xgafv))
  add(query_580277, "alt", newJString(alt))
  add(query_580277, "uploadType", newJString(uploadType))
  add(query_580277, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580278 = body
  add(query_580277, "callback", newJString(callback))
  add(path_580276, "resourceName", newJString(resourceName))
  add(query_580277, "fields", newJString(fields))
  add(query_580277, "access_token", newJString(accessToken))
  add(query_580277, "upload_protocol", newJString(uploadProtocol))
  result = call_580275.call(path_580276, query_580277, nil, nil, body_580278)

var cloudsearchMediaUpload* = Call_CloudsearchMediaUpload_580258(
    name: "cloudsearchMediaUpload", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/media/{resourceName}",
    validator: validate_CloudsearchMediaUpload_580259, base: "/",
    url: url_CloudsearchMediaUpload_580260, schemes: {Scheme.Https})
type
  Call_CloudsearchQuerySearch_580279 = ref object of OpenApiRestCall_579373
proc url_CloudsearchQuerySearch_580281(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CloudsearchQuerySearch_580280(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Cloud Search Query API provides the search method, which returns
  ## the most relevant results from a user query.  The results can come from
  ## G Suite Apps, such as Gmail or Google Drive, or they can come from data
  ## that you have indexed from a third party.
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
  var valid_580282 = query.getOrDefault("key")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "key", valid_580282
  var valid_580283 = query.getOrDefault("prettyPrint")
  valid_580283 = validateParameter(valid_580283, JBool, required = false,
                                 default = newJBool(true))
  if valid_580283 != nil:
    section.add "prettyPrint", valid_580283
  var valid_580284 = query.getOrDefault("oauth_token")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "oauth_token", valid_580284
  var valid_580285 = query.getOrDefault("$.xgafv")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = newJString("1"))
  if valid_580285 != nil:
    section.add "$.xgafv", valid_580285
  var valid_580286 = query.getOrDefault("alt")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = newJString("json"))
  if valid_580286 != nil:
    section.add "alt", valid_580286
  var valid_580287 = query.getOrDefault("uploadType")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "uploadType", valid_580287
  var valid_580288 = query.getOrDefault("quotaUser")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "quotaUser", valid_580288
  var valid_580289 = query.getOrDefault("callback")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "callback", valid_580289
  var valid_580290 = query.getOrDefault("fields")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "fields", valid_580290
  var valid_580291 = query.getOrDefault("access_token")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "access_token", valid_580291
  var valid_580292 = query.getOrDefault("upload_protocol")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = nil)
  if valid_580292 != nil:
    section.add "upload_protocol", valid_580292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580294: Call_CloudsearchQuerySearch_580279; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Cloud Search Query API provides the search method, which returns
  ## the most relevant results from a user query.  The results can come from
  ## G Suite Apps, such as Gmail or Google Drive, or they can come from data
  ## that you have indexed from a third party.
  ## 
  let valid = call_580294.validator(path, query, header, formData, body)
  let scheme = call_580294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580294.url(scheme.get, call_580294.host, call_580294.base,
                         call_580294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580294, url, valid)

proc call*(call_580295: Call_CloudsearchQuerySearch_580279; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudsearchQuerySearch
  ## The Cloud Search Query API provides the search method, which returns
  ## the most relevant results from a user query.  The results can come from
  ## G Suite Apps, such as Gmail or Google Drive, or they can come from data
  ## that you have indexed from a third party.
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
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_580296 = newJObject()
  var body_580297 = newJObject()
  add(query_580296, "key", newJString(key))
  add(query_580296, "prettyPrint", newJBool(prettyPrint))
  add(query_580296, "oauth_token", newJString(oauthToken))
  add(query_580296, "$.xgafv", newJString(Xgafv))
  add(query_580296, "alt", newJString(alt))
  add(query_580296, "uploadType", newJString(uploadType))
  add(query_580296, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580297 = body
  add(query_580296, "callback", newJString(callback))
  add(query_580296, "fields", newJString(fields))
  add(query_580296, "access_token", newJString(accessToken))
  add(query_580296, "upload_protocol", newJString(uploadProtocol))
  result = call_580295.call(nil, query_580296, nil, nil, body_580297)

var cloudsearchQuerySearch* = Call_CloudsearchQuerySearch_580279(
    name: "cloudsearchQuerySearch", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/query/search",
    validator: validate_CloudsearchQuerySearch_580280, base: "/",
    url: url_CloudsearchQuerySearch_580281, schemes: {Scheme.Https})
type
  Call_CloudsearchQuerySourcesList_580298 = ref object of OpenApiRestCall_579373
proc url_CloudsearchQuerySourcesList_580300(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CloudsearchQuerySourcesList_580299(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns list of sources that user can use for Search and Suggest APIs.
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
  ##   requestOptions.languageCode: JString
  ##                              : The BCP-47 language code, such as "en-US" or "sr-Latn".
  ## For more information, see
  ## http://www.unicode.org/reports/tr35/#Unicode_locale_identifier.
  ## For translations.
  ## 
  ## Set this field using the language set in browser or for the page. In the
  ## event that the user's language preference is known, set this field to the
  ## known user language.
  ## 
  ## When specified, the documents in search results are biased towards the
  ## specified language.
  ## 
  ## The suggest API does not use this parameter. Instead, suggest autocompletes
  ## only based on characters in the query.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Number of sources to return in the response.
  ##   requestOptions.debugOptions.enableDebugging: JBool
  ##                                              : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   callback: JString
  ##           : JSONP
  ##   requestOptions.searchApplicationId: JString
  ##                                     : Id of the application created using SearchApplicationsService.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   requestOptions.timeZone: JString
  ##                          : Current user's time zone id, such as "America/Los_Angeles" or
  ## "Australia/Sydney". These IDs are defined by
  ## [Unicode Common Locale Data Repository (CLDR)](http://cldr.unicode.org/)
  ## project, and currently available in the file
  ## [timezone.xml](http://unicode.org/repos/cldr/trunk/common/bcp47/timezone.xml).
  ## This field is used to correctly interpret date and time queries.
  ## If this field is not specified, the default time zone (UTC) is used.
  section = newJObject()
  var valid_580301 = query.getOrDefault("key")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "key", valid_580301
  var valid_580302 = query.getOrDefault("prettyPrint")
  valid_580302 = validateParameter(valid_580302, JBool, required = false,
                                 default = newJBool(true))
  if valid_580302 != nil:
    section.add "prettyPrint", valid_580302
  var valid_580303 = query.getOrDefault("oauth_token")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "oauth_token", valid_580303
  var valid_580304 = query.getOrDefault("requestOptions.languageCode")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "requestOptions.languageCode", valid_580304
  var valid_580305 = query.getOrDefault("$.xgafv")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = newJString("1"))
  if valid_580305 != nil:
    section.add "$.xgafv", valid_580305
  var valid_580306 = query.getOrDefault("alt")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = newJString("json"))
  if valid_580306 != nil:
    section.add "alt", valid_580306
  var valid_580307 = query.getOrDefault("uploadType")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "uploadType", valid_580307
  var valid_580308 = query.getOrDefault("quotaUser")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "quotaUser", valid_580308
  var valid_580309 = query.getOrDefault("pageToken")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "pageToken", valid_580309
  var valid_580310 = query.getOrDefault("requestOptions.debugOptions.enableDebugging")
  valid_580310 = validateParameter(valid_580310, JBool, required = false, default = nil)
  if valid_580310 != nil:
    section.add "requestOptions.debugOptions.enableDebugging", valid_580310
  var valid_580311 = query.getOrDefault("callback")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "callback", valid_580311
  var valid_580312 = query.getOrDefault("requestOptions.searchApplicationId")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = nil)
  if valid_580312 != nil:
    section.add "requestOptions.searchApplicationId", valid_580312
  var valid_580313 = query.getOrDefault("fields")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "fields", valid_580313
  var valid_580314 = query.getOrDefault("access_token")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = nil)
  if valid_580314 != nil:
    section.add "access_token", valid_580314
  var valid_580315 = query.getOrDefault("upload_protocol")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "upload_protocol", valid_580315
  var valid_580316 = query.getOrDefault("requestOptions.timeZone")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "requestOptions.timeZone", valid_580316
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580317: Call_CloudsearchQuerySourcesList_580298; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns list of sources that user can use for Search and Suggest APIs.
  ## 
  let valid = call_580317.validator(path, query, header, formData, body)
  let scheme = call_580317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580317.url(scheme.get, call_580317.host, call_580317.base,
                         call_580317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580317, url, valid)

proc call*(call_580318: Call_CloudsearchQuerySourcesList_580298; key: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          requestOptionsLanguageCode: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = "";
          requestOptionsDebugOptionsEnableDebugging: bool = false;
          callback: string = ""; requestOptionsSearchApplicationId: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          requestOptionsTimeZone: string = ""): Recallable =
  ## cloudsearchQuerySourcesList
  ## Returns list of sources that user can use for Search and Suggest APIs.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   requestOptionsLanguageCode: string
  ##                             : The BCP-47 language code, such as "en-US" or "sr-Latn".
  ## For more information, see
  ## http://www.unicode.org/reports/tr35/#Unicode_locale_identifier.
  ## For translations.
  ## 
  ## Set this field using the language set in browser or for the page. In the
  ## event that the user's language preference is known, set this field to the
  ## known user language.
  ## 
  ## When specified, the documents in search results are biased towards the
  ## specified language.
  ## 
  ## The suggest API does not use this parameter. Instead, suggest autocompletes
  ## only based on characters in the query.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Number of sources to return in the response.
  ##   requestOptionsDebugOptionsEnableDebugging: bool
  ##                                            : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   callback: string
  ##           : JSONP
  ##   requestOptionsSearchApplicationId: string
  ##                                    : Id of the application created using SearchApplicationsService.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   requestOptionsTimeZone: string
  ##                         : Current user's time zone id, such as "America/Los_Angeles" or
  ## "Australia/Sydney". These IDs are defined by
  ## [Unicode Common Locale Data Repository (CLDR)](http://cldr.unicode.org/)
  ## project, and currently available in the file
  ## [timezone.xml](http://unicode.org/repos/cldr/trunk/common/bcp47/timezone.xml).
  ## This field is used to correctly interpret date and time queries.
  ## If this field is not specified, the default time zone (UTC) is used.
  var query_580319 = newJObject()
  add(query_580319, "key", newJString(key))
  add(query_580319, "prettyPrint", newJBool(prettyPrint))
  add(query_580319, "oauth_token", newJString(oauthToken))
  add(query_580319, "requestOptions.languageCode",
      newJString(requestOptionsLanguageCode))
  add(query_580319, "$.xgafv", newJString(Xgafv))
  add(query_580319, "alt", newJString(alt))
  add(query_580319, "uploadType", newJString(uploadType))
  add(query_580319, "quotaUser", newJString(quotaUser))
  add(query_580319, "pageToken", newJString(pageToken))
  add(query_580319, "requestOptions.debugOptions.enableDebugging",
      newJBool(requestOptionsDebugOptionsEnableDebugging))
  add(query_580319, "callback", newJString(callback))
  add(query_580319, "requestOptions.searchApplicationId",
      newJString(requestOptionsSearchApplicationId))
  add(query_580319, "fields", newJString(fields))
  add(query_580319, "access_token", newJString(accessToken))
  add(query_580319, "upload_protocol", newJString(uploadProtocol))
  add(query_580319, "requestOptions.timeZone", newJString(requestOptionsTimeZone))
  result = call_580318.call(nil, query_580319, nil, nil, nil)

var cloudsearchQuerySourcesList* = Call_CloudsearchQuerySourcesList_580298(
    name: "cloudsearchQuerySourcesList", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/query/sources",
    validator: validate_CloudsearchQuerySourcesList_580299, base: "/",
    url: url_CloudsearchQuerySourcesList_580300, schemes: {Scheme.Https})
type
  Call_CloudsearchQuerySuggest_580320 = ref object of OpenApiRestCall_579373
proc url_CloudsearchQuerySuggest_580322(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CloudsearchQuerySuggest_580321(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides suggestions for autocompleting the query.
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
  var valid_580323 = query.getOrDefault("key")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "key", valid_580323
  var valid_580324 = query.getOrDefault("prettyPrint")
  valid_580324 = validateParameter(valid_580324, JBool, required = false,
                                 default = newJBool(true))
  if valid_580324 != nil:
    section.add "prettyPrint", valid_580324
  var valid_580325 = query.getOrDefault("oauth_token")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = nil)
  if valid_580325 != nil:
    section.add "oauth_token", valid_580325
  var valid_580326 = query.getOrDefault("$.xgafv")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = newJString("1"))
  if valid_580326 != nil:
    section.add "$.xgafv", valid_580326
  var valid_580327 = query.getOrDefault("alt")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = newJString("json"))
  if valid_580327 != nil:
    section.add "alt", valid_580327
  var valid_580328 = query.getOrDefault("uploadType")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "uploadType", valid_580328
  var valid_580329 = query.getOrDefault("quotaUser")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "quotaUser", valid_580329
  var valid_580330 = query.getOrDefault("callback")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = nil)
  if valid_580330 != nil:
    section.add "callback", valid_580330
  var valid_580331 = query.getOrDefault("fields")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "fields", valid_580331
  var valid_580332 = query.getOrDefault("access_token")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = nil)
  if valid_580332 != nil:
    section.add "access_token", valid_580332
  var valid_580333 = query.getOrDefault("upload_protocol")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "upload_protocol", valid_580333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580335: Call_CloudsearchQuerySuggest_580320; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides suggestions for autocompleting the query.
  ## 
  let valid = call_580335.validator(path, query, header, formData, body)
  let scheme = call_580335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580335.url(scheme.get, call_580335.host, call_580335.base,
                         call_580335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580335, url, valid)

proc call*(call_580336: Call_CloudsearchQuerySuggest_580320; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudsearchQuerySuggest
  ## Provides suggestions for autocompleting the query.
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
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_580337 = newJObject()
  var body_580338 = newJObject()
  add(query_580337, "key", newJString(key))
  add(query_580337, "prettyPrint", newJBool(prettyPrint))
  add(query_580337, "oauth_token", newJString(oauthToken))
  add(query_580337, "$.xgafv", newJString(Xgafv))
  add(query_580337, "alt", newJString(alt))
  add(query_580337, "uploadType", newJString(uploadType))
  add(query_580337, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580338 = body
  add(query_580337, "callback", newJString(callback))
  add(query_580337, "fields", newJString(fields))
  add(query_580337, "access_token", newJString(accessToken))
  add(query_580337, "upload_protocol", newJString(uploadProtocol))
  result = call_580336.call(nil, query_580337, nil, nil, body_580338)

var cloudsearchQuerySuggest* = Call_CloudsearchQuerySuggest_580320(
    name: "cloudsearchQuerySuggest", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/query/suggest",
    validator: validate_CloudsearchQuerySuggest_580321, base: "/",
    url: url_CloudsearchQuerySuggest_580322, schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsDatasourcesCreate_580359 = ref object of OpenApiRestCall_579373
proc url_CloudsearchSettingsDatasourcesCreate_580361(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CloudsearchSettingsDatasourcesCreate_580360(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a datasource.
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
  var valid_580362 = query.getOrDefault("key")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "key", valid_580362
  var valid_580363 = query.getOrDefault("prettyPrint")
  valid_580363 = validateParameter(valid_580363, JBool, required = false,
                                 default = newJBool(true))
  if valid_580363 != nil:
    section.add "prettyPrint", valid_580363
  var valid_580364 = query.getOrDefault("oauth_token")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "oauth_token", valid_580364
  var valid_580365 = query.getOrDefault("$.xgafv")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = newJString("1"))
  if valid_580365 != nil:
    section.add "$.xgafv", valid_580365
  var valid_580366 = query.getOrDefault("alt")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = newJString("json"))
  if valid_580366 != nil:
    section.add "alt", valid_580366
  var valid_580367 = query.getOrDefault("uploadType")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "uploadType", valid_580367
  var valid_580368 = query.getOrDefault("quotaUser")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "quotaUser", valid_580368
  var valid_580369 = query.getOrDefault("callback")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = nil)
  if valid_580369 != nil:
    section.add "callback", valid_580369
  var valid_580370 = query.getOrDefault("fields")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "fields", valid_580370
  var valid_580371 = query.getOrDefault("access_token")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "access_token", valid_580371
  var valid_580372 = query.getOrDefault("upload_protocol")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = nil)
  if valid_580372 != nil:
    section.add "upload_protocol", valid_580372
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580374: Call_CloudsearchSettingsDatasourcesCreate_580359;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a datasource.
  ## 
  let valid = call_580374.validator(path, query, header, formData, body)
  let scheme = call_580374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580374.url(scheme.get, call_580374.host, call_580374.base,
                         call_580374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580374, url, valid)

proc call*(call_580375: Call_CloudsearchSettingsDatasourcesCreate_580359;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudsearchSettingsDatasourcesCreate
  ## Creates a datasource.
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
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_580376 = newJObject()
  var body_580377 = newJObject()
  add(query_580376, "key", newJString(key))
  add(query_580376, "prettyPrint", newJBool(prettyPrint))
  add(query_580376, "oauth_token", newJString(oauthToken))
  add(query_580376, "$.xgafv", newJString(Xgafv))
  add(query_580376, "alt", newJString(alt))
  add(query_580376, "uploadType", newJString(uploadType))
  add(query_580376, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580377 = body
  add(query_580376, "callback", newJString(callback))
  add(query_580376, "fields", newJString(fields))
  add(query_580376, "access_token", newJString(accessToken))
  add(query_580376, "upload_protocol", newJString(uploadProtocol))
  result = call_580375.call(nil, query_580376, nil, nil, body_580377)

var cloudsearchSettingsDatasourcesCreate* = Call_CloudsearchSettingsDatasourcesCreate_580359(
    name: "cloudsearchSettingsDatasourcesCreate", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/datasources",
    validator: validate_CloudsearchSettingsDatasourcesCreate_580360, base: "/",
    url: url_CloudsearchSettingsDatasourcesCreate_580361, schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsDatasourcesList_580339 = ref object of OpenApiRestCall_579373
proc url_CloudsearchSettingsDatasourcesList_580341(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CloudsearchSettingsDatasourcesList_580340(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists datasources.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   debugOptions.enableDebugging: JBool
  ##                               : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum number of datasources to fetch in a request.
  ## The max value is 100.
  ## <br />The default value is 10
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Starting index of the results.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580342 = query.getOrDefault("key")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = nil)
  if valid_580342 != nil:
    section.add "key", valid_580342
  var valid_580343 = query.getOrDefault("debugOptions.enableDebugging")
  valid_580343 = validateParameter(valid_580343, JBool, required = false, default = nil)
  if valid_580343 != nil:
    section.add "debugOptions.enableDebugging", valid_580343
  var valid_580344 = query.getOrDefault("prettyPrint")
  valid_580344 = validateParameter(valid_580344, JBool, required = false,
                                 default = newJBool(true))
  if valid_580344 != nil:
    section.add "prettyPrint", valid_580344
  var valid_580345 = query.getOrDefault("oauth_token")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = nil)
  if valid_580345 != nil:
    section.add "oauth_token", valid_580345
  var valid_580346 = query.getOrDefault("$.xgafv")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = newJString("1"))
  if valid_580346 != nil:
    section.add "$.xgafv", valid_580346
  var valid_580347 = query.getOrDefault("pageSize")
  valid_580347 = validateParameter(valid_580347, JInt, required = false, default = nil)
  if valid_580347 != nil:
    section.add "pageSize", valid_580347
  var valid_580348 = query.getOrDefault("alt")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = newJString("json"))
  if valid_580348 != nil:
    section.add "alt", valid_580348
  var valid_580349 = query.getOrDefault("uploadType")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "uploadType", valid_580349
  var valid_580350 = query.getOrDefault("quotaUser")
  valid_580350 = validateParameter(valid_580350, JString, required = false,
                                 default = nil)
  if valid_580350 != nil:
    section.add "quotaUser", valid_580350
  var valid_580351 = query.getOrDefault("pageToken")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "pageToken", valid_580351
  var valid_580352 = query.getOrDefault("callback")
  valid_580352 = validateParameter(valid_580352, JString, required = false,
                                 default = nil)
  if valid_580352 != nil:
    section.add "callback", valid_580352
  var valid_580353 = query.getOrDefault("fields")
  valid_580353 = validateParameter(valid_580353, JString, required = false,
                                 default = nil)
  if valid_580353 != nil:
    section.add "fields", valid_580353
  var valid_580354 = query.getOrDefault("access_token")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = nil)
  if valid_580354 != nil:
    section.add "access_token", valid_580354
  var valid_580355 = query.getOrDefault("upload_protocol")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "upload_protocol", valid_580355
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580356: Call_CloudsearchSettingsDatasourcesList_580339;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists datasources.
  ## 
  let valid = call_580356.validator(path, query, header, formData, body)
  let scheme = call_580356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580356.url(scheme.get, call_580356.host, call_580356.base,
                         call_580356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580356, url, valid)

proc call*(call_580357: Call_CloudsearchSettingsDatasourcesList_580339;
          key: string = ""; debugOptionsEnableDebugging: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudsearchSettingsDatasourcesList
  ## Lists datasources.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   debugOptionsEnableDebugging: bool
  ##                              : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of datasources to fetch in a request.
  ## The max value is 100.
  ## <br />The default value is 10
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Starting index of the results.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_580358 = newJObject()
  add(query_580358, "key", newJString(key))
  add(query_580358, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_580358, "prettyPrint", newJBool(prettyPrint))
  add(query_580358, "oauth_token", newJString(oauthToken))
  add(query_580358, "$.xgafv", newJString(Xgafv))
  add(query_580358, "pageSize", newJInt(pageSize))
  add(query_580358, "alt", newJString(alt))
  add(query_580358, "uploadType", newJString(uploadType))
  add(query_580358, "quotaUser", newJString(quotaUser))
  add(query_580358, "pageToken", newJString(pageToken))
  add(query_580358, "callback", newJString(callback))
  add(query_580358, "fields", newJString(fields))
  add(query_580358, "access_token", newJString(accessToken))
  add(query_580358, "upload_protocol", newJString(uploadProtocol))
  result = call_580357.call(nil, query_580358, nil, nil, nil)

var cloudsearchSettingsDatasourcesList* = Call_CloudsearchSettingsDatasourcesList_580339(
    name: "cloudsearchSettingsDatasourcesList", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/datasources",
    validator: validate_CloudsearchSettingsDatasourcesList_580340, base: "/",
    url: url_CloudsearchSettingsDatasourcesList_580341, schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsSearchapplicationsCreate_580398 = ref object of OpenApiRestCall_579373
proc url_CloudsearchSettingsSearchapplicationsCreate_580400(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CloudsearchSettingsSearchapplicationsCreate_580399(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a search application.
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
  var valid_580401 = query.getOrDefault("key")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "key", valid_580401
  var valid_580402 = query.getOrDefault("prettyPrint")
  valid_580402 = validateParameter(valid_580402, JBool, required = false,
                                 default = newJBool(true))
  if valid_580402 != nil:
    section.add "prettyPrint", valid_580402
  var valid_580403 = query.getOrDefault("oauth_token")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = nil)
  if valid_580403 != nil:
    section.add "oauth_token", valid_580403
  var valid_580404 = query.getOrDefault("$.xgafv")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = newJString("1"))
  if valid_580404 != nil:
    section.add "$.xgafv", valid_580404
  var valid_580405 = query.getOrDefault("alt")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = newJString("json"))
  if valid_580405 != nil:
    section.add "alt", valid_580405
  var valid_580406 = query.getOrDefault("uploadType")
  valid_580406 = validateParameter(valid_580406, JString, required = false,
                                 default = nil)
  if valid_580406 != nil:
    section.add "uploadType", valid_580406
  var valid_580407 = query.getOrDefault("quotaUser")
  valid_580407 = validateParameter(valid_580407, JString, required = false,
                                 default = nil)
  if valid_580407 != nil:
    section.add "quotaUser", valid_580407
  var valid_580408 = query.getOrDefault("callback")
  valid_580408 = validateParameter(valid_580408, JString, required = false,
                                 default = nil)
  if valid_580408 != nil:
    section.add "callback", valid_580408
  var valid_580409 = query.getOrDefault("fields")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = nil)
  if valid_580409 != nil:
    section.add "fields", valid_580409
  var valid_580410 = query.getOrDefault("access_token")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = nil)
  if valid_580410 != nil:
    section.add "access_token", valid_580410
  var valid_580411 = query.getOrDefault("upload_protocol")
  valid_580411 = validateParameter(valid_580411, JString, required = false,
                                 default = nil)
  if valid_580411 != nil:
    section.add "upload_protocol", valid_580411
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580413: Call_CloudsearchSettingsSearchapplicationsCreate_580398;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a search application.
  ## 
  let valid = call_580413.validator(path, query, header, formData, body)
  let scheme = call_580413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580413.url(scheme.get, call_580413.host, call_580413.base,
                         call_580413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580413, url, valid)

proc call*(call_580414: Call_CloudsearchSettingsSearchapplicationsCreate_580398;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudsearchSettingsSearchapplicationsCreate
  ## Creates a search application.
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
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_580415 = newJObject()
  var body_580416 = newJObject()
  add(query_580415, "key", newJString(key))
  add(query_580415, "prettyPrint", newJBool(prettyPrint))
  add(query_580415, "oauth_token", newJString(oauthToken))
  add(query_580415, "$.xgafv", newJString(Xgafv))
  add(query_580415, "alt", newJString(alt))
  add(query_580415, "uploadType", newJString(uploadType))
  add(query_580415, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580416 = body
  add(query_580415, "callback", newJString(callback))
  add(query_580415, "fields", newJString(fields))
  add(query_580415, "access_token", newJString(accessToken))
  add(query_580415, "upload_protocol", newJString(uploadProtocol))
  result = call_580414.call(nil, query_580415, nil, nil, body_580416)

var cloudsearchSettingsSearchapplicationsCreate* = Call_CloudsearchSettingsSearchapplicationsCreate_580398(
    name: "cloudsearchSettingsSearchapplicationsCreate",
    meth: HttpMethod.HttpPost, host: "cloudsearch.googleapis.com",
    route: "/v1/settings/searchapplications",
    validator: validate_CloudsearchSettingsSearchapplicationsCreate_580399,
    base: "/", url: url_CloudsearchSettingsSearchapplicationsCreate_580400,
    schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsSearchapplicationsList_580378 = ref object of OpenApiRestCall_579373
proc url_CloudsearchSettingsSearchapplicationsList_580380(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CloudsearchSettingsSearchapplicationsList_580379(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all search applications.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   debugOptions.enableDebugging: JBool
  ##                               : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of items to return.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous List request, if any.
  ## <br/> The default value is 10
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580381 = query.getOrDefault("key")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "key", valid_580381
  var valid_580382 = query.getOrDefault("debugOptions.enableDebugging")
  valid_580382 = validateParameter(valid_580382, JBool, required = false, default = nil)
  if valid_580382 != nil:
    section.add "debugOptions.enableDebugging", valid_580382
  var valid_580383 = query.getOrDefault("prettyPrint")
  valid_580383 = validateParameter(valid_580383, JBool, required = false,
                                 default = newJBool(true))
  if valid_580383 != nil:
    section.add "prettyPrint", valid_580383
  var valid_580384 = query.getOrDefault("oauth_token")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = nil)
  if valid_580384 != nil:
    section.add "oauth_token", valid_580384
  var valid_580385 = query.getOrDefault("$.xgafv")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = newJString("1"))
  if valid_580385 != nil:
    section.add "$.xgafv", valid_580385
  var valid_580386 = query.getOrDefault("pageSize")
  valid_580386 = validateParameter(valid_580386, JInt, required = false, default = nil)
  if valid_580386 != nil:
    section.add "pageSize", valid_580386
  var valid_580387 = query.getOrDefault("alt")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = newJString("json"))
  if valid_580387 != nil:
    section.add "alt", valid_580387
  var valid_580388 = query.getOrDefault("uploadType")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = nil)
  if valid_580388 != nil:
    section.add "uploadType", valid_580388
  var valid_580389 = query.getOrDefault("quotaUser")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "quotaUser", valid_580389
  var valid_580390 = query.getOrDefault("pageToken")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = nil)
  if valid_580390 != nil:
    section.add "pageToken", valid_580390
  var valid_580391 = query.getOrDefault("callback")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = nil)
  if valid_580391 != nil:
    section.add "callback", valid_580391
  var valid_580392 = query.getOrDefault("fields")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = nil)
  if valid_580392 != nil:
    section.add "fields", valid_580392
  var valid_580393 = query.getOrDefault("access_token")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = nil)
  if valid_580393 != nil:
    section.add "access_token", valid_580393
  var valid_580394 = query.getOrDefault("upload_protocol")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = nil)
  if valid_580394 != nil:
    section.add "upload_protocol", valid_580394
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580395: Call_CloudsearchSettingsSearchapplicationsList_580378;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all search applications.
  ## 
  let valid = call_580395.validator(path, query, header, formData, body)
  let scheme = call_580395.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580395.url(scheme.get, call_580395.host, call_580395.base,
                         call_580395.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580395, url, valid)

proc call*(call_580396: Call_CloudsearchSettingsSearchapplicationsList_580378;
          key: string = ""; debugOptionsEnableDebugging: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudsearchSettingsSearchapplicationsList
  ## Lists all search applications.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   debugOptionsEnableDebugging: bool
  ##                              : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous List request, if any.
  ## <br/> The default value is 10
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_580397 = newJObject()
  add(query_580397, "key", newJString(key))
  add(query_580397, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_580397, "prettyPrint", newJBool(prettyPrint))
  add(query_580397, "oauth_token", newJString(oauthToken))
  add(query_580397, "$.xgafv", newJString(Xgafv))
  add(query_580397, "pageSize", newJInt(pageSize))
  add(query_580397, "alt", newJString(alt))
  add(query_580397, "uploadType", newJString(uploadType))
  add(query_580397, "quotaUser", newJString(quotaUser))
  add(query_580397, "pageToken", newJString(pageToken))
  add(query_580397, "callback", newJString(callback))
  add(query_580397, "fields", newJString(fields))
  add(query_580397, "access_token", newJString(accessToken))
  add(query_580397, "upload_protocol", newJString(uploadProtocol))
  result = call_580396.call(nil, query_580397, nil, nil, nil)

var cloudsearchSettingsSearchapplicationsList* = Call_CloudsearchSettingsSearchapplicationsList_580378(
    name: "cloudsearchSettingsSearchapplicationsList", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/searchapplications",
    validator: validate_CloudsearchSettingsSearchapplicationsList_580379,
    base: "/", url: url_CloudsearchSettingsSearchapplicationsList_580380,
    schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsSearchapplicationsUpdate_580437 = ref object of OpenApiRestCall_579373
proc url_CloudsearchSettingsSearchapplicationsUpdate_580439(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/settings/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudsearchSettingsSearchapplicationsUpdate_580438(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a search application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the Search Application.
  ## <br />Format: searchapplications/{application_id}.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580440 = path.getOrDefault("name")
  valid_580440 = validateParameter(valid_580440, JString, required = true,
                                 default = nil)
  if valid_580440 != nil:
    section.add "name", valid_580440
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
  var valid_580441 = query.getOrDefault("key")
  valid_580441 = validateParameter(valid_580441, JString, required = false,
                                 default = nil)
  if valid_580441 != nil:
    section.add "key", valid_580441
  var valid_580442 = query.getOrDefault("prettyPrint")
  valid_580442 = validateParameter(valid_580442, JBool, required = false,
                                 default = newJBool(true))
  if valid_580442 != nil:
    section.add "prettyPrint", valid_580442
  var valid_580443 = query.getOrDefault("oauth_token")
  valid_580443 = validateParameter(valid_580443, JString, required = false,
                                 default = nil)
  if valid_580443 != nil:
    section.add "oauth_token", valid_580443
  var valid_580444 = query.getOrDefault("$.xgafv")
  valid_580444 = validateParameter(valid_580444, JString, required = false,
                                 default = newJString("1"))
  if valid_580444 != nil:
    section.add "$.xgafv", valid_580444
  var valid_580445 = query.getOrDefault("alt")
  valid_580445 = validateParameter(valid_580445, JString, required = false,
                                 default = newJString("json"))
  if valid_580445 != nil:
    section.add "alt", valid_580445
  var valid_580446 = query.getOrDefault("uploadType")
  valid_580446 = validateParameter(valid_580446, JString, required = false,
                                 default = nil)
  if valid_580446 != nil:
    section.add "uploadType", valid_580446
  var valid_580447 = query.getOrDefault("quotaUser")
  valid_580447 = validateParameter(valid_580447, JString, required = false,
                                 default = nil)
  if valid_580447 != nil:
    section.add "quotaUser", valid_580447
  var valid_580448 = query.getOrDefault("callback")
  valid_580448 = validateParameter(valid_580448, JString, required = false,
                                 default = nil)
  if valid_580448 != nil:
    section.add "callback", valid_580448
  var valid_580449 = query.getOrDefault("fields")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = nil)
  if valid_580449 != nil:
    section.add "fields", valid_580449
  var valid_580450 = query.getOrDefault("access_token")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = nil)
  if valid_580450 != nil:
    section.add "access_token", valid_580450
  var valid_580451 = query.getOrDefault("upload_protocol")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = nil)
  if valid_580451 != nil:
    section.add "upload_protocol", valid_580451
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580453: Call_CloudsearchSettingsSearchapplicationsUpdate_580437;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a search application.
  ## 
  let valid = call_580453.validator(path, query, header, formData, body)
  let scheme = call_580453.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580453.url(scheme.get, call_580453.host, call_580453.base,
                         call_580453.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580453, url, valid)

proc call*(call_580454: Call_CloudsearchSettingsSearchapplicationsUpdate_580437;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudsearchSettingsSearchapplicationsUpdate
  ## Updates a search application.
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
  ##       : Name of the Search Application.
  ## <br />Format: searchapplications/{application_id}.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580455 = newJObject()
  var query_580456 = newJObject()
  var body_580457 = newJObject()
  add(query_580456, "key", newJString(key))
  add(query_580456, "prettyPrint", newJBool(prettyPrint))
  add(query_580456, "oauth_token", newJString(oauthToken))
  add(query_580456, "$.xgafv", newJString(Xgafv))
  add(query_580456, "alt", newJString(alt))
  add(query_580456, "uploadType", newJString(uploadType))
  add(query_580456, "quotaUser", newJString(quotaUser))
  add(path_580455, "name", newJString(name))
  if body != nil:
    body_580457 = body
  add(query_580456, "callback", newJString(callback))
  add(query_580456, "fields", newJString(fields))
  add(query_580456, "access_token", newJString(accessToken))
  add(query_580456, "upload_protocol", newJString(uploadProtocol))
  result = call_580454.call(path_580455, query_580456, nil, nil, body_580457)

var cloudsearchSettingsSearchapplicationsUpdate* = Call_CloudsearchSettingsSearchapplicationsUpdate_580437(
    name: "cloudsearchSettingsSearchapplicationsUpdate", meth: HttpMethod.HttpPut,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/{name}",
    validator: validate_CloudsearchSettingsSearchapplicationsUpdate_580438,
    base: "/", url: url_CloudsearchSettingsSearchapplicationsUpdate_580439,
    schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsSearchapplicationsGet_580417 = ref object of OpenApiRestCall_579373
proc url_CloudsearchSettingsSearchapplicationsGet_580419(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/settings/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudsearchSettingsSearchapplicationsGet_580418(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified search application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the search application.
  ## <br />Format: applications/{application_id}.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580420 = path.getOrDefault("name")
  valid_580420 = validateParameter(valid_580420, JString, required = true,
                                 default = nil)
  if valid_580420 != nil:
    section.add "name", valid_580420
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   debugOptions.enableDebugging: JBool
  ##                               : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
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
  var valid_580421 = query.getOrDefault("key")
  valid_580421 = validateParameter(valid_580421, JString, required = false,
                                 default = nil)
  if valid_580421 != nil:
    section.add "key", valid_580421
  var valid_580422 = query.getOrDefault("debugOptions.enableDebugging")
  valid_580422 = validateParameter(valid_580422, JBool, required = false, default = nil)
  if valid_580422 != nil:
    section.add "debugOptions.enableDebugging", valid_580422
  var valid_580423 = query.getOrDefault("prettyPrint")
  valid_580423 = validateParameter(valid_580423, JBool, required = false,
                                 default = newJBool(true))
  if valid_580423 != nil:
    section.add "prettyPrint", valid_580423
  var valid_580424 = query.getOrDefault("oauth_token")
  valid_580424 = validateParameter(valid_580424, JString, required = false,
                                 default = nil)
  if valid_580424 != nil:
    section.add "oauth_token", valid_580424
  var valid_580425 = query.getOrDefault("$.xgafv")
  valid_580425 = validateParameter(valid_580425, JString, required = false,
                                 default = newJString("1"))
  if valid_580425 != nil:
    section.add "$.xgafv", valid_580425
  var valid_580426 = query.getOrDefault("alt")
  valid_580426 = validateParameter(valid_580426, JString, required = false,
                                 default = newJString("json"))
  if valid_580426 != nil:
    section.add "alt", valid_580426
  var valid_580427 = query.getOrDefault("uploadType")
  valid_580427 = validateParameter(valid_580427, JString, required = false,
                                 default = nil)
  if valid_580427 != nil:
    section.add "uploadType", valid_580427
  var valid_580428 = query.getOrDefault("quotaUser")
  valid_580428 = validateParameter(valid_580428, JString, required = false,
                                 default = nil)
  if valid_580428 != nil:
    section.add "quotaUser", valid_580428
  var valid_580429 = query.getOrDefault("callback")
  valid_580429 = validateParameter(valid_580429, JString, required = false,
                                 default = nil)
  if valid_580429 != nil:
    section.add "callback", valid_580429
  var valid_580430 = query.getOrDefault("fields")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = nil)
  if valid_580430 != nil:
    section.add "fields", valid_580430
  var valid_580431 = query.getOrDefault("access_token")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = nil)
  if valid_580431 != nil:
    section.add "access_token", valid_580431
  var valid_580432 = query.getOrDefault("upload_protocol")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "upload_protocol", valid_580432
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580433: Call_CloudsearchSettingsSearchapplicationsGet_580417;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified search application.
  ## 
  let valid = call_580433.validator(path, query, header, formData, body)
  let scheme = call_580433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580433.url(scheme.get, call_580433.host, call_580433.base,
                         call_580433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580433, url, valid)

proc call*(call_580434: Call_CloudsearchSettingsSearchapplicationsGet_580417;
          name: string; key: string = ""; debugOptionsEnableDebugging: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudsearchSettingsSearchapplicationsGet
  ## Gets the specified search application.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   debugOptionsEnableDebugging: bool
  ##                              : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
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
  ##       : Name of the search application.
  ## <br />Format: applications/{application_id}.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580435 = newJObject()
  var query_580436 = newJObject()
  add(query_580436, "key", newJString(key))
  add(query_580436, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_580436, "prettyPrint", newJBool(prettyPrint))
  add(query_580436, "oauth_token", newJString(oauthToken))
  add(query_580436, "$.xgafv", newJString(Xgafv))
  add(query_580436, "alt", newJString(alt))
  add(query_580436, "uploadType", newJString(uploadType))
  add(query_580436, "quotaUser", newJString(quotaUser))
  add(path_580435, "name", newJString(name))
  add(query_580436, "callback", newJString(callback))
  add(query_580436, "fields", newJString(fields))
  add(query_580436, "access_token", newJString(accessToken))
  add(query_580436, "upload_protocol", newJString(uploadProtocol))
  result = call_580434.call(path_580435, query_580436, nil, nil, nil)

var cloudsearchSettingsSearchapplicationsGet* = Call_CloudsearchSettingsSearchapplicationsGet_580417(
    name: "cloudsearchSettingsSearchapplicationsGet", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/{name}",
    validator: validate_CloudsearchSettingsSearchapplicationsGet_580418,
    base: "/", url: url_CloudsearchSettingsSearchapplicationsGet_580419,
    schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsSearchapplicationsDelete_580458 = ref object of OpenApiRestCall_579373
proc url_CloudsearchSettingsSearchapplicationsDelete_580460(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/settings/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudsearchSettingsSearchapplicationsDelete_580459(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a search application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the search application to be deleted.
  ## <br />Format: applications/{application_id}.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580461 = path.getOrDefault("name")
  valid_580461 = validateParameter(valid_580461, JString, required = true,
                                 default = nil)
  if valid_580461 != nil:
    section.add "name", valid_580461
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   debugOptions.enableDebugging: JBool
  ##                               : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
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
  var valid_580462 = query.getOrDefault("key")
  valid_580462 = validateParameter(valid_580462, JString, required = false,
                                 default = nil)
  if valid_580462 != nil:
    section.add "key", valid_580462
  var valid_580463 = query.getOrDefault("debugOptions.enableDebugging")
  valid_580463 = validateParameter(valid_580463, JBool, required = false, default = nil)
  if valid_580463 != nil:
    section.add "debugOptions.enableDebugging", valid_580463
  var valid_580464 = query.getOrDefault("prettyPrint")
  valid_580464 = validateParameter(valid_580464, JBool, required = false,
                                 default = newJBool(true))
  if valid_580464 != nil:
    section.add "prettyPrint", valid_580464
  var valid_580465 = query.getOrDefault("oauth_token")
  valid_580465 = validateParameter(valid_580465, JString, required = false,
                                 default = nil)
  if valid_580465 != nil:
    section.add "oauth_token", valid_580465
  var valid_580466 = query.getOrDefault("$.xgafv")
  valid_580466 = validateParameter(valid_580466, JString, required = false,
                                 default = newJString("1"))
  if valid_580466 != nil:
    section.add "$.xgafv", valid_580466
  var valid_580467 = query.getOrDefault("alt")
  valid_580467 = validateParameter(valid_580467, JString, required = false,
                                 default = newJString("json"))
  if valid_580467 != nil:
    section.add "alt", valid_580467
  var valid_580468 = query.getOrDefault("uploadType")
  valid_580468 = validateParameter(valid_580468, JString, required = false,
                                 default = nil)
  if valid_580468 != nil:
    section.add "uploadType", valid_580468
  var valid_580469 = query.getOrDefault("quotaUser")
  valid_580469 = validateParameter(valid_580469, JString, required = false,
                                 default = nil)
  if valid_580469 != nil:
    section.add "quotaUser", valid_580469
  var valid_580470 = query.getOrDefault("callback")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = nil)
  if valid_580470 != nil:
    section.add "callback", valid_580470
  var valid_580471 = query.getOrDefault("fields")
  valid_580471 = validateParameter(valid_580471, JString, required = false,
                                 default = nil)
  if valid_580471 != nil:
    section.add "fields", valid_580471
  var valid_580472 = query.getOrDefault("access_token")
  valid_580472 = validateParameter(valid_580472, JString, required = false,
                                 default = nil)
  if valid_580472 != nil:
    section.add "access_token", valid_580472
  var valid_580473 = query.getOrDefault("upload_protocol")
  valid_580473 = validateParameter(valid_580473, JString, required = false,
                                 default = nil)
  if valid_580473 != nil:
    section.add "upload_protocol", valid_580473
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580474: Call_CloudsearchSettingsSearchapplicationsDelete_580458;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a search application.
  ## 
  let valid = call_580474.validator(path, query, header, formData, body)
  let scheme = call_580474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580474.url(scheme.get, call_580474.host, call_580474.base,
                         call_580474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580474, url, valid)

proc call*(call_580475: Call_CloudsearchSettingsSearchapplicationsDelete_580458;
          name: string; key: string = ""; debugOptionsEnableDebugging: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudsearchSettingsSearchapplicationsDelete
  ## Deletes a search application.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   debugOptionsEnableDebugging: bool
  ##                              : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
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
  ##       : The name of the search application to be deleted.
  ## <br />Format: applications/{application_id}.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580476 = newJObject()
  var query_580477 = newJObject()
  add(query_580477, "key", newJString(key))
  add(query_580477, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_580477, "prettyPrint", newJBool(prettyPrint))
  add(query_580477, "oauth_token", newJString(oauthToken))
  add(query_580477, "$.xgafv", newJString(Xgafv))
  add(query_580477, "alt", newJString(alt))
  add(query_580477, "uploadType", newJString(uploadType))
  add(query_580477, "quotaUser", newJString(quotaUser))
  add(path_580476, "name", newJString(name))
  add(query_580477, "callback", newJString(callback))
  add(query_580477, "fields", newJString(fields))
  add(query_580477, "access_token", newJString(accessToken))
  add(query_580477, "upload_protocol", newJString(uploadProtocol))
  result = call_580475.call(path_580476, query_580477, nil, nil, nil)

var cloudsearchSettingsSearchapplicationsDelete* = Call_CloudsearchSettingsSearchapplicationsDelete_580458(
    name: "cloudsearchSettingsSearchapplicationsDelete",
    meth: HttpMethod.HttpDelete, host: "cloudsearch.googleapis.com",
    route: "/v1/settings/{name}",
    validator: validate_CloudsearchSettingsSearchapplicationsDelete_580459,
    base: "/", url: url_CloudsearchSettingsSearchapplicationsDelete_580460,
    schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsSearchapplicationsReset_580478 = ref object of OpenApiRestCall_579373
proc url_CloudsearchSettingsSearchapplicationsReset_580480(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/settings/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":reset")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudsearchSettingsSearchapplicationsReset_580479(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resets a search application to default settings. This will return an empty
  ## response.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the search application to be reset.
  ## <br />Format: applications/{application_id}.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580481 = path.getOrDefault("name")
  valid_580481 = validateParameter(valid_580481, JString, required = true,
                                 default = nil)
  if valid_580481 != nil:
    section.add "name", valid_580481
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
  var valid_580482 = query.getOrDefault("key")
  valid_580482 = validateParameter(valid_580482, JString, required = false,
                                 default = nil)
  if valid_580482 != nil:
    section.add "key", valid_580482
  var valid_580483 = query.getOrDefault("prettyPrint")
  valid_580483 = validateParameter(valid_580483, JBool, required = false,
                                 default = newJBool(true))
  if valid_580483 != nil:
    section.add "prettyPrint", valid_580483
  var valid_580484 = query.getOrDefault("oauth_token")
  valid_580484 = validateParameter(valid_580484, JString, required = false,
                                 default = nil)
  if valid_580484 != nil:
    section.add "oauth_token", valid_580484
  var valid_580485 = query.getOrDefault("$.xgafv")
  valid_580485 = validateParameter(valid_580485, JString, required = false,
                                 default = newJString("1"))
  if valid_580485 != nil:
    section.add "$.xgafv", valid_580485
  var valid_580486 = query.getOrDefault("alt")
  valid_580486 = validateParameter(valid_580486, JString, required = false,
                                 default = newJString("json"))
  if valid_580486 != nil:
    section.add "alt", valid_580486
  var valid_580487 = query.getOrDefault("uploadType")
  valid_580487 = validateParameter(valid_580487, JString, required = false,
                                 default = nil)
  if valid_580487 != nil:
    section.add "uploadType", valid_580487
  var valid_580488 = query.getOrDefault("quotaUser")
  valid_580488 = validateParameter(valid_580488, JString, required = false,
                                 default = nil)
  if valid_580488 != nil:
    section.add "quotaUser", valid_580488
  var valid_580489 = query.getOrDefault("callback")
  valid_580489 = validateParameter(valid_580489, JString, required = false,
                                 default = nil)
  if valid_580489 != nil:
    section.add "callback", valid_580489
  var valid_580490 = query.getOrDefault("fields")
  valid_580490 = validateParameter(valid_580490, JString, required = false,
                                 default = nil)
  if valid_580490 != nil:
    section.add "fields", valid_580490
  var valid_580491 = query.getOrDefault("access_token")
  valid_580491 = validateParameter(valid_580491, JString, required = false,
                                 default = nil)
  if valid_580491 != nil:
    section.add "access_token", valid_580491
  var valid_580492 = query.getOrDefault("upload_protocol")
  valid_580492 = validateParameter(valid_580492, JString, required = false,
                                 default = nil)
  if valid_580492 != nil:
    section.add "upload_protocol", valid_580492
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580494: Call_CloudsearchSettingsSearchapplicationsReset_580478;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets a search application to default settings. This will return an empty
  ## response.
  ## 
  let valid = call_580494.validator(path, query, header, formData, body)
  let scheme = call_580494.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580494.url(scheme.get, call_580494.host, call_580494.base,
                         call_580494.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580494, url, valid)

proc call*(call_580495: Call_CloudsearchSettingsSearchapplicationsReset_580478;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudsearchSettingsSearchapplicationsReset
  ## Resets a search application to default settings. This will return an empty
  ## response.
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
  ##       : The name of the search application to be reset.
  ## <br />Format: applications/{application_id}.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580496 = newJObject()
  var query_580497 = newJObject()
  var body_580498 = newJObject()
  add(query_580497, "key", newJString(key))
  add(query_580497, "prettyPrint", newJBool(prettyPrint))
  add(query_580497, "oauth_token", newJString(oauthToken))
  add(query_580497, "$.xgafv", newJString(Xgafv))
  add(query_580497, "alt", newJString(alt))
  add(query_580497, "uploadType", newJString(uploadType))
  add(query_580497, "quotaUser", newJString(quotaUser))
  add(path_580496, "name", newJString(name))
  if body != nil:
    body_580498 = body
  add(query_580497, "callback", newJString(callback))
  add(query_580497, "fields", newJString(fields))
  add(query_580497, "access_token", newJString(accessToken))
  add(query_580497, "upload_protocol", newJString(uploadProtocol))
  result = call_580495.call(path_580496, query_580497, nil, nil, body_580498)

var cloudsearchSettingsSearchapplicationsReset* = Call_CloudsearchSettingsSearchapplicationsReset_580478(
    name: "cloudsearchSettingsSearchapplicationsReset", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/{name}:reset",
    validator: validate_CloudsearchSettingsSearchapplicationsReset_580479,
    base: "/", url: url_CloudsearchSettingsSearchapplicationsReset_580480,
    schemes: {Scheme.Https})
type
  Call_CloudsearchStatsGetIndex_580499 = ref object of OpenApiRestCall_579373
proc url_CloudsearchStatsGetIndex_580501(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CloudsearchStatsGetIndex_580500(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets indexed item statistics aggreggated across all data sources. This
  ## API only returns statistics for previous dates; it doesn't return
  ## statistics for the current day.
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
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   fromDate.year: JInt
  ##                : Year of date. Must be from 1 to 9999.
  ##   fromDate.day: JInt
  ##               : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   toDate.day: JInt
  ##             : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   toDate.year: JInt
  ##              : Year of date. Must be from 1 to 9999.
  ##   callback: JString
  ##           : JSONP
  ##   fromDate.month: JInt
  ##                 : Month of date. Must be from 1 to 12.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   toDate.month: JInt
  ##               : Month of date. Must be from 1 to 12.
  section = newJObject()
  var valid_580502 = query.getOrDefault("key")
  valid_580502 = validateParameter(valid_580502, JString, required = false,
                                 default = nil)
  if valid_580502 != nil:
    section.add "key", valid_580502
  var valid_580503 = query.getOrDefault("prettyPrint")
  valid_580503 = validateParameter(valid_580503, JBool, required = false,
                                 default = newJBool(true))
  if valid_580503 != nil:
    section.add "prettyPrint", valid_580503
  var valid_580504 = query.getOrDefault("oauth_token")
  valid_580504 = validateParameter(valid_580504, JString, required = false,
                                 default = nil)
  if valid_580504 != nil:
    section.add "oauth_token", valid_580504
  var valid_580505 = query.getOrDefault("$.xgafv")
  valid_580505 = validateParameter(valid_580505, JString, required = false,
                                 default = newJString("1"))
  if valid_580505 != nil:
    section.add "$.xgafv", valid_580505
  var valid_580506 = query.getOrDefault("fromDate.year")
  valid_580506 = validateParameter(valid_580506, JInt, required = false, default = nil)
  if valid_580506 != nil:
    section.add "fromDate.year", valid_580506
  var valid_580507 = query.getOrDefault("fromDate.day")
  valid_580507 = validateParameter(valid_580507, JInt, required = false, default = nil)
  if valid_580507 != nil:
    section.add "fromDate.day", valid_580507
  var valid_580508 = query.getOrDefault("alt")
  valid_580508 = validateParameter(valid_580508, JString, required = false,
                                 default = newJString("json"))
  if valid_580508 != nil:
    section.add "alt", valid_580508
  var valid_580509 = query.getOrDefault("uploadType")
  valid_580509 = validateParameter(valid_580509, JString, required = false,
                                 default = nil)
  if valid_580509 != nil:
    section.add "uploadType", valid_580509
  var valid_580510 = query.getOrDefault("quotaUser")
  valid_580510 = validateParameter(valid_580510, JString, required = false,
                                 default = nil)
  if valid_580510 != nil:
    section.add "quotaUser", valid_580510
  var valid_580511 = query.getOrDefault("toDate.day")
  valid_580511 = validateParameter(valid_580511, JInt, required = false, default = nil)
  if valid_580511 != nil:
    section.add "toDate.day", valid_580511
  var valid_580512 = query.getOrDefault("toDate.year")
  valid_580512 = validateParameter(valid_580512, JInt, required = false, default = nil)
  if valid_580512 != nil:
    section.add "toDate.year", valid_580512
  var valid_580513 = query.getOrDefault("callback")
  valid_580513 = validateParameter(valid_580513, JString, required = false,
                                 default = nil)
  if valid_580513 != nil:
    section.add "callback", valid_580513
  var valid_580514 = query.getOrDefault("fromDate.month")
  valid_580514 = validateParameter(valid_580514, JInt, required = false, default = nil)
  if valid_580514 != nil:
    section.add "fromDate.month", valid_580514
  var valid_580515 = query.getOrDefault("fields")
  valid_580515 = validateParameter(valid_580515, JString, required = false,
                                 default = nil)
  if valid_580515 != nil:
    section.add "fields", valid_580515
  var valid_580516 = query.getOrDefault("access_token")
  valid_580516 = validateParameter(valid_580516, JString, required = false,
                                 default = nil)
  if valid_580516 != nil:
    section.add "access_token", valid_580516
  var valid_580517 = query.getOrDefault("upload_protocol")
  valid_580517 = validateParameter(valid_580517, JString, required = false,
                                 default = nil)
  if valid_580517 != nil:
    section.add "upload_protocol", valid_580517
  var valid_580518 = query.getOrDefault("toDate.month")
  valid_580518 = validateParameter(valid_580518, JInt, required = false, default = nil)
  if valid_580518 != nil:
    section.add "toDate.month", valid_580518
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580519: Call_CloudsearchStatsGetIndex_580499; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets indexed item statistics aggreggated across all data sources. This
  ## API only returns statistics for previous dates; it doesn't return
  ## statistics for the current day.
  ## 
  let valid = call_580519.validator(path, query, header, formData, body)
  let scheme = call_580519.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580519.url(scheme.get, call_580519.host, call_580519.base,
                         call_580519.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580519, url, valid)

proc call*(call_580520: Call_CloudsearchStatsGetIndex_580499; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          fromDateYear: int = 0; fromDateDay: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; toDateDay: int = 0;
          toDateYear: int = 0; callback: string = ""; fromDateMonth: int = 0;
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          toDateMonth: int = 0): Recallable =
  ## cloudsearchStatsGetIndex
  ## Gets indexed item statistics aggreggated across all data sources. This
  ## API only returns statistics for previous dates; it doesn't return
  ## statistics for the current day.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   fromDateYear: int
  ##               : Year of date. Must be from 1 to 9999.
  ##   fromDateDay: int
  ##              : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   toDateDay: int
  ##            : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   toDateYear: int
  ##             : Year of date. Must be from 1 to 9999.
  ##   callback: string
  ##           : JSONP
  ##   fromDateMonth: int
  ##                : Month of date. Must be from 1 to 12.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   toDateMonth: int
  ##              : Month of date. Must be from 1 to 12.
  var query_580521 = newJObject()
  add(query_580521, "key", newJString(key))
  add(query_580521, "prettyPrint", newJBool(prettyPrint))
  add(query_580521, "oauth_token", newJString(oauthToken))
  add(query_580521, "$.xgafv", newJString(Xgafv))
  add(query_580521, "fromDate.year", newJInt(fromDateYear))
  add(query_580521, "fromDate.day", newJInt(fromDateDay))
  add(query_580521, "alt", newJString(alt))
  add(query_580521, "uploadType", newJString(uploadType))
  add(query_580521, "quotaUser", newJString(quotaUser))
  add(query_580521, "toDate.day", newJInt(toDateDay))
  add(query_580521, "toDate.year", newJInt(toDateYear))
  add(query_580521, "callback", newJString(callback))
  add(query_580521, "fromDate.month", newJInt(fromDateMonth))
  add(query_580521, "fields", newJString(fields))
  add(query_580521, "access_token", newJString(accessToken))
  add(query_580521, "upload_protocol", newJString(uploadProtocol))
  add(query_580521, "toDate.month", newJInt(toDateMonth))
  result = call_580520.call(nil, query_580521, nil, nil, nil)

var cloudsearchStatsGetIndex* = Call_CloudsearchStatsGetIndex_580499(
    name: "cloudsearchStatsGetIndex", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/stats/index",
    validator: validate_CloudsearchStatsGetIndex_580500, base: "/",
    url: url_CloudsearchStatsGetIndex_580501, schemes: {Scheme.Https})
type
  Call_CloudsearchStatsIndexDatasourcesGet_580522 = ref object of OpenApiRestCall_579373
proc url_CloudsearchStatsIndexDatasourcesGet_580524(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/stats/index/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudsearchStatsIndexDatasourcesGet_580523(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets indexed item statistics for a single data source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource id of the data source to retrieve statistics for,
  ## in the following format: "datasources/{source_id}"
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580525 = path.getOrDefault("name")
  valid_580525 = validateParameter(valid_580525, JString, required = true,
                                 default = nil)
  if valid_580525 != nil:
    section.add "name", valid_580525
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
  ##   fromDate.year: JInt
  ##                : Year of date. Must be from 1 to 9999.
  ##   fromDate.day: JInt
  ##               : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   toDate.day: JInt
  ##             : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   toDate.year: JInt
  ##              : Year of date. Must be from 1 to 9999.
  ##   callback: JString
  ##           : JSONP
  ##   fromDate.month: JInt
  ##                 : Month of date. Must be from 1 to 12.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   toDate.month: JInt
  ##               : Month of date. Must be from 1 to 12.
  section = newJObject()
  var valid_580526 = query.getOrDefault("key")
  valid_580526 = validateParameter(valid_580526, JString, required = false,
                                 default = nil)
  if valid_580526 != nil:
    section.add "key", valid_580526
  var valid_580527 = query.getOrDefault("prettyPrint")
  valid_580527 = validateParameter(valid_580527, JBool, required = false,
                                 default = newJBool(true))
  if valid_580527 != nil:
    section.add "prettyPrint", valid_580527
  var valid_580528 = query.getOrDefault("oauth_token")
  valid_580528 = validateParameter(valid_580528, JString, required = false,
                                 default = nil)
  if valid_580528 != nil:
    section.add "oauth_token", valid_580528
  var valid_580529 = query.getOrDefault("$.xgafv")
  valid_580529 = validateParameter(valid_580529, JString, required = false,
                                 default = newJString("1"))
  if valid_580529 != nil:
    section.add "$.xgafv", valid_580529
  var valid_580530 = query.getOrDefault("fromDate.year")
  valid_580530 = validateParameter(valid_580530, JInt, required = false, default = nil)
  if valid_580530 != nil:
    section.add "fromDate.year", valid_580530
  var valid_580531 = query.getOrDefault("fromDate.day")
  valid_580531 = validateParameter(valid_580531, JInt, required = false, default = nil)
  if valid_580531 != nil:
    section.add "fromDate.day", valid_580531
  var valid_580532 = query.getOrDefault("alt")
  valid_580532 = validateParameter(valid_580532, JString, required = false,
                                 default = newJString("json"))
  if valid_580532 != nil:
    section.add "alt", valid_580532
  var valid_580533 = query.getOrDefault("uploadType")
  valid_580533 = validateParameter(valid_580533, JString, required = false,
                                 default = nil)
  if valid_580533 != nil:
    section.add "uploadType", valid_580533
  var valid_580534 = query.getOrDefault("quotaUser")
  valid_580534 = validateParameter(valid_580534, JString, required = false,
                                 default = nil)
  if valid_580534 != nil:
    section.add "quotaUser", valid_580534
  var valid_580535 = query.getOrDefault("toDate.day")
  valid_580535 = validateParameter(valid_580535, JInt, required = false, default = nil)
  if valid_580535 != nil:
    section.add "toDate.day", valid_580535
  var valid_580536 = query.getOrDefault("toDate.year")
  valid_580536 = validateParameter(valid_580536, JInt, required = false, default = nil)
  if valid_580536 != nil:
    section.add "toDate.year", valid_580536
  var valid_580537 = query.getOrDefault("callback")
  valid_580537 = validateParameter(valid_580537, JString, required = false,
                                 default = nil)
  if valid_580537 != nil:
    section.add "callback", valid_580537
  var valid_580538 = query.getOrDefault("fromDate.month")
  valid_580538 = validateParameter(valid_580538, JInt, required = false, default = nil)
  if valid_580538 != nil:
    section.add "fromDate.month", valid_580538
  var valid_580539 = query.getOrDefault("fields")
  valid_580539 = validateParameter(valid_580539, JString, required = false,
                                 default = nil)
  if valid_580539 != nil:
    section.add "fields", valid_580539
  var valid_580540 = query.getOrDefault("access_token")
  valid_580540 = validateParameter(valid_580540, JString, required = false,
                                 default = nil)
  if valid_580540 != nil:
    section.add "access_token", valid_580540
  var valid_580541 = query.getOrDefault("upload_protocol")
  valid_580541 = validateParameter(valid_580541, JString, required = false,
                                 default = nil)
  if valid_580541 != nil:
    section.add "upload_protocol", valid_580541
  var valid_580542 = query.getOrDefault("toDate.month")
  valid_580542 = validateParameter(valid_580542, JInt, required = false, default = nil)
  if valid_580542 != nil:
    section.add "toDate.month", valid_580542
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580543: Call_CloudsearchStatsIndexDatasourcesGet_580522;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets indexed item statistics for a single data source.
  ## 
  let valid = call_580543.validator(path, query, header, formData, body)
  let scheme = call_580543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580543.url(scheme.get, call_580543.host, call_580543.base,
                         call_580543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580543, url, valid)

proc call*(call_580544: Call_CloudsearchStatsIndexDatasourcesGet_580522;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; fromDateYear: int = 0;
          fromDateDay: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; toDateDay: int = 0; toDateYear: int = 0;
          callback: string = ""; fromDateMonth: int = 0; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""; toDateMonth: int = 0): Recallable =
  ## cloudsearchStatsIndexDatasourcesGet
  ## Gets indexed item statistics for a single data source.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   fromDateYear: int
  ##               : Year of date. Must be from 1 to 9999.
  ##   fromDateDay: int
  ##              : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource id of the data source to retrieve statistics for,
  ## in the following format: "datasources/{source_id}"
  ##   toDateDay: int
  ##            : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   toDateYear: int
  ##             : Year of date. Must be from 1 to 9999.
  ##   callback: string
  ##           : JSONP
  ##   fromDateMonth: int
  ##                : Month of date. Must be from 1 to 12.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   toDateMonth: int
  ##              : Month of date. Must be from 1 to 12.
  var path_580545 = newJObject()
  var query_580546 = newJObject()
  add(query_580546, "key", newJString(key))
  add(query_580546, "prettyPrint", newJBool(prettyPrint))
  add(query_580546, "oauth_token", newJString(oauthToken))
  add(query_580546, "$.xgafv", newJString(Xgafv))
  add(query_580546, "fromDate.year", newJInt(fromDateYear))
  add(query_580546, "fromDate.day", newJInt(fromDateDay))
  add(query_580546, "alt", newJString(alt))
  add(query_580546, "uploadType", newJString(uploadType))
  add(query_580546, "quotaUser", newJString(quotaUser))
  add(path_580545, "name", newJString(name))
  add(query_580546, "toDate.day", newJInt(toDateDay))
  add(query_580546, "toDate.year", newJInt(toDateYear))
  add(query_580546, "callback", newJString(callback))
  add(query_580546, "fromDate.month", newJInt(fromDateMonth))
  add(query_580546, "fields", newJString(fields))
  add(query_580546, "access_token", newJString(accessToken))
  add(query_580546, "upload_protocol", newJString(uploadProtocol))
  add(query_580546, "toDate.month", newJInt(toDateMonth))
  result = call_580544.call(path_580545, query_580546, nil, nil, nil)

var cloudsearchStatsIndexDatasourcesGet* = Call_CloudsearchStatsIndexDatasourcesGet_580522(
    name: "cloudsearchStatsIndexDatasourcesGet", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/stats/index/{name}",
    validator: validate_CloudsearchStatsIndexDatasourcesGet_580523, base: "/",
    url: url_CloudsearchStatsIndexDatasourcesGet_580524, schemes: {Scheme.Https})
type
  Call_CloudsearchStatsGetQuery_580547 = ref object of OpenApiRestCall_579373
proc url_CloudsearchStatsGetQuery_580549(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CloudsearchStatsGetQuery_580548(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the query statistics for customer
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
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   fromDate.year: JInt
  ##                : Year of date. Must be from 1 to 9999.
  ##   fromDate.day: JInt
  ##               : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   toDate.day: JInt
  ##             : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   toDate.year: JInt
  ##              : Year of date. Must be from 1 to 9999.
  ##   callback: JString
  ##           : JSONP
  ##   fromDate.month: JInt
  ##                 : Month of date. Must be from 1 to 12.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   toDate.month: JInt
  ##               : Month of date. Must be from 1 to 12.
  section = newJObject()
  var valid_580550 = query.getOrDefault("key")
  valid_580550 = validateParameter(valid_580550, JString, required = false,
                                 default = nil)
  if valid_580550 != nil:
    section.add "key", valid_580550
  var valid_580551 = query.getOrDefault("prettyPrint")
  valid_580551 = validateParameter(valid_580551, JBool, required = false,
                                 default = newJBool(true))
  if valid_580551 != nil:
    section.add "prettyPrint", valid_580551
  var valid_580552 = query.getOrDefault("oauth_token")
  valid_580552 = validateParameter(valid_580552, JString, required = false,
                                 default = nil)
  if valid_580552 != nil:
    section.add "oauth_token", valid_580552
  var valid_580553 = query.getOrDefault("$.xgafv")
  valid_580553 = validateParameter(valid_580553, JString, required = false,
                                 default = newJString("1"))
  if valid_580553 != nil:
    section.add "$.xgafv", valid_580553
  var valid_580554 = query.getOrDefault("fromDate.year")
  valid_580554 = validateParameter(valid_580554, JInt, required = false, default = nil)
  if valid_580554 != nil:
    section.add "fromDate.year", valid_580554
  var valid_580555 = query.getOrDefault("fromDate.day")
  valid_580555 = validateParameter(valid_580555, JInt, required = false, default = nil)
  if valid_580555 != nil:
    section.add "fromDate.day", valid_580555
  var valid_580556 = query.getOrDefault("alt")
  valid_580556 = validateParameter(valid_580556, JString, required = false,
                                 default = newJString("json"))
  if valid_580556 != nil:
    section.add "alt", valid_580556
  var valid_580557 = query.getOrDefault("uploadType")
  valid_580557 = validateParameter(valid_580557, JString, required = false,
                                 default = nil)
  if valid_580557 != nil:
    section.add "uploadType", valid_580557
  var valid_580558 = query.getOrDefault("quotaUser")
  valid_580558 = validateParameter(valid_580558, JString, required = false,
                                 default = nil)
  if valid_580558 != nil:
    section.add "quotaUser", valid_580558
  var valid_580559 = query.getOrDefault("toDate.day")
  valid_580559 = validateParameter(valid_580559, JInt, required = false, default = nil)
  if valid_580559 != nil:
    section.add "toDate.day", valid_580559
  var valid_580560 = query.getOrDefault("toDate.year")
  valid_580560 = validateParameter(valid_580560, JInt, required = false, default = nil)
  if valid_580560 != nil:
    section.add "toDate.year", valid_580560
  var valid_580561 = query.getOrDefault("callback")
  valid_580561 = validateParameter(valid_580561, JString, required = false,
                                 default = nil)
  if valid_580561 != nil:
    section.add "callback", valid_580561
  var valid_580562 = query.getOrDefault("fromDate.month")
  valid_580562 = validateParameter(valid_580562, JInt, required = false, default = nil)
  if valid_580562 != nil:
    section.add "fromDate.month", valid_580562
  var valid_580563 = query.getOrDefault("fields")
  valid_580563 = validateParameter(valid_580563, JString, required = false,
                                 default = nil)
  if valid_580563 != nil:
    section.add "fields", valid_580563
  var valid_580564 = query.getOrDefault("access_token")
  valid_580564 = validateParameter(valid_580564, JString, required = false,
                                 default = nil)
  if valid_580564 != nil:
    section.add "access_token", valid_580564
  var valid_580565 = query.getOrDefault("upload_protocol")
  valid_580565 = validateParameter(valid_580565, JString, required = false,
                                 default = nil)
  if valid_580565 != nil:
    section.add "upload_protocol", valid_580565
  var valid_580566 = query.getOrDefault("toDate.month")
  valid_580566 = validateParameter(valid_580566, JInt, required = false, default = nil)
  if valid_580566 != nil:
    section.add "toDate.month", valid_580566
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580567: Call_CloudsearchStatsGetQuery_580547; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the query statistics for customer
  ## 
  let valid = call_580567.validator(path, query, header, formData, body)
  let scheme = call_580567.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580567.url(scheme.get, call_580567.host, call_580567.base,
                         call_580567.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580567, url, valid)

proc call*(call_580568: Call_CloudsearchStatsGetQuery_580547; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          fromDateYear: int = 0; fromDateDay: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; toDateDay: int = 0;
          toDateYear: int = 0; callback: string = ""; fromDateMonth: int = 0;
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          toDateMonth: int = 0): Recallable =
  ## cloudsearchStatsGetQuery
  ## Get the query statistics for customer
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   fromDateYear: int
  ##               : Year of date. Must be from 1 to 9999.
  ##   fromDateDay: int
  ##              : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   toDateDay: int
  ##            : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   toDateYear: int
  ##             : Year of date. Must be from 1 to 9999.
  ##   callback: string
  ##           : JSONP
  ##   fromDateMonth: int
  ##                : Month of date. Must be from 1 to 12.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   toDateMonth: int
  ##              : Month of date. Must be from 1 to 12.
  var query_580569 = newJObject()
  add(query_580569, "key", newJString(key))
  add(query_580569, "prettyPrint", newJBool(prettyPrint))
  add(query_580569, "oauth_token", newJString(oauthToken))
  add(query_580569, "$.xgafv", newJString(Xgafv))
  add(query_580569, "fromDate.year", newJInt(fromDateYear))
  add(query_580569, "fromDate.day", newJInt(fromDateDay))
  add(query_580569, "alt", newJString(alt))
  add(query_580569, "uploadType", newJString(uploadType))
  add(query_580569, "quotaUser", newJString(quotaUser))
  add(query_580569, "toDate.day", newJInt(toDateDay))
  add(query_580569, "toDate.year", newJInt(toDateYear))
  add(query_580569, "callback", newJString(callback))
  add(query_580569, "fromDate.month", newJInt(fromDateMonth))
  add(query_580569, "fields", newJString(fields))
  add(query_580569, "access_token", newJString(accessToken))
  add(query_580569, "upload_protocol", newJString(uploadProtocol))
  add(query_580569, "toDate.month", newJInt(toDateMonth))
  result = call_580568.call(nil, query_580569, nil, nil, nil)

var cloudsearchStatsGetQuery* = Call_CloudsearchStatsGetQuery_580547(
    name: "cloudsearchStatsGetQuery", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/stats/query",
    validator: validate_CloudsearchStatsGetQuery_580548, base: "/",
    url: url_CloudsearchStatsGetQuery_580549, schemes: {Scheme.Https})
type
  Call_CloudsearchStatsQuerySearchapplicationsGet_580570 = ref object of OpenApiRestCall_579373
proc url_CloudsearchStatsQuerySearchapplicationsGet_580572(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/stats/query/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudsearchStatsQuerySearchapplicationsGet_580571(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the query statistics for search application
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource id of the search application query stats, in the following
  ## format: searchapplications/{application_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580573 = path.getOrDefault("name")
  valid_580573 = validateParameter(valid_580573, JString, required = true,
                                 default = nil)
  if valid_580573 != nil:
    section.add "name", valid_580573
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
  ##   fromDate.year: JInt
  ##                : Year of date. Must be from 1 to 9999.
  ##   fromDate.day: JInt
  ##               : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   toDate.day: JInt
  ##             : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   toDate.year: JInt
  ##              : Year of date. Must be from 1 to 9999.
  ##   callback: JString
  ##           : JSONP
  ##   fromDate.month: JInt
  ##                 : Month of date. Must be from 1 to 12.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   toDate.month: JInt
  ##               : Month of date. Must be from 1 to 12.
  section = newJObject()
  var valid_580574 = query.getOrDefault("key")
  valid_580574 = validateParameter(valid_580574, JString, required = false,
                                 default = nil)
  if valid_580574 != nil:
    section.add "key", valid_580574
  var valid_580575 = query.getOrDefault("prettyPrint")
  valid_580575 = validateParameter(valid_580575, JBool, required = false,
                                 default = newJBool(true))
  if valid_580575 != nil:
    section.add "prettyPrint", valid_580575
  var valid_580576 = query.getOrDefault("oauth_token")
  valid_580576 = validateParameter(valid_580576, JString, required = false,
                                 default = nil)
  if valid_580576 != nil:
    section.add "oauth_token", valid_580576
  var valid_580577 = query.getOrDefault("$.xgafv")
  valid_580577 = validateParameter(valid_580577, JString, required = false,
                                 default = newJString("1"))
  if valid_580577 != nil:
    section.add "$.xgafv", valid_580577
  var valid_580578 = query.getOrDefault("fromDate.year")
  valid_580578 = validateParameter(valid_580578, JInt, required = false, default = nil)
  if valid_580578 != nil:
    section.add "fromDate.year", valid_580578
  var valid_580579 = query.getOrDefault("fromDate.day")
  valid_580579 = validateParameter(valid_580579, JInt, required = false, default = nil)
  if valid_580579 != nil:
    section.add "fromDate.day", valid_580579
  var valid_580580 = query.getOrDefault("alt")
  valid_580580 = validateParameter(valid_580580, JString, required = false,
                                 default = newJString("json"))
  if valid_580580 != nil:
    section.add "alt", valid_580580
  var valid_580581 = query.getOrDefault("uploadType")
  valid_580581 = validateParameter(valid_580581, JString, required = false,
                                 default = nil)
  if valid_580581 != nil:
    section.add "uploadType", valid_580581
  var valid_580582 = query.getOrDefault("quotaUser")
  valid_580582 = validateParameter(valid_580582, JString, required = false,
                                 default = nil)
  if valid_580582 != nil:
    section.add "quotaUser", valid_580582
  var valid_580583 = query.getOrDefault("toDate.day")
  valid_580583 = validateParameter(valid_580583, JInt, required = false, default = nil)
  if valid_580583 != nil:
    section.add "toDate.day", valid_580583
  var valid_580584 = query.getOrDefault("toDate.year")
  valid_580584 = validateParameter(valid_580584, JInt, required = false, default = nil)
  if valid_580584 != nil:
    section.add "toDate.year", valid_580584
  var valid_580585 = query.getOrDefault("callback")
  valid_580585 = validateParameter(valid_580585, JString, required = false,
                                 default = nil)
  if valid_580585 != nil:
    section.add "callback", valid_580585
  var valid_580586 = query.getOrDefault("fromDate.month")
  valid_580586 = validateParameter(valid_580586, JInt, required = false, default = nil)
  if valid_580586 != nil:
    section.add "fromDate.month", valid_580586
  var valid_580587 = query.getOrDefault("fields")
  valid_580587 = validateParameter(valid_580587, JString, required = false,
                                 default = nil)
  if valid_580587 != nil:
    section.add "fields", valid_580587
  var valid_580588 = query.getOrDefault("access_token")
  valid_580588 = validateParameter(valid_580588, JString, required = false,
                                 default = nil)
  if valid_580588 != nil:
    section.add "access_token", valid_580588
  var valid_580589 = query.getOrDefault("upload_protocol")
  valid_580589 = validateParameter(valid_580589, JString, required = false,
                                 default = nil)
  if valid_580589 != nil:
    section.add "upload_protocol", valid_580589
  var valid_580590 = query.getOrDefault("toDate.month")
  valid_580590 = validateParameter(valid_580590, JInt, required = false, default = nil)
  if valid_580590 != nil:
    section.add "toDate.month", valid_580590
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580591: Call_CloudsearchStatsQuerySearchapplicationsGet_580570;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the query statistics for search application
  ## 
  let valid = call_580591.validator(path, query, header, formData, body)
  let scheme = call_580591.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580591.url(scheme.get, call_580591.host, call_580591.base,
                         call_580591.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580591, url, valid)

proc call*(call_580592: Call_CloudsearchStatsQuerySearchapplicationsGet_580570;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; fromDateYear: int = 0;
          fromDateDay: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; toDateDay: int = 0; toDateYear: int = 0;
          callback: string = ""; fromDateMonth: int = 0; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""; toDateMonth: int = 0): Recallable =
  ## cloudsearchStatsQuerySearchapplicationsGet
  ## Get the query statistics for search application
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   fromDateYear: int
  ##               : Year of date. Must be from 1 to 9999.
  ##   fromDateDay: int
  ##              : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource id of the search application query stats, in the following
  ## format: searchapplications/{application_id}
  ##   toDateDay: int
  ##            : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   toDateYear: int
  ##             : Year of date. Must be from 1 to 9999.
  ##   callback: string
  ##           : JSONP
  ##   fromDateMonth: int
  ##                : Month of date. Must be from 1 to 12.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   toDateMonth: int
  ##              : Month of date. Must be from 1 to 12.
  var path_580593 = newJObject()
  var query_580594 = newJObject()
  add(query_580594, "key", newJString(key))
  add(query_580594, "prettyPrint", newJBool(prettyPrint))
  add(query_580594, "oauth_token", newJString(oauthToken))
  add(query_580594, "$.xgafv", newJString(Xgafv))
  add(query_580594, "fromDate.year", newJInt(fromDateYear))
  add(query_580594, "fromDate.day", newJInt(fromDateDay))
  add(query_580594, "alt", newJString(alt))
  add(query_580594, "uploadType", newJString(uploadType))
  add(query_580594, "quotaUser", newJString(quotaUser))
  add(path_580593, "name", newJString(name))
  add(query_580594, "toDate.day", newJInt(toDateDay))
  add(query_580594, "toDate.year", newJInt(toDateYear))
  add(query_580594, "callback", newJString(callback))
  add(query_580594, "fromDate.month", newJInt(fromDateMonth))
  add(query_580594, "fields", newJString(fields))
  add(query_580594, "access_token", newJString(accessToken))
  add(query_580594, "upload_protocol", newJString(uploadProtocol))
  add(query_580594, "toDate.month", newJInt(toDateMonth))
  result = call_580592.call(path_580593, query_580594, nil, nil, nil)

var cloudsearchStatsQuerySearchapplicationsGet* = Call_CloudsearchStatsQuerySearchapplicationsGet_580570(
    name: "cloudsearchStatsQuerySearchapplicationsGet", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/stats/query/{name}",
    validator: validate_CloudsearchStatsQuerySearchapplicationsGet_580571,
    base: "/", url: url_CloudsearchStatsQuerySearchapplicationsGet_580572,
    schemes: {Scheme.Https})
type
  Call_CloudsearchStatsGetSession_580595 = ref object of OpenApiRestCall_579373
proc url_CloudsearchStatsGetSession_580597(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CloudsearchStatsGetSession_580596(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the # of search sessions for the customer
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
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   fromDate.year: JInt
  ##                : Year of date. Must be from 1 to 9999.
  ##   fromDate.day: JInt
  ##               : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   toDate.day: JInt
  ##             : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   toDate.year: JInt
  ##              : Year of date. Must be from 1 to 9999.
  ##   callback: JString
  ##           : JSONP
  ##   fromDate.month: JInt
  ##                 : Month of date. Must be from 1 to 12.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   toDate.month: JInt
  ##               : Month of date. Must be from 1 to 12.
  section = newJObject()
  var valid_580598 = query.getOrDefault("key")
  valid_580598 = validateParameter(valid_580598, JString, required = false,
                                 default = nil)
  if valid_580598 != nil:
    section.add "key", valid_580598
  var valid_580599 = query.getOrDefault("prettyPrint")
  valid_580599 = validateParameter(valid_580599, JBool, required = false,
                                 default = newJBool(true))
  if valid_580599 != nil:
    section.add "prettyPrint", valid_580599
  var valid_580600 = query.getOrDefault("oauth_token")
  valid_580600 = validateParameter(valid_580600, JString, required = false,
                                 default = nil)
  if valid_580600 != nil:
    section.add "oauth_token", valid_580600
  var valid_580601 = query.getOrDefault("$.xgafv")
  valid_580601 = validateParameter(valid_580601, JString, required = false,
                                 default = newJString("1"))
  if valid_580601 != nil:
    section.add "$.xgafv", valid_580601
  var valid_580602 = query.getOrDefault("fromDate.year")
  valid_580602 = validateParameter(valid_580602, JInt, required = false, default = nil)
  if valid_580602 != nil:
    section.add "fromDate.year", valid_580602
  var valid_580603 = query.getOrDefault("fromDate.day")
  valid_580603 = validateParameter(valid_580603, JInt, required = false, default = nil)
  if valid_580603 != nil:
    section.add "fromDate.day", valid_580603
  var valid_580604 = query.getOrDefault("alt")
  valid_580604 = validateParameter(valid_580604, JString, required = false,
                                 default = newJString("json"))
  if valid_580604 != nil:
    section.add "alt", valid_580604
  var valid_580605 = query.getOrDefault("uploadType")
  valid_580605 = validateParameter(valid_580605, JString, required = false,
                                 default = nil)
  if valid_580605 != nil:
    section.add "uploadType", valid_580605
  var valid_580606 = query.getOrDefault("quotaUser")
  valid_580606 = validateParameter(valid_580606, JString, required = false,
                                 default = nil)
  if valid_580606 != nil:
    section.add "quotaUser", valid_580606
  var valid_580607 = query.getOrDefault("toDate.day")
  valid_580607 = validateParameter(valid_580607, JInt, required = false, default = nil)
  if valid_580607 != nil:
    section.add "toDate.day", valid_580607
  var valid_580608 = query.getOrDefault("toDate.year")
  valid_580608 = validateParameter(valid_580608, JInt, required = false, default = nil)
  if valid_580608 != nil:
    section.add "toDate.year", valid_580608
  var valid_580609 = query.getOrDefault("callback")
  valid_580609 = validateParameter(valid_580609, JString, required = false,
                                 default = nil)
  if valid_580609 != nil:
    section.add "callback", valid_580609
  var valid_580610 = query.getOrDefault("fromDate.month")
  valid_580610 = validateParameter(valid_580610, JInt, required = false, default = nil)
  if valid_580610 != nil:
    section.add "fromDate.month", valid_580610
  var valid_580611 = query.getOrDefault("fields")
  valid_580611 = validateParameter(valid_580611, JString, required = false,
                                 default = nil)
  if valid_580611 != nil:
    section.add "fields", valid_580611
  var valid_580612 = query.getOrDefault("access_token")
  valid_580612 = validateParameter(valid_580612, JString, required = false,
                                 default = nil)
  if valid_580612 != nil:
    section.add "access_token", valid_580612
  var valid_580613 = query.getOrDefault("upload_protocol")
  valid_580613 = validateParameter(valid_580613, JString, required = false,
                                 default = nil)
  if valid_580613 != nil:
    section.add "upload_protocol", valid_580613
  var valid_580614 = query.getOrDefault("toDate.month")
  valid_580614 = validateParameter(valid_580614, JInt, required = false, default = nil)
  if valid_580614 != nil:
    section.add "toDate.month", valid_580614
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580615: Call_CloudsearchStatsGetSession_580595; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the # of search sessions for the customer
  ## 
  let valid = call_580615.validator(path, query, header, formData, body)
  let scheme = call_580615.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580615.url(scheme.get, call_580615.host, call_580615.base,
                         call_580615.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580615, url, valid)

proc call*(call_580616: Call_CloudsearchStatsGetSession_580595; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          fromDateYear: int = 0; fromDateDay: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; toDateDay: int = 0;
          toDateYear: int = 0; callback: string = ""; fromDateMonth: int = 0;
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          toDateMonth: int = 0): Recallable =
  ## cloudsearchStatsGetSession
  ## Get the # of search sessions for the customer
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   fromDateYear: int
  ##               : Year of date. Must be from 1 to 9999.
  ##   fromDateDay: int
  ##              : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   toDateDay: int
  ##            : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   toDateYear: int
  ##             : Year of date. Must be from 1 to 9999.
  ##   callback: string
  ##           : JSONP
  ##   fromDateMonth: int
  ##                : Month of date. Must be from 1 to 12.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   toDateMonth: int
  ##              : Month of date. Must be from 1 to 12.
  var query_580617 = newJObject()
  add(query_580617, "key", newJString(key))
  add(query_580617, "prettyPrint", newJBool(prettyPrint))
  add(query_580617, "oauth_token", newJString(oauthToken))
  add(query_580617, "$.xgafv", newJString(Xgafv))
  add(query_580617, "fromDate.year", newJInt(fromDateYear))
  add(query_580617, "fromDate.day", newJInt(fromDateDay))
  add(query_580617, "alt", newJString(alt))
  add(query_580617, "uploadType", newJString(uploadType))
  add(query_580617, "quotaUser", newJString(quotaUser))
  add(query_580617, "toDate.day", newJInt(toDateDay))
  add(query_580617, "toDate.year", newJInt(toDateYear))
  add(query_580617, "callback", newJString(callback))
  add(query_580617, "fromDate.month", newJInt(fromDateMonth))
  add(query_580617, "fields", newJString(fields))
  add(query_580617, "access_token", newJString(accessToken))
  add(query_580617, "upload_protocol", newJString(uploadProtocol))
  add(query_580617, "toDate.month", newJInt(toDateMonth))
  result = call_580616.call(nil, query_580617, nil, nil, nil)

var cloudsearchStatsGetSession* = Call_CloudsearchStatsGetSession_580595(
    name: "cloudsearchStatsGetSession", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/stats/session",
    validator: validate_CloudsearchStatsGetSession_580596, base: "/",
    url: url_CloudsearchStatsGetSession_580597, schemes: {Scheme.Https})
type
  Call_CloudsearchStatsSessionSearchapplicationsGet_580618 = ref object of OpenApiRestCall_579373
proc url_CloudsearchStatsSessionSearchapplicationsGet_580620(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/stats/session/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudsearchStatsSessionSearchapplicationsGet_580619(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the # of search sessions for the search application
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource id of the search application session stats, in the following
  ## format: searchapplications/{application_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580621 = path.getOrDefault("name")
  valid_580621 = validateParameter(valid_580621, JString, required = true,
                                 default = nil)
  if valid_580621 != nil:
    section.add "name", valid_580621
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
  ##   fromDate.year: JInt
  ##                : Year of date. Must be from 1 to 9999.
  ##   fromDate.day: JInt
  ##               : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   toDate.day: JInt
  ##             : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   toDate.year: JInt
  ##              : Year of date. Must be from 1 to 9999.
  ##   callback: JString
  ##           : JSONP
  ##   fromDate.month: JInt
  ##                 : Month of date. Must be from 1 to 12.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   toDate.month: JInt
  ##               : Month of date. Must be from 1 to 12.
  section = newJObject()
  var valid_580622 = query.getOrDefault("key")
  valid_580622 = validateParameter(valid_580622, JString, required = false,
                                 default = nil)
  if valid_580622 != nil:
    section.add "key", valid_580622
  var valid_580623 = query.getOrDefault("prettyPrint")
  valid_580623 = validateParameter(valid_580623, JBool, required = false,
                                 default = newJBool(true))
  if valid_580623 != nil:
    section.add "prettyPrint", valid_580623
  var valid_580624 = query.getOrDefault("oauth_token")
  valid_580624 = validateParameter(valid_580624, JString, required = false,
                                 default = nil)
  if valid_580624 != nil:
    section.add "oauth_token", valid_580624
  var valid_580625 = query.getOrDefault("$.xgafv")
  valid_580625 = validateParameter(valid_580625, JString, required = false,
                                 default = newJString("1"))
  if valid_580625 != nil:
    section.add "$.xgafv", valid_580625
  var valid_580626 = query.getOrDefault("fromDate.year")
  valid_580626 = validateParameter(valid_580626, JInt, required = false, default = nil)
  if valid_580626 != nil:
    section.add "fromDate.year", valid_580626
  var valid_580627 = query.getOrDefault("fromDate.day")
  valid_580627 = validateParameter(valid_580627, JInt, required = false, default = nil)
  if valid_580627 != nil:
    section.add "fromDate.day", valid_580627
  var valid_580628 = query.getOrDefault("alt")
  valid_580628 = validateParameter(valid_580628, JString, required = false,
                                 default = newJString("json"))
  if valid_580628 != nil:
    section.add "alt", valid_580628
  var valid_580629 = query.getOrDefault("uploadType")
  valid_580629 = validateParameter(valid_580629, JString, required = false,
                                 default = nil)
  if valid_580629 != nil:
    section.add "uploadType", valid_580629
  var valid_580630 = query.getOrDefault("quotaUser")
  valid_580630 = validateParameter(valid_580630, JString, required = false,
                                 default = nil)
  if valid_580630 != nil:
    section.add "quotaUser", valid_580630
  var valid_580631 = query.getOrDefault("toDate.day")
  valid_580631 = validateParameter(valid_580631, JInt, required = false, default = nil)
  if valid_580631 != nil:
    section.add "toDate.day", valid_580631
  var valid_580632 = query.getOrDefault("toDate.year")
  valid_580632 = validateParameter(valid_580632, JInt, required = false, default = nil)
  if valid_580632 != nil:
    section.add "toDate.year", valid_580632
  var valid_580633 = query.getOrDefault("callback")
  valid_580633 = validateParameter(valid_580633, JString, required = false,
                                 default = nil)
  if valid_580633 != nil:
    section.add "callback", valid_580633
  var valid_580634 = query.getOrDefault("fromDate.month")
  valid_580634 = validateParameter(valid_580634, JInt, required = false, default = nil)
  if valid_580634 != nil:
    section.add "fromDate.month", valid_580634
  var valid_580635 = query.getOrDefault("fields")
  valid_580635 = validateParameter(valid_580635, JString, required = false,
                                 default = nil)
  if valid_580635 != nil:
    section.add "fields", valid_580635
  var valid_580636 = query.getOrDefault("access_token")
  valid_580636 = validateParameter(valid_580636, JString, required = false,
                                 default = nil)
  if valid_580636 != nil:
    section.add "access_token", valid_580636
  var valid_580637 = query.getOrDefault("upload_protocol")
  valid_580637 = validateParameter(valid_580637, JString, required = false,
                                 default = nil)
  if valid_580637 != nil:
    section.add "upload_protocol", valid_580637
  var valid_580638 = query.getOrDefault("toDate.month")
  valid_580638 = validateParameter(valid_580638, JInt, required = false, default = nil)
  if valid_580638 != nil:
    section.add "toDate.month", valid_580638
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580639: Call_CloudsearchStatsSessionSearchapplicationsGet_580618;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the # of search sessions for the search application
  ## 
  let valid = call_580639.validator(path, query, header, formData, body)
  let scheme = call_580639.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580639.url(scheme.get, call_580639.host, call_580639.base,
                         call_580639.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580639, url, valid)

proc call*(call_580640: Call_CloudsearchStatsSessionSearchapplicationsGet_580618;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; fromDateYear: int = 0;
          fromDateDay: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; toDateDay: int = 0; toDateYear: int = 0;
          callback: string = ""; fromDateMonth: int = 0; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""; toDateMonth: int = 0): Recallable =
  ## cloudsearchStatsSessionSearchapplicationsGet
  ## Get the # of search sessions for the search application
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   fromDateYear: int
  ##               : Year of date. Must be from 1 to 9999.
  ##   fromDateDay: int
  ##              : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource id of the search application session stats, in the following
  ## format: searchapplications/{application_id}
  ##   toDateDay: int
  ##            : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   toDateYear: int
  ##             : Year of date. Must be from 1 to 9999.
  ##   callback: string
  ##           : JSONP
  ##   fromDateMonth: int
  ##                : Month of date. Must be from 1 to 12.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   toDateMonth: int
  ##              : Month of date. Must be from 1 to 12.
  var path_580641 = newJObject()
  var query_580642 = newJObject()
  add(query_580642, "key", newJString(key))
  add(query_580642, "prettyPrint", newJBool(prettyPrint))
  add(query_580642, "oauth_token", newJString(oauthToken))
  add(query_580642, "$.xgafv", newJString(Xgafv))
  add(query_580642, "fromDate.year", newJInt(fromDateYear))
  add(query_580642, "fromDate.day", newJInt(fromDateDay))
  add(query_580642, "alt", newJString(alt))
  add(query_580642, "uploadType", newJString(uploadType))
  add(query_580642, "quotaUser", newJString(quotaUser))
  add(path_580641, "name", newJString(name))
  add(query_580642, "toDate.day", newJInt(toDateDay))
  add(query_580642, "toDate.year", newJInt(toDateYear))
  add(query_580642, "callback", newJString(callback))
  add(query_580642, "fromDate.month", newJInt(fromDateMonth))
  add(query_580642, "fields", newJString(fields))
  add(query_580642, "access_token", newJString(accessToken))
  add(query_580642, "upload_protocol", newJString(uploadProtocol))
  add(query_580642, "toDate.month", newJInt(toDateMonth))
  result = call_580640.call(path_580641, query_580642, nil, nil, nil)

var cloudsearchStatsSessionSearchapplicationsGet* = Call_CloudsearchStatsSessionSearchapplicationsGet_580618(
    name: "cloudsearchStatsSessionSearchapplicationsGet",
    meth: HttpMethod.HttpGet, host: "cloudsearch.googleapis.com",
    route: "/v1/stats/session/{name}",
    validator: validate_CloudsearchStatsSessionSearchapplicationsGet_580619,
    base: "/", url: url_CloudsearchStatsSessionSearchapplicationsGet_580620,
    schemes: {Scheme.Https})
type
  Call_CloudsearchStatsGetUser_580643 = ref object of OpenApiRestCall_579373
proc url_CloudsearchStatsGetUser_580645(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_CloudsearchStatsGetUser_580644(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the users statistics for customer
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
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   fromDate.year: JInt
  ##                : Year of date. Must be from 1 to 9999.
  ##   fromDate.day: JInt
  ##               : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   toDate.day: JInt
  ##             : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   toDate.year: JInt
  ##              : Year of date. Must be from 1 to 9999.
  ##   callback: JString
  ##           : JSONP
  ##   fromDate.month: JInt
  ##                 : Month of date. Must be from 1 to 12.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   toDate.month: JInt
  ##               : Month of date. Must be from 1 to 12.
  section = newJObject()
  var valid_580646 = query.getOrDefault("key")
  valid_580646 = validateParameter(valid_580646, JString, required = false,
                                 default = nil)
  if valid_580646 != nil:
    section.add "key", valid_580646
  var valid_580647 = query.getOrDefault("prettyPrint")
  valid_580647 = validateParameter(valid_580647, JBool, required = false,
                                 default = newJBool(true))
  if valid_580647 != nil:
    section.add "prettyPrint", valid_580647
  var valid_580648 = query.getOrDefault("oauth_token")
  valid_580648 = validateParameter(valid_580648, JString, required = false,
                                 default = nil)
  if valid_580648 != nil:
    section.add "oauth_token", valid_580648
  var valid_580649 = query.getOrDefault("$.xgafv")
  valid_580649 = validateParameter(valid_580649, JString, required = false,
                                 default = newJString("1"))
  if valid_580649 != nil:
    section.add "$.xgafv", valid_580649
  var valid_580650 = query.getOrDefault("fromDate.year")
  valid_580650 = validateParameter(valid_580650, JInt, required = false, default = nil)
  if valid_580650 != nil:
    section.add "fromDate.year", valid_580650
  var valid_580651 = query.getOrDefault("fromDate.day")
  valid_580651 = validateParameter(valid_580651, JInt, required = false, default = nil)
  if valid_580651 != nil:
    section.add "fromDate.day", valid_580651
  var valid_580652 = query.getOrDefault("alt")
  valid_580652 = validateParameter(valid_580652, JString, required = false,
                                 default = newJString("json"))
  if valid_580652 != nil:
    section.add "alt", valid_580652
  var valid_580653 = query.getOrDefault("uploadType")
  valid_580653 = validateParameter(valid_580653, JString, required = false,
                                 default = nil)
  if valid_580653 != nil:
    section.add "uploadType", valid_580653
  var valid_580654 = query.getOrDefault("quotaUser")
  valid_580654 = validateParameter(valid_580654, JString, required = false,
                                 default = nil)
  if valid_580654 != nil:
    section.add "quotaUser", valid_580654
  var valid_580655 = query.getOrDefault("toDate.day")
  valid_580655 = validateParameter(valid_580655, JInt, required = false, default = nil)
  if valid_580655 != nil:
    section.add "toDate.day", valid_580655
  var valid_580656 = query.getOrDefault("toDate.year")
  valid_580656 = validateParameter(valid_580656, JInt, required = false, default = nil)
  if valid_580656 != nil:
    section.add "toDate.year", valid_580656
  var valid_580657 = query.getOrDefault("callback")
  valid_580657 = validateParameter(valid_580657, JString, required = false,
                                 default = nil)
  if valid_580657 != nil:
    section.add "callback", valid_580657
  var valid_580658 = query.getOrDefault("fromDate.month")
  valid_580658 = validateParameter(valid_580658, JInt, required = false, default = nil)
  if valid_580658 != nil:
    section.add "fromDate.month", valid_580658
  var valid_580659 = query.getOrDefault("fields")
  valid_580659 = validateParameter(valid_580659, JString, required = false,
                                 default = nil)
  if valid_580659 != nil:
    section.add "fields", valid_580659
  var valid_580660 = query.getOrDefault("access_token")
  valid_580660 = validateParameter(valid_580660, JString, required = false,
                                 default = nil)
  if valid_580660 != nil:
    section.add "access_token", valid_580660
  var valid_580661 = query.getOrDefault("upload_protocol")
  valid_580661 = validateParameter(valid_580661, JString, required = false,
                                 default = nil)
  if valid_580661 != nil:
    section.add "upload_protocol", valid_580661
  var valid_580662 = query.getOrDefault("toDate.month")
  valid_580662 = validateParameter(valid_580662, JInt, required = false, default = nil)
  if valid_580662 != nil:
    section.add "toDate.month", valid_580662
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580663: Call_CloudsearchStatsGetUser_580643; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the users statistics for customer
  ## 
  let valid = call_580663.validator(path, query, header, formData, body)
  let scheme = call_580663.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580663.url(scheme.get, call_580663.host, call_580663.base,
                         call_580663.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580663, url, valid)

proc call*(call_580664: Call_CloudsearchStatsGetUser_580643; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          fromDateYear: int = 0; fromDateDay: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; toDateDay: int = 0;
          toDateYear: int = 0; callback: string = ""; fromDateMonth: int = 0;
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          toDateMonth: int = 0): Recallable =
  ## cloudsearchStatsGetUser
  ## Get the users statistics for customer
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   fromDateYear: int
  ##               : Year of date. Must be from 1 to 9999.
  ##   fromDateDay: int
  ##              : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   toDateDay: int
  ##            : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   toDateYear: int
  ##             : Year of date. Must be from 1 to 9999.
  ##   callback: string
  ##           : JSONP
  ##   fromDateMonth: int
  ##                : Month of date. Must be from 1 to 12.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   toDateMonth: int
  ##              : Month of date. Must be from 1 to 12.
  var query_580665 = newJObject()
  add(query_580665, "key", newJString(key))
  add(query_580665, "prettyPrint", newJBool(prettyPrint))
  add(query_580665, "oauth_token", newJString(oauthToken))
  add(query_580665, "$.xgafv", newJString(Xgafv))
  add(query_580665, "fromDate.year", newJInt(fromDateYear))
  add(query_580665, "fromDate.day", newJInt(fromDateDay))
  add(query_580665, "alt", newJString(alt))
  add(query_580665, "uploadType", newJString(uploadType))
  add(query_580665, "quotaUser", newJString(quotaUser))
  add(query_580665, "toDate.day", newJInt(toDateDay))
  add(query_580665, "toDate.year", newJInt(toDateYear))
  add(query_580665, "callback", newJString(callback))
  add(query_580665, "fromDate.month", newJInt(fromDateMonth))
  add(query_580665, "fields", newJString(fields))
  add(query_580665, "access_token", newJString(accessToken))
  add(query_580665, "upload_protocol", newJString(uploadProtocol))
  add(query_580665, "toDate.month", newJInt(toDateMonth))
  result = call_580664.call(nil, query_580665, nil, nil, nil)

var cloudsearchStatsGetUser* = Call_CloudsearchStatsGetUser_580643(
    name: "cloudsearchStatsGetUser", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/stats/user",
    validator: validate_CloudsearchStatsGetUser_580644, base: "/",
    url: url_CloudsearchStatsGetUser_580645, schemes: {Scheme.Https})
type
  Call_CloudsearchStatsUserSearchapplicationsGet_580666 = ref object of OpenApiRestCall_579373
proc url_CloudsearchStatsUserSearchapplicationsGet_580668(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/stats/user/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudsearchStatsUserSearchapplicationsGet_580667(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the users statistics for search application
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource id of the search application session stats, in the following
  ## format: searchapplications/{application_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580669 = path.getOrDefault("name")
  valid_580669 = validateParameter(valid_580669, JString, required = true,
                                 default = nil)
  if valid_580669 != nil:
    section.add "name", valid_580669
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
  ##   fromDate.year: JInt
  ##                : Year of date. Must be from 1 to 9999.
  ##   fromDate.day: JInt
  ##               : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   toDate.day: JInt
  ##             : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   toDate.year: JInt
  ##              : Year of date. Must be from 1 to 9999.
  ##   callback: JString
  ##           : JSONP
  ##   fromDate.month: JInt
  ##                 : Month of date. Must be from 1 to 12.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   toDate.month: JInt
  ##               : Month of date. Must be from 1 to 12.
  section = newJObject()
  var valid_580670 = query.getOrDefault("key")
  valid_580670 = validateParameter(valid_580670, JString, required = false,
                                 default = nil)
  if valid_580670 != nil:
    section.add "key", valid_580670
  var valid_580671 = query.getOrDefault("prettyPrint")
  valid_580671 = validateParameter(valid_580671, JBool, required = false,
                                 default = newJBool(true))
  if valid_580671 != nil:
    section.add "prettyPrint", valid_580671
  var valid_580672 = query.getOrDefault("oauth_token")
  valid_580672 = validateParameter(valid_580672, JString, required = false,
                                 default = nil)
  if valid_580672 != nil:
    section.add "oauth_token", valid_580672
  var valid_580673 = query.getOrDefault("$.xgafv")
  valid_580673 = validateParameter(valid_580673, JString, required = false,
                                 default = newJString("1"))
  if valid_580673 != nil:
    section.add "$.xgafv", valid_580673
  var valid_580674 = query.getOrDefault("fromDate.year")
  valid_580674 = validateParameter(valid_580674, JInt, required = false, default = nil)
  if valid_580674 != nil:
    section.add "fromDate.year", valid_580674
  var valid_580675 = query.getOrDefault("fromDate.day")
  valid_580675 = validateParameter(valid_580675, JInt, required = false, default = nil)
  if valid_580675 != nil:
    section.add "fromDate.day", valid_580675
  var valid_580676 = query.getOrDefault("alt")
  valid_580676 = validateParameter(valid_580676, JString, required = false,
                                 default = newJString("json"))
  if valid_580676 != nil:
    section.add "alt", valid_580676
  var valid_580677 = query.getOrDefault("uploadType")
  valid_580677 = validateParameter(valid_580677, JString, required = false,
                                 default = nil)
  if valid_580677 != nil:
    section.add "uploadType", valid_580677
  var valid_580678 = query.getOrDefault("quotaUser")
  valid_580678 = validateParameter(valid_580678, JString, required = false,
                                 default = nil)
  if valid_580678 != nil:
    section.add "quotaUser", valid_580678
  var valid_580679 = query.getOrDefault("toDate.day")
  valid_580679 = validateParameter(valid_580679, JInt, required = false, default = nil)
  if valid_580679 != nil:
    section.add "toDate.day", valid_580679
  var valid_580680 = query.getOrDefault("toDate.year")
  valid_580680 = validateParameter(valid_580680, JInt, required = false, default = nil)
  if valid_580680 != nil:
    section.add "toDate.year", valid_580680
  var valid_580681 = query.getOrDefault("callback")
  valid_580681 = validateParameter(valid_580681, JString, required = false,
                                 default = nil)
  if valid_580681 != nil:
    section.add "callback", valid_580681
  var valid_580682 = query.getOrDefault("fromDate.month")
  valid_580682 = validateParameter(valid_580682, JInt, required = false, default = nil)
  if valid_580682 != nil:
    section.add "fromDate.month", valid_580682
  var valid_580683 = query.getOrDefault("fields")
  valid_580683 = validateParameter(valid_580683, JString, required = false,
                                 default = nil)
  if valid_580683 != nil:
    section.add "fields", valid_580683
  var valid_580684 = query.getOrDefault("access_token")
  valid_580684 = validateParameter(valid_580684, JString, required = false,
                                 default = nil)
  if valid_580684 != nil:
    section.add "access_token", valid_580684
  var valid_580685 = query.getOrDefault("upload_protocol")
  valid_580685 = validateParameter(valid_580685, JString, required = false,
                                 default = nil)
  if valid_580685 != nil:
    section.add "upload_protocol", valid_580685
  var valid_580686 = query.getOrDefault("toDate.month")
  valid_580686 = validateParameter(valid_580686, JInt, required = false, default = nil)
  if valid_580686 != nil:
    section.add "toDate.month", valid_580686
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580687: Call_CloudsearchStatsUserSearchapplicationsGet_580666;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the users statistics for search application
  ## 
  let valid = call_580687.validator(path, query, header, formData, body)
  let scheme = call_580687.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580687.url(scheme.get, call_580687.host, call_580687.base,
                         call_580687.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580687, url, valid)

proc call*(call_580688: Call_CloudsearchStatsUserSearchapplicationsGet_580666;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; fromDateYear: int = 0;
          fromDateDay: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; toDateDay: int = 0; toDateYear: int = 0;
          callback: string = ""; fromDateMonth: int = 0; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""; toDateMonth: int = 0): Recallable =
  ## cloudsearchStatsUserSearchapplicationsGet
  ## Get the users statistics for search application
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   fromDateYear: int
  ##               : Year of date. Must be from 1 to 9999.
  ##   fromDateDay: int
  ##              : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource id of the search application session stats, in the following
  ## format: searchapplications/{application_id}
  ##   toDateDay: int
  ##            : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   toDateYear: int
  ##             : Year of date. Must be from 1 to 9999.
  ##   callback: string
  ##           : JSONP
  ##   fromDateMonth: int
  ##                : Month of date. Must be from 1 to 12.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   toDateMonth: int
  ##              : Month of date. Must be from 1 to 12.
  var path_580689 = newJObject()
  var query_580690 = newJObject()
  add(query_580690, "key", newJString(key))
  add(query_580690, "prettyPrint", newJBool(prettyPrint))
  add(query_580690, "oauth_token", newJString(oauthToken))
  add(query_580690, "$.xgafv", newJString(Xgafv))
  add(query_580690, "fromDate.year", newJInt(fromDateYear))
  add(query_580690, "fromDate.day", newJInt(fromDateDay))
  add(query_580690, "alt", newJString(alt))
  add(query_580690, "uploadType", newJString(uploadType))
  add(query_580690, "quotaUser", newJString(quotaUser))
  add(path_580689, "name", newJString(name))
  add(query_580690, "toDate.day", newJInt(toDateDay))
  add(query_580690, "toDate.year", newJInt(toDateYear))
  add(query_580690, "callback", newJString(callback))
  add(query_580690, "fromDate.month", newJInt(fromDateMonth))
  add(query_580690, "fields", newJString(fields))
  add(query_580690, "access_token", newJString(accessToken))
  add(query_580690, "upload_protocol", newJString(uploadProtocol))
  add(query_580690, "toDate.month", newJInt(toDateMonth))
  result = call_580688.call(path_580689, query_580690, nil, nil, nil)

var cloudsearchStatsUserSearchapplicationsGet* = Call_CloudsearchStatsUserSearchapplicationsGet_580666(
    name: "cloudsearchStatsUserSearchapplicationsGet", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/stats/user/{name}",
    validator: validate_CloudsearchStatsUserSearchapplicationsGet_580667,
    base: "/", url: url_CloudsearchStatsUserSearchapplicationsGet_580668,
    schemes: {Scheme.Https})
type
  Call_CloudsearchOperationsGet_580691 = ref object of OpenApiRestCall_579373
proc url_CloudsearchOperationsGet_580693(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudsearchOperationsGet_580692(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580694 = path.getOrDefault("name")
  valid_580694 = validateParameter(valid_580694, JString, required = true,
                                 default = nil)
  if valid_580694 != nil:
    section.add "name", valid_580694
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
  var valid_580695 = query.getOrDefault("key")
  valid_580695 = validateParameter(valid_580695, JString, required = false,
                                 default = nil)
  if valid_580695 != nil:
    section.add "key", valid_580695
  var valid_580696 = query.getOrDefault("prettyPrint")
  valid_580696 = validateParameter(valid_580696, JBool, required = false,
                                 default = newJBool(true))
  if valid_580696 != nil:
    section.add "prettyPrint", valid_580696
  var valid_580697 = query.getOrDefault("oauth_token")
  valid_580697 = validateParameter(valid_580697, JString, required = false,
                                 default = nil)
  if valid_580697 != nil:
    section.add "oauth_token", valid_580697
  var valid_580698 = query.getOrDefault("$.xgafv")
  valid_580698 = validateParameter(valid_580698, JString, required = false,
                                 default = newJString("1"))
  if valid_580698 != nil:
    section.add "$.xgafv", valid_580698
  var valid_580699 = query.getOrDefault("alt")
  valid_580699 = validateParameter(valid_580699, JString, required = false,
                                 default = newJString("json"))
  if valid_580699 != nil:
    section.add "alt", valid_580699
  var valid_580700 = query.getOrDefault("uploadType")
  valid_580700 = validateParameter(valid_580700, JString, required = false,
                                 default = nil)
  if valid_580700 != nil:
    section.add "uploadType", valid_580700
  var valid_580701 = query.getOrDefault("quotaUser")
  valid_580701 = validateParameter(valid_580701, JString, required = false,
                                 default = nil)
  if valid_580701 != nil:
    section.add "quotaUser", valid_580701
  var valid_580702 = query.getOrDefault("callback")
  valid_580702 = validateParameter(valid_580702, JString, required = false,
                                 default = nil)
  if valid_580702 != nil:
    section.add "callback", valid_580702
  var valid_580703 = query.getOrDefault("fields")
  valid_580703 = validateParameter(valid_580703, JString, required = false,
                                 default = nil)
  if valid_580703 != nil:
    section.add "fields", valid_580703
  var valid_580704 = query.getOrDefault("access_token")
  valid_580704 = validateParameter(valid_580704, JString, required = false,
                                 default = nil)
  if valid_580704 != nil:
    section.add "access_token", valid_580704
  var valid_580705 = query.getOrDefault("upload_protocol")
  valid_580705 = validateParameter(valid_580705, JString, required = false,
                                 default = nil)
  if valid_580705 != nil:
    section.add "upload_protocol", valid_580705
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580706: Call_CloudsearchOperationsGet_580691; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_580706.validator(path, query, header, formData, body)
  let scheme = call_580706.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580706.url(scheme.get, call_580706.host, call_580706.base,
                         call_580706.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580706, url, valid)

proc call*(call_580707: Call_CloudsearchOperationsGet_580691; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudsearchOperationsGet
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
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
  ##       : The name of the operation resource.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580708 = newJObject()
  var query_580709 = newJObject()
  add(query_580709, "key", newJString(key))
  add(query_580709, "prettyPrint", newJBool(prettyPrint))
  add(query_580709, "oauth_token", newJString(oauthToken))
  add(query_580709, "$.xgafv", newJString(Xgafv))
  add(query_580709, "alt", newJString(alt))
  add(query_580709, "uploadType", newJString(uploadType))
  add(query_580709, "quotaUser", newJString(quotaUser))
  add(path_580708, "name", newJString(name))
  add(query_580709, "callback", newJString(callback))
  add(query_580709, "fields", newJString(fields))
  add(query_580709, "access_token", newJString(accessToken))
  add(query_580709, "upload_protocol", newJString(uploadProtocol))
  result = call_580707.call(path_580708, query_580709, nil, nil, nil)

var cloudsearchOperationsGet* = Call_CloudsearchOperationsGet_580691(
    name: "cloudsearchOperationsGet", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudsearchOperationsGet_580692, base: "/",
    url: url_CloudsearchOperationsGet_580693, schemes: {Scheme.Https})
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
