
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
  gcpServiceName = "iam"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_IamIamPoliciesLintPolicy_579690 = ref object of OpenApiRestCall_579421
proc url_IamIamPoliciesLintPolicy_579692(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IamIamPoliciesLintPolicy_579691(path: JsonNode; query: JsonNode;
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

proc call*(call_579851: Call_IamIamPoliciesLintPolicy_579690; path: JsonNode;
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
  let valid = call_579851.validator(path, query, header, formData, body)
  let scheme = call_579851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579851.url(scheme.get, call_579851.host, call_579851.base,
                         call_579851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579851, url, valid)

proc call*(call_579922: Call_IamIamPoliciesLintPolicy_579690;
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

var iamIamPoliciesLintPolicy* = Call_IamIamPoliciesLintPolicy_579690(
    name: "iamIamPoliciesLintPolicy", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/iamPolicies:lintPolicy",
    validator: validate_IamIamPoliciesLintPolicy_579691, base: "/",
    url: url_IamIamPoliciesLintPolicy_579692, schemes: {Scheme.Https})
type
  Call_IamIamPoliciesQueryAuditableServices_579964 = ref object of OpenApiRestCall_579421
proc url_IamIamPoliciesQueryAuditableServices_579966(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IamIamPoliciesQueryAuditableServices_579965(path: JsonNode;
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
  var valid_579967 = query.getOrDefault("upload_protocol")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "upload_protocol", valid_579967
  var valid_579968 = query.getOrDefault("fields")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "fields", valid_579968
  var valid_579969 = query.getOrDefault("quotaUser")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "quotaUser", valid_579969
  var valid_579970 = query.getOrDefault("alt")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = newJString("json"))
  if valid_579970 != nil:
    section.add "alt", valid_579970
  var valid_579971 = query.getOrDefault("oauth_token")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "oauth_token", valid_579971
  var valid_579972 = query.getOrDefault("callback")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "callback", valid_579972
  var valid_579973 = query.getOrDefault("access_token")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "access_token", valid_579973
  var valid_579974 = query.getOrDefault("uploadType")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "uploadType", valid_579974
  var valid_579975 = query.getOrDefault("key")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "key", valid_579975
  var valid_579976 = query.getOrDefault("$.xgafv")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = newJString("1"))
  if valid_579976 != nil:
    section.add "$.xgafv", valid_579976
  var valid_579977 = query.getOrDefault("prettyPrint")
  valid_579977 = validateParameter(valid_579977, JBool, required = false,
                                 default = newJBool(true))
  if valid_579977 != nil:
    section.add "prettyPrint", valid_579977
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

proc call*(call_579979: Call_IamIamPoliciesQueryAuditableServices_579964;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of services that support service level audit logging
  ## configuration for the given resource.
  ## 
  let valid = call_579979.validator(path, query, header, formData, body)
  let scheme = call_579979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579979.url(scheme.get, call_579979.host, call_579979.base,
                         call_579979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579979, url, valid)

proc call*(call_579980: Call_IamIamPoliciesQueryAuditableServices_579964;
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
  var query_579981 = newJObject()
  var body_579982 = newJObject()
  add(query_579981, "upload_protocol", newJString(uploadProtocol))
  add(query_579981, "fields", newJString(fields))
  add(query_579981, "quotaUser", newJString(quotaUser))
  add(query_579981, "alt", newJString(alt))
  add(query_579981, "oauth_token", newJString(oauthToken))
  add(query_579981, "callback", newJString(callback))
  add(query_579981, "access_token", newJString(accessToken))
  add(query_579981, "uploadType", newJString(uploadType))
  add(query_579981, "key", newJString(key))
  add(query_579981, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579982 = body
  add(query_579981, "prettyPrint", newJBool(prettyPrint))
  result = call_579980.call(nil, query_579981, nil, nil, body_579982)

var iamIamPoliciesQueryAuditableServices* = Call_IamIamPoliciesQueryAuditableServices_579964(
    name: "iamIamPoliciesQueryAuditableServices", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/iamPolicies:queryAuditableServices",
    validator: validate_IamIamPoliciesQueryAuditableServices_579965, base: "/",
    url: url_IamIamPoliciesQueryAuditableServices_579966, schemes: {Scheme.Https})
type
  Call_IamPermissionsQueryTestablePermissions_579983 = ref object of OpenApiRestCall_579421
proc url_IamPermissionsQueryTestablePermissions_579985(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IamPermissionsQueryTestablePermissions_579984(path: JsonNode;
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
  var valid_579986 = query.getOrDefault("upload_protocol")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "upload_protocol", valid_579986
  var valid_579987 = query.getOrDefault("fields")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "fields", valid_579987
  var valid_579988 = query.getOrDefault("quotaUser")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "quotaUser", valid_579988
  var valid_579989 = query.getOrDefault("alt")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = newJString("json"))
  if valid_579989 != nil:
    section.add "alt", valid_579989
  var valid_579990 = query.getOrDefault("oauth_token")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "oauth_token", valid_579990
  var valid_579991 = query.getOrDefault("callback")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "callback", valid_579991
  var valid_579992 = query.getOrDefault("access_token")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "access_token", valid_579992
  var valid_579993 = query.getOrDefault("uploadType")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "uploadType", valid_579993
  var valid_579994 = query.getOrDefault("key")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "key", valid_579994
  var valid_579995 = query.getOrDefault("$.xgafv")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = newJString("1"))
  if valid_579995 != nil:
    section.add "$.xgafv", valid_579995
  var valid_579996 = query.getOrDefault("prettyPrint")
  valid_579996 = validateParameter(valid_579996, JBool, required = false,
                                 default = newJBool(true))
  if valid_579996 != nil:
    section.add "prettyPrint", valid_579996
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

proc call*(call_579998: Call_IamPermissionsQueryTestablePermissions_579983;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the permissions testable on a resource.
  ## A permission is testable if it can be tested for an identity on a resource.
  ## 
  let valid = call_579998.validator(path, query, header, formData, body)
  let scheme = call_579998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579998.url(scheme.get, call_579998.host, call_579998.base,
                         call_579998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579998, url, valid)

proc call*(call_579999: Call_IamPermissionsQueryTestablePermissions_579983;
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
  var query_580000 = newJObject()
  var body_580001 = newJObject()
  add(query_580000, "upload_protocol", newJString(uploadProtocol))
  add(query_580000, "fields", newJString(fields))
  add(query_580000, "quotaUser", newJString(quotaUser))
  add(query_580000, "alt", newJString(alt))
  add(query_580000, "oauth_token", newJString(oauthToken))
  add(query_580000, "callback", newJString(callback))
  add(query_580000, "access_token", newJString(accessToken))
  add(query_580000, "uploadType", newJString(uploadType))
  add(query_580000, "key", newJString(key))
  add(query_580000, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580001 = body
  add(query_580000, "prettyPrint", newJBool(prettyPrint))
  result = call_579999.call(nil, query_580000, nil, nil, body_580001)

var iamPermissionsQueryTestablePermissions* = Call_IamPermissionsQueryTestablePermissions_579983(
    name: "iamPermissionsQueryTestablePermissions", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/permissions:queryTestablePermissions",
    validator: validate_IamPermissionsQueryTestablePermissions_579984, base: "/",
    url: url_IamPermissionsQueryTestablePermissions_579985,
    schemes: {Scheme.Https})
type
  Call_IamRolesList_580002 = ref object of OpenApiRestCall_579421
proc url_IamRolesList_580004(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IamRolesList_580003(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_580007 = query.getOrDefault("pageToken")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "pageToken", valid_580007
  var valid_580008 = query.getOrDefault("quotaUser")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "quotaUser", valid_580008
  var valid_580009 = query.getOrDefault("view")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_580009 != nil:
    section.add "view", valid_580009
  var valid_580010 = query.getOrDefault("alt")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = newJString("json"))
  if valid_580010 != nil:
    section.add "alt", valid_580010
  var valid_580011 = query.getOrDefault("oauth_token")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "oauth_token", valid_580011
  var valid_580012 = query.getOrDefault("callback")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "callback", valid_580012
  var valid_580013 = query.getOrDefault("access_token")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "access_token", valid_580013
  var valid_580014 = query.getOrDefault("uploadType")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "uploadType", valid_580014
  var valid_580015 = query.getOrDefault("parent")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "parent", valid_580015
  var valid_580016 = query.getOrDefault("showDeleted")
  valid_580016 = validateParameter(valid_580016, JBool, required = false, default = nil)
  if valid_580016 != nil:
    section.add "showDeleted", valid_580016
  var valid_580017 = query.getOrDefault("key")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "key", valid_580017
  var valid_580018 = query.getOrDefault("$.xgafv")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = newJString("1"))
  if valid_580018 != nil:
    section.add "$.xgafv", valid_580018
  var valid_580019 = query.getOrDefault("pageSize")
  valid_580019 = validateParameter(valid_580019, JInt, required = false, default = nil)
  if valid_580019 != nil:
    section.add "pageSize", valid_580019
  var valid_580020 = query.getOrDefault("prettyPrint")
  valid_580020 = validateParameter(valid_580020, JBool, required = false,
                                 default = newJBool(true))
  if valid_580020 != nil:
    section.add "prettyPrint", valid_580020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580021: Call_IamRolesList_580002; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Roles defined on a resource.
  ## 
  let valid = call_580021.validator(path, query, header, formData, body)
  let scheme = call_580021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580021.url(scheme.get, call_580021.host, call_580021.base,
                         call_580021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580021, url, valid)

proc call*(call_580022: Call_IamRolesList_580002; uploadProtocol: string = "";
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
  var query_580023 = newJObject()
  add(query_580023, "upload_protocol", newJString(uploadProtocol))
  add(query_580023, "fields", newJString(fields))
  add(query_580023, "pageToken", newJString(pageToken))
  add(query_580023, "quotaUser", newJString(quotaUser))
  add(query_580023, "view", newJString(view))
  add(query_580023, "alt", newJString(alt))
  add(query_580023, "oauth_token", newJString(oauthToken))
  add(query_580023, "callback", newJString(callback))
  add(query_580023, "access_token", newJString(accessToken))
  add(query_580023, "uploadType", newJString(uploadType))
  add(query_580023, "parent", newJString(parent))
  add(query_580023, "showDeleted", newJBool(showDeleted))
  add(query_580023, "key", newJString(key))
  add(query_580023, "$.xgafv", newJString(Xgafv))
  add(query_580023, "pageSize", newJInt(pageSize))
  add(query_580023, "prettyPrint", newJBool(prettyPrint))
  result = call_580022.call(nil, query_580023, nil, nil, nil)

var iamRolesList* = Call_IamRolesList_580002(name: "iamRolesList",
    meth: HttpMethod.HttpGet, host: "iam.googleapis.com", route: "/v1/roles",
    validator: validate_IamRolesList_580003, base: "/", url: url_IamRolesList_580004,
    schemes: {Scheme.Https})
type
  Call_IamRolesQueryGrantableRoles_580024 = ref object of OpenApiRestCall_579421
proc url_IamRolesQueryGrantableRoles_580026(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IamRolesQueryGrantableRoles_580025(path: JsonNode; query: JsonNode;
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
  var valid_580027 = query.getOrDefault("upload_protocol")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "upload_protocol", valid_580027
  var valid_580028 = query.getOrDefault("fields")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "fields", valid_580028
  var valid_580029 = query.getOrDefault("quotaUser")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "quotaUser", valid_580029
  var valid_580030 = query.getOrDefault("alt")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = newJString("json"))
  if valid_580030 != nil:
    section.add "alt", valid_580030
  var valid_580031 = query.getOrDefault("oauth_token")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "oauth_token", valid_580031
  var valid_580032 = query.getOrDefault("callback")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "callback", valid_580032
  var valid_580033 = query.getOrDefault("access_token")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "access_token", valid_580033
  var valid_580034 = query.getOrDefault("uploadType")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "uploadType", valid_580034
  var valid_580035 = query.getOrDefault("key")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "key", valid_580035
  var valid_580036 = query.getOrDefault("$.xgafv")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = newJString("1"))
  if valid_580036 != nil:
    section.add "$.xgafv", valid_580036
  var valid_580037 = query.getOrDefault("prettyPrint")
  valid_580037 = validateParameter(valid_580037, JBool, required = false,
                                 default = newJBool(true))
  if valid_580037 != nil:
    section.add "prettyPrint", valid_580037
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

proc call*(call_580039: Call_IamRolesQueryGrantableRoles_580024; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Queries roles that can be granted on a particular resource.
  ## A role is grantable if it can be used as the role in a binding for a policy
  ## for that resource.
  ## 
  let valid = call_580039.validator(path, query, header, formData, body)
  let scheme = call_580039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580039.url(scheme.get, call_580039.host, call_580039.base,
                         call_580039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580039, url, valid)

proc call*(call_580040: Call_IamRolesQueryGrantableRoles_580024;
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
  add(query_580041, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580042 = body
  add(query_580041, "prettyPrint", newJBool(prettyPrint))
  result = call_580040.call(nil, query_580041, nil, nil, body_580042)

var iamRolesQueryGrantableRoles* = Call_IamRolesQueryGrantableRoles_580024(
    name: "iamRolesQueryGrantableRoles", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/roles:queryGrantableRoles",
    validator: validate_IamRolesQueryGrantableRoles_580025, base: "/",
    url: url_IamRolesQueryGrantableRoles_580026, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsUpdate_580077 = ref object of OpenApiRestCall_579421
proc url_IamProjectsServiceAccountsUpdate_580079(protocol: Scheme; host: string;
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

proc validate_IamProjectsServiceAccountsUpdate_580078(path: JsonNode;
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
  var valid_580080 = path.getOrDefault("name")
  valid_580080 = validateParameter(valid_580080, JString, required = true,
                                 default = nil)
  if valid_580080 != nil:
    section.add "name", valid_580080
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
  var valid_580081 = query.getOrDefault("upload_protocol")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "upload_protocol", valid_580081
  var valid_580082 = query.getOrDefault("fields")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "fields", valid_580082
  var valid_580083 = query.getOrDefault("quotaUser")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "quotaUser", valid_580083
  var valid_580084 = query.getOrDefault("alt")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = newJString("json"))
  if valid_580084 != nil:
    section.add "alt", valid_580084
  var valid_580085 = query.getOrDefault("oauth_token")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "oauth_token", valid_580085
  var valid_580086 = query.getOrDefault("callback")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "callback", valid_580086
  var valid_580087 = query.getOrDefault("access_token")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "access_token", valid_580087
  var valid_580088 = query.getOrDefault("uploadType")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "uploadType", valid_580088
  var valid_580089 = query.getOrDefault("key")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "key", valid_580089
  var valid_580090 = query.getOrDefault("$.xgafv")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = newJString("1"))
  if valid_580090 != nil:
    section.add "$.xgafv", valid_580090
  var valid_580091 = query.getOrDefault("prettyPrint")
  valid_580091 = validateParameter(valid_580091, JBool, required = false,
                                 default = newJBool(true))
  if valid_580091 != nil:
    section.add "prettyPrint", valid_580091
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

proc call*(call_580093: Call_IamProjectsServiceAccountsUpdate_580077;
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
  let valid = call_580093.validator(path, query, header, formData, body)
  let scheme = call_580093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580093.url(scheme.get, call_580093.host, call_580093.base,
                         call_580093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580093, url, valid)

proc call*(call_580094: Call_IamProjectsServiceAccountsUpdate_580077; name: string;
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
  var path_580095 = newJObject()
  var query_580096 = newJObject()
  var body_580097 = newJObject()
  add(query_580096, "upload_protocol", newJString(uploadProtocol))
  add(query_580096, "fields", newJString(fields))
  add(query_580096, "quotaUser", newJString(quotaUser))
  add(path_580095, "name", newJString(name))
  add(query_580096, "alt", newJString(alt))
  add(query_580096, "oauth_token", newJString(oauthToken))
  add(query_580096, "callback", newJString(callback))
  add(query_580096, "access_token", newJString(accessToken))
  add(query_580096, "uploadType", newJString(uploadType))
  add(query_580096, "key", newJString(key))
  add(query_580096, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580097 = body
  add(query_580096, "prettyPrint", newJBool(prettyPrint))
  result = call_580094.call(path_580095, query_580096, nil, nil, body_580097)

var iamProjectsServiceAccountsUpdate* = Call_IamProjectsServiceAccountsUpdate_580077(
    name: "iamProjectsServiceAccountsUpdate", meth: HttpMethod.HttpPut,
    host: "iam.googleapis.com", route: "/v1/{name}",
    validator: validate_IamProjectsServiceAccountsUpdate_580078, base: "/",
    url: url_IamProjectsServiceAccountsUpdate_580079, schemes: {Scheme.Https})
type
  Call_IamOrganizationsRolesGet_580043 = ref object of OpenApiRestCall_579421
proc url_IamOrganizationsRolesGet_580045(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
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

proc validate_IamOrganizationsRolesGet_580044(path: JsonNode; query: JsonNode;
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
  var valid_580060 = path.getOrDefault("name")
  valid_580060 = validateParameter(valid_580060, JString, required = true,
                                 default = nil)
  if valid_580060 != nil:
    section.add "name", valid_580060
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
  var valid_580061 = query.getOrDefault("upload_protocol")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "upload_protocol", valid_580061
  var valid_580062 = query.getOrDefault("fields")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "fields", valid_580062
  var valid_580063 = query.getOrDefault("quotaUser")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "quotaUser", valid_580063
  var valid_580064 = query.getOrDefault("alt")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = newJString("json"))
  if valid_580064 != nil:
    section.add "alt", valid_580064
  var valid_580065 = query.getOrDefault("oauth_token")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "oauth_token", valid_580065
  var valid_580066 = query.getOrDefault("callback")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "callback", valid_580066
  var valid_580067 = query.getOrDefault("access_token")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "access_token", valid_580067
  var valid_580068 = query.getOrDefault("uploadType")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "uploadType", valid_580068
  var valid_580069 = query.getOrDefault("publicKeyType")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = newJString("TYPE_NONE"))
  if valid_580069 != nil:
    section.add "publicKeyType", valid_580069
  var valid_580070 = query.getOrDefault("key")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "key", valid_580070
  var valid_580071 = query.getOrDefault("$.xgafv")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = newJString("1"))
  if valid_580071 != nil:
    section.add "$.xgafv", valid_580071
  var valid_580072 = query.getOrDefault("prettyPrint")
  valid_580072 = validateParameter(valid_580072, JBool, required = false,
                                 default = newJBool(true))
  if valid_580072 != nil:
    section.add "prettyPrint", valid_580072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580073: Call_IamOrganizationsRolesGet_580043; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Role definition.
  ## 
  let valid = call_580073.validator(path, query, header, formData, body)
  let scheme = call_580073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580073.url(scheme.get, call_580073.host, call_580073.base,
                         call_580073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580073, url, valid)

proc call*(call_580074: Call_IamOrganizationsRolesGet_580043; name: string;
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
  var path_580075 = newJObject()
  var query_580076 = newJObject()
  add(query_580076, "upload_protocol", newJString(uploadProtocol))
  add(query_580076, "fields", newJString(fields))
  add(query_580076, "quotaUser", newJString(quotaUser))
  add(path_580075, "name", newJString(name))
  add(query_580076, "alt", newJString(alt))
  add(query_580076, "oauth_token", newJString(oauthToken))
  add(query_580076, "callback", newJString(callback))
  add(query_580076, "access_token", newJString(accessToken))
  add(query_580076, "uploadType", newJString(uploadType))
  add(query_580076, "publicKeyType", newJString(publicKeyType))
  add(query_580076, "key", newJString(key))
  add(query_580076, "$.xgafv", newJString(Xgafv))
  add(query_580076, "prettyPrint", newJBool(prettyPrint))
  result = call_580074.call(path_580075, query_580076, nil, nil, nil)

var iamOrganizationsRolesGet* = Call_IamOrganizationsRolesGet_580043(
    name: "iamOrganizationsRolesGet", meth: HttpMethod.HttpGet,
    host: "iam.googleapis.com", route: "/v1/{name}",
    validator: validate_IamOrganizationsRolesGet_580044, base: "/",
    url: url_IamOrganizationsRolesGet_580045, schemes: {Scheme.Https})
type
  Call_IamOrganizationsRolesPatch_580118 = ref object of OpenApiRestCall_579421
proc url_IamOrganizationsRolesPatch_580120(protocol: Scheme; host: string;
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

proc validate_IamOrganizationsRolesPatch_580119(path: JsonNode; query: JsonNode;
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
  var valid_580121 = path.getOrDefault("name")
  valid_580121 = validateParameter(valid_580121, JString, required = true,
                                 default = nil)
  if valid_580121 != nil:
    section.add "name", valid_580121
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
  var valid_580122 = query.getOrDefault("upload_protocol")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "upload_protocol", valid_580122
  var valid_580123 = query.getOrDefault("fields")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "fields", valid_580123
  var valid_580124 = query.getOrDefault("quotaUser")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "quotaUser", valid_580124
  var valid_580125 = query.getOrDefault("alt")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = newJString("json"))
  if valid_580125 != nil:
    section.add "alt", valid_580125
  var valid_580126 = query.getOrDefault("oauth_token")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "oauth_token", valid_580126
  var valid_580127 = query.getOrDefault("callback")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "callback", valid_580127
  var valid_580128 = query.getOrDefault("access_token")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "access_token", valid_580128
  var valid_580129 = query.getOrDefault("uploadType")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "uploadType", valid_580129
  var valid_580130 = query.getOrDefault("key")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "key", valid_580130
  var valid_580131 = query.getOrDefault("$.xgafv")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = newJString("1"))
  if valid_580131 != nil:
    section.add "$.xgafv", valid_580131
  var valid_580132 = query.getOrDefault("prettyPrint")
  valid_580132 = validateParameter(valid_580132, JBool, required = false,
                                 default = newJBool(true))
  if valid_580132 != nil:
    section.add "prettyPrint", valid_580132
  var valid_580133 = query.getOrDefault("updateMask")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "updateMask", valid_580133
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

proc call*(call_580135: Call_IamOrganizationsRolesPatch_580118; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Role definition.
  ## 
  let valid = call_580135.validator(path, query, header, formData, body)
  let scheme = call_580135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580135.url(scheme.get, call_580135.host, call_580135.base,
                         call_580135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580135, url, valid)

proc call*(call_580136: Call_IamOrganizationsRolesPatch_580118; name: string;
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
  var path_580137 = newJObject()
  var query_580138 = newJObject()
  var body_580139 = newJObject()
  add(query_580138, "upload_protocol", newJString(uploadProtocol))
  add(query_580138, "fields", newJString(fields))
  add(query_580138, "quotaUser", newJString(quotaUser))
  add(path_580137, "name", newJString(name))
  add(query_580138, "alt", newJString(alt))
  add(query_580138, "oauth_token", newJString(oauthToken))
  add(query_580138, "callback", newJString(callback))
  add(query_580138, "access_token", newJString(accessToken))
  add(query_580138, "uploadType", newJString(uploadType))
  add(query_580138, "key", newJString(key))
  add(query_580138, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580139 = body
  add(query_580138, "prettyPrint", newJBool(prettyPrint))
  add(query_580138, "updateMask", newJString(updateMask))
  result = call_580136.call(path_580137, query_580138, nil, nil, body_580139)

var iamOrganizationsRolesPatch* = Call_IamOrganizationsRolesPatch_580118(
    name: "iamOrganizationsRolesPatch", meth: HttpMethod.HttpPatch,
    host: "iam.googleapis.com", route: "/v1/{name}",
    validator: validate_IamOrganizationsRolesPatch_580119, base: "/",
    url: url_IamOrganizationsRolesPatch_580120, schemes: {Scheme.Https})
type
  Call_IamOrganizationsRolesDelete_580098 = ref object of OpenApiRestCall_579421
proc url_IamOrganizationsRolesDelete_580100(protocol: Scheme; host: string;
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

proc validate_IamOrganizationsRolesDelete_580099(path: JsonNode; query: JsonNode;
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
  var valid_580101 = path.getOrDefault("name")
  valid_580101 = validateParameter(valid_580101, JString, required = true,
                                 default = nil)
  if valid_580101 != nil:
    section.add "name", valid_580101
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
  var valid_580102 = query.getOrDefault("upload_protocol")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "upload_protocol", valid_580102
  var valid_580103 = query.getOrDefault("fields")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "fields", valid_580103
  var valid_580104 = query.getOrDefault("quotaUser")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "quotaUser", valid_580104
  var valid_580105 = query.getOrDefault("alt")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = newJString("json"))
  if valid_580105 != nil:
    section.add "alt", valid_580105
  var valid_580106 = query.getOrDefault("oauth_token")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "oauth_token", valid_580106
  var valid_580107 = query.getOrDefault("callback")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "callback", valid_580107
  var valid_580108 = query.getOrDefault("access_token")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "access_token", valid_580108
  var valid_580109 = query.getOrDefault("uploadType")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "uploadType", valid_580109
  var valid_580110 = query.getOrDefault("key")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "key", valid_580110
  var valid_580111 = query.getOrDefault("$.xgafv")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = newJString("1"))
  if valid_580111 != nil:
    section.add "$.xgafv", valid_580111
  var valid_580112 = query.getOrDefault("prettyPrint")
  valid_580112 = validateParameter(valid_580112, JBool, required = false,
                                 default = newJBool(true))
  if valid_580112 != nil:
    section.add "prettyPrint", valid_580112
  var valid_580113 = query.getOrDefault("etag")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "etag", valid_580113
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580114: Call_IamOrganizationsRolesDelete_580098; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Soft deletes a role. The role is suspended and cannot be used to create new
  ## IAM Policy Bindings.
  ## The Role will not be included in `ListRoles()` unless `show_deleted` is set
  ## in the `ListRolesRequest`. The Role contains the deleted boolean set.
  ## Existing Bindings remains, but are inactive. The Role can be undeleted
  ## within 7 days. After 7 days the Role is deleted and all Bindings associated
  ## with the role are removed.
  ## 
  let valid = call_580114.validator(path, query, header, formData, body)
  let scheme = call_580114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580114.url(scheme.get, call_580114.host, call_580114.base,
                         call_580114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580114, url, valid)

proc call*(call_580115: Call_IamOrganizationsRolesDelete_580098; name: string;
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
  var path_580116 = newJObject()
  var query_580117 = newJObject()
  add(query_580117, "upload_protocol", newJString(uploadProtocol))
  add(query_580117, "fields", newJString(fields))
  add(query_580117, "quotaUser", newJString(quotaUser))
  add(path_580116, "name", newJString(name))
  add(query_580117, "alt", newJString(alt))
  add(query_580117, "oauth_token", newJString(oauthToken))
  add(query_580117, "callback", newJString(callback))
  add(query_580117, "access_token", newJString(accessToken))
  add(query_580117, "uploadType", newJString(uploadType))
  add(query_580117, "key", newJString(key))
  add(query_580117, "$.xgafv", newJString(Xgafv))
  add(query_580117, "prettyPrint", newJBool(prettyPrint))
  add(query_580117, "etag", newJString(etag))
  result = call_580115.call(path_580116, query_580117, nil, nil, nil)

var iamOrganizationsRolesDelete* = Call_IamOrganizationsRolesDelete_580098(
    name: "iamOrganizationsRolesDelete", meth: HttpMethod.HttpDelete,
    host: "iam.googleapis.com", route: "/v1/{name}",
    validator: validate_IamOrganizationsRolesDelete_580099, base: "/",
    url: url_IamOrganizationsRolesDelete_580100, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsKeysCreate_580160 = ref object of OpenApiRestCall_579421
proc url_IamProjectsServiceAccountsKeysCreate_580162(protocol: Scheme;
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

proc validate_IamProjectsServiceAccountsKeysCreate_580161(path: JsonNode;
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
  var valid_580163 = path.getOrDefault("name")
  valid_580163 = validateParameter(valid_580163, JString, required = true,
                                 default = nil)
  if valid_580163 != nil:
    section.add "name", valid_580163
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
  var valid_580164 = query.getOrDefault("upload_protocol")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "upload_protocol", valid_580164
  var valid_580165 = query.getOrDefault("fields")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "fields", valid_580165
  var valid_580166 = query.getOrDefault("quotaUser")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "quotaUser", valid_580166
  var valid_580167 = query.getOrDefault("alt")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = newJString("json"))
  if valid_580167 != nil:
    section.add "alt", valid_580167
  var valid_580168 = query.getOrDefault("oauth_token")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "oauth_token", valid_580168
  var valid_580169 = query.getOrDefault("callback")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "callback", valid_580169
  var valid_580170 = query.getOrDefault("access_token")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "access_token", valid_580170
  var valid_580171 = query.getOrDefault("uploadType")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "uploadType", valid_580171
  var valid_580172 = query.getOrDefault("key")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "key", valid_580172
  var valid_580173 = query.getOrDefault("$.xgafv")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = newJString("1"))
  if valid_580173 != nil:
    section.add "$.xgafv", valid_580173
  var valid_580174 = query.getOrDefault("prettyPrint")
  valid_580174 = validateParameter(valid_580174, JBool, required = false,
                                 default = newJBool(true))
  if valid_580174 != nil:
    section.add "prettyPrint", valid_580174
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

proc call*(call_580176: Call_IamProjectsServiceAccountsKeysCreate_580160;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a ServiceAccountKey
  ## and returns it.
  ## 
  let valid = call_580176.validator(path, query, header, formData, body)
  let scheme = call_580176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580176.url(scheme.get, call_580176.host, call_580176.base,
                         call_580176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580176, url, valid)

proc call*(call_580177: Call_IamProjectsServiceAccountsKeysCreate_580160;
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
  var path_580178 = newJObject()
  var query_580179 = newJObject()
  var body_580180 = newJObject()
  add(query_580179, "upload_protocol", newJString(uploadProtocol))
  add(query_580179, "fields", newJString(fields))
  add(query_580179, "quotaUser", newJString(quotaUser))
  add(path_580178, "name", newJString(name))
  add(query_580179, "alt", newJString(alt))
  add(query_580179, "oauth_token", newJString(oauthToken))
  add(query_580179, "callback", newJString(callback))
  add(query_580179, "access_token", newJString(accessToken))
  add(query_580179, "uploadType", newJString(uploadType))
  add(query_580179, "key", newJString(key))
  add(query_580179, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580180 = body
  add(query_580179, "prettyPrint", newJBool(prettyPrint))
  result = call_580177.call(path_580178, query_580179, nil, nil, body_580180)

var iamProjectsServiceAccountsKeysCreate* = Call_IamProjectsServiceAccountsKeysCreate_580160(
    name: "iamProjectsServiceAccountsKeysCreate", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}/keys",
    validator: validate_IamProjectsServiceAccountsKeysCreate_580161, base: "/",
    url: url_IamProjectsServiceAccountsKeysCreate_580162, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsKeysList_580140 = ref object of OpenApiRestCall_579421
proc url_IamProjectsServiceAccountsKeysList_580142(protocol: Scheme; host: string;
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

proc validate_IamProjectsServiceAccountsKeysList_580141(path: JsonNode;
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
  var valid_580143 = path.getOrDefault("name")
  valid_580143 = validateParameter(valid_580143, JString, required = true,
                                 default = nil)
  if valid_580143 != nil:
    section.add "name", valid_580143
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
  var valid_580144 = query.getOrDefault("upload_protocol")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "upload_protocol", valid_580144
  var valid_580145 = query.getOrDefault("fields")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "fields", valid_580145
  var valid_580146 = query.getOrDefault("quotaUser")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "quotaUser", valid_580146
  var valid_580147 = query.getOrDefault("keyTypes")
  valid_580147 = validateParameter(valid_580147, JArray, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "keyTypes", valid_580147
  var valid_580148 = query.getOrDefault("alt")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = newJString("json"))
  if valid_580148 != nil:
    section.add "alt", valid_580148
  var valid_580149 = query.getOrDefault("oauth_token")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "oauth_token", valid_580149
  var valid_580150 = query.getOrDefault("callback")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "callback", valid_580150
  var valid_580151 = query.getOrDefault("access_token")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "access_token", valid_580151
  var valid_580152 = query.getOrDefault("uploadType")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "uploadType", valid_580152
  var valid_580153 = query.getOrDefault("key")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "key", valid_580153
  var valid_580154 = query.getOrDefault("$.xgafv")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = newJString("1"))
  if valid_580154 != nil:
    section.add "$.xgafv", valid_580154
  var valid_580155 = query.getOrDefault("prettyPrint")
  valid_580155 = validateParameter(valid_580155, JBool, required = false,
                                 default = newJBool(true))
  if valid_580155 != nil:
    section.add "prettyPrint", valid_580155
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580156: Call_IamProjectsServiceAccountsKeysList_580140;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists ServiceAccountKeys.
  ## 
  let valid = call_580156.validator(path, query, header, formData, body)
  let scheme = call_580156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580156.url(scheme.get, call_580156.host, call_580156.base,
                         call_580156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580156, url, valid)

proc call*(call_580157: Call_IamProjectsServiceAccountsKeysList_580140;
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
  var path_580158 = newJObject()
  var query_580159 = newJObject()
  add(query_580159, "upload_protocol", newJString(uploadProtocol))
  add(query_580159, "fields", newJString(fields))
  add(query_580159, "quotaUser", newJString(quotaUser))
  if keyTypes != nil:
    query_580159.add "keyTypes", keyTypes
  add(path_580158, "name", newJString(name))
  add(query_580159, "alt", newJString(alt))
  add(query_580159, "oauth_token", newJString(oauthToken))
  add(query_580159, "callback", newJString(callback))
  add(query_580159, "access_token", newJString(accessToken))
  add(query_580159, "uploadType", newJString(uploadType))
  add(query_580159, "key", newJString(key))
  add(query_580159, "$.xgafv", newJString(Xgafv))
  add(query_580159, "prettyPrint", newJBool(prettyPrint))
  result = call_580157.call(path_580158, query_580159, nil, nil, nil)

var iamProjectsServiceAccountsKeysList* = Call_IamProjectsServiceAccountsKeysList_580140(
    name: "iamProjectsServiceAccountsKeysList", meth: HttpMethod.HttpGet,
    host: "iam.googleapis.com", route: "/v1/{name}/keys",
    validator: validate_IamProjectsServiceAccountsKeysList_580141, base: "/",
    url: url_IamProjectsServiceAccountsKeysList_580142, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsKeysUpload_580181 = ref object of OpenApiRestCall_579421
proc url_IamProjectsServiceAccountsKeysUpload_580183(protocol: Scheme;
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

proc validate_IamProjectsServiceAccountsKeysUpload_580182(path: JsonNode;
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
  var valid_580184 = path.getOrDefault("name")
  valid_580184 = validateParameter(valid_580184, JString, required = true,
                                 default = nil)
  if valid_580184 != nil:
    section.add "name", valid_580184
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
  var valid_580185 = query.getOrDefault("upload_protocol")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "upload_protocol", valid_580185
  var valid_580186 = query.getOrDefault("fields")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "fields", valid_580186
  var valid_580187 = query.getOrDefault("quotaUser")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "quotaUser", valid_580187
  var valid_580188 = query.getOrDefault("alt")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = newJString("json"))
  if valid_580188 != nil:
    section.add "alt", valid_580188
  var valid_580189 = query.getOrDefault("oauth_token")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "oauth_token", valid_580189
  var valid_580190 = query.getOrDefault("callback")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "callback", valid_580190
  var valid_580191 = query.getOrDefault("access_token")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "access_token", valid_580191
  var valid_580192 = query.getOrDefault("uploadType")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "uploadType", valid_580192
  var valid_580193 = query.getOrDefault("key")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "key", valid_580193
  var valid_580194 = query.getOrDefault("$.xgafv")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = newJString("1"))
  if valid_580194 != nil:
    section.add "$.xgafv", valid_580194
  var valid_580195 = query.getOrDefault("prettyPrint")
  valid_580195 = validateParameter(valid_580195, JBool, required = false,
                                 default = newJBool(true))
  if valid_580195 != nil:
    section.add "prettyPrint", valid_580195
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

proc call*(call_580197: Call_IamProjectsServiceAccountsKeysUpload_580181;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Upload public key for a given service account.
  ## This rpc will create a
  ## ServiceAccountKey that has the
  ## provided public key and returns it.
  ## 
  let valid = call_580197.validator(path, query, header, formData, body)
  let scheme = call_580197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580197.url(scheme.get, call_580197.host, call_580197.base,
                         call_580197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580197, url, valid)

proc call*(call_580198: Call_IamProjectsServiceAccountsKeysUpload_580181;
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
  var path_580199 = newJObject()
  var query_580200 = newJObject()
  var body_580201 = newJObject()
  add(query_580200, "upload_protocol", newJString(uploadProtocol))
  add(query_580200, "fields", newJString(fields))
  add(query_580200, "quotaUser", newJString(quotaUser))
  add(path_580199, "name", newJString(name))
  add(query_580200, "alt", newJString(alt))
  add(query_580200, "oauth_token", newJString(oauthToken))
  add(query_580200, "callback", newJString(callback))
  add(query_580200, "access_token", newJString(accessToken))
  add(query_580200, "uploadType", newJString(uploadType))
  add(query_580200, "key", newJString(key))
  add(query_580200, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580201 = body
  add(query_580200, "prettyPrint", newJBool(prettyPrint))
  result = call_580198.call(path_580199, query_580200, nil, nil, body_580201)

var iamProjectsServiceAccountsKeysUpload* = Call_IamProjectsServiceAccountsKeysUpload_580181(
    name: "iamProjectsServiceAccountsKeysUpload", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}/keys:upload",
    validator: validate_IamProjectsServiceAccountsKeysUpload_580182, base: "/",
    url: url_IamProjectsServiceAccountsKeysUpload_580183, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsCreate_580223 = ref object of OpenApiRestCall_579421
proc url_IamProjectsServiceAccountsCreate_580225(protocol: Scheme; host: string;
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

proc validate_IamProjectsServiceAccountsCreate_580224(path: JsonNode;
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
  var valid_580226 = path.getOrDefault("name")
  valid_580226 = validateParameter(valid_580226, JString, required = true,
                                 default = nil)
  if valid_580226 != nil:
    section.add "name", valid_580226
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
  var valid_580227 = query.getOrDefault("upload_protocol")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "upload_protocol", valid_580227
  var valid_580228 = query.getOrDefault("fields")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "fields", valid_580228
  var valid_580229 = query.getOrDefault("quotaUser")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "quotaUser", valid_580229
  var valid_580230 = query.getOrDefault("alt")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = newJString("json"))
  if valid_580230 != nil:
    section.add "alt", valid_580230
  var valid_580231 = query.getOrDefault("oauth_token")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "oauth_token", valid_580231
  var valid_580232 = query.getOrDefault("callback")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "callback", valid_580232
  var valid_580233 = query.getOrDefault("access_token")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "access_token", valid_580233
  var valid_580234 = query.getOrDefault("uploadType")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "uploadType", valid_580234
  var valid_580235 = query.getOrDefault("key")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "key", valid_580235
  var valid_580236 = query.getOrDefault("$.xgafv")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = newJString("1"))
  if valid_580236 != nil:
    section.add "$.xgafv", valid_580236
  var valid_580237 = query.getOrDefault("prettyPrint")
  valid_580237 = validateParameter(valid_580237, JBool, required = false,
                                 default = newJBool(true))
  if valid_580237 != nil:
    section.add "prettyPrint", valid_580237
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

proc call*(call_580239: Call_IamProjectsServiceAccountsCreate_580223;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a ServiceAccount
  ## and returns it.
  ## 
  let valid = call_580239.validator(path, query, header, formData, body)
  let scheme = call_580239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580239.url(scheme.get, call_580239.host, call_580239.base,
                         call_580239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580239, url, valid)

proc call*(call_580240: Call_IamProjectsServiceAccountsCreate_580223; name: string;
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
  var path_580241 = newJObject()
  var query_580242 = newJObject()
  var body_580243 = newJObject()
  add(query_580242, "upload_protocol", newJString(uploadProtocol))
  add(query_580242, "fields", newJString(fields))
  add(query_580242, "quotaUser", newJString(quotaUser))
  add(path_580241, "name", newJString(name))
  add(query_580242, "alt", newJString(alt))
  add(query_580242, "oauth_token", newJString(oauthToken))
  add(query_580242, "callback", newJString(callback))
  add(query_580242, "access_token", newJString(accessToken))
  add(query_580242, "uploadType", newJString(uploadType))
  add(query_580242, "key", newJString(key))
  add(query_580242, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580243 = body
  add(query_580242, "prettyPrint", newJBool(prettyPrint))
  result = call_580240.call(path_580241, query_580242, nil, nil, body_580243)

var iamProjectsServiceAccountsCreate* = Call_IamProjectsServiceAccountsCreate_580223(
    name: "iamProjectsServiceAccountsCreate", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}/serviceAccounts",
    validator: validate_IamProjectsServiceAccountsCreate_580224, base: "/",
    url: url_IamProjectsServiceAccountsCreate_580225, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsList_580202 = ref object of OpenApiRestCall_579421
proc url_IamProjectsServiceAccountsList_580204(protocol: Scheme; host: string;
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

proc validate_IamProjectsServiceAccountsList_580203(path: JsonNode;
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
  var valid_580205 = path.getOrDefault("name")
  valid_580205 = validateParameter(valid_580205, JString, required = true,
                                 default = nil)
  if valid_580205 != nil:
    section.add "name", valid_580205
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
  var valid_580206 = query.getOrDefault("upload_protocol")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "upload_protocol", valid_580206
  var valid_580207 = query.getOrDefault("fields")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "fields", valid_580207
  var valid_580208 = query.getOrDefault("pageToken")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "pageToken", valid_580208
  var valid_580209 = query.getOrDefault("quotaUser")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "quotaUser", valid_580209
  var valid_580210 = query.getOrDefault("alt")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = newJString("json"))
  if valid_580210 != nil:
    section.add "alt", valid_580210
  var valid_580211 = query.getOrDefault("oauth_token")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "oauth_token", valid_580211
  var valid_580212 = query.getOrDefault("callback")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "callback", valid_580212
  var valid_580213 = query.getOrDefault("access_token")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "access_token", valid_580213
  var valid_580214 = query.getOrDefault("uploadType")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "uploadType", valid_580214
  var valid_580215 = query.getOrDefault("key")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "key", valid_580215
  var valid_580216 = query.getOrDefault("$.xgafv")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = newJString("1"))
  if valid_580216 != nil:
    section.add "$.xgafv", valid_580216
  var valid_580217 = query.getOrDefault("pageSize")
  valid_580217 = validateParameter(valid_580217, JInt, required = false, default = nil)
  if valid_580217 != nil:
    section.add "pageSize", valid_580217
  var valid_580218 = query.getOrDefault("prettyPrint")
  valid_580218 = validateParameter(valid_580218, JBool, required = false,
                                 default = newJBool(true))
  if valid_580218 != nil:
    section.add "prettyPrint", valid_580218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580219: Call_IamProjectsServiceAccountsList_580202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists ServiceAccounts for a project.
  ## 
  let valid = call_580219.validator(path, query, header, formData, body)
  let scheme = call_580219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580219.url(scheme.get, call_580219.host, call_580219.base,
                         call_580219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580219, url, valid)

proc call*(call_580220: Call_IamProjectsServiceAccountsList_580202; name: string;
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
  var path_580221 = newJObject()
  var query_580222 = newJObject()
  add(query_580222, "upload_protocol", newJString(uploadProtocol))
  add(query_580222, "fields", newJString(fields))
  add(query_580222, "pageToken", newJString(pageToken))
  add(query_580222, "quotaUser", newJString(quotaUser))
  add(path_580221, "name", newJString(name))
  add(query_580222, "alt", newJString(alt))
  add(query_580222, "oauth_token", newJString(oauthToken))
  add(query_580222, "callback", newJString(callback))
  add(query_580222, "access_token", newJString(accessToken))
  add(query_580222, "uploadType", newJString(uploadType))
  add(query_580222, "key", newJString(key))
  add(query_580222, "$.xgafv", newJString(Xgafv))
  add(query_580222, "pageSize", newJInt(pageSize))
  add(query_580222, "prettyPrint", newJBool(prettyPrint))
  result = call_580220.call(path_580221, query_580222, nil, nil, nil)

var iamProjectsServiceAccountsList* = Call_IamProjectsServiceAccountsList_580202(
    name: "iamProjectsServiceAccountsList", meth: HttpMethod.HttpGet,
    host: "iam.googleapis.com", route: "/v1/{name}/serviceAccounts",
    validator: validate_IamProjectsServiceAccountsList_580203, base: "/",
    url: url_IamProjectsServiceAccountsList_580204, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsDisable_580244 = ref object of OpenApiRestCall_579421
proc url_IamProjectsServiceAccountsDisable_580246(protocol: Scheme; host: string;
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

proc validate_IamProjectsServiceAccountsDisable_580245(path: JsonNode;
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
  var valid_580247 = path.getOrDefault("name")
  valid_580247 = validateParameter(valid_580247, JString, required = true,
                                 default = nil)
  if valid_580247 != nil:
    section.add "name", valid_580247
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
  var valid_580248 = query.getOrDefault("upload_protocol")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "upload_protocol", valid_580248
  var valid_580249 = query.getOrDefault("fields")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "fields", valid_580249
  var valid_580250 = query.getOrDefault("quotaUser")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "quotaUser", valid_580250
  var valid_580251 = query.getOrDefault("alt")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = newJString("json"))
  if valid_580251 != nil:
    section.add "alt", valid_580251
  var valid_580252 = query.getOrDefault("oauth_token")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "oauth_token", valid_580252
  var valid_580253 = query.getOrDefault("callback")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "callback", valid_580253
  var valid_580254 = query.getOrDefault("access_token")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "access_token", valid_580254
  var valid_580255 = query.getOrDefault("uploadType")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "uploadType", valid_580255
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
  var valid_580258 = query.getOrDefault("prettyPrint")
  valid_580258 = validateParameter(valid_580258, JBool, required = false,
                                 default = newJBool(true))
  if valid_580258 != nil:
    section.add "prettyPrint", valid_580258
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

proc call*(call_580260: Call_IamProjectsServiceAccountsDisable_580244;
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
  let valid = call_580260.validator(path, query, header, formData, body)
  let scheme = call_580260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580260.url(scheme.get, call_580260.host, call_580260.base,
                         call_580260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580260, url, valid)

proc call*(call_580261: Call_IamProjectsServiceAccountsDisable_580244;
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
  var path_580262 = newJObject()
  var query_580263 = newJObject()
  var body_580264 = newJObject()
  add(query_580263, "upload_protocol", newJString(uploadProtocol))
  add(query_580263, "fields", newJString(fields))
  add(query_580263, "quotaUser", newJString(quotaUser))
  add(path_580262, "name", newJString(name))
  add(query_580263, "alt", newJString(alt))
  add(query_580263, "oauth_token", newJString(oauthToken))
  add(query_580263, "callback", newJString(callback))
  add(query_580263, "access_token", newJString(accessToken))
  add(query_580263, "uploadType", newJString(uploadType))
  add(query_580263, "key", newJString(key))
  add(query_580263, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580264 = body
  add(query_580263, "prettyPrint", newJBool(prettyPrint))
  result = call_580261.call(path_580262, query_580263, nil, nil, body_580264)

var iamProjectsServiceAccountsDisable* = Call_IamProjectsServiceAccountsDisable_580244(
    name: "iamProjectsServiceAccountsDisable", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}:disable",
    validator: validate_IamProjectsServiceAccountsDisable_580245, base: "/",
    url: url_IamProjectsServiceAccountsDisable_580246, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsEnable_580265 = ref object of OpenApiRestCall_579421
proc url_IamProjectsServiceAccountsEnable_580267(protocol: Scheme; host: string;
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

proc validate_IamProjectsServiceAccountsEnable_580266(path: JsonNode;
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
  var valid_580268 = path.getOrDefault("name")
  valid_580268 = validateParameter(valid_580268, JString, required = true,
                                 default = nil)
  if valid_580268 != nil:
    section.add "name", valid_580268
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
  var valid_580269 = query.getOrDefault("upload_protocol")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "upload_protocol", valid_580269
  var valid_580270 = query.getOrDefault("fields")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "fields", valid_580270
  var valid_580271 = query.getOrDefault("quotaUser")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "quotaUser", valid_580271
  var valid_580272 = query.getOrDefault("alt")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = newJString("json"))
  if valid_580272 != nil:
    section.add "alt", valid_580272
  var valid_580273 = query.getOrDefault("oauth_token")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "oauth_token", valid_580273
  var valid_580274 = query.getOrDefault("callback")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "callback", valid_580274
  var valid_580275 = query.getOrDefault("access_token")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = nil)
  if valid_580275 != nil:
    section.add "access_token", valid_580275
  var valid_580276 = query.getOrDefault("uploadType")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "uploadType", valid_580276
  var valid_580277 = query.getOrDefault("key")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "key", valid_580277
  var valid_580278 = query.getOrDefault("$.xgafv")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = newJString("1"))
  if valid_580278 != nil:
    section.add "$.xgafv", valid_580278
  var valid_580279 = query.getOrDefault("prettyPrint")
  valid_580279 = validateParameter(valid_580279, JBool, required = false,
                                 default = newJBool(true))
  if valid_580279 != nil:
    section.add "prettyPrint", valid_580279
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

proc call*(call_580281: Call_IamProjectsServiceAccountsEnable_580265;
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
  let valid = call_580281.validator(path, query, header, formData, body)
  let scheme = call_580281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580281.url(scheme.get, call_580281.host, call_580281.base,
                         call_580281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580281, url, valid)

proc call*(call_580282: Call_IamProjectsServiceAccountsEnable_580265; name: string;
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
  var path_580283 = newJObject()
  var query_580284 = newJObject()
  var body_580285 = newJObject()
  add(query_580284, "upload_protocol", newJString(uploadProtocol))
  add(query_580284, "fields", newJString(fields))
  add(query_580284, "quotaUser", newJString(quotaUser))
  add(path_580283, "name", newJString(name))
  add(query_580284, "alt", newJString(alt))
  add(query_580284, "oauth_token", newJString(oauthToken))
  add(query_580284, "callback", newJString(callback))
  add(query_580284, "access_token", newJString(accessToken))
  add(query_580284, "uploadType", newJString(uploadType))
  add(query_580284, "key", newJString(key))
  add(query_580284, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580285 = body
  add(query_580284, "prettyPrint", newJBool(prettyPrint))
  result = call_580282.call(path_580283, query_580284, nil, nil, body_580285)

var iamProjectsServiceAccountsEnable* = Call_IamProjectsServiceAccountsEnable_580265(
    name: "iamProjectsServiceAccountsEnable", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}:enable",
    validator: validate_IamProjectsServiceAccountsEnable_580266, base: "/",
    url: url_IamProjectsServiceAccountsEnable_580267, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsSignBlob_580286 = ref object of OpenApiRestCall_579421
proc url_IamProjectsServiceAccountsSignBlob_580288(protocol: Scheme; host: string;
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

proc validate_IamProjectsServiceAccountsSignBlob_580287(path: JsonNode;
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
  var valid_580289 = path.getOrDefault("name")
  valid_580289 = validateParameter(valid_580289, JString, required = true,
                                 default = nil)
  if valid_580289 != nil:
    section.add "name", valid_580289
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
  var valid_580290 = query.getOrDefault("upload_protocol")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "upload_protocol", valid_580290
  var valid_580291 = query.getOrDefault("fields")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "fields", valid_580291
  var valid_580292 = query.getOrDefault("quotaUser")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = nil)
  if valid_580292 != nil:
    section.add "quotaUser", valid_580292
  var valid_580293 = query.getOrDefault("alt")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = newJString("json"))
  if valid_580293 != nil:
    section.add "alt", valid_580293
  var valid_580294 = query.getOrDefault("oauth_token")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "oauth_token", valid_580294
  var valid_580295 = query.getOrDefault("callback")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "callback", valid_580295
  var valid_580296 = query.getOrDefault("access_token")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = nil)
  if valid_580296 != nil:
    section.add "access_token", valid_580296
  var valid_580297 = query.getOrDefault("uploadType")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "uploadType", valid_580297
  var valid_580298 = query.getOrDefault("key")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = nil)
  if valid_580298 != nil:
    section.add "key", valid_580298
  var valid_580299 = query.getOrDefault("$.xgafv")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = newJString("1"))
  if valid_580299 != nil:
    section.add "$.xgafv", valid_580299
  var valid_580300 = query.getOrDefault("prettyPrint")
  valid_580300 = validateParameter(valid_580300, JBool, required = false,
                                 default = newJBool(true))
  if valid_580300 != nil:
    section.add "prettyPrint", valid_580300
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

proc call*(call_580302: Call_IamProjectsServiceAccountsSignBlob_580286;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## **Note**: This method is in the process of being deprecated. Call the
  ## [`signBlob()`](/iam/credentials/reference/rest/v1/projects.serviceAccounts/signBlob)
  ## method of the Cloud IAM Service Account Credentials API instead.
  ## 
  ## Signs a blob using a service account's system-managed private key.
  ## 
  let valid = call_580302.validator(path, query, header, formData, body)
  let scheme = call_580302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580302.url(scheme.get, call_580302.host, call_580302.base,
                         call_580302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580302, url, valid)

proc call*(call_580303: Call_IamProjectsServiceAccountsSignBlob_580286;
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
  var path_580304 = newJObject()
  var query_580305 = newJObject()
  var body_580306 = newJObject()
  add(query_580305, "upload_protocol", newJString(uploadProtocol))
  add(query_580305, "fields", newJString(fields))
  add(query_580305, "quotaUser", newJString(quotaUser))
  add(path_580304, "name", newJString(name))
  add(query_580305, "alt", newJString(alt))
  add(query_580305, "oauth_token", newJString(oauthToken))
  add(query_580305, "callback", newJString(callback))
  add(query_580305, "access_token", newJString(accessToken))
  add(query_580305, "uploadType", newJString(uploadType))
  add(query_580305, "key", newJString(key))
  add(query_580305, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580306 = body
  add(query_580305, "prettyPrint", newJBool(prettyPrint))
  result = call_580303.call(path_580304, query_580305, nil, nil, body_580306)

var iamProjectsServiceAccountsSignBlob* = Call_IamProjectsServiceAccountsSignBlob_580286(
    name: "iamProjectsServiceAccountsSignBlob", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}:signBlob",
    validator: validate_IamProjectsServiceAccountsSignBlob_580287, base: "/",
    url: url_IamProjectsServiceAccountsSignBlob_580288, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsSignJwt_580307 = ref object of OpenApiRestCall_579421
proc url_IamProjectsServiceAccountsSignJwt_580309(protocol: Scheme; host: string;
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

proc validate_IamProjectsServiceAccountsSignJwt_580308(path: JsonNode;
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
  var valid_580310 = path.getOrDefault("name")
  valid_580310 = validateParameter(valid_580310, JString, required = true,
                                 default = nil)
  if valid_580310 != nil:
    section.add "name", valid_580310
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
  var valid_580311 = query.getOrDefault("upload_protocol")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "upload_protocol", valid_580311
  var valid_580312 = query.getOrDefault("fields")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = nil)
  if valid_580312 != nil:
    section.add "fields", valid_580312
  var valid_580313 = query.getOrDefault("quotaUser")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "quotaUser", valid_580313
  var valid_580314 = query.getOrDefault("alt")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = newJString("json"))
  if valid_580314 != nil:
    section.add "alt", valid_580314
  var valid_580315 = query.getOrDefault("oauth_token")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "oauth_token", valid_580315
  var valid_580316 = query.getOrDefault("callback")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "callback", valid_580316
  var valid_580317 = query.getOrDefault("access_token")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "access_token", valid_580317
  var valid_580318 = query.getOrDefault("uploadType")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "uploadType", valid_580318
  var valid_580319 = query.getOrDefault("key")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = nil)
  if valid_580319 != nil:
    section.add "key", valid_580319
  var valid_580320 = query.getOrDefault("$.xgafv")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = newJString("1"))
  if valid_580320 != nil:
    section.add "$.xgafv", valid_580320
  var valid_580321 = query.getOrDefault("prettyPrint")
  valid_580321 = validateParameter(valid_580321, JBool, required = false,
                                 default = newJBool(true))
  if valid_580321 != nil:
    section.add "prettyPrint", valid_580321
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

proc call*(call_580323: Call_IamProjectsServiceAccountsSignJwt_580307;
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
  let valid = call_580323.validator(path, query, header, formData, body)
  let scheme = call_580323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580323.url(scheme.get, call_580323.host, call_580323.base,
                         call_580323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580323, url, valid)

proc call*(call_580324: Call_IamProjectsServiceAccountsSignJwt_580307;
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
  var path_580325 = newJObject()
  var query_580326 = newJObject()
  var body_580327 = newJObject()
  add(query_580326, "upload_protocol", newJString(uploadProtocol))
  add(query_580326, "fields", newJString(fields))
  add(query_580326, "quotaUser", newJString(quotaUser))
  add(path_580325, "name", newJString(name))
  add(query_580326, "alt", newJString(alt))
  add(query_580326, "oauth_token", newJString(oauthToken))
  add(query_580326, "callback", newJString(callback))
  add(query_580326, "access_token", newJString(accessToken))
  add(query_580326, "uploadType", newJString(uploadType))
  add(query_580326, "key", newJString(key))
  add(query_580326, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580327 = body
  add(query_580326, "prettyPrint", newJBool(prettyPrint))
  result = call_580324.call(path_580325, query_580326, nil, nil, body_580327)

var iamProjectsServiceAccountsSignJwt* = Call_IamProjectsServiceAccountsSignJwt_580307(
    name: "iamProjectsServiceAccountsSignJwt", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}:signJwt",
    validator: validate_IamProjectsServiceAccountsSignJwt_580308, base: "/",
    url: url_IamProjectsServiceAccountsSignJwt_580309, schemes: {Scheme.Https})
type
  Call_IamOrganizationsRolesUndelete_580328 = ref object of OpenApiRestCall_579421
proc url_IamOrganizationsRolesUndelete_580330(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_IamOrganizationsRolesUndelete_580329(path: JsonNode; query: JsonNode;
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
  var valid_580331 = path.getOrDefault("name")
  valid_580331 = validateParameter(valid_580331, JString, required = true,
                                 default = nil)
  if valid_580331 != nil:
    section.add "name", valid_580331
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
  var valid_580332 = query.getOrDefault("upload_protocol")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = nil)
  if valid_580332 != nil:
    section.add "upload_protocol", valid_580332
  var valid_580333 = query.getOrDefault("fields")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "fields", valid_580333
  var valid_580334 = query.getOrDefault("quotaUser")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = nil)
  if valid_580334 != nil:
    section.add "quotaUser", valid_580334
  var valid_580335 = query.getOrDefault("alt")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = newJString("json"))
  if valid_580335 != nil:
    section.add "alt", valid_580335
  var valid_580336 = query.getOrDefault("oauth_token")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "oauth_token", valid_580336
  var valid_580337 = query.getOrDefault("callback")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "callback", valid_580337
  var valid_580338 = query.getOrDefault("access_token")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "access_token", valid_580338
  var valid_580339 = query.getOrDefault("uploadType")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "uploadType", valid_580339
  var valid_580340 = query.getOrDefault("key")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = nil)
  if valid_580340 != nil:
    section.add "key", valid_580340
  var valid_580341 = query.getOrDefault("$.xgafv")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = newJString("1"))
  if valid_580341 != nil:
    section.add "$.xgafv", valid_580341
  var valid_580342 = query.getOrDefault("prettyPrint")
  valid_580342 = validateParameter(valid_580342, JBool, required = false,
                                 default = newJBool(true))
  if valid_580342 != nil:
    section.add "prettyPrint", valid_580342
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

proc call*(call_580344: Call_IamOrganizationsRolesUndelete_580328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Undelete a Role, bringing it back in its previous state.
  ## 
  let valid = call_580344.validator(path, query, header, formData, body)
  let scheme = call_580344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580344.url(scheme.get, call_580344.host, call_580344.base,
                         call_580344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580344, url, valid)

proc call*(call_580345: Call_IamOrganizationsRolesUndelete_580328; name: string;
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
  var path_580346 = newJObject()
  var query_580347 = newJObject()
  var body_580348 = newJObject()
  add(query_580347, "upload_protocol", newJString(uploadProtocol))
  add(query_580347, "fields", newJString(fields))
  add(query_580347, "quotaUser", newJString(quotaUser))
  add(path_580346, "name", newJString(name))
  add(query_580347, "alt", newJString(alt))
  add(query_580347, "oauth_token", newJString(oauthToken))
  add(query_580347, "callback", newJString(callback))
  add(query_580347, "access_token", newJString(accessToken))
  add(query_580347, "uploadType", newJString(uploadType))
  add(query_580347, "key", newJString(key))
  add(query_580347, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580348 = body
  add(query_580347, "prettyPrint", newJBool(prettyPrint))
  result = call_580345.call(path_580346, query_580347, nil, nil, body_580348)

var iamOrganizationsRolesUndelete* = Call_IamOrganizationsRolesUndelete_580328(
    name: "iamOrganizationsRolesUndelete", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}:undelete",
    validator: validate_IamOrganizationsRolesUndelete_580329, base: "/",
    url: url_IamOrganizationsRolesUndelete_580330, schemes: {Scheme.Https})
type
  Call_IamOrganizationsRolesCreate_580372 = ref object of OpenApiRestCall_579421
proc url_IamOrganizationsRolesCreate_580374(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_IamOrganizationsRolesCreate_580373(path: JsonNode; query: JsonNode;
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
  var valid_580375 = path.getOrDefault("parent")
  valid_580375 = validateParameter(valid_580375, JString, required = true,
                                 default = nil)
  if valid_580375 != nil:
    section.add "parent", valid_580375
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
  var valid_580376 = query.getOrDefault("upload_protocol")
  valid_580376 = validateParameter(valid_580376, JString, required = false,
                                 default = nil)
  if valid_580376 != nil:
    section.add "upload_protocol", valid_580376
  var valid_580377 = query.getOrDefault("fields")
  valid_580377 = validateParameter(valid_580377, JString, required = false,
                                 default = nil)
  if valid_580377 != nil:
    section.add "fields", valid_580377
  var valid_580378 = query.getOrDefault("quotaUser")
  valid_580378 = validateParameter(valid_580378, JString, required = false,
                                 default = nil)
  if valid_580378 != nil:
    section.add "quotaUser", valid_580378
  var valid_580379 = query.getOrDefault("alt")
  valid_580379 = validateParameter(valid_580379, JString, required = false,
                                 default = newJString("json"))
  if valid_580379 != nil:
    section.add "alt", valid_580379
  var valid_580380 = query.getOrDefault("oauth_token")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = nil)
  if valid_580380 != nil:
    section.add "oauth_token", valid_580380
  var valid_580381 = query.getOrDefault("callback")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "callback", valid_580381
  var valid_580382 = query.getOrDefault("access_token")
  valid_580382 = validateParameter(valid_580382, JString, required = false,
                                 default = nil)
  if valid_580382 != nil:
    section.add "access_token", valid_580382
  var valid_580383 = query.getOrDefault("uploadType")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = nil)
  if valid_580383 != nil:
    section.add "uploadType", valid_580383
  var valid_580384 = query.getOrDefault("key")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = nil)
  if valid_580384 != nil:
    section.add "key", valid_580384
  var valid_580385 = query.getOrDefault("$.xgafv")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = newJString("1"))
  if valid_580385 != nil:
    section.add "$.xgafv", valid_580385
  var valid_580386 = query.getOrDefault("prettyPrint")
  valid_580386 = validateParameter(valid_580386, JBool, required = false,
                                 default = newJBool(true))
  if valid_580386 != nil:
    section.add "prettyPrint", valid_580386
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

proc call*(call_580388: Call_IamOrganizationsRolesCreate_580372; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Role.
  ## 
  let valid = call_580388.validator(path, query, header, formData, body)
  let scheme = call_580388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580388.url(scheme.get, call_580388.host, call_580388.base,
                         call_580388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580388, url, valid)

proc call*(call_580389: Call_IamOrganizationsRolesCreate_580372; parent: string;
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
  var path_580390 = newJObject()
  var query_580391 = newJObject()
  var body_580392 = newJObject()
  add(query_580391, "upload_protocol", newJString(uploadProtocol))
  add(query_580391, "fields", newJString(fields))
  add(query_580391, "quotaUser", newJString(quotaUser))
  add(query_580391, "alt", newJString(alt))
  add(query_580391, "oauth_token", newJString(oauthToken))
  add(query_580391, "callback", newJString(callback))
  add(query_580391, "access_token", newJString(accessToken))
  add(query_580391, "uploadType", newJString(uploadType))
  add(path_580390, "parent", newJString(parent))
  add(query_580391, "key", newJString(key))
  add(query_580391, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580392 = body
  add(query_580391, "prettyPrint", newJBool(prettyPrint))
  result = call_580389.call(path_580390, query_580391, nil, nil, body_580392)

var iamOrganizationsRolesCreate* = Call_IamOrganizationsRolesCreate_580372(
    name: "iamOrganizationsRolesCreate", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{parent}/roles",
    validator: validate_IamOrganizationsRolesCreate_580373, base: "/",
    url: url_IamOrganizationsRolesCreate_580374, schemes: {Scheme.Https})
type
  Call_IamOrganizationsRolesList_580349 = ref object of OpenApiRestCall_579421
proc url_IamOrganizationsRolesList_580351(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_IamOrganizationsRolesList_580350(path: JsonNode; query: JsonNode;
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
  var valid_580352 = path.getOrDefault("parent")
  valid_580352 = validateParameter(valid_580352, JString, required = true,
                                 default = nil)
  if valid_580352 != nil:
    section.add "parent", valid_580352
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
  var valid_580353 = query.getOrDefault("upload_protocol")
  valid_580353 = validateParameter(valid_580353, JString, required = false,
                                 default = nil)
  if valid_580353 != nil:
    section.add "upload_protocol", valid_580353
  var valid_580354 = query.getOrDefault("fields")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = nil)
  if valid_580354 != nil:
    section.add "fields", valid_580354
  var valid_580355 = query.getOrDefault("pageToken")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "pageToken", valid_580355
  var valid_580356 = query.getOrDefault("quotaUser")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = nil)
  if valid_580356 != nil:
    section.add "quotaUser", valid_580356
  var valid_580357 = query.getOrDefault("view")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_580357 != nil:
    section.add "view", valid_580357
  var valid_580358 = query.getOrDefault("alt")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = newJString("json"))
  if valid_580358 != nil:
    section.add "alt", valid_580358
  var valid_580359 = query.getOrDefault("oauth_token")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = nil)
  if valid_580359 != nil:
    section.add "oauth_token", valid_580359
  var valid_580360 = query.getOrDefault("callback")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "callback", valid_580360
  var valid_580361 = query.getOrDefault("access_token")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "access_token", valid_580361
  var valid_580362 = query.getOrDefault("uploadType")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "uploadType", valid_580362
  var valid_580363 = query.getOrDefault("showDeleted")
  valid_580363 = validateParameter(valid_580363, JBool, required = false, default = nil)
  if valid_580363 != nil:
    section.add "showDeleted", valid_580363
  var valid_580364 = query.getOrDefault("key")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "key", valid_580364
  var valid_580365 = query.getOrDefault("$.xgafv")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = newJString("1"))
  if valid_580365 != nil:
    section.add "$.xgafv", valid_580365
  var valid_580366 = query.getOrDefault("pageSize")
  valid_580366 = validateParameter(valid_580366, JInt, required = false, default = nil)
  if valid_580366 != nil:
    section.add "pageSize", valid_580366
  var valid_580367 = query.getOrDefault("prettyPrint")
  valid_580367 = validateParameter(valid_580367, JBool, required = false,
                                 default = newJBool(true))
  if valid_580367 != nil:
    section.add "prettyPrint", valid_580367
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580368: Call_IamOrganizationsRolesList_580349; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Roles defined on a resource.
  ## 
  let valid = call_580368.validator(path, query, header, formData, body)
  let scheme = call_580368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580368.url(scheme.get, call_580368.host, call_580368.base,
                         call_580368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580368, url, valid)

proc call*(call_580369: Call_IamOrganizationsRolesList_580349; parent: string;
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
  var path_580370 = newJObject()
  var query_580371 = newJObject()
  add(query_580371, "upload_protocol", newJString(uploadProtocol))
  add(query_580371, "fields", newJString(fields))
  add(query_580371, "pageToken", newJString(pageToken))
  add(query_580371, "quotaUser", newJString(quotaUser))
  add(query_580371, "view", newJString(view))
  add(query_580371, "alt", newJString(alt))
  add(query_580371, "oauth_token", newJString(oauthToken))
  add(query_580371, "callback", newJString(callback))
  add(query_580371, "access_token", newJString(accessToken))
  add(query_580371, "uploadType", newJString(uploadType))
  add(path_580370, "parent", newJString(parent))
  add(query_580371, "showDeleted", newJBool(showDeleted))
  add(query_580371, "key", newJString(key))
  add(query_580371, "$.xgafv", newJString(Xgafv))
  add(query_580371, "pageSize", newJInt(pageSize))
  add(query_580371, "prettyPrint", newJBool(prettyPrint))
  result = call_580369.call(path_580370, query_580371, nil, nil, nil)

var iamOrganizationsRolesList* = Call_IamOrganizationsRolesList_580349(
    name: "iamOrganizationsRolesList", meth: HttpMethod.HttpGet,
    host: "iam.googleapis.com", route: "/v1/{parent}/roles",
    validator: validate_IamOrganizationsRolesList_580350, base: "/",
    url: url_IamOrganizationsRolesList_580351, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsGetIamPolicy_580393 = ref object of OpenApiRestCall_579421
proc url_IamProjectsServiceAccountsGetIamPolicy_580395(protocol: Scheme;
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

proc validate_IamProjectsServiceAccountsGetIamPolicy_580394(path: JsonNode;
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
  var valid_580396 = path.getOrDefault("resource")
  valid_580396 = validateParameter(valid_580396, JString, required = true,
                                 default = nil)
  if valid_580396 != nil:
    section.add "resource", valid_580396
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
  var valid_580397 = query.getOrDefault("upload_protocol")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = nil)
  if valid_580397 != nil:
    section.add "upload_protocol", valid_580397
  var valid_580398 = query.getOrDefault("fields")
  valid_580398 = validateParameter(valid_580398, JString, required = false,
                                 default = nil)
  if valid_580398 != nil:
    section.add "fields", valid_580398
  var valid_580399 = query.getOrDefault("quotaUser")
  valid_580399 = validateParameter(valid_580399, JString, required = false,
                                 default = nil)
  if valid_580399 != nil:
    section.add "quotaUser", valid_580399
  var valid_580400 = query.getOrDefault("alt")
  valid_580400 = validateParameter(valid_580400, JString, required = false,
                                 default = newJString("json"))
  if valid_580400 != nil:
    section.add "alt", valid_580400
  var valid_580401 = query.getOrDefault("oauth_token")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "oauth_token", valid_580401
  var valid_580402 = query.getOrDefault("callback")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "callback", valid_580402
  var valid_580403 = query.getOrDefault("access_token")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = nil)
  if valid_580403 != nil:
    section.add "access_token", valid_580403
  var valid_580404 = query.getOrDefault("uploadType")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = nil)
  if valid_580404 != nil:
    section.add "uploadType", valid_580404
  var valid_580405 = query.getOrDefault("options.requestedPolicyVersion")
  valid_580405 = validateParameter(valid_580405, JInt, required = false, default = nil)
  if valid_580405 != nil:
    section.add "options.requestedPolicyVersion", valid_580405
  var valid_580406 = query.getOrDefault("key")
  valid_580406 = validateParameter(valid_580406, JString, required = false,
                                 default = nil)
  if valid_580406 != nil:
    section.add "key", valid_580406
  var valid_580407 = query.getOrDefault("$.xgafv")
  valid_580407 = validateParameter(valid_580407, JString, required = false,
                                 default = newJString("1"))
  if valid_580407 != nil:
    section.add "$.xgafv", valid_580407
  var valid_580408 = query.getOrDefault("prettyPrint")
  valid_580408 = validateParameter(valid_580408, JBool, required = false,
                                 default = newJBool(true))
  if valid_580408 != nil:
    section.add "prettyPrint", valid_580408
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580409: Call_IamProjectsServiceAccountsGetIamPolicy_580393;
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
  let valid = call_580409.validator(path, query, header, formData, body)
  let scheme = call_580409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580409.url(scheme.get, call_580409.host, call_580409.base,
                         call_580409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580409, url, valid)

proc call*(call_580410: Call_IamProjectsServiceAccountsGetIamPolicy_580393;
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
  var path_580411 = newJObject()
  var query_580412 = newJObject()
  add(query_580412, "upload_protocol", newJString(uploadProtocol))
  add(query_580412, "fields", newJString(fields))
  add(query_580412, "quotaUser", newJString(quotaUser))
  add(query_580412, "alt", newJString(alt))
  add(query_580412, "oauth_token", newJString(oauthToken))
  add(query_580412, "callback", newJString(callback))
  add(query_580412, "access_token", newJString(accessToken))
  add(query_580412, "uploadType", newJString(uploadType))
  add(query_580412, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_580412, "key", newJString(key))
  add(query_580412, "$.xgafv", newJString(Xgafv))
  add(path_580411, "resource", newJString(resource))
  add(query_580412, "prettyPrint", newJBool(prettyPrint))
  result = call_580410.call(path_580411, query_580412, nil, nil, nil)

var iamProjectsServiceAccountsGetIamPolicy* = Call_IamProjectsServiceAccountsGetIamPolicy_580393(
    name: "iamProjectsServiceAccountsGetIamPolicy", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{resource}:getIamPolicy",
    validator: validate_IamProjectsServiceAccountsGetIamPolicy_580394, base: "/",
    url: url_IamProjectsServiceAccountsGetIamPolicy_580395,
    schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsSetIamPolicy_580413 = ref object of OpenApiRestCall_579421
proc url_IamProjectsServiceAccountsSetIamPolicy_580415(protocol: Scheme;
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

proc validate_IamProjectsServiceAccountsSetIamPolicy_580414(path: JsonNode;
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
  var valid_580416 = path.getOrDefault("resource")
  valid_580416 = validateParameter(valid_580416, JString, required = true,
                                 default = nil)
  if valid_580416 != nil:
    section.add "resource", valid_580416
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
  var valid_580417 = query.getOrDefault("upload_protocol")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = nil)
  if valid_580417 != nil:
    section.add "upload_protocol", valid_580417
  var valid_580418 = query.getOrDefault("fields")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = nil)
  if valid_580418 != nil:
    section.add "fields", valid_580418
  var valid_580419 = query.getOrDefault("quotaUser")
  valid_580419 = validateParameter(valid_580419, JString, required = false,
                                 default = nil)
  if valid_580419 != nil:
    section.add "quotaUser", valid_580419
  var valid_580420 = query.getOrDefault("alt")
  valid_580420 = validateParameter(valid_580420, JString, required = false,
                                 default = newJString("json"))
  if valid_580420 != nil:
    section.add "alt", valid_580420
  var valid_580421 = query.getOrDefault("oauth_token")
  valid_580421 = validateParameter(valid_580421, JString, required = false,
                                 default = nil)
  if valid_580421 != nil:
    section.add "oauth_token", valid_580421
  var valid_580422 = query.getOrDefault("callback")
  valid_580422 = validateParameter(valid_580422, JString, required = false,
                                 default = nil)
  if valid_580422 != nil:
    section.add "callback", valid_580422
  var valid_580423 = query.getOrDefault("access_token")
  valid_580423 = validateParameter(valid_580423, JString, required = false,
                                 default = nil)
  if valid_580423 != nil:
    section.add "access_token", valid_580423
  var valid_580424 = query.getOrDefault("uploadType")
  valid_580424 = validateParameter(valid_580424, JString, required = false,
                                 default = nil)
  if valid_580424 != nil:
    section.add "uploadType", valid_580424
  var valid_580425 = query.getOrDefault("key")
  valid_580425 = validateParameter(valid_580425, JString, required = false,
                                 default = nil)
  if valid_580425 != nil:
    section.add "key", valid_580425
  var valid_580426 = query.getOrDefault("$.xgafv")
  valid_580426 = validateParameter(valid_580426, JString, required = false,
                                 default = newJString("1"))
  if valid_580426 != nil:
    section.add "$.xgafv", valid_580426
  var valid_580427 = query.getOrDefault("prettyPrint")
  valid_580427 = validateParameter(valid_580427, JBool, required = false,
                                 default = newJBool(true))
  if valid_580427 != nil:
    section.add "prettyPrint", valid_580427
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

proc call*(call_580429: Call_IamProjectsServiceAccountsSetIamPolicy_580413;
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
  let valid = call_580429.validator(path, query, header, formData, body)
  let scheme = call_580429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580429.url(scheme.get, call_580429.host, call_580429.base,
                         call_580429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580429, url, valid)

proc call*(call_580430: Call_IamProjectsServiceAccountsSetIamPolicy_580413;
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
  var path_580431 = newJObject()
  var query_580432 = newJObject()
  var body_580433 = newJObject()
  add(query_580432, "upload_protocol", newJString(uploadProtocol))
  add(query_580432, "fields", newJString(fields))
  add(query_580432, "quotaUser", newJString(quotaUser))
  add(query_580432, "alt", newJString(alt))
  add(query_580432, "oauth_token", newJString(oauthToken))
  add(query_580432, "callback", newJString(callback))
  add(query_580432, "access_token", newJString(accessToken))
  add(query_580432, "uploadType", newJString(uploadType))
  add(query_580432, "key", newJString(key))
  add(query_580432, "$.xgafv", newJString(Xgafv))
  add(path_580431, "resource", newJString(resource))
  if body != nil:
    body_580433 = body
  add(query_580432, "prettyPrint", newJBool(prettyPrint))
  result = call_580430.call(path_580431, query_580432, nil, nil, body_580433)

var iamProjectsServiceAccountsSetIamPolicy* = Call_IamProjectsServiceAccountsSetIamPolicy_580413(
    name: "iamProjectsServiceAccountsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{resource}:setIamPolicy",
    validator: validate_IamProjectsServiceAccountsSetIamPolicy_580414, base: "/",
    url: url_IamProjectsServiceAccountsSetIamPolicy_580415,
    schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsTestIamPermissions_580434 = ref object of OpenApiRestCall_579421
proc url_IamProjectsServiceAccountsTestIamPermissions_580436(protocol: Scheme;
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

proc validate_IamProjectsServiceAccountsTestIamPermissions_580435(path: JsonNode;
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
  var valid_580437 = path.getOrDefault("resource")
  valid_580437 = validateParameter(valid_580437, JString, required = true,
                                 default = nil)
  if valid_580437 != nil:
    section.add "resource", valid_580437
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
  var valid_580438 = query.getOrDefault("upload_protocol")
  valid_580438 = validateParameter(valid_580438, JString, required = false,
                                 default = nil)
  if valid_580438 != nil:
    section.add "upload_protocol", valid_580438
  var valid_580439 = query.getOrDefault("fields")
  valid_580439 = validateParameter(valid_580439, JString, required = false,
                                 default = nil)
  if valid_580439 != nil:
    section.add "fields", valid_580439
  var valid_580440 = query.getOrDefault("quotaUser")
  valid_580440 = validateParameter(valid_580440, JString, required = false,
                                 default = nil)
  if valid_580440 != nil:
    section.add "quotaUser", valid_580440
  var valid_580441 = query.getOrDefault("alt")
  valid_580441 = validateParameter(valid_580441, JString, required = false,
                                 default = newJString("json"))
  if valid_580441 != nil:
    section.add "alt", valid_580441
  var valid_580442 = query.getOrDefault("oauth_token")
  valid_580442 = validateParameter(valid_580442, JString, required = false,
                                 default = nil)
  if valid_580442 != nil:
    section.add "oauth_token", valid_580442
  var valid_580443 = query.getOrDefault("callback")
  valid_580443 = validateParameter(valid_580443, JString, required = false,
                                 default = nil)
  if valid_580443 != nil:
    section.add "callback", valid_580443
  var valid_580444 = query.getOrDefault("access_token")
  valid_580444 = validateParameter(valid_580444, JString, required = false,
                                 default = nil)
  if valid_580444 != nil:
    section.add "access_token", valid_580444
  var valid_580445 = query.getOrDefault("uploadType")
  valid_580445 = validateParameter(valid_580445, JString, required = false,
                                 default = nil)
  if valid_580445 != nil:
    section.add "uploadType", valid_580445
  var valid_580446 = query.getOrDefault("key")
  valid_580446 = validateParameter(valid_580446, JString, required = false,
                                 default = nil)
  if valid_580446 != nil:
    section.add "key", valid_580446
  var valid_580447 = query.getOrDefault("$.xgafv")
  valid_580447 = validateParameter(valid_580447, JString, required = false,
                                 default = newJString("1"))
  if valid_580447 != nil:
    section.add "$.xgafv", valid_580447
  var valid_580448 = query.getOrDefault("prettyPrint")
  valid_580448 = validateParameter(valid_580448, JBool, required = false,
                                 default = newJBool(true))
  if valid_580448 != nil:
    section.add "prettyPrint", valid_580448
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

proc call*(call_580450: Call_IamProjectsServiceAccountsTestIamPermissions_580434;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Tests the specified permissions against the IAM access control policy
  ## for a ServiceAccount.
  ## 
  let valid = call_580450.validator(path, query, header, formData, body)
  let scheme = call_580450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580450.url(scheme.get, call_580450.host, call_580450.base,
                         call_580450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580450, url, valid)

proc call*(call_580451: Call_IamProjectsServiceAccountsTestIamPermissions_580434;
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
  var path_580452 = newJObject()
  var query_580453 = newJObject()
  var body_580454 = newJObject()
  add(query_580453, "upload_protocol", newJString(uploadProtocol))
  add(query_580453, "fields", newJString(fields))
  add(query_580453, "quotaUser", newJString(quotaUser))
  add(query_580453, "alt", newJString(alt))
  add(query_580453, "oauth_token", newJString(oauthToken))
  add(query_580453, "callback", newJString(callback))
  add(query_580453, "access_token", newJString(accessToken))
  add(query_580453, "uploadType", newJString(uploadType))
  add(query_580453, "key", newJString(key))
  add(query_580453, "$.xgafv", newJString(Xgafv))
  add(path_580452, "resource", newJString(resource))
  if body != nil:
    body_580454 = body
  add(query_580453, "prettyPrint", newJBool(prettyPrint))
  result = call_580451.call(path_580452, query_580453, nil, nil, body_580454)

var iamProjectsServiceAccountsTestIamPermissions* = Call_IamProjectsServiceAccountsTestIamPermissions_580434(
    name: "iamProjectsServiceAccountsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "iam.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_IamProjectsServiceAccountsTestIamPermissions_580435,
    base: "/", url: url_IamProjectsServiceAccountsTestIamPermissions_580436,
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
