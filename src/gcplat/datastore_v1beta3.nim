
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Datastore
## version: v1beta3
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Accesses the schemaless NoSQL database to provide fully managed, robust, scalable storage for your application.
## 
## 
## https://cloud.google.com/datastore/
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
  gcpServiceName = "datastore"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DatastoreProjectsAllocateIds_588719 = ref object of OpenApiRestCall_588450
proc url_DatastoreProjectsAllocateIds_588721(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: ":allocateIds")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatastoreProjectsAllocateIds_588720(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Allocates IDs for the given keys, which is useful for referencing an entity
  ## before it is inserted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The ID of the project against which to make the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_588847 = path.getOrDefault("projectId")
  valid_588847 = validateParameter(valid_588847, JString, required = true,
                                 default = nil)
  if valid_588847 != nil:
    section.add "projectId", valid_588847
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

proc call*(call_588895: Call_DatastoreProjectsAllocateIds_588719; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allocates IDs for the given keys, which is useful for referencing an entity
  ## before it is inserted.
  ## 
  let valid = call_588895.validator(path, query, header, formData, body)
  let scheme = call_588895.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588895.url(scheme.get, call_588895.host, call_588895.base,
                         call_588895.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588895, url, valid)

proc call*(call_588966: Call_DatastoreProjectsAllocateIds_588719;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## datastoreProjectsAllocateIds
  ## Allocates IDs for the given keys, which is useful for referencing an entity
  ## before it is inserted.
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
  ##   projectId: string (required)
  ##            : The ID of the project against which to make the request.
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
  add(query_588969, "alt", newJString(alt))
  add(query_588969, "oauth_token", newJString(oauthToken))
  add(query_588969, "callback", newJString(callback))
  add(query_588969, "access_token", newJString(accessToken))
  add(query_588969, "uploadType", newJString(uploadType))
  add(query_588969, "key", newJString(key))
  add(path_588967, "projectId", newJString(projectId))
  add(query_588969, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_588970 = body
  add(query_588969, "prettyPrint", newJBool(prettyPrint))
  result = call_588966.call(path_588967, query_588969, nil, nil, body_588970)

var datastoreProjectsAllocateIds* = Call_DatastoreProjectsAllocateIds_588719(
    name: "datastoreProjectsAllocateIds", meth: HttpMethod.HttpPost,
    host: "datastore.googleapis.com",
    route: "/v1beta3/projects/{projectId}:allocateIds",
    validator: validate_DatastoreProjectsAllocateIds_588720, base: "/",
    url: url_DatastoreProjectsAllocateIds_588721, schemes: {Scheme.Https})
type
  Call_DatastoreProjectsBeginTransaction_589009 = ref object of OpenApiRestCall_588450
proc url_DatastoreProjectsBeginTransaction_589011(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: ":beginTransaction")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatastoreProjectsBeginTransaction_589010(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Begins a new transaction.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The ID of the project against which to make the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_589012 = path.getOrDefault("projectId")
  valid_589012 = validateParameter(valid_589012, JString, required = true,
                                 default = nil)
  if valid_589012 != nil:
    section.add "projectId", valid_589012
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
  var valid_589022 = query.getOrDefault("$.xgafv")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = newJString("1"))
  if valid_589022 != nil:
    section.add "$.xgafv", valid_589022
  var valid_589023 = query.getOrDefault("prettyPrint")
  valid_589023 = validateParameter(valid_589023, JBool, required = false,
                                 default = newJBool(true))
  if valid_589023 != nil:
    section.add "prettyPrint", valid_589023
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

proc call*(call_589025: Call_DatastoreProjectsBeginTransaction_589009;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Begins a new transaction.
  ## 
  let valid = call_589025.validator(path, query, header, formData, body)
  let scheme = call_589025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589025.url(scheme.get, call_589025.host, call_589025.base,
                         call_589025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589025, url, valid)

proc call*(call_589026: Call_DatastoreProjectsBeginTransaction_589009;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## datastoreProjectsBeginTransaction
  ## Begins a new transaction.
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
  ##   projectId: string (required)
  ##            : The ID of the project against which to make the request.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589027 = newJObject()
  var query_589028 = newJObject()
  var body_589029 = newJObject()
  add(query_589028, "upload_protocol", newJString(uploadProtocol))
  add(query_589028, "fields", newJString(fields))
  add(query_589028, "quotaUser", newJString(quotaUser))
  add(query_589028, "alt", newJString(alt))
  add(query_589028, "oauth_token", newJString(oauthToken))
  add(query_589028, "callback", newJString(callback))
  add(query_589028, "access_token", newJString(accessToken))
  add(query_589028, "uploadType", newJString(uploadType))
  add(query_589028, "key", newJString(key))
  add(path_589027, "projectId", newJString(projectId))
  add(query_589028, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589029 = body
  add(query_589028, "prettyPrint", newJBool(prettyPrint))
  result = call_589026.call(path_589027, query_589028, nil, nil, body_589029)

var datastoreProjectsBeginTransaction* = Call_DatastoreProjectsBeginTransaction_589009(
    name: "datastoreProjectsBeginTransaction", meth: HttpMethod.HttpPost,
    host: "datastore.googleapis.com",
    route: "/v1beta3/projects/{projectId}:beginTransaction",
    validator: validate_DatastoreProjectsBeginTransaction_589010, base: "/",
    url: url_DatastoreProjectsBeginTransaction_589011, schemes: {Scheme.Https})
type
  Call_DatastoreProjectsCommit_589030 = ref object of OpenApiRestCall_588450
proc url_DatastoreProjectsCommit_589032(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: ":commit")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatastoreProjectsCommit_589031(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Commits a transaction, optionally creating, deleting or modifying some
  ## entities.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The ID of the project against which to make the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_589033 = path.getOrDefault("projectId")
  valid_589033 = validateParameter(valid_589033, JString, required = true,
                                 default = nil)
  if valid_589033 != nil:
    section.add "projectId", valid_589033
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
  var valid_589034 = query.getOrDefault("upload_protocol")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "upload_protocol", valid_589034
  var valid_589035 = query.getOrDefault("fields")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "fields", valid_589035
  var valid_589036 = query.getOrDefault("quotaUser")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "quotaUser", valid_589036
  var valid_589037 = query.getOrDefault("alt")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = newJString("json"))
  if valid_589037 != nil:
    section.add "alt", valid_589037
  var valid_589038 = query.getOrDefault("oauth_token")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "oauth_token", valid_589038
  var valid_589039 = query.getOrDefault("callback")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "callback", valid_589039
  var valid_589040 = query.getOrDefault("access_token")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "access_token", valid_589040
  var valid_589041 = query.getOrDefault("uploadType")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "uploadType", valid_589041
  var valid_589042 = query.getOrDefault("key")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "key", valid_589042
  var valid_589043 = query.getOrDefault("$.xgafv")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = newJString("1"))
  if valid_589043 != nil:
    section.add "$.xgafv", valid_589043
  var valid_589044 = query.getOrDefault("prettyPrint")
  valid_589044 = validateParameter(valid_589044, JBool, required = false,
                                 default = newJBool(true))
  if valid_589044 != nil:
    section.add "prettyPrint", valid_589044
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

proc call*(call_589046: Call_DatastoreProjectsCommit_589030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Commits a transaction, optionally creating, deleting or modifying some
  ## entities.
  ## 
  let valid = call_589046.validator(path, query, header, formData, body)
  let scheme = call_589046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589046.url(scheme.get, call_589046.host, call_589046.base,
                         call_589046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589046, url, valid)

proc call*(call_589047: Call_DatastoreProjectsCommit_589030; projectId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## datastoreProjectsCommit
  ## Commits a transaction, optionally creating, deleting or modifying some
  ## entities.
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
  ##   projectId: string (required)
  ##            : The ID of the project against which to make the request.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589048 = newJObject()
  var query_589049 = newJObject()
  var body_589050 = newJObject()
  add(query_589049, "upload_protocol", newJString(uploadProtocol))
  add(query_589049, "fields", newJString(fields))
  add(query_589049, "quotaUser", newJString(quotaUser))
  add(query_589049, "alt", newJString(alt))
  add(query_589049, "oauth_token", newJString(oauthToken))
  add(query_589049, "callback", newJString(callback))
  add(query_589049, "access_token", newJString(accessToken))
  add(query_589049, "uploadType", newJString(uploadType))
  add(query_589049, "key", newJString(key))
  add(path_589048, "projectId", newJString(projectId))
  add(query_589049, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589050 = body
  add(query_589049, "prettyPrint", newJBool(prettyPrint))
  result = call_589047.call(path_589048, query_589049, nil, nil, body_589050)

var datastoreProjectsCommit* = Call_DatastoreProjectsCommit_589030(
    name: "datastoreProjectsCommit", meth: HttpMethod.HttpPost,
    host: "datastore.googleapis.com",
    route: "/v1beta3/projects/{projectId}:commit",
    validator: validate_DatastoreProjectsCommit_589031, base: "/",
    url: url_DatastoreProjectsCommit_589032, schemes: {Scheme.Https})
type
  Call_DatastoreProjectsLookup_589051 = ref object of OpenApiRestCall_588450
proc url_DatastoreProjectsLookup_589053(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: ":lookup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatastoreProjectsLookup_589052(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Looks up entities by key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The ID of the project against which to make the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_589054 = path.getOrDefault("projectId")
  valid_589054 = validateParameter(valid_589054, JString, required = true,
                                 default = nil)
  if valid_589054 != nil:
    section.add "projectId", valid_589054
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
  var valid_589055 = query.getOrDefault("upload_protocol")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "upload_protocol", valid_589055
  var valid_589056 = query.getOrDefault("fields")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "fields", valid_589056
  var valid_589057 = query.getOrDefault("quotaUser")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "quotaUser", valid_589057
  var valid_589058 = query.getOrDefault("alt")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = newJString("json"))
  if valid_589058 != nil:
    section.add "alt", valid_589058
  var valid_589059 = query.getOrDefault("oauth_token")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "oauth_token", valid_589059
  var valid_589060 = query.getOrDefault("callback")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "callback", valid_589060
  var valid_589061 = query.getOrDefault("access_token")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "access_token", valid_589061
  var valid_589062 = query.getOrDefault("uploadType")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "uploadType", valid_589062
  var valid_589063 = query.getOrDefault("key")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "key", valid_589063
  var valid_589064 = query.getOrDefault("$.xgafv")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = newJString("1"))
  if valid_589064 != nil:
    section.add "$.xgafv", valid_589064
  var valid_589065 = query.getOrDefault("prettyPrint")
  valid_589065 = validateParameter(valid_589065, JBool, required = false,
                                 default = newJBool(true))
  if valid_589065 != nil:
    section.add "prettyPrint", valid_589065
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

proc call*(call_589067: Call_DatastoreProjectsLookup_589051; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Looks up entities by key.
  ## 
  let valid = call_589067.validator(path, query, header, formData, body)
  let scheme = call_589067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589067.url(scheme.get, call_589067.host, call_589067.base,
                         call_589067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589067, url, valid)

proc call*(call_589068: Call_DatastoreProjectsLookup_589051; projectId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## datastoreProjectsLookup
  ## Looks up entities by key.
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
  ##   projectId: string (required)
  ##            : The ID of the project against which to make the request.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589069 = newJObject()
  var query_589070 = newJObject()
  var body_589071 = newJObject()
  add(query_589070, "upload_protocol", newJString(uploadProtocol))
  add(query_589070, "fields", newJString(fields))
  add(query_589070, "quotaUser", newJString(quotaUser))
  add(query_589070, "alt", newJString(alt))
  add(query_589070, "oauth_token", newJString(oauthToken))
  add(query_589070, "callback", newJString(callback))
  add(query_589070, "access_token", newJString(accessToken))
  add(query_589070, "uploadType", newJString(uploadType))
  add(query_589070, "key", newJString(key))
  add(path_589069, "projectId", newJString(projectId))
  add(query_589070, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589071 = body
  add(query_589070, "prettyPrint", newJBool(prettyPrint))
  result = call_589068.call(path_589069, query_589070, nil, nil, body_589071)

var datastoreProjectsLookup* = Call_DatastoreProjectsLookup_589051(
    name: "datastoreProjectsLookup", meth: HttpMethod.HttpPost,
    host: "datastore.googleapis.com",
    route: "/v1beta3/projects/{projectId}:lookup",
    validator: validate_DatastoreProjectsLookup_589052, base: "/",
    url: url_DatastoreProjectsLookup_589053, schemes: {Scheme.Https})
type
  Call_DatastoreProjectsReserveIds_589072 = ref object of OpenApiRestCall_588450
proc url_DatastoreProjectsReserveIds_589074(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: ":reserveIds")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatastoreProjectsReserveIds_589073(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Prevents the supplied keys' IDs from being auto-allocated by Cloud
  ## Datastore.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The ID of the project against which to make the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_589075 = path.getOrDefault("projectId")
  valid_589075 = validateParameter(valid_589075, JString, required = true,
                                 default = nil)
  if valid_589075 != nil:
    section.add "projectId", valid_589075
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
  var valid_589076 = query.getOrDefault("upload_protocol")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "upload_protocol", valid_589076
  var valid_589077 = query.getOrDefault("fields")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "fields", valid_589077
  var valid_589078 = query.getOrDefault("quotaUser")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "quotaUser", valid_589078
  var valid_589079 = query.getOrDefault("alt")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = newJString("json"))
  if valid_589079 != nil:
    section.add "alt", valid_589079
  var valid_589080 = query.getOrDefault("oauth_token")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "oauth_token", valid_589080
  var valid_589081 = query.getOrDefault("callback")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "callback", valid_589081
  var valid_589082 = query.getOrDefault("access_token")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "access_token", valid_589082
  var valid_589083 = query.getOrDefault("uploadType")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "uploadType", valid_589083
  var valid_589084 = query.getOrDefault("key")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "key", valid_589084
  var valid_589085 = query.getOrDefault("$.xgafv")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = newJString("1"))
  if valid_589085 != nil:
    section.add "$.xgafv", valid_589085
  var valid_589086 = query.getOrDefault("prettyPrint")
  valid_589086 = validateParameter(valid_589086, JBool, required = false,
                                 default = newJBool(true))
  if valid_589086 != nil:
    section.add "prettyPrint", valid_589086
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

proc call*(call_589088: Call_DatastoreProjectsReserveIds_589072; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Prevents the supplied keys' IDs from being auto-allocated by Cloud
  ## Datastore.
  ## 
  let valid = call_589088.validator(path, query, header, formData, body)
  let scheme = call_589088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589088.url(scheme.get, call_589088.host, call_589088.base,
                         call_589088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589088, url, valid)

proc call*(call_589089: Call_DatastoreProjectsReserveIds_589072; projectId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## datastoreProjectsReserveIds
  ## Prevents the supplied keys' IDs from being auto-allocated by Cloud
  ## Datastore.
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
  ##   projectId: string (required)
  ##            : The ID of the project against which to make the request.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589090 = newJObject()
  var query_589091 = newJObject()
  var body_589092 = newJObject()
  add(query_589091, "upload_protocol", newJString(uploadProtocol))
  add(query_589091, "fields", newJString(fields))
  add(query_589091, "quotaUser", newJString(quotaUser))
  add(query_589091, "alt", newJString(alt))
  add(query_589091, "oauth_token", newJString(oauthToken))
  add(query_589091, "callback", newJString(callback))
  add(query_589091, "access_token", newJString(accessToken))
  add(query_589091, "uploadType", newJString(uploadType))
  add(query_589091, "key", newJString(key))
  add(path_589090, "projectId", newJString(projectId))
  add(query_589091, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589092 = body
  add(query_589091, "prettyPrint", newJBool(prettyPrint))
  result = call_589089.call(path_589090, query_589091, nil, nil, body_589092)

var datastoreProjectsReserveIds* = Call_DatastoreProjectsReserveIds_589072(
    name: "datastoreProjectsReserveIds", meth: HttpMethod.HttpPost,
    host: "datastore.googleapis.com",
    route: "/v1beta3/projects/{projectId}:reserveIds",
    validator: validate_DatastoreProjectsReserveIds_589073, base: "/",
    url: url_DatastoreProjectsReserveIds_589074, schemes: {Scheme.Https})
type
  Call_DatastoreProjectsRollback_589093 = ref object of OpenApiRestCall_588450
proc url_DatastoreProjectsRollback_589095(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: ":rollback")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatastoreProjectsRollback_589094(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rolls back a transaction.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The ID of the project against which to make the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_589096 = path.getOrDefault("projectId")
  valid_589096 = validateParameter(valid_589096, JString, required = true,
                                 default = nil)
  if valid_589096 != nil:
    section.add "projectId", valid_589096
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
  var valid_589097 = query.getOrDefault("upload_protocol")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "upload_protocol", valid_589097
  var valid_589098 = query.getOrDefault("fields")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "fields", valid_589098
  var valid_589099 = query.getOrDefault("quotaUser")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "quotaUser", valid_589099
  var valid_589100 = query.getOrDefault("alt")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = newJString("json"))
  if valid_589100 != nil:
    section.add "alt", valid_589100
  var valid_589101 = query.getOrDefault("oauth_token")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "oauth_token", valid_589101
  var valid_589102 = query.getOrDefault("callback")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "callback", valid_589102
  var valid_589103 = query.getOrDefault("access_token")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "access_token", valid_589103
  var valid_589104 = query.getOrDefault("uploadType")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "uploadType", valid_589104
  var valid_589105 = query.getOrDefault("key")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "key", valid_589105
  var valid_589106 = query.getOrDefault("$.xgafv")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = newJString("1"))
  if valid_589106 != nil:
    section.add "$.xgafv", valid_589106
  var valid_589107 = query.getOrDefault("prettyPrint")
  valid_589107 = validateParameter(valid_589107, JBool, required = false,
                                 default = newJBool(true))
  if valid_589107 != nil:
    section.add "prettyPrint", valid_589107
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

proc call*(call_589109: Call_DatastoreProjectsRollback_589093; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rolls back a transaction.
  ## 
  let valid = call_589109.validator(path, query, header, formData, body)
  let scheme = call_589109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589109.url(scheme.get, call_589109.host, call_589109.base,
                         call_589109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589109, url, valid)

proc call*(call_589110: Call_DatastoreProjectsRollback_589093; projectId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## datastoreProjectsRollback
  ## Rolls back a transaction.
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
  ##   projectId: string (required)
  ##            : The ID of the project against which to make the request.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589111 = newJObject()
  var query_589112 = newJObject()
  var body_589113 = newJObject()
  add(query_589112, "upload_protocol", newJString(uploadProtocol))
  add(query_589112, "fields", newJString(fields))
  add(query_589112, "quotaUser", newJString(quotaUser))
  add(query_589112, "alt", newJString(alt))
  add(query_589112, "oauth_token", newJString(oauthToken))
  add(query_589112, "callback", newJString(callback))
  add(query_589112, "access_token", newJString(accessToken))
  add(query_589112, "uploadType", newJString(uploadType))
  add(query_589112, "key", newJString(key))
  add(path_589111, "projectId", newJString(projectId))
  add(query_589112, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589113 = body
  add(query_589112, "prettyPrint", newJBool(prettyPrint))
  result = call_589110.call(path_589111, query_589112, nil, nil, body_589113)

var datastoreProjectsRollback* = Call_DatastoreProjectsRollback_589093(
    name: "datastoreProjectsRollback", meth: HttpMethod.HttpPost,
    host: "datastore.googleapis.com",
    route: "/v1beta3/projects/{projectId}:rollback",
    validator: validate_DatastoreProjectsRollback_589094, base: "/",
    url: url_DatastoreProjectsRollback_589095, schemes: {Scheme.Https})
type
  Call_DatastoreProjectsRunQuery_589114 = ref object of OpenApiRestCall_588450
proc url_DatastoreProjectsRunQuery_589116(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta3/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: ":runQuery")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatastoreProjectsRunQuery_589115(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Queries for entities.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The ID of the project against which to make the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_589117 = path.getOrDefault("projectId")
  valid_589117 = validateParameter(valid_589117, JString, required = true,
                                 default = nil)
  if valid_589117 != nil:
    section.add "projectId", valid_589117
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
  var valid_589118 = query.getOrDefault("upload_protocol")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "upload_protocol", valid_589118
  var valid_589119 = query.getOrDefault("fields")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "fields", valid_589119
  var valid_589120 = query.getOrDefault("quotaUser")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "quotaUser", valid_589120
  var valid_589121 = query.getOrDefault("alt")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = newJString("json"))
  if valid_589121 != nil:
    section.add "alt", valid_589121
  var valid_589122 = query.getOrDefault("oauth_token")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "oauth_token", valid_589122
  var valid_589123 = query.getOrDefault("callback")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "callback", valid_589123
  var valid_589124 = query.getOrDefault("access_token")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "access_token", valid_589124
  var valid_589125 = query.getOrDefault("uploadType")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "uploadType", valid_589125
  var valid_589126 = query.getOrDefault("key")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "key", valid_589126
  var valid_589127 = query.getOrDefault("$.xgafv")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = newJString("1"))
  if valid_589127 != nil:
    section.add "$.xgafv", valid_589127
  var valid_589128 = query.getOrDefault("prettyPrint")
  valid_589128 = validateParameter(valid_589128, JBool, required = false,
                                 default = newJBool(true))
  if valid_589128 != nil:
    section.add "prettyPrint", valid_589128
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

proc call*(call_589130: Call_DatastoreProjectsRunQuery_589114; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Queries for entities.
  ## 
  let valid = call_589130.validator(path, query, header, formData, body)
  let scheme = call_589130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589130.url(scheme.get, call_589130.host, call_589130.base,
                         call_589130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589130, url, valid)

proc call*(call_589131: Call_DatastoreProjectsRunQuery_589114; projectId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## datastoreProjectsRunQuery
  ## Queries for entities.
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
  ##   projectId: string (required)
  ##            : The ID of the project against which to make the request.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589132 = newJObject()
  var query_589133 = newJObject()
  var body_589134 = newJObject()
  add(query_589133, "upload_protocol", newJString(uploadProtocol))
  add(query_589133, "fields", newJString(fields))
  add(query_589133, "quotaUser", newJString(quotaUser))
  add(query_589133, "alt", newJString(alt))
  add(query_589133, "oauth_token", newJString(oauthToken))
  add(query_589133, "callback", newJString(callback))
  add(query_589133, "access_token", newJString(accessToken))
  add(query_589133, "uploadType", newJString(uploadType))
  add(query_589133, "key", newJString(key))
  add(path_589132, "projectId", newJString(projectId))
  add(query_589133, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589134 = body
  add(query_589133, "prettyPrint", newJBool(prettyPrint))
  result = call_589131.call(path_589132, query_589133, nil, nil, body_589134)

var datastoreProjectsRunQuery* = Call_DatastoreProjectsRunQuery_589114(
    name: "datastoreProjectsRunQuery", meth: HttpMethod.HttpPost,
    host: "datastore.googleapis.com",
    route: "/v1beta3/projects/{projectId}:runQuery",
    validator: validate_DatastoreProjectsRunQuery_589115, base: "/",
    url: url_DatastoreProjectsRunQuery_589116, schemes: {Scheme.Https})
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
