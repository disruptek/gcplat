
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
  gcpServiceName = "testing"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_TestingApplicationDetailServiceGetApkDetails_578619 = ref object of OpenApiRestCall_578348
proc url_TestingApplicationDetailServiceGetApkDetails_578621(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_TestingApplicationDetailServiceGetApkDetails_578620(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of an Android application APK.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  var valid_578733 = query.getOrDefault("key")
  valid_578733 = validateParameter(valid_578733, JString, required = false,
                                 default = nil)
  if valid_578733 != nil:
    section.add "key", valid_578733
  var valid_578747 = query.getOrDefault("prettyPrint")
  valid_578747 = validateParameter(valid_578747, JBool, required = false,
                                 default = newJBool(true))
  if valid_578747 != nil:
    section.add "prettyPrint", valid_578747
  var valid_578748 = query.getOrDefault("oauth_token")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "oauth_token", valid_578748
  var valid_578749 = query.getOrDefault("$.xgafv")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = newJString("1"))
  if valid_578749 != nil:
    section.add "$.xgafv", valid_578749
  var valid_578750 = query.getOrDefault("alt")
  valid_578750 = validateParameter(valid_578750, JString, required = false,
                                 default = newJString("json"))
  if valid_578750 != nil:
    section.add "alt", valid_578750
  var valid_578751 = query.getOrDefault("uploadType")
  valid_578751 = validateParameter(valid_578751, JString, required = false,
                                 default = nil)
  if valid_578751 != nil:
    section.add "uploadType", valid_578751
  var valid_578752 = query.getOrDefault("quotaUser")
  valid_578752 = validateParameter(valid_578752, JString, required = false,
                                 default = nil)
  if valid_578752 != nil:
    section.add "quotaUser", valid_578752
  var valid_578753 = query.getOrDefault("callback")
  valid_578753 = validateParameter(valid_578753, JString, required = false,
                                 default = nil)
  if valid_578753 != nil:
    section.add "callback", valid_578753
  var valid_578754 = query.getOrDefault("fields")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "fields", valid_578754
  var valid_578755 = query.getOrDefault("access_token")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "access_token", valid_578755
  var valid_578756 = query.getOrDefault("upload_protocol")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "upload_protocol", valid_578756
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

proc call*(call_578780: Call_TestingApplicationDetailServiceGetApkDetails_578619;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of an Android application APK.
  ## 
  let valid = call_578780.validator(path, query, header, formData, body)
  let scheme = call_578780.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578780.url(scheme.get, call_578780.host, call_578780.base,
                         call_578780.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578780, url, valid)

proc call*(call_578851: Call_TestingApplicationDetailServiceGetApkDetails_578619;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## testingApplicationDetailServiceGetApkDetails
  ## Gets the details of an Android application APK.
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578852 = newJObject()
  var body_578854 = newJObject()
  add(query_578852, "key", newJString(key))
  add(query_578852, "prettyPrint", newJBool(prettyPrint))
  add(query_578852, "oauth_token", newJString(oauthToken))
  add(query_578852, "$.xgafv", newJString(Xgafv))
  add(query_578852, "alt", newJString(alt))
  add(query_578852, "uploadType", newJString(uploadType))
  add(query_578852, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578854 = body
  add(query_578852, "callback", newJString(callback))
  add(query_578852, "fields", newJString(fields))
  add(query_578852, "access_token", newJString(accessToken))
  add(query_578852, "upload_protocol", newJString(uploadProtocol))
  result = call_578851.call(nil, query_578852, nil, nil, body_578854)

var testingApplicationDetailServiceGetApkDetails* = Call_TestingApplicationDetailServiceGetApkDetails_578619(
    name: "testingApplicationDetailServiceGetApkDetails",
    meth: HttpMethod.HttpPost, host: "testing.googleapis.com",
    route: "/v1/applicationDetailService/getApkDetails",
    validator: validate_TestingApplicationDetailServiceGetApkDetails_578620,
    base: "/", url: url_TestingApplicationDetailServiceGetApkDetails_578621,
    schemes: {Scheme.Https})
type
  Call_TestingProjectsTestMatricesCreate_578893 = ref object of OpenApiRestCall_578348
proc url_TestingProjectsTestMatricesCreate_578895(protocol: Scheme; host: string;
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

proc validate_TestingProjectsTestMatricesCreate_578894(path: JsonNode;
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
  var valid_578910 = path.getOrDefault("projectId")
  valid_578910 = validateParameter(valid_578910, JString, required = true,
                                 default = nil)
  if valid_578910 != nil:
    section.add "projectId", valid_578910
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
  ##   requestId: JString
  ##            : A string id used to detect duplicated requests.
  ## Ids are automatically scoped to a project, so
  ## users should ensure the ID is unique per-project.
  ## A UUID is recommended.
  ## 
  ## Optional, but strongly recommended.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578911 = query.getOrDefault("key")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "key", valid_578911
  var valid_578912 = query.getOrDefault("prettyPrint")
  valid_578912 = validateParameter(valid_578912, JBool, required = false,
                                 default = newJBool(true))
  if valid_578912 != nil:
    section.add "prettyPrint", valid_578912
  var valid_578913 = query.getOrDefault("oauth_token")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "oauth_token", valid_578913
  var valid_578914 = query.getOrDefault("$.xgafv")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = newJString("1"))
  if valid_578914 != nil:
    section.add "$.xgafv", valid_578914
  var valid_578915 = query.getOrDefault("alt")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = newJString("json"))
  if valid_578915 != nil:
    section.add "alt", valid_578915
  var valid_578916 = query.getOrDefault("uploadType")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "uploadType", valid_578916
  var valid_578917 = query.getOrDefault("quotaUser")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "quotaUser", valid_578917
  var valid_578918 = query.getOrDefault("callback")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "callback", valid_578918
  var valid_578919 = query.getOrDefault("requestId")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "requestId", valid_578919
  var valid_578920 = query.getOrDefault("fields")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "fields", valid_578920
  var valid_578921 = query.getOrDefault("access_token")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "access_token", valid_578921
  var valid_578922 = query.getOrDefault("upload_protocol")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "upload_protocol", valid_578922
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

proc call*(call_578924: Call_TestingProjectsTestMatricesCreate_578893;
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
  let valid = call_578924.validator(path, query, header, formData, body)
  let scheme = call_578924.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578924.url(scheme.get, call_578924.host, call_578924.base,
                         call_578924.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578924, url, valid)

proc call*(call_578925: Call_TestingProjectsTestMatricesCreate_578893;
          projectId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; requestId: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : The GCE project under which this job will run.
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
  ##   requestId: string
  ##            : A string id used to detect duplicated requests.
  ## Ids are automatically scoped to a project, so
  ## users should ensure the ID is unique per-project.
  ## A UUID is recommended.
  ## 
  ## Optional, but strongly recommended.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578926 = newJObject()
  var query_578927 = newJObject()
  var body_578928 = newJObject()
  add(query_578927, "key", newJString(key))
  add(query_578927, "prettyPrint", newJBool(prettyPrint))
  add(query_578927, "oauth_token", newJString(oauthToken))
  add(path_578926, "projectId", newJString(projectId))
  add(query_578927, "$.xgafv", newJString(Xgafv))
  add(query_578927, "alt", newJString(alt))
  add(query_578927, "uploadType", newJString(uploadType))
  add(query_578927, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578928 = body
  add(query_578927, "callback", newJString(callback))
  add(query_578927, "requestId", newJString(requestId))
  add(query_578927, "fields", newJString(fields))
  add(query_578927, "access_token", newJString(accessToken))
  add(query_578927, "upload_protocol", newJString(uploadProtocol))
  result = call_578925.call(path_578926, query_578927, nil, nil, body_578928)

var testingProjectsTestMatricesCreate* = Call_TestingProjectsTestMatricesCreate_578893(
    name: "testingProjectsTestMatricesCreate", meth: HttpMethod.HttpPost,
    host: "testing.googleapis.com",
    route: "/v1/projects/{projectId}/testMatrices",
    validator: validate_TestingProjectsTestMatricesCreate_578894, base: "/",
    url: url_TestingProjectsTestMatricesCreate_578895, schemes: {Scheme.Https})
type
  Call_TestingProjectsTestMatricesGet_578929 = ref object of OpenApiRestCall_578348
proc url_TestingProjectsTestMatricesGet_578931(protocol: Scheme; host: string;
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

proc validate_TestingProjectsTestMatricesGet_578930(path: JsonNode;
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
  ##   projectId: JString (required)
  ##            : Cloud project that owns the test matrix.
  ##   testMatrixId: JString (required)
  ##               : Unique test matrix id which was assigned by the service.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_578932 = path.getOrDefault("projectId")
  valid_578932 = validateParameter(valid_578932, JString, required = true,
                                 default = nil)
  if valid_578932 != nil:
    section.add "projectId", valid_578932
  var valid_578933 = path.getOrDefault("testMatrixId")
  valid_578933 = validateParameter(valid_578933, JString, required = true,
                                 default = nil)
  if valid_578933 != nil:
    section.add "testMatrixId", valid_578933
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
  if body != nil:
    result.add "body", body

proc call*(call_578945: Call_TestingProjectsTestMatricesGet_578929; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks the status of a test matrix.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project
  ## - INVALID_ARGUMENT - if the request is malformed
  ## - NOT_FOUND - if the Test Matrix does not exist
  ## 
  let valid = call_578945.validator(path, query, header, formData, body)
  let scheme = call_578945.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578945.url(scheme.get, call_578945.host, call_578945.base,
                         call_578945.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578945, url, valid)

proc call*(call_578946: Call_TestingProjectsTestMatricesGet_578929;
          projectId: string; testMatrixId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## testingProjectsTestMatricesGet
  ## Checks the status of a test matrix.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - PERMISSION_DENIED - if the user is not authorized to read project
  ## - INVALID_ARGUMENT - if the request is malformed
  ## - NOT_FOUND - if the Test Matrix does not exist
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Cloud project that owns the test matrix.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   testMatrixId: string (required)
  ##               : Unique test matrix id which was assigned by the service.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578947 = newJObject()
  var query_578948 = newJObject()
  add(query_578948, "key", newJString(key))
  add(query_578948, "prettyPrint", newJBool(prettyPrint))
  add(query_578948, "oauth_token", newJString(oauthToken))
  add(path_578947, "projectId", newJString(projectId))
  add(query_578948, "$.xgafv", newJString(Xgafv))
  add(query_578948, "alt", newJString(alt))
  add(query_578948, "uploadType", newJString(uploadType))
  add(query_578948, "quotaUser", newJString(quotaUser))
  add(path_578947, "testMatrixId", newJString(testMatrixId))
  add(query_578948, "callback", newJString(callback))
  add(query_578948, "fields", newJString(fields))
  add(query_578948, "access_token", newJString(accessToken))
  add(query_578948, "upload_protocol", newJString(uploadProtocol))
  result = call_578946.call(path_578947, query_578948, nil, nil, nil)

var testingProjectsTestMatricesGet* = Call_TestingProjectsTestMatricesGet_578929(
    name: "testingProjectsTestMatricesGet", meth: HttpMethod.HttpGet,
    host: "testing.googleapis.com",
    route: "/v1/projects/{projectId}/testMatrices/{testMatrixId}",
    validator: validate_TestingProjectsTestMatricesGet_578930, base: "/",
    url: url_TestingProjectsTestMatricesGet_578931, schemes: {Scheme.Https})
type
  Call_TestingProjectsTestMatricesCancel_578949 = ref object of OpenApiRestCall_578348
proc url_TestingProjectsTestMatricesCancel_578951(protocol: Scheme; host: string;
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

proc validate_TestingProjectsTestMatricesCancel_578950(path: JsonNode;
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
  ##   projectId: JString (required)
  ##            : Cloud project that owns the test.
  ##   testMatrixId: JString (required)
  ##               : Test matrix that will be canceled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_578952 = path.getOrDefault("projectId")
  valid_578952 = validateParameter(valid_578952, JString, required = true,
                                 default = nil)
  if valid_578952 != nil:
    section.add "projectId", valid_578952
  var valid_578953 = path.getOrDefault("testMatrixId")
  valid_578953 = validateParameter(valid_578953, JString, required = true,
                                 default = nil)
  if valid_578953 != nil:
    section.add "testMatrixId", valid_578953
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
  var valid_578954 = query.getOrDefault("key")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "key", valid_578954
  var valid_578955 = query.getOrDefault("prettyPrint")
  valid_578955 = validateParameter(valid_578955, JBool, required = false,
                                 default = newJBool(true))
  if valid_578955 != nil:
    section.add "prettyPrint", valid_578955
  var valid_578956 = query.getOrDefault("oauth_token")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "oauth_token", valid_578956
  var valid_578957 = query.getOrDefault("$.xgafv")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = newJString("1"))
  if valid_578957 != nil:
    section.add "$.xgafv", valid_578957
  var valid_578958 = query.getOrDefault("alt")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = newJString("json"))
  if valid_578958 != nil:
    section.add "alt", valid_578958
  var valid_578959 = query.getOrDefault("uploadType")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "uploadType", valid_578959
  var valid_578960 = query.getOrDefault("quotaUser")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "quotaUser", valid_578960
  var valid_578961 = query.getOrDefault("callback")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "callback", valid_578961
  var valid_578962 = query.getOrDefault("fields")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "fields", valid_578962
  var valid_578963 = query.getOrDefault("access_token")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "access_token", valid_578963
  var valid_578964 = query.getOrDefault("upload_protocol")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "upload_protocol", valid_578964
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578965: Call_TestingProjectsTestMatricesCancel_578949;
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
  let valid = call_578965.validator(path, query, header, formData, body)
  let scheme = call_578965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578965.url(scheme.get, call_578965.host, call_578965.base,
                         call_578965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578965, url, valid)

proc call*(call_578966: Call_TestingProjectsTestMatricesCancel_578949;
          projectId: string; testMatrixId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Cloud project that owns the test.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   testMatrixId: string (required)
  ##               : Test matrix that will be canceled.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578967 = newJObject()
  var query_578968 = newJObject()
  add(query_578968, "key", newJString(key))
  add(query_578968, "prettyPrint", newJBool(prettyPrint))
  add(query_578968, "oauth_token", newJString(oauthToken))
  add(path_578967, "projectId", newJString(projectId))
  add(query_578968, "$.xgafv", newJString(Xgafv))
  add(query_578968, "alt", newJString(alt))
  add(query_578968, "uploadType", newJString(uploadType))
  add(query_578968, "quotaUser", newJString(quotaUser))
  add(path_578967, "testMatrixId", newJString(testMatrixId))
  add(query_578968, "callback", newJString(callback))
  add(query_578968, "fields", newJString(fields))
  add(query_578968, "access_token", newJString(accessToken))
  add(query_578968, "upload_protocol", newJString(uploadProtocol))
  result = call_578966.call(path_578967, query_578968, nil, nil, nil)

var testingProjectsTestMatricesCancel* = Call_TestingProjectsTestMatricesCancel_578949(
    name: "testingProjectsTestMatricesCancel", meth: HttpMethod.HttpPost,
    host: "testing.googleapis.com",
    route: "/v1/projects/{projectId}/testMatrices/{testMatrixId}:cancel",
    validator: validate_TestingProjectsTestMatricesCancel_578950, base: "/",
    url: url_TestingProjectsTestMatricesCancel_578951, schemes: {Scheme.Https})
type
  Call_TestingTestEnvironmentCatalogGet_578969 = ref object of OpenApiRestCall_578348
proc url_TestingTestEnvironmentCatalogGet_578971(protocol: Scheme; host: string;
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

proc validate_TestingTestEnvironmentCatalogGet_578970(path: JsonNode;
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
  var valid_578972 = path.getOrDefault("environmentType")
  valid_578972 = validateParameter(valid_578972, JString, required = true, default = newJString(
      "ENVIRONMENT_TYPE_UNSPECIFIED"))
  if valid_578972 != nil:
    section.add "environmentType", valid_578972
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
  ##   projectId: JString
  ##            : For authorization, the cloud project requesting the TestEnvironmentCatalog.
  section = newJObject()
  var valid_578973 = query.getOrDefault("key")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "key", valid_578973
  var valid_578974 = query.getOrDefault("prettyPrint")
  valid_578974 = validateParameter(valid_578974, JBool, required = false,
                                 default = newJBool(true))
  if valid_578974 != nil:
    section.add "prettyPrint", valid_578974
  var valid_578975 = query.getOrDefault("oauth_token")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "oauth_token", valid_578975
  var valid_578976 = query.getOrDefault("$.xgafv")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = newJString("1"))
  if valid_578976 != nil:
    section.add "$.xgafv", valid_578976
  var valid_578977 = query.getOrDefault("alt")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = newJString("json"))
  if valid_578977 != nil:
    section.add "alt", valid_578977
  var valid_578978 = query.getOrDefault("uploadType")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "uploadType", valid_578978
  var valid_578979 = query.getOrDefault("quotaUser")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "quotaUser", valid_578979
  var valid_578980 = query.getOrDefault("callback")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "callback", valid_578980
  var valid_578981 = query.getOrDefault("fields")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "fields", valid_578981
  var valid_578982 = query.getOrDefault("access_token")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "access_token", valid_578982
  var valid_578983 = query.getOrDefault("upload_protocol")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "upload_protocol", valid_578983
  var valid_578984 = query.getOrDefault("projectId")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "projectId", valid_578984
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578985: Call_TestingTestEnvironmentCatalogGet_578969;
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
  let valid = call_578985.validator(path, query, header, formData, body)
  let scheme = call_578985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578985.url(scheme.get, call_578985.host, call_578985.base,
                         call_578985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578985, url, valid)

proc call*(call_578986: Call_TestingTestEnvironmentCatalogGet_578969;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""; projectId: string = "";
          environmentType: string = "ENVIRONMENT_TYPE_UNSPECIFIED"): Recallable =
  ## testingTestEnvironmentCatalogGet
  ## Gets the catalog of supported test environments.
  ## 
  ## May return any of the following canonical error codes:
  ## 
  ## - INVALID_ARGUMENT - if the request is malformed
  ## - NOT_FOUND - if the environment type does not exist
  ## - INTERNAL - if an internal error occurred
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
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   projectId: string
  ##            : For authorization, the cloud project requesting the TestEnvironmentCatalog.
  ##   environmentType: string (required)
  ##                  : Required. The type of environment that should be listed.
  var path_578987 = newJObject()
  var query_578988 = newJObject()
  add(query_578988, "key", newJString(key))
  add(query_578988, "prettyPrint", newJBool(prettyPrint))
  add(query_578988, "oauth_token", newJString(oauthToken))
  add(query_578988, "$.xgafv", newJString(Xgafv))
  add(query_578988, "alt", newJString(alt))
  add(query_578988, "uploadType", newJString(uploadType))
  add(query_578988, "quotaUser", newJString(quotaUser))
  add(query_578988, "callback", newJString(callback))
  add(query_578988, "fields", newJString(fields))
  add(query_578988, "access_token", newJString(accessToken))
  add(query_578988, "upload_protocol", newJString(uploadProtocol))
  add(query_578988, "projectId", newJString(projectId))
  add(path_578987, "environmentType", newJString(environmentType))
  result = call_578986.call(path_578987, query_578988, nil, nil, nil)

var testingTestEnvironmentCatalogGet* = Call_TestingTestEnvironmentCatalogGet_578969(
    name: "testingTestEnvironmentCatalogGet", meth: HttpMethod.HttpGet,
    host: "testing.googleapis.com",
    route: "/v1/testEnvironmentCatalog/{environmentType}",
    validator: validate_TestingTestEnvironmentCatalogGet_578970, base: "/",
    url: url_TestingTestEnvironmentCatalogGet_578971, schemes: {Scheme.Https})
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
