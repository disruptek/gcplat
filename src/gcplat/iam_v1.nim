
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Identity and Access Management (IAM)
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Manages identity and access control for Google Cloud Platform resources, including the creation of service accounts, which you can use to authenticate to Google and make API calls.
## 
## https://cloud.google.com/iam/
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
  gcpServiceName = "iam"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_IamIamPoliciesLintPolicy_593690 = ref object of OpenApiRestCall_593421
proc url_IamIamPoliciesLintPolicy_593692(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IamIamPoliciesLintPolicy_593691(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lints a Cloud IAM policy object or its sub fields. Currently supports
  ## google.iam.v1.Policy, google.iam.v1.Binding and
  ## google.iam.v1.Binding.condition.
  ## 
  ## Each lint operation consists of multiple lint validation units.
  ## Validation units have the following properties:
  ## 
  ## - Each unit inspects the input object in regard to a particular
  ##   linting aspect and issues a google.iam.admin.v1.LintResult
  ##   disclosing the result.
  ## - Domain of discourse of each unit can be either
  ##   google.iam.v1.Policy, google.iam.v1.Binding, or
  ##   google.iam.v1.Binding.condition depending on the purpose of the
  ##   validation.
  ## - A unit may require additional data (like the list of all possible
  ##   enumerable values of a particular attribute used in the policy instance)
  ##   which shall be provided by the caller. Refer to the comments of
  ##   google.iam.admin.v1.LintPolicyRequest.context for more details.
  ## 
  ## The set of applicable validation units is determined by the Cloud IAM
  ## server and is not configurable.
  ## 
  ## Regardless of any lint issues or their severities, successful calls to
  ## `lintPolicy` return an HTTP 200 OK status code.
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

proc call*(call_593851: Call_IamIamPoliciesLintPolicy_593690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lints a Cloud IAM policy object or its sub fields. Currently supports
  ## google.iam.v1.Policy, google.iam.v1.Binding and
  ## google.iam.v1.Binding.condition.
  ## 
  ## Each lint operation consists of multiple lint validation units.
  ## Validation units have the following properties:
  ## 
  ## - Each unit inspects the input object in regard to a particular
  ##   linting aspect and issues a google.iam.admin.v1.LintResult
  ##   disclosing the result.
  ## - Domain of discourse of each unit can be either
  ##   google.iam.v1.Policy, google.iam.v1.Binding, or
  ##   google.iam.v1.Binding.condition depending on the purpose of the
  ##   validation.
  ## - A unit may require additional data (like the list of all possible
  ##   enumerable values of a particular attribute used in the policy instance)
  ##   which shall be provided by the caller. Refer to the comments of
  ##   google.iam.admin.v1.LintPolicyRequest.context for more details.
  ## 
  ## The set of applicable validation units is determined by the Cloud IAM
  ## server and is not configurable.
  ## 
  ## Regardless of any lint issues or their severities, successful calls to
  ## `lintPolicy` return an HTTP 200 OK status code.
  ## 
  let valid = call_593851.validator(path, query, header, formData, body)
  let scheme = call_593851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593851.url(scheme.get, call_593851.host, call_593851.base,
                         call_593851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593851, url, valid)

proc call*(call_593922: Call_IamIamPoliciesLintPolicy_593690;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## iamIamPoliciesLintPolicy
  ## Lints a Cloud IAM policy object or its sub fields. Currently supports
  ## google.iam.v1.Policy, google.iam.v1.Binding and
  ## google.iam.v1.Binding.condition.
  ## 
  ## Each lint operation consists of multiple lint validation units.
  ## Validation units have the following properties:
  ## 
  ## - Each unit inspects the input object in regard to a particular
  ##   linting aspect and issues a google.iam.admin.v1.LintResult
  ##   disclosing the result.
  ## - Domain of discourse of each unit can be either
  ##   google.iam.v1.Policy, google.iam.v1.Binding, or
  ##   google.iam.v1.Binding.condition depending on the purpose of the
  ##   validation.
  ## - A unit may require additional data (like the list of all possible
  ##   enumerable values of a particular attribute used in the policy instance)
  ##   which shall be provided by the caller. Refer to the comments of
  ##   google.iam.admin.v1.LintPolicyRequest.context for more details.
  ## 
  ## The set of applicable validation units is determined by the Cloud IAM
  ## server and is not configurable.
  ## 
  ## Regardless of any lint issues or their severities, successful calls to
  ## `lintPolicy` return an HTTP 200 OK status code.
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

var iamIamPoliciesLintPolicy* = Call_IamIamPoliciesLintPolicy_593690(
    name: "iamIamPoliciesLintPolicy", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/iamPolicies:lintPolicy",
    validator: validate_IamIamPoliciesLintPolicy_593691, base: "/",
    url: url_IamIamPoliciesLintPolicy_593692, schemes: {Scheme.Https})
type
  Call_IamIamPoliciesQueryAuditableServices_593964 = ref object of OpenApiRestCall_593421
proc url_IamIamPoliciesQueryAuditableServices_593966(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IamIamPoliciesQueryAuditableServices_593965(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of services that support service level audit logging
  ## configuration for the given resource.
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
  var valid_593967 = query.getOrDefault("upload_protocol")
  valid_593967 = validateParameter(valid_593967, JString, required = false,
                                 default = nil)
  if valid_593967 != nil:
    section.add "upload_protocol", valid_593967
  var valid_593968 = query.getOrDefault("fields")
  valid_593968 = validateParameter(valid_593968, JString, required = false,
                                 default = nil)
  if valid_593968 != nil:
    section.add "fields", valid_593968
  var valid_593969 = query.getOrDefault("quotaUser")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = nil)
  if valid_593969 != nil:
    section.add "quotaUser", valid_593969
  var valid_593970 = query.getOrDefault("alt")
  valid_593970 = validateParameter(valid_593970, JString, required = false,
                                 default = newJString("json"))
  if valid_593970 != nil:
    section.add "alt", valid_593970
  var valid_593971 = query.getOrDefault("oauth_token")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "oauth_token", valid_593971
  var valid_593972 = query.getOrDefault("callback")
  valid_593972 = validateParameter(valid_593972, JString, required = false,
                                 default = nil)
  if valid_593972 != nil:
    section.add "callback", valid_593972
  var valid_593973 = query.getOrDefault("access_token")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = nil)
  if valid_593973 != nil:
    section.add "access_token", valid_593973
  var valid_593974 = query.getOrDefault("uploadType")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = nil)
  if valid_593974 != nil:
    section.add "uploadType", valid_593974
  var valid_593975 = query.getOrDefault("key")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "key", valid_593975
  var valid_593976 = query.getOrDefault("$.xgafv")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = newJString("1"))
  if valid_593976 != nil:
    section.add "$.xgafv", valid_593976
  var valid_593977 = query.getOrDefault("prettyPrint")
  valid_593977 = validateParameter(valid_593977, JBool, required = false,
                                 default = newJBool(true))
  if valid_593977 != nil:
    section.add "prettyPrint", valid_593977
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

proc call*(call_593979: Call_IamIamPoliciesQueryAuditableServices_593964;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of services that support service level audit logging
  ## configuration for the given resource.
  ## 
  let valid = call_593979.validator(path, query, header, formData, body)
  let scheme = call_593979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593979.url(scheme.get, call_593979.host, call_593979.base,
                         call_593979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593979, url, valid)

proc call*(call_593980: Call_IamIamPoliciesQueryAuditableServices_593964;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## iamIamPoliciesQueryAuditableServices
  ## Returns a list of services that support service level audit logging
  ## configuration for the given resource.
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
  var query_593981 = newJObject()
  var body_593982 = newJObject()
  add(query_593981, "upload_protocol", newJString(uploadProtocol))
  add(query_593981, "fields", newJString(fields))
  add(query_593981, "quotaUser", newJString(quotaUser))
  add(query_593981, "alt", newJString(alt))
  add(query_593981, "oauth_token", newJString(oauthToken))
  add(query_593981, "callback", newJString(callback))
  add(query_593981, "access_token", newJString(accessToken))
  add(query_593981, "uploadType", newJString(uploadType))
  add(query_593981, "key", newJString(key))
  add(query_593981, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593982 = body
  add(query_593981, "prettyPrint", newJBool(prettyPrint))
  result = call_593980.call(nil, query_593981, nil, nil, body_593982)

var iamIamPoliciesQueryAuditableServices* = Call_IamIamPoliciesQueryAuditableServices_593964(
    name: "iamIamPoliciesQueryAuditableServices", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/iamPolicies:queryAuditableServices",
    validator: validate_IamIamPoliciesQueryAuditableServices_593965, base: "/",
    url: url_IamIamPoliciesQueryAuditableServices_593966, schemes: {Scheme.Https})
type
  Call_IamPermissionsQueryTestablePermissions_593983 = ref object of OpenApiRestCall_593421
proc url_IamPermissionsQueryTestablePermissions_593985(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IamPermissionsQueryTestablePermissions_593984(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the permissions testable on a resource.
  ## A permission is testable if it can be tested for an identity on a resource.
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
  var valid_593986 = query.getOrDefault("upload_protocol")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "upload_protocol", valid_593986
  var valid_593987 = query.getOrDefault("fields")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "fields", valid_593987
  var valid_593988 = query.getOrDefault("quotaUser")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "quotaUser", valid_593988
  var valid_593989 = query.getOrDefault("alt")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = newJString("json"))
  if valid_593989 != nil:
    section.add "alt", valid_593989
  var valid_593990 = query.getOrDefault("oauth_token")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "oauth_token", valid_593990
  var valid_593991 = query.getOrDefault("callback")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "callback", valid_593991
  var valid_593992 = query.getOrDefault("access_token")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "access_token", valid_593992
  var valid_593993 = query.getOrDefault("uploadType")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "uploadType", valid_593993
  var valid_593994 = query.getOrDefault("key")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "key", valid_593994
  var valid_593995 = query.getOrDefault("$.xgafv")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = newJString("1"))
  if valid_593995 != nil:
    section.add "$.xgafv", valid_593995
  var valid_593996 = query.getOrDefault("prettyPrint")
  valid_593996 = validateParameter(valid_593996, JBool, required = false,
                                 default = newJBool(true))
  if valid_593996 != nil:
    section.add "prettyPrint", valid_593996
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

proc call*(call_593998: Call_IamPermissionsQueryTestablePermissions_593983;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the permissions testable on a resource.
  ## A permission is testable if it can be tested for an identity on a resource.
  ## 
  let valid = call_593998.validator(path, query, header, formData, body)
  let scheme = call_593998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593998.url(scheme.get, call_593998.host, call_593998.base,
                         call_593998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593998, url, valid)

proc call*(call_593999: Call_IamPermissionsQueryTestablePermissions_593983;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## iamPermissionsQueryTestablePermissions
  ## Lists the permissions testable on a resource.
  ## A permission is testable if it can be tested for an identity on a resource.
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
  var query_594000 = newJObject()
  var body_594001 = newJObject()
  add(query_594000, "upload_protocol", newJString(uploadProtocol))
  add(query_594000, "fields", newJString(fields))
  add(query_594000, "quotaUser", newJString(quotaUser))
  add(query_594000, "alt", newJString(alt))
  add(query_594000, "oauth_token", newJString(oauthToken))
  add(query_594000, "callback", newJString(callback))
  add(query_594000, "access_token", newJString(accessToken))
  add(query_594000, "uploadType", newJString(uploadType))
  add(query_594000, "key", newJString(key))
  add(query_594000, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594001 = body
  add(query_594000, "prettyPrint", newJBool(prettyPrint))
  result = call_593999.call(nil, query_594000, nil, nil, body_594001)

var iamPermissionsQueryTestablePermissions* = Call_IamPermissionsQueryTestablePermissions_593983(
    name: "iamPermissionsQueryTestablePermissions", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/permissions:queryTestablePermissions",
    validator: validate_IamPermissionsQueryTestablePermissions_593984, base: "/",
    url: url_IamPermissionsQueryTestablePermissions_593985,
    schemes: {Scheme.Https})
type
  Call_IamRolesList_594002 = ref object of OpenApiRestCall_593421
proc url_IamRolesList_594004(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IamRolesList_594003(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Roles defined on a resource.
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
  ##   pageToken: JString
  ##            : Optional pagination token returned in an earlier ListRolesResponse.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: JString
  ##       : Optional view for the returned Role objects. When `FULL` is specified,
  ## the `includedPermissions` field is returned, which includes a list of all
  ## permissions in the role. The default value is `BASIC`, which does not
  ## return the `includedPermissions` field.
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
  ##   parent: JString
  ##         : The `parent` parameter's value depends on the target resource for the
  ## request, namely
  ## [`roles`](/iam/reference/rest/v1/roles),
  ## [`projects`](/iam/reference/rest/v1/projects.roles), or
  ## [`organizations`](/iam/reference/rest/v1/organizations.roles). Each
  ## resource type's `parent` value format is described below:
  ## 
  ## * [`roles.list()`](/iam/reference/rest/v1/roles/list): An empty string.
  ##   This method doesn't require a resource; it simply returns all
  ##   [predefined roles](/iam/docs/understanding-roles#predefined_roles) in
  ##   Cloud IAM. Example request URL:
  ##   `https://iam.googleapis.com/v1/roles`
  ## 
  ## * [`projects.roles.list()`](/iam/reference/rest/v1/projects.roles/list):
  ##   `projects/{PROJECT_ID}`. This method lists all project-level
  ##   [custom roles](/iam/docs/understanding-custom-roles).
  ##   Example request URL:
  ##   `https://iam.googleapis.com/v1/projects/{PROJECT_ID}/roles`
  ## 
  ## * 
  ## [`organizations.roles.list()`](/iam/reference/rest/v1/organizations.roles/list):
  ##   `organizations/{ORGANIZATION_ID}`. This method lists all
  ##   organization-level [custom roles](/iam/docs/understanding-custom-roles).
  ##   Example request URL:
  ##   `https://iam.googleapis.com/v1/organizations/{ORGANIZATION_ID}/roles`
  ## 
  ## Note: Wildcard (*) values are invalid; you must specify a complete project
  ## ID or organization ID.
  ##   showDeleted: JBool
  ##              : Include Roles that have been deleted.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional limit on the number of roles to include in the response.
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
  var valid_594007 = query.getOrDefault("pageToken")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "pageToken", valid_594007
  var valid_594008 = query.getOrDefault("quotaUser")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "quotaUser", valid_594008
  var valid_594009 = query.getOrDefault("view")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_594009 != nil:
    section.add "view", valid_594009
  var valid_594010 = query.getOrDefault("alt")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = newJString("json"))
  if valid_594010 != nil:
    section.add "alt", valid_594010
  var valid_594011 = query.getOrDefault("oauth_token")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "oauth_token", valid_594011
  var valid_594012 = query.getOrDefault("callback")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "callback", valid_594012
  var valid_594013 = query.getOrDefault("access_token")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "access_token", valid_594013
  var valid_594014 = query.getOrDefault("uploadType")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "uploadType", valid_594014
  var valid_594015 = query.getOrDefault("parent")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "parent", valid_594015
  var valid_594016 = query.getOrDefault("showDeleted")
  valid_594016 = validateParameter(valid_594016, JBool, required = false, default = nil)
  if valid_594016 != nil:
    section.add "showDeleted", valid_594016
  var valid_594017 = query.getOrDefault("key")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "key", valid_594017
  var valid_594018 = query.getOrDefault("$.xgafv")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = newJString("1"))
  if valid_594018 != nil:
    section.add "$.xgafv", valid_594018
  var valid_594019 = query.getOrDefault("pageSize")
  valid_594019 = validateParameter(valid_594019, JInt, required = false, default = nil)
  if valid_594019 != nil:
    section.add "pageSize", valid_594019
  var valid_594020 = query.getOrDefault("prettyPrint")
  valid_594020 = validateParameter(valid_594020, JBool, required = false,
                                 default = newJBool(true))
  if valid_594020 != nil:
    section.add "prettyPrint", valid_594020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594021: Call_IamRolesList_594002; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Roles defined on a resource.
  ## 
  let valid = call_594021.validator(path, query, header, formData, body)
  let scheme = call_594021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594021.url(scheme.get, call_594021.host, call_594021.base,
                         call_594021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594021, url, valid)

proc call*(call_594022: Call_IamRolesList_594002; uploadProtocol: string = "";
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          view: string = "BASIC"; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          parent: string = ""; showDeleted: bool = false; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## iamRolesList
  ## Lists the Roles defined on a resource.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional pagination token returned in an earlier ListRolesResponse.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: string
  ##       : Optional view for the returned Role objects. When `FULL` is specified,
  ## the `includedPermissions` field is returned, which includes a list of all
  ## permissions in the role. The default value is `BASIC`, which does not
  ## return the `includedPermissions` field.
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
  ##   parent: string
  ##         : The `parent` parameter's value depends on the target resource for the
  ## request, namely
  ## [`roles`](/iam/reference/rest/v1/roles),
  ## [`projects`](/iam/reference/rest/v1/projects.roles), or
  ## [`organizations`](/iam/reference/rest/v1/organizations.roles). Each
  ## resource type's `parent` value format is described below:
  ## 
  ## * [`roles.list()`](/iam/reference/rest/v1/roles/list): An empty string.
  ##   This method doesn't require a resource; it simply returns all
  ##   [predefined roles](/iam/docs/understanding-roles#predefined_roles) in
  ##   Cloud IAM. Example request URL:
  ##   `https://iam.googleapis.com/v1/roles`
  ## 
  ## * [`projects.roles.list()`](/iam/reference/rest/v1/projects.roles/list):
  ##   `projects/{PROJECT_ID}`. This method lists all project-level
  ##   [custom roles](/iam/docs/understanding-custom-roles).
  ##   Example request URL:
  ##   `https://iam.googleapis.com/v1/projects/{PROJECT_ID}/roles`
  ## 
  ## * 
  ## [`organizations.roles.list()`](/iam/reference/rest/v1/organizations.roles/list):
  ##   `organizations/{ORGANIZATION_ID}`. This method lists all
  ##   organization-level [custom roles](/iam/docs/understanding-custom-roles).
  ##   Example request URL:
  ##   `https://iam.googleapis.com/v1/organizations/{ORGANIZATION_ID}/roles`
  ## 
  ## Note: Wildcard (*) values are invalid; you must specify a complete project
  ## ID or organization ID.
  ##   showDeleted: bool
  ##              : Include Roles that have been deleted.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional limit on the number of roles to include in the response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594023 = newJObject()
  add(query_594023, "upload_protocol", newJString(uploadProtocol))
  add(query_594023, "fields", newJString(fields))
  add(query_594023, "pageToken", newJString(pageToken))
  add(query_594023, "quotaUser", newJString(quotaUser))
  add(query_594023, "view", newJString(view))
  add(query_594023, "alt", newJString(alt))
  add(query_594023, "oauth_token", newJString(oauthToken))
  add(query_594023, "callback", newJString(callback))
  add(query_594023, "access_token", newJString(accessToken))
  add(query_594023, "uploadType", newJString(uploadType))
  add(query_594023, "parent", newJString(parent))
  add(query_594023, "showDeleted", newJBool(showDeleted))
  add(query_594023, "key", newJString(key))
  add(query_594023, "$.xgafv", newJString(Xgafv))
  add(query_594023, "pageSize", newJInt(pageSize))
  add(query_594023, "prettyPrint", newJBool(prettyPrint))
  result = call_594022.call(nil, query_594023, nil, nil, nil)

var iamRolesList* = Call_IamRolesList_594002(name: "iamRolesList",
    meth: HttpMethod.HttpGet, host: "iam.googleapis.com", route: "/v1/roles",
    validator: validate_IamRolesList_594003, base: "/", url: url_IamRolesList_594004,
    schemes: {Scheme.Https})
type
  Call_IamRolesQueryGrantableRoles_594024 = ref object of OpenApiRestCall_593421
proc url_IamRolesQueryGrantableRoles_594026(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_IamRolesQueryGrantableRoles_594025(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Queries roles that can be granted on a particular resource.
  ## A role is grantable if it can be used as the role in a binding for a policy
  ## for that resource.
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
  var valid_594027 = query.getOrDefault("upload_protocol")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "upload_protocol", valid_594027
  var valid_594028 = query.getOrDefault("fields")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "fields", valid_594028
  var valid_594029 = query.getOrDefault("quotaUser")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "quotaUser", valid_594029
  var valid_594030 = query.getOrDefault("alt")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = newJString("json"))
  if valid_594030 != nil:
    section.add "alt", valid_594030
  var valid_594031 = query.getOrDefault("oauth_token")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "oauth_token", valid_594031
  var valid_594032 = query.getOrDefault("callback")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "callback", valid_594032
  var valid_594033 = query.getOrDefault("access_token")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "access_token", valid_594033
  var valid_594034 = query.getOrDefault("uploadType")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "uploadType", valid_594034
  var valid_594035 = query.getOrDefault("key")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = nil)
  if valid_594035 != nil:
    section.add "key", valid_594035
  var valid_594036 = query.getOrDefault("$.xgafv")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = newJString("1"))
  if valid_594036 != nil:
    section.add "$.xgafv", valid_594036
  var valid_594037 = query.getOrDefault("prettyPrint")
  valid_594037 = validateParameter(valid_594037, JBool, required = false,
                                 default = newJBool(true))
  if valid_594037 != nil:
    section.add "prettyPrint", valid_594037
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

proc call*(call_594039: Call_IamRolesQueryGrantableRoles_594024; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Queries roles that can be granted on a particular resource.
  ## A role is grantable if it can be used as the role in a binding for a policy
  ## for that resource.
  ## 
  let valid = call_594039.validator(path, query, header, formData, body)
  let scheme = call_594039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594039.url(scheme.get, call_594039.host, call_594039.base,
                         call_594039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594039, url, valid)

proc call*(call_594040: Call_IamRolesQueryGrantableRoles_594024;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## iamRolesQueryGrantableRoles
  ## Queries roles that can be granted on a particular resource.
  ## A role is grantable if it can be used as the role in a binding for a policy
  ## for that resource.
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
  add(query_594041, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594042 = body
  add(query_594041, "prettyPrint", newJBool(prettyPrint))
  result = call_594040.call(nil, query_594041, nil, nil, body_594042)

var iamRolesQueryGrantableRoles* = Call_IamRolesQueryGrantableRoles_594024(
    name: "iamRolesQueryGrantableRoles", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/roles:queryGrantableRoles",
    validator: validate_IamRolesQueryGrantableRoles_594025, base: "/",
    url: url_IamRolesQueryGrantableRoles_594026, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsUpdate_594077 = ref object of OpenApiRestCall_593421
proc url_IamProjectsServiceAccountsUpdate_594079(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IamProjectsServiceAccountsUpdate_594078(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Note: This method is in the process of being deprecated. Use
  ## PatchServiceAccount instead.
  ## 
  ## Updates a ServiceAccount.
  ## 
  ## Currently, only the following fields are updatable:
  ## `display_name` and `description`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the service account in the following format:
  ## `projects/{PROJECT_ID}/serviceAccounts/{ACCOUNT}`.
  ## 
  ## Requests using `-` as a wildcard for the `PROJECT_ID` will infer the
  ## project from the `account` and the `ACCOUNT` value can be the `email`
  ## address or the `unique_id` of the service account.
  ## 
  ## In responses the resource name will always be in the format
  ## `projects/{PROJECT_ID}/serviceAccounts/{ACCOUNT}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594080 = path.getOrDefault("name")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "name", valid_594080
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
  var valid_594081 = query.getOrDefault("upload_protocol")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "upload_protocol", valid_594081
  var valid_594082 = query.getOrDefault("fields")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "fields", valid_594082
  var valid_594083 = query.getOrDefault("quotaUser")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "quotaUser", valid_594083
  var valid_594084 = query.getOrDefault("alt")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = newJString("json"))
  if valid_594084 != nil:
    section.add "alt", valid_594084
  var valid_594085 = query.getOrDefault("oauth_token")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "oauth_token", valid_594085
  var valid_594086 = query.getOrDefault("callback")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "callback", valid_594086
  var valid_594087 = query.getOrDefault("access_token")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "access_token", valid_594087
  var valid_594088 = query.getOrDefault("uploadType")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = nil)
  if valid_594088 != nil:
    section.add "uploadType", valid_594088
  var valid_594089 = query.getOrDefault("key")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = nil)
  if valid_594089 != nil:
    section.add "key", valid_594089
  var valid_594090 = query.getOrDefault("$.xgafv")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = newJString("1"))
  if valid_594090 != nil:
    section.add "$.xgafv", valid_594090
  var valid_594091 = query.getOrDefault("prettyPrint")
  valid_594091 = validateParameter(valid_594091, JBool, required = false,
                                 default = newJBool(true))
  if valid_594091 != nil:
    section.add "prettyPrint", valid_594091
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

proc call*(call_594093: Call_IamProjectsServiceAccountsUpdate_594077;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Note: This method is in the process of being deprecated. Use
  ## PatchServiceAccount instead.
  ## 
  ## Updates a ServiceAccount.
  ## 
  ## Currently, only the following fields are updatable:
  ## `display_name` and `description`.
  ## 
  let valid = call_594093.validator(path, query, header, formData, body)
  let scheme = call_594093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594093.url(scheme.get, call_594093.host, call_594093.base,
                         call_594093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594093, url, valid)

proc call*(call_594094: Call_IamProjectsServiceAccountsUpdate_594077; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## iamProjectsServiceAccountsUpdate
  ## Note: This method is in the process of being deprecated. Use
  ## PatchServiceAccount instead.
  ## 
  ## Updates a ServiceAccount.
  ## 
  ## Currently, only the following fields are updatable:
  ## `display_name` and `description`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the service account in the following format:
  ## `projects/{PROJECT_ID}/serviceAccounts/{ACCOUNT}`.
  ## 
  ## Requests using `-` as a wildcard for the `PROJECT_ID` will infer the
  ## project from the `account` and the `ACCOUNT` value can be the `email`
  ## address or the `unique_id` of the service account.
  ## 
  ## In responses the resource name will always be in the format
  ## `projects/{PROJECT_ID}/serviceAccounts/{ACCOUNT}`.
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
  var path_594095 = newJObject()
  var query_594096 = newJObject()
  var body_594097 = newJObject()
  add(query_594096, "upload_protocol", newJString(uploadProtocol))
  add(query_594096, "fields", newJString(fields))
  add(query_594096, "quotaUser", newJString(quotaUser))
  add(path_594095, "name", newJString(name))
  add(query_594096, "alt", newJString(alt))
  add(query_594096, "oauth_token", newJString(oauthToken))
  add(query_594096, "callback", newJString(callback))
  add(query_594096, "access_token", newJString(accessToken))
  add(query_594096, "uploadType", newJString(uploadType))
  add(query_594096, "key", newJString(key))
  add(query_594096, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594097 = body
  add(query_594096, "prettyPrint", newJBool(prettyPrint))
  result = call_594094.call(path_594095, query_594096, nil, nil, body_594097)

var iamProjectsServiceAccountsUpdate* = Call_IamProjectsServiceAccountsUpdate_594077(
    name: "iamProjectsServiceAccountsUpdate", meth: HttpMethod.HttpPut,
    host: "iam.googleapis.com", route: "/v1/{name}",
    validator: validate_IamProjectsServiceAccountsUpdate_594078, base: "/",
    url: url_IamProjectsServiceAccountsUpdate_594079, schemes: {Scheme.Https})
type
  Call_IamOrganizationsRolesGet_594043 = ref object of OpenApiRestCall_593421
proc url_IamOrganizationsRolesGet_594045(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IamOrganizationsRolesGet_594044(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a Role definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The `name` parameter's value depends on the target resource for the
  ## request, namely
  ## [`roles`](/iam/reference/rest/v1/roles),
  ## [`projects`](/iam/reference/rest/v1/projects.roles), or
  ## [`organizations`](/iam/reference/rest/v1/organizations.roles). Each
  ## resource type's `name` value format is described below:
  ## 
  ## * [`roles.get()`](/iam/reference/rest/v1/roles/get): `roles/{ROLE_NAME}`.
  ##   This method returns results from all
  ##   [predefined roles](/iam/docs/understanding-roles#predefined_roles) in
  ##   Cloud IAM. Example request URL:
  ##   `https://iam.googleapis.com/v1/roles/{ROLE_NAME}`
  ## 
  ## * [`projects.roles.get()`](/iam/reference/rest/v1/projects.roles/get):
  ##   `projects/{PROJECT_ID}/roles/{CUSTOM_ROLE_ID}`. This method returns only
  ##   [custom roles](/iam/docs/understanding-custom-roles) that have been
  ##   created at the project level. Example request URL:
  ##   `https://iam.googleapis.com/v1/projects/{PROJECT_ID}/roles/{CUSTOM_ROLE_ID}`
  ## 
  ## * [`organizations.roles.get()`](/iam/reference/rest/v1/organizations.roles/get):
  ##   `organizations/{ORGANIZATION_ID}/roles/{CUSTOM_ROLE_ID}`. This method
  ##   returns only [custom roles](/iam/docs/understanding-custom-roles) that
  ##   have been created at the organization level. Example request URL:
  ##   
  ## `https://iam.googleapis.com/v1/organizations/{ORGANIZATION_ID}/roles/{CUSTOM_ROLE_ID}`
  ## 
  ## Note: Wildcard (*) values are invalid; you must specify a complete project
  ## ID or organization ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594060 = path.getOrDefault("name")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "name", valid_594060
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
  ##   publicKeyType: JString
  ##                : The output format of the public key requested.
  ## X509_PEM is the default output format.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594061 = query.getOrDefault("upload_protocol")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "upload_protocol", valid_594061
  var valid_594062 = query.getOrDefault("fields")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "fields", valid_594062
  var valid_594063 = query.getOrDefault("quotaUser")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = nil)
  if valid_594063 != nil:
    section.add "quotaUser", valid_594063
  var valid_594064 = query.getOrDefault("alt")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = newJString("json"))
  if valid_594064 != nil:
    section.add "alt", valid_594064
  var valid_594065 = query.getOrDefault("oauth_token")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "oauth_token", valid_594065
  var valid_594066 = query.getOrDefault("callback")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = nil)
  if valid_594066 != nil:
    section.add "callback", valid_594066
  var valid_594067 = query.getOrDefault("access_token")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = nil)
  if valid_594067 != nil:
    section.add "access_token", valid_594067
  var valid_594068 = query.getOrDefault("uploadType")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = nil)
  if valid_594068 != nil:
    section.add "uploadType", valid_594068
  var valid_594069 = query.getOrDefault("publicKeyType")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = newJString("TYPE_NONE"))
  if valid_594069 != nil:
    section.add "publicKeyType", valid_594069
  var valid_594070 = query.getOrDefault("key")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "key", valid_594070
  var valid_594071 = query.getOrDefault("$.xgafv")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = newJString("1"))
  if valid_594071 != nil:
    section.add "$.xgafv", valid_594071
  var valid_594072 = query.getOrDefault("prettyPrint")
  valid_594072 = validateParameter(valid_594072, JBool, required = false,
                                 default = newJBool(true))
  if valid_594072 != nil:
    section.add "prettyPrint", valid_594072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594073: Call_IamOrganizationsRolesGet_594043; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Role definition.
  ## 
  let valid = call_594073.validator(path, query, header, formData, body)
  let scheme = call_594073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594073.url(scheme.get, call_594073.host, call_594073.base,
                         call_594073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594073, url, valid)

proc call*(call_594074: Call_IamOrganizationsRolesGet_594043; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          publicKeyType: string = "TYPE_NONE"; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## iamOrganizationsRolesGet
  ## Gets a Role definition.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The `name` parameter's value depends on the target resource for the
  ## request, namely
  ## [`roles`](/iam/reference/rest/v1/roles),
  ## [`projects`](/iam/reference/rest/v1/projects.roles), or
  ## [`organizations`](/iam/reference/rest/v1/organizations.roles). Each
  ## resource type's `name` value format is described below:
  ## 
  ## * [`roles.get()`](/iam/reference/rest/v1/roles/get): `roles/{ROLE_NAME}`.
  ##   This method returns results from all
  ##   [predefined roles](/iam/docs/understanding-roles#predefined_roles) in
  ##   Cloud IAM. Example request URL:
  ##   `https://iam.googleapis.com/v1/roles/{ROLE_NAME}`
  ## 
  ## * [`projects.roles.get()`](/iam/reference/rest/v1/projects.roles/get):
  ##   `projects/{PROJECT_ID}/roles/{CUSTOM_ROLE_ID}`. This method returns only
  ##   [custom roles](/iam/docs/understanding-custom-roles) that have been
  ##   created at the project level. Example request URL:
  ##   `https://iam.googleapis.com/v1/projects/{PROJECT_ID}/roles/{CUSTOM_ROLE_ID}`
  ## 
  ## * [`organizations.roles.get()`](/iam/reference/rest/v1/organizations.roles/get):
  ##   `organizations/{ORGANIZATION_ID}/roles/{CUSTOM_ROLE_ID}`. This method
  ##   returns only [custom roles](/iam/docs/understanding-custom-roles) that
  ##   have been created at the organization level. Example request URL:
  ##   
  ## `https://iam.googleapis.com/v1/organizations/{ORGANIZATION_ID}/roles/{CUSTOM_ROLE_ID}`
  ## 
  ## Note: Wildcard (*) values are invalid; you must specify a complete project
  ## ID or organization ID.
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
  ##   publicKeyType: string
  ##                : The output format of the public key requested.
  ## X509_PEM is the default output format.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594075 = newJObject()
  var query_594076 = newJObject()
  add(query_594076, "upload_protocol", newJString(uploadProtocol))
  add(query_594076, "fields", newJString(fields))
  add(query_594076, "quotaUser", newJString(quotaUser))
  add(path_594075, "name", newJString(name))
  add(query_594076, "alt", newJString(alt))
  add(query_594076, "oauth_token", newJString(oauthToken))
  add(query_594076, "callback", newJString(callback))
  add(query_594076, "access_token", newJString(accessToken))
  add(query_594076, "uploadType", newJString(uploadType))
  add(query_594076, "publicKeyType", newJString(publicKeyType))
  add(query_594076, "key", newJString(key))
  add(query_594076, "$.xgafv", newJString(Xgafv))
  add(query_594076, "prettyPrint", newJBool(prettyPrint))
  result = call_594074.call(path_594075, query_594076, nil, nil, nil)

var iamOrganizationsRolesGet* = Call_IamOrganizationsRolesGet_594043(
    name: "iamOrganizationsRolesGet", meth: HttpMethod.HttpGet,
    host: "iam.googleapis.com", route: "/v1/{name}",
    validator: validate_IamOrganizationsRolesGet_594044, base: "/",
    url: url_IamOrganizationsRolesGet_594045, schemes: {Scheme.Https})
type
  Call_IamOrganizationsRolesPatch_594118 = ref object of OpenApiRestCall_593421
proc url_IamOrganizationsRolesPatch_594120(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IamOrganizationsRolesPatch_594119(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a Role definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The `name` parameter's value depends on the target resource for the
  ## request, namely
  ## [`projects`](/iam/reference/rest/v1/projects.roles) or
  ## [`organizations`](/iam/reference/rest/v1/organizations.roles). Each
  ## resource type's `name` value format is described below:
  ## 
  ## * [`projects.roles.patch()`](/iam/reference/rest/v1/projects.roles/patch):
  ##   `projects/{PROJECT_ID}/roles/{CUSTOM_ROLE_ID}`. This method updates only
  ##   [custom roles](/iam/docs/understanding-custom-roles) that have been
  ##   created at the project level. Example request URL:
  ##   `https://iam.googleapis.com/v1/projects/{PROJECT_ID}/roles/{CUSTOM_ROLE_ID}`
  ## 
  ## * 
  ## [`organizations.roles.patch()`](/iam/reference/rest/v1/organizations.roles/patch):
  ##   `organizations/{ORGANIZATION_ID}/roles/{CUSTOM_ROLE_ID}`. This method
  ##   updates only [custom roles](/iam/docs/understanding-custom-roles) that
  ##   have been created at the organization level. Example request URL:
  ##   
  ## `https://iam.googleapis.com/v1/organizations/{ORGANIZATION_ID}/roles/{CUSTOM_ROLE_ID}`
  ## 
  ## Note: Wildcard (*) values are invalid; you must specify a complete project
  ## ID or organization ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594121 = path.getOrDefault("name")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "name", valid_594121
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
  ##   updateMask: JString
  ##             : A mask describing which fields in the Role have changed.
  section = newJObject()
  var valid_594122 = query.getOrDefault("upload_protocol")
  valid_594122 = validateParameter(valid_594122, JString, required = false,
                                 default = nil)
  if valid_594122 != nil:
    section.add "upload_protocol", valid_594122
  var valid_594123 = query.getOrDefault("fields")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = nil)
  if valid_594123 != nil:
    section.add "fields", valid_594123
  var valid_594124 = query.getOrDefault("quotaUser")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = nil)
  if valid_594124 != nil:
    section.add "quotaUser", valid_594124
  var valid_594125 = query.getOrDefault("alt")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = newJString("json"))
  if valid_594125 != nil:
    section.add "alt", valid_594125
  var valid_594126 = query.getOrDefault("oauth_token")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = nil)
  if valid_594126 != nil:
    section.add "oauth_token", valid_594126
  var valid_594127 = query.getOrDefault("callback")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "callback", valid_594127
  var valid_594128 = query.getOrDefault("access_token")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = nil)
  if valid_594128 != nil:
    section.add "access_token", valid_594128
  var valid_594129 = query.getOrDefault("uploadType")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = nil)
  if valid_594129 != nil:
    section.add "uploadType", valid_594129
  var valid_594130 = query.getOrDefault("key")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = nil)
  if valid_594130 != nil:
    section.add "key", valid_594130
  var valid_594131 = query.getOrDefault("$.xgafv")
  valid_594131 = validateParameter(valid_594131, JString, required = false,
                                 default = newJString("1"))
  if valid_594131 != nil:
    section.add "$.xgafv", valid_594131
  var valid_594132 = query.getOrDefault("prettyPrint")
  valid_594132 = validateParameter(valid_594132, JBool, required = false,
                                 default = newJBool(true))
  if valid_594132 != nil:
    section.add "prettyPrint", valid_594132
  var valid_594133 = query.getOrDefault("updateMask")
  valid_594133 = validateParameter(valid_594133, JString, required = false,
                                 default = nil)
  if valid_594133 != nil:
    section.add "updateMask", valid_594133
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

proc call*(call_594135: Call_IamOrganizationsRolesPatch_594118; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Role definition.
  ## 
  let valid = call_594135.validator(path, query, header, formData, body)
  let scheme = call_594135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594135.url(scheme.get, call_594135.host, call_594135.base,
                         call_594135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594135, url, valid)

proc call*(call_594136: Call_IamOrganizationsRolesPatch_594118; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          updateMask: string = ""): Recallable =
  ## iamOrganizationsRolesPatch
  ## Updates a Role definition.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The `name` parameter's value depends on the target resource for the
  ## request, namely
  ## [`projects`](/iam/reference/rest/v1/projects.roles) or
  ## [`organizations`](/iam/reference/rest/v1/organizations.roles). Each
  ## resource type's `name` value format is described below:
  ## 
  ## * [`projects.roles.patch()`](/iam/reference/rest/v1/projects.roles/patch):
  ##   `projects/{PROJECT_ID}/roles/{CUSTOM_ROLE_ID}`. This method updates only
  ##   [custom roles](/iam/docs/understanding-custom-roles) that have been
  ##   created at the project level. Example request URL:
  ##   `https://iam.googleapis.com/v1/projects/{PROJECT_ID}/roles/{CUSTOM_ROLE_ID}`
  ## 
  ## * 
  ## [`organizations.roles.patch()`](/iam/reference/rest/v1/organizations.roles/patch):
  ##   `organizations/{ORGANIZATION_ID}/roles/{CUSTOM_ROLE_ID}`. This method
  ##   updates only [custom roles](/iam/docs/understanding-custom-roles) that
  ##   have been created at the organization level. Example request URL:
  ##   
  ## `https://iam.googleapis.com/v1/organizations/{ORGANIZATION_ID}/roles/{CUSTOM_ROLE_ID}`
  ## 
  ## Note: Wildcard (*) values are invalid; you must specify a complete project
  ## ID or organization ID.
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
  ##   updateMask: string
  ##             : A mask describing which fields in the Role have changed.
  var path_594137 = newJObject()
  var query_594138 = newJObject()
  var body_594139 = newJObject()
  add(query_594138, "upload_protocol", newJString(uploadProtocol))
  add(query_594138, "fields", newJString(fields))
  add(query_594138, "quotaUser", newJString(quotaUser))
  add(path_594137, "name", newJString(name))
  add(query_594138, "alt", newJString(alt))
  add(query_594138, "oauth_token", newJString(oauthToken))
  add(query_594138, "callback", newJString(callback))
  add(query_594138, "access_token", newJString(accessToken))
  add(query_594138, "uploadType", newJString(uploadType))
  add(query_594138, "key", newJString(key))
  add(query_594138, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594139 = body
  add(query_594138, "prettyPrint", newJBool(prettyPrint))
  add(query_594138, "updateMask", newJString(updateMask))
  result = call_594136.call(path_594137, query_594138, nil, nil, body_594139)

var iamOrganizationsRolesPatch* = Call_IamOrganizationsRolesPatch_594118(
    name: "iamOrganizationsRolesPatch", meth: HttpMethod.HttpPatch,
    host: "iam.googleapis.com", route: "/v1/{name}",
    validator: validate_IamOrganizationsRolesPatch_594119, base: "/",
    url: url_IamOrganizationsRolesPatch_594120, schemes: {Scheme.Https})
type
  Call_IamOrganizationsRolesDelete_594098 = ref object of OpenApiRestCall_593421
proc url_IamOrganizationsRolesDelete_594100(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IamOrganizationsRolesDelete_594099(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Soft deletes a role. The role is suspended and cannot be used to create new
  ## IAM Policy Bindings.
  ## The Role will not be included in `ListRoles()` unless `show_deleted` is set
  ## in the `ListRolesRequest`. The Role contains the deleted boolean set.
  ## Existing Bindings remains, but are inactive. The Role can be undeleted
  ## within 7 days. After 7 days the Role is deleted and all Bindings associated
  ## with the role are removed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The `name` parameter's value depends on the target resource for the
  ## request, namely
  ## [`projects`](/iam/reference/rest/v1/projects.roles) or
  ## [`organizations`](/iam/reference/rest/v1/organizations.roles). Each
  ## resource type's `name` value format is described below:
  ## 
  ## * [`projects.roles.delete()`](/iam/reference/rest/v1/projects.roles/delete):
  ##   `projects/{PROJECT_ID}/roles/{CUSTOM_ROLE_ID}`. This method deletes only
  ##   [custom roles](/iam/docs/understanding-custom-roles) that have been
  ##   created at the project level. Example request URL:
  ##   `https://iam.googleapis.com/v1/projects/{PROJECT_ID}/roles/{CUSTOM_ROLE_ID}`
  ## 
  ## * 
  ## [`organizations.roles.delete()`](/iam/reference/rest/v1/organizations.roles/delete):
  ##   `organizations/{ORGANIZATION_ID}/roles/{CUSTOM_ROLE_ID}`. This method
  ##   deletes only [custom roles](/iam/docs/understanding-custom-roles) that
  ##   have been created at the organization level. Example request URL:
  ##   
  ## `https://iam.googleapis.com/v1/organizations/{ORGANIZATION_ID}/roles/{CUSTOM_ROLE_ID}`
  ## 
  ## Note: Wildcard (*) values are invalid; you must specify a complete project
  ## ID or organization ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594101 = path.getOrDefault("name")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "name", valid_594101
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
  ##   etag: JString
  ##       : Used to perform a consistent read-modify-write.
  section = newJObject()
  var valid_594102 = query.getOrDefault("upload_protocol")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = nil)
  if valid_594102 != nil:
    section.add "upload_protocol", valid_594102
  var valid_594103 = query.getOrDefault("fields")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = nil)
  if valid_594103 != nil:
    section.add "fields", valid_594103
  var valid_594104 = query.getOrDefault("quotaUser")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = nil)
  if valid_594104 != nil:
    section.add "quotaUser", valid_594104
  var valid_594105 = query.getOrDefault("alt")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = newJString("json"))
  if valid_594105 != nil:
    section.add "alt", valid_594105
  var valid_594106 = query.getOrDefault("oauth_token")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = nil)
  if valid_594106 != nil:
    section.add "oauth_token", valid_594106
  var valid_594107 = query.getOrDefault("callback")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = nil)
  if valid_594107 != nil:
    section.add "callback", valid_594107
  var valid_594108 = query.getOrDefault("access_token")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = nil)
  if valid_594108 != nil:
    section.add "access_token", valid_594108
  var valid_594109 = query.getOrDefault("uploadType")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = nil)
  if valid_594109 != nil:
    section.add "uploadType", valid_594109
  var valid_594110 = query.getOrDefault("key")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = nil)
  if valid_594110 != nil:
    section.add "key", valid_594110
  var valid_594111 = query.getOrDefault("$.xgafv")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = newJString("1"))
  if valid_594111 != nil:
    section.add "$.xgafv", valid_594111
  var valid_594112 = query.getOrDefault("prettyPrint")
  valid_594112 = validateParameter(valid_594112, JBool, required = false,
                                 default = newJBool(true))
  if valid_594112 != nil:
    section.add "prettyPrint", valid_594112
  var valid_594113 = query.getOrDefault("etag")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = nil)
  if valid_594113 != nil:
    section.add "etag", valid_594113
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594114: Call_IamOrganizationsRolesDelete_594098; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Soft deletes a role. The role is suspended and cannot be used to create new
  ## IAM Policy Bindings.
  ## The Role will not be included in `ListRoles()` unless `show_deleted` is set
  ## in the `ListRolesRequest`. The Role contains the deleted boolean set.
  ## Existing Bindings remains, but are inactive. The Role can be undeleted
  ## within 7 days. After 7 days the Role is deleted and all Bindings associated
  ## with the role are removed.
  ## 
  let valid = call_594114.validator(path, query, header, formData, body)
  let scheme = call_594114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594114.url(scheme.get, call_594114.host, call_594114.base,
                         call_594114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594114, url, valid)

