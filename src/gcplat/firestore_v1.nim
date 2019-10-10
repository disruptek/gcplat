
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Firestore
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Accesses the NoSQL document database built for automatic scaling, high performance, and ease of application development.
## 
## 
## https://cloud.google.com/firestore
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
  gcpServiceName = "firestore"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FirestoreProjectsDatabasesDocumentsBatchGet_588719 = ref object of OpenApiRestCall_588450
proc url_FirestoreProjectsDatabasesDocumentsBatchGet_588721(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "database" in path, "`database` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "database"),
               (kind: ConstantSegment, value: "/documents:batchGet")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesDocumentsBatchGet_588720(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets multiple documents.
  ## 
  ## Documents returned by this method are not guaranteed to be returned in the
  ## same order that they were requested.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   database: JString (required)
  ##           : The database name. In the format:
  ## `projects/{project_id}/databases/{database_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `database` field"
  var valid_588847 = path.getOrDefault("database")
  valid_588847 = validateParameter(valid_588847, JString, required = true,
                                 default = nil)
  if valid_588847 != nil:
    section.add "database", valid_588847
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

proc call*(call_588895: Call_FirestoreProjectsDatabasesDocumentsBatchGet_588719;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets multiple documents.
  ## 
  ## Documents returned by this method are not guaranteed to be returned in the
  ## same order that they were requested.
  ## 
  let valid = call_588895.validator(path, query, header, formData, body)
  let scheme = call_588895.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588895.url(scheme.get, call_588895.host, call_588895.base,
                         call_588895.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588895, url, valid)

proc call*(call_588966: Call_FirestoreProjectsDatabasesDocumentsBatchGet_588719;
          database: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## firestoreProjectsDatabasesDocumentsBatchGet
  ## Gets multiple documents.
  ## 
  ## Documents returned by this method are not guaranteed to be returned in the
  ## same order that they were requested.
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
  ##   database: string (required)
  ##           : The database name. In the format:
  ## `projects/{project_id}/databases/{database_id}`.
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
  add(path_588967, "database", newJString(database))
  add(query_588969, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_588970 = body
  add(query_588969, "prettyPrint", newJBool(prettyPrint))
  result = call_588966.call(path_588967, query_588969, nil, nil, body_588970)

var firestoreProjectsDatabasesDocumentsBatchGet* = Call_FirestoreProjectsDatabasesDocumentsBatchGet_588719(
    name: "firestoreProjectsDatabasesDocumentsBatchGet",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1/{database}/documents:batchGet",
    validator: validate_FirestoreProjectsDatabasesDocumentsBatchGet_588720,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsBatchGet_588721,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsBeginTransaction_589009 = ref object of OpenApiRestCall_588450
proc url_FirestoreProjectsDatabasesDocumentsBeginTransaction_589011(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "database" in path, "`database` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "database"),
               (kind: ConstantSegment, value: "/documents:beginTransaction")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesDocumentsBeginTransaction_589010(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Starts a new transaction.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   database: JString (required)
  ##           : The database name. In the format:
  ## `projects/{project_id}/databases/{database_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `database` field"
  var valid_589012 = path.getOrDefault("database")
  valid_589012 = validateParameter(valid_589012, JString, required = true,
                                 default = nil)
  if valid_589012 != nil:
    section.add "database", valid_589012
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

proc call*(call_589025: Call_FirestoreProjectsDatabasesDocumentsBeginTransaction_589009;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts a new transaction.
  ## 
  let valid = call_589025.validator(path, query, header, formData, body)
  let scheme = call_589025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589025.url(scheme.get, call_589025.host, call_589025.base,
                         call_589025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589025, url, valid)

proc call*(call_589026: Call_FirestoreProjectsDatabasesDocumentsBeginTransaction_589009;
          database: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## firestoreProjectsDatabasesDocumentsBeginTransaction
  ## Starts a new transaction.
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
  ##   database: string (required)
  ##           : The database name. In the format:
  ## `projects/{project_id}/databases/{database_id}`.
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
  add(path_589027, "database", newJString(database))
  add(query_589028, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589029 = body
  add(query_589028, "prettyPrint", newJBool(prettyPrint))
  result = call_589026.call(path_589027, query_589028, nil, nil, body_589029)

var firestoreProjectsDatabasesDocumentsBeginTransaction* = Call_FirestoreProjectsDatabasesDocumentsBeginTransaction_589009(
    name: "firestoreProjectsDatabasesDocumentsBeginTransaction",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1/{database}/documents:beginTransaction",
    validator: validate_FirestoreProjectsDatabasesDocumentsBeginTransaction_589010,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsBeginTransaction_589011,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsCommit_589030 = ref object of OpenApiRestCall_588450
proc url_FirestoreProjectsDatabasesDocumentsCommit_589032(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "database" in path, "`database` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "database"),
               (kind: ConstantSegment, value: "/documents:commit")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesDocumentsCommit_589031(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Commits a transaction, while optionally updating documents.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   database: JString (required)
  ##           : The database name. In the format:
  ## `projects/{project_id}/databases/{database_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `database` field"
  var valid_589033 = path.getOrDefault("database")
  valid_589033 = validateParameter(valid_589033, JString, required = true,
                                 default = nil)
  if valid_589033 != nil:
    section.add "database", valid_589033
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

proc call*(call_589046: Call_FirestoreProjectsDatabasesDocumentsCommit_589030;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Commits a transaction, while optionally updating documents.
  ## 
  let valid = call_589046.validator(path, query, header, formData, body)
  let scheme = call_589046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589046.url(scheme.get, call_589046.host, call_589046.base,
                         call_589046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589046, url, valid)

proc call*(call_589047: Call_FirestoreProjectsDatabasesDocumentsCommit_589030;
          database: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## firestoreProjectsDatabasesDocumentsCommit
  ## Commits a transaction, while optionally updating documents.
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
  ##   database: string (required)
  ##           : The database name. In the format:
  ## `projects/{project_id}/databases/{database_id}`.
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
  add(path_589048, "database", newJString(database))
  add(query_589049, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589050 = body
  add(query_589049, "prettyPrint", newJBool(prettyPrint))
  result = call_589047.call(path_589048, query_589049, nil, nil, body_589050)

var firestoreProjectsDatabasesDocumentsCommit* = Call_FirestoreProjectsDatabasesDocumentsCommit_589030(
    name: "firestoreProjectsDatabasesDocumentsCommit", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com", route: "/v1/{database}/documents:commit",
    validator: validate_FirestoreProjectsDatabasesDocumentsCommit_589031,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsCommit_589032,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsListen_589051 = ref object of OpenApiRestCall_588450
proc url_FirestoreProjectsDatabasesDocumentsListen_589053(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "database" in path, "`database` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "database"),
               (kind: ConstantSegment, value: "/documents:listen")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesDocumentsListen_589052(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Listens to changes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   database: JString (required)
  ##           : The database name. In the format:
  ## `projects/{project_id}/databases/{database_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `database` field"
  var valid_589054 = path.getOrDefault("database")
  valid_589054 = validateParameter(valid_589054, JString, required = true,
                                 default = nil)
  if valid_589054 != nil:
    section.add "database", valid_589054
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

proc call*(call_589067: Call_FirestoreProjectsDatabasesDocumentsListen_589051;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Listens to changes.
  ## 
  let valid = call_589067.validator(path, query, header, formData, body)
  let scheme = call_589067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589067.url(scheme.get, call_589067.host, call_589067.base,
                         call_589067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589067, url, valid)

proc call*(call_589068: Call_FirestoreProjectsDatabasesDocumentsListen_589051;
          database: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## firestoreProjectsDatabasesDocumentsListen
  ## Listens to changes.
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
  ##   database: string (required)
  ##           : The database name. In the format:
  ## `projects/{project_id}/databases/{database_id}`.
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
  add(path_589069, "database", newJString(database))
  add(query_589070, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589071 = body
  add(query_589070, "prettyPrint", newJBool(prettyPrint))
  result = call_589068.call(path_589069, query_589070, nil, nil, body_589071)

var firestoreProjectsDatabasesDocumentsListen* = Call_FirestoreProjectsDatabasesDocumentsListen_589051(
    name: "firestoreProjectsDatabasesDocumentsListen", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com", route: "/v1/{database}/documents:listen",
    validator: validate_FirestoreProjectsDatabasesDocumentsListen_589052,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsListen_589053,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsRollback_589072 = ref object of OpenApiRestCall_588450
proc url_FirestoreProjectsDatabasesDocumentsRollback_589074(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "database" in path, "`database` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "database"),
               (kind: ConstantSegment, value: "/documents:rollback")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesDocumentsRollback_589073(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rolls back a transaction.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   database: JString (required)
  ##           : The database name. In the format:
  ## `projects/{project_id}/databases/{database_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `database` field"
  var valid_589075 = path.getOrDefault("database")
  valid_589075 = validateParameter(valid_589075, JString, required = true,
                                 default = nil)
  if valid_589075 != nil:
    section.add "database", valid_589075
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

proc call*(call_589088: Call_FirestoreProjectsDatabasesDocumentsRollback_589072;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rolls back a transaction.
  ## 
  let valid = call_589088.validator(path, query, header, formData, body)
  let scheme = call_589088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589088.url(scheme.get, call_589088.host, call_589088.base,
                         call_589088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589088, url, valid)

proc call*(call_589089: Call_FirestoreProjectsDatabasesDocumentsRollback_589072;
          database: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## firestoreProjectsDatabasesDocumentsRollback
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
  ##   database: string (required)
  ##           : The database name. In the format:
  ## `projects/{project_id}/databases/{database_id}`.
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
  add(path_589090, "database", newJString(database))
  add(query_589091, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589092 = body
  add(query_589091, "prettyPrint", newJBool(prettyPrint))
  result = call_589089.call(path_589090, query_589091, nil, nil, body_589092)

var firestoreProjectsDatabasesDocumentsRollback* = Call_FirestoreProjectsDatabasesDocumentsRollback_589072(
    name: "firestoreProjectsDatabasesDocumentsRollback",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1/{database}/documents:rollback",
    validator: validate_FirestoreProjectsDatabasesDocumentsRollback_589073,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsRollback_589074,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsWrite_589093 = ref object of OpenApiRestCall_588450
proc url_FirestoreProjectsDatabasesDocumentsWrite_589095(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "database" in path, "`database` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "database"),
               (kind: ConstantSegment, value: "/documents:write")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesDocumentsWrite_589094(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Streams batches of document updates and deletes, in order.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   database: JString (required)
  ##           : The database name. In the format:
  ## `projects/{project_id}/databases/{database_id}`.
  ## This is only required in the first message.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `database` field"
  var valid_589096 = path.getOrDefault("database")
  valid_589096 = validateParameter(valid_589096, JString, required = true,
                                 default = nil)
  if valid_589096 != nil:
    section.add "database", valid_589096
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

proc call*(call_589109: Call_FirestoreProjectsDatabasesDocumentsWrite_589093;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Streams batches of document updates and deletes, in order.
  ## 
  let valid = call_589109.validator(path, query, header, formData, body)
  let scheme = call_589109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589109.url(scheme.get, call_589109.host, call_589109.base,
                         call_589109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589109, url, valid)

proc call*(call_589110: Call_FirestoreProjectsDatabasesDocumentsWrite_589093;
          database: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## firestoreProjectsDatabasesDocumentsWrite
  ## Streams batches of document updates and deletes, in order.
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
  ##   database: string (required)
  ##           : The database name. In the format:
  ## `projects/{project_id}/databases/{database_id}`.
  ## This is only required in the first message.
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
  add(path_589111, "database", newJString(database))
  add(query_589112, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589113 = body
  add(query_589112, "prettyPrint", newJBool(prettyPrint))
  result = call_589110.call(path_589111, query_589112, nil, nil, body_589113)

var firestoreProjectsDatabasesDocumentsWrite* = Call_FirestoreProjectsDatabasesDocumentsWrite_589093(
    name: "firestoreProjectsDatabasesDocumentsWrite", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com", route: "/v1/{database}/documents:write",
    validator: validate_FirestoreProjectsDatabasesDocumentsWrite_589094,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsWrite_589095,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsLocationsGet_589114 = ref object of OpenApiRestCall_588450
proc url_FirestoreProjectsLocationsGet_589116(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_FirestoreProjectsLocationsGet_589115(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Resource name for the location.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589117 = path.getOrDefault("name")
  valid_589117 = validateParameter(valid_589117, JString, required = true,
                                 default = nil)
  if valid_589117 != nil:
    section.add "name", valid_589117
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
  ##   readTime: JString
  ##           : Reads the version of the document at the given time.
  ## This may not be older than 60 seconds.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   transaction: JString
  ##              : Reads the document in a transaction.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   mask.fieldPaths: JArray
  ##                  : The list of field paths in the mask. See Document.fields for a field
  ## path syntax reference.
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
  var valid_589122 = query.getOrDefault("readTime")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "readTime", valid_589122
  var valid_589123 = query.getOrDefault("oauth_token")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "oauth_token", valid_589123
  var valid_589124 = query.getOrDefault("callback")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "callback", valid_589124
  var valid_589125 = query.getOrDefault("access_token")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "access_token", valid_589125
  var valid_589126 = query.getOrDefault("uploadType")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "uploadType", valid_589126
  var valid_589127 = query.getOrDefault("transaction")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "transaction", valid_589127
  var valid_589128 = query.getOrDefault("key")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "key", valid_589128
  var valid_589129 = query.getOrDefault("$.xgafv")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = newJString("1"))
  if valid_589129 != nil:
    section.add "$.xgafv", valid_589129
  var valid_589130 = query.getOrDefault("mask.fieldPaths")
  valid_589130 = validateParameter(valid_589130, JArray, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "mask.fieldPaths", valid_589130
  var valid_589131 = query.getOrDefault("prettyPrint")
  valid_589131 = validateParameter(valid_589131, JBool, required = false,
                                 default = newJBool(true))
  if valid_589131 != nil:
    section.add "prettyPrint", valid_589131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589132: Call_FirestoreProjectsLocationsGet_589114; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a location.
  ## 
  let valid = call_589132.validator(path, query, header, formData, body)
  let scheme = call_589132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589132.url(scheme.get, call_589132.host, call_589132.base,
                         call_589132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589132, url, valid)

proc call*(call_589133: Call_FirestoreProjectsLocationsGet_589114; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; readTime: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          transaction: string = ""; key: string = ""; Xgafv: string = "1";
          maskFieldPaths: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## firestoreProjectsLocationsGet
  ## Gets information about a location.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name for the location.
  ##   alt: string
  ##      : Data format for response.
  ##   readTime: string
  ##           : Reads the version of the document at the given time.
  ## This may not be older than 60 seconds.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   transaction: string
  ##              : Reads the document in a transaction.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   maskFieldPaths: JArray
  ##                 : The list of field paths in the mask. See Document.fields for a field
  ## path syntax reference.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589134 = newJObject()
  var query_589135 = newJObject()
  add(query_589135, "upload_protocol", newJString(uploadProtocol))
  add(query_589135, "fields", newJString(fields))
  add(query_589135, "quotaUser", newJString(quotaUser))
  add(path_589134, "name", newJString(name))
  add(query_589135, "alt", newJString(alt))
  add(query_589135, "readTime", newJString(readTime))
  add(query_589135, "oauth_token", newJString(oauthToken))
  add(query_589135, "callback", newJString(callback))
  add(query_589135, "access_token", newJString(accessToken))
  add(query_589135, "uploadType", newJString(uploadType))
  add(query_589135, "transaction", newJString(transaction))
  add(query_589135, "key", newJString(key))
  add(query_589135, "$.xgafv", newJString(Xgafv))
  if maskFieldPaths != nil:
    query_589135.add "mask.fieldPaths", maskFieldPaths
  add(query_589135, "prettyPrint", newJBool(prettyPrint))
  result = call_589133.call(path_589134, query_589135, nil, nil, nil)

var firestoreProjectsLocationsGet* = Call_FirestoreProjectsLocationsGet_589114(
    name: "firestoreProjectsLocationsGet", meth: HttpMethod.HttpGet,
    host: "firestore.googleapis.com", route: "/v1/{name}",
    validator: validate_FirestoreProjectsLocationsGet_589115, base: "/",
    url: url_FirestoreProjectsLocationsGet_589116, schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsPatch_589157 = ref object of OpenApiRestCall_588450
proc url_FirestoreProjectsDatabasesDocumentsPatch_589159(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_FirestoreProjectsDatabasesDocumentsPatch_589158(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates or inserts a document.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the document, for example
  ## `projects/{project_id}/databases/{database_id}/documents/{document_path}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589160 = path.getOrDefault("name")
  valid_589160 = validateParameter(valid_589160, JString, required = true,
                                 default = nil)
  if valid_589160 != nil:
    section.add "name", valid_589160
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
  ##   currentDocument.updateTime: JString
  ##                             : When set, the target document must exist and have been last updated at
  ## that time.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   updateMask.fieldPaths: JArray
  ##                        : The list of field paths in the mask. See Document.fields for a field
  ## path syntax reference.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   currentDocument.exists: JBool
  ##                         : When set to `true`, the target document must exist.
  ## When set to `false`, the target document must not exist.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   mask.fieldPaths: JArray
  ##                  : The list of field paths in the mask. See Document.fields for a field
  ## path syntax reference.
  section = newJObject()
  var valid_589161 = query.getOrDefault("upload_protocol")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "upload_protocol", valid_589161
  var valid_589162 = query.getOrDefault("fields")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "fields", valid_589162
  var valid_589163 = query.getOrDefault("quotaUser")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "quotaUser", valid_589163
  var valid_589164 = query.getOrDefault("alt")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = newJString("json"))
  if valid_589164 != nil:
    section.add "alt", valid_589164
  var valid_589165 = query.getOrDefault("currentDocument.updateTime")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "currentDocument.updateTime", valid_589165
  var valid_589166 = query.getOrDefault("oauth_token")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "oauth_token", valid_589166
  var valid_589167 = query.getOrDefault("callback")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "callback", valid_589167
  var valid_589168 = query.getOrDefault("access_token")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "access_token", valid_589168
  var valid_589169 = query.getOrDefault("uploadType")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "uploadType", valid_589169
  var valid_589170 = query.getOrDefault("updateMask.fieldPaths")
  valid_589170 = validateParameter(valid_589170, JArray, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "updateMask.fieldPaths", valid_589170
  var valid_589171 = query.getOrDefault("key")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "key", valid_589171
  var valid_589172 = query.getOrDefault("currentDocument.exists")
  valid_589172 = validateParameter(valid_589172, JBool, required = false, default = nil)
  if valid_589172 != nil:
    section.add "currentDocument.exists", valid_589172
  var valid_589173 = query.getOrDefault("$.xgafv")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = newJString("1"))
  if valid_589173 != nil:
    section.add "$.xgafv", valid_589173
  var valid_589174 = query.getOrDefault("prettyPrint")
  valid_589174 = validateParameter(valid_589174, JBool, required = false,
                                 default = newJBool(true))
  if valid_589174 != nil:
    section.add "prettyPrint", valid_589174
  var valid_589175 = query.getOrDefault("mask.fieldPaths")
  valid_589175 = validateParameter(valid_589175, JArray, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "mask.fieldPaths", valid_589175
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

proc call*(call_589177: Call_FirestoreProjectsDatabasesDocumentsPatch_589157;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates or inserts a document.
  ## 
  let valid = call_589177.validator(path, query, header, formData, body)
  let scheme = call_589177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589177.url(scheme.get, call_589177.host, call_589177.base,
                         call_589177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589177, url, valid)

proc call*(call_589178: Call_FirestoreProjectsDatabasesDocumentsPatch_589157;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json";
          currentDocumentUpdateTime: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          updateMaskFieldPaths: JsonNode = nil; key: string = "";
          currentDocumentExists: bool = false; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; maskFieldPaths: JsonNode = nil): Recallable =
  ## firestoreProjectsDatabasesDocumentsPatch
  ## Updates or inserts a document.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the document, for example
  ## `projects/{project_id}/databases/{database_id}/documents/{document_path}`.
  ##   alt: string
  ##      : Data format for response.
  ##   currentDocumentUpdateTime: string
  ##                            : When set, the target document must exist and have been last updated at
  ## that time.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   updateMaskFieldPaths: JArray
  ##                       : The list of field paths in the mask. See Document.fields for a field
  ## path syntax reference.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   currentDocumentExists: bool
  ##                        : When set to `true`, the target document must exist.
  ## When set to `false`, the target document must not exist.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   maskFieldPaths: JArray
  ##                 : The list of field paths in the mask. See Document.fields for a field
  ## path syntax reference.
  var path_589179 = newJObject()
  var query_589180 = newJObject()
  var body_589181 = newJObject()
  add(query_589180, "upload_protocol", newJString(uploadProtocol))
  add(query_589180, "fields", newJString(fields))
  add(query_589180, "quotaUser", newJString(quotaUser))
  add(path_589179, "name", newJString(name))
  add(query_589180, "alt", newJString(alt))
  add(query_589180, "currentDocument.updateTime",
      newJString(currentDocumentUpdateTime))
  add(query_589180, "oauth_token", newJString(oauthToken))
  add(query_589180, "callback", newJString(callback))
  add(query_589180, "access_token", newJString(accessToken))
  add(query_589180, "uploadType", newJString(uploadType))
  if updateMaskFieldPaths != nil:
    query_589180.add "updateMask.fieldPaths", updateMaskFieldPaths
  add(query_589180, "key", newJString(key))
  add(query_589180, "currentDocument.exists", newJBool(currentDocumentExists))
  add(query_589180, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589181 = body
  add(query_589180, "prettyPrint", newJBool(prettyPrint))
  if maskFieldPaths != nil:
    query_589180.add "mask.fieldPaths", maskFieldPaths
  result = call_589178.call(path_589179, query_589180, nil, nil, body_589181)

var firestoreProjectsDatabasesDocumentsPatch* = Call_FirestoreProjectsDatabasesDocumentsPatch_589157(
    name: "firestoreProjectsDatabasesDocumentsPatch", meth: HttpMethod.HttpPatch,
    host: "firestore.googleapis.com", route: "/v1/{name}",
    validator: validate_FirestoreProjectsDatabasesDocumentsPatch_589158,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsPatch_589159,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesOperationsDelete_589136 = ref object of OpenApiRestCall_588450
proc url_FirestoreProjectsDatabasesOperationsDelete_589138(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_FirestoreProjectsDatabasesOperationsDelete_589137(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589139 = path.getOrDefault("name")
  valid_589139 = validateParameter(valid_589139, JString, required = true,
                                 default = nil)
  if valid_589139 != nil:
    section.add "name", valid_589139
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
  ##   currentDocument.updateTime: JString
  ##                             : When set, the target document must exist and have been last updated at
  ## that time.
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
  ##   currentDocument.exists: JBool
  ##                         : When set to `true`, the target document must exist.
  ## When set to `false`, the target document must not exist.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589140 = query.getOrDefault("upload_protocol")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "upload_protocol", valid_589140
  var valid_589141 = query.getOrDefault("fields")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "fields", valid_589141
  var valid_589142 = query.getOrDefault("quotaUser")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "quotaUser", valid_589142
  var valid_589143 = query.getOrDefault("alt")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = newJString("json"))
  if valid_589143 != nil:
    section.add "alt", valid_589143
  var valid_589144 = query.getOrDefault("currentDocument.updateTime")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "currentDocument.updateTime", valid_589144
  var valid_589145 = query.getOrDefault("oauth_token")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = nil)
  if valid_589145 != nil:
    section.add "oauth_token", valid_589145
  var valid_589146 = query.getOrDefault("callback")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "callback", valid_589146
  var valid_589147 = query.getOrDefault("access_token")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "access_token", valid_589147
  var valid_589148 = query.getOrDefault("uploadType")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "uploadType", valid_589148
  var valid_589149 = query.getOrDefault("key")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "key", valid_589149
  var valid_589150 = query.getOrDefault("currentDocument.exists")
  valid_589150 = validateParameter(valid_589150, JBool, required = false, default = nil)
  if valid_589150 != nil:
    section.add "currentDocument.exists", valid_589150
  var valid_589151 = query.getOrDefault("$.xgafv")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = newJString("1"))
  if valid_589151 != nil:
    section.add "$.xgafv", valid_589151
  var valid_589152 = query.getOrDefault("prettyPrint")
  valid_589152 = validateParameter(valid_589152, JBool, required = false,
                                 default = newJBool(true))
  if valid_589152 != nil:
    section.add "prettyPrint", valid_589152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589153: Call_FirestoreProjectsDatabasesOperationsDelete_589136;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_589153.validator(path, query, header, formData, body)
  let scheme = call_589153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589153.url(scheme.get, call_589153.host, call_589153.base,
                         call_589153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589153, url, valid)

proc call*(call_589154: Call_FirestoreProjectsDatabasesOperationsDelete_589136;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json";
          currentDocumentUpdateTime: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; currentDocumentExists: bool = false; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## firestoreProjectsDatabasesOperationsDelete
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be deleted.
  ##   alt: string
  ##      : Data format for response.
  ##   currentDocumentUpdateTime: string
  ##                            : When set, the target document must exist and have been last updated at
  ## that time.
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
  ##   currentDocumentExists: bool
  ##                        : When set to `true`, the target document must exist.
  ## When set to `false`, the target document must not exist.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589155 = newJObject()
  var query_589156 = newJObject()
  add(query_589156, "upload_protocol", newJString(uploadProtocol))
  add(query_589156, "fields", newJString(fields))
  add(query_589156, "quotaUser", newJString(quotaUser))
  add(path_589155, "name", newJString(name))
  add(query_589156, "alt", newJString(alt))
  add(query_589156, "currentDocument.updateTime",
      newJString(currentDocumentUpdateTime))
  add(query_589156, "oauth_token", newJString(oauthToken))
  add(query_589156, "callback", newJString(callback))
  add(query_589156, "access_token", newJString(accessToken))
  add(query_589156, "uploadType", newJString(uploadType))
  add(query_589156, "key", newJString(key))
  add(query_589156, "currentDocument.exists", newJBool(currentDocumentExists))
  add(query_589156, "$.xgafv", newJString(Xgafv))
  add(query_589156, "prettyPrint", newJBool(prettyPrint))
  result = call_589154.call(path_589155, query_589156, nil, nil, nil)

var firestoreProjectsDatabasesOperationsDelete* = Call_FirestoreProjectsDatabasesOperationsDelete_589136(
    name: "firestoreProjectsDatabasesOperationsDelete",
    meth: HttpMethod.HttpDelete, host: "firestore.googleapis.com",
    route: "/v1/{name}",
    validator: validate_FirestoreProjectsDatabasesOperationsDelete_589137,
    base: "/", url: url_FirestoreProjectsDatabasesOperationsDelete_589138,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsLocationsList_589182 = ref object of OpenApiRestCall_588450
proc url_FirestoreProjectsLocationsList_589184(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsLocationsList_589183(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists information about the supported locations for this service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource that owns the locations collection, if applicable.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589185 = path.getOrDefault("name")
  valid_589185 = validateParameter(valid_589185, JString, required = true,
                                 default = nil)
  if valid_589185 != nil:
    section.add "name", valid_589185
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The standard list page token.
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
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The standard list filter.
  section = newJObject()
  var valid_589186 = query.getOrDefault("upload_protocol")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "upload_protocol", valid_589186
  var valid_589187 = query.getOrDefault("fields")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = nil)
  if valid_589187 != nil:
    section.add "fields", valid_589187
  var valid_589188 = query.getOrDefault("pageToken")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "pageToken", valid_589188
  var valid_589189 = query.getOrDefault("quotaUser")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "quotaUser", valid_589189
  var valid_589190 = query.getOrDefault("alt")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = newJString("json"))
  if valid_589190 != nil:
    section.add "alt", valid_589190
  var valid_589191 = query.getOrDefault("oauth_token")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "oauth_token", valid_589191
  var valid_589192 = query.getOrDefault("callback")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "callback", valid_589192
  var valid_589193 = query.getOrDefault("access_token")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "access_token", valid_589193
  var valid_589194 = query.getOrDefault("uploadType")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "uploadType", valid_589194
  var valid_589195 = query.getOrDefault("key")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "key", valid_589195
  var valid_589196 = query.getOrDefault("$.xgafv")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = newJString("1"))
  if valid_589196 != nil:
    section.add "$.xgafv", valid_589196
  var valid_589197 = query.getOrDefault("pageSize")
  valid_589197 = validateParameter(valid_589197, JInt, required = false, default = nil)
  if valid_589197 != nil:
    section.add "pageSize", valid_589197
  var valid_589198 = query.getOrDefault("prettyPrint")
  valid_589198 = validateParameter(valid_589198, JBool, required = false,
                                 default = newJBool(true))
  if valid_589198 != nil:
    section.add "prettyPrint", valid_589198
  var valid_589199 = query.getOrDefault("filter")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "filter", valid_589199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589200: Call_FirestoreProjectsLocationsList_589182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_589200.validator(path, query, header, formData, body)
  let scheme = call_589200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589200.url(scheme.get, call_589200.host, call_589200.base,
                         call_589200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589200, url, valid)

proc call*(call_589201: Call_FirestoreProjectsLocationsList_589182; name: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## firestoreProjectsLocationsList
  ## Lists information about the supported locations for this service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource that owns the locations collection, if applicable.
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
  ##   pageSize: int
  ##           : The standard list page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The standard list filter.
  var path_589202 = newJObject()
  var query_589203 = newJObject()
  add(query_589203, "upload_protocol", newJString(uploadProtocol))
  add(query_589203, "fields", newJString(fields))
  add(query_589203, "pageToken", newJString(pageToken))
  add(query_589203, "quotaUser", newJString(quotaUser))
  add(path_589202, "name", newJString(name))
  add(query_589203, "alt", newJString(alt))
  add(query_589203, "oauth_token", newJString(oauthToken))
  add(query_589203, "callback", newJString(callback))
  add(query_589203, "access_token", newJString(accessToken))
  add(query_589203, "uploadType", newJString(uploadType))
  add(query_589203, "key", newJString(key))
  add(query_589203, "$.xgafv", newJString(Xgafv))
  add(query_589203, "pageSize", newJInt(pageSize))
  add(query_589203, "prettyPrint", newJBool(prettyPrint))
  add(query_589203, "filter", newJString(filter))
  result = call_589201.call(path_589202, query_589203, nil, nil, nil)

var firestoreProjectsLocationsList* = Call_FirestoreProjectsLocationsList_589182(
    name: "firestoreProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "firestore.googleapis.com", route: "/v1/{name}/locations",
    validator: validate_FirestoreProjectsLocationsList_589183, base: "/",
    url: url_FirestoreProjectsLocationsList_589184, schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesOperationsList_589204 = ref object of OpenApiRestCall_588450
proc url_FirestoreProjectsDatabasesOperationsList_589206(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesOperationsList_589205(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation's parent resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589207 = path.getOrDefault("name")
  valid_589207 = validateParameter(valid_589207, JString, required = true,
                                 default = nil)
  if valid_589207 != nil:
    section.add "name", valid_589207
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The standard list page token.
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
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The standard list filter.
  section = newJObject()
  var valid_589208 = query.getOrDefault("upload_protocol")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "upload_protocol", valid_589208
  var valid_589209 = query.getOrDefault("fields")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "fields", valid_589209
  var valid_589210 = query.getOrDefault("pageToken")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = nil)
  if valid_589210 != nil:
    section.add "pageToken", valid_589210
  var valid_589211 = query.getOrDefault("quotaUser")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "quotaUser", valid_589211
  var valid_589212 = query.getOrDefault("alt")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = newJString("json"))
  if valid_589212 != nil:
    section.add "alt", valid_589212
  var valid_589213 = query.getOrDefault("oauth_token")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "oauth_token", valid_589213
  var valid_589214 = query.getOrDefault("callback")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "callback", valid_589214
  var valid_589215 = query.getOrDefault("access_token")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "access_token", valid_589215
  var valid_589216 = query.getOrDefault("uploadType")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "uploadType", valid_589216
  var valid_589217 = query.getOrDefault("key")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = nil)
  if valid_589217 != nil:
    section.add "key", valid_589217
  var valid_589218 = query.getOrDefault("$.xgafv")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = newJString("1"))
  if valid_589218 != nil:
    section.add "$.xgafv", valid_589218
  var valid_589219 = query.getOrDefault("pageSize")
  valid_589219 = validateParameter(valid_589219, JInt, required = false, default = nil)
  if valid_589219 != nil:
    section.add "pageSize", valid_589219
  var valid_589220 = query.getOrDefault("prettyPrint")
  valid_589220 = validateParameter(valid_589220, JBool, required = false,
                                 default = newJBool(true))
  if valid_589220 != nil:
    section.add "prettyPrint", valid_589220
  var valid_589221 = query.getOrDefault("filter")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "filter", valid_589221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589222: Call_FirestoreProjectsDatabasesOperationsList_589204;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ## 
  let valid = call_589222.validator(path, query, header, formData, body)
  let scheme = call_589222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589222.url(scheme.get, call_589222.host, call_589222.base,
                         call_589222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589222, url, valid)

proc call*(call_589223: Call_FirestoreProjectsDatabasesOperationsList_589204;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## firestoreProjectsDatabasesOperationsList
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation's parent resource.
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
  ##   pageSize: int
  ##           : The standard list page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The standard list filter.
  var path_589224 = newJObject()
  var query_589225 = newJObject()
  add(query_589225, "upload_protocol", newJString(uploadProtocol))
  add(query_589225, "fields", newJString(fields))
  add(query_589225, "pageToken", newJString(pageToken))
  add(query_589225, "quotaUser", newJString(quotaUser))
  add(path_589224, "name", newJString(name))
  add(query_589225, "alt", newJString(alt))
  add(query_589225, "oauth_token", newJString(oauthToken))
  add(query_589225, "callback", newJString(callback))
  add(query_589225, "access_token", newJString(accessToken))
  add(query_589225, "uploadType", newJString(uploadType))
  add(query_589225, "key", newJString(key))
  add(query_589225, "$.xgafv", newJString(Xgafv))
  add(query_589225, "pageSize", newJInt(pageSize))
  add(query_589225, "prettyPrint", newJBool(prettyPrint))
  add(query_589225, "filter", newJString(filter))
  result = call_589223.call(path_589224, query_589225, nil, nil, nil)

var firestoreProjectsDatabasesOperationsList* = Call_FirestoreProjectsDatabasesOperationsList_589204(
    name: "firestoreProjectsDatabasesOperationsList", meth: HttpMethod.HttpGet,
    host: "firestore.googleapis.com", route: "/v1/{name}/operations",
    validator: validate_FirestoreProjectsDatabasesOperationsList_589205,
    base: "/", url: url_FirestoreProjectsDatabasesOperationsList_589206,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesOperationsCancel_589226 = ref object of OpenApiRestCall_588450
proc url_FirestoreProjectsDatabasesOperationsCancel_589228(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesOperationsCancel_589227(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be cancelled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589229 = path.getOrDefault("name")
  valid_589229 = validateParameter(valid_589229, JString, required = true,
                                 default = nil)
  if valid_589229 != nil:
    section.add "name", valid_589229
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
  var valid_589230 = query.getOrDefault("upload_protocol")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "upload_protocol", valid_589230
  var valid_589231 = query.getOrDefault("fields")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "fields", valid_589231
  var valid_589232 = query.getOrDefault("quotaUser")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "quotaUser", valid_589232
  var valid_589233 = query.getOrDefault("alt")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = newJString("json"))
  if valid_589233 != nil:
    section.add "alt", valid_589233
  var valid_589234 = query.getOrDefault("oauth_token")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "oauth_token", valid_589234
  var valid_589235 = query.getOrDefault("callback")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = nil)
  if valid_589235 != nil:
    section.add "callback", valid_589235
  var valid_589236 = query.getOrDefault("access_token")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "access_token", valid_589236
  var valid_589237 = query.getOrDefault("uploadType")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "uploadType", valid_589237
  var valid_589238 = query.getOrDefault("key")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "key", valid_589238
  var valid_589239 = query.getOrDefault("$.xgafv")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = newJString("1"))
  if valid_589239 != nil:
    section.add "$.xgafv", valid_589239
  var valid_589240 = query.getOrDefault("prettyPrint")
  valid_589240 = validateParameter(valid_589240, JBool, required = false,
                                 default = newJBool(true))
  if valid_589240 != nil:
    section.add "prettyPrint", valid_589240
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

proc call*(call_589242: Call_FirestoreProjectsDatabasesOperationsCancel_589226;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  let valid = call_589242.validator(path, query, header, formData, body)
  let scheme = call_589242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589242.url(scheme.get, call_589242.host, call_589242.base,
                         call_589242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589242, url, valid)

proc call*(call_589243: Call_FirestoreProjectsDatabasesOperationsCancel_589226;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## firestoreProjectsDatabasesOperationsCancel
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be cancelled.
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
  var path_589244 = newJObject()
  var query_589245 = newJObject()
  var body_589246 = newJObject()
  add(query_589245, "upload_protocol", newJString(uploadProtocol))
  add(query_589245, "fields", newJString(fields))
  add(query_589245, "quotaUser", newJString(quotaUser))
  add(path_589244, "name", newJString(name))
  add(query_589245, "alt", newJString(alt))
  add(query_589245, "oauth_token", newJString(oauthToken))
  add(query_589245, "callback", newJString(callback))
  add(query_589245, "access_token", newJString(accessToken))
  add(query_589245, "uploadType", newJString(uploadType))
  add(query_589245, "key", newJString(key))
  add(query_589245, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589246 = body
  add(query_589245, "prettyPrint", newJBool(prettyPrint))
  result = call_589243.call(path_589244, query_589245, nil, nil, body_589246)

var firestoreProjectsDatabasesOperationsCancel* = Call_FirestoreProjectsDatabasesOperationsCancel_589226(
    name: "firestoreProjectsDatabasesOperationsCancel", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_FirestoreProjectsDatabasesOperationsCancel_589227,
    base: "/", url: url_FirestoreProjectsDatabasesOperationsCancel_589228,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesExportDocuments_589247 = ref object of OpenApiRestCall_588450
proc url_FirestoreProjectsDatabasesExportDocuments_589249(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":exportDocuments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesExportDocuments_589248(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Exports a copy of all or a subset of documents from Google Cloud Firestore
  ## to another storage system, such as Google Cloud Storage. Recent updates to
  ## documents may not be reflected in the export. The export occurs in the
  ## background and its progress can be monitored and managed via the
  ## Operation resource that is created. The output of an export may only be
  ## used once the associated operation is done. If an export operation is
  ## cancelled before completion it may leave partial data behind in Google
  ## Cloud Storage.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Database to export. Should be of the form:
  ## `projects/{project_id}/databases/{database_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589250 = path.getOrDefault("name")
  valid_589250 = validateParameter(valid_589250, JString, required = true,
                                 default = nil)
  if valid_589250 != nil:
    section.add "name", valid_589250
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
  var valid_589251 = query.getOrDefault("upload_protocol")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "upload_protocol", valid_589251
  var valid_589252 = query.getOrDefault("fields")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = nil)
  if valid_589252 != nil:
    section.add "fields", valid_589252
  var valid_589253 = query.getOrDefault("quotaUser")
  valid_589253 = validateParameter(valid_589253, JString, required = false,
                                 default = nil)
  if valid_589253 != nil:
    section.add "quotaUser", valid_589253
  var valid_589254 = query.getOrDefault("alt")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = newJString("json"))
  if valid_589254 != nil:
    section.add "alt", valid_589254
  var valid_589255 = query.getOrDefault("oauth_token")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = nil)
  if valid_589255 != nil:
    section.add "oauth_token", valid_589255
  var valid_589256 = query.getOrDefault("callback")
  valid_589256 = validateParameter(valid_589256, JString, required = false,
                                 default = nil)
  if valid_589256 != nil:
    section.add "callback", valid_589256
  var valid_589257 = query.getOrDefault("access_token")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = nil)
  if valid_589257 != nil:
    section.add "access_token", valid_589257
  var valid_589258 = query.getOrDefault("uploadType")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "uploadType", valid_589258
  var valid_589259 = query.getOrDefault("key")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = nil)
  if valid_589259 != nil:
    section.add "key", valid_589259
  var valid_589260 = query.getOrDefault("$.xgafv")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = newJString("1"))
  if valid_589260 != nil:
    section.add "$.xgafv", valid_589260
  var valid_589261 = query.getOrDefault("prettyPrint")
  valid_589261 = validateParameter(valid_589261, JBool, required = false,
                                 default = newJBool(true))
  if valid_589261 != nil:
    section.add "prettyPrint", valid_589261
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

proc call*(call_589263: Call_FirestoreProjectsDatabasesExportDocuments_589247;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Exports a copy of all or a subset of documents from Google Cloud Firestore
  ## to another storage system, such as Google Cloud Storage. Recent updates to
  ## documents may not be reflected in the export. The export occurs in the
  ## background and its progress can be monitored and managed via the
  ## Operation resource that is created. The output of an export may only be
  ## used once the associated operation is done. If an export operation is
  ## cancelled before completion it may leave partial data behind in Google
  ## Cloud Storage.
  ## 
  let valid = call_589263.validator(path, query, header, formData, body)
  let scheme = call_589263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589263.url(scheme.get, call_589263.host, call_589263.base,
                         call_589263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589263, url, valid)

proc call*(call_589264: Call_FirestoreProjectsDatabasesExportDocuments_589247;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## firestoreProjectsDatabasesExportDocuments
  ## Exports a copy of all or a subset of documents from Google Cloud Firestore
  ## to another storage system, such as Google Cloud Storage. Recent updates to
  ## documents may not be reflected in the export. The export occurs in the
  ## background and its progress can be monitored and managed via the
  ## Operation resource that is created. The output of an export may only be
  ## used once the associated operation is done. If an export operation is
  ## cancelled before completion it may leave partial data behind in Google
  ## Cloud Storage.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Database to export. Should be of the form:
  ## `projects/{project_id}/databases/{database_id}`.
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
  var path_589265 = newJObject()
  var query_589266 = newJObject()
  var body_589267 = newJObject()
  add(query_589266, "upload_protocol", newJString(uploadProtocol))
  add(query_589266, "fields", newJString(fields))
  add(query_589266, "quotaUser", newJString(quotaUser))
  add(path_589265, "name", newJString(name))
  add(query_589266, "alt", newJString(alt))
  add(query_589266, "oauth_token", newJString(oauthToken))
  add(query_589266, "callback", newJString(callback))
  add(query_589266, "access_token", newJString(accessToken))
  add(query_589266, "uploadType", newJString(uploadType))
  add(query_589266, "key", newJString(key))
  add(query_589266, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589267 = body
  add(query_589266, "prettyPrint", newJBool(prettyPrint))
  result = call_589264.call(path_589265, query_589266, nil, nil, body_589267)

var firestoreProjectsDatabasesExportDocuments* = Call_FirestoreProjectsDatabasesExportDocuments_589247(
    name: "firestoreProjectsDatabasesExportDocuments", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com", route: "/v1/{name}:exportDocuments",
    validator: validate_FirestoreProjectsDatabasesExportDocuments_589248,
    base: "/", url: url_FirestoreProjectsDatabasesExportDocuments_589249,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesImportDocuments_589268 = ref object of OpenApiRestCall_588450
proc url_FirestoreProjectsDatabasesImportDocuments_589270(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":importDocuments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesImportDocuments_589269(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Imports documents into Google Cloud Firestore. Existing documents with the
  ## same name are overwritten. The import occurs in the background and its
  ## progress can be monitored and managed via the Operation resource that is
  ## created. If an ImportDocuments operation is cancelled, it is possible
  ## that a subset of the data has already been imported to Cloud Firestore.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Database to import into. Should be of the form:
  ## `projects/{project_id}/databases/{database_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589271 = path.getOrDefault("name")
  valid_589271 = validateParameter(valid_589271, JString, required = true,
                                 default = nil)
  if valid_589271 != nil:
    section.add "name", valid_589271
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
  var valid_589272 = query.getOrDefault("upload_protocol")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = nil)
  if valid_589272 != nil:
    section.add "upload_protocol", valid_589272
  var valid_589273 = query.getOrDefault("fields")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = nil)
  if valid_589273 != nil:
    section.add "fields", valid_589273
  var valid_589274 = query.getOrDefault("quotaUser")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = nil)
  if valid_589274 != nil:
    section.add "quotaUser", valid_589274
  var valid_589275 = query.getOrDefault("alt")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = newJString("json"))
  if valid_589275 != nil:
    section.add "alt", valid_589275
  var valid_589276 = query.getOrDefault("oauth_token")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = nil)
  if valid_589276 != nil:
    section.add "oauth_token", valid_589276
  var valid_589277 = query.getOrDefault("callback")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = nil)
  if valid_589277 != nil:
    section.add "callback", valid_589277
  var valid_589278 = query.getOrDefault("access_token")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = nil)
  if valid_589278 != nil:
    section.add "access_token", valid_589278
  var valid_589279 = query.getOrDefault("uploadType")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "uploadType", valid_589279
  var valid_589280 = query.getOrDefault("key")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = nil)
  if valid_589280 != nil:
    section.add "key", valid_589280
  var valid_589281 = query.getOrDefault("$.xgafv")
  valid_589281 = validateParameter(valid_589281, JString, required = false,
                                 default = newJString("1"))
  if valid_589281 != nil:
    section.add "$.xgafv", valid_589281
  var valid_589282 = query.getOrDefault("prettyPrint")
  valid_589282 = validateParameter(valid_589282, JBool, required = false,
                                 default = newJBool(true))
  if valid_589282 != nil:
    section.add "prettyPrint", valid_589282
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

proc call*(call_589284: Call_FirestoreProjectsDatabasesImportDocuments_589268;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Imports documents into Google Cloud Firestore. Existing documents with the
  ## same name are overwritten. The import occurs in the background and its
  ## progress can be monitored and managed via the Operation resource that is
  ## created. If an ImportDocuments operation is cancelled, it is possible
  ## that a subset of the data has already been imported to Cloud Firestore.
  ## 
  let valid = call_589284.validator(path, query, header, formData, body)
  let scheme = call_589284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589284.url(scheme.get, call_589284.host, call_589284.base,
                         call_589284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589284, url, valid)

proc call*(call_589285: Call_FirestoreProjectsDatabasesImportDocuments_589268;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## firestoreProjectsDatabasesImportDocuments
  ## Imports documents into Google Cloud Firestore. Existing documents with the
  ## same name are overwritten. The import occurs in the background and its
  ## progress can be monitored and managed via the Operation resource that is
  ## created. If an ImportDocuments operation is cancelled, it is possible
  ## that a subset of the data has already been imported to Cloud Firestore.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Database to import into. Should be of the form:
  ## `projects/{project_id}/databases/{database_id}`.
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
  var path_589286 = newJObject()
  var query_589287 = newJObject()
  var body_589288 = newJObject()
  add(query_589287, "upload_protocol", newJString(uploadProtocol))
  add(query_589287, "fields", newJString(fields))
  add(query_589287, "quotaUser", newJString(quotaUser))
  add(path_589286, "name", newJString(name))
  add(query_589287, "alt", newJString(alt))
  add(query_589287, "oauth_token", newJString(oauthToken))
  add(query_589287, "callback", newJString(callback))
  add(query_589287, "access_token", newJString(accessToken))
  add(query_589287, "uploadType", newJString(uploadType))
  add(query_589287, "key", newJString(key))
  add(query_589287, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589288 = body
  add(query_589287, "prettyPrint", newJBool(prettyPrint))
  result = call_589285.call(path_589286, query_589287, nil, nil, body_589288)

var firestoreProjectsDatabasesImportDocuments* = Call_FirestoreProjectsDatabasesImportDocuments_589268(
    name: "firestoreProjectsDatabasesImportDocuments", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com", route: "/v1/{name}:importDocuments",
    validator: validate_FirestoreProjectsDatabasesImportDocuments_589269,
    base: "/", url: url_FirestoreProjectsDatabasesImportDocuments_589270,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesCollectionGroupsFieldsList_589289 = ref object of OpenApiRestCall_588450
proc url_FirestoreProjectsDatabasesCollectionGroupsFieldsList_589291(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/fields")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesCollectionGroupsFieldsList_589290(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the field configuration and metadata for this database.
  ## 
  ## Currently, FirestoreAdmin.ListFields only supports listing fields
  ## that have been explicitly overridden. To issue this query, call
  ## FirestoreAdmin.ListFields with the filter set to
  ## `indexConfig.usesAncestorConfig:false`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : A parent name of the form
  ## 
  ## `projects/{project_id}/databases/{database_id}/collectionGroups/{collection_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589292 = path.getOrDefault("parent")
  valid_589292 = validateParameter(valid_589292, JString, required = true,
                                 default = nil)
  if valid_589292 != nil:
    section.add "parent", valid_589292
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A page token, returned from a previous call to
  ## FirestoreAdmin.ListFields, that may be used to get the next
  ## page of results.
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
  ##   pageSize: JInt
  ##           : The number of results to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The filter to apply to list results. Currently,
  ## FirestoreAdmin.ListFields only supports listing fields
  ## that have been explicitly overridden. To issue this query, call
  ## FirestoreAdmin.ListFields with the filter set to
  ## `indexConfig.usesAncestorConfig:false`.
  section = newJObject()
  var valid_589293 = query.getOrDefault("upload_protocol")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "upload_protocol", valid_589293
  var valid_589294 = query.getOrDefault("fields")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "fields", valid_589294
  var valid_589295 = query.getOrDefault("pageToken")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "pageToken", valid_589295
  var valid_589296 = query.getOrDefault("quotaUser")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "quotaUser", valid_589296
  var valid_589297 = query.getOrDefault("alt")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = newJString("json"))
  if valid_589297 != nil:
    section.add "alt", valid_589297
  var valid_589298 = query.getOrDefault("oauth_token")
  valid_589298 = validateParameter(valid_589298, JString, required = false,
                                 default = nil)
  if valid_589298 != nil:
    section.add "oauth_token", valid_589298
  var valid_589299 = query.getOrDefault("callback")
  valid_589299 = validateParameter(valid_589299, JString, required = false,
                                 default = nil)
  if valid_589299 != nil:
    section.add "callback", valid_589299
  var valid_589300 = query.getOrDefault("access_token")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = nil)
  if valid_589300 != nil:
    section.add "access_token", valid_589300
  var valid_589301 = query.getOrDefault("uploadType")
  valid_589301 = validateParameter(valid_589301, JString, required = false,
                                 default = nil)
  if valid_589301 != nil:
    section.add "uploadType", valid_589301
  var valid_589302 = query.getOrDefault("key")
  valid_589302 = validateParameter(valid_589302, JString, required = false,
                                 default = nil)
  if valid_589302 != nil:
    section.add "key", valid_589302
  var valid_589303 = query.getOrDefault("$.xgafv")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = newJString("1"))
  if valid_589303 != nil:
    section.add "$.xgafv", valid_589303
  var valid_589304 = query.getOrDefault("pageSize")
  valid_589304 = validateParameter(valid_589304, JInt, required = false, default = nil)
  if valid_589304 != nil:
    section.add "pageSize", valid_589304
  var valid_589305 = query.getOrDefault("prettyPrint")
  valid_589305 = validateParameter(valid_589305, JBool, required = false,
                                 default = newJBool(true))
  if valid_589305 != nil:
    section.add "prettyPrint", valid_589305
  var valid_589306 = query.getOrDefault("filter")
  valid_589306 = validateParameter(valid_589306, JString, required = false,
                                 default = nil)
  if valid_589306 != nil:
    section.add "filter", valid_589306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589307: Call_FirestoreProjectsDatabasesCollectionGroupsFieldsList_589289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the field configuration and metadata for this database.
  ## 
  ## Currently, FirestoreAdmin.ListFields only supports listing fields
  ## that have been explicitly overridden. To issue this query, call
  ## FirestoreAdmin.ListFields with the filter set to
  ## `indexConfig.usesAncestorConfig:false`.
  ## 
  let valid = call_589307.validator(path, query, header, formData, body)
  let scheme = call_589307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589307.url(scheme.get, call_589307.host, call_589307.base,
                         call_589307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589307, url, valid)

proc call*(call_589308: Call_FirestoreProjectsDatabasesCollectionGroupsFieldsList_589289;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## firestoreProjectsDatabasesCollectionGroupsFieldsList
  ## Lists the field configuration and metadata for this database.
  ## 
  ## Currently, FirestoreAdmin.ListFields only supports listing fields
  ## that have been explicitly overridden. To issue this query, call
  ## FirestoreAdmin.ListFields with the filter set to
  ## `indexConfig.usesAncestorConfig:false`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A page token, returned from a previous call to
  ## FirestoreAdmin.ListFields, that may be used to get the next
  ## page of results.
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
  ##         : A parent name of the form
  ## 
  ## `projects/{project_id}/databases/{database_id}/collectionGroups/{collection_id}`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The number of results to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The filter to apply to list results. Currently,
  ## FirestoreAdmin.ListFields only supports listing fields
  ## that have been explicitly overridden. To issue this query, call
  ## FirestoreAdmin.ListFields with the filter set to
  ## `indexConfig.usesAncestorConfig:false`.
  var path_589309 = newJObject()
  var query_589310 = newJObject()
  add(query_589310, "upload_protocol", newJString(uploadProtocol))
  add(query_589310, "fields", newJString(fields))
  add(query_589310, "pageToken", newJString(pageToken))
  add(query_589310, "quotaUser", newJString(quotaUser))
  add(query_589310, "alt", newJString(alt))
  add(query_589310, "oauth_token", newJString(oauthToken))
  add(query_589310, "callback", newJString(callback))
  add(query_589310, "access_token", newJString(accessToken))
  add(query_589310, "uploadType", newJString(uploadType))
  add(path_589309, "parent", newJString(parent))
  add(query_589310, "key", newJString(key))
  add(query_589310, "$.xgafv", newJString(Xgafv))
  add(query_589310, "pageSize", newJInt(pageSize))
  add(query_589310, "prettyPrint", newJBool(prettyPrint))
  add(query_589310, "filter", newJString(filter))
  result = call_589308.call(path_589309, query_589310, nil, nil, nil)

var firestoreProjectsDatabasesCollectionGroupsFieldsList* = Call_FirestoreProjectsDatabasesCollectionGroupsFieldsList_589289(
    name: "firestoreProjectsDatabasesCollectionGroupsFieldsList",
    meth: HttpMethod.HttpGet, host: "firestore.googleapis.com",
    route: "/v1/{parent}/fields",
    validator: validate_FirestoreProjectsDatabasesCollectionGroupsFieldsList_589290,
    base: "/", url: url_FirestoreProjectsDatabasesCollectionGroupsFieldsList_589291,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_589333 = ref object of OpenApiRestCall_588450
proc url_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_589335(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/indexes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_589334(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a composite index. This returns a google.longrunning.Operation
  ## which may be used to track the status of the creation. The metadata for
  ## the operation will be the type IndexOperationMetadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : A parent name of the form
  ## 
  ## `projects/{project_id}/databases/{database_id}/collectionGroups/{collection_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589336 = path.getOrDefault("parent")
  valid_589336 = validateParameter(valid_589336, JString, required = true,
                                 default = nil)
  if valid_589336 != nil:
    section.add "parent", valid_589336
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

proc call*(call_589349: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_589333;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a composite index. This returns a google.longrunning.Operation
  ## which may be used to track the status of the creation. The metadata for
  ## the operation will be the type IndexOperationMetadata.
  ## 
  let valid = call_589349.validator(path, query, header, formData, body)
  let scheme = call_589349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589349.url(scheme.get, call_589349.host, call_589349.base,
                         call_589349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589349, url, valid)

proc call*(call_589350: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_589333;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## firestoreProjectsDatabasesCollectionGroupsIndexesCreate
  ## Creates a composite index. This returns a google.longrunning.Operation
  ## which may be used to track the status of the creation. The metadata for
  ## the operation will be the type IndexOperationMetadata.
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
  ##   parent: string (required)
  ##         : A parent name of the form
  ## 
  ## `projects/{project_id}/databases/{database_id}/collectionGroups/{collection_id}`
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
  add(path_589351, "parent", newJString(parent))
  add(query_589352, "key", newJString(key))
  add(query_589352, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589353 = body
  add(query_589352, "prettyPrint", newJBool(prettyPrint))
  result = call_589350.call(path_589351, query_589352, nil, nil, body_589353)

var firestoreProjectsDatabasesCollectionGroupsIndexesCreate* = Call_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_589333(
    name: "firestoreProjectsDatabasesCollectionGroupsIndexesCreate",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1/{parent}/indexes", validator: validate_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_589334,
    base: "/", url: url_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_589335,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesCollectionGroupsIndexesList_589311 = ref object of OpenApiRestCall_588450
proc url_FirestoreProjectsDatabasesCollectionGroupsIndexesList_589313(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/indexes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesCollectionGroupsIndexesList_589312(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists composite indexes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : A parent name of the form
  ## 
  ## `projects/{project_id}/databases/{database_id}/collectionGroups/{collection_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589314 = path.getOrDefault("parent")
  valid_589314 = validateParameter(valid_589314, JString, required = true,
                                 default = nil)
  if valid_589314 != nil:
    section.add "parent", valid_589314
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A page token, returned from a previous call to
  ## FirestoreAdmin.ListIndexes, that may be used to get the next
  ## page of results.
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
  ##   pageSize: JInt
  ##           : The number of results to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The filter to apply to list results.
  section = newJObject()
  var valid_589315 = query.getOrDefault("upload_protocol")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = nil)
  if valid_589315 != nil:
    section.add "upload_protocol", valid_589315
  var valid_589316 = query.getOrDefault("fields")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "fields", valid_589316
  var valid_589317 = query.getOrDefault("pageToken")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = nil)
  if valid_589317 != nil:
    section.add "pageToken", valid_589317
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
  var valid_589326 = query.getOrDefault("pageSize")
  valid_589326 = validateParameter(valid_589326, JInt, required = false, default = nil)
  if valid_589326 != nil:
    section.add "pageSize", valid_589326
  var valid_589327 = query.getOrDefault("prettyPrint")
  valid_589327 = validateParameter(valid_589327, JBool, required = false,
                                 default = newJBool(true))
  if valid_589327 != nil:
    section.add "prettyPrint", valid_589327
  var valid_589328 = query.getOrDefault("filter")
  valid_589328 = validateParameter(valid_589328, JString, required = false,
                                 default = nil)
  if valid_589328 != nil:
    section.add "filter", valid_589328
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589329: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesList_589311;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists composite indexes.
  ## 
  let valid = call_589329.validator(path, query, header, formData, body)
  let scheme = call_589329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589329.url(scheme.get, call_589329.host, call_589329.base,
                         call_589329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589329, url, valid)

proc call*(call_589330: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesList_589311;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## firestoreProjectsDatabasesCollectionGroupsIndexesList
  ## Lists composite indexes.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A page token, returned from a previous call to
  ## FirestoreAdmin.ListIndexes, that may be used to get the next
  ## page of results.
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
  ##         : A parent name of the form
  ## 
  ## `projects/{project_id}/databases/{database_id}/collectionGroups/{collection_id}`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The number of results to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The filter to apply to list results.
  var path_589331 = newJObject()
  var query_589332 = newJObject()
  add(query_589332, "upload_protocol", newJString(uploadProtocol))
  add(query_589332, "fields", newJString(fields))
  add(query_589332, "pageToken", newJString(pageToken))
  add(query_589332, "quotaUser", newJString(quotaUser))
  add(query_589332, "alt", newJString(alt))
  add(query_589332, "oauth_token", newJString(oauthToken))
  add(query_589332, "callback", newJString(callback))
  add(query_589332, "access_token", newJString(accessToken))
  add(query_589332, "uploadType", newJString(uploadType))
  add(path_589331, "parent", newJString(parent))
  add(query_589332, "key", newJString(key))
  add(query_589332, "$.xgafv", newJString(Xgafv))
  add(query_589332, "pageSize", newJInt(pageSize))
  add(query_589332, "prettyPrint", newJBool(prettyPrint))
  add(query_589332, "filter", newJString(filter))
  result = call_589330.call(path_589331, query_589332, nil, nil, nil)

var firestoreProjectsDatabasesCollectionGroupsIndexesList* = Call_FirestoreProjectsDatabasesCollectionGroupsIndexesList_589311(
    name: "firestoreProjectsDatabasesCollectionGroupsIndexesList",
    meth: HttpMethod.HttpGet, host: "firestore.googleapis.com",
    route: "/v1/{parent}/indexes",
    validator: validate_FirestoreProjectsDatabasesCollectionGroupsIndexesList_589312,
    base: "/", url: url_FirestoreProjectsDatabasesCollectionGroupsIndexesList_589313,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsCreateDocument_589381 = ref object of OpenApiRestCall_588450
proc url_FirestoreProjectsDatabasesDocumentsCreateDocument_589383(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "collectionId" in path, "`collectionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "collectionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesDocumentsCreateDocument_589382(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a new document.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   collectionId: JString (required)
  ##               : The collection ID, relative to `parent`, to list. For example: `chatrooms`.
  ##   parent: JString (required)
  ##         : The parent resource. For example:
  ## `projects/{project_id}/databases/{database_id}/documents` or
  ## 
  ## `projects/{project_id}/databases/{database_id}/documents/chatrooms/{chatroom_id}`
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `collectionId` field"
  var valid_589384 = path.getOrDefault("collectionId")
  valid_589384 = validateParameter(valid_589384, JString, required = true,
                                 default = nil)
  if valid_589384 != nil:
    section.add "collectionId", valid_589384
  var valid_589385 = path.getOrDefault("parent")
  valid_589385 = validateParameter(valid_589385, JString, required = true,
                                 default = nil)
  if valid_589385 != nil:
    section.add "parent", valid_589385
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
  ##   mask.fieldPaths: JArray
  ##                  : The list of field paths in the mask. See Document.fields for a field
  ## path syntax reference.
  ##   documentId: JString
  ##             : The client-assigned document ID to use for this document.
  ## 
  ## Optional. If not specified, an ID will be assigned by the service.
  section = newJObject()
  var valid_589386 = query.getOrDefault("upload_protocol")
  valid_589386 = validateParameter(valid_589386, JString, required = false,
                                 default = nil)
  if valid_589386 != nil:
    section.add "upload_protocol", valid_589386
  var valid_589387 = query.getOrDefault("fields")
  valid_589387 = validateParameter(valid_589387, JString, required = false,
                                 default = nil)
  if valid_589387 != nil:
    section.add "fields", valid_589387
  var valid_589388 = query.getOrDefault("quotaUser")
  valid_589388 = validateParameter(valid_589388, JString, required = false,
                                 default = nil)
  if valid_589388 != nil:
    section.add "quotaUser", valid_589388
  var valid_589389 = query.getOrDefault("alt")
  valid_589389 = validateParameter(valid_589389, JString, required = false,
                                 default = newJString("json"))
  if valid_589389 != nil:
    section.add "alt", valid_589389
  var valid_589390 = query.getOrDefault("oauth_token")
  valid_589390 = validateParameter(valid_589390, JString, required = false,
                                 default = nil)
  if valid_589390 != nil:
    section.add "oauth_token", valid_589390
  var valid_589391 = query.getOrDefault("callback")
  valid_589391 = validateParameter(valid_589391, JString, required = false,
                                 default = nil)
  if valid_589391 != nil:
    section.add "callback", valid_589391
  var valid_589392 = query.getOrDefault("access_token")
  valid_589392 = validateParameter(valid_589392, JString, required = false,
                                 default = nil)
  if valid_589392 != nil:
    section.add "access_token", valid_589392
  var valid_589393 = query.getOrDefault("uploadType")
  valid_589393 = validateParameter(valid_589393, JString, required = false,
                                 default = nil)
  if valid_589393 != nil:
    section.add "uploadType", valid_589393
  var valid_589394 = query.getOrDefault("key")
  valid_589394 = validateParameter(valid_589394, JString, required = false,
                                 default = nil)
  if valid_589394 != nil:
    section.add "key", valid_589394
  var valid_589395 = query.getOrDefault("$.xgafv")
  valid_589395 = validateParameter(valid_589395, JString, required = false,
                                 default = newJString("1"))
  if valid_589395 != nil:
    section.add "$.xgafv", valid_589395
  var valid_589396 = query.getOrDefault("prettyPrint")
  valid_589396 = validateParameter(valid_589396, JBool, required = false,
                                 default = newJBool(true))
  if valid_589396 != nil:
    section.add "prettyPrint", valid_589396
  var valid_589397 = query.getOrDefault("mask.fieldPaths")
  valid_589397 = validateParameter(valid_589397, JArray, required = false,
                                 default = nil)
  if valid_589397 != nil:
    section.add "mask.fieldPaths", valid_589397
  var valid_589398 = query.getOrDefault("documentId")
  valid_589398 = validateParameter(valid_589398, JString, required = false,
                                 default = nil)
  if valid_589398 != nil:
    section.add "documentId", valid_589398
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

proc call*(call_589400: Call_FirestoreProjectsDatabasesDocumentsCreateDocument_589381;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new document.
  ## 
  let valid = call_589400.validator(path, query, header, formData, body)
  let scheme = call_589400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589400.url(scheme.get, call_589400.host, call_589400.base,
                         call_589400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589400, url, valid)

proc call*(call_589401: Call_FirestoreProjectsDatabasesDocumentsCreateDocument_589381;
          collectionId: string; parent: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true;
          maskFieldPaths: JsonNode = nil; documentId: string = ""): Recallable =
  ## firestoreProjectsDatabasesDocumentsCreateDocument
  ## Creates a new document.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   collectionId: string (required)
  ##               : The collection ID, relative to `parent`, to list. For example: `chatrooms`.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent resource. For example:
  ## `projects/{project_id}/databases/{database_id}/documents` or
  ## 
  ## `projects/{project_id}/databases/{database_id}/documents/chatrooms/{chatroom_id}`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   maskFieldPaths: JArray
  ##                 : The list of field paths in the mask. See Document.fields for a field
  ## path syntax reference.
  ##   documentId: string
  ##             : The client-assigned document ID to use for this document.
  ## 
  ## Optional. If not specified, an ID will be assigned by the service.
  var path_589402 = newJObject()
  var query_589403 = newJObject()
  var body_589404 = newJObject()
  add(query_589403, "upload_protocol", newJString(uploadProtocol))
  add(query_589403, "fields", newJString(fields))
  add(query_589403, "quotaUser", newJString(quotaUser))
  add(query_589403, "alt", newJString(alt))
  add(path_589402, "collectionId", newJString(collectionId))
  add(query_589403, "oauth_token", newJString(oauthToken))
  add(query_589403, "callback", newJString(callback))
  add(query_589403, "access_token", newJString(accessToken))
  add(query_589403, "uploadType", newJString(uploadType))
  add(path_589402, "parent", newJString(parent))
  add(query_589403, "key", newJString(key))
  add(query_589403, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589404 = body
  add(query_589403, "prettyPrint", newJBool(prettyPrint))
  if maskFieldPaths != nil:
    query_589403.add "mask.fieldPaths", maskFieldPaths
  add(query_589403, "documentId", newJString(documentId))
  result = call_589401.call(path_589402, query_589403, nil, nil, body_589404)

var firestoreProjectsDatabasesDocumentsCreateDocument* = Call_FirestoreProjectsDatabasesDocumentsCreateDocument_589381(
    name: "firestoreProjectsDatabasesDocumentsCreateDocument",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1/{parent}/{collectionId}",
    validator: validate_FirestoreProjectsDatabasesDocumentsCreateDocument_589382,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsCreateDocument_589383,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsList_589354 = ref object of OpenApiRestCall_588450
proc url_FirestoreProjectsDatabasesDocumentsList_589356(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "collectionId" in path, "`collectionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "collectionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesDocumentsList_589355(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists documents.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   collectionId: JString (required)
  ##               : The collection ID, relative to `parent`, to list. For example: `chatrooms`
  ## or `messages`.
  ##   parent: JString (required)
  ##         : The parent resource name. In the format:
  ## `projects/{project_id}/databases/{database_id}/documents` or
  ## `projects/{project_id}/databases/{database_id}/documents/{document_path}`.
  ## For example:
  ## `projects/my-project/databases/my-database/documents` or
  ## `projects/my-project/databases/my-database/documents/chatrooms/my-chatroom`
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `collectionId` field"
  var valid_589357 = path.getOrDefault("collectionId")
  valid_589357 = validateParameter(valid_589357, JString, required = true,
                                 default = nil)
  if valid_589357 != nil:
    section.add "collectionId", valid_589357
  var valid_589358 = path.getOrDefault("parent")
  valid_589358 = validateParameter(valid_589358, JString, required = true,
                                 default = nil)
  if valid_589358 != nil:
    section.add "parent", valid_589358
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The `next_page_token` value returned from a previous List request, if any.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   readTime: JString
  ##           : Reads documents as they were at the given time.
  ## This may not be older than 60 seconds.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   showMissing: JBool
  ##              : If the list should show missing documents. A missing document is a
  ## document that does not exist but has sub-documents. These documents will
  ## be returned with a key but will not have fields, Document.create_time,
  ## or Document.update_time set.
  ## 
  ## Requests with `show_missing` may not specify `where` or
  ## `order_by`.
  ##   orderBy: JString
  ##          : The order to sort results by. For example: `priority desc, name`.
  ##   transaction: JString
  ##              : Reads documents in a transaction.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of documents to return.
  ##   mask.fieldPaths: JArray
  ##                  : The list of field paths in the mask. See Document.fields for a field
  ## path syntax reference.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589359 = query.getOrDefault("upload_protocol")
  valid_589359 = validateParameter(valid_589359, JString, required = false,
                                 default = nil)
  if valid_589359 != nil:
    section.add "upload_protocol", valid_589359
  var valid_589360 = query.getOrDefault("fields")
  valid_589360 = validateParameter(valid_589360, JString, required = false,
                                 default = nil)
  if valid_589360 != nil:
    section.add "fields", valid_589360
  var valid_589361 = query.getOrDefault("pageToken")
  valid_589361 = validateParameter(valid_589361, JString, required = false,
                                 default = nil)
  if valid_589361 != nil:
    section.add "pageToken", valid_589361
  var valid_589362 = query.getOrDefault("quotaUser")
  valid_589362 = validateParameter(valid_589362, JString, required = false,
                                 default = nil)
  if valid_589362 != nil:
    section.add "quotaUser", valid_589362
  var valid_589363 = query.getOrDefault("alt")
  valid_589363 = validateParameter(valid_589363, JString, required = false,
                                 default = newJString("json"))
  if valid_589363 != nil:
    section.add "alt", valid_589363
  var valid_589364 = query.getOrDefault("readTime")
  valid_589364 = validateParameter(valid_589364, JString, required = false,
                                 default = nil)
  if valid_589364 != nil:
    section.add "readTime", valid_589364
  var valid_589365 = query.getOrDefault("oauth_token")
  valid_589365 = validateParameter(valid_589365, JString, required = false,
                                 default = nil)
  if valid_589365 != nil:
    section.add "oauth_token", valid_589365
  var valid_589366 = query.getOrDefault("callback")
  valid_589366 = validateParameter(valid_589366, JString, required = false,
                                 default = nil)
  if valid_589366 != nil:
    section.add "callback", valid_589366
  var valid_589367 = query.getOrDefault("access_token")
  valid_589367 = validateParameter(valid_589367, JString, required = false,
                                 default = nil)
  if valid_589367 != nil:
    section.add "access_token", valid_589367
  var valid_589368 = query.getOrDefault("uploadType")
  valid_589368 = validateParameter(valid_589368, JString, required = false,
                                 default = nil)
  if valid_589368 != nil:
    section.add "uploadType", valid_589368
  var valid_589369 = query.getOrDefault("showMissing")
  valid_589369 = validateParameter(valid_589369, JBool, required = false, default = nil)
  if valid_589369 != nil:
    section.add "showMissing", valid_589369
  var valid_589370 = query.getOrDefault("orderBy")
  valid_589370 = validateParameter(valid_589370, JString, required = false,
                                 default = nil)
  if valid_589370 != nil:
    section.add "orderBy", valid_589370
  var valid_589371 = query.getOrDefault("transaction")
  valid_589371 = validateParameter(valid_589371, JString, required = false,
                                 default = nil)
  if valid_589371 != nil:
    section.add "transaction", valid_589371
  var valid_589372 = query.getOrDefault("key")
  valid_589372 = validateParameter(valid_589372, JString, required = false,
                                 default = nil)
  if valid_589372 != nil:
    section.add "key", valid_589372
  var valid_589373 = query.getOrDefault("$.xgafv")
  valid_589373 = validateParameter(valid_589373, JString, required = false,
                                 default = newJString("1"))
  if valid_589373 != nil:
    section.add "$.xgafv", valid_589373
  var valid_589374 = query.getOrDefault("pageSize")
  valid_589374 = validateParameter(valid_589374, JInt, required = false, default = nil)
  if valid_589374 != nil:
    section.add "pageSize", valid_589374
  var valid_589375 = query.getOrDefault("mask.fieldPaths")
  valid_589375 = validateParameter(valid_589375, JArray, required = false,
                                 default = nil)
  if valid_589375 != nil:
    section.add "mask.fieldPaths", valid_589375
  var valid_589376 = query.getOrDefault("prettyPrint")
  valid_589376 = validateParameter(valid_589376, JBool, required = false,
                                 default = newJBool(true))
  if valid_589376 != nil:
    section.add "prettyPrint", valid_589376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589377: Call_FirestoreProjectsDatabasesDocumentsList_589354;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists documents.
  ## 
  let valid = call_589377.validator(path, query, header, formData, body)
  let scheme = call_589377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589377.url(scheme.get, call_589377.host, call_589377.base,
                         call_589377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589377, url, valid)

proc call*(call_589378: Call_FirestoreProjectsDatabasesDocumentsList_589354;
          collectionId: string; parent: string; uploadProtocol: string = "";
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; readTime: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          showMissing: bool = false; orderBy: string = ""; transaction: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          maskFieldPaths: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## firestoreProjectsDatabasesDocumentsList
  ## Lists documents.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The `next_page_token` value returned from a previous List request, if any.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   collectionId: string (required)
  ##               : The collection ID, relative to `parent`, to list. For example: `chatrooms`
  ## or `messages`.
  ##   readTime: string
  ##           : Reads documents as they were at the given time.
  ## This may not be older than 60 seconds.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The parent resource name. In the format:
  ## `projects/{project_id}/databases/{database_id}/documents` or
  ## `projects/{project_id}/databases/{database_id}/documents/{document_path}`.
  ## For example:
  ## `projects/my-project/databases/my-database/documents` or
  ## `projects/my-project/databases/my-database/documents/chatrooms/my-chatroom`
  ##   showMissing: bool
  ##              : If the list should show missing documents. A missing document is a
  ## document that does not exist but has sub-documents. These documents will
  ## be returned with a key but will not have fields, Document.create_time,
  ## or Document.update_time set.
  ## 
  ## Requests with `show_missing` may not specify `where` or
  ## `order_by`.
  ##   orderBy: string
  ##          : The order to sort results by. For example: `priority desc, name`.
  ##   transaction: string
  ##              : Reads documents in a transaction.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of documents to return.
  ##   maskFieldPaths: JArray
  ##                 : The list of field paths in the mask. See Document.fields for a field
  ## path syntax reference.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589379 = newJObject()
  var query_589380 = newJObject()
  add(query_589380, "upload_protocol", newJString(uploadProtocol))
  add(query_589380, "fields", newJString(fields))
  add(query_589380, "pageToken", newJString(pageToken))
  add(query_589380, "quotaUser", newJString(quotaUser))
  add(query_589380, "alt", newJString(alt))
  add(path_589379, "collectionId", newJString(collectionId))
  add(query_589380, "readTime", newJString(readTime))
  add(query_589380, "oauth_token", newJString(oauthToken))
  add(query_589380, "callback", newJString(callback))
  add(query_589380, "access_token", newJString(accessToken))
  add(query_589380, "uploadType", newJString(uploadType))
  add(path_589379, "parent", newJString(parent))
  add(query_589380, "showMissing", newJBool(showMissing))
  add(query_589380, "orderBy", newJString(orderBy))
  add(query_589380, "transaction", newJString(transaction))
  add(query_589380, "key", newJString(key))
  add(query_589380, "$.xgafv", newJString(Xgafv))
  add(query_589380, "pageSize", newJInt(pageSize))
  if maskFieldPaths != nil:
    query_589380.add "mask.fieldPaths", maskFieldPaths
  add(query_589380, "prettyPrint", newJBool(prettyPrint))
  result = call_589378.call(path_589379, query_589380, nil, nil, nil)

var firestoreProjectsDatabasesDocumentsList* = Call_FirestoreProjectsDatabasesDocumentsList_589354(
    name: "firestoreProjectsDatabasesDocumentsList", meth: HttpMethod.HttpGet,
    host: "firestore.googleapis.com", route: "/v1/{parent}/{collectionId}",
    validator: validate_FirestoreProjectsDatabasesDocumentsList_589355, base: "/",
    url: url_FirestoreProjectsDatabasesDocumentsList_589356,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsListCollectionIds_589405 = ref object of OpenApiRestCall_588450
proc url_FirestoreProjectsDatabasesDocumentsListCollectionIds_589407(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: ":listCollectionIds")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesDocumentsListCollectionIds_589406(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all the collection IDs underneath a document.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent document. In the format:
  ## `projects/{project_id}/databases/{database_id}/documents/{document_path}`.
  ## For example:
  ## `projects/my-project/databases/my-database/documents/chatrooms/my-chatroom`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589408 = path.getOrDefault("parent")
  valid_589408 = validateParameter(valid_589408, JString, required = true,
                                 default = nil)
  if valid_589408 != nil:
    section.add "parent", valid_589408
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
  var valid_589409 = query.getOrDefault("upload_protocol")
  valid_589409 = validateParameter(valid_589409, JString, required = false,
                                 default = nil)
  if valid_589409 != nil:
    section.add "upload_protocol", valid_589409
  var valid_589410 = query.getOrDefault("fields")
  valid_589410 = validateParameter(valid_589410, JString, required = false,
                                 default = nil)
  if valid_589410 != nil:
    section.add "fields", valid_589410
  var valid_589411 = query.getOrDefault("quotaUser")
  valid_589411 = validateParameter(valid_589411, JString, required = false,
                                 default = nil)
  if valid_589411 != nil:
    section.add "quotaUser", valid_589411
  var valid_589412 = query.getOrDefault("alt")
  valid_589412 = validateParameter(valid_589412, JString, required = false,
                                 default = newJString("json"))
  if valid_589412 != nil:
    section.add "alt", valid_589412
  var valid_589413 = query.getOrDefault("oauth_token")
  valid_589413 = validateParameter(valid_589413, JString, required = false,
                                 default = nil)
  if valid_589413 != nil:
    section.add "oauth_token", valid_589413
  var valid_589414 = query.getOrDefault("callback")
  valid_589414 = validateParameter(valid_589414, JString, required = false,
                                 default = nil)
  if valid_589414 != nil:
    section.add "callback", valid_589414
  var valid_589415 = query.getOrDefault("access_token")
  valid_589415 = validateParameter(valid_589415, JString, required = false,
                                 default = nil)
  if valid_589415 != nil:
    section.add "access_token", valid_589415
  var valid_589416 = query.getOrDefault("uploadType")
  valid_589416 = validateParameter(valid_589416, JString, required = false,
                                 default = nil)
  if valid_589416 != nil:
    section.add "uploadType", valid_589416
  var valid_589417 = query.getOrDefault("key")
  valid_589417 = validateParameter(valid_589417, JString, required = false,
                                 default = nil)
  if valid_589417 != nil:
    section.add "key", valid_589417
  var valid_589418 = query.getOrDefault("$.xgafv")
  valid_589418 = validateParameter(valid_589418, JString, required = false,
                                 default = newJString("1"))
  if valid_589418 != nil:
    section.add "$.xgafv", valid_589418
  var valid_589419 = query.getOrDefault("prettyPrint")
  valid_589419 = validateParameter(valid_589419, JBool, required = false,
                                 default = newJBool(true))
  if valid_589419 != nil:
    section.add "prettyPrint", valid_589419
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

proc call*(call_589421: Call_FirestoreProjectsDatabasesDocumentsListCollectionIds_589405;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the collection IDs underneath a document.
  ## 
  let valid = call_589421.validator(path, query, header, formData, body)
  let scheme = call_589421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589421.url(scheme.get, call_589421.host, call_589421.base,
                         call_589421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589421, url, valid)

proc call*(call_589422: Call_FirestoreProjectsDatabasesDocumentsListCollectionIds_589405;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## firestoreProjectsDatabasesDocumentsListCollectionIds
  ## Lists all the collection IDs underneath a document.
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
  ##   parent: string (required)
  ##         : The parent document. In the format:
  ## `projects/{project_id}/databases/{database_id}/documents/{document_path}`.
  ## For example:
  ## `projects/my-project/databases/my-database/documents/chatrooms/my-chatroom`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589423 = newJObject()
  var query_589424 = newJObject()
  var body_589425 = newJObject()
  add(query_589424, "upload_protocol", newJString(uploadProtocol))
  add(query_589424, "fields", newJString(fields))
  add(query_589424, "quotaUser", newJString(quotaUser))
  add(query_589424, "alt", newJString(alt))
  add(query_589424, "oauth_token", newJString(oauthToken))
  add(query_589424, "callback", newJString(callback))
  add(query_589424, "access_token", newJString(accessToken))
  add(query_589424, "uploadType", newJString(uploadType))
  add(path_589423, "parent", newJString(parent))
  add(query_589424, "key", newJString(key))
  add(query_589424, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589425 = body
  add(query_589424, "prettyPrint", newJBool(prettyPrint))
  result = call_589422.call(path_589423, query_589424, nil, nil, body_589425)

var firestoreProjectsDatabasesDocumentsListCollectionIds* = Call_FirestoreProjectsDatabasesDocumentsListCollectionIds_589405(
    name: "firestoreProjectsDatabasesDocumentsListCollectionIds",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1/{parent}:listCollectionIds",
    validator: validate_FirestoreProjectsDatabasesDocumentsListCollectionIds_589406,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsListCollectionIds_589407,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsRunQuery_589426 = ref object of OpenApiRestCall_588450
proc url_FirestoreProjectsDatabasesDocumentsRunQuery_589428(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: ":runQuery")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesDocumentsRunQuery_589427(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Runs a query.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource name. In the format:
  ## `projects/{project_id}/databases/{database_id}/documents` or
  ## `projects/{project_id}/databases/{database_id}/documents/{document_path}`.
  ## For example:
  ## `projects/my-project/databases/my-database/documents` or
  ## `projects/my-project/databases/my-database/documents/chatrooms/my-chatroom`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589429 = path.getOrDefault("parent")
  valid_589429 = validateParameter(valid_589429, JString, required = true,
                                 default = nil)
  if valid_589429 != nil:
    section.add "parent", valid_589429
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
  var valid_589430 = query.getOrDefault("upload_protocol")
  valid_589430 = validateParameter(valid_589430, JString, required = false,
                                 default = nil)
  if valid_589430 != nil:
    section.add "upload_protocol", valid_589430
  var valid_589431 = query.getOrDefault("fields")
  valid_589431 = validateParameter(valid_589431, JString, required = false,
                                 default = nil)
  if valid_589431 != nil:
    section.add "fields", valid_589431
  var valid_589432 = query.getOrDefault("quotaUser")
  valid_589432 = validateParameter(valid_589432, JString, required = false,
                                 default = nil)
  if valid_589432 != nil:
    section.add "quotaUser", valid_589432
  var valid_589433 = query.getOrDefault("alt")
  valid_589433 = validateParameter(valid_589433, JString, required = false,
                                 default = newJString("json"))
  if valid_589433 != nil:
    section.add "alt", valid_589433
  var valid_589434 = query.getOrDefault("oauth_token")
  valid_589434 = validateParameter(valid_589434, JString, required = false,
                                 default = nil)
  if valid_589434 != nil:
    section.add "oauth_token", valid_589434
  var valid_589435 = query.getOrDefault("callback")
  valid_589435 = validateParameter(valid_589435, JString, required = false,
                                 default = nil)
  if valid_589435 != nil:
    section.add "callback", valid_589435
  var valid_589436 = query.getOrDefault("access_token")
  valid_589436 = validateParameter(valid_589436, JString, required = false,
                                 default = nil)
  if valid_589436 != nil:
    section.add "access_token", valid_589436
  var valid_589437 = query.getOrDefault("uploadType")
  valid_589437 = validateParameter(valid_589437, JString, required = false,
                                 default = nil)
  if valid_589437 != nil:
    section.add "uploadType", valid_589437
  var valid_589438 = query.getOrDefault("key")
  valid_589438 = validateParameter(valid_589438, JString, required = false,
                                 default = nil)
  if valid_589438 != nil:
    section.add "key", valid_589438
  var valid_589439 = query.getOrDefault("$.xgafv")
  valid_589439 = validateParameter(valid_589439, JString, required = false,
                                 default = newJString("1"))
  if valid_589439 != nil:
    section.add "$.xgafv", valid_589439
  var valid_589440 = query.getOrDefault("prettyPrint")
  valid_589440 = validateParameter(valid_589440, JBool, required = false,
                                 default = newJBool(true))
  if valid_589440 != nil:
    section.add "prettyPrint", valid_589440
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

proc call*(call_589442: Call_FirestoreProjectsDatabasesDocumentsRunQuery_589426;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Runs a query.
  ## 
  let valid = call_589442.validator(path, query, header, formData, body)
  let scheme = call_589442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589442.url(scheme.get, call_589442.host, call_589442.base,
                         call_589442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589442, url, valid)

proc call*(call_589443: Call_FirestoreProjectsDatabasesDocumentsRunQuery_589426;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## firestoreProjectsDatabasesDocumentsRunQuery
  ## Runs a query.
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
  ##   parent: string (required)
  ##         : The parent resource name. In the format:
  ## `projects/{project_id}/databases/{database_id}/documents` or
  ## `projects/{project_id}/databases/{database_id}/documents/{document_path}`.
  ## For example:
  ## `projects/my-project/databases/my-database/documents` or
  ## `projects/my-project/databases/my-database/documents/chatrooms/my-chatroom`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589444 = newJObject()
  var query_589445 = newJObject()
  var body_589446 = newJObject()
  add(query_589445, "upload_protocol", newJString(uploadProtocol))
  add(query_589445, "fields", newJString(fields))
  add(query_589445, "quotaUser", newJString(quotaUser))
  add(query_589445, "alt", newJString(alt))
  add(query_589445, "oauth_token", newJString(oauthToken))
  add(query_589445, "callback", newJString(callback))
  add(query_589445, "access_token", newJString(accessToken))
  add(query_589445, "uploadType", newJString(uploadType))
  add(path_589444, "parent", newJString(parent))
  add(query_589445, "key", newJString(key))
  add(query_589445, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589446 = body
  add(query_589445, "prettyPrint", newJBool(prettyPrint))
  result = call_589443.call(path_589444, query_589445, nil, nil, body_589446)

var firestoreProjectsDatabasesDocumentsRunQuery* = Call_FirestoreProjectsDatabasesDocumentsRunQuery_589426(
    name: "firestoreProjectsDatabasesDocumentsRunQuery",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1/{parent}:runQuery",
    validator: validate_FirestoreProjectsDatabasesDocumentsRunQuery_589427,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsRunQuery_589428,
    schemes: {Scheme.Https})
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
