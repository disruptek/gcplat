
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

  OpenApiRestCall_588450 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588450](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588450): Option[Scheme] {.used.} =
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
  gcpServiceName = "cloudsearch"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudsearchDebugDatasourcesItemsSearchByViewUrl_588719 = ref object of OpenApiRestCall_588450
proc url_CloudsearchDebugDatasourcesItemsSearchByViewUrl_588721(protocol: Scheme;
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

proc validate_CloudsearchDebugDatasourcesItemsSearchByViewUrl_588720(
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
  var valid_588847 = path.getOrDefault("name")
  valid_588847 = validateParameter(valid_588847, JString, required = true,
                                 default = nil)
  if valid_588847 != nil:
    section.add "name", valid_588847
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
  var valid_588848 = query.getOrDefault("upload_protocol")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = nil)
  if valid_588848 != nil:
    section.add "upload_protocol", valid_588848
  var valid_588849 = query.getOrDefault("fields")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = nil)
  if valid_588849 != nil:
    section.add "fields", valid_588849
  var valid_588850 = query.getOrDefault("quotaUser")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "quotaUser", valid_588850
  var valid_588864 = query.getOrDefault("alt")
  valid_588864 = validateParameter(valid_588864, JString, required = false,
                                 default = newJString("json"))
  if valid_588864 != nil:
    section.add "alt", valid_588864
  var valid_588865 = query.getOrDefault("oauth_token")
  valid_588865 = validateParameter(valid_588865, JString, required = false,
                                 default = nil)
  if valid_588865 != nil:
    section.add "oauth_token", valid_588865
  var valid_588866 = query.getOrDefault("callback")
  valid_588866 = validateParameter(valid_588866, JString, required = false,
                                 default = nil)
  if valid_588866 != nil:
    section.add "callback", valid_588866
  var valid_588867 = query.getOrDefault("access_token")
  valid_588867 = validateParameter(valid_588867, JString, required = false,
                                 default = nil)
  if valid_588867 != nil:
    section.add "access_token", valid_588867
  var valid_588868 = query.getOrDefault("uploadType")
  valid_588868 = validateParameter(valid_588868, JString, required = false,
                                 default = nil)
  if valid_588868 != nil:
    section.add "uploadType", valid_588868
  var valid_588869 = query.getOrDefault("key")
  valid_588869 = validateParameter(valid_588869, JString, required = false,
                                 default = nil)
  if valid_588869 != nil:
    section.add "key", valid_588869
  var valid_588870 = query.getOrDefault("$.xgafv")
  valid_588870 = validateParameter(valid_588870, JString, required = false,
                                 default = newJString("1"))
  if valid_588870 != nil:
    section.add "$.xgafv", valid_588870
  var valid_588871 = query.getOrDefault("prettyPrint")
  valid_588871 = validateParameter(valid_588871, JBool, required = false,
                                 default = newJBool(true))
  if valid_588871 != nil:
    section.add "prettyPrint", valid_588871
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

