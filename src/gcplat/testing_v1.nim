
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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
  gcpServiceName = "testing"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_TestingApplicationDetailServiceGetApkDetails_579690 = ref object of OpenApiRestCall_579421
proc url_TestingApplicationDetailServiceGetApkDetails_579692(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_TestingApplicationDetailServiceGetApkDetails_579691(path: JsonNode;
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
  var valid_579804 = query.getOrDefault("upload_protocol")
  valid_579804 = validateParameter(valid_579804, JString, required = false,
                                 default = nil)
  if valid_579804 != nil:
    section.add "upload_protocol", valid_579804
  var valid_579805 = query.getOrDefault("fields")
  valid_579805 = validateParameter(valid_579805, JString, required = false,
                                 default = nil)
  if valid_579805 != nil:
    section.add "fields", valid_579805
  var valid_579806 = query.getOrDefault("quotaUser")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "quotaUser", valid_579806
  var valid_579820 = query.getOrDefault("alt")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = newJString("json"))
  if valid_579820 != nil:
    section.add "alt", valid_579820
  var valid_579821 = query.getOrDefault("oauth_token")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "oauth_token", valid_579821
  var valid_579822 = query.getOrDefault("callback")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "callback", valid_579822
  var valid_579823 = query.getOrDefault("access_token")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "access_token", valid_579823
  var valid_579824 = query.getOrDefault("uploadType")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "uploadType", valid_579824
  var valid_579825 = query.getOrDefault("key")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "key", valid_579825
  var valid_579826 = query.getOrDefault("$.xgafv")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = newJString("1"))
  if valid_579826 != nil:
    section.add "$.xgafv", valid_579826
  var valid_579827 = query.getOrDefault("prettyPrint")
  valid_579827 = validateParameter(valid_579827, JBool, required = false,
                                 default = newJBool(true))
  if valid_579827 != nil:
    section.add "prettyPrint", valid_579827
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

