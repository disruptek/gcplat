
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
  gcpServiceName = "firestore"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FirestoreProjectsDatabasesDocumentsBatchGet_579690 = ref object of OpenApiRestCall_579421
proc url_FirestoreProjectsDatabasesDocumentsBatchGet_579692(protocol: Scheme;
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

proc validate_FirestoreProjectsDatabasesDocumentsBatchGet_579691(path: JsonNode;
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
  var valid_579818 = path.getOrDefault("database")
  valid_579818 = validateParameter(valid_579818, JString, required = true,
                                 default = nil)
  if valid_579818 != nil:
    section.add "database", valid_579818
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

proc call*(call_579866: Call_FirestoreProjectsDatabasesDocumentsBatchGet_579690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets multiple documents.
  ## 
  ## Documents returned by this method are not guaranteed to be returned in the
  ## same order that they were requested.
  ## 
  let valid = call_579866.validator(path, query, header, formData, body)
  let scheme = call_579866.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579866.url(scheme.get, call_579866.host, call_579866.base,
                         call_579866.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579866, url, valid)

proc call*(call_579937: Call_FirestoreProjectsDatabasesDocumentsBatchGet_579690;
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
  var path_579938 = newJObject()
  var query_579940 = newJObject()
  var body_579941 = newJObject()
  add(query_579940, "upload_protocol", newJString(uploadProtocol))
  add(query_579940, "fields", newJString(fields))
  add(query_579940, "quotaUser", newJString(quotaUser))
  add(query_579940, "alt", newJString(alt))
  add(query_579940, "oauth_token", newJString(oauthToken))
  add(query_579940, "callback", newJString(callback))
  add(query_579940, "access_token", newJString(accessToken))
  add(query_579940, "uploadType", newJString(uploadType))
  add(query_579940, "key", newJString(key))
  add(path_579938, "database", newJString(database))
  add(query_579940, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579941 = body
  add(query_579940, "prettyPrint", newJBool(prettyPrint))
  result = call_579937.call(path_579938, query_579940, nil, nil, body_579941)

var firestoreProjectsDatabasesDocumentsBatchGet* = Call_FirestoreProjectsDatabasesDocumentsBatchGet_579690(
    name: "firestoreProjectsDatabasesDocumentsBatchGet",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1beta1/{database}/documents:batchGet",
    validator: validate_FirestoreProjectsDatabasesDocumentsBatchGet_579691,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsBatchGet_579692,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsBeginTransaction_579980 = ref object of OpenApiRestCall_579421
proc url_FirestoreProjectsDatabasesDocumentsBeginTransaction_579982(
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

proc validate_FirestoreProjectsDatabasesDocumentsBeginTransaction_579981(
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
  var valid_579983 = path.getOrDefault("database")
  valid_579983 = validateParameter(valid_579983, JString, required = true,
                                 default = nil)
  if valid_579983 != nil:
    section.add "database", valid_579983
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
  var valid_579993 = query.getOrDefault("$.xgafv")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = newJString("1"))
  if valid_579993 != nil:
    section.add "$.xgafv", valid_579993
  var valid_579994 = query.getOrDefault("prettyPrint")
  valid_579994 = validateParameter(valid_579994, JBool, required = false,
                                 default = newJBool(true))
  if valid_579994 != nil:
    section.add "prettyPrint", valid_579994
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

proc call*(call_579996: Call_FirestoreProjectsDatabasesDocumentsBeginTransaction_579980;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts a new transaction.
  ## 
  let valid = call_579996.validator(path, query, header, formData, body)
  let scheme = call_579996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579996.url(scheme.get, call_579996.host, call_579996.base,
                         call_579996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579996, url, valid)

proc call*(call_579997: Call_FirestoreProjectsDatabasesDocumentsBeginTransaction_579980;
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
  var path_579998 = newJObject()
  var query_579999 = newJObject()
  var body_580000 = newJObject()
  add(query_579999, "upload_protocol", newJString(uploadProtocol))
  add(query_579999, "fields", newJString(fields))
  add(query_579999, "quotaUser", newJString(quotaUser))
  add(query_579999, "alt", newJString(alt))
  add(query_579999, "oauth_token", newJString(oauthToken))
  add(query_579999, "callback", newJString(callback))
  add(query_579999, "access_token", newJString(accessToken))
  add(query_579999, "uploadType", newJString(uploadType))
  add(query_579999, "key", newJString(key))
  add(path_579998, "database", newJString(database))
  add(query_579999, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580000 = body
  add(query_579999, "prettyPrint", newJBool(prettyPrint))
  result = call_579997.call(path_579998, query_579999, nil, nil, body_580000)

var firestoreProjectsDatabasesDocumentsBeginTransaction* = Call_FirestoreProjectsDatabasesDocumentsBeginTransaction_579980(
    name: "firestoreProjectsDatabasesDocumentsBeginTransaction",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1beta1/{database}/documents:beginTransaction",
    validator: validate_FirestoreProjectsDatabasesDocumentsBeginTransaction_579981,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsBeginTransaction_579982,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsCommit_580001 = ref object of OpenApiRestCall_579421
proc url_FirestoreProjectsDatabasesDocumentsCommit_580003(protocol: Scheme;
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

proc validate_FirestoreProjectsDatabasesDocumentsCommit_580002(path: JsonNode;
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
  var valid_580004 = path.getOrDefault("database")
  valid_580004 = validateParameter(valid_580004, JString, required = true,
                                 default = nil)
  if valid_580004 != nil:
    section.add "database", valid_580004
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
  var valid_580005 = query.getOrDefault("upload_protocol")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "upload_protocol", valid_580005
  var valid_580006 = query.getOrDefault("fields")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "fields", valid_580006
  var valid_580007 = query.getOrDefault("quotaUser")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "quotaUser", valid_580007
  var valid_580008 = query.getOrDefault("alt")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = newJString("json"))
  if valid_580008 != nil:
    section.add "alt", valid_580008
  var valid_580009 = query.getOrDefault("oauth_token")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "oauth_token", valid_580009
  var valid_580010 = query.getOrDefault("callback")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "callback", valid_580010
  var valid_580011 = query.getOrDefault("access_token")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "access_token", valid_580011
  var valid_580012 = query.getOrDefault("uploadType")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "uploadType", valid_580012
  var valid_580013 = query.getOrDefault("key")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "key", valid_580013
  var valid_580014 = query.getOrDefault("$.xgafv")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = newJString("1"))
  if valid_580014 != nil:
    section.add "$.xgafv", valid_580014
  var valid_580015 = query.getOrDefault("prettyPrint")
  valid_580015 = validateParameter(valid_580015, JBool, required = false,
                                 default = newJBool(true))
  if valid_580015 != nil:
    section.add "prettyPrint", valid_580015
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

proc call*(call_580017: Call_FirestoreProjectsDatabasesDocumentsCommit_580001;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Commits a transaction, while optionally updating documents.
  ## 
  let valid = call_580017.validator(path, query, header, formData, body)
  let scheme = call_580017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580017.url(scheme.get, call_580017.host, call_580017.base,
                         call_580017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580017, url, valid)

proc call*(call_580018: Call_FirestoreProjectsDatabasesDocumentsCommit_580001;
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
  var path_580019 = newJObject()
  var query_580020 = newJObject()
  var body_580021 = newJObject()
  add(query_580020, "upload_protocol", newJString(uploadProtocol))
  add(query_580020, "fields", newJString(fields))
  add(query_580020, "quotaUser", newJString(quotaUser))
  add(query_580020, "alt", newJString(alt))
  add(query_580020, "oauth_token", newJString(oauthToken))
  add(query_580020, "callback", newJString(callback))
  add(query_580020, "access_token", newJString(accessToken))
  add(query_580020, "uploadType", newJString(uploadType))
  add(query_580020, "key", newJString(key))
  add(path_580019, "database", newJString(database))
  add(query_580020, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580021 = body
  add(query_580020, "prettyPrint", newJBool(prettyPrint))
  result = call_580018.call(path_580019, query_580020, nil, nil, body_580021)

var firestoreProjectsDatabasesDocumentsCommit* = Call_FirestoreProjectsDatabasesDocumentsCommit_580001(
    name: "firestoreProjectsDatabasesDocumentsCommit", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com",
    route: "/v1beta1/{database}/documents:commit",
    validator: validate_FirestoreProjectsDatabasesDocumentsCommit_580002,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsCommit_580003,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsListen_580022 = ref object of OpenApiRestCall_579421
proc url_FirestoreProjectsDatabasesDocumentsListen_580024(protocol: Scheme;
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

proc validate_FirestoreProjectsDatabasesDocumentsListen_580023(path: JsonNode;
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
  var valid_580025 = path.getOrDefault("database")
  valid_580025 = validateParameter(valid_580025, JString, required = true,
                                 default = nil)
  if valid_580025 != nil:
    section.add "database", valid_580025
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
  var valid_580026 = query.getOrDefault("upload_protocol")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "upload_protocol", valid_580026
  var valid_580027 = query.getOrDefault("fields")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "fields", valid_580027
  var valid_580028 = query.getOrDefault("quotaUser")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "quotaUser", valid_580028
  var valid_580029 = query.getOrDefault("alt")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = newJString("json"))
  if valid_580029 != nil:
    section.add "alt", valid_580029
  var valid_580030 = query.getOrDefault("oauth_token")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "oauth_token", valid_580030
  var valid_580031 = query.getOrDefault("callback")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "callback", valid_580031
  var valid_580032 = query.getOrDefault("access_token")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "access_token", valid_580032
  var valid_580033 = query.getOrDefault("uploadType")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "uploadType", valid_580033
  var valid_580034 = query.getOrDefault("key")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "key", valid_580034
  var valid_580035 = query.getOrDefault("$.xgafv")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = newJString("1"))
  if valid_580035 != nil:
    section.add "$.xgafv", valid_580035
  var valid_580036 = query.getOrDefault("prettyPrint")
  valid_580036 = validateParameter(valid_580036, JBool, required = false,
                                 default = newJBool(true))
  if valid_580036 != nil:
    section.add "prettyPrint", valid_580036
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

proc call*(call_580038: Call_FirestoreProjectsDatabasesDocumentsListen_580022;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Listens to changes.
  ## 
  let valid = call_580038.validator(path, query, header, formData, body)
  let scheme = call_580038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580038.url(scheme.get, call_580038.host, call_580038.base,
                         call_580038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580038, url, valid)

proc call*(call_580039: Call_FirestoreProjectsDatabasesDocumentsListen_580022;
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
  var path_580040 = newJObject()
  var query_580041 = newJObject()
  var body_580042 = newJObject()
  add(query_580041, "upload_protocol", newJString(uploadProtocol))
  add(query_580041, "fields", newJString(fields))
  add(query_580041, "quotaUser", newJString(quotaUser))
  add(query_580041, "alt", newJString(alt))
  add(query_580041, "oauth_token", newJString(oauthToken))
  add(query_580041, "callback", newJString(callback))
  add(query_580041, "access_token", newJString(accessToken))
  add(query_580041, "uploadType", newJString(uploadType))
  add(query_580041, "key", newJString(key))
  add(path_580040, "database", newJString(database))
  add(query_580041, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580042 = body
  add(query_580041, "prettyPrint", newJBool(prettyPrint))
  result = call_580039.call(path_580040, query_580041, nil, nil, body_580042)

var firestoreProjectsDatabasesDocumentsListen* = Call_FirestoreProjectsDatabasesDocumentsListen_580022(
    name: "firestoreProjectsDatabasesDocumentsListen", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com",
    route: "/v1beta1/{database}/documents:listen",
    validator: validate_FirestoreProjectsDatabasesDocumentsListen_580023,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsListen_580024,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsRollback_580043 = ref object of OpenApiRestCall_579421
proc url_FirestoreProjectsDatabasesDocumentsRollback_580045(protocol: Scheme;
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

proc validate_FirestoreProjectsDatabasesDocumentsRollback_580044(path: JsonNode;
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
  var valid_580046 = path.getOrDefault("database")
  valid_580046 = validateParameter(valid_580046, JString, required = true,
                                 default = nil)
  if valid_580046 != nil:
    section.add "database", valid_580046
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
  var valid_580047 = query.getOrDefault("upload_protocol")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "upload_protocol", valid_580047
  var valid_580048 = query.getOrDefault("fields")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "fields", valid_580048
  var valid_580049 = query.getOrDefault("quotaUser")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "quotaUser", valid_580049
  var valid_580050 = query.getOrDefault("alt")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = newJString("json"))
  if valid_580050 != nil:
    section.add "alt", valid_580050
  var valid_580051 = query.getOrDefault("oauth_token")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "oauth_token", valid_580051
  var valid_580052 = query.getOrDefault("callback")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "callback", valid_580052
  var valid_580053 = query.getOrDefault("access_token")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "access_token", valid_580053
  var valid_580054 = query.getOrDefault("uploadType")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "uploadType", valid_580054
  var valid_580055 = query.getOrDefault("key")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "key", valid_580055
  var valid_580056 = query.getOrDefault("$.xgafv")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = newJString("1"))
  if valid_580056 != nil:
    section.add "$.xgafv", valid_580056
  var valid_580057 = query.getOrDefault("prettyPrint")
  valid_580057 = validateParameter(valid_580057, JBool, required = false,
                                 default = newJBool(true))
  if valid_580057 != nil:
    section.add "prettyPrint", valid_580057
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

proc call*(call_580059: Call_FirestoreProjectsDatabasesDocumentsRollback_580043;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rolls back a transaction.
  ## 
  let valid = call_580059.validator(path, query, header, formData, body)
  let scheme = call_580059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580059.url(scheme.get, call_580059.host, call_580059.base,
                         call_580059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580059, url, valid)

proc call*(call_580060: Call_FirestoreProjectsDatabasesDocumentsRollback_580043;
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
  var path_580061 = newJObject()
  var query_580062 = newJObject()
  var body_580063 = newJObject()
  add(query_580062, "upload_protocol", newJString(uploadProtocol))
  add(query_580062, "fields", newJString(fields))
  add(query_580062, "quotaUser", newJString(quotaUser))
  add(query_580062, "alt", newJString(alt))
  add(query_580062, "oauth_token", newJString(oauthToken))
  add(query_580062, "callback", newJString(callback))
  add(query_580062, "access_token", newJString(accessToken))
  add(query_580062, "uploadType", newJString(uploadType))
  add(query_580062, "key", newJString(key))
  add(path_580061, "database", newJString(database))
  add(query_580062, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580063 = body
  add(query_580062, "prettyPrint", newJBool(prettyPrint))
  result = call_580060.call(path_580061, query_580062, nil, nil, body_580063)

var firestoreProjectsDatabasesDocumentsRollback* = Call_FirestoreProjectsDatabasesDocumentsRollback_580043(
    name: "firestoreProjectsDatabasesDocumentsRollback",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1beta1/{database}/documents:rollback",
    validator: validate_FirestoreProjectsDatabasesDocumentsRollback_580044,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsRollback_580045,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsWrite_580064 = ref object of OpenApiRestCall_579421
proc url_FirestoreProjectsDatabasesDocumentsWrite_580066(protocol: Scheme;
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

proc validate_FirestoreProjectsDatabasesDocumentsWrite_580065(path: JsonNode;
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
  var valid_580067 = path.getOrDefault("database")
  valid_580067 = validateParameter(valid_580067, JString, required = true,
                                 default = nil)
  if valid_580067 != nil:
    section.add "database", valid_580067
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
  var valid_580068 = query.getOrDefault("upload_protocol")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "upload_protocol", valid_580068
  var valid_580069 = query.getOrDefault("fields")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "fields", valid_580069
  var valid_580070 = query.getOrDefault("quotaUser")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "quotaUser", valid_580070
  var valid_580071 = query.getOrDefault("alt")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = newJString("json"))
  if valid_580071 != nil:
    section.add "alt", valid_580071
  var valid_580072 = query.getOrDefault("oauth_token")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "oauth_token", valid_580072
  var valid_580073 = query.getOrDefault("callback")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "callback", valid_580073
  var valid_580074 = query.getOrDefault("access_token")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "access_token", valid_580074
  var valid_580075 = query.getOrDefault("uploadType")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "uploadType", valid_580075
  var valid_580076 = query.getOrDefault("key")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "key", valid_580076
  var valid_580077 = query.getOrDefault("$.xgafv")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = newJString("1"))
  if valid_580077 != nil:
    section.add "$.xgafv", valid_580077
  var valid_580078 = query.getOrDefault("prettyPrint")
  valid_580078 = validateParameter(valid_580078, JBool, required = false,
                                 default = newJBool(true))
  if valid_580078 != nil:
    section.add "prettyPrint", valid_580078
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

proc call*(call_580080: Call_FirestoreProjectsDatabasesDocumentsWrite_580064;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Streams batches of document updates and deletes, in order.
  ## 
  let valid = call_580080.validator(path, query, header, formData, body)
  let scheme = call_580080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580080.url(scheme.get, call_580080.host, call_580080.base,
                         call_580080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580080, url, valid)

proc call*(call_580081: Call_FirestoreProjectsDatabasesDocumentsWrite_580064;
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
  var path_580082 = newJObject()
  var query_580083 = newJObject()
  var body_580084 = newJObject()
  add(query_580083, "upload_protocol", newJString(uploadProtocol))
  add(query_580083, "fields", newJString(fields))
  add(query_580083, "quotaUser", newJString(quotaUser))
  add(query_580083, "alt", newJString(alt))
  add(query_580083, "oauth_token", newJString(oauthToken))
  add(query_580083, "callback", newJString(callback))
  add(query_580083, "access_token", newJString(accessToken))
  add(query_580083, "uploadType", newJString(uploadType))
  add(query_580083, "key", newJString(key))
  add(path_580082, "database", newJString(database))
  add(query_580083, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580084 = body
  add(query_580083, "prettyPrint", newJBool(prettyPrint))
  result = call_580081.call(path_580082, query_580083, nil, nil, body_580084)

var firestoreProjectsDatabasesDocumentsWrite* = Call_FirestoreProjectsDatabasesDocumentsWrite_580064(
    name: "firestoreProjectsDatabasesDocumentsWrite", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com",
    route: "/v1beta1/{database}/documents:write",
    validator: validate_FirestoreProjectsDatabasesDocumentsWrite_580065,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsWrite_580066,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsGet_580085 = ref object of OpenApiRestCall_579421
proc url_FirestoreProjectsDatabasesDocumentsGet_580087(protocol: Scheme;
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

proc validate_FirestoreProjectsDatabasesDocumentsGet_580086(path: JsonNode;
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
  var valid_580088 = path.getOrDefault("name")
  valid_580088 = validateParameter(valid_580088, JString, required = true,
                                 default = nil)
  if valid_580088 != nil:
    section.add "name", valid_580088
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
  var valid_580089 = query.getOrDefault("upload_protocol")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "upload_protocol", valid_580089
  var valid_580090 = query.getOrDefault("fields")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "fields", valid_580090
  var valid_580091 = query.getOrDefault("quotaUser")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "quotaUser", valid_580091
  var valid_580092 = query.getOrDefault("alt")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = newJString("json"))
  if valid_580092 != nil:
    section.add "alt", valid_580092
  var valid_580093 = query.getOrDefault("readTime")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "readTime", valid_580093
  var valid_580094 = query.getOrDefault("oauth_token")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "oauth_token", valid_580094
  var valid_580095 = query.getOrDefault("callback")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "callback", valid_580095
  var valid_580096 = query.getOrDefault("access_token")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "access_token", valid_580096
  var valid_580097 = query.getOrDefault("uploadType")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "uploadType", valid_580097
  var valid_580098 = query.getOrDefault("transaction")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "transaction", valid_580098
  var valid_580099 = query.getOrDefault("key")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "key", valid_580099
  var valid_580100 = query.getOrDefault("$.xgafv")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = newJString("1"))
  if valid_580100 != nil:
    section.add "$.xgafv", valid_580100
  var valid_580101 = query.getOrDefault("mask.fieldPaths")
  valid_580101 = validateParameter(valid_580101, JArray, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "mask.fieldPaths", valid_580101
  var valid_580102 = query.getOrDefault("prettyPrint")
  valid_580102 = validateParameter(valid_580102, JBool, required = false,
                                 default = newJBool(true))
  if valid_580102 != nil:
    section.add "prettyPrint", valid_580102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580103: Call_FirestoreProjectsDatabasesDocumentsGet_580085;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a single document.
  ## 
  let valid = call_580103.validator(path, query, header, formData, body)
  let scheme = call_580103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580103.url(scheme.get, call_580103.host, call_580103.base,
                         call_580103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580103, url, valid)

proc call*(call_580104: Call_FirestoreProjectsDatabasesDocumentsGet_580085;
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
  var path_580105 = newJObject()
  var query_580106 = newJObject()
  add(query_580106, "upload_protocol", newJString(uploadProtocol))
  add(query_580106, "fields", newJString(fields))
  add(query_580106, "quotaUser", newJString(quotaUser))
  add(path_580105, "name", newJString(name))
  add(query_580106, "alt", newJString(alt))
  add(query_580106, "readTime", newJString(readTime))
  add(query_580106, "oauth_token", newJString(oauthToken))
  add(query_580106, "callback", newJString(callback))
  add(query_580106, "access_token", newJString(accessToken))
  add(query_580106, "uploadType", newJString(uploadType))
  add(query_580106, "transaction", newJString(transaction))
  add(query_580106, "key", newJString(key))
  add(query_580106, "$.xgafv", newJString(Xgafv))
  if maskFieldPaths != nil:
    query_580106.add "mask.fieldPaths", maskFieldPaths
  add(query_580106, "prettyPrint", newJBool(prettyPrint))
  result = call_580104.call(path_580105, query_580106, nil, nil, nil)

var firestoreProjectsDatabasesDocumentsGet* = Call_FirestoreProjectsDatabasesDocumentsGet_580085(
    name: "firestoreProjectsDatabasesDocumentsGet", meth: HttpMethod.HttpGet,
    host: "firestore.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_FirestoreProjectsDatabasesDocumentsGet_580086, base: "/",
    url: url_FirestoreProjectsDatabasesDocumentsGet_580087,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsPatch_580128 = ref object of OpenApiRestCall_579421
proc url_FirestoreProjectsDatabasesDocumentsPatch_580130(protocol: Scheme;
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

proc validate_FirestoreProjectsDatabasesDocumentsPatch_580129(path: JsonNode;
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
  var valid_580131 = path.getOrDefault("name")
  valid_580131 = validateParameter(valid_580131, JString, required = true,
                                 default = nil)
  if valid_580131 != nil:
    section.add "name", valid_580131
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
  var valid_580132 = query.getOrDefault("upload_protocol")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "upload_protocol", valid_580132
  var valid_580133 = query.getOrDefault("fields")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "fields", valid_580133
  var valid_580134 = query.getOrDefault("quotaUser")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "quotaUser", valid_580134
  var valid_580135 = query.getOrDefault("alt")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = newJString("json"))
  if valid_580135 != nil:
    section.add "alt", valid_580135
  var valid_580136 = query.getOrDefault("currentDocument.updateTime")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "currentDocument.updateTime", valid_580136
  var valid_580137 = query.getOrDefault("oauth_token")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "oauth_token", valid_580137
  var valid_580138 = query.getOrDefault("callback")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "callback", valid_580138
  var valid_580139 = query.getOrDefault("access_token")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "access_token", valid_580139
  var valid_580140 = query.getOrDefault("uploadType")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "uploadType", valid_580140
  var valid_580141 = query.getOrDefault("updateMask.fieldPaths")
  valid_580141 = validateParameter(valid_580141, JArray, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "updateMask.fieldPaths", valid_580141
  var valid_580142 = query.getOrDefault("key")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "key", valid_580142
  var valid_580143 = query.getOrDefault("currentDocument.exists")
  valid_580143 = validateParameter(valid_580143, JBool, required = false, default = nil)
  if valid_580143 != nil:
    section.add "currentDocument.exists", valid_580143
  var valid_580144 = query.getOrDefault("$.xgafv")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = newJString("1"))
  if valid_580144 != nil:
    section.add "$.xgafv", valid_580144
  var valid_580145 = query.getOrDefault("prettyPrint")
  valid_580145 = validateParameter(valid_580145, JBool, required = false,
                                 default = newJBool(true))
  if valid_580145 != nil:
    section.add "prettyPrint", valid_580145
  var valid_580146 = query.getOrDefault("mask.fieldPaths")
  valid_580146 = validateParameter(valid_580146, JArray, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "mask.fieldPaths", valid_580146
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

proc call*(call_580148: Call_FirestoreProjectsDatabasesDocumentsPatch_580128;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates or inserts a document.
  ## 
  let valid = call_580148.validator(path, query, header, formData, body)
  let scheme = call_580148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580148.url(scheme.get, call_580148.host, call_580148.base,
                         call_580148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580148, url, valid)

proc call*(call_580149: Call_FirestoreProjectsDatabasesDocumentsPatch_580128;
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
  var path_580150 = newJObject()
  var query_580151 = newJObject()
  var body_580152 = newJObject()
  add(query_580151, "upload_protocol", newJString(uploadProtocol))
  add(query_580151, "fields", newJString(fields))
  add(query_580151, "quotaUser", newJString(quotaUser))
  add(path_580150, "name", newJString(name))
  add(query_580151, "alt", newJString(alt))
  add(query_580151, "currentDocument.updateTime",
      newJString(currentDocumentUpdateTime))
  add(query_580151, "oauth_token", newJString(oauthToken))
  add(query_580151, "callback", newJString(callback))
  add(query_580151, "access_token", newJString(accessToken))
  add(query_580151, "uploadType", newJString(uploadType))
  if updateMaskFieldPaths != nil:
    query_580151.add "updateMask.fieldPaths", updateMaskFieldPaths
  add(query_580151, "key", newJString(key))
  add(query_580151, "currentDocument.exists", newJBool(currentDocumentExists))
  add(query_580151, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580152 = body
  add(query_580151, "prettyPrint", newJBool(prettyPrint))
  if maskFieldPaths != nil:
    query_580151.add "mask.fieldPaths", maskFieldPaths
  result = call_580149.call(path_580150, query_580151, nil, nil, body_580152)

var firestoreProjectsDatabasesDocumentsPatch* = Call_FirestoreProjectsDatabasesDocumentsPatch_580128(
    name: "firestoreProjectsDatabasesDocumentsPatch", meth: HttpMethod.HttpPatch,
    host: "firestore.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_FirestoreProjectsDatabasesDocumentsPatch_580129,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsPatch_580130,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsDelete_580107 = ref object of OpenApiRestCall_579421
proc url_FirestoreProjectsDatabasesDocumentsDelete_580109(protocol: Scheme;
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

proc validate_FirestoreProjectsDatabasesDocumentsDelete_580108(path: JsonNode;
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
  var valid_580110 = path.getOrDefault("name")
  valid_580110 = validateParameter(valid_580110, JString, required = true,
                                 default = nil)
  if valid_580110 != nil:
    section.add "name", valid_580110
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
  var valid_580111 = query.getOrDefault("upload_protocol")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "upload_protocol", valid_580111
  var valid_580112 = query.getOrDefault("fields")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "fields", valid_580112
  var valid_580113 = query.getOrDefault("quotaUser")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "quotaUser", valid_580113
  var valid_580114 = query.getOrDefault("alt")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = newJString("json"))
  if valid_580114 != nil:
    section.add "alt", valid_580114
  var valid_580115 = query.getOrDefault("currentDocument.updateTime")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "currentDocument.updateTime", valid_580115
  var valid_580116 = query.getOrDefault("oauth_token")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "oauth_token", valid_580116
  var valid_580117 = query.getOrDefault("callback")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "callback", valid_580117
  var valid_580118 = query.getOrDefault("access_token")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "access_token", valid_580118
  var valid_580119 = query.getOrDefault("uploadType")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "uploadType", valid_580119
  var valid_580120 = query.getOrDefault("key")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "key", valid_580120
  var valid_580121 = query.getOrDefault("currentDocument.exists")
  valid_580121 = validateParameter(valid_580121, JBool, required = false, default = nil)
  if valid_580121 != nil:
    section.add "currentDocument.exists", valid_580121
  var valid_580122 = query.getOrDefault("$.xgafv")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = newJString("1"))
  if valid_580122 != nil:
    section.add "$.xgafv", valid_580122
  var valid_580123 = query.getOrDefault("prettyPrint")
  valid_580123 = validateParameter(valid_580123, JBool, required = false,
                                 default = newJBool(true))
  if valid_580123 != nil:
    section.add "prettyPrint", valid_580123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580124: Call_FirestoreProjectsDatabasesDocumentsDelete_580107;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a document.
  ## 
  let valid = call_580124.validator(path, query, header, formData, body)
  let scheme = call_580124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580124.url(scheme.get, call_580124.host, call_580124.base,
                         call_580124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580124, url, valid)

proc call*(call_580125: Call_FirestoreProjectsDatabasesDocumentsDelete_580107;
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
  var path_580126 = newJObject()
  var query_580127 = newJObject()
  add(query_580127, "upload_protocol", newJString(uploadProtocol))
  add(query_580127, "fields", newJString(fields))
  add(query_580127, "quotaUser", newJString(quotaUser))
  add(path_580126, "name", newJString(name))
  add(query_580127, "alt", newJString(alt))
  add(query_580127, "currentDocument.updateTime",
      newJString(currentDocumentUpdateTime))
  add(query_580127, "oauth_token", newJString(oauthToken))
  add(query_580127, "callback", newJString(callback))
  add(query_580127, "access_token", newJString(accessToken))
  add(query_580127, "uploadType", newJString(uploadType))
  add(query_580127, "key", newJString(key))
  add(query_580127, "currentDocument.exists", newJBool(currentDocumentExists))
  add(query_580127, "$.xgafv", newJString(Xgafv))
  add(query_580127, "prettyPrint", newJBool(prettyPrint))
  result = call_580125.call(path_580126, query_580127, nil, nil, nil)

var firestoreProjectsDatabasesDocumentsDelete* = Call_FirestoreProjectsDatabasesDocumentsDelete_580107(
    name: "firestoreProjectsDatabasesDocumentsDelete",
    meth: HttpMethod.HttpDelete, host: "firestore.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_FirestoreProjectsDatabasesDocumentsDelete_580108,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsDelete_580109,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesExportDocuments_580153 = ref object of OpenApiRestCall_579421
proc url_FirestoreProjectsDatabasesExportDocuments_580155(protocol: Scheme;
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

proc validate_FirestoreProjectsDatabasesExportDocuments_580154(path: JsonNode;
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
  var valid_580156 = path.getOrDefault("name")
  valid_580156 = validateParameter(valid_580156, JString, required = true,
                                 default = nil)
  if valid_580156 != nil:
    section.add "name", valid_580156
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
  var valid_580157 = query.getOrDefault("upload_protocol")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "upload_protocol", valid_580157
  var valid_580158 = query.getOrDefault("fields")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "fields", valid_580158
  var valid_580159 = query.getOrDefault("quotaUser")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "quotaUser", valid_580159
  var valid_580160 = query.getOrDefault("alt")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = newJString("json"))
  if valid_580160 != nil:
    section.add "alt", valid_580160
  var valid_580161 = query.getOrDefault("oauth_token")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "oauth_token", valid_580161
  var valid_580162 = query.getOrDefault("callback")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "callback", valid_580162
  var valid_580163 = query.getOrDefault("access_token")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "access_token", valid_580163
  var valid_580164 = query.getOrDefault("uploadType")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "uploadType", valid_580164
  var valid_580165 = query.getOrDefault("key")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "key", valid_580165
  var valid_580166 = query.getOrDefault("$.xgafv")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = newJString("1"))
  if valid_580166 != nil:
    section.add "$.xgafv", valid_580166
  var valid_580167 = query.getOrDefault("prettyPrint")
  valid_580167 = validateParameter(valid_580167, JBool, required = false,
                                 default = newJBool(true))
  if valid_580167 != nil:
    section.add "prettyPrint", valid_580167
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

proc call*(call_580169: Call_FirestoreProjectsDatabasesExportDocuments_580153;
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
  let valid = call_580169.validator(path, query, header, formData, body)
  let scheme = call_580169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580169.url(scheme.get, call_580169.host, call_580169.base,
                         call_580169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580169, url, valid)

proc call*(call_580170: Call_FirestoreProjectsDatabasesExportDocuments_580153;
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
  var path_580171 = newJObject()
  var query_580172 = newJObject()
  var body_580173 = newJObject()
  add(query_580172, "upload_protocol", newJString(uploadProtocol))
  add(query_580172, "fields", newJString(fields))
  add(query_580172, "quotaUser", newJString(quotaUser))
  add(path_580171, "name", newJString(name))
  add(query_580172, "alt", newJString(alt))
  add(query_580172, "oauth_token", newJString(oauthToken))
  add(query_580172, "callback", newJString(callback))
  add(query_580172, "access_token", newJString(accessToken))
  add(query_580172, "uploadType", newJString(uploadType))
  add(query_580172, "key", newJString(key))
  add(query_580172, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580173 = body
  add(query_580172, "prettyPrint", newJBool(prettyPrint))
  result = call_580170.call(path_580171, query_580172, nil, nil, body_580173)

var firestoreProjectsDatabasesExportDocuments* = Call_FirestoreProjectsDatabasesExportDocuments_580153(
    name: "firestoreProjectsDatabasesExportDocuments", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com", route: "/v1beta1/{name}:exportDocuments",
    validator: validate_FirestoreProjectsDatabasesExportDocuments_580154,
    base: "/", url: url_FirestoreProjectsDatabasesExportDocuments_580155,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesImportDocuments_580174 = ref object of OpenApiRestCall_579421
proc url_FirestoreProjectsDatabasesImportDocuments_580176(protocol: Scheme;
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

proc validate_FirestoreProjectsDatabasesImportDocuments_580175(path: JsonNode;
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
  var valid_580177 = path.getOrDefault("name")
  valid_580177 = validateParameter(valid_580177, JString, required = true,
                                 default = nil)
  if valid_580177 != nil:
    section.add "name", valid_580177
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
  var valid_580178 = query.getOrDefault("upload_protocol")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "upload_protocol", valid_580178
  var valid_580179 = query.getOrDefault("fields")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "fields", valid_580179
  var valid_580180 = query.getOrDefault("quotaUser")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "quotaUser", valid_580180
  var valid_580181 = query.getOrDefault("alt")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = newJString("json"))
  if valid_580181 != nil:
    section.add "alt", valid_580181
  var valid_580182 = query.getOrDefault("oauth_token")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "oauth_token", valid_580182
  var valid_580183 = query.getOrDefault("callback")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "callback", valid_580183
  var valid_580184 = query.getOrDefault("access_token")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "access_token", valid_580184
  var valid_580185 = query.getOrDefault("uploadType")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "uploadType", valid_580185
  var valid_580186 = query.getOrDefault("key")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "key", valid_580186
  var valid_580187 = query.getOrDefault("$.xgafv")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = newJString("1"))
  if valid_580187 != nil:
    section.add "$.xgafv", valid_580187
  var valid_580188 = query.getOrDefault("prettyPrint")
  valid_580188 = validateParameter(valid_580188, JBool, required = false,
                                 default = newJBool(true))
  if valid_580188 != nil:
    section.add "prettyPrint", valid_580188
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

proc call*(call_580190: Call_FirestoreProjectsDatabasesImportDocuments_580174;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Imports documents into Google Cloud Firestore. Existing documents with the
  ## same name are overwritten. The import occurs in the background and its
  ## progress can be monitored and managed via the Operation resource that is
  ## created. If an ImportDocuments operation is cancelled, it is possible
  ## that a subset of the data has already been imported to Cloud Firestore.
  ## 
  let valid = call_580190.validator(path, query, header, formData, body)
  let scheme = call_580190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580190.url(scheme.get, call_580190.host, call_580190.base,
                         call_580190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580190, url, valid)

proc call*(call_580191: Call_FirestoreProjectsDatabasesImportDocuments_580174;
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
  var path_580192 = newJObject()
  var query_580193 = newJObject()
  var body_580194 = newJObject()
  add(query_580193, "upload_protocol", newJString(uploadProtocol))
  add(query_580193, "fields", newJString(fields))
  add(query_580193, "quotaUser", newJString(quotaUser))
  add(path_580192, "name", newJString(name))
  add(query_580193, "alt", newJString(alt))
  add(query_580193, "oauth_token", newJString(oauthToken))
  add(query_580193, "callback", newJString(callback))
  add(query_580193, "access_token", newJString(accessToken))
  add(query_580193, "uploadType", newJString(uploadType))
  add(query_580193, "key", newJString(key))
  add(query_580193, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580194 = body
  add(query_580193, "prettyPrint", newJBool(prettyPrint))
  result = call_580191.call(path_580192, query_580193, nil, nil, body_580194)

var firestoreProjectsDatabasesImportDocuments* = Call_FirestoreProjectsDatabasesImportDocuments_580174(
    name: "firestoreProjectsDatabasesImportDocuments", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com", route: "/v1beta1/{name}:importDocuments",
    validator: validate_FirestoreProjectsDatabasesImportDocuments_580175,
    base: "/", url: url_FirestoreProjectsDatabasesImportDocuments_580176,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesIndexesCreate_580217 = ref object of OpenApiRestCall_579421
proc url_FirestoreProjectsDatabasesIndexesCreate_580219(protocol: Scheme;
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

proc validate_FirestoreProjectsDatabasesIndexesCreate_580218(path: JsonNode;
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
  var valid_580220 = path.getOrDefault("parent")
  valid_580220 = validateParameter(valid_580220, JString, required = true,
                                 default = nil)
  if valid_580220 != nil:
    section.add "parent", valid_580220
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
  var valid_580221 = query.getOrDefault("upload_protocol")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "upload_protocol", valid_580221
  var valid_580222 = query.getOrDefault("fields")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "fields", valid_580222
  var valid_580223 = query.getOrDefault("quotaUser")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "quotaUser", valid_580223
  var valid_580224 = query.getOrDefault("alt")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = newJString("json"))
  if valid_580224 != nil:
    section.add "alt", valid_580224
  var valid_580225 = query.getOrDefault("oauth_token")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "oauth_token", valid_580225
  var valid_580226 = query.getOrDefault("callback")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "callback", valid_580226
  var valid_580227 = query.getOrDefault("access_token")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "access_token", valid_580227
  var valid_580228 = query.getOrDefault("uploadType")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "uploadType", valid_580228
  var valid_580229 = query.getOrDefault("key")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "key", valid_580229
  var valid_580230 = query.getOrDefault("$.xgafv")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = newJString("1"))
  if valid_580230 != nil:
    section.add "$.xgafv", valid_580230
  var valid_580231 = query.getOrDefault("prettyPrint")
  valid_580231 = validateParameter(valid_580231, JBool, required = false,
                                 default = newJBool(true))
  if valid_580231 != nil:
    section.add "prettyPrint", valid_580231
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

proc call*(call_580233: Call_FirestoreProjectsDatabasesIndexesCreate_580217;
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
  let valid = call_580233.validator(path, query, header, formData, body)
  let scheme = call_580233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580233.url(scheme.get, call_580233.host, call_580233.base,
                         call_580233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580233, url, valid)

proc call*(call_580234: Call_FirestoreProjectsDatabasesIndexesCreate_580217;
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
  var path_580235 = newJObject()
  var query_580236 = newJObject()
  var body_580237 = newJObject()
  add(query_580236, "upload_protocol", newJString(uploadProtocol))
  add(query_580236, "fields", newJString(fields))
  add(query_580236, "quotaUser", newJString(quotaUser))
  add(query_580236, "alt", newJString(alt))
  add(query_580236, "oauth_token", newJString(oauthToken))
  add(query_580236, "callback", newJString(callback))
  add(query_580236, "access_token", newJString(accessToken))
  add(query_580236, "uploadType", newJString(uploadType))
  add(path_580235, "parent", newJString(parent))
  add(query_580236, "key", newJString(key))
  add(query_580236, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580237 = body
  add(query_580236, "prettyPrint", newJBool(prettyPrint))
  result = call_580234.call(path_580235, query_580236, nil, nil, body_580237)

var firestoreProjectsDatabasesIndexesCreate* = Call_FirestoreProjectsDatabasesIndexesCreate_580217(
    name: "firestoreProjectsDatabasesIndexesCreate", meth: HttpMethod.HttpPost,
    host: "firestore.googleapis.com", route: "/v1beta1/{parent}/indexes",
    validator: validate_FirestoreProjectsDatabasesIndexesCreate_580218, base: "/",
    url: url_FirestoreProjectsDatabasesIndexesCreate_580219,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesIndexesList_580195 = ref object of OpenApiRestCall_579421
proc url_FirestoreProjectsDatabasesIndexesList_580197(protocol: Scheme;
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

proc validate_FirestoreProjectsDatabasesIndexesList_580196(path: JsonNode;
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
  var valid_580198 = path.getOrDefault("parent")
  valid_580198 = validateParameter(valid_580198, JString, required = true,
                                 default = nil)
  if valid_580198 != nil:
    section.add "parent", valid_580198
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
  var valid_580199 = query.getOrDefault("upload_protocol")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "upload_protocol", valid_580199
  var valid_580200 = query.getOrDefault("fields")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "fields", valid_580200
  var valid_580201 = query.getOrDefault("pageToken")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "pageToken", valid_580201
  var valid_580202 = query.getOrDefault("quotaUser")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "quotaUser", valid_580202
  var valid_580203 = query.getOrDefault("alt")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = newJString("json"))
  if valid_580203 != nil:
    section.add "alt", valid_580203
  var valid_580204 = query.getOrDefault("oauth_token")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "oauth_token", valid_580204
  var valid_580205 = query.getOrDefault("callback")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "callback", valid_580205
  var valid_580206 = query.getOrDefault("access_token")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "access_token", valid_580206
  var valid_580207 = query.getOrDefault("uploadType")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "uploadType", valid_580207
  var valid_580208 = query.getOrDefault("key")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "key", valid_580208
  var valid_580209 = query.getOrDefault("$.xgafv")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = newJString("1"))
  if valid_580209 != nil:
    section.add "$.xgafv", valid_580209
  var valid_580210 = query.getOrDefault("pageSize")
  valid_580210 = validateParameter(valid_580210, JInt, required = false, default = nil)
  if valid_580210 != nil:
    section.add "pageSize", valid_580210
  var valid_580211 = query.getOrDefault("prettyPrint")
  valid_580211 = validateParameter(valid_580211, JBool, required = false,
                                 default = newJBool(true))
  if valid_580211 != nil:
    section.add "prettyPrint", valid_580211
  var valid_580212 = query.getOrDefault("filter")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "filter", valid_580212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580213: Call_FirestoreProjectsDatabasesIndexesList_580195;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the indexes that match the specified filters.
  ## 
  let valid = call_580213.validator(path, query, header, formData, body)
  let scheme = call_580213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580213.url(scheme.get, call_580213.host, call_580213.base,
                         call_580213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580213, url, valid)

proc call*(call_580214: Call_FirestoreProjectsDatabasesIndexesList_580195;
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
  var path_580215 = newJObject()
  var query_580216 = newJObject()
  add(query_580216, "upload_protocol", newJString(uploadProtocol))
  add(query_580216, "fields", newJString(fields))
  add(query_580216, "pageToken", newJString(pageToken))
  add(query_580216, "quotaUser", newJString(quotaUser))
  add(query_580216, "alt", newJString(alt))
  add(query_580216, "oauth_token", newJString(oauthToken))
  add(query_580216, "callback", newJString(callback))
  add(query_580216, "access_token", newJString(accessToken))
  add(query_580216, "uploadType", newJString(uploadType))
  add(path_580215, "parent", newJString(parent))
  add(query_580216, "key", newJString(key))
  add(query_580216, "$.xgafv", newJString(Xgafv))
  add(query_580216, "pageSize", newJInt(pageSize))
  add(query_580216, "prettyPrint", newJBool(prettyPrint))
  add(query_580216, "filter", newJString(filter))
  result = call_580214.call(path_580215, query_580216, nil, nil, nil)

var firestoreProjectsDatabasesIndexesList* = Call_FirestoreProjectsDatabasesIndexesList_580195(
    name: "firestoreProjectsDatabasesIndexesList", meth: HttpMethod.HttpGet,
    host: "firestore.googleapis.com", route: "/v1beta1/{parent}/indexes",
    validator: validate_FirestoreProjectsDatabasesIndexesList_580196, base: "/",
    url: url_FirestoreProjectsDatabasesIndexesList_580197, schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsCreateDocument_580265 = ref object of OpenApiRestCall_579421
proc url_FirestoreProjectsDatabasesDocumentsCreateDocument_580267(
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

proc validate_FirestoreProjectsDatabasesDocumentsCreateDocument_580266(
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
  var valid_580268 = path.getOrDefault("collectionId")
  valid_580268 = validateParameter(valid_580268, JString, required = true,
                                 default = nil)
  if valid_580268 != nil:
    section.add "collectionId", valid_580268
  var valid_580269 = path.getOrDefault("parent")
  valid_580269 = validateParameter(valid_580269, JString, required = true,
                                 default = nil)
  if valid_580269 != nil:
    section.add "parent", valid_580269
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
  var valid_580270 = query.getOrDefault("upload_protocol")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "upload_protocol", valid_580270
  var valid_580271 = query.getOrDefault("fields")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "fields", valid_580271
  var valid_580272 = query.getOrDefault("quotaUser")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "quotaUser", valid_580272
  var valid_580273 = query.getOrDefault("alt")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = newJString("json"))
  if valid_580273 != nil:
    section.add "alt", valid_580273
  var valid_580274 = query.getOrDefault("oauth_token")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "oauth_token", valid_580274
  var valid_580275 = query.getOrDefault("callback")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = nil)
  if valid_580275 != nil:
    section.add "callback", valid_580275
  var valid_580276 = query.getOrDefault("access_token")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "access_token", valid_580276
  var valid_580277 = query.getOrDefault("uploadType")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "uploadType", valid_580277
  var valid_580278 = query.getOrDefault("key")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "key", valid_580278
  var valid_580279 = query.getOrDefault("$.xgafv")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = newJString("1"))
  if valid_580279 != nil:
    section.add "$.xgafv", valid_580279
  var valid_580280 = query.getOrDefault("prettyPrint")
  valid_580280 = validateParameter(valid_580280, JBool, required = false,
                                 default = newJBool(true))
  if valid_580280 != nil:
    section.add "prettyPrint", valid_580280
  var valid_580281 = query.getOrDefault("mask.fieldPaths")
  valid_580281 = validateParameter(valid_580281, JArray, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "mask.fieldPaths", valid_580281
  var valid_580282 = query.getOrDefault("documentId")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "documentId", valid_580282
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

proc call*(call_580284: Call_FirestoreProjectsDatabasesDocumentsCreateDocument_580265;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new document.
  ## 
  let valid = call_580284.validator(path, query, header, formData, body)
  let scheme = call_580284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580284.url(scheme.get, call_580284.host, call_580284.base,
                         call_580284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580284, url, valid)

proc call*(call_580285: Call_FirestoreProjectsDatabasesDocumentsCreateDocument_580265;
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
  var path_580286 = newJObject()
  var query_580287 = newJObject()
  var body_580288 = newJObject()
  add(query_580287, "upload_protocol", newJString(uploadProtocol))
  add(query_580287, "fields", newJString(fields))
  add(query_580287, "quotaUser", newJString(quotaUser))
  add(query_580287, "alt", newJString(alt))
  add(path_580286, "collectionId", newJString(collectionId))
  add(query_580287, "oauth_token", newJString(oauthToken))
  add(query_580287, "callback", newJString(callback))
  add(query_580287, "access_token", newJString(accessToken))
  add(query_580287, "uploadType", newJString(uploadType))
  add(path_580286, "parent", newJString(parent))
  add(query_580287, "key", newJString(key))
  add(query_580287, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580288 = body
  add(query_580287, "prettyPrint", newJBool(prettyPrint))
  if maskFieldPaths != nil:
    query_580287.add "mask.fieldPaths", maskFieldPaths
  add(query_580287, "documentId", newJString(documentId))
  result = call_580285.call(path_580286, query_580287, nil, nil, body_580288)

var firestoreProjectsDatabasesDocumentsCreateDocument* = Call_FirestoreProjectsDatabasesDocumentsCreateDocument_580265(
    name: "firestoreProjectsDatabasesDocumentsCreateDocument",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1beta1/{parent}/{collectionId}",
    validator: validate_FirestoreProjectsDatabasesDocumentsCreateDocument_580266,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsCreateDocument_580267,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsList_580238 = ref object of OpenApiRestCall_579421
proc url_FirestoreProjectsDatabasesDocumentsList_580240(protocol: Scheme;
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

proc validate_FirestoreProjectsDatabasesDocumentsList_580239(path: JsonNode;
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
  var valid_580241 = path.getOrDefault("collectionId")
  valid_580241 = validateParameter(valid_580241, JString, required = true,
                                 default = nil)
  if valid_580241 != nil:
    section.add "collectionId", valid_580241
  var valid_580242 = path.getOrDefault("parent")
  valid_580242 = validateParameter(valid_580242, JString, required = true,
                                 default = nil)
  if valid_580242 != nil:
    section.add "parent", valid_580242
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
  var valid_580243 = query.getOrDefault("upload_protocol")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "upload_protocol", valid_580243
  var valid_580244 = query.getOrDefault("fields")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "fields", valid_580244
  var valid_580245 = query.getOrDefault("pageToken")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "pageToken", valid_580245
  var valid_580246 = query.getOrDefault("quotaUser")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "quotaUser", valid_580246
  var valid_580247 = query.getOrDefault("alt")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = newJString("json"))
  if valid_580247 != nil:
    section.add "alt", valid_580247
  var valid_580248 = query.getOrDefault("readTime")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "readTime", valid_580248
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
  var valid_580253 = query.getOrDefault("showMissing")
  valid_580253 = validateParameter(valid_580253, JBool, required = false, default = nil)
  if valid_580253 != nil:
    section.add "showMissing", valid_580253
  var valid_580254 = query.getOrDefault("orderBy")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "orderBy", valid_580254
  var valid_580255 = query.getOrDefault("transaction")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "transaction", valid_580255
  var valid_580256 = query.getOrDefault("key")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "key", valid_580256
  var valid_580257 = query.getOrDefault("$.xgafv")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = newJString("1"))
  if valid_580257 != nil:
    section.add "$.xgafv", valid_580257
  var valid_580258 = query.getOrDefault("pageSize")
  valid_580258 = validateParameter(valid_580258, JInt, required = false, default = nil)
  if valid_580258 != nil:
    section.add "pageSize", valid_580258
  var valid_580259 = query.getOrDefault("mask.fieldPaths")
  valid_580259 = validateParameter(valid_580259, JArray, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "mask.fieldPaths", valid_580259
  var valid_580260 = query.getOrDefault("prettyPrint")
  valid_580260 = validateParameter(valid_580260, JBool, required = false,
                                 default = newJBool(true))
  if valid_580260 != nil:
    section.add "prettyPrint", valid_580260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580261: Call_FirestoreProjectsDatabasesDocumentsList_580238;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists documents.
  ## 
  let valid = call_580261.validator(path, query, header, formData, body)
  let scheme = call_580261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580261.url(scheme.get, call_580261.host, call_580261.base,
                         call_580261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580261, url, valid)

proc call*(call_580262: Call_FirestoreProjectsDatabasesDocumentsList_580238;
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
  var path_580263 = newJObject()
  var query_580264 = newJObject()
  add(query_580264, "upload_protocol", newJString(uploadProtocol))
  add(query_580264, "fields", newJString(fields))
  add(query_580264, "pageToken", newJString(pageToken))
  add(query_580264, "quotaUser", newJString(quotaUser))
  add(query_580264, "alt", newJString(alt))
  add(path_580263, "collectionId", newJString(collectionId))
  add(query_580264, "readTime", newJString(readTime))
  add(query_580264, "oauth_token", newJString(oauthToken))
  add(query_580264, "callback", newJString(callback))
  add(query_580264, "access_token", newJString(accessToken))
  add(query_580264, "uploadType", newJString(uploadType))
  add(path_580263, "parent", newJString(parent))
  add(query_580264, "showMissing", newJBool(showMissing))
  add(query_580264, "orderBy", newJString(orderBy))
  add(query_580264, "transaction", newJString(transaction))
  add(query_580264, "key", newJString(key))
  add(query_580264, "$.xgafv", newJString(Xgafv))
  add(query_580264, "pageSize", newJInt(pageSize))
  if maskFieldPaths != nil:
    query_580264.add "mask.fieldPaths", maskFieldPaths
  add(query_580264, "prettyPrint", newJBool(prettyPrint))
  result = call_580262.call(path_580263, query_580264, nil, nil, nil)

var firestoreProjectsDatabasesDocumentsList* = Call_FirestoreProjectsDatabasesDocumentsList_580238(
    name: "firestoreProjectsDatabasesDocumentsList", meth: HttpMethod.HttpGet,
    host: "firestore.googleapis.com", route: "/v1beta1/{parent}/{collectionId}",
    validator: validate_FirestoreProjectsDatabasesDocumentsList_580239, base: "/",
    url: url_FirestoreProjectsDatabasesDocumentsList_580240,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsListCollectionIds_580289 = ref object of OpenApiRestCall_579421
proc url_FirestoreProjectsDatabasesDocumentsListCollectionIds_580291(
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

proc validate_FirestoreProjectsDatabasesDocumentsListCollectionIds_580290(
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
  var valid_580292 = path.getOrDefault("parent")
  valid_580292 = validateParameter(valid_580292, JString, required = true,
                                 default = nil)
  if valid_580292 != nil:
    section.add "parent", valid_580292
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
  var valid_580293 = query.getOrDefault("upload_protocol")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "upload_protocol", valid_580293
  var valid_580294 = query.getOrDefault("fields")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "fields", valid_580294
  var valid_580295 = query.getOrDefault("quotaUser")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "quotaUser", valid_580295
  var valid_580296 = query.getOrDefault("alt")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = newJString("json"))
  if valid_580296 != nil:
    section.add "alt", valid_580296
  var valid_580297 = query.getOrDefault("oauth_token")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "oauth_token", valid_580297
  var valid_580298 = query.getOrDefault("callback")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = nil)
  if valid_580298 != nil:
    section.add "callback", valid_580298
  var valid_580299 = query.getOrDefault("access_token")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = nil)
  if valid_580299 != nil:
    section.add "access_token", valid_580299
  var valid_580300 = query.getOrDefault("uploadType")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = nil)
  if valid_580300 != nil:
    section.add "uploadType", valid_580300
  var valid_580301 = query.getOrDefault("key")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "key", valid_580301
  var valid_580302 = query.getOrDefault("$.xgafv")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = newJString("1"))
  if valid_580302 != nil:
    section.add "$.xgafv", valid_580302
  var valid_580303 = query.getOrDefault("prettyPrint")
  valid_580303 = validateParameter(valid_580303, JBool, required = false,
                                 default = newJBool(true))
  if valid_580303 != nil:
    section.add "prettyPrint", valid_580303
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

proc call*(call_580305: Call_FirestoreProjectsDatabasesDocumentsListCollectionIds_580289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the collection IDs underneath a document.
  ## 
  let valid = call_580305.validator(path, query, header, formData, body)
  let scheme = call_580305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580305.url(scheme.get, call_580305.host, call_580305.base,
                         call_580305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580305, url, valid)

proc call*(call_580306: Call_FirestoreProjectsDatabasesDocumentsListCollectionIds_580289;
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
  var path_580307 = newJObject()
  var query_580308 = newJObject()
  var body_580309 = newJObject()
  add(query_580308, "upload_protocol", newJString(uploadProtocol))
  add(query_580308, "fields", newJString(fields))
  add(query_580308, "quotaUser", newJString(quotaUser))
  add(query_580308, "alt", newJString(alt))
  add(query_580308, "oauth_token", newJString(oauthToken))
  add(query_580308, "callback", newJString(callback))
  add(query_580308, "access_token", newJString(accessToken))
  add(query_580308, "uploadType", newJString(uploadType))
  add(path_580307, "parent", newJString(parent))
  add(query_580308, "key", newJString(key))
  add(query_580308, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580309 = body
  add(query_580308, "prettyPrint", newJBool(prettyPrint))
  result = call_580306.call(path_580307, query_580308, nil, nil, body_580309)

var firestoreProjectsDatabasesDocumentsListCollectionIds* = Call_FirestoreProjectsDatabasesDocumentsListCollectionIds_580289(
    name: "firestoreProjectsDatabasesDocumentsListCollectionIds",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1beta1/{parent}:listCollectionIds",
    validator: validate_FirestoreProjectsDatabasesDocumentsListCollectionIds_580290,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsListCollectionIds_580291,
    schemes: {Scheme.Https})
type
  Call_FirestoreProjectsDatabasesDocumentsRunQuery_580310 = ref object of OpenApiRestCall_579421
proc url_FirestoreProjectsDatabasesDocumentsRunQuery_580312(protocol: Scheme;
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

proc validate_FirestoreProjectsDatabasesDocumentsRunQuery_580311(path: JsonNode;
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
  var valid_580313 = path.getOrDefault("parent")
  valid_580313 = validateParameter(valid_580313, JString, required = true,
                                 default = nil)
  if valid_580313 != nil:
    section.add "parent", valid_580313
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
  var valid_580314 = query.getOrDefault("upload_protocol")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = nil)
  if valid_580314 != nil:
    section.add "upload_protocol", valid_580314
  var valid_580315 = query.getOrDefault("fields")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "fields", valid_580315
  var valid_580316 = query.getOrDefault("quotaUser")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "quotaUser", valid_580316
  var valid_580317 = query.getOrDefault("alt")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = newJString("json"))
  if valid_580317 != nil:
    section.add "alt", valid_580317
  var valid_580318 = query.getOrDefault("oauth_token")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "oauth_token", valid_580318
  var valid_580319 = query.getOrDefault("callback")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = nil)
  if valid_580319 != nil:
    section.add "callback", valid_580319
  var valid_580320 = query.getOrDefault("access_token")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "access_token", valid_580320
  var valid_580321 = query.getOrDefault("uploadType")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "uploadType", valid_580321
  var valid_580322 = query.getOrDefault("key")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = nil)
  if valid_580322 != nil:
    section.add "key", valid_580322
  var valid_580323 = query.getOrDefault("$.xgafv")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = newJString("1"))
  if valid_580323 != nil:
    section.add "$.xgafv", valid_580323
  var valid_580324 = query.getOrDefault("prettyPrint")
  valid_580324 = validateParameter(valid_580324, JBool, required = false,
                                 default = newJBool(true))
  if valid_580324 != nil:
    section.add "prettyPrint", valid_580324
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

proc call*(call_580326: Call_FirestoreProjectsDatabasesDocumentsRunQuery_580310;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Runs a query.
  ## 
  let valid = call_580326.validator(path, query, header, formData, body)
  let scheme = call_580326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580326.url(scheme.get, call_580326.host, call_580326.base,
                         call_580326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580326, url, valid)

proc call*(call_580327: Call_FirestoreProjectsDatabasesDocumentsRunQuery_580310;
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
  var path_580328 = newJObject()
  var query_580329 = newJObject()
  var body_580330 = newJObject()
  add(query_580329, "upload_protocol", newJString(uploadProtocol))
  add(query_580329, "fields", newJString(fields))
  add(query_580329, "quotaUser", newJString(quotaUser))
  add(query_580329, "alt", newJString(alt))
  add(query_580329, "oauth_token", newJString(oauthToken))
  add(query_580329, "callback", newJString(callback))
  add(query_580329, "access_token", newJString(accessToken))
  add(query_580329, "uploadType", newJString(uploadType))
  add(path_580328, "parent", newJString(parent))
  add(query_580329, "key", newJString(key))
  add(query_580329, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580330 = body
  add(query_580329, "prettyPrint", newJBool(prettyPrint))
  result = call_580327.call(path_580328, query_580329, nil, nil, body_580330)

var firestoreProjectsDatabasesDocumentsRunQuery* = Call_FirestoreProjectsDatabasesDocumentsRunQuery_580310(
    name: "firestoreProjectsDatabasesDocumentsRunQuery",
    meth: HttpMethod.HttpPost, host: "firestore.googleapis.com",
    route: "/v1beta1/{parent}:runQuery",
    validator: validate_FirestoreProjectsDatabasesDocumentsRunQuery_580311,
    base: "/", url: url_FirestoreProjectsDatabasesDocumentsRunQuery_580312,
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
