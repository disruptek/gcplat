
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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
  gcpServiceName = "iam"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_IamIamPoliciesLintPolicy_578619 = ref object of OpenApiRestCall_578348
proc url_IamIamPoliciesLintPolicy_578621(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IamIamPoliciesLintPolicy_578620(path: JsonNode; query: JsonNode;
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

proc call*(call_578780: Call_IamIamPoliciesLintPolicy_578619; path: JsonNode;
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
  let valid = call_578780.validator(path, query, header, formData, body)
  let scheme = call_578780.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578780.url(scheme.get, call_578780.host, call_578780.base,
                         call_578780.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578780, url, valid)

proc call*(call_578851: Call_IamIamPoliciesLintPolicy_578619; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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

var iamIamPoliciesLintPolicy* = Call_IamIamPoliciesLintPolicy_578619(
    name: "iamIamPoliciesLintPolicy", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/iamPolicies:lintPolicy",
    validator: validate_IamIamPoliciesLintPolicy_578620, base: "/",
    url: url_IamIamPoliciesLintPolicy_578621, schemes: {Scheme.Https})
type
  Call_IamIamPoliciesQueryAuditableServices_578893 = ref object of OpenApiRestCall_578348
proc url_IamIamPoliciesQueryAuditableServices_578895(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IamIamPoliciesQueryAuditableServices_578894(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of services that support service level audit logging
  ## configuration for the given resource.
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
  var valid_578896 = query.getOrDefault("key")
  valid_578896 = validateParameter(valid_578896, JString, required = false,
                                 default = nil)
  if valid_578896 != nil:
    section.add "key", valid_578896
  var valid_578897 = query.getOrDefault("prettyPrint")
  valid_578897 = validateParameter(valid_578897, JBool, required = false,
                                 default = newJBool(true))
  if valid_578897 != nil:
    section.add "prettyPrint", valid_578897
  var valid_578898 = query.getOrDefault("oauth_token")
  valid_578898 = validateParameter(valid_578898, JString, required = false,
                                 default = nil)
  if valid_578898 != nil:
    section.add "oauth_token", valid_578898
  var valid_578899 = query.getOrDefault("$.xgafv")
  valid_578899 = validateParameter(valid_578899, JString, required = false,
                                 default = newJString("1"))
  if valid_578899 != nil:
    section.add "$.xgafv", valid_578899
  var valid_578900 = query.getOrDefault("alt")
  valid_578900 = validateParameter(valid_578900, JString, required = false,
                                 default = newJString("json"))
  if valid_578900 != nil:
    section.add "alt", valid_578900
  var valid_578901 = query.getOrDefault("uploadType")
  valid_578901 = validateParameter(valid_578901, JString, required = false,
                                 default = nil)
  if valid_578901 != nil:
    section.add "uploadType", valid_578901
  var valid_578902 = query.getOrDefault("quotaUser")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = nil)
  if valid_578902 != nil:
    section.add "quotaUser", valid_578902
  var valid_578903 = query.getOrDefault("callback")
  valid_578903 = validateParameter(valid_578903, JString, required = false,
                                 default = nil)
  if valid_578903 != nil:
    section.add "callback", valid_578903
  var valid_578904 = query.getOrDefault("fields")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "fields", valid_578904
  var valid_578905 = query.getOrDefault("access_token")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = nil)
  if valid_578905 != nil:
    section.add "access_token", valid_578905
  var valid_578906 = query.getOrDefault("upload_protocol")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = nil)
  if valid_578906 != nil:
    section.add "upload_protocol", valid_578906
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

proc call*(call_578908: Call_IamIamPoliciesQueryAuditableServices_578893;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of services that support service level audit logging
  ## configuration for the given resource.
  ## 
  let valid = call_578908.validator(path, query, header, formData, body)
  let scheme = call_578908.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578908.url(scheme.get, call_578908.host, call_578908.base,
                         call_578908.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578908, url, valid)

proc call*(call_578909: Call_IamIamPoliciesQueryAuditableServices_578893;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## iamIamPoliciesQueryAuditableServices
  ## Returns a list of services that support service level audit logging
  ## configuration for the given resource.
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
  var query_578910 = newJObject()
  var body_578911 = newJObject()
  add(query_578910, "key", newJString(key))
  add(query_578910, "prettyPrint", newJBool(prettyPrint))
  add(query_578910, "oauth_token", newJString(oauthToken))
  add(query_578910, "$.xgafv", newJString(Xgafv))
  add(query_578910, "alt", newJString(alt))
  add(query_578910, "uploadType", newJString(uploadType))
  add(query_578910, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578911 = body
  add(query_578910, "callback", newJString(callback))
  add(query_578910, "fields", newJString(fields))
  add(query_578910, "access_token", newJString(accessToken))
  add(query_578910, "upload_protocol", newJString(uploadProtocol))
  result = call_578909.call(nil, query_578910, nil, nil, body_578911)

var iamIamPoliciesQueryAuditableServices* = Call_IamIamPoliciesQueryAuditableServices_578893(
    name: "iamIamPoliciesQueryAuditableServices", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/iamPolicies:queryAuditableServices",
    validator: validate_IamIamPoliciesQueryAuditableServices_578894, base: "/",
    url: url_IamIamPoliciesQueryAuditableServices_578895, schemes: {Scheme.Https})
type
  Call_IamPermissionsQueryTestablePermissions_578912 = ref object of OpenApiRestCall_578348
proc url_IamPermissionsQueryTestablePermissions_578914(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IamPermissionsQueryTestablePermissions_578913(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the permissions testable on a resource.
  ## A permission is testable if it can be tested for an identity on a resource.
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
  var valid_578915 = query.getOrDefault("key")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "key", valid_578915
  var valid_578916 = query.getOrDefault("prettyPrint")
  valid_578916 = validateParameter(valid_578916, JBool, required = false,
                                 default = newJBool(true))
  if valid_578916 != nil:
    section.add "prettyPrint", valid_578916
  var valid_578917 = query.getOrDefault("oauth_token")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "oauth_token", valid_578917
  var valid_578918 = query.getOrDefault("$.xgafv")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = newJString("1"))
  if valid_578918 != nil:
    section.add "$.xgafv", valid_578918
  var valid_578919 = query.getOrDefault("alt")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = newJString("json"))
  if valid_578919 != nil:
    section.add "alt", valid_578919
  var valid_578920 = query.getOrDefault("uploadType")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "uploadType", valid_578920
  var valid_578921 = query.getOrDefault("quotaUser")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "quotaUser", valid_578921
  var valid_578922 = query.getOrDefault("callback")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "callback", valid_578922
  var valid_578923 = query.getOrDefault("fields")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "fields", valid_578923
  var valid_578924 = query.getOrDefault("access_token")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "access_token", valid_578924
  var valid_578925 = query.getOrDefault("upload_protocol")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "upload_protocol", valid_578925
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

proc call*(call_578927: Call_IamPermissionsQueryTestablePermissions_578912;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the permissions testable on a resource.
  ## A permission is testable if it can be tested for an identity on a resource.
  ## 
  let valid = call_578927.validator(path, query, header, formData, body)
  let scheme = call_578927.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578927.url(scheme.get, call_578927.host, call_578927.base,
                         call_578927.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578927, url, valid)

proc call*(call_578928: Call_IamPermissionsQueryTestablePermissions_578912;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## iamPermissionsQueryTestablePermissions
  ## Lists the permissions testable on a resource.
  ## A permission is testable if it can be tested for an identity on a resource.
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
  var query_578929 = newJObject()
  var body_578930 = newJObject()
  add(query_578929, "key", newJString(key))
  add(query_578929, "prettyPrint", newJBool(prettyPrint))
  add(query_578929, "oauth_token", newJString(oauthToken))
  add(query_578929, "$.xgafv", newJString(Xgafv))
  add(query_578929, "alt", newJString(alt))
  add(query_578929, "uploadType", newJString(uploadType))
  add(query_578929, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578930 = body
  add(query_578929, "callback", newJString(callback))
  add(query_578929, "fields", newJString(fields))
  add(query_578929, "access_token", newJString(accessToken))
  add(query_578929, "upload_protocol", newJString(uploadProtocol))
  result = call_578928.call(nil, query_578929, nil, nil, body_578930)

var iamPermissionsQueryTestablePermissions* = Call_IamPermissionsQueryTestablePermissions_578912(
    name: "iamPermissionsQueryTestablePermissions", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/permissions:queryTestablePermissions",
    validator: validate_IamPermissionsQueryTestablePermissions_578913, base: "/",
    url: url_IamPermissionsQueryTestablePermissions_578914,
    schemes: {Scheme.Https})
type
  Call_IamRolesList_578931 = ref object of OpenApiRestCall_578348
proc url_IamRolesList_578933(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IamRolesList_578932(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Roles defined on a resource.
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
  ##   pageSize: JInt
  ##           : Optional limit on the number of roles to include in the response.
  ##   alt: JString
  ##      : Data format for response.
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
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Optional pagination token returned in an earlier ListRolesResponse.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   showDeleted: JBool
  ##              : Include Roles that have been deleted.
  ##   view: JString
  ##       : Optional view for the returned Role objects. When `FULL` is specified,
  ## the `includedPermissions` field is returned, which includes a list of all
  ## permissions in the role. The default value is `BASIC`, which does not
  ## return the `includedPermissions` field.
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
  var valid_578938 = query.getOrDefault("pageSize")
  valid_578938 = validateParameter(valid_578938, JInt, required = false, default = nil)
  if valid_578938 != nil:
    section.add "pageSize", valid_578938
  var valid_578939 = query.getOrDefault("alt")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = newJString("json"))
  if valid_578939 != nil:
    section.add "alt", valid_578939
  var valid_578940 = query.getOrDefault("uploadType")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "uploadType", valid_578940
  var valid_578941 = query.getOrDefault("parent")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "parent", valid_578941
  var valid_578942 = query.getOrDefault("quotaUser")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "quotaUser", valid_578942
  var valid_578943 = query.getOrDefault("pageToken")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "pageToken", valid_578943
  var valid_578944 = query.getOrDefault("callback")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "callback", valid_578944
  var valid_578945 = query.getOrDefault("fields")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "fields", valid_578945
  var valid_578946 = query.getOrDefault("access_token")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "access_token", valid_578946
  var valid_578947 = query.getOrDefault("upload_protocol")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "upload_protocol", valid_578947
  var valid_578948 = query.getOrDefault("showDeleted")
  valid_578948 = validateParameter(valid_578948, JBool, required = false, default = nil)
  if valid_578948 != nil:
    section.add "showDeleted", valid_578948
  var valid_578949 = query.getOrDefault("view")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_578949 != nil:
    section.add "view", valid_578949
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578950: Call_IamRolesList_578931; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Roles defined on a resource.
  ## 
  let valid = call_578950.validator(path, query, header, formData, body)
  let scheme = call_578950.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578950.url(scheme.get, call_578950.host, call_578950.base,
                         call_578950.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578950, url, valid)

proc call*(call_578951: Call_IamRolesList_578931; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          parent: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; showDeleted: bool = false; view: string = "BASIC"): Recallable =
  ## iamRolesList
  ## Lists the Roles defined on a resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional limit on the number of roles to include in the response.
  ##   alt: string
  ##      : Data format for response.
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
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Optional pagination token returned in an earlier ListRolesResponse.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   showDeleted: bool
  ##              : Include Roles that have been deleted.
  ##   view: string
  ##       : Optional view for the returned Role objects. When `FULL` is specified,
  ## the `includedPermissions` field is returned, which includes a list of all
  ## permissions in the role. The default value is `BASIC`, which does not
  ## return the `includedPermissions` field.
  var query_578952 = newJObject()
  add(query_578952, "key", newJString(key))
  add(query_578952, "prettyPrint", newJBool(prettyPrint))
  add(query_578952, "oauth_token", newJString(oauthToken))
  add(query_578952, "$.xgafv", newJString(Xgafv))
  add(query_578952, "pageSize", newJInt(pageSize))
  add(query_578952, "alt", newJString(alt))
  add(query_578952, "uploadType", newJString(uploadType))
  add(query_578952, "parent", newJString(parent))
  add(query_578952, "quotaUser", newJString(quotaUser))
  add(query_578952, "pageToken", newJString(pageToken))
  add(query_578952, "callback", newJString(callback))
  add(query_578952, "fields", newJString(fields))
  add(query_578952, "access_token", newJString(accessToken))
  add(query_578952, "upload_protocol", newJString(uploadProtocol))
  add(query_578952, "showDeleted", newJBool(showDeleted))
  add(query_578952, "view", newJString(view))
  result = call_578951.call(nil, query_578952, nil, nil, nil)

var iamRolesList* = Call_IamRolesList_578931(name: "iamRolesList",
    meth: HttpMethod.HttpGet, host: "iam.googleapis.com", route: "/v1/roles",
    validator: validate_IamRolesList_578932, base: "/", url: url_IamRolesList_578933,
    schemes: {Scheme.Https})
type
  Call_IamRolesQueryGrantableRoles_578953 = ref object of OpenApiRestCall_578348
proc url_IamRolesQueryGrantableRoles_578955(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IamRolesQueryGrantableRoles_578954(path: JsonNode; query: JsonNode;
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
  var valid_578956 = query.getOrDefault("key")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "key", valid_578956
  var valid_578957 = query.getOrDefault("prettyPrint")
  valid_578957 = validateParameter(valid_578957, JBool, required = false,
                                 default = newJBool(true))
  if valid_578957 != nil:
    section.add "prettyPrint", valid_578957
  var valid_578958 = query.getOrDefault("oauth_token")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "oauth_token", valid_578958
  var valid_578959 = query.getOrDefault("$.xgafv")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = newJString("1"))
  if valid_578959 != nil:
    section.add "$.xgafv", valid_578959
  var valid_578960 = query.getOrDefault("alt")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = newJString("json"))
  if valid_578960 != nil:
    section.add "alt", valid_578960
  var valid_578961 = query.getOrDefault("uploadType")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "uploadType", valid_578961
  var valid_578962 = query.getOrDefault("quotaUser")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "quotaUser", valid_578962
  var valid_578963 = query.getOrDefault("callback")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "callback", valid_578963
  var valid_578964 = query.getOrDefault("fields")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "fields", valid_578964
  var valid_578965 = query.getOrDefault("access_token")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "access_token", valid_578965
  var valid_578966 = query.getOrDefault("upload_protocol")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "upload_protocol", valid_578966
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

proc call*(call_578968: Call_IamRolesQueryGrantableRoles_578953; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Queries roles that can be granted on a particular resource.
  ## A role is grantable if it can be used as the role in a binding for a policy
  ## for that resource.
  ## 
  let valid = call_578968.validator(path, query, header, formData, body)
  let scheme = call_578968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578968.url(scheme.get, call_578968.host, call_578968.base,
                         call_578968.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578968, url, valid)

proc call*(call_578969: Call_IamRolesQueryGrantableRoles_578953; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## iamRolesQueryGrantableRoles
  ## Queries roles that can be granted on a particular resource.
  ## A role is grantable if it can be used as the role in a binding for a policy
  ## for that resource.
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
  var query_578970 = newJObject()
  var body_578971 = newJObject()
  add(query_578970, "key", newJString(key))
  add(query_578970, "prettyPrint", newJBool(prettyPrint))
  add(query_578970, "oauth_token", newJString(oauthToken))
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
  result = call_578969.call(nil, query_578970, nil, nil, body_578971)

var iamRolesQueryGrantableRoles* = Call_IamRolesQueryGrantableRoles_578953(
    name: "iamRolesQueryGrantableRoles", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/roles:queryGrantableRoles",
    validator: validate_IamRolesQueryGrantableRoles_578954, base: "/",
    url: url_IamRolesQueryGrantableRoles_578955, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsUpdate_579006 = ref object of OpenApiRestCall_578348
proc url_IamProjectsServiceAccountsUpdate_579008(protocol: Scheme; host: string;
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

proc validate_IamProjectsServiceAccountsUpdate_579007(path: JsonNode;
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
  var valid_579009 = path.getOrDefault("name")
  valid_579009 = validateParameter(valid_579009, JString, required = true,
                                 default = nil)
  if valid_579009 != nil:
    section.add "name", valid_579009
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
  var valid_579010 = query.getOrDefault("key")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "key", valid_579010
  var valid_579011 = query.getOrDefault("prettyPrint")
  valid_579011 = validateParameter(valid_579011, JBool, required = false,
                                 default = newJBool(true))
  if valid_579011 != nil:
    section.add "prettyPrint", valid_579011
  var valid_579012 = query.getOrDefault("oauth_token")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "oauth_token", valid_579012
  var valid_579013 = query.getOrDefault("$.xgafv")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = newJString("1"))
  if valid_579013 != nil:
    section.add "$.xgafv", valid_579013
  var valid_579014 = query.getOrDefault("alt")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = newJString("json"))
  if valid_579014 != nil:
    section.add "alt", valid_579014
  var valid_579015 = query.getOrDefault("uploadType")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "uploadType", valid_579015
  var valid_579016 = query.getOrDefault("quotaUser")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "quotaUser", valid_579016
  var valid_579017 = query.getOrDefault("callback")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "callback", valid_579017
  var valid_579018 = query.getOrDefault("fields")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "fields", valid_579018
  var valid_579019 = query.getOrDefault("access_token")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "access_token", valid_579019
  var valid_579020 = query.getOrDefault("upload_protocol")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "upload_protocol", valid_579020
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

proc call*(call_579022: Call_IamProjectsServiceAccountsUpdate_579006;
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
  let valid = call_579022.validator(path, query, header, formData, body)
  let scheme = call_579022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579022.url(scheme.get, call_579022.host, call_579022.base,
                         call_579022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579022, url, valid)

proc call*(call_579023: Call_IamProjectsServiceAccountsUpdate_579006; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## iamProjectsServiceAccountsUpdate
  ## Note: This method is in the process of being deprecated. Use
  ## PatchServiceAccount instead.
  ## 
  ## Updates a ServiceAccount.
  ## 
  ## Currently, only the following fields are updatable:
  ## `display_name` and `description`.
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
  ##       : The resource name of the service account in the following format:
  ## `projects/{PROJECT_ID}/serviceAccounts/{ACCOUNT}`.
  ## 
  ## Requests using `-` as a wildcard for the `PROJECT_ID` will infer the
  ## project from the `account` and the `ACCOUNT` value can be the `email`
  ## address or the `unique_id` of the service account.
  ## 
  ## In responses the resource name will always be in the format
  ## `projects/{PROJECT_ID}/serviceAccounts/{ACCOUNT}`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579024 = newJObject()
  var query_579025 = newJObject()
  var body_579026 = newJObject()
  add(query_579025, "key", newJString(key))
  add(query_579025, "prettyPrint", newJBool(prettyPrint))
  add(query_579025, "oauth_token", newJString(oauthToken))
  add(query_579025, "$.xgafv", newJString(Xgafv))
  add(query_579025, "alt", newJString(alt))
  add(query_579025, "uploadType", newJString(uploadType))
  add(query_579025, "quotaUser", newJString(quotaUser))
  add(path_579024, "name", newJString(name))
  if body != nil:
    body_579026 = body
  add(query_579025, "callback", newJString(callback))
  add(query_579025, "fields", newJString(fields))
  add(query_579025, "access_token", newJString(accessToken))
  add(query_579025, "upload_protocol", newJString(uploadProtocol))
  result = call_579023.call(path_579024, query_579025, nil, nil, body_579026)

var iamProjectsServiceAccountsUpdate* = Call_IamProjectsServiceAccountsUpdate_579006(
    name: "iamProjectsServiceAccountsUpdate", meth: HttpMethod.HttpPut,
    host: "iam.googleapis.com", route: "/v1/{name}",
    validator: validate_IamProjectsServiceAccountsUpdate_579007, base: "/",
    url: url_IamProjectsServiceAccountsUpdate_579008, schemes: {Scheme.Https})
type
  Call_IamRolesGet_578972 = ref object of OpenApiRestCall_578348
proc url_IamRolesGet_578974(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_IamRolesGet_578973(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_578989 = path.getOrDefault("name")
  valid_578989 = validateParameter(valid_578989, JString, required = true,
                                 default = nil)
  if valid_578989 != nil:
    section.add "name", valid_578989
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
  ##   publicKeyType: JString
  ##                : The output format of the public key requested.
  ## X509_PEM is the default output format.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578990 = query.getOrDefault("key")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "key", valid_578990
  var valid_578991 = query.getOrDefault("prettyPrint")
  valid_578991 = validateParameter(valid_578991, JBool, required = false,
                                 default = newJBool(true))
  if valid_578991 != nil:
    section.add "prettyPrint", valid_578991
  var valid_578992 = query.getOrDefault("oauth_token")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "oauth_token", valid_578992
  var valid_578993 = query.getOrDefault("$.xgafv")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = newJString("1"))
  if valid_578993 != nil:
    section.add "$.xgafv", valid_578993
  var valid_578994 = query.getOrDefault("alt")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = newJString("json"))
  if valid_578994 != nil:
    section.add "alt", valid_578994
  var valid_578995 = query.getOrDefault("uploadType")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "uploadType", valid_578995
  var valid_578996 = query.getOrDefault("quotaUser")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "quotaUser", valid_578996
  var valid_578997 = query.getOrDefault("publicKeyType")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = newJString("TYPE_NONE"))
  if valid_578997 != nil:
    section.add "publicKeyType", valid_578997
  var valid_578998 = query.getOrDefault("callback")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "callback", valid_578998
  var valid_578999 = query.getOrDefault("fields")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "fields", valid_578999
  var valid_579000 = query.getOrDefault("access_token")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "access_token", valid_579000
  var valid_579001 = query.getOrDefault("upload_protocol")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "upload_protocol", valid_579001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579002: Call_IamRolesGet_578972; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Role definition.
  ## 
  let valid = call_579002.validator(path, query, header, formData, body)
  let scheme = call_579002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579002.url(scheme.get, call_579002.host, call_579002.base,
                         call_579002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579002, url, valid)

proc call*(call_579003: Call_IamRolesGet_578972; name: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          publicKeyType: string = "TYPE_NONE"; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## iamRolesGet
  ## Gets a Role definition.
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
  ##   publicKeyType: string
  ##                : The output format of the public key requested.
  ## X509_PEM is the default output format.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579004 = newJObject()
  var query_579005 = newJObject()
  add(query_579005, "key", newJString(key))
  add(query_579005, "prettyPrint", newJBool(prettyPrint))
  add(query_579005, "oauth_token", newJString(oauthToken))
  add(query_579005, "$.xgafv", newJString(Xgafv))
  add(query_579005, "alt", newJString(alt))
  add(query_579005, "uploadType", newJString(uploadType))
  add(query_579005, "quotaUser", newJString(quotaUser))
  add(path_579004, "name", newJString(name))
  add(query_579005, "publicKeyType", newJString(publicKeyType))
  add(query_579005, "callback", newJString(callback))
  add(query_579005, "fields", newJString(fields))
  add(query_579005, "access_token", newJString(accessToken))
  add(query_579005, "upload_protocol", newJString(uploadProtocol))
  result = call_579003.call(path_579004, query_579005, nil, nil, nil)

var iamRolesGet* = Call_IamRolesGet_578972(name: "iamRolesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "iam.googleapis.com",
                                        route: "/v1/{name}",
                                        validator: validate_IamRolesGet_578973,
                                        base: "/", url: url_IamRolesGet_578974,
                                        schemes: {Scheme.Https})
type
  Call_IamProjectsRolesPatch_579047 = ref object of OpenApiRestCall_578348
proc url_IamProjectsRolesPatch_579049(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_IamProjectsRolesPatch_579048(path: JsonNode; query: JsonNode;
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
  var valid_579050 = path.getOrDefault("name")
  valid_579050 = validateParameter(valid_579050, JString, required = true,
                                 default = nil)
  if valid_579050 != nil:
    section.add "name", valid_579050
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
  ##   updateMask: JString
  ##             : A mask describing which fields in the Role have changed.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579051 = query.getOrDefault("key")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "key", valid_579051
  var valid_579052 = query.getOrDefault("prettyPrint")
  valid_579052 = validateParameter(valid_579052, JBool, required = false,
                                 default = newJBool(true))
  if valid_579052 != nil:
    section.add "prettyPrint", valid_579052
  var valid_579053 = query.getOrDefault("oauth_token")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "oauth_token", valid_579053
  var valid_579054 = query.getOrDefault("$.xgafv")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = newJString("1"))
  if valid_579054 != nil:
    section.add "$.xgafv", valid_579054
  var valid_579055 = query.getOrDefault("alt")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = newJString("json"))
  if valid_579055 != nil:
    section.add "alt", valid_579055
  var valid_579056 = query.getOrDefault("uploadType")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "uploadType", valid_579056
  var valid_579057 = query.getOrDefault("quotaUser")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "quotaUser", valid_579057
  var valid_579058 = query.getOrDefault("updateMask")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "updateMask", valid_579058
  var valid_579059 = query.getOrDefault("callback")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "callback", valid_579059
  var valid_579060 = query.getOrDefault("fields")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "fields", valid_579060
  var valid_579061 = query.getOrDefault("access_token")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "access_token", valid_579061
  var valid_579062 = query.getOrDefault("upload_protocol")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "upload_protocol", valid_579062
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

proc call*(call_579064: Call_IamProjectsRolesPatch_579047; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Role definition.
  ## 
  let valid = call_579064.validator(path, query, header, formData, body)
  let scheme = call_579064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579064.url(scheme.get, call_579064.host, call_579064.base,
                         call_579064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579064, url, valid)

proc call*(call_579065: Call_IamProjectsRolesPatch_579047; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; updateMask: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## iamProjectsRolesPatch
  ## Updates a Role definition.
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
  ##   updateMask: string
  ##             : A mask describing which fields in the Role have changed.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579066 = newJObject()
  var query_579067 = newJObject()
  var body_579068 = newJObject()
  add(query_579067, "key", newJString(key))
  add(query_579067, "prettyPrint", newJBool(prettyPrint))
  add(query_579067, "oauth_token", newJString(oauthToken))
  add(query_579067, "$.xgafv", newJString(Xgafv))
  add(query_579067, "alt", newJString(alt))
  add(query_579067, "uploadType", newJString(uploadType))
  add(query_579067, "quotaUser", newJString(quotaUser))
  add(path_579066, "name", newJString(name))
  add(query_579067, "updateMask", newJString(updateMask))
  if body != nil:
    body_579068 = body
  add(query_579067, "callback", newJString(callback))
  add(query_579067, "fields", newJString(fields))
  add(query_579067, "access_token", newJString(accessToken))
  add(query_579067, "upload_protocol", newJString(uploadProtocol))
  result = call_579065.call(path_579066, query_579067, nil, nil, body_579068)

var iamProjectsRolesPatch* = Call_IamProjectsRolesPatch_579047(
    name: "iamProjectsRolesPatch", meth: HttpMethod.HttpPatch,
    host: "iam.googleapis.com", route: "/v1/{name}",
    validator: validate_IamProjectsRolesPatch_579048, base: "/",
    url: url_IamProjectsRolesPatch_579049, schemes: {Scheme.Https})
type
  Call_IamProjectsRolesDelete_579027 = ref object of OpenApiRestCall_578348
proc url_IamProjectsRolesDelete_579029(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_IamProjectsRolesDelete_579028(path: JsonNode; query: JsonNode;
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
  var valid_579030 = path.getOrDefault("name")
  valid_579030 = validateParameter(valid_579030, JString, required = true,
                                 default = nil)
  if valid_579030 != nil:
    section.add "name", valid_579030
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
  ##   etag: JString
  ##       : Used to perform a consistent read-modify-write.
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
  var valid_579031 = query.getOrDefault("key")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "key", valid_579031
  var valid_579032 = query.getOrDefault("prettyPrint")
  valid_579032 = validateParameter(valid_579032, JBool, required = false,
                                 default = newJBool(true))
  if valid_579032 != nil:
    section.add "prettyPrint", valid_579032
  var valid_579033 = query.getOrDefault("oauth_token")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "oauth_token", valid_579033
  var valid_579034 = query.getOrDefault("$.xgafv")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = newJString("1"))
  if valid_579034 != nil:
    section.add "$.xgafv", valid_579034
  var valid_579035 = query.getOrDefault("etag")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "etag", valid_579035
  var valid_579036 = query.getOrDefault("alt")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = newJString("json"))
  if valid_579036 != nil:
    section.add "alt", valid_579036
  var valid_579037 = query.getOrDefault("uploadType")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "uploadType", valid_579037
  var valid_579038 = query.getOrDefault("quotaUser")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "quotaUser", valid_579038
  var valid_579039 = query.getOrDefault("callback")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "callback", valid_579039
  var valid_579040 = query.getOrDefault("fields")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "fields", valid_579040
  var valid_579041 = query.getOrDefault("access_token")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "access_token", valid_579041
  var valid_579042 = query.getOrDefault("upload_protocol")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "upload_protocol", valid_579042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579043: Call_IamProjectsRolesDelete_579027; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Soft deletes a role. The role is suspended and cannot be used to create new
  ## IAM Policy Bindings.
  ## The Role will not be included in `ListRoles()` unless `show_deleted` is set
  ## in the `ListRolesRequest`. The Role contains the deleted boolean set.
  ## Existing Bindings remains, but are inactive. The Role can be undeleted
  ## within 7 days. After 7 days the Role is deleted and all Bindings associated
  ## with the role are removed.
  ## 
  let valid = call_579043.validator(path, query, header, formData, body)
  let scheme = call_579043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579043.url(scheme.get, call_579043.host, call_579043.base,
                         call_579043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579043, url, valid)

proc call*(call_579044: Call_IamProjectsRolesDelete_579027; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; etag: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## iamProjectsRolesDelete
  ## Soft deletes a role. The role is suspended and cannot be used to create new
  ## IAM Policy Bindings.
  ## The Role will not be included in `ListRoles()` unless `show_deleted` is set
  ## in the `ListRolesRequest`. The Role contains the deleted boolean set.
  ## Existing Bindings remains, but are inactive. The Role can be undeleted
  ## within 7 days. After 7 days the Role is deleted and all Bindings associated
  ## with the role are removed.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   etag: string
  ##       : Used to perform a consistent read-modify-write.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
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
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579045 = newJObject()
  var query_579046 = newJObject()
  add(query_579046, "key", newJString(key))
  add(query_579046, "prettyPrint", newJBool(prettyPrint))
  add(query_579046, "oauth_token", newJString(oauthToken))
  add(query_579046, "$.xgafv", newJString(Xgafv))
  add(query_579046, "etag", newJString(etag))
  add(query_579046, "alt", newJString(alt))
  add(query_579046, "uploadType", newJString(uploadType))
  add(query_579046, "quotaUser", newJString(quotaUser))
  add(path_579045, "name", newJString(name))
  add(query_579046, "callback", newJString(callback))
  add(query_579046, "fields", newJString(fields))
  add(query_579046, "access_token", newJString(accessToken))
  add(query_579046, "upload_protocol", newJString(uploadProtocol))
  result = call_579044.call(path_579045, query_579046, nil, nil, nil)

var iamProjectsRolesDelete* = Call_IamProjectsRolesDelete_579027(
    name: "iamProjectsRolesDelete", meth: HttpMethod.HttpDelete,
    host: "iam.googleapis.com", route: "/v1/{name}",
    validator: validate_IamProjectsRolesDelete_579028, base: "/",
    url: url_IamProjectsRolesDelete_579029, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsKeysCreate_579089 = ref object of OpenApiRestCall_578348
proc url_IamProjectsServiceAccountsKeysCreate_579091(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_IamProjectsServiceAccountsKeysCreate_579090(path: JsonNode;
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
  var valid_579092 = path.getOrDefault("name")
  valid_579092 = validateParameter(valid_579092, JString, required = true,
                                 default = nil)
  if valid_579092 != nil:
    section.add "name", valid_579092
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
  var valid_579093 = query.getOrDefault("key")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "key", valid_579093
  var valid_579094 = query.getOrDefault("prettyPrint")
  valid_579094 = validateParameter(valid_579094, JBool, required = false,
                                 default = newJBool(true))
  if valid_579094 != nil:
    section.add "prettyPrint", valid_579094
  var valid_579095 = query.getOrDefault("oauth_token")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "oauth_token", valid_579095
  var valid_579096 = query.getOrDefault("$.xgafv")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = newJString("1"))
  if valid_579096 != nil:
    section.add "$.xgafv", valid_579096
  var valid_579097 = query.getOrDefault("alt")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = newJString("json"))
  if valid_579097 != nil:
    section.add "alt", valid_579097
  var valid_579098 = query.getOrDefault("uploadType")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "uploadType", valid_579098
  var valid_579099 = query.getOrDefault("quotaUser")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "quotaUser", valid_579099
  var valid_579100 = query.getOrDefault("callback")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "callback", valid_579100
  var valid_579101 = query.getOrDefault("fields")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "fields", valid_579101
  var valid_579102 = query.getOrDefault("access_token")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "access_token", valid_579102
  var valid_579103 = query.getOrDefault("upload_protocol")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "upload_protocol", valid_579103
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

proc call*(call_579105: Call_IamProjectsServiceAccountsKeysCreate_579089;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a ServiceAccountKey
  ## and returns it.
  ## 
  let valid = call_579105.validator(path, query, header, formData, body)
  let scheme = call_579105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579105.url(scheme.get, call_579105.host, call_579105.base,
                         call_579105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579105, url, valid)

proc call*(call_579106: Call_IamProjectsServiceAccountsKeysCreate_579089;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## iamProjectsServiceAccountsKeysCreate
  ## Creates a ServiceAccountKey
  ## and returns it.
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
  ##       : The resource name of the service account in the following format:
  ## `projects/{PROJECT_ID}/serviceAccounts/{ACCOUNT}`.
  ## Using `-` as a wildcard for the `PROJECT_ID` will infer the project from
  ## the account. The `ACCOUNT` value can be the `email` address or the
  ## `unique_id` of the service account.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579107 = newJObject()
  var query_579108 = newJObject()
  var body_579109 = newJObject()
  add(query_579108, "key", newJString(key))
  add(query_579108, "prettyPrint", newJBool(prettyPrint))
  add(query_579108, "oauth_token", newJString(oauthToken))
  add(query_579108, "$.xgafv", newJString(Xgafv))
  add(query_579108, "alt", newJString(alt))
  add(query_579108, "uploadType", newJString(uploadType))
  add(query_579108, "quotaUser", newJString(quotaUser))
  add(path_579107, "name", newJString(name))
  if body != nil:
    body_579109 = body
  add(query_579108, "callback", newJString(callback))
  add(query_579108, "fields", newJString(fields))
  add(query_579108, "access_token", newJString(accessToken))
  add(query_579108, "upload_protocol", newJString(uploadProtocol))
  result = call_579106.call(path_579107, query_579108, nil, nil, body_579109)

var iamProjectsServiceAccountsKeysCreate* = Call_IamProjectsServiceAccountsKeysCreate_579089(
    name: "iamProjectsServiceAccountsKeysCreate", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}/keys",
    validator: validate_IamProjectsServiceAccountsKeysCreate_579090, base: "/",
    url: url_IamProjectsServiceAccountsKeysCreate_579091, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsKeysList_579069 = ref object of OpenApiRestCall_578348
proc url_IamProjectsServiceAccountsKeysList_579071(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_IamProjectsServiceAccountsKeysList_579070(path: JsonNode;
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
  var valid_579072 = path.getOrDefault("name")
  valid_579072 = validateParameter(valid_579072, JString, required = true,
                                 default = nil)
  if valid_579072 != nil:
    section.add "name", valid_579072
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
  ##   keyTypes: JArray
  ##           : Filters the types of keys the user wants to include in the list
  ## response. Duplicate key types are not allowed. If no key type
  ## is provided, all keys are returned.
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
  var valid_579073 = query.getOrDefault("key")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "key", valid_579073
  var valid_579074 = query.getOrDefault("prettyPrint")
  valid_579074 = validateParameter(valid_579074, JBool, required = false,
                                 default = newJBool(true))
  if valid_579074 != nil:
    section.add "prettyPrint", valid_579074
  var valid_579075 = query.getOrDefault("oauth_token")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "oauth_token", valid_579075
  var valid_579076 = query.getOrDefault("$.xgafv")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = newJString("1"))
  if valid_579076 != nil:
    section.add "$.xgafv", valid_579076
  var valid_579077 = query.getOrDefault("keyTypes")
  valid_579077 = validateParameter(valid_579077, JArray, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "keyTypes", valid_579077
  var valid_579078 = query.getOrDefault("alt")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = newJString("json"))
  if valid_579078 != nil:
    section.add "alt", valid_579078
  var valid_579079 = query.getOrDefault("uploadType")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "uploadType", valid_579079
  var valid_579080 = query.getOrDefault("quotaUser")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "quotaUser", valid_579080
  var valid_579081 = query.getOrDefault("callback")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "callback", valid_579081
  var valid_579082 = query.getOrDefault("fields")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "fields", valid_579082
  var valid_579083 = query.getOrDefault("access_token")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "access_token", valid_579083
  var valid_579084 = query.getOrDefault("upload_protocol")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "upload_protocol", valid_579084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579085: Call_IamProjectsServiceAccountsKeysList_579069;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists ServiceAccountKeys.
  ## 
  let valid = call_579085.validator(path, query, header, formData, body)
  let scheme = call_579085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579085.url(scheme.get, call_579085.host, call_579085.base,
                         call_579085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579085, url, valid)

proc call*(call_579086: Call_IamProjectsServiceAccountsKeysList_579069;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; keyTypes: JsonNode = nil;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## iamProjectsServiceAccountsKeysList
  ## Lists ServiceAccountKeys.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   keyTypes: JArray
  ##           : Filters the types of keys the user wants to include in the list
  ## response. Duplicate key types are not allowed. If no key type
  ## is provided, all keys are returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the service account in the following format:
  ## `projects/{PROJECT_ID}/serviceAccounts/{ACCOUNT}`.
  ## 
  ## Using `-` as a wildcard for the `PROJECT_ID`, will infer the project from
  ## the account. The `ACCOUNT` value can be the `email` address or the
  ## `unique_id` of the service account.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579087 = newJObject()
  var query_579088 = newJObject()
  add(query_579088, "key", newJString(key))
  add(query_579088, "prettyPrint", newJBool(prettyPrint))
  add(query_579088, "oauth_token", newJString(oauthToken))
  add(query_579088, "$.xgafv", newJString(Xgafv))
  if keyTypes != nil:
    query_579088.add "keyTypes", keyTypes
  add(query_579088, "alt", newJString(alt))
  add(query_579088, "uploadType", newJString(uploadType))
  add(query_579088, "quotaUser", newJString(quotaUser))
  add(path_579087, "name", newJString(name))
  add(query_579088, "callback", newJString(callback))
  add(query_579088, "fields", newJString(fields))
  add(query_579088, "access_token", newJString(accessToken))
  add(query_579088, "upload_protocol", newJString(uploadProtocol))
  result = call_579086.call(path_579087, query_579088, nil, nil, nil)

var iamProjectsServiceAccountsKeysList* = Call_IamProjectsServiceAccountsKeysList_579069(
    name: "iamProjectsServiceAccountsKeysList", meth: HttpMethod.HttpGet,
    host: "iam.googleapis.com", route: "/v1/{name}/keys",
    validator: validate_IamProjectsServiceAccountsKeysList_579070, base: "/",
    url: url_IamProjectsServiceAccountsKeysList_579071, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsKeysUpload_579110 = ref object of OpenApiRestCall_578348
proc url_IamProjectsServiceAccountsKeysUpload_579112(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_IamProjectsServiceAccountsKeysUpload_579111(path: JsonNode;
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
  var valid_579113 = path.getOrDefault("name")
  valid_579113 = validateParameter(valid_579113, JString, required = true,
                                 default = nil)
  if valid_579113 != nil:
    section.add "name", valid_579113
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
  var valid_579114 = query.getOrDefault("key")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "key", valid_579114
  var valid_579115 = query.getOrDefault("prettyPrint")
  valid_579115 = validateParameter(valid_579115, JBool, required = false,
                                 default = newJBool(true))
  if valid_579115 != nil:
    section.add "prettyPrint", valid_579115
  var valid_579116 = query.getOrDefault("oauth_token")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "oauth_token", valid_579116
  var valid_579117 = query.getOrDefault("$.xgafv")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = newJString("1"))
  if valid_579117 != nil:
    section.add "$.xgafv", valid_579117
  var valid_579118 = query.getOrDefault("alt")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = newJString("json"))
  if valid_579118 != nil:
    section.add "alt", valid_579118
  var valid_579119 = query.getOrDefault("uploadType")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "uploadType", valid_579119
  var valid_579120 = query.getOrDefault("quotaUser")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "quotaUser", valid_579120
  var valid_579121 = query.getOrDefault("callback")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "callback", valid_579121
  var valid_579122 = query.getOrDefault("fields")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "fields", valid_579122
  var valid_579123 = query.getOrDefault("access_token")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "access_token", valid_579123
  var valid_579124 = query.getOrDefault("upload_protocol")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "upload_protocol", valid_579124
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

proc call*(call_579126: Call_IamProjectsServiceAccountsKeysUpload_579110;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Upload public key for a given service account.
  ## This rpc will create a
  ## ServiceAccountKey that has the
  ## provided public key and returns it.
  ## 
  let valid = call_579126.validator(path, query, header, formData, body)
  let scheme = call_579126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579126.url(scheme.get, call_579126.host, call_579126.base,
                         call_579126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579126, url, valid)

proc call*(call_579127: Call_IamProjectsServiceAccountsKeysUpload_579110;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## iamProjectsServiceAccountsKeysUpload
  ## Upload public key for a given service account.
  ## This rpc will create a
  ## ServiceAccountKey that has the
  ## provided public key and returns it.
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
  ##       : The resource name of the service account in the following format:
  ## `projects/{PROJECT_ID}/serviceAccounts/{ACCOUNT}`.
  ## Using `-` as a wildcard for the `PROJECT_ID` will infer the project from
  ## the account. The `ACCOUNT` value can be the `email` address or the
  ## `unique_id` of the service account.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579128 = newJObject()
  var query_579129 = newJObject()
  var body_579130 = newJObject()
  add(query_579129, "key", newJString(key))
  add(query_579129, "prettyPrint", newJBool(prettyPrint))
  add(query_579129, "oauth_token", newJString(oauthToken))
  add(query_579129, "$.xgafv", newJString(Xgafv))
  add(query_579129, "alt", newJString(alt))
  add(query_579129, "uploadType", newJString(uploadType))
  add(query_579129, "quotaUser", newJString(quotaUser))
  add(path_579128, "name", newJString(name))
  if body != nil:
    body_579130 = body
  add(query_579129, "callback", newJString(callback))
  add(query_579129, "fields", newJString(fields))
  add(query_579129, "access_token", newJString(accessToken))
  add(query_579129, "upload_protocol", newJString(uploadProtocol))
  result = call_579127.call(path_579128, query_579129, nil, nil, body_579130)

var iamProjectsServiceAccountsKeysUpload* = Call_IamProjectsServiceAccountsKeysUpload_579110(
    name: "iamProjectsServiceAccountsKeysUpload", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}/keys:upload",
    validator: validate_IamProjectsServiceAccountsKeysUpload_579111, base: "/",
    url: url_IamProjectsServiceAccountsKeysUpload_579112, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsCreate_579152 = ref object of OpenApiRestCall_578348
proc url_IamProjectsServiceAccountsCreate_579154(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_IamProjectsServiceAccountsCreate_579153(path: JsonNode;
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
  var valid_579155 = path.getOrDefault("name")
  valid_579155 = validateParameter(valid_579155, JString, required = true,
                                 default = nil)
  if valid_579155 != nil:
    section.add "name", valid_579155
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
  var valid_579156 = query.getOrDefault("key")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = nil)
  if valid_579156 != nil:
    section.add "key", valid_579156
  var valid_579157 = query.getOrDefault("prettyPrint")
  valid_579157 = validateParameter(valid_579157, JBool, required = false,
                                 default = newJBool(true))
  if valid_579157 != nil:
    section.add "prettyPrint", valid_579157
  var valid_579158 = query.getOrDefault("oauth_token")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = nil)
  if valid_579158 != nil:
    section.add "oauth_token", valid_579158
  var valid_579159 = query.getOrDefault("$.xgafv")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = newJString("1"))
  if valid_579159 != nil:
    section.add "$.xgafv", valid_579159
  var valid_579160 = query.getOrDefault("alt")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = newJString("json"))
  if valid_579160 != nil:
    section.add "alt", valid_579160
  var valid_579161 = query.getOrDefault("uploadType")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = nil)
  if valid_579161 != nil:
    section.add "uploadType", valid_579161
  var valid_579162 = query.getOrDefault("quotaUser")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "quotaUser", valid_579162
  var valid_579163 = query.getOrDefault("callback")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "callback", valid_579163
  var valid_579164 = query.getOrDefault("fields")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "fields", valid_579164
  var valid_579165 = query.getOrDefault("access_token")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "access_token", valid_579165
  var valid_579166 = query.getOrDefault("upload_protocol")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = nil)
  if valid_579166 != nil:
    section.add "upload_protocol", valid_579166
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

proc call*(call_579168: Call_IamProjectsServiceAccountsCreate_579152;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a ServiceAccount
  ## and returns it.
  ## 
  let valid = call_579168.validator(path, query, header, formData, body)
  let scheme = call_579168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579168.url(scheme.get, call_579168.host, call_579168.base,
                         call_579168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579168, url, valid)

proc call*(call_579169: Call_IamProjectsServiceAccountsCreate_579152; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## iamProjectsServiceAccountsCreate
  ## Creates a ServiceAccount
  ## and returns it.
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
  ##       : Required. The resource name of the project associated with the service
  ## accounts, such as `projects/my-project-123`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579170 = newJObject()
  var query_579171 = newJObject()
  var body_579172 = newJObject()
  add(query_579171, "key", newJString(key))
  add(query_579171, "prettyPrint", newJBool(prettyPrint))
  add(query_579171, "oauth_token", newJString(oauthToken))
  add(query_579171, "$.xgafv", newJString(Xgafv))
  add(query_579171, "alt", newJString(alt))
  add(query_579171, "uploadType", newJString(uploadType))
  add(query_579171, "quotaUser", newJString(quotaUser))
  add(path_579170, "name", newJString(name))
  if body != nil:
    body_579172 = body
  add(query_579171, "callback", newJString(callback))
  add(query_579171, "fields", newJString(fields))
  add(query_579171, "access_token", newJString(accessToken))
  add(query_579171, "upload_protocol", newJString(uploadProtocol))
  result = call_579169.call(path_579170, query_579171, nil, nil, body_579172)

var iamProjectsServiceAccountsCreate* = Call_IamProjectsServiceAccountsCreate_579152(
    name: "iamProjectsServiceAccountsCreate", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}/serviceAccounts",
    validator: validate_IamProjectsServiceAccountsCreate_579153, base: "/",
    url: url_IamProjectsServiceAccountsCreate_579154, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsList_579131 = ref object of OpenApiRestCall_578348
proc url_IamProjectsServiceAccountsList_579133(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_IamProjectsServiceAccountsList_579132(path: JsonNode;
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
  var valid_579134 = path.getOrDefault("name")
  valid_579134 = validateParameter(valid_579134, JString, required = true,
                                 default = nil)
  if valid_579134 != nil:
    section.add "name", valid_579134
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
  ##           : Optional limit on the number of service accounts to include in the
  ## response. Further accounts can subsequently be obtained by including the
  ## ListServiceAccountsResponse.next_page_token
  ## in a subsequent request.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Optional pagination token returned in an earlier
  ## ListServiceAccountsResponse.next_page_token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579135 = query.getOrDefault("key")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "key", valid_579135
  var valid_579136 = query.getOrDefault("prettyPrint")
  valid_579136 = validateParameter(valid_579136, JBool, required = false,
                                 default = newJBool(true))
  if valid_579136 != nil:
    section.add "prettyPrint", valid_579136
  var valid_579137 = query.getOrDefault("oauth_token")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = nil)
  if valid_579137 != nil:
    section.add "oauth_token", valid_579137
  var valid_579138 = query.getOrDefault("$.xgafv")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = newJString("1"))
  if valid_579138 != nil:
    section.add "$.xgafv", valid_579138
  var valid_579139 = query.getOrDefault("pageSize")
  valid_579139 = validateParameter(valid_579139, JInt, required = false, default = nil)
  if valid_579139 != nil:
    section.add "pageSize", valid_579139
  var valid_579140 = query.getOrDefault("alt")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = newJString("json"))
  if valid_579140 != nil:
    section.add "alt", valid_579140
  var valid_579141 = query.getOrDefault("uploadType")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "uploadType", valid_579141
  var valid_579142 = query.getOrDefault("quotaUser")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "quotaUser", valid_579142
  var valid_579143 = query.getOrDefault("pageToken")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "pageToken", valid_579143
  var valid_579144 = query.getOrDefault("callback")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "callback", valid_579144
  var valid_579145 = query.getOrDefault("fields")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "fields", valid_579145
  var valid_579146 = query.getOrDefault("access_token")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "access_token", valid_579146
  var valid_579147 = query.getOrDefault("upload_protocol")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "upload_protocol", valid_579147
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579148: Call_IamProjectsServiceAccountsList_579131; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists ServiceAccounts for a project.
  ## 
  let valid = call_579148.validator(path, query, header, formData, body)
  let scheme = call_579148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579148.url(scheme.get, call_579148.host, call_579148.base,
                         call_579148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579148, url, valid)

proc call*(call_579149: Call_IamProjectsServiceAccountsList_579131; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## iamProjectsServiceAccountsList
  ## Lists ServiceAccounts for a project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional limit on the number of service accounts to include in the
  ## response. Further accounts can subsequently be obtained by including the
  ## ListServiceAccountsResponse.next_page_token
  ## in a subsequent request.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The resource name of the project associated with the service
  ## accounts, such as `projects/my-project-123`.
  ##   pageToken: string
  ##            : Optional pagination token returned in an earlier
  ## ListServiceAccountsResponse.next_page_token.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579150 = newJObject()
  var query_579151 = newJObject()
  add(query_579151, "key", newJString(key))
  add(query_579151, "prettyPrint", newJBool(prettyPrint))
  add(query_579151, "oauth_token", newJString(oauthToken))
  add(query_579151, "$.xgafv", newJString(Xgafv))
  add(query_579151, "pageSize", newJInt(pageSize))
  add(query_579151, "alt", newJString(alt))
  add(query_579151, "uploadType", newJString(uploadType))
  add(query_579151, "quotaUser", newJString(quotaUser))
  add(path_579150, "name", newJString(name))
  add(query_579151, "pageToken", newJString(pageToken))
  add(query_579151, "callback", newJString(callback))
  add(query_579151, "fields", newJString(fields))
  add(query_579151, "access_token", newJString(accessToken))
  add(query_579151, "upload_protocol", newJString(uploadProtocol))
  result = call_579149.call(path_579150, query_579151, nil, nil, nil)

var iamProjectsServiceAccountsList* = Call_IamProjectsServiceAccountsList_579131(
    name: "iamProjectsServiceAccountsList", meth: HttpMethod.HttpGet,
    host: "iam.googleapis.com", route: "/v1/{name}/serviceAccounts",
    validator: validate_IamProjectsServiceAccountsList_579132, base: "/",
    url: url_IamProjectsServiceAccountsList_579133, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsDisable_579173 = ref object of OpenApiRestCall_578348
proc url_IamProjectsServiceAccountsDisable_579175(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_IamProjectsServiceAccountsDisable_579174(path: JsonNode;
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
  var valid_579176 = path.getOrDefault("name")
  valid_579176 = validateParameter(valid_579176, JString, required = true,
                                 default = nil)
  if valid_579176 != nil:
    section.add "name", valid_579176
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
  var valid_579177 = query.getOrDefault("key")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "key", valid_579177
  var valid_579178 = query.getOrDefault("prettyPrint")
  valid_579178 = validateParameter(valid_579178, JBool, required = false,
                                 default = newJBool(true))
  if valid_579178 != nil:
    section.add "prettyPrint", valid_579178
  var valid_579179 = query.getOrDefault("oauth_token")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "oauth_token", valid_579179
  var valid_579180 = query.getOrDefault("$.xgafv")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = newJString("1"))
  if valid_579180 != nil:
    section.add "$.xgafv", valid_579180
  var valid_579181 = query.getOrDefault("alt")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = newJString("json"))
  if valid_579181 != nil:
    section.add "alt", valid_579181
  var valid_579182 = query.getOrDefault("uploadType")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = nil)
  if valid_579182 != nil:
    section.add "uploadType", valid_579182
  var valid_579183 = query.getOrDefault("quotaUser")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "quotaUser", valid_579183
  var valid_579184 = query.getOrDefault("callback")
  valid_579184 = validateParameter(valid_579184, JString, required = false,
                                 default = nil)
  if valid_579184 != nil:
    section.add "callback", valid_579184
  var valid_579185 = query.getOrDefault("fields")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "fields", valid_579185
  var valid_579186 = query.getOrDefault("access_token")
  valid_579186 = validateParameter(valid_579186, JString, required = false,
                                 default = nil)
  if valid_579186 != nil:
    section.add "access_token", valid_579186
  var valid_579187 = query.getOrDefault("upload_protocol")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = nil)
  if valid_579187 != nil:
    section.add "upload_protocol", valid_579187
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

proc call*(call_579189: Call_IamProjectsServiceAccountsDisable_579173;
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
  let valid = call_579189.validator(path, query, header, formData, body)
  let scheme = call_579189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579189.url(scheme.get, call_579189.host, call_579189.base,
                         call_579189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579189, url, valid)

proc call*(call_579190: Call_IamProjectsServiceAccountsDisable_579173;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##       : The resource name of the service account in the following format:
  ## `projects/{PROJECT_ID}/serviceAccounts/{ACCOUNT}`.
  ## Using `-` as a wildcard for the `PROJECT_ID` will infer the project from
  ## the account. The `ACCOUNT` value can be the `email` address or the
  ## `unique_id` of the service account.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579191 = newJObject()
  var query_579192 = newJObject()
  var body_579193 = newJObject()
  add(query_579192, "key", newJString(key))
  add(query_579192, "prettyPrint", newJBool(prettyPrint))
  add(query_579192, "oauth_token", newJString(oauthToken))
  add(query_579192, "$.xgafv", newJString(Xgafv))
  add(query_579192, "alt", newJString(alt))
  add(query_579192, "uploadType", newJString(uploadType))
  add(query_579192, "quotaUser", newJString(quotaUser))
  add(path_579191, "name", newJString(name))
  if body != nil:
    body_579193 = body
  add(query_579192, "callback", newJString(callback))
  add(query_579192, "fields", newJString(fields))
  add(query_579192, "access_token", newJString(accessToken))
  add(query_579192, "upload_protocol", newJString(uploadProtocol))
  result = call_579190.call(path_579191, query_579192, nil, nil, body_579193)

var iamProjectsServiceAccountsDisable* = Call_IamProjectsServiceAccountsDisable_579173(
    name: "iamProjectsServiceAccountsDisable", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}:disable",
    validator: validate_IamProjectsServiceAccountsDisable_579174, base: "/",
    url: url_IamProjectsServiceAccountsDisable_579175, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsEnable_579194 = ref object of OpenApiRestCall_578348
proc url_IamProjectsServiceAccountsEnable_579196(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_IamProjectsServiceAccountsEnable_579195(path: JsonNode;
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
  var valid_579197 = path.getOrDefault("name")
  valid_579197 = validateParameter(valid_579197, JString, required = true,
                                 default = nil)
  if valid_579197 != nil:
    section.add "name", valid_579197
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
  var valid_579198 = query.getOrDefault("key")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "key", valid_579198
  var valid_579199 = query.getOrDefault("prettyPrint")
  valid_579199 = validateParameter(valid_579199, JBool, required = false,
                                 default = newJBool(true))
  if valid_579199 != nil:
    section.add "prettyPrint", valid_579199
  var valid_579200 = query.getOrDefault("oauth_token")
  valid_579200 = validateParameter(valid_579200, JString, required = false,
                                 default = nil)
  if valid_579200 != nil:
    section.add "oauth_token", valid_579200
  var valid_579201 = query.getOrDefault("$.xgafv")
  valid_579201 = validateParameter(valid_579201, JString, required = false,
                                 default = newJString("1"))
  if valid_579201 != nil:
    section.add "$.xgafv", valid_579201
  var valid_579202 = query.getOrDefault("alt")
  valid_579202 = validateParameter(valid_579202, JString, required = false,
                                 default = newJString("json"))
  if valid_579202 != nil:
    section.add "alt", valid_579202
  var valid_579203 = query.getOrDefault("uploadType")
  valid_579203 = validateParameter(valid_579203, JString, required = false,
                                 default = nil)
  if valid_579203 != nil:
    section.add "uploadType", valid_579203
  var valid_579204 = query.getOrDefault("quotaUser")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = nil)
  if valid_579204 != nil:
    section.add "quotaUser", valid_579204
  var valid_579205 = query.getOrDefault("callback")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = nil)
  if valid_579205 != nil:
    section.add "callback", valid_579205
  var valid_579206 = query.getOrDefault("fields")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = nil)
  if valid_579206 != nil:
    section.add "fields", valid_579206
  var valid_579207 = query.getOrDefault("access_token")
  valid_579207 = validateParameter(valid_579207, JString, required = false,
                                 default = nil)
  if valid_579207 != nil:
    section.add "access_token", valid_579207
  var valid_579208 = query.getOrDefault("upload_protocol")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = nil)
  if valid_579208 != nil:
    section.add "upload_protocol", valid_579208
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

proc call*(call_579210: Call_IamProjectsServiceAccountsEnable_579194;
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
  let valid = call_579210.validator(path, query, header, formData, body)
  let scheme = call_579210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579210.url(scheme.get, call_579210.host, call_579210.base,
                         call_579210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579210, url, valid)

proc call*(call_579211: Call_IamProjectsServiceAccountsEnable_579194; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##       : The resource name of the service account in the following format:
  ## `projects/{PROJECT_ID}/serviceAccounts/{ACCOUNT}`.
  ## Using `-` as a wildcard for the `PROJECT_ID` will infer the project from
  ## the account. The `ACCOUNT` value can be the `email` address or the
  ## `unique_id` of the service account.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579212 = newJObject()
  var query_579213 = newJObject()
  var body_579214 = newJObject()
  add(query_579213, "key", newJString(key))
  add(query_579213, "prettyPrint", newJBool(prettyPrint))
  add(query_579213, "oauth_token", newJString(oauthToken))
  add(query_579213, "$.xgafv", newJString(Xgafv))
  add(query_579213, "alt", newJString(alt))
  add(query_579213, "uploadType", newJString(uploadType))
  add(query_579213, "quotaUser", newJString(quotaUser))
  add(path_579212, "name", newJString(name))
  if body != nil:
    body_579214 = body
  add(query_579213, "callback", newJString(callback))
  add(query_579213, "fields", newJString(fields))
  add(query_579213, "access_token", newJString(accessToken))
  add(query_579213, "upload_protocol", newJString(uploadProtocol))
  result = call_579211.call(path_579212, query_579213, nil, nil, body_579214)

var iamProjectsServiceAccountsEnable* = Call_IamProjectsServiceAccountsEnable_579194(
    name: "iamProjectsServiceAccountsEnable", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}:enable",
    validator: validate_IamProjectsServiceAccountsEnable_579195, base: "/",
    url: url_IamProjectsServiceAccountsEnable_579196, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsSignBlob_579215 = ref object of OpenApiRestCall_578348
proc url_IamProjectsServiceAccountsSignBlob_579217(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_IamProjectsServiceAccountsSignBlob_579216(path: JsonNode;
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
  var valid_579218 = path.getOrDefault("name")
  valid_579218 = validateParameter(valid_579218, JString, required = true,
                                 default = nil)
  if valid_579218 != nil:
    section.add "name", valid_579218
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
  var valid_579219 = query.getOrDefault("key")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "key", valid_579219
  var valid_579220 = query.getOrDefault("prettyPrint")
  valid_579220 = validateParameter(valid_579220, JBool, required = false,
                                 default = newJBool(true))
  if valid_579220 != nil:
    section.add "prettyPrint", valid_579220
  var valid_579221 = query.getOrDefault("oauth_token")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = nil)
  if valid_579221 != nil:
    section.add "oauth_token", valid_579221
  var valid_579222 = query.getOrDefault("$.xgafv")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = newJString("1"))
  if valid_579222 != nil:
    section.add "$.xgafv", valid_579222
  var valid_579223 = query.getOrDefault("alt")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = newJString("json"))
  if valid_579223 != nil:
    section.add "alt", valid_579223
  var valid_579224 = query.getOrDefault("uploadType")
  valid_579224 = validateParameter(valid_579224, JString, required = false,
                                 default = nil)
  if valid_579224 != nil:
    section.add "uploadType", valid_579224
  var valid_579225 = query.getOrDefault("quotaUser")
  valid_579225 = validateParameter(valid_579225, JString, required = false,
                                 default = nil)
  if valid_579225 != nil:
    section.add "quotaUser", valid_579225
  var valid_579226 = query.getOrDefault("callback")
  valid_579226 = validateParameter(valid_579226, JString, required = false,
                                 default = nil)
  if valid_579226 != nil:
    section.add "callback", valid_579226
  var valid_579227 = query.getOrDefault("fields")
  valid_579227 = validateParameter(valid_579227, JString, required = false,
                                 default = nil)
  if valid_579227 != nil:
    section.add "fields", valid_579227
  var valid_579228 = query.getOrDefault("access_token")
  valid_579228 = validateParameter(valid_579228, JString, required = false,
                                 default = nil)
  if valid_579228 != nil:
    section.add "access_token", valid_579228
  var valid_579229 = query.getOrDefault("upload_protocol")
  valid_579229 = validateParameter(valid_579229, JString, required = false,
                                 default = nil)
  if valid_579229 != nil:
    section.add "upload_protocol", valid_579229
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

proc call*(call_579231: Call_IamProjectsServiceAccountsSignBlob_579215;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## **Note**: This method is in the process of being deprecated. Call the
  ## [`signBlob()`](/iam/credentials/reference/rest/v1/projects.serviceAccounts/signBlob)
  ## method of the Cloud IAM Service Account Credentials API instead.
  ## 
  ## Signs a blob using a service account's system-managed private key.
  ## 
  let valid = call_579231.validator(path, query, header, formData, body)
  let scheme = call_579231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579231.url(scheme.get, call_579231.host, call_579231.base,
                         call_579231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579231, url, valid)

proc call*(call_579232: Call_IamProjectsServiceAccountsSignBlob_579215;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## iamProjectsServiceAccountsSignBlob
  ## **Note**: This method is in the process of being deprecated. Call the
  ## [`signBlob()`](/iam/credentials/reference/rest/v1/projects.serviceAccounts/signBlob)
  ## method of the Cloud IAM Service Account Credentials API instead.
  ## 
  ## Signs a blob using a service account's system-managed private key.
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
  ##       : The resource name of the service account in the following format:
  ## `projects/{PROJECT_ID}/serviceAccounts/{ACCOUNT}`.
  ## Using `-` as a wildcard for the `PROJECT_ID` will infer the project from
  ## the account. The `ACCOUNT` value can be the `email` address or the
  ## `unique_id` of the service account.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579233 = newJObject()
  var query_579234 = newJObject()
  var body_579235 = newJObject()
  add(query_579234, "key", newJString(key))
  add(query_579234, "prettyPrint", newJBool(prettyPrint))
  add(query_579234, "oauth_token", newJString(oauthToken))
  add(query_579234, "$.xgafv", newJString(Xgafv))
  add(query_579234, "alt", newJString(alt))
  add(query_579234, "uploadType", newJString(uploadType))
  add(query_579234, "quotaUser", newJString(quotaUser))
  add(path_579233, "name", newJString(name))
  if body != nil:
    body_579235 = body
  add(query_579234, "callback", newJString(callback))
  add(query_579234, "fields", newJString(fields))
  add(query_579234, "access_token", newJString(accessToken))
  add(query_579234, "upload_protocol", newJString(uploadProtocol))
  result = call_579232.call(path_579233, query_579234, nil, nil, body_579235)

var iamProjectsServiceAccountsSignBlob* = Call_IamProjectsServiceAccountsSignBlob_579215(
    name: "iamProjectsServiceAccountsSignBlob", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}:signBlob",
    validator: validate_IamProjectsServiceAccountsSignBlob_579216, base: "/",
    url: url_IamProjectsServiceAccountsSignBlob_579217, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsSignJwt_579236 = ref object of OpenApiRestCall_578348
proc url_IamProjectsServiceAccountsSignJwt_579238(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_IamProjectsServiceAccountsSignJwt_579237(path: JsonNode;
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
  var valid_579239 = path.getOrDefault("name")
  valid_579239 = validateParameter(valid_579239, JString, required = true,
                                 default = nil)
  if valid_579239 != nil:
    section.add "name", valid_579239
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
  var valid_579240 = query.getOrDefault("key")
  valid_579240 = validateParameter(valid_579240, JString, required = false,
                                 default = nil)
  if valid_579240 != nil:
    section.add "key", valid_579240
  var valid_579241 = query.getOrDefault("prettyPrint")
  valid_579241 = validateParameter(valid_579241, JBool, required = false,
                                 default = newJBool(true))
  if valid_579241 != nil:
    section.add "prettyPrint", valid_579241
  var valid_579242 = query.getOrDefault("oauth_token")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = nil)
  if valid_579242 != nil:
    section.add "oauth_token", valid_579242
  var valid_579243 = query.getOrDefault("$.xgafv")
  valid_579243 = validateParameter(valid_579243, JString, required = false,
                                 default = newJString("1"))
  if valid_579243 != nil:
    section.add "$.xgafv", valid_579243
  var valid_579244 = query.getOrDefault("alt")
  valid_579244 = validateParameter(valid_579244, JString, required = false,
                                 default = newJString("json"))
  if valid_579244 != nil:
    section.add "alt", valid_579244
  var valid_579245 = query.getOrDefault("uploadType")
  valid_579245 = validateParameter(valid_579245, JString, required = false,
                                 default = nil)
  if valid_579245 != nil:
    section.add "uploadType", valid_579245
  var valid_579246 = query.getOrDefault("quotaUser")
  valid_579246 = validateParameter(valid_579246, JString, required = false,
                                 default = nil)
  if valid_579246 != nil:
    section.add "quotaUser", valid_579246
  var valid_579247 = query.getOrDefault("callback")
  valid_579247 = validateParameter(valid_579247, JString, required = false,
                                 default = nil)
  if valid_579247 != nil:
    section.add "callback", valid_579247
  var valid_579248 = query.getOrDefault("fields")
  valid_579248 = validateParameter(valid_579248, JString, required = false,
                                 default = nil)
  if valid_579248 != nil:
    section.add "fields", valid_579248
  var valid_579249 = query.getOrDefault("access_token")
  valid_579249 = validateParameter(valid_579249, JString, required = false,
                                 default = nil)
  if valid_579249 != nil:
    section.add "access_token", valid_579249
  var valid_579250 = query.getOrDefault("upload_protocol")
  valid_579250 = validateParameter(valid_579250, JString, required = false,
                                 default = nil)
  if valid_579250 != nil:
    section.add "upload_protocol", valid_579250
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

proc call*(call_579252: Call_IamProjectsServiceAccountsSignJwt_579236;
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
  let valid = call_579252.validator(path, query, header, formData, body)
  let scheme = call_579252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579252.url(scheme.get, call_579252.host, call_579252.base,
                         call_579252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579252, url, valid)

proc call*(call_579253: Call_IamProjectsServiceAccountsSignJwt_579236;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##       : The resource name of the service account in the following format:
  ## `projects/{PROJECT_ID}/serviceAccounts/{ACCOUNT}`.
  ## Using `-` as a wildcard for the `PROJECT_ID` will infer the project from
  ## the account. The `ACCOUNT` value can be the `email` address or the
  ## `unique_id` of the service account.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579254 = newJObject()
  var query_579255 = newJObject()
  var body_579256 = newJObject()
  add(query_579255, "key", newJString(key))
  add(query_579255, "prettyPrint", newJBool(prettyPrint))
  add(query_579255, "oauth_token", newJString(oauthToken))
  add(query_579255, "$.xgafv", newJString(Xgafv))
  add(query_579255, "alt", newJString(alt))
  add(query_579255, "uploadType", newJString(uploadType))
  add(query_579255, "quotaUser", newJString(quotaUser))
  add(path_579254, "name", newJString(name))
  if body != nil:
    body_579256 = body
  add(query_579255, "callback", newJString(callback))
  add(query_579255, "fields", newJString(fields))
  add(query_579255, "access_token", newJString(accessToken))
  add(query_579255, "upload_protocol", newJString(uploadProtocol))
  result = call_579253.call(path_579254, query_579255, nil, nil, body_579256)

var iamProjectsServiceAccountsSignJwt* = Call_IamProjectsServiceAccountsSignJwt_579236(
    name: "iamProjectsServiceAccountsSignJwt", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}:signJwt",
    validator: validate_IamProjectsServiceAccountsSignJwt_579237, base: "/",
    url: url_IamProjectsServiceAccountsSignJwt_579238, schemes: {Scheme.Https})
type
  Call_IamProjectsRolesUndelete_579257 = ref object of OpenApiRestCall_578348
proc url_IamProjectsRolesUndelete_579259(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_IamProjectsRolesUndelete_579258(path: JsonNode; query: JsonNode;
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
  var valid_579260 = path.getOrDefault("name")
  valid_579260 = validateParameter(valid_579260, JString, required = true,
                                 default = nil)
  if valid_579260 != nil:
    section.add "name", valid_579260
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
  var valid_579261 = query.getOrDefault("key")
  valid_579261 = validateParameter(valid_579261, JString, required = false,
                                 default = nil)
  if valid_579261 != nil:
    section.add "key", valid_579261
  var valid_579262 = query.getOrDefault("prettyPrint")
  valid_579262 = validateParameter(valid_579262, JBool, required = false,
                                 default = newJBool(true))
  if valid_579262 != nil:
    section.add "prettyPrint", valid_579262
  var valid_579263 = query.getOrDefault("oauth_token")
  valid_579263 = validateParameter(valid_579263, JString, required = false,
                                 default = nil)
  if valid_579263 != nil:
    section.add "oauth_token", valid_579263
  var valid_579264 = query.getOrDefault("$.xgafv")
  valid_579264 = validateParameter(valid_579264, JString, required = false,
                                 default = newJString("1"))
  if valid_579264 != nil:
    section.add "$.xgafv", valid_579264
  var valid_579265 = query.getOrDefault("alt")
  valid_579265 = validateParameter(valid_579265, JString, required = false,
                                 default = newJString("json"))
  if valid_579265 != nil:
    section.add "alt", valid_579265
  var valid_579266 = query.getOrDefault("uploadType")
  valid_579266 = validateParameter(valid_579266, JString, required = false,
                                 default = nil)
  if valid_579266 != nil:
    section.add "uploadType", valid_579266
  var valid_579267 = query.getOrDefault("quotaUser")
  valid_579267 = validateParameter(valid_579267, JString, required = false,
                                 default = nil)
  if valid_579267 != nil:
    section.add "quotaUser", valid_579267
  var valid_579268 = query.getOrDefault("callback")
  valid_579268 = validateParameter(valid_579268, JString, required = false,
                                 default = nil)
  if valid_579268 != nil:
    section.add "callback", valid_579268
  var valid_579269 = query.getOrDefault("fields")
  valid_579269 = validateParameter(valid_579269, JString, required = false,
                                 default = nil)
  if valid_579269 != nil:
    section.add "fields", valid_579269
  var valid_579270 = query.getOrDefault("access_token")
  valid_579270 = validateParameter(valid_579270, JString, required = false,
                                 default = nil)
  if valid_579270 != nil:
    section.add "access_token", valid_579270
  var valid_579271 = query.getOrDefault("upload_protocol")
  valid_579271 = validateParameter(valid_579271, JString, required = false,
                                 default = nil)
  if valid_579271 != nil:
    section.add "upload_protocol", valid_579271
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

proc call*(call_579273: Call_IamProjectsRolesUndelete_579257; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Undelete a Role, bringing it back in its previous state.
  ## 
  let valid = call_579273.validator(path, query, header, formData, body)
  let scheme = call_579273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579273.url(scheme.get, call_579273.host, call_579273.base,
                         call_579273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579273, url, valid)

proc call*(call_579274: Call_IamProjectsRolesUndelete_579257; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## iamProjectsRolesUndelete
  ## Undelete a Role, bringing it back in its previous state.
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
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579275 = newJObject()
  var query_579276 = newJObject()
  var body_579277 = newJObject()
  add(query_579276, "key", newJString(key))
  add(query_579276, "prettyPrint", newJBool(prettyPrint))
  add(query_579276, "oauth_token", newJString(oauthToken))
  add(query_579276, "$.xgafv", newJString(Xgafv))
  add(query_579276, "alt", newJString(alt))
  add(query_579276, "uploadType", newJString(uploadType))
  add(query_579276, "quotaUser", newJString(quotaUser))
  add(path_579275, "name", newJString(name))
  if body != nil:
    body_579277 = body
  add(query_579276, "callback", newJString(callback))
  add(query_579276, "fields", newJString(fields))
  add(query_579276, "access_token", newJString(accessToken))
  add(query_579276, "upload_protocol", newJString(uploadProtocol))
  result = call_579274.call(path_579275, query_579276, nil, nil, body_579277)

var iamProjectsRolesUndelete* = Call_IamProjectsRolesUndelete_579257(
    name: "iamProjectsRolesUndelete", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}:undelete",
    validator: validate_IamProjectsRolesUndelete_579258, base: "/",
    url: url_IamProjectsRolesUndelete_579259, schemes: {Scheme.Https})
type
  Call_IamProjectsRolesCreate_579301 = ref object of OpenApiRestCall_578348
proc url_IamProjectsRolesCreate_579303(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_IamProjectsRolesCreate_579302(path: JsonNode; query: JsonNode;
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
  var valid_579304 = path.getOrDefault("parent")
  valid_579304 = validateParameter(valid_579304, JString, required = true,
                                 default = nil)
  if valid_579304 != nil:
    section.add "parent", valid_579304
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
  var valid_579305 = query.getOrDefault("key")
  valid_579305 = validateParameter(valid_579305, JString, required = false,
                                 default = nil)
  if valid_579305 != nil:
    section.add "key", valid_579305
  var valid_579306 = query.getOrDefault("prettyPrint")
  valid_579306 = validateParameter(valid_579306, JBool, required = false,
                                 default = newJBool(true))
  if valid_579306 != nil:
    section.add "prettyPrint", valid_579306
  var valid_579307 = query.getOrDefault("oauth_token")
  valid_579307 = validateParameter(valid_579307, JString, required = false,
                                 default = nil)
  if valid_579307 != nil:
    section.add "oauth_token", valid_579307
  var valid_579308 = query.getOrDefault("$.xgafv")
  valid_579308 = validateParameter(valid_579308, JString, required = false,
                                 default = newJString("1"))
  if valid_579308 != nil:
    section.add "$.xgafv", valid_579308
  var valid_579309 = query.getOrDefault("alt")
  valid_579309 = validateParameter(valid_579309, JString, required = false,
                                 default = newJString("json"))
  if valid_579309 != nil:
    section.add "alt", valid_579309
  var valid_579310 = query.getOrDefault("uploadType")
  valid_579310 = validateParameter(valid_579310, JString, required = false,
                                 default = nil)
  if valid_579310 != nil:
    section.add "uploadType", valid_579310
  var valid_579311 = query.getOrDefault("quotaUser")
  valid_579311 = validateParameter(valid_579311, JString, required = false,
                                 default = nil)
  if valid_579311 != nil:
    section.add "quotaUser", valid_579311
  var valid_579312 = query.getOrDefault("callback")
  valid_579312 = validateParameter(valid_579312, JString, required = false,
                                 default = nil)
  if valid_579312 != nil:
    section.add "callback", valid_579312
  var valid_579313 = query.getOrDefault("fields")
  valid_579313 = validateParameter(valid_579313, JString, required = false,
                                 default = nil)
  if valid_579313 != nil:
    section.add "fields", valid_579313
  var valid_579314 = query.getOrDefault("access_token")
  valid_579314 = validateParameter(valid_579314, JString, required = false,
                                 default = nil)
  if valid_579314 != nil:
    section.add "access_token", valid_579314
  var valid_579315 = query.getOrDefault("upload_protocol")
  valid_579315 = validateParameter(valid_579315, JString, required = false,
                                 default = nil)
  if valid_579315 != nil:
    section.add "upload_protocol", valid_579315
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

proc call*(call_579317: Call_IamProjectsRolesCreate_579301; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Role.
  ## 
  let valid = call_579317.validator(path, query, header, formData, body)
  let scheme = call_579317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579317.url(scheme.get, call_579317.host, call_579317.base,
                         call_579317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579317, url, valid)

proc call*(call_579318: Call_IamProjectsRolesCreate_579301; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## iamProjectsRolesCreate
  ## Creates a new Role.
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579319 = newJObject()
  var query_579320 = newJObject()
  var body_579321 = newJObject()
  add(query_579320, "key", newJString(key))
  add(query_579320, "prettyPrint", newJBool(prettyPrint))
  add(query_579320, "oauth_token", newJString(oauthToken))
  add(query_579320, "$.xgafv", newJString(Xgafv))
  add(query_579320, "alt", newJString(alt))
  add(query_579320, "uploadType", newJString(uploadType))
  add(query_579320, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579321 = body
  add(query_579320, "callback", newJString(callback))
  add(path_579319, "parent", newJString(parent))
  add(query_579320, "fields", newJString(fields))
  add(query_579320, "access_token", newJString(accessToken))
  add(query_579320, "upload_protocol", newJString(uploadProtocol))
  result = call_579318.call(path_579319, query_579320, nil, nil, body_579321)

var iamProjectsRolesCreate* = Call_IamProjectsRolesCreate_579301(
    name: "iamProjectsRolesCreate", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{parent}/roles",
    validator: validate_IamProjectsRolesCreate_579302, base: "/",
    url: url_IamProjectsRolesCreate_579303, schemes: {Scheme.Https})
type
  Call_IamProjectsRolesList_579278 = ref object of OpenApiRestCall_578348
proc url_IamProjectsRolesList_579280(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_IamProjectsRolesList_579279(path: JsonNode; query: JsonNode;
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
  var valid_579281 = path.getOrDefault("parent")
  valid_579281 = validateParameter(valid_579281, JString, required = true,
                                 default = nil)
  if valid_579281 != nil:
    section.add "parent", valid_579281
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
  ##           : Optional limit on the number of roles to include in the response.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Optional pagination token returned in an earlier ListRolesResponse.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   showDeleted: JBool
  ##              : Include Roles that have been deleted.
  ##   view: JString
  ##       : Optional view for the returned Role objects. When `FULL` is specified,
  ## the `includedPermissions` field is returned, which includes a list of all
  ## permissions in the role. The default value is `BASIC`, which does not
  ## return the `includedPermissions` field.
  section = newJObject()
  var valid_579282 = query.getOrDefault("key")
  valid_579282 = validateParameter(valid_579282, JString, required = false,
                                 default = nil)
  if valid_579282 != nil:
    section.add "key", valid_579282
  var valid_579283 = query.getOrDefault("prettyPrint")
  valid_579283 = validateParameter(valid_579283, JBool, required = false,
                                 default = newJBool(true))
  if valid_579283 != nil:
    section.add "prettyPrint", valid_579283
  var valid_579284 = query.getOrDefault("oauth_token")
  valid_579284 = validateParameter(valid_579284, JString, required = false,
                                 default = nil)
  if valid_579284 != nil:
    section.add "oauth_token", valid_579284
  var valid_579285 = query.getOrDefault("$.xgafv")
  valid_579285 = validateParameter(valid_579285, JString, required = false,
                                 default = newJString("1"))
  if valid_579285 != nil:
    section.add "$.xgafv", valid_579285
  var valid_579286 = query.getOrDefault("pageSize")
  valid_579286 = validateParameter(valid_579286, JInt, required = false, default = nil)
  if valid_579286 != nil:
    section.add "pageSize", valid_579286
  var valid_579287 = query.getOrDefault("alt")
  valid_579287 = validateParameter(valid_579287, JString, required = false,
                                 default = newJString("json"))
  if valid_579287 != nil:
    section.add "alt", valid_579287
  var valid_579288 = query.getOrDefault("uploadType")
  valid_579288 = validateParameter(valid_579288, JString, required = false,
                                 default = nil)
  if valid_579288 != nil:
    section.add "uploadType", valid_579288
  var valid_579289 = query.getOrDefault("quotaUser")
  valid_579289 = validateParameter(valid_579289, JString, required = false,
                                 default = nil)
  if valid_579289 != nil:
    section.add "quotaUser", valid_579289
  var valid_579290 = query.getOrDefault("pageToken")
  valid_579290 = validateParameter(valid_579290, JString, required = false,
                                 default = nil)
  if valid_579290 != nil:
    section.add "pageToken", valid_579290
  var valid_579291 = query.getOrDefault("callback")
  valid_579291 = validateParameter(valid_579291, JString, required = false,
                                 default = nil)
  if valid_579291 != nil:
    section.add "callback", valid_579291
  var valid_579292 = query.getOrDefault("fields")
  valid_579292 = validateParameter(valid_579292, JString, required = false,
                                 default = nil)
  if valid_579292 != nil:
    section.add "fields", valid_579292
  var valid_579293 = query.getOrDefault("access_token")
  valid_579293 = validateParameter(valid_579293, JString, required = false,
                                 default = nil)
  if valid_579293 != nil:
    section.add "access_token", valid_579293
  var valid_579294 = query.getOrDefault("upload_protocol")
  valid_579294 = validateParameter(valid_579294, JString, required = false,
                                 default = nil)
  if valid_579294 != nil:
    section.add "upload_protocol", valid_579294
  var valid_579295 = query.getOrDefault("showDeleted")
  valid_579295 = validateParameter(valid_579295, JBool, required = false, default = nil)
  if valid_579295 != nil:
    section.add "showDeleted", valid_579295
  var valid_579296 = query.getOrDefault("view")
  valid_579296 = validateParameter(valid_579296, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_579296 != nil:
    section.add "view", valid_579296
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579297: Call_IamProjectsRolesList_579278; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Roles defined on a resource.
  ## 
  let valid = call_579297.validator(path, query, header, formData, body)
  let scheme = call_579297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579297.url(scheme.get, call_579297.host, call_579297.base,
                         call_579297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579297, url, valid)

proc call*(call_579298: Call_IamProjectsRolesList_579278; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; showDeleted: bool = false; view: string = "BASIC"): Recallable =
  ## iamProjectsRolesList
  ## Lists the Roles defined on a resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional limit on the number of roles to include in the response.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Optional pagination token returned in an earlier ListRolesResponse.
  ##   callback: string
  ##           : JSONP
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   showDeleted: bool
  ##              : Include Roles that have been deleted.
  ##   view: string
  ##       : Optional view for the returned Role objects. When `FULL` is specified,
  ## the `includedPermissions` field is returned, which includes a list of all
  ## permissions in the role. The default value is `BASIC`, which does not
  ## return the `includedPermissions` field.
  var path_579299 = newJObject()
  var query_579300 = newJObject()
  add(query_579300, "key", newJString(key))
  add(query_579300, "prettyPrint", newJBool(prettyPrint))
  add(query_579300, "oauth_token", newJString(oauthToken))
  add(query_579300, "$.xgafv", newJString(Xgafv))
  add(query_579300, "pageSize", newJInt(pageSize))
  add(query_579300, "alt", newJString(alt))
  add(query_579300, "uploadType", newJString(uploadType))
  add(query_579300, "quotaUser", newJString(quotaUser))
  add(query_579300, "pageToken", newJString(pageToken))
  add(query_579300, "callback", newJString(callback))
  add(path_579299, "parent", newJString(parent))
  add(query_579300, "fields", newJString(fields))
  add(query_579300, "access_token", newJString(accessToken))
  add(query_579300, "upload_protocol", newJString(uploadProtocol))
  add(query_579300, "showDeleted", newJBool(showDeleted))
  add(query_579300, "view", newJString(view))
  result = call_579298.call(path_579299, query_579300, nil, nil, nil)

var iamProjectsRolesList* = Call_IamProjectsRolesList_579278(
    name: "iamProjectsRolesList", meth: HttpMethod.HttpGet,
    host: "iam.googleapis.com", route: "/v1/{parent}/roles",
    validator: validate_IamProjectsRolesList_579279, base: "/",
    url: url_IamProjectsRolesList_579280, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsGetIamPolicy_579322 = ref object of OpenApiRestCall_578348
proc url_IamProjectsServiceAccountsGetIamPolicy_579324(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_IamProjectsServiceAccountsGetIamPolicy_579323(path: JsonNode;
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
  var valid_579325 = path.getOrDefault("resource")
  valid_579325 = validateParameter(valid_579325, JString, required = true,
                                 default = nil)
  if valid_579325 != nil:
    section.add "resource", valid_579325
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
  ##   options.requestedPolicyVersion: JInt
  ##                                 : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
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
  var valid_579326 = query.getOrDefault("key")
  valid_579326 = validateParameter(valid_579326, JString, required = false,
                                 default = nil)
  if valid_579326 != nil:
    section.add "key", valid_579326
  var valid_579327 = query.getOrDefault("prettyPrint")
  valid_579327 = validateParameter(valid_579327, JBool, required = false,
                                 default = newJBool(true))
  if valid_579327 != nil:
    section.add "prettyPrint", valid_579327
  var valid_579328 = query.getOrDefault("oauth_token")
  valid_579328 = validateParameter(valid_579328, JString, required = false,
                                 default = nil)
  if valid_579328 != nil:
    section.add "oauth_token", valid_579328
  var valid_579329 = query.getOrDefault("$.xgafv")
  valid_579329 = validateParameter(valid_579329, JString, required = false,
                                 default = newJString("1"))
  if valid_579329 != nil:
    section.add "$.xgafv", valid_579329
  var valid_579330 = query.getOrDefault("options.requestedPolicyVersion")
  valid_579330 = validateParameter(valid_579330, JInt, required = false, default = nil)
  if valid_579330 != nil:
    section.add "options.requestedPolicyVersion", valid_579330
  var valid_579331 = query.getOrDefault("alt")
  valid_579331 = validateParameter(valid_579331, JString, required = false,
                                 default = newJString("json"))
  if valid_579331 != nil:
    section.add "alt", valid_579331
  var valid_579332 = query.getOrDefault("uploadType")
  valid_579332 = validateParameter(valid_579332, JString, required = false,
                                 default = nil)
  if valid_579332 != nil:
    section.add "uploadType", valid_579332
  var valid_579333 = query.getOrDefault("quotaUser")
  valid_579333 = validateParameter(valid_579333, JString, required = false,
                                 default = nil)
  if valid_579333 != nil:
    section.add "quotaUser", valid_579333
  var valid_579334 = query.getOrDefault("callback")
  valid_579334 = validateParameter(valid_579334, JString, required = false,
                                 default = nil)
  if valid_579334 != nil:
    section.add "callback", valid_579334
  var valid_579335 = query.getOrDefault("fields")
  valid_579335 = validateParameter(valid_579335, JString, required = false,
                                 default = nil)
  if valid_579335 != nil:
    section.add "fields", valid_579335
  var valid_579336 = query.getOrDefault("access_token")
  valid_579336 = validateParameter(valid_579336, JString, required = false,
                                 default = nil)
  if valid_579336 != nil:
    section.add "access_token", valid_579336
  var valid_579337 = query.getOrDefault("upload_protocol")
  valid_579337 = validateParameter(valid_579337, JString, required = false,
                                 default = nil)
  if valid_579337 != nil:
    section.add "upload_protocol", valid_579337
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579338: Call_IamProjectsServiceAccountsGetIamPolicy_579322;
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
  let valid = call_579338.validator(path, query, header, formData, body)
  let scheme = call_579338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579338.url(scheme.get, call_579338.host, call_579338.base,
                         call_579338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579338, url, valid)

proc call*(call_579339: Call_IamProjectsServiceAccountsGetIamPolicy_579322;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1";
          optionsRequestedPolicyVersion: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   optionsRequestedPolicyVersion: int
  ##                                : Optional. The policy format version to be returned.
  ## 
  ## Valid values are 0, 1, and 3. Requests specifying an invalid value will be
  ## rejected.
  ## 
  ## Requests for policies with any conditional bindings must specify version 3.
  ## Policies without any conditional bindings may specify any valid value or
  ## leave the field unset.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579340 = newJObject()
  var query_579341 = newJObject()
  add(query_579341, "key", newJString(key))
  add(query_579341, "prettyPrint", newJBool(prettyPrint))
  add(query_579341, "oauth_token", newJString(oauthToken))
  add(query_579341, "$.xgafv", newJString(Xgafv))
  add(query_579341, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_579341, "alt", newJString(alt))
  add(query_579341, "uploadType", newJString(uploadType))
  add(query_579341, "quotaUser", newJString(quotaUser))
  add(path_579340, "resource", newJString(resource))
  add(query_579341, "callback", newJString(callback))
  add(query_579341, "fields", newJString(fields))
  add(query_579341, "access_token", newJString(accessToken))
  add(query_579341, "upload_protocol", newJString(uploadProtocol))
  result = call_579339.call(path_579340, query_579341, nil, nil, nil)

var iamProjectsServiceAccountsGetIamPolicy* = Call_IamProjectsServiceAccountsGetIamPolicy_579322(
    name: "iamProjectsServiceAccountsGetIamPolicy", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{resource}:getIamPolicy",
    validator: validate_IamProjectsServiceAccountsGetIamPolicy_579323, base: "/",
    url: url_IamProjectsServiceAccountsGetIamPolicy_579324,
    schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsSetIamPolicy_579342 = ref object of OpenApiRestCall_578348
proc url_IamProjectsServiceAccountsSetIamPolicy_579344(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_IamProjectsServiceAccountsSetIamPolicy_579343(path: JsonNode;
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
  var valid_579345 = path.getOrDefault("resource")
  valid_579345 = validateParameter(valid_579345, JString, required = true,
                                 default = nil)
  if valid_579345 != nil:
    section.add "resource", valid_579345
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
  var valid_579346 = query.getOrDefault("key")
  valid_579346 = validateParameter(valid_579346, JString, required = false,
                                 default = nil)
  if valid_579346 != nil:
    section.add "key", valid_579346
  var valid_579347 = query.getOrDefault("prettyPrint")
  valid_579347 = validateParameter(valid_579347, JBool, required = false,
                                 default = newJBool(true))
  if valid_579347 != nil:
    section.add "prettyPrint", valid_579347
  var valid_579348 = query.getOrDefault("oauth_token")
  valid_579348 = validateParameter(valid_579348, JString, required = false,
                                 default = nil)
  if valid_579348 != nil:
    section.add "oauth_token", valid_579348
  var valid_579349 = query.getOrDefault("$.xgafv")
  valid_579349 = validateParameter(valid_579349, JString, required = false,
                                 default = newJString("1"))
  if valid_579349 != nil:
    section.add "$.xgafv", valid_579349
  var valid_579350 = query.getOrDefault("alt")
  valid_579350 = validateParameter(valid_579350, JString, required = false,
                                 default = newJString("json"))
  if valid_579350 != nil:
    section.add "alt", valid_579350
  var valid_579351 = query.getOrDefault("uploadType")
  valid_579351 = validateParameter(valid_579351, JString, required = false,
                                 default = nil)
  if valid_579351 != nil:
    section.add "uploadType", valid_579351
  var valid_579352 = query.getOrDefault("quotaUser")
  valid_579352 = validateParameter(valid_579352, JString, required = false,
                                 default = nil)
  if valid_579352 != nil:
    section.add "quotaUser", valid_579352
  var valid_579353 = query.getOrDefault("callback")
  valid_579353 = validateParameter(valid_579353, JString, required = false,
                                 default = nil)
  if valid_579353 != nil:
    section.add "callback", valid_579353
  var valid_579354 = query.getOrDefault("fields")
  valid_579354 = validateParameter(valid_579354, JString, required = false,
                                 default = nil)
  if valid_579354 != nil:
    section.add "fields", valid_579354
  var valid_579355 = query.getOrDefault("access_token")
  valid_579355 = validateParameter(valid_579355, JString, required = false,
                                 default = nil)
  if valid_579355 != nil:
    section.add "access_token", valid_579355
  var valid_579356 = query.getOrDefault("upload_protocol")
  valid_579356 = validateParameter(valid_579356, JString, required = false,
                                 default = nil)
  if valid_579356 != nil:
    section.add "upload_protocol", valid_579356
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

proc call*(call_579358: Call_IamProjectsServiceAccountsSetIamPolicy_579342;
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
  let valid = call_579358.validator(path, query, header, formData, body)
  let scheme = call_579358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579358.url(scheme.get, call_579358.host, call_579358.base,
                         call_579358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579358, url, valid)

proc call*(call_579359: Call_IamProjectsServiceAccountsSetIamPolicy_579342;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579360 = newJObject()
  var query_579361 = newJObject()
  var body_579362 = newJObject()
  add(query_579361, "key", newJString(key))
  add(query_579361, "prettyPrint", newJBool(prettyPrint))
  add(query_579361, "oauth_token", newJString(oauthToken))
  add(query_579361, "$.xgafv", newJString(Xgafv))
  add(query_579361, "alt", newJString(alt))
  add(query_579361, "uploadType", newJString(uploadType))
  add(query_579361, "quotaUser", newJString(quotaUser))
  add(path_579360, "resource", newJString(resource))
  if body != nil:
    body_579362 = body
  add(query_579361, "callback", newJString(callback))
  add(query_579361, "fields", newJString(fields))
  add(query_579361, "access_token", newJString(accessToken))
  add(query_579361, "upload_protocol", newJString(uploadProtocol))
  result = call_579359.call(path_579360, query_579361, nil, nil, body_579362)

var iamProjectsServiceAccountsSetIamPolicy* = Call_IamProjectsServiceAccountsSetIamPolicy_579342(
    name: "iamProjectsServiceAccountsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{resource}:setIamPolicy",
    validator: validate_IamProjectsServiceAccountsSetIamPolicy_579343, base: "/",
    url: url_IamProjectsServiceAccountsSetIamPolicy_579344,
    schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsTestIamPermissions_579363 = ref object of OpenApiRestCall_578348
proc url_IamProjectsServiceAccountsTestIamPermissions_579365(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_IamProjectsServiceAccountsTestIamPermissions_579364(path: JsonNode;
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
  var valid_579366 = path.getOrDefault("resource")
  valid_579366 = validateParameter(valid_579366, JString, required = true,
                                 default = nil)
  if valid_579366 != nil:
    section.add "resource", valid_579366
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
  var valid_579367 = query.getOrDefault("key")
  valid_579367 = validateParameter(valid_579367, JString, required = false,
                                 default = nil)
  if valid_579367 != nil:
    section.add "key", valid_579367
  var valid_579368 = query.getOrDefault("prettyPrint")
  valid_579368 = validateParameter(valid_579368, JBool, required = false,
                                 default = newJBool(true))
  if valid_579368 != nil:
    section.add "prettyPrint", valid_579368
  var valid_579369 = query.getOrDefault("oauth_token")
  valid_579369 = validateParameter(valid_579369, JString, required = false,
                                 default = nil)
  if valid_579369 != nil:
    section.add "oauth_token", valid_579369
  var valid_579370 = query.getOrDefault("$.xgafv")
  valid_579370 = validateParameter(valid_579370, JString, required = false,
                                 default = newJString("1"))
  if valid_579370 != nil:
    section.add "$.xgafv", valid_579370
  var valid_579371 = query.getOrDefault("alt")
  valid_579371 = validateParameter(valid_579371, JString, required = false,
                                 default = newJString("json"))
  if valid_579371 != nil:
    section.add "alt", valid_579371
  var valid_579372 = query.getOrDefault("uploadType")
  valid_579372 = validateParameter(valid_579372, JString, required = false,
                                 default = nil)
  if valid_579372 != nil:
    section.add "uploadType", valid_579372
  var valid_579373 = query.getOrDefault("quotaUser")
  valid_579373 = validateParameter(valid_579373, JString, required = false,
                                 default = nil)
  if valid_579373 != nil:
    section.add "quotaUser", valid_579373
  var valid_579374 = query.getOrDefault("callback")
  valid_579374 = validateParameter(valid_579374, JString, required = false,
                                 default = nil)
  if valid_579374 != nil:
    section.add "callback", valid_579374
  var valid_579375 = query.getOrDefault("fields")
  valid_579375 = validateParameter(valid_579375, JString, required = false,
                                 default = nil)
  if valid_579375 != nil:
    section.add "fields", valid_579375
  var valid_579376 = query.getOrDefault("access_token")
  valid_579376 = validateParameter(valid_579376, JString, required = false,
                                 default = nil)
  if valid_579376 != nil:
    section.add "access_token", valid_579376
  var valid_579377 = query.getOrDefault("upload_protocol")
  valid_579377 = validateParameter(valid_579377, JString, required = false,
                                 default = nil)
  if valid_579377 != nil:
    section.add "upload_protocol", valid_579377
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

proc call*(call_579379: Call_IamProjectsServiceAccountsTestIamPermissions_579363;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Tests the specified permissions against the IAM access control policy
  ## for a ServiceAccount.
  ## 
  let valid = call_579379.validator(path, query, header, formData, body)
  let scheme = call_579379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579379.url(scheme.get, call_579379.host, call_579379.base,
                         call_579379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579379, url, valid)

proc call*(call_579380: Call_IamProjectsServiceAccountsTestIamPermissions_579363;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## iamProjectsServiceAccountsTestIamPermissions
  ## Tests the specified permissions against the IAM access control policy
  ## for a ServiceAccount.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579381 = newJObject()
  var query_579382 = newJObject()
  var body_579383 = newJObject()
  add(query_579382, "key", newJString(key))
  add(query_579382, "prettyPrint", newJBool(prettyPrint))
  add(query_579382, "oauth_token", newJString(oauthToken))
  add(query_579382, "$.xgafv", newJString(Xgafv))
  add(query_579382, "alt", newJString(alt))
  add(query_579382, "uploadType", newJString(uploadType))
  add(query_579382, "quotaUser", newJString(quotaUser))
  add(path_579381, "resource", newJString(resource))
  if body != nil:
    body_579383 = body
  add(query_579382, "callback", newJString(callback))
  add(query_579382, "fields", newJString(fields))
  add(query_579382, "access_token", newJString(accessToken))
  add(query_579382, "upload_protocol", newJString(uploadProtocol))
  result = call_579380.call(path_579381, query_579382, nil, nil, body_579383)

var iamProjectsServiceAccountsTestIamPermissions* = Call_IamProjectsServiceAccountsTestIamPermissions_579363(
    name: "iamProjectsServiceAccountsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "iam.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_IamProjectsServiceAccountsTestIamPermissions_579364,
    base: "/", url: url_IamProjectsServiceAccountsTestIamPermissions_579365,
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
