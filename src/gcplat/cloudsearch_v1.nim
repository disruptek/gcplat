
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

  OpenApiRestCall_579421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579421): Option[Scheme] {.used.} =
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
  gcpServiceName = "cloudsearch"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudsearchDebugDatasourcesItemsSearchByViewUrl_579690 = ref object of OpenApiRestCall_579421
proc url_CloudsearchDebugDatasourcesItemsSearchByViewUrl_579692(protocol: Scheme;
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

proc validate_CloudsearchDebugDatasourcesItemsSearchByViewUrl_579691(
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
  var valid_579818 = path.getOrDefault("name")
  valid_579818 = validateParameter(valid_579818, JString, required = true,
                                 default = nil)
  if valid_579818 != nil:
    section.add "name", valid_579818
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
  var valid_579819 = query.getOrDefault("upload_protocol")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = nil)
  if valid_579819 != nil:
    section.add "upload_protocol", valid_579819
  var valid_579820 = query.getOrDefault("fields")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "fields", valid_579820
  var valid_579821 = query.getOrDefault("quotaUser")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "quotaUser", valid_579821
  var valid_579835 = query.getOrDefault("alt")
  valid_579835 = validateParameter(valid_579835, JString, required = false,
                                 default = newJString("json"))
  if valid_579835 != nil:
    section.add "alt", valid_579835
  var valid_579836 = query.getOrDefault("oauth_token")
  valid_579836 = validateParameter(valid_579836, JString, required = false,
                                 default = nil)
  if valid_579836 != nil:
    section.add "oauth_token", valid_579836
  var valid_579837 = query.getOrDefault("callback")
  valid_579837 = validateParameter(valid_579837, JString, required = false,
                                 default = nil)
  if valid_579837 != nil:
    section.add "callback", valid_579837
  var valid_579838 = query.getOrDefault("access_token")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = nil)
  if valid_579838 != nil:
    section.add "access_token", valid_579838
  var valid_579839 = query.getOrDefault("uploadType")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "uploadType", valid_579839
  var valid_579840 = query.getOrDefault("key")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = nil)
  if valid_579840 != nil:
    section.add "key", valid_579840
  var valid_579841 = query.getOrDefault("$.xgafv")
  valid_579841 = validateParameter(valid_579841, JString, required = false,
                                 default = newJString("1"))
  if valid_579841 != nil:
    section.add "$.xgafv", valid_579841
  var valid_579842 = query.getOrDefault("prettyPrint")
  valid_579842 = validateParameter(valid_579842, JBool, required = false,
                                 default = newJBool(true))
  if valid_579842 != nil:
    section.add "prettyPrint", valid_579842
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

