
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Cloud Testing
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Allows developers to run automated tests for their mobile applications on Google infrastructure.
## 
## https://developers.google.com/cloud-test-lab/
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
  gcpServiceName = "testing"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_TestingApplicationDetailServiceGetApkDetails_593690 = ref object of OpenApiRestCall_593421
proc url_TestingApplicationDetailServiceGetApkDetails_593692(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TestingApplicationDetailServiceGetApkDetails_593691(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of an Android application APK.
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
  var valid_593804 = query.getOrDefault("upload_protocol")
  valid_593804 = validateParameter(valid_593804, JString, required = false,
                                 default = nil)
  if valid_593804 != nil:
    section.add "upload_protocol", valid_593804
  var valid_593805 = query.getOrDefault("fields")
  valid_593805 = validateParameter(valid_593805, JString, required = false,
                                 default = nil)
  if valid_593805 != nil:
    section.add "fields", valid_593805
  var valid_593806 = query.getOrDefault("quotaUser")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "quotaUser", valid_593806
  var valid_593820 = query.getOrDefault("alt")
  valid_593820 = validateParameter(valid_593820, JString, required = false,
                                 default = newJString("json"))
  if valid_593820 != nil:
    section.add "alt", valid_593820
  var valid_593821 = query.getOrDefault("oauth_token")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = nil)
  if valid_593821 != nil:
    section.add "oauth_token", valid_593821
  var valid_593822 = query.getOrDefault("callback")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "callback", valid_593822
  var valid_593823 = query.getOrDefault("access_token")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "access_token", valid_593823
  var valid_593824 = query.getOrDefault("uploadType")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "uploadType", valid_593824
  var valid_593825 = query.getOrDefault("key")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "key", valid_593825
  var valid_593826 = query.getOrDefault("$.xgafv")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = newJString("1"))
  if valid_593826 != nil:
    section.add "$.xgafv", valid_593826
  var valid_593827 = query.getOrDefault("prettyPrint")
  valid_593827 = validateParameter(valid_593827, JBool, required = false,
                                 default = newJBool(true))
  if valid_593827 != nil:
    section.add "prettyPrint", valid_593827
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