proc call*(call_588895: Call_CloudsearchDebugDatasourcesItemsSearchByViewUrl_588719;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Fetches the item whose viewUrl exactly matches that of the URL provided
  ## in the request.
  ## 
  let valid = call_588895.validator(path, query, header, formData, body)
  let scheme = call_588895.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588895.url(scheme.get, call_588895.host, call_588895.base,
                         call_588895.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588895, url, valid)

proc call*(call_588966: Call_CloudsearchDebugDatasourcesItemsSearchByViewUrl_588719;
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
  var path_588967 = newJObject()
  var query_588969 = newJObject()
  var body_588970 = newJObject()
  add(query_588969, "upload_protocol", newJString(uploadProtocol))
  add(query_588969, "fields", newJString(fields))
  add(query_588969, "quotaUser", newJString(quotaUser))
  add(path_588967, "name", newJString(name))
  add(query_588969, "alt", newJString(alt))
  add(query_588969, "oauth_token", newJString(oauthToken))
  add(query_588969, "callback", newJString(callback))
  add(query_588969, "access_token", newJString(accessToken))
  add(query_588969, "uploadType", newJString(uploadType))
  add(query_588969, "key", newJString(key))
  add(query_588969, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_588970 = body
  add(query_588969, "prettyPrint", newJBool(prettyPrint))
  result = call_588966.call(path_588967, query_588969, nil, nil, body_588970)

var cloudsearchDebugDatasourcesItemsSearchByViewUrl* = Call_CloudsearchDebugDatasourcesItemsSearchByViewUrl_588719(
    name: "cloudsearchDebugDatasourcesItemsSearchByViewUrl",
    meth: HttpMethod.HttpPost, host: "cloudsearch.googleapis.com",
    route: "/v1/debug/{name}/items:searchByViewUrl",
    validator: validate_CloudsearchDebugDatasourcesItemsSearchByViewUrl_588720,
    base: "/", url: url_CloudsearchDebugDatasourcesItemsSearchByViewUrl_588721,
    schemes: {Scheme.Https})
type
  Call_CloudsearchDebugDatasourcesItemsCheckAccess_589009 = ref object of OpenApiRestCall_588450
proc url_CloudsearchDebugDatasourcesItemsCheckAccess_589011(protocol: Scheme;
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

proc validate_CloudsearchDebugDatasourcesItemsCheckAccess_589010(path: JsonNode;
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
  var valid_589012 = path.getOrDefault("name")
  valid_589012 = validateParameter(valid_589012, JString, required = true,
                                 default = nil)
  if valid_589012 != nil:
    section.add "name", valid_589012
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
  var valid_589013 = query.getOrDefault("upload_protocol")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "upload_protocol", valid_589013
  var valid_589014 = query.getOrDefault("fields")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "fields", valid_589014
  var valid_589015 = query.getOrDefault("quotaUser")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "quotaUser", valid_589015
  var valid_589016 = query.getOrDefault("alt")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = newJString("json"))
  if valid_589016 != nil:
    section.add "alt", valid_589016
  var valid_589017 = query.getOrDefault("oauth_token")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "oauth_token", valid_589017
  var valid_589018 = query.getOrDefault("callback")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "callback", valid_589018
  var valid_589019 = query.getOrDefault("access_token")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "access_token", valid_589019
  var valid_589020 = query.getOrDefault("uploadType")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "uploadType", valid_589020
  var valid_589021 = query.getOrDefault("key")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "key", valid_589021
  var valid_589022 = query.getOrDefault("debugOptions.enableDebugging")
  valid_589022 = validateParameter(valid_589022, JBool, required = false, default = nil)
  if valid_589022 != nil:
    section.add "debugOptions.enableDebugging", valid_589022
  var valid_589023 = query.getOrDefault("$.xgafv")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = newJString("1"))
  if valid_589023 != nil:
    section.add "$.xgafv", valid_589023
  var valid_589024 = query.getOrDefault("prettyPrint")
  valid_589024 = validateParameter(valid_589024, JBool, required = false,
                                 default = newJBool(true))
  if valid_589024 != nil:
    section.add "prettyPrint", valid_589024
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

proc call*(call_589026: Call_CloudsearchDebugDatasourcesItemsCheckAccess_589009;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether an item is accessible by specified principal.
  ## 
  let valid = call_589026.validator(path, query, header, formData, body)
  let scheme = call_589026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589026.url(scheme.get, call_589026.host, call_589026.base,
                         call_589026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589026, url, valid)

proc call*(call_589027: Call_CloudsearchDebugDatasourcesItemsCheckAccess_589009;
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
  var path_589028 = newJObject()
  var query_589029 = newJObject()
  var body_589030 = newJObject()
  add(query_589029, "upload_protocol", newJString(uploadProtocol))
  add(query_589029, "fields", newJString(fields))
  add(query_589029, "quotaUser", newJString(quotaUser))
  add(path_589028, "name", newJString(name))
  add(query_589029, "alt", newJString(alt))
  add(query_589029, "oauth_token", newJString(oauthToken))
  add(query_589029, "callback", newJString(callback))
  add(query_589029, "access_token", newJString(accessToken))
  add(query_589029, "uploadType", newJString(uploadType))
  add(query_589029, "key", newJString(key))
  add(query_589029, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_589029, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589030 = body
  add(query_589029, "prettyPrint", newJBool(prettyPrint))
  result = call_589027.call(path_589028, query_589029, nil, nil, body_589030)

var cloudsearchDebugDatasourcesItemsCheckAccess* = Call_CloudsearchDebugDatasourcesItemsCheckAccess_589009(
    name: "cloudsearchDebugDatasourcesItemsCheckAccess",
    meth: HttpMethod.HttpPost, host: "cloudsearch.googleapis.com",
    route: "/v1/debug/{name}:checkAccess",
    validator: validate_CloudsearchDebugDatasourcesItemsCheckAccess_589010,
    base: "/", url: url_CloudsearchDebugDatasourcesItemsCheckAccess_589011,
    schemes: {Scheme.Https})
type
  Call_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_589031 = ref object of OpenApiRestCall_588450
proc url_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_589033(
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

proc validate_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_589032(
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
  var valid_589034 = path.getOrDefault("parent")
  valid_589034 = validateParameter(valid_589034, JString, required = true,
                                 default = nil)
  if valid_589034 != nil:
    section.add "parent", valid_589034
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
  var valid_589035 = query.getOrDefault("upload_protocol")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "upload_protocol", valid_589035
  var valid_589036 = query.getOrDefault("fields")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "fields", valid_589036
  var valid_589037 = query.getOrDefault("pageToken")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "pageToken", valid_589037
  var valid_589038 = query.getOrDefault("quotaUser")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "quotaUser", valid_589038
  var valid_589039 = query.getOrDefault("alt")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = newJString("json"))
  if valid_589039 != nil:
    section.add "alt", valid_589039
  var valid_589040 = query.getOrDefault("oauth_token")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "oauth_token", valid_589040
  var valid_589041 = query.getOrDefault("callback")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "callback", valid_589041
  var valid_589042 = query.getOrDefault("access_token")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "access_token", valid_589042
  var valid_589043 = query.getOrDefault("uploadType")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "uploadType", valid_589043
  var valid_589044 = query.getOrDefault("groupResourceName")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "groupResourceName", valid_589044
  var valid_589045 = query.getOrDefault("userResourceName")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "userResourceName", valid_589045
  var valid_589046 = query.getOrDefault("key")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "key", valid_589046
  var valid_589047 = query.getOrDefault("debugOptions.enableDebugging")
  valid_589047 = validateParameter(valid_589047, JBool, required = false, default = nil)
  if valid_589047 != nil:
    section.add "debugOptions.enableDebugging", valid_589047
  var valid_589048 = query.getOrDefault("$.xgafv")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = newJString("1"))
  if valid_589048 != nil:
    section.add "$.xgafv", valid_589048
  var valid_589049 = query.getOrDefault("pageSize")
  valid_589049 = validateParameter(valid_589049, JInt, required = false, default = nil)
  if valid_589049 != nil:
    section.add "pageSize", valid_589049
  var valid_589050 = query.getOrDefault("prettyPrint")
  valid_589050 = validateParameter(valid_589050, JBool, required = false,
                                 default = newJBool(true))
  if valid_589050 != nil:
    section.add "prettyPrint", valid_589050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589051: Call_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_589031;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists names of items associated with an unmapped identity.
  ## 
  let valid = call_589051.validator(path, query, header, formData, body)
  let scheme = call_589051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589051.url(scheme.get, call_589051.host, call_589051.base,
                         call_589051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589051, url, valid)

proc call*(call_589052: Call_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_589031;
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
  var path_589053 = newJObject()
  var query_589054 = newJObject()
  add(query_589054, "upload_protocol", newJString(uploadProtocol))
  add(query_589054, "fields", newJString(fields))
  add(query_589054, "pageToken", newJString(pageToken))
  add(query_589054, "quotaUser", newJString(quotaUser))
  add(query_589054, "alt", newJString(alt))
  add(query_589054, "oauth_token", newJString(oauthToken))
  add(query_589054, "callback", newJString(callback))
  add(query_589054, "access_token", newJString(accessToken))
  add(query_589054, "uploadType", newJString(uploadType))
  add(path_589053, "parent", newJString(parent))
  add(query_589054, "groupResourceName", newJString(groupResourceName))
  add(query_589054, "userResourceName", newJString(userResourceName))
  add(query_589054, "key", newJString(key))
  add(query_589054, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_589054, "$.xgafv", newJString(Xgafv))
  add(query_589054, "pageSize", newJInt(pageSize))
  add(query_589054, "prettyPrint", newJBool(prettyPrint))
  result = call_589052.call(path_589053, query_589054, nil, nil, nil)

var cloudsearchDebugIdentitysourcesItemsListForunmappedidentity* = Call_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_589031(
    name: "cloudsearchDebugIdentitysourcesItemsListForunmappedidentity",
    meth: HttpMethod.HttpGet, host: "cloudsearch.googleapis.com",
    route: "/v1/debug/{parent}/items:forunmappedidentity", validator: validate_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_589032,
    base: "/",
    url: url_CloudsearchDebugIdentitysourcesItemsListForunmappedidentity_589033,
    schemes: {Scheme.Https})
type
  Call_CloudsearchDebugIdentitysourcesUnmappedidsList_589055 = ref object of OpenApiRestCall_588450
proc url_CloudsearchDebugIdentitysourcesUnmappedidsList_589057(protocol: Scheme;
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

proc validate_CloudsearchDebugIdentitysourcesUnmappedidsList_589056(
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
  var valid_589058 = path.getOrDefault("parent")
  valid_589058 = validateParameter(valid_589058, JString, required = true,
                                 default = nil)
  if valid_589058 != nil:
    section.add "parent", valid_589058
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
  var valid_589059 = query.getOrDefault("upload_protocol")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "upload_protocol", valid_589059
  var valid_589060 = query.getOrDefault("fields")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "fields", valid_589060
  var valid_589061 = query.getOrDefault("pageToken")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "pageToken", valid_589061
  var valid_589062 = query.getOrDefault("quotaUser")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "quotaUser", valid_589062
  var valid_589063 = query.getOrDefault("alt")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = newJString("json"))
  if valid_589063 != nil:
    section.add "alt", valid_589063
  var valid_589064 = query.getOrDefault("oauth_token")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "oauth_token", valid_589064
  var valid_589065 = query.getOrDefault("callback")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "callback", valid_589065
  var valid_589066 = query.getOrDefault("access_token")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "access_token", valid_589066
  var valid_589067 = query.getOrDefault("uploadType")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "uploadType", valid_589067
  var valid_589068 = query.getOrDefault("key")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "key", valid_589068
  var valid_589069 = query.getOrDefault("debugOptions.enableDebugging")
  valid_589069 = validateParameter(valid_589069, JBool, required = false, default = nil)
  if valid_589069 != nil:
    section.add "debugOptions.enableDebugging", valid_589069
  var valid_589070 = query.getOrDefault("resolutionStatusCode")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = newJString("CODE_UNSPECIFIED"))
  if valid_589070 != nil:
    section.add "resolutionStatusCode", valid_589070
  var valid_589071 = query.getOrDefault("$.xgafv")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = newJString("1"))
  if valid_589071 != nil:
    section.add "$.xgafv", valid_589071
  var valid_589072 = query.getOrDefault("pageSize")
  valid_589072 = validateParameter(valid_589072, JInt, required = false, default = nil)
  if valid_589072 != nil:
    section.add "pageSize", valid_589072
  var valid_589073 = query.getOrDefault("prettyPrint")
  valid_589073 = validateParameter(valid_589073, JBool, required = false,
                                 default = newJBool(true))
  if valid_589073 != nil:
    section.add "prettyPrint", valid_589073
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589074: Call_CloudsearchDebugIdentitysourcesUnmappedidsList_589055;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists unmapped user identities for an identity source.
  ## 
  let valid = call_589074.validator(path, query, header, formData, body)
  let scheme = call_589074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589074.url(scheme.get, call_589074.host, call_589074.base,
                         call_589074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589074, url, valid)

proc call*(call_589075: Call_CloudsearchDebugIdentitysourcesUnmappedidsList_589055;
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
  var path_589076 = newJObject()
  var query_589077 = newJObject()
  add(query_589077, "upload_protocol", newJString(uploadProtocol))
  add(query_589077, "fields", newJString(fields))
  add(query_589077, "pageToken", newJString(pageToken))
  add(query_589077, "quotaUser", newJString(quotaUser))
  add(query_589077, "alt", newJString(alt))
  add(query_589077, "oauth_token", newJString(oauthToken))
  add(query_589077, "callback", newJString(callback))
  add(query_589077, "access_token", newJString(accessToken))
  add(query_589077, "uploadType", newJString(uploadType))
  add(path_589076, "parent", newJString(parent))
  add(query_589077, "key", newJString(key))
  add(query_589077, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_589077, "resolutionStatusCode", newJString(resolutionStatusCode))
  add(query_589077, "$.xgafv", newJString(Xgafv))
  add(query_589077, "pageSize", newJInt(pageSize))
  add(query_589077, "prettyPrint", newJBool(prettyPrint))
  result = call_589075.call(path_589076, query_589077, nil, nil, nil)

var cloudsearchDebugIdentitysourcesUnmappedidsList* = Call_CloudsearchDebugIdentitysourcesUnmappedidsList_589055(
    name: "cloudsearchDebugIdentitysourcesUnmappedidsList",
    meth: HttpMethod.HttpGet, host: "cloudsearch.googleapis.com",
    route: "/v1/debug/{parent}/unmappedids",
    validator: validate_CloudsearchDebugIdentitysourcesUnmappedidsList_589056,
    base: "/", url: url_CloudsearchDebugIdentitysourcesUnmappedidsList_589057,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsGet_589078 = ref object of OpenApiRestCall_588450
proc url_CloudsearchIndexingDatasourcesItemsGet_589080(protocol: Scheme;
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

proc validate_CloudsearchIndexingDatasourcesItemsGet_589079(path: JsonNode;
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
  var valid_589081 = path.getOrDefault("name")
  valid_589081 = validateParameter(valid_589081, JString, required = true,
                                 default = nil)
  if valid_589081 != nil:
    section.add "name", valid_589081
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
  var valid_589082 = query.getOrDefault("upload_protocol")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "upload_protocol", valid_589082
  var valid_589083 = query.getOrDefault("fields")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "fields", valid_589083
  var valid_589084 = query.getOrDefault("quotaUser")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "quotaUser", valid_589084
  var valid_589085 = query.getOrDefault("alt")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = newJString("json"))
  if valid_589085 != nil:
    section.add "alt", valid_589085
  var valid_589086 = query.getOrDefault("oauth_token")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "oauth_token", valid_589086
  var valid_589087 = query.getOrDefault("callback")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "callback", valid_589087
  var valid_589088 = query.getOrDefault("access_token")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "access_token", valid_589088
  var valid_589089 = query.getOrDefault("uploadType")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "uploadType", valid_589089
  var valid_589090 = query.getOrDefault("key")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "key", valid_589090
  var valid_589091 = query.getOrDefault("debugOptions.enableDebugging")
  valid_589091 = validateParameter(valid_589091, JBool, required = false, default = nil)
  if valid_589091 != nil:
    section.add "debugOptions.enableDebugging", valid_589091
  var valid_589092 = query.getOrDefault("$.xgafv")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = newJString("1"))
  if valid_589092 != nil:
    section.add "$.xgafv", valid_589092
  var valid_589093 = query.getOrDefault("prettyPrint")
  valid_589093 = validateParameter(valid_589093, JBool, required = false,
                                 default = newJBool(true))
  if valid_589093 != nil:
    section.add "prettyPrint", valid_589093
  var valid_589094 = query.getOrDefault("connectorName")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "connectorName", valid_589094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589095: Call_CloudsearchIndexingDatasourcesItemsGet_589078;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets Item resource by item name.
  ## 
  let valid = call_589095.validator(path, query, header, formData, body)
  let scheme = call_589095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589095.url(scheme.get, call_589095.host, call_589095.base,
                         call_589095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589095, url, valid)

proc call*(call_589096: Call_CloudsearchIndexingDatasourcesItemsGet_589078;
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
  var path_589097 = newJObject()
  var query_589098 = newJObject()
  add(query_589098, "upload_protocol", newJString(uploadProtocol))
  add(query_589098, "fields", newJString(fields))
  add(query_589098, "quotaUser", newJString(quotaUser))
  add(path_589097, "name", newJString(name))
  add(query_589098, "alt", newJString(alt))
  add(query_589098, "oauth_token", newJString(oauthToken))
  add(query_589098, "callback", newJString(callback))
  add(query_589098, "access_token", newJString(accessToken))
  add(query_589098, "uploadType", newJString(uploadType))
  add(query_589098, "key", newJString(key))
  add(query_589098, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_589098, "$.xgafv", newJString(Xgafv))
  add(query_589098, "prettyPrint", newJBool(prettyPrint))
  add(query_589098, "connectorName", newJString(connectorName))
  result = call_589096.call(path_589097, query_589098, nil, nil, nil)

var cloudsearchIndexingDatasourcesItemsGet* = Call_CloudsearchIndexingDatasourcesItemsGet_589078(
    name: "cloudsearchIndexingDatasourcesItemsGet", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}",
    validator: validate_CloudsearchIndexingDatasourcesItemsGet_589079, base: "/",
    url: url_CloudsearchIndexingDatasourcesItemsGet_589080,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsDelete_589099 = ref object of OpenApiRestCall_588450
proc url_CloudsearchIndexingDatasourcesItemsDelete_589101(protocol: Scheme;
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

proc validate_CloudsearchIndexingDatasourcesItemsDelete_589100(path: JsonNode;
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
  var valid_589102 = path.getOrDefault("name")
  valid_589102 = validateParameter(valid_589102, JString, required = true,
                                 default = nil)
  if valid_589102 != nil:
    section.add "name", valid_589102
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
  var valid_589103 = query.getOrDefault("upload_protocol")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "upload_protocol", valid_589103
  var valid_589104 = query.getOrDefault("fields")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "fields", valid_589104
  var valid_589105 = query.getOrDefault("quotaUser")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "quotaUser", valid_589105
  var valid_589106 = query.getOrDefault("alt")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = newJString("json"))
  if valid_589106 != nil:
    section.add "alt", valid_589106
  var valid_589107 = query.getOrDefault("oauth_token")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "oauth_token", valid_589107
  var valid_589108 = query.getOrDefault("callback")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "callback", valid_589108
  var valid_589109 = query.getOrDefault("access_token")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "access_token", valid_589109
  var valid_589110 = query.getOrDefault("uploadType")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "uploadType", valid_589110
  var valid_589111 = query.getOrDefault("mode")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = newJString("UNSPECIFIED"))
  if valid_589111 != nil:
    section.add "mode", valid_589111
  var valid_589112 = query.getOrDefault("key")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "key", valid_589112
  var valid_589113 = query.getOrDefault("debugOptions.enableDebugging")
  valid_589113 = validateParameter(valid_589113, JBool, required = false, default = nil)
  if valid_589113 != nil:
    section.add "debugOptions.enableDebugging", valid_589113
  var valid_589114 = query.getOrDefault("$.xgafv")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = newJString("1"))
  if valid_589114 != nil:
    section.add "$.xgafv", valid_589114
  var valid_589115 = query.getOrDefault("version")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "version", valid_589115
  var valid_589116 = query.getOrDefault("prettyPrint")
  valid_589116 = validateParameter(valid_589116, JBool, required = false,
                                 default = newJBool(true))
  if valid_589116 != nil:
    section.add "prettyPrint", valid_589116
  var valid_589117 = query.getOrDefault("connectorName")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "connectorName", valid_589117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589118: Call_CloudsearchIndexingDatasourcesItemsDelete_589099;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes Item resource for the
  ## specified resource name.
  ## 
  let valid = call_589118.validator(path, query, header, formData, body)
  let scheme = call_589118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589118.url(scheme.get, call_589118.host, call_589118.base,
                         call_589118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589118, url, valid)

proc call*(call_589119: Call_CloudsearchIndexingDatasourcesItemsDelete_589099;
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
  var path_589120 = newJObject()
  var query_589121 = newJObject()
  add(query_589121, "upload_protocol", newJString(uploadProtocol))
  add(query_589121, "fields", newJString(fields))
  add(query_589121, "quotaUser", newJString(quotaUser))
  add(path_589120, "name", newJString(name))
  add(query_589121, "alt", newJString(alt))
  add(query_589121, "oauth_token", newJString(oauthToken))
  add(query_589121, "callback", newJString(callback))
  add(query_589121, "access_token", newJString(accessToken))
  add(query_589121, "uploadType", newJString(uploadType))
  add(query_589121, "mode", newJString(mode))
  add(query_589121, "key", newJString(key))
  add(query_589121, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_589121, "$.xgafv", newJString(Xgafv))
  add(query_589121, "version", newJString(version))
  add(query_589121, "prettyPrint", newJBool(prettyPrint))
  add(query_589121, "connectorName", newJString(connectorName))
  result = call_589119.call(path_589120, query_589121, nil, nil, nil)

var cloudsearchIndexingDatasourcesItemsDelete* = Call_CloudsearchIndexingDatasourcesItemsDelete_589099(
    name: "cloudsearchIndexingDatasourcesItemsDelete",
    meth: HttpMethod.HttpDelete, host: "cloudsearch.googleapis.com",
    route: "/v1/indexing/{name}",
    validator: validate_CloudsearchIndexingDatasourcesItemsDelete_589100,
    base: "/", url: url_CloudsearchIndexingDatasourcesItemsDelete_589101,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsList_589122 = ref object of OpenApiRestCall_588450
proc url_CloudsearchIndexingDatasourcesItemsList_589124(protocol: Scheme;
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

proc validate_CloudsearchIndexingDatasourcesItemsList_589123(path: JsonNode;
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
  var valid_589125 = path.getOrDefault("name")
  valid_589125 = validateParameter(valid_589125, JString, required = true,
                                 default = nil)
  if valid_589125 != nil:
    section.add "name", valid_589125
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
  var valid_589126 = query.getOrDefault("upload_protocol")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "upload_protocol", valid_589126
  var valid_589127 = query.getOrDefault("fields")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "fields", valid_589127
  var valid_589128 = query.getOrDefault("pageToken")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "pageToken", valid_589128
  var valid_589129 = query.getOrDefault("quotaUser")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "quotaUser", valid_589129
  var valid_589130 = query.getOrDefault("alt")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = newJString("json"))
  if valid_589130 != nil:
    section.add "alt", valid_589130
  var valid_589131 = query.getOrDefault("oauth_token")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "oauth_token", valid_589131
  var valid_589132 = query.getOrDefault("callback")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "callback", valid_589132
  var valid_589133 = query.getOrDefault("access_token")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "access_token", valid_589133
  var valid_589134 = query.getOrDefault("uploadType")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "uploadType", valid_589134
  var valid_589135 = query.getOrDefault("key")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "key", valid_589135
  var valid_589136 = query.getOrDefault("brief")
  valid_589136 = validateParameter(valid_589136, JBool, required = false, default = nil)
  if valid_589136 != nil:
    section.add "brief", valid_589136
  var valid_589137 = query.getOrDefault("debugOptions.enableDebugging")
  valid_589137 = validateParameter(valid_589137, JBool, required = false, default = nil)
  if valid_589137 != nil:
    section.add "debugOptions.enableDebugging", valid_589137
  var valid_589138 = query.getOrDefault("$.xgafv")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = newJString("1"))
  if valid_589138 != nil:
    section.add "$.xgafv", valid_589138
  var valid_589139 = query.getOrDefault("pageSize")
  valid_589139 = validateParameter(valid_589139, JInt, required = false, default = nil)
  if valid_589139 != nil:
    section.add "pageSize", valid_589139
  var valid_589140 = query.getOrDefault("prettyPrint")
  valid_589140 = validateParameter(valid_589140, JBool, required = false,
                                 default = newJBool(true))
  if valid_589140 != nil:
    section.add "prettyPrint", valid_589140
  var valid_589141 = query.getOrDefault("connectorName")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "connectorName", valid_589141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589142: Call_CloudsearchIndexingDatasourcesItemsList_589122;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all or a subset of Item resources.
  ## 
  let valid = call_589142.validator(path, query, header, formData, body)
  let scheme = call_589142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589142.url(scheme.get, call_589142.host, call_589142.base,
                         call_589142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589142, url, valid)

proc call*(call_589143: Call_CloudsearchIndexingDatasourcesItemsList_589122;
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
  var path_589144 = newJObject()
  var query_589145 = newJObject()
  add(query_589145, "upload_protocol", newJString(uploadProtocol))
  add(query_589145, "fields", newJString(fields))
  add(query_589145, "pageToken", newJString(pageToken))
  add(query_589145, "quotaUser", newJString(quotaUser))
  add(path_589144, "name", newJString(name))
  add(query_589145, "alt", newJString(alt))
  add(query_589145, "oauth_token", newJString(oauthToken))
  add(query_589145, "callback", newJString(callback))
  add(query_589145, "access_token", newJString(accessToken))
  add(query_589145, "uploadType", newJString(uploadType))
  add(query_589145, "key", newJString(key))
  add(query_589145, "brief", newJBool(brief))
  add(query_589145, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_589145, "$.xgafv", newJString(Xgafv))
  add(query_589145, "pageSize", newJInt(pageSize))
  add(query_589145, "prettyPrint", newJBool(prettyPrint))
  add(query_589145, "connectorName", newJString(connectorName))
  result = call_589143.call(path_589144, query_589145, nil, nil, nil)

var cloudsearchIndexingDatasourcesItemsList* = Call_CloudsearchIndexingDatasourcesItemsList_589122(
    name: "cloudsearchIndexingDatasourcesItemsList", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}/items",
    validator: validate_CloudsearchIndexingDatasourcesItemsList_589123, base: "/",
    url: url_CloudsearchIndexingDatasourcesItemsList_589124,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_589146 = ref object of OpenApiRestCall_588450
proc url_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_589148(
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

proc validate_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_589147(
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
  var valid_589149 = path.getOrDefault("name")
  valid_589149 = validateParameter(valid_589149, JString, required = true,
                                 default = nil)
  if valid_589149 != nil:
    section.add "name", valid_589149
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
  var valid_589150 = query.getOrDefault("upload_protocol")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "upload_protocol", valid_589150
  var valid_589151 = query.getOrDefault("fields")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "fields", valid_589151
  var valid_589152 = query.getOrDefault("quotaUser")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "quotaUser", valid_589152
  var valid_589153 = query.getOrDefault("alt")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = newJString("json"))
  if valid_589153 != nil:
    section.add "alt", valid_589153
  var valid_589154 = query.getOrDefault("oauth_token")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "oauth_token", valid_589154
  var valid_589155 = query.getOrDefault("callback")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "callback", valid_589155
  var valid_589156 = query.getOrDefault("access_token")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "access_token", valid_589156
  var valid_589157 = query.getOrDefault("uploadType")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "uploadType", valid_589157
  var valid_589158 = query.getOrDefault("key")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "key", valid_589158
  var valid_589159 = query.getOrDefault("$.xgafv")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = newJString("1"))
  if valid_589159 != nil:
    section.add "$.xgafv", valid_589159
  var valid_589160 = query.getOrDefault("prettyPrint")
  valid_589160 = validateParameter(valid_589160, JBool, required = false,
                                 default = newJBool(true))
  if valid_589160 != nil:
    section.add "prettyPrint", valid_589160
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

proc call*(call_589162: Call_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_589146;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all items in a queue. This method is useful for deleting stale
  ## items.
  ## 
  let valid = call_589162.validator(path, query, header, formData, body)
  let scheme = call_589162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589162.url(scheme.get, call_589162.host, call_589162.base,
                         call_589162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589162, url, valid)

proc call*(call_589163: Call_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_589146;
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
  var path_589164 = newJObject()
  var query_589165 = newJObject()
  var body_589166 = newJObject()
  add(query_589165, "upload_protocol", newJString(uploadProtocol))
  add(query_589165, "fields", newJString(fields))
  add(query_589165, "quotaUser", newJString(quotaUser))
  add(path_589164, "name", newJString(name))
  add(query_589165, "alt", newJString(alt))
  add(query_589165, "oauth_token", newJString(oauthToken))
  add(query_589165, "callback", newJString(callback))
  add(query_589165, "access_token", newJString(accessToken))
  add(query_589165, "uploadType", newJString(uploadType))
  add(query_589165, "key", newJString(key))
  add(query_589165, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589166 = body
  add(query_589165, "prettyPrint", newJBool(prettyPrint))
  result = call_589163.call(path_589164, query_589165, nil, nil, body_589166)

var cloudsearchIndexingDatasourcesItemsDeleteQueueItems* = Call_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_589146(
    name: "cloudsearchIndexingDatasourcesItemsDeleteQueueItems",
    meth: HttpMethod.HttpPost, host: "cloudsearch.googleapis.com",
    route: "/v1/indexing/{name}/items:deleteQueueItems",
    validator: validate_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_589147,
    base: "/", url: url_CloudsearchIndexingDatasourcesItemsDeleteQueueItems_589148,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsPoll_589167 = ref object of OpenApiRestCall_588450
proc url_CloudsearchIndexingDatasourcesItemsPoll_589169(protocol: Scheme;
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

proc validate_CloudsearchIndexingDatasourcesItemsPoll_589168(path: JsonNode;
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
  var valid_589170 = path.getOrDefault("name")
  valid_589170 = validateParameter(valid_589170, JString, required = true,
                                 default = nil)
  if valid_589170 != nil:
    section.add "name", valid_589170
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
  var valid_589171 = query.getOrDefault("upload_protocol")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "upload_protocol", valid_589171
  var valid_589172 = query.getOrDefault("fields")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "fields", valid_589172
  var valid_589173 = query.getOrDefault("quotaUser")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "quotaUser", valid_589173
  var valid_589174 = query.getOrDefault("alt")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = newJString("json"))
  if valid_589174 != nil:
    section.add "alt", valid_589174
  var valid_589175 = query.getOrDefault("oauth_token")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "oauth_token", valid_589175
  var valid_589176 = query.getOrDefault("callback")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "callback", valid_589176
  var valid_589177 = query.getOrDefault("access_token")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "access_token", valid_589177
  var valid_589178 = query.getOrDefault("uploadType")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "uploadType", valid_589178
  var valid_589179 = query.getOrDefault("key")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "key", valid_589179
  var valid_589180 = query.getOrDefault("$.xgafv")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = newJString("1"))
  if valid_589180 != nil:
    section.add "$.xgafv", valid_589180
  var valid_589181 = query.getOrDefault("prettyPrint")
  valid_589181 = validateParameter(valid_589181, JBool, required = false,
                                 default = newJBool(true))
  if valid_589181 != nil:
    section.add "prettyPrint", valid_589181
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

proc call*(call_589183: Call_CloudsearchIndexingDatasourcesItemsPoll_589167;
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
  let valid = call_589183.validator(path, query, header, formData, body)
  let scheme = call_589183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589183.url(scheme.get, call_589183.host, call_589183.base,
                         call_589183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589183, url, valid)

proc call*(call_589184: Call_CloudsearchIndexingDatasourcesItemsPoll_589167;
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
  var path_589185 = newJObject()
  var query_589186 = newJObject()
  var body_589187 = newJObject()
  add(query_589186, "upload_protocol", newJString(uploadProtocol))
  add(query_589186, "fields", newJString(fields))
  add(query_589186, "quotaUser", newJString(quotaUser))
  add(path_589185, "name", newJString(name))
  add(query_589186, "alt", newJString(alt))
  add(query_589186, "oauth_token", newJString(oauthToken))
  add(query_589186, "callback", newJString(callback))
  add(query_589186, "access_token", newJString(accessToken))
  add(query_589186, "uploadType", newJString(uploadType))
  add(query_589186, "key", newJString(key))
  add(query_589186, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589187 = body
  add(query_589186, "prettyPrint", newJBool(prettyPrint))
  result = call_589184.call(path_589185, query_589186, nil, nil, body_589187)

var cloudsearchIndexingDatasourcesItemsPoll* = Call_CloudsearchIndexingDatasourcesItemsPoll_589167(
    name: "cloudsearchIndexingDatasourcesItemsPoll", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}/items:poll",
    validator: validate_CloudsearchIndexingDatasourcesItemsPoll_589168, base: "/",
    url: url_CloudsearchIndexingDatasourcesItemsPoll_589169,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsUnreserve_589188 = ref object of OpenApiRestCall_588450
proc url_CloudsearchIndexingDatasourcesItemsUnreserve_589190(protocol: Scheme;
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

proc validate_CloudsearchIndexingDatasourcesItemsUnreserve_589189(path: JsonNode;
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
  var valid_589191 = path.getOrDefault("name")
  valid_589191 = validateParameter(valid_589191, JString, required = true,
                                 default = nil)
  if valid_589191 != nil:
    section.add "name", valid_589191
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
  var valid_589192 = query.getOrDefault("upload_protocol")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "upload_protocol", valid_589192
  var valid_589193 = query.getOrDefault("fields")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "fields", valid_589193
  var valid_589194 = query.getOrDefault("quotaUser")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "quotaUser", valid_589194
  var valid_589195 = query.getOrDefault("alt")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = newJString("json"))
  if valid_589195 != nil:
    section.add "alt", valid_589195
  var valid_589196 = query.getOrDefault("oauth_token")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "oauth_token", valid_589196
  var valid_589197 = query.getOrDefault("callback")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "callback", valid_589197
  var valid_589198 = query.getOrDefault("access_token")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "access_token", valid_589198
  var valid_589199 = query.getOrDefault("uploadType")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "uploadType", valid_589199
  var valid_589200 = query.getOrDefault("key")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "key", valid_589200
  var valid_589201 = query.getOrDefault("$.xgafv")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = newJString("1"))
  if valid_589201 != nil:
    section.add "$.xgafv", valid_589201
  var valid_589202 = query.getOrDefault("prettyPrint")
  valid_589202 = validateParameter(valid_589202, JBool, required = false,
                                 default = newJBool(true))
  if valid_589202 != nil:
    section.add "prettyPrint", valid_589202
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

proc call*(call_589204: Call_CloudsearchIndexingDatasourcesItemsUnreserve_589188;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unreserves all items from a queue, making them all eligible to be
  ## polled.  This method is useful for resetting the indexing queue
  ## after a connector has been restarted.
  ## 
  let valid = call_589204.validator(path, query, header, formData, body)
  let scheme = call_589204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589204.url(scheme.get, call_589204.host, call_589204.base,
                         call_589204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589204, url, valid)

proc call*(call_589205: Call_CloudsearchIndexingDatasourcesItemsUnreserve_589188;
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
  var path_589206 = newJObject()
  var query_589207 = newJObject()
  var body_589208 = newJObject()
  add(query_589207, "upload_protocol", newJString(uploadProtocol))
  add(query_589207, "fields", newJString(fields))
  add(query_589207, "quotaUser", newJString(quotaUser))
  add(path_589206, "name", newJString(name))
  add(query_589207, "alt", newJString(alt))
  add(query_589207, "oauth_token", newJString(oauthToken))
  add(query_589207, "callback", newJString(callback))
  add(query_589207, "access_token", newJString(accessToken))
  add(query_589207, "uploadType", newJString(uploadType))
  add(query_589207, "key", newJString(key))
  add(query_589207, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589208 = body
  add(query_589207, "prettyPrint", newJBool(prettyPrint))
  result = call_589205.call(path_589206, query_589207, nil, nil, body_589208)

var cloudsearchIndexingDatasourcesItemsUnreserve* = Call_CloudsearchIndexingDatasourcesItemsUnreserve_589188(
    name: "cloudsearchIndexingDatasourcesItemsUnreserve",
    meth: HttpMethod.HttpPost, host: "cloudsearch.googleapis.com",
    route: "/v1/indexing/{name}/items:unreserve",
    validator: validate_CloudsearchIndexingDatasourcesItemsUnreserve_589189,
    base: "/", url: url_CloudsearchIndexingDatasourcesItemsUnreserve_589190,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesUpdateSchema_589229 = ref object of OpenApiRestCall_588450
proc url_CloudsearchIndexingDatasourcesUpdateSchema_589231(protocol: Scheme;
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

proc validate_CloudsearchIndexingDatasourcesUpdateSchema_589230(path: JsonNode;
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
  var valid_589232 = path.getOrDefault("name")
  valid_589232 = validateParameter(valid_589232, JString, required = true,
                                 default = nil)
  if valid_589232 != nil:
    section.add "name", valid_589232
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
  var valid_589233 = query.getOrDefault("upload_protocol")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = nil)
  if valid_589233 != nil:
    section.add "upload_protocol", valid_589233
  var valid_589234 = query.getOrDefault("fields")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "fields", valid_589234
  var valid_589235 = query.getOrDefault("quotaUser")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = nil)
  if valid_589235 != nil:
    section.add "quotaUser", valid_589235
  var valid_589236 = query.getOrDefault("alt")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = newJString("json"))
  if valid_589236 != nil:
    section.add "alt", valid_589236
  var valid_589237 = query.getOrDefault("oauth_token")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "oauth_token", valid_589237
  var valid_589238 = query.getOrDefault("callback")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "callback", valid_589238
  var valid_589239 = query.getOrDefault("access_token")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = nil)
  if valid_589239 != nil:
    section.add "access_token", valid_589239
  var valid_589240 = query.getOrDefault("uploadType")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = nil)
  if valid_589240 != nil:
    section.add "uploadType", valid_589240
  var valid_589241 = query.getOrDefault("key")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "key", valid_589241
  var valid_589242 = query.getOrDefault("$.xgafv")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = newJString("1"))
  if valid_589242 != nil:
    section.add "$.xgafv", valid_589242
  var valid_589243 = query.getOrDefault("prettyPrint")
  valid_589243 = validateParameter(valid_589243, JBool, required = false,
                                 default = newJBool(true))
  if valid_589243 != nil:
    section.add "prettyPrint", valid_589243
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

proc call*(call_589245: Call_CloudsearchIndexingDatasourcesUpdateSchema_589229;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the schema of a data source.
  ## 
  let valid = call_589245.validator(path, query, header, formData, body)
  let scheme = call_589245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589245.url(scheme.get, call_589245.host, call_589245.base,
                         call_589245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589245, url, valid)

proc call*(call_589246: Call_CloudsearchIndexingDatasourcesUpdateSchema_589229;
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
  var path_589247 = newJObject()
  var query_589248 = newJObject()
  var body_589249 = newJObject()
  add(query_589248, "upload_protocol", newJString(uploadProtocol))
  add(query_589248, "fields", newJString(fields))
  add(query_589248, "quotaUser", newJString(quotaUser))
  add(path_589247, "name", newJString(name))
  add(query_589248, "alt", newJString(alt))
  add(query_589248, "oauth_token", newJString(oauthToken))
  add(query_589248, "callback", newJString(callback))
  add(query_589248, "access_token", newJString(accessToken))
  add(query_589248, "uploadType", newJString(uploadType))
  add(query_589248, "key", newJString(key))
  add(query_589248, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589249 = body
  add(query_589248, "prettyPrint", newJBool(prettyPrint))
  result = call_589246.call(path_589247, query_589248, nil, nil, body_589249)

var cloudsearchIndexingDatasourcesUpdateSchema* = Call_CloudsearchIndexingDatasourcesUpdateSchema_589229(
    name: "cloudsearchIndexingDatasourcesUpdateSchema", meth: HttpMethod.HttpPut,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}/schema",
    validator: validate_CloudsearchIndexingDatasourcesUpdateSchema_589230,
    base: "/", url: url_CloudsearchIndexingDatasourcesUpdateSchema_589231,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesGetSchema_589209 = ref object of OpenApiRestCall_588450
proc url_CloudsearchIndexingDatasourcesGetSchema_589211(protocol: Scheme;
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

proc validate_CloudsearchIndexingDatasourcesGetSchema_589210(path: JsonNode;
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
  var valid_589212 = path.getOrDefault("name")
  valid_589212 = validateParameter(valid_589212, JString, required = true,
                                 default = nil)
  if valid_589212 != nil:
    section.add "name", valid_589212
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
  var valid_589213 = query.getOrDefault("upload_protocol")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "upload_protocol", valid_589213
  var valid_589214 = query.getOrDefault("fields")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "fields", valid_589214
  var valid_589215 = query.getOrDefault("quotaUser")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "quotaUser", valid_589215
  var valid_589216 = query.getOrDefault("alt")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = newJString("json"))
  if valid_589216 != nil:
    section.add "alt", valid_589216
  var valid_589217 = query.getOrDefault("oauth_token")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = nil)
  if valid_589217 != nil:
    section.add "oauth_token", valid_589217
  var valid_589218 = query.getOrDefault("callback")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "callback", valid_589218
  var valid_589219 = query.getOrDefault("access_token")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "access_token", valid_589219
  var valid_589220 = query.getOrDefault("uploadType")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "uploadType", valid_589220
  var valid_589221 = query.getOrDefault("key")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "key", valid_589221
  var valid_589222 = query.getOrDefault("debugOptions.enableDebugging")
  valid_589222 = validateParameter(valid_589222, JBool, required = false, default = nil)
  if valid_589222 != nil:
    section.add "debugOptions.enableDebugging", valid_589222
  var valid_589223 = query.getOrDefault("$.xgafv")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = newJString("1"))
  if valid_589223 != nil:
    section.add "$.xgafv", valid_589223
  var valid_589224 = query.getOrDefault("prettyPrint")
  valid_589224 = validateParameter(valid_589224, JBool, required = false,
                                 default = newJBool(true))
  if valid_589224 != nil:
    section.add "prettyPrint", valid_589224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589225: Call_CloudsearchIndexingDatasourcesGetSchema_589209;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the schema of a data source.
  ## 
  let valid = call_589225.validator(path, query, header, formData, body)
  let scheme = call_589225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589225.url(scheme.get, call_589225.host, call_589225.base,
                         call_589225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589225, url, valid)

proc call*(call_589226: Call_CloudsearchIndexingDatasourcesGetSchema_589209;
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
  var path_589227 = newJObject()
  var query_589228 = newJObject()
  add(query_589228, "upload_protocol", newJString(uploadProtocol))
  add(query_589228, "fields", newJString(fields))
  add(query_589228, "quotaUser", newJString(quotaUser))
  add(path_589227, "name", newJString(name))
  add(query_589228, "alt", newJString(alt))
  add(query_589228, "oauth_token", newJString(oauthToken))
  add(query_589228, "callback", newJString(callback))
  add(query_589228, "access_token", newJString(accessToken))
  add(query_589228, "uploadType", newJString(uploadType))
  add(query_589228, "key", newJString(key))
  add(query_589228, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_589228, "$.xgafv", newJString(Xgafv))
  add(query_589228, "prettyPrint", newJBool(prettyPrint))
  result = call_589226.call(path_589227, query_589228, nil, nil, nil)

var cloudsearchIndexingDatasourcesGetSchema* = Call_CloudsearchIndexingDatasourcesGetSchema_589209(
    name: "cloudsearchIndexingDatasourcesGetSchema", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}/schema",
    validator: validate_CloudsearchIndexingDatasourcesGetSchema_589210, base: "/",
    url: url_CloudsearchIndexingDatasourcesGetSchema_589211,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesDeleteSchema_589250 = ref object of OpenApiRestCall_588450
proc url_CloudsearchIndexingDatasourcesDeleteSchema_589252(protocol: Scheme;
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

proc validate_CloudsearchIndexingDatasourcesDeleteSchema_589251(path: JsonNode;
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
  var valid_589253 = path.getOrDefault("name")
  valid_589253 = validateParameter(valid_589253, JString, required = true,
                                 default = nil)
  if valid_589253 != nil:
    section.add "name", valid_589253
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
  var valid_589254 = query.getOrDefault("upload_protocol")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = nil)
  if valid_589254 != nil:
    section.add "upload_protocol", valid_589254
  var valid_589255 = query.getOrDefault("fields")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = nil)
  if valid_589255 != nil:
    section.add "fields", valid_589255
  var valid_589256 = query.getOrDefault("quotaUser")
  valid_589256 = validateParameter(valid_589256, JString, required = false,
                                 default = nil)
  if valid_589256 != nil:
    section.add "quotaUser", valid_589256
  var valid_589257 = query.getOrDefault("alt")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = newJString("json"))
  if valid_589257 != nil:
    section.add "alt", valid_589257
  var valid_589258 = query.getOrDefault("oauth_token")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "oauth_token", valid_589258
  var valid_589259 = query.getOrDefault("callback")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = nil)
  if valid_589259 != nil:
    section.add "callback", valid_589259
  var valid_589260 = query.getOrDefault("access_token")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = nil)
  if valid_589260 != nil:
    section.add "access_token", valid_589260
  var valid_589261 = query.getOrDefault("uploadType")
  valid_589261 = validateParameter(valid_589261, JString, required = false,
                                 default = nil)
  if valid_589261 != nil:
    section.add "uploadType", valid_589261
  var valid_589262 = query.getOrDefault("key")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = nil)
  if valid_589262 != nil:
    section.add "key", valid_589262
  var valid_589263 = query.getOrDefault("debugOptions.enableDebugging")
  valid_589263 = validateParameter(valid_589263, JBool, required = false, default = nil)
  if valid_589263 != nil:
    section.add "debugOptions.enableDebugging", valid_589263
  var valid_589264 = query.getOrDefault("$.xgafv")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = newJString("1"))
  if valid_589264 != nil:
    section.add "$.xgafv", valid_589264
  var valid_589265 = query.getOrDefault("prettyPrint")
  valid_589265 = validateParameter(valid_589265, JBool, required = false,
                                 default = newJBool(true))
  if valid_589265 != nil:
    section.add "prettyPrint", valid_589265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589266: Call_CloudsearchIndexingDatasourcesDeleteSchema_589250;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the schema of a data source.
  ## 
  let valid = call_589266.validator(path, query, header, formData, body)
  let scheme = call_589266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589266.url(scheme.get, call_589266.host, call_589266.base,
                         call_589266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589266, url, valid)

proc call*(call_589267: Call_CloudsearchIndexingDatasourcesDeleteSchema_589250;
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
  var path_589268 = newJObject()
  var query_589269 = newJObject()
  add(query_589269, "upload_protocol", newJString(uploadProtocol))
  add(query_589269, "fields", newJString(fields))
  add(query_589269, "quotaUser", newJString(quotaUser))
  add(path_589268, "name", newJString(name))
  add(query_589269, "alt", newJString(alt))
  add(query_589269, "oauth_token", newJString(oauthToken))
  add(query_589269, "callback", newJString(callback))
  add(query_589269, "access_token", newJString(accessToken))
  add(query_589269, "uploadType", newJString(uploadType))
  add(query_589269, "key", newJString(key))
  add(query_589269, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_589269, "$.xgafv", newJString(Xgafv))
  add(query_589269, "prettyPrint", newJBool(prettyPrint))
  result = call_589267.call(path_589268, query_589269, nil, nil, nil)

var cloudsearchIndexingDatasourcesDeleteSchema* = Call_CloudsearchIndexingDatasourcesDeleteSchema_589250(
    name: "cloudsearchIndexingDatasourcesDeleteSchema",
    meth: HttpMethod.HttpDelete, host: "cloudsearch.googleapis.com",
    route: "/v1/indexing/{name}/schema",
    validator: validate_CloudsearchIndexingDatasourcesDeleteSchema_589251,
    base: "/", url: url_CloudsearchIndexingDatasourcesDeleteSchema_589252,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsIndex_589270 = ref object of OpenApiRestCall_588450
proc url_CloudsearchIndexingDatasourcesItemsIndex_589272(protocol: Scheme;
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

proc validate_CloudsearchIndexingDatasourcesItemsIndex_589271(path: JsonNode;
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
  var valid_589273 = path.getOrDefault("name")
  valid_589273 = validateParameter(valid_589273, JString, required = true,
                                 default = nil)
  if valid_589273 != nil:
    section.add "name", valid_589273
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
  var valid_589274 = query.getOrDefault("upload_protocol")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = nil)
  if valid_589274 != nil:
    section.add "upload_protocol", valid_589274
  var valid_589275 = query.getOrDefault("fields")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "fields", valid_589275
  var valid_589276 = query.getOrDefault("quotaUser")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = nil)
  if valid_589276 != nil:
    section.add "quotaUser", valid_589276
  var valid_589277 = query.getOrDefault("alt")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = newJString("json"))
  if valid_589277 != nil:
    section.add "alt", valid_589277
  var valid_589278 = query.getOrDefault("oauth_token")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = nil)
  if valid_589278 != nil:
    section.add "oauth_token", valid_589278
  var valid_589279 = query.getOrDefault("callback")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "callback", valid_589279
  var valid_589280 = query.getOrDefault("access_token")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = nil)
  if valid_589280 != nil:
    section.add "access_token", valid_589280
  var valid_589281 = query.getOrDefault("uploadType")
  valid_589281 = validateParameter(valid_589281, JString, required = false,
                                 default = nil)
  if valid_589281 != nil:
    section.add "uploadType", valid_589281
  var valid_589282 = query.getOrDefault("key")
  valid_589282 = validateParameter(valid_589282, JString, required = false,
                                 default = nil)
  if valid_589282 != nil:
    section.add "key", valid_589282
  var valid_589283 = query.getOrDefault("$.xgafv")
  valid_589283 = validateParameter(valid_589283, JString, required = false,
                                 default = newJString("1"))
  if valid_589283 != nil:
    section.add "$.xgafv", valid_589283
  var valid_589284 = query.getOrDefault("prettyPrint")
  valid_589284 = validateParameter(valid_589284, JBool, required = false,
                                 default = newJBool(true))
  if valid_589284 != nil:
    section.add "prettyPrint", valid_589284
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

proc call*(call_589286: Call_CloudsearchIndexingDatasourcesItemsIndex_589270;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates Item ACL, metadata, and
  ## content. It will insert the Item if it
  ## does not exist.
  ## This method does not support partial updates.  Fields with no provided
  ## values are cleared out in the Cloud Search index.
  ## 
  let valid = call_589286.validator(path, query, header, formData, body)
  let scheme = call_589286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589286.url(scheme.get, call_589286.host, call_589286.base,
                         call_589286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589286, url, valid)

proc call*(call_589287: Call_CloudsearchIndexingDatasourcesItemsIndex_589270;
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
  var path_589288 = newJObject()
  var query_589289 = newJObject()
  var body_589290 = newJObject()
  add(query_589289, "upload_protocol", newJString(uploadProtocol))
  add(query_589289, "fields", newJString(fields))
  add(query_589289, "quotaUser", newJString(quotaUser))
  add(path_589288, "name", newJString(name))
  add(query_589289, "alt", newJString(alt))
  add(query_589289, "oauth_token", newJString(oauthToken))
  add(query_589289, "callback", newJString(callback))
  add(query_589289, "access_token", newJString(accessToken))
  add(query_589289, "uploadType", newJString(uploadType))
  add(query_589289, "key", newJString(key))
  add(query_589289, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589290 = body
  add(query_589289, "prettyPrint", newJBool(prettyPrint))
  result = call_589287.call(path_589288, query_589289, nil, nil, body_589290)

var cloudsearchIndexingDatasourcesItemsIndex* = Call_CloudsearchIndexingDatasourcesItemsIndex_589270(
    name: "cloudsearchIndexingDatasourcesItemsIndex", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}:index",
    validator: validate_CloudsearchIndexingDatasourcesItemsIndex_589271,
    base: "/", url: url_CloudsearchIndexingDatasourcesItemsIndex_589272,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsPush_589291 = ref object of OpenApiRestCall_588450
proc url_CloudsearchIndexingDatasourcesItemsPush_589293(protocol: Scheme;
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

proc validate_CloudsearchIndexingDatasourcesItemsPush_589292(path: JsonNode;
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
  var valid_589294 = path.getOrDefault("name")
  valid_589294 = validateParameter(valid_589294, JString, required = true,
                                 default = nil)
  if valid_589294 != nil:
    section.add "name", valid_589294
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
  var valid_589295 = query.getOrDefault("upload_protocol")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "upload_protocol", valid_589295
  var valid_589296 = query.getOrDefault("fields")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "fields", valid_589296
  var valid_589297 = query.getOrDefault("quotaUser")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = nil)
  if valid_589297 != nil:
    section.add "quotaUser", valid_589297
  var valid_589298 = query.getOrDefault("alt")
  valid_589298 = validateParameter(valid_589298, JString, required = false,
                                 default = newJString("json"))
  if valid_589298 != nil:
    section.add "alt", valid_589298
  var valid_589299 = query.getOrDefault("oauth_token")
  valid_589299 = validateParameter(valid_589299, JString, required = false,
                                 default = nil)
  if valid_589299 != nil:
    section.add "oauth_token", valid_589299
  var valid_589300 = query.getOrDefault("callback")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = nil)
  if valid_589300 != nil:
    section.add "callback", valid_589300
  var valid_589301 = query.getOrDefault("access_token")
  valid_589301 = validateParameter(valid_589301, JString, required = false,
                                 default = nil)
  if valid_589301 != nil:
    section.add "access_token", valid_589301
  var valid_589302 = query.getOrDefault("uploadType")
  valid_589302 = validateParameter(valid_589302, JString, required = false,
                                 default = nil)
  if valid_589302 != nil:
    section.add "uploadType", valid_589302
  var valid_589303 = query.getOrDefault("key")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = nil)
  if valid_589303 != nil:
    section.add "key", valid_589303
  var valid_589304 = query.getOrDefault("$.xgafv")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = newJString("1"))
  if valid_589304 != nil:
    section.add "$.xgafv", valid_589304
  var valid_589305 = query.getOrDefault("prettyPrint")
  valid_589305 = validateParameter(valid_589305, JBool, required = false,
                                 default = newJBool(true))
  if valid_589305 != nil:
    section.add "prettyPrint", valid_589305
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

proc call*(call_589307: Call_CloudsearchIndexingDatasourcesItemsPush_589291;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Pushes an item onto a queue for later polling and updating.
  ## 
  let valid = call_589307.validator(path, query, header, formData, body)
  let scheme = call_589307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589307.url(scheme.get, call_589307.host, call_589307.base,
                         call_589307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589307, url, valid)

proc call*(call_589308: Call_CloudsearchIndexingDatasourcesItemsPush_589291;
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
  var path_589309 = newJObject()
  var query_589310 = newJObject()
  var body_589311 = newJObject()
  add(query_589310, "upload_protocol", newJString(uploadProtocol))
  add(query_589310, "fields", newJString(fields))
  add(query_589310, "quotaUser", newJString(quotaUser))
  add(path_589309, "name", newJString(name))
  add(query_589310, "alt", newJString(alt))
  add(query_589310, "oauth_token", newJString(oauthToken))
  add(query_589310, "callback", newJString(callback))
  add(query_589310, "access_token", newJString(accessToken))
  add(query_589310, "uploadType", newJString(uploadType))
  add(query_589310, "key", newJString(key))
  add(query_589310, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589311 = body
  add(query_589310, "prettyPrint", newJBool(prettyPrint))
  result = call_589308.call(path_589309, query_589310, nil, nil, body_589311)

var cloudsearchIndexingDatasourcesItemsPush* = Call_CloudsearchIndexingDatasourcesItemsPush_589291(
    name: "cloudsearchIndexingDatasourcesItemsPush", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}:push",
    validator: validate_CloudsearchIndexingDatasourcesItemsPush_589292, base: "/",
    url: url_CloudsearchIndexingDatasourcesItemsPush_589293,
    schemes: {Scheme.Https})
type
  Call_CloudsearchIndexingDatasourcesItemsUpload_589312 = ref object of OpenApiRestCall_588450
proc url_CloudsearchIndexingDatasourcesItemsUpload_589314(protocol: Scheme;
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

proc validate_CloudsearchIndexingDatasourcesItemsUpload_589313(path: JsonNode;
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
  var valid_589315 = path.getOrDefault("name")
  valid_589315 = validateParameter(valid_589315, JString, required = true,
                                 default = nil)
  if valid_589315 != nil:
    section.add "name", valid_589315
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
  var valid_589316 = query.getOrDefault("upload_protocol")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "upload_protocol", valid_589316
  var valid_589317 = query.getOrDefault("fields")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = nil)
  if valid_589317 != nil:
    section.add "fields", valid_589317
  var valid_589318 = query.getOrDefault("quotaUser")
  valid_589318 = validateParameter(valid_589318, JString, required = false,
                                 default = nil)
  if valid_589318 != nil:
    section.add "quotaUser", valid_589318
  var valid_589319 = query.getOrDefault("alt")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = newJString("json"))
  if valid_589319 != nil:
    section.add "alt", valid_589319
  var valid_589320 = query.getOrDefault("oauth_token")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "oauth_token", valid_589320
  var valid_589321 = query.getOrDefault("callback")
  valid_589321 = validateParameter(valid_589321, JString, required = false,
                                 default = nil)
  if valid_589321 != nil:
    section.add "callback", valid_589321
  var valid_589322 = query.getOrDefault("access_token")
  valid_589322 = validateParameter(valid_589322, JString, required = false,
                                 default = nil)
  if valid_589322 != nil:
    section.add "access_token", valid_589322
  var valid_589323 = query.getOrDefault("uploadType")
  valid_589323 = validateParameter(valid_589323, JString, required = false,
                                 default = nil)
  if valid_589323 != nil:
    section.add "uploadType", valid_589323
  var valid_589324 = query.getOrDefault("key")
  valid_589324 = validateParameter(valid_589324, JString, required = false,
                                 default = nil)
  if valid_589324 != nil:
    section.add "key", valid_589324
  var valid_589325 = query.getOrDefault("$.xgafv")
  valid_589325 = validateParameter(valid_589325, JString, required = false,
                                 default = newJString("1"))
  if valid_589325 != nil:
    section.add "$.xgafv", valid_589325
  var valid_589326 = query.getOrDefault("prettyPrint")
  valid_589326 = validateParameter(valid_589326, JBool, required = false,
                                 default = newJBool(true))
  if valid_589326 != nil:
    section.add "prettyPrint", valid_589326
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

proc call*(call_589328: Call_CloudsearchIndexingDatasourcesItemsUpload_589312;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an upload session for uploading item content. For items smaller
  ## than 100 KB, it's easier to embed the content
  ## inline within
  ## an index request.
  ## 
  let valid = call_589328.validator(path, query, header, formData, body)
  let scheme = call_589328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589328.url(scheme.get, call_589328.host, call_589328.base,
                         call_589328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589328, url, valid)

proc call*(call_589329: Call_CloudsearchIndexingDatasourcesItemsUpload_589312;
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
  var path_589330 = newJObject()
  var query_589331 = newJObject()
  var body_589332 = newJObject()
  add(query_589331, "upload_protocol", newJString(uploadProtocol))
  add(query_589331, "fields", newJString(fields))
  add(query_589331, "quotaUser", newJString(quotaUser))
  add(path_589330, "name", newJString(name))
  add(query_589331, "alt", newJString(alt))
  add(query_589331, "oauth_token", newJString(oauthToken))
  add(query_589331, "callback", newJString(callback))
  add(query_589331, "access_token", newJString(accessToken))
  add(query_589331, "uploadType", newJString(uploadType))
  add(query_589331, "key", newJString(key))
  add(query_589331, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589332 = body
  add(query_589331, "prettyPrint", newJBool(prettyPrint))
  result = call_589329.call(path_589330, query_589331, nil, nil, body_589332)

var cloudsearchIndexingDatasourcesItemsUpload* = Call_CloudsearchIndexingDatasourcesItemsUpload_589312(
    name: "cloudsearchIndexingDatasourcesItemsUpload", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/indexing/{name}:upload",
    validator: validate_CloudsearchIndexingDatasourcesItemsUpload_589313,
    base: "/", url: url_CloudsearchIndexingDatasourcesItemsUpload_589314,
    schemes: {Scheme.Https})
type
  Call_CloudsearchMediaUpload_589333 = ref object of OpenApiRestCall_588450
proc url_CloudsearchMediaUpload_589335(protocol: Scheme; host: string; base: string;
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

proc validate_CloudsearchMediaUpload_589334(path: JsonNode; query: JsonNode;
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
  var valid_589336 = path.getOrDefault("resourceName")
  valid_589336 = validateParameter(valid_589336, JString, required = true,
                                 default = nil)
  if valid_589336 != nil:
    section.add "resourceName", valid_589336
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
  var valid_589337 = query.getOrDefault("upload_protocol")
  valid_589337 = validateParameter(valid_589337, JString, required = false,
                                 default = nil)
  if valid_589337 != nil:
    section.add "upload_protocol", valid_589337
  var valid_589338 = query.getOrDefault("fields")
  valid_589338 = validateParameter(valid_589338, JString, required = false,
                                 default = nil)
  if valid_589338 != nil:
    section.add "fields", valid_589338
  var valid_589339 = query.getOrDefault("quotaUser")
  valid_589339 = validateParameter(valid_589339, JString, required = false,
                                 default = nil)
  if valid_589339 != nil:
    section.add "quotaUser", valid_589339
  var valid_589340 = query.getOrDefault("alt")
  valid_589340 = validateParameter(valid_589340, JString, required = false,
                                 default = newJString("json"))
  if valid_589340 != nil:
    section.add "alt", valid_589340
  var valid_589341 = query.getOrDefault("oauth_token")
  valid_589341 = validateParameter(valid_589341, JString, required = false,
                                 default = nil)
  if valid_589341 != nil:
    section.add "oauth_token", valid_589341
  var valid_589342 = query.getOrDefault("callback")
  valid_589342 = validateParameter(valid_589342, JString, required = false,
                                 default = nil)
  if valid_589342 != nil:
    section.add "callback", valid_589342
  var valid_589343 = query.getOrDefault("access_token")
  valid_589343 = validateParameter(valid_589343, JString, required = false,
                                 default = nil)
  if valid_589343 != nil:
    section.add "access_token", valid_589343
  var valid_589344 = query.getOrDefault("uploadType")
  valid_589344 = validateParameter(valid_589344, JString, required = false,
                                 default = nil)
  if valid_589344 != nil:
    section.add "uploadType", valid_589344
  var valid_589345 = query.getOrDefault("key")
  valid_589345 = validateParameter(valid_589345, JString, required = false,
                                 default = nil)
  if valid_589345 != nil:
    section.add "key", valid_589345
  var valid_589346 = query.getOrDefault("$.xgafv")
  valid_589346 = validateParameter(valid_589346, JString, required = false,
                                 default = newJString("1"))
  if valid_589346 != nil:
    section.add "$.xgafv", valid_589346
  var valid_589347 = query.getOrDefault("prettyPrint")
  valid_589347 = validateParameter(valid_589347, JBool, required = false,
                                 default = newJBool(true))
  if valid_589347 != nil:
    section.add "prettyPrint", valid_589347
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

proc call*(call_589349: Call_CloudsearchMediaUpload_589333; path: JsonNode;
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
  let valid = call_589349.validator(path, query, header, formData, body)
  let scheme = call_589349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589349.url(scheme.get, call_589349.host, call_589349.base,
                         call_589349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589349, url, valid)

proc call*(call_589350: Call_CloudsearchMediaUpload_589333; resourceName: string;
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
  var path_589351 = newJObject()
  var query_589352 = newJObject()
  var body_589353 = newJObject()
  add(query_589352, "upload_protocol", newJString(uploadProtocol))
  add(query_589352, "fields", newJString(fields))
  add(query_589352, "quotaUser", newJString(quotaUser))
  add(query_589352, "alt", newJString(alt))
  add(query_589352, "oauth_token", newJString(oauthToken))
  add(query_589352, "callback", newJString(callback))
  add(query_589352, "access_token", newJString(accessToken))
  add(query_589352, "uploadType", newJString(uploadType))
  add(path_589351, "resourceName", newJString(resourceName))
  add(query_589352, "key", newJString(key))
  add(query_589352, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589353 = body
  add(query_589352, "prettyPrint", newJBool(prettyPrint))
  result = call_589350.call(path_589351, query_589352, nil, nil, body_589353)

var cloudsearchMediaUpload* = Call_CloudsearchMediaUpload_589333(
    name: "cloudsearchMediaUpload", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/media/{resourceName}",
    validator: validate_CloudsearchMediaUpload_589334, base: "/",
    url: url_CloudsearchMediaUpload_589335, schemes: {Scheme.Https})
type
  Call_CloudsearchQuerySearch_589354 = ref object of OpenApiRestCall_588450
proc url_CloudsearchQuerySearch_589356(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudsearchQuerySearch_589355(path: JsonNode; query: JsonNode;
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
  var valid_589357 = query.getOrDefault("upload_protocol")
  valid_589357 = validateParameter(valid_589357, JString, required = false,
                                 default = nil)
  if valid_589357 != nil:
    section.add "upload_protocol", valid_589357
  var valid_589358 = query.getOrDefault("fields")
  valid_589358 = validateParameter(valid_589358, JString, required = false,
                                 default = nil)
  if valid_589358 != nil:
    section.add "fields", valid_589358
  var valid_589359 = query.getOrDefault("quotaUser")
  valid_589359 = validateParameter(valid_589359, JString, required = false,
                                 default = nil)
  if valid_589359 != nil:
    section.add "quotaUser", valid_589359
  var valid_589360 = query.getOrDefault("alt")
  valid_589360 = validateParameter(valid_589360, JString, required = false,
                                 default = newJString("json"))
  if valid_589360 != nil:
    section.add "alt", valid_589360
  var valid_589361 = query.getOrDefault("oauth_token")
  valid_589361 = validateParameter(valid_589361, JString, required = false,
                                 default = nil)
  if valid_589361 != nil:
    section.add "oauth_token", valid_589361
  var valid_589362 = query.getOrDefault("callback")
  valid_589362 = validateParameter(valid_589362, JString, required = false,
                                 default = nil)
  if valid_589362 != nil:
    section.add "callback", valid_589362
  var valid_589363 = query.getOrDefault("access_token")
  valid_589363 = validateParameter(valid_589363, JString, required = false,
                                 default = nil)
  if valid_589363 != nil:
    section.add "access_token", valid_589363
  var valid_589364 = query.getOrDefault("uploadType")
  valid_589364 = validateParameter(valid_589364, JString, required = false,
                                 default = nil)
  if valid_589364 != nil:
    section.add "uploadType", valid_589364
  var valid_589365 = query.getOrDefault("key")
  valid_589365 = validateParameter(valid_589365, JString, required = false,
                                 default = nil)
  if valid_589365 != nil:
    section.add "key", valid_589365
  var valid_589366 = query.getOrDefault("$.xgafv")
  valid_589366 = validateParameter(valid_589366, JString, required = false,
                                 default = newJString("1"))
  if valid_589366 != nil:
    section.add "$.xgafv", valid_589366
  var valid_589367 = query.getOrDefault("prettyPrint")
  valid_589367 = validateParameter(valid_589367, JBool, required = false,
                                 default = newJBool(true))
  if valid_589367 != nil:
    section.add "prettyPrint", valid_589367
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

proc call*(call_589369: Call_CloudsearchQuerySearch_589354; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Cloud Search Query API provides the search method, which returns
  ## the most relevant results from a user query.  The results can come from
  ## G Suite Apps, such as Gmail or Google Drive, or they can come from data
  ## that you have indexed from a third party.
  ## 
  let valid = call_589369.validator(path, query, header, formData, body)
  let scheme = call_589369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589369.url(scheme.get, call_589369.host, call_589369.base,
                         call_589369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589369, url, valid)

proc call*(call_589370: Call_CloudsearchQuerySearch_589354;
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
  var query_589371 = newJObject()
  var body_589372 = newJObject()
  add(query_589371, "upload_protocol", newJString(uploadProtocol))
  add(query_589371, "fields", newJString(fields))
  add(query_589371, "quotaUser", newJString(quotaUser))
  add(query_589371, "alt", newJString(alt))
  add(query_589371, "oauth_token", newJString(oauthToken))
  add(query_589371, "callback", newJString(callback))
  add(query_589371, "access_token", newJString(accessToken))
  add(query_589371, "uploadType", newJString(uploadType))
  add(query_589371, "key", newJString(key))
  add(query_589371, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589372 = body
  add(query_589371, "prettyPrint", newJBool(prettyPrint))
  result = call_589370.call(nil, query_589371, nil, nil, body_589372)

var cloudsearchQuerySearch* = Call_CloudsearchQuerySearch_589354(
    name: "cloudsearchQuerySearch", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/query/search",
    validator: validate_CloudsearchQuerySearch_589355, base: "/",
    url: url_CloudsearchQuerySearch_589356, schemes: {Scheme.Https})
type
  Call_CloudsearchQuerySourcesList_589373 = ref object of OpenApiRestCall_588450
proc url_CloudsearchQuerySourcesList_589375(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudsearchQuerySourcesList_589374(path: JsonNode; query: JsonNode;
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
  var valid_589376 = query.getOrDefault("upload_protocol")
  valid_589376 = validateParameter(valid_589376, JString, required = false,
                                 default = nil)
  if valid_589376 != nil:
    section.add "upload_protocol", valid_589376
  var valid_589377 = query.getOrDefault("fields")
  valid_589377 = validateParameter(valid_589377, JString, required = false,
                                 default = nil)
  if valid_589377 != nil:
    section.add "fields", valid_589377
  var valid_589378 = query.getOrDefault("pageToken")
  valid_589378 = validateParameter(valid_589378, JString, required = false,
                                 default = nil)
  if valid_589378 != nil:
    section.add "pageToken", valid_589378
  var valid_589379 = query.getOrDefault("quotaUser")
  valid_589379 = validateParameter(valid_589379, JString, required = false,
                                 default = nil)
  if valid_589379 != nil:
    section.add "quotaUser", valid_589379
  var valid_589380 = query.getOrDefault("alt")
  valid_589380 = validateParameter(valid_589380, JString, required = false,
                                 default = newJString("json"))
  if valid_589380 != nil:
    section.add "alt", valid_589380
  var valid_589381 = query.getOrDefault("requestOptions.searchApplicationId")
  valid_589381 = validateParameter(valid_589381, JString, required = false,
                                 default = nil)
  if valid_589381 != nil:
    section.add "requestOptions.searchApplicationId", valid_589381
  var valid_589382 = query.getOrDefault("oauth_token")
  valid_589382 = validateParameter(valid_589382, JString, required = false,
                                 default = nil)
  if valid_589382 != nil:
    section.add "oauth_token", valid_589382
  var valid_589383 = query.getOrDefault("callback")
  valid_589383 = validateParameter(valid_589383, JString, required = false,
                                 default = nil)
  if valid_589383 != nil:
    section.add "callback", valid_589383
  var valid_589384 = query.getOrDefault("access_token")
  valid_589384 = validateParameter(valid_589384, JString, required = false,
                                 default = nil)
  if valid_589384 != nil:
    section.add "access_token", valid_589384
  var valid_589385 = query.getOrDefault("uploadType")
  valid_589385 = validateParameter(valid_589385, JString, required = false,
                                 default = nil)
  if valid_589385 != nil:
    section.add "uploadType", valid_589385
  var valid_589386 = query.getOrDefault("requestOptions.languageCode")
  valid_589386 = validateParameter(valid_589386, JString, required = false,
                                 default = nil)
  if valid_589386 != nil:
    section.add "requestOptions.languageCode", valid_589386
  var valid_589387 = query.getOrDefault("key")
  valid_589387 = validateParameter(valid_589387, JString, required = false,
                                 default = nil)
  if valid_589387 != nil:
    section.add "key", valid_589387
  var valid_589388 = query.getOrDefault("requestOptions.debugOptions.enableDebugging")
  valid_589388 = validateParameter(valid_589388, JBool, required = false, default = nil)
  if valid_589388 != nil:
    section.add "requestOptions.debugOptions.enableDebugging", valid_589388
  var valid_589389 = query.getOrDefault("$.xgafv")
  valid_589389 = validateParameter(valid_589389, JString, required = false,
                                 default = newJString("1"))
  if valid_589389 != nil:
    section.add "$.xgafv", valid_589389
  var valid_589390 = query.getOrDefault("requestOptions.timeZone")
  valid_589390 = validateParameter(valid_589390, JString, required = false,
                                 default = nil)
  if valid_589390 != nil:
    section.add "requestOptions.timeZone", valid_589390
  var valid_589391 = query.getOrDefault("prettyPrint")
  valid_589391 = validateParameter(valid_589391, JBool, required = false,
                                 default = newJBool(true))
  if valid_589391 != nil:
    section.add "prettyPrint", valid_589391
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589392: Call_CloudsearchQuerySourcesList_589373; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns list of sources that user can use for Search and Suggest APIs.
  ## 
  let valid = call_589392.validator(path, query, header, formData, body)
  let scheme = call_589392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589392.url(scheme.get, call_589392.host, call_589392.base,
                         call_589392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589392, url, valid)

proc call*(call_589393: Call_CloudsearchQuerySourcesList_589373;
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
  var query_589394 = newJObject()
  add(query_589394, "upload_protocol", newJString(uploadProtocol))
  add(query_589394, "fields", newJString(fields))
  add(query_589394, "pageToken", newJString(pageToken))
  add(query_589394, "quotaUser", newJString(quotaUser))
  add(query_589394, "alt", newJString(alt))
  add(query_589394, "requestOptions.searchApplicationId",
      newJString(requestOptionsSearchApplicationId))
  add(query_589394, "oauth_token", newJString(oauthToken))
  add(query_589394, "callback", newJString(callback))
  add(query_589394, "access_token", newJString(accessToken))
  add(query_589394, "uploadType", newJString(uploadType))
  add(query_589394, "requestOptions.languageCode",
      newJString(requestOptionsLanguageCode))
  add(query_589394, "key", newJString(key))
  add(query_589394, "requestOptions.debugOptions.enableDebugging",
      newJBool(requestOptionsDebugOptionsEnableDebugging))
  add(query_589394, "$.xgafv", newJString(Xgafv))
  add(query_589394, "requestOptions.timeZone", newJString(requestOptionsTimeZone))
  add(query_589394, "prettyPrint", newJBool(prettyPrint))
  result = call_589393.call(nil, query_589394, nil, nil, nil)

var cloudsearchQuerySourcesList* = Call_CloudsearchQuerySourcesList_589373(
    name: "cloudsearchQuerySourcesList", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/query/sources",
    validator: validate_CloudsearchQuerySourcesList_589374, base: "/",
    url: url_CloudsearchQuerySourcesList_589375, schemes: {Scheme.Https})
type
  Call_CloudsearchQuerySuggest_589395 = ref object of OpenApiRestCall_588450
proc url_CloudsearchQuerySuggest_589397(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudsearchQuerySuggest_589396(path: JsonNode; query: JsonNode;
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
  var valid_589398 = query.getOrDefault("upload_protocol")
  valid_589398 = validateParameter(valid_589398, JString, required = false,
                                 default = nil)
  if valid_589398 != nil:
    section.add "upload_protocol", valid_589398
  var valid_589399 = query.getOrDefault("fields")
  valid_589399 = validateParameter(valid_589399, JString, required = false,
                                 default = nil)
  if valid_589399 != nil:
    section.add "fields", valid_589399
  var valid_589400 = query.getOrDefault("quotaUser")
  valid_589400 = validateParameter(valid_589400, JString, required = false,
                                 default = nil)
  if valid_589400 != nil:
    section.add "quotaUser", valid_589400
  var valid_589401 = query.getOrDefault("alt")
  valid_589401 = validateParameter(valid_589401, JString, required = false,
                                 default = newJString("json"))
  if valid_589401 != nil:
    section.add "alt", valid_589401
  var valid_589402 = query.getOrDefault("oauth_token")
  valid_589402 = validateParameter(valid_589402, JString, required = false,
                                 default = nil)
  if valid_589402 != nil:
    section.add "oauth_token", valid_589402
  var valid_589403 = query.getOrDefault("callback")
  valid_589403 = validateParameter(valid_589403, JString, required = false,
                                 default = nil)
  if valid_589403 != nil:
    section.add "callback", valid_589403
  var valid_589404 = query.getOrDefault("access_token")
  valid_589404 = validateParameter(valid_589404, JString, required = false,
                                 default = nil)
  if valid_589404 != nil:
    section.add "access_token", valid_589404
  var valid_589405 = query.getOrDefault("uploadType")
  valid_589405 = validateParameter(valid_589405, JString, required = false,
                                 default = nil)
  if valid_589405 != nil:
    section.add "uploadType", valid_589405
  var valid_589406 = query.getOrDefault("key")
  valid_589406 = validateParameter(valid_589406, JString, required = false,
                                 default = nil)
  if valid_589406 != nil:
    section.add "key", valid_589406
  var valid_589407 = query.getOrDefault("$.xgafv")
  valid_589407 = validateParameter(valid_589407, JString, required = false,
                                 default = newJString("1"))
  if valid_589407 != nil:
    section.add "$.xgafv", valid_589407
  var valid_589408 = query.getOrDefault("prettyPrint")
  valid_589408 = validateParameter(valid_589408, JBool, required = false,
                                 default = newJBool(true))
  if valid_589408 != nil:
    section.add "prettyPrint", valid_589408
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

proc call*(call_589410: Call_CloudsearchQuerySuggest_589395; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provides suggestions for autocompleting the query.
  ## 
  let valid = call_589410.validator(path, query, header, formData, body)
  let scheme = call_589410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589410.url(scheme.get, call_589410.host, call_589410.base,
                         call_589410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589410, url, valid)

proc call*(call_589411: Call_CloudsearchQuerySuggest_589395;
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
  var query_589412 = newJObject()
  var body_589413 = newJObject()
  add(query_589412, "upload_protocol", newJString(uploadProtocol))
  add(query_589412, "fields", newJString(fields))
  add(query_589412, "quotaUser", newJString(quotaUser))
  add(query_589412, "alt", newJString(alt))
  add(query_589412, "oauth_token", newJString(oauthToken))
  add(query_589412, "callback", newJString(callback))
  add(query_589412, "access_token", newJString(accessToken))
  add(query_589412, "uploadType", newJString(uploadType))
  add(query_589412, "key", newJString(key))
  add(query_589412, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589413 = body
  add(query_589412, "prettyPrint", newJBool(prettyPrint))
  result = call_589411.call(nil, query_589412, nil, nil, body_589413)

var cloudsearchQuerySuggest* = Call_CloudsearchQuerySuggest_589395(
    name: "cloudsearchQuerySuggest", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/query/suggest",
    validator: validate_CloudsearchQuerySuggest_589396, base: "/",
    url: url_CloudsearchQuerySuggest_589397, schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsDatasourcesCreate_589434 = ref object of OpenApiRestCall_588450
proc url_CloudsearchSettingsDatasourcesCreate_589436(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudsearchSettingsDatasourcesCreate_589435(path: JsonNode;
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
  var valid_589437 = query.getOrDefault("upload_protocol")
  valid_589437 = validateParameter(valid_589437, JString, required = false,
                                 default = nil)
  if valid_589437 != nil:
    section.add "upload_protocol", valid_589437
  var valid_589438 = query.getOrDefault("fields")
  valid_589438 = validateParameter(valid_589438, JString, required = false,
                                 default = nil)
  if valid_589438 != nil:
    section.add "fields", valid_589438
  var valid_589439 = query.getOrDefault("quotaUser")
  valid_589439 = validateParameter(valid_589439, JString, required = false,
                                 default = nil)
  if valid_589439 != nil:
    section.add "quotaUser", valid_589439
  var valid_589440 = query.getOrDefault("alt")
  valid_589440 = validateParameter(valid_589440, JString, required = false,
                                 default = newJString("json"))
  if valid_589440 != nil:
    section.add "alt", valid_589440
  var valid_589441 = query.getOrDefault("oauth_token")
  valid_589441 = validateParameter(valid_589441, JString, required = false,
                                 default = nil)
  if valid_589441 != nil:
    section.add "oauth_token", valid_589441
  var valid_589442 = query.getOrDefault("callback")
  valid_589442 = validateParameter(valid_589442, JString, required = false,
                                 default = nil)
  if valid_589442 != nil:
    section.add "callback", valid_589442
  var valid_589443 = query.getOrDefault("access_token")
  valid_589443 = validateParameter(valid_589443, JString, required = false,
                                 default = nil)
  if valid_589443 != nil:
    section.add "access_token", valid_589443
  var valid_589444 = query.getOrDefault("uploadType")
  valid_589444 = validateParameter(valid_589444, JString, required = false,
                                 default = nil)
  if valid_589444 != nil:
    section.add "uploadType", valid_589444
  var valid_589445 = query.getOrDefault("key")
  valid_589445 = validateParameter(valid_589445, JString, required = false,
                                 default = nil)
  if valid_589445 != nil:
    section.add "key", valid_589445
  var valid_589446 = query.getOrDefault("$.xgafv")
  valid_589446 = validateParameter(valid_589446, JString, required = false,
                                 default = newJString("1"))
  if valid_589446 != nil:
    section.add "$.xgafv", valid_589446
  var valid_589447 = query.getOrDefault("prettyPrint")
  valid_589447 = validateParameter(valid_589447, JBool, required = false,
                                 default = newJBool(true))
  if valid_589447 != nil:
    section.add "prettyPrint", valid_589447
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

proc call*(call_589449: Call_CloudsearchSettingsDatasourcesCreate_589434;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a datasource.
  ## 
  let valid = call_589449.validator(path, query, header, formData, body)
  let scheme = call_589449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589449.url(scheme.get, call_589449.host, call_589449.base,
                         call_589449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589449, url, valid)

proc call*(call_589450: Call_CloudsearchSettingsDatasourcesCreate_589434;
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
  var query_589451 = newJObject()
  var body_589452 = newJObject()
  add(query_589451, "upload_protocol", newJString(uploadProtocol))
  add(query_589451, "fields", newJString(fields))
  add(query_589451, "quotaUser", newJString(quotaUser))
  add(query_589451, "alt", newJString(alt))
  add(query_589451, "oauth_token", newJString(oauthToken))
  add(query_589451, "callback", newJString(callback))
  add(query_589451, "access_token", newJString(accessToken))
  add(query_589451, "uploadType", newJString(uploadType))
  add(query_589451, "key", newJString(key))
  add(query_589451, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589452 = body
  add(query_589451, "prettyPrint", newJBool(prettyPrint))
  result = call_589450.call(nil, query_589451, nil, nil, body_589452)

var cloudsearchSettingsDatasourcesCreate* = Call_CloudsearchSettingsDatasourcesCreate_589434(
    name: "cloudsearchSettingsDatasourcesCreate", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/datasources",
    validator: validate_CloudsearchSettingsDatasourcesCreate_589435, base: "/",
    url: url_CloudsearchSettingsDatasourcesCreate_589436, schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsDatasourcesList_589414 = ref object of OpenApiRestCall_588450
proc url_CloudsearchSettingsDatasourcesList_589416(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudsearchSettingsDatasourcesList_589415(path: JsonNode;
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
  var valid_589417 = query.getOrDefault("upload_protocol")
  valid_589417 = validateParameter(valid_589417, JString, required = false,
                                 default = nil)
  if valid_589417 != nil:
    section.add "upload_protocol", valid_589417
  var valid_589418 = query.getOrDefault("fields")
  valid_589418 = validateParameter(valid_589418, JString, required = false,
                                 default = nil)
  if valid_589418 != nil:
    section.add "fields", valid_589418
  var valid_589419 = query.getOrDefault("pageToken")
  valid_589419 = validateParameter(valid_589419, JString, required = false,
                                 default = nil)
  if valid_589419 != nil:
    section.add "pageToken", valid_589419
  var valid_589420 = query.getOrDefault("quotaUser")
  valid_589420 = validateParameter(valid_589420, JString, required = false,
                                 default = nil)
  if valid_589420 != nil:
    section.add "quotaUser", valid_589420
  var valid_589421 = query.getOrDefault("alt")
  valid_589421 = validateParameter(valid_589421, JString, required = false,
                                 default = newJString("json"))
  if valid_589421 != nil:
    section.add "alt", valid_589421
  var valid_589422 = query.getOrDefault("oauth_token")
  valid_589422 = validateParameter(valid_589422, JString, required = false,
                                 default = nil)
  if valid_589422 != nil:
    section.add "oauth_token", valid_589422
  var valid_589423 = query.getOrDefault("callback")
  valid_589423 = validateParameter(valid_589423, JString, required = false,
                                 default = nil)
  if valid_589423 != nil:
    section.add "callback", valid_589423
  var valid_589424 = query.getOrDefault("access_token")
  valid_589424 = validateParameter(valid_589424, JString, required = false,
                                 default = nil)
  if valid_589424 != nil:
    section.add "access_token", valid_589424
  var valid_589425 = query.getOrDefault("uploadType")
  valid_589425 = validateParameter(valid_589425, JString, required = false,
                                 default = nil)
  if valid_589425 != nil:
    section.add "uploadType", valid_589425
  var valid_589426 = query.getOrDefault("key")
  valid_589426 = validateParameter(valid_589426, JString, required = false,
                                 default = nil)
  if valid_589426 != nil:
    section.add "key", valid_589426
  var valid_589427 = query.getOrDefault("debugOptions.enableDebugging")
  valid_589427 = validateParameter(valid_589427, JBool, required = false, default = nil)
  if valid_589427 != nil:
    section.add "debugOptions.enableDebugging", valid_589427
  var valid_589428 = query.getOrDefault("$.xgafv")
  valid_589428 = validateParameter(valid_589428, JString, required = false,
                                 default = newJString("1"))
  if valid_589428 != nil:
    section.add "$.xgafv", valid_589428
  var valid_589429 = query.getOrDefault("pageSize")
  valid_589429 = validateParameter(valid_589429, JInt, required = false, default = nil)
  if valid_589429 != nil:
    section.add "pageSize", valid_589429
  var valid_589430 = query.getOrDefault("prettyPrint")
  valid_589430 = validateParameter(valid_589430, JBool, required = false,
                                 default = newJBool(true))
  if valid_589430 != nil:
    section.add "prettyPrint", valid_589430
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589431: Call_CloudsearchSettingsDatasourcesList_589414;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists datasources.
  ## 
  let valid = call_589431.validator(path, query, header, formData, body)
  let scheme = call_589431.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589431.url(scheme.get, call_589431.host, call_589431.base,
                         call_589431.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589431, url, valid)

proc call*(call_589432: Call_CloudsearchSettingsDatasourcesList_589414;
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
  var query_589433 = newJObject()
  add(query_589433, "upload_protocol", newJString(uploadProtocol))
  add(query_589433, "fields", newJString(fields))
  add(query_589433, "pageToken", newJString(pageToken))
  add(query_589433, "quotaUser", newJString(quotaUser))
  add(query_589433, "alt", newJString(alt))
  add(query_589433, "oauth_token", newJString(oauthToken))
  add(query_589433, "callback", newJString(callback))
  add(query_589433, "access_token", newJString(accessToken))
  add(query_589433, "uploadType", newJString(uploadType))
  add(query_589433, "key", newJString(key))
  add(query_589433, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_589433, "$.xgafv", newJString(Xgafv))
  add(query_589433, "pageSize", newJInt(pageSize))
  add(query_589433, "prettyPrint", newJBool(prettyPrint))
  result = call_589432.call(nil, query_589433, nil, nil, nil)

var cloudsearchSettingsDatasourcesList* = Call_CloudsearchSettingsDatasourcesList_589414(
    name: "cloudsearchSettingsDatasourcesList", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/datasources",
    validator: validate_CloudsearchSettingsDatasourcesList_589415, base: "/",
    url: url_CloudsearchSettingsDatasourcesList_589416, schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsSearchapplicationsCreate_589473 = ref object of OpenApiRestCall_588450
proc url_CloudsearchSettingsSearchapplicationsCreate_589475(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudsearchSettingsSearchapplicationsCreate_589474(path: JsonNode;
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
  var valid_589476 = query.getOrDefault("upload_protocol")
  valid_589476 = validateParameter(valid_589476, JString, required = false,
                                 default = nil)
  if valid_589476 != nil:
    section.add "upload_protocol", valid_589476
  var valid_589477 = query.getOrDefault("fields")
  valid_589477 = validateParameter(valid_589477, JString, required = false,
                                 default = nil)
  if valid_589477 != nil:
    section.add "fields", valid_589477
  var valid_589478 = query.getOrDefault("quotaUser")
  valid_589478 = validateParameter(valid_589478, JString, required = false,
                                 default = nil)
  if valid_589478 != nil:
    section.add "quotaUser", valid_589478
  var valid_589479 = query.getOrDefault("alt")
  valid_589479 = validateParameter(valid_589479, JString, required = false,
                                 default = newJString("json"))
  if valid_589479 != nil:
    section.add "alt", valid_589479
  var valid_589480 = query.getOrDefault("oauth_token")
  valid_589480 = validateParameter(valid_589480, JString, required = false,
                                 default = nil)
  if valid_589480 != nil:
    section.add "oauth_token", valid_589480
  var valid_589481 = query.getOrDefault("callback")
  valid_589481 = validateParameter(valid_589481, JString, required = false,
                                 default = nil)
  if valid_589481 != nil:
    section.add "callback", valid_589481
  var valid_589482 = query.getOrDefault("access_token")
  valid_589482 = validateParameter(valid_589482, JString, required = false,
                                 default = nil)
  if valid_589482 != nil:
    section.add "access_token", valid_589482
  var valid_589483 = query.getOrDefault("uploadType")
  valid_589483 = validateParameter(valid_589483, JString, required = false,
                                 default = nil)
  if valid_589483 != nil:
    section.add "uploadType", valid_589483
  var valid_589484 = query.getOrDefault("key")
  valid_589484 = validateParameter(valid_589484, JString, required = false,
                                 default = nil)
  if valid_589484 != nil:
    section.add "key", valid_589484
  var valid_589485 = query.getOrDefault("$.xgafv")
  valid_589485 = validateParameter(valid_589485, JString, required = false,
                                 default = newJString("1"))
  if valid_589485 != nil:
    section.add "$.xgafv", valid_589485
  var valid_589486 = query.getOrDefault("prettyPrint")
  valid_589486 = validateParameter(valid_589486, JBool, required = false,
                                 default = newJBool(true))
  if valid_589486 != nil:
    section.add "prettyPrint", valid_589486
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

proc call*(call_589488: Call_CloudsearchSettingsSearchapplicationsCreate_589473;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a search application.
  ## 
  let valid = call_589488.validator(path, query, header, formData, body)
  let scheme = call_589488.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589488.url(scheme.get, call_589488.host, call_589488.base,
                         call_589488.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589488, url, valid)

proc call*(call_589489: Call_CloudsearchSettingsSearchapplicationsCreate_589473;
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
  var query_589490 = newJObject()
  var body_589491 = newJObject()
  add(query_589490, "upload_protocol", newJString(uploadProtocol))
  add(query_589490, "fields", newJString(fields))
  add(query_589490, "quotaUser", newJString(quotaUser))
  add(query_589490, "alt", newJString(alt))
  add(query_589490, "oauth_token", newJString(oauthToken))
  add(query_589490, "callback", newJString(callback))
  add(query_589490, "access_token", newJString(accessToken))
  add(query_589490, "uploadType", newJString(uploadType))
  add(query_589490, "key", newJString(key))
  add(query_589490, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589491 = body
  add(query_589490, "prettyPrint", newJBool(prettyPrint))
  result = call_589489.call(nil, query_589490, nil, nil, body_589491)

var cloudsearchSettingsSearchapplicationsCreate* = Call_CloudsearchSettingsSearchapplicationsCreate_589473(
    name: "cloudsearchSettingsSearchapplicationsCreate",
    meth: HttpMethod.HttpPost, host: "cloudsearch.googleapis.com",
    route: "/v1/settings/searchapplications",
    validator: validate_CloudsearchSettingsSearchapplicationsCreate_589474,
    base: "/", url: url_CloudsearchSettingsSearchapplicationsCreate_589475,
    schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsSearchapplicationsList_589453 = ref object of OpenApiRestCall_588450
proc url_CloudsearchSettingsSearchapplicationsList_589455(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudsearchSettingsSearchapplicationsList_589454(path: JsonNode;
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
  var valid_589456 = query.getOrDefault("upload_protocol")
  valid_589456 = validateParameter(valid_589456, JString, required = false,
                                 default = nil)
  if valid_589456 != nil:
    section.add "upload_protocol", valid_589456
  var valid_589457 = query.getOrDefault("fields")
  valid_589457 = validateParameter(valid_589457, JString, required = false,
                                 default = nil)
  if valid_589457 != nil:
    section.add "fields", valid_589457
  var valid_589458 = query.getOrDefault("pageToken")
  valid_589458 = validateParameter(valid_589458, JString, required = false,
                                 default = nil)
  if valid_589458 != nil:
    section.add "pageToken", valid_589458
  var valid_589459 = query.getOrDefault("quotaUser")
  valid_589459 = validateParameter(valid_589459, JString, required = false,
                                 default = nil)
  if valid_589459 != nil:
    section.add "quotaUser", valid_589459
  var valid_589460 = query.getOrDefault("alt")
  valid_589460 = validateParameter(valid_589460, JString, required = false,
                                 default = newJString("json"))
  if valid_589460 != nil:
    section.add "alt", valid_589460
  var valid_589461 = query.getOrDefault("oauth_token")
  valid_589461 = validateParameter(valid_589461, JString, required = false,
                                 default = nil)
  if valid_589461 != nil:
    section.add "oauth_token", valid_589461
  var valid_589462 = query.getOrDefault("callback")
  valid_589462 = validateParameter(valid_589462, JString, required = false,
                                 default = nil)
  if valid_589462 != nil:
    section.add "callback", valid_589462
  var valid_589463 = query.getOrDefault("access_token")
  valid_589463 = validateParameter(valid_589463, JString, required = false,
                                 default = nil)
  if valid_589463 != nil:
    section.add "access_token", valid_589463
  var valid_589464 = query.getOrDefault("uploadType")
  valid_589464 = validateParameter(valid_589464, JString, required = false,
                                 default = nil)
  if valid_589464 != nil:
    section.add "uploadType", valid_589464
  var valid_589465 = query.getOrDefault("key")
  valid_589465 = validateParameter(valid_589465, JString, required = false,
                                 default = nil)
  if valid_589465 != nil:
    section.add "key", valid_589465
  var valid_589466 = query.getOrDefault("debugOptions.enableDebugging")
  valid_589466 = validateParameter(valid_589466, JBool, required = false, default = nil)
  if valid_589466 != nil:
    section.add "debugOptions.enableDebugging", valid_589466
  var valid_589467 = query.getOrDefault("$.xgafv")
  valid_589467 = validateParameter(valid_589467, JString, required = false,
                                 default = newJString("1"))
  if valid_589467 != nil:
    section.add "$.xgafv", valid_589467
  var valid_589468 = query.getOrDefault("pageSize")
  valid_589468 = validateParameter(valid_589468, JInt, required = false, default = nil)
  if valid_589468 != nil:
    section.add "pageSize", valid_589468
  var valid_589469 = query.getOrDefault("prettyPrint")
  valid_589469 = validateParameter(valid_589469, JBool, required = false,
                                 default = newJBool(true))
  if valid_589469 != nil:
    section.add "prettyPrint", valid_589469
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589470: Call_CloudsearchSettingsSearchapplicationsList_589453;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all search applications.
  ## 
  let valid = call_589470.validator(path, query, header, formData, body)
  let scheme = call_589470.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589470.url(scheme.get, call_589470.host, call_589470.base,
                         call_589470.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589470, url, valid)

proc call*(call_589471: Call_CloudsearchSettingsSearchapplicationsList_589453;
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
  var query_589472 = newJObject()
  add(query_589472, "upload_protocol", newJString(uploadProtocol))
  add(query_589472, "fields", newJString(fields))
  add(query_589472, "pageToken", newJString(pageToken))
  add(query_589472, "quotaUser", newJString(quotaUser))
  add(query_589472, "alt", newJString(alt))
  add(query_589472, "oauth_token", newJString(oauthToken))
  add(query_589472, "callback", newJString(callback))
  add(query_589472, "access_token", newJString(accessToken))
  add(query_589472, "uploadType", newJString(uploadType))
  add(query_589472, "key", newJString(key))
  add(query_589472, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_589472, "$.xgafv", newJString(Xgafv))
  add(query_589472, "pageSize", newJInt(pageSize))
  add(query_589472, "prettyPrint", newJBool(prettyPrint))
  result = call_589471.call(nil, query_589472, nil, nil, nil)

var cloudsearchSettingsSearchapplicationsList* = Call_CloudsearchSettingsSearchapplicationsList_589453(
    name: "cloudsearchSettingsSearchapplicationsList", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/searchapplications",
    validator: validate_CloudsearchSettingsSearchapplicationsList_589454,
    base: "/", url: url_CloudsearchSettingsSearchapplicationsList_589455,
    schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsSearchapplicationsUpdate_589512 = ref object of OpenApiRestCall_588450
proc url_CloudsearchSettingsSearchapplicationsUpdate_589514(protocol: Scheme;
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

proc validate_CloudsearchSettingsSearchapplicationsUpdate_589513(path: JsonNode;
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
  var valid_589515 = path.getOrDefault("name")
  valid_589515 = validateParameter(valid_589515, JString, required = true,
                                 default = nil)
  if valid_589515 != nil:
    section.add "name", valid_589515
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
  var valid_589516 = query.getOrDefault("upload_protocol")
  valid_589516 = validateParameter(valid_589516, JString, required = false,
                                 default = nil)
  if valid_589516 != nil:
    section.add "upload_protocol", valid_589516
  var valid_589517 = query.getOrDefault("fields")
  valid_589517 = validateParameter(valid_589517, JString, required = false,
                                 default = nil)
  if valid_589517 != nil:
    section.add "fields", valid_589517
  var valid_589518 = query.getOrDefault("quotaUser")
  valid_589518 = validateParameter(valid_589518, JString, required = false,
                                 default = nil)
  if valid_589518 != nil:
    section.add "quotaUser", valid_589518
  var valid_589519 = query.getOrDefault("alt")
  valid_589519 = validateParameter(valid_589519, JString, required = false,
                                 default = newJString("json"))
  if valid_589519 != nil:
    section.add "alt", valid_589519
  var valid_589520 = query.getOrDefault("oauth_token")
  valid_589520 = validateParameter(valid_589520, JString, required = false,
                                 default = nil)
  if valid_589520 != nil:
    section.add "oauth_token", valid_589520
  var valid_589521 = query.getOrDefault("callback")
  valid_589521 = validateParameter(valid_589521, JString, required = false,
                                 default = nil)
  if valid_589521 != nil:
    section.add "callback", valid_589521
  var valid_589522 = query.getOrDefault("access_token")
  valid_589522 = validateParameter(valid_589522, JString, required = false,
                                 default = nil)
  if valid_589522 != nil:
    section.add "access_token", valid_589522
  var valid_589523 = query.getOrDefault("uploadType")
  valid_589523 = validateParameter(valid_589523, JString, required = false,
                                 default = nil)
  if valid_589523 != nil:
    section.add "uploadType", valid_589523
  var valid_589524 = query.getOrDefault("key")
  valid_589524 = validateParameter(valid_589524, JString, required = false,
                                 default = nil)
  if valid_589524 != nil:
    section.add "key", valid_589524
  var valid_589525 = query.getOrDefault("$.xgafv")
  valid_589525 = validateParameter(valid_589525, JString, required = false,
                                 default = newJString("1"))
  if valid_589525 != nil:
    section.add "$.xgafv", valid_589525
  var valid_589526 = query.getOrDefault("prettyPrint")
  valid_589526 = validateParameter(valid_589526, JBool, required = false,
                                 default = newJBool(true))
  if valid_589526 != nil:
    section.add "prettyPrint", valid_589526
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

proc call*(call_589528: Call_CloudsearchSettingsSearchapplicationsUpdate_589512;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a search application.
  ## 
  let valid = call_589528.validator(path, query, header, formData, body)
  let scheme = call_589528.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589528.url(scheme.get, call_589528.host, call_589528.base,
                         call_589528.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589528, url, valid)

proc call*(call_589529: Call_CloudsearchSettingsSearchapplicationsUpdate_589512;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudsearchSettingsSearchapplicationsUpdate
  ## Updates a search application.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the Search Application.
  ## <br />Format: searchapplications/{application_id}.
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
  var path_589530 = newJObject()
  var query_589531 = newJObject()
  var body_589532 = newJObject()
  add(query_589531, "upload_protocol", newJString(uploadProtocol))
  add(query_589531, "fields", newJString(fields))
  add(query_589531, "quotaUser", newJString(quotaUser))
  add(path_589530, "name", newJString(name))
  add(query_589531, "alt", newJString(alt))
  add(query_589531, "oauth_token", newJString(oauthToken))
  add(query_589531, "callback", newJString(callback))
  add(query_589531, "access_token", newJString(accessToken))
  add(query_589531, "uploadType", newJString(uploadType))
  add(query_589531, "key", newJString(key))
  add(query_589531, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589532 = body
  add(query_589531, "prettyPrint", newJBool(prettyPrint))
  result = call_589529.call(path_589530, query_589531, nil, nil, body_589532)

var cloudsearchSettingsSearchapplicationsUpdate* = Call_CloudsearchSettingsSearchapplicationsUpdate_589512(
    name: "cloudsearchSettingsSearchapplicationsUpdate", meth: HttpMethod.HttpPut,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/{name}",
    validator: validate_CloudsearchSettingsSearchapplicationsUpdate_589513,
    base: "/", url: url_CloudsearchSettingsSearchapplicationsUpdate_589514,
    schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsSearchapplicationsGet_589492 = ref object of OpenApiRestCall_588450
proc url_CloudsearchSettingsSearchapplicationsGet_589494(protocol: Scheme;
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

proc validate_CloudsearchSettingsSearchapplicationsGet_589493(path: JsonNode;
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
  var valid_589495 = path.getOrDefault("name")
  valid_589495 = validateParameter(valid_589495, JString, required = true,
                                 default = nil)
  if valid_589495 != nil:
    section.add "name", valid_589495
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
  var valid_589496 = query.getOrDefault("upload_protocol")
  valid_589496 = validateParameter(valid_589496, JString, required = false,
                                 default = nil)
  if valid_589496 != nil:
    section.add "upload_protocol", valid_589496
  var valid_589497 = query.getOrDefault("fields")
  valid_589497 = validateParameter(valid_589497, JString, required = false,
                                 default = nil)
  if valid_589497 != nil:
    section.add "fields", valid_589497
  var valid_589498 = query.getOrDefault("quotaUser")
  valid_589498 = validateParameter(valid_589498, JString, required = false,
                                 default = nil)
  if valid_589498 != nil:
    section.add "quotaUser", valid_589498
  var valid_589499 = query.getOrDefault("alt")
  valid_589499 = validateParameter(valid_589499, JString, required = false,
                                 default = newJString("json"))
  if valid_589499 != nil:
    section.add "alt", valid_589499
  var valid_589500 = query.getOrDefault("oauth_token")
  valid_589500 = validateParameter(valid_589500, JString, required = false,
                                 default = nil)
  if valid_589500 != nil:
    section.add "oauth_token", valid_589500
  var valid_589501 = query.getOrDefault("callback")
  valid_589501 = validateParameter(valid_589501, JString, required = false,
                                 default = nil)
  if valid_589501 != nil:
    section.add "callback", valid_589501
  var valid_589502 = query.getOrDefault("access_token")
  valid_589502 = validateParameter(valid_589502, JString, required = false,
                                 default = nil)
  if valid_589502 != nil:
    section.add "access_token", valid_589502
  var valid_589503 = query.getOrDefault("uploadType")
  valid_589503 = validateParameter(valid_589503, JString, required = false,
                                 default = nil)
  if valid_589503 != nil:
    section.add "uploadType", valid_589503
  var valid_589504 = query.getOrDefault("key")
  valid_589504 = validateParameter(valid_589504, JString, required = false,
                                 default = nil)
  if valid_589504 != nil:
    section.add "key", valid_589504
  var valid_589505 = query.getOrDefault("debugOptions.enableDebugging")
  valid_589505 = validateParameter(valid_589505, JBool, required = false, default = nil)
  if valid_589505 != nil:
    section.add "debugOptions.enableDebugging", valid_589505
  var valid_589506 = query.getOrDefault("$.xgafv")
  valid_589506 = validateParameter(valid_589506, JString, required = false,
                                 default = newJString("1"))
  if valid_589506 != nil:
    section.add "$.xgafv", valid_589506
  var valid_589507 = query.getOrDefault("prettyPrint")
  valid_589507 = validateParameter(valid_589507, JBool, required = false,
                                 default = newJBool(true))
  if valid_589507 != nil:
    section.add "prettyPrint", valid_589507
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589508: Call_CloudsearchSettingsSearchapplicationsGet_589492;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the specified search application.
  ## 
  let valid = call_589508.validator(path, query, header, formData, body)
  let scheme = call_589508.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589508.url(scheme.get, call_589508.host, call_589508.base,
                         call_589508.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589508, url, valid)

proc call*(call_589509: Call_CloudsearchSettingsSearchapplicationsGet_589492;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; debugOptionsEnableDebugging: bool = false;
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudsearchSettingsSearchapplicationsGet
  ## Gets the specified search application.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the search application.
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
  ##   debugOptionsEnableDebugging: bool
  ##                              : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589510 = newJObject()
  var query_589511 = newJObject()
  add(query_589511, "upload_protocol", newJString(uploadProtocol))
  add(query_589511, "fields", newJString(fields))
  add(query_589511, "quotaUser", newJString(quotaUser))
  add(path_589510, "name", newJString(name))
  add(query_589511, "alt", newJString(alt))
  add(query_589511, "oauth_token", newJString(oauthToken))
  add(query_589511, "callback", newJString(callback))
  add(query_589511, "access_token", newJString(accessToken))
  add(query_589511, "uploadType", newJString(uploadType))
  add(query_589511, "key", newJString(key))
  add(query_589511, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_589511, "$.xgafv", newJString(Xgafv))
  add(query_589511, "prettyPrint", newJBool(prettyPrint))
  result = call_589509.call(path_589510, query_589511, nil, nil, nil)

var cloudsearchSettingsSearchapplicationsGet* = Call_CloudsearchSettingsSearchapplicationsGet_589492(
    name: "cloudsearchSettingsSearchapplicationsGet", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/{name}",
    validator: validate_CloudsearchSettingsSearchapplicationsGet_589493,
    base: "/", url: url_CloudsearchSettingsSearchapplicationsGet_589494,
    schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsSearchapplicationsDelete_589533 = ref object of OpenApiRestCall_588450
proc url_CloudsearchSettingsSearchapplicationsDelete_589535(protocol: Scheme;
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

proc validate_CloudsearchSettingsSearchapplicationsDelete_589534(path: JsonNode;
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
  var valid_589536 = path.getOrDefault("name")
  valid_589536 = validateParameter(valid_589536, JString, required = true,
                                 default = nil)
  if valid_589536 != nil:
    section.add "name", valid_589536
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
  var valid_589537 = query.getOrDefault("upload_protocol")
  valid_589537 = validateParameter(valid_589537, JString, required = false,
                                 default = nil)
  if valid_589537 != nil:
    section.add "upload_protocol", valid_589537
  var valid_589538 = query.getOrDefault("fields")
  valid_589538 = validateParameter(valid_589538, JString, required = false,
                                 default = nil)
  if valid_589538 != nil:
    section.add "fields", valid_589538
  var valid_589539 = query.getOrDefault("quotaUser")
  valid_589539 = validateParameter(valid_589539, JString, required = false,
                                 default = nil)
  if valid_589539 != nil:
    section.add "quotaUser", valid_589539
  var valid_589540 = query.getOrDefault("alt")
  valid_589540 = validateParameter(valid_589540, JString, required = false,
                                 default = newJString("json"))
  if valid_589540 != nil:
    section.add "alt", valid_589540
  var valid_589541 = query.getOrDefault("oauth_token")
  valid_589541 = validateParameter(valid_589541, JString, required = false,
                                 default = nil)
  if valid_589541 != nil:
    section.add "oauth_token", valid_589541
  var valid_589542 = query.getOrDefault("callback")
  valid_589542 = validateParameter(valid_589542, JString, required = false,
                                 default = nil)
  if valid_589542 != nil:
    section.add "callback", valid_589542
  var valid_589543 = query.getOrDefault("access_token")
  valid_589543 = validateParameter(valid_589543, JString, required = false,
                                 default = nil)
  if valid_589543 != nil:
    section.add "access_token", valid_589543
  var valid_589544 = query.getOrDefault("uploadType")
  valid_589544 = validateParameter(valid_589544, JString, required = false,
                                 default = nil)
  if valid_589544 != nil:
    section.add "uploadType", valid_589544
  var valid_589545 = query.getOrDefault("key")
  valid_589545 = validateParameter(valid_589545, JString, required = false,
                                 default = nil)
  if valid_589545 != nil:
    section.add "key", valid_589545
  var valid_589546 = query.getOrDefault("debugOptions.enableDebugging")
  valid_589546 = validateParameter(valid_589546, JBool, required = false, default = nil)
  if valid_589546 != nil:
    section.add "debugOptions.enableDebugging", valid_589546
  var valid_589547 = query.getOrDefault("$.xgafv")
  valid_589547 = validateParameter(valid_589547, JString, required = false,
                                 default = newJString("1"))
  if valid_589547 != nil:
    section.add "$.xgafv", valid_589547
  var valid_589548 = query.getOrDefault("prettyPrint")
  valid_589548 = validateParameter(valid_589548, JBool, required = false,
                                 default = newJBool(true))
  if valid_589548 != nil:
    section.add "prettyPrint", valid_589548
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589549: Call_CloudsearchSettingsSearchapplicationsDelete_589533;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a search application.
  ## 
  let valid = call_589549.validator(path, query, header, formData, body)
  let scheme = call_589549.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589549.url(scheme.get, call_589549.host, call_589549.base,
                         call_589549.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589549, url, valid)

proc call*(call_589550: Call_CloudsearchSettingsSearchapplicationsDelete_589533;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; debugOptionsEnableDebugging: bool = false;
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudsearchSettingsSearchapplicationsDelete
  ## Deletes a search application.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the search application to be deleted.
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
  ##   debugOptionsEnableDebugging: bool
  ##                              : If you are asked by Google to help with debugging, set this field.
  ## Otherwise, ignore this field.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589551 = newJObject()
  var query_589552 = newJObject()
  add(query_589552, "upload_protocol", newJString(uploadProtocol))
  add(query_589552, "fields", newJString(fields))
  add(query_589552, "quotaUser", newJString(quotaUser))
  add(path_589551, "name", newJString(name))
  add(query_589552, "alt", newJString(alt))
  add(query_589552, "oauth_token", newJString(oauthToken))
  add(query_589552, "callback", newJString(callback))
  add(query_589552, "access_token", newJString(accessToken))
  add(query_589552, "uploadType", newJString(uploadType))
  add(query_589552, "key", newJString(key))
  add(query_589552, "debugOptions.enableDebugging",
      newJBool(debugOptionsEnableDebugging))
  add(query_589552, "$.xgafv", newJString(Xgafv))
  add(query_589552, "prettyPrint", newJBool(prettyPrint))
  result = call_589550.call(path_589551, query_589552, nil, nil, nil)

var cloudsearchSettingsSearchapplicationsDelete* = Call_CloudsearchSettingsSearchapplicationsDelete_589533(
    name: "cloudsearchSettingsSearchapplicationsDelete",
    meth: HttpMethod.HttpDelete, host: "cloudsearch.googleapis.com",
    route: "/v1/settings/{name}",
    validator: validate_CloudsearchSettingsSearchapplicationsDelete_589534,
    base: "/", url: url_CloudsearchSettingsSearchapplicationsDelete_589535,
    schemes: {Scheme.Https})
type
  Call_CloudsearchSettingsSearchapplicationsReset_589553 = ref object of OpenApiRestCall_588450
proc url_CloudsearchSettingsSearchapplicationsReset_589555(protocol: Scheme;
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

proc validate_CloudsearchSettingsSearchapplicationsReset_589554(path: JsonNode;
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
  var valid_589556 = path.getOrDefault("name")
  valid_589556 = validateParameter(valid_589556, JString, required = true,
                                 default = nil)
  if valid_589556 != nil:
    section.add "name", valid_589556
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
  var valid_589557 = query.getOrDefault("upload_protocol")
  valid_589557 = validateParameter(valid_589557, JString, required = false,
                                 default = nil)
  if valid_589557 != nil:
    section.add "upload_protocol", valid_589557
  var valid_589558 = query.getOrDefault("fields")
  valid_589558 = validateParameter(valid_589558, JString, required = false,
                                 default = nil)
  if valid_589558 != nil:
    section.add "fields", valid_589558
  var valid_589559 = query.getOrDefault("quotaUser")
  valid_589559 = validateParameter(valid_589559, JString, required = false,
                                 default = nil)
  if valid_589559 != nil:
    section.add "quotaUser", valid_589559
  var valid_589560 = query.getOrDefault("alt")
  valid_589560 = validateParameter(valid_589560, JString, required = false,
                                 default = newJString("json"))
  if valid_589560 != nil:
    section.add "alt", valid_589560
  var valid_589561 = query.getOrDefault("oauth_token")
  valid_589561 = validateParameter(valid_589561, JString, required = false,
                                 default = nil)
  if valid_589561 != nil:
    section.add "oauth_token", valid_589561
  var valid_589562 = query.getOrDefault("callback")
  valid_589562 = validateParameter(valid_589562, JString, required = false,
                                 default = nil)
  if valid_589562 != nil:
    section.add "callback", valid_589562
  var valid_589563 = query.getOrDefault("access_token")
  valid_589563 = validateParameter(valid_589563, JString, required = false,
                                 default = nil)
  if valid_589563 != nil:
    section.add "access_token", valid_589563
  var valid_589564 = query.getOrDefault("uploadType")
  valid_589564 = validateParameter(valid_589564, JString, required = false,
                                 default = nil)
  if valid_589564 != nil:
    section.add "uploadType", valid_589564
  var valid_589565 = query.getOrDefault("key")
  valid_589565 = validateParameter(valid_589565, JString, required = false,
                                 default = nil)
  if valid_589565 != nil:
    section.add "key", valid_589565
  var valid_589566 = query.getOrDefault("$.xgafv")
  valid_589566 = validateParameter(valid_589566, JString, required = false,
                                 default = newJString("1"))
  if valid_589566 != nil:
    section.add "$.xgafv", valid_589566
  var valid_589567 = query.getOrDefault("prettyPrint")
  valid_589567 = validateParameter(valid_589567, JBool, required = false,
                                 default = newJBool(true))
  if valid_589567 != nil:
    section.add "prettyPrint", valid_589567
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

proc call*(call_589569: Call_CloudsearchSettingsSearchapplicationsReset_589553;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Resets a search application to default settings. This will return an empty
  ## response.
  ## 
  let valid = call_589569.validator(path, query, header, formData, body)
  let scheme = call_589569.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589569.url(scheme.get, call_589569.host, call_589569.base,
                         call_589569.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589569, url, valid)

proc call*(call_589570: Call_CloudsearchSettingsSearchapplicationsReset_589553;
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
  var path_589571 = newJObject()
  var query_589572 = newJObject()
  var body_589573 = newJObject()
  add(query_589572, "upload_protocol", newJString(uploadProtocol))
  add(query_589572, "fields", newJString(fields))
  add(query_589572, "quotaUser", newJString(quotaUser))
  add(path_589571, "name", newJString(name))
  add(query_589572, "alt", newJString(alt))
  add(query_589572, "oauth_token", newJString(oauthToken))
  add(query_589572, "callback", newJString(callback))
  add(query_589572, "access_token", newJString(accessToken))
  add(query_589572, "uploadType", newJString(uploadType))
  add(query_589572, "key", newJString(key))
  add(query_589572, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589573 = body
  add(query_589572, "prettyPrint", newJBool(prettyPrint))
  result = call_589570.call(path_589571, query_589572, nil, nil, body_589573)

var cloudsearchSettingsSearchapplicationsReset* = Call_CloudsearchSettingsSearchapplicationsReset_589553(
    name: "cloudsearchSettingsSearchapplicationsReset", meth: HttpMethod.HttpPost,
    host: "cloudsearch.googleapis.com", route: "/v1/settings/{name}:reset",
    validator: validate_CloudsearchSettingsSearchapplicationsReset_589554,
    base: "/", url: url_CloudsearchSettingsSearchapplicationsReset_589555,
    schemes: {Scheme.Https})
type
  Call_CloudsearchStatsGetIndex_589574 = ref object of OpenApiRestCall_588450
proc url_CloudsearchStatsGetIndex_589576(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_CloudsearchStatsGetIndex_589575(path: JsonNode; query: JsonNode;
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
  var valid_589577 = query.getOrDefault("upload_protocol")
  valid_589577 = validateParameter(valid_589577, JString, required = false,
                                 default = nil)
  if valid_589577 != nil:
    section.add "upload_protocol", valid_589577
  var valid_589578 = query.getOrDefault("fields")
  valid_589578 = validateParameter(valid_589578, JString, required = false,
                                 default = nil)
  if valid_589578 != nil:
    section.add "fields", valid_589578
  var valid_589579 = query.getOrDefault("quotaUser")
  valid_589579 = validateParameter(valid_589579, JString, required = false,
                                 default = nil)
  if valid_589579 != nil:
    section.add "quotaUser", valid_589579
  var valid_589580 = query.getOrDefault("alt")
  valid_589580 = validateParameter(valid_589580, JString, required = false,
                                 default = newJString("json"))
  if valid_589580 != nil:
    section.add "alt", valid_589580
  var valid_589581 = query.getOrDefault("toDate.day")
  valid_589581 = validateParameter(valid_589581, JInt, required = false, default = nil)
  if valid_589581 != nil:
    section.add "toDate.day", valid_589581
  var valid_589582 = query.getOrDefault("oauth_token")
  valid_589582 = validateParameter(valid_589582, JString, required = false,
                                 default = nil)
  if valid_589582 != nil:
    section.add "oauth_token", valid_589582
  var valid_589583 = query.getOrDefault("callback")
  valid_589583 = validateParameter(valid_589583, JString, required = false,
                                 default = nil)
  if valid_589583 != nil:
    section.add "callback", valid_589583
  var valid_589584 = query.getOrDefault("access_token")
  valid_589584 = validateParameter(valid_589584, JString, required = false,
                                 default = nil)
  if valid_589584 != nil:
    section.add "access_token", valid_589584
  var valid_589585 = query.getOrDefault("uploadType")
  valid_589585 = validateParameter(valid_589585, JString, required = false,
                                 default = nil)
  if valid_589585 != nil:
    section.add "uploadType", valid_589585
  var valid_589586 = query.getOrDefault("fromDate.day")
  valid_589586 = validateParameter(valid_589586, JInt, required = false, default = nil)
  if valid_589586 != nil:
    section.add "fromDate.day", valid_589586
  var valid_589587 = query.getOrDefault("fromDate.month")
  valid_589587 = validateParameter(valid_589587, JInt, required = false, default = nil)
  if valid_589587 != nil:
    section.add "fromDate.month", valid_589587
  var valid_589588 = query.getOrDefault("key")
  valid_589588 = validateParameter(valid_589588, JString, required = false,
                                 default = nil)
  if valid_589588 != nil:
    section.add "key", valid_589588
  var valid_589589 = query.getOrDefault("$.xgafv")
  valid_589589 = validateParameter(valid_589589, JString, required = false,
                                 default = newJString("1"))
  if valid_589589 != nil:
    section.add "$.xgafv", valid_589589
  var valid_589590 = query.getOrDefault("toDate.month")
  valid_589590 = validateParameter(valid_589590, JInt, required = false, default = nil)
  if valid_589590 != nil:
    section.add "toDate.month", valid_589590
  var valid_589591 = query.getOrDefault("prettyPrint")
  valid_589591 = validateParameter(valid_589591, JBool, required = false,
                                 default = newJBool(true))
  if valid_589591 != nil:
    section.add "prettyPrint", valid_589591
  var valid_589592 = query.getOrDefault("toDate.year")
  valid_589592 = validateParameter(valid_589592, JInt, required = false, default = nil)
  if valid_589592 != nil:
    section.add "toDate.year", valid_589592
  var valid_589593 = query.getOrDefault("fromDate.year")
  valid_589593 = validateParameter(valid_589593, JInt, required = false, default = nil)
  if valid_589593 != nil:
    section.add "fromDate.year", valid_589593
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589594: Call_CloudsearchStatsGetIndex_589574; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets indexed item statistics aggreggated across all data sources. This
  ## API only returns statistics for previous dates; it doesn't return
  ## statistics for the current day.
  ## 
  let valid = call_589594.validator(path, query, header, formData, body)
  let scheme = call_589594.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589594.url(scheme.get, call_589594.host, call_589594.base,
                         call_589594.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589594, url, valid)

proc call*(call_589595: Call_CloudsearchStatsGetIndex_589574;
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
  var query_589596 = newJObject()
  add(query_589596, "upload_protocol", newJString(uploadProtocol))
  add(query_589596, "fields", newJString(fields))
  add(query_589596, "quotaUser", newJString(quotaUser))
  add(query_589596, "alt", newJString(alt))
  add(query_589596, "toDate.day", newJInt(toDateDay))
  add(query_589596, "oauth_token", newJString(oauthToken))
  add(query_589596, "callback", newJString(callback))
  add(query_589596, "access_token", newJString(accessToken))
  add(query_589596, "uploadType", newJString(uploadType))
  add(query_589596, "fromDate.day", newJInt(fromDateDay))
  add(query_589596, "fromDate.month", newJInt(fromDateMonth))
  add(query_589596, "key", newJString(key))
  add(query_589596, "$.xgafv", newJString(Xgafv))
  add(query_589596, "toDate.month", newJInt(toDateMonth))
  add(query_589596, "prettyPrint", newJBool(prettyPrint))
  add(query_589596, "toDate.year", newJInt(toDateYear))
  add(query_589596, "fromDate.year", newJInt(fromDateYear))
  result = call_589595.call(nil, query_589596, nil, nil, nil)

var cloudsearchStatsGetIndex* = Call_CloudsearchStatsGetIndex_589574(
    name: "cloudsearchStatsGetIndex", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/stats/index",
    validator: validate_CloudsearchStatsGetIndex_589575, base: "/",
    url: url_CloudsearchStatsGetIndex_589576, schemes: {Scheme.Https})
type
  Call_CloudsearchStatsIndexDatasourcesGet_589597 = ref object of OpenApiRestCall_588450
proc url_CloudsearchStatsIndexDatasourcesGet_589599(protocol: Scheme; host: string;
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

proc validate_CloudsearchStatsIndexDatasourcesGet_589598(path: JsonNode;
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
  var valid_589600 = path.getOrDefault("name")
  valid_589600 = validateParameter(valid_589600, JString, required = true,
                                 default = nil)
  if valid_589600 != nil:
    section.add "name", valid_589600
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
  var valid_589601 = query.getOrDefault("upload_protocol")
  valid_589601 = validateParameter(valid_589601, JString, required = false,
                                 default = nil)
  if valid_589601 != nil:
    section.add "upload_protocol", valid_589601
  var valid_589602 = query.getOrDefault("fields")
  valid_589602 = validateParameter(valid_589602, JString, required = false,
                                 default = nil)
  if valid_589602 != nil:
    section.add "fields", valid_589602
  var valid_589603 = query.getOrDefault("quotaUser")
  valid_589603 = validateParameter(valid_589603, JString, required = false,
                                 default = nil)
  if valid_589603 != nil:
    section.add "quotaUser", valid_589603
  var valid_589604 = query.getOrDefault("alt")
  valid_589604 = validateParameter(valid_589604, JString, required = false,
                                 default = newJString("json"))
  if valid_589604 != nil:
    section.add "alt", valid_589604
  var valid_589605 = query.getOrDefault("toDate.day")
  valid_589605 = validateParameter(valid_589605, JInt, required = false, default = nil)
  if valid_589605 != nil:
    section.add "toDate.day", valid_589605
  var valid_589606 = query.getOrDefault("oauth_token")
  valid_589606 = validateParameter(valid_589606, JString, required = false,
                                 default = nil)
  if valid_589606 != nil:
    section.add "oauth_token", valid_589606
  var valid_589607 = query.getOrDefault("callback")
  valid_589607 = validateParameter(valid_589607, JString, required = false,
                                 default = nil)
  if valid_589607 != nil:
    section.add "callback", valid_589607
  var valid_589608 = query.getOrDefault("access_token")
  valid_589608 = validateParameter(valid_589608, JString, required = false,
                                 default = nil)
  if valid_589608 != nil:
    section.add "access_token", valid_589608
  var valid_589609 = query.getOrDefault("uploadType")
  valid_589609 = validateParameter(valid_589609, JString, required = false,
                                 default = nil)
  if valid_589609 != nil:
    section.add "uploadType", valid_589609
  var valid_589610 = query.getOrDefault("fromDate.day")
  valid_589610 = validateParameter(valid_589610, JInt, required = false, default = nil)
  if valid_589610 != nil:
    section.add "fromDate.day", valid_589610
  var valid_589611 = query.getOrDefault("fromDate.month")
  valid_589611 = validateParameter(valid_589611, JInt, required = false, default = nil)
  if valid_589611 != nil:
    section.add "fromDate.month", valid_589611
  var valid_589612 = query.getOrDefault("key")
  valid_589612 = validateParameter(valid_589612, JString, required = false,
                                 default = nil)
  if valid_589612 != nil:
    section.add "key", valid_589612
  var valid_589613 = query.getOrDefault("$.xgafv")
  valid_589613 = validateParameter(valid_589613, JString, required = false,
                                 default = newJString("1"))
  if valid_589613 != nil:
    section.add "$.xgafv", valid_589613
  var valid_589614 = query.getOrDefault("toDate.month")
  valid_589614 = validateParameter(valid_589614, JInt, required = false, default = nil)
  if valid_589614 != nil:
    section.add "toDate.month", valid_589614
  var valid_589615 = query.getOrDefault("prettyPrint")
  valid_589615 = validateParameter(valid_589615, JBool, required = false,
                                 default = newJBool(true))
  if valid_589615 != nil:
    section.add "prettyPrint", valid_589615
  var valid_589616 = query.getOrDefault("toDate.year")
  valid_589616 = validateParameter(valid_589616, JInt, required = false, default = nil)
  if valid_589616 != nil:
    section.add "toDate.year", valid_589616
  var valid_589617 = query.getOrDefault("fromDate.year")
  valid_589617 = validateParameter(valid_589617, JInt, required = false, default = nil)
  if valid_589617 != nil:
    section.add "fromDate.year", valid_589617
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589618: Call_CloudsearchStatsIndexDatasourcesGet_589597;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets indexed item statistics for a single data source.
  ## 
  let valid = call_589618.validator(path, query, header, formData, body)
  let scheme = call_589618.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589618.url(scheme.get, call_589618.host, call_589618.base,
                         call_589618.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589618, url, valid)

proc call*(call_589619: Call_CloudsearchStatsIndexDatasourcesGet_589597;
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
  var path_589620 = newJObject()
  var query_589621 = newJObject()
  add(query_589621, "upload_protocol", newJString(uploadProtocol))
  add(query_589621, "fields", newJString(fields))
  add(query_589621, "quotaUser", newJString(quotaUser))
  add(path_589620, "name", newJString(name))
  add(query_589621, "alt", newJString(alt))
  add(query_589621, "toDate.day", newJInt(toDateDay))
  add(query_589621, "oauth_token", newJString(oauthToken))
  add(query_589621, "callback", newJString(callback))
  add(query_589621, "access_token", newJString(accessToken))
  add(query_589621, "uploadType", newJString(uploadType))
  add(query_589621, "fromDate.day", newJInt(fromDateDay))
  add(query_589621, "fromDate.month", newJInt(fromDateMonth))
  add(query_589621, "key", newJString(key))
  add(query_589621, "$.xgafv", newJString(Xgafv))
  add(query_589621, "toDate.month", newJInt(toDateMonth))
  add(query_589621, "prettyPrint", newJBool(prettyPrint))
  add(query_589621, "toDate.year", newJInt(toDateYear))
  add(query_589621, "fromDate.year", newJInt(fromDateYear))
  result = call_589619.call(path_589620, query_589621, nil, nil, nil)

var cloudsearchStatsIndexDatasourcesGet* = Call_CloudsearchStatsIndexDatasourcesGet_589597(
    name: "cloudsearchStatsIndexDatasourcesGet", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/stats/index/{name}",
    validator: validate_CloudsearchStatsIndexDatasourcesGet_589598, base: "/",
    url: url_CloudsearchStatsIndexDatasourcesGet_589599, schemes: {Scheme.Https})
type
  Call_CloudsearchOperationsGet_589622 = ref object of OpenApiRestCall_588450
proc url_CloudsearchOperationsGet_589624(protocol: Scheme; host: string;
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

proc validate_CloudsearchOperationsGet_589623(path: JsonNode; query: JsonNode;
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
  var valid_589625 = path.getOrDefault("name")
  valid_589625 = validateParameter(valid_589625, JString, required = true,
                                 default = nil)
  if valid_589625 != nil:
    section.add "name", valid_589625
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
  var valid_589626 = query.getOrDefault("upload_protocol")
  valid_589626 = validateParameter(valid_589626, JString, required = false,
                                 default = nil)
  if valid_589626 != nil:
    section.add "upload_protocol", valid_589626
  var valid_589627 = query.getOrDefault("fields")
  valid_589627 = validateParameter(valid_589627, JString, required = false,
                                 default = nil)
  if valid_589627 != nil:
    section.add "fields", valid_589627
  var valid_589628 = query.getOrDefault("quotaUser")
  valid_589628 = validateParameter(valid_589628, JString, required = false,
                                 default = nil)
  if valid_589628 != nil:
    section.add "quotaUser", valid_589628
  var valid_589629 = query.getOrDefault("alt")
  valid_589629 = validateParameter(valid_589629, JString, required = false,
                                 default = newJString("json"))
  if valid_589629 != nil:
    section.add "alt", valid_589629
  var valid_589630 = query.getOrDefault("oauth_token")
  valid_589630 = validateParameter(valid_589630, JString, required = false,
                                 default = nil)
  if valid_589630 != nil:
    section.add "oauth_token", valid_589630
  var valid_589631 = query.getOrDefault("callback")
  valid_589631 = validateParameter(valid_589631, JString, required = false,
                                 default = nil)
  if valid_589631 != nil:
    section.add "callback", valid_589631
  var valid_589632 = query.getOrDefault("access_token")
  valid_589632 = validateParameter(valid_589632, JString, required = false,
                                 default = nil)
  if valid_589632 != nil:
    section.add "access_token", valid_589632
  var valid_589633 = query.getOrDefault("uploadType")
  valid_589633 = validateParameter(valid_589633, JString, required = false,
                                 default = nil)
  if valid_589633 != nil:
    section.add "uploadType", valid_589633
  var valid_589634 = query.getOrDefault("key")
  valid_589634 = validateParameter(valid_589634, JString, required = false,
                                 default = nil)
  if valid_589634 != nil:
    section.add "key", valid_589634
  var valid_589635 = query.getOrDefault("$.xgafv")
  valid_589635 = validateParameter(valid_589635, JString, required = false,
                                 default = newJString("1"))
  if valid_589635 != nil:
    section.add "$.xgafv", valid_589635
  var valid_589636 = query.getOrDefault("prettyPrint")
  valid_589636 = validateParameter(valid_589636, JBool, required = false,
                                 default = newJBool(true))
  if valid_589636 != nil:
    section.add "prettyPrint", valid_589636
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589637: Call_CloudsearchOperationsGet_589622; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_589637.validator(path, query, header, formData, body)
  let scheme = call_589637.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589637.url(scheme.get, call_589637.host, call_589637.base,
                         call_589637.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589637, url, valid)

proc call*(call_589638: Call_CloudsearchOperationsGet_589622; name: string;
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
  var path_589639 = newJObject()
  var query_589640 = newJObject()
  add(query_589640, "upload_protocol", newJString(uploadProtocol))
  add(query_589640, "fields", newJString(fields))
  add(query_589640, "quotaUser", newJString(quotaUser))
  add(path_589639, "name", newJString(name))
  add(query_589640, "alt", newJString(alt))
  add(query_589640, "oauth_token", newJString(oauthToken))
  add(query_589640, "callback", newJString(callback))
  add(query_589640, "access_token", newJString(accessToken))
  add(query_589640, "uploadType", newJString(uploadType))
  add(query_589640, "key", newJString(key))
  add(query_589640, "$.xgafv", newJString(Xgafv))
  add(query_589640, "prettyPrint", newJBool(prettyPrint))
  result = call_589638.call(path_589639, query_589640, nil, nil, nil)

var cloudsearchOperationsGet* = Call_CloudsearchOperationsGet_589622(
    name: "cloudsearchOperationsGet", meth: HttpMethod.HttpGet,
    host: "cloudsearch.googleapis.com", route: "/v1/{name}",
    validator: validate_CloudsearchOperationsGet_589623, base: "/",
    url: url_CloudsearchOperationsGet_589624, schemes: {Scheme.Https})
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