proc call*(call_579851: Call_TestingApplicationDetailServiceGetApkDetails_579690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of an Android application APK.
  ## 
  let valid = call_579851.validator(path, query, header, formData, body)
  let scheme = call_579851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579851.url(scheme.get, call_579851.host, call_579851.base,
                         call_579851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579851, url, valid)

proc call*(call_579922: Call_TestingApplicationDetailServiceGetApkDetails_579690;
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
  var query_579923 = newJObject()
  var body_579925 = newJObject()
  add(query_579923, "upload_protocol", newJString(uploadProtocol))
  add(query_579923, "fields", newJString(fields))
  add(query_579923, "quotaUser", newJString(quotaUser))
  add(query_579923, "alt", newJString(alt))
  add(query_579923, "oauth_token", newJString(oauthToken))
  add(query_579923, "callback", newJString(callback))
  add(query_579923, "access_token", newJString(accessToken))
  add(query_579923, "uploadType", newJString(uploadType))
  add(query_579923, "key", newJString(key))
  add(query_579923, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579925 = body
  add(query_579923, "prettyPrint", newJBool(prettyPrint))
  result = call_579922.call(nil, query_579923, nil, nil, body_579925)

var testingApplicationDetailServiceGetApkDetails* = Call_TestingApplicationDetailServiceGetApkDetails_579690(
    name: "testingApplicationDetailServiceGetApkDetails",
    meth: HttpMethod.HttpPost, host: "testing.googleapis.com",
    route: "/v1/applicationDetailService/getApkDetails",
    validator: validate_TestingApplicationDetailServiceGetApkDetails_579691,
    base: "/", url: url_TestingApplicationDetailServiceGetApkDetails_579692,
    schemes: {Scheme.Https})
type
  Call_TestingProjectsTestMatricesCreate_579964 = ref object of OpenApiRestCall_579421
proc url_TestingProjectsTestMatricesCreate_579966(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_TestingProjectsTestMatricesCreate_579965(path: JsonNode;
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
  var valid_579981 = path.getOrDefault("projectId")
  valid_579981 = validateParameter(valid_579981, JString, required = true,
                                 default = nil)
  if valid_579981 != nil:
    section.add "projectId", valid_579981
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
  var valid_579982 = query.getOrDefault("upload_protocol")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "upload_protocol", valid_579982
  var valid_579983 = query.getOrDefault("fields")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "fields", valid_579983
  var valid_579984 = query.getOrDefault("requestId")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "requestId", valid_579984
  var valid_579985 = query.getOrDefault("quotaUser")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "quotaUser", valid_579985
  var valid_579986 = query.getOrDefault("alt")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = newJString("json"))
  if valid_579986 != nil:
    section.add "alt", valid_579986
  var valid_579987 = query.getOrDefault("oauth_token")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "oauth_token", valid_579987
  var valid_579988 = query.getOrDefault("callback")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "callback", valid_579988
  var valid_579989 = query.getOrDefault("access_token")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "access_token", valid_579989
  var valid_579990 = query.getOrDefault("uploadType")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "uploadType", valid_579990
  var valid_579991 = query.getOrDefault("key")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "key", valid_579991
  var valid_579992 = query.getOrDefault("$.xgafv")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = newJString("1"))
  if valid_579992 != nil:
    section.add "$.xgafv", valid_579992
  var valid_579993 = query.getOrDefault("prettyPrint")
  valid_579993 = validateParameter(valid_579993, JBool, required = false,
                                 default = newJBool(true))
  if valid_579993 != nil:
    section.add "prettyPrint", valid_579993
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

proc call*(call_579995: Call_TestingProjectsTestMatricesCreate_579964;
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
  let valid = call_579995.validator(path, query, header, formData, body)
  let scheme = call_579995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579995.url(scheme.get, call_579995.host, call_579995.base,
                         call_579995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579995, url, valid)

proc call*(call_579996: Call_TestingProjectsTestMatricesCreate_579964;
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
  var path_579997 = newJObject()
  var query_579998 = newJObject()
  var body_579999 = newJObject()
  add(query_579998, "upload_protocol", newJString(uploadProtocol))
  add(query_579998, "fields", newJString(fields))
  add(query_579998, "requestId", newJString(requestId))
  add(query_579998, "quotaUser", newJString(quotaUser))
  add(query_579998, "alt", newJString(alt))
  add(query_579998, "oauth_token", newJString(oauthToken))
  add(query_579998, "callback", newJString(callback))
  add(query_579998, "access_token", newJString(accessToken))
  add(query_579998, "uploadType", newJString(uploadType))
  add(query_579998, "key", newJString(key))
  add(path_579997, "projectId", newJString(projectId))
  add(query_579998, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579999 = body
  add(query_579998, "prettyPrint", newJBool(prettyPrint))
  result = call_579996.call(path_579997, query_579998, nil, nil, body_579999)

var testingProjectsTestMatricesCreate* = Call_TestingProjectsTestMatricesCreate_579964(
    name: "testingProjectsTestMatricesCreate", meth: HttpMethod.HttpPost,
    host: "testing.googleapis.com",
    route: "/v1/projects/{projectId}/testMatrices",
    validator: validate_TestingProjectsTestMatricesCreate_579965, base: "/",
    url: url_TestingProjectsTestMatricesCreate_579966, schemes: {Scheme.Https})
type
  Call_TestingProjectsTestMatricesGet_580000 = ref object of OpenApiRestCall_579421
proc url_TestingProjectsTestMatricesGet_580002(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_TestingProjectsTestMatricesGet_580001(path: JsonNode;
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
  var valid_580003 = path.getOrDefault("testMatrixId")
  valid_580003 = validateParameter(valid_580003, JString, required = true,
                                 default = nil)
  if valid_580003 != nil:
    section.add "testMatrixId", valid_580003
  var valid_580004 = path.getOrDefault("projectId")
  valid_580004 = validateParameter(valid_580004, JString, required = true,
                                 default = nil)
  if valid_580004 != nil:
    section.add "projectId", valid_580004
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
  if body != nil:
    result.add "body", body

proc call*(call_580016: Call_TestingProjectsTestMatricesGet_580000; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks the status of a test matrix.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project
  ## - INVALID_ARGUMENT - if the request is malformed
  ## - NOT_FOUND - if the Test Matrix does not exist
  ## 
  let valid = call_580016.validator(path, query, header, formData, body)
  let scheme = call_580016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580016.url(scheme.get, call_580016.host, call_580016.base,
                         call_580016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580016, url, valid)

proc call*(call_580017: Call_TestingProjectsTestMatricesGet_580000;
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
  var path_580018 = newJObject()
  var query_580019 = newJObject()
  add(query_580019, "upload_protocol", newJString(uploadProtocol))
  add(query_580019, "fields", newJString(fields))
  add(query_580019, "quotaUser", newJString(quotaUser))
  add(query_580019, "alt", newJString(alt))
  add(query_580019, "oauth_token", newJString(oauthToken))
  add(query_580019, "callback", newJString(callback))
  add(query_580019, "access_token", newJString(accessToken))
  add(query_580019, "uploadType", newJString(uploadType))
  add(path_580018, "testMatrixId", newJString(testMatrixId))
  add(query_580019, "key", newJString(key))
  add(path_580018, "projectId", newJString(projectId))
  add(query_580019, "$.xgafv", newJString(Xgafv))
  add(query_580019, "prettyPrint", newJBool(prettyPrint))
  result = call_580017.call(path_580018, query_580019, nil, nil, nil)

var testingProjectsTestMatricesGet* = Call_TestingProjectsTestMatricesGet_580000(
    name: "testingProjectsTestMatricesGet", meth: HttpMethod.HttpGet,
    host: "testing.googleapis.com",
    route: "/v1/projects/{projectId}/testMatrices/{testMatrixId}",
    validator: validate_TestingProjectsTestMatricesGet_580001, base: "/",
    url: url_TestingProjectsTestMatricesGet_580002, schemes: {Scheme.Https})
type
  Call_TestingProjectsTestMatricesCancel_580020 = ref object of OpenApiRestCall_579421
proc url_TestingProjectsTestMatricesCancel_580022(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_TestingProjectsTestMatricesCancel_580021(path: JsonNode;
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
  var valid_580023 = path.getOrDefault("testMatrixId")
  valid_580023 = validateParameter(valid_580023, JString, required = true,
                                 default = nil)
  if valid_580023 != nil:
    section.add "testMatrixId", valid_580023
  var valid_580024 = path.getOrDefault("projectId")
  valid_580024 = validateParameter(valid_580024, JString, required = true,
                                 default = nil)
  if valid_580024 != nil:
    section.add "projectId", valid_580024
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
  var valid_580025 = query.getOrDefault("upload_protocol")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "upload_protocol", valid_580025
  var valid_580026 = query.getOrDefault("fields")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "fields", valid_580026
  var valid_580027 = query.getOrDefault("quotaUser")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "quotaUser", valid_580027
  var valid_580028 = query.getOrDefault("alt")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = newJString("json"))
  if valid_580028 != nil:
    section.add "alt", valid_580028
  var valid_580029 = query.getOrDefault("oauth_token")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "oauth_token", valid_580029
  var valid_580030 = query.getOrDefault("callback")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "callback", valid_580030
  var valid_580031 = query.getOrDefault("access_token")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "access_token", valid_580031
  var valid_580032 = query.getOrDefault("uploadType")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "uploadType", valid_580032
  var valid_580033 = query.getOrDefault("key")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "key", valid_580033
  var valid_580034 = query.getOrDefault("$.xgafv")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = newJString("1"))
  if valid_580034 != nil:
    section.add "$.xgafv", valid_580034
  var valid_580035 = query.getOrDefault("prettyPrint")
  valid_580035 = validateParameter(valid_580035, JBool, required = false,
                                 default = newJBool(true))
  if valid_580035 != nil:
    section.add "prettyPrint", valid_580035
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580036: Call_TestingProjectsTestMatricesCancel_580020;
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
  let valid = call_580036.validator(path, query, header, formData, body)
  let scheme = call_580036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580036.url(scheme.get, call_580036.host, call_580036.base,
                         call_580036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580036, url, valid)

proc call*(call_580037: Call_TestingProjectsTestMatricesCancel_580020;
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
  var path_580038 = newJObject()
  var query_580039 = newJObject()
  add(query_580039, "upload_protocol", newJString(uploadProtocol))
  add(query_580039, "fields", newJString(fields))
  add(query_580039, "quotaUser", newJString(quotaUser))
  add(query_580039, "alt", newJString(alt))
  add(query_580039, "oauth_token", newJString(oauthToken))
  add(query_580039, "callback", newJString(callback))
  add(query_580039, "access_token", newJString(accessToken))
  add(query_580039, "uploadType", newJString(uploadType))
  add(path_580038, "testMatrixId", newJString(testMatrixId))
  add(query_580039, "key", newJString(key))
  add(path_580038, "projectId", newJString(projectId))
  add(query_580039, "$.xgafv", newJString(Xgafv))
  add(query_580039, "prettyPrint", newJBool(prettyPrint))
  result = call_580037.call(path_580038, query_580039, nil, nil, nil)

var testingProjectsTestMatricesCancel* = Call_TestingProjectsTestMatricesCancel_580020(
    name: "testingProjectsTestMatricesCancel", meth: HttpMethod.HttpPost,
    host: "testing.googleapis.com",
    route: "/v1/projects/{projectId}/testMatrices/{testMatrixId}:cancel",
    validator: validate_TestingProjectsTestMatricesCancel_580021, base: "/",
    url: url_TestingProjectsTestMatricesCancel_580022, schemes: {Scheme.Https})
type
  Call_TestingTestEnvironmentCatalogGet_580040 = ref object of OpenApiRestCall_579421
proc url_TestingTestEnvironmentCatalogGet_580042(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "environmentType" in path, "`environmentType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/testEnvironmentCatalog/"),
               (kind: VariableSegment, value: "environmentType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TestingTestEnvironmentCatalogGet_580041(path: JsonNode;
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
  var valid_580043 = path.getOrDefault("environmentType")
  valid_580043 = validateParameter(valid_580043, JString, required = true, default = newJString(
      "ENVIRONMENT_TYPE_UNSPECIFIED"))
  if valid_580043 != nil:
    section.add "environmentType", valid_580043
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
  var valid_580044 = query.getOrDefault("upload_protocol")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "upload_protocol", valid_580044
  var valid_580045 = query.getOrDefault("fields")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "fields", valid_580045
  var valid_580046 = query.getOrDefault("quotaUser")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "quotaUser", valid_580046
  var valid_580047 = query.getOrDefault("alt")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = newJString("json"))
  if valid_580047 != nil:
    section.add "alt", valid_580047
  var valid_580048 = query.getOrDefault("oauth_token")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "oauth_token", valid_580048
  var valid_580049 = query.getOrDefault("callback")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "callback", valid_580049
  var valid_580050 = query.getOrDefault("access_token")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "access_token", valid_580050
  var valid_580051 = query.getOrDefault("uploadType")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "uploadType", valid_580051
  var valid_580052 = query.getOrDefault("key")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "key", valid_580052
  var valid_580053 = query.getOrDefault("$.xgafv")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = newJString("1"))
  if valid_580053 != nil:
    section.add "$.xgafv", valid_580053
  var valid_580054 = query.getOrDefault("projectId")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "projectId", valid_580054
  var valid_580055 = query.getOrDefault("prettyPrint")
  valid_580055 = validateParameter(valid_580055, JBool, required = false,
                                 default = newJBool(true))
  if valid_580055 != nil:
    section.add "prettyPrint", valid_580055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580056: Call_TestingTestEnvironmentCatalogGet_580040;
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
  let valid = call_580056.validator(path, query, header, formData, body)
  let scheme = call_580056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580056.url(scheme.get, call_580056.host, call_580056.base,
                         call_580056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580056, url, valid)

proc call*(call_580057: Call_TestingTestEnvironmentCatalogGet_580040;
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
  var path_580058 = newJObject()
  var query_580059 = newJObject()
  add(query_580059, "upload_protocol", newJString(uploadProtocol))
  add(query_580059, "fields", newJString(fields))
  add(query_580059, "quotaUser", newJString(quotaUser))
  add(query_580059, "alt", newJString(alt))
  add(query_580059, "oauth_token", newJString(oauthToken))
  add(query_580059, "callback", newJString(callback))
  add(query_580059, "access_token", newJString(accessToken))
  add(query_580059, "uploadType", newJString(uploadType))
  add(query_580059, "key", newJString(key))
  add(query_580059, "$.xgafv", newJString(Xgafv))
  add(query_580059, "projectId", newJString(projectId))
  add(query_580059, "prettyPrint", newJBool(prettyPrint))
  add(path_580058, "environmentType", newJString(environmentType))
  result = call_580057.call(path_580058, query_580059, nil, nil, nil)

var testingTestEnvironmentCatalogGet* = Call_TestingTestEnvironmentCatalogGet_580040(
    name: "testingTestEnvironmentCatalogGet", meth: HttpMethod.HttpGet,
    host: "testing.googleapis.com",
    route: "/v1/testEnvironmentCatalog/{environmentType}",
    validator: validate_TestingTestEnvironmentCatalogGet_580041, base: "/",
    url: url_TestingTestEnvironmentCatalogGet_580042, schemes: {Scheme.Https})
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