proc call*(call_594115: Call_IamOrganizationsRolesDelete_594098; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true; etag: string = ""): Recallable =
  ## iamOrganizationsRolesDelete
  ## Soft deletes a role. The role is suspended and cannot be used to create new
  ## IAM Policy Bindings.
  ## The Role will not be included in `ListRoles()` unless `show_deleted` is set
  ## in the `ListRolesRequest`. The Role contains the deleted boolean set.
  ## Existing Bindings remains, but are inactive. The Role can be undeleted
  ## within 7 days. After 7 days the Role is deleted and all Bindings associated
  ## with the role are removed.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The `name` parameter's value depends on the target resource for the
  ## request, namely
  ## [`projects`](/iam/reference/rest/v1/projects.roles) or
  ## [`organizations`](/iam/reference/rest/v1/organizations.roles). Each
  ## resource type's `name` value format is described below:
  ## 
  ## * [`projects.roles.delete()`](/iam/reference/rest/v1/projects.roles/delete):
  ##   `projects/{PROJECT_ID}/roles/{CUSTOM_ROLE_ID}`. This method deletes only
  ##   [custom roles](/iam/docs/understanding-custom-roles) that have been
  ##   created at the project level. Example request URL:
  ##   `https://iam.googleapis.com/v1/projects/{PROJECT_ID}/roles/{CUSTOM_ROLE_ID}`
  ## 
  ## * 
  ## [`organizations.roles.delete()`](/iam/reference/rest/v1/organizations.roles/delete):
  ##   `organizations/{ORGANIZATION_ID}/roles/{CUSTOM_ROLE_ID}`. This method
  ##   deletes only [custom roles](/iam/docs/understanding-custom-roles) that
  ##   have been created at the organization level. Example request URL:
  ##   
  ## `https://iam.googleapis.com/v1/organizations/{ORGANIZATION_ID}/roles/{CUSTOM_ROLE_ID}`
  ## 
  ## Note: Wildcard (*) values are invalid; you must specify a complete project
  ## ID or organization ID.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   etag: string
  ##       : Used to perform a consistent read-modify-write.
  var path_594116 = newJObject()
  var query_594117 = newJObject()
  add(query_594117, "upload_protocol", newJString(uploadProtocol))
  add(query_594117, "fields", newJString(fields))
  add(query_594117, "quotaUser", newJString(quotaUser))
  add(path_594116, "name", newJString(name))
  add(query_594117, "alt", newJString(alt))
  add(query_594117, "oauth_token", newJString(oauthToken))
  add(query_594117, "callback", newJString(callback))
  add(query_594117, "access_token", newJString(accessToken))
  add(query_594117, "uploadType", newJString(uploadType))
  add(query_594117, "key", newJString(key))
  add(query_594117, "$.xgafv", newJString(Xgafv))
  add(query_594117, "prettyPrint", newJBool(prettyPrint))
  add(query_594117, "etag", newJString(etag))
  result = call_594115.call(path_594116, query_594117, nil, nil, nil)

