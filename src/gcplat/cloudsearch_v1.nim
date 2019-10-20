
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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

  OpenApiRestCall_578348 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578348](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578348): Option[Scheme] {.used.} =
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
  Call_CloudsearchDebugDatasourcesItemsSearchByViewUrl_578619 = ref object of OpenApiRestCall_578348
proc url_CloudsearchDebugDatasourcesItemsSearchByViewUrl_578621(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_CloudsearchDebugDatasourcesItemsSearchByViewUrl_578620(
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
  var valid_578747 = path.getOrDefault("name")
  valid_578747 = validateParameter(valid_578747, JString, required = true,
                                 default = nil)
  if valid_578747 != nil:
    section.add "name", valid_578747
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
  var valid_578748 = query.getOrDefault("key")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "key", valid_578748
  var valid_578762 = query.getOrDefault("prettyPrint")
  valid_578762 = validateParameter(valid_578762, JBool, required = false,
                                 default = newJBool(true))
  if valid_578762 != nil:
    section.add "prettyPrint", valid_578762
  var valid_578763 = query.getOrDefault("oauth_token")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = nil)
  if valid_578763 != nil:
    section.add "oauth_token", valid_578763
  var valid_578764 = query.getOrDefault("$.xgafv")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = newJString("1"))
  if valid_578764 != nil:
    section.add "$.xgafv", valid_578764
  var valid_578765 = query.getOrDefault("alt")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = newJString("json"))
  if valid_578765 != nil:
    section.add "alt", valid_578765
  var valid_578766 = query.getOrDefault("uploadType")
  valid_578766 = validateParameter(valid_578766, JString, required = false,
                                 default = nil)
  if valid_578766 != nil:
    section.add "uploadType", valid_578766
  var valid_578767 = query.getOrDefault("quotaUser")
  valid_578767 = validateParameter(valid_578767, JString, required = false,
                                 default = nil)
  if valid_578767 != nil:
    section.add "quotaUser", valid_578767
  var valid_578768 = query.getOrDefault("callback")
  valid_578768 = validateParameter(valid_578768, JString, required = false,
                                 default = nil)
  if valid_578768 != nil:
    section.add "callback", valid_578768
  var valid_578769 = query.getOrDefault("fields")
  valid_578769 = validateParameter(valid_578769, JString, required = false,
                                 default = nil)
  if valid_578769 != nil:
    section.add "fields", valid_578769
  var valid_578770 = query.getOrDefault("access_token")
  valid_578770 = validateParameter(valid_578770, JString, required = false,
                                 default = nil)
  if valid_578770 != nil:
    section.add "access_token", valid_578770
  var valid_578771 = query.getOrDefault("upload_protocol")
  valid_578771 = validateParameter(valid_578771, JString, required = false,
                                 default = nil)
  if valid_578771 != nil:
    section.add "upload_protocol", valid_578771
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

