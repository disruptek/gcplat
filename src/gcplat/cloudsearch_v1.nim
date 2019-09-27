
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597421): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudsearchDebugDatasourcesItemsSearchByViewUrl_597690 = ref object of OpenApiRestCall_597421
proc url_CloudsearchDebugDatasourcesItemsSearchByViewUrl_597692(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudsearchDebugDatasourcesItemsSearchByViewUrl_597691(
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
  var valid_597818 = path.getOrDefault("name")
  valid_597818 = validateParameter(valid_597818, JString, required = true,
                                 default = nil)
  if valid_597818 != nil:
    section.add "name", valid_597818
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
  var valid_597819 = query.getOrDefault("upload_protocol")
  valid_597819 = validateParameter(valid_597819, JString, required = false,
                                 default = nil)
  if valid_597819 != nil:
    section.add "upload_protocol", valid_597819
  var valid_597820 = query.getOrDefault("fields")
  valid_597820 = validateParameter(valid_597820, JString, required = false,
                                 default = nil)
  if valid_597820 != nil:
    section.add "fields", valid_597820
  var valid_597821 = query.getOrDefault("quotaUser")
  valid_597821 = validateParameter(valid_597821, JString, required = false,
                                 default = nil)
  if valid_597821 != nil:
    section.add "quotaUser", valid_597821
  var valid_597835 = query.getOrDefault("alt")
  valid_597835 = validateParameter(valid_597835, JString, required = false,
                                 default = newJString("json"))
  if valid_597835 != nil:
    section.add "alt", valid_597835
  var valid_597836 = query.getOrDefault("oauth_token")
  valid_597836 = validateParameter(valid_597836, JString, required = false,
                                 default = nil)
  if valid_597836 != nil:
    section.add "oauth_token", valid_597836
  var valid_597837 = query.getOrDefault("callback")
  valid_597837 = validateParameter(valid_597837, JString, required = false,
                                 default = nil)
  if valid_597837 != nil:
    section.add "callback", valid_597837
  var valid_597838 = query.getOrDefault("access_token")
  valid_597838 = validateParameter(valid_597838, JString, required = false,
                                 default = nil)
  if valid_597838 != nil:
    section.add "access_token", valid_597838
  var valid_597839 = query.getOrDefault("uploadType")
  valid_597839 = validateParameter(valid_597839, JString, required = false,
                                 default = nil)
  if valid_597839 != nil:
    section.add "uploadType", valid_597839
  var valid_597840 = query.getOrDefault("key")
  valid_597840 = validateParameter(valid_597840, JString, required = false,
                                 default = nil)
  if valid_597840 != nil:
    section.add "key", valid_597840
  var valid_597841 = query.getOrDefault("$.xgafv")
  valid_597841 = validateParameter(valid_597841, JString, required = false,
                                 default = newJString("1"))
  if valid_597841 != nil:
    section.add "$.xgafv", valid_597841
  var valid_597842 = query.getOrDefault("prettyPrint")
  valid_597842 = validateParameter(valid_597842, JBool, required = false,
                                 default = newJBool(true))
  if valid_597842 != nil:
    section.add "prettyPrint", valid_597842
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

proc call*(call_597866: Call_CloudsearchDebugDatasourcesItemsSearchByViewUrl_597690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches the item whose viewUrl exactly matches that of the URL provided
  ## in the request.
  ## 
  let valid = call_597866.validator(path, query, header, formData, body)
  let scheme = call_597866.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597866.url(scheme.get, call_597866.host, call_597866.base,
                         call_597866.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597866, url, valid)

proc call*(call_597937: Call_CloudsearchDebugDatasourcesItemsSearchByViewUrl_597690;
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
  var path_597938 = newJObject()
  var query_597940 = newJObject()
  var body_597941 = newJObject()
  add(query_597940, "upload_protocol", newJString(uploadProtocol))
  add(query_597940, "fields", newJString(fields))
  add(query_597940, "quotaUser", newJString(quotaUser))
  add(path_597938, "name", newJString(name))
  add(query_597940, "alt", newJString(alt))
  add(query_597940, "oauth_token", newJString(oauthToken))
  add(query_597940, "callback", newJString(callback))
  add(query_597940, "access_token", newJString(accessToken))
  add(query_597940, "uploadType", newJString(uploadType))
  add(query_597940, "key", newJString(key))
  add(query_597940, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_597941 = body
  add(query_597940, "prettyPrint", newJBool(prettyPrint))
  result = call_597937.call(path_597938, query_597940, nil, nil, body_597941)

var cloudsearchDebugDatasourcesItemsSearchByViewUrl* = Call_CloudsearchDebugDatasourcesItemsSearchByViewUrl_597690(
    name: "cloudsearchDebugDatasourcesItemsSearchByViewUrl",
    meth: HttpMethod.HttpPost, host: "cloudsearch.googleapis.com",
    route: "/v1/debug/{name}/items:searchByViewUrl",
    validator: validate_CloudsearchDebugDatasourcesItemsSearchByViewUrl_597691,
    base: "/", url: url_CloudsearchDebugDatasourcesItemsSearchByViewUrl_597692,
    schemes: {Scheme.Https})
type
  Call_CloudsearchDebugDatasourcesItemsCheckAccess_597980 = ref object of OpenApiRestCall_597421
proc url_CloudsearchDebugDatasourcesItemsCheckAccess_597982(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudsearchDebugDatasourcesItemsCheckAccess_597981(path: JsonNode;
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
  var valid_597983 = path.getOrDefault("name")
  valid_597983 = validateParameter(valid_597983, JString, required = true,
                                 default = nil)
  if valid_597983 != nil:
    section.add "name", valid_597983
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
  var valid_597984 = query.getOrDefault("upload_protocol")
  valid_597984 = validateParameter(valid_597984, JString, required = false,
                                 default = nil)
  if valid_597984 != nil:
    section.add "upload_protocol", valid_597984
  var valid_597985 = query.getOrDefault("fields")
  valid_597985 = validateParameter(valid_597985, JString, required = false,
                                 default = nil)
  if valid_597985 != nil:
    section.add "fields", valid_597985
  var valid_597986 = query.getOrDefault("quotaUser")
  valid_597986 = validateParameter(valid_597986, JString, required = false,
                                 default = nil)
  if valid_597986 != nil:
    section.add "quotaUser", valid_597986
  var valid_597987 = query.getOrDefault("alt")
  valid_597987 = validateParameter(valid_597987, JString, required = false,
                                 default = newJString("json"))
  if valid_597987 != nil:
    section.add "alt", valid_597987
  var valid_597988 = query.getOrDefault("oauth_token")
  valid_597988 = validateParameter(valid_597988, JString, required = false,
                                 default = nil)
  if valid_597988 != nil:
    section.add "oauth_token", valid_597988
  var valid_597989 = query.getOrDefault("callback")
  valid_597989 = validateParameter(valid_597989, JString, required = false,
                                 default = nil)
  if valid_597989 != nil:
    section.add "callback", valid_597989
  var valid_597990 = query.getOrDefault("access_token")
  valid_597990 = validateParameter(valid_597990, JString, required = false,
                                 default = nil)
  if valid_597990 != nil:
    section.add "access_token", valid_597990
  var valid_597991 = query.getOrDefault("uploadType")
  valid_597991 = validateParameter(valid_597991, JString, required = false,
                                 default = nil)
  if valid_597991 != nil:
    section.add "uploadType", valid_597991
  var valid_597992 = query.getOrDefault("key")
  valid_597992 = validateParameter(valid_597992, JString, required = false,
                                 default = nil)
  if valid_597992 != nil:
    section.add "key", valid_597992
  var valid_597993 = query.getOrDefault("debugOptions.enableDebugging")
  valid_597993 = validateParameter(valid_597993, JBool, required = false, default = nil)
  if valid_597993 != nil:
    section.add "debugOptions.enableDebugging", valid_597993
  var valid_597994 = query.getOrDefault("$.xgafv")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = newJString("1"))
  if valid_597994 != nil:
    section.add "$.xgafv", valid_597994
  var valid_597995 = query.getOrDefault("prettyPrint")
  valid_597995 = validateParameter(valid_597995, JBool, required = false,
                                 default = newJBool(true))
  if valid_597995 != nil:
    section.add "prettyPrint", valid_597995
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

proc call*(call_597997: Call_CloudsearchDebugDatasourcesItemsCheckAccess_597980;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether an item is accessible by specified principal.
  ## 
  let valid = call_597997.validator(path, query, header, formData, body)
  let scheme = call_597997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597997.url(scheme.get, call_597997.host, call_597997.base,
                         call_597997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597997, url, valid)

proc call*(call_597998: Call_CloudsearchDebugDatasourcesItemsCheckAccess_597980;
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
  var path_597999 = newJObject()
  var query_598000 = newJObject()
  var body_598001 = newJObject()
  add(query_598000, "upload_protocol", newJString(uploadProtocol))
  add(query_598000, "fields", newJString(fields))
  add(query_598000, "quotaUser", newJString(quotaUser))
  add(path_597999, "name", newJString(name))
  add(query_598000, "alt", newJString(alt))
  add(query_598000, "oauth_token", newJString(oauthToken))
  add(query_598000, "callback", newJString(callback))
  add(query_598000, "access_token", newJString(accessToken))
  add(query_598000, "uploadType", newJString(uploadType))
  add(query_598000, "key", newJString(key))
  add(query_598000, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_598000, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598001 = body
  add(query_598000, "prettyPrint", newJBool(prettyPrint))
  result = call_597998.call(path_597999, query_598000, nil, nil, body_598001)

var cloudsearchDebugDatasourcesItemsCheckAccess* = Call_CloudsearchDebugDatasourcesItemsCheckAccess_597980(
    name: "cloudsearchDebugDatasourcesItemsCheckAccess",
    meth: HttpMethod.HttpPost, host: "cloudsearch.googleapis.com",
    route: "/v1/debug/{name}:checkAccess",
    validator: validate_CloudsearchDebugDatasourcesItemsCheckAccess_597981,
    base: "/", url: url_CloudsearchDebugDatasourcesItemsCheckAccess_597982,
    schemes: {Scheme.Https})
type
  Call_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_598002 = ref object of OpenApiRestCall_597421
proc url_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_598004(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_598003(
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
  var valid_598005 = path.getOrDefault("parent")
  valid_598005 = validateParameter(valid_598005, JString, required = true,
                                 default = nil)
  if valid_598005 != nil:
    section.add "parent", valid_598005
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
  var valid_598006 = query.getOrDefault("upload_protocol")
  valid_598006 = validateParameter(valid_598006, JString, required = false,
                                 default = nil)
  if valid_598006 != nil:
    section.add "upload_protocol", valid_598006
  var valid_598007 = query.getOrDefault("fields")
  valid_598007 = validateParameter(valid_598007, JString, required = false,
                                 default = nil)
  if valid_598007 != nil:
    section.add "fields", valid_598007
  var valid_598008 = query.getOrDefault("pageToken")
  valid_598008 = validateParameter(valid_598008, JString, required = false,
                                 default = nil)
  if valid_598008 != nil:
    section.add "pageToken", valid_598008
  var valid_598009 = query.getOrDefault("quotaUser")
  valid_598009 = validateParameter(valid_598009, JString, required = false,
                                 default = nil)
  if valid_598009 != nil:
    section.add "quotaUser", valid_598009
  var valid_598010 = query.getOrDefault("alt")
  valid_598010 = validateParameter(valid_598010, JString, required = false,
                                 default = newJString("json"))
  if valid_598010 != nil:
    section.add "alt", valid_598010
  var valid_598011 = query.getOrDefault("oauth_token")
  valid_598011 = validateParameter(valid_598011, JString, required = false,
                                 default = nil)
  if valid_598011 != nil:
    section.add "oauth_token", valid_598011
  var valid_598012 = query.getOrDefault("callback")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = nil)
  if valid_598012 != nil:
    section.add "callback", valid_598012
  var valid_598013 = query.getOrDefault("access_token")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = nil)
  if valid_598013 != nil:
    section.add "access_token", valid_598013
  var valid_598014 = query.getOrDefault("uploadType")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = nil)
  if valid_598014 != nil:
    section.add "uploadType", valid_598014
  var valid_598015 = query.getOrDefault("groupResourceName")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "groupResourceName", valid_598015
  var valid_598016 = query.getOrDefault("userResourceName")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "userResourceName", valid_598016
  var valid_598017 = query.getOrDefault("key")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "key", valid_598017
  var valid_598018 = query.getOrDefault("debugOptions.enableDebugging")
  valid_598018 = validateParameter(valid_598018, JBool, required = false, default = nil)
  if valid_598018 != nil:
    section.add "debugOptions.enableDebugging", valid_598018
  var valid_598019 = query.getOrDefault("$.xgafv")
  valid_598019 = validateParameter(valid_598019, JString, required = false,
                                 default = newJString("1"))
  if valid_598019 != nil:
    section.add "$.xgafv", valid_598019
  var valid_598020 = query.getOrDefault("pageSize")
  valid_598020 = validateParameter(valid_598020, JInt, required = false, default = nil)
  if valid_598020 != nil:
    section.add "pageSize", valid_598020
  var valid_598021 = query.getOrDefault("prettyPrint")
  valid_598021 = validateParameter(valid_598021, JBool, required = false,
                                 default = newJBool(true))
  if valid_598021 != nil:
    section.add "prettyPrint", valid_598021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598022: Call_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_598002;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists names of items associated with an unmapped identity.
  ## 
  let valid = call_598022.validator(path, query, header, formData, body)
  let scheme = call_598022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598022.url(scheme.get, call_598022.host, call_598022.base,
                         call_598022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598022, url, valid)

proc call*(call_598023: Call_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_598002;
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
  var path_598024 = newJObject()
  var query_598025 = newJObject()
  add(query_598025, "upload_protocol", newJString(uploadProtocol))
  add(query_598025, "fields", newJString(fields))
  add(query_598025, "pageToken", newJString(pageToken))
  add(query_598025, "quotaUser", newJString(quotaUser))
  add(query_598025, "alt", newJString(alt))
  add(query_598025, "oauth_token", newJString(oauthToken))
  add(query_598025, "callback", newJString(callback))
  add(query_598025, "access_token", newJString(accessToken))
  add(query_598025, "uploadType", newJString(uploadType))
  add(path_598024, "parent", newJString(parent))
  add(query_598025, "groupResourceName", newJString(groupResourceName))
  add(query_598025, "userResourceName", newJString(userResourceName))
  add(query_598025, "key", newJString(key))
  add(query_598025, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_598025, "$.xgafv", newJString(Xgafv))
  add(query_598025, "pageSize", newJInt(pageSize))
  add(query_598025, "prettyPrint", newJBool(prettyPrint))
  result = call_598023.call(path_598024, query_598025, nil, nil, nil)

var cloudsearchDebugIdentitysourcesItemsListForunmappedidentity* = Call_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_598002(
    name: "cloudsearchDebugIdentitysourcesItemsListForunmappedidentity",
    meth: HttpMethod.HttpGet, host: "cloudsearch.googleapis.com",
    route: "/v1/debug/{parent}/items:forunmappedidentity", validator: validate_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_598003,
    base: "/",
    url: url_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_598004,
    schemes: {Scheme.Https})
type
  Call_CloudsearchDebugIdentitysourcesUnmappedidsList_598026 = ref object of OpenApiRestCall_597421
proc url_CloudsearchDebugIdentitysourcesUnmappedidsList_598028(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudsearchDebugIdentitysourcesUnmappedidsList_598027(
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
  var valid_598029 = path.getOrDefault("parent")
  valid_598029 = validateParameter(valid_598029, JString, required = true,
                                 default = nil)
  if valid_598029 != nil:
    section.add "parent", valid_598029
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
  var valid_598030 = query.getOrDefault("upload_protocol")
  valid_598030 = validateParameter(valid_598030, JString, required = false,
                                 default = nil)
  if valid_598030 != nil:
    section.add "upload_protocol", valid_598030
  var valid_598031 = query.getOrDefault("fields")
  valid_598031 = validateParameter(valid_598031, JString, required = false,
                                 default = nil)
  if valid_598031 != nil:
    section.add "fields", valid_598031
  var valid_598032 = query.getOrDefault("pageToken")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = nil)
  if valid_598032 != nil:
    section.add "pageToken", valid_598032
  var valid_598033 = query.getOrDefault("quotaUser")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "quotaUser", valid_598033
  var valid_598034 = query.getOrDefault("alt")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = newJString("json"))
  if valid_598034 != nil:
    section.add "alt", valid_598034
  var valid_598035 = query.getOrDefault("oauth_token")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = nil)
  if valid_598035 != nil:
    section.add "oauth_token", valid_598035
  var valid_598036 = query.getOrDefault("callback")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = nil)
  if valid_598036 != nil:
    section.add "callback", valid_598036
  var valid_598037 = query.getOrDefault("access_token")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = nil)
  if valid_598037 != nil:
    section.add "access_token", valid_598037
  var valid_598038 = query.getOrDefault("uploadType")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = nil)
  if valid_598038 != nil:
    section.add "uploadType", valid_598038
  var valid_598039 = query.getOrDefault("key")
  valid_598039 = validateParameter(valid_598039, JString, required = false,
                                 default = nil)
  if valid_598039 != nil:
    section.add "key", valid_598039
  var valid_598040 = query.getOrDefault("debugOptions.enableDebugging")
  valid_598040 = validateParameter(valid_598040, JBool, required = false, default = nil)
  if valid_598040 != nil:
    section.add "debugOptions.enableDebugging", valid_598040
  var valid_598041 = query.getOrDefault("resolutionStatusCode")
  valid_598041 = validateParameter(valid_598041, JString, required = false,
                                 default = newJString("CODE_UNSPECIFIED"))
  if valid_598041 != nil:
    section.add "resolutionStatusCode", valid_598041
  var valid_598042 = query.getOrDefault("$.xgafv")
  valid_598042 = validateParameter(valid_598042, JString, required = false,
                                 default = newJString("1"))
  if valid_598042 != nil:
    section.add "$.xgafv", valid_598042
  var valid_598043 = query.getOrDefault("pageSize")
  valid_598043 = validateParameter(valid_598043, JInt, required = false, default = nil)
  if valid_598043 != nil:
    section.add "pageSize", valid_598043
  var valid_598044 = query.getOrDefault("prettyPrint")
  valid_598044 = validateParameter(valid_598044, JBool, required = false,
                                 default = newJBool(true))
  if valid_598044 != nil:
    section.add "prettyPrint", valid_598044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598045: Call_CloudsearchDebugIdentitysourcesUnmappedidsList_598026;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists unmapped user identities for an identity source.
  ## 
  let valid = call_598045.validator(path, query, header, formData, body)
  let scheme = call_598045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598045.url(scheme.get, call_598045.host, call_598045.base,
                         call_598045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598045, url, valid)

proc call*(call_598046: Call_CloudsearchDebugIdentitysourcesUnmappedidsList_598026;
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
  var path_598047 = newJObject()
  var query_598048 = newJObject()
  add(query_598048, "upload_protocol", newJString(uploadProtocol))
  add(query_598048, "fields", newJString(fields))
  add(query_598048, "pageToken", newJString(pageToken))
  add(query_598048, "quotaUser", newJString(quotaUser))
  add(query_598048, "alt", newJString(alt))
  add(query_598048, "oauth_token", newJString(oauthToken))
  add(query_598048, "callback", newJString(callback))
  add(query_598048, "access_token", newJString(accessToken))
  add(query_598048, "uploadType", newJString(uploadType))
  add(path_598047, "parent", newJString(parent))
  add(query_598048, "key", newJString(key))
  add(query_598048, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_598048, "resolutionStatusCode", newJString(resolutionStatusCode))
  add(query_598048, "$.xgafv", newJString(Xgafv))
  add(query_598048, "pageSize", newJInt(pageSize))
  add(query_598048, "prettyPrint", newJBool(prettyPrint))
  result = call_598046.call(path_598047, query_598048, nil, nil, nil)

var cloudsearchDebugIdentitysourcesUnmappedidsList* = Call_CloudsearchDebugIdentitysourcesUnmappedidsList_598026(
    name: "cloudsearchDebugIdentitysourcesUnmappedidsList",
    meth: HttpMethod.HttpGet, host: "cloudsearch.googleapis.com",
    route: "/v1/debug/{parent}/unmappedids",
    validator: validate_CloudsearchDebugIdentitysourcesUnmappedidsList_598027,
    base: "/", url: url_CloudsearchDebugIdentitysourcesUnmappedidsList_598028,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsGet_598049 = ref object of OpenApiRestCall_597421
proc url_CloudsearchIndexingDatasourcesItemsGet_598051(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/indexing/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudsearchIndexingDatasourcesItemsGet_598050(path: JsonNode;
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
  var valid_598052 = path.getOrDefault("name")
  valid_598052 = validateParameter(valid_598052, JString, required = true,
                                 default = nil)
  if valid_598052 != nil:
    section.add "name", valid_598052
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
  var valid_598053 = query.getOrDefault("upload_protocol")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = nil)
  if valid_598053 != nil:
    section.add "upload_protocol", valid_598053
  var valid_598054 = query.getOrDefault("fields")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = nil)
  if valid_598054 != nil:
    section.add "fields", valid_598054
  var valid_598055 = query.getOrDefault("quotaUser")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = nil)
  if valid_598055 != nil:
    section.add "quotaUser", valid_598055
  var valid_598056 = query.getOrDefault("alt")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = newJString("json"))
  if valid_598056 != nil:
    section.add "alt", valid_598056
  var valid_598057 = query.getOrDefault("oauth_token")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = nil)
  if valid_598057 != nil:
    section.add "oauth_token", valid_598057
  var valid_598058 = query.getOrDefault("callback")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = nil)
  if valid_598058 != nil:
    section.add "callback", valid_598058
  var valid_598059 = query.getOrDefault("access_token")
  valid_598059 = validateParameter(valid_598059, JString, required = false,
                                 default = nil)
  if valid_598059 != nil:
    section.add "access_token", valid_598059
  var valid_598060 = query.getOrDefault("uploadType")
  valid_598060 = validateParameter(valid_598060, JString, required = false,
                                 default = nil)
  if valid_598060 != nil:
    section.add "uploadType", valid_598060
  var valid_598061 = query.getOrDefault("key")
  valid_598061 = validateParameter(valid_598061, JString, required = false,
                                 default = nil)
  if valid_598061 != nil:
    section.add "key", valid_598061
  var valid_598062 = query.getOrDefault("debugOptions.enableDebugging")
  valid_598062 = validateParameter(valid_598062, JBool, required = false, default = nil)
  if valid_598062 != nil:
    section.add "debugOptions.enableDebugging", valid_598062
  var valid_598063 = query.getOrDefault("$.xgafv")
  valid_598063 = validateParameter(valid_598063, JString, required = false,
                                 default = newJString("1"))
  if valid_598063 != nil:
    section.add "$.xgafv", valid_598063
  var valid_598064 = query.getOrDefault("prettyPrint")
  valid_598064 = validateParameter(valid_598064, JBool, required = false,
                                 default = newJBool(true))
  if valid_598064 != nil:
    section.add "prettyPrint", valid_598064
  var valid_598065 = query.getOrDefault("connectorName")
  valid_598065 = validateParameter(valid_598065, JString, required = false,
                                 default = nil)
  if valid_598065 != nil:
    section.add "connectorName", valid_598065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598066: Call_CloudsearchIndexingDatasourcesItemsGet_598049;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets Item resource by item name.
  ## 
  let valid = call_598066.validator(path, query, header, formData, body)
  let scheme = call_598066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598066.url(scheme.get, call_598066.host, call_598066.base,
                         call_598066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598066, url, valid)

proc call*(call_598067: Call_CloudsearchIndexingDatasourcesItemsGet_598049;
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
  var path_598068 = newJObject()
  var query_598069 = newJObject()
  add(query_598069, "upload_protocol", newJString(uploadProtocol))
  add(query_598069, "fields", newJString(fields))
  add(query_598069, "quotaUser", newJString(quotaUser))
  add(path_598068, "name", newJString(name))
  add(query_598069, "alt", newJString(alt))
  add(query_598069, "oauth_token", newJString(oauthToken))
  add(query_598069, "callback", newJString(callback))
  add(query_598069, "access_token", newJString(accessToken))
  add(query_598069, "uploadType", newJString(uploadType))
  add(query_598069, "key", newJString(key))
  add(query_598069, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_598069, "$.xgafv", newJString(Xgafv))
  add(query_598069, "prettyPrint", newJBool(prettyPrint))
  add(query_598069, "connectorName", newJString(connectorName))
  result = call_598067.call(path_598068, query_598069, nil, nil, nil)

var cloudsearchIndexingDatasourcesItemsGet* = Call_CloudsearchIndexingDatasourcesItemsGet_598049(
    name: "cloudsearchIndexingDatasourcesItemsGet", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}",
    validator: validate_CloudsearchIndexingDatasourcesItemsGet_598050, base: "/",
    url: url_CloudsearchIndexingDatasourcesItemsGet_598051,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsDelete_598070 = ref object of OpenApiRestCall_597421
proc url_CloudsearchIndexingDatasourcesItemsDelete_598072(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/indexing/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudsearchIndexingDatasourcesItemsDelete_598071(path: JsonNode;
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
  var valid_598073 = path.getOrDefault("name")
  valid_598073 = validateParameter(valid_598073, JString, required = true,
                                 default = nil)
  if valid_598073 != nil:
    section.add "name", valid_598073
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
  var valid_598074 = query.getOrDefault("upload_protocol")
  valid_598074 = validateParameter(valid_598074, JString, required = false,
                                 default = nil)
  if valid_598074 != nil:
    section.add "upload_protocol", valid_598074
  var valid_598075 = query.getOrDefault("fields")
  valid_598075 = validateParameter(valid_598075, JString, required = false,
                                 default = nil)
  if valid_598075 != nil:
    section.add "fields", valid_598075
  var valid_598076 = query.getOrDefault("quotaUser")
  valid_598076 = validateParameter(valid_598076, JString, required = false,
                                 default = nil)
  if valid_598076 != nil:
    section.add "quotaUser", valid_598076
  var valid_598077 = query.getOrDefault("alt")
  valid_598077 = validateParameter(valid_598077, JString, required = false,
                                 default = newJString("json"))
  if valid_598077 != nil:
    section.add "alt", valid_598077
  var valid_598078 = query.getOrDefault("oauth_token")
  valid_598078 = validateParameter(valid_598078, JString, required = false,
                                 default = nil)
  if valid_598078 != nil:
    section.add "oauth_token", valid_598078
  var valid_598079 = query.getOrDefault("callback")
  valid_598079 = validateParameter(valid_598079, JString, required = false,
                                 default = nil)
  if valid_598079 != nil:
    section.add "callback", valid_598079
  var valid_598080 = query.getOrDefault("access_token")
  valid_598080 = validateParameter(valid_598080, JString, required = false,
                                 default = nil)
  if valid_598080 != nil:
    section.add "access_token", valid_598080
  var valid_598081 = query.getOrDefault("uploadType")
  valid_598081 = validateParameter(valid_598081, JString, required = false,
                                 default = nil)
  if valid_598081 != nil:
    section.add "uploadType", valid_598081
  var valid_598082 = query.getOrDefault("mode")
  valid_598082 = validateParameter(valid_598082, JString, required = false,
                                 default = newJString("UNSPECIFIED"))
  if valid_598082 != nil:
    section.add "mode", valid_598082
  var valid_598083 = query.getOrDefault("key")
  valid_598083 = validateParameter(valid_598083, JString, required = false,
                                 default = nil)
  if valid_598083 != nil:
    section.add "key", valid_598083
  var valid_598084 = query.getOrDefault("debugOptions.enableDebugging")
  valid_598084 = validateParameter(valid_598084, JBool, required = false, default = nil)
  if valid_598084 != nil:
    section.add "debugOptions.enableDebugging", valid_598084
  var valid_598085 = query.getOrDefault("$.xgafv")
  valid_598085 = validateParameter(valid_598085, JString, required = false,
                                 default = newJString("1"))
  if valid_598085 != nil:
    section.add "$.xgafv", valid_598085
  var valid_598086 = query.getOrDefault("version")
  valid_598086 = validateParameter(valid_598086, JString, required = false,
                                 default = nil)
  if valid_598086 != nil:
    section.add "version", valid_598086
  var valid_598087 = query.getOrDefault("prettyPrint")
  valid_598087 = validateParameter(valid_598087, JBool, required = false,
                                 default = newJBool(true))
  if valid_598087 != nil:
    section.add "prettyPrint", valid_598087
  var valid_598088 = query.getOrDefault("connectorName")
  valid_598088 = validateParameter(valid_598088, JString, required = false,
                                 default = nil)
  if valid_598088 != nil:
    section.add "connectorName", valid_598088
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598089: Call_CloudsearchIndexingDatasourcesItemsDelete_598070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes Item resource for the
  ## specified resource name.
  ## 
  let valid = call_598089.validator(path, query, header, formData, body)
  let scheme = call_598089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598089.url(scheme.get, call_598089.host, call_598089.base,
                         call_598089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598089, url, valid)

proc call*(call_598090: Call_CloudsearchIndexingDatasourcesItemsDelete_598070;
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
  var path_598091 = newJObject()
  var query_598092 = newJObject()
  add(query_598092, "upload_protocol", newJString(uploadProtocol))
  add(query_598092, "fields", newJString(fields))
  add(query_598092, "quotaUser", newJString(quotaUser))
  add(path_598091, "name", newJString(name))
  add(query_598092, "alt", newJString(alt))
  add(query_598092, "oauth_token", newJString(oauthToken))
  add(query_598092, "callback", newJString(callback))
  add(query_598092, "access_token", newJString(accessToken))
  add(query_598092, "uploadType", newJString(uploadType))
  add(query_598092, "mode", newJString(mode))
  add(query_598092, "key", newJString(key))
  add(query_598092, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_598092, "$.xgafv", newJString(Xgafv))
  add(query_598092, "version", newJString(version))
  add(query_598092, "prettyPrint", newJBool(prettyPrint))
  add(query_598092, "connectorName", newJString(connectorName))
  result = call_598090.call(path_598091, query_598092, nil, nil, nil)

var cloudsearchIndexingDatasourcesItemsDelete* = Call_CloudsearchIndexingDatasourcesItemsDelete_598070(
    name: "cloudsearchIndexingDatasourcesItemsDelete",
    meth: HttpMethod.HttpDelete, host: "cloudsearch.googleapis.com",
    route: "/v1/indexing/{name}",
    validator: validate_CloudsearchIndexingDatasourcesItemsDelete_598071,
    base: "/", url: url_CloudsearchIndexingDatasourcesItemsDelete_598072,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsList_598093 = ref object of OpenApiRestCall_597421
proc url_CloudsearchIndexingDatasourcesItemsList_598095(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudsearchIndexingDatasourcesItemsList_598094(path: JsonNode;
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
  var valid_598096 = path.getOrDefault("name")
  valid_598096 = validateParameter(valid_598096, JString, required = true,
                                 default = nil)
  if valid_598096 != nil:
    section.add "name", valid_598096
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
  var valid_598097 = query.getOrDefault("upload_protocol")
  valid_598097 = validateParameter(valid_598097, JString, required = false,
                                 default = nil)
  if valid_598097 != nil:
    section.add "upload_protocol", valid_598097
  var valid_598098 = query.getOrDefault("fields")
  valid_598098 = validateParameter(valid_598098, JString, required = false,
                                 default = nil)
  if valid_598098 != nil:
    section.add "fields", valid_598098
  var valid_598099 = query.getOrDefault("pageToken")
  valid_598099 = validateParameter(valid_598099, JString, required = false,
                                 default = nil)
  if valid_598099 != nil:
    section.add "pageToken", valid_598099
  var valid_598100 = query.getOrDefault("quotaUser")
  valid_598100 = validateParameter(valid_598100, JString, required = false,
                                 default = nil)
  if valid_598100 != nil:
    section.add "quotaUser", valid_598100
  var valid_598101 = query.getOrDefault("alt")
  valid_598101 = validateParameter(valid_598101, JString, required = false,
                                 default = newJString("json"))
  if valid_598101 != nil:
    section.add "alt", valid_598101
  var valid_598102 = query.getOrDefault("oauth_token")
  valid_598102 = validateParameter(valid_598102, JString, required = false,
                                 default = nil)
  if valid_598102 != nil:
    section.add "oauth_token", valid_598102
  var valid_598103 = query.getOrDefault("callback")
  valid_598103 = validateParameter(valid_598103, JString, required = false,
                                 default = nil)
  if valid_598103 != nil:
    section.add "callback", valid_598103
  var valid_598104 = query.getOrDefault("access_token")
  valid_598104 = validateParameter(valid_598104, JString, required = false,
                                 default = nil)
  if valid_598104 != nil:
    section.add "access_token", valid_598104
  var valid_598105 = query.getOrDefault("uploadType")
  valid_598105 = validateParameter(valid_598105, JString, required = false,
                                 default = nil)
  if valid_598105 != nil:
    section.add "uploadType", valid_598105
  var valid_598106 = query.getOrDefault("key")
  valid_598106 = validateParameter(valid_598106, JString, required = false,
                                 default = nil)
  if valid_598106 != nil:
    section.add "key", valid_598106
  var valid_598107 = query.getOrDefault("brief")
  valid_598107 = validateParameter(valid_598107, JBool, required = false, default = nil)
  if valid_598107 != nil:
    section.add "brief", valid_598107
  var valid_598108 = query.getOrDefault("debugOptions.enableDebugging")
  valid_598108 = validateParameter(valid_598108, JBool, required = false, default = nil)
  if valid_598108 != nil:
    section.add "debugOptions.enableDebugging", valid_598108
  var valid_598109 = query.getOrDefault("$.xgafv")
  valid_598109 = validateParameter(valid_598109, JString, required = false,
                                 default = newJString("1"))
  if valid_598109 != nil:
    section.add "$.xgafv", valid_598109
  var valid_598110 = query.getOrDefault("pageSize")
  valid_598110 = validateParameter(valid_598110, JInt, required = false, default = nil)
  if valid_598110 != nil:
    section.add "pageSize", valid_598110
  var valid_598111 = query.getOrDefault("prettyPrint")
  valid_598111 = validateParameter(valid_598111, JBool, required = false,
                                 default = newJBool(true))
  if valid_598111 != nil:
    section.add "prettyPrint", valid_598111
  var valid_598112 = query.getOrDefault("connectorName")
  valid_598112 = validateParameter(valid_598112, JString, required = false,
                                 default = nil)
  if valid_598112 != nil:
    section.add "connectorName", valid_598112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598113: Call_CloudsearchIndexingDatasourcesItemsList_598093;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all or a subset of Item resources.
  ## 
  let valid = call_598113.validator(path, query, header, formData, body)
  let scheme = call_598113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598113.url(scheme.get, call_598113.host, call_598113.base,
                         call_598113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598113, url, valid)

proc call*(call_598114: Call_CloudsearchIndexingDatasourcesItemsList_598093;
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
  var path_598115 = newJObject()
  var query_598116 = newJObject()
  add(query_598116, "upload_protocol", newJString(uploadProtocol))
  add(query_598116, "fields", newJString(fields))
  add(query_598116, "pageToken", newJString(pageToken))
  add(query_598116, "quotaUser", newJString(quotaUser))
  add(path_598115, "name", newJString(name))
  add(query_598116, "alt", newJString(alt))
  add(query_598116, "oauth_token", newJString(oauthToken))
  add(query_598116, "callback", newJString(callback))
  add(query_598116, "access_token", newJString(accessToken))
  add(query_598116, "uploadType", newJString(uploadType))
  add(query_598116, "key", newJString(key))
  add(query_598116, "brief", newJBool(brief))
  add(query_598116, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_598116, "$.xgafv", newJString(Xgafv))
  add(query_598116, "pageSize", newJInt(pageSize))
  add(query_598116, "prettyPrint", newJBool(prettyPrint))
  add(query_598116, "connectorName", newJString(connectorName))
  result = call_598114.call(path_598115, query_598116, nil, nil, nil)

var cloudsearchIndexingDatasourcesItemsList* = Call_CloudsearchIndexingDatasourcesItemsList_598093(
    name: "cloudsearchIndexingDatasourcesItemsList", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}/items",
    validator: validate_CloudsearchIndexingDatasourcesItemsList_598094, base: "/",
    url: url_CloudsearchIndexingDatasourcesItemsList_598095,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_598117 = ref object of OpenApiRestCall_597421
proc url_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_598119(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_598118(
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
  var valid_598120 = path.getOrDefault("name")
  valid_598120 = validateParameter(valid_598120, JString, required = true,
                                 default = nil)
  if valid_598120 != nil:
    section.add "name", valid_598120
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
  var valid_598121 = query.getOrDefault("upload_protocol")
  valid_598121 = validateParameter(valid_598121, JString, required = false,
                                 default = nil)
  if valid_598121 != nil:
    section.add "upload_protocol", valid_598121
  var valid_598122 = query.getOrDefault("fields")
  valid_598122 = validateParameter(valid_598122, JString, required = false,
                                 default = nil)
  if valid_598122 != nil:
    section.add "fields", valid_598122
  var valid_598123 = query.getOrDefault("quotaUser")
  valid_598123 = validateParameter(valid_598123, JString, required = false,
                                 default = nil)
  if valid_598123 != nil:
    section.add "quotaUser", valid_598123
  var valid_598124 = query.getOrDefault("alt")
  valid_598124 = validateParameter(valid_598124, JString, required = false,
                                 default = newJString("json"))
  if valid_598124 != nil:
    section.add "alt", valid_598124
  var valid_598125 = query.getOrDefault("oauth_token")
  valid_598125 = validateParameter(valid_598125, JString, required = false,
                                 default = nil)
  if valid_598125 != nil:
    section.add "oauth_token", valid_598125
  var valid_598126 = query.getOrDefault("callback")
  valid_598126 = validateParameter(valid_598126, JString, required = false,
                                 default = nil)
  if valid_598126 != nil:
    section.add "callback", valid_598126
  var valid_598127 = query.getOrDefault("access_token")
  valid_598127 = validateParameter(valid_598127, JString, required = false,
                                 default = nil)
  if valid_598127 != nil:
    section.add "access_token", valid_598127
  var valid_598128 = query.getOrDefault("uploadType")
  valid_598128 = validateParameter(valid_598128, JString, required = false,
                                 default = nil)
  if valid_598128 != nil:
    section.add "uploadType", valid_598128
  var valid_598129 = query.getOrDefault("key")
  valid_598129 = validateParameter(valid_598129, JString, required = false,
                                 default = nil)
  if valid_598129 != nil:
    section.add "key", valid_598129
  var valid_598130 = query.getOrDefault("$.xgafv")
  valid_598130 = validateParameter(valid_598130, JString, required = false,
                                 default = newJString("1"))
  if valid_598130 != nil:
    section.add "$.xgafv", valid_598130
  var valid_598131 = query.getOrDefault("prettyPrint")
  valid_598131 = validateParameter(valid_598131, JBool, required = false,
                                 default = newJBool(true))
  if valid_598131 != nil:
    section.add "prettyPrint", valid_598131
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

proc call*(call_598133: Call_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_598117;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all items in a queue. This method is useful for deleting stale
  ## items.
  ## 
  let valid = call_598133.validator(path, query, header, formData, body)
  let scheme = call_598133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598133.url(scheme.get, call_598133.host, call_598133.base,
                         call_598133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598133, url, valid)

proc call*(call_598134: Call_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_598117;
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
  var path_598135 = newJObject()
  var query_598136 = newJObject()
  var body_598137 = newJObject()
  add(query_598136, "upload_protocol", newJString(uploadProtocol))
  add(query_598136, "fields", newJString(fields))
  add(query_598136, "quotaUser", newJString(quotaUser))
  add(path_598135, "name", newJString(name))
  add(query_598136, "alt", newJString(alt))
  add(query_598136, "oauth_token", newJString(oauthToken))
  add(query_598136, "callback", newJString(callback))
  add(query_598136, "access_token", newJString(accessToken))
  add(query_598136, "uploadType", newJString(uploadType))
  add(query_598136, "key", newJString(key))
  add(query_598136, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598137 = body
  add(query_598136, "prettyPrint", newJBool(prettyPrint))
  result = call_598134.call(path_598135, query_598136, nil, nil, body_598137)

var cloudsearchIndexingDatasourcesItemsDeleteQueueItems* = Call_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_598117(
    name: "cloudsearchIndexingDatasourcesItemsDeleteQueueItems",
    meth: HttpMethod.HttpPost, host: "cloudsearch.googleapis.com",
    route: "/v1/indexing/{name}/items:deleteQueueItems",
    validator: validate_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_598118,
    base: "/", url: url_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_598119,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsPoll_598138 = ref object of OpenApiRestCall_597421
proc url_CloudsearchIndexingDatasourcesItemsPoll_598140(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudsearchIndexingDatasourcesItemsPoll_598139(path: JsonNode;
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
  var valid_598141 = path.getOrDefault("name")
  valid_598141 = validateParameter(valid_598141, JString, required = true,
                                 default = nil)
  if valid_598141 != nil:
    section.add "name", valid_598141
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
  var valid_598142 = query.getOrDefault("upload_protocol")
  valid_598142 = validateParameter(valid_598142, JString, required = false,
                                 default = nil)
  if valid_598142 != nil:
    section.add "upload_protocol", valid_598142
  var valid_598143 = query.getOrDefault("fields")
  valid_598143 = validateParameter(valid_598143, JString, required = false,
                                 default = nil)
  if valid_598143 != nil:
    section.add "fields", valid_598143
  var valid_598144 = query.getOrDefault("quotaUser")
  valid_598144 = validateParameter(valid_598144, JString, required = false,
                                 default = nil)
  if valid_598144 != nil:
    section.add "quotaUser", valid_598144
  var valid_598145 = query.getOrDefault("alt")
  valid_598145 = validateParameter(valid_598145, JString, required = false,
                                 default = newJString("json"))
  if valid_598145 != nil:
    section.add "alt", valid_598145
  var valid_598146 = query.getOrDefault("oauth_token")
  valid_598146 = validateParameter(valid_598146, JString, required = false,
                                 default = nil)
  if valid_598146 != nil:
    section.add "oauth_token", valid_598146
  var valid_598147 = query.getOrDefault("callback")
  valid_598147 = validateParameter(valid_598147, JString, required = false,
                                 default = nil)
  if valid_598147 != nil:
    section.add "callback", valid_598147
  var valid_598148 = query.getOrDefault("access_token")
  valid_598148 = validateParameter(valid_598148, JString, required = false,
                                 default = nil)
  if valid_598148 != nil:
    section.add "access_token", valid_598148
  var valid_598149 = query.getOrDefault("uploadType")
  valid_598149 = validateParameter(valid_598149, JString, required = false,
                                 default = nil)
  if valid_598149 != nil:
    section.add "uploadType", valid_598149
  var valid_598150 = query.getOrDefault("key")
  valid_598150 = validateParameter(valid_598150, JString, required = false,
                                 default = nil)
  if valid_598150 != nil:
    section.add "key", valid_598150
  var valid_598151 = query.getOrDefault("$.xgafv")
  valid_598151 = validateParameter(valid_598151, JString, required = false,
                                 default = newJString("1"))
  if valid_598151 != nil:
    section.add "$.xgafv", valid_598151
  var valid_598152 = query.getOrDefault("prettyPrint")
  valid_598152 = validateParameter(valid_598152, JBool, required = false,
                                 default = newJBool(true))
  if valid_598152 != nil:
    section.add "prettyPrint", valid_598152
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

proc call*(call_598154: Call_CloudsearchIndexingDatasourcesItemsPoll_598138;
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
  let valid = call_598154.validator(path, query, header, formData, body)
  let scheme = call_598154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598154.url(scheme.get, call_598154.host, call_598154.base,
                         call_598154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598154, url, valid)

proc call*(call_598155: Call_CloudsearchIndexingDatasourcesItemsPoll_598138;
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
  var path_598156 = newJObject()
  var query_598157 = newJObject()
  var body_598158 = newJObject()
  add(query_598157, "upload_protocol", newJString(uploadProtocol))
  add(query_598157, "fields", newJString(fields))
  add(query_598157, "quotaUser", newJString(quotaUser))
  add(path_598156, "name", newJString(name))
  add(query_598157, "alt", newJString(alt))
  add(query_598157, "oauth_token", newJString(oauthToken))
  add(query_598157, "callback", newJString(callback))
  add(query_598157, "access_token", newJString(accessToken))
  add(query_598157, "uploadType", newJString(uploadType))
  add(query_598157, "key", newJString(key))
  add(query_598157, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598158 = body
  add(query_598157, "prettyPrint", newJBool(prettyPrint))
  result = call_598155.call(path_598156, query_598157, nil, nil, body_598158)

var cloudsearchIndexingDatasourcesItemsPoll* = Call_CloudsearchIndexingDatasourcesItemsPoll_598138(
    name: "cloudsearchIndexingDatasourcesItemsPoll", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}/items:poll",
    validator: validate_CloudsearchIndexingDatasourcesItemsPoll_598139, base: "/",
    url: url_CloudsearchIndexingDatasourcesItemsPoll_598140,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsUnreserve_598159 = ref object of OpenApiRestCall_597421
proc url_CloudsearchIndexingDatasourcesItemsUnreserve_598161(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudsearchIndexingDatasourcesItemsUnreserve_598160(path: JsonNode;
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
  var valid_598162 = path.getOrDefault("name")
  valid_598162 = validateParameter(valid_598162, JString, required = true,
                                 default = nil)
  if valid_598162 != nil:
    section.add "name", valid_598162
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
  var valid_598163 = query.getOrDefault("upload_protocol")
  valid_598163 = validateParameter(valid_598163, JString, required = false,
                                 default = nil)
  if valid_598163 != nil:
    section.add "upload_protocol", valid_598163
  var valid_598164 = query.getOrDefault("fields")
  valid_598164 = validateParameter(valid_598164, JString, required = false,
                                 default = nil)
  if valid_598164 != nil:
    section.add "fields", valid_598164
  var valid_598165 = query.getOrDefault("quotaUser")
  valid_598165 = validateParameter(valid_598165, JString, required = false,
                                 default = nil)
  if valid_598165 != nil:
    section.add "quotaUser", valid_598165
  var valid_598166 = query.getOrDefault("alt")
  valid_598166 = validateParameter(valid_598166, JString, required = false,
                                 default = newJString("json"))
  if valid_598166 != nil:
    section.add "alt", valid_598166
  var valid_598167 = query.getOrDefault("oauth_token")
  valid_598167 = validateParameter(valid_598167, JString, required = false,
                                 default = nil)
  if valid_598167 != nil:
    section.add "oauth_token", valid_598167
  var valid_598168 = query.getOrDefault("callback")
  valid_598168 = validateParameter(valid_598168, JString, required = false,
                                 default = nil)
  if valid_598168 != nil:
    section.add "callback", valid_598168
  var valid_598169 = query.getOrDefault("access_token")
  valid_598169 = validateParameter(valid_598169, JString, required = false,
                                 default = nil)
  if valid_598169 != nil:
    section.add "access_token", valid_598169
  var valid_598170 = query.getOrDefault("uploadType")
  valid_598170 = validateParameter(valid_598170, JString, required = false,
                                 default = nil)
  if valid_598170 != nil:
    section.add "uploadType", valid_598170
  var valid_598171 = query.getOrDefault("key")
  valid_598171 = validateParameter(valid_598171, JString, required = false,
                                 default = nil)
  if valid_598171 != nil:
    section.add "key", valid_598171
  var valid_598172 = query.getOrDefault("$.xgafv")
  valid_598172 = validateParameter(valid_598172, JString, required = false,
                                 default = newJString("1"))
  if valid_598172 != nil:
    section.add "$.xgafv", valid_598172
  var valid_598173 = query.getOrDefault("prettyPrint")
  valid_598173 = validateParameter(valid_598173, JBool, required = false,
                                 default = newJBool(true))
  if valid_598173 != nil:
    section.add "prettyPrint", valid_598173
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

proc call*(call_598175: Call_CloudsearchIndexingDatasourcesItemsUnreserve_598159;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unreserves all items from a queue, making them all eligible to be
  ## polled.  This method is useful for resetting the indexing queue
  ## after a connector has been restarted.
  ## 
  let valid = call_598175.validator(path, query, header, formData, body)
  let scheme = call_598175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598175.url(scheme.get, call_598175.host, call_598175.base,
                         call_598175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598175, url, valid)

proc call*(call_598176: Call_CloudsearchIndexingDatasourcesItemsUnreserve_598159;
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
  var path_598177 = newJObject()
  var query_598178 = newJObject()
  var body_598179 = newJObject()
  add(query_598178, "upload_protocol", newJString(uploadProtocol))
  add(query_598178, "fields", newJString(fields))
  add(query_598178, "quotaUser", newJString(quotaUser))
  add(path_598177, "name", newJString(name))
  add(query_598178, "alt", newJString(alt))
  add(query_598178, "oauth_token", newJString(oauthToken))
  add(query_598178, "callback", newJString(callback))
  add(query_598178, "access_token", newJString(accessToken))
  add(query_598178, "uploadType", newJString(uploadType))
  add(query_598178, "key", newJString(key))
  add(query_598178, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598179 = body
  add(query_598178, "prettyPrint", newJBool(prettyPrint))
  result = call_598176.call(path_598177, query_598178, nil, nil, body_598179)

var cloudsearchIndexingDatasourcesItemsUnreserve* = Call_CloudsearchIndexingDatasourcesItemsUnreserve_598159(
    name: "cloudsearchIndexingDatasourcesItemsUnreserve",
    meth: HttpMethod.HttpPost, host: "cloudsearch.googleapis.com",
    route: "/v1/indexing/{name}/items:unreserve",
    validator: validate_CloudsearchIndexingDatasourcesItemsUnreserve_598160,
    base: "/", url: url_CloudsearchIndexingDatasourcesItemsUnreserve_598161,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesUpdateSchema_598200 = ref object of OpenApiRestCall_597421
proc url_CloudsearchIndexingDatasourcesUpdateSchema_598202(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudsearchIndexingDatasourcesUpdateSchema_598201(path: JsonNode;
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
  var valid_598203 = path.getOrDefault("name")
  valid_598203 = validateParameter(valid_598203, JString, required = true,
                                 default = nil)
  if valid_598203 != nil:
    section.add "name", valid_598203
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
  var valid_598204 = query.getOrDefault("upload_protocol")
  valid_598204 = validateParameter(valid_598204, JString, required = false,
                                 default = nil)
  if valid_598204 != nil:
    section.add "upload_protocol", valid_598204
  var valid_598205 = query.getOrDefault("fields")
  valid_598205 = validateParameter(valid_598205, JString, required = false,
                                 default = nil)
  if valid_598205 != nil:
    section.add "fields", valid_598205
  var valid_598206 = query.getOrDefault("quotaUser")
  valid_598206 = validateParameter(valid_598206, JString, required = false,
                                 default = nil)
  if valid_598206 != nil:
    section.add "quotaUser", valid_598206
  var valid_598207 = query.getOrDefault("alt")
  valid_598207 = validateParameter(valid_598207, JString, required = false,
                                 default = newJString("json"))
  if valid_598207 != nil:
    section.add "alt", valid_598207
  var valid_598208 = query.getOrDefault("oauth_token")
  valid_598208 = validateParameter(valid_598208, JString, required = false,
                                 default = nil)
  if valid_598208 != nil:
    section.add "oauth_token", valid_598208
  var valid_598209 = query.getOrDefault("callback")
  valid_598209 = validateParameter(valid_598209, JString, required = false,
                                 default = nil)
  if valid_598209 != nil:
    section.add "callback", valid_598209
  var valid_598210 = query.getOrDefault("access_token")
  valid_598210 = validateParameter(valid_598210, JString, required = false,
                                 default = nil)
  if valid_598210 != nil:
    section.add "access_token", valid_598210
  var valid_598211 = query.getOrDefault("uploadType")
  valid_598211 = validateParameter(valid_598211, JString, required = false,
                                 default = nil)
  if valid_598211 != nil:
    section.add "uploadType", valid_598211
  var valid_598212 = query.getOrDefault("key")
  valid_598212 = validateParameter(valid_598212, JString, required = false,
                                 default = nil)
  if valid_598212 != nil:
    section.add "key", valid_598212
  var valid_598213 = query.getOrDefault("$.xgafv")
  valid_598213 = validateParameter(valid_598213, JString, required = false,
                                 default = newJString("1"))
  if valid_598213 != nil:
    section.add "$.xgafv", valid_598213
  var valid_598214 = query.getOrDefault("prettyPrint")
  valid_598214 = validateParameter(valid_598214, JBool, required = false,
                                 default = newJBool(true))
  if valid_598214 != nil:
    section.add "prettyPrint", valid_598214
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

proc call*(call_598216: Call_CloudsearchIndexingDatasourcesUpdateSchema_598200;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the schema of a data source.
  ## 
  let valid = call_598216.validator(path, query, header, formData, body)
  let scheme = call_598216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598216.url(scheme.get, call_598216.host, call_598216.base,
                         call_598216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598216, url, valid)

proc call*(call_598217: Call_CloudsearchIndexingDatasourcesUpdateSchema_598200;
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
  var path_598218 = newJObject()
  var query_598219 = newJObject()
  var body_598220 = newJObject()
  add(query_598219, "upload_protocol", newJString(uploadProtocol))
  add(query_598219, "fields", newJString(fields))
  add(query_598219, "quotaUser", newJString(quotaUser))
  add(path_598218, "name", newJString(name))
  add(query_598219, "alt", newJString(alt))
  add(query_598219, "oauth_token", newJString(oauthToken))
  add(query_598219, "callback", newJString(callback))
  add(query_598219, "access_token", newJString(accessToken))
  add(query_598219, "uploadType", newJString(uploadType))
  add(query_598219, "key", newJString(key))
  add(query_598219, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598220 = body
  add(query_598219, "prettyPrint", newJBool(prettyPrint))
  result = call_598217.call(path_598218, query_598219, nil, nil, body_598220)

var cloudsearchIndexingDatasourcesUpdateSchema* = Call_CloudsearchIndexingDatasourcesUpdateSchema_598200(
    name: "cloudsearchIndexingDatasourcesUpdateSchema", meth: HttpMethod.HttpPut,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}/schema",
    validator: validate_CloudsearchIndexingDatasourcesUpdateSchema_598201,
    base: "/", url: url_CloudsearchIndexingDatasourcesUpdateSchema_598202,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesGetSchema_598180 = ref object of OpenApiRestCall_597421
proc url_CloudsearchIndexingDatasourcesGetSchema_598182(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudsearchIndexingDatasourcesGetSchema_598181(path: JsonNode;
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
  var valid_598183 = path.getOrDefault("name")
  valid_598183 = validateParameter(valid_598183, JString, required = true,
                                 default = nil)
  if valid_598183 != nil:
    section.add "name", valid_598183
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
  var valid_598184 = query.getOrDefault("upload_protocol")
  valid_598184 = validateParameter(valid_598184, JString, required = false,
                                 default = nil)
  if valid_598184 != nil:
    section.add "upload_protocol", valid_598184
  var valid_598185 = query.getOrDefault("fields")
  valid_598185 = validateParameter(valid_598185, JString, required = false,
                                 default = nil)
  if valid_598185 != nil:
    section.add "fields", valid_598185
  var valid_598186 = query.getOrDefault("quotaUser")
  valid_598186 = validateParameter(valid_598186, JString, required = false,
                                 default = nil)
  if valid_598186 != nil:
    section.add "quotaUser", valid_598186
  var valid_598187 = query.getOrDefault("alt")
  valid_598187 = validateParameter(valid_598187, JString, required = false,
                                 default = newJString("json"))
  if valid_598187 != nil:
    section.add "alt", valid_598187
  var valid_598188 = query.getOrDefault("oauth_token")
  valid_598188 = validateParameter(valid_598188, JString, required = false,
                                 default = nil)
  if valid_598188 != nil:
    section.add "oauth_token", valid_598188
  var valid_598189 = query.getOrDefault("callback")
  valid_598189 = validateParameter(valid_598189, JString, required = false,
                                 default = nil)
  if valid_598189 != nil:
    section.add "callback", valid_598189
  var valid_598190 = query.getOrDefault("access_token")
  valid_598190 = validateParameter(valid_598190, JString, required = false,
                                 default = nil)
  if valid_598190 != nil:
    section.add "access_token", valid_598190
  var valid_598191 = query.getOrDefault("uploadType")
  valid_598191 = validateParameter(valid_598191, JString, required = false,
                                 default = nil)
  if valid_598191 != nil:
    section.add "uploadType", valid_598191
  var valid_598192 = query.getOrDefault("key")
  valid_598192 = validateParameter(valid_598192, JString, required = false,
                                 default = nil)
  if valid_598192 != nil:
    section.add "key", valid_598192
  var valid_598193 = query.getOrDefault("debugOptions.enableDebugging")
  valid_598193 = validateParameter(valid_598193, JBool, required = false, default = nil)
  if valid_598193 != nil:
    section.add "debugOptions.enableDebugging", valid_598193
  var valid_598194 = query.getOrDefault("$.xgafv")
  valid_598194 = validateParameter(valid_598194, JString, required = false,
                                 default = newJString("1"))
  if valid_598194 != nil:
    section.add "$.xgafv", valid_598194
  var valid_598195 = query.getOrDefault("prettyPrint")
  valid_598195 = validateParameter(valid_598195, JBool, required = false,
                                 default = newJBool(true))
  if valid_598195 != nil:
    section.add "prettyPrint", valid_598195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598196: Call_CloudsearchIndexingDatasourcesGetSchema_598180;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the schema of a data source.
  ## 
  let valid = call_598196.validator(path, query, header, formData, body)
  let scheme = call_598196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598196.url(scheme.get, call_598196.host, call_598196.base,
                         call_598196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598196, url, valid)

proc call*(call_598197: Call_CloudsearchIndexingDatasourcesGetSchema_598180;
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
  var path_598198 = newJObject()
  var query_598199 = newJObject()
  add(query_598199, "upload_protocol", newJString(uploadProtocol))
  add(query_598199, "fields", newJString(fields))
  add(query_598199, "quotaUser", newJString(quotaUser))
  add(path_598198, "name", newJString(name))
  add(query_598199, "alt", newJString(alt))
  add(query_598199, "oauth_token", newJString(oauthToken))
  add(query_598199, "callback", newJString(callback))
  add(query_598199, "access_token", newJString(accessToken))
  add(query_598199, "uploadType", newJString(uploadType))
  add(query_598199, "key", newJString(key))
  add(query_598199, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_598199, "$.xgafv", newJString(Xgafv))
  add(query_598199, "prettyPrint", newJBool(prettyPrint))
  result = call_598197.call(path_598198, query_598199, nil, nil, nil)

var cloudsearchIndexingDatasourcesGetSchema* = Call_CloudsearchIndexingDatasourcesGetSchema_598180(
    name: "cloudsearchIndexingDatasourcesGetSchema", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}/schema",
    validator: validate_CloudsearchIndexingDatasourcesGetSchema_598181, base: "/",
    url: url_CloudsearchIndexingDatasourcesGetSchema_598182,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesDeleteSchema_598221 = ref object of OpenApiRestCall_597421
proc url_CloudsearchIndexingDatasourcesDeleteSchema_598223(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudsearchIndexingDatasourcesDeleteSchema_598222(path: JsonNode;
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
  var valid_598224 = path.getOrDefault("name")
  valid_598224 = validateParameter(valid_598224, JString, required = true,
                                 default = nil)
  if valid_598224 != nil:
    section.add "name", valid_598224
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
  var valid_598225 = query.getOrDefault("upload_protocol")
  valid_598225 = validateParameter(valid_598225, JString, required = false,
                                 default = nil)
  if valid_598225 != nil:
    section.add "upload_protocol", valid_598225
  var valid_598226 = query.getOrDefault("fields")
  valid_598226 = validateParameter(valid_598226, JString, required = false,
                                 default = nil)
  if valid_598226 != nil:
    section.add "fields", valid_598226
  var valid_598227 = query.getOrDefault("quotaUser")
  valid_598227 = validateParameter(valid_598227, JString, required = false,
                                 default = nil)
  if valid_598227 != nil:
    section.add "quotaUser", valid_598227
  var valid_598228 = query.getOrDefault("alt")
  valid_598228 = validateParameter(valid_598228, JString, required = false,
                                 default = newJString("json"))
  if valid_598228 != nil:
    section.add "alt", valid_598228
  var valid_598229 = query.getOrDefault("oauth_token")
  valid_598229 = validateParameter(valid_598229, JString, required = false,
                                 default = nil)
  if valid_598229 != nil:
    section.add "oauth_token", valid_598229
  var valid_598230 = query.getOrDefault("callback")
  valid_598230 = validateParameter(valid_598230, JString, required = false,
                                 default = nil)
  if valid_598230 != nil:
    section.add "callback", valid_598230
  var valid_598231 = query.getOrDefault("access_token")
  valid_598231 = validateParameter(valid_598231, JString, required = false,
                                 default = nil)
  if valid_598231 != nil:
    section.add "access_token", valid_598231
  var valid_598232 = query.getOrDefault("uploadType")
  valid_598232 = validateParameter(valid_598232, JString, required = false,
                                 default = nil)
  if valid_598232 != nil:
    section.add "uploadType", valid_598232
  var valid_598233 = query.getOrDefault("key")
  valid_598233 = validateParameter(valid_598233, JString, required = false,
                                 default = nil)
  if valid_598233 != nil:
    section.add "key", valid_598233
  var valid_598234 = query.getOrDefault("debugOptions.enableDebugging")
  valid_598234 = validateParameter(valid_598234, JBool, required = false, default = nil)
  if valid_598234 != nil:
    section.add "debugOptions.enableDebugging", valid_598234
  var valid_598235 = query.getOrDefault("$.xgafv")
  valid_598235 = validateParameter(valid_598235, JString, required = false,
                                 default = newJString("1"))
  if valid_598235 != nil:
    section.add "$.xgafv", valid_598235
  var valid_598236 = query.getOrDefault("prettyPrint")
  valid_598236 = validateParameter(valid_598236, JBool, required = false,
                                 default = newJBool(true))
  if valid_598236 != nil:
    section.add "prettyPrint", valid_598236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598237: Call_CloudsearchIndexingDatasourcesDeleteSchema_598221;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the schema of a data source.
  ## 
  let valid = call_598237.validator(path, query, header, formData, body)
  let scheme = call_598237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598237.url(scheme.get, call_598237.host, call_598237.base,
                         call_598237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598237, url, valid)

proc call*(call_598238: Call_CloudsearchIndexingDatasourcesDeleteSchema_598221;
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
  var path_598239 = newJObject()
  var query_598240 = newJObject()
  add(query_598240, "upload_protocol", newJString(uploadProtocol))
  add(query_598240, "fields", newJString(fields))
  add(query_598240, "quotaUser", newJString(quotaUser))
  add(path_598239, "name", newJString(name))
  add(query_598240, "alt", newJString(alt))
  add(query_598240, "oauth_token", newJString(oauthToken))
  add(query_598240, "callback", newJString(callback))
  add(query_598240, "access_token", newJString(accessToken))
  add(query_598240, "uploadType", newJString(uploadType))
  add(query_598240, "key", newJString(key))
  add(query_598240, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_598240, "$.xgafv", newJString(Xgafv))
  add(query_598240, "prettyPrint", newJBool(prettyPrint))
  result = call_598238.call(path_598239, query_598240, nil, nil, nil)

var cloudsearchIndexingDatasourcesDeleteSchema* = Call_CloudsearchIndexingDatasourcesDeleteSchema_598221(
    name: "cloudsearchIndexingDatasourcesDeleteSchema",
    meth: HttpMethod.HttpDelete, host: "cloudsearch.googleapis.com",
    route: "/v1/indexing/{name}/schema",
    validator: validate_CloudsearchIndexingDatasourcesDeleteSchema_598222,
    base: "/", url: url_CloudsearchIndexingDatasourcesDeleteSchema_598223,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsIndex_598241 = ref object of OpenApiRestCall_597421
proc url_CloudsearchIndexingDatasourcesItemsIndex_598243(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudsearchIndexingDatasourcesItemsIndex_598242(path: JsonNode;
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
  var valid_598244 = path.getOrDefault("name")
  valid_598244 = validateParameter(valid_598244, JString, required = true,
                                 default = nil)
  if valid_598244 != nil:
    section.add "name", valid_598244
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
  var valid_598245 = query.getOrDefault("upload_protocol")
  valid_598245 = validateParameter(valid_598245, JString, required = false,
                                 default = nil)
  if valid_598245 != nil:
    section.add "upload_protocol", valid_598245
  var valid_598246 = query.getOrDefault("fields")
  valid_598246 = validateParameter(valid_598246, JString, required = false,
                                 default = nil)
  if valid_598246 != nil:
    section.add "fields", valid_598246
  var valid_598247 = query.getOrDefault("quotaUser")
  valid_598247 = validateParameter(valid_598247, JString, required = false,
                                 default = nil)
  if valid_598247 != nil:
    section.add "quotaUser", valid_598247
  var valid_598248 = query.getOrDefault("alt")
  valid_598248 = validateParameter(valid_598248, JString, required = false,
                                 default = newJString("json"))
  if valid_598248 != nil:
    section.add "alt", valid_598248
  var valid_598249 = query.getOrDefault("oauth_token")
  valid_598249 = validateParameter(valid_598249, JString, required = false,
                                 default = nil)
  if valid_598249 != nil:
    section.add "oauth_token", valid_598249
  var valid_598250 = query.getOrDefault("callback")
  valid_598250 = validateParameter(valid_598250, JString, required = false,
                                 default = nil)
  if valid_598250 != nil:
    section.add "callback", valid_598250
  var valid_598251 = query.getOrDefault("access_token")
  valid_598251 = validateParameter(valid_598251, JString, required = false,
                                 default = nil)
  if valid_598251 != nil:
    section.add "access_token", valid_598251
  var valid_598252 = query.getOrDefault("uploadType")
  valid_598252 = validateParameter(valid_598252, JString, required = false,
                                 default = nil)
  if valid_598252 != nil:
    section.add "uploadType", valid_598252
  var valid_598253 = query.getOrDefault("key")
  valid_598253 = validateParameter(valid_598253, JString, required = false,
                                 default = nil)
  if valid_598253 != nil:
    section.add "key", valid_598253
  var valid_598254 = query.getOrDefault("$.xgafv")
  valid_598254 = validateParameter(valid_598254, JString, required = false,
                                 default = newJString("1"))
  if valid_598254 != nil:
    section.add "$.xgafv", valid_598254
  var valid_598255 = query.getOrDefault("prettyPrint")
  valid_598255 = validateParameter(valid_598255, JBool, required = false,
                                 default = newJBool(true))
  if valid_598255 != nil:
    section.add "prettyPrint", valid_598255
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

proc call*(call_598257: Call_CloudsearchIndexingDatasourcesItemsIndex_598241;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates Item ACL, metadata, and
  ## content. It will insert the Item if it
  ## does not exist.
  ## This method does not support partial updates.  Fields with no provided
  ## values are cleared out in the Cloud Search index.
  ## 
  let valid = call_598257.validator(path, query, header, formData, body)
  let scheme = call_598257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598257.url(scheme.get, call_598257.host, call_598257.base,
                         call_598257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598257, url, valid)

proc call*(call_598258: Call_CloudsearchIndexingDatasourcesItemsIndex_598241;
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
  var path_598259 = newJObject()
  var query_598260 = newJObject()
  var body_598261 = newJObject()
  add(query_598260, "upload_protocol", newJString(uploadProtocol))
  add(query_598260, "fields", newJString(fields))
  add(query_598260, "quotaUser", newJString(quotaUser))
  add(path_598259, "name", newJString(name))
  add(query_598260, "alt", newJString(alt))
  add(query_598260, "oauth_token", newJString(oauthToken))
  add(query_598260, "callback", newJString(callback))
  add(query_598260, "access_token", newJString(accessToken))
  add(query_598260, "uploadType", newJString(uploadType))
  add(query_598260, "key", newJString(key))
  add(query_598260, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598261 = body
  add(query_598260, "prettyPrint", newJBool(prettyPrint))
  result = call_598258.call(path_598259, query_598260, nil, nil, body_598261)

var cloudsearchIndexingDatasourcesItemsIndex* = Call_CloudsearchIndexingDatasourcesItemsIndex_598241(
    name: "cloudsearchIndexingDatasourcesItemsIndex", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}:index",
    validator: validate_CloudsearchIndexingDatasourcesItemsIndex_598242,
    base: "/", url: url_CloudsearchIndexingDatasourcesItemsIndex_598243,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsPush_598262 = ref object of OpenApiRestCall_597421
proc url_CloudsearchIndexingDatasourcesItemsPush_598264(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudsearchIndexingDatasourcesItemsPush_598263(path: JsonNode;
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
  var valid_598265 = path.getOrDefault("name")
  valid_598265 = validateParameter(valid_598265, JString, required = true,
                                 default = nil)
  if valid_598265 != nil:
    section.add "name", valid_598265
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
  var valid_598266 = query.getOrDefault("upload_protocol")
  valid_598266 = validateParameter(valid_598266, JString, required = false,
                                 default = nil)
  if valid_598266 != nil:
    section.add "upload_protocol", valid_598266
  var valid_598267 = query.getOrDefault("fields")
  valid_598267 = validateParameter(valid_598267, JString, required = false,
                                 default = nil)
  if valid_598267 != nil:
    section.add "fields", valid_598267
  var valid_598268 = query.getOrDefault("quotaUser")
  valid_598268 = validateParameter(valid_598268, JString, required = false,
                                 default = nil)
  if valid_598268 != nil:
    section.add "quotaUser", valid_598268
  var valid_598269 = query.getOrDefault("alt")
  valid_598269 = validateParameter(valid_598269, JString, required = false,
                                 default = newJString("json"))
  if valid_598269 != nil:
    section.add "alt", valid_598269
  var valid_598270 = query.getOrDefault("oauth_token")
  valid_598270 = validateParameter(valid_598270, JString, required = false,
                                 default = nil)
  if valid_598270 != nil:
    section.add "oauth_token", valid_598270
  var valid_598271 = query.getOrDefault("callback")
  valid_598271 = validateParameter(valid_598271, JString, required = false,
                                 default = nil)
  if valid_598271 != nil:
    section.add "callback", valid_598271
  var valid_598272 = query.getOrDefault("access_token")
  valid_598272 = validateParameter(valid_598272, JString, required = false,
                                 default = nil)
  if valid_598272 != nil:
    section.add "access_token", valid_598272
  var valid_598273 = query.getOrDefault("uploadType")
  valid_598273 = validateParameter(valid_598273, JString, required = false,
                                 default = nil)
  if valid_598273 != nil:
    section.add "uploadType", valid_598273
  var valid_598274 = query.getOrDefault("key")
  valid_598274 = validateParameter(valid_598274, JString, required = false,
                                 default = nil)
  if valid_598274 != nil:
    section.add "key", valid_598274
  var valid_598275 = query.getOrDefault("$.xgafv")
  valid_598275 = validateParameter(valid_598275, JString, required = false,
                                 default = newJString("1"))
  if valid_598275 != nil:
    section.add "$.xgafv", valid_598275
  var valid_598276 = query.getOrDefault("prettyPrint")
  valid_598276 = validateParameter(valid_598276, JBool, required = false,
                                 default = newJBool(true))
  if valid_598276 != nil:
    section.add "prettyPrint", valid_598276
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

proc call*(call_598278: Call_CloudsearchIndexingDatasourcesItemsPush_598262;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Pushes an item onto a queue for later polling and updating.
  ## 
  let valid = call_598278.validator(path, query, header, formData, body)
  let scheme = call_598278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598278.url(scheme.get, call_598278.host, call_598278.base,
                         call_598278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598278, url, valid)

proc call*(call_598279: Call_CloudsearchIndexingDatasourcesItemsPush_598262;
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
  var path_598280 = newJObject()
  var query_598281 = newJObject()
  var body_598282 = newJObject()
  add(query_598281, "upload_protocol", newJString(uploadProtocol))
  add(query_598281, "fields", newJString(fields))
  add(query_598281, "quotaUser", newJString(quotaUser))
  add(path_598280, "name", newJString(name))
  add(query_598281, "alt", newJString(alt))
  add(query_598281, "oauth_token", newJString(oauthToken))
  add(query_598281, "callback", newJString(callback))
  add(query_598281, "access_token", newJString(accessToken))
  add(query_598281, "uploadType", newJString(uploadType))
  add(query_598281, "key", newJString(key))
  add(query_598281, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598282 = body
  add(query_598281, "prettyPrint", newJBool(prettyPrint))
  result = call_598279.call(path_598280, query_598281, nil, nil, body_598282)

var cloudsearchIndexingDatasourcesItemsPush* = Call_CloudsearchIndexingDatasourcesItemsPush_598262(
    name: "cloudsearchIndexingDatasourcesItemsPush", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}:push",
    validator: validate_CloudsearchIndexingDatasourcesItemsPush_598263, base: "/",
    url: url_CloudsearchIndexingDatasourcesItemsPush_598264,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsUpload_598283 = ref object of OpenApiRestCall_597421
proc url_CloudsearchIndexingDatasourcesItemsUpload_598285(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudsearchIndexingDatasourcesItemsUpload_598284(path: JsonNode;
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
  var valid_598286 = path.getOrDefault("name")
  valid_598286 = validateParameter(valid_598286, JString, required = true,
                                 default = nil)
  if valid_598286 != nil:
    section.add "name", valid_598286
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
  var valid_598287 = query.getOrDefault("upload_protocol")
  valid_598287 = validateParameter(valid_598287, JString, required = false,
                                 default = nil)
  if valid_598287 != nil:
    section.add "upload_protocol", valid_598287
  var valid_598288 = query.getOrDefault("fields")
  valid_598288 = validateParameter(valid_598288, JString, required = false,
                                 default = nil)
  if valid_598288 != nil:
    section.add "fields", valid_598288
  var valid_598289 = query.getOrDefault("quotaUser")
  valid_598289 = validateParameter(valid_598289, JString, required = false,
                                 default = nil)
  if valid_598289 != nil:
    section.add "quotaUser", valid_598289
  var valid_598290 = query.getOrDefault("alt")
  valid_598290 = validateParameter(valid_598290, JString, required = false,
                                 default = newJString("json"))
  if valid_598290 != nil:
    section.add "alt", valid_598290
  var valid_598291 = query.getOrDefault("oauth_token")
  valid_598291 = validateParameter(valid_598291, JString, required = false,
                                 default = nil)
  if valid_598291 != nil:
    section.add "oauth_token", valid_598291
  var valid_598292 = query.getOrDefault("callback")
  valid_598292 = validateParameter(valid_598292, JString, required = false,
                                 default = nil)
  if valid_598292 != nil:
    section.add "callback", valid_598292
  var valid_598293 = query.getOrDefault("access_token")
  valid_598293 = validateParameter(valid_598293, JString, required = false,
                                 default = nil)
  if valid_598293 != nil:
    section.add "access_token", valid_598293
  var valid_598294 = query.getOrDefault("uploadType")
  valid_598294 = validateParameter(valid_598294, JString, required = false,
                                 default = nil)
  if valid_598294 != nil:
    section.add "uploadType", valid_598294
  var valid_598295 = query.getOrDefault("key")
  valid_598295 = validateParameter(valid_598295, JString, required = false,
                                 default = nil)
  if valid_598295 != nil:
    section.add "key", valid_598295
  var valid_598296 = query.getOrDefault("$.xgafv")
  valid_598296 = validateParameter(valid_598296, JString, required = false,
                                 default = newJString("1"))
  if valid_598296 != nil:
    section.add "$.xgafv", valid_598296
  var valid_598297 = query.getOrDefault("prettyPrint")
  valid_598297 = validateParameter(valid_598297, JBool, required = false,
                                 default = newJBool(true))
  if valid_598297 != nil:
    section.add "prettyPrint", valid_598297
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

proc call*(call_598299: Call_CloudsearchIndexingDatasourcesItemsUpload_598283;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an upload session for uploading item content. For items smaller
  ## than 100 KB, it's easier to embed the content
  ## inline within
  ## an index request.
  ## 
  let valid = call_598299.validator(path, query, header, formData, body)
  let scheme = call_598299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598299.url(scheme.get, call_598299.host, call_598299.base,
                         call_598299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598299, url, valid)

proc call*(call_598300: Call_CloudsearchIndexingDatasourcesItemsUpload_598283;
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
  var path_598301 = newJObject()
  var query_598302 = newJObject()
  var body_598303 = newJObject()
  add(query_598302, "upload_protocol", newJString(uploadProtocol))
  add(query_598302, "fields", newJString(fields))
  add(query_598302, "quotaUser", newJString(quotaUser))
  add(path_598301, "name", newJString(name))
  add(query_598302, "alt", newJString(alt))
  add(query_598302, "oauth_token", newJString(oauthToken))
  add(query_598302, "callback", newJString(callback))
  add(query_598302, "access_token", newJString(accessToken))
  add(query_598302, "uploadType", newJString(uploadType))
  add(query_598302, "key", newJString(key))
  add(query_598302, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598303 = body
  add(query_598302, "prettyPrint", newJBool(prettyPrint))
  result = call_598300.call(path_598301, query_598302, nil, nil, body_598303)

var cloudsearchIndexingDatasourcesItemsUpload* = Call_CloudsearchIndexingDatasourcesItemsUpload_598283(
    name: "cloudsearchIndexingDatasourcesItemsUpload", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}:upload",
    validator: validate_CloudsearchIndexingDatasourcesItemsUpload_598284,
    base: "/", url: url_CloudsearchIndexingDatasourcesItemsUpload_598285,
    schemes: {Scheme.Https})
type
  Call_CloudsearchMediaUpload_598304 = ref object of OpenApiRestCall_597421
proc url_CloudsearchMediaUpload_598306(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/media/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudsearchMediaUpload_598305(path: JsonNode; query: JsonNode;
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
  var valid_598307 = path.getOrDefault("resourceName")
  valid_598307 = validateParameter(valid_598307, JString, required = true,
                                 default = nil)
  if valid_598307 != nil:
    section.add "resourceName", valid_598307
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
  var valid_598308 = query.getOrDefault("upload_protocol")
  valid_598308 = validateParameter(valid_598308, JString, required = false,
                                 default = nil)
  if valid_598308 != nil:
    section.add "upload_protocol", valid_598308
  var valid_598309 = query.getOrDefault("fields")
  valid_598309 = validateParameter(valid_598309, JString, required = false,
                                 default = nil)
  if valid_598309 != nil:
    section.add "fields", valid_598309
  var valid_598310 = query.getOrDefault("quotaUser")
  valid_598310 = validateParameter(valid_598310, JString, required = false,
                                 default = nil)
  if valid_598310 != nil:
    section.add "quotaUser", valid_598310
  var valid_598311 = query.getOrDefault("alt")
  valid_598311 = validateParameter(valid_598311, JString, required = false,
                                 default = newJString("json"))
  if valid_598311 != nil:
    section.add "alt", valid_598311
  var valid_598312 = query.getOrDefault("oauth_token")
  valid_598312 = validateParameter(valid_598312, JString, required = false,
                                 default = nil)
  if valid_598312 != nil:
    section.add "oauth_token", valid_598312
  var valid_598313 = query.getOrDefault("callback")
  valid_598313 = validateParameter(valid_598313, JString, required = false,
                                 default = nil)
  if valid_598313 != nil:
    section.add "callback", valid_598313
  var valid_598314 = query.getOrDefault("access_token")
  valid_598314 = validateParameter(valid_598314, JString, required = false,
                                 default = nil)
  if valid_598314 != nil:
    section.add "access_token", valid_598314
  var valid_598315 = query.getOrDefault("uploadType")
  valid_598315 = validateParameter(valid_598315, JString, required = false,
                                 default = nil)
  if valid_598315 != nil:
    section.add "uploadType", valid_598315
  var valid_598316 = query.getOrDefault("key")
  valid_598316 = validateParameter(valid_598316, JString, required = false,
                                 default = nil)
  if valid_598316 != nil:
    section.add "key", valid_598316
  var valid_598317 = query.getOrDefault("$.xgafv")
  valid_598317 = validateParameter(valid_598317, JString, required = false,
                                 default = newJString("1"))
  if valid_598317 != nil:
    section.add "$.xgafv", valid_598317
  var valid_598318 = query.getOrDefault("prettyPrint")
  valid_598318 = validateParameter(valid_598318, JBool, required = false,
                                 default = newJBool(true))
  if valid_598318 != nil:
    section.add "prettyPrint", valid_598318
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

proc call*(call_598320: Call_CloudsearchMediaUpload_598304; path: JsonNode;
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
  let valid = call_598320.validator(path, query, header, formData, body)
  let scheme = call_598320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598320.url(scheme.get, call_598320.host, call_598320.base,
                         call_598320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598320, url, valid)

proc call*(call_598321: Call_CloudsearchMediaUpload_598304; resourceName: string;
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
  var path_598322 = newJObject()
  var query_598323 = newJObject()
  var body_598324 = newJObject()
  add(query_598323, "upload_protocol", newJString(uploadProtocol))
  add(query_598323, "fields", newJString(fields))
  add(query_598323, "quotaUser", newJString(quotaUser))
  add(query_598323, "alt", newJString(alt))
  add(query_598323, "oauth_token", newJString(oauthToken))
  add(query_598323, "callback", newJString(callback))
  add(query_598323, "access_token", newJString(accessToken))
  add(query_598323, "uploadType", newJString(uploadType))
  add(path_598322, "resourceName", newJString(resourceName))
  add(query_598323, "key", newJString(key))
  add(query_598323, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598324 = body
  add(query_598323, "prettyPrint", newJBool(prettyPrint))
  result = call_598321.call(path_598322, query_598323, nil, nil, body_598324)

var cloudsearchMediaUpload* = Call_CloudsearchMediaUpload_598304(
    name: "cloudsearchMediaUpload", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/media/{resourceName}",
    validator: validate_CloudsearchMediaUpload_598305, base: "/",
    url: url_CloudsearchMediaUpload_598306, schemes: {Scheme.Https})
type
  Call_CloudsearchQuerySearch_598325 = ref object of OpenApiRestCall_597421
proc url_CloudsearchQuerySearch_598327(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudsearchQuerySearch_598326(path: JsonNode; query: JsonNode;
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
  var valid_598328 = query.getOrDefault("upload_protocol")
  valid_598328 = validateParameter(valid_598328, JString, required = false,
                                 default = nil)
  if valid_598328 != nil:
    section.add "upload_protocol", valid_598328
  var valid_598329 = query.getOrDefault("fields")
  valid_598329 = validateParameter(valid_598329, JString, required = false,
                                 default = nil)
  if valid_598329 != nil:
    section.add "fields", valid_598329
  var valid_598330 = query.getOrDefault("quotaUser")
  valid_598330 = validateParameter(valid_598330, JString, required = false,
                                 default = nil)
  if valid_598330 != nil:
    section.add "quotaUser", valid_598330
  var valid_598331 = query.getOrDefault("alt")
  valid_598331 = validateParameter(valid_598331, JString, required = false,
                                 default = newJString("json"))
  if valid_598331 != nil:
    section.add "alt", valid_598331
  var valid_598332 = query.getOrDefault("oauth_token")
  valid_598332 = validateParameter(valid_598332, JString, required = false,
                                 default = nil)
  if valid_598332 != nil:
    section.add "oauth_token", valid_598332
  var valid_598333 = query.getOrDefault("callback")
  valid_598333 = validateParameter(valid_598333, JString, required = false,
                                 default = nil)
  if valid_598333 != nil:
    section.add "callback", valid_598333
  var valid_598334 = query.getOrDefault("access_token")
  valid_598334 = validateParameter(valid_598334, JString, required = false,
                                 default = nil)
  if valid_598334 != nil:
    section.add "access_token", valid_598334
  var valid_598335 = query.getOrDefault("uploadType")
  valid_598335 = validateParameter(valid_598335, JString, required = false,
                                 default = nil)
  if valid_598335 != nil:
    section.add "uploadType", valid_598335
  var valid_598336 = query.getOrDefault("key")
  valid_598336 = validateParameter(valid_598336, JString, required = false,
                                 default = nil)
  if valid_598336 != nil:
    section.add "key", valid_598336
  var valid_598337 = query.getOrDefault("$.xgafv")
  valid_598337 = validateParameter(valid_598337, JString, required = false,
                                 default = newJString("1"))
  if valid_598337 != nil:
    section.add "$.xgafv", valid_598337
  var valid_598338 = query.getOrDefault("prettyPrint")
  valid_598338 = validateParameter(valid_598338, JBool, required = false,
                                 default = newJBool(true))
  if valid_598338 != nil:
    section.add "prettyPrint", valid_598338
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

proc call*(call_598340: Call_CloudsearchQuerySearch_598325; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Cloud Search Query API provides the search method, which returns
  ## the most relevant results from a user query.  The results can come from
  ## G Suite Apps, such as Gmail or Google Drive, or they can come from data
  ## that you have indexed from a third party.
  ## 
  let valid = call_598340.validator(path, query, header, formData, body)
  let scheme = call_598340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598340.url(scheme.get, call_598340.host, call_598340.base,
                         call_598340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598340, url, valid)

proc call*(call_598341: Call_CloudsearchQuerySearch_598325;
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
  var query_598342 = newJObject()
  var body_598343 = newJObject()
  add(query_598342, "upload_protocol", newJString(uploadProtocol))
  add(query_598342, "fields", newJString(fields))
  add(query_598342, "quotaUser", newJString(quotaUser))
  add(query_598342, "alt", newJString(alt))
  add(query_598342, "oauth_token", newJString(oauthToken))
  add(query_598342, "callback", newJString(callback))
  add(query_598342, "access_token", newJString(accessToken))
  add(query_598342, "uploadType", newJString(uploadType))
  add(query_598342, "key", newJString(key))
  add(query_598342, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598343 = body
  add(query_598342, "prettyPrint", newJBool(prettyPrint))
  result = call_598341.call(nil, query_598342, nil, nil, body_598343)

var cloudsearchQuerySearch* = Call_CloudsearchQuerySearch_598325(
    name: "cloudsearchQuerySearch", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/query/search",
    validator: validate_CloudsearchQuerySearch_598326, base: "/",
    url: url_CloudsearchQuerySearch_598327, schemes: {Scheme.Https})
type
  Call_CloudsearchQuerySourcesList_598344 = ref object of OpenApiRestCall_597421
proc url_CloudsearchQuerySourcesList_598346(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudsearchQuerySourcesList_598345(path: JsonNode; query: JsonNode;
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
  var valid_598347 = query.getOrDefault("upload_protocol")
  valid_598347 = validateParameter(valid_598347, JString, required = false,
                                 default = nil)
  if valid_598347 != nil:
    section.add "upload_protocol", valid_598347
  var valid_598348 = query.getOrDefault("fields")
  valid_598348 = validateParameter(valid_598348, JString, required = false,
                                 default = nil)
  if valid_598348 != nil:
    section.add "fields", valid_598348
  var valid_598349 = query.getOrDefault("pageToken")
  valid_598349 = validateParameter(valid_598349, JString, required = false,
                                 default = nil)
  if valid_598349 != nil:
    section.add "pageToken", valid_598349
  var valid_598350 = query.getOrDefault("quotaUser")
  valid_598350 = validateParameter(valid_598350, JString, required = false,
                                 default = nil)
  if valid_598350 != nil:
    section.add "quotaUser", valid_598350
  var valid_598351 = query.getOrDefault("alt")
  valid_598351 = validateParameter(valid_598351, JString, required = false,
                                 default = newJString("json"))
  if valid_598351 != nil:
    section.add "alt", valid_598351
  var valid_598352 = query.getOrDefault("requestOptions.searchApplicationId")
  valid_598352 = validateParameter(valid_598352, JString, required = false,
                                 default = nil)
  if valid_598352 != nil:
    section.add "requestOptions.searchApplicationId", valid_598352
  var valid_598353 = query.getOrDefault("oauth_token")
  valid_598353 = validateParameter(valid_598353, JString, required = false,
                                 default = nil)
  if valid_598353 != nil:
    section.add "oauth_token", valid_598353
  var valid_598354 = query.getOrDefault("callback")
  valid_598354 = validateParameter(valid_598354, JString, required = false,
                                 default = nil)
  if valid_598354 != nil:
    section.add "callback", valid_598354
  var valid_598355 = query.getOrDefault("access_token")
  valid_598355 = validateParameter(valid_598355, JString, required = false,
                                 default = nil)
  if valid_598355 != nil:
    section.add "access_token", valid_598355
  var valid_598356 = query.getOrDefault("uploadType")
  valid_598356 = validateParameter(valid_598356, JString, required = false,
                                 default = nil)
  if valid_598356 != nil:
    section.add "uploadType", valid_598356
  var valid_598357 = query.getOrDefault("requestOptions.languageCode")
  valid_598357 = validateParameter(valid_598357, JString, required = false,
                                 default = nil)
  if valid_598357 != nil:
    section.add "requestOptions.languageCode", valid_598357
  var valid_598358 = query.getOrDefault("key")
  valid_598358 = validateParameter(valid_598358, JString, required = false,
                                 default = nil)
  if valid_598358 != nil:
    section.add "key", valid_598358
  var valid_598359 = query.getOrDefault("requestOptions.debugOptions.enableDebugging")
  valid_598359 = validateParameter(valid_598359, JBool, required = false, default = nil)
  if valid_598359 != nil:
    section.add "requestOptions.debugOptions.enableDebugging", valid_598359
  var valid_598360 = query.getOrDefault("$.xgafv")
  valid_598360 = validateParameter(valid_598360, JString, required = false,
                                 default = newJString("1"))
  if valid_598360 != nil:
    section.add "$.xgafv", valid_598360
  var valid_598361 = query.getOrDefault("requestOptions.timeZone")
  valid_598361 = validateParameter(valid_598361, JString, required = false,
                                 default = nil)
  if valid_598361 != nil:
    section.add "requestOptions.timeZone", valid_598361
  var valid_598362 = query.getOrDefault("prettyPrint")
  valid_598362 = validateParameter(valid_598362, JBool, required = false,
                                 default = newJBool(true))
  if valid_598362 != nil:
    section.add "prettyPrint", valid_598362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598363: Call_CloudsearchQuerySourcesList_598344; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns list of sources that user can use for Search and Suggest APIs.
  ## 
  let valid = call_598363.validator(path, query, header, formData, body)
  let scheme = call_598363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598363.url(scheme.get, call_598363.host, call_598363.base,
                         call_598363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598363, url, valid)

proc call*(call_598364: Call_CloudsearchQuerySourcesList_598344;
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
  var query_598365 = newJObject()
  add(query_598365, "upload_protocol", newJString(uploadProtocol))
  add(query_598365, "fields", newJString(fields))
  add(query_598365, "pageToken", newJString(pageToken))
  add(query_598365, "quotaUser", newJString(quotaUser))
  add(query_598365, "alt", newJString(alt))
  add(query_598365, "requestOptions.searchApplicationId",
      newJString(requestOptionsSearchApplicationId))
  add(query_598365, "oauth_token", newJString(oauthToken))
  add(query_598365, "callback", newJString(callback))
  add(query_598365, "access_token", newJString(accessToken))
  add(query_598365, "uploadType", newJString(uploadType))
  add(query_598365, "requestOptions.languageCode",
      newJString(requestOptionsLanguageCode))
  add(query_598365, "key", newJString(key))
  add(query_598365, "requestOptions.debugOptions.enableDebugging",
      newJBool(requestOptionsDebugOptionsEnableDebugging))
  add(query_598365, "$.xgafv", newJString(Xgafv))
  add(query_598365, "requestOptions.timeZone", newJString(requestOptionsTimeZone))
  add(query_598365, "prettyPrint", newJBool(prettyPrint))
  result = call_598364.call(nil, query_598365, nil, nil, nil)

var cloudsearchQuerySourcesList* = Call_CloudsearchQuerySourcesList_598344(
    name: "cloudsearchQuerySourcesList", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/query/sources",
    validator: validate_CloudsearchQuerySourcesList_598345, base: "/",
    url: url_CloudsearchQuerySourcesList_598346, schemes: {Scheme.Https})
type
  Call_CloudsearchQuerySuggest_598366 = ref object of OpenApiRestCall_597421
proc url_CloudsearchQuerySuggest_598368(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudsearchQuerySuggest_598367(path: JsonNode; query: JsonNode;
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
  var valid_598369 = query.getOrDefault("upload_protocol")
  valid_598369 = validateParameter(valid_598369, JString, required = false,
                                 default = nil)
  if valid_598369 != nil:
    section.add "upload_protocol", valid_598369
  var valid_598370 = query.getOrDefault("fields")
  valid_598370 = validateParameter(valid_598370, JString, required = false,
                                 default = nil)
  if valid_598370 != nil:
    section.add "fields", valid_598370
  var valid_598371 = query.getOrDefault("quotaUser")
  valid_598371 = validateParameter(valid_598371, JString, required = false,
                                 default = nil)
  if valid_598371 != nil:
    section.add "quotaUser", valid_598371
  var valid_598372 = query.getOrDefault("alt")
  valid_598372 = validateParameter(valid_598372, JString, required = false,
                                 default = newJString("json"))
  if valid_598372 != nil:
    section.add "alt", valid_598372
  var valid_598373 = query.getOrDefault("oauth_token")
  valid_598373 = validateParameter(valid_598373, JString, required = false,
                                 default = nil)
  if valid_598373 != nil:
    section.add "oauth_token", valid_598373
  var valid_598374 = query.getOrDefault("callback")
  valid_598374 = validateParameter(valid_598374, JString, required = false,
                                 default = nil)
  if valid_598374 != nil:
    section.add "callback", valid_598374
  var valid_598375 = query.getOrDefault("access_token")
  valid_598375 = validateParameter(valid_598375, JString, required = false,
                                 default = nil)
  if valid_598375 != nil:
    section.add "access_token", valid_598375
  var valid_598376 = query.getOrDefault("uploadType")
  valid_598376 = validateParameter(valid_598376, JString, required = false,
                                 default = nil)
  if valid_598376 != nil:
    section.add "uploadType", valid_598376
  var valid_598377 = query.getOrDefault("key")
  valid_598377 = validateParameter(valid_598377, JString, required = false,
                                 default = nil)
  if valid_598377 != nil:
    section.add "key", valid_598377
  var valid_598378 = query.getOrDefault("$.xgafv")
  valid_598378 = validateParameter(valid_598378, JString, required = false,
                                 default = newJString("1"))
  if valid_598378 != nil:
    section.add "$.xgafv", valid_598378
  var valid_598379 = query.getOrDefault("prettyPrint")
  valid_598379 = validateParameter(valid_598379, JBool, required = false,
                                 default = newJBool(true))
  if valid_598379 != nil:
    section.add "prettyPrint", valid_598379
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

proc call*(call_598381: Call_CloudsearchQuerySuggest_598366; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides suggestions for autocompleting the query.
  ## 
  let valid = call_598381.validator(path, query, header, formData, body)
  let scheme = call_598381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598381.url(scheme.get, call_598381.host, call_598381.base,
                         call_598381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598381, url, valid)

proc call*(call_598382: Call_CloudsearchQuerySuggest_598366;
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
  var query_598383 = newJObject()
  var body_598384 = newJObject()
  add(query_598383, "upload_protocol", newJString(uploadProtocol))
  add(query_598383, "fields", newJString(fields))
  add(query_598383, "quotaUser", newJString(quotaUser))
  add(query_598383, "alt", newJString(alt))
  add(query_598383, "oauth_token", newJString(oauthToken))
  add(query_598383, "callback", newJString(callback))
  add(query_598383, "access_token", newJString(accessToken))
  add(query_598383, "uploadType", newJString(uploadType))
  add(query_598383, "key", newJString(key))
  add(query_598383, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598384 = body
  add(query_598383, "prettyPrint", newJBool(prettyPrint))
  result = call_598382.call(nil, query_598383, nil, nil, body_598384)

var cloudsearchQuerySuggest* = Call_CloudsearchQuerySuggest_598366(
    name: "cloudsearchQuerySuggest", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/query/suggest",
    validator: validate_CloudsearchQuerySuggest_598367, base: "/",
    url: url_CloudsearchQuerySuggest_598368, schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsDatasourcesCreate_598405 = ref object of OpenApiRestCall_597421
proc url_CloudsearchSettingsDatasourcesCreate_598407(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudsearchSettingsDatasourcesCreate_598406(path: JsonNode;
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
  var valid_598408 = query.getOrDefault("upload_protocol")
  valid_598408 = validateParameter(valid_598408, JString, required = false,
                                 default = nil)
  if valid_598408 != nil:
    section.add "upload_protocol", valid_598408
  var valid_598409 = query.getOrDefault("fields")
  valid_598409 = validateParameter(valid_598409, JString, required = false,
                                 default = nil)
  if valid_598409 != nil:
    section.add "fields", valid_598409
  var valid_598410 = query.getOrDefault("quotaUser")
  valid_598410 = validateParameter(valid_598410, JString, required = false,
                                 default = nil)
  if valid_598410 != nil:
    section.add "quotaUser", valid_598410
  var valid_598411 = query.getOrDefault("alt")
  valid_598411 = validateParameter(valid_598411, JString, required = false,
                                 default = newJString("json"))
  if valid_598411 != nil:
    section.add "alt", valid_598411
  var valid_598412 = query.getOrDefault("oauth_token")
  valid_598412 = validateParameter(valid_598412, JString, required = false,
                                 default = nil)
  if valid_598412 != nil:
    section.add "oauth_token", valid_598412
  var valid_598413 = query.getOrDefault("callback")
  valid_598413 = validateParameter(valid_598413, JString, required = false,
                                 default = nil)
  if valid_598413 != nil:
    section.add "callback", valid_598413
  var valid_598414 = query.getOrDefault("access_token")
  valid_598414 = validateParameter(valid_598414, JString, required = false,
                                 default = nil)
  if valid_598414 != nil:
    section.add "access_token", valid_598414
  var valid_598415 = query.getOrDefault("uploadType")
  valid_598415 = validateParameter(valid_598415, JString, required = false,
                                 default = nil)
  if valid_598415 != nil:
    section.add "uploadType", valid_598415
  var valid_598416 = query.getOrDefault("key")
  valid_598416 = validateParameter(valid_598416, JString, required = false,
                                 default = nil)
  if valid_598416 != nil:
    section.add "key", valid_598416
  var valid_598417 = query.getOrDefault("$.xgafv")
  valid_598417 = validateParameter(valid_598417, JString, required = false,
                                 default = newJString("1"))
  if valid_598417 != nil:
    section.add "$.xgafv", valid_598417
  var valid_598418 = query.getOrDefault("prettyPrint")
  valid_598418 = validateParameter(valid_598418, JBool, required = false,
                                 default = newJBool(true))
  if valid_598418 != nil:
    section.add "prettyPrint", valid_598418
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

proc call*(call_598420: Call_CloudsearchSettingsDatasourcesCreate_598405;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a datasource.
  ## 
  let valid = call_598420.validator(path, query, header, formData, body)
  let scheme = call_598420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598420.url(scheme.get, call_598420.host, call_598420.base,
                         call_598420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598420, url, valid)

proc call*(call_598421: Call_CloudsearchSettingsDatasourcesCreate_598405;
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
  var query_598422 = newJObject()
  var body_598423 = newJObject()
  add(query_598422, "upload_protocol", newJString(uploadProtocol))
  add(query_598422, "fields", newJString(fields))
  add(query_598422, "quotaUser", newJString(quotaUser))
  add(query_598422, "alt", newJString(alt))
  add(query_598422, "oauth_token", newJString(oauthToken))
  add(query_598422, "callback", newJString(callback))
  add(query_598422, "access_token", newJString(accessToken))
  add(query_598422, "uploadType", newJString(uploadType))
  add(query_598422, "key", newJString(key))
  add(query_598422, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598423 = body
  add(query_598422, "prettyPrint", newJBool(prettyPrint))
  result = call_598421.call(nil, query_598422, nil, nil, body_598423)

var cloudsearchSettingsDatasourcesCreate* = Call_CloudsearchSettingsDatasourcesCreate_598405(
    name: "cloudsearchSettingsDatasourcesCreate", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/datasources",
    validator: validate_CloudsearchSettingsDatasourcesCreate_598406, base: "/",
    url: url_CloudsearchSettingsDatasourcesCreate_598407, schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsDatasourcesList_598385 = ref object of OpenApiRestCall_597421
proc url_CloudsearchSettingsDatasourcesList_598387(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudsearchSettingsDatasourcesList_598386(path: JsonNode;
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
  var valid_598388 = query.getOrDefault("upload_protocol")
  valid_598388 = validateParameter(valid_598388, JString, required = false,
                                 default = nil)
  if valid_598388 != nil:
    section.add "upload_protocol", valid_598388
  var valid_598389 = query.getOrDefault("fields")
  valid_598389 = validateParameter(valid_598389, JString, required = false,
                                 default = nil)
  if valid_598389 != nil:
    section.add "fields", valid_598389
  var valid_598390 = query.getOrDefault("pageToken")
  valid_598390 = validateParameter(valid_598390, JString, required = false,
                                 default = nil)
  if valid_598390 != nil:
    section.add "pageToken", valid_598390
  var valid_598391 = query.getOrDefault("quotaUser")
  valid_598391 = validateParameter(valid_598391, JString, required = false,
                                 default = nil)
  if valid_598391 != nil:
    section.add "quotaUser", valid_598391
  var valid_598392 = query.getOrDefault("alt")
  valid_598392 = validateParameter(valid_598392, JString, required = false,
                                 default = newJString("json"))
  if valid_598392 != nil:
    section.add "alt", valid_598392
  var valid_598393 = query.getOrDefault("oauth_token")
  valid_598393 = validateParameter(valid_598393, JString, required = false,
                                 default = nil)
  if valid_598393 != nil:
    section.add "oauth_token", valid_598393
  var valid_598394 = query.getOrDefault("callback")
  valid_598394 = validateParameter(valid_598394, JString, required = false,
                                 default = nil)
  if valid_598394 != nil:
    section.add "callback", valid_598394
  var valid_598395 = query.getOrDefault("access_token")
  valid_598395 = validateParameter(valid_598395, JString, required = false,
                                 default = nil)
  if valid_598395 != nil:
    section.add "access_token", valid_598395
  var valid_598396 = query.getOrDefault("uploadType")
  valid_598396 = validateParameter(valid_598396, JString, required = false,
                                 default = nil)
  if valid_598396 != nil:
    section.add "uploadType", valid_598396
  var valid_598397 = query.getOrDefault("key")
  valid_598397 = validateParameter(valid_598397, JString, required = false,
                                 default = nil)
  if valid_598397 != nil:
    section.add "key", valid_598397
  var valid_598398 = query.getOrDefault("debugOptions.enableDebugging")
  valid_598398 = validateParameter(valid_598398, JBool, required = false, default = nil)
  if valid_598398 != nil:
    section.add "debugOptions.enableDebugging", valid_598398
  var valid_598399 = query.getOrDefault("$.xgafv")
  valid_598399 = validateParameter(valid_598399, JString, required = false,
                                 default = newJString("1"))
  if valid_598399 != nil:
    section.add "$.xgafv", valid_598399
  var valid_598400 = query.getOrDefault("pageSize")
  valid_598400 = validateParameter(valid_598400, JInt, required = false, default = nil)
  if valid_598400 != nil:
    section.add "pageSize", valid_598400
  var valid_598401 = query.getOrDefault("prettyPrint")
  valid_598401 = validateParameter(valid_598401, JBool, required = false,
                                 default = newJBool(true))
  if valid_598401 != nil:
    section.add "prettyPrint", valid_598401
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598402: Call_CloudsearchSettingsDatasourcesList_598385;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists datasources.
  ## 
  let valid = call_598402.validator(path, query, header, formData, body)
  let scheme = call_598402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598402.url(scheme.get, call_598402.host, call_598402.base,
                         call_598402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598402, url, valid)

proc call*(call_598403: Call_CloudsearchSettingsDatasourcesList_598385;
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
  var query_598404 = newJObject()
  add(query_598404, "upload_protocol", newJString(uploadProtocol))
  add(query_598404, "fields", newJString(fields))
  add(query_598404, "pageToken", newJString(pageToken))
  add(query_598404, "quotaUser", newJString(quotaUser))
  add(query_598404, "alt", newJString(alt))
  add(query_598404, "oauth_token", newJString(oauthToken))
  add(query_598404, "callback", newJString(callback))
  add(query_598404, "access_token", newJString(accessToken))
  add(query_598404, "uploadType", newJString(uploadType))
  add(query_598404, "key", newJString(key))
  add(query_598404, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_598404, "$.xgafv", newJString(Xgafv))
  add(query_598404, "pageSize", newJInt(pageSize))
  add(query_598404, "prettyPrint", newJBool(prettyPrint))
  result = call_598403.call(nil, query_598404, nil, nil, nil)

var cloudsearchSettingsDatasourcesList* = Call_CloudsearchSettingsDatasourcesList_598385(
    name: "cloudsearchSettingsDatasourcesList", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/datasources",
    validator: validate_CloudsearchSettingsDatasourcesList_598386, base: "/",
    url: url_CloudsearchSettingsDatasourcesList_598387, schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsSearchapplicationsCreate_598444 = ref object of OpenApiRestCall_597421
proc url_CloudsearchSettingsSearchapplicationsCreate_598446(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudsearchSettingsSearchapplicationsCreate_598445(path: JsonNode;
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
  var valid_598447 = query.getOrDefault("upload_protocol")
  valid_598447 = validateParameter(valid_598447, JString, required = false,
                                 default = nil)
  if valid_598447 != nil:
    section.add "upload_protocol", valid_598447
  var valid_598448 = query.getOrDefault("fields")
  valid_598448 = validateParameter(valid_598448, JString, required = false,
                                 default = nil)
  if valid_598448 != nil:
    section.add "fields", valid_598448
  var valid_598449 = query.getOrDefault("quotaUser")
  valid_598449 = validateParameter(valid_598449, JString, required = false,
                                 default = nil)
  if valid_598449 != nil:
    section.add "quotaUser", valid_598449
  var valid_598450 = query.getOrDefault("alt")
  valid_598450 = validateParameter(valid_598450, JString, required = false,
                                 default = newJString("json"))
  if valid_598450 != nil:
    section.add "alt", valid_598450
  var valid_598451 = query.getOrDefault("oauth_token")
  valid_598451 = validateParameter(valid_598451, JString, required = false,
                                 default = nil)
  if valid_598451 != nil:
    section.add "oauth_token", valid_598451
  var valid_598452 = query.getOrDefault("callback")
  valid_598452 = validateParameter(valid_598452, JString, required = false,
                                 default = nil)
  if valid_598452 != nil:
    section.add "callback", valid_598452
  var valid_598453 = query.getOrDefault("access_token")
  valid_598453 = validateParameter(valid_598453, JString, required = false,
                                 default = nil)
  if valid_598453 != nil:
    section.add "access_token", valid_598453
  var valid_598454 = query.getOrDefault("uploadType")
  valid_598454 = validateParameter(valid_598454, JString, required = false,
                                 default = nil)
  if valid_598454 != nil:
    section.add "uploadType", valid_598454
  var valid_598455 = query.getOrDefault("key")
  valid_598455 = validateParameter(valid_598455, JString, required = false,
                                 default = nil)
  if valid_598455 != nil:
    section.add "key", valid_598455
  var valid_598456 = query.getOrDefault("$.xgafv")
  valid_598456 = validateParameter(valid_598456, JString, required = false,
                                 default = newJString("1"))
  if valid_598456 != nil:
    section.add "$.xgafv", valid_598456
  var valid_598457 = query.getOrDefault("prettyPrint")
  valid_598457 = validateParameter(valid_598457, JBool, required = false,
                                 default = newJBool(true))
  if valid_598457 != nil:
    section.add "prettyPrint", valid_598457
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

proc call*(call_598459: Call_CloudsearchSettingsSearchapplicationsCreate_598444;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a search application.
  ## 
  let valid = call_598459.validator(path, query, header, formData, body)
  let scheme = call_598459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598459.url(scheme.get, call_598459.host, call_598459.base,
                         call_598459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598459, url, valid)

proc call*(call_598460: Call_CloudsearchSettingsSearchapplicationsCreate_598444;
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
  var query_598461 = newJObject()
  var body_598462 = newJObject()
  add(query_598461, "upload_protocol", newJString(uploadProtocol))
  add(query_598461, "fields", newJString(fields))
  add(query_598461, "quotaUser", newJString(quotaUser))
  add(query_598461, "alt", newJString(alt))
  add(query_598461, "oauth_token", newJString(oauthToken))
  add(query_598461, "callback", newJString(callback))
  add(query_598461, "access_token", newJString(accessToken))
  add(query_598461, "uploadType", newJString(uploadType))
  add(query_598461, "key", newJString(key))
  add(query_598461, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598462 = body
  add(query_598461, "prettyPrint", newJBool(prettyPrint))
  result = call_598460.call(nil, query_598461, nil, nil, body_598462)

var cloudsearchSettingsSearchapplicationsCreate* = Call_CloudsearchSettingsSearchapplicationsCreate_598444(
    name: "cloudsearchSettingsSearchapplicationsCreate",
    meth: HttpMethod.HttpPost, host: "cloudsearch.googleapis.com",
    route: "/v1/settings/searchapplications",
    validator: validate_CloudsearchSettingsSearchapplicationsCreate_598445,
    base: "/", url: url_CloudsearchSettingsSearchapplicationsCreate_598446,
    schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsSearchapplicationsList_598424 = ref object of OpenApiRestCall_597421
proc url_CloudsearchSettingsSearchapplicationsList_598426(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudsearchSettingsSearchapplicationsList_598425(path: JsonNode;
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
  var valid_598427 = query.getOrDefault("upload_protocol")
  valid_598427 = validateParameter(valid_598427, JString, required = false,
                                 default = nil)
  if valid_598427 != nil:
    section.add "upload_protocol", valid_598427
  var valid_598428 = query.getOrDefault("fields")
  valid_598428 = validateParameter(valid_598428, JString, required = false,
                                 default = nil)
  if valid_598428 != nil:
    section.add "fields", valid_598428
  var valid_598429 = query.getOrDefault("pageToken")
  valid_598429 = validateParameter(valid_598429, JString, required = false,
                                 default = nil)
  if valid_598429 != nil:
    section.add "pageToken", valid_598429
  var valid_598430 = query.getOrDefault("quotaUser")
  valid_598430 = validateParameter(valid_598430, JString, required = false,
                                 default = nil)
  if valid_598430 != nil:
    section.add "quotaUser", valid_598430
  var valid_598431 = query.getOrDefault("alt")
  valid_598431 = validateParameter(valid_598431, JString, required = false,
                                 default = newJString("json"))
  if valid_598431 != nil:
    section.add "alt", valid_598431
  var valid_598432 = query.getOrDefault("oauth_token")
  valid_598432 = validateParameter(valid_598432, JString, required = false,
                                 default = nil)
  if valid_598432 != nil:
    section.add "oauth_token", valid_598432
  var valid_598433 = query.getOrDefault("callback")
  valid_598433 = validateParameter(valid_598433, JString, required = false,
                                 default = nil)
  if valid_598433 != nil:
    section.add "callback", valid_598433
  var valid_598434 = query.getOrDefault("access_token")
  valid_598434 = validateParameter(valid_598434, JString, required = false,
                                 default = nil)
  if valid_598434 != nil:
    section.add "access_token", valid_598434
  var valid_598435 = query.getOrDefault("uploadType")
  valid_598435 = validateParameter(valid_598435, JString, required = false,
                                 default = nil)
  if valid_598435 != nil:
    section.add "uploadType", valid_598435
  var valid_598436 = query.getOrDefault("key")
  valid_598436 = validateParameter(valid_598436, JString, required = false,
                                 default = nil)
  if valid_598436 != nil:
    section.add "key", valid_598436
  var valid_598437 = query.getOrDefault("debugOptions.enableDebugging")
  valid_598437 = validateParameter(valid_598437, JBool, required = false, default = nil)
  if valid_598437 != nil:
    section.add "debugOptions.enableDebugging", valid_598437
  var valid_598438 = query.getOrDefault("$.xgafv")
  valid_598438 = validateParameter(valid_598438, JString, required = false,
                                 default = newJString("1"))
  if valid_598438 != nil:
    section.add "$.xgafv", valid_598438
  var valid_598439 = query.getOrDefault("pageSize")
  valid_598439 = validateParameter(valid_598439, JInt, required = false, default = nil)
  if valid_598439 != nil:
    section.add "pageSize", valid_598439
  var valid_598440 = query.getOrDefault("prettyPrint")
  valid_598440 = validateParameter(valid_598440, JBool, required = false,
                                 default = newJBool(true))
  if valid_598440 != nil:
    section.add "prettyPrint", valid_598440
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598441: Call_CloudsearchSettingsSearchapplicationsList_598424;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all search applications.
  ## 
  let valid = call_598441.validator(path, query, header, formData, body)
  let scheme = call_598441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598441.url(scheme.get, call_598441.host, call_598441.base,
                         call_598441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598441, url, valid)

proc call*(call_598442: Call_CloudsearchSettingsSearchapplicationsList_598424;
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
  var query_598443 = newJObject()
  add(query_598443, "upload_protocol", newJString(uploadProtocol))
  add(query_598443, "fields", newJString(fields))
  add(query_598443, "pageToken", newJString(pageToken))
  add(query_598443, "quotaUser", newJString(quotaUser))
  add(query_598443, "alt", newJString(alt))
  add(query_598443, "oauth_token", newJString(oauthToken))
  add(query_598443, "callback", newJString(callback))
  add(query_598443, "access_token", newJString(accessToken))
  add(query_598443, "uploadType", newJString(uploadType))
  add(query_598443, "key", newJString(key))
  add(query_598443, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_598443, "$.xgafv", newJString(Xgafv))
  add(query_598443, "pageSize", newJInt(pageSize))
  add(query_598443, "prettyPrint", newJBool(prettyPrint))
  result = call_598442.call(nil, query_598443, nil, nil, nil)

var cloudsearchSettingsSearchapplicationsList* = Call_CloudsearchSettingsSearchapplicationsList_598424(
    name: "cloudsearchSettingsSearchapplicationsList", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/searchapplications",
    validator: validate_CloudsearchSettingsSearchapplicationsList_598425,
    base: "/", url: url_CloudsearchSettingsSearchapplicationsList_598426,
    schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsDatasourcesUpdate_598483 = ref object of OpenApiRestCall_597421
proc url_CloudsearchSettingsDatasourcesUpdate_598485(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/settings/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudsearchSettingsDatasourcesUpdate_598484(path: JsonNode;
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
  var valid_598486 = path.getOrDefault("name")
  valid_598486 = validateParameter(valid_598486, JString, required = true,
                                 default = nil)
  if valid_598486 != nil:
    section.add "name", valid_598486
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
  var valid_598487 = query.getOrDefault("upload_protocol")
  valid_598487 = validateParameter(valid_598487, JString, required = false,
                                 default = nil)
  if valid_598487 != nil:
    section.add "upload_protocol", valid_598487
  var valid_598488 = query.getOrDefault("fields")
  valid_598488 = validateParameter(valid_598488, JString, required = false,
                                 default = nil)
  if valid_598488 != nil:
    section.add "fields", valid_598488
  var valid_598489 = query.getOrDefault("quotaUser")
  valid_598489 = validateParameter(valid_598489, JString, required = false,
                                 default = nil)
  if valid_598489 != nil:
    section.add "quotaUser", valid_598489
  var valid_598490 = query.getOrDefault("alt")
  valid_598490 = validateParameter(valid_598490, JString, required = false,
                                 default = newJString("json"))
  if valid_598490 != nil:
    section.add "alt", valid_598490
  var valid_598491 = query.getOrDefault("oauth_token")
  valid_598491 = validateParameter(valid_598491, JString, required = false,
                                 default = nil)
  if valid_598491 != nil:
    section.add "oauth_token", valid_598491
  var valid_598492 = query.getOrDefault("callback")
  valid_598492 = validateParameter(valid_598492, JString, required = false,
                                 default = nil)
  if valid_598492 != nil:
    section.add "callback", valid_598492
  var valid_598493 = query.getOrDefault("access_token")
  valid_598493 = validateParameter(valid_598493, JString, required = false,
                                 default = nil)
  if valid_598493 != nil:
    section.add "access_token", valid_598493
  var valid_598494 = query.getOrDefault("uploadType")
  valid_598494 = validateParameter(valid_598494, JString, required = false,
                                 default = nil)
  if valid_598494 != nil:
    section.add "uploadType", valid_598494
  var valid_598495 = query.getOrDefault("key")
  valid_598495 = validateParameter(valid_598495, JString, required = false,
                                 default = nil)
  if valid_598495 != nil:
    section.add "key", valid_598495
  var valid_598496 = query.getOrDefault("$.xgafv")
  valid_598496 = validateParameter(valid_598496, JString, required = false,
                                 default = newJString("1"))
  if valid_598496 != nil:
    section.add "$.xgafv", valid_598496
  var valid_598497 = query.getOrDefault("prettyPrint")
  valid_598497 = validateParameter(valid_598497, JBool, required = false,
                                 default = newJBool(true))
  if valid_598497 != nil:
    section.add "prettyPrint", valid_598497
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

proc call*(call_598499: Call_CloudsearchSettingsDatasourcesUpdate_598483;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a datasource.
  ## 
  let valid = call_598499.validator(path, query, header, formData, body)
  let scheme = call_598499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598499.url(scheme.get, call_598499.host, call_598499.base,
                         call_598499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598499, url, valid)

proc call*(call_598500: Call_CloudsearchSettingsDatasourcesUpdate_598483;
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
  var path_598501 = newJObject()
  var query_598502 = newJObject()
  var body_598503 = newJObject()
  add(query_598502, "upload_protocol", newJString(uploadProtocol))
  add(query_598502, "fields", newJString(fields))
  add(query_598502, "quotaUser", newJString(quotaUser))
  add(path_598501, "name", newJString(name))
  add(query_598502, "alt", newJString(alt))
  add(query_598502, "oauth_token", newJString(oauthToken))
  add(query_598502, "callback", newJString(callback))
  add(query_598502, "access_token", newJString(accessToken))
  add(query_598502, "uploadType", newJString(uploadType))
  add(query_598502, "key", newJString(key))
  add(query_598502, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598503 = body
  add(query_598502, "prettyPrint", newJBool(prettyPrint))
  result = call_598500.call(path_598501, query_598502, nil, nil, body_598503)

var cloudsearchSettingsDatasourcesUpdate* = Call_CloudsearchSettingsDatasourcesUpdate_598483(
    name: "cloudsearchSettingsDatasourcesUpdate", meth: HttpMethod.HttpPut,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/{name}",
    validator: validate_CloudsearchSettingsDatasourcesUpdate_598484, base: "/",
    url: url_CloudsearchSettingsDatasourcesUpdate_598485, schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsDatasourcesGet_598463 = ref object of OpenApiRestCall_597421
proc url_CloudsearchSettingsDatasourcesGet_598465(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/settings/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudsearchSettingsDatasourcesGet_598464(path: JsonNode;
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
  var valid_598466 = path.getOrDefault("name")
  valid_598466 = validateParameter(valid_598466, JString, required = true,
                                 default = nil)
  if valid_598466 != nil:
    section.add "name", valid_598466
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
  var valid_598467 = query.getOrDefault("upload_protocol")
  valid_598467 = validateParameter(valid_598467, JString, required = false,
                                 default = nil)
  if valid_598467 != nil:
    section.add "upload_protocol", valid_598467
  var valid_598468 = query.getOrDefault("fields")
  valid_598468 = validateParameter(valid_598468, JString, required = false,
                                 default = nil)
  if valid_598468 != nil:
    section.add "fields", valid_598468
  var valid_598469 = query.getOrDefault("quotaUser")
  valid_598469 = validateParameter(valid_598469, JString, required = false,
                                 default = nil)
  if valid_598469 != nil:
    section.add "quotaUser", valid_598469
  var valid_598470 = query.getOrDefault("alt")
  valid_598470 = validateParameter(valid_598470, JString, required = false,
                                 default = newJString("json"))
  if valid_598470 != nil:
    section.add "alt", valid_598470
  var valid_598471 = query.getOrDefault("oauth_token")
  valid_598471 = validateParameter(valid_598471, JString, required = false,
                                 default = nil)
  if valid_598471 != nil:
    section.add "oauth_token", valid_598471
  var valid_598472 = query.getOrDefault("callback")
  valid_598472 = validateParameter(valid_598472, JString, required = false,
                                 default = nil)
  if valid_598472 != nil:
    section.add "callback", valid_598472
  var valid_598473 = query.getOrDefault("access_token")
  valid_598473 = validateParameter(valid_598473, JString, required = false,
                                 default = nil)
  if valid_598473 != nil:
    section.add "access_token", valid_598473
  var valid_598474 = query.getOrDefault("uploadType")
  valid_598474 = validateParameter(valid_598474, JString, required = false,
                                 default = nil)
  if valid_598474 != nil:
    section.add "uploadType", valid_598474
  var valid_598475 = query.getOrDefault("key")
  valid_598475 = validateParameter(valid_598475, JString, required = false,
                                 default = nil)
  if valid_598475 != nil:
    section.add "key", valid_598475
  var valid_598476 = query.getOrDefault("debugOptions.enableDebugging")
  valid_598476 = validateParameter(valid_598476, JBool, required = false, default = nil)
  if valid_598476 != nil:
    section.add "debugOptions.enableDebugging", valid_598476
  var valid_598477 = query.getOrDefault("$.xgafv")
  valid_598477 = validateParameter(valid_598477, JString, required = false,
                                 default = newJString("1"))
  if valid_598477 != nil:
    section.add "$.xgafv", valid_598477
  var valid_598478 = query.getOrDefault("prettyPrint")
  valid_598478 = validateParameter(valid_598478, JBool, required = false,
                                 default = newJBool(true))
  if valid_598478 != nil:
    section.add "prettyPrint", valid_598478
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598479: Call_CloudsearchSettingsDatasourcesGet_598463;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a datasource.
  ## 
  let valid = call_598479.validator(path, query, header, formData, body)
  let scheme = call_598479.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598479.url(scheme.get, call_598479.host, call_598479.base,
                         call_598479.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598479, url, valid)

proc call*(call_598480: Call_CloudsearchSettingsDatasourcesGet_598463;
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
  var path_598481 = newJObject()
  var query_598482 = newJObject()
  add(query_598482, "upload_protocol", newJString(uploadProtocol))
  add(query_598482, "fields", newJString(fields))
  add(query_598482, "quotaUser", newJString(quotaUser))
  add(path_598481, "name", newJString(name))
  add(query_598482, "alt", newJString(alt))
  add(query_598482, "oauth_token", newJString(oauthToken))
  add(query_598482, "callback", newJString(callback))
  add(query_598482, "access_token", newJString(accessToken))
  add(query_598482, "uploadType", newJString(uploadType))
  add(query_598482, "key", newJString(key))
  add(query_598482, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_598482, "$.xgafv", newJString(Xgafv))
  add(query_598482, "prettyPrint", newJBool(prettyPrint))
  result = call_598480.call(path_598481, query_598482, nil, nil, nil)

var cloudsearchSettingsDatasourcesGet* = Call_CloudsearchSettingsDatasourcesGet_598463(
    name: "cloudsearchSettingsDatasourcesGet", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/{name}",
    validator: validate_CloudsearchSettingsDatasourcesGet_598464, base: "/",
    url: url_CloudsearchSettingsDatasourcesGet_598465, schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsDatasourcesDelete_598504 = ref object of OpenApiRestCall_597421
proc url_CloudsearchSettingsDatasourcesDelete_598506(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/settings/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudsearchSettingsDatasourcesDelete_598505(path: JsonNode;
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
  var valid_598507 = path.getOrDefault("name")
  valid_598507 = validateParameter(valid_598507, JString, required = true,
                                 default = nil)
  if valid_598507 != nil:
    section.add "name", valid_598507
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
  var valid_598508 = query.getOrDefault("upload_protocol")
  valid_598508 = validateParameter(valid_598508, JString, required = false,
                                 default = nil)
  if valid_598508 != nil:
    section.add "upload_protocol", valid_598508
  var valid_598509 = query.getOrDefault("fields")
  valid_598509 = validateParameter(valid_598509, JString, required = false,
                                 default = nil)
  if valid_598509 != nil:
    section.add "fields", valid_598509
  var valid_598510 = query.getOrDefault("quotaUser")
  valid_598510 = validateParameter(valid_598510, JString, required = false,
                                 default = nil)
  if valid_598510 != nil:
    section.add "quotaUser", valid_598510
  var valid_598511 = query.getOrDefault("alt")
  valid_598511 = validateParameter(valid_598511, JString, required = false,
                                 default = newJString("json"))
  if valid_598511 != nil:
    section.add "alt", valid_598511
  var valid_598512 = query.getOrDefault("oauth_token")
  valid_598512 = validateParameter(valid_598512, JString, required = false,
                                 default = nil)
  if valid_598512 != nil:
    section.add "oauth_token", valid_598512
  var valid_598513 = query.getOrDefault("callback")
  valid_598513 = validateParameter(valid_598513, JString, required = false,
                                 default = nil)
  if valid_598513 != nil:
    section.add "callback", valid_598513
  var valid_598514 = query.getOrDefault("access_token")
  valid_598514 = validateParameter(valid_598514, JString, required = false,
                                 default = nil)
  if valid_598514 != nil:
    section.add "access_token", valid_598514
  var valid_598515 = query.getOrDefault("uploadType")
  valid_598515 = validateParameter(valid_598515, JString, required = false,
                                 default = nil)
  if valid_598515 != nil:
    section.add "uploadType", valid_598515
  var valid_598516 = query.getOrDefault("key")
  valid_598516 = validateParameter(valid_598516, JString, required = false,
                                 default = nil)
  if valid_598516 != nil:
    section.add "key", valid_598516
  var valid_598517 = query.getOrDefault("debugOptions.enableDebugging")
  valid_598517 = validateParameter(valid_598517, JBool, required = false, default = nil)
  if valid_598517 != nil:
    section.add "debugOptions.enableDebugging", valid_598517
  var valid_598518 = query.getOrDefault("$.xgafv")
  valid_598518 = validateParameter(valid_598518, JString, required = false,
                                 default = newJString("1"))
  if valid_598518 != nil:
    section.add "$.xgafv", valid_598518
  var valid_598519 = query.getOrDefault("prettyPrint")
  valid_598519 = validateParameter(valid_598519, JBool, required = false,
                                 default = newJBool(true))
  if valid_598519 != nil:
    section.add "prettyPrint", valid_598519
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598520: Call_CloudsearchSettingsDatasourcesDelete_598504;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a datasource.
  ## 
  let valid = call_598520.validator(path, query, header, formData, body)
  let scheme = call_598520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598520.url(scheme.get, call_598520.host, call_598520.base,
                         call_598520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598520, url, valid)

proc call*(call_598521: Call_CloudsearchSettingsDatasourcesDelete_598504;
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
  var path_598522 = newJObject()
  var query_598523 = newJObject()
  add(query_598523, "upload_protocol", newJString(uploadProtocol))
  add(query_598523, "fields", newJString(fields))
  add(query_598523, "quotaUser", newJString(quotaUser))
  add(path_598522, "name", newJString(name))
  add(query_598523, "alt", newJString(alt))
  add(query_598523, "oauth_token", newJString(oauthToken))
  add(query_598523, "callback", newJString(callback))
  add(query_598523, "access_token", newJString(accessToken))
  add(query_598523, "uploadType", newJString(uploadType))
  add(query_598523, "key", newJString(key))
  add(query_598523, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_598523, "$.xgafv", newJString(Xgafv))
  add(query_598523, "prettyPrint", newJBool(prettyPrint))
  result = call_598521.call(path_598522, query_598523, nil, nil, nil)

var cloudsearchSettingsDatasourcesDelete* = Call_CloudsearchSettingsDatasourcesDelete_598504(
    name: "cloudsearchSettingsDatasourcesDelete", meth: HttpMethod.HttpDelete,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/{name}",
    validator: validate_CloudsearchSettingsDatasourcesDelete_598505, base: "/",
    url: url_CloudsearchSettingsDatasourcesDelete_598506, schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsSearchapplicationsReset_598524 = ref object of OpenApiRestCall_597421
proc url_CloudsearchSettingsSearchapplicationsReset_598526(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_CloudsearchSettingsSearchapplicationsReset_598525(path: JsonNode;
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
  var valid_598527 = path.getOrDefault("name")
  valid_598527 = validateParameter(valid_598527, JString, required = true,
                                 default = nil)
  if valid_598527 != nil:
    section.add "name", valid_598527
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
  var valid_598528 = query.getOrDefault("upload_protocol")
  valid_598528 = validateParameter(valid_598528, JString, required = false,
                                 default = nil)
  if valid_598528 != nil:
    section.add "upload_protocol", valid_598528
  var valid_598529 = query.getOrDefault("fields")
  valid_598529 = validateParameter(valid_598529, JString, required = false,
                                 default = nil)
  if valid_598529 != nil:
    section.add "fields", valid_598529
  var valid_598530 = query.getOrDefault("quotaUser")
  valid_598530 = validateParameter(valid_598530, JString, required = false,
                                 default = nil)
  if valid_598530 != nil:
    section.add "quotaUser", valid_598530
  var valid_598531 = query.getOrDefault("alt")
  valid_598531 = validateParameter(valid_598531, JString, required = false,
                                 default = newJString("json"))
  if valid_598531 != nil:
    section.add "alt", valid_598531
  var valid_598532 = query.getOrDefault("oauth_token")
  valid_598532 = validateParameter(valid_598532, JString, required = false,
                                 default = nil)
  if valid_598532 != nil:
    section.add "oauth_token", valid_598532
  var valid_598533 = query.getOrDefault("callback")
  valid_598533 = validateParameter(valid_598533, JString, required = false,
                                 default = nil)
  if valid_598533 != nil:
    section.add "callback", valid_598533
  var valid_598534 = query.getOrDefault("access_token")
  valid_598534 = validateParameter(valid_598534, JString, required = false,
                                 default = nil)
  if valid_598534 != nil:
    section.add "access_token", valid_598534
  var valid_598535 = query.getOrDefault("uploadType")
  valid_598535 = validateParameter(valid_598535, JString, required = false,
                                 default = nil)
  if valid_598535 != nil:
    section.add "uploadType", valid_598535
  var valid_598536 = query.getOrDefault("key")
  valid_598536 = validateParameter(valid_598536, JString, required = false,
                                 default = nil)
  if valid_598536 != nil:
    section.add "key", valid_598536
  var valid_598537 = query.getOrDefault("$.xgafv")
  valid_598537 = validateParameter(valid_598537, JString, required = false,
                                 default = newJString("1"))
  if valid_598537 != nil:
    section.add "$.xgafv", valid_598537
  var valid_598538 = query.getOrDefault("prettyPrint")
  valid_598538 = validateParameter(valid_598538, JBool, required = false,
                                 default = newJBool(true))
  if valid_598538 != nil:
    section.add "prettyPrint", valid_598538
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

proc call*(call_598540: Call_CloudsearchSettingsSearchapplicationsReset_598524;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets a search application to default settings. This will return an empty
  ## response.
  ## 
  let valid = call_598540.validator(path, query, header, formData, body)
  let scheme = call_598540.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598540.url(scheme.get, call_598540.host, call_598540.base,
                         call_598540.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598540, url, valid)

proc call*(call_598541: Call_CloudsearchSettingsSearchapplicationsReset_598524;
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
  var path_598542 = newJObject()
  var query_598543 = newJObject()
  var body_598544 = newJObject()
  add(query_598543, "upload_protocol", newJString(uploadProtocol))
  add(query_598543, "fields", newJString(fields))
  add(query_598543, "quotaUser", newJString(quotaUser))
  add(path_598542, "name", newJString(name))
  add(query_598543, "alt", newJString(alt))
  add(query_598543, "oauth_token", newJString(oauthToken))
  add(query_598543, "callback", newJString(callback))
  add(query_598543, "access_token", newJString(accessToken))
  add(query_598543, "uploadType", newJString(uploadType))
  add(query_598543, "key", newJString(key))
  add(query_598543, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598544 = body
  add(query_598543, "prettyPrint", newJBool(prettyPrint))
  result = call_598541.call(path_598542, query_598543, nil, nil, body_598544)

var cloudsearchSettingsSearchapplicationsReset* = Call_CloudsearchSettingsSearchapplicationsReset_598524(
    name: "cloudsearchSettingsSearchapplicationsReset", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/{name}:reset",
    validator: validate_CloudsearchSettingsSearchapplicationsReset_598525,
    base: "/", url: url_CloudsearchSettingsSearchapplicationsReset_598526,
    schemes: {Scheme.Https})
type
  Call_CloudsearchStatsGetIndex_598545 = ref object of OpenApiRestCall_597421
proc url_CloudsearchStatsGetIndex_598547(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CloudsearchStatsGetIndex_598546(path: JsonNode; query: JsonNode;
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
  var valid_598548 = query.getOrDefault("upload_protocol")
  valid_598548 = validateParameter(valid_598548, JString, required = false,
                                 default = nil)
  if valid_598548 != nil:
    section.add "upload_protocol", valid_598548
  var valid_598549 = query.getOrDefault("fields")
  valid_598549 = validateParameter(valid_598549, JString, required = false,
                                 default = nil)
  if valid_598549 != nil:
    section.add "fields", valid_598549
  var valid_598550 = query.getOrDefault("quotaUser")
  valid_598550 = validateParameter(valid_598550, JString, required = false,
                                 default = nil)
  if valid_598550 != nil:
    section.add "quotaUser", valid_598550
  var valid_598551 = query.getOrDefault("alt")
  valid_598551 = validateParameter(valid_598551, JString, required = false,
                                 default = newJString("json"))
  if valid_598551 != nil:
    section.add "alt", valid_598551
  var valid_598552 = query.getOrDefault("toDate.day")
  valid_598552 = validateParameter(valid_598552, JInt, required = false, default = nil)
  if valid_598552 != nil:
    section.add "toDate.day", valid_598552
  var valid_598553 = query.getOrDefault("oauth_token")
  valid_598553 = validateParameter(valid_598553, JString, required = false,
                                 default = nil)
  if valid_598553 != nil:
    section.add "oauth_token", valid_598553
  var valid_598554 = query.getOrDefault("callback")
  valid_598554 = validateParameter(valid_598554, JString, required = false,
                                 default = nil)
  if valid_598554 != nil:
    section.add "callback", valid_598554
  var valid_598555 = query.getOrDefault("access_token")
  valid_598555 = validateParameter(valid_598555, JString, required = false,
                                 default = nil)
  if valid_598555 != nil:
    section.add "access_token", valid_598555
  var valid_598556 = query.getOrDefault("uploadType")
  valid_598556 = validateParameter(valid_598556, JString, required = false,
                                 default = nil)
  if valid_598556 != nil:
    section.add "uploadType", valid_598556
  var valid_598557 = query.getOrDefault("fromDate.day")
  valid_598557 = validateParameter(valid_598557, JInt, required = false, default = nil)
  if valid_598557 != nil:
    section.add "fromDate.day", valid_598557
  var valid_598558 = query.getOrDefault("fromDate.month")
  valid_598558 = validateParameter(valid_598558, JInt, required = false, default = nil)
  if valid_598558 != nil:
    section.add "fromDate.month", valid_598558
  var valid_598559 = query.getOrDefault("key")
  valid_598559 = validateParameter(valid_598559, JString, required = false,
                                 default = nil)
  if valid_598559 != nil:
    section.add "key", valid_598559
  var valid_598560 = query.getOrDefault("$.xgafv")
  valid_598560 = validateParameter(valid_598560, JString, required = false,
                                 default = newJString("1"))
  if valid_598560 != nil:
    section.add "$.xgafv", valid_598560
  var valid_598561 = query.getOrDefault("toDate.month")
  valid_598561 = validateParameter(valid_598561, JInt, required = false, default = nil)
  if valid_598561 != nil:
    section.add "toDate.month", valid_598561
  var valid_598562 = query.getOrDefault("prettyPrint")
  valid_598562 = validateParameter(valid_598562, JBool, required = false,
                                 default = newJBool(true))
  if valid_598562 != nil:
    section.add "prettyPrint", valid_598562
  var valid_598563 = query.getOrDefault("toDate.year")
  valid_598563 = validateParameter(valid_598563, JInt, required = false, default = nil)
  if valid_598563 != nil:
    section.add "toDate.year", valid_598563
  var valid_598564 = query.getOrDefault("fromDate.year")
  valid_598564 = validateParameter(valid_598564, JInt, required = false, default = nil)
  if valid_598564 != nil:
    section.add "fromDate.year", valid_598564
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598565: Call_CloudsearchStatsGetIndex_598545; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets indexed item statistics aggreggated across all data sources. This
  ## API only returns statistics for previous dates; it doesn't return
  ## statistics for the current day.
  ## 
  let valid = call_598565.validator(path, query, header, formData, body)
  let scheme = call_598565.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598565.url(scheme.get, call_598565.host, call_598565.base,
                         call_598565.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598565, url, valid)

proc call*(call_598566: Call_CloudsearchStatsGetIndex_598545;
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
  var query_598567 = newJObject()
  add(query_598567, "upload_protocol", newJString(uploadProtocol))
  add(query_598567, "fields", newJString(fields))
  add(query_598567, "quotaUser", newJString(quotaUser))
  add(query_598567, "alt", newJString(alt))
  add(query_598567, "toDate.day", newJInt(toDateDay))
  add(query_598567, "oauth_token", newJString(oauthToken))
  add(query_598567, "callback", newJString(callback))
  add(query_598567, "access_token", newJString(accessToken))
  add(query_598567, "uploadType", newJString(uploadType))
  add(query_598567, "fromDate.day", newJInt(fromDateDay))
  add(query_598567, "fromDate.month", newJInt(fromDateMonth))
  add(query_598567, "key", newJString(key))
  add(query_598567, "$.xgafv", newJString(Xgafv))
  add(query_598567, "toDate.month", newJInt(toDateMonth))
  add(query_598567, "prettyPrint", newJBool(prettyPrint))
  add(query_598567, "toDate.year", newJInt(toDateYear))
  add(query_598567, "fromDate.year", newJInt(fromDateYear))
  result = call_598566.call(nil, query_598567, nil, nil, nil)

var cloudsearchStatsGetIndex* = Call_CloudsearchStatsGetIndex_598545(
    name: "cloudsearchStatsGetIndex", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/stats/index",
    validator: validate_CloudsearchStatsGetIndex_598546, base: "/",
    url: url_CloudsearchStatsGetIndex_598547, schemes: {Scheme.Https})
type
  Call_CloudsearchStatsIndexDatasourcesGet_598568 = ref object of OpenApiRestCall_597421
proc url_CloudsearchStatsIndexDatasourcesGet_598570(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/stats/index/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudsearchStatsIndexDatasourcesGet_598569(path: JsonNode;
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
  var valid_598571 = path.getOrDefault("name")
  valid_598571 = validateParameter(valid_598571, JString, required = true,
                                 default = nil)
  if valid_598571 != nil:
    section.add "name", valid_598571
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
  var valid_598572 = query.getOrDefault("upload_protocol")
  valid_598572 = validateParameter(valid_598572, JString, required = false,
                                 default = nil)
  if valid_598572 != nil:
    section.add "upload_protocol", valid_598572
  var valid_598573 = query.getOrDefault("fields")
  valid_598573 = validateParameter(valid_598573, JString, required = false,
                                 default = nil)
  if valid_598573 != nil:
    section.add "fields", valid_598573
  var valid_598574 = query.getOrDefault("quotaUser")
  valid_598574 = validateParameter(valid_598574, JString, required = false,
                                 default = nil)
  if valid_598574 != nil:
    section.add "quotaUser", valid_598574
  var valid_598575 = query.getOrDefault("alt")
  valid_598575 = validateParameter(valid_598575, JString, required = false,
                                 default = newJString("json"))
  if valid_598575 != nil:
    section.add "alt", valid_598575
  var valid_598576 = query.getOrDefault("toDate.day")
  valid_598576 = validateParameter(valid_598576, JInt, required = false, default = nil)
  if valid_598576 != nil:
    section.add "toDate.day", valid_598576
  var valid_598577 = query.getOrDefault("oauth_token")
  valid_598577 = validateParameter(valid_598577, JString, required = false,
                                 default = nil)
  if valid_598577 != nil:
    section.add "oauth_token", valid_598577
  var valid_598578 = query.getOrDefault("callback")
  valid_598578 = validateParameter(valid_598578, JString, required = false,
                                 default = nil)
  if valid_598578 != nil:
    section.add "callback", valid_598578
  var valid_598579 = query.getOrDefault("access_token")
  valid_598579 = validateParameter(valid_598579, JString, required = false,
                                 default = nil)
  if valid_598579 != nil:
    section.add "access_token", valid_598579
  var valid_598580 = query.getOrDefault("uploadType")
  valid_598580 = validateParameter(valid_598580, JString, required = false,
                                 default = nil)
  if valid_598580 != nil:
    section.add "uploadType", valid_598580
  var valid_598581 = query.getOrDefault("fromDate.day")
  valid_598581 = validateParameter(valid_598581, JInt, required = false, default = nil)
  if valid_598581 != nil:
    section.add "fromDate.day", valid_598581
  var valid_598582 = query.getOrDefault("fromDate.month")
  valid_598582 = validateParameter(valid_598582, JInt, required = false, default = nil)
  if valid_598582 != nil:
    section.add "fromDate.month", valid_598582
  var valid_598583 = query.getOrDefault("key")
  valid_598583 = validateParameter(valid_598583, JString, required = false,
                                 default = nil)
  if valid_598583 != nil:
    section.add "key", valid_598583
  var valid_598584 = query.getOrDefault("$.xgafv")
  valid_598584 = validateParameter(valid_598584, JString, required = false,
                                 default = newJString("1"))
  if valid_598584 != nil:
    section.add "$.xgafv", valid_598584
  var valid_598585 = query.getOrDefault("toDate.month")
  valid_598585 = validateParameter(valid_598585, JInt, required = false, default = nil)
  if valid_598585 != nil:
    section.add "toDate.month", valid_598585
  var valid_598586 = query.getOrDefault("prettyPrint")
  valid_598586 = validateParameter(valid_598586, JBool, required = false,
                                 default = newJBool(true))
  if valid_598586 != nil:
    section.add "prettyPrint", valid_598586
  var valid_598587 = query.getOrDefault("toDate.year")
  valid_598587 = validateParameter(valid_598587, JInt, required = false, default = nil)
  if valid_598587 != nil:
    section.add "toDate.year", valid_598587
  var valid_598588 = query.getOrDefault("fromDate.year")
  valid_598588 = validateParameter(valid_598588, JInt, required = false, default = nil)
  if valid_598588 != nil:
    section.add "fromDate.year", valid_598588
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598589: Call_CloudsearchStatsIndexDatasourcesGet_598568;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets indexed item statistics for a single data source.
  ## 
  let valid = call_598589.validator(path, query, header, formData, body)
  let scheme = call_598589.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598589.url(scheme.get, call_598589.host, call_598589.base,
                         call_598589.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598589, url, valid)

proc call*(call_598590: Call_CloudsearchStatsIndexDatasourcesGet_598568;
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
  var path_598591 = newJObject()
  var query_598592 = newJObject()
  add(query_598592, "upload_protocol", newJString(uploadProtocol))
  add(query_598592, "fields", newJString(fields))
  add(query_598592, "quotaUser", newJString(quotaUser))
  add(path_598591, "name", newJString(name))
  add(query_598592, "alt", newJString(alt))
  add(query_598592, "toDate.day", newJInt(toDateDay))
  add(query_598592, "oauth_token", newJString(oauthToken))
  add(query_598592, "callback", newJString(callback))
  add(query_598592, "access_token", newJString(accessToken))
  add(query_598592, "uploadType", newJString(uploadType))
  add(query_598592, "fromDate.day", newJInt(fromDateDay))
  add(query_598592, "fromDate.month", newJInt(fromDateMonth))
  add(query_598592, "key", newJString(key))
  add(query_598592, "$.xgafv", newJString(Xgafv))
  add(query_598592, "toDate.month", newJInt(toDateMonth))
  add(query_598592, "prettyPrint", newJBool(prettyPrint))
  add(query_598592, "toDate.year", newJInt(toDateYear))
  add(query_598592, "fromDate.year", newJInt(fromDateYear))
  result = call_598590.call(path_598591, query_598592, nil, nil, nil)

var cloudsearchStatsIndexDatasourcesGet* = Call_CloudsearchStatsIndexDatasourcesGet_598568(
    name: "cloudsearchStatsIndexDatasourcesGet", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/stats/index/{name}",
    validator: validate_CloudsearchStatsIndexDatasourcesGet_598569, base: "/",
    url: url_CloudsearchStatsIndexDatasourcesGet_598570, schemes: {Scheme.Https})
type
  Call_CloudsearchOperationsGet_598593 = ref object of OpenApiRestCall_597421
proc url_CloudsearchOperationsGet_598595(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
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

proc validate_CloudsearchOperationsGet_598594(path: JsonNode; query: JsonNode;
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
  var valid_598596 = path.getOrDefault("name")
  valid_598596 = validateParameter(valid_598596, JString, required = true,
                                 default = nil)
  if valid_598596 != nil:
    section.add "name", valid_598596
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
  var valid_598597 = query.getOrDefault("upload_protocol")
  valid_598597 = validateParameter(valid_598597, JString, required = false,
                                 default = nil)
  if valid_598597 != nil:
    section.add "upload_protocol", valid_598597
  var valid_598598 = query.getOrDefault("fields")
  valid_598598 = validateParameter(valid_598598, JString, required = false,
                                 default = nil)
  if valid_598598 != nil:
    section.add "fields", valid_598598
  var valid_598599 = query.getOrDefault("quotaUser")
  valid_598599 = validateParameter(valid_598599, JString, required = false,
                                 default = nil)
  if valid_598599 != nil:
    section.add "quotaUser", valid_598599
  var valid_598600 = query.getOrDefault("alt")
  valid_598600 = validateParameter(valid_598600, JString, required = false,
                                 default = newJString("json"))
  if valid_598600 != nil:
    section.add "alt", valid_598600
  var valid_598601 = query.getOrDefault("oauth_token")
  valid_598601 = validateParameter(valid_598601, JString, required = false,
                                 default = nil)
  if valid_598601 != nil:
    section.add "oauth_token", valid_598601
  var valid_598602 = query.getOrDefault("callback")
  valid_598602 = validateParameter(valid_598602, JString, required = false,
                                 default = nil)
  if valid_598602 != nil:
    section.add "callback", valid_598602
  var valid_598603 = query.getOrDefault("access_token")
  valid_598603 = validateParameter(valid_598603, JString, required = false,
                                 default = nil)
  if valid_598603 != nil:
    section.add "access_token", valid_598603
  var valid_598604 = query.getOrDefault("uploadType")
  valid_598604 = validateParameter(valid_598604, JString, required = false,
                                 default = nil)
  if valid_598604 != nil:
    section.add "uploadType", valid_598604
  var valid_598605 = query.getOrDefault("key")
  valid_598605 = validateParameter(valid_598605, JString, required = false,
                                 default = nil)
  if valid_598605 != nil:
    section.add "key", valid_598605
  var valid_598606 = query.getOrDefault("$.xgafv")
  valid_598606 = validateParameter(valid_598606, JString, required = false,
                                 default = newJString("1"))
  if valid_598606 != nil:
    section.add "$.xgafv", valid_598606
  var valid_598607 = query.getOrDefault("prettyPrint")
  valid_598607 = validateParameter(valid_598607, JBool, required = false,
                                 default = newJBool(true))
  if valid_598607 != nil:
    section.add "prettyPrint", valid_598607
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598608: Call_CloudsearchOperationsGet_598593; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_598608.validator(path, query, header, formData, body)
  let scheme = call_598608.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598608.url(scheme.get, call_598608.host, call_598608.base,
                         call_598608.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598608, url, valid)

proc call*(call_598609: Call_CloudsearchOperationsGet_598593; name: string;
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
  var path_598610 = newJObject()
  var query_598611 = newJObject()
  add(query_598611, "upload_protocol", newJString(uploadProtocol))
  add(query_598611, "fields", newJString(fields))
  add(query_598611, "quotaUser", newJString(quotaUser))
  add(path_598610, "name", newJString(name))
  add(query_598611, "alt", newJString(alt))
  add(query_598611, "oauth_token", newJString(oauthToken))
  add(query_598611, "callback", newJString(callback))
  add(query_598611, "access_token", newJString(accessToken))
  add(query_598611, "uploadType", newJString(uploadType))
  add(query_598611, "key", newJString(key))
  add(query_598611, "$.xgafv", newJString(Xgafv))
  add(query_598611, "prettyPrint", newJBool(prettyPrint))
  result = call_598609.call(path_598610, query_598611, nil, nil, nil)

var cloudsearchOperationsGet* = Call_CloudsearchOperationsGet_598593(
    name: "cloudsearchOperationsGet", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudsearchOperationsGet_598594, base: "/",
    url: url_CloudsearchOperationsGet_598595, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