var iamOrganizationsRolesDelete* = Call_IamOrganizationsRolesDelete_594098(
    name: "iamOrganizationsRolesDelete", meth: HttpMethod.HttpDelete,
    host: "iam.googleapis.com", route: "/v1/{name}",
    validator: validate_IamOrganizationsRolesDelete_594099, base: "/",
    url: url_IamOrganizationsRolesDelete_594100, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsKeysCreate_594160 = ref object of OpenApiRestCall_593421
proc url_IamProjectsServiceAccountsKeysCreate_594162(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/keys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IamProjectsServiceAccountsKeysCreate_594161(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a ServiceAccountKey
  ## and returns it.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the service account in the following format:
  ## `projects/{PROJECT_ID}/serviceAccounts/{ACCOUNT}`.
  ## Using `-` as a wildcard for the `PROJECT_ID` will infer the project from
  ## the account. The `ACCOUNT` value can be the `email` address or the
  ## `unique_id` of the service account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594163 = path.getOrDefault("name")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "name", valid_594163
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
  var valid_594164 = query.getOrDefault("upload_protocol")
  valid_594164 = validateParameter(valid_594164, JString, required = false,
                                 default = nil)
  if valid_594164 != nil:
    section.add "upload_protocol", valid_594164
  var valid_594165 = query.getOrDefault("fields")
  valid_594165 = validateParameter(valid_594165, JString, required = false,
                                 default = nil)
  if valid_594165 != nil:
    section.add "fields", valid_594165
  var valid_594166 = query.getOrDefault("quotaUser")
  valid_594166 = validateParameter(valid_594166, JString, required = false,
                                 default = nil)
  if valid_594166 != nil:
    section.add "quotaUser", valid_594166
  var valid_594167 = query.getOrDefault("alt")
  valid_594167 = validateParameter(valid_594167, JString, required = false,
                                 default = newJString("json"))
  if valid_594167 != nil:
    section.add "alt", valid_594167
  var valid_594168 = query.getOrDefault("oauth_token")
  valid_594168 = validateParameter(valid_594168, JString, required = false,
                                 default = nil)
  if valid_594168 != nil:
    section.add "oauth_token", valid_594168
  var valid_594169 = query.getOrDefault("callback")
  valid_594169 = validateParameter(valid_594169, JString, required = false,
                                 default = nil)
  if valid_594169 != nil:
    section.add "callback", valid_594169
  var valid_594170 = query.getOrDefault("access_token")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = nil)
  if valid_594170 != nil:
    section.add "access_token", valid_594170
  var valid_594171 = query.getOrDefault("uploadType")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = nil)
  if valid_594171 != nil:
    section.add "uploadType", valid_594171
  var valid_594172 = query.getOrDefault("key")
  valid_594172 = validateParameter(valid_594172, JString, required = false,
                                 default = nil)
  if valid_594172 != nil:
    section.add "key", valid_594172
  var valid_594173 = query.getOrDefault("$.xgafv")
  valid_594173 = validateParameter(valid_594173, JString, required = false,
                                 default = newJString("1"))
  if valid_594173 != nil:
    section.add "$.xgafv", valid_594173
  var valid_594174 = query.getOrDefault("prettyPrint")
  valid_594174 = validateParameter(valid_594174, JBool, required = false,
                                 default = newJBool(true))
  if valid_594174 != nil:
    section.add "prettyPrint", valid_594174
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

proc call*(call_594176: Call_IamProjectsServiceAccountsKeysCreate_594160;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a ServiceAccountKey
  ## and returns it.
  ## 
  let valid = call_594176.validator(path, query, header, formData, body)
  let scheme = call_594176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594176.url(scheme.get, call_594176.host, call_594176.base,
                         call_594176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594176, url, valid)

proc call*(call_594177: Call_IamProjectsServiceAccountsKeysCreate_594160;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## iamProjectsServiceAccountsKeysCreate
  ## Creates a ServiceAccountKey
  ## and returns it.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the service account in the following format:
  ## `projects/{PROJECT_ID}/serviceAccounts/{ACCOUNT}`.
  ## Using `-` as a wildcard for the `PROJECT_ID` will infer the project from
  ## the account. The `ACCOUNT` value can be the `email` address or the
  ## `unique_id` of the service account.
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
  var path_594178 = newJObject()
  var query_594179 = newJObject()
  var body_594180 = newJObject()
  add(query_594179, "upload_protocol", newJString(uploadProtocol))
  add(query_594179, "fields", newJString(fields))
  add(query_594179, "quotaUser", newJString(quotaUser))
  add(path_594178, "name", newJString(name))
  add(query_594179, "alt", newJString(alt))
  add(query_594179, "oauth_token", newJString(oauthToken))
  add(query_594179, "callback", newJString(callback))
  add(query_594179, "access_token", newJString(accessToken))
  add(query_594179, "uploadType", newJString(uploadType))
  add(query_594179, "key", newJString(key))
  add(query_594179, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594180 = body
  add(query_594179, "prettyPrint", newJBool(prettyPrint))
  result = call_594177.call(path_594178, query_594179, nil, nil, body_594180)

var iamProjectsServiceAccountsKeysCreate* = Call_IamProjectsServiceAccountsKeysCreate_594160(
    name: "iamProjectsServiceAccountsKeysCreate", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}/keys",
    validator: validate_IamProjectsServiceAccountsKeysCreate_594161, base: "/",
    url: url_IamProjectsServiceAccountsKeysCreate_594162, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsKeysList_594140 = ref object of OpenApiRestCall_593421
proc url_IamProjectsServiceAccountsKeysList_594142(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/keys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IamProjectsServiceAccountsKeysList_594141(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists ServiceAccountKeys.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the service account in the following format:
  ## `projects/{PROJECT_ID}/serviceAccounts/{ACCOUNT}`.
  ## 
  ## Using `-` as a wildcard for the `PROJECT_ID`, will infer the project from
  ## the account. The `ACCOUNT` value can be the `email` address or the
  ## `unique_id` of the service account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594143 = path.getOrDefault("name")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "name", valid_594143
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   keyTypes: JArray
  ##           : Filters the types of keys the user wants to include in the list
  ## response. Duplicate key types are not allowed. If no key type
  ## is provided, all keys are returned.
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
  var valid_594144 = query.getOrDefault("upload_protocol")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = nil)
  if valid_594144 != nil:
    section.add "upload_protocol", valid_594144
  var valid_594145 = query.getOrDefault("fields")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "fields", valid_594145
  var valid_594146 = query.getOrDefault("quotaUser")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = nil)
  if valid_594146 != nil:
    section.add "quotaUser", valid_594146
  var valid_594147 = query.getOrDefault("keyTypes")
  valid_594147 = validateParameter(valid_594147, JArray, required = false,
                                 default = nil)
  if valid_594147 != nil:
    section.add "keyTypes", valid_594147
  var valid_594148 = query.getOrDefault("alt")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = newJString("json"))
  if valid_594148 != nil:
    section.add "alt", valid_594148
  var valid_594149 = query.getOrDefault("oauth_token")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = nil)
  if valid_594149 != nil:
    section.add "oauth_token", valid_594149
  var valid_594150 = query.getOrDefault("callback")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = nil)
  if valid_594150 != nil:
    section.add "callback", valid_594150
  var valid_594151 = query.getOrDefault("access_token")
  valid_594151 = validateParameter(valid_594151, JString, required = false,
                                 default = nil)
  if valid_594151 != nil:
    section.add "access_token", valid_594151
  var valid_594152 = query.getOrDefault("uploadType")
  valid_594152 = validateParameter(valid_594152, JString, required = false,
                                 default = nil)
  if valid_594152 != nil:
    section.add "uploadType", valid_594152
  var valid_594153 = query.getOrDefault("key")
  valid_594153 = validateParameter(valid_594153, JString, required = false,
                                 default = nil)
  if valid_594153 != nil:
    section.add "key", valid_594153
  var valid_594154 = query.getOrDefault("$.xgafv")
  valid_594154 = validateParameter(valid_594154, JString, required = false,
                                 default = newJString("1"))
  if valid_594154 != nil:
    section.add "$.xgafv", valid_594154
  var valid_594155 = query.getOrDefault("prettyPrint")
  valid_594155 = validateParameter(valid_594155, JBool, required = false,
                                 default = newJBool(true))
  if valid_594155 != nil:
    section.add "prettyPrint", valid_594155
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594156: Call_IamProjectsServiceAccountsKeysList_594140;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists ServiceAccountKeys.
  ## 
  let valid = call_594156.validator(path, query, header, formData, body)
  let scheme = call_594156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594156.url(scheme.get, call_594156.host, call_594156.base,
                         call_594156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594156, url, valid)

proc call*(call_594157: Call_IamProjectsServiceAccountsKeysList_594140;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; keyTypes: JsonNode = nil; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## iamProjectsServiceAccountsKeysList
  ## Lists ServiceAccountKeys.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   keyTypes: JArray
  ##           : Filters the types of keys the user wants to include in the list
  ## response. Duplicate key types are not allowed. If no key type
  ## is provided, all keys are returned.
  ##   name: string (required)
  ##       : The resource name of the service account in the following format:
  ## `projects/{PROJECT_ID}/serviceAccounts/{ACCOUNT}`.
  ## 
  ## Using `-` as a wildcard for the `PROJECT_ID`, will infer the project from
  ## the account. The `ACCOUNT` value can be the `email` address or the
  ## `unique_id` of the service account.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594158 = newJObject()
  var query_594159 = newJObject()
  add(query_594159, "upload_protocol", newJString(uploadProtocol))
  add(query_594159, "fields", newJString(fields))
  add(query_594159, "quotaUser", newJString(quotaUser))
  if keyTypes != nil:
    query_594159.add "keyTypes", keyTypes
  add(path_594158, "name", newJString(name))
  add(query_594159, "alt", newJString(alt))
  add(query_594159, "oauth_token", newJString(oauthToken))
  add(query_594159, "callback", newJString(callback))
  add(query_594159, "access_token", newJString(accessToken))
  add(query_594159, "uploadType", newJString(uploadType))
  add(query_594159, "key", newJString(key))
  add(query_594159, "$.xgafv", newJString(Xgafv))
  add(query_594159, "prettyPrint", newJBool(prettyPrint))
  result = call_594157.call(path_594158, query_594159, nil, nil, nil)

var iamProjectsServiceAccountsKeysList* = Call_IamProjectsServiceAccountsKeysList_594140(
    name: "iamProjectsServiceAccountsKeysList", meth: HttpMethod.HttpGet,
    host: "iam.googleapis.com", route: "/v1/{name}/keys",
    validator: validate_IamProjectsServiceAccountsKeysList_594141, base: "/",
    url: url_IamProjectsServiceAccountsKeysList_594142, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsKeysUpload_594181 = ref object of OpenApiRestCall_593421
proc url_IamProjectsServiceAccountsKeysUpload_594183(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/keys:upload")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IamProjectsServiceAccountsKeysUpload_594182(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Upload public key for a given service account.
  ## This rpc will create a
  ## ServiceAccountKey that has the
  ## provided public key and returns it.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the service account in the following format:
  ## `projects/{PROJECT_ID}/serviceAccounts/{ACCOUNT}`.
  ## Using `-` as a wildcard for the `PROJECT_ID` will infer the project from
  ## the account. The `ACCOUNT` value can be the `email` address or the
  ## `unique_id` of the service account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594184 = path.getOrDefault("name")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "name", valid_594184
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
  var valid_594185 = query.getOrDefault("upload_protocol")
  valid_594185 = validateParameter(valid_594185, JString, required = false,
                                 default = nil)
  if valid_594185 != nil:
    section.add "upload_protocol", valid_594185
  var valid_594186 = query.getOrDefault("fields")
  valid_594186 = validateParameter(valid_594186, JString, required = false,
                                 default = nil)
  if valid_594186 != nil:
    section.add "fields", valid_594186
  var valid_594187 = query.getOrDefault("quotaUser")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = nil)
  if valid_594187 != nil:
    section.add "quotaUser", valid_594187
  var valid_594188 = query.getOrDefault("alt")
  valid_594188 = validateParameter(valid_594188, JString, required = false,
                                 default = newJString("json"))
  if valid_594188 != nil:
    section.add "alt", valid_594188
  var valid_594189 = query.getOrDefault("oauth_token")
  valid_594189 = validateParameter(valid_594189, JString, required = false,
                                 default = nil)
  if valid_594189 != nil:
    section.add "oauth_token", valid_594189
  var valid_594190 = query.getOrDefault("callback")
  valid_594190 = validateParameter(valid_594190, JString, required = false,
                                 default = nil)
  if valid_594190 != nil:
    section.add "callback", valid_594190
  var valid_594191 = query.getOrDefault("access_token")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = nil)
  if valid_594191 != nil:
    section.add "access_token", valid_594191
  var valid_594192 = query.getOrDefault("uploadType")
  valid_594192 = validateParameter(valid_594192, JString, required = false,
                                 default = nil)
  if valid_594192 != nil:
    section.add "uploadType", valid_594192
  var valid_594193 = query.getOrDefault("key")
  valid_594193 = validateParameter(valid_594193, JString, required = false,
                                 default = nil)
  if valid_594193 != nil:
    section.add "key", valid_594193
  var valid_594194 = query.getOrDefault("$.xgafv")
  valid_594194 = validateParameter(valid_594194, JString, required = false,
                                 default = newJString("1"))
  if valid_594194 != nil:
    section.add "$.xgafv", valid_594194
  var valid_594195 = query.getOrDefault("prettyPrint")
  valid_594195 = validateParameter(valid_594195, JBool, required = false,
                                 default = newJBool(true))
  if valid_594195 != nil:
    section.add "prettyPrint", valid_594195
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

proc call*(call_594197: Call_IamProjectsServiceAccountsKeysUpload_594181;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Upload public key for a given service account.
  ## This rpc will create a
  ## ServiceAccountKey that has the
  ## provided public key and returns it.
  ## 
  let valid = call_594197.validator(path, query, header, formData, body)
  let scheme = call_594197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594197.url(scheme.get, call_594197.host, call_594197.base,
                         call_594197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594197, url, valid)

proc call*(call_594198: Call_IamProjectsServiceAccountsKeysUpload_594181;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## iamProjectsServiceAccountsKeysUpload
  ## Upload public key for a given service account.
  ## This rpc will create a
  ## ServiceAccountKey that has the
  ## provided public key and returns it.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the service account in the following format:
  ## `projects/{PROJECT_ID}/serviceAccounts/{ACCOUNT}`.
  ## Using `-` as a wildcard for the `PROJECT_ID` will infer the project from
  ## the account. The `ACCOUNT` value can be the `email` address or the
  ## `unique_id` of the service account.
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
  var path_594199 = newJObject()
  var query_594200 = newJObject()
  var body_594201 = newJObject()
  add(query_594200, "upload_protocol", newJString(uploadProtocol))
  add(query_594200, "fields", newJString(fields))
  add(query_594200, "quotaUser", newJString(quotaUser))
  add(path_594199, "name", newJString(name))
  add(query_594200, "alt", newJString(alt))
  add(query_594200, "oauth_token", newJString(oauthToken))
  add(query_594200, "callback", newJString(callback))
  add(query_594200, "access_token", newJString(accessToken))
  add(query_594200, "uploadType", newJString(uploadType))
  add(query_594200, "key", newJString(key))
  add(query_594200, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594201 = body
  add(query_594200, "prettyPrint", newJBool(prettyPrint))
  result = call_594198.call(path_594199, query_594200, nil, nil, body_594201)

var iamProjectsServiceAccountsKeysUpload* = Call_IamProjectsServiceAccountsKeysUpload_594181(
    name: "iamProjectsServiceAccountsKeysUpload", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}/keys:upload",
    validator: validate_IamProjectsServiceAccountsKeysUpload_594182, base: "/",
    url: url_IamProjectsServiceAccountsKeysUpload_594183, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsCreate_594223 = ref object of OpenApiRestCall_593421
proc url_IamProjectsServiceAccountsCreate_594225(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/serviceAccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IamProjectsServiceAccountsCreate_594224(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a ServiceAccount
  ## and returns it.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name of the project associated with the service
  ## accounts, such as `projects/my-project-123`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594226 = path.getOrDefault("name")
  valid_594226 = validateParameter(valid_594226, JString, required = true,
                                 default = nil)
  if valid_594226 != nil:
    section.add "name", valid_594226
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
  var valid_594227 = query.getOrDefault("upload_protocol")
  valid_594227 = validateParameter(valid_594227, JString, required = false,
                                 default = nil)
  if valid_594227 != nil:
    section.add "upload_protocol", valid_594227
  var valid_594228 = query.getOrDefault("fields")
  valid_594228 = validateParameter(valid_594228, JString, required = false,
                                 default = nil)
  if valid_594228 != nil:
    section.add "fields", valid_594228
  var valid_594229 = query.getOrDefault("quotaUser")
  valid_594229 = validateParameter(valid_594229, JString, required = false,
                                 default = nil)
  if valid_594229 != nil:
    section.add "quotaUser", valid_594229
  var valid_594230 = query.getOrDefault("alt")
  valid_594230 = validateParameter(valid_594230, JString, required = false,
                                 default = newJString("json"))
  if valid_594230 != nil:
    section.add "alt", valid_594230
  var valid_594231 = query.getOrDefault("oauth_token")
  valid_594231 = validateParameter(valid_594231, JString, required = false,
                                 default = nil)
  if valid_594231 != nil:
    section.add "oauth_token", valid_594231
  var valid_594232 = query.getOrDefault("callback")
  valid_594232 = validateParameter(valid_594232, JString, required = false,
                                 default = nil)
  if valid_594232 != nil:
    section.add "callback", valid_594232
  var valid_594233 = query.getOrDefault("access_token")
  valid_594233 = validateParameter(valid_594233, JString, required = false,
                                 default = nil)
  if valid_594233 != nil:
    section.add "access_token", valid_594233
  var valid_594234 = query.getOrDefault("uploadType")
  valid_594234 = validateParameter(valid_594234, JString, required = false,
                                 default = nil)
  if valid_594234 != nil:
    section.add "uploadType", valid_594234
  var valid_594235 = query.getOrDefault("key")
  valid_594235 = validateParameter(valid_594235, JString, required = false,
                                 default = nil)
  if valid_594235 != nil:
    section.add "key", valid_594235
  var valid_594236 = query.getOrDefault("$.xgafv")
  valid_594236 = validateParameter(valid_594236, JString, required = false,
                                 default = newJString("1"))
  if valid_594236 != nil:
    section.add "$.xgafv", valid_594236
  var valid_594237 = query.getOrDefault("prettyPrint")
  valid_594237 = validateParameter(valid_594237, JBool, required = false,
                                 default = newJBool(true))
  if valid_594237 != nil:
    section.add "prettyPrint", valid_594237
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

proc call*(call_594239: Call_IamProjectsServiceAccountsCreate_594223;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a ServiceAccount
  ## and returns it.
  ## 
  let valid = call_594239.validator(path, query, header, formData, body)
  let scheme = call_594239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594239.url(scheme.get, call_594239.host, call_594239.base,
                         call_594239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594239, url, valid)

proc call*(call_594240: Call_IamProjectsServiceAccountsCreate_594223; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## iamProjectsServiceAccountsCreate
  ## Creates a ServiceAccount
  ## and returns it.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the project associated with the service
  ## accounts, such as `projects/my-project-123`.
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
  var path_594241 = newJObject()
  var query_594242 = newJObject()
  var body_594243 = newJObject()
  add(query_594242, "upload_protocol", newJString(uploadProtocol))
  add(query_594242, "fields", newJString(fields))
  add(query_594242, "quotaUser", newJString(quotaUser))
  add(path_594241, "name", newJString(name))
  add(query_594242, "alt", newJString(alt))
  add(query_594242, "oauth_token", newJString(oauthToken))
  add(query_594242, "callback", newJString(callback))
  add(query_594242, "access_token", newJString(accessToken))
  add(query_594242, "uploadType", newJString(uploadType))
  add(query_594242, "key", newJString(key))
  add(query_594242, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594243 = body
  add(query_594242, "prettyPrint", newJBool(prettyPrint))
  result = call_594240.call(path_594241, query_594242, nil, nil, body_594243)

var iamProjectsServiceAccountsCreate* = Call_IamProjectsServiceAccountsCreate_594223(
    name: "iamProjectsServiceAccountsCreate", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}/serviceAccounts",
    validator: validate_IamProjectsServiceAccountsCreate_594224, base: "/",
    url: url_IamProjectsServiceAccountsCreate_594225, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsList_594202 = ref object of OpenApiRestCall_593421
proc url_IamProjectsServiceAccountsList_594204(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/serviceAccounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IamProjectsServiceAccountsList_594203(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists ServiceAccounts for a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The resource name of the project associated with the service
  ## accounts, such as `projects/my-project-123`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594205 = path.getOrDefault("name")
  valid_594205 = validateParameter(valid_594205, JString, required = true,
                                 default = nil)
  if valid_594205 != nil:
    section.add "name", valid_594205
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional pagination token returned in an earlier
  ## ListServiceAccountsResponse.next_page_token.
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
  ##           : Optional limit on the number of service accounts to include in the
  ## response. Further accounts can subsequently be obtained by including the
  ## ListServiceAccountsResponse.next_page_token
  ## in a subsequent request.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594206 = query.getOrDefault("upload_protocol")
  valid_594206 = validateParameter(valid_594206, JString, required = false,
                                 default = nil)
  if valid_594206 != nil:
    section.add "upload_protocol", valid_594206
  var valid_594207 = query.getOrDefault("fields")
  valid_594207 = validateParameter(valid_594207, JString, required = false,
                                 default = nil)
  if valid_594207 != nil:
    section.add "fields", valid_594207
  var valid_594208 = query.getOrDefault("pageToken")
  valid_594208 = validateParameter(valid_594208, JString, required = false,
                                 default = nil)
  if valid_594208 != nil:
    section.add "pageToken", valid_594208
  var valid_594209 = query.getOrDefault("quotaUser")
  valid_594209 = validateParameter(valid_594209, JString, required = false,
                                 default = nil)
  if valid_594209 != nil:
    section.add "quotaUser", valid_594209
  var valid_594210 = query.getOrDefault("alt")
  valid_594210 = validateParameter(valid_594210, JString, required = false,
                                 default = newJString("json"))
  if valid_594210 != nil:
    section.add "alt", valid_594210
  var valid_594211 = query.getOrDefault("oauth_token")
  valid_594211 = validateParameter(valid_594211, JString, required = false,
                                 default = nil)
  if valid_594211 != nil:
    section.add "oauth_token", valid_594211
  var valid_594212 = query.getOrDefault("callback")
  valid_594212 = validateParameter(valid_594212, JString, required = false,
                                 default = nil)
  if valid_594212 != nil:
    section.add "callback", valid_594212
  var valid_594213 = query.getOrDefault("access_token")
  valid_594213 = validateParameter(valid_594213, JString, required = false,
                                 default = nil)
  if valid_594213 != nil:
    section.add "access_token", valid_594213
  var valid_594214 = query.getOrDefault("uploadType")
  valid_594214 = validateParameter(valid_594214, JString, required = false,
                                 default = nil)
  if valid_594214 != nil:
    section.add "uploadType", valid_594214
  var valid_594215 = query.getOrDefault("key")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = nil)
  if valid_594215 != nil:
    section.add "key", valid_594215
  var valid_594216 = query.getOrDefault("$.xgafv")
  valid_594216 = validateParameter(valid_594216, JString, required = false,
                                 default = newJString("1"))
  if valid_594216 != nil:
    section.add "$.xgafv", valid_594216
  var valid_594217 = query.getOrDefault("pageSize")
  valid_594217 = validateParameter(valid_594217, JInt, required = false, default = nil)
  if valid_594217 != nil:
    section.add "pageSize", valid_594217
  var valid_594218 = query.getOrDefault("prettyPrint")
  valid_594218 = validateParameter(valid_594218, JBool, required = false,
                                 default = newJBool(true))
  if valid_594218 != nil:
    section.add "prettyPrint", valid_594218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594219: Call_IamProjectsServiceAccountsList_594202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists ServiceAccounts for a project.
  ## 
  let valid = call_594219.validator(path, query, header, formData, body)
  let scheme = call_594219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594219.url(scheme.get, call_594219.host, call_594219.base,
                         call_594219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594219, url, valid)

proc call*(call_594220: Call_IamProjectsServiceAccountsList_594202; name: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## iamProjectsServiceAccountsList
  ## Lists ServiceAccounts for a project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional pagination token returned in an earlier
  ## ListServiceAccountsResponse.next_page_token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the project associated with the service
  ## accounts, such as `projects/my-project-123`.
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
  ##           : Optional limit on the number of service accounts to include in the
  ## response. Further accounts can subsequently be obtained by including the
  ## ListServiceAccountsResponse.next_page_token
  ## in a subsequent request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594221 = newJObject()
  var query_594222 = newJObject()
  add(query_594222, "upload_protocol", newJString(uploadProtocol))
  add(query_594222, "fields", newJString(fields))
  add(query_594222, "pageToken", newJString(pageToken))
  add(query_594222, "quotaUser", newJString(quotaUser))
  add(path_594221, "name", newJString(name))
  add(query_594222, "alt", newJString(alt))
  add(query_594222, "oauth_token", newJString(oauthToken))
  add(query_594222, "callback", newJString(callback))
  add(query_594222, "access_token", newJString(accessToken))
  add(query_594222, "uploadType", newJString(uploadType))
  add(query_594222, "key", newJString(key))
  add(query_594222, "$.xgafv", newJString(Xgafv))
  add(query_594222, "pageSize", newJInt(pageSize))
  add(query_594222, "prettyPrint", newJBool(prettyPrint))
  result = call_594220.call(path_594221, query_594222, nil, nil, nil)

var iamProjectsServiceAccountsList* = Call_IamProjectsServiceAccountsList_594202(
    name: "iamProjectsServiceAccountsList", meth: HttpMethod.HttpGet,
    host: "iam.googleapis.com", route: "/v1/{name}/serviceAccounts",
    validator: validate_IamProjectsServiceAccountsList_594203, base: "/",
    url: url_IamProjectsServiceAccountsList_594204, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsDisable_594244 = ref object of OpenApiRestCall_593421
proc url_IamProjectsServiceAccountsDisable_594246(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":disable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IamProjectsServiceAccountsDisable_594245(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## DisableServiceAccount is currently in the alpha launch stage.
  ## 
  ## Disables a ServiceAccount,
  ## which immediately prevents the service account from authenticating and
  ## gaining access to APIs.
  ## 
  ## Disabled service accounts can be safely restored by using
  ## EnableServiceAccount at any point. Deleted service accounts cannot be
  ## restored using this method.
  ## 
  ## Disabling a service account that is bound to VMs, Apps, Functions, or
  ## other jobs will cause those jobs to lose access to resources if they are
  ## using the disabled service account.
  ## 
  ## To improve reliability of your services and avoid unexpected outages, it
  ## is recommended to first disable a service account rather than delete it.
  ## After disabling the service account, wait at least 24 hours to verify there
  ## are no unintended consequences, and then delete the service account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the service account in the following format:
  ## `projects/{PROJECT_ID}/serviceAccounts/{ACCOUNT}`.
  ## Using `-` as a wildcard for the `PROJECT_ID` will infer the project from
  ## the account. The `ACCOUNT` value can be the `email` address or the
  ## `unique_id` of the service account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594247 = path.getOrDefault("name")
  valid_594247 = validateParameter(valid_594247, JString, required = true,
                                 default = nil)
  if valid_594247 != nil:
    section.add "name", valid_594247
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
  var valid_594248 = query.getOrDefault("upload_protocol")
  valid_594248 = validateParameter(valid_594248, JString, required = false,
                                 default = nil)
  if valid_594248 != nil:
    section.add "upload_protocol", valid_594248
  var valid_594249 = query.getOrDefault("fields")
  valid_594249 = validateParameter(valid_594249, JString, required = false,
                                 default = nil)
  if valid_594249 != nil:
    section.add "fields", valid_594249
  var valid_594250 = query.getOrDefault("quotaUser")
  valid_594250 = validateParameter(valid_594250, JString, required = false,
                                 default = nil)
  if valid_594250 != nil:
    section.add "quotaUser", valid_594250
  var valid_594251 = query.getOrDefault("alt")
  valid_594251 = validateParameter(valid_594251, JString, required = false,
                                 default = newJString("json"))
  if valid_594251 != nil:
    section.add "alt", valid_594251
  var valid_594252 = query.getOrDefault("oauth_token")
  valid_594252 = validateParameter(valid_594252, JString, required = false,
                                 default = nil)
  if valid_594252 != nil:
    section.add "oauth_token", valid_594252
  var valid_594253 = query.getOrDefault("callback")
  valid_594253 = validateParameter(valid_594253, JString, required = false,
                                 default = nil)
  if valid_594253 != nil:
    section.add "callback", valid_594253
  var valid_594254 = query.getOrDefault("access_token")
  valid_594254 = validateParameter(valid_594254, JString, required = false,
                                 default = nil)
  if valid_594254 != nil:
    section.add "access_token", valid_594254
  var valid_594255 = query.getOrDefault("uploadType")
  valid_594255 = validateParameter(valid_594255, JString, required = false,
                                 default = nil)
  if valid_594255 != nil:
    section.add "uploadType", valid_594255
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
  var valid_594258 = query.getOrDefault("prettyPrint")
  valid_594258 = validateParameter(valid_594258, JBool, required = false,
                                 default = newJBool(true))
  if valid_594258 != nil:
    section.add "prettyPrint", valid_594258
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

proc call*(call_594260: Call_IamProjectsServiceAccountsDisable_594244;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## DisableServiceAccount is currently in the alpha launch stage.
  ## 
  ## Disables a ServiceAccount,
  ## which immediately prevents the service account from authenticating and
  ## gaining access to APIs.
  ## 
  ## Disabled service accounts can be safely restored by using
  ## EnableServiceAccount at any point. Deleted service accounts cannot be
  ## restored using this method.
  ## 
  ## Disabling a service account that is bound to VMs, Apps, Functions, or
  ## other jobs will cause those jobs to lose access to resources if they are
  ## using the disabled service account.
  ## 
  ## To improve reliability of your services and avoid unexpected outages, it
  ## is recommended to first disable a service account rather than delete it.
  ## After disabling the service account, wait at least 24 hours to verify there
  ## are no unintended consequences, and then delete the service account.
  ## 
  let valid = call_594260.validator(path, query, header, formData, body)
  let scheme = call_594260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594260.url(scheme.get, call_594260.host, call_594260.base,
                         call_594260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594260, url, valid)

proc call*(call_594261: Call_IamProjectsServiceAccountsDisable_594244;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## iamProjectsServiceAccountsDisable
  ## DisableServiceAccount is currently in the alpha launch stage.
  ## 
  ## Disables a ServiceAccount,
  ## which immediately prevents the service account from authenticating and
  ## gaining access to APIs.
  ## 
  ## Disabled service accounts can be safely restored by using
  ## EnableServiceAccount at any point. Deleted service accounts cannot be
  ## restored using this method.
  ## 
  ## Disabling a service account that is bound to VMs, Apps, Functions, or
  ## other jobs will cause those jobs to lose access to resources if they are
  ## using the disabled service account.
  ## 
  ## To improve reliability of your services and avoid unexpected outages, it
  ## is recommended to first disable a service account rather than delete it.
  ## After disabling the service account, wait at least 24 hours to verify there
  ## are no unintended consequences, and then delete the service account.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the service account in the following format:
  ## `projects/{PROJECT_ID}/serviceAccounts/{ACCOUNT}`.
  ## Using `-` as a wildcard for the `PROJECT_ID` will infer the project from
  ## the account. The `ACCOUNT` value can be the `email` address or the
  ## `unique_id` of the service account.
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
  var path_594262 = newJObject()
  var query_594263 = newJObject()
  var body_594264 = newJObject()
  add(query_594263, "upload_protocol", newJString(uploadProtocol))
  add(query_594263, "fields", newJString(fields))
  add(query_594263, "quotaUser", newJString(quotaUser))
  add(path_594262, "name", newJString(name))
  add(query_594263, "alt", newJString(alt))
  add(query_594263, "oauth_token", newJString(oauthToken))
  add(query_594263, "callback", newJString(callback))
  add(query_594263, "access_token", newJString(accessToken))
  add(query_594263, "uploadType", newJString(uploadType))
  add(query_594263, "key", newJString(key))
  add(query_594263, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594264 = body
  add(query_594263, "prettyPrint", newJBool(prettyPrint))
  result = call_594261.call(path_594262, query_594263, nil, nil, body_594264)

var iamProjectsServiceAccountsDisable* = Call_IamProjectsServiceAccountsDisable_594244(
    name: "iamProjectsServiceAccountsDisable", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}:disable",
    validator: validate_IamProjectsServiceAccountsDisable_594245, base: "/",
    url: url_IamProjectsServiceAccountsDisable_594246, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsEnable_594265 = ref object of OpenApiRestCall_593421
proc url_IamProjectsServiceAccountsEnable_594267(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":enable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IamProjectsServiceAccountsEnable_594266(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## EnableServiceAccount is currently in the alpha launch stage.
  ## 
  ##  Restores a disabled ServiceAccount
  ##  that has been manually disabled by using DisableServiceAccount. Service
  ##  accounts that have been disabled by other means or for other reasons,
  ##  such as abuse, cannot be restored using this method.
  ## 
  ##  EnableServiceAccount will have no effect on a service account that is
  ##  not disabled.  Enabling an already enabled service account will have no
  ##  effect.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the service account in the following format:
  ## `projects/{PROJECT_ID}/serviceAccounts/{ACCOUNT}`.
  ## Using `-` as a wildcard for the `PROJECT_ID` will infer the project from
  ## the account. The `ACCOUNT` value can be the `email` address or the
  ## `unique_id` of the service account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594268 = path.getOrDefault("name")
  valid_594268 = validateParameter(valid_594268, JString, required = true,
                                 default = nil)
  if valid_594268 != nil:
    section.add "name", valid_594268
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
  var valid_594269 = query.getOrDefault("upload_protocol")
  valid_594269 = validateParameter(valid_594269, JString, required = false,
                                 default = nil)
  if valid_594269 != nil:
    section.add "upload_protocol", valid_594269
  var valid_594270 = query.getOrDefault("fields")
  valid_594270 = validateParameter(valid_594270, JString, required = false,
                                 default = nil)
  if valid_594270 != nil:
    section.add "fields", valid_594270
  var valid_594271 = query.getOrDefault("quotaUser")
  valid_594271 = validateParameter(valid_594271, JString, required = false,
                                 default = nil)
  if valid_594271 != nil:
    section.add "quotaUser", valid_594271
  var valid_594272 = query.getOrDefault("alt")
  valid_594272 = validateParameter(valid_594272, JString, required = false,
                                 default = newJString("json"))
  if valid_594272 != nil:
    section.add "alt", valid_594272
  var valid_594273 = query.getOrDefault("oauth_token")
  valid_594273 = validateParameter(valid_594273, JString, required = false,
                                 default = nil)
  if valid_594273 != nil:
    section.add "oauth_token", valid_594273
  var valid_594274 = query.getOrDefault("callback")
  valid_594274 = validateParameter(valid_594274, JString, required = false,
                                 default = nil)
  if valid_594274 != nil:
    section.add "callback", valid_594274
  var valid_594275 = query.getOrDefault("access_token")
  valid_594275 = validateParameter(valid_594275, JString, required = false,
                                 default = nil)
  if valid_594275 != nil:
    section.add "access_token", valid_594275
  var valid_594276 = query.getOrDefault("uploadType")
  valid_594276 = validateParameter(valid_594276, JString, required = false,
                                 default = nil)
  if valid_594276 != nil:
    section.add "uploadType", valid_594276
  var valid_594277 = query.getOrDefault("key")
  valid_594277 = validateParameter(valid_594277, JString, required = false,
                                 default = nil)
  if valid_594277 != nil:
    section.add "key", valid_594277
  var valid_594278 = query.getOrDefault("$.xgafv")
  valid_594278 = validateParameter(valid_594278, JString, required = false,
                                 default = newJString("1"))
  if valid_594278 != nil:
    section.add "$.xgafv", valid_594278
  var valid_594279 = query.getOrDefault("prettyPrint")
  valid_594279 = validateParameter(valid_594279, JBool, required = false,
                                 default = newJBool(true))
  if valid_594279 != nil:
    section.add "prettyPrint", valid_594279
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

proc call*(call_594281: Call_IamProjectsServiceAccountsEnable_594265;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## EnableServiceAccount is currently in the alpha launch stage.
  ## 
  ##  Restores a disabled ServiceAccount
  ##  that has been manually disabled by using DisableServiceAccount. Service
  ##  accounts that have been disabled by other means or for other reasons,
  ##  such as abuse, cannot be restored using this method.
  ## 
  ##  EnableServiceAccount will have no effect on a service account that is
  ##  not disabled.  Enabling an already enabled service account will have no
  ##  effect.
  ## 
  let valid = call_594281.validator(path, query, header, formData, body)
  let scheme = call_594281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594281.url(scheme.get, call_594281.host, call_594281.base,
                         call_594281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594281, url, valid)

proc call*(call_594282: Call_IamProjectsServiceAccountsEnable_594265; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## iamProjectsServiceAccountsEnable
  ## EnableServiceAccount is currently in the alpha launch stage.
  ## 
  ##  Restores a disabled ServiceAccount
  ##  that has been manually disabled by using DisableServiceAccount. Service
  ##  accounts that have been disabled by other means or for other reasons,
  ##  such as abuse, cannot be restored using this method.
  ## 
  ##  EnableServiceAccount will have no effect on a service account that is
  ##  not disabled.  Enabling an already enabled service account will have no
  ##  effect.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the service account in the following format:
  ## `projects/{PROJECT_ID}/serviceAccounts/{ACCOUNT}`.
  ## Using `-` as a wildcard for the `PROJECT_ID` will infer the project from
  ## the account. The `ACCOUNT` value can be the `email` address or the
  ## `unique_id` of the service account.
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
  var path_594283 = newJObject()
  var query_594284 = newJObject()
  var body_594285 = newJObject()
  add(query_594284, "upload_protocol", newJString(uploadProtocol))
  add(query_594284, "fields", newJString(fields))
  add(query_594284, "quotaUser", newJString(quotaUser))
  add(path_594283, "name", newJString(name))
  add(query_594284, "alt", newJString(alt))
  add(query_594284, "oauth_token", newJString(oauthToken))
  add(query_594284, "callback", newJString(callback))
  add(query_594284, "access_token", newJString(accessToken))
  add(query_594284, "uploadType", newJString(uploadType))
  add(query_594284, "key", newJString(key))
  add(query_594284, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594285 = body
  add(query_594284, "prettyPrint", newJBool(prettyPrint))
  result = call_594282.call(path_594283, query_594284, nil, nil, body_594285)

var iamProjectsServiceAccountsEnable* = Call_IamProjectsServiceAccountsEnable_594265(
    name: "iamProjectsServiceAccountsEnable", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}:enable",
    validator: validate_IamProjectsServiceAccountsEnable_594266, base: "/",
    url: url_IamProjectsServiceAccountsEnable_594267, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsSignBlob_594286 = ref object of OpenApiRestCall_593421
proc url_IamProjectsServiceAccountsSignBlob_594288(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":signBlob")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IamProjectsServiceAccountsSignBlob_594287(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## **Note**: This method is in the process of being deprecated. Call the
  ## [`signBlob()`](/iam/credentials/reference/rest/v1/projects.serviceAccounts/signBlob)
  ## method of the Cloud IAM Service Account Credentials API instead.
  ## 
  ## Signs a blob using a service account's system-managed private key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the service account in the following format:
  ## `projects/{PROJECT_ID}/serviceAccounts/{ACCOUNT}`.
  ## Using `-` as a wildcard for the `PROJECT_ID` will infer the project from
  ## the account. The `ACCOUNT` value can be the `email` address or the
  ## `unique_id` of the service account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594289 = path.getOrDefault("name")
  valid_594289 = validateParameter(valid_594289, JString, required = true,
                                 default = nil)
  if valid_594289 != nil:
    section.add "name", valid_594289
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
  var valid_594290 = query.getOrDefault("upload_protocol")
  valid_594290 = validateParameter(valid_594290, JString, required = false,
                                 default = nil)
  if valid_594290 != nil:
    section.add "upload_protocol", valid_594290
  var valid_594291 = query.getOrDefault("fields")
  valid_594291 = validateParameter(valid_594291, JString, required = false,
                                 default = nil)
  if valid_594291 != nil:
    section.add "fields", valid_594291
  var valid_594292 = query.getOrDefault("quotaUser")
  valid_594292 = validateParameter(valid_594292, JString, required = false,
                                 default = nil)
  if valid_594292 != nil:
    section.add "quotaUser", valid_594292
  var valid_594293 = query.getOrDefault("alt")
  valid_594293 = validateParameter(valid_594293, JString, required = false,
                                 default = newJString("json"))
  if valid_594293 != nil:
    section.add "alt", valid_594293
  var valid_594294 = query.getOrDefault("oauth_token")
  valid_594294 = validateParameter(valid_594294, JString, required = false,
                                 default = nil)
  if valid_594294 != nil:
    section.add "oauth_token", valid_594294
  var valid_594295 = query.getOrDefault("callback")
  valid_594295 = validateParameter(valid_594295, JString, required = false,
                                 default = nil)
  if valid_594295 != nil:
    section.add "callback", valid_594295
  var valid_594296 = query.getOrDefault("access_token")
  valid_594296 = validateParameter(valid_594296, JString, required = false,
                                 default = nil)
  if valid_594296 != nil:
    section.add "access_token", valid_594296
  var valid_594297 = query.getOrDefault("uploadType")
  valid_594297 = validateParameter(valid_594297, JString, required = false,
                                 default = nil)
  if valid_594297 != nil:
    section.add "uploadType", valid_594297
  var valid_594298 = query.getOrDefault("key")
  valid_594298 = validateParameter(valid_594298, JString, required = false,
                                 default = nil)
  if valid_594298 != nil:
    section.add "key", valid_594298
  var valid_594299 = query.getOrDefault("$.xgafv")
  valid_594299 = validateParameter(valid_594299, JString, required = false,
                                 default = newJString("1"))
  if valid_594299 != nil:
    section.add "$.xgafv", valid_594299
  var valid_594300 = query.getOrDefault("prettyPrint")
  valid_594300 = validateParameter(valid_594300, JBool, required = false,
                                 default = newJBool(true))
  if valid_594300 != nil:
    section.add "prettyPrint", valid_594300
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

proc call*(call_594302: Call_IamProjectsServiceAccountsSignBlob_594286;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## **Note**: This method is in the process of being deprecated. Call the
  ## [`signBlob()`](/iam/credentials/reference/rest/v1/projects.serviceAccounts/signBlob)
  ## method of the Cloud IAM Service Account Credentials API instead.
  ## 
  ## Signs a blob using a service account's system-managed private key.
  ## 
  let valid = call_594302.validator(path, query, header, formData, body)
  let scheme = call_594302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594302.url(scheme.get, call_594302.host, call_594302.base,
                         call_594302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594302, url, valid)

proc call*(call_594303: Call_IamProjectsServiceAccountsSignBlob_594286;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## iamProjectsServiceAccountsSignBlob
  ## **Note**: This method is in the process of being deprecated. Call the
  ## [`signBlob()`](/iam/credentials/reference/rest/v1/projects.serviceAccounts/signBlob)
  ## method of the Cloud IAM Service Account Credentials API instead.
  ## 
  ## Signs a blob using a service account's system-managed private key.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the service account in the following format:
  ## `projects/{PROJECT_ID}/serviceAccounts/{ACCOUNT}`.
  ## Using `-` as a wildcard for the `PROJECT_ID` will infer the project from
  ## the account. The `ACCOUNT` value can be the `email` address or the
  ## `unique_id` of the service account.
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
  var path_594304 = newJObject()
  var query_594305 = newJObject()
  var body_594306 = newJObject()
  add(query_594305, "upload_protocol", newJString(uploadProtocol))
  add(query_594305, "fields", newJString(fields))
  add(query_594305, "quotaUser", newJString(quotaUser))
  add(path_594304, "name", newJString(name))
  add(query_594305, "alt", newJString(alt))
  add(query_594305, "oauth_token", newJString(oauthToken))
  add(query_594305, "callback", newJString(callback))
  add(query_594305, "access_token", newJString(accessToken))
  add(query_594305, "uploadType", newJString(uploadType))
  add(query_594305, "key", newJString(key))
  add(query_594305, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594306 = body
  add(query_594305, "prettyPrint", newJBool(prettyPrint))
  result = call_594303.call(path_594304, query_594305, nil, nil, body_594306)

var iamProjectsServiceAccountsSignBlob* = Call_IamProjectsServiceAccountsSignBlob_594286(
    name: "iamProjectsServiceAccountsSignBlob", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}:signBlob",
    validator: validate_IamProjectsServiceAccountsSignBlob_594287, base: "/",
    url: url_IamProjectsServiceAccountsSignBlob_594288, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsSignJwt_594307 = ref object of OpenApiRestCall_593421
proc url_IamProjectsServiceAccountsSignJwt_594309(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":signJwt")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IamProjectsServiceAccountsSignJwt_594308(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## **Note**: This method is in the process of being deprecated. Call the
  ## [`signJwt()`](/iam/credentials/reference/rest/v1/projects.serviceAccounts/signJwt)
  ## method of the Cloud IAM Service Account Credentials API instead.
  ## 
  ## Signs a JWT using a service account's system-managed private key.
  ## 
  ## If no expiry time (`exp`) is provided in the `SignJwtRequest`, IAM sets an
  ## an expiry time of one hour by default. If you request an expiry time of
  ## more than one hour, the request will fail.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the service account in the following format:
  ## `projects/{PROJECT_ID}/serviceAccounts/{ACCOUNT}`.
  ## Using `-` as a wildcard for the `PROJECT_ID` will infer the project from
  ## the account. The `ACCOUNT` value can be the `email` address or the
  ## `unique_id` of the service account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594310 = path.getOrDefault("name")
  valid_594310 = validateParameter(valid_594310, JString, required = true,
                                 default = nil)
  if valid_594310 != nil:
    section.add "name", valid_594310
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
  var valid_594311 = query.getOrDefault("upload_protocol")
  valid_594311 = validateParameter(valid_594311, JString, required = false,
                                 default = nil)
  if valid_594311 != nil:
    section.add "upload_protocol", valid_594311
  var valid_594312 = query.getOrDefault("fields")
  valid_594312 = validateParameter(valid_594312, JString, required = false,
                                 default = nil)
  if valid_594312 != nil:
    section.add "fields", valid_594312
  var valid_594313 = query.getOrDefault("quotaUser")
  valid_594313 = validateParameter(valid_594313, JString, required = false,
                                 default = nil)
  if valid_594313 != nil:
    section.add "quotaUser", valid_594313
  var valid_594314 = query.getOrDefault("alt")
  valid_594314 = validateParameter(valid_594314, JString, required = false,
                                 default = newJString("json"))
  if valid_594314 != nil:
    section.add "alt", valid_594314
  var valid_594315 = query.getOrDefault("oauth_token")
  valid_594315 = validateParameter(valid_594315, JString, required = false,
                                 default = nil)
  if valid_594315 != nil:
    section.add "oauth_token", valid_594315
  var valid_594316 = query.getOrDefault("callback")
  valid_594316 = validateParameter(valid_594316, JString, required = false,
                                 default = nil)
  if valid_594316 != nil:
    section.add "callback", valid_594316
  var valid_594317 = query.getOrDefault("access_token")
  valid_594317 = validateParameter(valid_594317, JString, required = false,
                                 default = nil)
  if valid_594317 != nil:
    section.add "access_token", valid_594317
  var valid_594318 = query.getOrDefault("uploadType")
  valid_594318 = validateParameter(valid_594318, JString, required = false,
                                 default = nil)
  if valid_594318 != nil:
    section.add "uploadType", valid_594318
  var valid_594319 = query.getOrDefault("key")
  valid_594319 = validateParameter(valid_594319, JString, required = false,
                                 default = nil)
  if valid_594319 != nil:
    section.add "key", valid_594319
  var valid_594320 = query.getOrDefault("$.xgafv")
  valid_594320 = validateParameter(valid_594320, JString, required = false,
                                 default = newJString("1"))
  if valid_594320 != nil:
    section.add "$.xgafv", valid_594320
  var valid_594321 = query.getOrDefault("prettyPrint")
  valid_594321 = validateParameter(valid_594321, JBool, required = false,
                                 default = newJBool(true))
  if valid_594321 != nil:
    section.add "prettyPrint", valid_594321
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

proc call*(call_594323: Call_IamProjectsServiceAccountsSignJwt_594307;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## **Note**: This method is in the process of being deprecated. Call the
  ## [`signJwt()`](/iam/credentials/reference/rest/v1/projects.serviceAccounts/signJwt)
  ## method of the Cloud IAM Service Account Credentials API instead.
  ## 
  ## Signs a JWT using a service account's system-managed private key.
  ## 
  ## If no expiry time (`exp`) is provided in the `SignJwtRequest`, IAM sets an
  ## an expiry time of one hour by default. If you request an expiry time of
  ## more than one hour, the request will fail.
  ## 
  let valid = call_594323.validator(path, query, header, formData, body)
  let scheme = call_594323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594323.url(scheme.get, call_594323.host, call_594323.base,
                         call_594323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594323, url, valid)

proc call*(call_594324: Call_IamProjectsServiceAccountsSignJwt_594307;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## iamProjectsServiceAccountsSignJwt
  ## **Note**: This method is in the process of being deprecated. Call the
  ## [`signJwt()`](/iam/credentials/reference/rest/v1/projects.serviceAccounts/signJwt)
  ## method of the Cloud IAM Service Account Credentials API instead.
  ## 
  ## Signs a JWT using a service account's system-managed private key.
  ## 
  ## If no expiry time (`exp`) is provided in the `SignJwtRequest`, IAM sets an
  ## an expiry time of one hour by default. If you request an expiry time of
  ## more than one hour, the request will fail.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the service account in the following format:
  ## `projects/{PROJECT_ID}/serviceAccounts/{ACCOUNT}`.
  ## Using `-` as a wildcard for the `PROJECT_ID` will infer the project from
  ## the account. The `ACCOUNT` value can be the `email` address or the
  ## `unique_id` of the service account.
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
  var path_594325 = newJObject()
  var query_594326 = newJObject()
  var body_594327 = newJObject()
  add(query_594326, "upload_protocol", newJString(uploadProtocol))
  add(query_594326, "fields", newJString(fields))
  add(query_594326, "quotaUser", newJString(quotaUser))
  add(path_594325, "name", newJString(name))
  add(query_594326, "alt", newJString(alt))
  add(query_594326, "oauth_token", newJString(oauthToken))
  add(query_594326, "callback", newJString(callback))
  add(query_594326, "access_token", newJString(accessToken))
  add(query_594326, "uploadType", newJString(uploadType))
  add(query_594326, "key", newJString(key))
  add(query_594326, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594327 = body
  add(query_594326, "prettyPrint", newJBool(prettyPrint))
  result = call_594324.call(path_594325, query_594326, nil, nil, body_594327)

var iamProjectsServiceAccountsSignJwt* = Call_IamProjectsServiceAccountsSignJwt_594307(
    name: "iamProjectsServiceAccountsSignJwt", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}:signJwt",
    validator: validate_IamProjectsServiceAccountsSignJwt_594308, base: "/",
    url: url_IamProjectsServiceAccountsSignJwt_594309, schemes: {Scheme.Https})
type
  Call_IamOrganizationsRolesUndelete_594328 = ref object of OpenApiRestCall_593421
proc url_IamOrganizationsRolesUndelete_594330(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":undelete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IamOrganizationsRolesUndelete_594329(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Undelete a Role, bringing it back in its previous state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The `name` parameter's value depends on the target resource for the
  ## request, namely
  ## [`projects`](/iam/reference/rest/v1/projects.roles) or
  ## [`organizations`](/iam/reference/rest/v1/organizations.roles). Each
  ## resource type's `name` value format is described below:
  ## 
  ## * [`projects.roles.undelete()`](/iam/reference/rest/v1/projects.roles/undelete):
  ##   `projects/{PROJECT_ID}/roles/{CUSTOM_ROLE_ID}`. This method undeletes
  ##   only [custom roles](/iam/docs/understanding-custom-roles) that have been
  ##   created at the project level. Example request URL:
  ##   `https://iam.googleapis.com/v1/projects/{PROJECT_ID}/roles/{CUSTOM_ROLE_ID}`
  ## 
  ## * 
  ## [`organizations.roles.undelete()`](/iam/reference/rest/v1/organizations.roles/undelete):
  ##   `organizations/{ORGANIZATION_ID}/roles/{CUSTOM_ROLE_ID}`. This method
  ##   undeletes only [custom roles](/iam/docs/understanding-custom-roles) that
  ##   have been created at the organization level. Example request URL:
  ##   
  ## `https://iam.googleapis.com/v1/organizations/{ORGANIZATION_ID}/roles/{CUSTOM_ROLE_ID}`
  ## 
  ## Note: Wildcard (*) values are invalid; you must specify a complete project
  ## ID or organization ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594331 = path.getOrDefault("name")
  valid_594331 = validateParameter(valid_594331, JString, required = true,
                                 default = nil)
  if valid_594331 != nil:
    section.add "name", valid_594331
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
  var valid_594332 = query.getOrDefault("upload_protocol")
  valid_594332 = validateParameter(valid_594332, JString, required = false,
                                 default = nil)
  if valid_594332 != nil:
    section.add "upload_protocol", valid_594332
  var valid_594333 = query.getOrDefault("fields")
  valid_594333 = validateParameter(valid_594333, JString, required = false,
                                 default = nil)
  if valid_594333 != nil:
    section.add "fields", valid_594333
  var valid_594334 = query.getOrDefault("quotaUser")
  valid_594334 = validateParameter(valid_594334, JString, required = false,
                                 default = nil)
  if valid_594334 != nil:
    section.add "quotaUser", valid_594334
  var valid_594335 = query.getOrDefault("alt")
  valid_594335 = validateParameter(valid_594335, JString, required = false,
                                 default = newJString("json"))
  if valid_594335 != nil:
    section.add "alt", valid_594335
  var valid_594336 = query.getOrDefault("oauth_token")
  valid_594336 = validateParameter(valid_594336, JString, required = false,
                                 default = nil)
  if valid_594336 != nil:
    section.add "oauth_token", valid_594336
  var valid_594337 = query.getOrDefault("callback")
  valid_594337 = validateParameter(valid_594337, JString, required = false,
                                 default = nil)
  if valid_594337 != nil:
    section.add "callback", valid_594337
  var valid_594338 = query.getOrDefault("access_token")
  valid_594338 = validateParameter(valid_594338, JString, required = false,
                                 default = nil)
  if valid_594338 != nil:
    section.add "access_token", valid_594338
  var valid_594339 = query.getOrDefault("uploadType")
  valid_594339 = validateParameter(valid_594339, JString, required = false,
                                 default = nil)
  if valid_594339 != nil:
    section.add "uploadType", valid_594339
  var valid_594340 = query.getOrDefault("key")
  valid_594340 = validateParameter(valid_594340, JString, required = false,
                                 default = nil)
  if valid_594340 != nil:
    section.add "key", valid_594340
  var valid_594341 = query.getOrDefault("$.xgafv")
  valid_594341 = validateParameter(valid_594341, JString, required = false,
                                 default = newJString("1"))
  if valid_594341 != nil:
    section.add "$.xgafv", valid_594341
  var valid_594342 = query.getOrDefault("prettyPrint")
  valid_594342 = validateParameter(valid_594342, JBool, required = false,
                                 default = newJBool(true))
  if valid_594342 != nil:
    section.add "prettyPrint", valid_594342
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

proc call*(call_594344: Call_IamOrganizationsRolesUndelete_594328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Undelete a Role, bringing it back in its previous state.
  ## 
  let valid = call_594344.validator(path, query, header, formData, body)
  let scheme = call_594344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594344.url(scheme.get, call_594344.host, call_594344.base,
                         call_594344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594344, url, valid)

proc call*(call_594345: Call_IamOrganizationsRolesUndelete_594328; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## iamOrganizationsRolesUndelete
  ## Undelete a Role, bringing it back in its previous state.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The `name` parameter's value depends on the target resource for the
  ## request, namely
  ## [`projects`](/iam/reference/rest/v1/projects.roles) or
  ## [`organizations`](/iam/reference/rest/v1/organizations.roles). Each
  ## resource type's `name` value format is described below:
  ## 
  ## * [`projects.roles.undelete()`](/iam/reference/rest/v1/projects.roles/undelete):
  ##   `projects/{PROJECT_ID}/roles/{CUSTOM_ROLE_ID}`. This method undeletes
  ##   only [custom roles](/iam/docs/understanding-custom-roles) that have been
  ##   created at the project level. Example request URL:
  ##   `https://iam.googleapis.com/v1/projects/{PROJECT_ID}/roles/{CUSTOM_ROLE_ID}`
  ## 
  ## * 
  ## [`organizations.roles.undelete()`](/iam/reference/rest/v1/organizations.roles/undelete):
  ##   `organizations/{ORGANIZATION_ID}/roles/{CUSTOM_ROLE_ID}`. This method
  ##   undeletes only [custom roles](/iam/docs/understanding-custom-roles) that
  ##   have been created at the organization level. Example request URL:
  ##   
  ## `https://iam.googleapis.com/v1/organizations/{ORGANIZATION_ID}/roles/{CUSTOM_ROLE_ID}`
  ## 
  ## Note: Wildcard (*) values are invalid; you must specify a complete project
  ## ID or organization ID.
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
  var path_594346 = newJObject()
  var query_594347 = newJObject()
  var body_594348 = newJObject()
  add(query_594347, "upload_protocol", newJString(uploadProtocol))
  add(query_594347, "fields", newJString(fields))
  add(query_594347, "quotaUser", newJString(quotaUser))
  add(path_594346, "name", newJString(name))
  add(query_594347, "alt", newJString(alt))
  add(query_594347, "oauth_token", newJString(oauthToken))
  add(query_594347, "callback", newJString(callback))
  add(query_594347, "access_token", newJString(accessToken))
  add(query_594347, "uploadType", newJString(uploadType))
  add(query_594347, "key", newJString(key))
  add(query_594347, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594348 = body
  add(query_594347, "prettyPrint", newJBool(prettyPrint))
  result = call_594345.call(path_594346, query_594347, nil, nil, body_594348)

var iamOrganizationsRolesUndelete* = Call_IamOrganizationsRolesUndelete_594328(
    name: "iamOrganizationsRolesUndelete", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}:undelete",
    validator: validate_IamOrganizationsRolesUndelete_594329, base: "/",
    url: url_IamOrganizationsRolesUndelete_594330, schemes: {Scheme.Https})
type
  Call_IamOrganizationsRolesCreate_594372 = ref object of OpenApiRestCall_593421
proc url_IamOrganizationsRolesCreate_594374(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IamOrganizationsRolesCreate_594373(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Role.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The `parent` parameter's value depends on the target resource for the
  ## request, namely
  ## [`projects`](/iam/reference/rest/v1/projects.roles) or
  ## [`organizations`](/iam/reference/rest/v1/organizations.roles). Each
  ## resource type's `parent` value format is described below:
  ## 
  ## * [`projects.roles.create()`](/iam/reference/rest/v1/projects.roles/create):
  ##   `projects/{PROJECT_ID}`. This method creates project-level
  ##   [custom roles](/iam/docs/understanding-custom-roles).
  ##   Example request URL:
  ##   `https://iam.googleapis.com/v1/projects/{PROJECT_ID}/roles`
  ## 
  ## * 
  ## [`organizations.roles.create()`](/iam/reference/rest/v1/organizations.roles/create):
  ##   `organizations/{ORGANIZATION_ID}`. This method creates organization-level
  ##   [custom roles](/iam/docs/understanding-custom-roles). Example request
  ##   URL:
  ##   `https://iam.googleapis.com/v1/organizations/{ORGANIZATION_ID}/roles`
  ## 
  ## Note: Wildcard (*) values are invalid; you must specify a complete project
  ## ID or organization ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594375 = path.getOrDefault("parent")
  valid_594375 = validateParameter(valid_594375, JString, required = true,
                                 default = nil)
  if valid_594375 != nil:
    section.add "parent", valid_594375
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
  var valid_594376 = query.getOrDefault("upload_protocol")
  valid_594376 = validateParameter(valid_594376, JString, required = false,
                                 default = nil)
  if valid_594376 != nil:
    section.add "upload_protocol", valid_594376
  var valid_594377 = query.getOrDefault("fields")
  valid_594377 = validateParameter(valid_594377, JString, required = false,
                                 default = nil)
  if valid_594377 != nil:
    section.add "fields", valid_594377
  var valid_594378 = query.getOrDefault("quotaUser")
  valid_594378 = validateParameter(valid_594378, JString, required = false,
                                 default = nil)
  if valid_594378 != nil:
    section.add "quotaUser", valid_594378
  var valid_594379 = query.getOrDefault("alt")
  valid_594379 = validateParameter(valid_594379, JString, required = false,
                                 default = newJString("json"))
  if valid_594379 != nil:
    section.add "alt", valid_594379
  var valid_594380 = query.getOrDefault("oauth_token")
  valid_594380 = validateParameter(valid_594380, JString, required = false,
                                 default = nil)
  if valid_594380 != nil:
    section.add "oauth_token", valid_594380
  var valid_594381 = query.getOrDefault("callback")
  valid_594381 = validateParameter(valid_594381, JString, required = false,
                                 default = nil)
  if valid_594381 != nil:
    section.add "callback", valid_594381
  var valid_594382 = query.getOrDefault("access_token")
  valid_594382 = validateParameter(valid_594382, JString, required = false,
                                 default = nil)
  if valid_594382 != nil:
    section.add "access_token", valid_594382
  var valid_594383 = query.getOrDefault("uploadType")
  valid_594383 = validateParameter(valid_594383, JString, required = false,
                                 default = nil)
  if valid_594383 != nil:
    section.add "uploadType", valid_594383
  var valid_594384 = query.getOrDefault("key")
  valid_594384 = validateParameter(valid_594384, JString, required = false,
                                 default = nil)
  if valid_594384 != nil:
    section.add "key", valid_594384
  var valid_594385 = query.getOrDefault("$.xgafv")
  valid_594385 = validateParameter(valid_594385, JString, required = false,
                                 default = newJString("1"))
  if valid_594385 != nil:
    section.add "$.xgafv", valid_594385
  var valid_594386 = query.getOrDefault("prettyPrint")
  valid_594386 = validateParameter(valid_594386, JBool, required = false,
                                 default = newJBool(true))
  if valid_594386 != nil:
    section.add "prettyPrint", valid_594386
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

proc call*(call_594388: Call_IamOrganizationsRolesCreate_594372; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Role.
  ## 
  let valid = call_594388.validator(path, query, header, formData, body)
  let scheme = call_594388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594388.url(scheme.get, call_594388.host, call_594388.base,
                         call_594388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594388, url, valid)

proc call*(call_594389: Call_IamOrganizationsRolesCreate_594372; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## iamOrganizationsRolesCreate
  ## Creates a new Role.
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
  ##         : The `parent` parameter's value depends on the target resource for the
  ## request, namely
  ## [`projects`](/iam/reference/rest/v1/projects.roles) or
  ## [`organizations`](/iam/reference/rest/v1/organizations.roles). Each
  ## resource type's `parent` value format is described below:
  ## 
  ## * [`projects.roles.create()`](/iam/reference/rest/v1/projects.roles/create):
  ##   `projects/{PROJECT_ID}`. This method creates project-level
  ##   [custom roles](/iam/docs/understanding-custom-roles).
  ##   Example request URL:
  ##   `https://iam.googleapis.com/v1/projects/{PROJECT_ID}/roles`
  ## 
  ## * 
  ## [`organizations.roles.create()`](/iam/reference/rest/v1/organizations.roles/create):
  ##   `organizations/{ORGANIZATION_ID}`. This method creates organization-level
  ##   [custom roles](/iam/docs/understanding-custom-roles). Example request
  ##   URL:
  ##   `https://iam.googleapis.com/v1/organizations/{ORGANIZATION_ID}/roles`
  ## 
  ## Note: Wildcard (*) values are invalid; you must specify a complete project
  ## ID or organization ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594390 = newJObject()
  var query_594391 = newJObject()
  var body_594392 = newJObject()
  add(query_594391, "upload_protocol", newJString(uploadProtocol))
  add(query_594391, "fields", newJString(fields))
  add(query_594391, "quotaUser", newJString(quotaUser))
  add(query_594391, "alt", newJString(alt))
  add(query_594391, "oauth_token", newJString(oauthToken))
  add(query_594391, "callback", newJString(callback))
  add(query_594391, "access_token", newJString(accessToken))
  add(query_594391, "uploadType", newJString(uploadType))
  add(path_594390, "parent", newJString(parent))
  add(query_594391, "key", newJString(key))
  add(query_594391, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594392 = body
  add(query_594391, "prettyPrint", newJBool(prettyPrint))
  result = call_594389.call(path_594390, query_594391, nil, nil, body_594392)

var iamOrganizationsRolesCreate* = Call_IamOrganizationsRolesCreate_594372(
    name: "iamOrganizationsRolesCreate", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{parent}/roles",
    validator: validate_IamOrganizationsRolesCreate_594373, base: "/",
    url: url_IamOrganizationsRolesCreate_594374, schemes: {Scheme.Https})
type
  Call_IamOrganizationsRolesList_594349 = ref object of OpenApiRestCall_593421
proc url_IamOrganizationsRolesList_594351(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IamOrganizationsRolesList_594350(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Roles defined on a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The `parent` parameter's value depends on the target resource for the
  ## request, namely
  ## [`roles`](/iam/reference/rest/v1/roles),
  ## [`projects`](/iam/reference/rest/v1/projects.roles), or
  ## [`organizations`](/iam/reference/rest/v1/organizations.roles). Each
  ## resource type's `parent` value format is described below:
  ## 
  ## * [`roles.list()`](/iam/reference/rest/v1/roles/list): An empty string.
  ##   This method doesn't require a resource; it simply returns all
  ##   [predefined roles](/iam/docs/understanding-roles#predefined_roles) in
  ##   Cloud IAM. Example request URL:
  ##   `https://iam.googleapis.com/v1/roles`
  ## 
  ## * [`projects.roles.list()`](/iam/reference/rest/v1/projects.roles/list):
  ##   `projects/{PROJECT_ID}`. This method lists all project-level
  ##   [custom roles](/iam/docs/understanding-custom-roles).
  ##   Example request URL:
  ##   `https://iam.googleapis.com/v1/projects/{PROJECT_ID}/roles`
  ## 
  ## * 
  ## [`organizations.roles.list()`](/iam/reference/rest/v1/organizations.roles/list):
  ##   `organizations/{ORGANIZATION_ID}`. This method lists all
  ##   organization-level [custom roles](/iam/docs/understanding-custom-roles).
  ##   Example request URL:
  ##   `https://iam.googleapis.com/v1/organizations/{ORGANIZATION_ID}/roles`
  ## 
  ## Note: Wildcard (*) values are invalid; you must specify a complete project
  ## ID or organization ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594352 = path.getOrDefault("parent")
  valid_594352 = validateParameter(valid_594352, JString, required = true,
                                 default = nil)
  if valid_594352 != nil:
    section.add "parent", valid_594352
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional pagination token returned in an earlier ListRolesResponse.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: JString
  ##       : Optional view for the returned Role objects. When `FULL` is specified,
  ## the `includedPermissions` field is returned, which includes a list of all
  ## permissions in the role. The default value is `BASIC`, which does not
  ## return the `includedPermissions` field.
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
  ##   showDeleted: JBool
  ##              : Include Roles that have been deleted.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional limit on the number of roles to include in the response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594353 = query.getOrDefault("upload_protocol")
  valid_594353 = validateParameter(valid_594353, JString, required = false,
                                 default = nil)
  if valid_594353 != nil:
    section.add "upload_protocol", valid_594353
  var valid_594354 = query.getOrDefault("fields")
  valid_594354 = validateParameter(valid_594354, JString, required = false,
                                 default = nil)
  if valid_594354 != nil:
    section.add "fields", valid_594354
  var valid_594355 = query.getOrDefault("pageToken")
  valid_594355 = validateParameter(valid_594355, JString, required = false,
                                 default = nil)
  if valid_594355 != nil:
    section.add "pageToken", valid_594355
  var valid_594356 = query.getOrDefault("quotaUser")
  valid_594356 = validateParameter(valid_594356, JString, required = false,
                                 default = nil)
  if valid_594356 != nil:
    section.add "quotaUser", valid_594356
  var valid_594357 = query.getOrDefault("view")
  valid_594357 = validateParameter(valid_594357, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_594357 != nil:
    section.add "view", valid_594357
  var valid_594358 = query.getOrDefault("alt")
  valid_594358 = validateParameter(valid_594358, JString, required = false,
                                 default = newJString("json"))
  if valid_594358 != nil:
    section.add "alt", valid_594358
  var valid_594359 = query.getOrDefault("oauth_token")
  valid_594359 = validateParameter(valid_594359, JString, required = false,
                                 default = nil)
  if valid_594359 != nil:
    section.add "oauth_token", valid_594359
  var valid_594360 = query.getOrDefault("callback")
  valid_594360 = validateParameter(valid_594360, JString, required = false,
                                 default = nil)
  if valid_594360 != nil:
    section.add "callback", valid_594360
  var valid_594361 = query.getOrDefault("access_token")
  valid_594361 = validateParameter(valid_594361, JString, required = false,
                                 default = nil)
  if valid_594361 != nil:
    section.add "access_token", valid_594361
  var valid_594362 = query.getOrDefault("uploadType")
  valid_594362 = validateParameter(valid_594362, JString, required = false,
                                 default = nil)
  if valid_594362 != nil:
    section.add "uploadType", valid_594362
  var valid_594363 = query.getOrDefault("showDeleted")
  valid_594363 = validateParameter(valid_594363, JBool, required = false, default = nil)
  if valid_594363 != nil:
    section.add "showDeleted", valid_594363
  var valid_594364 = query.getOrDefault("key")
  valid_594364 = validateParameter(valid_594364, JString, required = false,
                                 default = nil)
  if valid_594364 != nil:
    section.add "key", valid_594364
  var valid_594365 = query.getOrDefault("$.xgafv")
  valid_594365 = validateParameter(valid_594365, JString, required = false,
                                 default = newJString("1"))
  if valid_594365 != nil:
    section.add "$.xgafv", valid_594365
  var valid_594366 = query.getOrDefault("pageSize")
  valid_594366 = validateParameter(valid_594366, JInt, required = false, default = nil)
  if valid_594366 != nil:
    section.add "pageSize", valid_594366
  var valid_594367 = query.getOrDefault("prettyPrint")
  valid_594367 = validateParameter(valid_594367, JBool, required = false,
                                 default = newJBool(true))
  if valid_594367 != nil:
    section.add "prettyPrint", valid_594367
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594368: Call_IamOrganizationsRolesList_594349; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Roles defined on a resource.
  ## 
  let valid = call_594368.validator(path, query, header, formData, body)
  let scheme = call_594368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594368.url(scheme.get, call_594368.host, call_594368.base,
                         call_594368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594368, url, valid)

proc call*(call_594369: Call_IamOrganizationsRolesList_594349; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; view: string = "BASIC"; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; showDeleted: bool = false; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## iamOrganizationsRolesList
  ## Lists the Roles defined on a resource.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional pagination token returned in an earlier ListRolesResponse.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: string
  ##       : Optional view for the returned Role objects. When `FULL` is specified,
  ## the `includedPermissions` field is returned, which includes a list of all
  ## permissions in the role. The default value is `BASIC`, which does not
  ## return the `includedPermissions` field.
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
  ##         : The `parent` parameter's value depends on the target resource for the
  ## request, namely
  ## [`roles`](/iam/reference/rest/v1/roles),
  ## [`projects`](/iam/reference/rest/v1/projects.roles), or
  ## [`organizations`](/iam/reference/rest/v1/organizations.roles). Each
  ## resource type's `parent` value format is described below:
  ## 
  ## * [`roles.list()`](/iam/reference/rest/v1/roles/list): An empty string.
  ##   This method doesn't require a resource; it simply returns all
  ##   [predefined roles](/iam/docs/understanding-roles#predefined_roles) in
  ##   Cloud IAM. Example request URL:
  ##   `https://iam.googleapis.com/v1/roles`
  ## 
  ## * [`projects.roles.list()`](/iam/reference/rest/v1/projects.roles/list):
  ##   `projects/{PROJECT_ID}`. This method lists all project-level
  ##   [custom roles](/iam/docs/understanding-custom-roles).
  ##   Example request URL:
  ##   `https://iam.googleapis.com/v1/projects/{PROJECT_ID}/roles`
  ## 
  ## * 
  ## [`organizations.roles.list()`](/iam/reference/rest/v1/organizations.roles/list):
  ##   `organizations/{ORGANIZATION_ID}`. This method lists all
  ##   organization-level [custom roles](/iam/docs/understanding-custom-roles).
  ##   Example request URL:
  ##   `https://iam.googleapis.com/v1/organizations/{ORGANIZATION_ID}/roles`
  ## 
  ## Note: Wildcard (*) values are invalid; you must specify a complete project
  ## ID or organization ID.
  ##   showDeleted: bool
  ##              : Include Roles that have been deleted.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional limit on the number of roles to include in the response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594370 = newJObject()
  var query_594371 = newJObject()
  add(query_594371, "upload_protocol", newJString(uploadProtocol))
  add(query_594371, "fields", newJString(fields))
  add(query_594371, "pageToken", newJString(pageToken))
  add(query_594371, "quotaUser", newJString(quotaUser))
  add(query_594371, "view", newJString(view))
  add(query_594371, "alt", newJString(alt))
  add(query_594371, "oauth_token", newJString(oauthToken))
  add(query_594371, "callback", newJString(callback))
  add(query_594371, "access_token", newJString(accessToken))
  add(query_594371, "uploadType", newJString(uploadType))
  add(path_594370, "parent", newJString(parent))
  add(query_594371, "showDeleted", newJBool(showDeleted))
  add(query_594371, "key", newJString(key))
  add(query_594371, "$.xgafv", newJString(Xgafv))
  add(query_594371, "pageSize", newJInt(pageSize))
  add(query_594371, "prettyPrint", newJBool(prettyPrint))
  result = call_594369.call(path_594370, query_594371, nil, nil, nil)

var iamOrganizationsRolesList* = Call_IamOrganizationsRolesList_594349(
    name: "iamOrganizationsRolesList", meth: HttpMethod.HttpGet,
    host: "iam.googleapis.com", route: "/v1/{parent}/roles",
    validator: validate_IamOrganizationsRolesList_594350, base: "/",
    url: url_IamOrganizationsRolesList_594351, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsGetIamPolicy_594393 = ref object of OpenApiRestCall_593421
proc url_IamProjectsServiceAccountsGetIamPolicy_594395(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IamProjectsServiceAccountsGetIamPolicy_594394(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the Cloud IAM access control policy for a
  ## ServiceAccount.
  ## 
  ## Note: Service accounts are both
  ## [resources and
  ## identities](/iam/docs/service-accounts#service_account_permissions). This
  ## method treats the service account as a resource. It returns the Cloud IAM
  ## policy that reflects what members have access to the service account.
  ## 
  ## This method does not return what resources the service account has access
  ## to. To see if a service account has access to a resource, call the
  ## `getIamPolicy` method on the target resource. For example, to view grants
  ## for a project, call the
  ## [projects.getIamPolicy](/resource-manager/reference/rest/v1/projects/getIamPolicy)
  ## method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_594396 = path.getOrDefault("resource")
  valid_594396 = validateParameter(valid_594396, JString, required = true,
                                 default = nil)
  if valid_594396 != nil:
    section.add "resource", valid_594396
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
  ##   options.requestedPolicyVersion: JInt
  ##                                 : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594397 = query.getOrDefault("upload_protocol")
  valid_594397 = validateParameter(valid_594397, JString, required = false,
                                 default = nil)
  if valid_594397 != nil:
    section.add "upload_protocol", valid_594397
  var valid_594398 = query.getOrDefault("fields")
  valid_594398 = validateParameter(valid_594398, JString, required = false,
                                 default = nil)
  if valid_594398 != nil:
    section.add "fields", valid_594398
  var valid_594399 = query.getOrDefault("quotaUser")
  valid_594399 = validateParameter(valid_594399, JString, required = false,
                                 default = nil)
  if valid_594399 != nil:
    section.add "quotaUser", valid_594399
  var valid_594400 = query.getOrDefault("alt")
  valid_594400 = validateParameter(valid_594400, JString, required = false,
                                 default = newJString("json"))
  if valid_594400 != nil:
    section.add "alt", valid_594400
  var valid_594401 = query.getOrDefault("oauth_token")
  valid_594401 = validateParameter(valid_594401, JString, required = false,
                                 default = nil)
  if valid_594401 != nil:
    section.add "oauth_token", valid_594401
  var valid_594402 = query.getOrDefault("callback")
  valid_594402 = validateParameter(valid_594402, JString, required = false,
                                 default = nil)
  if valid_594402 != nil:
    section.add "callback", valid_594402
  var valid_594403 = query.getOrDefault("access_token")
  valid_594403 = validateParameter(valid_594403, JString, required = false,
                                 default = nil)
  if valid_594403 != nil:
    section.add "access_token", valid_594403
  var valid_594404 = query.getOrDefault("uploadType")
  valid_594404 = validateParameter(valid_594404, JString, required = false,
                                 default = nil)
  if valid_594404 != nil:
    section.add "uploadType", valid_594404
  var valid_594405 = query.getOrDefault("options.requestedPolicyVersion")
  valid_594405 = validateParameter(valid_594405, JInt, required = false, default = nil)
  if valid_594405 != nil:
    section.add "options.requestedPolicyVersion", valid_594405
  var valid_594406 = query.getOrDefault("key")
  valid_594406 = validateParameter(valid_594406, JString, required = false,
                                 default = nil)
  if valid_594406 != nil:
    section.add "key", valid_594406
  var valid_594407 = query.getOrDefault("$.xgafv")
  valid_594407 = validateParameter(valid_594407, JString, required = false,
                                 default = newJString("1"))
  if valid_594407 != nil:
    section.add "$.xgafv", valid_594407
  var valid_594408 = query.getOrDefault("prettyPrint")
  valid_594408 = validateParameter(valid_594408, JBool, required = false,
                                 default = newJBool(true))
  if valid_594408 != nil:
    section.add "prettyPrint", valid_594408
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594409: Call_IamProjectsServiceAccountsGetIamPolicy_594393;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the Cloud IAM access control policy for a
  ## ServiceAccount.
  ## 
  ## Note: Service accounts are both
  ## [resources and
  ## identities](/iam/docs/service-accounts#service_account_permissions). This
  ## method treats the service account as a resource. It returns the Cloud IAM
  ## policy that reflects what members have access to the service account.
  ## 
  ## This method does not return what resources the service account has access
  ## to. To see if a service account has access to a resource, call the
  ## `getIamPolicy` method on the target resource. For example, to view grants
  ## for a project, call the
  ## [projects.getIamPolicy](/resource-manager/reference/rest/v1/projects/getIamPolicy)
  ## method.
  ## 
  let valid = call_594409.validator(path, query, header, formData, body)
  let scheme = call_594409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594409.url(scheme.get, call_594409.host, call_594409.base,
                         call_594409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594409, url, valid)

proc call*(call_594410: Call_IamProjectsServiceAccountsGetIamPolicy_594393;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          optionsRequestedPolicyVersion: int = 0; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## iamProjectsServiceAccountsGetIamPolicy
  ## Returns the Cloud IAM access control policy for a
  ## ServiceAccount.
  ## 
  ## Note: Service accounts are both
  ## [resources and
  ## identities](/iam/docs/service-accounts#service_account_permissions). This
  ## method treats the service account as a resource. It returns the Cloud IAM
  ## policy that reflects what members have access to the service account.
  ## 
  ## This method does not return what resources the service account has access
  ## to. To see if a service account has access to a resource, call the
  ## `getIamPolicy` method on the target resource. For example, to view grants
  ## for a project, call the
  ## [projects.getIamPolicy](/resource-manager/reference/rest/v1/projects/getIamPolicy)
  ## method.
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
  ##   optionsRequestedPolicyVersion: int
  ##                                : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594411 = newJObject()
  var query_594412 = newJObject()
  add(query_594412, "upload_protocol", newJString(uploadProtocol))
  add(query_594412, "fields", newJString(fields))
  add(query_594412, "quotaUser", newJString(quotaUser))
  add(query_594412, "alt", newJString(alt))
  add(query_594412, "oauth_token", newJString(oauthToken))
  add(query_594412, "callback", newJString(callback))
  add(query_594412, "access_token", newJString(accessToken))
  add(query_594412, "uploadType", newJString(uploadType))
  add(query_594412, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_594412, "key", newJString(key))
  add(query_594412, "$.xgafv", newJString(Xgafv))
  add(path_594411, "resource", newJString(resource))
  add(query_594412, "prettyPrint", newJBool(prettyPrint))
  result = call_594410.call(path_594411, query_594412, nil, nil, nil)

var iamProjectsServiceAccountsGetIamPolicy* = Call_IamProjectsServiceAccountsGetIamPolicy_594393(
    name: "iamProjectsServiceAccountsGetIamPolicy", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{resource}:getIamPolicy",
    validator: validate_IamProjectsServiceAccountsGetIamPolicy_594394, base: "/",
    url: url_IamProjectsServiceAccountsGetIamPolicy_594395,
    schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsSetIamPolicy_594413 = ref object of OpenApiRestCall_593421
proc url_IamProjectsServiceAccountsSetIamPolicy_594415(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IamProjectsServiceAccountsSetIamPolicy_594414(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the Cloud IAM access control policy for a
  ## ServiceAccount.
  ## 
  ## Note: Service accounts are both
  ## [resources and
  ## identities](/iam/docs/service-accounts#service_account_permissions). This
  ## method treats the service account as a resource. Use it to grant members
  ## access to the service account, such as when they need to impersonate it.
  ## 
  ## This method does not grant the service account access to other resources,
  ## such as projects. To grant a service account access to resources, include
  ## the service account in the Cloud IAM policy for the desired resource, then
  ## call the appropriate `setIamPolicy` method on the target resource. For
  ## example, to grant a service account access to a project, call the
  ## [projects.setIamPolicy](/resource-manager/reference/rest/v1/projects/setIamPolicy)
  ## method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_594416 = path.getOrDefault("resource")
  valid_594416 = validateParameter(valid_594416, JString, required = true,
                                 default = nil)
  if valid_594416 != nil:
    section.add "resource", valid_594416
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
  var valid_594417 = query.getOrDefault("upload_protocol")
  valid_594417 = validateParameter(valid_594417, JString, required = false,
                                 default = nil)
  if valid_594417 != nil:
    section.add "upload_protocol", valid_594417
  var valid_594418 = query.getOrDefault("fields")
  valid_594418 = validateParameter(valid_594418, JString, required = false,
                                 default = nil)
  if valid_594418 != nil:
    section.add "fields", valid_594418
  var valid_594419 = query.getOrDefault("quotaUser")
  valid_594419 = validateParameter(valid_594419, JString, required = false,
                                 default = nil)
  if valid_594419 != nil:
    section.add "quotaUser", valid_594419
  var valid_594420 = query.getOrDefault("alt")
  valid_594420 = validateParameter(valid_594420, JString, required = false,
                                 default = newJString("json"))
  if valid_594420 != nil:
    section.add "alt", valid_594420
  var valid_594421 = query.getOrDefault("oauth_token")
  valid_594421 = validateParameter(valid_594421, JString, required = false,
                                 default = nil)
  if valid_594421 != nil:
    section.add "oauth_token", valid_594421
  var valid_594422 = query.getOrDefault("callback")
  valid_594422 = validateParameter(valid_594422, JString, required = false,
                                 default = nil)
  if valid_594422 != nil:
    section.add "callback", valid_594422
  var valid_594423 = query.getOrDefault("access_token")
  valid_594423 = validateParameter(valid_594423, JString, required = false,
                                 default = nil)
  if valid_594423 != nil:
    section.add "access_token", valid_594423
  var valid_594424 = query.getOrDefault("uploadType")
  valid_594424 = validateParameter(valid_594424, JString, required = false,
                                 default = nil)
  if valid_594424 != nil:
    section.add "uploadType", valid_594424
  var valid_594425 = query.getOrDefault("key")
  valid_594425 = validateParameter(valid_594425, JString, required = false,
                                 default = nil)
  if valid_594425 != nil:
    section.add "key", valid_594425
  var valid_594426 = query.getOrDefault("$.xgafv")
  valid_594426 = validateParameter(valid_594426, JString, required = false,
                                 default = newJString("1"))
  if valid_594426 != nil:
    section.add "$.xgafv", valid_594426
  var valid_594427 = query.getOrDefault("prettyPrint")
  valid_594427 = validateParameter(valid_594427, JBool, required = false,
                                 default = newJBool(true))
  if valid_594427 != nil:
    section.add "prettyPrint", valid_594427
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

proc call*(call_594429: Call_IamProjectsServiceAccountsSetIamPolicy_594413;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the Cloud IAM access control policy for a
  ## ServiceAccount.
  ## 
  ## Note: Service accounts are both
  ## [resources and
  ## identities](/iam/docs/service-accounts#service_account_permissions). This
  ## method treats the service account as a resource. Use it to grant members
  ## access to the service account, such as when they need to impersonate it.
  ## 
  ## This method does not grant the service account access to other resources,
  ## such as projects. To grant a service account access to resources, include
  ## the service account in the Cloud IAM policy for the desired resource, then
  ## call the appropriate `setIamPolicy` method on the target resource. For
  ## example, to grant a service account access to a project, call the
  ## [projects.setIamPolicy](/resource-manager/reference/rest/v1/projects/setIamPolicy)
  ## method.
  ## 
  let valid = call_594429.validator(path, query, header, formData, body)
  let scheme = call_594429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594429.url(scheme.get, call_594429.host, call_594429.base,
                         call_594429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594429, url, valid)

proc call*(call_594430: Call_IamProjectsServiceAccountsSetIamPolicy_594413;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## iamProjectsServiceAccountsSetIamPolicy
  ## Sets the Cloud IAM access control policy for a
  ## ServiceAccount.
  ## 
  ## Note: Service accounts are both
  ## [resources and
  ## identities](/iam/docs/service-accounts#service_account_permissions). This
  ## method treats the service account as a resource. Use it to grant members
  ## access to the service account, such as when they need to impersonate it.
  ## 
  ## This method does not grant the service account access to other resources,
  ## such as projects. To grant a service account access to resources, include
  ## the service account in the Cloud IAM policy for the desired resource, then
  ## call the appropriate `setIamPolicy` method on the target resource. For
  ## example, to grant a service account access to a project, call the
  ## [projects.setIamPolicy](/resource-manager/reference/rest/v1/projects/setIamPolicy)
  ## method.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594431 = newJObject()
  var query_594432 = newJObject()
  var body_594433 = newJObject()
  add(query_594432, "upload_protocol", newJString(uploadProtocol))
  add(query_594432, "fields", newJString(fields))
  add(query_594432, "quotaUser", newJString(quotaUser))
  add(query_594432, "alt", newJString(alt))
  add(query_594432, "oauth_token", newJString(oauthToken))
  add(query_594432, "callback", newJString(callback))
  add(query_594432, "access_token", newJString(accessToken))
  add(query_594432, "uploadType", newJString(uploadType))
  add(query_594432, "key", newJString(key))
  add(query_594432, "$.xgafv", newJString(Xgafv))
  add(path_594431, "resource", newJString(resource))
  if body != nil:
    body_594433 = body
  add(query_594432, "prettyPrint", newJBool(prettyPrint))
  result = call_594430.call(path_594431, query_594432, nil, nil, body_594433)

var iamProjectsServiceAccountsSetIamPolicy* = Call_IamProjectsServiceAccountsSetIamPolicy_594413(
    name: "iamProjectsServiceAccountsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{resource}:setIamPolicy",
    validator: validate_IamProjectsServiceAccountsSetIamPolicy_594414, base: "/",
    url: url_IamProjectsServiceAccountsSetIamPolicy_594415,
    schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsTestIamPermissions_594434 = ref object of OpenApiRestCall_593421
proc url_IamProjectsServiceAccountsTestIamPermissions_594436(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IamProjectsServiceAccountsTestIamPermissions_594435(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Tests the specified permissions against the IAM access control policy
  ## for a ServiceAccount.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_594437 = path.getOrDefault("resource")
  valid_594437 = validateParameter(valid_594437, JString, required = true,
                                 default = nil)
  if valid_594437 != nil:
    section.add "resource", valid_594437
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
  var valid_594438 = query.getOrDefault("upload_protocol")
  valid_594438 = validateParameter(valid_594438, JString, required = false,
                                 default = nil)
  if valid_594438 != nil:
    section.add "upload_protocol", valid_594438
  var valid_594439 = query.getOrDefault("fields")
  valid_594439 = validateParameter(valid_594439, JString, required = false,
                                 default = nil)
  if valid_594439 != nil:
    section.add "fields", valid_594439
  var valid_594440 = query.getOrDefault("quotaUser")
  valid_594440 = validateParameter(valid_594440, JString, required = false,
                                 default = nil)
  if valid_594440 != nil:
    section.add "quotaUser", valid_594440
  var valid_594441 = query.getOrDefault("alt")
  valid_594441 = validateParameter(valid_594441, JString, required = false,
                                 default = newJString("json"))
  if valid_594441 != nil:
    section.add "alt", valid_594441
  var valid_594442 = query.getOrDefault("oauth_token")
  valid_594442 = validateParameter(valid_594442, JString, required = false,
                                 default = nil)
  if valid_594442 != nil:
    section.add "oauth_token", valid_594442
  var valid_594443 = query.getOrDefault("callback")
  valid_594443 = validateParameter(valid_594443, JString, required = false,
                                 default = nil)
  if valid_594443 != nil:
    section.add "callback", valid_594443
  var valid_594444 = query.getOrDefault("access_token")
  valid_594444 = validateParameter(valid_594444, JString, required = false,
                                 default = nil)
  if valid_594444 != nil:
    section.add "access_token", valid_594444
  var valid_594445 = query.getOrDefault("uploadType")
  valid_594445 = validateParameter(valid_594445, JString, required = false,
                                 default = nil)
  if valid_594445 != nil:
    section.add "uploadType", valid_594445
  var valid_594446 = query.getOrDefault("key")
  valid_594446 = validateParameter(valid_594446, JString, required = false,
                                 default = nil)
  if valid_594446 != nil:
    section.add "key", valid_594446
  var valid_594447 = query.getOrDefault("$.xgafv")
  valid_594447 = validateParameter(valid_594447, JString, required = false,
                                 default = newJString("1"))
  if valid_594447 != nil:
    section.add "$.xgafv", valid_594447
  var valid_594448 = query.getOrDefault("prettyPrint")
  valid_594448 = validateParameter(valid_594448, JBool, required = false,
                                 default = newJBool(true))
  if valid_594448 != nil:
    section.add "prettyPrint", valid_594448
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

proc call*(call_594450: Call_IamProjectsServiceAccountsTestIamPermissions_594434;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Tests the specified permissions against the IAM access control policy
  ## for a ServiceAccount.
  ## 
  let valid = call_594450.validator(path, query, header, formData, body)
  let scheme = call_594450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594450.url(scheme.get, call_594450.host, call_594450.base,
                         call_594450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594450, url, valid)

proc call*(call_594451: Call_IamProjectsServiceAccountsTestIamPermissions_594434;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## iamProjectsServiceAccountsTestIamPermissions
  ## Tests the specified permissions against the IAM access control policy
  ## for a ServiceAccount.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594452 = newJObject()
  var query_594453 = newJObject()
  var body_594454 = newJObject()
  add(query_594453, "upload_protocol", newJString(uploadProtocol))
  add(query_594453, "fields", newJString(fields))
  add(query_594453, "quotaUser", newJString(quotaUser))
  add(query_594453, "alt", newJString(alt))
  add(query_594453, "oauth_token", newJString(oauthToken))
  add(query_594453, "callback", newJString(callback))
  add(query_594453, "access_token", newJString(accessToken))
  add(query_594453, "uploadType", newJString(uploadType))
  add(query_594453, "key", newJString(key))
  add(query_594453, "$.xgafv", newJString(Xgafv))
  add(path_594452, "resource", newJString(resource))
  if body != nil:
    body_594454 = body
  add(query_594453, "prettyPrint", newJBool(prettyPrint))
  result = call_594451.call(path_594452, query_594453, nil, nil, body_594454)

var iamProjectsServiceAccountsTestIamPermissions* = Call_IamProjectsServiceAccountsTestIamPermissions_594434(
    name: "iamProjectsServiceAccountsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "iam.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_IamProjectsServiceAccountsTestIamPermissions_594435,
    base: "/", url: url_IamProjectsServiceAccountsTestIamPermissions_594436,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