proc call*(call_579866: Call_CloudsearchDebugDatasourcesItemsSearchByViewUrl_579690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches the item whose viewUrl exactly matches that of the URL provided
  ## in the request.
  ## 
  let valid = call_579866.validator(path, query, header, formData, body)
  let scheme = call_579866.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579866.url(scheme.get, call_579866.host, call_579866.base,
                         call_579866.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579866, url, valid)

proc call*(call_579937: Call_CloudsearchDebugDatasourcesItemsSearchByViewUrl_579690;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudsearchDebugDatasourcesItemsSearchByViewUrl
  ## Fetches the item whose viewUrl exactly matches that of the URL provided
  ## in the request.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Source name, format:
  ## datasources/{source_id}
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579938 = newJObject()
  var query_579940 = newJObject()
  var body_579941 = newJObject()
  add(query_579940, "upload_protocol", newJString(uploadProtocol))
  add(query_579940, "fields", newJString(fields))
  add(query_579940, "quotaUser", newJString(quotaUser))
  add(path_579938, "name", newJString(name))
  add(query_579940, "alt", newJString(alt))
  add(query_579940, "oauth_token", newJString(oauthToken))
  add(query_579940, "callback", newJString(callback))
  add(query_579940, "access_token", newJString(accessToken))
  add(query_579940, "uploadType", newJString(uploadType))
  add(query_579940, "key", newJString(key))
  add(query_579940, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579941 = body
  add(query_579940, "prettyPrint", newJBool(prettyPrint))
  result = call_579937.call(path_579938, query_579940, nil, nil, body_579941)

var cloudsearchDebugDatasourcesItemsSearchByViewUrl* = Call_CloudsearchDebugDatasourcesItemsSearchByViewUrl_579690(
    name: "cloudsearchDebugDatasourcesItemsSearchByViewUrl",
    meth: HttpMethod.HttpPost, host: "cloudsearch.googleapis.com",
    route: "/v1/debug/{name}/items:searchByViewUrl",
    validator: validate_CloudsearchDebugDatasourcesItemsSearchByViewUrl_579691,
    base: "/", url: url_CloudsearchDebugDatasourcesItemsSearchByViewUrl_579692,
    schemes: {Scheme.Https})
type
  Call_CloudsearchDebugDatasourcesItemsCheckAccess_579980 = ref object of OpenApiRestCall_579421
proc url_CloudsearchDebugDatasourcesItemsCheckAccess_579982(protocol: Scheme;
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

proc validate_CloudsearchDebugDatasourcesItemsCheckAccess_579981(path: JsonNode;
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
  var valid_579983 = path.getOrDefault("name")
  valid_579983 = validateParameter(valid_579983, JString, required = true,
                                 default = nil)
  if valid_579983 != nil:
    section.add "name", valid_579983
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
  ##   debugOptions.enableDebugging: JBool
  ##                               : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579984 = query.getOrDefault("upload_protocol")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "upload_protocol", valid_579984
  var valid_579985 = query.getOrDefault("fields")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "fields", valid_579985
  var valid_579986 = query.getOrDefault("quotaUser")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "quotaUser", valid_579986
  var valid_579987 = query.getOrDefault("alt")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = newJString("json"))
  if valid_579987 != nil:
    section.add "alt", valid_579987
  var valid_579988 = query.getOrDefault("oauth_token")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "oauth_token", valid_579988
  var valid_579989 = query.getOrDefault("callback")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "callback", valid_579989
  var valid_579990 = query.getOrDefault("access_token")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "access_token", valid_579990
  var valid_579991 = query.getOrDefault("uploadType")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "uploadType", valid_579991
  var valid_579992 = query.getOrDefault("key")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "key", valid_579992
  var valid_579993 = query.getOrDefault("debugOptions.enableDebugging")
  valid_579993 = validateParameter(valid_579993, JBool, required = false, default = nil)
  if valid_579993 != nil:
    section.add "debugOptions.enableDebugging", valid_579993
  var valid_579994 = query.getOrDefault("$.xgafv")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = newJString("1"))
  if valid_579994 != nil:
    section.add "$.xgafv", valid_579994
  var valid_579995 = query.getOrDefault("prettyPrint")
  valid_579995 = validateParameter(valid_579995, JBool, required = false,
                                 default = newJBool(true))
  if valid_579995 != nil:
    section.add "prettyPrint", valid_579995
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

proc call*(call_579997: Call_CloudsearchDebugDatasourcesItemsCheckAccess_579980;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether an item is accessible by specified principal.
  ## 
  let valid = call_579997.validator(path, query, header, formData, body)
  let scheme = call_579997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579997.url(scheme.get, call_579997.host, call_579997.base,
                         call_579997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579997, url, valid)

proc call*(call_579998: Call_CloudsearchDebugDatasourcesItemsCheckAccess_579980;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; debugOptionsEnableDebugging: bool = false;
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## cloudsearchDebugDatasourcesItemsCheckAccess
  ## Checks whether an item is accessible by specified principal.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Item name, format:
  ## datasources/{source_id}/items/{item_id}
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
  ##   debugOptionsEnableDebugging: bool
  ##                              : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579999 = newJObject()
  var query_580000 = newJObject()
  var body_580001 = newJObject()
  add(query_580000, "upload_protocol", newJString(uploadProtocol))
  add(query_580000, "fields", newJString(fields))
  add(query_580000, "quotaUser", newJString(quotaUser))
  add(path_579999, "name", newJString(name))
  add(query_580000, "alt", newJString(alt))
  add(query_580000, "oauth_token", newJString(oauthToken))
  add(query_580000, "callback", newJString(callback))
  add(query_580000, "access_token", newJString(accessToken))
  add(query_580000, "uploadType", newJString(uploadType))
  add(query_580000, "key", newJString(key))
  add(query_580000, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_580000, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580001 = body
  add(query_580000, "prettyPrint", newJBool(prettyPrint))
  result = call_579998.call(path_579999, query_580000, nil, nil, body_580001)

var cloudsearchDebugDatasourcesItemsCheckAccess* = Call_CloudsearchDebugDatasourcesItemsCheckAccess_579980(
    name: "cloudsearchDebugDatasourcesItemsCheckAccess",
    meth: HttpMethod.HttpPost, host: "cloudsearch.googleapis.com",
    route: "/v1/debug/{name}:checkAccess",
    validator: validate_CloudsearchDebugDatasourcesItemsCheckAccess_579981,
    base: "/", url: url_CloudsearchDebugDatasourcesItemsCheckAccess_579982,
    schemes: {Scheme.Https})
type
  Call_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_580002 = ref object of OpenApiRestCall_579421
proc url_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_580004(
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

proc validate_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_580003(
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
  var valid_580005 = path.getOrDefault("parent")
  valid_580005 = validateParameter(valid_580005, JString, required = true,
                                 default = nil)
  if valid_580005 != nil:
    section.add "parent", valid_580005
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous List request, if any.
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
  ##   groupResourceName: JString
  ##   userResourceName: JString
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   debugOptions.enableDebugging: JBool
  ##                               : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum number of items to fetch in a request.
  ## Defaults to 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580006 = query.getOrDefault("upload_protocol")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "upload_protocol", valid_580006
  var valid_580007 = query.getOrDefault("fields")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "fields", valid_580007
  var valid_580008 = query.getOrDefault("pageToken")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "pageToken", valid_580008
  var valid_580009 = query.getOrDefault("quotaUser")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "quotaUser", valid_580009
  var valid_580010 = query.getOrDefault("alt")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = newJString("json"))
  if valid_580010 != nil:
    section.add "alt", valid_580010
  var valid_580011 = query.getOrDefault("oauth_token")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "oauth_token", valid_580011
  var valid_580012 = query.getOrDefault("callback")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "callback", valid_580012
  var valid_580013 = query.getOrDefault("access_token")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "access_token", valid_580013
  var valid_580014 = query.getOrDefault("uploadType")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "uploadType", valid_580014
  var valid_580015 = query.getOrDefault("groupResourceName")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "groupResourceName", valid_580015
  var valid_580016 = query.getOrDefault("userResourceName")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "userResourceName", valid_580016
  var valid_580017 = query.getOrDefault("key")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "key", valid_580017
  var valid_580018 = query.getOrDefault("debugOptions.enableDebugging")
  valid_580018 = validateParameter(valid_580018, JBool, required = false, default = nil)
  if valid_580018 != nil:
    section.add "debugOptions.enableDebugging", valid_580018
  var valid_580019 = query.getOrDefault("$.xgafv")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = newJString("1"))
  if valid_580019 != nil:
    section.add "$.xgafv", valid_580019
  var valid_580020 = query.getOrDefault("pageSize")
  valid_580020 = validateParameter(valid_580020, JInt, required = false, default = nil)
  if valid_580020 != nil:
    section.add "pageSize", valid_580020
  var valid_580021 = query.getOrDefault("prettyPrint")
  valid_580021 = validateParameter(valid_580021, JBool, required = false,
                                 default = newJBool(true))
  if valid_580021 != nil:
    section.add "prettyPrint", valid_580021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580022: Call_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_580002;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists names of items associated with an unmapped identity.
  ## 
  let valid = call_580022.validator(path, query, header, formData, body)
  let scheme = call_580022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580022.url(scheme.get, call_580022.host, call_580022.base,
                         call_580022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580022, url, valid)

proc call*(call_580023: Call_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_580002;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; groupResourceName: string = "";
          userResourceName: string = ""; key: string = "";
          debugOptionsEnableDebugging: bool = false; Xgafv: string = "1";
          pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## cloudsearchDebugIdentitysourcesItemsListForunmappedidentity
  ## Lists names of items associated with an unmapped identity.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous List request, if any.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   parent: string (required)
  ##         : The name of the identity source, in the following format:
  ## identitysources/{source_id}}
  ##   groupResourceName: string
  ##   userResourceName: string
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   debugOptionsEnableDebugging: bool
  ##                              : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of items to fetch in a request.
  ## Defaults to 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580024 = newJObject()
  var query_580025 = newJObject()
  add(query_580025, "upload_protocol", newJString(uploadProtocol))
  add(query_580025, "fields", newJString(fields))
  add(query_580025, "pageToken", newJString(pageToken))
  add(query_580025, "quotaUser", newJString(quotaUser))
  add(query_580025, "alt", newJString(alt))
  add(query_580025, "oauth_token", newJString(oauthToken))
  add(query_580025, "callback", newJString(callback))
  add(query_580025, "access_token", newJString(accessToken))
  add(query_580025, "uploadType", newJString(uploadType))
  add(path_580024, "parent", newJString(parent))
  add(query_580025, "groupResourceName", newJString(groupResourceName))
  add(query_580025, "userResourceName", newJString(userResourceName))
  add(query_580025, "key", newJString(key))
  add(query_580025, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_580025, "$.xgafv", newJString(Xgafv))
  add(query_580025, "pageSize", newJInt(pageSize))
  add(query_580025, "prettyPrint", newJBool(prettyPrint))
  result = call_580023.call(path_580024, query_580025, nil, nil, nil)

var cloudsearchDebugIdentitysourcesItemsListForunmappedidentity* = Call_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_580002(
    name: "cloudsearchDebugIdentitysourcesItemsListForunmappedidentity",
    meth: HttpMethod.HttpGet, host: "cloudsearch.googleapis.com",
    route: "/v1/debug/{parent}/items:forunmappedidentity", validator: validate_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_580003,
    base: "/",
    url: url_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_580004,
    schemes: {Scheme.Https})
type
  Call_CloudsearchDebugIdentitysourcesUnmappedidsList_580026 = ref object of OpenApiRestCall_579421
proc url_CloudsearchDebugIdentitysourcesUnmappedidsList_580028(protocol: Scheme;
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

proc validate_CloudsearchDebugIdentitysourcesUnmappedidsList_580027(
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
  var valid_580029 = path.getOrDefault("parent")
  valid_580029 = validateParameter(valid_580029, JString, required = true,
                                 default = nil)
  if valid_580029 != nil:
    section.add "parent", valid_580029
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous List request, if any.
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
  ##   debugOptions.enableDebugging: JBool
  ##                               : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   resolutionStatusCode: JString
  ##                       : Limit users selection to this status.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum number of items to fetch in a request.
  ## Defaults to 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580030 = query.getOrDefault("upload_protocol")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "upload_protocol", valid_580030
  var valid_580031 = query.getOrDefault("fields")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "fields", valid_580031
  var valid_580032 = query.getOrDefault("pageToken")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "pageToken", valid_580032
  var valid_580033 = query.getOrDefault("quotaUser")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "quotaUser", valid_580033
  var valid_580034 = query.getOrDefault("alt")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = newJString("json"))
  if valid_580034 != nil:
    section.add "alt", valid_580034
  var valid_580035 = query.getOrDefault("oauth_token")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "oauth_token", valid_580035
  var valid_580036 = query.getOrDefault("callback")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "callback", valid_580036
  var valid_580037 = query.getOrDefault("access_token")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "access_token", valid_580037
  var valid_580038 = query.getOrDefault("uploadType")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "uploadType", valid_580038
  var valid_580039 = query.getOrDefault("key")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "key", valid_580039
  var valid_580040 = query.getOrDefault("debugOptions.enableDebugging")
  valid_580040 = validateParameter(valid_580040, JBool, required = false, default = nil)
  if valid_580040 != nil:
    section.add "debugOptions.enableDebugging", valid_580040
  var valid_580041 = query.getOrDefault("resolutionStatusCode")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = newJString("CODE_UNSPECIFIED"))
  if valid_580041 != nil:
    section.add "resolutionStatusCode", valid_580041
  var valid_580042 = query.getOrDefault("$.xgafv")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = newJString("1"))
  if valid_580042 != nil:
    section.add "$.xgafv", valid_580042
  var valid_580043 = query.getOrDefault("pageSize")
  valid_580043 = validateParameter(valid_580043, JInt, required = false, default = nil)
  if valid_580043 != nil:
    section.add "pageSize", valid_580043
  var valid_580044 = query.getOrDefault("prettyPrint")
  valid_580044 = validateParameter(valid_580044, JBool, required = false,
                                 default = newJBool(true))
  if valid_580044 != nil:
    section.add "prettyPrint", valid_580044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580045: Call_CloudsearchDebugIdentitysourcesUnmappedidsList_580026;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists unmapped user identities for an identity source.
  ## 
  let valid = call_580045.validator(path, query, header, formData, body)
  let scheme = call_580045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580045.url(scheme.get, call_580045.host, call_580045.base,
                         call_580045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580045, url, valid)

proc call*(call_580046: Call_CloudsearchDebugIdentitysourcesUnmappedidsList_580026;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = "";
          debugOptionsEnableDebugging: bool = false;
          resolutionStatusCode: string = "CODE_UNSPECIFIED"; Xgafv: string = "1";
          pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## cloudsearchDebugIdentitysourcesUnmappedidsList
  ## Lists unmapped user identities for an identity source.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous List request, if any.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   parent: string (required)
  ##         : The name of the identity source, in the following format:
  ## identitysources/{source_id}
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   debugOptionsEnableDebugging: bool
  ##                              : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   resolutionStatusCode: string
  ##                       : Limit users selection to this status.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of items to fetch in a request.
  ## Defaults to 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580047 = newJObject()
  var query_580048 = newJObject()
  add(query_580048, "upload_protocol", newJString(uploadProtocol))
  add(query_580048, "fields", newJString(fields))
  add(query_580048, "pageToken", newJString(pageToken))
  add(query_580048, "quotaUser", newJString(quotaUser))
  add(query_580048, "alt", newJString(alt))
  add(query_580048, "oauth_token", newJString(oauthToken))
  add(query_580048, "callback", newJString(callback))
  add(query_580048, "access_token", newJString(accessToken))
  add(query_580048, "uploadType", newJString(uploadType))
  add(path_580047, "parent", newJString(parent))
  add(query_580048, "key", newJString(key))
  add(query_580048, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_580048, "resolutionStatusCode", newJString(resolutionStatusCode))
  add(query_580048, "$.xgafv", newJString(Xgafv))
  add(query_580048, "pageSize", newJInt(pageSize))
  add(query_580048, "prettyPrint", newJBool(prettyPrint))
  result = call_580046.call(path_580047, query_580048, nil, nil, nil)

var cloudsearchDebugIdentitysourcesUnmappedidsList* = Call_CloudsearchDebugIdentitysourcesUnmappedidsList_580026(
    name: "cloudsearchDebugIdentitysourcesUnmappedidsList",
    meth: HttpMethod.HttpGet, host: "cloudsearch.googleapis.com",
    route: "/v1/debug/{parent}/unmappedids",
    validator: validate_CloudsearchDebugIdentitysourcesUnmappedidsList_580027,
    base: "/", url: url_CloudsearchDebugIdentitysourcesUnmappedidsList_580028,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsGet_580049 = ref object of OpenApiRestCall_579421
proc url_CloudsearchIndexingDatasourcesItemsGet_580051(protocol: Scheme;
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

proc validate_CloudsearchIndexingDatasourcesItemsGet_580050(path: JsonNode;
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
  var valid_580052 = path.getOrDefault("name")
  valid_580052 = validateParameter(valid_580052, JString, required = true,
                                 default = nil)
  if valid_580052 != nil:
    section.add "name", valid_580052
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
  ##   debugOptions.enableDebugging: JBool
  ##                               : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   connectorName: JString
  ##                : Name of connector making this call.
  ## <br />Format: datasources/{source_id}/connectors/{ID}
  section = newJObject()
  var valid_580053 = query.getOrDefault("upload_protocol")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "upload_protocol", valid_580053
  var valid_580054 = query.getOrDefault("fields")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "fields", valid_580054
  var valid_580055 = query.getOrDefault("quotaUser")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "quotaUser", valid_580055
  var valid_580056 = query.getOrDefault("alt")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = newJString("json"))
  if valid_580056 != nil:
    section.add "alt", valid_580056
  var valid_580057 = query.getOrDefault("oauth_token")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "oauth_token", valid_580057
  var valid_580058 = query.getOrDefault("callback")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "callback", valid_580058
  var valid_580059 = query.getOrDefault("access_token")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "access_token", valid_580059
  var valid_580060 = query.getOrDefault("uploadType")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "uploadType", valid_580060
  var valid_580061 = query.getOrDefault("key")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "key", valid_580061
  var valid_580062 = query.getOrDefault("debugOptions.enableDebugging")
  valid_580062 = validateParameter(valid_580062, JBool, required = false, default = nil)
  if valid_580062 != nil:
    section.add "debugOptions.enableDebugging", valid_580062
  var valid_580063 = query.getOrDefault("$.xgafv")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = newJString("1"))
  if valid_580063 != nil:
    section.add "$.xgafv", valid_580063
  var valid_580064 = query.getOrDefault("prettyPrint")
  valid_580064 = validateParameter(valid_580064, JBool, required = false,
                                 default = newJBool(true))
  if valid_580064 != nil:
    section.add "prettyPrint", valid_580064
  var valid_580065 = query.getOrDefault("connectorName")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "connectorName", valid_580065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580066: Call_CloudsearchIndexingDatasourcesItemsGet_580049;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets Item resource by item name.
  ## 
  let valid = call_580066.validator(path, query, header, formData, body)
  let scheme = call_580066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580066.url(scheme.get, call_580066.host, call_580066.base,
                         call_580066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580066, url, valid)

proc call*(call_580067: Call_CloudsearchIndexingDatasourcesItemsGet_580049;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; debugOptionsEnableDebugging: bool = false;
          Xgafv: string = "1"; prettyPrint: bool = true; connectorName: string = ""): Recallable =
  ## cloudsearchIndexingDatasourcesItemsGet
  ## Gets Item resource by item name.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the item to get info.
  ## Format: datasources/{source_id}/items/{item_id}
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
  ##   debugOptionsEnableDebugging: bool
  ##                              : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   connectorName: string
  ##                : Name of connector making this call.
  ## <br />Format: datasources/{source_id}/connectors/{ID}
  var path_580068 = newJObject()
  var query_580069 = newJObject()
  add(query_580069, "upload_protocol", newJString(uploadProtocol))
  add(query_580069, "fields", newJString(fields))
  add(query_580069, "quotaUser", newJString(quotaUser))
  add(path_580068, "name", newJString(name))
  add(query_580069, "alt", newJString(alt))
  add(query_580069, "oauth_token", newJString(oauthToken))
  add(query_580069, "callback", newJString(callback))
  add(query_580069, "access_token", newJString(accessToken))
  add(query_580069, "uploadType", newJString(uploadType))
  add(query_580069, "key", newJString(key))
  add(query_580069, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_580069, "$.xgafv", newJString(Xgafv))
  add(query_580069, "prettyPrint", newJBool(prettyPrint))
  add(query_580069, "connectorName", newJString(connectorName))
  result = call_580067.call(path_580068, query_580069, nil, nil, nil)

var cloudsearchIndexingDatasourcesItemsGet* = Call_CloudsearchIndexingDatasourcesItemsGet_580049(
    name: "cloudsearchIndexingDatasourcesItemsGet", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}",
    validator: validate_CloudsearchIndexingDatasourcesItemsGet_580050, base: "/",
    url: url_CloudsearchIndexingDatasourcesItemsGet_580051,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsDelete_580070 = ref object of OpenApiRestCall_579421
proc url_CloudsearchIndexingDatasourcesItemsDelete_580072(protocol: Scheme;
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

proc validate_CloudsearchIndexingDatasourcesItemsDelete_580071(path: JsonNode;
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
  var valid_580073 = path.getOrDefault("name")
  valid_580073 = validateParameter(valid_580073, JString, required = true,
                                 default = nil)
  if valid_580073 != nil:
    section.add "name", valid_580073
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
  ##   mode: JString
  ##       : Required. The RequestMode for this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   debugOptions.enableDebugging: JBool
  ##                               : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   $.xgafv: JString
  ##          : V1 error format.
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   connectorName: JString
  ##                : Name of connector making this call.
  ## <br />Format: datasources/{source_id}/connectors/{ID}
  section = newJObject()
  var valid_580074 = query.getOrDefault("upload_protocol")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "upload_protocol", valid_580074
  var valid_580075 = query.getOrDefault("fields")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "fields", valid_580075
  var valid_580076 = query.getOrDefault("quotaUser")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "quotaUser", valid_580076
  var valid_580077 = query.getOrDefault("alt")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = newJString("json"))
  if valid_580077 != nil:
    section.add "alt", valid_580077
  var valid_580078 = query.getOrDefault("oauth_token")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "oauth_token", valid_580078
  var valid_580079 = query.getOrDefault("callback")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "callback", valid_580079
  var valid_580080 = query.getOrDefault("access_token")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "access_token", valid_580080
  var valid_580081 = query.getOrDefault("uploadType")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "uploadType", valid_580081
  var valid_580082 = query.getOrDefault("mode")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = newJString("UNSPECIFIED"))
  if valid_580082 != nil:
    section.add "mode", valid_580082
  var valid_580083 = query.getOrDefault("key")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "key", valid_580083
  var valid_580084 = query.getOrDefault("debugOptions.enableDebugging")
  valid_580084 = validateParameter(valid_580084, JBool, required = false, default = nil)
  if valid_580084 != nil:
    section.add "debugOptions.enableDebugging", valid_580084
  var valid_580085 = query.getOrDefault("$.xgafv")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = newJString("1"))
  if valid_580085 != nil:
    section.add "$.xgafv", valid_580085
  var valid_580086 = query.getOrDefault("version")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "version", valid_580086
  var valid_580087 = query.getOrDefault("prettyPrint")
  valid_580087 = validateParameter(valid_580087, JBool, required = false,
                                 default = newJBool(true))
  if valid_580087 != nil:
    section.add "prettyPrint", valid_580087
  var valid_580088 = query.getOrDefault("connectorName")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "connectorName", valid_580088
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580089: Call_CloudsearchIndexingDatasourcesItemsDelete_580070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes Item resource for the
  ## specified resource name.
  ## 
  let valid = call_580089.validator(path, query, header, formData, body)
  let scheme = call_580089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580089.url(scheme.get, call_580089.host, call_580089.base,
                         call_580089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580089, url, valid)

proc call*(call_580090: Call_CloudsearchIndexingDatasourcesItemsDelete_580070;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          mode: string = "UNSPECIFIED"; key: string = "";
          debugOptionsEnableDebugging: bool = false; Xgafv: string = "1";
          version: string = ""; prettyPrint: bool = true; connectorName: string = ""): Recallable =
  ## cloudsearchIndexingDatasourcesItemsDelete
  ## Deletes Item resource for the
  ## specified resource name.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. Name of the item to delete.
  ## Format: datasources/{source_id}/items/{item_id}
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
  ##   mode: string
  ##       : Required. The RequestMode for this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   debugOptionsEnableDebugging: bool
  ##                              : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   Xgafv: string
  ##        : V1 error format.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   connectorName: string
  ##                : Name of connector making this call.
  ## <br />Format: datasources/{source_id}/connectors/{ID}
  var path_580091 = newJObject()
  var query_580092 = newJObject()
  add(query_580092, "upload_protocol", newJString(uploadProtocol))
  add(query_580092, "fields", newJString(fields))
  add(query_580092, "quotaUser", newJString(quotaUser))
  add(path_580091, "name", newJString(name))
  add(query_580092, "alt", newJString(alt))
  add(query_580092, "oauth_token", newJString(oauthToken))
  add(query_580092, "callback", newJString(callback))
  add(query_580092, "access_token", newJString(accessToken))
  add(query_580092, "uploadType", newJString(uploadType))
  add(query_580092, "mode", newJString(mode))
  add(query_580092, "key", newJString(key))
  add(query_580092, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_580092, "$.xgafv", newJString(Xgafv))
  add(query_580092, "version", newJString(version))
  add(query_580092, "prettyPrint", newJBool(prettyPrint))
  add(query_580092, "connectorName", newJString(connectorName))
  result = call_580090.call(path_580091, query_580092, nil, nil, nil)

var cloudsearchIndexingDatasourcesItemsDelete* = Call_CloudsearchIndexingDatasourcesItemsDelete_580070(
    name: "cloudsearchIndexingDatasourcesItemsDelete",
    meth: HttpMethod.HttpDelete, host: "cloudsearch.googleapis.com",
    route: "/v1/indexing/{name}",
    validator: validate_CloudsearchIndexingDatasourcesItemsDelete_580071,
    base: "/", url: url_CloudsearchIndexingDatasourcesItemsDelete_580072,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsList_580093 = ref object of OpenApiRestCall_579421
proc url_CloudsearchIndexingDatasourcesItemsList_580095(protocol: Scheme;
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

proc validate_CloudsearchIndexingDatasourcesItemsList_580094(path: JsonNode;
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
  var valid_580096 = path.getOrDefault("name")
  valid_580096 = validateParameter(valid_580096, JString, required = true,
                                 default = nil)
  if valid_580096 != nil:
    section.add "name", valid_580096
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous List request, if any.
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
  ##   brief: JBool
  ##        : When set to true, the indexing system only populates the following fields:
  ## name,
  ## version,
  ## metadata.hash,
  ## structured_data.hash,
  ## content.hash.
  ## <br />If this value is false, then all the fields are populated in Item.
  ##   debugOptions.enableDebugging: JBool
  ##                               : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum number of items to fetch in a request.
  ## The max value is 1000 when brief is true.  The max value is 10 if brief
  ## is false.
  ## <br />The default value is 10
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   connectorName: JString
  ##                : Name of connector making this call.
  ## <br />Format: datasources/{source_id}/connectors/{ID}
  section = newJObject()
  var valid_580097 = query.getOrDefault("upload_protocol")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "upload_protocol", valid_580097
  var valid_580098 = query.getOrDefault("fields")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "fields", valid_580098
  var valid_580099 = query.getOrDefault("pageToken")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "pageToken", valid_580099
  var valid_580100 = query.getOrDefault("quotaUser")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "quotaUser", valid_580100
  var valid_580101 = query.getOrDefault("alt")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = newJString("json"))
  if valid_580101 != nil:
    section.add "alt", valid_580101
  var valid_580102 = query.getOrDefault("oauth_token")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "oauth_token", valid_580102
  var valid_580103 = query.getOrDefault("callback")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "callback", valid_580103
  var valid_580104 = query.getOrDefault("access_token")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "access_token", valid_580104
  var valid_580105 = query.getOrDefault("uploadType")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "uploadType", valid_580105
  var valid_580106 = query.getOrDefault("key")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "key", valid_580106
  var valid_580107 = query.getOrDefault("brief")
  valid_580107 = validateParameter(valid_580107, JBool, required = false, default = nil)
  if valid_580107 != nil:
    section.add "brief", valid_580107
  var valid_580108 = query.getOrDefault("debugOptions.enableDebugging")
  valid_580108 = validateParameter(valid_580108, JBool, required = false, default = nil)
  if valid_580108 != nil:
    section.add "debugOptions.enableDebugging", valid_580108
  var valid_580109 = query.getOrDefault("$.xgafv")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = newJString("1"))
  if valid_580109 != nil:
    section.add "$.xgafv", valid_580109
  var valid_580110 = query.getOrDefault("pageSize")
  valid_580110 = validateParameter(valid_580110, JInt, required = false, default = nil)
  if valid_580110 != nil:
    section.add "pageSize", valid_580110
  var valid_580111 = query.getOrDefault("prettyPrint")
  valid_580111 = validateParameter(valid_580111, JBool, required = false,
                                 default = newJBool(true))
  if valid_580111 != nil:
    section.add "prettyPrint", valid_580111
  var valid_580112 = query.getOrDefault("connectorName")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "connectorName", valid_580112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580113: Call_CloudsearchIndexingDatasourcesItemsList_580093;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all or a subset of Item resources.
  ## 
  let valid = call_580113.validator(path, query, header, formData, body)
  let scheme = call_580113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580113.url(scheme.get, call_580113.host, call_580113.base,
                         call_580113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580113, url, valid)

proc call*(call_580114: Call_CloudsearchIndexingDatasourcesItemsList_580093;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; brief: bool = false;
          debugOptionsEnableDebugging: bool = false; Xgafv: string = "1";
          pageSize: int = 0; prettyPrint: bool = true; connectorName: string = ""): Recallable =
  ## cloudsearchIndexingDatasourcesItemsList
  ## Lists all or a subset of Item resources.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous List request, if any.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the Data Source to list Items.  Format:
  ## datasources/{source_id}
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
  ##   brief: bool
  ##        : When set to true, the indexing system only populates the following fields:
  ## name,
  ## version,
  ## metadata.hash,
  ## structured_data.hash,
  ## content.hash.
  ## <br />If this value is false, then all the fields are populated in Item.
  ##   debugOptionsEnableDebugging: bool
  ##                              : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of items to fetch in a request.
  ## The max value is 1000 when brief is true.  The max value is 10 if brief
  ## is false.
  ## <br />The default value is 10
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   connectorName: string
  ##                : Name of connector making this call.
  ## <br />Format: datasources/{source_id}/connectors/{ID}
  var path_580115 = newJObject()
  var query_580116 = newJObject()
  add(query_580116, "upload_protocol", newJString(uploadProtocol))
  add(query_580116, "fields", newJString(fields))
  add(query_580116, "pageToken", newJString(pageToken))
  add(query_580116, "quotaUser", newJString(quotaUser))
  add(path_580115, "name", newJString(name))
  add(query_580116, "alt", newJString(alt))
  add(query_580116, "oauth_token", newJString(oauthToken))
  add(query_580116, "callback", newJString(callback))
  add(query_580116, "access_token", newJString(accessToken))
  add(query_580116, "uploadType", newJString(uploadType))
  add(query_580116, "key", newJString(key))
  add(query_580116, "brief", newJBool(brief))
  add(query_580116, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_580116, "$.xgafv", newJString(Xgafv))
  add(query_580116, "pageSize", newJInt(pageSize))
  add(query_580116, "prettyPrint", newJBool(prettyPrint))
  add(query_580116, "connectorName", newJString(connectorName))
  result = call_580114.call(path_580115, query_580116, nil, nil, nil)

var cloudsearchIndexingDatasourcesItemsList* = Call_CloudsearchIndexingDatasourcesItemsList_580093(
    name: "cloudsearchIndexingDatasourcesItemsList", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}/items",
    validator: validate_CloudsearchIndexingDatasourcesItemsList_580094, base: "/",
    url: url_CloudsearchIndexingDatasourcesItemsList_580095,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_580117 = ref object of OpenApiRestCall_579421
proc url_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_580119(
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

proc validate_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_580118(
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
  var valid_580120 = path.getOrDefault("name")
  valid_580120 = validateParameter(valid_580120, JString, required = true,
                                 default = nil)
  if valid_580120 != nil:
    section.add "name", valid_580120
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
  var valid_580121 = query.getOrDefault("upload_protocol")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "upload_protocol", valid_580121
  var valid_580122 = query.getOrDefault("fields")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "fields", valid_580122
  var valid_580123 = query.getOrDefault("quotaUser")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "quotaUser", valid_580123
  var valid_580124 = query.getOrDefault("alt")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = newJString("json"))
  if valid_580124 != nil:
    section.add "alt", valid_580124
  var valid_580125 = query.getOrDefault("oauth_token")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "oauth_token", valid_580125
  var valid_580126 = query.getOrDefault("callback")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "callback", valid_580126
  var valid_580127 = query.getOrDefault("access_token")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "access_token", valid_580127
  var valid_580128 = query.getOrDefault("uploadType")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "uploadType", valid_580128
  var valid_580129 = query.getOrDefault("key")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "key", valid_580129
  var valid_580130 = query.getOrDefault("$.xgafv")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = newJString("1"))
  if valid_580130 != nil:
    section.add "$.xgafv", valid_580130
  var valid_580131 = query.getOrDefault("prettyPrint")
  valid_580131 = validateParameter(valid_580131, JBool, required = false,
                                 default = newJBool(true))
  if valid_580131 != nil:
    section.add "prettyPrint", valid_580131
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

proc call*(call_580133: Call_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_580117;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all items in a queue. This method is useful for deleting stale
  ## items.
  ## 
  let valid = call_580133.validator(path, query, header, formData, body)
  let scheme = call_580133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580133.url(scheme.get, call_580133.host, call_580133.base,
                         call_580133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580133, url, valid)

proc call*(call_580134: Call_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_580117;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudsearchIndexingDatasourcesItemsDeleteQueueItems
  ## Deletes all items in a queue. This method is useful for deleting stale
  ## items.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the Data Source to delete items in a queue.
  ## Format: datasources/{source_id}
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580135 = newJObject()
  var query_580136 = newJObject()
  var body_580137 = newJObject()
  add(query_580136, "upload_protocol", newJString(uploadProtocol))
  add(query_580136, "fields", newJString(fields))
  add(query_580136, "quotaUser", newJString(quotaUser))
  add(path_580135, "name", newJString(name))
  add(query_580136, "alt", newJString(alt))
  add(query_580136, "oauth_token", newJString(oauthToken))
  add(query_580136, "callback", newJString(callback))
  add(query_580136, "access_token", newJString(accessToken))
  add(query_580136, "uploadType", newJString(uploadType))
  add(query_580136, "key", newJString(key))
  add(query_580136, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580137 = body
  add(query_580136, "prettyPrint", newJBool(prettyPrint))
  result = call_580134.call(path_580135, query_580136, nil, nil, body_580137)

var cloudsearchIndexingDatasourcesItemsDeleteQueueItems* = Call_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_580117(
    name: "cloudsearchIndexingDatasourcesItemsDeleteQueueItems",
    meth: HttpMethod.HttpPost, host: "cloudsearch.googleapis.com",
    route: "/v1/indexing/{name}/items:deleteQueueItems",
    validator: validate_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_580118,
    base: "/", url: url_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_580119,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsPoll_580138 = ref object of OpenApiRestCall_579421
proc url_CloudsearchIndexingDatasourcesItemsPoll_580140(protocol: Scheme;
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

proc validate_CloudsearchIndexingDatasourcesItemsPoll_580139(path: JsonNode;
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
  var valid_580141 = path.getOrDefault("name")
  valid_580141 = validateParameter(valid_580141, JString, required = true,
                                 default = nil)
  if valid_580141 != nil:
    section.add "name", valid_580141
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
  var valid_580142 = query.getOrDefault("upload_protocol")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "upload_protocol", valid_580142
  var valid_580143 = query.getOrDefault("fields")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "fields", valid_580143
  var valid_580144 = query.getOrDefault("quotaUser")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "quotaUser", valid_580144
  var valid_580145 = query.getOrDefault("alt")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = newJString("json"))
  if valid_580145 != nil:
    section.add "alt", valid_580145
  var valid_580146 = query.getOrDefault("oauth_token")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "oauth_token", valid_580146
  var valid_580147 = query.getOrDefault("callback")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "callback", valid_580147
  var valid_580148 = query.getOrDefault("access_token")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "access_token", valid_580148
  var valid_580149 = query.getOrDefault("uploadType")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "uploadType", valid_580149
  var valid_580150 = query.getOrDefault("key")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "key", valid_580150
  var valid_580151 = query.getOrDefault("$.xgafv")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = newJString("1"))
  if valid_580151 != nil:
    section.add "$.xgafv", valid_580151
  var valid_580152 = query.getOrDefault("prettyPrint")
  valid_580152 = validateParameter(valid_580152, JBool, required = false,
                                 default = newJBool(true))
  if valid_580152 != nil:
    section.add "prettyPrint", valid_580152
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

proc call*(call_580154: Call_CloudsearchIndexingDatasourcesItemsPoll_580138;
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
  let valid = call_580154.validator(path, query, header, formData, body)
  let scheme = call_580154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580154.url(scheme.get, call_580154.host, call_580154.base,
                         call_580154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580154, url, valid)

proc call*(call_580155: Call_CloudsearchIndexingDatasourcesItemsPoll_580138;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the Data Source to poll items.
  ## Format: datasources/{source_id}
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580156 = newJObject()
  var query_580157 = newJObject()
  var body_580158 = newJObject()
  add(query_580157, "upload_protocol", newJString(uploadProtocol))
  add(query_580157, "fields", newJString(fields))
  add(query_580157, "quotaUser", newJString(quotaUser))
  add(path_580156, "name", newJString(name))
  add(query_580157, "alt", newJString(alt))
  add(query_580157, "oauth_token", newJString(oauthToken))
  add(query_580157, "callback", newJString(callback))
  add(query_580157, "access_token", newJString(accessToken))
  add(query_580157, "uploadType", newJString(uploadType))
  add(query_580157, "key", newJString(key))
  add(query_580157, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580158 = body
  add(query_580157, "prettyPrint", newJBool(prettyPrint))
  result = call_580155.call(path_580156, query_580157, nil, nil, body_580158)

var cloudsearchIndexingDatasourcesItemsPoll* = Call_CloudsearchIndexingDatasourcesItemsPoll_580138(
    name: "cloudsearchIndexingDatasourcesItemsPoll", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}/items:poll",
    validator: validate_CloudsearchIndexingDatasourcesItemsPoll_580139, base: "/",
    url: url_CloudsearchIndexingDatasourcesItemsPoll_580140,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsUnreserve_580159 = ref object of OpenApiRestCall_579421
proc url_CloudsearchIndexingDatasourcesItemsUnreserve_580161(protocol: Scheme;
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

proc validate_CloudsearchIndexingDatasourcesItemsUnreserve_580160(path: JsonNode;
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
  var valid_580162 = path.getOrDefault("name")
  valid_580162 = validateParameter(valid_580162, JString, required = true,
                                 default = nil)
  if valid_580162 != nil:
    section.add "name", valid_580162
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
  var valid_580163 = query.getOrDefault("upload_protocol")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "upload_protocol", valid_580163
  var valid_580164 = query.getOrDefault("fields")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "fields", valid_580164
  var valid_580165 = query.getOrDefault("quotaUser")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "quotaUser", valid_580165
  var valid_580166 = query.getOrDefault("alt")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = newJString("json"))
  if valid_580166 != nil:
    section.add "alt", valid_580166
  var valid_580167 = query.getOrDefault("oauth_token")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "oauth_token", valid_580167
  var valid_580168 = query.getOrDefault("callback")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "callback", valid_580168
  var valid_580169 = query.getOrDefault("access_token")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "access_token", valid_580169
  var valid_580170 = query.getOrDefault("uploadType")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "uploadType", valid_580170
  var valid_580171 = query.getOrDefault("key")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "key", valid_580171
  var valid_580172 = query.getOrDefault("$.xgafv")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = newJString("1"))
  if valid_580172 != nil:
    section.add "$.xgafv", valid_580172
  var valid_580173 = query.getOrDefault("prettyPrint")
  valid_580173 = validateParameter(valid_580173, JBool, required = false,
                                 default = newJBool(true))
  if valid_580173 != nil:
    section.add "prettyPrint", valid_580173
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

proc call*(call_580175: Call_CloudsearchIndexingDatasourcesItemsUnreserve_580159;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unreserves all items from a queue, making them all eligible to be
  ## polled.  This method is useful for resetting the indexing queue
  ## after a connector has been restarted.
  ## 
  let valid = call_580175.validator(path, query, header, formData, body)
  let scheme = call_580175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580175.url(scheme.get, call_580175.host, call_580175.base,
                         call_580175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580175, url, valid)

proc call*(call_580176: Call_CloudsearchIndexingDatasourcesItemsUnreserve_580159;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudsearchIndexingDatasourcesItemsUnreserve
  ## Unreserves all items from a queue, making them all eligible to be
  ## polled.  This method is useful for resetting the indexing queue
  ## after a connector has been restarted.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the Data Source to unreserve all items.
  ## Format: datasources/{source_id}
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580177 = newJObject()
  var query_580178 = newJObject()
  var body_580179 = newJObject()
  add(query_580178, "upload_protocol", newJString(uploadProtocol))
  add(query_580178, "fields", newJString(fields))
  add(query_580178, "quotaUser", newJString(quotaUser))
  add(path_580177, "name", newJString(name))
  add(query_580178, "alt", newJString(alt))
  add(query_580178, "oauth_token", newJString(oauthToken))
  add(query_580178, "callback", newJString(callback))
  add(query_580178, "access_token", newJString(accessToken))
  add(query_580178, "uploadType", newJString(uploadType))
  add(query_580178, "key", newJString(key))
  add(query_580178, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580179 = body
  add(query_580178, "prettyPrint", newJBool(prettyPrint))
  result = call_580176.call(path_580177, query_580178, nil, nil, body_580179)

var cloudsearchIndexingDatasourcesItemsUnreserve* = Call_CloudsearchIndexingDatasourcesItemsUnreserve_580159(
    name: "cloudsearchIndexingDatasourcesItemsUnreserve",
    meth: HttpMethod.HttpPost, host: "cloudsearch.googleapis.com",
    route: "/v1/indexing/{name}/items:unreserve",
    validator: validate_CloudsearchIndexingDatasourcesItemsUnreserve_580160,
    base: "/", url: url_CloudsearchIndexingDatasourcesItemsUnreserve_580161,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesUpdateSchema_580200 = ref object of OpenApiRestCall_579421
proc url_CloudsearchIndexingDatasourcesUpdateSchema_580202(protocol: Scheme;
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

proc validate_CloudsearchIndexingDatasourcesUpdateSchema_580201(path: JsonNode;
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
  var valid_580203 = path.getOrDefault("name")
  valid_580203 = validateParameter(valid_580203, JString, required = true,
                                 default = nil)
  if valid_580203 != nil:
    section.add "name", valid_580203
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
  var valid_580204 = query.getOrDefault("upload_protocol")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "upload_protocol", valid_580204
  var valid_580205 = query.getOrDefault("fields")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "fields", valid_580205
  var valid_580206 = query.getOrDefault("quotaUser")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "quotaUser", valid_580206
  var valid_580207 = query.getOrDefault("alt")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = newJString("json"))
  if valid_580207 != nil:
    section.add "alt", valid_580207
  var valid_580208 = query.getOrDefault("oauth_token")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "oauth_token", valid_580208
  var valid_580209 = query.getOrDefault("callback")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "callback", valid_580209
  var valid_580210 = query.getOrDefault("access_token")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "access_token", valid_580210
  var valid_580211 = query.getOrDefault("uploadType")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "uploadType", valid_580211
  var valid_580212 = query.getOrDefault("key")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "key", valid_580212
  var valid_580213 = query.getOrDefault("$.xgafv")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = newJString("1"))
  if valid_580213 != nil:
    section.add "$.xgafv", valid_580213
  var valid_580214 = query.getOrDefault("prettyPrint")
  valid_580214 = validateParameter(valid_580214, JBool, required = false,
                                 default = newJBool(true))
  if valid_580214 != nil:
    section.add "prettyPrint", valid_580214
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

proc call*(call_580216: Call_CloudsearchIndexingDatasourcesUpdateSchema_580200;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the schema of a data source.
  ## 
  let valid = call_580216.validator(path, query, header, formData, body)
  let scheme = call_580216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580216.url(scheme.get, call_580216.host, call_580216.base,
                         call_580216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580216, url, valid)

proc call*(call_580217: Call_CloudsearchIndexingDatasourcesUpdateSchema_580200;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudsearchIndexingDatasourcesUpdateSchema
  ## Updates the schema of a data source.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the data source to update Schema.  Format:
  ## datasources/{source_id}
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580218 = newJObject()
  var query_580219 = newJObject()
  var body_580220 = newJObject()
  add(query_580219, "upload_protocol", newJString(uploadProtocol))
  add(query_580219, "fields", newJString(fields))
  add(query_580219, "quotaUser", newJString(quotaUser))
  add(path_580218, "name", newJString(name))
  add(query_580219, "alt", newJString(alt))
  add(query_580219, "oauth_token", newJString(oauthToken))
  add(query_580219, "callback", newJString(callback))
  add(query_580219, "access_token", newJString(accessToken))
  add(query_580219, "uploadType", newJString(uploadType))
  add(query_580219, "key", newJString(key))
  add(query_580219, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580220 = body
  add(query_580219, "prettyPrint", newJBool(prettyPrint))
  result = call_580217.call(path_580218, query_580219, nil, nil, body_580220)

var cloudsearchIndexingDatasourcesUpdateSchema* = Call_CloudsearchIndexingDatasourcesUpdateSchema_580200(
    name: "cloudsearchIndexingDatasourcesUpdateSchema", meth: HttpMethod.HttpPut,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}/schema",
    validator: validate_CloudsearchIndexingDatasourcesUpdateSchema_580201,
    base: "/", url: url_CloudsearchIndexingDatasourcesUpdateSchema_580202,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesGetSchema_580180 = ref object of OpenApiRestCall_579421
proc url_CloudsearchIndexingDatasourcesGetSchema_580182(protocol: Scheme;
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

proc validate_CloudsearchIndexingDatasourcesGetSchema_580181(path: JsonNode;
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
  var valid_580183 = path.getOrDefault("name")
  valid_580183 = validateParameter(valid_580183, JString, required = true,
                                 default = nil)
  if valid_580183 != nil:
    section.add "name", valid_580183
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
  ##   debugOptions.enableDebugging: JBool
  ##                               : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580184 = query.getOrDefault("upload_protocol")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "upload_protocol", valid_580184
  var valid_580185 = query.getOrDefault("fields")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "fields", valid_580185
  var valid_580186 = query.getOrDefault("quotaUser")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "quotaUser", valid_580186
  var valid_580187 = query.getOrDefault("alt")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = newJString("json"))
  if valid_580187 != nil:
    section.add "alt", valid_580187
  var valid_580188 = query.getOrDefault("oauth_token")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "oauth_token", valid_580188
  var valid_580189 = query.getOrDefault("callback")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "callback", valid_580189
  var valid_580190 = query.getOrDefault("access_token")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "access_token", valid_580190
  var valid_580191 = query.getOrDefault("uploadType")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "uploadType", valid_580191
  var valid_580192 = query.getOrDefault("key")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "key", valid_580192
  var valid_580193 = query.getOrDefault("debugOptions.enableDebugging")
  valid_580193 = validateParameter(valid_580193, JBool, required = false, default = nil)
  if valid_580193 != nil:
    section.add "debugOptions.enableDebugging", valid_580193
  var valid_580194 = query.getOrDefault("$.xgafv")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = newJString("1"))
  if valid_580194 != nil:
    section.add "$.xgafv", valid_580194
  var valid_580195 = query.getOrDefault("prettyPrint")
  valid_580195 = validateParameter(valid_580195, JBool, required = false,
                                 default = newJBool(true))
  if valid_580195 != nil:
    section.add "prettyPrint", valid_580195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580196: Call_CloudsearchIndexingDatasourcesGetSchema_580180;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the schema of a data source.
  ## 
  let valid = call_580196.validator(path, query, header, formData, body)
  let scheme = call_580196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580196.url(scheme.get, call_580196.host, call_580196.base,
                         call_580196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580196, url, valid)

proc call*(call_580197: Call_CloudsearchIndexingDatasourcesGetSchema_580180;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; debugOptionsEnableDebugging: bool = false;
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudsearchIndexingDatasourcesGetSchema
  ## Gets the schema of a data source.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the data source to get Schema.  Format:
  ## datasources/{source_id}
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
  ##   debugOptionsEnableDebugging: bool
  ##                              : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580198 = newJObject()
  var query_580199 = newJObject()
  add(query_580199, "upload_protocol", newJString(uploadProtocol))
  add(query_580199, "fields", newJString(fields))
  add(query_580199, "quotaUser", newJString(quotaUser))
  add(path_580198, "name", newJString(name))
  add(query_580199, "alt", newJString(alt))
  add(query_580199, "oauth_token", newJString(oauthToken))
  add(query_580199, "callback", newJString(callback))
  add(query_580199, "access_token", newJString(accessToken))
  add(query_580199, "uploadType", newJString(uploadType))
  add(query_580199, "key", newJString(key))
  add(query_580199, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_580199, "$.xgafv", newJString(Xgafv))
  add(query_580199, "prettyPrint", newJBool(prettyPrint))
  result = call_580197.call(path_580198, query_580199, nil, nil, nil)

var cloudsearchIndexingDatasourcesGetSchema* = Call_CloudsearchIndexingDatasourcesGetSchema_580180(
    name: "cloudsearchIndexingDatasourcesGetSchema", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}/schema",
    validator: validate_CloudsearchIndexingDatasourcesGetSchema_580181, base: "/",
    url: url_CloudsearchIndexingDatasourcesGetSchema_580182,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesDeleteSchema_580221 = ref object of OpenApiRestCall_579421
proc url_CloudsearchIndexingDatasourcesDeleteSchema_580223(protocol: Scheme;
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

proc validate_CloudsearchIndexingDatasourcesDeleteSchema_580222(path: JsonNode;
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
  var valid_580224 = path.getOrDefault("name")
  valid_580224 = validateParameter(valid_580224, JString, required = true,
                                 default = nil)
  if valid_580224 != nil:
    section.add "name", valid_580224
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
  ##   debugOptions.enableDebugging: JBool
  ##                               : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580225 = query.getOrDefault("upload_protocol")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "upload_protocol", valid_580225
  var valid_580226 = query.getOrDefault("fields")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "fields", valid_580226
  var valid_580227 = query.getOrDefault("quotaUser")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "quotaUser", valid_580227
  var valid_580228 = query.getOrDefault("alt")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = newJString("json"))
  if valid_580228 != nil:
    section.add "alt", valid_580228
  var valid_580229 = query.getOrDefault("oauth_token")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "oauth_token", valid_580229
  var valid_580230 = query.getOrDefault("callback")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "callback", valid_580230
  var valid_580231 = query.getOrDefault("access_token")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "access_token", valid_580231
  var valid_580232 = query.getOrDefault("uploadType")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "uploadType", valid_580232
  var valid_580233 = query.getOrDefault("key")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "key", valid_580233
  var valid_580234 = query.getOrDefault("debugOptions.enableDebugging")
  valid_580234 = validateParameter(valid_580234, JBool, required = false, default = nil)
  if valid_580234 != nil:
    section.add "debugOptions.enableDebugging", valid_580234
  var valid_580235 = query.getOrDefault("$.xgafv")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = newJString("1"))
  if valid_580235 != nil:
    section.add "$.xgafv", valid_580235
  var valid_580236 = query.getOrDefault("prettyPrint")
  valid_580236 = validateParameter(valid_580236, JBool, required = false,
                                 default = newJBool(true))
  if valid_580236 != nil:
    section.add "prettyPrint", valid_580236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580237: Call_CloudsearchIndexingDatasourcesDeleteSchema_580221;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the schema of a data source.
  ## 
  let valid = call_580237.validator(path, query, header, formData, body)
  let scheme = call_580237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580237.url(scheme.get, call_580237.host, call_580237.base,
                         call_580237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580237, url, valid)

proc call*(call_580238: Call_CloudsearchIndexingDatasourcesDeleteSchema_580221;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; debugOptionsEnableDebugging: bool = false;
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudsearchIndexingDatasourcesDeleteSchema
  ## Deletes the schema of a data source.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the data source to delete Schema.  Format:
  ## datasources/{source_id}
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
  ##   debugOptionsEnableDebugging: bool
  ##                              : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580239 = newJObject()
  var query_580240 = newJObject()
  add(query_580240, "upload_protocol", newJString(uploadProtocol))
  add(query_580240, "fields", newJString(fields))
  add(query_580240, "quotaUser", newJString(quotaUser))
  add(path_580239, "name", newJString(name))
  add(query_580240, "alt", newJString(alt))
  add(query_580240, "oauth_token", newJString(oauthToken))
  add(query_580240, "callback", newJString(callback))
  add(query_580240, "access_token", newJString(accessToken))
  add(query_580240, "uploadType", newJString(uploadType))
  add(query_580240, "key", newJString(key))
  add(query_580240, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_580240, "$.xgafv", newJString(Xgafv))
  add(query_580240, "prettyPrint", newJBool(prettyPrint))
  result = call_580238.call(path_580239, query_580240, nil, nil, nil)

var cloudsearchIndexingDatasourcesDeleteSchema* = Call_CloudsearchIndexingDatasourcesDeleteSchema_580221(
    name: "cloudsearchIndexingDatasourcesDeleteSchema",
    meth: HttpMethod.HttpDelete, host: "cloudsearch.googleapis.com",
    route: "/v1/indexing/{name}/schema",
    validator: validate_CloudsearchIndexingDatasourcesDeleteSchema_580222,
    base: "/", url: url_CloudsearchIndexingDatasourcesDeleteSchema_580223,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsIndex_580241 = ref object of OpenApiRestCall_579421
proc url_CloudsearchIndexingDatasourcesItemsIndex_580243(protocol: Scheme;
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

proc validate_CloudsearchIndexingDatasourcesItemsIndex_580242(path: JsonNode;
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
  var valid_580244 = path.getOrDefault("name")
  valid_580244 = validateParameter(valid_580244, JString, required = true,
                                 default = nil)
  if valid_580244 != nil:
    section.add "name", valid_580244
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
  var valid_580245 = query.getOrDefault("upload_protocol")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "upload_protocol", valid_580245
  var valid_580246 = query.getOrDefault("fields")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "fields", valid_580246
  var valid_580247 = query.getOrDefault("quotaUser")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "quotaUser", valid_580247
  var valid_580248 = query.getOrDefault("alt")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = newJString("json"))
  if valid_580248 != nil:
    section.add "alt", valid_580248
  var valid_580249 = query.getOrDefault("oauth_token")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "oauth_token", valid_580249
  var valid_580250 = query.getOrDefault("callback")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "callback", valid_580250
  var valid_580251 = query.getOrDefault("access_token")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "access_token", valid_580251
  var valid_580252 = query.getOrDefault("uploadType")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "uploadType", valid_580252
  var valid_580253 = query.getOrDefault("key")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "key", valid_580253
  var valid_580254 = query.getOrDefault("$.xgafv")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = newJString("1"))
  if valid_580254 != nil:
    section.add "$.xgafv", valid_580254
  var valid_580255 = query.getOrDefault("prettyPrint")
  valid_580255 = validateParameter(valid_580255, JBool, required = false,
                                 default = newJBool(true))
  if valid_580255 != nil:
    section.add "prettyPrint", valid_580255
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

proc call*(call_580257: Call_CloudsearchIndexingDatasourcesItemsIndex_580241;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates Item ACL, metadata, and
  ## content. It will insert the Item if it
  ## does not exist.
  ## This method does not support partial updates.  Fields with no provided
  ## values are cleared out in the Cloud Search index.
  ## 
  let valid = call_580257.validator(path, query, header, formData, body)
  let scheme = call_580257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580257.url(scheme.get, call_580257.host, call_580257.base,
                         call_580257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580257, url, valid)

proc call*(call_580258: Call_CloudsearchIndexingDatasourcesItemsIndex_580241;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudsearchIndexingDatasourcesItemsIndex
  ## Updates Item ACL, metadata, and
  ## content. It will insert the Item if it
  ## does not exist.
  ## This method does not support partial updates.  Fields with no provided
  ## values are cleared out in the Cloud Search index.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the Item. Format:
  ## datasources/{source_id}/items/{item_id}
  ## <br />This is a required field.
  ## The maximum length is 1536 characters.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580259 = newJObject()
  var query_580260 = newJObject()
  var body_580261 = newJObject()
  add(query_580260, "upload_protocol", newJString(uploadProtocol))
  add(query_580260, "fields", newJString(fields))
  add(query_580260, "quotaUser", newJString(quotaUser))
  add(path_580259, "name", newJString(name))
  add(query_580260, "alt", newJString(alt))
  add(query_580260, "oauth_token", newJString(oauthToken))
  add(query_580260, "callback", newJString(callback))
  add(query_580260, "access_token", newJString(accessToken))
  add(query_580260, "uploadType", newJString(uploadType))
  add(query_580260, "key", newJString(key))
  add(query_580260, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580261 = body
  add(query_580260, "prettyPrint", newJBool(prettyPrint))
  result = call_580258.call(path_580259, query_580260, nil, nil, body_580261)

var cloudsearchIndexingDatasourcesItemsIndex* = Call_CloudsearchIndexingDatasourcesItemsIndex_580241(
    name: "cloudsearchIndexingDatasourcesItemsIndex", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}:index",
    validator: validate_CloudsearchIndexingDatasourcesItemsIndex_580242,
    base: "/", url: url_CloudsearchIndexingDatasourcesItemsIndex_580243,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsPush_580262 = ref object of OpenApiRestCall_579421
proc url_CloudsearchIndexingDatasourcesItemsPush_580264(protocol: Scheme;
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

proc validate_CloudsearchIndexingDatasourcesItemsPush_580263(path: JsonNode;
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
  var valid_580265 = path.getOrDefault("name")
  valid_580265 = validateParameter(valid_580265, JString, required = true,
                                 default = nil)
  if valid_580265 != nil:
    section.add "name", valid_580265
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
  var valid_580266 = query.getOrDefault("upload_protocol")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "upload_protocol", valid_580266
  var valid_580267 = query.getOrDefault("fields")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "fields", valid_580267
  var valid_580268 = query.getOrDefault("quotaUser")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "quotaUser", valid_580268
  var valid_580269 = query.getOrDefault("alt")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = newJString("json"))
  if valid_580269 != nil:
    section.add "alt", valid_580269
  var valid_580270 = query.getOrDefault("oauth_token")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "oauth_token", valid_580270
  var valid_580271 = query.getOrDefault("callback")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "callback", valid_580271
  var valid_580272 = query.getOrDefault("access_token")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "access_token", valid_580272
  var valid_580273 = query.getOrDefault("uploadType")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "uploadType", valid_580273
  var valid_580274 = query.getOrDefault("key")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "key", valid_580274
  var valid_580275 = query.getOrDefault("$.xgafv")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = newJString("1"))
  if valid_580275 != nil:
    section.add "$.xgafv", valid_580275
  var valid_580276 = query.getOrDefault("prettyPrint")
  valid_580276 = validateParameter(valid_580276, JBool, required = false,
                                 default = newJBool(true))
  if valid_580276 != nil:
    section.add "prettyPrint", valid_580276
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

proc call*(call_580278: Call_CloudsearchIndexingDatasourcesItemsPush_580262;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Pushes an item onto a queue for later polling and updating.
  ## 
  let valid = call_580278.validator(path, query, header, formData, body)
  let scheme = call_580278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580278.url(scheme.get, call_580278.host, call_580278.base,
                         call_580278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580278, url, valid)

proc call*(call_580279: Call_CloudsearchIndexingDatasourcesItemsPush_580262;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudsearchIndexingDatasourcesItemsPush
  ## Pushes an item onto a queue for later polling and updating.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the item to
  ## push into the indexing queue.<br />
  ## Format: datasources/{source_id}/items/{ID}
  ## <br />This is a required field.
  ## The maximum length is 1536 characters.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580280 = newJObject()
  var query_580281 = newJObject()
  var body_580282 = newJObject()
  add(query_580281, "upload_protocol", newJString(uploadProtocol))
  add(query_580281, "fields", newJString(fields))
  add(query_580281, "quotaUser", newJString(quotaUser))
  add(path_580280, "name", newJString(name))
  add(query_580281, "alt", newJString(alt))
  add(query_580281, "oauth_token", newJString(oauthToken))
  add(query_580281, "callback", newJString(callback))
  add(query_580281, "access_token", newJString(accessToken))
  add(query_580281, "uploadType", newJString(uploadType))
  add(query_580281, "key", newJString(key))
  add(query_580281, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580282 = body
  add(query_580281, "prettyPrint", newJBool(prettyPrint))
  result = call_580279.call(path_580280, query_580281, nil, nil, body_580282)

var cloudsearchIndexingDatasourcesItemsPush* = Call_CloudsearchIndexingDatasourcesItemsPush_580262(
    name: "cloudsearchIndexingDatasourcesItemsPush", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}:push",
    validator: validate_CloudsearchIndexingDatasourcesItemsPush_580263, base: "/",
    url: url_CloudsearchIndexingDatasourcesItemsPush_580264,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsUpload_580283 = ref object of OpenApiRestCall_579421
proc url_CloudsearchIndexingDatasourcesItemsUpload_580285(protocol: Scheme;
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

proc validate_CloudsearchIndexingDatasourcesItemsUpload_580284(path: JsonNode;
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
  var valid_580286 = path.getOrDefault("name")
  valid_580286 = validateParameter(valid_580286, JString, required = true,
                                 default = nil)
  if valid_580286 != nil:
    section.add "name", valid_580286
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
  var valid_580287 = query.getOrDefault("upload_protocol")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "upload_protocol", valid_580287
  var valid_580288 = query.getOrDefault("fields")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "fields", valid_580288
  var valid_580289 = query.getOrDefault("quotaUser")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "quotaUser", valid_580289
  var valid_580290 = query.getOrDefault("alt")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = newJString("json"))
  if valid_580290 != nil:
    section.add "alt", valid_580290
  var valid_580291 = query.getOrDefault("oauth_token")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "oauth_token", valid_580291
  var valid_580292 = query.getOrDefault("callback")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = nil)
  if valid_580292 != nil:
    section.add "callback", valid_580292
  var valid_580293 = query.getOrDefault("access_token")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "access_token", valid_580293
  var valid_580294 = query.getOrDefault("uploadType")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "uploadType", valid_580294
  var valid_580295 = query.getOrDefault("key")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "key", valid_580295
  var valid_580296 = query.getOrDefault("$.xgafv")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = newJString("1"))
  if valid_580296 != nil:
    section.add "$.xgafv", valid_580296
  var valid_580297 = query.getOrDefault("prettyPrint")
  valid_580297 = validateParameter(valid_580297, JBool, required = false,
                                 default = newJBool(true))
  if valid_580297 != nil:
    section.add "prettyPrint", valid_580297
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

proc call*(call_580299: Call_CloudsearchIndexingDatasourcesItemsUpload_580283;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an upload session for uploading item content. For items smaller
  ## than 100 KB, it's easier to embed the content
  ## inline within
  ## an index request.
  ## 
  let valid = call_580299.validator(path, query, header, formData, body)
  let scheme = call_580299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580299.url(scheme.get, call_580299.host, call_580299.base,
                         call_580299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580299, url, valid)

proc call*(call_580300: Call_CloudsearchIndexingDatasourcesItemsUpload_580283;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudsearchIndexingDatasourcesItemsUpload
  ## Creates an upload session for uploading item content. For items smaller
  ## than 100 KB, it's easier to embed the content
  ## inline within
  ## an index request.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the Item to start a resumable upload.
  ## Format: datasources/{source_id}/items/{item_id}.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580301 = newJObject()
  var query_580302 = newJObject()
  var body_580303 = newJObject()
  add(query_580302, "upload_protocol", newJString(uploadProtocol))
  add(query_580302, "fields", newJString(fields))
  add(query_580302, "quotaUser", newJString(quotaUser))
  add(path_580301, "name", newJString(name))
  add(query_580302, "alt", newJString(alt))
  add(query_580302, "oauth_token", newJString(oauthToken))
  add(query_580302, "callback", newJString(callback))
  add(query_580302, "access_token", newJString(accessToken))
  add(query_580302, "uploadType", newJString(uploadType))
  add(query_580302, "key", newJString(key))
  add(query_580302, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580303 = body
  add(query_580302, "prettyPrint", newJBool(prettyPrint))
  result = call_580300.call(path_580301, query_580302, nil, nil, body_580303)

var cloudsearchIndexingDatasourcesItemsUpload* = Call_CloudsearchIndexingDatasourcesItemsUpload_580283(
    name: "cloudsearchIndexingDatasourcesItemsUpload", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}:upload",
    validator: validate_CloudsearchIndexingDatasourcesItemsUpload_580284,
    base: "/", url: url_CloudsearchIndexingDatasourcesItemsUpload_580285,
    schemes: {Scheme.Https})
type
  Call_CloudsearchMediaUpload_580304 = ref object of OpenApiRestCall_579421
proc url_CloudsearchMediaUpload_580306(protocol: Scheme; host: string; base: string;
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

proc validate_CloudsearchMediaUpload_580305(path: JsonNode; query: JsonNode;
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
  var valid_580307 = path.getOrDefault("resourceName")
  valid_580307 = validateParameter(valid_580307, JString, required = true,
                                 default = nil)
  if valid_580307 != nil:
    section.add "resourceName", valid_580307
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
  var valid_580308 = query.getOrDefault("upload_protocol")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "upload_protocol", valid_580308
  var valid_580309 = query.getOrDefault("fields")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "fields", valid_580309
  var valid_580310 = query.getOrDefault("quotaUser")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = nil)
  if valid_580310 != nil:
    section.add "quotaUser", valid_580310
  var valid_580311 = query.getOrDefault("alt")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = newJString("json"))
  if valid_580311 != nil:
    section.add "alt", valid_580311
  var valid_580312 = query.getOrDefault("oauth_token")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = nil)
  if valid_580312 != nil:
    section.add "oauth_token", valid_580312
  var valid_580313 = query.getOrDefault("callback")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "callback", valid_580313
  var valid_580314 = query.getOrDefault("access_token")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = nil)
  if valid_580314 != nil:
    section.add "access_token", valid_580314
  var valid_580315 = query.getOrDefault("uploadType")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "uploadType", valid_580315
  var valid_580316 = query.getOrDefault("key")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "key", valid_580316
  var valid_580317 = query.getOrDefault("$.xgafv")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = newJString("1"))
  if valid_580317 != nil:
    section.add "$.xgafv", valid_580317
  var valid_580318 = query.getOrDefault("prettyPrint")
  valid_580318 = validateParameter(valid_580318, JBool, required = false,
                                 default = newJBool(true))
  if valid_580318 != nil:
    section.add "prettyPrint", valid_580318
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

proc call*(call_580320: Call_CloudsearchMediaUpload_580304; path: JsonNode;
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
  let valid = call_580320.validator(path, query, header, formData, body)
  let scheme = call_580320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580320.url(scheme.get, call_580320.host, call_580320.base,
                         call_580320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580320, url, valid)

proc call*(call_580321: Call_CloudsearchMediaUpload_580304; resourceName: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   resourceName: string (required)
  ##               : Name of the media that is being downloaded.  See
  ## ReadRequest.resource_name.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580322 = newJObject()
  var query_580323 = newJObject()
  var body_580324 = newJObject()
  add(query_580323, "upload_protocol", newJString(uploadProtocol))
  add(query_580323, "fields", newJString(fields))
  add(query_580323, "quotaUser", newJString(quotaUser))
  add(query_580323, "alt", newJString(alt))
  add(query_580323, "oauth_token", newJString(oauthToken))
  add(query_580323, "callback", newJString(callback))
  add(query_580323, "access_token", newJString(accessToken))
  add(query_580323, "uploadType", newJString(uploadType))
  add(path_580322, "resourceName", newJString(resourceName))
  add(query_580323, "key", newJString(key))
  add(query_580323, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580324 = body
  add(query_580323, "prettyPrint", newJBool(prettyPrint))
  result = call_580321.call(path_580322, query_580323, nil, nil, body_580324)

var cloudsearchMediaUpload* = Call_CloudsearchMediaUpload_580304(
    name: "cloudsearchMediaUpload", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/media/{resourceName}",
    validator: validate_CloudsearchMediaUpload_580305, base: "/",
    url: url_CloudsearchMediaUpload_580306, schemes: {Scheme.Https})
type
  Call_CloudsearchQuerySearch_580325 = ref object of OpenApiRestCall_579421
proc url_CloudsearchQuerySearch_580327(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudsearchQuerySearch_580326(path: JsonNode; query: JsonNode;
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
  var valid_580328 = query.getOrDefault("upload_protocol")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "upload_protocol", valid_580328
  var valid_580329 = query.getOrDefault("fields")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "fields", valid_580329
  var valid_580330 = query.getOrDefault("quotaUser")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = nil)
  if valid_580330 != nil:
    section.add "quotaUser", valid_580330
  var valid_580331 = query.getOrDefault("alt")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = newJString("json"))
  if valid_580331 != nil:
    section.add "alt", valid_580331
  var valid_580332 = query.getOrDefault("oauth_token")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = nil)
  if valid_580332 != nil:
    section.add "oauth_token", valid_580332
  var valid_580333 = query.getOrDefault("callback")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "callback", valid_580333
  var valid_580334 = query.getOrDefault("access_token")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = nil)
  if valid_580334 != nil:
    section.add "access_token", valid_580334
  var valid_580335 = query.getOrDefault("uploadType")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = nil)
  if valid_580335 != nil:
    section.add "uploadType", valid_580335
  var valid_580336 = query.getOrDefault("key")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "key", valid_580336
  var valid_580337 = query.getOrDefault("$.xgafv")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = newJString("1"))
  if valid_580337 != nil:
    section.add "$.xgafv", valid_580337
  var valid_580338 = query.getOrDefault("prettyPrint")
  valid_580338 = validateParameter(valid_580338, JBool, required = false,
                                 default = newJBool(true))
  if valid_580338 != nil:
    section.add "prettyPrint", valid_580338
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

proc call*(call_580340: Call_CloudsearchQuerySearch_580325; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Cloud Search Query API provides the search method, which returns
  ## the most relevant results from a user query.  The results can come from
  ## G Suite Apps, such as Gmail or Google Drive, or they can come from data
  ## that you have indexed from a third party.
  ## 
  let valid = call_580340.validator(path, query, header, formData, body)
  let scheme = call_580340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580340.url(scheme.get, call_580340.host, call_580340.base,
                         call_580340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580340, url, valid)

proc call*(call_580341: Call_CloudsearchQuerySearch_580325;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## cloudsearchQuerySearch
  ## The Cloud Search Query API provides the search method, which returns
  ## the most relevant results from a user query.  The results can come from
  ## G Suite Apps, such as Gmail or Google Drive, or they can come from data
  ## that you have indexed from a third party.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580342 = newJObject()
  var body_580343 = newJObject()
  add(query_580342, "upload_protocol", newJString(uploadProtocol))
  add(query_580342, "fields", newJString(fields))
  add(query_580342, "quotaUser", newJString(quotaUser))
  add(query_580342, "alt", newJString(alt))
  add(query_580342, "oauth_token", newJString(oauthToken))
  add(query_580342, "callback", newJString(callback))
  add(query_580342, "access_token", newJString(accessToken))
  add(query_580342, "uploadType", newJString(uploadType))
  add(query_580342, "key", newJString(key))
  add(query_580342, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580343 = body
  add(query_580342, "prettyPrint", newJBool(prettyPrint))
  result = call_580341.call(nil, query_580342, nil, nil, body_580343)

var cloudsearchQuerySearch* = Call_CloudsearchQuerySearch_580325(
    name: "cloudsearchQuerySearch", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/query/search",
    validator: validate_CloudsearchQuerySearch_580326, base: "/",
    url: url_CloudsearchQuerySearch_580327, schemes: {Scheme.Https})
type
  Call_CloudsearchQuerySourcesList_580344 = ref object of OpenApiRestCall_579421
proc url_CloudsearchQuerySourcesList_580346(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudsearchQuerySourcesList_580345(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns list of sources that user can use for Search and Suggest APIs.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Number of sources to return in the response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   requestOptions.searchApplicationId: JString
  ##                                     : Id of the application created using SearchApplicationsService.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   requestOptions.debugOptions.enableDebugging: JBool
  ##                                              : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   requestOptions.timeZone: JString
  ##                          : Current user's time zone id, such as "America/Los_Angeles" or
  ## "Australia/Sydney". These IDs are defined by
  ## [Unicode Common Locale Data Repository (CLDR)](http://cldr.unicode.org/)
  ## project, and currently available in the file
  ## [timezone.xml](http://unicode.org/repos/cldr/trunk/common/bcp47/timezone.xml).
  ## This field is used to correctly interpret date and time queries.
  ## If this field is not specified, the default time zone (UTC) is used.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580347 = query.getOrDefault("upload_protocol")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = nil)
  if valid_580347 != nil:
    section.add "upload_protocol", valid_580347
  var valid_580348 = query.getOrDefault("fields")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = nil)
  if valid_580348 != nil:
    section.add "fields", valid_580348
  var valid_580349 = query.getOrDefault("pageToken")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "pageToken", valid_580349
  var valid_580350 = query.getOrDefault("quotaUser")
  valid_580350 = validateParameter(valid_580350, JString, required = false,
                                 default = nil)
  if valid_580350 != nil:
    section.add "quotaUser", valid_580350
  var valid_580351 = query.getOrDefault("alt")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = newJString("json"))
  if valid_580351 != nil:
    section.add "alt", valid_580351
  var valid_580352 = query.getOrDefault("requestOptions.searchApplicationId")
  valid_580352 = validateParameter(valid_580352, JString, required = false,
                                 default = nil)
  if valid_580352 != nil:
    section.add "requestOptions.searchApplicationId", valid_580352
  var valid_580353 = query.getOrDefault("oauth_token")
  valid_580353 = validateParameter(valid_580353, JString, required = false,
                                 default = nil)
  if valid_580353 != nil:
    section.add "oauth_token", valid_580353
  var valid_580354 = query.getOrDefault("callback")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = nil)
  if valid_580354 != nil:
    section.add "callback", valid_580354
  var valid_580355 = query.getOrDefault("access_token")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "access_token", valid_580355
  var valid_580356 = query.getOrDefault("uploadType")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = nil)
  if valid_580356 != nil:
    section.add "uploadType", valid_580356
  var valid_580357 = query.getOrDefault("requestOptions.languageCode")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = nil)
  if valid_580357 != nil:
    section.add "requestOptions.languageCode", valid_580357
  var valid_580358 = query.getOrDefault("key")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = nil)
  if valid_580358 != nil:
    section.add "key", valid_580358
  var valid_580359 = query.getOrDefault("requestOptions.debugOptions.enableDebugging")
  valid_580359 = validateParameter(valid_580359, JBool, required = false, default = nil)
  if valid_580359 != nil:
    section.add "requestOptions.debugOptions.enableDebugging", valid_580359
  var valid_580360 = query.getOrDefault("$.xgafv")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = newJString("1"))
  if valid_580360 != nil:
    section.add "$.xgafv", valid_580360
  var valid_580361 = query.getOrDefault("requestOptions.timeZone")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "requestOptions.timeZone", valid_580361
  var valid_580362 = query.getOrDefault("prettyPrint")
  valid_580362 = validateParameter(valid_580362, JBool, required = false,
                                 default = newJBool(true))
  if valid_580362 != nil:
    section.add "prettyPrint", valid_580362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580363: Call_CloudsearchQuerySourcesList_580344; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns list of sources that user can use for Search and Suggest APIs.
  ## 
  let valid = call_580363.validator(path, query, header, formData, body)
  let scheme = call_580363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580363.url(scheme.get, call_580363.host, call_580363.base,
                         call_580363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580363, url, valid)

proc call*(call_580364: Call_CloudsearchQuerySourcesList_580344;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json";
          requestOptionsSearchApplicationId: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          requestOptionsLanguageCode: string = ""; key: string = "";
          requestOptionsDebugOptionsEnableDebugging: bool = false;
          Xgafv: string = "1"; requestOptionsTimeZone: string = "";
          prettyPrint: bool = true): Recallable =
  ## cloudsearchQuerySourcesList
  ## Returns list of sources that user can use for Search and Suggest APIs.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Number of sources to return in the response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   requestOptionsSearchApplicationId: string
  ##                                    : Id of the application created using SearchApplicationsService.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   requestOptionsDebugOptionsEnableDebugging: bool
  ##                                            : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   requestOptionsTimeZone: string
  ##                         : Current user's time zone id, such as "America/Los_Angeles" or
  ## "Australia/Sydney". These IDs are defined by
  ## [Unicode Common Locale Data Repository (CLDR)](http://cldr.unicode.org/)
  ## project, and currently available in the file
  ## [timezone.xml](http://unicode.org/repos/cldr/trunk/common/bcp47/timezone.xml).
  ## This field is used to correctly interpret date and time queries.
  ## If this field is not specified, the default time zone (UTC) is used.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580365 = newJObject()
  add(query_580365, "upload_protocol", newJString(uploadProtocol))
  add(query_580365, "fields", newJString(fields))
  add(query_580365, "pageToken", newJString(pageToken))
  add(query_580365, "quotaUser", newJString(quotaUser))
  add(query_580365, "alt", newJString(alt))
  add(query_580365, "requestOptions.searchApplicationId",
      newJString(requestOptionsSearchApplicationId))
  add(query_580365, "oauth_token", newJString(oauthToken))
  add(query_580365, "callback", newJString(callback))
  add(query_580365, "access_token", newJString(accessToken))
  add(query_580365, "uploadType", newJString(uploadType))
  add(query_580365, "requestOptions.languageCode",
      newJString(requestOptionsLanguageCode))
  add(query_580365, "key", newJString(key))
  add(query_580365, "requestOptions.debugOptions.enableDebugging",
      newJBool(requestOptionsDebugOptionsEnableDebugging))
  add(query_580365, "$.xgafv", newJString(Xgafv))
  add(query_580365, "requestOptions.timeZone", newJString(requestOptionsTimeZone))
  add(query_580365, "prettyPrint", newJBool(prettyPrint))
  result = call_580364.call(nil, query_580365, nil, nil, nil)

var cloudsearchQuerySourcesList* = Call_CloudsearchQuerySourcesList_580344(
    name: "cloudsearchQuerySourcesList", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/query/sources",
    validator: validate_CloudsearchQuerySourcesList_580345, base: "/",
    url: url_CloudsearchQuerySourcesList_580346, schemes: {Scheme.Https})
type
  Call_CloudsearchQuerySuggest_580366 = ref object of OpenApiRestCall_579421
proc url_CloudsearchQuerySuggest_580368(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudsearchQuerySuggest_580367(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provides suggestions for autocompleting the query.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  var valid_580369 = query.getOrDefault("upload_protocol")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = nil)
  if valid_580369 != nil:
    section.add "upload_protocol", valid_580369
  var valid_580370 = query.getOrDefault("fields")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "fields", valid_580370
  var valid_580371 = query.getOrDefault("quotaUser")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "quotaUser", valid_580371
  var valid_580372 = query.getOrDefault("alt")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = newJString("json"))
  if valid_580372 != nil:
    section.add "alt", valid_580372
  var valid_580373 = query.getOrDefault("oauth_token")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = nil)
  if valid_580373 != nil:
    section.add "oauth_token", valid_580373
  var valid_580374 = query.getOrDefault("callback")
  valid_580374 = validateParameter(valid_580374, JString, required = false,
                                 default = nil)
  if valid_580374 != nil:
    section.add "callback", valid_580374
  var valid_580375 = query.getOrDefault("access_token")
  valid_580375 = validateParameter(valid_580375, JString, required = false,
                                 default = nil)
  if valid_580375 != nil:
    section.add "access_token", valid_580375
  var valid_580376 = query.getOrDefault("uploadType")
  valid_580376 = validateParameter(valid_580376, JString, required = false,
                                 default = nil)
  if valid_580376 != nil:
    section.add "uploadType", valid_580376
  var valid_580377 = query.getOrDefault("key")
  valid_580377 = validateParameter(valid_580377, JString, required = false,
                                 default = nil)
  if valid_580377 != nil:
    section.add "key", valid_580377
  var valid_580378 = query.getOrDefault("$.xgafv")
  valid_580378 = validateParameter(valid_580378, JString, required = false,
                                 default = newJString("1"))
  if valid_580378 != nil:
    section.add "$.xgafv", valid_580378
  var valid_580379 = query.getOrDefault("prettyPrint")
  valid_580379 = validateParameter(valid_580379, JBool, required = false,
                                 default = newJBool(true))
  if valid_580379 != nil:
    section.add "prettyPrint", valid_580379
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

proc call*(call_580381: Call_CloudsearchQuerySuggest_580366; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides suggestions for autocompleting the query.
  ## 
  let valid = call_580381.validator(path, query, header, formData, body)
  let scheme = call_580381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580381.url(scheme.get, call_580381.host, call_580381.base,
                         call_580381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580381, url, valid)

proc call*(call_580382: Call_CloudsearchQuerySuggest_580366;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## cloudsearchQuerySuggest
  ## Provides suggestions for autocompleting the query.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580383 = newJObject()
  var body_580384 = newJObject()
  add(query_580383, "upload_protocol", newJString(uploadProtocol))
  add(query_580383, "fields", newJString(fields))
  add(query_580383, "quotaUser", newJString(quotaUser))
  add(query_580383, "alt", newJString(alt))
  add(query_580383, "oauth_token", newJString(oauthToken))
  add(query_580383, "callback", newJString(callback))
  add(query_580383, "access_token", newJString(accessToken))
  add(query_580383, "uploadType", newJString(uploadType))
  add(query_580383, "key", newJString(key))
  add(query_580383, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580384 = body
  add(query_580383, "prettyPrint", newJBool(prettyPrint))
  result = call_580382.call(nil, query_580383, nil, nil, body_580384)

var cloudsearchQuerySuggest* = Call_CloudsearchQuerySuggest_580366(
    name: "cloudsearchQuerySuggest", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/query/suggest",
    validator: validate_CloudsearchQuerySuggest_580367, base: "/",
    url: url_CloudsearchQuerySuggest_580368, schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsDatasourcesCreate_580405 = ref object of OpenApiRestCall_579421
proc url_CloudsearchSettingsDatasourcesCreate_580407(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudsearchSettingsDatasourcesCreate_580406(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a datasource.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  var valid_580408 = query.getOrDefault("upload_protocol")
  valid_580408 = validateParameter(valid_580408, JString, required = false,
                                 default = nil)
  if valid_580408 != nil:
    section.add "upload_protocol", valid_580408
  var valid_580409 = query.getOrDefault("fields")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = nil)
  if valid_580409 != nil:
    section.add "fields", valid_580409
  var valid_580410 = query.getOrDefault("quotaUser")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = nil)
  if valid_580410 != nil:
    section.add "quotaUser", valid_580410
  var valid_580411 = query.getOrDefault("alt")
  valid_580411 = validateParameter(valid_580411, JString, required = false,
                                 default = newJString("json"))
  if valid_580411 != nil:
    section.add "alt", valid_580411
  var valid_580412 = query.getOrDefault("oauth_token")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = nil)
  if valid_580412 != nil:
    section.add "oauth_token", valid_580412
  var valid_580413 = query.getOrDefault("callback")
  valid_580413 = validateParameter(valid_580413, JString, required = false,
                                 default = nil)
  if valid_580413 != nil:
    section.add "callback", valid_580413
  var valid_580414 = query.getOrDefault("access_token")
  valid_580414 = validateParameter(valid_580414, JString, required = false,
                                 default = nil)
  if valid_580414 != nil:
    section.add "access_token", valid_580414
  var valid_580415 = query.getOrDefault("uploadType")
  valid_580415 = validateParameter(valid_580415, JString, required = false,
                                 default = nil)
  if valid_580415 != nil:
    section.add "uploadType", valid_580415
  var valid_580416 = query.getOrDefault("key")
  valid_580416 = validateParameter(valid_580416, JString, required = false,
                                 default = nil)
  if valid_580416 != nil:
    section.add "key", valid_580416
  var valid_580417 = query.getOrDefault("$.xgafv")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = newJString("1"))
  if valid_580417 != nil:
    section.add "$.xgafv", valid_580417
  var valid_580418 = query.getOrDefault("prettyPrint")
  valid_580418 = validateParameter(valid_580418, JBool, required = false,
                                 default = newJBool(true))
  if valid_580418 != nil:
    section.add "prettyPrint", valid_580418
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

proc call*(call_580420: Call_CloudsearchSettingsDatasourcesCreate_580405;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a datasource.
  ## 
  let valid = call_580420.validator(path, query, header, formData, body)
  let scheme = call_580420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580420.url(scheme.get, call_580420.host, call_580420.base,
                         call_580420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580420, url, valid)

proc call*(call_580421: Call_CloudsearchSettingsDatasourcesCreate_580405;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## cloudsearchSettingsDatasourcesCreate
  ## Creates a datasource.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580422 = newJObject()
  var body_580423 = newJObject()
  add(query_580422, "upload_protocol", newJString(uploadProtocol))
  add(query_580422, "fields", newJString(fields))
  add(query_580422, "quotaUser", newJString(quotaUser))
  add(query_580422, "alt", newJString(alt))
  add(query_580422, "oauth_token", newJString(oauthToken))
  add(query_580422, "callback", newJString(callback))
  add(query_580422, "access_token", newJString(accessToken))
  add(query_580422, "uploadType", newJString(uploadType))
  add(query_580422, "key", newJString(key))
  add(query_580422, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580423 = body
  add(query_580422, "prettyPrint", newJBool(prettyPrint))
  result = call_580421.call(nil, query_580422, nil, nil, body_580423)

var cloudsearchSettingsDatasourcesCreate* = Call_CloudsearchSettingsDatasourcesCreate_580405(
    name: "cloudsearchSettingsDatasourcesCreate", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/datasources",
    validator: validate_CloudsearchSettingsDatasourcesCreate_580406, base: "/",
    url: url_CloudsearchSettingsDatasourcesCreate_580407, schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsDatasourcesList_580385 = ref object of OpenApiRestCall_579421
proc url_CloudsearchSettingsDatasourcesList_580387(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudsearchSettingsDatasourcesList_580386(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists datasources.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Starting index of the results.
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
  ##   debugOptions.enableDebugging: JBool
  ##                               : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum number of datasources to fetch in a request.
  ## The max value is 100.
  ## <br />The default value is 10
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580388 = query.getOrDefault("upload_protocol")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = nil)
  if valid_580388 != nil:
    section.add "upload_protocol", valid_580388
  var valid_580389 = query.getOrDefault("fields")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "fields", valid_580389
  var valid_580390 = query.getOrDefault("pageToken")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = nil)
  if valid_580390 != nil:
    section.add "pageToken", valid_580390
  var valid_580391 = query.getOrDefault("quotaUser")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = nil)
  if valid_580391 != nil:
    section.add "quotaUser", valid_580391
  var valid_580392 = query.getOrDefault("alt")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = newJString("json"))
  if valid_580392 != nil:
    section.add "alt", valid_580392
  var valid_580393 = query.getOrDefault("oauth_token")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = nil)
  if valid_580393 != nil:
    section.add "oauth_token", valid_580393
  var valid_580394 = query.getOrDefault("callback")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = nil)
  if valid_580394 != nil:
    section.add "callback", valid_580394
  var valid_580395 = query.getOrDefault("access_token")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = nil)
  if valid_580395 != nil:
    section.add "access_token", valid_580395
  var valid_580396 = query.getOrDefault("uploadType")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = nil)
  if valid_580396 != nil:
    section.add "uploadType", valid_580396
  var valid_580397 = query.getOrDefault("key")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = nil)
  if valid_580397 != nil:
    section.add "key", valid_580397
  var valid_580398 = query.getOrDefault("debugOptions.enableDebugging")
  valid_580398 = validateParameter(valid_580398, JBool, required = false, default = nil)
  if valid_580398 != nil:
    section.add "debugOptions.enableDebugging", valid_580398
  var valid_580399 = query.getOrDefault("$.xgafv")
  valid_580399 = validateParameter(valid_580399, JString, required = false,
                                 default = newJString("1"))
  if valid_580399 != nil:
    section.add "$.xgafv", valid_580399
  var valid_580400 = query.getOrDefault("pageSize")
  valid_580400 = validateParameter(valid_580400, JInt, required = false, default = nil)
  if valid_580400 != nil:
    section.add "pageSize", valid_580400
  var valid_580401 = query.getOrDefault("prettyPrint")
  valid_580401 = validateParameter(valid_580401, JBool, required = false,
                                 default = newJBool(true))
  if valid_580401 != nil:
    section.add "prettyPrint", valid_580401
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580402: Call_CloudsearchSettingsDatasourcesList_580385;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists datasources.
  ## 
  let valid = call_580402.validator(path, query, header, formData, body)
  let scheme = call_580402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580402.url(scheme.get, call_580402.host, call_580402.base,
                         call_580402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580402, url, valid)

proc call*(call_580403: Call_CloudsearchSettingsDatasourcesList_580385;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; debugOptionsEnableDebugging: bool = false;
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## cloudsearchSettingsDatasourcesList
  ## Lists datasources.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Starting index of the results.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   debugOptionsEnableDebugging: bool
  ##                              : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of datasources to fetch in a request.
  ## The max value is 100.
  ## <br />The default value is 10
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580404 = newJObject()
  add(query_580404, "upload_protocol", newJString(uploadProtocol))
  add(query_580404, "fields", newJString(fields))
  add(query_580404, "pageToken", newJString(pageToken))
  add(query_580404, "quotaUser", newJString(quotaUser))
  add(query_580404, "alt", newJString(alt))
  add(query_580404, "oauth_token", newJString(oauthToken))
  add(query_580404, "callback", newJString(callback))
  add(query_580404, "access_token", newJString(accessToken))
  add(query_580404, "uploadType", newJString(uploadType))
  add(query_580404, "key", newJString(key))
  add(query_580404, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_580404, "$.xgafv", newJString(Xgafv))
  add(query_580404, "pageSize", newJInt(pageSize))
  add(query_580404, "prettyPrint", newJBool(prettyPrint))
  result = call_580403.call(nil, query_580404, nil, nil, nil)

var cloudsearchSettingsDatasourcesList* = Call_CloudsearchSettingsDatasourcesList_580385(
    name: "cloudsearchSettingsDatasourcesList", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/datasources",
    validator: validate_CloudsearchSettingsDatasourcesList_580386, base: "/",
    url: url_CloudsearchSettingsDatasourcesList_580387, schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsSearchapplicationsCreate_580444 = ref object of OpenApiRestCall_579421
proc url_CloudsearchSettingsSearchapplicationsCreate_580446(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudsearchSettingsSearchapplicationsCreate_580445(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a search application.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  var valid_580447 = query.getOrDefault("upload_protocol")
  valid_580447 = validateParameter(valid_580447, JString, required = false,
                                 default = nil)
  if valid_580447 != nil:
    section.add "upload_protocol", valid_580447
  var valid_580448 = query.getOrDefault("fields")
  valid_580448 = validateParameter(valid_580448, JString, required = false,
                                 default = nil)
  if valid_580448 != nil:
    section.add "fields", valid_580448
  var valid_580449 = query.getOrDefault("quotaUser")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = nil)
  if valid_580449 != nil:
    section.add "quotaUser", valid_580449
  var valid_580450 = query.getOrDefault("alt")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = newJString("json"))
  if valid_580450 != nil:
    section.add "alt", valid_580450
  var valid_580451 = query.getOrDefault("oauth_token")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = nil)
  if valid_580451 != nil:
    section.add "oauth_token", valid_580451
  var valid_580452 = query.getOrDefault("callback")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = nil)
  if valid_580452 != nil:
    section.add "callback", valid_580452
  var valid_580453 = query.getOrDefault("access_token")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = nil)
  if valid_580453 != nil:
    section.add "access_token", valid_580453
  var valid_580454 = query.getOrDefault("uploadType")
  valid_580454 = validateParameter(valid_580454, JString, required = false,
                                 default = nil)
  if valid_580454 != nil:
    section.add "uploadType", valid_580454
  var valid_580455 = query.getOrDefault("key")
  valid_580455 = validateParameter(valid_580455, JString, required = false,
                                 default = nil)
  if valid_580455 != nil:
    section.add "key", valid_580455
  var valid_580456 = query.getOrDefault("$.xgafv")
  valid_580456 = validateParameter(valid_580456, JString, required = false,
                                 default = newJString("1"))
  if valid_580456 != nil:
    section.add "$.xgafv", valid_580456
  var valid_580457 = query.getOrDefault("prettyPrint")
  valid_580457 = validateParameter(valid_580457, JBool, required = false,
                                 default = newJBool(true))
  if valid_580457 != nil:
    section.add "prettyPrint", valid_580457
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

proc call*(call_580459: Call_CloudsearchSettingsSearchapplicationsCreate_580444;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a search application.
  ## 
  let valid = call_580459.validator(path, query, header, formData, body)
  let scheme = call_580459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580459.url(scheme.get, call_580459.host, call_580459.base,
                         call_580459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580459, url, valid)

proc call*(call_580460: Call_CloudsearchSettingsSearchapplicationsCreate_580444;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## cloudsearchSettingsSearchapplicationsCreate
  ## Creates a search application.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580461 = newJObject()
  var body_580462 = newJObject()
  add(query_580461, "upload_protocol", newJString(uploadProtocol))
  add(query_580461, "fields", newJString(fields))
  add(query_580461, "quotaUser", newJString(quotaUser))
  add(query_580461, "alt", newJString(alt))
  add(query_580461, "oauth_token", newJString(oauthToken))
  add(query_580461, "callback", newJString(callback))
  add(query_580461, "access_token", newJString(accessToken))
  add(query_580461, "uploadType", newJString(uploadType))
  add(query_580461, "key", newJString(key))
  add(query_580461, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580462 = body
  add(query_580461, "prettyPrint", newJBool(prettyPrint))
  result = call_580460.call(nil, query_580461, nil, nil, body_580462)

var cloudsearchSettingsSearchapplicationsCreate* = Call_CloudsearchSettingsSearchapplicationsCreate_580444(
    name: "cloudsearchSettingsSearchapplicationsCreate",
    meth: HttpMethod.HttpPost, host: "cloudsearch.googleapis.com",
    route: "/v1/settings/searchapplications",
    validator: validate_CloudsearchSettingsSearchapplicationsCreate_580445,
    base: "/", url: url_CloudsearchSettingsSearchapplicationsCreate_580446,
    schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsSearchapplicationsList_580424 = ref object of OpenApiRestCall_579421
proc url_CloudsearchSettingsSearchapplicationsList_580426(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudsearchSettingsSearchapplicationsList_580425(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all search applications.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous List request, if any.
  ## <br/> The default value is 10
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
  ##   debugOptions.enableDebugging: JBool
  ##                               : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of items to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580427 = query.getOrDefault("upload_protocol")
  valid_580427 = validateParameter(valid_580427, JString, required = false,
                                 default = nil)
  if valid_580427 != nil:
    section.add "upload_protocol", valid_580427
  var valid_580428 = query.getOrDefault("fields")
  valid_580428 = validateParameter(valid_580428, JString, required = false,
                                 default = nil)
  if valid_580428 != nil:
    section.add "fields", valid_580428
  var valid_580429 = query.getOrDefault("pageToken")
  valid_580429 = validateParameter(valid_580429, JString, required = false,
                                 default = nil)
  if valid_580429 != nil:
    section.add "pageToken", valid_580429
  var valid_580430 = query.getOrDefault("quotaUser")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = nil)
  if valid_580430 != nil:
    section.add "quotaUser", valid_580430
  var valid_580431 = query.getOrDefault("alt")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = newJString("json"))
  if valid_580431 != nil:
    section.add "alt", valid_580431
  var valid_580432 = query.getOrDefault("oauth_token")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "oauth_token", valid_580432
  var valid_580433 = query.getOrDefault("callback")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = nil)
  if valid_580433 != nil:
    section.add "callback", valid_580433
  var valid_580434 = query.getOrDefault("access_token")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = nil)
  if valid_580434 != nil:
    section.add "access_token", valid_580434
  var valid_580435 = query.getOrDefault("uploadType")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "uploadType", valid_580435
  var valid_580436 = query.getOrDefault("key")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = nil)
  if valid_580436 != nil:
    section.add "key", valid_580436
  var valid_580437 = query.getOrDefault("debugOptions.enableDebugging")
  valid_580437 = validateParameter(valid_580437, JBool, required = false, default = nil)
  if valid_580437 != nil:
    section.add "debugOptions.enableDebugging", valid_580437
  var valid_580438 = query.getOrDefault("$.xgafv")
  valid_580438 = validateParameter(valid_580438, JString, required = false,
                                 default = newJString("1"))
  if valid_580438 != nil:
    section.add "$.xgafv", valid_580438
  var valid_580439 = query.getOrDefault("pageSize")
  valid_580439 = validateParameter(valid_580439, JInt, required = false, default = nil)
  if valid_580439 != nil:
    section.add "pageSize", valid_580439
  var valid_580440 = query.getOrDefault("prettyPrint")
  valid_580440 = validateParameter(valid_580440, JBool, required = false,
                                 default = newJBool(true))
  if valid_580440 != nil:
    section.add "prettyPrint", valid_580440
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580441: Call_CloudsearchSettingsSearchapplicationsList_580424;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all search applications.
  ## 
  let valid = call_580441.validator(path, query, header, formData, body)
  let scheme = call_580441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580441.url(scheme.get, call_580441.host, call_580441.base,
                         call_580441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580441, url, valid)

proc call*(call_580442: Call_CloudsearchSettingsSearchapplicationsList_580424;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; debugOptionsEnableDebugging: bool = false;
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## cloudsearchSettingsSearchapplicationsList
  ## Lists all search applications.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous List request, if any.
  ## <br/> The default value is 10
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   debugOptionsEnableDebugging: bool
  ##                              : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580443 = newJObject()
  add(query_580443, "upload_protocol", newJString(uploadProtocol))
  add(query_580443, "fields", newJString(fields))
  add(query_580443, "pageToken", newJString(pageToken))
  add(query_580443, "quotaUser", newJString(quotaUser))
  add(query_580443, "alt", newJString(alt))
  add(query_580443, "oauth_token", newJString(oauthToken))
  add(query_580443, "callback", newJString(callback))
  add(query_580443, "access_token", newJString(accessToken))
  add(query_580443, "uploadType", newJString(uploadType))
  add(query_580443, "key", newJString(key))
  add(query_580443, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_580443, "$.xgafv", newJString(Xgafv))
  add(query_580443, "pageSize", newJInt(pageSize))
  add(query_580443, "prettyPrint", newJBool(prettyPrint))
  result = call_580442.call(nil, query_580443, nil, nil, nil)

var cloudsearchSettingsSearchapplicationsList* = Call_CloudsearchSettingsSearchapplicationsList_580424(
    name: "cloudsearchSettingsSearchapplicationsList", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/searchapplications",
    validator: validate_CloudsearchSettingsSearchapplicationsList_580425,
    base: "/", url: url_CloudsearchSettingsSearchapplicationsList_580426,
    schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsDatasourcesUpdate_580483 = ref object of OpenApiRestCall_579421
proc url_CloudsearchSettingsDatasourcesUpdate_580485(protocol: Scheme;
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

proc validate_CloudsearchSettingsDatasourcesUpdate_580484(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a datasource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the datasource resource.
  ## Format: datasources/{source_id}.
  ## <br />The name is ignored when creating a datasource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580486 = path.getOrDefault("name")
  valid_580486 = validateParameter(valid_580486, JString, required = true,
                                 default = nil)
  if valid_580486 != nil:
    section.add "name", valid_580486
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
  var valid_580487 = query.getOrDefault("upload_protocol")
  valid_580487 = validateParameter(valid_580487, JString, required = false,
                                 default = nil)
  if valid_580487 != nil:
    section.add "upload_protocol", valid_580487
  var valid_580488 = query.getOrDefault("fields")
  valid_580488 = validateParameter(valid_580488, JString, required = false,
                                 default = nil)
  if valid_580488 != nil:
    section.add "fields", valid_580488
  var valid_580489 = query.getOrDefault("quotaUser")
  valid_580489 = validateParameter(valid_580489, JString, required = false,
                                 default = nil)
  if valid_580489 != nil:
    section.add "quotaUser", valid_580489
  var valid_580490 = query.getOrDefault("alt")
  valid_580490 = validateParameter(valid_580490, JString, required = false,
                                 default = newJString("json"))
  if valid_580490 != nil:
    section.add "alt", valid_580490
  var valid_580491 = query.getOrDefault("oauth_token")
  valid_580491 = validateParameter(valid_580491, JString, required = false,
                                 default = nil)
  if valid_580491 != nil:
    section.add "oauth_token", valid_580491
  var valid_580492 = query.getOrDefault("callback")
  valid_580492 = validateParameter(valid_580492, JString, required = false,
                                 default = nil)
  if valid_580492 != nil:
    section.add "callback", valid_580492
  var valid_580493 = query.getOrDefault("access_token")
  valid_580493 = validateParameter(valid_580493, JString, required = false,
                                 default = nil)
  if valid_580493 != nil:
    section.add "access_token", valid_580493
  var valid_580494 = query.getOrDefault("uploadType")
  valid_580494 = validateParameter(valid_580494, JString, required = false,
                                 default = nil)
  if valid_580494 != nil:
    section.add "uploadType", valid_580494
  var valid_580495 = query.getOrDefault("key")
  valid_580495 = validateParameter(valid_580495, JString, required = false,
                                 default = nil)
  if valid_580495 != nil:
    section.add "key", valid_580495
  var valid_580496 = query.getOrDefault("$.xgafv")
  valid_580496 = validateParameter(valid_580496, JString, required = false,
                                 default = newJString("1"))
  if valid_580496 != nil:
    section.add "$.xgafv", valid_580496
  var valid_580497 = query.getOrDefault("prettyPrint")
  valid_580497 = validateParameter(valid_580497, JBool, required = false,
                                 default = newJBool(true))
  if valid_580497 != nil:
    section.add "prettyPrint", valid_580497
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

proc call*(call_580499: Call_CloudsearchSettingsDatasourcesUpdate_580483;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a datasource.
  ## 
  let valid = call_580499.validator(path, query, header, formData, body)
  let scheme = call_580499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580499.url(scheme.get, call_580499.host, call_580499.base,
                         call_580499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580499, url, valid)

proc call*(call_580500: Call_CloudsearchSettingsDatasourcesUpdate_580483;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudsearchSettingsDatasourcesUpdate
  ## Updates a datasource.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the datasource resource.
  ## Format: datasources/{source_id}.
  ## <br />The name is ignored when creating a datasource.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580501 = newJObject()
  var query_580502 = newJObject()
  var body_580503 = newJObject()
  add(query_580502, "upload_protocol", newJString(uploadProtocol))
  add(query_580502, "fields", newJString(fields))
  add(query_580502, "quotaUser", newJString(quotaUser))
  add(path_580501, "name", newJString(name))
  add(query_580502, "alt", newJString(alt))
  add(query_580502, "oauth_token", newJString(oauthToken))
  add(query_580502, "callback", newJString(callback))
  add(query_580502, "access_token", newJString(accessToken))
  add(query_580502, "uploadType", newJString(uploadType))
  add(query_580502, "key", newJString(key))
  add(query_580502, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580503 = body
  add(query_580502, "prettyPrint", newJBool(prettyPrint))
  result = call_580500.call(path_580501, query_580502, nil, nil, body_580503)

var cloudsearchSettingsDatasourcesUpdate* = Call_CloudsearchSettingsDatasourcesUpdate_580483(
    name: "cloudsearchSettingsDatasourcesUpdate", meth: HttpMethod.HttpPut,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/{name}",
    validator: validate_CloudsearchSettingsDatasourcesUpdate_580484, base: "/",
    url: url_CloudsearchSettingsDatasourcesUpdate_580485, schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsDatasourcesGet_580463 = ref object of OpenApiRestCall_579421
proc url_CloudsearchSettingsDatasourcesGet_580465(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_CloudsearchSettingsDatasourcesGet_580464(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a datasource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the datasource resource.
  ## Format: datasources/{source_id}.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580466 = path.getOrDefault("name")
  valid_580466 = validateParameter(valid_580466, JString, required = true,
                                 default = nil)
  if valid_580466 != nil:
    section.add "name", valid_580466
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
  ##   debugOptions.enableDebugging: JBool
  ##                               : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580467 = query.getOrDefault("upload_protocol")
  valid_580467 = validateParameter(valid_580467, JString, required = false,
                                 default = nil)
  if valid_580467 != nil:
    section.add "upload_protocol", valid_580467
  var valid_580468 = query.getOrDefault("fields")
  valid_580468 = validateParameter(valid_580468, JString, required = false,
                                 default = nil)
  if valid_580468 != nil:
    section.add "fields", valid_580468
  var valid_580469 = query.getOrDefault("quotaUser")
  valid_580469 = validateParameter(valid_580469, JString, required = false,
                                 default = nil)
  if valid_580469 != nil:
    section.add "quotaUser", valid_580469
  var valid_580470 = query.getOrDefault("alt")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = newJString("json"))
  if valid_580470 != nil:
    section.add "alt", valid_580470
  var valid_580471 = query.getOrDefault("oauth_token")
  valid_580471 = validateParameter(valid_580471, JString, required = false,
                                 default = nil)
  if valid_580471 != nil:
    section.add "oauth_token", valid_580471
  var valid_580472 = query.getOrDefault("callback")
  valid_580472 = validateParameter(valid_580472, JString, required = false,
                                 default = nil)
  if valid_580472 != nil:
    section.add "callback", valid_580472
  var valid_580473 = query.getOrDefault("access_token")
  valid_580473 = validateParameter(valid_580473, JString, required = false,
                                 default = nil)
  if valid_580473 != nil:
    section.add "access_token", valid_580473
  var valid_580474 = query.getOrDefault("uploadType")
  valid_580474 = validateParameter(valid_580474, JString, required = false,
                                 default = nil)
  if valid_580474 != nil:
    section.add "uploadType", valid_580474
  var valid_580475 = query.getOrDefault("key")
  valid_580475 = validateParameter(valid_580475, JString, required = false,
                                 default = nil)
  if valid_580475 != nil:
    section.add "key", valid_580475
  var valid_580476 = query.getOrDefault("debugOptions.enableDebugging")
  valid_580476 = validateParameter(valid_580476, JBool, required = false, default = nil)
  if valid_580476 != nil:
    section.add "debugOptions.enableDebugging", valid_580476
  var valid_580477 = query.getOrDefault("$.xgafv")
  valid_580477 = validateParameter(valid_580477, JString, required = false,
                                 default = newJString("1"))
  if valid_580477 != nil:
    section.add "$.xgafv", valid_580477
  var valid_580478 = query.getOrDefault("prettyPrint")
  valid_580478 = validateParameter(valid_580478, JBool, required = false,
                                 default = newJBool(true))
  if valid_580478 != nil:
    section.add "prettyPrint", valid_580478
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580479: Call_CloudsearchSettingsDatasourcesGet_580463;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a datasource.
  ## 
  let valid = call_580479.validator(path, query, header, formData, body)
  let scheme = call_580479.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580479.url(scheme.get, call_580479.host, call_580479.base,
                         call_580479.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580479, url, valid)

proc call*(call_580480: Call_CloudsearchSettingsDatasourcesGet_580463;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; debugOptionsEnableDebugging: bool = false;
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudsearchSettingsDatasourcesGet
  ## Gets a datasource.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the datasource resource.
  ## Format: datasources/{source_id}.
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
  ##   debugOptionsEnableDebugging: bool
  ##                              : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580481 = newJObject()
  var query_580482 = newJObject()
  add(query_580482, "upload_protocol", newJString(uploadProtocol))
  add(query_580482, "fields", newJString(fields))
  add(query_580482, "quotaUser", newJString(quotaUser))
  add(path_580481, "name", newJString(name))
  add(query_580482, "alt", newJString(alt))
  add(query_580482, "oauth_token", newJString(oauthToken))
  add(query_580482, "callback", newJString(callback))
  add(query_580482, "access_token", newJString(accessToken))
  add(query_580482, "uploadType", newJString(uploadType))
  add(query_580482, "key", newJString(key))
  add(query_580482, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_580482, "$.xgafv", newJString(Xgafv))
  add(query_580482, "prettyPrint", newJBool(prettyPrint))
  result = call_580480.call(path_580481, query_580482, nil, nil, nil)

var cloudsearchSettingsDatasourcesGet* = Call_CloudsearchSettingsDatasourcesGet_580463(
    name: "cloudsearchSettingsDatasourcesGet", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/{name}",
    validator: validate_CloudsearchSettingsDatasourcesGet_580464, base: "/",
    url: url_CloudsearchSettingsDatasourcesGet_580465, schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsDatasourcesDelete_580504 = ref object of OpenApiRestCall_579421
proc url_CloudsearchSettingsDatasourcesDelete_580506(protocol: Scheme;
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

proc validate_CloudsearchSettingsDatasourcesDelete_580505(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a datasource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the datasource.
  ## Format: datasources/{source_id}.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580507 = path.getOrDefault("name")
  valid_580507 = validateParameter(valid_580507, JString, required = true,
                                 default = nil)
  if valid_580507 != nil:
    section.add "name", valid_580507
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
  ##   debugOptions.enableDebugging: JBool
  ##                               : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580508 = query.getOrDefault("upload_protocol")
  valid_580508 = validateParameter(valid_580508, JString, required = false,
                                 default = nil)
  if valid_580508 != nil:
    section.add "upload_protocol", valid_580508
  var valid_580509 = query.getOrDefault("fields")
  valid_580509 = validateParameter(valid_580509, JString, required = false,
                                 default = nil)
  if valid_580509 != nil:
    section.add "fields", valid_580509
  var valid_580510 = query.getOrDefault("quotaUser")
  valid_580510 = validateParameter(valid_580510, JString, required = false,
                                 default = nil)
  if valid_580510 != nil:
    section.add "quotaUser", valid_580510
  var valid_580511 = query.getOrDefault("alt")
  valid_580511 = validateParameter(valid_580511, JString, required = false,
                                 default = newJString("json"))
  if valid_580511 != nil:
    section.add "alt", valid_580511
  var valid_580512 = query.getOrDefault("oauth_token")
  valid_580512 = validateParameter(valid_580512, JString, required = false,
                                 default = nil)
  if valid_580512 != nil:
    section.add "oauth_token", valid_580512
  var valid_580513 = query.getOrDefault("callback")
  valid_580513 = validateParameter(valid_580513, JString, required = false,
                                 default = nil)
  if valid_580513 != nil:
    section.add "callback", valid_580513
  var valid_580514 = query.getOrDefault("access_token")
  valid_580514 = validateParameter(valid_580514, JString, required = false,
                                 default = nil)
  if valid_580514 != nil:
    section.add "access_token", valid_580514
  var valid_580515 = query.getOrDefault("uploadType")
  valid_580515 = validateParameter(valid_580515, JString, required = false,
                                 default = nil)
  if valid_580515 != nil:
    section.add "uploadType", valid_580515
  var valid_580516 = query.getOrDefault("key")
  valid_580516 = validateParameter(valid_580516, JString, required = false,
                                 default = nil)
  if valid_580516 != nil:
    section.add "key", valid_580516
  var valid_580517 = query.getOrDefault("debugOptions.enableDebugging")
  valid_580517 = validateParameter(valid_580517, JBool, required = false, default = nil)
  if valid_580517 != nil:
    section.add "debugOptions.enableDebugging", valid_580517
  var valid_580518 = query.getOrDefault("$.xgafv")
  valid_580518 = validateParameter(valid_580518, JString, required = false,
                                 default = newJString("1"))
  if valid_580518 != nil:
    section.add "$.xgafv", valid_580518
  var valid_580519 = query.getOrDefault("prettyPrint")
  valid_580519 = validateParameter(valid_580519, JBool, required = false,
                                 default = newJBool(true))
  if valid_580519 != nil:
    section.add "prettyPrint", valid_580519
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580520: Call_CloudsearchSettingsDatasourcesDelete_580504;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a datasource.
  ## 
  let valid = call_580520.validator(path, query, header, formData, body)
  let scheme = call_580520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580520.url(scheme.get, call_580520.host, call_580520.base,
                         call_580520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580520, url, valid)

proc call*(call_580521: Call_CloudsearchSettingsDatasourcesDelete_580504;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; debugOptionsEnableDebugging: bool = false;
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudsearchSettingsDatasourcesDelete
  ## Deletes a datasource.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the datasource.
  ## Format: datasources/{source_id}.
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
  ##   debugOptionsEnableDebugging: bool
  ##                              : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580522 = newJObject()
  var query_580523 = newJObject()
  add(query_580523, "upload_protocol", newJString(uploadProtocol))
  add(query_580523, "fields", newJString(fields))
  add(query_580523, "quotaUser", newJString(quotaUser))
  add(path_580522, "name", newJString(name))
  add(query_580523, "alt", newJString(alt))
  add(query_580523, "oauth_token", newJString(oauthToken))
  add(query_580523, "callback", newJString(callback))
  add(query_580523, "access_token", newJString(accessToken))
  add(query_580523, "uploadType", newJString(uploadType))
  add(query_580523, "key", newJString(key))
  add(query_580523, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_580523, "$.xgafv", newJString(Xgafv))
  add(query_580523, "prettyPrint", newJBool(prettyPrint))
  result = call_580521.call(path_580522, query_580523, nil, nil, nil)

var cloudsearchSettingsDatasourcesDelete* = Call_CloudsearchSettingsDatasourcesDelete_580504(
    name: "cloudsearchSettingsDatasourcesDelete", meth: HttpMethod.HttpDelete,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/{name}",
    validator: validate_CloudsearchSettingsDatasourcesDelete_580505, base: "/",
    url: url_CloudsearchSettingsDatasourcesDelete_580506, schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsSearchapplicationsReset_580524 = ref object of OpenApiRestCall_579421
proc url_CloudsearchSettingsSearchapplicationsReset_580526(protocol: Scheme;
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

proc validate_CloudsearchSettingsSearchapplicationsReset_580525(path: JsonNode;
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
  var valid_580527 = path.getOrDefault("name")
  valid_580527 = validateParameter(valid_580527, JString, required = true,
                                 default = nil)
  if valid_580527 != nil:
    section.add "name", valid_580527
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
  var valid_580528 = query.getOrDefault("upload_protocol")
  valid_580528 = validateParameter(valid_580528, JString, required = false,
                                 default = nil)
  if valid_580528 != nil:
    section.add "upload_protocol", valid_580528
  var valid_580529 = query.getOrDefault("fields")
  valid_580529 = validateParameter(valid_580529, JString, required = false,
                                 default = nil)
  if valid_580529 != nil:
    section.add "fields", valid_580529
  var valid_580530 = query.getOrDefault("quotaUser")
  valid_580530 = validateParameter(valid_580530, JString, required = false,
                                 default = nil)
  if valid_580530 != nil:
    section.add "quotaUser", valid_580530
  var valid_580531 = query.getOrDefault("alt")
  valid_580531 = validateParameter(valid_580531, JString, required = false,
                                 default = newJString("json"))
  if valid_580531 != nil:
    section.add "alt", valid_580531
  var valid_580532 = query.getOrDefault("oauth_token")
  valid_580532 = validateParameter(valid_580532, JString, required = false,
                                 default = nil)
  if valid_580532 != nil:
    section.add "oauth_token", valid_580532
  var valid_580533 = query.getOrDefault("callback")
  valid_580533 = validateParameter(valid_580533, JString, required = false,
                                 default = nil)
  if valid_580533 != nil:
    section.add "callback", valid_580533
  var valid_580534 = query.getOrDefault("access_token")
  valid_580534 = validateParameter(valid_580534, JString, required = false,
                                 default = nil)
  if valid_580534 != nil:
    section.add "access_token", valid_580534
  var valid_580535 = query.getOrDefault("uploadType")
  valid_580535 = validateParameter(valid_580535, JString, required = false,
                                 default = nil)
  if valid_580535 != nil:
    section.add "uploadType", valid_580535
  var valid_580536 = query.getOrDefault("key")
  valid_580536 = validateParameter(valid_580536, JString, required = false,
                                 default = nil)
  if valid_580536 != nil:
    section.add "key", valid_580536
  var valid_580537 = query.getOrDefault("$.xgafv")
  valid_580537 = validateParameter(valid_580537, JString, required = false,
                                 default = newJString("1"))
  if valid_580537 != nil:
    section.add "$.xgafv", valid_580537
  var valid_580538 = query.getOrDefault("prettyPrint")
  valid_580538 = validateParameter(valid_580538, JBool, required = false,
                                 default = newJBool(true))
  if valid_580538 != nil:
    section.add "prettyPrint", valid_580538
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

proc call*(call_580540: Call_CloudsearchSettingsSearchapplicationsReset_580524;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets a search application to default settings. This will return an empty
  ## response.
  ## 
  let valid = call_580540.validator(path, query, header, formData, body)
  let scheme = call_580540.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580540.url(scheme.get, call_580540.host, call_580540.base,
                         call_580540.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580540, url, valid)

proc call*(call_580541: Call_CloudsearchSettingsSearchapplicationsReset_580524;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudsearchSettingsSearchapplicationsReset
  ## Resets a search application to default settings. This will return an empty
  ## response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the search application to be reset.
  ## <br />Format: applications/{application_id}.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580542 = newJObject()
  var query_580543 = newJObject()
  var body_580544 = newJObject()
  add(query_580543, "upload_protocol", newJString(uploadProtocol))
  add(query_580543, "fields", newJString(fields))
  add(query_580543, "quotaUser", newJString(quotaUser))
  add(path_580542, "name", newJString(name))
  add(query_580543, "alt", newJString(alt))
  add(query_580543, "oauth_token", newJString(oauthToken))
  add(query_580543, "callback", newJString(callback))
  add(query_580543, "access_token", newJString(accessToken))
  add(query_580543, "uploadType", newJString(uploadType))
  add(query_580543, "key", newJString(key))
  add(query_580543, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580544 = body
  add(query_580543, "prettyPrint", newJBool(prettyPrint))
  result = call_580541.call(path_580542, query_580543, nil, nil, body_580544)

var cloudsearchSettingsSearchapplicationsReset* = Call_CloudsearchSettingsSearchapplicationsReset_580524(
    name: "cloudsearchSettingsSearchapplicationsReset", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/{name}:reset",
    validator: validate_CloudsearchSettingsSearchapplicationsReset_580525,
    base: "/", url: url_CloudsearchSettingsSearchapplicationsReset_580526,
    schemes: {Scheme.Https})
type
  Call_CloudsearchStatsGetIndex_580545 = ref object of OpenApiRestCall_579421
proc url_CloudsearchStatsGetIndex_580547(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudsearchStatsGetIndex_580546(path: JsonNode; query: JsonNode;
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
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   toDate.day: JInt
  ##             : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   fromDate.day: JInt
  ##               : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   fromDate.month: JInt
  ##                 : Month of date. Must be from 1 to 12.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   toDate.month: JInt
  ##               : Month of date. Must be from 1 to 12.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   toDate.year: JInt
  ##              : Year of date. Must be from 1 to 9999.
  ##   fromDate.year: JInt
  ##                : Year of date. Must be from 1 to 9999.
  section = newJObject()
  var valid_580548 = query.getOrDefault("upload_protocol")
  valid_580548 = validateParameter(valid_580548, JString, required = false,
                                 default = nil)
  if valid_580548 != nil:
    section.add "upload_protocol", valid_580548
  var valid_580549 = query.getOrDefault("fields")
  valid_580549 = validateParameter(valid_580549, JString, required = false,
                                 default = nil)
  if valid_580549 != nil:
    section.add "fields", valid_580549
  var valid_580550 = query.getOrDefault("quotaUser")
  valid_580550 = validateParameter(valid_580550, JString, required = false,
                                 default = nil)
  if valid_580550 != nil:
    section.add "quotaUser", valid_580550
  var valid_580551 = query.getOrDefault("alt")
  valid_580551 = validateParameter(valid_580551, JString, required = false,
                                 default = newJString("json"))
  if valid_580551 != nil:
    section.add "alt", valid_580551
  var valid_580552 = query.getOrDefault("toDate.day")
  valid_580552 = validateParameter(valid_580552, JInt, required = false, default = nil)
  if valid_580552 != nil:
    section.add "toDate.day", valid_580552
  var valid_580553 = query.getOrDefault("oauth_token")
  valid_580553 = validateParameter(valid_580553, JString, required = false,
                                 default = nil)
  if valid_580553 != nil:
    section.add "oauth_token", valid_580553
  var valid_580554 = query.getOrDefault("callback")
  valid_580554 = validateParameter(valid_580554, JString, required = false,
                                 default = nil)
  if valid_580554 != nil:
    section.add "callback", valid_580554
  var valid_580555 = query.getOrDefault("access_token")
  valid_580555 = validateParameter(valid_580555, JString, required = false,
                                 default = nil)
  if valid_580555 != nil:
    section.add "access_token", valid_580555
  var valid_580556 = query.getOrDefault("uploadType")
  valid_580556 = validateParameter(valid_580556, JString, required = false,
                                 default = nil)
  if valid_580556 != nil:
    section.add "uploadType", valid_580556
  var valid_580557 = query.getOrDefault("fromDate.day")
  valid_580557 = validateParameter(valid_580557, JInt, required = false, default = nil)
  if valid_580557 != nil:
    section.add "fromDate.day", valid_580557
  var valid_580558 = query.getOrDefault("fromDate.month")
  valid_580558 = validateParameter(valid_580558, JInt, required = false, default = nil)
  if valid_580558 != nil:
    section.add "fromDate.month", valid_580558
  var valid_580559 = query.getOrDefault("key")
  valid_580559 = validateParameter(valid_580559, JString, required = false,
                                 default = nil)
  if valid_580559 != nil:
    section.add "key", valid_580559
  var valid_580560 = query.getOrDefault("$.xgafv")
  valid_580560 = validateParameter(valid_580560, JString, required = false,
                                 default = newJString("1"))
  if valid_580560 != nil:
    section.add "$.xgafv", valid_580560
  var valid_580561 = query.getOrDefault("toDate.month")
  valid_580561 = validateParameter(valid_580561, JInt, required = false, default = nil)
  if valid_580561 != nil:
    section.add "toDate.month", valid_580561
  var valid_580562 = query.getOrDefault("prettyPrint")
  valid_580562 = validateParameter(valid_580562, JBool, required = false,
                                 default = newJBool(true))
  if valid_580562 != nil:
    section.add "prettyPrint", valid_580562
  var valid_580563 = query.getOrDefault("toDate.year")
  valid_580563 = validateParameter(valid_580563, JInt, required = false, default = nil)
  if valid_580563 != nil:
    section.add "toDate.year", valid_580563
  var valid_580564 = query.getOrDefault("fromDate.year")
  valid_580564 = validateParameter(valid_580564, JInt, required = false, default = nil)
  if valid_580564 != nil:
    section.add "fromDate.year", valid_580564
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580565: Call_CloudsearchStatsGetIndex_580545; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets indexed item statistics aggreggated across all data sources. This
  ## API only returns statistics for previous dates; it doesn't return
  ## statistics for the current day.
  ## 
  let valid = call_580565.validator(path, query, header, formData, body)
  let scheme = call_580565.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580565.url(scheme.get, call_580565.host, call_580565.base,
                         call_580565.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580565, url, valid)

proc call*(call_580566: Call_CloudsearchStatsGetIndex_580545;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; toDateDay: int = 0; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          fromDateDay: int = 0; fromDateMonth: int = 0; key: string = "";
          Xgafv: string = "1"; toDateMonth: int = 0; prettyPrint: bool = true;
          toDateYear: int = 0; fromDateYear: int = 0): Recallable =
  ## cloudsearchStatsGetIndex
  ## Gets indexed item statistics aggreggated across all data sources. This
  ## API only returns statistics for previous dates; it doesn't return
  ## statistics for the current day.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   toDateDay: int
  ##            : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   fromDateDay: int
  ##              : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   fromDateMonth: int
  ##                : Month of date. Must be from 1 to 12.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   toDateMonth: int
  ##              : Month of date. Must be from 1 to 12.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   toDateYear: int
  ##             : Year of date. Must be from 1 to 9999.
  ##   fromDateYear: int
  ##               : Year of date. Must be from 1 to 9999.
  var query_580567 = newJObject()
  add(query_580567, "upload_protocol", newJString(uploadProtocol))
  add(query_580567, "fields", newJString(fields))
  add(query_580567, "quotaUser", newJString(quotaUser))
  add(query_580567, "alt", newJString(alt))
  add(query_580567, "toDate.day", newJInt(toDateDay))
  add(query_580567, "oauth_token", newJString(oauthToken))
  add(query_580567, "callback", newJString(callback))
  add(query_580567, "access_token", newJString(accessToken))
  add(query_580567, "uploadType", newJString(uploadType))
  add(query_580567, "fromDate.day", newJInt(fromDateDay))
  add(query_580567, "fromDate.month", newJInt(fromDateMonth))
  add(query_580567, "key", newJString(key))
  add(query_580567, "$.xgafv", newJString(Xgafv))
  add(query_580567, "toDate.month", newJInt(toDateMonth))
  add(query_580567, "prettyPrint", newJBool(prettyPrint))
  add(query_580567, "toDate.year", newJInt(toDateYear))
  add(query_580567, "fromDate.year", newJInt(fromDateYear))
  result = call_580566.call(nil, query_580567, nil, nil, nil)

var cloudsearchStatsGetIndex* = Call_CloudsearchStatsGetIndex_580545(
    name: "cloudsearchStatsGetIndex", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/stats/index",
    validator: validate_CloudsearchStatsGetIndex_580546, base: "/",
    url: url_CloudsearchStatsGetIndex_580547, schemes: {Scheme.Https})
type
  Call_CloudsearchStatsIndexDatasourcesGet_580568 = ref object of OpenApiRestCall_579421
proc url_CloudsearchStatsIndexDatasourcesGet_580570(protocol: Scheme; host: string;
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

proc validate_CloudsearchStatsIndexDatasourcesGet_580569(path: JsonNode;
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
  var valid_580571 = path.getOrDefault("name")
  valid_580571 = validateParameter(valid_580571, JString, required = true,
                                 default = nil)
  if valid_580571 != nil:
    section.add "name", valid_580571
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
  ##   toDate.day: JInt
  ##             : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   fromDate.day: JInt
  ##               : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   fromDate.month: JInt
  ##                 : Month of date. Must be from 1 to 12.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   toDate.month: JInt
  ##               : Month of date. Must be from 1 to 12.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   toDate.year: JInt
  ##              : Year of date. Must be from 1 to 9999.
  ##   fromDate.year: JInt
  ##                : Year of date. Must be from 1 to 9999.
  section = newJObject()
  var valid_580572 = query.getOrDefault("upload_protocol")
  valid_580572 = validateParameter(valid_580572, JString, required = false,
                                 default = nil)
  if valid_580572 != nil:
    section.add "upload_protocol", valid_580572
  var valid_580573 = query.getOrDefault("fields")
  valid_580573 = validateParameter(valid_580573, JString, required = false,
                                 default = nil)
  if valid_580573 != nil:
    section.add "fields", valid_580573
  var valid_580574 = query.getOrDefault("quotaUser")
  valid_580574 = validateParameter(valid_580574, JString, required = false,
                                 default = nil)
  if valid_580574 != nil:
    section.add "quotaUser", valid_580574
  var valid_580575 = query.getOrDefault("alt")
  valid_580575 = validateParameter(valid_580575, JString, required = false,
                                 default = newJString("json"))
  if valid_580575 != nil:
    section.add "alt", valid_580575
  var valid_580576 = query.getOrDefault("toDate.day")
  valid_580576 = validateParameter(valid_580576, JInt, required = false, default = nil)
  if valid_580576 != nil:
    section.add "toDate.day", valid_580576
  var valid_580577 = query.getOrDefault("oauth_token")
  valid_580577 = validateParameter(valid_580577, JString, required = false,
                                 default = nil)
  if valid_580577 != nil:
    section.add "oauth_token", valid_580577
  var valid_580578 = query.getOrDefault("callback")
  valid_580578 = validateParameter(valid_580578, JString, required = false,
                                 default = nil)
  if valid_580578 != nil:
    section.add "callback", valid_580578
  var valid_580579 = query.getOrDefault("access_token")
  valid_580579 = validateParameter(valid_580579, JString, required = false,
                                 default = nil)
  if valid_580579 != nil:
    section.add "access_token", valid_580579
  var valid_580580 = query.getOrDefault("uploadType")
  valid_580580 = validateParameter(valid_580580, JString, required = false,
                                 default = nil)
  if valid_580580 != nil:
    section.add "uploadType", valid_580580
  var valid_580581 = query.getOrDefault("fromDate.day")
  valid_580581 = validateParameter(valid_580581, JInt, required = false, default = nil)
  if valid_580581 != nil:
    section.add "fromDate.day", valid_580581
  var valid_580582 = query.getOrDefault("fromDate.month")
  valid_580582 = validateParameter(valid_580582, JInt, required = false, default = nil)
  if valid_580582 != nil:
    section.add "fromDate.month", valid_580582
  var valid_580583 = query.getOrDefault("key")
  valid_580583 = validateParameter(valid_580583, JString, required = false,
                                 default = nil)
  if valid_580583 != nil:
    section.add "key", valid_580583
  var valid_580584 = query.getOrDefault("$.xgafv")
  valid_580584 = validateParameter(valid_580584, JString, required = false,
                                 default = newJString("1"))
  if valid_580584 != nil:
    section.add "$.xgafv", valid_580584
  var valid_580585 = query.getOrDefault("toDate.month")
  valid_580585 = validateParameter(valid_580585, JInt, required = false, default = nil)
  if valid_580585 != nil:
    section.add "toDate.month", valid_580585
  var valid_580586 = query.getOrDefault("prettyPrint")
  valid_580586 = validateParameter(valid_580586, JBool, required = false,
                                 default = newJBool(true))
  if valid_580586 != nil:
    section.add "prettyPrint", valid_580586
  var valid_580587 = query.getOrDefault("toDate.year")
  valid_580587 = validateParameter(valid_580587, JInt, required = false, default = nil)
  if valid_580587 != nil:
    section.add "toDate.year", valid_580587
  var valid_580588 = query.getOrDefault("fromDate.year")
  valid_580588 = validateParameter(valid_580588, JInt, required = false, default = nil)
  if valid_580588 != nil:
    section.add "fromDate.year", valid_580588
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580589: Call_CloudsearchStatsIndexDatasourcesGet_580568;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets indexed item statistics for a single data source.
  ## 
  let valid = call_580589.validator(path, query, header, formData, body)
  let scheme = call_580589.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580589.url(scheme.get, call_580589.host, call_580589.base,
                         call_580589.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580589, url, valid)

proc call*(call_580590: Call_CloudsearchStatsIndexDatasourcesGet_580568;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; toDateDay: int = 0;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; fromDateDay: int = 0; fromDateMonth: int = 0;
          key: string = ""; Xgafv: string = "1"; toDateMonth: int = 0;
          prettyPrint: bool = true; toDateYear: int = 0; fromDateYear: int = 0): Recallable =
  ## cloudsearchStatsIndexDatasourcesGet
  ## Gets indexed item statistics for a single data source.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource id of the data source to retrieve statistics for,
  ## in the following format: "datasources/{source_id}"
  ##   alt: string
  ##      : Data format for response.
  ##   toDateDay: int
  ##            : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   fromDateDay: int
  ##              : Day of month. Must be from 1 to 31 and valid for the year and month.
  ##   fromDateMonth: int
  ##                : Month of date. Must be from 1 to 12.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   toDateMonth: int
  ##              : Month of date. Must be from 1 to 12.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   toDateYear: int
  ##             : Year of date. Must be from 1 to 9999.
  ##   fromDateYear: int
  ##               : Year of date. Must be from 1 to 9999.
  var path_580591 = newJObject()
  var query_580592 = newJObject()
  add(query_580592, "upload_protocol", newJString(uploadProtocol))
  add(query_580592, "fields", newJString(fields))
  add(query_580592, "quotaUser", newJString(quotaUser))
  add(path_580591, "name", newJString(name))
  add(query_580592, "alt", newJString(alt))
  add(query_580592, "toDate.day", newJInt(toDateDay))
  add(query_580592, "oauth_token", newJString(oauthToken))
  add(query_580592, "callback", newJString(callback))
  add(query_580592, "access_token", newJString(accessToken))
  add(query_580592, "uploadType", newJString(uploadType))
  add(query_580592, "fromDate.day", newJInt(fromDateDay))
  add(query_580592, "fromDate.month", newJInt(fromDateMonth))
  add(query_580592, "key", newJString(key))
  add(query_580592, "$.xgafv", newJString(Xgafv))
  add(query_580592, "toDate.month", newJInt(toDateMonth))
  add(query_580592, "prettyPrint", newJBool(prettyPrint))
  add(query_580592, "toDate.year", newJInt(toDateYear))
  add(query_580592, "fromDate.year", newJInt(fromDateYear))
  result = call_580590.call(path_580591, query_580592, nil, nil, nil)

var cloudsearchStatsIndexDatasourcesGet* = Call_CloudsearchStatsIndexDatasourcesGet_580568(
    name: "cloudsearchStatsIndexDatasourcesGet", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/stats/index/{name}",
    validator: validate_CloudsearchStatsIndexDatasourcesGet_580569, base: "/",
    url: url_CloudsearchStatsIndexDatasourcesGet_580570, schemes: {Scheme.Https})
type
  Call_CloudsearchOperationsGet_580593 = ref object of OpenApiRestCall_579421
proc url_CloudsearchOperationsGet_580595(protocol: Scheme; host: string;
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

proc validate_CloudsearchOperationsGet_580594(path: JsonNode; query: JsonNode;
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
  var valid_580596 = path.getOrDefault("name")
  valid_580596 = validateParameter(valid_580596, JString, required = true,
                                 default = nil)
  if valid_580596 != nil:
    section.add "name", valid_580596
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
  var valid_580597 = query.getOrDefault("upload_protocol")
  valid_580597 = validateParameter(valid_580597, JString, required = false,
                                 default = nil)
  if valid_580597 != nil:
    section.add "upload_protocol", valid_580597
  var valid_580598 = query.getOrDefault("fields")
  valid_580598 = validateParameter(valid_580598, JString, required = false,
                                 default = nil)
  if valid_580598 != nil:
    section.add "fields", valid_580598
  var valid_580599 = query.getOrDefault("quotaUser")
  valid_580599 = validateParameter(valid_580599, JString, required = false,
                                 default = nil)
  if valid_580599 != nil:
    section.add "quotaUser", valid_580599
  var valid_580600 = query.getOrDefault("alt")
  valid_580600 = validateParameter(valid_580600, JString, required = false,
                                 default = newJString("json"))
  if valid_580600 != nil:
    section.add "alt", valid_580600
  var valid_580601 = query.getOrDefault("oauth_token")
  valid_580601 = validateParameter(valid_580601, JString, required = false,
                                 default = nil)
  if valid_580601 != nil:
    section.add "oauth_token", valid_580601
  var valid_580602 = query.getOrDefault("callback")
  valid_580602 = validateParameter(valid_580602, JString, required = false,
                                 default = nil)
  if valid_580602 != nil:
    section.add "callback", valid_580602
  var valid_580603 = query.getOrDefault("access_token")
  valid_580603 = validateParameter(valid_580603, JString, required = false,
                                 default = nil)
  if valid_580603 != nil:
    section.add "access_token", valid_580603
  var valid_580604 = query.getOrDefault("uploadType")
  valid_580604 = validateParameter(valid_580604, JString, required = false,
                                 default = nil)
  if valid_580604 != nil:
    section.add "uploadType", valid_580604
  var valid_580605 = query.getOrDefault("key")
  valid_580605 = validateParameter(valid_580605, JString, required = false,
                                 default = nil)
  if valid_580605 != nil:
    section.add "key", valid_580605
  var valid_580606 = query.getOrDefault("$.xgafv")
  valid_580606 = validateParameter(valid_580606, JString, required = false,
                                 default = newJString("1"))
  if valid_580606 != nil:
    section.add "$.xgafv", valid_580606
  var valid_580607 = query.getOrDefault("prettyPrint")
  valid_580607 = validateParameter(valid_580607, JBool, required = false,
                                 default = newJBool(true))
  if valid_580607 != nil:
    section.add "prettyPrint", valid_580607
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580608: Call_CloudsearchOperationsGet_580593; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_580608.validator(path, query, header, formData, body)
  let scheme = call_580608.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580608.url(scheme.get, call_580608.host, call_580608.base,
                         call_580608.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580608, url, valid)

proc call*(call_580609: Call_CloudsearchOperationsGet_580593; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudsearchOperationsGet
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource.
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
  var path_580610 = newJObject()
  var query_580611 = newJObject()
  add(query_580611, "upload_protocol", newJString(uploadProtocol))
  add(query_580611, "fields", newJString(fields))
  add(query_580611, "quotaUser", newJString(quotaUser))
  add(path_580610, "name", newJString(name))
  add(query_580611, "alt", newJString(alt))
  add(query_580611, "oauth_token", newJString(oauthToken))
  add(query_580611, "callback", newJString(callback))
  add(query_580611, "access_token", newJString(accessToken))
  add(query_580611, "uploadType", newJString(uploadType))
  add(query_580611, "key", newJString(key))
  add(query_580611, "$.xgafv", newJString(Xgafv))
  add(query_580611, "prettyPrint", newJBool(prettyPrint))
  result = call_580609.call(path_580610, query_580611, nil, nil, nil)

var cloudsearchOperationsGet* = Call_CloudsearchOperationsGet_580593(
    name: "cloudsearchOperationsGet", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudsearchOperationsGet_580594, base: "/",
    url: url_CloudsearchOperationsGet_580595, schemes: {Scheme.Https})
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
