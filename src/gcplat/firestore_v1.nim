
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
  gcpServiceName = "firestore"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FirestoreProjectsDatabasesDocumentsBatchGet_578619 = ref object of OpenApiRestCall_578348
proc url_FirestoreProjectsDatabasesDocumentsBatchGet_578621(protocol: Scheme;
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

proc validate_FirestoreProjectsDatabasesDocumentsBatchGet_578620(path: JsonNode;
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
  var valid_578747 = path.getOrDefault("database")
  valid_578747 = validateParameter(valid_578747, JString, required = true,
                                 default = nil)
  if valid_578747 != nil:
    section.add "database", valid_578747
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

proc call*(call_578795: Call_FirestoreProjectsDatabasesDocumentsBatchGet_578619;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets multiple documents.
  ## 
  ## Documents returned by this method are not guaranteed to be returned in the
  ## same order that they were requested.
  ## 
  let valid = call_578795.validator(path, query, header, formData, body)
  let scheme = call_578795.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578795.url(scheme.get, call_578795.host, call_578795.base,
                         call_578795.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578795, url, valid)

proc call*(call_578866: Call_FirestoreProjectsDatabasesDocumentsBatchGet_578619;
          database: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firestoreProjectsDatabasesDocumentsBatchGet
  ## Gets multiple documents.
  ## 
  ## Documents returned by this method are not guaranteed to be returned in the
  ## same order that they were requested.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   database: string (required)
  ##           : The database name. In the format:
  ## `projects/{project_id}/databases/{database_id}`.
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
  var path_578867 = newJObject()
  var query_578869 = newJObject()
  var body_578870 = newJObject()
  add(query_578869, "key", newJString(key))
  add(query_578869, "prettyPrint", newJBool(prettyPrint))
  add(query_578869, "oauth_token", newJString(oauthToken))
  add(path_578867, "database", newJString(database))
  add(query_578869, "$.xgafv", newJString(Xgafv))
  add(query_578869, "alt", newJString(alt))
  add(query_578869, "uploadType", newJString(uploadType))
  add(query_578869, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578870 = body
  add(query_578869, "callback", newJString(callback))
  add(query_578869, "fields", newJString(fields))
  add(query_578869, "access_token", newJString(accessToken))
  add(query_578869, "upload_protocol", newJString(uploadProtocol))
  result = call_578866.call(path_578867, query_578869, nil, nil, body_578870)

var firestoreProjectsDatabasesDocumentsBatchGet* = Call_FirestoreProjectsDatabasesDocumentsBatchGet_578619(
    name: "firestoreProjectsDatabasesDocumentsBatchGet",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1/{database}/documents:batchGet",
    validator: validate_FirestoreProjectsDatabasesDocumentsBatchGet_578620,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsBatchGet_578621,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsBeginTransaction_578909 = ref object of OpenApiRestCall_578348
proc url_FirestoreProjectsDatabasesDocumentsBeginTransaction_578911(
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

proc validate_FirestoreProjectsDatabasesDocumentsBeginTransaction_578910(
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
  var valid_578912 = path.getOrDefault("database")
  valid_578912 = validateParameter(valid_578912, JString, required = true,
                                 default = nil)
  if valid_578912 != nil:
    section.add "database", valid_578912
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
  var valid_578913 = query.getOrDefault("key")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "key", valid_578913
  var valid_578914 = query.getOrDefault("prettyPrint")
  valid_578914 = validateParameter(valid_578914, JBool, required = false,
                                 default = newJBool(true))
  if valid_578914 != nil:
    section.add "prettyPrint", valid_578914
  var valid_578915 = query.getOrDefault("oauth_token")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "oauth_token", valid_578915
  var valid_578916 = query.getOrDefault("$.xgafv")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = newJString("1"))
  if valid_578916 != nil:
    section.add "$.xgafv", valid_578916
  var valid_578917 = query.getOrDefault("alt")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = newJString("json"))
  if valid_578917 != nil:
    section.add "alt", valid_578917
  var valid_578918 = query.getOrDefault("uploadType")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "uploadType", valid_578918
  var valid_578919 = query.getOrDefault("quotaUser")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "quotaUser", valid_578919
  var valid_578920 = query.getOrDefault("callback")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "callback", valid_578920
  var valid_578921 = query.getOrDefault("fields")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "fields", valid_578921
  var valid_578922 = query.getOrDefault("access_token")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "access_token", valid_578922
  var valid_578923 = query.getOrDefault("upload_protocol")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "upload_protocol", valid_578923
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

proc call*(call_578925: Call_FirestoreProjectsDatabasesDocumentsBeginTransaction_578909;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts a new transaction.
  ## 
  let valid = call_578925.validator(path, query, header, formData, body)
  let scheme = call_578925.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578925.url(scheme.get, call_578925.host, call_578925.base,
                         call_578925.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578925, url, valid)

proc call*(call_578926: Call_FirestoreProjectsDatabasesDocumentsBeginTransaction_578909;
          database: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firestoreProjectsDatabasesDocumentsBeginTransaction
  ## Starts a new transaction.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   database: string (required)
  ##           : The database name. In the format:
  ## `projects/{project_id}/databases/{database_id}`.
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
  var path_578927 = newJObject()
  var query_578928 = newJObject()
  var body_578929 = newJObject()
  add(query_578928, "key", newJString(key))
  add(query_578928, "prettyPrint", newJBool(prettyPrint))
  add(query_578928, "oauth_token", newJString(oauthToken))
  add(path_578927, "database", newJString(database))
  add(query_578928, "$.xgafv", newJString(Xgafv))
  add(query_578928, "alt", newJString(alt))
  add(query_578928, "uploadType", newJString(uploadType))
  add(query_578928, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578929 = body
  add(query_578928, "callback", newJString(callback))
  add(query_578928, "fields", newJString(fields))
  add(query_578928, "access_token", newJString(accessToken))
  add(query_578928, "upload_protocol", newJString(uploadProtocol))
  result = call_578926.call(path_578927, query_578928, nil, nil, body_578929)

var firestoreProjectsDatabasesDocumentsBeginTransaction* = Call_FirestoreProjectsDatabasesDocumentsBeginTransaction_578909(
    name: "firestoreProjectsDatabasesDocumentsBeginTransaction",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1/{database}/documents:beginTransaction",
    validator: validate_FirestoreProjectsDatabasesDocumentsBeginTransaction_578910,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsBeginTransaction_578911,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsCommit_578930 = ref object of OpenApiRestCall_578348
proc url_FirestoreProjectsDatabasesDocumentsCommit_578932(protocol: Scheme;
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

proc validate_FirestoreProjectsDatabasesDocumentsCommit_578931(path: JsonNode;
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
  var valid_578933 = path.getOrDefault("database")
  valid_578933 = validateParameter(valid_578933, JString, required = true,
                                 default = nil)
  if valid_578933 != nil:
    section.add "database", valid_578933
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
  var valid_578934 = query.getOrDefault("key")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "key", valid_578934
  var valid_578935 = query.getOrDefault("prettyPrint")
  valid_578935 = validateParameter(valid_578935, JBool, required = false,
                                 default = newJBool(true))
  if valid_578935 != nil:
    section.add "prettyPrint", valid_578935
  var valid_578936 = query.getOrDefault("oauth_token")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "oauth_token", valid_578936
  var valid_578937 = query.getOrDefault("$.xgafv")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = newJString("1"))
  if valid_578937 != nil:
    section.add "$.xgafv", valid_578937
  var valid_578938 = query.getOrDefault("alt")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = newJString("json"))
  if valid_578938 != nil:
    section.add "alt", valid_578938
  var valid_578939 = query.getOrDefault("uploadType")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "uploadType", valid_578939
  var valid_578940 = query.getOrDefault("quotaUser")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "quotaUser", valid_578940
  var valid_578941 = query.getOrDefault("callback")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "callback", valid_578941
  var valid_578942 = query.getOrDefault("fields")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "fields", valid_578942
  var valid_578943 = query.getOrDefault("access_token")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "access_token", valid_578943
  var valid_578944 = query.getOrDefault("upload_protocol")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "upload_protocol", valid_578944
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

proc call*(call_578946: Call_FirestoreProjectsDatabasesDocumentsCommit_578930;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Commits a transaction, while optionally updating documents.
  ## 
  let valid = call_578946.validator(path, query, header, formData, body)
  let scheme = call_578946.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578946.url(scheme.get, call_578946.host, call_578946.base,
                         call_578946.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578946, url, valid)

proc call*(call_578947: Call_FirestoreProjectsDatabasesDocumentsCommit_578930;
          database: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firestoreProjectsDatabasesDocumentsCommit
  ## Commits a transaction, while optionally updating documents.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   database: string (required)
  ##           : The database name. In the format:
  ## `projects/{project_id}/databases/{database_id}`.
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
  var path_578948 = newJObject()
  var query_578949 = newJObject()
  var body_578950 = newJObject()
  add(query_578949, "key", newJString(key))
  add(query_578949, "prettyPrint", newJBool(prettyPrint))
  add(query_578949, "oauth_token", newJString(oauthToken))
  add(path_578948, "database", newJString(database))
  add(query_578949, "$.xgafv", newJString(Xgafv))
  add(query_578949, "alt", newJString(alt))
  add(query_578949, "uploadType", newJString(uploadType))
  add(query_578949, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578950 = body
  add(query_578949, "callback", newJString(callback))
  add(query_578949, "fields", newJString(fields))
  add(query_578949, "access_token", newJString(accessToken))
  add(query_578949, "upload_protocol", newJString(uploadProtocol))
  result = call_578947.call(path_578948, query_578949, nil, nil, body_578950)

var firestoreProjectsDatabasesDocumentsCommit* = Call_FirestoreProjectsDatabasesDocumentsCommit_578930(
    name: "firestoreProjectsDatabasesDocumentsCommit", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com", route: "/v1/{database}/documents:commit",
    validator: validate_FirestoreProjectsDatabasesDocumentsCommit_578931,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsCommit_578932,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsListen_578951 = ref object of OpenApiRestCall_578348
proc url_FirestoreProjectsDatabasesDocumentsListen_578953(protocol: Scheme;
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

proc validate_FirestoreProjectsDatabasesDocumentsListen_578952(path: JsonNode;
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
  var valid_578954 = path.getOrDefault("database")
  valid_578954 = validateParameter(valid_578954, JString, required = true,
                                 default = nil)
  if valid_578954 != nil:
    section.add "database", valid_578954
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
  var valid_578955 = query.getOrDefault("key")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "key", valid_578955
  var valid_578956 = query.getOrDefault("prettyPrint")
  valid_578956 = validateParameter(valid_578956, JBool, required = false,
                                 default = newJBool(true))
  if valid_578956 != nil:
    section.add "prettyPrint", valid_578956
  var valid_578957 = query.getOrDefault("oauth_token")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "oauth_token", valid_578957
  var valid_578958 = query.getOrDefault("$.xgafv")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = newJString("1"))
  if valid_578958 != nil:
    section.add "$.xgafv", valid_578958
  var valid_578959 = query.getOrDefault("alt")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = newJString("json"))
  if valid_578959 != nil:
    section.add "alt", valid_578959
  var valid_578960 = query.getOrDefault("uploadType")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "uploadType", valid_578960
  var valid_578961 = query.getOrDefault("quotaUser")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "quotaUser", valid_578961
  var valid_578962 = query.getOrDefault("callback")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "callback", valid_578962
  var valid_578963 = query.getOrDefault("fields")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "fields", valid_578963
  var valid_578964 = query.getOrDefault("access_token")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "access_token", valid_578964
  var valid_578965 = query.getOrDefault("upload_protocol")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "upload_protocol", valid_578965
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

proc call*(call_578967: Call_FirestoreProjectsDatabasesDocumentsListen_578951;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Listens to changes.
  ## 
  let valid = call_578967.validator(path, query, header, formData, body)
  let scheme = call_578967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578967.url(scheme.get, call_578967.host, call_578967.base,
                         call_578967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578967, url, valid)

proc call*(call_578968: Call_FirestoreProjectsDatabasesDocumentsListen_578951;
          database: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firestoreProjectsDatabasesDocumentsListen
  ## Listens to changes.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   database: string (required)
  ##           : The database name. In the format:
  ## `projects/{project_id}/databases/{database_id}`.
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
  var path_578969 = newJObject()
  var query_578970 = newJObject()
  var body_578971 = newJObject()
  add(query_578970, "key", newJString(key))
  add(query_578970, "prettyPrint", newJBool(prettyPrint))
  add(query_578970, "oauth_token", newJString(oauthToken))
  add(path_578969, "database", newJString(database))
  add(query_578970, "$.xgafv", newJString(Xgafv))
  add(query_578970, "alt", newJString(alt))
  add(query_578970, "uploadType", newJString(uploadType))
  add(query_578970, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578971 = body
  add(query_578970, "callback", newJString(callback))
  add(query_578970, "fields", newJString(fields))
  add(query_578970, "access_token", newJString(accessToken))
  add(query_578970, "upload_protocol", newJString(uploadProtocol))
  result = call_578968.call(path_578969, query_578970, nil, nil, body_578971)

var firestoreProjectsDatabasesDocumentsListen* = Call_FirestoreProjectsDatabasesDocumentsListen_578951(
    name: "firestoreProjectsDatabasesDocumentsListen", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com", route: "/v1/{database}/documents:listen",
    validator: validate_FirestoreProjectsDatabasesDocumentsListen_578952,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsListen_578953,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsRollback_578972 = ref object of OpenApiRestCall_578348
proc url_FirestoreProjectsDatabasesDocumentsRollback_578974(protocol: Scheme;
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

proc validate_FirestoreProjectsDatabasesDocumentsRollback_578973(path: JsonNode;
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
  var valid_578975 = path.getOrDefault("database")
  valid_578975 = validateParameter(valid_578975, JString, required = true,
                                 default = nil)
  if valid_578975 != nil:
    section.add "database", valid_578975
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
  var valid_578976 = query.getOrDefault("key")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "key", valid_578976
  var valid_578977 = query.getOrDefault("prettyPrint")
  valid_578977 = validateParameter(valid_578977, JBool, required = false,
                                 default = newJBool(true))
  if valid_578977 != nil:
    section.add "prettyPrint", valid_578977
  var valid_578978 = query.getOrDefault("oauth_token")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "oauth_token", valid_578978
  var valid_578979 = query.getOrDefault("$.xgafv")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = newJString("1"))
  if valid_578979 != nil:
    section.add "$.xgafv", valid_578979
  var valid_578980 = query.getOrDefault("alt")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = newJString("json"))
  if valid_578980 != nil:
    section.add "alt", valid_578980
  var valid_578981 = query.getOrDefault("uploadType")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "uploadType", valid_578981
  var valid_578982 = query.getOrDefault("quotaUser")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "quotaUser", valid_578982
  var valid_578983 = query.getOrDefault("callback")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "callback", valid_578983
  var valid_578984 = query.getOrDefault("fields")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "fields", valid_578984
  var valid_578985 = query.getOrDefault("access_token")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "access_token", valid_578985
  var valid_578986 = query.getOrDefault("upload_protocol")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "upload_protocol", valid_578986
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

proc call*(call_578988: Call_FirestoreProjectsDatabasesDocumentsRollback_578972;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rolls back a transaction.
  ## 
  let valid = call_578988.validator(path, query, header, formData, body)
  let scheme = call_578988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578988.url(scheme.get, call_578988.host, call_578988.base,
                         call_578988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578988, url, valid)

proc call*(call_578989: Call_FirestoreProjectsDatabasesDocumentsRollback_578972;
          database: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firestoreProjectsDatabasesDocumentsRollback
  ## Rolls back a transaction.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   database: string (required)
  ##           : The database name. In the format:
  ## `projects/{project_id}/databases/{database_id}`.
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
  var path_578990 = newJObject()
  var query_578991 = newJObject()
  var body_578992 = newJObject()
  add(query_578991, "key", newJString(key))
  add(query_578991, "prettyPrint", newJBool(prettyPrint))
  add(query_578991, "oauth_token", newJString(oauthToken))
  add(path_578990, "database", newJString(database))
  add(query_578991, "$.xgafv", newJString(Xgafv))
  add(query_578991, "alt", newJString(alt))
  add(query_578991, "uploadType", newJString(uploadType))
  add(query_578991, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578992 = body
  add(query_578991, "callback", newJString(callback))
  add(query_578991, "fields", newJString(fields))
  add(query_578991, "access_token", newJString(accessToken))
  add(query_578991, "upload_protocol", newJString(uploadProtocol))
  result = call_578989.call(path_578990, query_578991, nil, nil, body_578992)

var firestoreProjectsDatabasesDocumentsRollback* = Call_FirestoreProjectsDatabasesDocumentsRollback_578972(
    name: "firestoreProjectsDatabasesDocumentsRollback",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1/{database}/documents:rollback",
    validator: validate_FirestoreProjectsDatabasesDocumentsRollback_578973,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsRollback_578974,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsWrite_578993 = ref object of OpenApiRestCall_578348
proc url_FirestoreProjectsDatabasesDocumentsWrite_578995(protocol: Scheme;
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

proc validate_FirestoreProjectsDatabasesDocumentsWrite_578994(path: JsonNode;
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
  var valid_578996 = path.getOrDefault("database")
  valid_578996 = validateParameter(valid_578996, JString, required = true,
                                 default = nil)
  if valid_578996 != nil:
    section.add "database", valid_578996
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
  var valid_578997 = query.getOrDefault("key")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "key", valid_578997
  var valid_578998 = query.getOrDefault("prettyPrint")
  valid_578998 = validateParameter(valid_578998, JBool, required = false,
                                 default = newJBool(true))
  if valid_578998 != nil:
    section.add "prettyPrint", valid_578998
  var valid_578999 = query.getOrDefault("oauth_token")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "oauth_token", valid_578999
  var valid_579000 = query.getOrDefault("$.xgafv")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = newJString("1"))
  if valid_579000 != nil:
    section.add "$.xgafv", valid_579000
  var valid_579001 = query.getOrDefault("alt")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = newJString("json"))
  if valid_579001 != nil:
    section.add "alt", valid_579001
  var valid_579002 = query.getOrDefault("uploadType")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "uploadType", valid_579002
  var valid_579003 = query.getOrDefault("quotaUser")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "quotaUser", valid_579003
  var valid_579004 = query.getOrDefault("callback")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "callback", valid_579004
  var valid_579005 = query.getOrDefault("fields")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "fields", valid_579005
  var valid_579006 = query.getOrDefault("access_token")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "access_token", valid_579006
  var valid_579007 = query.getOrDefault("upload_protocol")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "upload_protocol", valid_579007
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

proc call*(call_579009: Call_FirestoreProjectsDatabasesDocumentsWrite_578993;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Streams batches of document updates and deletes, in order.
  ## 
  let valid = call_579009.validator(path, query, header, formData, body)
  let scheme = call_579009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579009.url(scheme.get, call_579009.host, call_579009.base,
                         call_579009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579009, url, valid)

proc call*(call_579010: Call_FirestoreProjectsDatabasesDocumentsWrite_578993;
          database: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firestoreProjectsDatabasesDocumentsWrite
  ## Streams batches of document updates and deletes, in order.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   database: string (required)
  ##           : The database name. In the format:
  ## `projects/{project_id}/databases/{database_id}`.
  ## This is only required in the first message.
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
  var path_579011 = newJObject()
  var query_579012 = newJObject()
  var body_579013 = newJObject()
  add(query_579012, "key", newJString(key))
  add(query_579012, "prettyPrint", newJBool(prettyPrint))
  add(query_579012, "oauth_token", newJString(oauthToken))
  add(path_579011, "database", newJString(database))
  add(query_579012, "$.xgafv", newJString(Xgafv))
  add(query_579012, "alt", newJString(alt))
  add(query_579012, "uploadType", newJString(uploadType))
  add(query_579012, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579013 = body
  add(query_579012, "callback", newJString(callback))
  add(query_579012, "fields", newJString(fields))
  add(query_579012, "access_token", newJString(accessToken))
  add(query_579012, "upload_protocol", newJString(uploadProtocol))
  result = call_579010.call(path_579011, query_579012, nil, nil, body_579013)

var firestoreProjectsDatabasesDocumentsWrite* = Call_FirestoreProjectsDatabasesDocumentsWrite_578993(
    name: "firestoreProjectsDatabasesDocumentsWrite", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com", route: "/v1/{database}/documents:write",
    validator: validate_FirestoreProjectsDatabasesDocumentsWrite_578994,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsWrite_578995,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsLocationsGet_579014 = ref object of OpenApiRestCall_578348
proc url_FirestoreProjectsLocationsGet_579016(protocol: Scheme; host: string;
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

proc validate_FirestoreProjectsLocationsGet_579015(path: JsonNode; query: JsonNode;
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
  var valid_579017 = path.getOrDefault("name")
  valid_579017 = validateParameter(valid_579017, JString, required = true,
                                 default = nil)
  if valid_579017 != nil:
    section.add "name", valid_579017
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   transaction: JString
  ##              : Reads the document in a transaction.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   readTime: JString
  ##           : Reads the version of the document at the given time.
  ## This may not be older than 60 seconds.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   mask.fieldPaths: JArray
  ##                  : The list of field paths in the mask. See Document.fields for a field
  ## path syntax reference.
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
  var valid_579018 = query.getOrDefault("key")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "key", valid_579018
  var valid_579019 = query.getOrDefault("prettyPrint")
  valid_579019 = validateParameter(valid_579019, JBool, required = false,
                                 default = newJBool(true))
  if valid_579019 != nil:
    section.add "prettyPrint", valid_579019
  var valid_579020 = query.getOrDefault("oauth_token")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "oauth_token", valid_579020
  var valid_579021 = query.getOrDefault("transaction")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "transaction", valid_579021
  var valid_579022 = query.getOrDefault("$.xgafv")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = newJString("1"))
  if valid_579022 != nil:
    section.add "$.xgafv", valid_579022
  var valid_579023 = query.getOrDefault("readTime")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "readTime", valid_579023
  var valid_579024 = query.getOrDefault("alt")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = newJString("json"))
  if valid_579024 != nil:
    section.add "alt", valid_579024
  var valid_579025 = query.getOrDefault("uploadType")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "uploadType", valid_579025
  var valid_579026 = query.getOrDefault("mask.fieldPaths")
  valid_579026 = validateParameter(valid_579026, JArray, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "mask.fieldPaths", valid_579026
  var valid_579027 = query.getOrDefault("quotaUser")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "quotaUser", valid_579027
  var valid_579028 = query.getOrDefault("callback")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "callback", valid_579028
  var valid_579029 = query.getOrDefault("fields")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "fields", valid_579029
  var valid_579030 = query.getOrDefault("access_token")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "access_token", valid_579030
  var valid_579031 = query.getOrDefault("upload_protocol")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "upload_protocol", valid_579031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579032: Call_FirestoreProjectsLocationsGet_579014; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a location.
  ## 
  let valid = call_579032.validator(path, query, header, formData, body)
  let scheme = call_579032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579032.url(scheme.get, call_579032.host, call_579032.base,
                         call_579032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579032, url, valid)

proc call*(call_579033: Call_FirestoreProjectsLocationsGet_579014; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          transaction: string = ""; Xgafv: string = "1"; readTime: string = "";
          alt: string = "json"; uploadType: string = ""; maskFieldPaths: JsonNode = nil;
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firestoreProjectsLocationsGet
  ## Gets information about a location.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   transaction: string
  ##              : Reads the document in a transaction.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   readTime: string
  ##           : Reads the version of the document at the given time.
  ## This may not be older than 60 seconds.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   maskFieldPaths: JArray
  ##                 : The list of field paths in the mask. See Document.fields for a field
  ## path syntax reference.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Resource name for the location.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579034 = newJObject()
  var query_579035 = newJObject()
  add(query_579035, "key", newJString(key))
  add(query_579035, "prettyPrint", newJBool(prettyPrint))
  add(query_579035, "oauth_token", newJString(oauthToken))
  add(query_579035, "transaction", newJString(transaction))
  add(query_579035, "$.xgafv", newJString(Xgafv))
  add(query_579035, "readTime", newJString(readTime))
  add(query_579035, "alt", newJString(alt))
  add(query_579035, "uploadType", newJString(uploadType))
  if maskFieldPaths != nil:
    query_579035.add "mask.fieldPaths", maskFieldPaths
  add(query_579035, "quotaUser", newJString(quotaUser))
  add(path_579034, "name", newJString(name))
  add(query_579035, "callback", newJString(callback))
  add(query_579035, "fields", newJString(fields))
  add(query_579035, "access_token", newJString(accessToken))
  add(query_579035, "upload_protocol", newJString(uploadProtocol))
  result = call_579033.call(path_579034, query_579035, nil, nil, nil)

var firestoreProjectsLocationsGet* = Call_FirestoreProjectsLocationsGet_579014(
    name: "firestoreProjectsLocationsGet", meth: HttpMethod.HttpGet,
    host: "firestore.googleapis.com", route: "/v1/{name}",
    validator: validate_FirestoreProjectsLocationsGet_579015, base: "/",
    url: url_FirestoreProjectsLocationsGet_579016, schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsPatch_579057 = ref object of OpenApiRestCall_578348
proc url_FirestoreProjectsDatabasesDocumentsPatch_579059(protocol: Scheme;
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

proc validate_FirestoreProjectsDatabasesDocumentsPatch_579058(path: JsonNode;
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
  var valid_579060 = path.getOrDefault("name")
  valid_579060 = validateParameter(valid_579060, JString, required = true,
                                 default = nil)
  if valid_579060 != nil:
    section.add "name", valid_579060
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
  ##   currentDocument.exists: JBool
  ##                         : When set to `true`, the target document must exist.
  ## When set to `false`, the target document must not exist.
  ##   currentDocument.updateTime: JString
  ##                             : When set, the target document must exist and have been last updated at
  ## that time.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   mask.fieldPaths: JArray
  ##                  : The list of field paths in the mask. See Document.fields for a field
  ## path syntax reference.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask.fieldPaths: JArray
  ##                        : The list of field paths in the mask. See Document.fields for a field
  ## path syntax reference.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579061 = query.getOrDefault("key")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "key", valid_579061
  var valid_579062 = query.getOrDefault("prettyPrint")
  valid_579062 = validateParameter(valid_579062, JBool, required = false,
                                 default = newJBool(true))
  if valid_579062 != nil:
    section.add "prettyPrint", valid_579062
  var valid_579063 = query.getOrDefault("oauth_token")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "oauth_token", valid_579063
  var valid_579064 = query.getOrDefault("$.xgafv")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = newJString("1"))
  if valid_579064 != nil:
    section.add "$.xgafv", valid_579064
  var valid_579065 = query.getOrDefault("currentDocument.exists")
  valid_579065 = validateParameter(valid_579065, JBool, required = false, default = nil)
  if valid_579065 != nil:
    section.add "currentDocument.exists", valid_579065
  var valid_579066 = query.getOrDefault("currentDocument.updateTime")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "currentDocument.updateTime", valid_579066
  var valid_579067 = query.getOrDefault("alt")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = newJString("json"))
  if valid_579067 != nil:
    section.add "alt", valid_579067
  var valid_579068 = query.getOrDefault("uploadType")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "uploadType", valid_579068
  var valid_579069 = query.getOrDefault("mask.fieldPaths")
  valid_579069 = validateParameter(valid_579069, JArray, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "mask.fieldPaths", valid_579069
  var valid_579070 = query.getOrDefault("quotaUser")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = nil)
  if valid_579070 != nil:
    section.add "quotaUser", valid_579070
  var valid_579071 = query.getOrDefault("updateMask.fieldPaths")
  valid_579071 = validateParameter(valid_579071, JArray, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "updateMask.fieldPaths", valid_579071
  var valid_579072 = query.getOrDefault("callback")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "callback", valid_579072
  var valid_579073 = query.getOrDefault("fields")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "fields", valid_579073
  var valid_579074 = query.getOrDefault("access_token")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "access_token", valid_579074
  var valid_579075 = query.getOrDefault("upload_protocol")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "upload_protocol", valid_579075
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

proc call*(call_579077: Call_FirestoreProjectsDatabasesDocumentsPatch_579057;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates or inserts a document.
  ## 
  let valid = call_579077.validator(path, query, header, formData, body)
  let scheme = call_579077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579077.url(scheme.get, call_579077.host, call_579077.base,
                         call_579077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579077, url, valid)

proc call*(call_579078: Call_FirestoreProjectsDatabasesDocumentsPatch_579057;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1";
          currentDocumentExists: bool = false;
          currentDocumentUpdateTime: string = ""; alt: string = "json";
          uploadType: string = ""; maskFieldPaths: JsonNode = nil;
          quotaUser: string = ""; updateMaskFieldPaths: JsonNode = nil;
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firestoreProjectsDatabasesDocumentsPatch
  ## Updates or inserts a document.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   currentDocumentExists: bool
  ##                        : When set to `true`, the target document must exist.
  ## When set to `false`, the target document must not exist.
  ##   currentDocumentUpdateTime: string
  ##                            : When set, the target document must exist and have been last updated at
  ## that time.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   maskFieldPaths: JArray
  ##                 : The list of field paths in the mask. See Document.fields for a field
  ## path syntax reference.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the document, for example
  ## `projects/{project_id}/databases/{database_id}/documents/{document_path}`.
  ##   updateMaskFieldPaths: JArray
  ##                       : The list of field paths in the mask. See Document.fields for a field
  ## path syntax reference.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579079 = newJObject()
  var query_579080 = newJObject()
  var body_579081 = newJObject()
  add(query_579080, "key", newJString(key))
  add(query_579080, "prettyPrint", newJBool(prettyPrint))
  add(query_579080, "oauth_token", newJString(oauthToken))
  add(query_579080, "$.xgafv", newJString(Xgafv))
  add(query_579080, "currentDocument.exists", newJBool(currentDocumentExists))
  add(query_579080, "currentDocument.updateTime",
      newJString(currentDocumentUpdateTime))
  add(query_579080, "alt", newJString(alt))
  add(query_579080, "uploadType", newJString(uploadType))
  if maskFieldPaths != nil:
    query_579080.add "mask.fieldPaths", maskFieldPaths
  add(query_579080, "quotaUser", newJString(quotaUser))
  add(path_579079, "name", newJString(name))
  if updateMaskFieldPaths != nil:
    query_579080.add "updateMask.fieldPaths", updateMaskFieldPaths
  if body != nil:
    body_579081 = body
  add(query_579080, "callback", newJString(callback))
  add(query_579080, "fields", newJString(fields))
  add(query_579080, "access_token", newJString(accessToken))
  add(query_579080, "upload_protocol", newJString(uploadProtocol))
  result = call_579078.call(path_579079, query_579080, nil, nil, body_579081)

var firestoreProjectsDatabasesDocumentsPatch* = Call_FirestoreProjectsDatabasesDocumentsPatch_579057(
    name: "firestoreProjectsDatabasesDocumentsPatch", meth: HttpMethod.HttpPatch,
    host: "firestore.googleapis.com", route: "/v1/{name}",
    validator: validate_FirestoreProjectsDatabasesDocumentsPatch_579058,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsPatch_579059,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesOperationsDelete_579036 = ref object of OpenApiRestCall_578348
proc url_FirestoreProjectsDatabasesOperationsDelete_579038(protocol: Scheme;
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

proc validate_FirestoreProjectsDatabasesOperationsDelete_579037(path: JsonNode;
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
  var valid_579039 = path.getOrDefault("name")
  valid_579039 = validateParameter(valid_579039, JString, required = true,
                                 default = nil)
  if valid_579039 != nil:
    section.add "name", valid_579039
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
  ##   currentDocument.exists: JBool
  ##                         : When set to `true`, the target document must exist.
  ## When set to `false`, the target document must not exist.
  ##   currentDocument.updateTime: JString
  ##                             : When set, the target document must exist and have been last updated at
  ## that time.
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
  var valid_579040 = query.getOrDefault("key")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "key", valid_579040
  var valid_579041 = query.getOrDefault("prettyPrint")
  valid_579041 = validateParameter(valid_579041, JBool, required = false,
                                 default = newJBool(true))
  if valid_579041 != nil:
    section.add "prettyPrint", valid_579041
  var valid_579042 = query.getOrDefault("oauth_token")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "oauth_token", valid_579042
  var valid_579043 = query.getOrDefault("$.xgafv")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = newJString("1"))
  if valid_579043 != nil:
    section.add "$.xgafv", valid_579043
  var valid_579044 = query.getOrDefault("currentDocument.exists")
  valid_579044 = validateParameter(valid_579044, JBool, required = false, default = nil)
  if valid_579044 != nil:
    section.add "currentDocument.exists", valid_579044
  var valid_579045 = query.getOrDefault("currentDocument.updateTime")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "currentDocument.updateTime", valid_579045
  var valid_579046 = query.getOrDefault("alt")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = newJString("json"))
  if valid_579046 != nil:
    section.add "alt", valid_579046
  var valid_579047 = query.getOrDefault("uploadType")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "uploadType", valid_579047
  var valid_579048 = query.getOrDefault("quotaUser")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "quotaUser", valid_579048
  var valid_579049 = query.getOrDefault("callback")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "callback", valid_579049
  var valid_579050 = query.getOrDefault("fields")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "fields", valid_579050
  var valid_579051 = query.getOrDefault("access_token")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "access_token", valid_579051
  var valid_579052 = query.getOrDefault("upload_protocol")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "upload_protocol", valid_579052
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579053: Call_FirestoreProjectsDatabasesOperationsDelete_579036;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_579053.validator(path, query, header, formData, body)
  let scheme = call_579053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579053.url(scheme.get, call_579053.host, call_579053.base,
                         call_579053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579053, url, valid)

proc call*(call_579054: Call_FirestoreProjectsDatabasesOperationsDelete_579036;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1";
          currentDocumentExists: bool = false;
          currentDocumentUpdateTime: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firestoreProjectsDatabasesOperationsDelete
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   currentDocumentExists: bool
  ##                        : When set to `true`, the target document must exist.
  ## When set to `false`, the target document must not exist.
  ##   currentDocumentUpdateTime: string
  ##                            : When set, the target document must exist and have been last updated at
  ## that time.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be deleted.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579055 = newJObject()
  var query_579056 = newJObject()
  add(query_579056, "key", newJString(key))
  add(query_579056, "prettyPrint", newJBool(prettyPrint))
  add(query_579056, "oauth_token", newJString(oauthToken))
  add(query_579056, "$.xgafv", newJString(Xgafv))
  add(query_579056, "currentDocument.exists", newJBool(currentDocumentExists))
  add(query_579056, "currentDocument.updateTime",
      newJString(currentDocumentUpdateTime))
  add(query_579056, "alt", newJString(alt))
  add(query_579056, "uploadType", newJString(uploadType))
  add(query_579056, "quotaUser", newJString(quotaUser))
  add(path_579055, "name", newJString(name))
  add(query_579056, "callback", newJString(callback))
  add(query_579056, "fields", newJString(fields))
  add(query_579056, "access_token", newJString(accessToken))
  add(query_579056, "upload_protocol", newJString(uploadProtocol))
  result = call_579054.call(path_579055, query_579056, nil, nil, nil)

var firestoreProjectsDatabasesOperationsDelete* = Call_FirestoreProjectsDatabasesOperationsDelete_579036(
    name: "firestoreProjectsDatabasesOperationsDelete",
    meth: HttpMethod.HttpDelete, host: "firestore.googleapis.com",
    route: "/v1/{name}",
    validator: validate_FirestoreProjectsDatabasesOperationsDelete_579037,
    base: "/", url: url_FirestoreProjectsDatabasesOperationsDelete_579038,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsLocationsList_579082 = ref object of OpenApiRestCall_578348
proc url_FirestoreProjectsLocationsList_579084(protocol: Scheme; host: string;
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

proc validate_FirestoreProjectsLocationsList_579083(path: JsonNode;
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
  var valid_579085 = path.getOrDefault("name")
  valid_579085 = validateParameter(valid_579085, JString, required = true,
                                 default = nil)
  if valid_579085 != nil:
    section.add "name", valid_579085
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
  ##           : The standard list page size.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The standard list filter.
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579086 = query.getOrDefault("key")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "key", valid_579086
  var valid_579087 = query.getOrDefault("prettyPrint")
  valid_579087 = validateParameter(valid_579087, JBool, required = false,
                                 default = newJBool(true))
  if valid_579087 != nil:
    section.add "prettyPrint", valid_579087
  var valid_579088 = query.getOrDefault("oauth_token")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "oauth_token", valid_579088
  var valid_579089 = query.getOrDefault("$.xgafv")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = newJString("1"))
  if valid_579089 != nil:
    section.add "$.xgafv", valid_579089
  var valid_579090 = query.getOrDefault("pageSize")
  valid_579090 = validateParameter(valid_579090, JInt, required = false, default = nil)
  if valid_579090 != nil:
    section.add "pageSize", valid_579090
  var valid_579091 = query.getOrDefault("alt")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = newJString("json"))
  if valid_579091 != nil:
    section.add "alt", valid_579091
  var valid_579092 = query.getOrDefault("uploadType")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "uploadType", valid_579092
  var valid_579093 = query.getOrDefault("quotaUser")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "quotaUser", valid_579093
  var valid_579094 = query.getOrDefault("filter")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "filter", valid_579094
  var valid_579095 = query.getOrDefault("pageToken")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "pageToken", valid_579095
  var valid_579096 = query.getOrDefault("callback")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "callback", valid_579096
  var valid_579097 = query.getOrDefault("fields")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "fields", valid_579097
  var valid_579098 = query.getOrDefault("access_token")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "access_token", valid_579098
  var valid_579099 = query.getOrDefault("upload_protocol")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "upload_protocol", valid_579099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579100: Call_FirestoreProjectsLocationsList_579082; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_579100.validator(path, query, header, formData, body)
  let scheme = call_579100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579100.url(scheme.get, call_579100.host, call_579100.base,
                         call_579100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579100, url, valid)

proc call*(call_579101: Call_FirestoreProjectsLocationsList_579082; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; filter: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firestoreProjectsLocationsList
  ## Lists information about the supported locations for this service.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource that owns the locations collection, if applicable.
  ##   filter: string
  ##         : The standard list filter.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579102 = newJObject()
  var query_579103 = newJObject()
  add(query_579103, "key", newJString(key))
  add(query_579103, "prettyPrint", newJBool(prettyPrint))
  add(query_579103, "oauth_token", newJString(oauthToken))
  add(query_579103, "$.xgafv", newJString(Xgafv))
  add(query_579103, "pageSize", newJInt(pageSize))
  add(query_579103, "alt", newJString(alt))
  add(query_579103, "uploadType", newJString(uploadType))
  add(query_579103, "quotaUser", newJString(quotaUser))
  add(path_579102, "name", newJString(name))
  add(query_579103, "filter", newJString(filter))
  add(query_579103, "pageToken", newJString(pageToken))
  add(query_579103, "callback", newJString(callback))
  add(query_579103, "fields", newJString(fields))
  add(query_579103, "access_token", newJString(accessToken))
  add(query_579103, "upload_protocol", newJString(uploadProtocol))
  result = call_579101.call(path_579102, query_579103, nil, nil, nil)

var firestoreProjectsLocationsList* = Call_FirestoreProjectsLocationsList_579082(
    name: "firestoreProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "firestore.googleapis.com", route: "/v1/{name}/locations",
    validator: validate_FirestoreProjectsLocationsList_579083, base: "/",
    url: url_FirestoreProjectsLocationsList_579084, schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesOperationsList_579104 = ref object of OpenApiRestCall_578348
proc url_FirestoreProjectsDatabasesOperationsList_579106(protocol: Scheme;
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

proc validate_FirestoreProjectsDatabasesOperationsList_579105(path: JsonNode;
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
  var valid_579107 = path.getOrDefault("name")
  valid_579107 = validateParameter(valid_579107, JString, required = true,
                                 default = nil)
  if valid_579107 != nil:
    section.add "name", valid_579107
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
  ##           : The standard list page size.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The standard list filter.
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579108 = query.getOrDefault("key")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "key", valid_579108
  var valid_579109 = query.getOrDefault("prettyPrint")
  valid_579109 = validateParameter(valid_579109, JBool, required = false,
                                 default = newJBool(true))
  if valid_579109 != nil:
    section.add "prettyPrint", valid_579109
  var valid_579110 = query.getOrDefault("oauth_token")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "oauth_token", valid_579110
  var valid_579111 = query.getOrDefault("$.xgafv")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = newJString("1"))
  if valid_579111 != nil:
    section.add "$.xgafv", valid_579111
  var valid_579112 = query.getOrDefault("pageSize")
  valid_579112 = validateParameter(valid_579112, JInt, required = false, default = nil)
  if valid_579112 != nil:
    section.add "pageSize", valid_579112
  var valid_579113 = query.getOrDefault("alt")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = newJString("json"))
  if valid_579113 != nil:
    section.add "alt", valid_579113
  var valid_579114 = query.getOrDefault("uploadType")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "uploadType", valid_579114
  var valid_579115 = query.getOrDefault("quotaUser")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = nil)
  if valid_579115 != nil:
    section.add "quotaUser", valid_579115
  var valid_579116 = query.getOrDefault("filter")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "filter", valid_579116
  var valid_579117 = query.getOrDefault("pageToken")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "pageToken", valid_579117
  var valid_579118 = query.getOrDefault("callback")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "callback", valid_579118
  var valid_579119 = query.getOrDefault("fields")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "fields", valid_579119
  var valid_579120 = query.getOrDefault("access_token")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "access_token", valid_579120
  var valid_579121 = query.getOrDefault("upload_protocol")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "upload_protocol", valid_579121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579122: Call_FirestoreProjectsDatabasesOperationsList_579104;
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
  let valid = call_579122.validator(path, query, header, formData, body)
  let scheme = call_579122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579122.url(scheme.get, call_579122.host, call_579122.base,
                         call_579122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579122, url, valid)

proc call*(call_579123: Call_FirestoreProjectsDatabasesOperationsList_579104;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation's parent resource.
  ##   filter: string
  ##         : The standard list filter.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579124 = newJObject()
  var query_579125 = newJObject()
  add(query_579125, "key", newJString(key))
  add(query_579125, "prettyPrint", newJBool(prettyPrint))
  add(query_579125, "oauth_token", newJString(oauthToken))
  add(query_579125, "$.xgafv", newJString(Xgafv))
  add(query_579125, "pageSize", newJInt(pageSize))
  add(query_579125, "alt", newJString(alt))
  add(query_579125, "uploadType", newJString(uploadType))
  add(query_579125, "quotaUser", newJString(quotaUser))
  add(path_579124, "name", newJString(name))
  add(query_579125, "filter", newJString(filter))
  add(query_579125, "pageToken", newJString(pageToken))
  add(query_579125, "callback", newJString(callback))
  add(query_579125, "fields", newJString(fields))
  add(query_579125, "access_token", newJString(accessToken))
  add(query_579125, "upload_protocol", newJString(uploadProtocol))
  result = call_579123.call(path_579124, query_579125, nil, nil, nil)

var firestoreProjectsDatabasesOperationsList* = Call_FirestoreProjectsDatabasesOperationsList_579104(
    name: "firestoreProjectsDatabasesOperationsList", meth: HttpMethod.HttpGet,
    host: "firestore.googleapis.com", route: "/v1/{name}/operations",
    validator: validate_FirestoreProjectsDatabasesOperationsList_579105,
    base: "/", url: url_FirestoreProjectsDatabasesOperationsList_579106,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesOperationsCancel_579126 = ref object of OpenApiRestCall_578348
proc url_FirestoreProjectsDatabasesOperationsCancel_579128(protocol: Scheme;
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

proc validate_FirestoreProjectsDatabasesOperationsCancel_579127(path: JsonNode;
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
  var valid_579129 = path.getOrDefault("name")
  valid_579129 = validateParameter(valid_579129, JString, required = true,
                                 default = nil)
  if valid_579129 != nil:
    section.add "name", valid_579129
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
  var valid_579130 = query.getOrDefault("key")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "key", valid_579130
  var valid_579131 = query.getOrDefault("prettyPrint")
  valid_579131 = validateParameter(valid_579131, JBool, required = false,
                                 default = newJBool(true))
  if valid_579131 != nil:
    section.add "prettyPrint", valid_579131
  var valid_579132 = query.getOrDefault("oauth_token")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "oauth_token", valid_579132
  var valid_579133 = query.getOrDefault("$.xgafv")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = newJString("1"))
  if valid_579133 != nil:
    section.add "$.xgafv", valid_579133
  var valid_579134 = query.getOrDefault("alt")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = newJString("json"))
  if valid_579134 != nil:
    section.add "alt", valid_579134
  var valid_579135 = query.getOrDefault("uploadType")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "uploadType", valid_579135
  var valid_579136 = query.getOrDefault("quotaUser")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = nil)
  if valid_579136 != nil:
    section.add "quotaUser", valid_579136
  var valid_579137 = query.getOrDefault("callback")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = nil)
  if valid_579137 != nil:
    section.add "callback", valid_579137
  var valid_579138 = query.getOrDefault("fields")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "fields", valid_579138
  var valid_579139 = query.getOrDefault("access_token")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "access_token", valid_579139
  var valid_579140 = query.getOrDefault("upload_protocol")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = nil)
  if valid_579140 != nil:
    section.add "upload_protocol", valid_579140
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

proc call*(call_579142: Call_FirestoreProjectsDatabasesOperationsCancel_579126;
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
  let valid = call_579142.validator(path, query, header, formData, body)
  let scheme = call_579142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579142.url(scheme.get, call_579142.host, call_579142.base,
                         call_579142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579142, url, valid)

proc call*(call_579143: Call_FirestoreProjectsDatabasesOperationsCancel_579126;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##       : The name of the operation resource to be cancelled.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579144 = newJObject()
  var query_579145 = newJObject()
  var body_579146 = newJObject()
  add(query_579145, "key", newJString(key))
  add(query_579145, "prettyPrint", newJBool(prettyPrint))
  add(query_579145, "oauth_token", newJString(oauthToken))
  add(query_579145, "$.xgafv", newJString(Xgafv))
  add(query_579145, "alt", newJString(alt))
  add(query_579145, "uploadType", newJString(uploadType))
  add(query_579145, "quotaUser", newJString(quotaUser))
  add(path_579144, "name", newJString(name))
  if body != nil:
    body_579146 = body
  add(query_579145, "callback", newJString(callback))
  add(query_579145, "fields", newJString(fields))
  add(query_579145, "access_token", newJString(accessToken))
  add(query_579145, "upload_protocol", newJString(uploadProtocol))
  result = call_579143.call(path_579144, query_579145, nil, nil, body_579146)

var firestoreProjectsDatabasesOperationsCancel* = Call_FirestoreProjectsDatabasesOperationsCancel_579126(
    name: "firestoreProjectsDatabasesOperationsCancel", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_FirestoreProjectsDatabasesOperationsCancel_579127,
    base: "/", url: url_FirestoreProjectsDatabasesOperationsCancel_579128,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesExportDocuments_579147 = ref object of OpenApiRestCall_578348
proc url_FirestoreProjectsDatabasesExportDocuments_579149(protocol: Scheme;
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

proc validate_FirestoreProjectsDatabasesExportDocuments_579148(path: JsonNode;
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
  var valid_579150 = path.getOrDefault("name")
  valid_579150 = validateParameter(valid_579150, JString, required = true,
                                 default = nil)
  if valid_579150 != nil:
    section.add "name", valid_579150
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
  var valid_579151 = query.getOrDefault("key")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = nil)
  if valid_579151 != nil:
    section.add "key", valid_579151
  var valid_579152 = query.getOrDefault("prettyPrint")
  valid_579152 = validateParameter(valid_579152, JBool, required = false,
                                 default = newJBool(true))
  if valid_579152 != nil:
    section.add "prettyPrint", valid_579152
  var valid_579153 = query.getOrDefault("oauth_token")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = nil)
  if valid_579153 != nil:
    section.add "oauth_token", valid_579153
  var valid_579154 = query.getOrDefault("$.xgafv")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = newJString("1"))
  if valid_579154 != nil:
    section.add "$.xgafv", valid_579154
  var valid_579155 = query.getOrDefault("alt")
  valid_579155 = validateParameter(valid_579155, JString, required = false,
                                 default = newJString("json"))
  if valid_579155 != nil:
    section.add "alt", valid_579155
  var valid_579156 = query.getOrDefault("uploadType")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = nil)
  if valid_579156 != nil:
    section.add "uploadType", valid_579156
  var valid_579157 = query.getOrDefault("quotaUser")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = nil)
  if valid_579157 != nil:
    section.add "quotaUser", valid_579157
  var valid_579158 = query.getOrDefault("callback")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = nil)
  if valid_579158 != nil:
    section.add "callback", valid_579158
  var valid_579159 = query.getOrDefault("fields")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = nil)
  if valid_579159 != nil:
    section.add "fields", valid_579159
  var valid_579160 = query.getOrDefault("access_token")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "access_token", valid_579160
  var valid_579161 = query.getOrDefault("upload_protocol")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = nil)
  if valid_579161 != nil:
    section.add "upload_protocol", valid_579161
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

proc call*(call_579163: Call_FirestoreProjectsDatabasesExportDocuments_579147;
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
  let valid = call_579163.validator(path, query, header, formData, body)
  let scheme = call_579163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579163.url(scheme.get, call_579163.host, call_579163.base,
                         call_579163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579163, url, valid)

proc call*(call_579164: Call_FirestoreProjectsDatabasesExportDocuments_579147;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firestoreProjectsDatabasesExportDocuments
  ## Exports a copy of all or a subset of documents from Google Cloud Firestore
  ## to another storage system, such as Google Cloud Storage. Recent updates to
  ## documents may not be reflected in the export. The export occurs in the
  ## background and its progress can be monitored and managed via the
  ## Operation resource that is created. The output of an export may only be
  ## used once the associated operation is done. If an export operation is
  ## cancelled before completion it may leave partial data behind in Google
  ## Cloud Storage.
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
  ##       : Database to export. Should be of the form:
  ## `projects/{project_id}/databases/{database_id}`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579165 = newJObject()
  var query_579166 = newJObject()
  var body_579167 = newJObject()
  add(query_579166, "key", newJString(key))
  add(query_579166, "prettyPrint", newJBool(prettyPrint))
  add(query_579166, "oauth_token", newJString(oauthToken))
  add(query_579166, "$.xgafv", newJString(Xgafv))
  add(query_579166, "alt", newJString(alt))
  add(query_579166, "uploadType", newJString(uploadType))
  add(query_579166, "quotaUser", newJString(quotaUser))
  add(path_579165, "name", newJString(name))
  if body != nil:
    body_579167 = body
  add(query_579166, "callback", newJString(callback))
  add(query_579166, "fields", newJString(fields))
  add(query_579166, "access_token", newJString(accessToken))
  add(query_579166, "upload_protocol", newJString(uploadProtocol))
  result = call_579164.call(path_579165, query_579166, nil, nil, body_579167)

var firestoreProjectsDatabasesExportDocuments* = Call_FirestoreProjectsDatabasesExportDocuments_579147(
    name: "firestoreProjectsDatabasesExportDocuments", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com", route: "/v1/{name}:exportDocuments",
    validator: validate_FirestoreProjectsDatabasesExportDocuments_579148,
    base: "/", url: url_FirestoreProjectsDatabasesExportDocuments_579149,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesImportDocuments_579168 = ref object of OpenApiRestCall_578348
proc url_FirestoreProjectsDatabasesImportDocuments_579170(protocol: Scheme;
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

proc validate_FirestoreProjectsDatabasesImportDocuments_579169(path: JsonNode;
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
  var valid_579171 = path.getOrDefault("name")
  valid_579171 = validateParameter(valid_579171, JString, required = true,
                                 default = nil)
  if valid_579171 != nil:
    section.add "name", valid_579171
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
  var valid_579172 = query.getOrDefault("key")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = nil)
  if valid_579172 != nil:
    section.add "key", valid_579172
  var valid_579173 = query.getOrDefault("prettyPrint")
  valid_579173 = validateParameter(valid_579173, JBool, required = false,
                                 default = newJBool(true))
  if valid_579173 != nil:
    section.add "prettyPrint", valid_579173
  var valid_579174 = query.getOrDefault("oauth_token")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "oauth_token", valid_579174
  var valid_579175 = query.getOrDefault("$.xgafv")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = newJString("1"))
  if valid_579175 != nil:
    section.add "$.xgafv", valid_579175
  var valid_579176 = query.getOrDefault("alt")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = newJString("json"))
  if valid_579176 != nil:
    section.add "alt", valid_579176
  var valid_579177 = query.getOrDefault("uploadType")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "uploadType", valid_579177
  var valid_579178 = query.getOrDefault("quotaUser")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "quotaUser", valid_579178
  var valid_579179 = query.getOrDefault("callback")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "callback", valid_579179
  var valid_579180 = query.getOrDefault("fields")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = nil)
  if valid_579180 != nil:
    section.add "fields", valid_579180
  var valid_579181 = query.getOrDefault("access_token")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "access_token", valid_579181
  var valid_579182 = query.getOrDefault("upload_protocol")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = nil)
  if valid_579182 != nil:
    section.add "upload_protocol", valid_579182
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

proc call*(call_579184: Call_FirestoreProjectsDatabasesImportDocuments_579168;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Imports documents into Google Cloud Firestore. Existing documents with the
  ## same name are overwritten. The import occurs in the background and its
  ## progress can be monitored and managed via the Operation resource that is
  ## created. If an ImportDocuments operation is cancelled, it is possible
  ## that a subset of the data has already been imported to Cloud Firestore.
  ## 
  let valid = call_579184.validator(path, query, header, formData, body)
  let scheme = call_579184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579184.url(scheme.get, call_579184.host, call_579184.base,
                         call_579184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579184, url, valid)

proc call*(call_579185: Call_FirestoreProjectsDatabasesImportDocuments_579168;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firestoreProjectsDatabasesImportDocuments
  ## Imports documents into Google Cloud Firestore. Existing documents with the
  ## same name are overwritten. The import occurs in the background and its
  ## progress can be monitored and managed via the Operation resource that is
  ## created. If an ImportDocuments operation is cancelled, it is possible
  ## that a subset of the data has already been imported to Cloud Firestore.
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
  ##       : Database to import into. Should be of the form:
  ## `projects/{project_id}/databases/{database_id}`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579186 = newJObject()
  var query_579187 = newJObject()
  var body_579188 = newJObject()
  add(query_579187, "key", newJString(key))
  add(query_579187, "prettyPrint", newJBool(prettyPrint))
  add(query_579187, "oauth_token", newJString(oauthToken))
  add(query_579187, "$.xgafv", newJString(Xgafv))
  add(query_579187, "alt", newJString(alt))
  add(query_579187, "uploadType", newJString(uploadType))
  add(query_579187, "quotaUser", newJString(quotaUser))
  add(path_579186, "name", newJString(name))
  if body != nil:
    body_579188 = body
  add(query_579187, "callback", newJString(callback))
  add(query_579187, "fields", newJString(fields))
  add(query_579187, "access_token", newJString(accessToken))
  add(query_579187, "upload_protocol", newJString(uploadProtocol))
  result = call_579185.call(path_579186, query_579187, nil, nil, body_579188)

var firestoreProjectsDatabasesImportDocuments* = Call_FirestoreProjectsDatabasesImportDocuments_579168(
    name: "firestoreProjectsDatabasesImportDocuments", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com", route: "/v1/{name}:importDocuments",
    validator: validate_FirestoreProjectsDatabasesImportDocuments_579169,
    base: "/", url: url_FirestoreProjectsDatabasesImportDocuments_579170,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesCollectionGroupsFieldsList_579189 = ref object of OpenApiRestCall_578348
proc url_FirestoreProjectsDatabasesCollectionGroupsFieldsList_579191(
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

proc validate_FirestoreProjectsDatabasesCollectionGroupsFieldsList_579190(
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
  var valid_579192 = path.getOrDefault("parent")
  valid_579192 = validateParameter(valid_579192, JString, required = true,
                                 default = nil)
  if valid_579192 != nil:
    section.add "parent", valid_579192
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
  ##           : The number of results to return.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The filter to apply to list results. Currently,
  ## FirestoreAdmin.ListFields only supports listing fields
  ## that have been explicitly overridden. To issue this query, call
  ## FirestoreAdmin.ListFields with the filter set to
  ## `indexConfig.usesAncestorConfig:false`.
  ##   pageToken: JString
  ##            : A page token, returned from a previous call to
  ## FirestoreAdmin.ListFields, that may be used to get the next
  ## page of results.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579193 = query.getOrDefault("key")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = nil)
  if valid_579193 != nil:
    section.add "key", valid_579193
  var valid_579194 = query.getOrDefault("prettyPrint")
  valid_579194 = validateParameter(valid_579194, JBool, required = false,
                                 default = newJBool(true))
  if valid_579194 != nil:
    section.add "prettyPrint", valid_579194
  var valid_579195 = query.getOrDefault("oauth_token")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "oauth_token", valid_579195
  var valid_579196 = query.getOrDefault("$.xgafv")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = newJString("1"))
  if valid_579196 != nil:
    section.add "$.xgafv", valid_579196
  var valid_579197 = query.getOrDefault("pageSize")
  valid_579197 = validateParameter(valid_579197, JInt, required = false, default = nil)
  if valid_579197 != nil:
    section.add "pageSize", valid_579197
  var valid_579198 = query.getOrDefault("alt")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = newJString("json"))
  if valid_579198 != nil:
    section.add "alt", valid_579198
  var valid_579199 = query.getOrDefault("uploadType")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "uploadType", valid_579199
  var valid_579200 = query.getOrDefault("quotaUser")
  valid_579200 = validateParameter(valid_579200, JString, required = false,
                                 default = nil)
  if valid_579200 != nil:
    section.add "quotaUser", valid_579200
  var valid_579201 = query.getOrDefault("filter")
  valid_579201 = validateParameter(valid_579201, JString, required = false,
                                 default = nil)
  if valid_579201 != nil:
    section.add "filter", valid_579201
  var valid_579202 = query.getOrDefault("pageToken")
  valid_579202 = validateParameter(valid_579202, JString, required = false,
                                 default = nil)
  if valid_579202 != nil:
    section.add "pageToken", valid_579202
  var valid_579203 = query.getOrDefault("callback")
  valid_579203 = validateParameter(valid_579203, JString, required = false,
                                 default = nil)
  if valid_579203 != nil:
    section.add "callback", valid_579203
  var valid_579204 = query.getOrDefault("fields")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = nil)
  if valid_579204 != nil:
    section.add "fields", valid_579204
  var valid_579205 = query.getOrDefault("access_token")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = nil)
  if valid_579205 != nil:
    section.add "access_token", valid_579205
  var valid_579206 = query.getOrDefault("upload_protocol")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = nil)
  if valid_579206 != nil:
    section.add "upload_protocol", valid_579206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579207: Call_FirestoreProjectsDatabasesCollectionGroupsFieldsList_579189;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the field configuration and metadata for this database.
  ## 
  ## Currently, FirestoreAdmin.ListFields only supports listing fields
  ## that have been explicitly overridden. To issue this query, call
  ## FirestoreAdmin.ListFields with the filter set to
  ## `indexConfig.usesAncestorConfig:false`.
  ## 
  let valid = call_579207.validator(path, query, header, formData, body)
  let scheme = call_579207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579207.url(scheme.get, call_579207.host, call_579207.base,
                         call_579207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579207, url, valid)

proc call*(call_579208: Call_FirestoreProjectsDatabasesCollectionGroupsFieldsList_579189;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firestoreProjectsDatabasesCollectionGroupsFieldsList
  ## Lists the field configuration and metadata for this database.
  ## 
  ## Currently, FirestoreAdmin.ListFields only supports listing fields
  ## that have been explicitly overridden. To issue this query, call
  ## FirestoreAdmin.ListFields with the filter set to
  ## `indexConfig.usesAncestorConfig:false`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The number of results to return.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : The filter to apply to list results. Currently,
  ## FirestoreAdmin.ListFields only supports listing fields
  ## that have been explicitly overridden. To issue this query, call
  ## FirestoreAdmin.ListFields with the filter set to
  ## `indexConfig.usesAncestorConfig:false`.
  ##   pageToken: string
  ##            : A page token, returned from a previous call to
  ## FirestoreAdmin.ListFields, that may be used to get the next
  ## page of results.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : A parent name of the form
  ## 
  ## `projects/{project_id}/databases/{database_id}/collectionGroups/{collection_id}`
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579209 = newJObject()
  var query_579210 = newJObject()
  add(query_579210, "key", newJString(key))
  add(query_579210, "prettyPrint", newJBool(prettyPrint))
  add(query_579210, "oauth_token", newJString(oauthToken))
  add(query_579210, "$.xgafv", newJString(Xgafv))
  add(query_579210, "pageSize", newJInt(pageSize))
  add(query_579210, "alt", newJString(alt))
  add(query_579210, "uploadType", newJString(uploadType))
  add(query_579210, "quotaUser", newJString(quotaUser))
  add(query_579210, "filter", newJString(filter))
  add(query_579210, "pageToken", newJString(pageToken))
  add(query_579210, "callback", newJString(callback))
  add(path_579209, "parent", newJString(parent))
  add(query_579210, "fields", newJString(fields))
  add(query_579210, "access_token", newJString(accessToken))
  add(query_579210, "upload_protocol", newJString(uploadProtocol))
  result = call_579208.call(path_579209, query_579210, nil, nil, nil)

var firestoreProjectsDatabasesCollectionGroupsFieldsList* = Call_FirestoreProjectsDatabasesCollectionGroupsFieldsList_579189(
    name: "firestoreProjectsDatabasesCollectionGroupsFieldsList",
    meth: HttpMethod.HttpGet, host: "firestore.googleapis.com",
    route: "/v1/{parent}/fields",
    validator: validate_FirestoreProjectsDatabasesCollectionGroupsFieldsList_579190,
    base: "/", url: url_FirestoreProjectsDatabasesCollectionGroupsFieldsList_579191,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_579233 = ref object of OpenApiRestCall_578348
proc url_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_579235(
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

proc validate_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_579234(
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
  var valid_579236 = path.getOrDefault("parent")
  valid_579236 = validateParameter(valid_579236, JString, required = true,
                                 default = nil)
  if valid_579236 != nil:
    section.add "parent", valid_579236
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

proc call*(call_579249: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_579233;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a composite index. This returns a google.longrunning.Operation
  ## which may be used to track the status of the creation. The metadata for
  ## the operation will be the type IndexOperationMetadata.
  ## 
  let valid = call_579249.validator(path, query, header, formData, body)
  let scheme = call_579249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579249.url(scheme.get, call_579249.host, call_579249.base,
                         call_579249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579249, url, valid)

proc call*(call_579250: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_579233;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firestoreProjectsDatabasesCollectionGroupsIndexesCreate
  ## Creates a composite index. This returns a google.longrunning.Operation
  ## which may be used to track the status of the creation. The metadata for
  ## the operation will be the type IndexOperationMetadata.
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
  ##   parent: string (required)
  ##         : A parent name of the form
  ## 
  ## `projects/{project_id}/databases/{database_id}/collectionGroups/{collection_id}`
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
  add(path_579251, "parent", newJString(parent))
  add(query_579252, "fields", newJString(fields))
  add(query_579252, "access_token", newJString(accessToken))
  add(query_579252, "upload_protocol", newJString(uploadProtocol))
  result = call_579250.call(path_579251, query_579252, nil, nil, body_579253)

var firestoreProjectsDatabasesCollectionGroupsIndexesCreate* = Call_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_579233(
    name: "firestoreProjectsDatabasesCollectionGroupsIndexesCreate",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1/{parent}/indexes", validator: validate_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_579234,
    base: "/", url: url_FirestoreProjectsDatabasesCollectionGroupsIndexesCreate_579235,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesCollectionGroupsIndexesList_579211 = ref object of OpenApiRestCall_578348
proc url_FirestoreProjectsDatabasesCollectionGroupsIndexesList_579213(
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

proc validate_FirestoreProjectsDatabasesCollectionGroupsIndexesList_579212(
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
  var valid_579214 = path.getOrDefault("parent")
  valid_579214 = validateParameter(valid_579214, JString, required = true,
                                 default = nil)
  if valid_579214 != nil:
    section.add "parent", valid_579214
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
  ##           : The number of results to return.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The filter to apply to list results.
  ##   pageToken: JString
  ##            : A page token, returned from a previous call to
  ## FirestoreAdmin.ListIndexes, that may be used to get the next
  ## page of results.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579215 = query.getOrDefault("key")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "key", valid_579215
  var valid_579216 = query.getOrDefault("prettyPrint")
  valid_579216 = validateParameter(valid_579216, JBool, required = false,
                                 default = newJBool(true))
  if valid_579216 != nil:
    section.add "prettyPrint", valid_579216
  var valid_579217 = query.getOrDefault("oauth_token")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "oauth_token", valid_579217
  var valid_579218 = query.getOrDefault("$.xgafv")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = newJString("1"))
  if valid_579218 != nil:
    section.add "$.xgafv", valid_579218
  var valid_579219 = query.getOrDefault("pageSize")
  valid_579219 = validateParameter(valid_579219, JInt, required = false, default = nil)
  if valid_579219 != nil:
    section.add "pageSize", valid_579219
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
  var valid_579223 = query.getOrDefault("filter")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = nil)
  if valid_579223 != nil:
    section.add "filter", valid_579223
  var valid_579224 = query.getOrDefault("pageToken")
  valid_579224 = validateParameter(valid_579224, JString, required = false,
                                 default = nil)
  if valid_579224 != nil:
    section.add "pageToken", valid_579224
  var valid_579225 = query.getOrDefault("callback")
  valid_579225 = validateParameter(valid_579225, JString, required = false,
                                 default = nil)
  if valid_579225 != nil:
    section.add "callback", valid_579225
  var valid_579226 = query.getOrDefault("fields")
  valid_579226 = validateParameter(valid_579226, JString, required = false,
                                 default = nil)
  if valid_579226 != nil:
    section.add "fields", valid_579226
  var valid_579227 = query.getOrDefault("access_token")
  valid_579227 = validateParameter(valid_579227, JString, required = false,
                                 default = nil)
  if valid_579227 != nil:
    section.add "access_token", valid_579227
  var valid_579228 = query.getOrDefault("upload_protocol")
  valid_579228 = validateParameter(valid_579228, JString, required = false,
                                 default = nil)
  if valid_579228 != nil:
    section.add "upload_protocol", valid_579228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579229: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesList_579211;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists composite indexes.
  ## 
  let valid = call_579229.validator(path, query, header, formData, body)
  let scheme = call_579229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579229.url(scheme.get, call_579229.host, call_579229.base,
                         call_579229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579229, url, valid)

proc call*(call_579230: Call_FirestoreProjectsDatabasesCollectionGroupsIndexesList_579211;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firestoreProjectsDatabasesCollectionGroupsIndexesList
  ## Lists composite indexes.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The number of results to return.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : The filter to apply to list results.
  ##   pageToken: string
  ##            : A page token, returned from a previous call to
  ## FirestoreAdmin.ListIndexes, that may be used to get the next
  ## page of results.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : A parent name of the form
  ## 
  ## `projects/{project_id}/databases/{database_id}/collectionGroups/{collection_id}`
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579231 = newJObject()
  var query_579232 = newJObject()
  add(query_579232, "key", newJString(key))
  add(query_579232, "prettyPrint", newJBool(prettyPrint))
  add(query_579232, "oauth_token", newJString(oauthToken))
  add(query_579232, "$.xgafv", newJString(Xgafv))
  add(query_579232, "pageSize", newJInt(pageSize))
  add(query_579232, "alt", newJString(alt))
  add(query_579232, "uploadType", newJString(uploadType))
  add(query_579232, "quotaUser", newJString(quotaUser))
  add(query_579232, "filter", newJString(filter))
  add(query_579232, "pageToken", newJString(pageToken))
  add(query_579232, "callback", newJString(callback))
  add(path_579231, "parent", newJString(parent))
  add(query_579232, "fields", newJString(fields))
  add(query_579232, "access_token", newJString(accessToken))
  add(query_579232, "upload_protocol", newJString(uploadProtocol))
  result = call_579230.call(path_579231, query_579232, nil, nil, nil)

var firestoreProjectsDatabasesCollectionGroupsIndexesList* = Call_FirestoreProjectsDatabasesCollectionGroupsIndexesList_579211(
    name: "firestoreProjectsDatabasesCollectionGroupsIndexesList",
    meth: HttpMethod.HttpGet, host: "firestore.googleapis.com",
    route: "/v1/{parent}/indexes",
    validator: validate_FirestoreProjectsDatabasesCollectionGroupsIndexesList_579212,
    base: "/", url: url_FirestoreProjectsDatabasesCollectionGroupsIndexesList_579213,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsCreateDocument_579281 = ref object of OpenApiRestCall_578348
proc url_FirestoreProjectsDatabasesDocumentsCreateDocument_579283(
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

proc validate_FirestoreProjectsDatabasesDocumentsCreateDocument_579282(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a new document.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The parent resource. For example:
  ## `projects/{project_id}/databases/{database_id}/documents` or
  ## 
  ## `projects/{project_id}/databases/{database_id}/documents/chatrooms/{chatroom_id}`
  ##   collectionId: JString (required)
  ##               : The collection ID, relative to `parent`, to list. For example: `chatrooms`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579284 = path.getOrDefault("parent")
  valid_579284 = validateParameter(valid_579284, JString, required = true,
                                 default = nil)
  if valid_579284 != nil:
    section.add "parent", valid_579284
  var valid_579285 = path.getOrDefault("collectionId")
  valid_579285 = validateParameter(valid_579285, JString, required = true,
                                 default = nil)
  if valid_579285 != nil:
    section.add "collectionId", valid_579285
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   documentId: JString
  ##             : The client-assigned document ID to use for this document.
  ## 
  ## Optional. If not specified, an ID will be assigned by the service.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   mask.fieldPaths: JArray
  ##                  : The list of field paths in the mask. See Document.fields for a field
  ## path syntax reference.
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
  var valid_579286 = query.getOrDefault("key")
  valid_579286 = validateParameter(valid_579286, JString, required = false,
                                 default = nil)
  if valid_579286 != nil:
    section.add "key", valid_579286
  var valid_579287 = query.getOrDefault("prettyPrint")
  valid_579287 = validateParameter(valid_579287, JBool, required = false,
                                 default = newJBool(true))
  if valid_579287 != nil:
    section.add "prettyPrint", valid_579287
  var valid_579288 = query.getOrDefault("oauth_token")
  valid_579288 = validateParameter(valid_579288, JString, required = false,
                                 default = nil)
  if valid_579288 != nil:
    section.add "oauth_token", valid_579288
  var valid_579289 = query.getOrDefault("documentId")
  valid_579289 = validateParameter(valid_579289, JString, required = false,
                                 default = nil)
  if valid_579289 != nil:
    section.add "documentId", valid_579289
  var valid_579290 = query.getOrDefault("$.xgafv")
  valid_579290 = validateParameter(valid_579290, JString, required = false,
                                 default = newJString("1"))
  if valid_579290 != nil:
    section.add "$.xgafv", valid_579290
  var valid_579291 = query.getOrDefault("alt")
  valid_579291 = validateParameter(valid_579291, JString, required = false,
                                 default = newJString("json"))
  if valid_579291 != nil:
    section.add "alt", valid_579291
  var valid_579292 = query.getOrDefault("uploadType")
  valid_579292 = validateParameter(valid_579292, JString, required = false,
                                 default = nil)
  if valid_579292 != nil:
    section.add "uploadType", valid_579292
  var valid_579293 = query.getOrDefault("mask.fieldPaths")
  valid_579293 = validateParameter(valid_579293, JArray, required = false,
                                 default = nil)
  if valid_579293 != nil:
    section.add "mask.fieldPaths", valid_579293
  var valid_579294 = query.getOrDefault("quotaUser")
  valid_579294 = validateParameter(valid_579294, JString, required = false,
                                 default = nil)
  if valid_579294 != nil:
    section.add "quotaUser", valid_579294
  var valid_579295 = query.getOrDefault("callback")
  valid_579295 = validateParameter(valid_579295, JString, required = false,
                                 default = nil)
  if valid_579295 != nil:
    section.add "callback", valid_579295
  var valid_579296 = query.getOrDefault("fields")
  valid_579296 = validateParameter(valid_579296, JString, required = false,
                                 default = nil)
  if valid_579296 != nil:
    section.add "fields", valid_579296
  var valid_579297 = query.getOrDefault("access_token")
  valid_579297 = validateParameter(valid_579297, JString, required = false,
                                 default = nil)
  if valid_579297 != nil:
    section.add "access_token", valid_579297
  var valid_579298 = query.getOrDefault("upload_protocol")
  valid_579298 = validateParameter(valid_579298, JString, required = false,
                                 default = nil)
  if valid_579298 != nil:
    section.add "upload_protocol", valid_579298
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

proc call*(call_579300: Call_FirestoreProjectsDatabasesDocumentsCreateDocument_579281;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new document.
  ## 
  let valid = call_579300.validator(path, query, header, formData, body)
  let scheme = call_579300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579300.url(scheme.get, call_579300.host, call_579300.base,
                         call_579300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579300, url, valid)

proc call*(call_579301: Call_FirestoreProjectsDatabasesDocumentsCreateDocument_579281;
          parent: string; collectionId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; documentId: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          maskFieldPaths: JsonNode = nil; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firestoreProjectsDatabasesDocumentsCreateDocument
  ## Creates a new document.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   documentId: string
  ##             : The client-assigned document ID to use for this document.
  ## 
  ## Optional. If not specified, an ID will be assigned by the service.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   maskFieldPaths: JArray
  ##                 : The list of field paths in the mask. See Document.fields for a field
  ## path syntax reference.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource. For example:
  ## `projects/{project_id}/databases/{database_id}/documents` or
  ## 
  ## `projects/{project_id}/databases/{database_id}/documents/chatrooms/{chatroom_id}`
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   collectionId: string (required)
  ##               : The collection ID, relative to `parent`, to list. For example: `chatrooms`.
  var path_579302 = newJObject()
  var query_579303 = newJObject()
  var body_579304 = newJObject()
  add(query_579303, "key", newJString(key))
  add(query_579303, "prettyPrint", newJBool(prettyPrint))
  add(query_579303, "oauth_token", newJString(oauthToken))
  add(query_579303, "documentId", newJString(documentId))
  add(query_579303, "$.xgafv", newJString(Xgafv))
  add(query_579303, "alt", newJString(alt))
  add(query_579303, "uploadType", newJString(uploadType))
  if maskFieldPaths != nil:
    query_579303.add "mask.fieldPaths", maskFieldPaths
  add(query_579303, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579304 = body
  add(query_579303, "callback", newJString(callback))
  add(path_579302, "parent", newJString(parent))
  add(query_579303, "fields", newJString(fields))
  add(query_579303, "access_token", newJString(accessToken))
  add(query_579303, "upload_protocol", newJString(uploadProtocol))
  add(path_579302, "collectionId", newJString(collectionId))
  result = call_579301.call(path_579302, query_579303, nil, nil, body_579304)

var firestoreProjectsDatabasesDocumentsCreateDocument* = Call_FirestoreProjectsDatabasesDocumentsCreateDocument_579281(
    name: "firestoreProjectsDatabasesDocumentsCreateDocument",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1/{parent}/{collectionId}",
    validator: validate_FirestoreProjectsDatabasesDocumentsCreateDocument_579282,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsCreateDocument_579283,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsList_579254 = ref object of OpenApiRestCall_578348
proc url_FirestoreProjectsDatabasesDocumentsList_579256(protocol: Scheme;
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

proc validate_FirestoreProjectsDatabasesDocumentsList_579255(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists documents.
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
  ##   collectionId: JString (required)
  ##               : The collection ID, relative to `parent`, to list. For example: `chatrooms`
  ## or `messages`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579257 = path.getOrDefault("parent")
  valid_579257 = validateParameter(valid_579257, JString, required = true,
                                 default = nil)
  if valid_579257 != nil:
    section.add "parent", valid_579257
  var valid_579258 = path.getOrDefault("collectionId")
  valid_579258 = validateParameter(valid_579258, JString, required = true,
                                 default = nil)
  if valid_579258 != nil:
    section.add "collectionId", valid_579258
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   showMissing: JBool
  ##              : If the list should show missing documents. A missing document is a
  ## document that does not exist but has sub-documents. These documents will
  ## be returned with a key but will not have fields, Document.create_time,
  ## or Document.update_time set.
  ## 
  ## Requests with `show_missing` may not specify `where` or
  ## `order_by`.
  ##   transaction: JString
  ##              : Reads documents in a transaction.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of documents to return.
  ##   readTime: JString
  ##           : Reads documents as they were at the given time.
  ## This may not be older than 60 seconds.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   mask.fieldPaths: JArray
  ##                  : The list of field paths in the mask. See Document.fields for a field
  ## path syntax reference.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: JString
  ##          : The order to sort results by. For example: `priority desc, name`.
  ##   pageToken: JString
  ##            : The `next_page_token` value returned from a previous List request, if any.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579259 = query.getOrDefault("key")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = nil)
  if valid_579259 != nil:
    section.add "key", valid_579259
  var valid_579260 = query.getOrDefault("prettyPrint")
  valid_579260 = validateParameter(valid_579260, JBool, required = false,
                                 default = newJBool(true))
  if valid_579260 != nil:
    section.add "prettyPrint", valid_579260
  var valid_579261 = query.getOrDefault("oauth_token")
  valid_579261 = validateParameter(valid_579261, JString, required = false,
                                 default = nil)
  if valid_579261 != nil:
    section.add "oauth_token", valid_579261
  var valid_579262 = query.getOrDefault("showMissing")
  valid_579262 = validateParameter(valid_579262, JBool, required = false, default = nil)
  if valid_579262 != nil:
    section.add "showMissing", valid_579262
  var valid_579263 = query.getOrDefault("transaction")
  valid_579263 = validateParameter(valid_579263, JString, required = false,
                                 default = nil)
  if valid_579263 != nil:
    section.add "transaction", valid_579263
  var valid_579264 = query.getOrDefault("$.xgafv")
  valid_579264 = validateParameter(valid_579264, JString, required = false,
                                 default = newJString("1"))
  if valid_579264 != nil:
    section.add "$.xgafv", valid_579264
  var valid_579265 = query.getOrDefault("pageSize")
  valid_579265 = validateParameter(valid_579265, JInt, required = false, default = nil)
  if valid_579265 != nil:
    section.add "pageSize", valid_579265
  var valid_579266 = query.getOrDefault("readTime")
  valid_579266 = validateParameter(valid_579266, JString, required = false,
                                 default = nil)
  if valid_579266 != nil:
    section.add "readTime", valid_579266
  var valid_579267 = query.getOrDefault("alt")
  valid_579267 = validateParameter(valid_579267, JString, required = false,
                                 default = newJString("json"))
  if valid_579267 != nil:
    section.add "alt", valid_579267
  var valid_579268 = query.getOrDefault("uploadType")
  valid_579268 = validateParameter(valid_579268, JString, required = false,
                                 default = nil)
  if valid_579268 != nil:
    section.add "uploadType", valid_579268
  var valid_579269 = query.getOrDefault("mask.fieldPaths")
  valid_579269 = validateParameter(valid_579269, JArray, required = false,
                                 default = nil)
  if valid_579269 != nil:
    section.add "mask.fieldPaths", valid_579269
  var valid_579270 = query.getOrDefault("quotaUser")
  valid_579270 = validateParameter(valid_579270, JString, required = false,
                                 default = nil)
  if valid_579270 != nil:
    section.add "quotaUser", valid_579270
  var valid_579271 = query.getOrDefault("orderBy")
  valid_579271 = validateParameter(valid_579271, JString, required = false,
                                 default = nil)
  if valid_579271 != nil:
    section.add "orderBy", valid_579271
  var valid_579272 = query.getOrDefault("pageToken")
  valid_579272 = validateParameter(valid_579272, JString, required = false,
                                 default = nil)
  if valid_579272 != nil:
    section.add "pageToken", valid_579272
  var valid_579273 = query.getOrDefault("callback")
  valid_579273 = validateParameter(valid_579273, JString, required = false,
                                 default = nil)
  if valid_579273 != nil:
    section.add "callback", valid_579273
  var valid_579274 = query.getOrDefault("fields")
  valid_579274 = validateParameter(valid_579274, JString, required = false,
                                 default = nil)
  if valid_579274 != nil:
    section.add "fields", valid_579274
  var valid_579275 = query.getOrDefault("access_token")
  valid_579275 = validateParameter(valid_579275, JString, required = false,
                                 default = nil)
  if valid_579275 != nil:
    section.add "access_token", valid_579275
  var valid_579276 = query.getOrDefault("upload_protocol")
  valid_579276 = validateParameter(valid_579276, JString, required = false,
                                 default = nil)
  if valid_579276 != nil:
    section.add "upload_protocol", valid_579276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579277: Call_FirestoreProjectsDatabasesDocumentsList_579254;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists documents.
  ## 
  let valid = call_579277.validator(path, query, header, formData, body)
  let scheme = call_579277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579277.url(scheme.get, call_579277.host, call_579277.base,
                         call_579277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579277, url, valid)

proc call*(call_579278: Call_FirestoreProjectsDatabasesDocumentsList_579254;
          parent: string; collectionId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; showMissing: bool = false;
          transaction: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          readTime: string = ""; alt: string = "json"; uploadType: string = "";
          maskFieldPaths: JsonNode = nil; quotaUser: string = ""; orderBy: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firestoreProjectsDatabasesDocumentsList
  ## Lists documents.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   showMissing: bool
  ##              : If the list should show missing documents. A missing document is a
  ## document that does not exist but has sub-documents. These documents will
  ## be returned with a key but will not have fields, Document.create_time,
  ## or Document.update_time set.
  ## 
  ## Requests with `show_missing` may not specify `where` or
  ## `order_by`.
  ##   transaction: string
  ##              : Reads documents in a transaction.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of documents to return.
  ##   readTime: string
  ##           : Reads documents as they were at the given time.
  ## This may not be older than 60 seconds.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   maskFieldPaths: JArray
  ##                 : The list of field paths in the mask. See Document.fields for a field
  ## path syntax reference.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: string
  ##          : The order to sort results by. For example: `priority desc, name`.
  ##   pageToken: string
  ##            : The `next_page_token` value returned from a previous List request, if any.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The parent resource name. In the format:
  ## `projects/{project_id}/databases/{database_id}/documents` or
  ## `projects/{project_id}/databases/{database_id}/documents/{document_path}`.
  ## For example:
  ## `projects/my-project/databases/my-database/documents` or
  ## `projects/my-project/databases/my-database/documents/chatrooms/my-chatroom`
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   collectionId: string (required)
  ##               : The collection ID, relative to `parent`, to list. For example: `chatrooms`
  ## or `messages`.
  var path_579279 = newJObject()
  var query_579280 = newJObject()
  add(query_579280, "key", newJString(key))
  add(query_579280, "prettyPrint", newJBool(prettyPrint))
  add(query_579280, "oauth_token", newJString(oauthToken))
  add(query_579280, "showMissing", newJBool(showMissing))
  add(query_579280, "transaction", newJString(transaction))
  add(query_579280, "$.xgafv", newJString(Xgafv))
  add(query_579280, "pageSize", newJInt(pageSize))
  add(query_579280, "readTime", newJString(readTime))
  add(query_579280, "alt", newJString(alt))
  add(query_579280, "uploadType", newJString(uploadType))
  if maskFieldPaths != nil:
    query_579280.add "mask.fieldPaths", maskFieldPaths
  add(query_579280, "quotaUser", newJString(quotaUser))
  add(query_579280, "orderBy", newJString(orderBy))
  add(query_579280, "pageToken", newJString(pageToken))
  add(query_579280, "callback", newJString(callback))
  add(path_579279, "parent", newJString(parent))
  add(query_579280, "fields", newJString(fields))
  add(query_579280, "access_token", newJString(accessToken))
  add(query_579280, "upload_protocol", newJString(uploadProtocol))
  add(path_579279, "collectionId", newJString(collectionId))
  result = call_579278.call(path_579279, query_579280, nil, nil, nil)

var firestoreProjectsDatabasesDocumentsList* = Call_FirestoreProjectsDatabasesDocumentsList_579254(
    name: "firestoreProjectsDatabasesDocumentsList", meth: HttpMethod.HttpGet,
    host: "firestore.googleapis.com", route: "/v1/{parent}/{collectionId}",
    validator: validate_FirestoreProjectsDatabasesDocumentsList_579255, base: "/",
    url: url_FirestoreProjectsDatabasesDocumentsList_579256,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsListCollectionIds_579305 = ref object of OpenApiRestCall_578348
proc url_FirestoreProjectsDatabasesDocumentsListCollectionIds_579307(
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

proc validate_FirestoreProjectsDatabasesDocumentsListCollectionIds_579306(
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
  var valid_579308 = path.getOrDefault("parent")
  valid_579308 = validateParameter(valid_579308, JString, required = true,
                                 default = nil)
  if valid_579308 != nil:
    section.add "parent", valid_579308
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
  var valid_579309 = query.getOrDefault("key")
  valid_579309 = validateParameter(valid_579309, JString, required = false,
                                 default = nil)
  if valid_579309 != nil:
    section.add "key", valid_579309
  var valid_579310 = query.getOrDefault("prettyPrint")
  valid_579310 = validateParameter(valid_579310, JBool, required = false,
                                 default = newJBool(true))
  if valid_579310 != nil:
    section.add "prettyPrint", valid_579310
  var valid_579311 = query.getOrDefault("oauth_token")
  valid_579311 = validateParameter(valid_579311, JString, required = false,
                                 default = nil)
  if valid_579311 != nil:
    section.add "oauth_token", valid_579311
  var valid_579312 = query.getOrDefault("$.xgafv")
  valid_579312 = validateParameter(valid_579312, JString, required = false,
                                 default = newJString("1"))
  if valid_579312 != nil:
    section.add "$.xgafv", valid_579312
  var valid_579313 = query.getOrDefault("alt")
  valid_579313 = validateParameter(valid_579313, JString, required = false,
                                 default = newJString("json"))
  if valid_579313 != nil:
    section.add "alt", valid_579313
  var valid_579314 = query.getOrDefault("uploadType")
  valid_579314 = validateParameter(valid_579314, JString, required = false,
                                 default = nil)
  if valid_579314 != nil:
    section.add "uploadType", valid_579314
  var valid_579315 = query.getOrDefault("quotaUser")
  valid_579315 = validateParameter(valid_579315, JString, required = false,
                                 default = nil)
  if valid_579315 != nil:
    section.add "quotaUser", valid_579315
  var valid_579316 = query.getOrDefault("callback")
  valid_579316 = validateParameter(valid_579316, JString, required = false,
                                 default = nil)
  if valid_579316 != nil:
    section.add "callback", valid_579316
  var valid_579317 = query.getOrDefault("fields")
  valid_579317 = validateParameter(valid_579317, JString, required = false,
                                 default = nil)
  if valid_579317 != nil:
    section.add "fields", valid_579317
  var valid_579318 = query.getOrDefault("access_token")
  valid_579318 = validateParameter(valid_579318, JString, required = false,
                                 default = nil)
  if valid_579318 != nil:
    section.add "access_token", valid_579318
  var valid_579319 = query.getOrDefault("upload_protocol")
  valid_579319 = validateParameter(valid_579319, JString, required = false,
                                 default = nil)
  if valid_579319 != nil:
    section.add "upload_protocol", valid_579319
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

proc call*(call_579321: Call_FirestoreProjectsDatabasesDocumentsListCollectionIds_579305;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the collection IDs underneath a document.
  ## 
  let valid = call_579321.validator(path, query, header, formData, body)
  let scheme = call_579321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579321.url(scheme.get, call_579321.host, call_579321.base,
                         call_579321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579321, url, valid)

proc call*(call_579322: Call_FirestoreProjectsDatabasesDocumentsListCollectionIds_579305;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firestoreProjectsDatabasesDocumentsListCollectionIds
  ## Lists all the collection IDs underneath a document.
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
  ##   parent: string (required)
  ##         : The parent document. In the format:
  ## `projects/{project_id}/databases/{database_id}/documents/{document_path}`.
  ## For example:
  ## `projects/my-project/databases/my-database/documents/chatrooms/my-chatroom`
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579323 = newJObject()
  var query_579324 = newJObject()
  var body_579325 = newJObject()
  add(query_579324, "key", newJString(key))
  add(query_579324, "prettyPrint", newJBool(prettyPrint))
  add(query_579324, "oauth_token", newJString(oauthToken))
  add(query_579324, "$.xgafv", newJString(Xgafv))
  add(query_579324, "alt", newJString(alt))
  add(query_579324, "uploadType", newJString(uploadType))
  add(query_579324, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579325 = body
  add(query_579324, "callback", newJString(callback))
  add(path_579323, "parent", newJString(parent))
  add(query_579324, "fields", newJString(fields))
  add(query_579324, "access_token", newJString(accessToken))
  add(query_579324, "upload_protocol", newJString(uploadProtocol))
  result = call_579322.call(path_579323, query_579324, nil, nil, body_579325)

var firestoreProjectsDatabasesDocumentsListCollectionIds* = Call_FirestoreProjectsDatabasesDocumentsListCollectionIds_579305(
    name: "firestoreProjectsDatabasesDocumentsListCollectionIds",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1/{parent}:listCollectionIds",
    validator: validate_FirestoreProjectsDatabasesDocumentsListCollectionIds_579306,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsListCollectionIds_579307,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsRunQuery_579326 = ref object of OpenApiRestCall_578348
proc url_FirestoreProjectsDatabasesDocumentsRunQuery_579328(protocol: Scheme;
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

proc validate_FirestoreProjectsDatabasesDocumentsRunQuery_579327(path: JsonNode;
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
  var valid_579329 = path.getOrDefault("parent")
  valid_579329 = validateParameter(valid_579329, JString, required = true,
                                 default = nil)
  if valid_579329 != nil:
    section.add "parent", valid_579329
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
  var valid_579330 = query.getOrDefault("key")
  valid_579330 = validateParameter(valid_579330, JString, required = false,
                                 default = nil)
  if valid_579330 != nil:
    section.add "key", valid_579330
  var valid_579331 = query.getOrDefault("prettyPrint")
  valid_579331 = validateParameter(valid_579331, JBool, required = false,
                                 default = newJBool(true))
  if valid_579331 != nil:
    section.add "prettyPrint", valid_579331
  var valid_579332 = query.getOrDefault("oauth_token")
  valid_579332 = validateParameter(valid_579332, JString, required = false,
                                 default = nil)
  if valid_579332 != nil:
    section.add "oauth_token", valid_579332
  var valid_579333 = query.getOrDefault("$.xgafv")
  valid_579333 = validateParameter(valid_579333, JString, required = false,
                                 default = newJString("1"))
  if valid_579333 != nil:
    section.add "$.xgafv", valid_579333
  var valid_579334 = query.getOrDefault("alt")
  valid_579334 = validateParameter(valid_579334, JString, required = false,
                                 default = newJString("json"))
  if valid_579334 != nil:
    section.add "alt", valid_579334
  var valid_579335 = query.getOrDefault("uploadType")
  valid_579335 = validateParameter(valid_579335, JString, required = false,
                                 default = nil)
  if valid_579335 != nil:
    section.add "uploadType", valid_579335
  var valid_579336 = query.getOrDefault("quotaUser")
  valid_579336 = validateParameter(valid_579336, JString, required = false,
                                 default = nil)
  if valid_579336 != nil:
    section.add "quotaUser", valid_579336
  var valid_579337 = query.getOrDefault("callback")
  valid_579337 = validateParameter(valid_579337, JString, required = false,
                                 default = nil)
  if valid_579337 != nil:
    section.add "callback", valid_579337
  var valid_579338 = query.getOrDefault("fields")
  valid_579338 = validateParameter(valid_579338, JString, required = false,
                                 default = nil)
  if valid_579338 != nil:
    section.add "fields", valid_579338
  var valid_579339 = query.getOrDefault("access_token")
  valid_579339 = validateParameter(valid_579339, JString, required = false,
                                 default = nil)
  if valid_579339 != nil:
    section.add "access_token", valid_579339
  var valid_579340 = query.getOrDefault("upload_protocol")
  valid_579340 = validateParameter(valid_579340, JString, required = false,
                                 default = nil)
  if valid_579340 != nil:
    section.add "upload_protocol", valid_579340
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

proc call*(call_579342: Call_FirestoreProjectsDatabasesDocumentsRunQuery_579326;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Runs a query.
  ## 
  let valid = call_579342.validator(path, query, header, formData, body)
  let scheme = call_579342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579342.url(scheme.get, call_579342.host, call_579342.base,
                         call_579342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579342, url, valid)

proc call*(call_579343: Call_FirestoreProjectsDatabasesDocumentsRunQuery_579326;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firestoreProjectsDatabasesDocumentsRunQuery
  ## Runs a query.
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
  ##   parent: string (required)
  ##         : The parent resource name. In the format:
  ## `projects/{project_id}/databases/{database_id}/documents` or
  ## `projects/{project_id}/databases/{database_id}/documents/{document_path}`.
  ## For example:
  ## `projects/my-project/databases/my-database/documents` or
  ## `projects/my-project/databases/my-database/documents/chatrooms/my-chatroom`
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579344 = newJObject()
  var query_579345 = newJObject()
  var body_579346 = newJObject()
  add(query_579345, "key", newJString(key))
  add(query_579345, "prettyPrint", newJBool(prettyPrint))
  add(query_579345, "oauth_token", newJString(oauthToken))
  add(query_579345, "$.xgafv", newJString(Xgafv))
  add(query_579345, "alt", newJString(alt))
  add(query_579345, "uploadType", newJString(uploadType))
  add(query_579345, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579346 = body
  add(query_579345, "callback", newJString(callback))
  add(path_579344, "parent", newJString(parent))
  add(query_579345, "fields", newJString(fields))
  add(query_579345, "access_token", newJString(accessToken))
  add(query_579345, "upload_protocol", newJString(uploadProtocol))
  result = call_579343.call(path_579344, query_579345, nil, nil, body_579346)

var firestoreProjectsDatabasesDocumentsRunQuery* = Call_FirestoreProjectsDatabasesDocumentsRunQuery_579326(
    name: "firestoreProjectsDatabasesDocumentsRunQuery",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1/{parent}:runQuery",
    validator: validate_FirestoreProjectsDatabasesDocumentsRunQuery_579327,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsRunQuery_579328,
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
