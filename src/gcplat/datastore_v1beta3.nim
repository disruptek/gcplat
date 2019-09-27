
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  gcpServiceName = "datastore"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DatastoreProjectsAllocateIds_593690 = ref object of OpenApiRestCall_593421
proc url_DatastoreProjectsAllocateIds_593692(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DatastoreProjectsAllocateIds_593691(path: JsonNode; query: JsonNode;
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
  var valid_593818 = path.getOrDefault("projectId")
  valid_593818 = validateParameter(valid_593818, JString, required = true,
                                 default = nil)
  if valid_593818 != nil:
    section.add "projectId", valid_593818
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

proc call*(call_593866: Call_DatastoreProjectsAllocateIds_593690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Allocates IDs for the given keys, which is useful for referencing an entity
  ## before it is inserted.
  ## 
  let valid = call_593866.validator(path, query, header, formData, body)
  let scheme = call_593866.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593866.url(scheme.get, call_593866.host, call_593866.base,
                         call_593866.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593866, url, valid)

proc call*(call_593937: Call_DatastoreProjectsAllocateIds_593690;
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
  add(path_593938, "projectId", newJString(projectId))
  add(query_593940, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593941 = body
  add(query_593940, "prettyPrint", newJBool(prettyPrint))
  result = call_593937.call(path_593938, query_593940, nil, nil, body_593941)

var datastoreProjectsAllocateIds* = Call_DatastoreProjectsAllocateIds_593690(
    name: "datastoreProjectsAllocateIds", meth: HttpMethod.HttpPost,
    host: "datastore.googleapis.com",
    route: "/v1beta3/projects/{projectId}:allocateIds",
    validator: validate_DatastoreProjectsAllocateIds_593691, base: "/",
    url: url_DatastoreProjectsAllocateIds_593692, schemes: {Scheme.Https})
type
  Call_DatastoreProjectsBeginTransaction_593980 = ref object of OpenApiRestCall_593421
proc url_DatastoreProjectsBeginTransaction_593982(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DatastoreProjectsBeginTransaction_593981(path: JsonNode;
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
  var valid_593983 = path.getOrDefault("projectId")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "projectId", valid_593983
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

proc call*(call_593996: Call_DatastoreProjectsBeginTransaction_593980;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Begins a new transaction.
  ## 
  let valid = call_593996.validator(path, query, header, formData, body)
  let scheme = call_593996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593996.url(scheme.get, call_593996.host, call_593996.base,
                         call_593996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593996, url, valid)

proc call*(call_593997: Call_DatastoreProjectsBeginTransaction_593980;
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
  add(path_593998, "projectId", newJString(projectId))
  add(query_593999, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594000 = body
  add(query_593999, "prettyPrint", newJBool(prettyPrint))
  result = call_593997.call(path_593998, query_593999, nil, nil, body_594000)

var datastoreProjectsBeginTransaction* = Call_DatastoreProjectsBeginTransaction_593980(
    name: "datastoreProjectsBeginTransaction", meth: HttpMethod.HttpPost,
    host: "datastore.googleapis.com",
    route: "/v1beta3/projects/{projectId}:beginTransaction",
    validator: validate_DatastoreProjectsBeginTransaction_593981, base: "/",
    url: url_DatastoreProjectsBeginTransaction_593982, schemes: {Scheme.Https})
type
  Call_DatastoreProjectsCommit_594001 = ref object of OpenApiRestCall_593421
proc url_DatastoreProjectsCommit_594003(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DatastoreProjectsCommit_594002(path: JsonNode; query: JsonNode;
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
  var valid_594004 = path.getOrDefault("projectId")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "projectId", valid_594004
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

proc call*(call_594017: Call_DatastoreProjectsCommit_594001; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Commits a transaction, optionally creating, deleting or modifying some
  ## entities.
  ## 
  let valid = call_594017.validator(path, query, header, formData, body)
  let scheme = call_594017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594017.url(scheme.get, call_594017.host, call_594017.base,
                         call_594017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594017, url, valid)

proc call*(call_594018: Call_DatastoreProjectsCommit_594001; projectId: string;
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
  add(path_594019, "projectId", newJString(projectId))
  add(query_594020, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594021 = body
  add(query_594020, "prettyPrint", newJBool(prettyPrint))
  result = call_594018.call(path_594019, query_594020, nil, nil, body_594021)

var datastoreProjectsCommit* = Call_DatastoreProjectsCommit_594001(
    name: "datastoreProjectsCommit", meth: HttpMethod.HttpPost,
    host: "datastore.googleapis.com",
    route: "/v1beta3/projects/{projectId}:commit",
    validator: validate_DatastoreProjectsCommit_594002, base: "/",
    url: url_DatastoreProjectsCommit_594003, schemes: {Scheme.Https})
type
  Call_DatastoreProjectsLookup_594022 = ref object of OpenApiRestCall_593421
proc url_DatastoreProjectsLookup_594024(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DatastoreProjectsLookup_594023(path: JsonNode; query: JsonNode;
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
  var valid_594025 = path.getOrDefault("projectId")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "projectId", valid_594025
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

proc call*(call_594038: Call_DatastoreProjectsLookup_594022; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Looks up entities by key.
  ## 
  let valid = call_594038.validator(path, query, header, formData, body)
  let scheme = call_594038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594038.url(scheme.get, call_594038.host, call_594038.base,
                         call_594038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594038, url, valid)

proc call*(call_594039: Call_DatastoreProjectsLookup_594022; projectId: string;
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
  add(path_594040, "projectId", newJString(projectId))
  add(query_594041, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594042 = body
  add(query_594041, "prettyPrint", newJBool(prettyPrint))
  result = call_594039.call(path_594040, query_594041, nil, nil, body_594042)

var datastoreProjectsLookup* = Call_DatastoreProjectsLookup_594022(
    name: "datastoreProjectsLookup", meth: HttpMethod.HttpPost,
    host: "datastore.googleapis.com",
    route: "/v1beta3/projects/{projectId}:lookup",
    validator: validate_DatastoreProjectsLookup_594023, base: "/",
    url: url_DatastoreProjectsLookup_594024, schemes: {Scheme.Https})
type
  Call_DatastoreProjectsReserveIds_594043 = ref object of OpenApiRestCall_593421
proc url_DatastoreProjectsReserveIds_594045(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DatastoreProjectsReserveIds_594044(path: JsonNode; query: JsonNode;
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
  var valid_594046 = path.getOrDefault("projectId")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "projectId", valid_594046
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

proc call*(call_594059: Call_DatastoreProjectsReserveIds_594043; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Prevents the supplied keys' IDs from being auto-allocated by Cloud
  ## Datastore.
  ## 
  let valid = call_594059.validator(path, query, header, formData, body)
  let scheme = call_594059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594059.url(scheme.get, call_594059.host, call_594059.base,
                         call_594059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594059, url, valid)

proc call*(call_594060: Call_DatastoreProjectsReserveIds_594043; projectId: string;
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
  add(path_594061, "projectId", newJString(projectId))
  add(query_594062, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594063 = body
  add(query_594062, "prettyPrint", newJBool(prettyPrint))
  result = call_594060.call(path_594061, query_594062, nil, nil, body_594063)

var datastoreProjectsReserveIds* = Call_DatastoreProjectsReserveIds_594043(
    name: "datastoreProjectsReserveIds", meth: HttpMethod.HttpPost,
    host: "datastore.googleapis.com",
    route: "/v1beta3/projects/{projectId}:reserveIds",
    validator: validate_DatastoreProjectsReserveIds_594044, base: "/",
    url: url_DatastoreProjectsReserveIds_594045, schemes: {Scheme.Https})
type
  Call_DatastoreProjectsRollback_594064 = ref object of OpenApiRestCall_593421
proc url_DatastoreProjectsRollback_594066(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DatastoreProjectsRollback_594065(path: JsonNode; query: JsonNode;
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
  var valid_594067 = path.getOrDefault("projectId")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "projectId", valid_594067
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

proc call*(call_594080: Call_DatastoreProjectsRollback_594064; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rolls back a transaction.
  ## 
  let valid = call_594080.validator(path, query, header, formData, body)
  let scheme = call_594080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594080.url(scheme.get, call_594080.host, call_594080.base,
                         call_594080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594080, url, valid)

proc call*(call_594081: Call_DatastoreProjectsRollback_594064; projectId: string;
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
  add(path_594082, "projectId", newJString(projectId))
  add(query_594083, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594084 = body
  add(query_594083, "prettyPrint", newJBool(prettyPrint))
  result = call_594081.call(path_594082, query_594083, nil, nil, body_594084)

var datastoreProjectsRollback* = Call_DatastoreProjectsRollback_594064(
    name: "datastoreProjectsRollback", meth: HttpMethod.HttpPost,
    host: "datastore.googleapis.com",
    route: "/v1beta3/projects/{projectId}:rollback",
    validator: validate_DatastoreProjectsRollback_594065, base: "/",
    url: url_DatastoreProjectsRollback_594066, schemes: {Scheme.Https})
type
  Call_DatastoreProjectsRunQuery_594085 = ref object of OpenApiRestCall_593421
proc url_DatastoreProjectsRunQuery_594087(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_DatastoreProjectsRunQuery_594086(path: JsonNode; query: JsonNode;
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
  var valid_594088 = path.getOrDefault("projectId")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "projectId", valid_594088
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
  var valid_594093 = query.getOrDefault("oauth_token")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "oauth_token", valid_594093
  var valid_594094 = query.getOrDefault("callback")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "callback", valid_594094
  var valid_594095 = query.getOrDefault("access_token")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "access_token", valid_594095
  var valid_594096 = query.getOrDefault("uploadType")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = nil)
  if valid_594096 != nil:
    section.add "uploadType", valid_594096
  var valid_594097 = query.getOrDefault("key")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "key", valid_594097
  var valid_594098 = query.getOrDefault("$.xgafv")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = newJString("1"))
  if valid_594098 != nil:
    section.add "$.xgafv", valid_594098
  var valid_594099 = query.getOrDefault("prettyPrint")
  valid_594099 = validateParameter(valid_594099, JBool, required = false,
                                 default = newJBool(true))
  if valid_594099 != nil:
    section.add "prettyPrint", valid_594099
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

proc call*(call_594101: Call_DatastoreProjectsRunQuery_594085; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Queries for entities.
  ## 
  let valid = call_594101.validator(path, query, header, formData, body)
  let scheme = call_594101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594101.url(scheme.get, call_594101.host, call_594101.base,
                         call_594101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594101, url, valid)

proc call*(call_594102: Call_DatastoreProjectsRunQuery_594085; projectId: string;
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
  var path_594103 = newJObject()
  var query_594104 = newJObject()
  var body_594105 = newJObject()
  add(query_594104, "upload_protocol", newJString(uploadProtocol))
  add(query_594104, "fields", newJString(fields))
  add(query_594104, "quotaUser", newJString(quotaUser))
  add(query_594104, "alt", newJString(alt))
  add(query_594104, "oauth_token", newJString(oauthToken))
  add(query_594104, "callback", newJString(callback))
  add(query_594104, "access_token", newJString(accessToken))
  add(query_594104, "uploadType", newJString(uploadType))
  add(query_594104, "key", newJString(key))
  add(path_594103, "projectId", newJString(projectId))
  add(query_594104, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594105 = body
  add(query_594104, "prettyPrint", newJBool(prettyPrint))
  result = call_594102.call(path_594103, query_594104, nil, nil, body_594105)

var datastoreProjectsRunQuery* = Call_DatastoreProjectsRunQuery_594085(
    name: "datastoreProjectsRunQuery", meth: HttpMethod.HttpPost,
    host: "datastore.googleapis.com",
    route: "/v1beta3/projects/{projectId}:runQuery",
    validator: validate_DatastoreProjectsRunQuery_594086, base: "/",
    url: url_DatastoreProjectsRunQuery_594087, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
