
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593421): Option[Scheme] {.used.} =
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
  gcpServiceName = "firestore"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FirestoreProjectsDatabasesDocumentsBatchGet_593690 = ref object of OpenApiRestCall_593421
proc url_FirestoreProjectsDatabasesDocumentsBatchGet_593692(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FirestoreProjectsDatabasesDocumentsBatchGet_593691(path: JsonNode;
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
  var valid_593818 = path.getOrDefault("database")
  valid_593818 = validateParameter(valid_593818, JString, required = true,
                                 default = nil)
  if valid_593818 != nil:
    section.add "database", valid_593818
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
  var valid_593819 = query.getOrDefault("upload_protocol")
  valid_593819 = validateParameter(valid_593819, JString, required = false,
                                 default = nil)
  if valid_593819 != nil:
    section.add "upload_protocol", valid_593819
  var valid_593820 = query.getOrDefault("fields")
  valid_593820 = validateParameter(valid_593820, JString, required = false,
                                 default = nil)
  if valid_593820 != nil:
    section.add "fields", valid_593820
  var valid_593821 = query.getOrDefault("quotaUser")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = nil)
  if valid_593821 != nil:
    section.add "quotaUser", valid_593821
  var valid_593835 = query.getOrDefault("alt")
  valid_593835 = validateParameter(valid_593835, JString, required = false,
                                 default = newJString("json"))
  if valid_593835 != nil:
    section.add "alt", valid_593835
  var valid_593836 = query.getOrDefault("oauth_token")
  valid_593836 = validateParameter(valid_593836, JString, required = false,
                                 default = nil)
  if valid_593836 != nil:
    section.add "oauth_token", valid_593836
  var valid_593837 = query.getOrDefault("callback")
  valid_593837 = validateParameter(valid_593837, JString, required = false,
                                 default = nil)
  if valid_593837 != nil:
    section.add "callback", valid_593837
  var valid_593838 = query.getOrDefault("access_token")
  valid_593838 = validateParameter(valid_593838, JString, required = false,
                                 default = nil)
  if valid_593838 != nil:
    section.add "access_token", valid_593838
  var valid_593839 = query.getOrDefault("uploadType")
  valid_593839 = validateParameter(valid_593839, JString, required = false,
                                 default = nil)
  if valid_593839 != nil:
    section.add "uploadType", valid_593839
  var valid_593840 = query.getOrDefault("key")
  valid_593840 = validateParameter(valid_593840, JString, required = false,
                                 default = nil)
  if valid_593840 != nil:
    section.add "key", valid_593840
  var valid_593841 = query.getOrDefault("$.xgafv")
  valid_593841 = validateParameter(valid_593841, JString, required = false,
                                 default = newJString("1"))
  if valid_593841 != nil:
    section.add "$.xgafv", valid_593841
  var valid_593842 = query.getOrDefault("prettyPrint")
  valid_593842 = validateParameter(valid_593842, JBool, required = false,
                                 default = newJBool(true))
  if valid_593842 != nil:
    section.add "prettyPrint", valid_593842
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

proc call*(call_593866: Call_FirestoreProjectsDatabasesDocumentsBatchGet_593690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets multiple documents.
  ## 
  ## Documents returned by this method are not guaranteed to be returned in the
  ## same order that they were requested.
  ## 
  let valid = call_593866.validator(path, query, header, formData, body)
  let scheme = call_593866.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593866.url(scheme.get, call_593866.host, call_593866.base,
                         call_593866.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593866, url, valid)

proc call*(call_593937: Call_FirestoreProjectsDatabasesDocumentsBatchGet_593690;
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
  var path_593938 = newJObject()
  var query_593940 = newJObject()
  var body_593941 = newJObject()
  add(query_593940, "upload_protocol", newJString(uploadProtocol))
  add(query_593940, "fields", newJString(fields))
  add(query_593940, "quotaUser", newJString(quotaUser))
  add(query_593940, "alt", newJString(alt))
  add(query_593940, "oauth_token", newJString(oauthToken))
  add(query_593940, "callback", newJString(callback))
  add(query_593940, "access_token", newJString(accessToken))
  add(query_593940, "uploadType", newJString(uploadType))
  add(query_593940, "key", newJString(key))
  add(path_593938, "database", newJString(database))
  add(query_593940, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593941 = body
  add(query_593940, "prettyPrint", newJBool(prettyPrint))
  result = call_593937.call(path_593938, query_593940, nil, nil, body_593941)

var firestoreProjectsDatabasesDocumentsBatchGet* = Call_FirestoreProjectsDatabasesDocumentsBatchGet_593690(
    name: "firestoreProjectsDatabasesDocumentsBatchGet",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1beta1/{database}/documents:batchGet",
    validator: validate_FirestoreProjectsDatabasesDocumentsBatchGet_593691,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsBatchGet_593692,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsBeginTransaction_593980 = ref object of OpenApiRestCall_593421
proc url_FirestoreProjectsDatabasesDocumentsBeginTransaction_593982(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FirestoreProjectsDatabasesDocumentsBeginTransaction_593981(
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
  var valid_593983 = path.getOrDefault("database")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "database", valid_593983
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
  var valid_593984 = query.getOrDefault("upload_protocol")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "upload_protocol", valid_593984
  var valid_593985 = query.getOrDefault("fields")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = nil)
  if valid_593985 != nil:
    section.add "fields", valid_593985
  var valid_593986 = query.getOrDefault("quotaUser")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "quotaUser", valid_593986
  var valid_593987 = query.getOrDefault("alt")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = newJString("json"))
  if valid_593987 != nil:
    section.add "alt", valid_593987
  var valid_593988 = query.getOrDefault("oauth_token")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "oauth_token", valid_593988
  var valid_593989 = query.getOrDefault("callback")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "callback", valid_593989
  var valid_593990 = query.getOrDefault("access_token")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "access_token", valid_593990
  var valid_593991 = query.getOrDefault("uploadType")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "uploadType", valid_593991
  var valid_593992 = query.getOrDefault("key")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "key", valid_593992
  var valid_593993 = query.getOrDefault("$.xgafv")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = newJString("1"))
  if valid_593993 != nil:
    section.add "$.xgafv", valid_593993
  var valid_593994 = query.getOrDefault("prettyPrint")
  valid_593994 = validateParameter(valid_593994, JBool, required = false,
                                 default = newJBool(true))
  if valid_593994 != nil:
    section.add "prettyPrint", valid_593994
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

proc call*(call_593996: Call_FirestoreProjectsDatabasesDocumentsBeginTransaction_593980;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts a new transaction.
  ## 
  let valid = call_593996.validator(path, query, header, formData, body)
  let scheme = call_593996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593996.url(scheme.get, call_593996.host, call_593996.base,
                         call_593996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593996, url, valid)

proc call*(call_593997: Call_FirestoreProjectsDatabasesDocumentsBeginTransaction_593980;
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
  var path_593998 = newJObject()
  var query_593999 = newJObject()
  var body_594000 = newJObject()
  add(query_593999, "upload_protocol", newJString(uploadProtocol))
  add(query_593999, "fields", newJString(fields))
  add(query_593999, "quotaUser", newJString(quotaUser))
  add(query_593999, "alt", newJString(alt))
  add(query_593999, "oauth_token", newJString(oauthToken))
  add(query_593999, "callback", newJString(callback))
  add(query_593999, "access_token", newJString(accessToken))
  add(query_593999, "uploadType", newJString(uploadType))
  add(query_593999, "key", newJString(key))
  add(path_593998, "database", newJString(database))
  add(query_593999, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594000 = body
  add(query_593999, "prettyPrint", newJBool(prettyPrint))
  result = call_593997.call(path_593998, query_593999, nil, nil, body_594000)

var firestoreProjectsDatabasesDocumentsBeginTransaction* = Call_FirestoreProjectsDatabasesDocumentsBeginTransaction_593980(
    name: "firestoreProjectsDatabasesDocumentsBeginTransaction",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1beta1/{database}/documents:beginTransaction",
    validator: validate_FirestoreProjectsDatabasesDocumentsBeginTransaction_593981,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsBeginTransaction_593982,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsCommit_594001 = ref object of OpenApiRestCall_593421
proc url_FirestoreProjectsDatabasesDocumentsCommit_594003(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FirestoreProjectsDatabasesDocumentsCommit_594002(path: JsonNode;
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
  var valid_594004 = path.getOrDefault("database")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "database", valid_594004
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
  var valid_594005 = query.getOrDefault("upload_protocol")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "upload_protocol", valid_594005
  var valid_594006 = query.getOrDefault("fields")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "fields", valid_594006
  var valid_594007 = query.getOrDefault("quotaUser")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "quotaUser", valid_594007
  var valid_594008 = query.getOrDefault("alt")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = newJString("json"))
  if valid_594008 != nil:
    section.add "alt", valid_594008
  var valid_594009 = query.getOrDefault("oauth_token")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "oauth_token", valid_594009
  var valid_594010 = query.getOrDefault("callback")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "callback", valid_594010
  var valid_594011 = query.getOrDefault("access_token")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "access_token", valid_594011
  var valid_594012 = query.getOrDefault("uploadType")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "uploadType", valid_594012
  var valid_594013 = query.getOrDefault("key")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "key", valid_594013
  var valid_594014 = query.getOrDefault("$.xgafv")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = newJString("1"))
  if valid_594014 != nil:
    section.add "$.xgafv", valid_594014
  var valid_594015 = query.getOrDefault("prettyPrint")
  valid_594015 = validateParameter(valid_594015, JBool, required = false,
                                 default = newJBool(true))
  if valid_594015 != nil:
    section.add "prettyPrint", valid_594015
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

proc call*(call_594017: Call_FirestoreProjectsDatabasesDocumentsCommit_594001;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Commits a transaction, while optionally updating documents.
  ## 
  let valid = call_594017.validator(path, query, header, formData, body)
  let scheme = call_594017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594017.url(scheme.get, call_594017.host, call_594017.base,
                         call_594017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594017, url, valid)

proc call*(call_594018: Call_FirestoreProjectsDatabasesDocumentsCommit_594001;
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
  var path_594019 = newJObject()
  var query_594020 = newJObject()
  var body_594021 = newJObject()
  add(query_594020, "upload_protocol", newJString(uploadProtocol))
  add(query_594020, "fields", newJString(fields))
  add(query_594020, "quotaUser", newJString(quotaUser))
  add(query_594020, "alt", newJString(alt))
  add(query_594020, "oauth_token", newJString(oauthToken))
  add(query_594020, "callback", newJString(callback))
  add(query_594020, "access_token", newJString(accessToken))
  add(query_594020, "uploadType", newJString(uploadType))
  add(query_594020, "key", newJString(key))
  add(path_594019, "database", newJString(database))
  add(query_594020, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594021 = body
  add(query_594020, "prettyPrint", newJBool(prettyPrint))
  result = call_594018.call(path_594019, query_594020, nil, nil, body_594021)

var firestoreProjectsDatabasesDocumentsCommit* = Call_FirestoreProjectsDatabasesDocumentsCommit_594001(
    name: "firestoreProjectsDatabasesDocumentsCommit", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com",
    route: "/v1beta1/{database}/documents:commit",
    validator: validate_FirestoreProjectsDatabasesDocumentsCommit_594002,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsCommit_594003,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsListen_594022 = ref object of OpenApiRestCall_593421
proc url_FirestoreProjectsDatabasesDocumentsListen_594024(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FirestoreProjectsDatabasesDocumentsListen_594023(path: JsonNode;
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
  var valid_594025 = path.getOrDefault("database")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "database", valid_594025
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
  var valid_594026 = query.getOrDefault("upload_protocol")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "upload_protocol", valid_594026
  var valid_594027 = query.getOrDefault("fields")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "fields", valid_594027
  var valid_594028 = query.getOrDefault("quotaUser")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "quotaUser", valid_594028
  var valid_594029 = query.getOrDefault("alt")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = newJString("json"))
  if valid_594029 != nil:
    section.add "alt", valid_594029
  var valid_594030 = query.getOrDefault("oauth_token")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "oauth_token", valid_594030
  var valid_594031 = query.getOrDefault("callback")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "callback", valid_594031
  var valid_594032 = query.getOrDefault("access_token")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "access_token", valid_594032
  var valid_594033 = query.getOrDefault("uploadType")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "uploadType", valid_594033
  var valid_594034 = query.getOrDefault("key")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "key", valid_594034
  var valid_594035 = query.getOrDefault("$.xgafv")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = newJString("1"))
  if valid_594035 != nil:
    section.add "$.xgafv", valid_594035
  var valid_594036 = query.getOrDefault("prettyPrint")
  valid_594036 = validateParameter(valid_594036, JBool, required = false,
                                 default = newJBool(true))
  if valid_594036 != nil:
    section.add "prettyPrint", valid_594036
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

proc call*(call_594038: Call_FirestoreProjectsDatabasesDocumentsListen_594022;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Listens to changes.
  ## 
  let valid = call_594038.validator(path, query, header, formData, body)
  let scheme = call_594038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594038.url(scheme.get, call_594038.host, call_594038.base,
                         call_594038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594038, url, valid)

proc call*(call_594039: Call_FirestoreProjectsDatabasesDocumentsListen_594022;
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
  var path_594040 = newJObject()
  var query_594041 = newJObject()
  var body_594042 = newJObject()
  add(query_594041, "upload_protocol", newJString(uploadProtocol))
  add(query_594041, "fields", newJString(fields))
  add(query_594041, "quotaUser", newJString(quotaUser))
  add(query_594041, "alt", newJString(alt))
  add(query_594041, "oauth_token", newJString(oauthToken))
  add(query_594041, "callback", newJString(callback))
  add(query_594041, "access_token", newJString(accessToken))
  add(query_594041, "uploadType", newJString(uploadType))
  add(query_594041, "key", newJString(key))
  add(path_594040, "database", newJString(database))
  add(query_594041, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594042 = body
  add(query_594041, "prettyPrint", newJBool(prettyPrint))
  result = call_594039.call(path_594040, query_594041, nil, nil, body_594042)

var firestoreProjectsDatabasesDocumentsListen* = Call_FirestoreProjectsDatabasesDocumentsListen_594022(
    name: "firestoreProjectsDatabasesDocumentsListen", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com",
    route: "/v1beta1/{database}/documents:listen",
    validator: validate_FirestoreProjectsDatabasesDocumentsListen_594023,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsListen_594024,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsRollback_594043 = ref object of OpenApiRestCall_593421
proc url_FirestoreProjectsDatabasesDocumentsRollback_594045(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FirestoreProjectsDatabasesDocumentsRollback_594044(path: JsonNode;
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
  var valid_594046 = path.getOrDefault("database")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "database", valid_594046
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
  var valid_594047 = query.getOrDefault("upload_protocol")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = nil)
  if valid_594047 != nil:
    section.add "upload_protocol", valid_594047
  var valid_594048 = query.getOrDefault("fields")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "fields", valid_594048
  var valid_594049 = query.getOrDefault("quotaUser")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = nil)
  if valid_594049 != nil:
    section.add "quotaUser", valid_594049
  var valid_594050 = query.getOrDefault("alt")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = newJString("json"))
  if valid_594050 != nil:
    section.add "alt", valid_594050
  var valid_594051 = query.getOrDefault("oauth_token")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "oauth_token", valid_594051
  var valid_594052 = query.getOrDefault("callback")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "callback", valid_594052
  var valid_594053 = query.getOrDefault("access_token")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = nil)
  if valid_594053 != nil:
    section.add "access_token", valid_594053
  var valid_594054 = query.getOrDefault("uploadType")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "uploadType", valid_594054
  var valid_594055 = query.getOrDefault("key")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "key", valid_594055
  var valid_594056 = query.getOrDefault("$.xgafv")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = newJString("1"))
  if valid_594056 != nil:
    section.add "$.xgafv", valid_594056
  var valid_594057 = query.getOrDefault("prettyPrint")
  valid_594057 = validateParameter(valid_594057, JBool, required = false,
                                 default = newJBool(true))
  if valid_594057 != nil:
    section.add "prettyPrint", valid_594057
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

proc call*(call_594059: Call_FirestoreProjectsDatabasesDocumentsRollback_594043;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rolls back a transaction.
  ## 
  let valid = call_594059.validator(path, query, header, formData, body)
  let scheme = call_594059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594059.url(scheme.get, call_594059.host, call_594059.base,
                         call_594059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594059, url, valid)

proc call*(call_594060: Call_FirestoreProjectsDatabasesDocumentsRollback_594043;
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
  var path_594061 = newJObject()
  var query_594062 = newJObject()
  var body_594063 = newJObject()
  add(query_594062, "upload_protocol", newJString(uploadProtocol))
  add(query_594062, "fields", newJString(fields))
  add(query_594062, "quotaUser", newJString(quotaUser))
  add(query_594062, "alt", newJString(alt))
  add(query_594062, "oauth_token", newJString(oauthToken))
  add(query_594062, "callback", newJString(callback))
  add(query_594062, "access_token", newJString(accessToken))
  add(query_594062, "uploadType", newJString(uploadType))
  add(query_594062, "key", newJString(key))
  add(path_594061, "database", newJString(database))
  add(query_594062, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594063 = body
  add(query_594062, "prettyPrint", newJBool(prettyPrint))
  result = call_594060.call(path_594061, query_594062, nil, nil, body_594063)

var firestoreProjectsDatabasesDocumentsRollback* = Call_FirestoreProjectsDatabasesDocumentsRollback_594043(
    name: "firestoreProjectsDatabasesDocumentsRollback",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1beta1/{database}/documents:rollback",
    validator: validate_FirestoreProjectsDatabasesDocumentsRollback_594044,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsRollback_594045,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsWrite_594064 = ref object of OpenApiRestCall_593421
proc url_FirestoreProjectsDatabasesDocumentsWrite_594066(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FirestoreProjectsDatabasesDocumentsWrite_594065(path: JsonNode;
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
  var valid_594067 = path.getOrDefault("database")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "database", valid_594067
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
  var valid_594068 = query.getOrDefault("upload_protocol")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = nil)
  if valid_594068 != nil:
    section.add "upload_protocol", valid_594068
  var valid_594069 = query.getOrDefault("fields")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "fields", valid_594069
  var valid_594070 = query.getOrDefault("quotaUser")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "quotaUser", valid_594070
  var valid_594071 = query.getOrDefault("alt")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = newJString("json"))
  if valid_594071 != nil:
    section.add "alt", valid_594071
  var valid_594072 = query.getOrDefault("oauth_token")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = nil)
  if valid_594072 != nil:
    section.add "oauth_token", valid_594072
  var valid_594073 = query.getOrDefault("callback")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "callback", valid_594073
  var valid_594074 = query.getOrDefault("access_token")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = nil)
  if valid_594074 != nil:
    section.add "access_token", valid_594074
  var valid_594075 = query.getOrDefault("uploadType")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = nil)
  if valid_594075 != nil:
    section.add "uploadType", valid_594075
  var valid_594076 = query.getOrDefault("key")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = nil)
  if valid_594076 != nil:
    section.add "key", valid_594076
  var valid_594077 = query.getOrDefault("$.xgafv")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = newJString("1"))
  if valid_594077 != nil:
    section.add "$.xgafv", valid_594077
  var valid_594078 = query.getOrDefault("prettyPrint")
  valid_594078 = validateParameter(valid_594078, JBool, required = false,
                                 default = newJBool(true))
  if valid_594078 != nil:
    section.add "prettyPrint", valid_594078
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

proc call*(call_594080: Call_FirestoreProjectsDatabasesDocumentsWrite_594064;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Streams batches of document updates and deletes, in order.
  ## 
  let valid = call_594080.validator(path, query, header, formData, body)
  let scheme = call_594080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594080.url(scheme.get, call_594080.host, call_594080.base,
                         call_594080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594080, url, valid)

proc call*(call_594081: Call_FirestoreProjectsDatabasesDocumentsWrite_594064;
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
  var path_594082 = newJObject()
  var query_594083 = newJObject()
  var body_594084 = newJObject()
  add(query_594083, "upload_protocol", newJString(uploadProtocol))
  add(query_594083, "fields", newJString(fields))
  add(query_594083, "quotaUser", newJString(quotaUser))
  add(query_594083, "alt", newJString(alt))
  add(query_594083, "oauth_token", newJString(oauthToken))
  add(query_594083, "callback", newJString(callback))
  add(query_594083, "access_token", newJString(accessToken))
  add(query_594083, "uploadType", newJString(uploadType))
  add(query_594083, "key", newJString(key))
  add(path_594082, "database", newJString(database))
  add(query_594083, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594084 = body
  add(query_594083, "prettyPrint", newJBool(prettyPrint))
  result = call_594081.call(path_594082, query_594083, nil, nil, body_594084)

var firestoreProjectsDatabasesDocumentsWrite* = Call_FirestoreProjectsDatabasesDocumentsWrite_594064(
    name: "firestoreProjectsDatabasesDocumentsWrite", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com",
    route: "/v1beta1/{database}/documents:write",
    validator: validate_FirestoreProjectsDatabasesDocumentsWrite_594065,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsWrite_594066,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsGet_594085 = ref object of OpenApiRestCall_593421
proc url_FirestoreProjectsDatabasesDocumentsGet_594087(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesDocumentsGet_594086(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a single document.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the Document to get. In the format:
  ## `projects/{project_id}/databases/{database_id}/documents/{document_path}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594088 = path.getOrDefault("name")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "name", valid_594088
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
  var valid_594089 = query.getOrDefault("upload_protocol")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = nil)
  if valid_594089 != nil:
    section.add "upload_protocol", valid_594089
  var valid_594090 = query.getOrDefault("fields")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "fields", valid_594090
  var valid_594091 = query.getOrDefault("quotaUser")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "quotaUser", valid_594091
  var valid_594092 = query.getOrDefault("alt")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = newJString("json"))
  if valid_594092 != nil:
    section.add "alt", valid_594092
  var valid_594093 = query.getOrDefault("readTime")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "readTime", valid_594093
  var valid_594094 = query.getOrDefault("oauth_token")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "oauth_token", valid_594094
  var valid_594095 = query.getOrDefault("callback")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "callback", valid_594095
  var valid_594096 = query.getOrDefault("access_token")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = nil)
  if valid_594096 != nil:
    section.add "access_token", valid_594096
  var valid_594097 = query.getOrDefault("uploadType")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "uploadType", valid_594097
  var valid_594098 = query.getOrDefault("transaction")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "transaction", valid_594098
  var valid_594099 = query.getOrDefault("key")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "key", valid_594099
  var valid_594100 = query.getOrDefault("$.xgafv")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = newJString("1"))
  if valid_594100 != nil:
    section.add "$.xgafv", valid_594100
  var valid_594101 = query.getOrDefault("mask.fieldPaths")
  valid_594101 = validateParameter(valid_594101, JArray, required = false,
                                 default = nil)
  if valid_594101 != nil:
    section.add "mask.fieldPaths", valid_594101
  var valid_594102 = query.getOrDefault("prettyPrint")
  valid_594102 = validateParameter(valid_594102, JBool, required = false,
                                 default = newJBool(true))
  if valid_594102 != nil:
    section.add "prettyPrint", valid_594102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594103: Call_FirestoreProjectsDatabasesDocumentsGet_594085;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a single document.
  ## 
  let valid = call_594103.validator(path, query, header, formData, body)
  let scheme = call_594103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594103.url(scheme.get, call_594103.host, call_594103.base,
                         call_594103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594103, url, valid)

proc call*(call_594104: Call_FirestoreProjectsDatabasesDocumentsGet_594085;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; readTime: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; transaction: string = ""; key: string = "";
          Xgafv: string = "1"; maskFieldPaths: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## firestoreProjectsDatabasesDocumentsGet
  ## Gets a single document.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the Document to get. In the format:
  ## `projects/{project_id}/databases/{database_id}/documents/{document_path}`.
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
  var path_594105 = newJObject()
  var query_594106 = newJObject()
  add(query_594106, "upload_protocol", newJString(uploadProtocol))
  add(query_594106, "fields", newJString(fields))
  add(query_594106, "quotaUser", newJString(quotaUser))
  add(path_594105, "name", newJString(name))
  add(query_594106, "alt", newJString(alt))
  add(query_594106, "readTime", newJString(readTime))
  add(query_594106, "oauth_token", newJString(oauthToken))
  add(query_594106, "callback", newJString(callback))
  add(query_594106, "access_token", newJString(accessToken))
  add(query_594106, "uploadType", newJString(uploadType))
  add(query_594106, "transaction", newJString(transaction))
  add(query_594106, "key", newJString(key))
  add(query_594106, "$.xgafv", newJString(Xgafv))
  if maskFieldPaths != nil:
    query_594106.add "mask.fieldPaths", maskFieldPaths
  add(query_594106, "prettyPrint", newJBool(prettyPrint))
  result = call_594104.call(path_594105, query_594106, nil, nil, nil)

var firestoreProjectsDatabasesDocumentsGet* = Call_FirestoreProjectsDatabasesDocumentsGet_594085(
    name: "firestoreProjectsDatabasesDocumentsGet", meth: HttpMethod.HttpGet,
    host: "firestore.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_FirestoreProjectsDatabasesDocumentsGet_594086, base: "/",
    url: url_FirestoreProjectsDatabasesDocumentsGet_594087,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsPatch_594128 = ref object of OpenApiRestCall_593421
proc url_FirestoreProjectsDatabasesDocumentsPatch_594130(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesDocumentsPatch_594129(path: JsonNode;
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
  var valid_594131 = path.getOrDefault("name")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "name", valid_594131
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
  var valid_594132 = query.getOrDefault("upload_protocol")
  valid_594132 = validateParameter(valid_594132, JString, required = false,
                                 default = nil)
  if valid_594132 != nil:
    section.add "upload_protocol", valid_594132
  var valid_594133 = query.getOrDefault("fields")
  valid_594133 = validateParameter(valid_594133, JString, required = false,
                                 default = nil)
  if valid_594133 != nil:
    section.add "fields", valid_594133
  var valid_594134 = query.getOrDefault("quotaUser")
  valid_594134 = validateParameter(valid_594134, JString, required = false,
                                 default = nil)
  if valid_594134 != nil:
    section.add "quotaUser", valid_594134
  var valid_594135 = query.getOrDefault("alt")
  valid_594135 = validateParameter(valid_594135, JString, required = false,
                                 default = newJString("json"))
  if valid_594135 != nil:
    section.add "alt", valid_594135
  var valid_594136 = query.getOrDefault("currentDocument.updateTime")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = nil)
  if valid_594136 != nil:
    section.add "currentDocument.updateTime", valid_594136
  var valid_594137 = query.getOrDefault("oauth_token")
  valid_594137 = validateParameter(valid_594137, JString, required = false,
                                 default = nil)
  if valid_594137 != nil:
    section.add "oauth_token", valid_594137
  var valid_594138 = query.getOrDefault("callback")
  valid_594138 = validateParameter(valid_594138, JString, required = false,
                                 default = nil)
  if valid_594138 != nil:
    section.add "callback", valid_594138
  var valid_594139 = query.getOrDefault("access_token")
  valid_594139 = validateParameter(valid_594139, JString, required = false,
                                 default = nil)
  if valid_594139 != nil:
    section.add "access_token", valid_594139
  var valid_594140 = query.getOrDefault("uploadType")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = nil)
  if valid_594140 != nil:
    section.add "uploadType", valid_594140
  var valid_594141 = query.getOrDefault("updateMask.fieldPaths")
  valid_594141 = validateParameter(valid_594141, JArray, required = false,
                                 default = nil)
  if valid_594141 != nil:
    section.add "updateMask.fieldPaths", valid_594141
  var valid_594142 = query.getOrDefault("key")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = nil)
  if valid_594142 != nil:
    section.add "key", valid_594142
  var valid_594143 = query.getOrDefault("currentDocument.exists")
  valid_594143 = validateParameter(valid_594143, JBool, required = false, default = nil)
  if valid_594143 != nil:
    section.add "currentDocument.exists", valid_594143
  var valid_594144 = query.getOrDefault("$.xgafv")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = newJString("1"))
  if valid_594144 != nil:
    section.add "$.xgafv", valid_594144
  var valid_594145 = query.getOrDefault("prettyPrint")
  valid_594145 = validateParameter(valid_594145, JBool, required = false,
                                 default = newJBool(true))
  if valid_594145 != nil:
    section.add "prettyPrint", valid_594145
  var valid_594146 = query.getOrDefault("mask.fieldPaths")
  valid_594146 = validateParameter(valid_594146, JArray, required = false,
                                 default = nil)
  if valid_594146 != nil:
    section.add "mask.fieldPaths", valid_594146
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

proc call*(call_594148: Call_FirestoreProjectsDatabasesDocumentsPatch_594128;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates or inserts a document.
  ## 
  let valid = call_594148.validator(path, query, header, formData, body)
  let scheme = call_594148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594148.url(scheme.get, call_594148.host, call_594148.base,
                         call_594148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594148, url, valid)

proc call*(call_594149: Call_FirestoreProjectsDatabasesDocumentsPatch_594128;
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
  var path_594150 = newJObject()
  var query_594151 = newJObject()
  var body_594152 = newJObject()
  add(query_594151, "upload_protocol", newJString(uploadProtocol))
  add(query_594151, "fields", newJString(fields))
  add(query_594151, "quotaUser", newJString(quotaUser))
  add(path_594150, "name", newJString(name))
  add(query_594151, "alt", newJString(alt))
  add(query_594151, "currentDocument.updateTime",
      newJString(currentDocumentUpdateTime))
  add(query_594151, "oauth_token", newJString(oauthToken))
  add(query_594151, "callback", newJString(callback))
  add(query_594151, "access_token", newJString(accessToken))
  add(query_594151, "uploadType", newJString(uploadType))
  if updateMaskFieldPaths != nil:
    query_594151.add "updateMask.fieldPaths", updateMaskFieldPaths
  add(query_594151, "key", newJString(key))
  add(query_594151, "currentDocument.exists", newJBool(currentDocumentExists))
  add(query_594151, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594152 = body
  add(query_594151, "prettyPrint", newJBool(prettyPrint))
  if maskFieldPaths != nil:
    query_594151.add "mask.fieldPaths", maskFieldPaths
  result = call_594149.call(path_594150, query_594151, nil, nil, body_594152)

var firestoreProjectsDatabasesDocumentsPatch* = Call_FirestoreProjectsDatabasesDocumentsPatch_594128(
    name: "firestoreProjectsDatabasesDocumentsPatch", meth: HttpMethod.HttpPatch,
    host: "firestore.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_FirestoreProjectsDatabasesDocumentsPatch_594129,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsPatch_594130,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsDelete_594107 = ref object of OpenApiRestCall_593421
proc url_FirestoreProjectsDatabasesDocumentsDelete_594109(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirestoreProjectsDatabasesDocumentsDelete_594108(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a document.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the Document to delete. In the format:
  ## `projects/{project_id}/databases/{database_id}/documents/{document_path}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594110 = path.getOrDefault("name")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "name", valid_594110
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
  var valid_594111 = query.getOrDefault("upload_protocol")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = nil)
  if valid_594111 != nil:
    section.add "upload_protocol", valid_594111
  var valid_594112 = query.getOrDefault("fields")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = nil)
  if valid_594112 != nil:
    section.add "fields", valid_594112
  var valid_594113 = query.getOrDefault("quotaUser")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = nil)
  if valid_594113 != nil:
    section.add "quotaUser", valid_594113
  var valid_594114 = query.getOrDefault("alt")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = newJString("json"))
  if valid_594114 != nil:
    section.add "alt", valid_594114
  var valid_594115 = query.getOrDefault("currentDocument.updateTime")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = nil)
  if valid_594115 != nil:
    section.add "currentDocument.updateTime", valid_594115
  var valid_594116 = query.getOrDefault("oauth_token")
  valid_594116 = validateParameter(valid_594116, JString, required = false,
                                 default = nil)
  if valid_594116 != nil:
    section.add "oauth_token", valid_594116
  var valid_594117 = query.getOrDefault("callback")
  valid_594117 = validateParameter(valid_594117, JString, required = false,
                                 default = nil)
  if valid_594117 != nil:
    section.add "callback", valid_594117
  var valid_594118 = query.getOrDefault("access_token")
  valid_594118 = validateParameter(valid_594118, JString, required = false,
                                 default = nil)
  if valid_594118 != nil:
    section.add "access_token", valid_594118
  var valid_594119 = query.getOrDefault("uploadType")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "uploadType", valid_594119
  var valid_594120 = query.getOrDefault("key")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = nil)
  if valid_594120 != nil:
    section.add "key", valid_594120
  var valid_594121 = query.getOrDefault("currentDocument.exists")
  valid_594121 = validateParameter(valid_594121, JBool, required = false, default = nil)
  if valid_594121 != nil:
    section.add "currentDocument.exists", valid_594121
  var valid_594122 = query.getOrDefault("$.xgafv")
  valid_594122 = validateParameter(valid_594122, JString, required = false,
                                 default = newJString("1"))
  if valid_594122 != nil:
    section.add "$.xgafv", valid_594122
  var valid_594123 = query.getOrDefault("prettyPrint")
  valid_594123 = validateParameter(valid_594123, JBool, required = false,
                                 default = newJBool(true))
  if valid_594123 != nil:
    section.add "prettyPrint", valid_594123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594124: Call_FirestoreProjectsDatabasesDocumentsDelete_594107;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a document.
  ## 
  let valid = call_594124.validator(path, query, header, formData, body)
  let scheme = call_594124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594124.url(scheme.get, call_594124.host, call_594124.base,
                         call_594124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594124, url, valid)

proc call*(call_594125: Call_FirestoreProjectsDatabasesDocumentsDelete_594107;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json";
          currentDocumentUpdateTime: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; currentDocumentExists: bool = false; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## firestoreProjectsDatabasesDocumentsDelete
  ## Deletes a document.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the Document to delete. In the format:
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   currentDocumentExists: bool
  ##                        : When set to `true`, the target document must exist.
  ## When set to `false`, the target document must not exist.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594126 = newJObject()
  var query_594127 = newJObject()
  add(query_594127, "upload_protocol", newJString(uploadProtocol))
  add(query_594127, "fields", newJString(fields))
  add(query_594127, "quotaUser", newJString(quotaUser))
  add(path_594126, "name", newJString(name))
  add(query_594127, "alt", newJString(alt))
  add(query_594127, "currentDocument.updateTime",
      newJString(currentDocumentUpdateTime))
  add(query_594127, "oauth_token", newJString(oauthToken))
  add(query_594127, "callback", newJString(callback))
  add(query_594127, "access_token", newJString(accessToken))
  add(query_594127, "uploadType", newJString(uploadType))
  add(query_594127, "key", newJString(key))
  add(query_594127, "currentDocument.exists", newJBool(currentDocumentExists))
  add(query_594127, "$.xgafv", newJString(Xgafv))
  add(query_594127, "prettyPrint", newJBool(prettyPrint))
  result = call_594125.call(path_594126, query_594127, nil, nil, nil)

var firestoreProjectsDatabasesDocumentsDelete* = Call_FirestoreProjectsDatabasesDocumentsDelete_594107(
    name: "firestoreProjectsDatabasesDocumentsDelete",
    meth: HttpMethod.HttpDelete, host: "firestore.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_FirestoreProjectsDatabasesDocumentsDelete_594108,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsDelete_594109,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesExportDocuments_594153 = ref object of OpenApiRestCall_593421
proc url_FirestoreProjectsDatabasesExportDocuments_594155(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FirestoreProjectsDatabasesExportDocuments_594154(path: JsonNode;
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
  var valid_594156 = path.getOrDefault("name")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "name", valid_594156
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
  var valid_594157 = query.getOrDefault("upload_protocol")
  valid_594157 = validateParameter(valid_594157, JString, required = false,
                                 default = nil)
  if valid_594157 != nil:
    section.add "upload_protocol", valid_594157
  var valid_594158 = query.getOrDefault("fields")
  valid_594158 = validateParameter(valid_594158, JString, required = false,
                                 default = nil)
  if valid_594158 != nil:
    section.add "fields", valid_594158
  var valid_594159 = query.getOrDefault("quotaUser")
  valid_594159 = validateParameter(valid_594159, JString, required = false,
                                 default = nil)
  if valid_594159 != nil:
    section.add "quotaUser", valid_594159
  var valid_594160 = query.getOrDefault("alt")
  valid_594160 = validateParameter(valid_594160, JString, required = false,
                                 default = newJString("json"))
  if valid_594160 != nil:
    section.add "alt", valid_594160
  var valid_594161 = query.getOrDefault("oauth_token")
  valid_594161 = validateParameter(valid_594161, JString, required = false,
                                 default = nil)
  if valid_594161 != nil:
    section.add "oauth_token", valid_594161
  var valid_594162 = query.getOrDefault("callback")
  valid_594162 = validateParameter(valid_594162, JString, required = false,
                                 default = nil)
  if valid_594162 != nil:
    section.add "callback", valid_594162
  var valid_594163 = query.getOrDefault("access_token")
  valid_594163 = validateParameter(valid_594163, JString, required = false,
                                 default = nil)
  if valid_594163 != nil:
    section.add "access_token", valid_594163
  var valid_594164 = query.getOrDefault("uploadType")
  valid_594164 = validateParameter(valid_594164, JString, required = false,
                                 default = nil)
  if valid_594164 != nil:
    section.add "uploadType", valid_594164
  var valid_594165 = query.getOrDefault("key")
  valid_594165 = validateParameter(valid_594165, JString, required = false,
                                 default = nil)
  if valid_594165 != nil:
    section.add "key", valid_594165
  var valid_594166 = query.getOrDefault("$.xgafv")
  valid_594166 = validateParameter(valid_594166, JString, required = false,
                                 default = newJString("1"))
  if valid_594166 != nil:
    section.add "$.xgafv", valid_594166
  var valid_594167 = query.getOrDefault("prettyPrint")
  valid_594167 = validateParameter(valid_594167, JBool, required = false,
                                 default = newJBool(true))
  if valid_594167 != nil:
    section.add "prettyPrint", valid_594167
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

proc call*(call_594169: Call_FirestoreProjectsDatabasesExportDocuments_594153;
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
  let valid = call_594169.validator(path, query, header, formData, body)
  let scheme = call_594169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594169.url(scheme.get, call_594169.host, call_594169.base,
                         call_594169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594169, url, valid)

proc call*(call_594170: Call_FirestoreProjectsDatabasesExportDocuments_594153;
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
  var path_594171 = newJObject()
  var query_594172 = newJObject()
  var body_594173 = newJObject()
  add(query_594172, "upload_protocol", newJString(uploadProtocol))
  add(query_594172, "fields", newJString(fields))
  add(query_594172, "quotaUser", newJString(quotaUser))
  add(path_594171, "name", newJString(name))
  add(query_594172, "alt", newJString(alt))
  add(query_594172, "oauth_token", newJString(oauthToken))
  add(query_594172, "callback", newJString(callback))
  add(query_594172, "access_token", newJString(accessToken))
  add(query_594172, "uploadType", newJString(uploadType))
  add(query_594172, "key", newJString(key))
  add(query_594172, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594173 = body
  add(query_594172, "prettyPrint", newJBool(prettyPrint))
  result = call_594170.call(path_594171, query_594172, nil, nil, body_594173)

var firestoreProjectsDatabasesExportDocuments* = Call_FirestoreProjectsDatabasesExportDocuments_594153(
    name: "firestoreProjectsDatabasesExportDocuments", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com", route: "/v1beta1/{name}:exportDocuments",
    validator: validate_FirestoreProjectsDatabasesExportDocuments_594154,
    base: "/", url: url_FirestoreProjectsDatabasesExportDocuments_594155,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesImportDocuments_594174 = ref object of OpenApiRestCall_593421
proc url_FirestoreProjectsDatabasesImportDocuments_594176(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FirestoreProjectsDatabasesImportDocuments_594175(path: JsonNode;
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
  var valid_594177 = path.getOrDefault("name")
  valid_594177 = validateParameter(valid_594177, JString, required = true,
                                 default = nil)
  if valid_594177 != nil:
    section.add "name", valid_594177
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
  var valid_594178 = query.getOrDefault("upload_protocol")
  valid_594178 = validateParameter(valid_594178, JString, required = false,
                                 default = nil)
  if valid_594178 != nil:
    section.add "upload_protocol", valid_594178
  var valid_594179 = query.getOrDefault("fields")
  valid_594179 = validateParameter(valid_594179, JString, required = false,
                                 default = nil)
  if valid_594179 != nil:
    section.add "fields", valid_594179
  var valid_594180 = query.getOrDefault("quotaUser")
  valid_594180 = validateParameter(valid_594180, JString, required = false,
                                 default = nil)
  if valid_594180 != nil:
    section.add "quotaUser", valid_594180
  var valid_594181 = query.getOrDefault("alt")
  valid_594181 = validateParameter(valid_594181, JString, required = false,
                                 default = newJString("json"))
  if valid_594181 != nil:
    section.add "alt", valid_594181
  var valid_594182 = query.getOrDefault("oauth_token")
  valid_594182 = validateParameter(valid_594182, JString, required = false,
                                 default = nil)
  if valid_594182 != nil:
    section.add "oauth_token", valid_594182
  var valid_594183 = query.getOrDefault("callback")
  valid_594183 = validateParameter(valid_594183, JString, required = false,
                                 default = nil)
  if valid_594183 != nil:
    section.add "callback", valid_594183
  var valid_594184 = query.getOrDefault("access_token")
  valid_594184 = validateParameter(valid_594184, JString, required = false,
                                 default = nil)
  if valid_594184 != nil:
    section.add "access_token", valid_594184
  var valid_594185 = query.getOrDefault("uploadType")
  valid_594185 = validateParameter(valid_594185, JString, required = false,
                                 default = nil)
  if valid_594185 != nil:
    section.add "uploadType", valid_594185
  var valid_594186 = query.getOrDefault("key")
  valid_594186 = validateParameter(valid_594186, JString, required = false,
                                 default = nil)
  if valid_594186 != nil:
    section.add "key", valid_594186
  var valid_594187 = query.getOrDefault("$.xgafv")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = newJString("1"))
  if valid_594187 != nil:
    section.add "$.xgafv", valid_594187
  var valid_594188 = query.getOrDefault("prettyPrint")
  valid_594188 = validateParameter(valid_594188, JBool, required = false,
                                 default = newJBool(true))
  if valid_594188 != nil:
    section.add "prettyPrint", valid_594188
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

proc call*(call_594190: Call_FirestoreProjectsDatabasesImportDocuments_594174;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Imports documents into Google Cloud Firestore. Existing documents with the
  ## same name are overwritten. The import occurs in the background and its
  ## progress can be monitored and managed via the Operation resource that is
  ## created. If an ImportDocuments operation is cancelled, it is possible
  ## that a subset of the data has already been imported to Cloud Firestore.
  ## 
  let valid = call_594190.validator(path, query, header, formData, body)
  let scheme = call_594190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594190.url(scheme.get, call_594190.host, call_594190.base,
                         call_594190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594190, url, valid)

proc call*(call_594191: Call_FirestoreProjectsDatabasesImportDocuments_594174;
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
  var path_594192 = newJObject()
  var query_594193 = newJObject()
  var body_594194 = newJObject()
  add(query_594193, "upload_protocol", newJString(uploadProtocol))
  add(query_594193, "fields", newJString(fields))
  add(query_594193, "quotaUser", newJString(quotaUser))
  add(path_594192, "name", newJString(name))
  add(query_594193, "alt", newJString(alt))
  add(query_594193, "oauth_token", newJString(oauthToken))
  add(query_594193, "callback", newJString(callback))
  add(query_594193, "access_token", newJString(accessToken))
  add(query_594193, "uploadType", newJString(uploadType))
  add(query_594193, "key", newJString(key))
  add(query_594193, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594194 = body
  add(query_594193, "prettyPrint", newJBool(prettyPrint))
  result = call_594191.call(path_594192, query_594193, nil, nil, body_594194)

var firestoreProjectsDatabasesImportDocuments* = Call_FirestoreProjectsDatabasesImportDocuments_594174(
    name: "firestoreProjectsDatabasesImportDocuments", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com", route: "/v1beta1/{name}:importDocuments",
    validator: validate_FirestoreProjectsDatabasesImportDocuments_594175,
    base: "/", url: url_FirestoreProjectsDatabasesImportDocuments_594176,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesIndexesCreate_594217 = ref object of OpenApiRestCall_593421
proc url_FirestoreProjectsDatabasesIndexesCreate_594219(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FirestoreProjectsDatabasesIndexesCreate_594218(path: JsonNode;
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
  var valid_594220 = path.getOrDefault("parent")
  valid_594220 = validateParameter(valid_594220, JString, required = true,
                                 default = nil)
  if valid_594220 != nil:
    section.add "parent", valid_594220
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
  var valid_594221 = query.getOrDefault("upload_protocol")
  valid_594221 = validateParameter(valid_594221, JString, required = false,
                                 default = nil)
  if valid_594221 != nil:
    section.add "upload_protocol", valid_594221
  var valid_594222 = query.getOrDefault("fields")
  valid_594222 = validateParameter(valid_594222, JString, required = false,
                                 default = nil)
  if valid_594222 != nil:
    section.add "fields", valid_594222
  var valid_594223 = query.getOrDefault("quotaUser")
  valid_594223 = validateParameter(valid_594223, JString, required = false,
                                 default = nil)
  if valid_594223 != nil:
    section.add "quotaUser", valid_594223
  var valid_594224 = query.getOrDefault("alt")
  valid_594224 = validateParameter(valid_594224, JString, required = false,
                                 default = newJString("json"))
  if valid_594224 != nil:
    section.add "alt", valid_594224
  var valid_594225 = query.getOrDefault("oauth_token")
  valid_594225 = validateParameter(valid_594225, JString, required = false,
                                 default = nil)
  if valid_594225 != nil:
    section.add "oauth_token", valid_594225
  var valid_594226 = query.getOrDefault("callback")
  valid_594226 = validateParameter(valid_594226, JString, required = false,
                                 default = nil)
  if valid_594226 != nil:
    section.add "callback", valid_594226
  var valid_594227 = query.getOrDefault("access_token")
  valid_594227 = validateParameter(valid_594227, JString, required = false,
                                 default = nil)
  if valid_594227 != nil:
    section.add "access_token", valid_594227
  var valid_594228 = query.getOrDefault("uploadType")
  valid_594228 = validateParameter(valid_594228, JString, required = false,
                                 default = nil)
  if valid_594228 != nil:
    section.add "uploadType", valid_594228
  var valid_594229 = query.getOrDefault("key")
  valid_594229 = validateParameter(valid_594229, JString, required = false,
                                 default = nil)
  if valid_594229 != nil:
    section.add "key", valid_594229
  var valid_594230 = query.getOrDefault("$.xgafv")
  valid_594230 = validateParameter(valid_594230, JString, required = false,
                                 default = newJString("1"))
  if valid_594230 != nil:
    section.add "$.xgafv", valid_594230
  var valid_594231 = query.getOrDefault("prettyPrint")
  valid_594231 = validateParameter(valid_594231, JBool, required = false,
                                 default = newJBool(true))
  if valid_594231 != nil:
    section.add "prettyPrint", valid_594231
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

proc call*(call_594233: Call_FirestoreProjectsDatabasesIndexesCreate_594217;
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
  let valid = call_594233.validator(path, query, header, formData, body)
  let scheme = call_594233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594233.url(scheme.get, call_594233.host, call_594233.base,
                         call_594233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594233, url, valid)

proc call*(call_594234: Call_FirestoreProjectsDatabasesIndexesCreate_594217;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##         : The name of the database this index will apply to. For example:
  ## `projects/{project_id}/databases/{database_id}`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594235 = newJObject()
  var query_594236 = newJObject()
  var body_594237 = newJObject()
  add(query_594236, "upload_protocol", newJString(uploadProtocol))
  add(query_594236, "fields", newJString(fields))
  add(query_594236, "quotaUser", newJString(quotaUser))
  add(query_594236, "alt", newJString(alt))
  add(query_594236, "oauth_token", newJString(oauthToken))
  add(query_594236, "callback", newJString(callback))
  add(query_594236, "access_token", newJString(accessToken))
  add(query_594236, "uploadType", newJString(uploadType))
  add(path_594235, "parent", newJString(parent))
  add(query_594236, "key", newJString(key))
  add(query_594236, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594237 = body
  add(query_594236, "prettyPrint", newJBool(prettyPrint))
  result = call_594234.call(path_594235, query_594236, nil, nil, body_594237)

var firestoreProjectsDatabasesIndexesCreate* = Call_FirestoreProjectsDatabasesIndexesCreate_594217(
    name: "firestoreProjectsDatabasesIndexesCreate", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com", route: "/v1beta1/{parent}/indexes",
    validator: validate_FirestoreProjectsDatabasesIndexesCreate_594218, base: "/",
    url: url_FirestoreProjectsDatabasesIndexesCreate_594219,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesIndexesList_594195 = ref object of OpenApiRestCall_593421
proc url_FirestoreProjectsDatabasesIndexesList_594197(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FirestoreProjectsDatabasesIndexesList_594196(path: JsonNode;
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
  var valid_594198 = path.getOrDefault("parent")
  valid_594198 = validateParameter(valid_594198, JString, required = true,
                                 default = nil)
  if valid_594198 != nil:
    section.add "parent", valid_594198
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The standard List page token.
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
  ##           : The standard List page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  section = newJObject()
  var valid_594199 = query.getOrDefault("upload_protocol")
  valid_594199 = validateParameter(valid_594199, JString, required = false,
                                 default = nil)
  if valid_594199 != nil:
    section.add "upload_protocol", valid_594199
  var valid_594200 = query.getOrDefault("fields")
  valid_594200 = validateParameter(valid_594200, JString, required = false,
                                 default = nil)
  if valid_594200 != nil:
    section.add "fields", valid_594200
  var valid_594201 = query.getOrDefault("pageToken")
  valid_594201 = validateParameter(valid_594201, JString, required = false,
                                 default = nil)
  if valid_594201 != nil:
    section.add "pageToken", valid_594201
  var valid_594202 = query.getOrDefault("quotaUser")
  valid_594202 = validateParameter(valid_594202, JString, required = false,
                                 default = nil)
  if valid_594202 != nil:
    section.add "quotaUser", valid_594202
  var valid_594203 = query.getOrDefault("alt")
  valid_594203 = validateParameter(valid_594203, JString, required = false,
                                 default = newJString("json"))
  if valid_594203 != nil:
    section.add "alt", valid_594203
  var valid_594204 = query.getOrDefault("oauth_token")
  valid_594204 = validateParameter(valid_594204, JString, required = false,
                                 default = nil)
  if valid_594204 != nil:
    section.add "oauth_token", valid_594204
  var valid_594205 = query.getOrDefault("callback")
  valid_594205 = validateParameter(valid_594205, JString, required = false,
                                 default = nil)
  if valid_594205 != nil:
    section.add "callback", valid_594205
  var valid_594206 = query.getOrDefault("access_token")
  valid_594206 = validateParameter(valid_594206, JString, required = false,
                                 default = nil)
  if valid_594206 != nil:
    section.add "access_token", valid_594206
  var valid_594207 = query.getOrDefault("uploadType")
  valid_594207 = validateParameter(valid_594207, JString, required = false,
                                 default = nil)
  if valid_594207 != nil:
    section.add "uploadType", valid_594207
  var valid_594208 = query.getOrDefault("key")
  valid_594208 = validateParameter(valid_594208, JString, required = false,
                                 default = nil)
  if valid_594208 != nil:
    section.add "key", valid_594208
  var valid_594209 = query.getOrDefault("$.xgafv")
  valid_594209 = validateParameter(valid_594209, JString, required = false,
                                 default = newJString("1"))
  if valid_594209 != nil:
    section.add "$.xgafv", valid_594209
  var valid_594210 = query.getOrDefault("pageSize")
  valid_594210 = validateParameter(valid_594210, JInt, required = false, default = nil)
  if valid_594210 != nil:
    section.add "pageSize", valid_594210
  var valid_594211 = query.getOrDefault("prettyPrint")
  valid_594211 = validateParameter(valid_594211, JBool, required = false,
                                 default = newJBool(true))
  if valid_594211 != nil:
    section.add "prettyPrint", valid_594211
  var valid_594212 = query.getOrDefault("filter")
  valid_594212 = validateParameter(valid_594212, JString, required = false,
                                 default = nil)
  if valid_594212 != nil:
    section.add "filter", valid_594212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594213: Call_FirestoreProjectsDatabasesIndexesList_594195;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the indexes that match the specified filters.
  ## 
  let valid = call_594213.validator(path, query, header, formData, body)
  let scheme = call_594213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594213.url(scheme.get, call_594213.host, call_594213.base,
                         call_594213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594213, url, valid)

proc call*(call_594214: Call_FirestoreProjectsDatabasesIndexesList_594195;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## firestoreProjectsDatabasesIndexesList
  ## Lists the indexes that match the specified filters.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard List page token.
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
  ##         : The database name. For example:
  ## `projects/{project_id}/databases/{database_id}`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard List page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  var path_594215 = newJObject()
  var query_594216 = newJObject()
  add(query_594216, "upload_protocol", newJString(uploadProtocol))
  add(query_594216, "fields", newJString(fields))
  add(query_594216, "pageToken", newJString(pageToken))
  add(query_594216, "quotaUser", newJString(quotaUser))
  add(query_594216, "alt", newJString(alt))
  add(query_594216, "oauth_token", newJString(oauthToken))
  add(query_594216, "callback", newJString(callback))
  add(query_594216, "access_token", newJString(accessToken))
  add(query_594216, "uploadType", newJString(uploadType))
  add(path_594215, "parent", newJString(parent))
  add(query_594216, "key", newJString(key))
  add(query_594216, "$.xgafv", newJString(Xgafv))
  add(query_594216, "pageSize", newJInt(pageSize))
  add(query_594216, "prettyPrint", newJBool(prettyPrint))
  add(query_594216, "filter", newJString(filter))
  result = call_594214.call(path_594215, query_594216, nil, nil, nil)

var firestoreProjectsDatabasesIndexesList* = Call_FirestoreProjectsDatabasesIndexesList_594195(
    name: "firestoreProjectsDatabasesIndexesList", meth: HttpMethod.HttpGet,
    host: "firestore.googleapis.com", route: "/v1beta1/{parent}/indexes",
    validator: validate_FirestoreProjectsDatabasesIndexesList_594196, base: "/",
    url: url_FirestoreProjectsDatabasesIndexesList_594197, schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsCreateDocument_594265 = ref object of OpenApiRestCall_593421
proc url_FirestoreProjectsDatabasesDocumentsCreateDocument_594267(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FirestoreProjectsDatabasesDocumentsCreateDocument_594266(
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
  var valid_594268 = path.getOrDefault("collectionId")
  valid_594268 = validateParameter(valid_594268, JString, required = true,
                                 default = nil)
  if valid_594268 != nil:
    section.add "collectionId", valid_594268
  var valid_594269 = path.getOrDefault("parent")
  valid_594269 = validateParameter(valid_594269, JString, required = true,
                                 default = nil)
  if valid_594269 != nil:
    section.add "parent", valid_594269
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
  var valid_594270 = query.getOrDefault("upload_protocol")
  valid_594270 = validateParameter(valid_594270, JString, required = false,
                                 default = nil)
  if valid_594270 != nil:
    section.add "upload_protocol", valid_594270
  var valid_594271 = query.getOrDefault("fields")
  valid_594271 = validateParameter(valid_594271, JString, required = false,
                                 default = nil)
  if valid_594271 != nil:
    section.add "fields", valid_594271
  var valid_594272 = query.getOrDefault("quotaUser")
  valid_594272 = validateParameter(valid_594272, JString, required = false,
                                 default = nil)
  if valid_594272 != nil:
    section.add "quotaUser", valid_594272
  var valid_594273 = query.getOrDefault("alt")
  valid_594273 = validateParameter(valid_594273, JString, required = false,
                                 default = newJString("json"))
  if valid_594273 != nil:
    section.add "alt", valid_594273
  var valid_594274 = query.getOrDefault("oauth_token")
  valid_594274 = validateParameter(valid_594274, JString, required = false,
                                 default = nil)
  if valid_594274 != nil:
    section.add "oauth_token", valid_594274
  var valid_594275 = query.getOrDefault("callback")
  valid_594275 = validateParameter(valid_594275, JString, required = false,
                                 default = nil)
  if valid_594275 != nil:
    section.add "callback", valid_594275
  var valid_594276 = query.getOrDefault("access_token")
  valid_594276 = validateParameter(valid_594276, JString, required = false,
                                 default = nil)
  if valid_594276 != nil:
    section.add "access_token", valid_594276
  var valid_594277 = query.getOrDefault("uploadType")
  valid_594277 = validateParameter(valid_594277, JString, required = false,
                                 default = nil)
  if valid_594277 != nil:
    section.add "uploadType", valid_594277
  var valid_594278 = query.getOrDefault("key")
  valid_594278 = validateParameter(valid_594278, JString, required = false,
                                 default = nil)
  if valid_594278 != nil:
    section.add "key", valid_594278
  var valid_594279 = query.getOrDefault("$.xgafv")
  valid_594279 = validateParameter(valid_594279, JString, required = false,
                                 default = newJString("1"))
  if valid_594279 != nil:
    section.add "$.xgafv", valid_594279
  var valid_594280 = query.getOrDefault("prettyPrint")
  valid_594280 = validateParameter(valid_594280, JBool, required = false,
                                 default = newJBool(true))
  if valid_594280 != nil:
    section.add "prettyPrint", valid_594280
  var valid_594281 = query.getOrDefault("mask.fieldPaths")
  valid_594281 = validateParameter(valid_594281, JArray, required = false,
                                 default = nil)
  if valid_594281 != nil:
    section.add "mask.fieldPaths", valid_594281
  var valid_594282 = query.getOrDefault("documentId")
  valid_594282 = validateParameter(valid_594282, JString, required = false,
                                 default = nil)
  if valid_594282 != nil:
    section.add "documentId", valid_594282
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

proc call*(call_594284: Call_FirestoreProjectsDatabasesDocumentsCreateDocument_594265;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new document.
  ## 
  let valid = call_594284.validator(path, query, header, formData, body)
  let scheme = call_594284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594284.url(scheme.get, call_594284.host, call_594284.base,
                         call_594284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594284, url, valid)

proc call*(call_594285: Call_FirestoreProjectsDatabasesDocumentsCreateDocument_594265;
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
  var path_594286 = newJObject()
  var query_594287 = newJObject()
  var body_594288 = newJObject()
  add(query_594287, "upload_protocol", newJString(uploadProtocol))
  add(query_594287, "fields", newJString(fields))
  add(query_594287, "quotaUser", newJString(quotaUser))
  add(query_594287, "alt", newJString(alt))
  add(path_594286, "collectionId", newJString(collectionId))
  add(query_594287, "oauth_token", newJString(oauthToken))
  add(query_594287, "callback", newJString(callback))
  add(query_594287, "access_token", newJString(accessToken))
  add(query_594287, "uploadType", newJString(uploadType))
  add(path_594286, "parent", newJString(parent))
  add(query_594287, "key", newJString(key))
  add(query_594287, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594288 = body
  add(query_594287, "prettyPrint", newJBool(prettyPrint))
  if maskFieldPaths != nil:
    query_594287.add "mask.fieldPaths", maskFieldPaths
  add(query_594287, "documentId", newJString(documentId))
  result = call_594285.call(path_594286, query_594287, nil, nil, body_594288)

var firestoreProjectsDatabasesDocumentsCreateDocument* = Call_FirestoreProjectsDatabasesDocumentsCreateDocument_594265(
    name: "firestoreProjectsDatabasesDocumentsCreateDocument",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1beta1/{parent}/{collectionId}",
    validator: validate_FirestoreProjectsDatabasesDocumentsCreateDocument_594266,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsCreateDocument_594267,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsList_594238 = ref object of OpenApiRestCall_593421
proc url_FirestoreProjectsDatabasesDocumentsList_594240(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FirestoreProjectsDatabasesDocumentsList_594239(path: JsonNode;
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
  var valid_594241 = path.getOrDefault("collectionId")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "collectionId", valid_594241
  var valid_594242 = path.getOrDefault("parent")
  valid_594242 = validateParameter(valid_594242, JString, required = true,
                                 default = nil)
  if valid_594242 != nil:
    section.add "parent", valid_594242
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
  var valid_594243 = query.getOrDefault("upload_protocol")
  valid_594243 = validateParameter(valid_594243, JString, required = false,
                                 default = nil)
  if valid_594243 != nil:
    section.add "upload_protocol", valid_594243
  var valid_594244 = query.getOrDefault("fields")
  valid_594244 = validateParameter(valid_594244, JString, required = false,
                                 default = nil)
  if valid_594244 != nil:
    section.add "fields", valid_594244
  var valid_594245 = query.getOrDefault("pageToken")
  valid_594245 = validateParameter(valid_594245, JString, required = false,
                                 default = nil)
  if valid_594245 != nil:
    section.add "pageToken", valid_594245
  var valid_594246 = query.getOrDefault("quotaUser")
  valid_594246 = validateParameter(valid_594246, JString, required = false,
                                 default = nil)
  if valid_594246 != nil:
    section.add "quotaUser", valid_594246
  var valid_594247 = query.getOrDefault("alt")
  valid_594247 = validateParameter(valid_594247, JString, required = false,
                                 default = newJString("json"))
  if valid_594247 != nil:
    section.add "alt", valid_594247
  var valid_594248 = query.getOrDefault("readTime")
  valid_594248 = validateParameter(valid_594248, JString, required = false,
                                 default = nil)
  if valid_594248 != nil:
    section.add "readTime", valid_594248
  var valid_594249 = query.getOrDefault("oauth_token")
  valid_594249 = validateParameter(valid_594249, JString, required = false,
                                 default = nil)
  if valid_594249 != nil:
    section.add "oauth_token", valid_594249
  var valid_594250 = query.getOrDefault("callback")
  valid_594250 = validateParameter(valid_594250, JString, required = false,
                                 default = nil)
  if valid_594250 != nil:
    section.add "callback", valid_594250
  var valid_594251 = query.getOrDefault("access_token")
  valid_594251 = validateParameter(valid_594251, JString, required = false,
                                 default = nil)
  if valid_594251 != nil:
    section.add "access_token", valid_594251
  var valid_594252 = query.getOrDefault("uploadType")
  valid_594252 = validateParameter(valid_594252, JString, required = false,
                                 default = nil)
  if valid_594252 != nil:
    section.add "uploadType", valid_594252
  var valid_594253 = query.getOrDefault("showMissing")
  valid_594253 = validateParameter(valid_594253, JBool, required = false, default = nil)
  if valid_594253 != nil:
    section.add "showMissing", valid_594253
  var valid_594254 = query.getOrDefault("orderBy")
  valid_594254 = validateParameter(valid_594254, JString, required = false,
                                 default = nil)
  if valid_594254 != nil:
    section.add "orderBy", valid_594254
  var valid_594255 = query.getOrDefault("transaction")
  valid_594255 = validateParameter(valid_594255, JString, required = false,
                                 default = nil)
  if valid_594255 != nil:
    section.add "transaction", valid_594255
  var valid_594256 = query.getOrDefault("key")
  valid_594256 = validateParameter(valid_594256, JString, required = false,
                                 default = nil)
  if valid_594256 != nil:
    section.add "key", valid_594256
  var valid_594257 = query.getOrDefault("$.xgafv")
  valid_594257 = validateParameter(valid_594257, JString, required = false,
                                 default = newJString("1"))
  if valid_594257 != nil:
    section.add "$.xgafv", valid_594257
  var valid_594258 = query.getOrDefault("pageSize")
  valid_594258 = validateParameter(valid_594258, JInt, required = false, default = nil)
  if valid_594258 != nil:
    section.add "pageSize", valid_594258
  var valid_594259 = query.getOrDefault("mask.fieldPaths")
  valid_594259 = validateParameter(valid_594259, JArray, required = false,
                                 default = nil)
  if valid_594259 != nil:
    section.add "mask.fieldPaths", valid_594259
  var valid_594260 = query.getOrDefault("prettyPrint")
  valid_594260 = validateParameter(valid_594260, JBool, required = false,
                                 default = newJBool(true))
  if valid_594260 != nil:
    section.add "prettyPrint", valid_594260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594261: Call_FirestoreProjectsDatabasesDocumentsList_594238;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists documents.
  ## 
  let valid = call_594261.validator(path, query, header, formData, body)
  let scheme = call_594261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594261.url(scheme.get, call_594261.host, call_594261.base,
                         call_594261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594261, url, valid)

proc call*(call_594262: Call_FirestoreProjectsDatabasesDocumentsList_594238;
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
  var path_594263 = newJObject()
  var query_594264 = newJObject()
  add(query_594264, "upload_protocol", newJString(uploadProtocol))
  add(query_594264, "fields", newJString(fields))
  add(query_594264, "pageToken", newJString(pageToken))
  add(query_594264, "quotaUser", newJString(quotaUser))
  add(query_594264, "alt", newJString(alt))
  add(path_594263, "collectionId", newJString(collectionId))
  add(query_594264, "readTime", newJString(readTime))
  add(query_594264, "oauth_token", newJString(oauthToken))
  add(query_594264, "callback", newJString(callback))
  add(query_594264, "access_token", newJString(accessToken))
  add(query_594264, "uploadType", newJString(uploadType))
  add(path_594263, "parent", newJString(parent))
  add(query_594264, "showMissing", newJBool(showMissing))
  add(query_594264, "orderBy", newJString(orderBy))
  add(query_594264, "transaction", newJString(transaction))
  add(query_594264, "key", newJString(key))
  add(query_594264, "$.xgafv", newJString(Xgafv))
  add(query_594264, "pageSize", newJInt(pageSize))
  if maskFieldPaths != nil:
    query_594264.add "mask.fieldPaths", maskFieldPaths
  add(query_594264, "prettyPrint", newJBool(prettyPrint))
  result = call_594262.call(path_594263, query_594264, nil, nil, nil)

var firestoreProjectsDatabasesDocumentsList* = Call_FirestoreProjectsDatabasesDocumentsList_594238(
    name: "firestoreProjectsDatabasesDocumentsList", meth: HttpMethod.HttpGet,
    host: "firestore.googleapis.com", route: "/v1beta1/{parent}/{collectionId}",
    validator: validate_FirestoreProjectsDatabasesDocumentsList_594239, base: "/",
    url: url_FirestoreProjectsDatabasesDocumentsList_594240,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsListCollectionIds_594289 = ref object of OpenApiRestCall_593421
proc url_FirestoreProjectsDatabasesDocumentsListCollectionIds_594291(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FirestoreProjectsDatabasesDocumentsListCollectionIds_594290(
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
  var valid_594292 = path.getOrDefault("parent")
  valid_594292 = validateParameter(valid_594292, JString, required = true,
                                 default = nil)
  if valid_594292 != nil:
    section.add "parent", valid_594292
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
  var valid_594293 = query.getOrDefault("upload_protocol")
  valid_594293 = validateParameter(valid_594293, JString, required = false,
                                 default = nil)
  if valid_594293 != nil:
    section.add "upload_protocol", valid_594293
  var valid_594294 = query.getOrDefault("fields")
  valid_594294 = validateParameter(valid_594294, JString, required = false,
                                 default = nil)
  if valid_594294 != nil:
    section.add "fields", valid_594294
  var valid_594295 = query.getOrDefault("quotaUser")
  valid_594295 = validateParameter(valid_594295, JString, required = false,
                                 default = nil)
  if valid_594295 != nil:
    section.add "quotaUser", valid_594295
  var valid_594296 = query.getOrDefault("alt")
  valid_594296 = validateParameter(valid_594296, JString, required = false,
                                 default = newJString("json"))
  if valid_594296 != nil:
    section.add "alt", valid_594296
  var valid_594297 = query.getOrDefault("oauth_token")
  valid_594297 = validateParameter(valid_594297, JString, required = false,
                                 default = nil)
  if valid_594297 != nil:
    section.add "oauth_token", valid_594297
  var valid_594298 = query.getOrDefault("callback")
  valid_594298 = validateParameter(valid_594298, JString, required = false,
                                 default = nil)
  if valid_594298 != nil:
    section.add "callback", valid_594298
  var valid_594299 = query.getOrDefault("access_token")
  valid_594299 = validateParameter(valid_594299, JString, required = false,
                                 default = nil)
  if valid_594299 != nil:
    section.add "access_token", valid_594299
  var valid_594300 = query.getOrDefault("uploadType")
  valid_594300 = validateParameter(valid_594300, JString, required = false,
                                 default = nil)
  if valid_594300 != nil:
    section.add "uploadType", valid_594300
  var valid_594301 = query.getOrDefault("key")
  valid_594301 = validateParameter(valid_594301, JString, required = false,
                                 default = nil)
  if valid_594301 != nil:
    section.add "key", valid_594301
  var valid_594302 = query.getOrDefault("$.xgafv")
  valid_594302 = validateParameter(valid_594302, JString, required = false,
                                 default = newJString("1"))
  if valid_594302 != nil:
    section.add "$.xgafv", valid_594302
  var valid_594303 = query.getOrDefault("prettyPrint")
  valid_594303 = validateParameter(valid_594303, JBool, required = false,
                                 default = newJBool(true))
  if valid_594303 != nil:
    section.add "prettyPrint", valid_594303
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

proc call*(call_594305: Call_FirestoreProjectsDatabasesDocumentsListCollectionIds_594289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the collection IDs underneath a document.
  ## 
  let valid = call_594305.validator(path, query, header, formData, body)
  let scheme = call_594305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594305.url(scheme.get, call_594305.host, call_594305.base,
                         call_594305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594305, url, valid)

proc call*(call_594306: Call_FirestoreProjectsDatabasesDocumentsListCollectionIds_594289;
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
  var path_594307 = newJObject()
  var query_594308 = newJObject()
  var body_594309 = newJObject()
  add(query_594308, "upload_protocol", newJString(uploadProtocol))
  add(query_594308, "fields", newJString(fields))
  add(query_594308, "quotaUser", newJString(quotaUser))
  add(query_594308, "alt", newJString(alt))
  add(query_594308, "oauth_token", newJString(oauthToken))
  add(query_594308, "callback", newJString(callback))
  add(query_594308, "access_token", newJString(accessToken))
  add(query_594308, "uploadType", newJString(uploadType))
  add(path_594307, "parent", newJString(parent))
  add(query_594308, "key", newJString(key))
  add(query_594308, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594309 = body
  add(query_594308, "prettyPrint", newJBool(prettyPrint))
  result = call_594306.call(path_594307, query_594308, nil, nil, body_594309)

var firestoreProjectsDatabasesDocumentsListCollectionIds* = Call_FirestoreProjectsDatabasesDocumentsListCollectionIds_594289(
    name: "firestoreProjectsDatabasesDocumentsListCollectionIds",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1beta1/{parent}:listCollectionIds",
    validator: validate_FirestoreProjectsDatabasesDocumentsListCollectionIds_594290,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsListCollectionIds_594291,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsRunQuery_594310 = ref object of OpenApiRestCall_593421
proc url_FirestoreProjectsDatabasesDocumentsRunQuery_594312(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FirestoreProjectsDatabasesDocumentsRunQuery_594311(path: JsonNode;
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
  var valid_594313 = path.getOrDefault("parent")
  valid_594313 = validateParameter(valid_594313, JString, required = true,
                                 default = nil)
  if valid_594313 != nil:
    section.add "parent", valid_594313
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
  var valid_594314 = query.getOrDefault("upload_protocol")
  valid_594314 = validateParameter(valid_594314, JString, required = false,
                                 default = nil)
  if valid_594314 != nil:
    section.add "upload_protocol", valid_594314
  var valid_594315 = query.getOrDefault("fields")
  valid_594315 = validateParameter(valid_594315, JString, required = false,
                                 default = nil)
  if valid_594315 != nil:
    section.add "fields", valid_594315
  var valid_594316 = query.getOrDefault("quotaUser")
  valid_594316 = validateParameter(valid_594316, JString, required = false,
                                 default = nil)
  if valid_594316 != nil:
    section.add "quotaUser", valid_594316
  var valid_594317 = query.getOrDefault("alt")
  valid_594317 = validateParameter(valid_594317, JString, required = false,
                                 default = newJString("json"))
  if valid_594317 != nil:
    section.add "alt", valid_594317
  var valid_594318 = query.getOrDefault("oauth_token")
  valid_594318 = validateParameter(valid_594318, JString, required = false,
                                 default = nil)
  if valid_594318 != nil:
    section.add "oauth_token", valid_594318
  var valid_594319 = query.getOrDefault("callback")
  valid_594319 = validateParameter(valid_594319, JString, required = false,
                                 default = nil)
  if valid_594319 != nil:
    section.add "callback", valid_594319
  var valid_594320 = query.getOrDefault("access_token")
  valid_594320 = validateParameter(valid_594320, JString, required = false,
                                 default = nil)
  if valid_594320 != nil:
    section.add "access_token", valid_594320
  var valid_594321 = query.getOrDefault("uploadType")
  valid_594321 = validateParameter(valid_594321, JString, required = false,
                                 default = nil)
  if valid_594321 != nil:
    section.add "uploadType", valid_594321
  var valid_594322 = query.getOrDefault("key")
  valid_594322 = validateParameter(valid_594322, JString, required = false,
                                 default = nil)
  if valid_594322 != nil:
    section.add "key", valid_594322
  var valid_594323 = query.getOrDefault("$.xgafv")
  valid_594323 = validateParameter(valid_594323, JString, required = false,
                                 default = newJString("1"))
  if valid_594323 != nil:
    section.add "$.xgafv", valid_594323
  var valid_594324 = query.getOrDefault("prettyPrint")
  valid_594324 = validateParameter(valid_594324, JBool, required = false,
                                 default = newJBool(true))
  if valid_594324 != nil:
    section.add "prettyPrint", valid_594324
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

proc call*(call_594326: Call_FirestoreProjectsDatabasesDocumentsRunQuery_594310;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Runs a query.
  ## 
  let valid = call_594326.validator(path, query, header, formData, body)
  let scheme = call_594326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594326.url(scheme.get, call_594326.host, call_594326.base,
                         call_594326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594326, url, valid)

proc call*(call_594327: Call_FirestoreProjectsDatabasesDocumentsRunQuery_594310;
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
  var path_594328 = newJObject()
  var query_594329 = newJObject()
  var body_594330 = newJObject()
  add(query_594329, "upload_protocol", newJString(uploadProtocol))
  add(query_594329, "fields", newJString(fields))
  add(query_594329, "quotaUser", newJString(quotaUser))
  add(query_594329, "alt", newJString(alt))
  add(query_594329, "oauth_token", newJString(oauthToken))
  add(query_594329, "callback", newJString(callback))
  add(query_594329, "access_token", newJString(accessToken))
  add(query_594329, "uploadType", newJString(uploadType))
  add(path_594328, "parent", newJString(parent))
  add(query_594329, "key", newJString(key))
  add(query_594329, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594330 = body
  add(query_594329, "prettyPrint", newJBool(prettyPrint))
  result = call_594327.call(path_594328, query_594329, nil, nil, body_594330)

var firestoreProjectsDatabasesDocumentsRunQuery* = Call_FirestoreProjectsDatabasesDocumentsRunQuery_594310(
    name: "firestoreProjectsDatabasesDocumentsRunQuery",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1beta1/{parent}:runQuery",
    validator: validate_FirestoreProjectsDatabasesDocumentsRunQuery_594311,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsRunQuery_594312,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
