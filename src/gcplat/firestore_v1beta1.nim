
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Firestore
## version: v1beta1
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
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
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
    route: "/v1beta1/{database}/documents:batchGet",
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
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
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
    route: "/v1beta1/{database}/documents:beginTransaction",
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
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
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
    host: "firestore.googleapis.com",
    route: "/v1beta1/{database}/documents:commit",
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
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
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
    host: "firestore.googleapis.com",
    route: "/v1beta1/{database}/documents:listen",
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
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
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
    route: "/v1beta1/{database}/documents:rollback",
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
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
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
    host: "firestore.googleapis.com",
    route: "/v1beta1/{database}/documents:write",
    validator: validate_FirestoreProjectsDatabasesDocumentsWrite_578994,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsWrite_578995,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesIndexesGet_579014 = ref object of OpenApiRestCall_578348
proc url_FirestoreProjectsDatabasesIndexesGet_579016(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesIndexesGet_579015(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an index.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the index. For example:
  ## `projects/{project_id}/databases/{database_id}/indexes/{index_id}`
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

proc call*(call_579032: Call_FirestoreProjectsDatabasesIndexesGet_579014;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets an index.
  ## 
  let valid = call_579032.validator(path, query, header, formData, body)
  let scheme = call_579032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579032.url(scheme.get, call_579032.host, call_579032.base,
                         call_579032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579032, url, valid)

proc call*(call_579033: Call_FirestoreProjectsDatabasesIndexesGet_579014;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; transaction: string = ""; Xgafv: string = "1";
          readTime: string = ""; alt: string = "json"; uploadType: string = "";
          maskFieldPaths: JsonNode = nil; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firestoreProjectsDatabasesIndexesGet
  ## Gets an index.
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
  ##       : The name of the index. For example:
  ## `projects/{project_id}/databases/{database_id}/indexes/{index_id}`
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

var firestoreProjectsDatabasesIndexesGet* = Call_FirestoreProjectsDatabasesIndexesGet_579014(
    name: "firestoreProjectsDatabasesIndexesGet", meth: HttpMethod.HttpGet,
    host: "firestore.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_FirestoreProjectsDatabasesIndexesGet_579015, base: "/",
    url: url_FirestoreProjectsDatabasesIndexesGet_579016, schemes: {Scheme.Https})
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
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
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
    host: "firestore.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_FirestoreProjectsDatabasesDocumentsPatch_579058,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsPatch_579059,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesIndexesDelete_579036 = ref object of OpenApiRestCall_578348
proc url_FirestoreProjectsDatabasesIndexesDelete_579038(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesIndexesDelete_579037(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an index.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The index name. For example:
  ## `projects/{project_id}/databases/{database_id}/indexes/{index_id}`
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

proc call*(call_579053: Call_FirestoreProjectsDatabasesIndexesDelete_579036;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an index.
  ## 
  let valid = call_579053.validator(path, query, header, formData, body)
  let scheme = call_579053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579053.url(scheme.get, call_579053.host, call_579053.base,
                         call_579053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579053, url, valid)

proc call*(call_579054: Call_FirestoreProjectsDatabasesIndexesDelete_579036;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1";
          currentDocumentExists: bool = false;
          currentDocumentUpdateTime: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firestoreProjectsDatabasesIndexesDelete
  ## Deletes an index.
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
  ##       : The index name. For example:
  ## `projects/{project_id}/databases/{database_id}/indexes/{index_id}`
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

var firestoreProjectsDatabasesIndexesDelete* = Call_FirestoreProjectsDatabasesIndexesDelete_579036(
    name: "firestoreProjectsDatabasesIndexesDelete", meth: HttpMethod.HttpDelete,
    host: "firestore.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_FirestoreProjectsDatabasesIndexesDelete_579037, base: "/",
    url: url_FirestoreProjectsDatabasesIndexesDelete_579038,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesExportDocuments_579082 = ref object of OpenApiRestCall_578348
proc url_FirestoreProjectsDatabasesExportDocuments_579084(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":exportDocuments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesExportDocuments_579083(path: JsonNode;
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
  var valid_579090 = query.getOrDefault("alt")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = newJString("json"))
  if valid_579090 != nil:
    section.add "alt", valid_579090
  var valid_579091 = query.getOrDefault("uploadType")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "uploadType", valid_579091
  var valid_579092 = query.getOrDefault("quotaUser")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "quotaUser", valid_579092
  var valid_579093 = query.getOrDefault("callback")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "callback", valid_579093
  var valid_579094 = query.getOrDefault("fields")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "fields", valid_579094
  var valid_579095 = query.getOrDefault("access_token")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "access_token", valid_579095
  var valid_579096 = query.getOrDefault("upload_protocol")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "upload_protocol", valid_579096
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

proc call*(call_579098: Call_FirestoreProjectsDatabasesExportDocuments_579082;
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
  let valid = call_579098.validator(path, query, header, formData, body)
  let scheme = call_579098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579098.url(scheme.get, call_579098.host, call_579098.base,
                         call_579098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579098, url, valid)

proc call*(call_579099: Call_FirestoreProjectsDatabasesExportDocuments_579082;
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
  var path_579100 = newJObject()
  var query_579101 = newJObject()
  var body_579102 = newJObject()
  add(query_579101, "key", newJString(key))
  add(query_579101, "prettyPrint", newJBool(prettyPrint))
  add(query_579101, "oauth_token", newJString(oauthToken))
  add(query_579101, "$.xgafv", newJString(Xgafv))
  add(query_579101, "alt", newJString(alt))
  add(query_579101, "uploadType", newJString(uploadType))
  add(query_579101, "quotaUser", newJString(quotaUser))
  add(path_579100, "name", newJString(name))
  if body != nil:
    body_579102 = body
  add(query_579101, "callback", newJString(callback))
  add(query_579101, "fields", newJString(fields))
  add(query_579101, "access_token", newJString(accessToken))
  add(query_579101, "upload_protocol", newJString(uploadProtocol))
  result = call_579099.call(path_579100, query_579101, nil, nil, body_579102)

var firestoreProjectsDatabasesExportDocuments* = Call_FirestoreProjectsDatabasesExportDocuments_579082(
    name: "firestoreProjectsDatabasesExportDocuments", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com", route: "/v1beta1/{name}:exportDocuments",
    validator: validate_FirestoreProjectsDatabasesExportDocuments_579083,
    base: "/", url: url_FirestoreProjectsDatabasesExportDocuments_579084,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesImportDocuments_579103 = ref object of OpenApiRestCall_578348
proc url_FirestoreProjectsDatabasesImportDocuments_579105(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":importDocuments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesImportDocuments_579104(path: JsonNode;
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
  var valid_579106 = path.getOrDefault("name")
  valid_579106 = validateParameter(valid_579106, JString, required = true,
                                 default = nil)
  if valid_579106 != nil:
    section.add "name", valid_579106
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
  var valid_579107 = query.getOrDefault("key")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "key", valid_579107
  var valid_579108 = query.getOrDefault("prettyPrint")
  valid_579108 = validateParameter(valid_579108, JBool, required = false,
                                 default = newJBool(true))
  if valid_579108 != nil:
    section.add "prettyPrint", valid_579108
  var valid_579109 = query.getOrDefault("oauth_token")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "oauth_token", valid_579109
  var valid_579110 = query.getOrDefault("$.xgafv")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = newJString("1"))
  if valid_579110 != nil:
    section.add "$.xgafv", valid_579110
  var valid_579111 = query.getOrDefault("alt")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = newJString("json"))
  if valid_579111 != nil:
    section.add "alt", valid_579111
  var valid_579112 = query.getOrDefault("uploadType")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "uploadType", valid_579112
  var valid_579113 = query.getOrDefault("quotaUser")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "quotaUser", valid_579113
  var valid_579114 = query.getOrDefault("callback")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "callback", valid_579114
  var valid_579115 = query.getOrDefault("fields")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = nil)
  if valid_579115 != nil:
    section.add "fields", valid_579115
  var valid_579116 = query.getOrDefault("access_token")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "access_token", valid_579116
  var valid_579117 = query.getOrDefault("upload_protocol")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "upload_protocol", valid_579117
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

proc call*(call_579119: Call_FirestoreProjectsDatabasesImportDocuments_579103;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Imports documents into Google Cloud Firestore. Existing documents with the
  ## same name are overwritten. The import occurs in the background and its
  ## progress can be monitored and managed via the Operation resource that is
  ## created. If an ImportDocuments operation is cancelled, it is possible
  ## that a subset of the data has already been imported to Cloud Firestore.
  ## 
  let valid = call_579119.validator(path, query, header, formData, body)
  let scheme = call_579119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579119.url(scheme.get, call_579119.host, call_579119.base,
                         call_579119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579119, url, valid)

proc call*(call_579120: Call_FirestoreProjectsDatabasesImportDocuments_579103;
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
  var path_579121 = newJObject()
  var query_579122 = newJObject()
  var body_579123 = newJObject()
  add(query_579122, "key", newJString(key))
  add(query_579122, "prettyPrint", newJBool(prettyPrint))
  add(query_579122, "oauth_token", newJString(oauthToken))
  add(query_579122, "$.xgafv", newJString(Xgafv))
  add(query_579122, "alt", newJString(alt))
  add(query_579122, "uploadType", newJString(uploadType))
  add(query_579122, "quotaUser", newJString(quotaUser))
  add(path_579121, "name", newJString(name))
  if body != nil:
    body_579123 = body
  add(query_579122, "callback", newJString(callback))
  add(query_579122, "fields", newJString(fields))
  add(query_579122, "access_token", newJString(accessToken))
  add(query_579122, "upload_protocol", newJString(uploadProtocol))
  result = call_579120.call(path_579121, query_579122, nil, nil, body_579123)

var firestoreProjectsDatabasesImportDocuments* = Call_FirestoreProjectsDatabasesImportDocuments_579103(
    name: "firestoreProjectsDatabasesImportDocuments", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com", route: "/v1beta1/{name}:importDocuments",
    validator: validate_FirestoreProjectsDatabasesImportDocuments_579104,
    base: "/", url: url_FirestoreProjectsDatabasesImportDocuments_579105,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesIndexesCreate_579146 = ref object of OpenApiRestCall_578348
proc url_FirestoreProjectsDatabasesIndexesCreate_579148(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/indexes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesIndexesCreate_579147(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates the specified index.
  ## A newly created index's initial state is `CREATING`. On completion of the
  ## returned google.longrunning.Operation, the state will be `READY`.
  ## If the index already exists, the call will return an `ALREADY_EXISTS`
  ## status.
  ## 
  ## During creation, the process could result in an error, in which case the
  ## index will move to the `ERROR` state. The process can be recovered by
  ## fixing the data that caused the error, removing the index with
  ## delete, then re-creating the index with
  ## create.
  ## 
  ## Indexes with a single field cannot be created.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The name of the database this index will apply to. For example:
  ## `projects/{project_id}/databases/{database_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579149 = path.getOrDefault("parent")
  valid_579149 = validateParameter(valid_579149, JString, required = true,
                                 default = nil)
  if valid_579149 != nil:
    section.add "parent", valid_579149
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
  var valid_579150 = query.getOrDefault("key")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = nil)
  if valid_579150 != nil:
    section.add "key", valid_579150
  var valid_579151 = query.getOrDefault("prettyPrint")
  valid_579151 = validateParameter(valid_579151, JBool, required = false,
                                 default = newJBool(true))
  if valid_579151 != nil:
    section.add "prettyPrint", valid_579151
  var valid_579152 = query.getOrDefault("oauth_token")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = nil)
  if valid_579152 != nil:
    section.add "oauth_token", valid_579152
  var valid_579153 = query.getOrDefault("$.xgafv")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = newJString("1"))
  if valid_579153 != nil:
    section.add "$.xgafv", valid_579153
  var valid_579154 = query.getOrDefault("alt")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = newJString("json"))
  if valid_579154 != nil:
    section.add "alt", valid_579154
  var valid_579155 = query.getOrDefault("uploadType")
  valid_579155 = validateParameter(valid_579155, JString, required = false,
                                 default = nil)
  if valid_579155 != nil:
    section.add "uploadType", valid_579155
  var valid_579156 = query.getOrDefault("quotaUser")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = nil)
  if valid_579156 != nil:
    section.add "quotaUser", valid_579156
  var valid_579157 = query.getOrDefault("callback")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = nil)
  if valid_579157 != nil:
    section.add "callback", valid_579157
  var valid_579158 = query.getOrDefault("fields")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = nil)
  if valid_579158 != nil:
    section.add "fields", valid_579158
  var valid_579159 = query.getOrDefault("access_token")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = nil)
  if valid_579159 != nil:
    section.add "access_token", valid_579159
  var valid_579160 = query.getOrDefault("upload_protocol")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "upload_protocol", valid_579160
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

proc call*(call_579162: Call_FirestoreProjectsDatabasesIndexesCreate_579146;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates the specified index.
  ## A newly created index's initial state is `CREATING`. On completion of the
  ## returned google.longrunning.Operation, the state will be `READY`.
  ## If the index already exists, the call will return an `ALREADY_EXISTS`
  ## status.
  ## 
  ## During creation, the process could result in an error, in which case the
  ## index will move to the `ERROR` state. The process can be recovered by
  ## fixing the data that caused the error, removing the index with
  ## delete, then re-creating the index with
  ## create.
  ## 
  ## Indexes with a single field cannot be created.
  ## 
  let valid = call_579162.validator(path, query, header, formData, body)
  let scheme = call_579162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579162.url(scheme.get, call_579162.host, call_579162.base,
                         call_579162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579162, url, valid)

proc call*(call_579163: Call_FirestoreProjectsDatabasesIndexesCreate_579146;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## firestoreProjectsDatabasesIndexesCreate
  ## Creates the specified index.
  ## A newly created index's initial state is `CREATING`. On completion of the
  ## returned google.longrunning.Operation, the state will be `READY`.
  ## If the index already exists, the call will return an `ALREADY_EXISTS`
  ## status.
  ## 
  ## During creation, the process could result in an error, in which case the
  ## index will move to the `ERROR` state. The process can be recovered by
  ## fixing the data that caused the error, removing the index with
  ## delete, then re-creating the index with
  ## create.
  ## 
  ## Indexes with a single field cannot be created.
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
  ##         : The name of the database this index will apply to. For example:
  ## `projects/{project_id}/databases/{database_id}`
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579164 = newJObject()
  var query_579165 = newJObject()
  var body_579166 = newJObject()
  add(query_579165, "key", newJString(key))
  add(query_579165, "prettyPrint", newJBool(prettyPrint))
  add(query_579165, "oauth_token", newJString(oauthToken))
  add(query_579165, "$.xgafv", newJString(Xgafv))
  add(query_579165, "alt", newJString(alt))
  add(query_579165, "uploadType", newJString(uploadType))
  add(query_579165, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579166 = body
  add(query_579165, "callback", newJString(callback))
  add(path_579164, "parent", newJString(parent))
  add(query_579165, "fields", newJString(fields))
  add(query_579165, "access_token", newJString(accessToken))
  add(query_579165, "upload_protocol", newJString(uploadProtocol))
  result = call_579163.call(path_579164, query_579165, nil, nil, body_579166)

var firestoreProjectsDatabasesIndexesCreate* = Call_FirestoreProjectsDatabasesIndexesCreate_579146(
    name: "firestoreProjectsDatabasesIndexesCreate", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com", route: "/v1beta1/{parent}/indexes",
    validator: validate_FirestoreProjectsDatabasesIndexesCreate_579147, base: "/",
    url: url_FirestoreProjectsDatabasesIndexesCreate_579148,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesIndexesList_579124 = ref object of OpenApiRestCall_578348
proc url_FirestoreProjectsDatabasesIndexesList_579126(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/indexes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesIndexesList_579125(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the indexes that match the specified filters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The database name. For example:
  ## `projects/{project_id}/databases/{database_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579127 = path.getOrDefault("parent")
  valid_579127 = validateParameter(valid_579127, JString, required = true,
                                 default = nil)
  if valid_579127 != nil:
    section.add "parent", valid_579127
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
  ##           : The standard List page size.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##   pageToken: JString
  ##            : The standard List page token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579128 = query.getOrDefault("key")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "key", valid_579128
  var valid_579129 = query.getOrDefault("prettyPrint")
  valid_579129 = validateParameter(valid_579129, JBool, required = false,
                                 default = newJBool(true))
  if valid_579129 != nil:
    section.add "prettyPrint", valid_579129
  var valid_579130 = query.getOrDefault("oauth_token")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "oauth_token", valid_579130
  var valid_579131 = query.getOrDefault("$.xgafv")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = newJString("1"))
  if valid_579131 != nil:
    section.add "$.xgafv", valid_579131
  var valid_579132 = query.getOrDefault("pageSize")
  valid_579132 = validateParameter(valid_579132, JInt, required = false, default = nil)
  if valid_579132 != nil:
    section.add "pageSize", valid_579132
  var valid_579133 = query.getOrDefault("alt")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = newJString("json"))
  if valid_579133 != nil:
    section.add "alt", valid_579133
  var valid_579134 = query.getOrDefault("uploadType")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = nil)
  if valid_579134 != nil:
    section.add "uploadType", valid_579134
  var valid_579135 = query.getOrDefault("quotaUser")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "quotaUser", valid_579135
  var valid_579136 = query.getOrDefault("filter")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = nil)
  if valid_579136 != nil:
    section.add "filter", valid_579136
  var valid_579137 = query.getOrDefault("pageToken")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = nil)
  if valid_579137 != nil:
    section.add "pageToken", valid_579137
  var valid_579138 = query.getOrDefault("callback")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "callback", valid_579138
  var valid_579139 = query.getOrDefault("fields")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "fields", valid_579139
  var valid_579140 = query.getOrDefault("access_token")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = nil)
  if valid_579140 != nil:
    section.add "access_token", valid_579140
  var valid_579141 = query.getOrDefault("upload_protocol")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "upload_protocol", valid_579141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579142: Call_FirestoreProjectsDatabasesIndexesList_579124;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the indexes that match the specified filters.
  ## 
  let valid = call_579142.validator(path, query, header, formData, body)
  let scheme = call_579142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579142.url(scheme.get, call_579142.host, call_579142.base,
                         call_579142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579142, url, valid)

proc call*(call_579143: Call_FirestoreProjectsDatabasesIndexesList_579124;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## firestoreProjectsDatabasesIndexesList
  ## Lists the indexes that match the specified filters.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard List page size.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##   pageToken: string
  ##            : The standard List page token.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The database name. For example:
  ## `projects/{project_id}/databases/{database_id}`
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579144 = newJObject()
  var query_579145 = newJObject()
  add(query_579145, "key", newJString(key))
  add(query_579145, "prettyPrint", newJBool(prettyPrint))
  add(query_579145, "oauth_token", newJString(oauthToken))
  add(query_579145, "$.xgafv", newJString(Xgafv))
  add(query_579145, "pageSize", newJInt(pageSize))
  add(query_579145, "alt", newJString(alt))
  add(query_579145, "uploadType", newJString(uploadType))
  add(query_579145, "quotaUser", newJString(quotaUser))
  add(query_579145, "filter", newJString(filter))
  add(query_579145, "pageToken", newJString(pageToken))
  add(query_579145, "callback", newJString(callback))
  add(path_579144, "parent", newJString(parent))
  add(query_579145, "fields", newJString(fields))
  add(query_579145, "access_token", newJString(accessToken))
  add(query_579145, "upload_protocol", newJString(uploadProtocol))
  result = call_579143.call(path_579144, query_579145, nil, nil, nil)

var firestoreProjectsDatabasesIndexesList* = Call_FirestoreProjectsDatabasesIndexesList_579124(
    name: "firestoreProjectsDatabasesIndexesList", meth: HttpMethod.HttpGet,
    host: "firestore.googleapis.com", route: "/v1beta1/{parent}/indexes",
    validator: validate_FirestoreProjectsDatabasesIndexesList_579125, base: "/",
    url: url_FirestoreProjectsDatabasesIndexesList_579126, schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsCreateDocument_579194 = ref object of OpenApiRestCall_578348
proc url_FirestoreProjectsDatabasesDocumentsCreateDocument_579196(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "collectionId" in path, "`collectionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "collectionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesDocumentsCreateDocument_579195(
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
  var valid_579197 = path.getOrDefault("parent")
  valid_579197 = validateParameter(valid_579197, JString, required = true,
                                 default = nil)
  if valid_579197 != nil:
    section.add "parent", valid_579197
  var valid_579198 = path.getOrDefault("collectionId")
  valid_579198 = validateParameter(valid_579198, JString, required = true,
                                 default = nil)
  if valid_579198 != nil:
    section.add "collectionId", valid_579198
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
  var valid_579199 = query.getOrDefault("key")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "key", valid_579199
  var valid_579200 = query.getOrDefault("prettyPrint")
  valid_579200 = validateParameter(valid_579200, JBool, required = false,
                                 default = newJBool(true))
  if valid_579200 != nil:
    section.add "prettyPrint", valid_579200
  var valid_579201 = query.getOrDefault("oauth_token")
  valid_579201 = validateParameter(valid_579201, JString, required = false,
                                 default = nil)
  if valid_579201 != nil:
    section.add "oauth_token", valid_579201
  var valid_579202 = query.getOrDefault("documentId")
  valid_579202 = validateParameter(valid_579202, JString, required = false,
                                 default = nil)
  if valid_579202 != nil:
    section.add "documentId", valid_579202
  var valid_579203 = query.getOrDefault("$.xgafv")
  valid_579203 = validateParameter(valid_579203, JString, required = false,
                                 default = newJString("1"))
  if valid_579203 != nil:
    section.add "$.xgafv", valid_579203
  var valid_579204 = query.getOrDefault("alt")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = newJString("json"))
  if valid_579204 != nil:
    section.add "alt", valid_579204
  var valid_579205 = query.getOrDefault("uploadType")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = nil)
  if valid_579205 != nil:
    section.add "uploadType", valid_579205
  var valid_579206 = query.getOrDefault("mask.fieldPaths")
  valid_579206 = validateParameter(valid_579206, JArray, required = false,
                                 default = nil)
  if valid_579206 != nil:
    section.add "mask.fieldPaths", valid_579206
  var valid_579207 = query.getOrDefault("quotaUser")
  valid_579207 = validateParameter(valid_579207, JString, required = false,
                                 default = nil)
  if valid_579207 != nil:
    section.add "quotaUser", valid_579207
  var valid_579208 = query.getOrDefault("callback")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = nil)
  if valid_579208 != nil:
    section.add "callback", valid_579208
  var valid_579209 = query.getOrDefault("fields")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = nil)
  if valid_579209 != nil:
    section.add "fields", valid_579209
  var valid_579210 = query.getOrDefault("access_token")
  valid_579210 = validateParameter(valid_579210, JString, required = false,
                                 default = nil)
  if valid_579210 != nil:
    section.add "access_token", valid_579210
  var valid_579211 = query.getOrDefault("upload_protocol")
  valid_579211 = validateParameter(valid_579211, JString, required = false,
                                 default = nil)
  if valid_579211 != nil:
    section.add "upload_protocol", valid_579211
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

proc call*(call_579213: Call_FirestoreProjectsDatabasesDocumentsCreateDocument_579194;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new document.
  ## 
  let valid = call_579213.validator(path, query, header, formData, body)
  let scheme = call_579213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579213.url(scheme.get, call_579213.host, call_579213.base,
                         call_579213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579213, url, valid)

proc call*(call_579214: Call_FirestoreProjectsDatabasesDocumentsCreateDocument_579194;
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
  var path_579215 = newJObject()
  var query_579216 = newJObject()
  var body_579217 = newJObject()
  add(query_579216, "key", newJString(key))
  add(query_579216, "prettyPrint", newJBool(prettyPrint))
  add(query_579216, "oauth_token", newJString(oauthToken))
  add(query_579216, "documentId", newJString(documentId))
  add(query_579216, "$.xgafv", newJString(Xgafv))
  add(query_579216, "alt", newJString(alt))
  add(query_579216, "uploadType", newJString(uploadType))
  if maskFieldPaths != nil:
    query_579216.add "mask.fieldPaths", maskFieldPaths
  add(query_579216, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579217 = body
  add(query_579216, "callback", newJString(callback))
  add(path_579215, "parent", newJString(parent))
  add(query_579216, "fields", newJString(fields))
  add(query_579216, "access_token", newJString(accessToken))
  add(query_579216, "upload_protocol", newJString(uploadProtocol))
  add(path_579215, "collectionId", newJString(collectionId))
  result = call_579214.call(path_579215, query_579216, nil, nil, body_579217)

var firestoreProjectsDatabasesDocumentsCreateDocument* = Call_FirestoreProjectsDatabasesDocumentsCreateDocument_579194(
    name: "firestoreProjectsDatabasesDocumentsCreateDocument",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1beta1/{parent}/{collectionId}",
    validator: validate_FirestoreProjectsDatabasesDocumentsCreateDocument_579195,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsCreateDocument_579196,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsList_579167 = ref object of OpenApiRestCall_578348
proc url_FirestoreProjectsDatabasesDocumentsList_579169(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "collectionId" in path, "`collectionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "collectionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesDocumentsList_579168(path: JsonNode;
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
  var valid_579170 = path.getOrDefault("parent")
  valid_579170 = validateParameter(valid_579170, JString, required = true,
                                 default = nil)
  if valid_579170 != nil:
    section.add "parent", valid_579170
  var valid_579171 = path.getOrDefault("collectionId")
  valid_579171 = validateParameter(valid_579171, JString, required = true,
                                 default = nil)
  if valid_579171 != nil:
    section.add "collectionId", valid_579171
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
  var valid_579175 = query.getOrDefault("showMissing")
  valid_579175 = validateParameter(valid_579175, JBool, required = false, default = nil)
  if valid_579175 != nil:
    section.add "showMissing", valid_579175
  var valid_579176 = query.getOrDefault("transaction")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = nil)
  if valid_579176 != nil:
    section.add "transaction", valid_579176
  var valid_579177 = query.getOrDefault("$.xgafv")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = newJString("1"))
  if valid_579177 != nil:
    section.add "$.xgafv", valid_579177
  var valid_579178 = query.getOrDefault("pageSize")
  valid_579178 = validateParameter(valid_579178, JInt, required = false, default = nil)
  if valid_579178 != nil:
    section.add "pageSize", valid_579178
  var valid_579179 = query.getOrDefault("readTime")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "readTime", valid_579179
  var valid_579180 = query.getOrDefault("alt")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = newJString("json"))
  if valid_579180 != nil:
    section.add "alt", valid_579180
  var valid_579181 = query.getOrDefault("uploadType")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "uploadType", valid_579181
  var valid_579182 = query.getOrDefault("mask.fieldPaths")
  valid_579182 = validateParameter(valid_579182, JArray, required = false,
                                 default = nil)
  if valid_579182 != nil:
    section.add "mask.fieldPaths", valid_579182
  var valid_579183 = query.getOrDefault("quotaUser")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "quotaUser", valid_579183
  var valid_579184 = query.getOrDefault("orderBy")
  valid_579184 = validateParameter(valid_579184, JString, required = false,
                                 default = nil)
  if valid_579184 != nil:
    section.add "orderBy", valid_579184
  var valid_579185 = query.getOrDefault("pageToken")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "pageToken", valid_579185
  var valid_579186 = query.getOrDefault("callback")
  valid_579186 = validateParameter(valid_579186, JString, required = false,
                                 default = nil)
  if valid_579186 != nil:
    section.add "callback", valid_579186
  var valid_579187 = query.getOrDefault("fields")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = nil)
  if valid_579187 != nil:
    section.add "fields", valid_579187
  var valid_579188 = query.getOrDefault("access_token")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = nil)
  if valid_579188 != nil:
    section.add "access_token", valid_579188
  var valid_579189 = query.getOrDefault("upload_protocol")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "upload_protocol", valid_579189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579190: Call_FirestoreProjectsDatabasesDocumentsList_579167;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists documents.
  ## 
  let valid = call_579190.validator(path, query, header, formData, body)
  let scheme = call_579190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579190.url(scheme.get, call_579190.host, call_579190.base,
                         call_579190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579190, url, valid)

proc call*(call_579191: Call_FirestoreProjectsDatabasesDocumentsList_579167;
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
  var path_579192 = newJObject()
  var query_579193 = newJObject()
  add(query_579193, "key", newJString(key))
  add(query_579193, "prettyPrint", newJBool(prettyPrint))
  add(query_579193, "oauth_token", newJString(oauthToken))
  add(query_579193, "showMissing", newJBool(showMissing))
  add(query_579193, "transaction", newJString(transaction))
  add(query_579193, "$.xgafv", newJString(Xgafv))
  add(query_579193, "pageSize", newJInt(pageSize))
  add(query_579193, "readTime", newJString(readTime))
  add(query_579193, "alt", newJString(alt))
  add(query_579193, "uploadType", newJString(uploadType))
  if maskFieldPaths != nil:
    query_579193.add "mask.fieldPaths", maskFieldPaths
  add(query_579193, "quotaUser", newJString(quotaUser))
  add(query_579193, "orderBy", newJString(orderBy))
  add(query_579193, "pageToken", newJString(pageToken))
  add(query_579193, "callback", newJString(callback))
  add(path_579192, "parent", newJString(parent))
  add(query_579193, "fields", newJString(fields))
  add(query_579193, "access_token", newJString(accessToken))
  add(query_579193, "upload_protocol", newJString(uploadProtocol))
  add(path_579192, "collectionId", newJString(collectionId))
  result = call_579191.call(path_579192, query_579193, nil, nil, nil)

var firestoreProjectsDatabasesDocumentsList* = Call_FirestoreProjectsDatabasesDocumentsList_579167(
    name: "firestoreProjectsDatabasesDocumentsList", meth: HttpMethod.HttpGet,
    host: "firestore.googleapis.com", route: "/v1beta1/{parent}/{collectionId}",
    validator: validate_FirestoreProjectsDatabasesDocumentsList_579168, base: "/",
    url: url_FirestoreProjectsDatabasesDocumentsList_579169,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsListCollectionIds_579218 = ref object of OpenApiRestCall_578348
proc url_FirestoreProjectsDatabasesDocumentsListCollectionIds_579220(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: ":listCollectionIds")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesDocumentsListCollectionIds_579219(
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
  var valid_579221 = path.getOrDefault("parent")
  valid_579221 = validateParameter(valid_579221, JString, required = true,
                                 default = nil)
  if valid_579221 != nil:
    section.add "parent", valid_579221
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
  var valid_579222 = query.getOrDefault("key")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = nil)
  if valid_579222 != nil:
    section.add "key", valid_579222
  var valid_579223 = query.getOrDefault("prettyPrint")
  valid_579223 = validateParameter(valid_579223, JBool, required = false,
                                 default = newJBool(true))
  if valid_579223 != nil:
    section.add "prettyPrint", valid_579223
  var valid_579224 = query.getOrDefault("oauth_token")
  valid_579224 = validateParameter(valid_579224, JString, required = false,
                                 default = nil)
  if valid_579224 != nil:
    section.add "oauth_token", valid_579224
  var valid_579225 = query.getOrDefault("$.xgafv")
  valid_579225 = validateParameter(valid_579225, JString, required = false,
                                 default = newJString("1"))
  if valid_579225 != nil:
    section.add "$.xgafv", valid_579225
  var valid_579226 = query.getOrDefault("alt")
  valid_579226 = validateParameter(valid_579226, JString, required = false,
                                 default = newJString("json"))
  if valid_579226 != nil:
    section.add "alt", valid_579226
  var valid_579227 = query.getOrDefault("uploadType")
  valid_579227 = validateParameter(valid_579227, JString, required = false,
                                 default = nil)
  if valid_579227 != nil:
    section.add "uploadType", valid_579227
  var valid_579228 = query.getOrDefault("quotaUser")
  valid_579228 = validateParameter(valid_579228, JString, required = false,
                                 default = nil)
  if valid_579228 != nil:
    section.add "quotaUser", valid_579228
  var valid_579229 = query.getOrDefault("callback")
  valid_579229 = validateParameter(valid_579229, JString, required = false,
                                 default = nil)
  if valid_579229 != nil:
    section.add "callback", valid_579229
  var valid_579230 = query.getOrDefault("fields")
  valid_579230 = validateParameter(valid_579230, JString, required = false,
                                 default = nil)
  if valid_579230 != nil:
    section.add "fields", valid_579230
  var valid_579231 = query.getOrDefault("access_token")
  valid_579231 = validateParameter(valid_579231, JString, required = false,
                                 default = nil)
  if valid_579231 != nil:
    section.add "access_token", valid_579231
  var valid_579232 = query.getOrDefault("upload_protocol")
  valid_579232 = validateParameter(valid_579232, JString, required = false,
                                 default = nil)
  if valid_579232 != nil:
    section.add "upload_protocol", valid_579232
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

proc call*(call_579234: Call_FirestoreProjectsDatabasesDocumentsListCollectionIds_579218;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the collection IDs underneath a document.
  ## 
  let valid = call_579234.validator(path, query, header, formData, body)
  let scheme = call_579234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579234.url(scheme.get, call_579234.host, call_579234.base,
                         call_579234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579234, url, valid)

proc call*(call_579235: Call_FirestoreProjectsDatabasesDocumentsListCollectionIds_579218;
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
  var path_579236 = newJObject()
  var query_579237 = newJObject()
  var body_579238 = newJObject()
  add(query_579237, "key", newJString(key))
  add(query_579237, "prettyPrint", newJBool(prettyPrint))
  add(query_579237, "oauth_token", newJString(oauthToken))
  add(query_579237, "$.xgafv", newJString(Xgafv))
  add(query_579237, "alt", newJString(alt))
  add(query_579237, "uploadType", newJString(uploadType))
  add(query_579237, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579238 = body
  add(query_579237, "callback", newJString(callback))
  add(path_579236, "parent", newJString(parent))
  add(query_579237, "fields", newJString(fields))
  add(query_579237, "access_token", newJString(accessToken))
  add(query_579237, "upload_protocol", newJString(uploadProtocol))
  result = call_579235.call(path_579236, query_579237, nil, nil, body_579238)

var firestoreProjectsDatabasesDocumentsListCollectionIds* = Call_FirestoreProjectsDatabasesDocumentsListCollectionIds_579218(
    name: "firestoreProjectsDatabasesDocumentsListCollectionIds",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1beta1/{parent}:listCollectionIds",
    validator: validate_FirestoreProjectsDatabasesDocumentsListCollectionIds_579219,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsListCollectionIds_579220,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsRunQuery_579239 = ref object of OpenApiRestCall_578348
proc url_FirestoreProjectsDatabasesDocumentsRunQuery_579241(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: ":runQuery")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesDocumentsRunQuery_579240(path: JsonNode;
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
  var valid_579242 = path.getOrDefault("parent")
  valid_579242 = validateParameter(valid_579242, JString, required = true,
                                 default = nil)
  if valid_579242 != nil:
    section.add "parent", valid_579242
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
  var valid_579243 = query.getOrDefault("key")
  valid_579243 = validateParameter(valid_579243, JString, required = false,
                                 default = nil)
  if valid_579243 != nil:
    section.add "key", valid_579243
  var valid_579244 = query.getOrDefault("prettyPrint")
  valid_579244 = validateParameter(valid_579244, JBool, required = false,
                                 default = newJBool(true))
  if valid_579244 != nil:
    section.add "prettyPrint", valid_579244
  var valid_579245 = query.getOrDefault("oauth_token")
  valid_579245 = validateParameter(valid_579245, JString, required = false,
                                 default = nil)
  if valid_579245 != nil:
    section.add "oauth_token", valid_579245
  var valid_579246 = query.getOrDefault("$.xgafv")
  valid_579246 = validateParameter(valid_579246, JString, required = false,
                                 default = newJString("1"))
  if valid_579246 != nil:
    section.add "$.xgafv", valid_579246
  var valid_579247 = query.getOrDefault("alt")
  valid_579247 = validateParameter(valid_579247, JString, required = false,
                                 default = newJString("json"))
  if valid_579247 != nil:
    section.add "alt", valid_579247
  var valid_579248 = query.getOrDefault("uploadType")
  valid_579248 = validateParameter(valid_579248, JString, required = false,
                                 default = nil)
  if valid_579248 != nil:
    section.add "uploadType", valid_579248
  var valid_579249 = query.getOrDefault("quotaUser")
  valid_579249 = validateParameter(valid_579249, JString, required = false,
                                 default = nil)
  if valid_579249 != nil:
    section.add "quotaUser", valid_579249
  var valid_579250 = query.getOrDefault("callback")
  valid_579250 = validateParameter(valid_579250, JString, required = false,
                                 default = nil)
  if valid_579250 != nil:
    section.add "callback", valid_579250
  var valid_579251 = query.getOrDefault("fields")
  valid_579251 = validateParameter(valid_579251, JString, required = false,
                                 default = nil)
  if valid_579251 != nil:
    section.add "fields", valid_579251
  var valid_579252 = query.getOrDefault("access_token")
  valid_579252 = validateParameter(valid_579252, JString, required = false,
                                 default = nil)
  if valid_579252 != nil:
    section.add "access_token", valid_579252
  var valid_579253 = query.getOrDefault("upload_protocol")
  valid_579253 = validateParameter(valid_579253, JString, required = false,
                                 default = nil)
  if valid_579253 != nil:
    section.add "upload_protocol", valid_579253
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

proc call*(call_579255: Call_FirestoreProjectsDatabasesDocumentsRunQuery_579239;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Runs a query.
  ## 
  let valid = call_579255.validator(path, query, header, formData, body)
  let scheme = call_579255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579255.url(scheme.get, call_579255.host, call_579255.base,
                         call_579255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579255, url, valid)

proc call*(call_579256: Call_FirestoreProjectsDatabasesDocumentsRunQuery_579239;
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
  var path_579257 = newJObject()
  var query_579258 = newJObject()
  var body_579259 = newJObject()
  add(query_579258, "key", newJString(key))
  add(query_579258, "prettyPrint", newJBool(prettyPrint))
  add(query_579258, "oauth_token", newJString(oauthToken))
  add(query_579258, "$.xgafv", newJString(Xgafv))
  add(query_579258, "alt", newJString(alt))
  add(query_579258, "uploadType", newJString(uploadType))
  add(query_579258, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579259 = body
  add(query_579258, "callback", newJString(callback))
  add(path_579257, "parent", newJString(parent))
  add(query_579258, "fields", newJString(fields))
  add(query_579258, "access_token", newJString(accessToken))
  add(query_579258, "upload_protocol", newJString(uploadProtocol))
  result = call_579256.call(path_579257, query_579258, nil, nil, body_579259)

var firestoreProjectsDatabasesDocumentsRunQuery* = Call_FirestoreProjectsDatabasesDocumentsRunQuery_579239(
    name: "firestoreProjectsDatabasesDocumentsRunQuery",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1beta1/{parent}:runQuery",
    validator: validate_FirestoreProjectsDatabasesDocumentsRunQuery_579240,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsRunQuery_579241,
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