proc call*(call_593851: Call_TestingApplicationDetailServiceGetApkDetails_593690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of an Android application APK.
  ## 
  let valid = call_593851.validator(path, query, header, formData, body)
  let scheme = call_593851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593851.url(scheme.get, call_593851.host, call_593851.base,
                         call_593851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593851, url, valid)

proc call*(call_593922: Call_TestingApplicationDetailServiceGetApkDetails_593690;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## testingApplicationDetailServiceGetApkDetails
  ## Gets the details of an Android application APK.
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
  var query_593923 = newJObject()
  var body_593925 = newJObject()
  add(query_593923, "upload_protocol", newJString(uploadProtocol))
  add(query_593923, "fields", newJString(fields))
  add(query_593923, "quotaUser", newJString(quotaUser))
  add(query_593923, "alt", newJString(alt))
  add(query_593923, "oauth_token", newJString(oauthToken))
  add(query_593923, "callback", newJString(callback))
  add(query_593923, "access_token", newJString(accessToken))
  add(query_593923, "uploadType", newJString(uploadType))
  add(query_593923, "key", newJString(key))
  add(query_593923, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593925 = body
  add(query_593923, "prettyPrint", newJBool(prettyPrint))
  result = call_593922.call(nil, query_593923, nil, nil, body_593925)

var testingApplicationDetailServiceGetApkDetails* = Call_TestingApplicationDetailServiceGetApkDetails_593690(
    name: "testingApplicationDetailServiceGetApkDetails",
    meth: HttpMethod.HttpPost, host: "testing.googleapis.com",
    route: "/v1/applicationDetailService/getApkDetails",
    validator: validate_TestingApplicationDetailServiceGetApkDetails_593691,
    base: "/", url: url_TestingApplicationDetailServiceGetApkDetails_593692,
    schemes: {Scheme.Https})
type
  Call_TestingProjectsTestMatricesCreate_593964 = ref object of OpenApiRestCall_593421
proc url_TestingProjectsTestMatricesCreate_593966(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/testMatrices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TestingProjectsTestMatricesCreate_593965(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates and runs a matrix of tests according to the given specifications.
  ## Unsupported environments will be returned in the state UNSUPPORTED.
  ## Matrices are limited to at most 200 supported executions.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project
  ## - INVALID_ARGUMENT - if the request is malformed or if the matrix expands
  ##                      to more than 200 supported executions
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : The GCE project under which this job will run.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_593981 = path.getOrDefault("projectId")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "projectId", valid_593981
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: JString
  ##            : A string id used to detect duplicated requests.
  ## Ids are automatically scoped to a project, so
  ## users should ensure the ID is unique per-project.
  ## A UUID is recommended.
  ## 
  ## Optional, but strongly recommended.
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
  var valid_593982 = query.getOrDefault("upload_protocol")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "upload_protocol", valid_593982
  var valid_593983 = query.getOrDefault("fields")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "fields", valid_593983
  var valid_593984 = query.getOrDefault("requestId")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "requestId", valid_593984
  var valid_593985 = query.getOrDefault("quotaUser")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = nil)
  if valid_593985 != nil:
    section.add "quotaUser", valid_593985
  var valid_593986 = query.getOrDefault("alt")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = newJString("json"))
  if valid_593986 != nil:
    section.add "alt", valid_593986
  var valid_593987 = query.getOrDefault("oauth_token")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "oauth_token", valid_593987
  var valid_593988 = query.getOrDefault("callback")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "callback", valid_593988
  var valid_593989 = query.getOrDefault("access_token")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "access_token", valid_593989
  var valid_593990 = query.getOrDefault("uploadType")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "uploadType", valid_593990
  var valid_593991 = query.getOrDefault("key")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "key", valid_593991
  var valid_593992 = query.getOrDefault("$.xgafv")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = newJString("1"))
  if valid_593992 != nil:
    section.add "$.xgafv", valid_593992
  var valid_593993 = query.getOrDefault("prettyPrint")
  valid_593993 = validateParameter(valid_593993, JBool, required = false,
                                 default = newJBool(true))
  if valid_593993 != nil:
    section.add "prettyPrint", valid_593993
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

proc call*(call_593995: Call_TestingProjectsTestMatricesCreate_593964;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates and runs a matrix of tests according to the given specifications.
  ## Unsupported environments will be returned in the state UNSUPPORTED.
  ## Matrices are limited to at most 200 supported executions.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project
  ## - INVALID_ARGUMENT - if the request is malformed or if the matrix expands
  ##                      to more than 200 supported executions
  ## 
  let valid = call_593995.validator(path, query, header, formData, body)
  let scheme = call_593995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593995.url(scheme.get, call_593995.host, call_593995.base,
                         call_593995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593995, url, valid)

proc call*(call_593996: Call_TestingProjectsTestMatricesCreate_593964;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          requestId: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## testingProjectsTestMatricesCreate
  ## Creates and runs a matrix of tests according to the given specifications.
  ## Unsupported environments will be returned in the state UNSUPPORTED.
  ## Matrices are limited to at most 200 supported executions.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to write to project
  ## - INVALID_ARGUMENT - if the request is malformed or if the matrix expands
  ##                      to more than 200 supported executions
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   requestId: string
  ##            : A string id used to detect duplicated requests.
  ## Ids are automatically scoped to a project, so
  ## users should ensure the ID is unique per-project.
  ## A UUID is recommended.
  ## 
  ## Optional, but strongly recommended.
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
  ##            : The GCE project under which this job will run.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_593997 = newJObject()
  var query_593998 = newJObject()
  var body_593999 = newJObject()
  add(query_593998, "upload_protocol", newJString(uploadProtocol))
  add(query_593998, "fields", newJString(fields))
  add(query_593998, "requestId", newJString(requestId))
  add(query_593998, "quotaUser", newJString(quotaUser))
  add(query_593998, "alt", newJString(alt))
  add(query_593998, "oauth_token", newJString(oauthToken))
  add(query_593998, "callback", newJString(callback))
  add(query_593998, "access_token", newJString(accessToken))
  add(query_593998, "uploadType", newJString(uploadType))
  add(query_593998, "key", newJString(key))
  add(path_593997, "projectId", newJString(projectId))
  add(query_593998, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593999 = body
  add(query_593998, "prettyPrint", newJBool(prettyPrint))
  result = call_593996.call(path_593997, query_593998, nil, nil, body_593999)

var testingProjectsTestMatricesCreate* = Call_TestingProjectsTestMatricesCreate_593964(
    name: "testingProjectsTestMatricesCreate", meth: HttpMethod.HttpPost,
    host: "testing.googleapis.com",
    route: "/v1/projects/{projectId}/testMatrices",
    validator: validate_TestingProjectsTestMatricesCreate_593965, base: "/",
    url: url_TestingProjectsTestMatricesCreate_593966, schemes: {Scheme.Https})
type
  Call_TestingProjectsTestMatricesGet_594000 = ref object of OpenApiRestCall_593421
proc url_TestingProjectsTestMatricesGet_594002(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "testMatrixId" in path, "`testMatrixId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/testMatrices/"),
               (kind: VariableSegment, value: "testMatrixId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TestingProjectsTestMatricesGet_594001(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks the status of a test matrix.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project
  ## - INVALID_ARGUMENT - if the request is malformed
  ## - NOT_FOUND - if the Test Matrix does not exist
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   testMatrixId: JString (required)
  ##               : Unique test matrix id which was assigned by the service.
  ##   projectId: JString (required)
  ##            : Cloud project that owns the test matrix.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `testMatrixId` field"
  var valid_594003 = path.getOrDefault("testMatrixId")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "testMatrixId", valid_594003
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
  if body != nil:
    result.add "body", body

proc call*(call_594016: Call_TestingProjectsTestMatricesGet_594000; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks the status of a test matrix.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project
  ## - INVALID_ARGUMENT - if the request is malformed
  ## - NOT_FOUND - if the Test Matrix does not exist
  ## 
  let valid = call_594016.validator(path, query, header, formData, body)
  let scheme = call_594016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594016.url(scheme.get, call_594016.host, call_594016.base,
                         call_594016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594016, url, valid)

proc call*(call_594017: Call_TestingProjectsTestMatricesGet_594000;
          testMatrixId: string; projectId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## testingProjectsTestMatricesGet
  ## Checks the status of a test matrix.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project
  ## - INVALID_ARGUMENT - if the request is malformed
  ## - NOT_FOUND - if the Test Matrix does not exist
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
  ##   testMatrixId: string (required)
  ##               : Unique test matrix id which was assigned by the service.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Cloud project that owns the test matrix.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594018 = newJObject()
  var query_594019 = newJObject()
  add(query_594019, "upload_protocol", newJString(uploadProtocol))
  add(query_594019, "fields", newJString(fields))
  add(query_594019, "quotaUser", newJString(quotaUser))
  add(query_594019, "alt", newJString(alt))
  add(query_594019, "oauth_token", newJString(oauthToken))
  add(query_594019, "callback", newJString(callback))
  add(query_594019, "access_token", newJString(accessToken))
  add(query_594019, "uploadType", newJString(uploadType))
  add(path_594018, "testMatrixId", newJString(testMatrixId))
  add(query_594019, "key", newJString(key))
  add(path_594018, "projectId", newJString(projectId))
  add(query_594019, "$.xgafv", newJString(Xgafv))
  add(query_594019, "prettyPrint", newJBool(prettyPrint))
  result = call_594017.call(path_594018, query_594019, nil, nil, nil)

var testingProjectsTestMatricesGet* = Call_TestingProjectsTestMatricesGet_594000(
    name: "testingProjectsTestMatricesGet", meth: HttpMethod.HttpGet,
    host: "testing.googleapis.com",
    route: "/v1/projects/{projectId}/testMatrices/{testMatrixId}",
    validator: validate_TestingProjectsTestMatricesGet_594001, base: "/",
    url: url_TestingProjectsTestMatricesGet_594002, schemes: {Scheme.Https})
type
  Call_TestingProjectsTestMatricesCancel_594020 = ref object of OpenApiRestCall_593421
proc url_TestingProjectsTestMatricesCancel_594022(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "testMatrixId" in path, "`testMatrixId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/testMatrices/"),
               (kind: VariableSegment, value: "testMatrixId"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TestingProjectsTestMatricesCancel_594021(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels unfinished test executions in a test matrix.
  ## This call returns immediately and cancellation proceeds asychronously.
  ## If the matrix is already final, this operation will have no effect.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project
  ## - INVALID_ARGUMENT - if the request is malformed
  ## - NOT_FOUND - if the Test Matrix does not exist
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   testMatrixId: JString (required)
  ##               : Test matrix that will be canceled.
  ##   projectId: JString (required)
  ##            : Cloud project that owns the test.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `testMatrixId` field"
  var valid_594023 = path.getOrDefault("testMatrixId")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "testMatrixId", valid_594023
  var valid_594024 = path.getOrDefault("projectId")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "projectId", valid_594024
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
  var valid_594025 = query.getOrDefault("upload_protocol")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "upload_protocol", valid_594025
  var valid_594026 = query.getOrDefault("fields")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "fields", valid_594026
  var valid_594027 = query.getOrDefault("quotaUser")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "quotaUser", valid_594027
  var valid_594028 = query.getOrDefault("alt")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = newJString("json"))
  if valid_594028 != nil:
    section.add "alt", valid_594028
  var valid_594029 = query.getOrDefault("oauth_token")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "oauth_token", valid_594029
  var valid_594030 = query.getOrDefault("callback")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "callback", valid_594030
  var valid_594031 = query.getOrDefault("access_token")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "access_token", valid_594031
  var valid_594032 = query.getOrDefault("uploadType")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "uploadType", valid_594032
  var valid_594033 = query.getOrDefault("key")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "key", valid_594033
  var valid_594034 = query.getOrDefault("$.xgafv")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = newJString("1"))
  if valid_594034 != nil:
    section.add "$.xgafv", valid_594034
  var valid_594035 = query.getOrDefault("prettyPrint")
  valid_594035 = validateParameter(valid_594035, JBool, required = false,
                                 default = newJBool(true))
  if valid_594035 != nil:
    section.add "prettyPrint", valid_594035
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594036: Call_TestingProjectsTestMatricesCancel_594020;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels unfinished test executions in a test matrix.
  ## This call returns immediately and cancellation proceeds asychronously.
  ## If the matrix is already final, this operation will have no effect.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project
  ## - INVALID_ARGUMENT - if the request is malformed
  ## - NOT_FOUND - if the Test Matrix does not exist
  ## 
  let valid = call_594036.validator(path, query, header, formData, body)
  let scheme = call_594036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594036.url(scheme.get, call_594036.host, call_594036.base,
                         call_594036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594036, url, valid)

proc call*(call_594037: Call_TestingProjectsTestMatricesCancel_594020;
          testMatrixId: string; projectId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## testingProjectsTestMatricesCancel
  ## Cancels unfinished test executions in a test matrix.
  ## This call returns immediately and cancellation proceeds asychronously.
  ## If the matrix is already final, this operation will have no effect.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project
  ## - INVALID_ARGUMENT - if the request is malformed
  ## - NOT_FOUND - if the Test Matrix does not exist
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
  ##   testMatrixId: string (required)
  ##               : Test matrix that will be canceled.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Cloud project that owns the test.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594038 = newJObject()
  var query_594039 = newJObject()
  add(query_594039, "upload_protocol", newJString(uploadProtocol))
  add(query_594039, "fields", newJString(fields))
  add(query_594039, "quotaUser", newJString(quotaUser))
  add(query_594039, "alt", newJString(alt))
  add(query_594039, "oauth_token", newJString(oauthToken))
  add(query_594039, "callback", newJString(callback))
  add(query_594039, "access_token", newJString(accessToken))
  add(query_594039, "uploadType", newJString(uploadType))
  add(path_594038, "testMatrixId", newJString(testMatrixId))
  add(query_594039, "key", newJString(key))
  add(path_594038, "projectId", newJString(projectId))
  add(query_594039, "$.xgafv", newJString(Xgafv))
  add(query_594039, "prettyPrint", newJBool(prettyPrint))
  result = call_594037.call(path_594038, query_594039, nil, nil, nil)

var testingProjectsTestMatricesCancel* = Call_TestingProjectsTestMatricesCancel_594020(
    name: "testingProjectsTestMatricesCancel", meth: HttpMethod.HttpPost,
    host: "testing.googleapis.com",
    route: "/v1/projects/{projectId}/testMatrices/{testMatrixId}:cancel",
    validator: validate_TestingProjectsTestMatricesCancel_594021, base: "/",
    url: url_TestingProjectsTestMatricesCancel_594022, schemes: {Scheme.Https})
type
  Call_TestingTestEnvironmentCatalogGet_594040 = ref object of OpenApiRestCall_593421
proc url_TestingTestEnvironmentCatalogGet_594042(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "environmentType" in path, "`environmentType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/testEnvironmentCatalog/"),
               (kind: VariableSegment, value: "environmentType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TestingTestEnvironmentCatalogGet_594041(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the catalog of supported test environments.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - INVALID_ARGUMENT - if the request is malformed
  ## - NOT_FOUND - if the environment type does not exist
  ## - INTERNAL - if an internal error occurred
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   environmentType: JString (required)
  ##                  : Required. The type of environment that should be listed.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `environmentType` field"
  var valid_594043 = path.getOrDefault("environmentType")
  valid_594043 = validateParameter(valid_594043, JString, required = true, default = newJString(
      "ENVIRONMENT_TYPE_UNSPECIFIED"))
  if valid_594043 != nil:
    section.add "environmentType", valid_594043
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
  ##   projectId: JString
  ##            : For authorization, the cloud project requesting the TestEnvironmentCatalog.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594044 = query.getOrDefault("upload_protocol")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "upload_protocol", valid_594044
  var valid_594045 = query.getOrDefault("fields")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = nil)
  if valid_594045 != nil:
    section.add "fields", valid_594045
  var valid_594046 = query.getOrDefault("quotaUser")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "quotaUser", valid_594046
  var valid_594047 = query.getOrDefault("alt")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = newJString("json"))
  if valid_594047 != nil:
    section.add "alt", valid_594047
  var valid_594048 = query.getOrDefault("oauth_token")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "oauth_token", valid_594048
  var valid_594049 = query.getOrDefault("callback")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = nil)
  if valid_594049 != nil:
    section.add "callback", valid_594049
  var valid_594050 = query.getOrDefault("access_token")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "access_token", valid_594050
  var valid_594051 = query.getOrDefault("uploadType")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "uploadType", valid_594051
  var valid_594052 = query.getOrDefault("key")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "key", valid_594052
  var valid_594053 = query.getOrDefault("$.xgafv")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = newJString("1"))
  if valid_594053 != nil:
    section.add "$.xgafv", valid_594053
  var valid_594054 = query.getOrDefault("projectId")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "projectId", valid_594054
  var valid_594055 = query.getOrDefault("prettyPrint")
  valid_594055 = validateParameter(valid_594055, JBool, required = false,
                                 default = newJBool(true))
  if valid_594055 != nil:
    section.add "prettyPrint", valid_594055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594056: Call_TestingTestEnvironmentCatalogGet_594040;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the catalog of supported test environments.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - INVALID_ARGUMENT - if the request is malformed
  ## - NOT_FOUND - if the environment type does not exist
  ## - INTERNAL - if an internal error occurred
  ## 
  let valid = call_594056.validator(path, query, header, formData, body)
  let scheme = call_594056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594056.url(scheme.get, call_594056.host, call_594056.base,
                         call_594056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594056, url, valid)

proc call*(call_594057: Call_TestingTestEnvironmentCatalogGet_594040;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; projectId: string = ""; prettyPrint: bool = true;
          environmentType: string = "ENVIRONMENT_TYPE_UNSPECIFIED"): Recallable =
  ## testingTestEnvironmentCatalogGet
  ## Gets the catalog of supported test environments.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - INVALID_ARGUMENT - if the request is malformed
  ## - NOT_FOUND - if the environment type does not exist
  ## - INTERNAL - if an internal error occurred
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
  ##   projectId: string
  ##            : For authorization, the cloud project requesting the TestEnvironmentCatalog.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   environmentType: string (required)
  ##                  : Required. The type of environment that should be listed.
  var path_594058 = newJObject()
  var query_594059 = newJObject()
  add(query_594059, "upload_protocol", newJString(uploadProtocol))
  add(query_594059, "fields", newJString(fields))
  add(query_594059, "quotaUser", newJString(quotaUser))
  add(query_594059, "alt", newJString(alt))
  add(query_594059, "oauth_token", newJString(oauthToken))
  add(query_594059, "callback", newJString(callback))
  add(query_594059, "access_token", newJString(accessToken))
  add(query_594059, "uploadType", newJString(uploadType))
  add(query_594059, "key", newJString(key))
  add(query_594059, "$.xgafv", newJString(Xgafv))
  add(query_594059, "projectId", newJString(projectId))
  add(query_594059, "prettyPrint", newJBool(prettyPrint))
  add(path_594058, "environmentType", newJString(environmentType))
  result = call_594057.call(path_594058, query_594059, nil, nil, nil)

var testingTestEnvironmentCatalogGet* = Call_TestingTestEnvironmentCatalogGet_594040(
    name: "testingTestEnvironmentCatalogGet", meth: HttpMethod.HttpGet,
    host: "testing.googleapis.com",
    route: "/v1/testEnvironmentCatalog/{environmentType}",
    validator: validate_TestingTestEnvironmentCatalogGet_594041, base: "/",
    url: url_TestingTestEnvironmentCatalogGet_594042, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