proc call*(call_578795: Call_CloudsearchDebugDatasourcesItemsSearchByViewUrl_578619;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches the item whose viewUrl exactly matches that of the URL provided
  ## in the request.
  ## 
  let valid = call_578795.validator(path, query, header, formData, body)
  let scheme = call_578795.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578795.url(scheme.get, call_578795.host, call_578795.base,
                         call_578795.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578795, url, valid)

proc call*(call_578866: Call_CloudsearchDebugDatasourcesItemsSearchByViewUrl_578619;
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
  var path_578867 = newJObject()
  var query_578869 = newJObject()
  var body_578870 = newJObject()
  add(query_578869, "key", newJString(key))
  add(query_578869, "prettyPrint", newJBool(prettyPrint))
  add(query_578869, "oauth_token", newJString(oauthToken))
  add(query_578869, "$.xgafv", newJString(Xgafv))
  add(query_578869, "alt", newJString(alt))
  add(query_578869, "uploadType", newJString(uploadType))
  add(query_578869, "quotaUser", newJString(quotaUser))
  add(path_578867, "name", newJString(name))
  if body != nil:
    body_578870 = body
  add(query_578869, "callback", newJString(callback))
  add(query_578869, "fields", newJString(fields))
  add(query_578869, "access_token", newJString(accessToken))
  add(query_578869, "upload_protocol", newJString(uploadProtocol))
  result = call_578866.call(path_578867, query_578869, nil, nil, body_578870)

var cloudsearchDebugDatasourcesItemsSearchByViewUrl* = Call_CloudsearchDebugDatasourcesItemsSearchByViewUrl_578619(
    name: "cloudsearchDebugDatasourcesItemsSearchByViewUrl",
    meth: HttpMethod.HttpPost, host: "cloudsearch.googleapis.com",
    route: "/v1/debug/{name}/items:searchByViewUrl",
    validator: validate_CloudsearchDebugDatasourcesItemsSearchByViewUrl_578620,
    base: "/", url: url_CloudsearchDebugDatasourcesItemsSearchByViewUrl_578621,
    schemes: {Scheme.Https})
type
  Call_CloudsearchDebugDatasourcesItemsCheckAccess_578909 = ref object of OpenApiRestCall_578348
proc url_CloudsearchDebugDatasourcesItemsCheckAccess_578911(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_CloudsearchDebugDatasourcesItemsCheckAccess_578910(path: JsonNode;
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
  var valid_578912 = path.getOrDefault("name")
  valid_578912 = validateParameter(valid_578912, JString, required = true,
                                 default = nil)
  if valid_578912 != nil:
    section.add "name", valid_578912
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
  var valid_578913 = query.getOrDefault("key")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "key", valid_578913
  var valid_578914 = query.getOrDefault("debugOptions.enableDebugging")
  valid_578914 = validateParameter(valid_578914, JBool, required = false, default = nil)
  if valid_578914 != nil:
    section.add "debugOptions.enableDebugging", valid_578914
  var valid_578915 = query.getOrDefault("prettyPrint")
  valid_578915 = validateParameter(valid_578915, JBool, required = false,
                                 default = newJBool(true))
  if valid_578915 != nil:
    section.add "prettyPrint", valid_578915
  var valid_578916 = query.getOrDefault("oauth_token")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "oauth_token", valid_578916
  var valid_578917 = query.getOrDefault("$.xgafv")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = newJString("1"))
  if valid_578917 != nil:
    section.add "$.xgafv", valid_578917
  var valid_578918 = query.getOrDefault("alt")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = newJString("json"))
  if valid_578918 != nil:
    section.add "alt", valid_578918
  var valid_578919 = query.getOrDefault("uploadType")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "uploadType", valid_578919
  var valid_578920 = query.getOrDefault("quotaUser")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "quotaUser", valid_578920
  var valid_578921 = query.getOrDefault("callback")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "callback", valid_578921
  var valid_578922 = query.getOrDefault("fields")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "fields", valid_578922
  var valid_578923 = query.getOrDefault("access_token")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "access_token", valid_578923
  var valid_578924 = query.getOrDefault("upload_protocol")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "upload_protocol", valid_578924
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

proc call*(call_578926: Call_CloudsearchDebugDatasourcesItemsCheckAccess_578909;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether an item is accessible by specified principal.
  ## 
  let valid = call_578926.validator(path, query, header, formData, body)
  let scheme = call_578926.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578926.url(scheme.get, call_578926.host, call_578926.base,
                         call_578926.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578926, url, valid)

proc call*(call_578927: Call_CloudsearchDebugDatasourcesItemsCheckAccess_578909;
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
  var path_578928 = newJObject()
  var query_578929 = newJObject()
  var body_578930 = newJObject()
  add(query_578929, "key", newJString(key))
  add(query_578929, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_578929, "prettyPrint", newJBool(prettyPrint))
  add(query_578929, "oauth_token", newJString(oauthToken))
  add(query_578929, "$.xgafv", newJString(Xgafv))
  add(query_578929, "alt", newJString(alt))
  add(query_578929, "uploadType", newJString(uploadType))
  add(query_578929, "quotaUser", newJString(quotaUser))
  add(path_578928, "name", newJString(name))
  if body != nil:
    body_578930 = body
  add(query_578929, "callback", newJString(callback))
  add(query_578929, "fields", newJString(fields))
  add(query_578929, "access_token", newJString(accessToken))
  add(query_578929, "upload_protocol", newJString(uploadProtocol))
  result = call_578927.call(path_578928, query_578929, nil, nil, body_578930)

var cloudsearchDebugDatasourcesItemsCheckAccess* = Call_CloudsearchDebugDatasourcesItemsCheckAccess_578909(
    name: "cloudsearchDebugDatasourcesItemsCheckAccess",
    meth: HttpMethod.HttpPost, host: "cloudsearch.googleapis.com",
    route: "/v1/debug/{name}:checkAccess",
    validator: validate_CloudsearchDebugDatasourcesItemsCheckAccess_578910,
    base: "/", url: url_CloudsearchDebugDatasourcesItemsCheckAccess_578911,
    schemes: {Scheme.Https})
type
  Call_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_578931 = ref object of OpenApiRestCall_578348
proc url_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_578933(
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
  result.path = base & hydrated.get

proc validate_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_578932(
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
  var valid_578934 = path.getOrDefault("parent")
  valid_578934 = validateParameter(valid_578934, JString, required = true,
                                 default = nil)
  if valid_578934 != nil:
    section.add "parent", valid_578934
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
  var valid_578935 = query.getOrDefault("key")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "key", valid_578935
  var valid_578936 = query.getOrDefault("debugOptions.enableDebugging")
  valid_578936 = validateParameter(valid_578936, JBool, required = false, default = nil)
  if valid_578936 != nil:
    section.add "debugOptions.enableDebugging", valid_578936
  var valid_578937 = query.getOrDefault("prettyPrint")
  valid_578937 = validateParameter(valid_578937, JBool, required = false,
                                 default = newJBool(true))
  if valid_578937 != nil:
    section.add "prettyPrint", valid_578937
  var valid_578938 = query.getOrDefault("oauth_token")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "oauth_token", valid_578938
  var valid_578939 = query.getOrDefault("$.xgafv")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = newJString("1"))
  if valid_578939 != nil:
    section.add "$.xgafv", valid_578939
  var valid_578940 = query.getOrDefault("pageSize")
  valid_578940 = validateParameter(valid_578940, JInt, required = false, default = nil)
  if valid_578940 != nil:
    section.add "pageSize", valid_578940
  var valid_578941 = query.getOrDefault("alt")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = newJString("json"))
  if valid_578941 != nil:
    section.add "alt", valid_578941
  var valid_578942 = query.getOrDefault("uploadType")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "uploadType", valid_578942
  var valid_578943 = query.getOrDefault("quotaUser")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "quotaUser", valid_578943
  var valid_578944 = query.getOrDefault("groupResourceName")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "groupResourceName", valid_578944
  var valid_578945 = query.getOrDefault("pageToken")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "pageToken", valid_578945
  var valid_578946 = query.getOrDefault("userResourceName")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "userResourceName", valid_578946
  var valid_578947 = query.getOrDefault("callback")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "callback", valid_578947
  var valid_578948 = query.getOrDefault("fields")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "fields", valid_578948
  var valid_578949 = query.getOrDefault("access_token")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "access_token", valid_578949
  var valid_578950 = query.getOrDefault("upload_protocol")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "upload_protocol", valid_578950
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578951: Call_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_578931;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists names of items associated with an unmapped identity.
  ## 
  let valid = call_578951.validator(path, query, header, formData, body)
  let scheme = call_578951.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578951.url(scheme.get, call_578951.host, call_578951.base,
                         call_578951.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578951, url, valid)

proc call*(call_578952: Call_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_578931;
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
  var path_578953 = newJObject()
  var query_578954 = newJObject()
  add(query_578954, "key", newJString(key))
  add(query_578954, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_578954, "prettyPrint", newJBool(prettyPrint))
  add(query_578954, "oauth_token", newJString(oauthToken))
  add(query_578954, "$.xgafv", newJString(Xgafv))
  add(query_578954, "pageSize", newJInt(pageSize))
  add(query_578954, "alt", newJString(alt))
  add(query_578954, "uploadType", newJString(uploadType))
  add(query_578954, "quotaUser", newJString(quotaUser))
  add(query_578954, "groupResourceName", newJString(groupResourceName))
  add(query_578954, "pageToken", newJString(pageToken))
  add(query_578954, "userResourceName", newJString(userResourceName))
  add(query_578954, "callback", newJString(callback))
  add(path_578953, "parent", newJString(parent))
  add(query_578954, "fields", newJString(fields))
  add(query_578954, "access_token", newJString(accessToken))
  add(query_578954, "upload_protocol", newJString(uploadProtocol))
  result = call_578952.call(path_578953, query_578954, nil, nil, nil)

var cloudsearchDebugIdentitysourcesItemsListForunmappedidentity* = Call_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_578931(
    name: "cloudsearchDebugIdentitysourcesItemsListForunmappedidentity",
    meth: HttpMethod.HttpGet, host: "cloudsearch.googleapis.com",
    route: "/v1/debug/{parent}/items:forunmappedidentity", validator: validate_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_578932,
    base: "/",
    url: url_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_578933,
    schemes: {Scheme.Https})
type
  Call_CloudsearchDebugIdentitysourcesUnmappedidsList_578955 = ref object of OpenApiRestCall_578348
proc url_CloudsearchDebugIdentitysourcesUnmappedidsList_578957(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_CloudsearchDebugIdentitysourcesUnmappedidsList_578956(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists unmapped user identities for an identity source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the identity source, in the following format:
  ## identitysources/{source_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_578958 = path.getOrDefault("parent")
  valid_578958 = validateParameter(valid_578958, JString, required = true,
                                 default = nil)
  if valid_578958 != nil:
    section.add "parent", valid_578958
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
  var valid_578959 = query.getOrDefault("key")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "key", valid_578959
  var valid_578960 = query.getOrDefault("debugOptions.enableDebugging")
  valid_578960 = validateParameter(valid_578960, JBool, required = false, default = nil)
  if valid_578960 != nil:
    section.add "debugOptions.enableDebugging", valid_578960
  var valid_578961 = query.getOrDefault("prettyPrint")
  valid_578961 = validateParameter(valid_578961, JBool, required = false,
                                 default = newJBool(true))
  if valid_578961 != nil:
    section.add "prettyPrint", valid_578961
  var valid_578962 = query.getOrDefault("oauth_token")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "oauth_token", valid_578962
  var valid_578963 = query.getOrDefault("$.xgafv")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = newJString("1"))
  if valid_578963 != nil:
    section.add "$.xgafv", valid_578963
  var valid_578964 = query.getOrDefault("pageSize")
  valid_578964 = validateParameter(valid_578964, JInt, required = false, default = nil)
  if valid_578964 != nil:
    section.add "pageSize", valid_578964
  var valid_578965 = query.getOrDefault("alt")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = newJString("json"))
  if valid_578965 != nil:
    section.add "alt", valid_578965
  var valid_578966 = query.getOrDefault("uploadType")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "uploadType", valid_578966
  var valid_578967 = query.getOrDefault("quotaUser")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "quotaUser", valid_578967
  var valid_578968 = query.getOrDefault("pageToken")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "pageToken", valid_578968
  var valid_578969 = query.getOrDefault("callback")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "callback", valid_578969
  var valid_578970 = query.getOrDefault("resolutionStatusCode")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = newJString("CODE_UNSPECIFIED"))
  if valid_578970 != nil:
    section.add "resolutionStatusCode", valid_578970
  var valid_578971 = query.getOrDefault("fields")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "fields", valid_578971
  var valid_578972 = query.getOrDefault("access_token")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "access_token", valid_578972
  var valid_578973 = query.getOrDefault("upload_protocol")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "upload_protocol", valid_578973
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578974: Call_CloudsearchDebugIdentitysourcesUnmappedidsList_578955;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists unmapped user identities for an identity source.
  ## 
  let valid = call_578974.validator(path, query, header, formData, body)
  let scheme = call_578974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578974.url(scheme.get, call_578974.host, call_578974.base,
                         call_578974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578974, url, valid)

proc call*(call_578975: Call_CloudsearchDebugIdentitysourcesUnmappedidsList_578955;
          parent: string; key: string = ""; debugOptionsEnableDebugging: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; pageToken: string = ""; callback: string = "";
          resolutionStatusCode: string = "CODE_UNSPECIFIED"; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudsearchDebugIdentitysourcesUnmappedidsList
  ## Lists unmapped user identities for an identity source.
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
  ##         : The name of the identity source, in the following format:
  ## identitysources/{source_id}
  ##   resolutionStatusCode: string
  ##                       : Limit users selection to this status.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578976 = newJObject()
  var query_578977 = newJObject()
  add(query_578977, "key", newJString(key))
  add(query_578977, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_578977, "prettyPrint", newJBool(prettyPrint))
  add(query_578977, "oauth_token", newJString(oauthToken))
  add(query_578977, "$.xgafv", newJString(Xgafv))
  add(query_578977, "pageSize", newJInt(pageSize))
  add(query_578977, "alt", newJString(alt))
  add(query_578977, "uploadType", newJString(uploadType))
  add(query_578977, "quotaUser", newJString(quotaUser))
  add(query_578977, "pageToken", newJString(pageToken))
  add(query_578977, "callback", newJString(callback))
  add(path_578976, "parent", newJString(parent))
  add(query_578977, "resolutionStatusCode", newJString(resolutionStatusCode))
  add(query_578977, "fields", newJString(fields))
  add(query_578977, "access_token", newJString(accessToken))
  add(query_578977, "upload_protocol", newJString(uploadProtocol))
  result = call_578975.call(path_578976, query_578977, nil, nil, nil)

var cloudsearchDebugIdentitysourcesUnmappedidsList* = Call_CloudsearchDebugIdentitysourcesUnmappedidsList_578955(
    name: "cloudsearchDebugIdentitysourcesUnmappedidsList",
    meth: HttpMethod.HttpGet, host: "cloudsearch.googleapis.com",
    route: "/v1/debug/{parent}/unmappedids",
    validator: validate_CloudsearchDebugIdentitysourcesUnmappedidsList_578956,
    base: "/", url: url_CloudsearchDebugIdentitysourcesUnmappedidsList_578957,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsGet_578978 = ref object of OpenApiRestCall_578348
proc url_CloudsearchIndexingDatasourcesItemsGet_578980(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_CloudsearchIndexingDatasourcesItemsGet_578979(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets Item resource by item name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the item to get info.
  ## Format: datasources/{source_id}/items/{item_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578981 = path.getOrDefault("name")
  valid_578981 = validateParameter(valid_578981, JString, required = true,
                                 default = nil)
  if valid_578981 != nil:
    section.add "name", valid_578981
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
  var valid_578982 = query.getOrDefault("key")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "key", valid_578982
  var valid_578983 = query.getOrDefault("debugOptions.enableDebugging")
  valid_578983 = validateParameter(valid_578983, JBool, required = false, default = nil)
  if valid_578983 != nil:
    section.add "debugOptions.enableDebugging", valid_578983
  var valid_578984 = query.getOrDefault("prettyPrint")
  valid_578984 = validateParameter(valid_578984, JBool, required = false,
                                 default = newJBool(true))
  if valid_578984 != nil:
    section.add "prettyPrint", valid_578984
  var valid_578985 = query.getOrDefault("oauth_token")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "oauth_token", valid_578985
  var valid_578986 = query.getOrDefault("$.xgafv")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = newJString("1"))
  if valid_578986 != nil:
    section.add "$.xgafv", valid_578986
  var valid_578987 = query.getOrDefault("alt")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = newJString("json"))
  if valid_578987 != nil:
    section.add "alt", valid_578987
  var valid_578988 = query.getOrDefault("uploadType")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "uploadType", valid_578988
  var valid_578989 = query.getOrDefault("quotaUser")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "quotaUser", valid_578989
  var valid_578990 = query.getOrDefault("connectorName")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "connectorName", valid_578990
  var valid_578991 = query.getOrDefault("callback")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "callback", valid_578991
  var valid_578992 = query.getOrDefault("fields")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "fields", valid_578992
  var valid_578993 = query.getOrDefault("access_token")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "access_token", valid_578993
  var valid_578994 = query.getOrDefault("upload_protocol")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "upload_protocol", valid_578994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578995: Call_CloudsearchIndexingDatasourcesItemsGet_578978;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets Item resource by item name.
  ## 
  let valid = call_578995.validator(path, query, header, formData, body)
  let scheme = call_578995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578995.url(scheme.get, call_578995.host, call_578995.base,
                         call_578995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578995, url, valid)

proc call*(call_578996: Call_CloudsearchIndexingDatasourcesItemsGet_578978;
          name: string; key: string = ""; debugOptionsEnableDebugging: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          connectorName: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudsearchIndexingDatasourcesItemsGet
  ## Gets Item resource by item name.
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
  var path_578997 = newJObject()
  var query_578998 = newJObject()
  add(query_578998, "key", newJString(key))
  add(query_578998, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_578998, "prettyPrint", newJBool(prettyPrint))
  add(query_578998, "oauth_token", newJString(oauthToken))
  add(query_578998, "$.xgafv", newJString(Xgafv))
  add(query_578998, "alt", newJString(alt))
  add(query_578998, "uploadType", newJString(uploadType))
  add(query_578998, "quotaUser", newJString(quotaUser))
  add(path_578997, "name", newJString(name))
  add(query_578998, "connectorName", newJString(connectorName))
  add(query_578998, "callback", newJString(callback))
  add(query_578998, "fields", newJString(fields))
  add(query_578998, "access_token", newJString(accessToken))
  add(query_578998, "upload_protocol", newJString(uploadProtocol))
  result = call_578996.call(path_578997, query_578998, nil, nil, nil)

var cloudsearchIndexingDatasourcesItemsGet* = Call_CloudsearchIndexingDatasourcesItemsGet_578978(
    name: "cloudsearchIndexingDatasourcesItemsGet", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}",
    validator: validate_CloudsearchIndexingDatasourcesItemsGet_578979, base: "/",
    url: url_CloudsearchIndexingDatasourcesItemsGet_578980,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsDelete_578999 = ref object of OpenApiRestCall_578348
proc url_CloudsearchIndexingDatasourcesItemsDelete_579001(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_CloudsearchIndexingDatasourcesItemsDelete_579000(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes Item resource for the
  ## specified resource name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. Name of the item to delete.
  ## Format: datasources/{source_id}/items/{item_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579002 = path.getOrDefault("name")
  valid_579002 = validateParameter(valid_579002, JString, required = true,
                                 default = nil)
  if valid_579002 != nil:
    section.add "name", valid_579002
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
  var valid_579003 = query.getOrDefault("key")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "key", valid_579003
  var valid_579004 = query.getOrDefault("debugOptions.enableDebugging")
  valid_579004 = validateParameter(valid_579004, JBool, required = false, default = nil)
  if valid_579004 != nil:
    section.add "debugOptions.enableDebugging", valid_579004
  var valid_579005 = query.getOrDefault("prettyPrint")
  valid_579005 = validateParameter(valid_579005, JBool, required = false,
                                 default = newJBool(true))
  if valid_579005 != nil:
    section.add "prettyPrint", valid_579005
  var valid_579006 = query.getOrDefault("oauth_token")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "oauth_token", valid_579006
  var valid_579007 = query.getOrDefault("$.xgafv")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = newJString("1"))
  if valid_579007 != nil:
    section.add "$.xgafv", valid_579007
  var valid_579008 = query.getOrDefault("mode")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = newJString("UNSPECIFIED"))
  if valid_579008 != nil:
    section.add "mode", valid_579008
  var valid_579009 = query.getOrDefault("alt")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = newJString("json"))
  if valid_579009 != nil:
    section.add "alt", valid_579009
  var valid_579010 = query.getOrDefault("uploadType")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "uploadType", valid_579010
  var valid_579011 = query.getOrDefault("version")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "version", valid_579011
  var valid_579012 = query.getOrDefault("quotaUser")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "quotaUser", valid_579012
  var valid_579013 = query.getOrDefault("connectorName")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "connectorName", valid_579013
  var valid_579014 = query.getOrDefault("callback")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "callback", valid_579014
  var valid_579015 = query.getOrDefault("fields")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "fields", valid_579015
  var valid_579016 = query.getOrDefault("access_token")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "access_token", valid_579016
  var valid_579017 = query.getOrDefault("upload_protocol")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "upload_protocol", valid_579017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579018: Call_CloudsearchIndexingDatasourcesItemsDelete_578999;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes Item resource for the
  ## specified resource name.
  ## 
  let valid = call_579018.validator(path, query, header, formData, body)
  let scheme = call_579018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579018.url(scheme.get, call_579018.host, call_579018.base,
                         call_579018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579018, url, valid)

proc call*(call_579019: Call_CloudsearchIndexingDatasourcesItemsDelete_578999;
          name: string; key: string = ""; debugOptionsEnableDebugging: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          mode: string = "UNSPECIFIED"; alt: string = "json"; uploadType: string = "";
          version: string = ""; quotaUser: string = ""; connectorName: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudsearchIndexingDatasourcesItemsDelete
  ## Deletes Item resource for the
  ## specified resource name.
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
  var path_579020 = newJObject()
  var query_579021 = newJObject()
  add(query_579021, "key", newJString(key))
  add(query_579021, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_579021, "prettyPrint", newJBool(prettyPrint))
  add(query_579021, "oauth_token", newJString(oauthToken))
  add(query_579021, "$.xgafv", newJString(Xgafv))
  add(query_579021, "mode", newJString(mode))
  add(query_579021, "alt", newJString(alt))
  add(query_579021, "uploadType", newJString(uploadType))
  add(query_579021, "version", newJString(version))
  add(query_579021, "quotaUser", newJString(quotaUser))
  add(path_579020, "name", newJString(name))
  add(query_579021, "connectorName", newJString(connectorName))
  add(query_579021, "callback", newJString(callback))
  add(query_579021, "fields", newJString(fields))
  add(query_579021, "access_token", newJString(accessToken))
  add(query_579021, "upload_protocol", newJString(uploadProtocol))
  result = call_579019.call(path_579020, query_579021, nil, nil, nil)

var cloudsearchIndexingDatasourcesItemsDelete* = Call_CloudsearchIndexingDatasourcesItemsDelete_578999(
    name: "cloudsearchIndexingDatasourcesItemsDelete",
    meth: HttpMethod.HttpDelete, host: "cloudsearch.googleapis.com",
    route: "/v1/indexing/{name}",
    validator: validate_CloudsearchIndexingDatasourcesItemsDelete_579000,
    base: "/", url: url_CloudsearchIndexingDatasourcesItemsDelete_579001,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsList_579022 = ref object of OpenApiRestCall_578348
proc url_CloudsearchIndexingDatasourcesItemsList_579024(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_CloudsearchIndexingDatasourcesItemsList_579023(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all or a subset of Item resources.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the Data Source to list Items.  Format:
  ## datasources/{source_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579025 = path.getOrDefault("name")
  valid_579025 = validateParameter(valid_579025, JString, required = true,
                                 default = nil)
  if valid_579025 != nil:
    section.add "name", valid_579025
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
  ## metadata.hash,
  ## structured_data.hash,
  ## content.hash.
  ## <br />If this value is false, then all the fields are populated in Item.
  section = newJObject()
  var valid_579026 = query.getOrDefault("key")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "key", valid_579026
  var valid_579027 = query.getOrDefault("debugOptions.enableDebugging")
  valid_579027 = validateParameter(valid_579027, JBool, required = false, default = nil)
  if valid_579027 != nil:
    section.add "debugOptions.enableDebugging", valid_579027
  var valid_579028 = query.getOrDefault("prettyPrint")
  valid_579028 = validateParameter(valid_579028, JBool, required = false,
                                 default = newJBool(true))
  if valid_579028 != nil:
    section.add "prettyPrint", valid_579028
  var valid_579029 = query.getOrDefault("oauth_token")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "oauth_token", valid_579029
  var valid_579030 = query.getOrDefault("$.xgafv")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = newJString("1"))
  if valid_579030 != nil:
    section.add "$.xgafv", valid_579030
  var valid_579031 = query.getOrDefault("pageSize")
  valid_579031 = validateParameter(valid_579031, JInt, required = false, default = nil)
  if valid_579031 != nil:
    section.add "pageSize", valid_579031
  var valid_579032 = query.getOrDefault("alt")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = newJString("json"))
  if valid_579032 != nil:
    section.add "alt", valid_579032
  var valid_579033 = query.getOrDefault("uploadType")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "uploadType", valid_579033
  var valid_579034 = query.getOrDefault("quotaUser")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "quotaUser", valid_579034
  var valid_579035 = query.getOrDefault("connectorName")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "connectorName", valid_579035
  var valid_579036 = query.getOrDefault("pageToken")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "pageToken", valid_579036
  var valid_579037 = query.getOrDefault("callback")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "callback", valid_579037
  var valid_579038 = query.getOrDefault("fields")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "fields", valid_579038
  var valid_579039 = query.getOrDefault("access_token")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "access_token", valid_579039
  var valid_579040 = query.getOrDefault("upload_protocol")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "upload_protocol", valid_579040
  var valid_579041 = query.getOrDefault("brief")
  valid_579041 = validateParameter(valid_579041, JBool, required = false, default = nil)
  if valid_579041 != nil:
    section.add "brief", valid_579041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579042: Call_CloudsearchIndexingDatasourcesItemsList_579022;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all or a subset of Item resources.
  ## 
  let valid = call_579042.validator(path, query, header, formData, body)
  let scheme = call_579042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579042.url(scheme.get, call_579042.host, call_579042.base,
                         call_579042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579042, url, valid)

proc call*(call_579043: Call_CloudsearchIndexingDatasourcesItemsList_579022;
          name: string; key: string = ""; debugOptionsEnableDebugging: bool = false;
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; connectorName: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; brief: bool = false): Recallable =
  ## cloudsearchIndexingDatasourcesItemsList
  ## Lists all or a subset of Item resources.
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
  ## metadata.hash,
  ## structured_data.hash,
  ## content.hash.
  ## <br />If this value is false, then all the fields are populated in Item.
  var path_579044 = newJObject()
  var query_579045 = newJObject()
  add(query_579045, "key", newJString(key))
  add(query_579045, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_579045, "prettyPrint", newJBool(prettyPrint))
  add(query_579045, "oauth_token", newJString(oauthToken))
  add(query_579045, "$.xgafv", newJString(Xgafv))
  add(query_579045, "pageSize", newJInt(pageSize))
  add(query_579045, "alt", newJString(alt))
  add(query_579045, "uploadType", newJString(uploadType))
  add(query_579045, "quotaUser", newJString(quotaUser))
  add(path_579044, "name", newJString(name))
  add(query_579045, "connectorName", newJString(connectorName))
  add(query_579045, "pageToken", newJString(pageToken))
  add(query_579045, "callback", newJString(callback))
  add(query_579045, "fields", newJString(fields))
  add(query_579045, "access_token", newJString(accessToken))
  add(query_579045, "upload_protocol", newJString(uploadProtocol))
  add(query_579045, "brief", newJBool(brief))
  result = call_579043.call(path_579044, query_579045, nil, nil, nil)

var cloudsearchIndexingDatasourcesItemsList* = Call_CloudsearchIndexingDatasourcesItemsList_579022(
    name: "cloudsearchIndexingDatasourcesItemsList", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}/items",
    validator: validate_CloudsearchIndexingDatasourcesItemsList_579023, base: "/",
    url: url_CloudsearchIndexingDatasourcesItemsList_579024,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_579046 = ref object of OpenApiRestCall_578348
proc url_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_579048(
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
  result.path = base & hydrated.get

proc validate_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_579047(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes all items in a queue. This method is useful for deleting stale
  ## items.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the Data Source to delete items in a queue.
  ## Format: datasources/{source_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579049 = path.getOrDefault("name")
  valid_579049 = validateParameter(valid_579049, JString, required = true,
                                 default = nil)
  if valid_579049 != nil:
    section.add "name", valid_579049
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
  var valid_579050 = query.getOrDefault("key")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "key", valid_579050
  var valid_579051 = query.getOrDefault("prettyPrint")
  valid_579051 = validateParameter(valid_579051, JBool, required = false,
                                 default = newJBool(true))
  if valid_579051 != nil:
    section.add "prettyPrint", valid_579051
  var valid_579052 = query.getOrDefault("oauth_token")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "oauth_token", valid_579052
  var valid_579053 = query.getOrDefault("$.xgafv")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = newJString("1"))
  if valid_579053 != nil:
    section.add "$.xgafv", valid_579053
  var valid_579054 = query.getOrDefault("alt")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = newJString("json"))
  if valid_579054 != nil:
    section.add "alt", valid_579054
  var valid_579055 = query.getOrDefault("uploadType")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "uploadType", valid_579055
  var valid_579056 = query.getOrDefault("quotaUser")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "quotaUser", valid_579056
  var valid_579057 = query.getOrDefault("callback")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "callback", valid_579057
  var valid_579058 = query.getOrDefault("fields")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "fields", valid_579058
  var valid_579059 = query.getOrDefault("access_token")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "access_token", valid_579059
  var valid_579060 = query.getOrDefault("upload_protocol")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "upload_protocol", valid_579060
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

proc call*(call_579062: Call_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_579046;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all items in a queue. This method is useful for deleting stale
  ## items.
  ## 
  let valid = call_579062.validator(path, query, header, formData, body)
  let scheme = call_579062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579062.url(scheme.get, call_579062.host, call_579062.base,
                         call_579062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579062, url, valid)

proc call*(call_579063: Call_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_579046;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudsearchIndexingDatasourcesItemsDeleteQueueItems
  ## Deletes all items in a queue. This method is useful for deleting stale
  ## items.
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
  var path_579064 = newJObject()
  var query_579065 = newJObject()
  var body_579066 = newJObject()
  add(query_579065, "key", newJString(key))
  add(query_579065, "prettyPrint", newJBool(prettyPrint))
  add(query_579065, "oauth_token", newJString(oauthToken))
  add(query_579065, "$.xgafv", newJString(Xgafv))
  add(query_579065, "alt", newJString(alt))
  add(query_579065, "uploadType", newJString(uploadType))
  add(query_579065, "quotaUser", newJString(quotaUser))
  add(path_579064, "name", newJString(name))
  if body != nil:
    body_579066 = body
  add(query_579065, "callback", newJString(callback))
  add(query_579065, "fields", newJString(fields))
  add(query_579065, "access_token", newJString(accessToken))
  add(query_579065, "upload_protocol", newJString(uploadProtocol))
  result = call_579063.call(path_579064, query_579065, nil, nil, body_579066)

var cloudsearchIndexingDatasourcesItemsDeleteQueueItems* = Call_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_579046(
    name: "cloudsearchIndexingDatasourcesItemsDeleteQueueItems",
    meth: HttpMethod.HttpPost, host: "cloudsearch.googleapis.com",
    route: "/v1/indexing/{name}/items:deleteQueueItems",
    validator: validate_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_579047,
    base: "/", url: url_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_579048,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsPoll_579067 = ref object of OpenApiRestCall_578348
proc url_CloudsearchIndexingDatasourcesItemsPoll_579069(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_CloudsearchIndexingDatasourcesItemsPoll_579068(path: JsonNode;
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
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the Data Source to poll items.
  ## Format: datasources/{source_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579070 = path.getOrDefault("name")
  valid_579070 = validateParameter(valid_579070, JString, required = true,
                                 default = nil)
  if valid_579070 != nil:
    section.add "name", valid_579070
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
  var valid_579071 = query.getOrDefault("key")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "key", valid_579071
  var valid_579072 = query.getOrDefault("prettyPrint")
  valid_579072 = validateParameter(valid_579072, JBool, required = false,
                                 default = newJBool(true))
  if valid_579072 != nil:
    section.add "prettyPrint", valid_579072
  var valid_579073 = query.getOrDefault("oauth_token")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "oauth_token", valid_579073
  var valid_579074 = query.getOrDefault("$.xgafv")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = newJString("1"))
  if valid_579074 != nil:
    section.add "$.xgafv", valid_579074
  var valid_579075 = query.getOrDefault("alt")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = newJString("json"))
  if valid_579075 != nil:
    section.add "alt", valid_579075
  var valid_579076 = query.getOrDefault("uploadType")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "uploadType", valid_579076
  var valid_579077 = query.getOrDefault("quotaUser")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "quotaUser", valid_579077
  var valid_579078 = query.getOrDefault("callback")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "callback", valid_579078
  var valid_579079 = query.getOrDefault("fields")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "fields", valid_579079
  var valid_579080 = query.getOrDefault("access_token")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "access_token", valid_579080
  var valid_579081 = query.getOrDefault("upload_protocol")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "upload_protocol", valid_579081
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

proc call*(call_579083: Call_CloudsearchIndexingDatasourcesItemsPoll_579067;
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
  let valid = call_579083.validator(path, query, header, formData, body)
  let scheme = call_579083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579083.url(scheme.get, call_579083.host, call_579083.base,
                         call_579083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579083, url, valid)

proc call*(call_579084: Call_CloudsearchIndexingDatasourcesItemsPoll_579067;
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
  var path_579085 = newJObject()
  var query_579086 = newJObject()
  var body_579087 = newJObject()
  add(query_579086, "key", newJString(key))
  add(query_579086, "prettyPrint", newJBool(prettyPrint))
  add(query_579086, "oauth_token", newJString(oauthToken))
  add(query_579086, "$.xgafv", newJString(Xgafv))
  add(query_579086, "alt", newJString(alt))
  add(query_579086, "uploadType", newJString(uploadType))
  add(query_579086, "quotaUser", newJString(quotaUser))
  add(path_579085, "name", newJString(name))
  if body != nil:
    body_579087 = body
  add(query_579086, "callback", newJString(callback))
  add(query_579086, "fields", newJString(fields))
  add(query_579086, "access_token", newJString(accessToken))
  add(query_579086, "upload_protocol", newJString(uploadProtocol))
  result = call_579084.call(path_579085, query_579086, nil, nil, body_579087)

var cloudsearchIndexingDatasourcesItemsPoll* = Call_CloudsearchIndexingDatasourcesItemsPoll_579067(
    name: "cloudsearchIndexingDatasourcesItemsPoll", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}/items:poll",
    validator: validate_CloudsearchIndexingDatasourcesItemsPoll_579068, base: "/",
    url: url_CloudsearchIndexingDatasourcesItemsPoll_579069,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsUnreserve_579088 = ref object of OpenApiRestCall_578348
proc url_CloudsearchIndexingDatasourcesItemsUnreserve_579090(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_CloudsearchIndexingDatasourcesItemsUnreserve_579089(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Unreserves all items from a queue, making them all eligible to be
  ## polled.  This method is useful for resetting the indexing queue
  ## after a connector has been restarted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the Data Source to unreserve all items.
  ## Format: datasources/{source_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579091 = path.getOrDefault("name")
  valid_579091 = validateParameter(valid_579091, JString, required = true,
                                 default = nil)
  if valid_579091 != nil:
    section.add "name", valid_579091
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
  var valid_579092 = query.getOrDefault("key")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "key", valid_579092
  var valid_579093 = query.getOrDefault("prettyPrint")
  valid_579093 = validateParameter(valid_579093, JBool, required = false,
                                 default = newJBool(true))
  if valid_579093 != nil:
    section.add "prettyPrint", valid_579093
  var valid_579094 = query.getOrDefault("oauth_token")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "oauth_token", valid_579094
  var valid_579095 = query.getOrDefault("$.xgafv")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = newJString("1"))
  if valid_579095 != nil:
    section.add "$.xgafv", valid_579095
  var valid_579096 = query.getOrDefault("alt")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = newJString("json"))
  if valid_579096 != nil:
    section.add "alt", valid_579096
  var valid_579097 = query.getOrDefault("uploadType")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "uploadType", valid_579097
  var valid_579098 = query.getOrDefault("quotaUser")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "quotaUser", valid_579098
  var valid_579099 = query.getOrDefault("callback")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "callback", valid_579099
  var valid_579100 = query.getOrDefault("fields")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "fields", valid_579100
  var valid_579101 = query.getOrDefault("access_token")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "access_token", valid_579101
  var valid_579102 = query.getOrDefault("upload_protocol")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "upload_protocol", valid_579102
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

proc call*(call_579104: Call_CloudsearchIndexingDatasourcesItemsUnreserve_579088;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unreserves all items from a queue, making them all eligible to be
  ## polled.  This method is useful for resetting the indexing queue
  ## after a connector has been restarted.
  ## 
  let valid = call_579104.validator(path, query, header, formData, body)
  let scheme = call_579104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579104.url(scheme.get, call_579104.host, call_579104.base,
                         call_579104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579104, url, valid)

proc call*(call_579105: Call_CloudsearchIndexingDatasourcesItemsUnreserve_579088;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudsearchIndexingDatasourcesItemsUnreserve
  ## Unreserves all items from a queue, making them all eligible to be
  ## polled.  This method is useful for resetting the indexing queue
  ## after a connector has been restarted.
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
  var path_579106 = newJObject()
  var query_579107 = newJObject()
  var body_579108 = newJObject()
  add(query_579107, "key", newJString(key))
  add(query_579107, "prettyPrint", newJBool(prettyPrint))
  add(query_579107, "oauth_token", newJString(oauthToken))
  add(query_579107, "$.xgafv", newJString(Xgafv))
  add(query_579107, "alt", newJString(alt))
  add(query_579107, "uploadType", newJString(uploadType))
  add(query_579107, "quotaUser", newJString(quotaUser))
  add(path_579106, "name", newJString(name))
  if body != nil:
    body_579108 = body
  add(query_579107, "callback", newJString(callback))
  add(query_579107, "fields", newJString(fields))
  add(query_579107, "access_token", newJString(accessToken))
  add(query_579107, "upload_protocol", newJString(uploadProtocol))
  result = call_579105.call(path_579106, query_579107, nil, nil, body_579108)

var cloudsearchIndexingDatasourcesItemsUnreserve* = Call_CloudsearchIndexingDatasourcesItemsUnreserve_579088(
    name: "cloudsearchIndexingDatasourcesItemsUnreserve",
    meth: HttpMethod.HttpPost, host: "cloudsearch.googleapis.com",
    route: "/v1/indexing/{name}/items:unreserve",
    validator: validate_CloudsearchIndexingDatasourcesItemsUnreserve_579089,
    base: "/", url: url_CloudsearchIndexingDatasourcesItemsUnreserve_579090,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesUpdateSchema_579129 = ref object of OpenApiRestCall_578348
proc url_CloudsearchIndexingDatasourcesUpdateSchema_579131(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_CloudsearchIndexingDatasourcesUpdateSchema_579130(path: JsonNode;
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
  var valid_579132 = path.getOrDefault("name")
  valid_579132 = validateParameter(valid_579132, JString, required = true,
                                 default = nil)
  if valid_579132 != nil:
    section.add "name", valid_579132
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
  var valid_579133 = query.getOrDefault("key")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = nil)
  if valid_579133 != nil:
    section.add "key", valid_579133
  var valid_579134 = query.getOrDefault("prettyPrint")
  valid_579134 = validateParameter(valid_579134, JBool, required = false,
                                 default = newJBool(true))
  if valid_579134 != nil:
    section.add "prettyPrint", valid_579134
  var valid_579135 = query.getOrDefault("oauth_token")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "oauth_token", valid_579135
  var valid_579136 = query.getOrDefault("$.xgafv")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = newJString("1"))
  if valid_579136 != nil:
    section.add "$.xgafv", valid_579136
  var valid_579137 = query.getOrDefault("alt")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = newJString("json"))
  if valid_579137 != nil:
    section.add "alt", valid_579137
  var valid_579138 = query.getOrDefault("uploadType")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "uploadType", valid_579138
  var valid_579139 = query.getOrDefault("quotaUser")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "quotaUser", valid_579139
  var valid_579140 = query.getOrDefault("callback")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = nil)
  if valid_579140 != nil:
    section.add "callback", valid_579140
  var valid_579141 = query.getOrDefault("fields")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "fields", valid_579141
  var valid_579142 = query.getOrDefault("access_token")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "access_token", valid_579142
  var valid_579143 = query.getOrDefault("upload_protocol")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "upload_protocol", valid_579143
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

proc call*(call_579145: Call_CloudsearchIndexingDatasourcesUpdateSchema_579129;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the schema of a data source.
  ## 
  let valid = call_579145.validator(path, query, header, formData, body)
  let scheme = call_579145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579145.url(scheme.get, call_579145.host, call_579145.base,
                         call_579145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579145, url, valid)

proc call*(call_579146: Call_CloudsearchIndexingDatasourcesUpdateSchema_579129;
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
  var path_579147 = newJObject()
  var query_579148 = newJObject()
  var body_579149 = newJObject()
  add(query_579148, "key", newJString(key))
  add(query_579148, "prettyPrint", newJBool(prettyPrint))
  add(query_579148, "oauth_token", newJString(oauthToken))
  add(query_579148, "$.xgafv", newJString(Xgafv))
  add(query_579148, "alt", newJString(alt))
  add(query_579148, "uploadType", newJString(uploadType))
  add(query_579148, "quotaUser", newJString(quotaUser))
  add(path_579147, "name", newJString(name))
  if body != nil:
    body_579149 = body
  add(query_579148, "callback", newJString(callback))
  add(query_579148, "fields", newJString(fields))
  add(query_579148, "access_token", newJString(accessToken))
  add(query_579148, "upload_protocol", newJString(uploadProtocol))
  result = call_579146.call(path_579147, query_579148, nil, nil, body_579149)

var cloudsearchIndexingDatasourcesUpdateSchema* = Call_CloudsearchIndexingDatasourcesUpdateSchema_579129(
    name: "cloudsearchIndexingDatasourcesUpdateSchema", meth: HttpMethod.HttpPut,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}/schema",
    validator: validate_CloudsearchIndexingDatasourcesUpdateSchema_579130,
    base: "/", url: url_CloudsearchIndexingDatasourcesUpdateSchema_579131,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesGetSchema_579109 = ref object of OpenApiRestCall_578348
proc url_CloudsearchIndexingDatasourcesGetSchema_579111(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_CloudsearchIndexingDatasourcesGetSchema_579110(path: JsonNode;
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
  var valid_579112 = path.getOrDefault("name")
  valid_579112 = validateParameter(valid_579112, JString, required = true,
                                 default = nil)
  if valid_579112 != nil:
    section.add "name", valid_579112
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
  var valid_579113 = query.getOrDefault("key")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "key", valid_579113
  var valid_579114 = query.getOrDefault("debugOptions.enableDebugging")
  valid_579114 = validateParameter(valid_579114, JBool, required = false, default = nil)
  if valid_579114 != nil:
    section.add "debugOptions.enableDebugging", valid_579114
  var valid_579115 = query.getOrDefault("prettyPrint")
  valid_579115 = validateParameter(valid_579115, JBool, required = false,
                                 default = newJBool(true))
  if valid_579115 != nil:
    section.add "prettyPrint", valid_579115
  var valid_579116 = query.getOrDefault("oauth_token")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "oauth_token", valid_579116
  var valid_579117 = query.getOrDefault("$.xgafv")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = newJString("1"))
  if valid_579117 != nil:
    section.add "$.xgafv", valid_579117
  var valid_579118 = query.getOrDefault("alt")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = newJString("json"))
  if valid_579118 != nil:
    section.add "alt", valid_579118
  var valid_579119 = query.getOrDefault("uploadType")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "uploadType", valid_579119
  var valid_579120 = query.getOrDefault("quotaUser")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "quotaUser", valid_579120
  var valid_579121 = query.getOrDefault("callback")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "callback", valid_579121
  var valid_579122 = query.getOrDefault("fields")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "fields", valid_579122
  var valid_579123 = query.getOrDefault("access_token")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "access_token", valid_579123
  var valid_579124 = query.getOrDefault("upload_protocol")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "upload_protocol", valid_579124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579125: Call_CloudsearchIndexingDatasourcesGetSchema_579109;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the schema of a data source.
  ## 
  let valid = call_579125.validator(path, query, header, formData, body)
  let scheme = call_579125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579125.url(scheme.get, call_579125.host, call_579125.base,
                         call_579125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579125, url, valid)

proc call*(call_579126: Call_CloudsearchIndexingDatasourcesGetSchema_579109;
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
  var path_579127 = newJObject()
  var query_579128 = newJObject()
  add(query_579128, "key", newJString(key))
  add(query_579128, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_579128, "prettyPrint", newJBool(prettyPrint))
  add(query_579128, "oauth_token", newJString(oauthToken))
  add(query_579128, "$.xgafv", newJString(Xgafv))
  add(query_579128, "alt", newJString(alt))
  add(query_579128, "uploadType", newJString(uploadType))
  add(query_579128, "quotaUser", newJString(quotaUser))
  add(path_579127, "name", newJString(name))
  add(query_579128, "callback", newJString(callback))
  add(query_579128, "fields", newJString(fields))
  add(query_579128, "access_token", newJString(accessToken))
  add(query_579128, "upload_protocol", newJString(uploadProtocol))
  result = call_579126.call(path_579127, query_579128, nil, nil, nil)

var cloudsearchIndexingDatasourcesGetSchema* = Call_CloudsearchIndexingDatasourcesGetSchema_579109(
    name: "cloudsearchIndexingDatasourcesGetSchema", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}/schema",
    validator: validate_CloudsearchIndexingDatasourcesGetSchema_579110, base: "/",
    url: url_CloudsearchIndexingDatasourcesGetSchema_579111,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesDeleteSchema_579150 = ref object of OpenApiRestCall_578348
proc url_CloudsearchIndexingDatasourcesDeleteSchema_579152(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_CloudsearchIndexingDatasourcesDeleteSchema_579151(path: JsonNode;
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
  var valid_579153 = path.getOrDefault("name")
  valid_579153 = validateParameter(valid_579153, JString, required = true,
                                 default = nil)
  if valid_579153 != nil:
    section.add "name", valid_579153
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
  var valid_579154 = query.getOrDefault("key")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = nil)
  if valid_579154 != nil:
    section.add "key", valid_579154
  var valid_579155 = query.getOrDefault("debugOptions.enableDebugging")
  valid_579155 = validateParameter(valid_579155, JBool, required = false, default = nil)
  if valid_579155 != nil:
    section.add "debugOptions.enableDebugging", valid_579155
  var valid_579156 = query.getOrDefault("prettyPrint")
  valid_579156 = validateParameter(valid_579156, JBool, required = false,
                                 default = newJBool(true))
  if valid_579156 != nil:
    section.add "prettyPrint", valid_579156
  var valid_579157 = query.getOrDefault("oauth_token")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = nil)
  if valid_579157 != nil:
    section.add "oauth_token", valid_579157
  var valid_579158 = query.getOrDefault("$.xgafv")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = newJString("1"))
  if valid_579158 != nil:
    section.add "$.xgafv", valid_579158
  var valid_579159 = query.getOrDefault("alt")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = newJString("json"))
  if valid_579159 != nil:
    section.add "alt", valid_579159
  var valid_579160 = query.getOrDefault("uploadType")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "uploadType", valid_579160
  var valid_579161 = query.getOrDefault("quotaUser")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = nil)
  if valid_579161 != nil:
    section.add "quotaUser", valid_579161
  var valid_579162 = query.getOrDefault("callback")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "callback", valid_579162
  var valid_579163 = query.getOrDefault("fields")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "fields", valid_579163
  var valid_579164 = query.getOrDefault("access_token")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "access_token", valid_579164
  var valid_579165 = query.getOrDefault("upload_protocol")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "upload_protocol", valid_579165
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579166: Call_CloudsearchIndexingDatasourcesDeleteSchema_579150;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the schema of a data source.
  ## 
  let valid = call_579166.validator(path, query, header, formData, body)
  let scheme = call_579166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579166.url(scheme.get, call_579166.host, call_579166.base,
                         call_579166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579166, url, valid)

proc call*(call_579167: Call_CloudsearchIndexingDatasourcesDeleteSchema_579150;
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
  var path_579168 = newJObject()
  var query_579169 = newJObject()
  add(query_579169, "key", newJString(key))
  add(query_579169, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_579169, "prettyPrint", newJBool(prettyPrint))
  add(query_579169, "oauth_token", newJString(oauthToken))
  add(query_579169, "$.xgafv", newJString(Xgafv))
  add(query_579169, "alt", newJString(alt))
  add(query_579169, "uploadType", newJString(uploadType))
  add(query_579169, "quotaUser", newJString(quotaUser))
  add(path_579168, "name", newJString(name))
  add(query_579169, "callback", newJString(callback))
  add(query_579169, "fields", newJString(fields))
  add(query_579169, "access_token", newJString(accessToken))
  add(query_579169, "upload_protocol", newJString(uploadProtocol))
  result = call_579167.call(path_579168, query_579169, nil, nil, nil)

var cloudsearchIndexingDatasourcesDeleteSchema* = Call_CloudsearchIndexingDatasourcesDeleteSchema_579150(
    name: "cloudsearchIndexingDatasourcesDeleteSchema",
    meth: HttpMethod.HttpDelete, host: "cloudsearch.googleapis.com",
    route: "/v1/indexing/{name}/schema",
    validator: validate_CloudsearchIndexingDatasourcesDeleteSchema_579151,
    base: "/", url: url_CloudsearchIndexingDatasourcesDeleteSchema_579152,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsIndex_579170 = ref object of OpenApiRestCall_578348
proc url_CloudsearchIndexingDatasourcesItemsIndex_579172(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_CloudsearchIndexingDatasourcesItemsIndex_579171(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates Item ACL, metadata, and
  ## content. It will insert the Item if it
  ## does not exist.
  ## This method does not support partial updates.  Fields with no provided
  ## values are cleared out in the Cloud Search index.
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
  var valid_579173 = path.getOrDefault("name")
  valid_579173 = validateParameter(valid_579173, JString, required = true,
                                 default = nil)
  if valid_579173 != nil:
    section.add "name", valid_579173
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
  var valid_579174 = query.getOrDefault("key")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "key", valid_579174
  var valid_579175 = query.getOrDefault("prettyPrint")
  valid_579175 = validateParameter(valid_579175, JBool, required = false,
                                 default = newJBool(true))
  if valid_579175 != nil:
    section.add "prettyPrint", valid_579175
  var valid_579176 = query.getOrDefault("oauth_token")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = nil)
  if valid_579176 != nil:
    section.add "oauth_token", valid_579176
  var valid_579177 = query.getOrDefault("$.xgafv")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = newJString("1"))
  if valid_579177 != nil:
    section.add "$.xgafv", valid_579177
  var valid_579178 = query.getOrDefault("alt")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = newJString("json"))
  if valid_579178 != nil:
    section.add "alt", valid_579178
  var valid_579179 = query.getOrDefault("uploadType")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "uploadType", valid_579179
  var valid_579180 = query.getOrDefault("quotaUser")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = nil)
  if valid_579180 != nil:
    section.add "quotaUser", valid_579180
  var valid_579181 = query.getOrDefault("callback")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "callback", valid_579181
  var valid_579182 = query.getOrDefault("fields")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = nil)
  if valid_579182 != nil:
    section.add "fields", valid_579182
  var valid_579183 = query.getOrDefault("access_token")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "access_token", valid_579183
  var valid_579184 = query.getOrDefault("upload_protocol")
  valid_579184 = validateParameter(valid_579184, JString, required = false,
                                 default = nil)
  if valid_579184 != nil:
    section.add "upload_protocol", valid_579184
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

proc call*(call_579186: Call_CloudsearchIndexingDatasourcesItemsIndex_579170;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates Item ACL, metadata, and
  ## content. It will insert the Item if it
  ## does not exist.
  ## This method does not support partial updates.  Fields with no provided
  ## values are cleared out in the Cloud Search index.
  ## 
  let valid = call_579186.validator(path, query, header, formData, body)
  let scheme = call_579186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579186.url(scheme.get, call_579186.host, call_579186.base,
                         call_579186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579186, url, valid)

proc call*(call_579187: Call_CloudsearchIndexingDatasourcesItemsIndex_579170;
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
  var path_579188 = newJObject()
  var query_579189 = newJObject()
  var body_579190 = newJObject()
  add(query_579189, "key", newJString(key))
  add(query_579189, "prettyPrint", newJBool(prettyPrint))
  add(query_579189, "oauth_token", newJString(oauthToken))
  add(query_579189, "$.xgafv", newJString(Xgafv))
  add(query_579189, "alt", newJString(alt))
  add(query_579189, "uploadType", newJString(uploadType))
  add(query_579189, "quotaUser", newJString(quotaUser))
  add(path_579188, "name", newJString(name))
  if body != nil:
    body_579190 = body
  add(query_579189, "callback", newJString(callback))
  add(query_579189, "fields", newJString(fields))
  add(query_579189, "access_token", newJString(accessToken))
  add(query_579189, "upload_protocol", newJString(uploadProtocol))
  result = call_579187.call(path_579188, query_579189, nil, nil, body_579190)

var cloudsearchIndexingDatasourcesItemsIndex* = Call_CloudsearchIndexingDatasourcesItemsIndex_579170(
    name: "cloudsearchIndexingDatasourcesItemsIndex", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}:index",
    validator: validate_CloudsearchIndexingDatasourcesItemsIndex_579171,
    base: "/", url: url_CloudsearchIndexingDatasourcesItemsIndex_579172,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsPush_579191 = ref object of OpenApiRestCall_578348
proc url_CloudsearchIndexingDatasourcesItemsPush_579193(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_CloudsearchIndexingDatasourcesItemsPush_579192(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Pushes an item onto a queue for later polling and updating.
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
  var valid_579194 = path.getOrDefault("name")
  valid_579194 = validateParameter(valid_579194, JString, required = true,
                                 default = nil)
  if valid_579194 != nil:
    section.add "name", valid_579194
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
  var valid_579195 = query.getOrDefault("key")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "key", valid_579195
  var valid_579196 = query.getOrDefault("prettyPrint")
  valid_579196 = validateParameter(valid_579196, JBool, required = false,
                                 default = newJBool(true))
  if valid_579196 != nil:
    section.add "prettyPrint", valid_579196
  var valid_579197 = query.getOrDefault("oauth_token")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = nil)
  if valid_579197 != nil:
    section.add "oauth_token", valid_579197
  var valid_579198 = query.getOrDefault("$.xgafv")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = newJString("1"))
  if valid_579198 != nil:
    section.add "$.xgafv", valid_579198
  var valid_579199 = query.getOrDefault("alt")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = newJString("json"))
  if valid_579199 != nil:
    section.add "alt", valid_579199
  var valid_579200 = query.getOrDefault("uploadType")
  valid_579200 = validateParameter(valid_579200, JString, required = false,
                                 default = nil)
  if valid_579200 != nil:
    section.add "uploadType", valid_579200
  var valid_579201 = query.getOrDefault("quotaUser")
  valid_579201 = validateParameter(valid_579201, JString, required = false,
                                 default = nil)
  if valid_579201 != nil:
    section.add "quotaUser", valid_579201
  var valid_579202 = query.getOrDefault("callback")
  valid_579202 = validateParameter(valid_579202, JString, required = false,
                                 default = nil)
  if valid_579202 != nil:
    section.add "callback", valid_579202
  var valid_579203 = query.getOrDefault("fields")
  valid_579203 = validateParameter(valid_579203, JString, required = false,
                                 default = nil)
  if valid_579203 != nil:
    section.add "fields", valid_579203
  var valid_579204 = query.getOrDefault("access_token")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = nil)
  if valid_579204 != nil:
    section.add "access_token", valid_579204
  var valid_579205 = query.getOrDefault("upload_protocol")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = nil)
  if valid_579205 != nil:
    section.add "upload_protocol", valid_579205
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

proc call*(call_579207: Call_CloudsearchIndexingDatasourcesItemsPush_579191;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Pushes an item onto a queue for later polling and updating.
  ## 
  let valid = call_579207.validator(path, query, header, formData, body)
  let scheme = call_579207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579207.url(scheme.get, call_579207.host, call_579207.base,
                         call_579207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579207, url, valid)

proc call*(call_579208: Call_CloudsearchIndexingDatasourcesItemsPush_579191;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudsearchIndexingDatasourcesItemsPush
  ## Pushes an item onto a queue for later polling and updating.
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
  var path_579209 = newJObject()
  var query_579210 = newJObject()
  var body_579211 = newJObject()
  add(query_579210, "key", newJString(key))
  add(query_579210, "prettyPrint", newJBool(prettyPrint))
  add(query_579210, "oauth_token", newJString(oauthToken))
  add(query_579210, "$.xgafv", newJString(Xgafv))
  add(query_579210, "alt", newJString(alt))
  add(query_579210, "uploadType", newJString(uploadType))
  add(query_579210, "quotaUser", newJString(quotaUser))
  add(path_579209, "name", newJString(name))
  if body != nil:
    body_579211 = body
  add(query_579210, "callback", newJString(callback))
  add(query_579210, "fields", newJString(fields))
  add(query_579210, "access_token", newJString(accessToken))
  add(query_579210, "upload_protocol", newJString(uploadProtocol))
  result = call_579208.call(path_579209, query_579210, nil, nil, body_579211)

var cloudsearchIndexingDatasourcesItemsPush* = Call_CloudsearchIndexingDatasourcesItemsPush_579191(
    name: "cloudsearchIndexingDatasourcesItemsPush", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}:push",
    validator: validate_CloudsearchIndexingDatasourcesItemsPush_579192, base: "/",
    url: url_CloudsearchIndexingDatasourcesItemsPush_579193,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsUpload_579212 = ref object of OpenApiRestCall_578348
proc url_CloudsearchIndexingDatasourcesItemsUpload_579214(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_CloudsearchIndexingDatasourcesItemsUpload_579213(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an upload session for uploading item content. For items smaller
  ## than 100 KB, it's easier to embed the content
  ## inline within
  ## an index request.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the Item to start a resumable upload.
  ## Format: datasources/{source_id}/items/{item_id}.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579215 = path.getOrDefault("name")
  valid_579215 = validateParameter(valid_579215, JString, required = true,
                                 default = nil)
  if valid_579215 != nil:
    section.add "name", valid_579215
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
  var valid_579216 = query.getOrDefault("key")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = nil)
  if valid_579216 != nil:
    section.add "key", valid_579216
  var valid_579217 = query.getOrDefault("prettyPrint")
  valid_579217 = validateParameter(valid_579217, JBool, required = false,
                                 default = newJBool(true))
  if valid_579217 != nil:
    section.add "prettyPrint", valid_579217
  var valid_579218 = query.getOrDefault("oauth_token")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "oauth_token", valid_579218
  var valid_579219 = query.getOrDefault("$.xgafv")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = newJString("1"))
  if valid_579219 != nil:
    section.add "$.xgafv", valid_579219
  var valid_579220 = query.getOrDefault("alt")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = newJString("json"))
  if valid_579220 != nil:
    section.add "alt", valid_579220
  var valid_579221 = query.getOrDefault("uploadType")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = nil)
  if valid_579221 != nil:
    section.add "uploadType", valid_579221
  var valid_579222 = query.getOrDefault("quotaUser")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = nil)
  if valid_579222 != nil:
    section.add "quotaUser", valid_579222
  var valid_579223 = query.getOrDefault("callback")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = nil)
  if valid_579223 != nil:
    section.add "callback", valid_579223
  var valid_579224 = query.getOrDefault("fields")
  valid_579224 = validateParameter(valid_579224, JString, required = false,
                                 default = nil)
  if valid_579224 != nil:
    section.add "fields", valid_579224
  var valid_579225 = query.getOrDefault("access_token")
  valid_579225 = validateParameter(valid_579225, JString, required = false,
                                 default = nil)
  if valid_579225 != nil:
    section.add "access_token", valid_579225
  var valid_579226 = query.getOrDefault("upload_protocol")
  valid_579226 = validateParameter(valid_579226, JString, required = false,
                                 default = nil)
  if valid_579226 != nil:
    section.add "upload_protocol", valid_579226
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

proc call*(call_579228: Call_CloudsearchIndexingDatasourcesItemsUpload_579212;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an upload session for uploading item content. For items smaller
  ## than 100 KB, it's easier to embed the content
  ## inline within
  ## an index request.
  ## 
  let valid = call_579228.validator(path, query, header, formData, body)
  let scheme = call_579228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579228.url(scheme.get, call_579228.host, call_579228.base,
                         call_579228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579228, url, valid)

proc call*(call_579229: Call_CloudsearchIndexingDatasourcesItemsUpload_579212;
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
  var path_579230 = newJObject()
  var query_579231 = newJObject()
  var body_579232 = newJObject()
  add(query_579231, "key", newJString(key))
  add(query_579231, "prettyPrint", newJBool(prettyPrint))
  add(query_579231, "oauth_token", newJString(oauthToken))
  add(query_579231, "$.xgafv", newJString(Xgafv))
  add(query_579231, "alt", newJString(alt))
  add(query_579231, "uploadType", newJString(uploadType))
  add(query_579231, "quotaUser", newJString(quotaUser))
  add(path_579230, "name", newJString(name))
  if body != nil:
    body_579232 = body
  add(query_579231, "callback", newJString(callback))
  add(query_579231, "fields", newJString(fields))
  add(query_579231, "access_token", newJString(accessToken))
  add(query_579231, "upload_protocol", newJString(uploadProtocol))
  result = call_579229.call(path_579230, query_579231, nil, nil, body_579232)

var cloudsearchIndexingDatasourcesItemsUpload* = Call_CloudsearchIndexingDatasourcesItemsUpload_579212(
    name: "cloudsearchIndexingDatasourcesItemsUpload", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}:upload",
    validator: validate_CloudsearchIndexingDatasourcesItemsUpload_579213,
    base: "/", url: url_CloudsearchIndexingDatasourcesItemsUpload_579214,
    schemes: {Scheme.Https})
type
  Call_CloudsearchMediaUpload_579233 = ref object of OpenApiRestCall_578348
proc url_CloudsearchMediaUpload_579235(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_CloudsearchMediaUpload_579234(path: JsonNode; query: JsonNode;
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
  var valid_579236 = path.getOrDefault("resourceName")
  valid_579236 = validateParameter(valid_579236, JString, required = true,
                                 default = nil)
  if valid_579236 != nil:
    section.add "resourceName", valid_579236
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
  var valid_579237 = query.getOrDefault("key")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = nil)
  if valid_579237 != nil:
    section.add "key", valid_579237
  var valid_579238 = query.getOrDefault("prettyPrint")
  valid_579238 = validateParameter(valid_579238, JBool, required = false,
                                 default = newJBool(true))
  if valid_579238 != nil:
    section.add "prettyPrint", valid_579238
  var valid_579239 = query.getOrDefault("oauth_token")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = nil)
  if valid_579239 != nil:
    section.add "oauth_token", valid_579239
  var valid_579240 = query.getOrDefault("$.xgafv")
  valid_579240 = validateParameter(valid_579240, JString, required = false,
                                 default = newJString("1"))
  if valid_579240 != nil:
    section.add "$.xgafv", valid_579240
  var valid_579241 = query.getOrDefault("alt")
  valid_579241 = validateParameter(valid_579241, JString, required = false,
                                 default = newJString("json"))
  if valid_579241 != nil:
    section.add "alt", valid_579241
  var valid_579242 = query.getOrDefault("uploadType")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = nil)
  if valid_579242 != nil:
    section.add "uploadType", valid_579242
  var valid_579243 = query.getOrDefault("quotaUser")
  valid_579243 = validateParameter(valid_579243, JString, required = false,
                                 default = nil)
  if valid_579243 != nil:
    section.add "quotaUser", valid_579243
  var valid_579244 = query.getOrDefault("callback")
  valid_579244 = validateParameter(valid_579244, JString, required = false,
                                 default = nil)
  if valid_579244 != nil:
    section.add "callback", valid_579244
  var valid_579245 = query.getOrDefault("fields")
  valid_579245 = validateParameter(valid_579245, JString, required = false,
                                 default = nil)
  if valid_579245 != nil:
    section.add "fields", valid_579245
  var valid_579246 = query.getOrDefault("access_token")
  valid_579246 = validateParameter(valid_579246, JString, required = false,
                                 default = nil)
  if valid_579246 != nil:
    section.add "access_token", valid_579246
  var valid_579247 = query.getOrDefault("upload_protocol")
  valid_579247 = validateParameter(valid_579247, JString, required = false,
                                 default = nil)
  if valid_579247 != nil:
    section.add "upload_protocol", valid_579247
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

proc call*(call_579249: Call_CloudsearchMediaUpload_579233; path: JsonNode;
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
  let valid = call_579249.validator(path, query, header, formData, body)
  let scheme = call_579249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579249.url(scheme.get, call_579249.host, call_579249.base,
                         call_579249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579249, url, valid)

proc call*(call_579250: Call_CloudsearchMediaUpload_579233; resourceName: string;
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
  var path_579251 = newJObject()
  var query_579252 = newJObject()
  var body_579253 = newJObject()
  add(query_579252, "key", newJString(key))
  add(query_579252, "prettyPrint", newJBool(prettyPrint))
  add(query_579252, "oauth_token", newJString(oauthToken))
  add(query_579252, "$.xgafv", newJString(Xgafv))
  add(query_579252, "alt", newJString(alt))
  add(query_579252, "uploadType", newJString(uploadType))
  add(query_579252, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579253 = body
  add(query_579252, "callback", newJString(callback))
  add(path_579251, "resourceName", newJString(resourceName))
  add(query_579252, "fields", newJString(fields))
  add(query_579252, "access_token", newJString(accessToken))
  add(query_579252, "upload_protocol", newJString(uploadProtocol))
  result = call_579250.call(path_579251, query_579252, nil, nil, body_579253)

var cloudsearchMediaUpload* = Call_CloudsearchMediaUpload_579233(
    name: "cloudsearchMediaUpload", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/media/{resourceName}",
    validator: validate_CloudsearchMediaUpload_579234, base: "/",
    url: url_CloudsearchMediaUpload_579235, schemes: {Scheme.Https})
type
  Call_CloudsearchQuerySearch_579254 = ref object of OpenApiRestCall_578348
proc url_CloudsearchQuerySearch_579256(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudsearchQuerySearch_579255(path: JsonNode; query: JsonNode;
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
  var valid_579257 = query.getOrDefault("key")
  valid_579257 = validateParameter(valid_579257, JString, required = false,
                                 default = nil)
  if valid_579257 != nil:
    section.add "key", valid_579257
  var valid_579258 = query.getOrDefault("prettyPrint")
  valid_579258 = validateParameter(valid_579258, JBool, required = false,
                                 default = newJBool(true))
  if valid_579258 != nil:
    section.add "prettyPrint", valid_579258
  var valid_579259 = query.getOrDefault("oauth_token")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = nil)
  if valid_579259 != nil:
    section.add "oauth_token", valid_579259
  var valid_579260 = query.getOrDefault("$.xgafv")
  valid_579260 = validateParameter(valid_579260, JString, required = false,
                                 default = newJString("1"))
  if valid_579260 != nil:
    section.add "$.xgafv", valid_579260
  var valid_579261 = query.getOrDefault("alt")
  valid_579261 = validateParameter(valid_579261, JString, required = false,
                                 default = newJString("json"))
  if valid_579261 != nil:
    section.add "alt", valid_579261
  var valid_579262 = query.getOrDefault("uploadType")
  valid_579262 = validateParameter(valid_579262, JString, required = false,
                                 default = nil)
  if valid_579262 != nil:
    section.add "uploadType", valid_579262
  var valid_579263 = query.getOrDefault("quotaUser")
  valid_579263 = validateParameter(valid_579263, JString, required = false,
                                 default = nil)
  if valid_579263 != nil:
    section.add "quotaUser", valid_579263
  var valid_579264 = query.getOrDefault("callback")
  valid_579264 = validateParameter(valid_579264, JString, required = false,
                                 default = nil)
  if valid_579264 != nil:
    section.add "callback", valid_579264
  var valid_579265 = query.getOrDefault("fields")
  valid_579265 = validateParameter(valid_579265, JString, required = false,
                                 default = nil)
  if valid_579265 != nil:
    section.add "fields", valid_579265
  var valid_579266 = query.getOrDefault("access_token")
  valid_579266 = validateParameter(valid_579266, JString, required = false,
                                 default = nil)
  if valid_579266 != nil:
    section.add "access_token", valid_579266
  var valid_579267 = query.getOrDefault("upload_protocol")
  valid_579267 = validateParameter(valid_579267, JString, required = false,
                                 default = nil)
  if valid_579267 != nil:
    section.add "upload_protocol", valid_579267
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

proc call*(call_579269: Call_CloudsearchQuerySearch_579254; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Cloud Search Query API provides the search method, which returns
  ## the most relevant results from a user query.  The results can come from
  ## G Suite Apps, such as Gmail or Google Drive, or they can come from data
  ## that you have indexed from a third party.
  ## 
  let valid = call_579269.validator(path, query, header, formData, body)
  let scheme = call_579269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579269.url(scheme.get, call_579269.host, call_579269.base,
                         call_579269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579269, url, valid)

proc call*(call_579270: Call_CloudsearchQuerySearch_579254; key: string = "";
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
  var query_579271 = newJObject()
  var body_579272 = newJObject()
  add(query_579271, "key", newJString(key))
  add(query_579271, "prettyPrint", newJBool(prettyPrint))
  add(query_579271, "oauth_token", newJString(oauthToken))
  add(query_579271, "$.xgafv", newJString(Xgafv))
  add(query_579271, "alt", newJString(alt))
  add(query_579271, "uploadType", newJString(uploadType))
  add(query_579271, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579272 = body
  add(query_579271, "callback", newJString(callback))
  add(query_579271, "fields", newJString(fields))
  add(query_579271, "access_token", newJString(accessToken))
  add(query_579271, "upload_protocol", newJString(uploadProtocol))
  result = call_579270.call(nil, query_579271, nil, nil, body_579272)

var cloudsearchQuerySearch* = Call_CloudsearchQuerySearch_579254(
    name: "cloudsearchQuerySearch", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/query/search",
    validator: validate_CloudsearchQuerySearch_579255, base: "/",
    url: url_CloudsearchQuerySearch_579256, schemes: {Scheme.Https})
type
  Call_CloudsearchQuerySourcesList_579273 = ref object of OpenApiRestCall_578348
proc url_CloudsearchQuerySourcesList_579275(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudsearchQuerySourcesList_579274(path: JsonNode; query: JsonNode;
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
  ## When specified, the documents in search results are biased towards the
  ## specified language.
  ## Suggest API does not use this parameter. It autocompletes only based on
  ## characters in the query.
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
  var valid_579276 = query.getOrDefault("key")
  valid_579276 = validateParameter(valid_579276, JString, required = false,
                                 default = nil)
  if valid_579276 != nil:
    section.add "key", valid_579276
  var valid_579277 = query.getOrDefault("prettyPrint")
  valid_579277 = validateParameter(valid_579277, JBool, required = false,
                                 default = newJBool(true))
  if valid_579277 != nil:
    section.add "prettyPrint", valid_579277
  var valid_579278 = query.getOrDefault("oauth_token")
  valid_579278 = validateParameter(valid_579278, JString, required = false,
                                 default = nil)
  if valid_579278 != nil:
    section.add "oauth_token", valid_579278
  var valid_579279 = query.getOrDefault("requestOptions.languageCode")
  valid_579279 = validateParameter(valid_579279, JString, required = false,
                                 default = nil)
  if valid_579279 != nil:
    section.add "requestOptions.languageCode", valid_579279
  var valid_579280 = query.getOrDefault("$.xgafv")
  valid_579280 = validateParameter(valid_579280, JString, required = false,
                                 default = newJString("1"))
  if valid_579280 != nil:
    section.add "$.xgafv", valid_579280
  var valid_579281 = query.getOrDefault("alt")
  valid_579281 = validateParameter(valid_579281, JString, required = false,
                                 default = newJString("json"))
  if valid_579281 != nil:
    section.add "alt", valid_579281
  var valid_579282 = query.getOrDefault("uploadType")
  valid_579282 = validateParameter(valid_579282, JString, required = false,
                                 default = nil)
  if valid_579282 != nil:
    section.add "uploadType", valid_579282
  var valid_579283 = query.getOrDefault("quotaUser")
  valid_579283 = validateParameter(valid_579283, JString, required = false,
                                 default = nil)
  if valid_579283 != nil:
    section.add "quotaUser", valid_579283
  var valid_579284 = query.getOrDefault("pageToken")
  valid_579284 = validateParameter(valid_579284, JString, required = false,
                                 default = nil)
  if valid_579284 != nil:
    section.add "pageToken", valid_579284
  var valid_579285 = query.getOrDefault("requestOptions.debugOptions.enableDebugging")
  valid_579285 = validateParameter(valid_579285, JBool, required = false, default = nil)
  if valid_579285 != nil:
    section.add "requestOptions.debugOptions.enableDebugging", valid_579285
  var valid_579286 = query.getOrDefault("callback")
  valid_579286 = validateParameter(valid_579286, JString, required = false,
                                 default = nil)
  if valid_579286 != nil:
    section.add "callback", valid_579286
  var valid_579287 = query.getOrDefault("requestOptions.searchApplicationId")
  valid_579287 = validateParameter(valid_579287, JString, required = false,
                                 default = nil)
  if valid_579287 != nil:
    section.add "requestOptions.searchApplicationId", valid_579287
  var valid_579288 = query.getOrDefault("fields")
  valid_579288 = validateParameter(valid_579288, JString, required = false,
                                 default = nil)
  if valid_579288 != nil:
    section.add "fields", valid_579288
  var valid_579289 = query.getOrDefault("access_token")
  valid_579289 = validateParameter(valid_579289, JString, required = false,
                                 default = nil)
  if valid_579289 != nil:
    section.add "access_token", valid_579289
  var valid_579290 = query.getOrDefault("upload_protocol")
  valid_579290 = validateParameter(valid_579290, JString, required = false,
                                 default = nil)
  if valid_579290 != nil:
    section.add "upload_protocol", valid_579290
  var valid_579291 = query.getOrDefault("requestOptions.timeZone")
  valid_579291 = validateParameter(valid_579291, JString, required = false,
                                 default = nil)
  if valid_579291 != nil:
    section.add "requestOptions.timeZone", valid_579291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579292: Call_CloudsearchQuerySourcesList_579273; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns list of sources that user can use for Search and Suggest APIs.
  ## 
  let valid = call_579292.validator(path, query, header, formData, body)
  let scheme = call_579292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579292.url(scheme.get, call_579292.host, call_579292.base,
                         call_579292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579292, url, valid)

proc call*(call_579293: Call_CloudsearchQuerySourcesList_579273; key: string = "";
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
  ## When specified, the documents in search results are biased towards the
  ## specified language.
  ## Suggest API does not use this parameter. It autocompletes only based on
  ## characters in the query.
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
  var query_579294 = newJObject()
  add(query_579294, "key", newJString(key))
  add(query_579294, "prettyPrint", newJBool(prettyPrint))
  add(query_579294, "oauth_token", newJString(oauthToken))
  add(query_579294, "requestOptions.languageCode",
      newJString(requestOptionsLanguageCode))
  add(query_579294, "$.xgafv", newJString(Xgafv))
  add(query_579294, "alt", newJString(alt))
  add(query_579294, "uploadType", newJString(uploadType))
  add(query_579294, "quotaUser", newJString(quotaUser))
  add(query_579294, "pageToken", newJString(pageToken))
  add(query_579294, "requestOptions.debugOptions.enableDebugging",
      newJBool(requestOptionsDebugOptionsEnableDebugging))
  add(query_579294, "callback", newJString(callback))
  add(query_579294, "requestOptions.searchApplicationId",
      newJString(requestOptionsSearchApplicationId))
  add(query_579294, "fields", newJString(fields))
  add(query_579294, "access_token", newJString(accessToken))
  add(query_579294, "upload_protocol", newJString(uploadProtocol))
  add(query_579294, "requestOptions.timeZone", newJString(requestOptionsTimeZone))
  result = call_579293.call(nil, query_579294, nil, nil, nil)

var cloudsearchQuerySourcesList* = Call_CloudsearchQuerySourcesList_579273(
    name: "cloudsearchQuerySourcesList", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/query/sources",
    validator: validate_CloudsearchQuerySourcesList_579274, base: "/",
    url: url_CloudsearchQuerySourcesList_579275, schemes: {Scheme.Https})
type
  Call_CloudsearchQuerySuggest_579295 = ref object of OpenApiRestCall_578348
proc url_CloudsearchQuerySuggest_579297(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudsearchQuerySuggest_579296(path: JsonNode; query: JsonNode;
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
  var valid_579298 = query.getOrDefault("key")
  valid_579298 = validateParameter(valid_579298, JString, required = false,
                                 default = nil)
  if valid_579298 != nil:
    section.add "key", valid_579298
  var valid_579299 = query.getOrDefault("prettyPrint")
  valid_579299 = validateParameter(valid_579299, JBool, required = false,
                                 default = newJBool(true))
  if valid_579299 != nil:
    section.add "prettyPrint", valid_579299
  var valid_579300 = query.getOrDefault("oauth_token")
  valid_579300 = validateParameter(valid_579300, JString, required = false,
                                 default = nil)
  if valid_579300 != nil:
    section.add "oauth_token", valid_579300
  var valid_579301 = query.getOrDefault("$.xgafv")
  valid_579301 = validateParameter(valid_579301, JString, required = false,
                                 default = newJString("1"))
  if valid_579301 != nil:
    section.add "$.xgafv", valid_579301
  var valid_579302 = query.getOrDefault("alt")
  valid_579302 = validateParameter(valid_579302, JString, required = false,
                                 default = newJString("json"))
  if valid_579302 != nil:
    section.add "alt", valid_579302
  var valid_579303 = query.getOrDefault("uploadType")
  valid_579303 = validateParameter(valid_579303, JString, required = false,
                                 default = nil)
  if valid_579303 != nil:
    section.add "uploadType", valid_579303
  var valid_579304 = query.getOrDefault("quotaUser")
  valid_579304 = validateParameter(valid_579304, JString, required = false,
                                 default = nil)
  if valid_579304 != nil:
    section.add "quotaUser", valid_579304
  var valid_579305 = query.getOrDefault("callback")
  valid_579305 = validateParameter(valid_579305, JString, required = false,
                                 default = nil)
  if valid_579305 != nil:
    section.add "callback", valid_579305
  var valid_579306 = query.getOrDefault("fields")
  valid_579306 = validateParameter(valid_579306, JString, required = false,
                                 default = nil)
  if valid_579306 != nil:
    section.add "fields", valid_579306
  var valid_579307 = query.getOrDefault("access_token")
  valid_579307 = validateParameter(valid_579307, JString, required = false,
                                 default = nil)
  if valid_579307 != nil:
    section.add "access_token", valid_579307
  var valid_579308 = query.getOrDefault("upload_protocol")
  valid_579308 = validateParameter(valid_579308, JString, required = false,
                                 default = nil)
  if valid_579308 != nil:
    section.add "upload_protocol", valid_579308
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

proc call*(call_579310: Call_CloudsearchQuerySuggest_579295; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides suggestions for autocompleting the query.
  ## 
  let valid = call_579310.validator(path, query, header, formData, body)
  let scheme = call_579310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579310.url(scheme.get, call_579310.host, call_579310.base,
                         call_579310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579310, url, valid)

proc call*(call_579311: Call_CloudsearchQuerySuggest_579295; key: string = "";
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
  var query_579312 = newJObject()
  var body_579313 = newJObject()
  add(query_579312, "key", newJString(key))
  add(query_579312, "prettyPrint", newJBool(prettyPrint))
  add(query_579312, "oauth_token", newJString(oauthToken))
  add(query_579312, "$.xgafv", newJString(Xgafv))
  add(query_579312, "alt", newJString(alt))
  add(query_579312, "uploadType", newJString(uploadType))
  add(query_579312, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579313 = body
  add(query_579312, "callback", newJString(callback))
  add(query_579312, "fields", newJString(fields))
  add(query_579312, "access_token", newJString(accessToken))
  add(query_579312, "upload_protocol", newJString(uploadProtocol))
  result = call_579311.call(nil, query_579312, nil, nil, body_579313)

var cloudsearchQuerySuggest* = Call_CloudsearchQuerySuggest_579295(
    name: "cloudsearchQuerySuggest", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/query/suggest",
    validator: validate_CloudsearchQuerySuggest_579296, base: "/",
    url: url_CloudsearchQuerySuggest_579297, schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsDatasourcesCreate_579334 = ref object of OpenApiRestCall_578348
proc url_CloudsearchSettingsDatasourcesCreate_579336(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudsearchSettingsDatasourcesCreate_579335(path: JsonNode;
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
  var valid_579337 = query.getOrDefault("key")
  valid_579337 = validateParameter(valid_579337, JString, required = false,
                                 default = nil)
  if valid_579337 != nil:
    section.add "key", valid_579337
  var valid_579338 = query.getOrDefault("prettyPrint")
  valid_579338 = validateParameter(valid_579338, JBool, required = false,
                                 default = newJBool(true))
  if valid_579338 != nil:
    section.add "prettyPrint", valid_579338
  var valid_579339 = query.getOrDefault("oauth_token")
  valid_579339 = validateParameter(valid_579339, JString, required = false,
                                 default = nil)
  if valid_579339 != nil:
    section.add "oauth_token", valid_579339
  var valid_579340 = query.getOrDefault("$.xgafv")
  valid_579340 = validateParameter(valid_579340, JString, required = false,
                                 default = newJString("1"))
  if valid_579340 != nil:
    section.add "$.xgafv", valid_579340
  var valid_579341 = query.getOrDefault("alt")
  valid_579341 = validateParameter(valid_579341, JString, required = false,
                                 default = newJString("json"))
  if valid_579341 != nil:
    section.add "alt", valid_579341
  var valid_579342 = query.getOrDefault("uploadType")
  valid_579342 = validateParameter(valid_579342, JString, required = false,
                                 default = nil)
  if valid_579342 != nil:
    section.add "uploadType", valid_579342
  var valid_579343 = query.getOrDefault("quotaUser")
  valid_579343 = validateParameter(valid_579343, JString, required = false,
                                 default = nil)
  if valid_579343 != nil:
    section.add "quotaUser", valid_579343
  var valid_579344 = query.getOrDefault("callback")
  valid_579344 = validateParameter(valid_579344, JString, required = false,
                                 default = nil)
  if valid_579344 != nil:
    section.add "callback", valid_579344
  var valid_579345 = query.getOrDefault("fields")
  valid_579345 = validateParameter(valid_579345, JString, required = false,
                                 default = nil)
  if valid_579345 != nil:
    section.add "fields", valid_579345
  var valid_579346 = query.getOrDefault("access_token")
  valid_579346 = validateParameter(valid_579346, JString, required = false,
                                 default = nil)
  if valid_579346 != nil:
    section.add "access_token", valid_579346
  var valid_579347 = query.getOrDefault("upload_protocol")
  valid_579347 = validateParameter(valid_579347, JString, required = false,
                                 default = nil)
  if valid_579347 != nil:
    section.add "upload_protocol", valid_579347
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

proc call*(call_579349: Call_CloudsearchSettingsDatasourcesCreate_579334;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a datasource.
  ## 
  let valid = call_579349.validator(path, query, header, formData, body)
  let scheme = call_579349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579349.url(scheme.get, call_579349.host, call_579349.base,
                         call_579349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579349, url, valid)

proc call*(call_579350: Call_CloudsearchSettingsDatasourcesCreate_579334;
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
  var query_579351 = newJObject()
  var body_579352 = newJObject()
  add(query_579351, "key", newJString(key))
  add(query_579351, "prettyPrint", newJBool(prettyPrint))
  add(query_579351, "oauth_token", newJString(oauthToken))
  add(query_579351, "$.xgafv", newJString(Xgafv))
  add(query_579351, "alt", newJString(alt))
  add(query_579351, "uploadType", newJString(uploadType))
  add(query_579351, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579352 = body
  add(query_579351, "callback", newJString(callback))
  add(query_579351, "fields", newJString(fields))
  add(query_579351, "access_token", newJString(accessToken))
  add(query_579351, "upload_protocol", newJString(uploadProtocol))
  result = call_579350.call(nil, query_579351, nil, nil, body_579352)

var cloudsearchSettingsDatasourcesCreate* = Call_CloudsearchSettingsDatasourcesCreate_579334(
    name: "cloudsearchSettingsDatasourcesCreate", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/datasources",
    validator: validate_CloudsearchSettingsDatasourcesCreate_579335, base: "/",
    url: url_CloudsearchSettingsDatasourcesCreate_579336, schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsDatasourcesList_579314 = ref object of OpenApiRestCall_578348
proc url_CloudsearchSettingsDatasourcesList_579316(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudsearchSettingsDatasourcesList_579315(path: JsonNode;
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
  var valid_579317 = query.getOrDefault("key")
  valid_579317 = validateParameter(valid_579317, JString, required = false,
                                 default = nil)
  if valid_579317 != nil:
    section.add "key", valid_579317
  var valid_579318 = query.getOrDefault("debugOptions.enableDebugging")
  valid_579318 = validateParameter(valid_579318, JBool, required = false, default = nil)
  if valid_579318 != nil:
    section.add "debugOptions.enableDebugging", valid_579318
  var valid_579319 = query.getOrDefault("prettyPrint")
  valid_579319 = validateParameter(valid_579319, JBool, required = false,
                                 default = newJBool(true))
  if valid_579319 != nil:
    section.add "prettyPrint", valid_579319
  var valid_579320 = query.getOrDefault("oauth_token")
  valid_579320 = validateParameter(valid_579320, JString, required = false,
                                 default = nil)
  if valid_579320 != nil:
    section.add "oauth_token", valid_579320
  var valid_579321 = query.getOrDefault("$.xgafv")
  valid_579321 = validateParameter(valid_579321, JString, required = false,
                                 default = newJString("1"))
  if valid_579321 != nil:
    section.add "$.xgafv", valid_579321
  var valid_579322 = query.getOrDefault("pageSize")
  valid_579322 = validateParameter(valid_579322, JInt, required = false, default = nil)
  if valid_579322 != nil:
    section.add "pageSize", valid_579322
  var valid_579323 = query.getOrDefault("alt")
  valid_579323 = validateParameter(valid_579323, JString, required = false,
                                 default = newJString("json"))
  if valid_579323 != nil:
    section.add "alt", valid_579323
  var valid_579324 = query.getOrDefault("uploadType")
  valid_579324 = validateParameter(valid_579324, JString, required = false,
                                 default = nil)
  if valid_579324 != nil:
    section.add "uploadType", valid_579324
  var valid_579325 = query.getOrDefault("quotaUser")
  valid_579325 = validateParameter(valid_579325, JString, required = false,
                                 default = nil)
  if valid_579325 != nil:
    section.add "quotaUser", valid_579325
  var valid_579326 = query.getOrDefault("pageToken")
  valid_579326 = validateParameter(valid_579326, JString, required = false,
                                 default = nil)
  if valid_579326 != nil:
    section.add "pageToken", valid_579326
  var valid_579327 = query.getOrDefault("callback")
  valid_579327 = validateParameter(valid_579327, JString, required = false,
                                 default = nil)
  if valid_579327 != nil:
    section.add "callback", valid_579327
  var valid_579328 = query.getOrDefault("fields")
  valid_579328 = validateParameter(valid_579328, JString, required = false,
                                 default = nil)
  if valid_579328 != nil:
    section.add "fields", valid_579328
  var valid_579329 = query.getOrDefault("access_token")
  valid_579329 = validateParameter(valid_579329, JString, required = false,
                                 default = nil)
  if valid_579329 != nil:
    section.add "access_token", valid_579329
  var valid_579330 = query.getOrDefault("upload_protocol")
  valid_579330 = validateParameter(valid_579330, JString, required = false,
                                 default = nil)
  if valid_579330 != nil:
    section.add "upload_protocol", valid_579330
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579331: Call_CloudsearchSettingsDatasourcesList_579314;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists datasources.
  ## 
  let valid = call_579331.validator(path, query, header, formData, body)
  let scheme = call_579331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579331.url(scheme.get, call_579331.host, call_579331.base,
                         call_579331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579331, url, valid)

proc call*(call_579332: Call_CloudsearchSettingsDatasourcesList_579314;
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
  var query_579333 = newJObject()
  add(query_579333, "key", newJString(key))
  add(query_579333, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_579333, "prettyPrint", newJBool(prettyPrint))
  add(query_579333, "oauth_token", newJString(oauthToken))
  add(query_579333, "$.xgafv", newJString(Xgafv))
  add(query_579333, "pageSize", newJInt(pageSize))
  add(query_579333, "alt", newJString(alt))
  add(query_579333, "uploadType", newJString(uploadType))
  add(query_579333, "quotaUser", newJString(quotaUser))
  add(query_579333, "pageToken", newJString(pageToken))
  add(query_579333, "callback", newJString(callback))
  add(query_579333, "fields", newJString(fields))
  add(query_579333, "access_token", newJString(accessToken))
  add(query_579333, "upload_protocol", newJString(uploadProtocol))
  result = call_579332.call(nil, query_579333, nil, nil, nil)

var cloudsearchSettingsDatasourcesList* = Call_CloudsearchSettingsDatasourcesList_579314(
    name: "cloudsearchSettingsDatasourcesList", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/datasources",
    validator: validate_CloudsearchSettingsDatasourcesList_579315, base: "/",
    url: url_CloudsearchSettingsDatasourcesList_579316, schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsSearchapplicationsCreate_579373 = ref object of OpenApiRestCall_578348
proc url_CloudsearchSettingsSearchapplicationsCreate_579375(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudsearchSettingsSearchapplicationsCreate_579374(path: JsonNode;
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
  var valid_579376 = query.getOrDefault("key")
  valid_579376 = validateParameter(valid_579376, JString, required = false,
                                 default = nil)
  if valid_579376 != nil:
    section.add "key", valid_579376
  var valid_579377 = query.getOrDefault("prettyPrint")
  valid_579377 = validateParameter(valid_579377, JBool, required = false,
                                 default = newJBool(true))
  if valid_579377 != nil:
    section.add "prettyPrint", valid_579377
  var valid_579378 = query.getOrDefault("oauth_token")
  valid_579378 = validateParameter(valid_579378, JString, required = false,
                                 default = nil)
  if valid_579378 != nil:
    section.add "oauth_token", valid_579378
  var valid_579379 = query.getOrDefault("$.xgafv")
  valid_579379 = validateParameter(valid_579379, JString, required = false,
                                 default = newJString("1"))
  if valid_579379 != nil:
    section.add "$.xgafv", valid_579379
  var valid_579380 = query.getOrDefault("alt")
  valid_579380 = validateParameter(valid_579380, JString, required = false,
                                 default = newJString("json"))
  if valid_579380 != nil:
    section.add "alt", valid_579380
  var valid_579381 = query.getOrDefault("uploadType")
  valid_579381 = validateParameter(valid_579381, JString, required = false,
                                 default = nil)
  if valid_579381 != nil:
    section.add "uploadType", valid_579381
  var valid_579382 = query.getOrDefault("quotaUser")
  valid_579382 = validateParameter(valid_579382, JString, required = false,
                                 default = nil)
  if valid_579382 != nil:
    section.add "quotaUser", valid_579382
  var valid_579383 = query.getOrDefault("callback")
  valid_579383 = validateParameter(valid_579383, JString, required = false,
                                 default = nil)
  if valid_579383 != nil:
    section.add "callback", valid_579383
  var valid_579384 = query.getOrDefault("fields")
  valid_579384 = validateParameter(valid_579384, JString, required = false,
                                 default = nil)
  if valid_579384 != nil:
    section.add "fields", valid_579384
  var valid_579385 = query.getOrDefault("access_token")
  valid_579385 = validateParameter(valid_579385, JString, required = false,
                                 default = nil)
  if valid_579385 != nil:
    section.add "access_token", valid_579385
  var valid_579386 = query.getOrDefault("upload_protocol")
  valid_579386 = validateParameter(valid_579386, JString, required = false,
                                 default = nil)
  if valid_579386 != nil:
    section.add "upload_protocol", valid_579386
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

proc call*(call_579388: Call_CloudsearchSettingsSearchapplicationsCreate_579373;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a search application.
  ## 
  let valid = call_579388.validator(path, query, header, formData, body)
  let scheme = call_579388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579388.url(scheme.get, call_579388.host, call_579388.base,
                         call_579388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579388, url, valid)

proc call*(call_579389: Call_CloudsearchSettingsSearchapplicationsCreate_579373;
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
  var query_579390 = newJObject()
  var body_579391 = newJObject()
  add(query_579390, "key", newJString(key))
  add(query_579390, "prettyPrint", newJBool(prettyPrint))
  add(query_579390, "oauth_token", newJString(oauthToken))
  add(query_579390, "$.xgafv", newJString(Xgafv))
  add(query_579390, "alt", newJString(alt))
  add(query_579390, "uploadType", newJString(uploadType))
  add(query_579390, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579391 = body
  add(query_579390, "callback", newJString(callback))
  add(query_579390, "fields", newJString(fields))
  add(query_579390, "access_token", newJString(accessToken))
  add(query_579390, "upload_protocol", newJString(uploadProtocol))
  result = call_579389.call(nil, query_579390, nil, nil, body_579391)

var cloudsearchSettingsSearchapplicationsCreate* = Call_CloudsearchSettingsSearchapplicationsCreate_579373(
    name: "cloudsearchSettingsSearchapplicationsCreate",
    meth: HttpMethod.HttpPost, host: "cloudsearch.googleapis.com",
    route: "/v1/settings/searchapplications",
    validator: validate_CloudsearchSettingsSearchapplicationsCreate_579374,
    base: "/", url: url_CloudsearchSettingsSearchapplicationsCreate_579375,
    schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsSearchapplicationsList_579353 = ref object of OpenApiRestCall_578348
proc url_CloudsearchSettingsSearchapplicationsList_579355(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudsearchSettingsSearchapplicationsList_579354(path: JsonNode;
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
  var valid_579356 = query.getOrDefault("key")
  valid_579356 = validateParameter(valid_579356, JString, required = false,
                                 default = nil)
  if valid_579356 != nil:
    section.add "key", valid_579356
  var valid_579357 = query.getOrDefault("debugOptions.enableDebugging")
  valid_579357 = validateParameter(valid_579357, JBool, required = false, default = nil)
  if valid_579357 != nil:
    section.add "debugOptions.enableDebugging", valid_579357
  var valid_579358 = query.getOrDefault("prettyPrint")
  valid_579358 = validateParameter(valid_579358, JBool, required = false,
                                 default = newJBool(true))
  if valid_579358 != nil:
    section.add "prettyPrint", valid_579358
  var valid_579359 = query.getOrDefault("oauth_token")
  valid_579359 = validateParameter(valid_579359, JString, required = false,
                                 default = nil)
  if valid_579359 != nil:
    section.add "oauth_token", valid_579359
  var valid_579360 = query.getOrDefault("$.xgafv")
  valid_579360 = validateParameter(valid_579360, JString, required = false,
                                 default = newJString("1"))
  if valid_579360 != nil:
    section.add "$.xgafv", valid_579360
  var valid_579361 = query.getOrDefault("pageSize")
  valid_579361 = validateParameter(valid_579361, JInt, required = false, default = nil)
  if valid_579361 != nil:
    section.add "pageSize", valid_579361
  var valid_579362 = query.getOrDefault("alt")
  valid_579362 = validateParameter(valid_579362, JString, required = false,
                                 default = newJString("json"))
  if valid_579362 != nil:
    section.add "alt", valid_579362
  var valid_579363 = query.getOrDefault("uploadType")
  valid_579363 = validateParameter(valid_579363, JString, required = false,
                                 default = nil)
  if valid_579363 != nil:
    section.add "uploadType", valid_579363
  var valid_579364 = query.getOrDefault("quotaUser")
  valid_579364 = validateParameter(valid_579364, JString, required = false,
                                 default = nil)
  if valid_579364 != nil:
    section.add "quotaUser", valid_579364
  var valid_579365 = query.getOrDefault("pageToken")
  valid_579365 = validateParameter(valid_579365, JString, required = false,
                                 default = nil)
  if valid_579365 != nil:
    section.add "pageToken", valid_579365
  var valid_579366 = query.getOrDefault("callback")
  valid_579366 = validateParameter(valid_579366, JString, required = false,
                                 default = nil)
  if valid_579366 != nil:
    section.add "callback", valid_579366
  var valid_579367 = query.getOrDefault("fields")
  valid_579367 = validateParameter(valid_579367, JString, required = false,
                                 default = nil)
  if valid_579367 != nil:
    section.add "fields", valid_579367
  var valid_579368 = query.getOrDefault("access_token")
  valid_579368 = validateParameter(valid_579368, JString, required = false,
                                 default = nil)
  if valid_579368 != nil:
    section.add "access_token", valid_579368
  var valid_579369 = query.getOrDefault("upload_protocol")
  valid_579369 = validateParameter(valid_579369, JString, required = false,
                                 default = nil)
  if valid_579369 != nil:
    section.add "upload_protocol", valid_579369
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579370: Call_CloudsearchSettingsSearchapplicationsList_579353;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all search applications.
  ## 
  let valid = call_579370.validator(path, query, header, formData, body)
  let scheme = call_579370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579370.url(scheme.get, call_579370.host, call_579370.base,
                         call_579370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579370, url, valid)

proc call*(call_579371: Call_CloudsearchSettingsSearchapplicationsList_579353;
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
  var query_579372 = newJObject()
  add(query_579372, "key", newJString(key))
  add(query_579372, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_579372, "prettyPrint", newJBool(prettyPrint))
  add(query_579372, "oauth_token", newJString(oauthToken))
  add(query_579372, "$.xgafv", newJString(Xgafv))
  add(query_579372, "pageSize", newJInt(pageSize))
  add(query_579372, "alt", newJString(alt))
  add(query_579372, "uploadType", newJString(uploadType))
  add(query_579372, "quotaUser", newJString(quotaUser))
  add(query_579372, "pageToken", newJString(pageToken))
  add(query_579372, "callback", newJString(callback))
  add(query_579372, "fields", newJString(fields))
  add(query_579372, "access_token", newJString(accessToken))
  add(query_579372, "upload_protocol", newJString(uploadProtocol))
  result = call_579371.call(nil, query_579372, nil, nil, nil)

var cloudsearchSettingsSearchapplicationsList* = Call_CloudsearchSettingsSearchapplicationsList_579353(
    name: "cloudsearchSettingsSearchapplicationsList", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/searchapplications",
    validator: validate_CloudsearchSettingsSearchapplicationsList_579354,
    base: "/", url: url_CloudsearchSettingsSearchapplicationsList_579355,
    schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsSearchapplicationsUpdate_579412 = ref object of OpenApiRestCall_578348
proc url_CloudsearchSettingsSearchapplicationsUpdate_579414(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_CloudsearchSettingsSearchapplicationsUpdate_579413(path: JsonNode;
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
  var valid_579415 = path.getOrDefault("name")
  valid_579415 = validateParameter(valid_579415, JString, required = true,
                                 default = nil)
  if valid_579415 != nil:
    section.add "name", valid_579415
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
  var valid_579416 = query.getOrDefault("key")
  valid_579416 = validateParameter(valid_579416, JString, required = false,
                                 default = nil)
  if valid_579416 != nil:
    section.add "key", valid_579416
  var valid_579417 = query.getOrDefault("prettyPrint")
  valid_579417 = validateParameter(valid_579417, JBool, required = false,
                                 default = newJBool(true))
  if valid_579417 != nil:
    section.add "prettyPrint", valid_579417
  var valid_579418 = query.getOrDefault("oauth_token")
  valid_579418 = validateParameter(valid_579418, JString, required = false,
                                 default = nil)
  if valid_579418 != nil:
    section.add "oauth_token", valid_579418
  var valid_579419 = query.getOrDefault("$.xgafv")
  valid_579419 = validateParameter(valid_579419, JString, required = false,
                                 default = newJString("1"))
  if valid_579419 != nil:
    section.add "$.xgafv", valid_579419
  var valid_579420 = query.getOrDefault("alt")
  valid_579420 = validateParameter(valid_579420, JString, required = false,
                                 default = newJString("json"))
  if valid_579420 != nil:
    section.add "alt", valid_579420
  var valid_579421 = query.getOrDefault("uploadType")
  valid_579421 = validateParameter(valid_579421, JString, required = false,
                                 default = nil)
  if valid_579421 != nil:
    section.add "uploadType", valid_579421
  var valid_579422 = query.getOrDefault("quotaUser")
  valid_579422 = validateParameter(valid_579422, JString, required = false,
                                 default = nil)
  if valid_579422 != nil:
    section.add "quotaUser", valid_579422
  var valid_579423 = query.getOrDefault("callback")
  valid_579423 = validateParameter(valid_579423, JString, required = false,
                                 default = nil)
  if valid_579423 != nil:
    section.add "callback", valid_579423
  var valid_579424 = query.getOrDefault("fields")
  valid_579424 = validateParameter(valid_579424, JString, required = false,
                                 default = nil)
  if valid_579424 != nil:
    section.add "fields", valid_579424
  var valid_579425 = query.getOrDefault("access_token")
  valid_579425 = validateParameter(valid_579425, JString, required = false,
                                 default = nil)
  if valid_579425 != nil:
    section.add "access_token", valid_579425
  var valid_579426 = query.getOrDefault("upload_protocol")
  valid_579426 = validateParameter(valid_579426, JString, required = false,
                                 default = nil)
  if valid_579426 != nil:
    section.add "upload_protocol", valid_579426
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

proc call*(call_579428: Call_CloudsearchSettingsSearchapplicationsUpdate_579412;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a search application.
  ## 
  let valid = call_579428.validator(path, query, header, formData, body)
  let scheme = call_579428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579428.url(scheme.get, call_579428.host, call_579428.base,
                         call_579428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579428, url, valid)

proc call*(call_579429: Call_CloudsearchSettingsSearchapplicationsUpdate_579412;
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
  var path_579430 = newJObject()
  var query_579431 = newJObject()
  var body_579432 = newJObject()
  add(query_579431, "key", newJString(key))
  add(query_579431, "prettyPrint", newJBool(prettyPrint))
  add(query_579431, "oauth_token", newJString(oauthToken))
  add(query_579431, "$.xgafv", newJString(Xgafv))
  add(query_579431, "alt", newJString(alt))
  add(query_579431, "uploadType", newJString(uploadType))
  add(query_579431, "quotaUser", newJString(quotaUser))
  add(path_579430, "name", newJString(name))
  if body != nil:
    body_579432 = body
  add(query_579431, "callback", newJString(callback))
  add(query_579431, "fields", newJString(fields))
  add(query_579431, "access_token", newJString(accessToken))
  add(query_579431, "upload_protocol", newJString(uploadProtocol))
  result = call_579429.call(path_579430, query_579431, nil, nil, body_579432)

var cloudsearchSettingsSearchapplicationsUpdate* = Call_CloudsearchSettingsSearchapplicationsUpdate_579412(
    name: "cloudsearchSettingsSearchapplicationsUpdate", meth: HttpMethod.HttpPut,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/{name}",
    validator: validate_CloudsearchSettingsSearchapplicationsUpdate_579413,
    base: "/", url: url_CloudsearchSettingsSearchapplicationsUpdate_579414,
    schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsSearchapplicationsGet_579392 = ref object of OpenApiRestCall_578348
proc url_CloudsearchSettingsSearchapplicationsGet_579394(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_CloudsearchSettingsSearchapplicationsGet_579393(path: JsonNode;
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
  var valid_579395 = path.getOrDefault("name")
  valid_579395 = validateParameter(valid_579395, JString, required = true,
                                 default = nil)
  if valid_579395 != nil:
    section.add "name", valid_579395
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
  var valid_579396 = query.getOrDefault("key")
  valid_579396 = validateParameter(valid_579396, JString, required = false,
                                 default = nil)
  if valid_579396 != nil:
    section.add "key", valid_579396
  var valid_579397 = query.getOrDefault("debugOptions.enableDebugging")
  valid_579397 = validateParameter(valid_579397, JBool, required = false, default = nil)
  if valid_579397 != nil:
    section.add "debugOptions.enableDebugging", valid_579397
  var valid_579398 = query.getOrDefault("prettyPrint")
  valid_579398 = validateParameter(valid_579398, JBool, required = false,
                                 default = newJBool(true))
  if valid_579398 != nil:
    section.add "prettyPrint", valid_579398
  var valid_579399 = query.getOrDefault("oauth_token")
  valid_579399 = validateParameter(valid_579399, JString, required = false,
                                 default = nil)
  if valid_579399 != nil:
    section.add "oauth_token", valid_579399
  var valid_579400 = query.getOrDefault("$.xgafv")
  valid_579400 = validateParameter(valid_579400, JString, required = false,
                                 default = newJString("1"))
  if valid_579400 != nil:
    section.add "$.xgafv", valid_579400
  var valid_579401 = query.getOrDefault("alt")
  valid_579401 = validateParameter(valid_579401, JString, required = false,
                                 default = newJString("json"))
  if valid_579401 != nil:
    section.add "alt", valid_579401
  var valid_579402 = query.getOrDefault("uploadType")
  valid_579402 = validateParameter(valid_579402, JString, required = false,
                                 default = nil)
  if valid_579402 != nil:
    section.add "uploadType", valid_579402
  var valid_579403 = query.getOrDefault("quotaUser")
  valid_579403 = validateParameter(valid_579403, JString, required = false,
                                 default = nil)
  if valid_579403 != nil:
    section.add "quotaUser", valid_579403
  var valid_579404 = query.getOrDefault("callback")
  valid_579404 = validateParameter(valid_579404, JString, required = false,
                                 default = nil)
  if valid_579404 != nil:
    section.add "callback", valid_579404
  var valid_579405 = query.getOrDefault("fields")
  valid_579405 = validateParameter(valid_579405, JString, required = false,
                                 default = nil)
  if valid_579405 != nil:
    section.add "fields", valid_579405
  var valid_579406 = query.getOrDefault("access_token")
  valid_579406 = validateParameter(valid_579406, JString, required = false,
                                 default = nil)
  if valid_579406 != nil:
    section.add "access_token", valid_579406
  var valid_579407 = query.getOrDefault("upload_protocol")
  valid_579407 = validateParameter(valid_579407, JString, required = false,
                                 default = nil)
  if valid_579407 != nil:
    section.add "upload_protocol", valid_579407
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579408: Call_CloudsearchSettingsSearchapplicationsGet_579392;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified search application.
  ## 
  let valid = call_579408.validator(path, query, header, formData, body)
  let scheme = call_579408.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579408.url(scheme.get, call_579408.host, call_579408.base,
                         call_579408.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579408, url, valid)

proc call*(call_579409: Call_CloudsearchSettingsSearchapplicationsGet_579392;
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
  var path_579410 = newJObject()
  var query_579411 = newJObject()
  add(query_579411, "key", newJString(key))
  add(query_579411, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_579411, "prettyPrint", newJBool(prettyPrint))
  add(query_579411, "oauth_token", newJString(oauthToken))
  add(query_579411, "$.xgafv", newJString(Xgafv))
  add(query_579411, "alt", newJString(alt))
  add(query_579411, "uploadType", newJString(uploadType))
  add(query_579411, "quotaUser", newJString(quotaUser))
  add(path_579410, "name", newJString(name))
  add(query_579411, "callback", newJString(callback))
  add(query_579411, "fields", newJString(fields))
  add(query_579411, "access_token", newJString(accessToken))
  add(query_579411, "upload_protocol", newJString(uploadProtocol))
  result = call_579409.call(path_579410, query_579411, nil, nil, nil)

var cloudsearchSettingsSearchapplicationsGet* = Call_CloudsearchSettingsSearchapplicationsGet_579392(
    name: "cloudsearchSettingsSearchapplicationsGet", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/{name}",
    validator: validate_CloudsearchSettingsSearchapplicationsGet_579393,
    base: "/", url: url_CloudsearchSettingsSearchapplicationsGet_579394,
    schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsSearchapplicationsDelete_579433 = ref object of OpenApiRestCall_578348
proc url_CloudsearchSettingsSearchapplicationsDelete_579435(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_CloudsearchSettingsSearchapplicationsDelete_579434(path: JsonNode;
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
  var valid_579436 = path.getOrDefault("name")
  valid_579436 = validateParameter(valid_579436, JString, required = true,
                                 default = nil)
  if valid_579436 != nil:
    section.add "name", valid_579436
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
  var valid_579437 = query.getOrDefault("key")
  valid_579437 = validateParameter(valid_579437, JString, required = false,
                                 default = nil)
  if valid_579437 != nil:
    section.add "key", valid_579437
  var valid_579438 = query.getOrDefault("debugOptions.enableDebugging")
  valid_579438 = validateParameter(valid_579438, JBool, required = false, default = nil)
  if valid_579438 != nil:
    section.add "debugOptions.enableDebugging", valid_579438
  var valid_579439 = query.getOrDefault("prettyPrint")
  valid_579439 = validateParameter(valid_579439, JBool, required = false,
                                 default = newJBool(true))
  if valid_579439 != nil:
    section.add "prettyPrint", valid_579439
  var valid_579440 = query.getOrDefault("oauth_token")
  valid_579440 = validateParameter(valid_579440, JString, required = false,
                                 default = nil)
  if valid_579440 != nil:
    section.add "oauth_token", valid_579440
  var valid_579441 = query.getOrDefault("$.xgafv")
  valid_579441 = validateParameter(valid_579441, JString, required = false,
                                 default = newJString("1"))
  if valid_579441 != nil:
    section.add "$.xgafv", valid_579441
  var valid_579442 = query.getOrDefault("alt")
  valid_579442 = validateParameter(valid_579442, JString, required = false,
                                 default = newJString("json"))
  if valid_579442 != nil:
    section.add "alt", valid_579442
  var valid_579443 = query.getOrDefault("uploadType")
  valid_579443 = validateParameter(valid_579443, JString, required = false,
                                 default = nil)
  if valid_579443 != nil:
    section.add "uploadType", valid_579443
  var valid_579444 = query.getOrDefault("quotaUser")
  valid_579444 = validateParameter(valid_579444, JString, required = false,
                                 default = nil)
  if valid_579444 != nil:
    section.add "quotaUser", valid_579444
  var valid_579445 = query.getOrDefault("callback")
  valid_579445 = validateParameter(valid_579445, JString, required = false,
                                 default = nil)
  if valid_579445 != nil:
    section.add "callback", valid_579445
  var valid_579446 = query.getOrDefault("fields")
  valid_579446 = validateParameter(valid_579446, JString, required = false,
                                 default = nil)
  if valid_579446 != nil:
    section.add "fields", valid_579446
  var valid_579447 = query.getOrDefault("access_token")
  valid_579447 = validateParameter(valid_579447, JString, required = false,
                                 default = nil)
  if valid_579447 != nil:
    section.add "access_token", valid_579447
  var valid_579448 = query.getOrDefault("upload_protocol")
  valid_579448 = validateParameter(valid_579448, JString, required = false,
                                 default = nil)
  if valid_579448 != nil:
    section.add "upload_protocol", valid_579448
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579449: Call_CloudsearchSettingsSearchapplicationsDelete_579433;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a search application.
  ## 
  let valid = call_579449.validator(path, query, header, formData, body)
  let scheme = call_579449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579449.url(scheme.get, call_579449.host, call_579449.base,
                         call_579449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579449, url, valid)

proc call*(call_579450: Call_CloudsearchSettingsSearchapplicationsDelete_579433;
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
  var path_579451 = newJObject()
  var query_579452 = newJObject()
  add(query_579452, "key", newJString(key))
  add(query_579452, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_579452, "prettyPrint", newJBool(prettyPrint))
  add(query_579452, "oauth_token", newJString(oauthToken))
  add(query_579452, "$.xgafv", newJString(Xgafv))
  add(query_579452, "alt", newJString(alt))
  add(query_579452, "uploadType", newJString(uploadType))
  add(query_579452, "quotaUser", newJString(quotaUser))
  add(path_579451, "name", newJString(name))
  add(query_579452, "callback", newJString(callback))
  add(query_579452, "fields", newJString(fields))
  add(query_579452, "access_token", newJString(accessToken))
  add(query_579452, "upload_protocol", newJString(uploadProtocol))
  result = call_579450.call(path_579451, query_579452, nil, nil, nil)

var cloudsearchSettingsSearchapplicationsDelete* = Call_CloudsearchSettingsSearchapplicationsDelete_579433(
    name: "cloudsearchSettingsSearchapplicationsDelete",
    meth: HttpMethod.HttpDelete, host: "cloudsearch.googleapis.com",
    route: "/v1/settings/{name}",
    validator: validate_CloudsearchSettingsSearchapplicationsDelete_579434,
    base: "/", url: url_CloudsearchSettingsSearchapplicationsDelete_579435,
    schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsSearchapplicationsReset_579453 = ref object of OpenApiRestCall_578348
proc url_CloudsearchSettingsSearchapplicationsReset_579455(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_CloudsearchSettingsSearchapplicationsReset_579454(path: JsonNode;
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
  var valid_579456 = path.getOrDefault("name")
  valid_579456 = validateParameter(valid_579456, JString, required = true,
                                 default = nil)
  if valid_579456 != nil:
    section.add "name", valid_579456
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
  var valid_579457 = query.getOrDefault("key")
  valid_579457 = validateParameter(valid_579457, JString, required = false,
                                 default = nil)
  if valid_579457 != nil:
    section.add "key", valid_579457
  var valid_579458 = query.getOrDefault("prettyPrint")
  valid_579458 = validateParameter(valid_579458, JBool, required = false,
                                 default = newJBool(true))
  if valid_579458 != nil:
    section.add "prettyPrint", valid_579458
  var valid_579459 = query.getOrDefault("oauth_token")
  valid_579459 = validateParameter(valid_579459, JString, required = false,
                                 default = nil)
  if valid_579459 != nil:
    section.add "oauth_token", valid_579459
  var valid_579460 = query.getOrDefault("$.xgafv")
  valid_579460 = validateParameter(valid_579460, JString, required = false,
                                 default = newJString("1"))
  if valid_579460 != nil:
    section.add "$.xgafv", valid_579460
  var valid_579461 = query.getOrDefault("alt")
  valid_579461 = validateParameter(valid_579461, JString, required = false,
                                 default = newJString("json"))
  if valid_579461 != nil:
    section.add "alt", valid_579461
  var valid_579462 = query.getOrDefault("uploadType")
  valid_579462 = validateParameter(valid_579462, JString, required = false,
                                 default = nil)
  if valid_579462 != nil:
    section.add "uploadType", valid_579462
  var valid_579463 = query.getOrDefault("quotaUser")
  valid_579463 = validateParameter(valid_579463, JString, required = false,
                                 default = nil)
  if valid_579463 != nil:
    section.add "quotaUser", valid_579463
  var valid_579464 = query.getOrDefault("callback")
  valid_579464 = validateParameter(valid_579464, JString, required = false,
                                 default = nil)
  if valid_579464 != nil:
    section.add "callback", valid_579464
  var valid_579465 = query.getOrDefault("fields")
  valid_579465 = validateParameter(valid_579465, JString, required = false,
                                 default = nil)
  if valid_579465 != nil:
    section.add "fields", valid_579465
  var valid_579466 = query.getOrDefault("access_token")
  valid_579466 = validateParameter(valid_579466, JString, required = false,
                                 default = nil)
  if valid_579466 != nil:
    section.add "access_token", valid_579466
  var valid_579467 = query.getOrDefault("upload_protocol")
  valid_579467 = validateParameter(valid_579467, JString, required = false,
                                 default = nil)
  if valid_579467 != nil:
    section.add "upload_protocol", valid_579467
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

proc call*(call_579469: Call_CloudsearchSettingsSearchapplicationsReset_579453;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets a search application to default settings. This will return an empty
  ## response.
  ## 
  let valid = call_579469.validator(path, query, header, formData, body)
  let scheme = call_579469.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579469.url(scheme.get, call_579469.host, call_579469.base,
                         call_579469.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579469, url, valid)

proc call*(call_579470: Call_CloudsearchSettingsSearchapplicationsReset_579453;
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
  var path_579471 = newJObject()
  var query_579472 = newJObject()
  var body_579473 = newJObject()
  add(query_579472, "key", newJString(key))
  add(query_579472, "prettyPrint", newJBool(prettyPrint))
  add(query_579472, "oauth_token", newJString(oauthToken))
  add(query_579472, "$.xgafv", newJString(Xgafv))
  add(query_579472, "alt", newJString(alt))
  add(query_579472, "uploadType", newJString(uploadType))
  add(query_579472, "quotaUser", newJString(quotaUser))
  add(path_579471, "name", newJString(name))
  if body != nil:
    body_579473 = body
  add(query_579472, "callback", newJString(callback))
  add(query_579472, "fields", newJString(fields))
  add(query_579472, "access_token", newJString(accessToken))
  add(query_579472, "upload_protocol", newJString(uploadProtocol))
  result = call_579470.call(path_579471, query_579472, nil, nil, body_579473)

var cloudsearchSettingsSearchapplicationsReset* = Call_CloudsearchSettingsSearchapplicationsReset_579453(
    name: "cloudsearchSettingsSearchapplicationsReset", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/{name}:reset",
    validator: validate_CloudsearchSettingsSearchapplicationsReset_579454,
    base: "/", url: url_CloudsearchSettingsSearchapplicationsReset_579455,
    schemes: {Scheme.Https})
type
  Call_CloudsearchStatsGetIndex_579474 = ref object of OpenApiRestCall_578348
proc url_CloudsearchStatsGetIndex_579476(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudsearchStatsGetIndex_579475(path: JsonNode; query: JsonNode;
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
  var valid_579477 = query.getOrDefault("key")
  valid_579477 = validateParameter(valid_579477, JString, required = false,
                                 default = nil)
  if valid_579477 != nil:
    section.add "key", valid_579477
  var valid_579478 = query.getOrDefault("prettyPrint")
  valid_579478 = validateParameter(valid_579478, JBool, required = false,
                                 default = newJBool(true))
  if valid_579478 != nil:
    section.add "prettyPrint", valid_579478
  var valid_579479 = query.getOrDefault("oauth_token")
  valid_579479 = validateParameter(valid_579479, JString, required = false,
                                 default = nil)
  if valid_579479 != nil:
    section.add "oauth_token", valid_579479
  var valid_579480 = query.getOrDefault("$.xgafv")
  valid_579480 = validateParameter(valid_579480, JString, required = false,
                                 default = newJString("1"))
  if valid_579480 != nil:
    section.add "$.xgafv", valid_579480
  var valid_579481 = query.getOrDefault("fromDate.year")
  valid_579481 = validateParameter(valid_579481, JInt, required = false, default = nil)
  if valid_579481 != nil:
    section.add "fromDate.year", valid_579481
  var valid_579482 = query.getOrDefault("fromDate.day")
  valid_579482 = validateParameter(valid_579482, JInt, required = false, default = nil)
  if valid_579482 != nil:
    section.add "fromDate.day", valid_579482
  var valid_579483 = query.getOrDefault("alt")
  valid_579483 = validateParameter(valid_579483, JString, required = false,
                                 default = newJString("json"))
  if valid_579483 != nil:
    section.add "alt", valid_579483
  var valid_579484 = query.getOrDefault("uploadType")
  valid_579484 = validateParameter(valid_579484, JString, required = false,
                                 default = nil)
  if valid_579484 != nil:
    section.add "uploadType", valid_579484
  var valid_579485 = query.getOrDefault("quotaUser")
  valid_579485 = validateParameter(valid_579485, JString, required = false,
                                 default = nil)
  if valid_579485 != nil:
    section.add "quotaUser", valid_579485
  var valid_579486 = query.getOrDefault("toDate.day")
  valid_579486 = validateParameter(valid_579486, JInt, required = false, default = nil)
  if valid_579486 != nil:
    section.add "toDate.day", valid_579486
  var valid_579487 = query.getOrDefault("toDate.year")
  valid_579487 = validateParameter(valid_579487, JInt, required = false, default = nil)
  if valid_579487 != nil:
    section.add "toDate.year", valid_579487
  var valid_579488 = query.getOrDefault("callback")
  valid_579488 = validateParameter(valid_579488, JString, required = false,
                                 default = nil)
  if valid_579488 != nil:
    section.add "callback", valid_579488
  var valid_579489 = query.getOrDefault("fromDate.month")
  valid_579489 = validateParameter(valid_579489, JInt, required = false, default = nil)
  if valid_579489 != nil:
    section.add "fromDate.month", valid_579489
  var valid_579490 = query.getOrDefault("fields")
  valid_579490 = validateParameter(valid_579490, JString, required = false,
                                 default = nil)
  if valid_579490 != nil:
    section.add "fields", valid_579490
  var valid_579491 = query.getOrDefault("access_token")
  valid_579491 = validateParameter(valid_579491, JString, required = false,
                                 default = nil)
  if valid_579491 != nil:
    section.add "access_token", valid_579491
  var valid_579492 = query.getOrDefault("upload_protocol")
  valid_579492 = validateParameter(valid_579492, JString, required = false,
                                 default = nil)
  if valid_579492 != nil:
    section.add "upload_protocol", valid_579492
  var valid_579493 = query.getOrDefault("toDate.month")
  valid_579493 = validateParameter(valid_579493, JInt, required = false, default = nil)
  if valid_579493 != nil:
    section.add "toDate.month", valid_579493
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579494: Call_CloudsearchStatsGetIndex_579474; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets indexed item statistics aggreggated across all data sources. This
  ## API only returns statistics for previous dates; it doesn't return
  ## statistics for the current day.
  ## 
  let valid = call_579494.validator(path, query, header, formData, body)
  let scheme = call_579494.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579494.url(scheme.get, call_579494.host, call_579494.base,
                         call_579494.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579494, url, valid)

proc call*(call_579495: Call_CloudsearchStatsGetIndex_579474; key: string = "";
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
  var query_579496 = newJObject()
  add(query_579496, "key", newJString(key))
  add(query_579496, "prettyPrint", newJBool(prettyPrint))
  add(query_579496, "oauth_token", newJString(oauthToken))
  add(query_579496, "$.xgafv", newJString(Xgafv))
  add(query_579496, "fromDate.year", newJInt(fromDateYear))
  add(query_579496, "fromDate.day", newJInt(fromDateDay))
  add(query_579496, "alt", newJString(alt))
  add(query_579496, "uploadType", newJString(uploadType))
  add(query_579496, "quotaUser", newJString(quotaUser))
  add(query_579496, "toDate.day", newJInt(toDateDay))
  add(query_579496, "toDate.year", newJInt(toDateYear))
  add(query_579496, "callback", newJString(callback))
  add(query_579496, "fromDate.month", newJInt(fromDateMonth))
  add(query_579496, "fields", newJString(fields))
  add(query_579496, "access_token", newJString(accessToken))
  add(query_579496, "upload_protocol", newJString(uploadProtocol))
  add(query_579496, "toDate.month", newJInt(toDateMonth))
  result = call_579495.call(nil, query_579496, nil, nil, nil)

var cloudsearchStatsGetIndex* = Call_CloudsearchStatsGetIndex_579474(
    name: "cloudsearchStatsGetIndex", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/stats/index",
    validator: validate_CloudsearchStatsGetIndex_579475, base: "/",
    url: url_CloudsearchStatsGetIndex_579476, schemes: {Scheme.Https})
type
  Call_CloudsearchStatsIndexDatasourcesGet_579497 = ref object of OpenApiRestCall_578348
proc url_CloudsearchStatsIndexDatasourcesGet_579499(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_CloudsearchStatsIndexDatasourcesGet_579498(path: JsonNode;
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
  var valid_579500 = path.getOrDefault("name")
  valid_579500 = validateParameter(valid_579500, JString, required = true,
                                 default = nil)
  if valid_579500 != nil:
    section.add "name", valid_579500
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
  var valid_579501 = query.getOrDefault("key")
  valid_579501 = validateParameter(valid_579501, JString, required = false,
                                 default = nil)
  if valid_579501 != nil:
    section.add "key", valid_579501
  var valid_579502 = query.getOrDefault("prettyPrint")
  valid_579502 = validateParameter(valid_579502, JBool, required = false,
                                 default = newJBool(true))
  if valid_579502 != nil:
    section.add "prettyPrint", valid_579502
  var valid_579503 = query.getOrDefault("oauth_token")
  valid_579503 = validateParameter(valid_579503, JString, required = false,
                                 default = nil)
  if valid_579503 != nil:
    section.add "oauth_token", valid_579503
  var valid_579504 = query.getOrDefault("$.xgafv")
  valid_579504 = validateParameter(valid_579504, JString, required = false,
                                 default = newJString("1"))
  if valid_579504 != nil:
    section.add "$.xgafv", valid_579504
  var valid_579505 = query.getOrDefault("fromDate.year")
  valid_579505 = validateParameter(valid_579505, JInt, required = false, default = nil)
  if valid_579505 != nil:
    section.add "fromDate.year", valid_579505
  var valid_579506 = query.getOrDefault("fromDate.day")
  valid_579506 = validateParameter(valid_579506, JInt, required = false, default = nil)
  if valid_579506 != nil:
    section.add "fromDate.day", valid_579506
  var valid_579507 = query.getOrDefault("alt")
  valid_579507 = validateParameter(valid_579507, JString, required = false,
                                 default = newJString("json"))
  if valid_579507 != nil:
    section.add "alt", valid_579507
  var valid_579508 = query.getOrDefault("uploadType")
  valid_579508 = validateParameter(valid_579508, JString, required = false,
                                 default = nil)
  if valid_579508 != nil:
    section.add "uploadType", valid_579508
  var valid_579509 = query.getOrDefault("quotaUser")
  valid_579509 = validateParameter(valid_579509, JString, required = false,
                                 default = nil)
  if valid_579509 != nil:
    section.add "quotaUser", valid_579509
  var valid_579510 = query.getOrDefault("toDate.day")
  valid_579510 = validateParameter(valid_579510, JInt, required = false, default = nil)
  if valid_579510 != nil:
    section.add "toDate.day", valid_579510
  var valid_579511 = query.getOrDefault("toDate.year")
  valid_579511 = validateParameter(valid_579511, JInt, required = false, default = nil)
  if valid_579511 != nil:
    section.add "toDate.year", valid_579511
  var valid_579512 = query.getOrDefault("callback")
  valid_579512 = validateParameter(valid_579512, JString, required = false,
                                 default = nil)
  if valid_579512 != nil:
    section.add "callback", valid_579512
  var valid_579513 = query.getOrDefault("fromDate.month")
  valid_579513 = validateParameter(valid_579513, JInt, required = false, default = nil)
  if valid_579513 != nil:
    section.add "fromDate.month", valid_579513
  var valid_579514 = query.getOrDefault("fields")
  valid_579514 = validateParameter(valid_579514, JString, required = false,
                                 default = nil)
  if valid_579514 != nil:
    section.add "fields", valid_579514
  var valid_579515 = query.getOrDefault("access_token")
  valid_579515 = validateParameter(valid_579515, JString, required = false,
                                 default = nil)
  if valid_579515 != nil:
    section.add "access_token", valid_579515
  var valid_579516 = query.getOrDefault("upload_protocol")
  valid_579516 = validateParameter(valid_579516, JString, required = false,
                                 default = nil)
  if valid_579516 != nil:
    section.add "upload_protocol", valid_579516
  var valid_579517 = query.getOrDefault("toDate.month")
  valid_579517 = validateParameter(valid_579517, JInt, required = false, default = nil)
  if valid_579517 != nil:
    section.add "toDate.month", valid_579517
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579518: Call_CloudsearchStatsIndexDatasourcesGet_579497;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets indexed item statistics for a single data source.
  ## 
  let valid = call_579518.validator(path, query, header, formData, body)
  let scheme = call_579518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579518.url(scheme.get, call_579518.host, call_579518.base,
                         call_579518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579518, url, valid)

proc call*(call_579519: Call_CloudsearchStatsIndexDatasourcesGet_579497;
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
  var path_579520 = newJObject()
  var query_579521 = newJObject()
  add(query_579521, "key", newJString(key))
  add(query_579521, "prettyPrint", newJBool(prettyPrint))
  add(query_579521, "oauth_token", newJString(oauthToken))
  add(query_579521, "$.xgafv", newJString(Xgafv))
  add(query_579521, "fromDate.year", newJInt(fromDateYear))
  add(query_579521, "fromDate.day", newJInt(fromDateDay))
  add(query_579521, "alt", newJString(alt))
  add(query_579521, "uploadType", newJString(uploadType))
  add(query_579521, "quotaUser", newJString(quotaUser))
  add(path_579520, "name", newJString(name))
  add(query_579521, "toDate.day", newJInt(toDateDay))
  add(query_579521, "toDate.year", newJInt(toDateYear))
  add(query_579521, "callback", newJString(callback))
  add(query_579521, "fromDate.month", newJInt(fromDateMonth))
  add(query_579521, "fields", newJString(fields))
  add(query_579521, "access_token", newJString(accessToken))
  add(query_579521, "upload_protocol", newJString(uploadProtocol))
  add(query_579521, "toDate.month", newJInt(toDateMonth))
  result = call_579519.call(path_579520, query_579521, nil, nil, nil)

var cloudsearchStatsIndexDatasourcesGet* = Call_CloudsearchStatsIndexDatasourcesGet_579497(
    name: "cloudsearchStatsIndexDatasourcesGet", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/stats/index/{name}",
    validator: validate_CloudsearchStatsIndexDatasourcesGet_579498, base: "/",
    url: url_CloudsearchStatsIndexDatasourcesGet_579499, schemes: {Scheme.Https})
type
  Call_CloudsearchOperationsGet_579522 = ref object of OpenApiRestCall_578348
proc url_CloudsearchOperationsGet_579524(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_CloudsearchOperationsGet_579523(path: JsonNode; query: JsonNode;
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
  var valid_579525 = path.getOrDefault("name")
  valid_579525 = validateParameter(valid_579525, JString, required = true,
                                 default = nil)
  if valid_579525 != nil:
    section.add "name", valid_579525
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
  var valid_579526 = query.getOrDefault("key")
  valid_579526 = validateParameter(valid_579526, JString, required = false,
                                 default = nil)
  if valid_579526 != nil:
    section.add "key", valid_579526
  var valid_579527 = query.getOrDefault("prettyPrint")
  valid_579527 = validateParameter(valid_579527, JBool, required = false,
                                 default = newJBool(true))
  if valid_579527 != nil:
    section.add "prettyPrint", valid_579527
  var valid_579528 = query.getOrDefault("oauth_token")
  valid_579528 = validateParameter(valid_579528, JString, required = false,
                                 default = nil)
  if valid_579528 != nil:
    section.add "oauth_token", valid_579528
  var valid_579529 = query.getOrDefault("$.xgafv")
  valid_579529 = validateParameter(valid_579529, JString, required = false,
                                 default = newJString("1"))
  if valid_579529 != nil:
    section.add "$.xgafv", valid_579529
  var valid_579530 = query.getOrDefault("alt")
  valid_579530 = validateParameter(valid_579530, JString, required = false,
                                 default = newJString("json"))
  if valid_579530 != nil:
    section.add "alt", valid_579530
  var valid_579531 = query.getOrDefault("uploadType")
  valid_579531 = validateParameter(valid_579531, JString, required = false,
                                 default = nil)
  if valid_579531 != nil:
    section.add "uploadType", valid_579531
  var valid_579532 = query.getOrDefault("quotaUser")
  valid_579532 = validateParameter(valid_579532, JString, required = false,
                                 default = nil)
  if valid_579532 != nil:
    section.add "quotaUser", valid_579532
  var valid_579533 = query.getOrDefault("callback")
  valid_579533 = validateParameter(valid_579533, JString, required = false,
                                 default = nil)
  if valid_579533 != nil:
    section.add "callback", valid_579533
  var valid_579534 = query.getOrDefault("fields")
  valid_579534 = validateParameter(valid_579534, JString, required = false,
                                 default = nil)
  if valid_579534 != nil:
    section.add "fields", valid_579534
  var valid_579535 = query.getOrDefault("access_token")
  valid_579535 = validateParameter(valid_579535, JString, required = false,
                                 default = nil)
  if valid_579535 != nil:
    section.add "access_token", valid_579535
  var valid_579536 = query.getOrDefault("upload_protocol")
  valid_579536 = validateParameter(valid_579536, JString, required = false,
                                 default = nil)
  if valid_579536 != nil:
    section.add "upload_protocol", valid_579536
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579537: Call_CloudsearchOperationsGet_579522; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_579537.validator(path, query, header, formData, body)
  let scheme = call_579537.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579537.url(scheme.get, call_579537.host, call_579537.base,
                         call_579537.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579537, url, valid)

proc call*(call_579538: Call_CloudsearchOperationsGet_579522; name: string;
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
  var path_579539 = newJObject()
  var query_579540 = newJObject()
  add(query_579540, "key", newJString(key))
  add(query_579540, "prettyPrint", newJBool(prettyPrint))
  add(query_579540, "oauth_token", newJString(oauthToken))
  add(query_579540, "$.xgafv", newJString(Xgafv))
  add(query_579540, "alt", newJString(alt))
  add(query_579540, "uploadType", newJString(uploadType))
  add(query_579540, "quotaUser", newJString(quotaUser))
  add(path_579539, "name", newJString(name))
  add(query_579540, "callback", newJString(callback))
  add(query_579540, "fields", newJString(fields))
  add(query_579540, "access_token", newJString(accessToken))
  add(query_579540, "upload_protocol", newJString(uploadProtocol))
  result = call_579538.call(path_579539, query_579540, nil, nil, nil)

var cloudsearchOperationsGet* = Call_CloudsearchOperationsGet_579522(
    name: "cloudsearchOperationsGet", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudsearchOperationsGet_579523, base: "/",
    url: url_CloudsearchOperationsGet_579524, schemes: {Scheme.Https})
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
