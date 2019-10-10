
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

  OpenApiRestCall_588450 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588450](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588450): Option[Scheme] {.used.} =
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
  Call_IamIamPoliciesLintPolicy_588719 = ref object of OpenApiRestCall_588450
proc url_IamIamPoliciesLintPolicy_588721(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IamIamPoliciesLintPolicy_588720(path: JsonNode; query: JsonNode;
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
  var valid_588833 = query.getOrDefault("upload_protocol")
  valid_588833 = validateParameter(valid_588833, JString, required = false,
                                 default = nil)
  if valid_588833 != nil:
    section.add "upload_protocol", valid_588833
  var valid_588834 = query.getOrDefault("fields")
  valid_588834 = validateParameter(valid_588834, JString, required = false,
                                 default = nil)
  if valid_588834 != nil:
    section.add "fields", valid_588834
  var valid_588835 = query.getOrDefault("quotaUser")
  valid_588835 = validateParameter(valid_588835, JString, required = false,
                                 default = nil)
  if valid_588835 != nil:
    section.add "quotaUser", valid_588835
  var valid_588849 = query.getOrDefault("alt")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = newJString("json"))
  if valid_588849 != nil:
    section.add "alt", valid_588849
  var valid_588850 = query.getOrDefault("oauth_token")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "oauth_token", valid_588850
  var valid_588851 = query.getOrDefault("callback")
  valid_588851 = validateParameter(valid_588851, JString, required = false,
                                 default = nil)
  if valid_588851 != nil:
    section.add "callback", valid_588851
  var valid_588852 = query.getOrDefault("access_token")
  valid_588852 = validateParameter(valid_588852, JString, required = false,
                                 default = nil)
  if valid_588852 != nil:
    section.add "access_token", valid_588852
  var valid_588853 = query.getOrDefault("uploadType")
  valid_588853 = validateParameter(valid_588853, JString, required = false,
                                 default = nil)
  if valid_588853 != nil:
    section.add "uploadType", valid_588853
  var valid_588854 = query.getOrDefault("key")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = nil)
  if valid_588854 != nil:
    section.add "key", valid_588854
  var valid_588855 = query.getOrDefault("$.xgafv")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = newJString("1"))
  if valid_588855 != nil:
    section.add "$.xgafv", valid_588855
  var valid_588856 = query.getOrDefault("prettyPrint")
  valid_588856 = validateParameter(valid_588856, JBool, required = false,
                                 default = newJBool(true))
  if valid_588856 != nil:
    section.add "prettyPrint", valid_588856
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

proc call*(call_588880: Call_IamIamPoliciesLintPolicy_588719; path: JsonNode;
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
  let valid = call_588880.validator(path, query, header, formData, body)
  let scheme = call_588880.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588880.url(scheme.get, call_588880.host, call_588880.base,
                         call_588880.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588880, url, valid)

proc call*(call_588951: Call_IamIamPoliciesLintPolicy_588719;
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
  var query_588952 = newJObject()
  var body_588954 = newJObject()
  add(query_588952, "upload_protocol", newJString(uploadProtocol))
  add(query_588952, "fields", newJString(fields))
  add(query_588952, "quotaUser", newJString(quotaUser))
  add(query_588952, "alt", newJString(alt))
  add(query_588952, "oauth_token", newJString(oauthToken))
  add(query_588952, "callback", newJString(callback))
  add(query_588952, "access_token", newJString(accessToken))
  add(query_588952, "uploadType", newJString(uploadType))
  add(query_588952, "key", newJString(key))
  add(query_588952, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_588954 = body
  add(query_588952, "prettyPrint", newJBool(prettyPrint))
  result = call_588951.call(nil, query_588952, nil, nil, body_588954)

var iamIamPoliciesLintPolicy* = Call_IamIamPoliciesLintPolicy_588719(
    name: "iamIamPoliciesLintPolicy", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/iamPolicies:lintPolicy",
    validator: validate_IamIamPoliciesLintPolicy_588720, base: "/",
    url: url_IamIamPoliciesLintPolicy_588721, schemes: {Scheme.Https})
type
  Call_IamIamPoliciesQueryAuditableServices_588993 = ref object of OpenApiRestCall_588450
proc url_IamIamPoliciesQueryAuditableServices_588995(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IamIamPoliciesQueryAuditableServices_588994(path: JsonNode;
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
  var valid_588996 = query.getOrDefault("upload_protocol")
  valid_588996 = validateParameter(valid_588996, JString, required = false,
                                 default = nil)
  if valid_588996 != nil:
    section.add "upload_protocol", valid_588996
  var valid_588997 = query.getOrDefault("fields")
  valid_588997 = validateParameter(valid_588997, JString, required = false,
                                 default = nil)
  if valid_588997 != nil:
    section.add "fields", valid_588997
  var valid_588998 = query.getOrDefault("quotaUser")
  valid_588998 = validateParameter(valid_588998, JString, required = false,
                                 default = nil)
  if valid_588998 != nil:
    section.add "quotaUser", valid_588998
  var valid_588999 = query.getOrDefault("alt")
  valid_588999 = validateParameter(valid_588999, JString, required = false,
                                 default = newJString("json"))
  if valid_588999 != nil:
    section.add "alt", valid_588999
  var valid_589000 = query.getOrDefault("oauth_token")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = nil)
  if valid_589000 != nil:
    section.add "oauth_token", valid_589000
  var valid_589001 = query.getOrDefault("callback")
  valid_589001 = validateParameter(valid_589001, JString, required = false,
                                 default = nil)
  if valid_589001 != nil:
    section.add "callback", valid_589001
  var valid_589002 = query.getOrDefault("access_token")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "access_token", valid_589002
  var valid_589003 = query.getOrDefault("uploadType")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "uploadType", valid_589003
  var valid_589004 = query.getOrDefault("key")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "key", valid_589004
  var valid_589005 = query.getOrDefault("$.xgafv")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = newJString("1"))
  if valid_589005 != nil:
    section.add "$.xgafv", valid_589005
  var valid_589006 = query.getOrDefault("prettyPrint")
  valid_589006 = validateParameter(valid_589006, JBool, required = false,
                                 default = newJBool(true))
  if valid_589006 != nil:
    section.add "prettyPrint", valid_589006
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

proc call*(call_589008: Call_IamIamPoliciesQueryAuditableServices_588993;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of services that support service level audit logging
  ## configuration for the given resource.
  ## 
  let valid = call_589008.validator(path, query, header, formData, body)
  let scheme = call_589008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589008.url(scheme.get, call_589008.host, call_589008.base,
                         call_589008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589008, url, valid)

proc call*(call_589009: Call_IamIamPoliciesQueryAuditableServices_588993;
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
  var query_589010 = newJObject()
  var body_589011 = newJObject()
  add(query_589010, "upload_protocol", newJString(uploadProtocol))
  add(query_589010, "fields", newJString(fields))
  add(query_589010, "quotaUser", newJString(quotaUser))
  add(query_589010, "alt", newJString(alt))
  add(query_589010, "oauth_token", newJString(oauthToken))
  add(query_589010, "callback", newJString(callback))
  add(query_589010, "access_token", newJString(accessToken))
  add(query_589010, "uploadType", newJString(uploadType))
  add(query_589010, "key", newJString(key))
  add(query_589010, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589011 = body
  add(query_589010, "prettyPrint", newJBool(prettyPrint))
  result = call_589009.call(nil, query_589010, nil, nil, body_589011)

var iamIamPoliciesQueryAuditableServices* = Call_IamIamPoliciesQueryAuditableServices_588993(
    name: "iamIamPoliciesQueryAuditableServices", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/iamPolicies:queryAuditableServices",
    validator: validate_IamIamPoliciesQueryAuditableServices_588994, base: "/",
    url: url_IamIamPoliciesQueryAuditableServices_588995, schemes: {Scheme.Https})
type
  Call_IamPermissionsQueryTestablePermissions_589012 = ref object of OpenApiRestCall_588450
proc url_IamPermissionsQueryTestablePermissions_589014(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IamPermissionsQueryTestablePermissions_589013(path: JsonNode;
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
  var valid_589015 = query.getOrDefault("upload_protocol")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "upload_protocol", valid_589015
  var valid_589016 = query.getOrDefault("fields")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "fields", valid_589016
  var valid_589017 = query.getOrDefault("quotaUser")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "quotaUser", valid_589017
  var valid_589018 = query.getOrDefault("alt")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = newJString("json"))
  if valid_589018 != nil:
    section.add "alt", valid_589018
  var valid_589019 = query.getOrDefault("oauth_token")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "oauth_token", valid_589019
  var valid_589020 = query.getOrDefault("callback")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "callback", valid_589020
  var valid_589021 = query.getOrDefault("access_token")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "access_token", valid_589021
  var valid_589022 = query.getOrDefault("uploadType")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "uploadType", valid_589022
  var valid_589023 = query.getOrDefault("key")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "key", valid_589023
  var valid_589024 = query.getOrDefault("$.xgafv")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = newJString("1"))
  if valid_589024 != nil:
    section.add "$.xgafv", valid_589024
  var valid_589025 = query.getOrDefault("prettyPrint")
  valid_589025 = validateParameter(valid_589025, JBool, required = false,
                                 default = newJBool(true))
  if valid_589025 != nil:
    section.add "prettyPrint", valid_589025
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

proc call*(call_589027: Call_IamPermissionsQueryTestablePermissions_589012;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the permissions testable on a resource.
  ## A permission is testable if it can be tested for an identity on a resource.
  ## 
  let valid = call_589027.validator(path, query, header, formData, body)
  let scheme = call_589027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589027.url(scheme.get, call_589027.host, call_589027.base,
                         call_589027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589027, url, valid)

proc call*(call_589028: Call_IamPermissionsQueryTestablePermissions_589012;
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
  var query_589029 = newJObject()
  var body_589030 = newJObject()
  add(query_589029, "upload_protocol", newJString(uploadProtocol))
  add(query_589029, "fields", newJString(fields))
  add(query_589029, "quotaUser", newJString(quotaUser))
  add(query_589029, "alt", newJString(alt))
  add(query_589029, "oauth_token", newJString(oauthToken))
  add(query_589029, "callback", newJString(callback))
  add(query_589029, "access_token", newJString(accessToken))
  add(query_589029, "uploadType", newJString(uploadType))
  add(query_589029, "key", newJString(key))
  add(query_589029, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589030 = body
  add(query_589029, "prettyPrint", newJBool(prettyPrint))
  result = call_589028.call(nil, query_589029, nil, nil, body_589030)

var iamPermissionsQueryTestablePermissions* = Call_IamPermissionsQueryTestablePermissions_589012(
    name: "iamPermissionsQueryTestablePermissions", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/permissions:queryTestablePermissions",
    validator: validate_IamPermissionsQueryTestablePermissions_589013, base: "/",
    url: url_IamPermissionsQueryTestablePermissions_589014,
    schemes: {Scheme.Https})
type
  Call_IamRolesList_589031 = ref object of OpenApiRestCall_588450
proc url_IamRolesList_589033(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IamRolesList_589032(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_589034 = query.getOrDefault("upload_protocol")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "upload_protocol", valid_589034
  var valid_589035 = query.getOrDefault("fields")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "fields", valid_589035
  var valid_589036 = query.getOrDefault("pageToken")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "pageToken", valid_589036
  var valid_589037 = query.getOrDefault("quotaUser")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "quotaUser", valid_589037
  var valid_589038 = query.getOrDefault("view")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_589038 != nil:
    section.add "view", valid_589038
  var valid_589039 = query.getOrDefault("alt")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = newJString("json"))
  if valid_589039 != nil:
    section.add "alt", valid_589039
  var valid_589040 = query.getOrDefault("oauth_token")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "oauth_token", valid_589040
  var valid_589041 = query.getOrDefault("callback")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "callback", valid_589041
  var valid_589042 = query.getOrDefault("access_token")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "access_token", valid_589042
  var valid_589043 = query.getOrDefault("uploadType")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "uploadType", valid_589043
  var valid_589044 = query.getOrDefault("parent")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "parent", valid_589044
  var valid_589045 = query.getOrDefault("showDeleted")
  valid_589045 = validateParameter(valid_589045, JBool, required = false, default = nil)
  if valid_589045 != nil:
    section.add "showDeleted", valid_589045
  var valid_589046 = query.getOrDefault("key")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "key", valid_589046
  var valid_589047 = query.getOrDefault("$.xgafv")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = newJString("1"))
  if valid_589047 != nil:
    section.add "$.xgafv", valid_589047
  var valid_589048 = query.getOrDefault("pageSize")
  valid_589048 = validateParameter(valid_589048, JInt, required = false, default = nil)
  if valid_589048 != nil:
    section.add "pageSize", valid_589048
  var valid_589049 = query.getOrDefault("prettyPrint")
  valid_589049 = validateParameter(valid_589049, JBool, required = false,
                                 default = newJBool(true))
  if valid_589049 != nil:
    section.add "prettyPrint", valid_589049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589050: Call_IamRolesList_589031; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Roles defined on a resource.
  ## 
  let valid = call_589050.validator(path, query, header, formData, body)
  let scheme = call_589050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589050.url(scheme.get, call_589050.host, call_589050.base,
                         call_589050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589050, url, valid)

proc call*(call_589051: Call_IamRolesList_589031; uploadProtocol: string = "";
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
  var query_589052 = newJObject()
  add(query_589052, "upload_protocol", newJString(uploadProtocol))
  add(query_589052, "fields", newJString(fields))
  add(query_589052, "pageToken", newJString(pageToken))
  add(query_589052, "quotaUser", newJString(quotaUser))
  add(query_589052, "view", newJString(view))
  add(query_589052, "alt", newJString(alt))
  add(query_589052, "oauth_token", newJString(oauthToken))
  add(query_589052, "callback", newJString(callback))
  add(query_589052, "access_token", newJString(accessToken))
  add(query_589052, "uploadType", newJString(uploadType))
  add(query_589052, "parent", newJString(parent))
  add(query_589052, "showDeleted", newJBool(showDeleted))
  add(query_589052, "key", newJString(key))
  add(query_589052, "$.xgafv", newJString(Xgafv))
  add(query_589052, "pageSize", newJInt(pageSize))
  add(query_589052, "prettyPrint", newJBool(prettyPrint))
  result = call_589051.call(nil, query_589052, nil, nil, nil)

var iamRolesList* = Call_IamRolesList_589031(name: "iamRolesList",
    meth: HttpMethod.HttpGet, host: "iam.googleapis.com", route: "/v1/roles",
    validator: validate_IamRolesList_589032, base: "/", url: url_IamRolesList_589033,
    schemes: {Scheme.Https})
type
  Call_IamRolesQueryGrantableRoles_589053 = ref object of OpenApiRestCall_588450
proc url_IamRolesQueryGrantableRoles_589055(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_IamRolesQueryGrantableRoles_589054(path: JsonNode; query: JsonNode;
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
  var valid_589056 = query.getOrDefault("upload_protocol")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "upload_protocol", valid_589056
  var valid_589057 = query.getOrDefault("fields")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "fields", valid_589057
  var valid_589058 = query.getOrDefault("quotaUser")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "quotaUser", valid_589058
  var valid_589059 = query.getOrDefault("alt")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = newJString("json"))
  if valid_589059 != nil:
    section.add "alt", valid_589059
  var valid_589060 = query.getOrDefault("oauth_token")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "oauth_token", valid_589060
  var valid_589061 = query.getOrDefault("callback")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "callback", valid_589061
  var valid_589062 = query.getOrDefault("access_token")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "access_token", valid_589062
  var valid_589063 = query.getOrDefault("uploadType")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "uploadType", valid_589063
  var valid_589064 = query.getOrDefault("key")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "key", valid_589064
  var valid_589065 = query.getOrDefault("$.xgafv")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = newJString("1"))
  if valid_589065 != nil:
    section.add "$.xgafv", valid_589065
  var valid_589066 = query.getOrDefault("prettyPrint")
  valid_589066 = validateParameter(valid_589066, JBool, required = false,
                                 default = newJBool(true))
  if valid_589066 != nil:
    section.add "prettyPrint", valid_589066
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

proc call*(call_589068: Call_IamRolesQueryGrantableRoles_589053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Queries roles that can be granted on a particular resource.
  ## A role is grantable if it can be used as the role in a binding for a policy
  ## for that resource.
  ## 
  let valid = call_589068.validator(path, query, header, formData, body)
  let scheme = call_589068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589068.url(scheme.get, call_589068.host, call_589068.base,
                         call_589068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589068, url, valid)

proc call*(call_589069: Call_IamRolesQueryGrantableRoles_589053;
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
  var query_589070 = newJObject()
  var body_589071 = newJObject()
  add(query_589070, "upload_protocol", newJString(uploadProtocol))
  add(query_589070, "fields", newJString(fields))
  add(query_589070, "quotaUser", newJString(quotaUser))
  add(query_589070, "alt", newJString(alt))
  add(query_589070, "oauth_token", newJString(oauthToken))
  add(query_589070, "callback", newJString(callback))
  add(query_589070, "access_token", newJString(accessToken))
  add(query_589070, "uploadType", newJString(uploadType))
  add(query_589070, "key", newJString(key))
  add(query_589070, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589071 = body
  add(query_589070, "prettyPrint", newJBool(prettyPrint))
  result = call_589069.call(nil, query_589070, nil, nil, body_589071)

var iamRolesQueryGrantableRoles* = Call_IamRolesQueryGrantableRoles_589053(
    name: "iamRolesQueryGrantableRoles", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/roles:queryGrantableRoles",
    validator: validate_IamRolesQueryGrantableRoles_589054, base: "/",
    url: url_IamRolesQueryGrantableRoles_589055, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsUpdate_589106 = ref object of OpenApiRestCall_588450
proc url_IamProjectsServiceAccountsUpdate_589108(protocol: Scheme; host: string;
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

proc validate_IamProjectsServiceAccountsUpdate_589107(path: JsonNode;
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
  var valid_589109 = path.getOrDefault("name")
  valid_589109 = validateParameter(valid_589109, JString, required = true,
                                 default = nil)
  if valid_589109 != nil:
    section.add "name", valid_589109
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
  var valid_589110 = query.getOrDefault("upload_protocol")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "upload_protocol", valid_589110
  var valid_589111 = query.getOrDefault("fields")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "fields", valid_589111
  var valid_589112 = query.getOrDefault("quotaUser")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "quotaUser", valid_589112
  var valid_589113 = query.getOrDefault("alt")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = newJString("json"))
  if valid_589113 != nil:
    section.add "alt", valid_589113
  var valid_589114 = query.getOrDefault("oauth_token")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "oauth_token", valid_589114
  var valid_589115 = query.getOrDefault("callback")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "callback", valid_589115
  var valid_589116 = query.getOrDefault("access_token")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "access_token", valid_589116
  var valid_589117 = query.getOrDefault("uploadType")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "uploadType", valid_589117
  var valid_589118 = query.getOrDefault("key")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "key", valid_589118
  var valid_589119 = query.getOrDefault("$.xgafv")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = newJString("1"))
  if valid_589119 != nil:
    section.add "$.xgafv", valid_589119
  var valid_589120 = query.getOrDefault("prettyPrint")
  valid_589120 = validateParameter(valid_589120, JBool, required = false,
                                 default = newJBool(true))
  if valid_589120 != nil:
    section.add "prettyPrint", valid_589120
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

proc call*(call_589122: Call_IamProjectsServiceAccountsUpdate_589106;
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
  let valid = call_589122.validator(path, query, header, formData, body)
  let scheme = call_589122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589122.url(scheme.get, call_589122.host, call_589122.base,
                         call_589122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589122, url, valid)

proc call*(call_589123: Call_IamProjectsServiceAccountsUpdate_589106; name: string;
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
  var path_589124 = newJObject()
  var query_589125 = newJObject()
  var body_589126 = newJObject()
  add(query_589125, "upload_protocol", newJString(uploadProtocol))
  add(query_589125, "fields", newJString(fields))
  add(query_589125, "quotaUser", newJString(quotaUser))
  add(path_589124, "name", newJString(name))
  add(query_589125, "alt", newJString(alt))
  add(query_589125, "oauth_token", newJString(oauthToken))
  add(query_589125, "callback", newJString(callback))
  add(query_589125, "access_token", newJString(accessToken))
  add(query_589125, "uploadType", newJString(uploadType))
  add(query_589125, "key", newJString(key))
  add(query_589125, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589126 = body
  add(query_589125, "prettyPrint", newJBool(prettyPrint))
  result = call_589123.call(path_589124, query_589125, nil, nil, body_589126)

var iamProjectsServiceAccountsUpdate* = Call_IamProjectsServiceAccountsUpdate_589106(
    name: "iamProjectsServiceAccountsUpdate", meth: HttpMethod.HttpPut,
    host: "iam.googleapis.com", route: "/v1/{name}",
    validator: validate_IamProjectsServiceAccountsUpdate_589107, base: "/",
    url: url_IamProjectsServiceAccountsUpdate_589108, schemes: {Scheme.Https})
type
  Call_IamRolesGet_589072 = ref object of OpenApiRestCall_588450
proc url_IamRolesGet_589074(protocol: Scheme; host: string; base: string;
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

proc validate_IamRolesGet_589073(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_589089 = path.getOrDefault("name")
  valid_589089 = validateParameter(valid_589089, JString, required = true,
                                 default = nil)
  if valid_589089 != nil:
    section.add "name", valid_589089
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
  var valid_589090 = query.getOrDefault("upload_protocol")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "upload_protocol", valid_589090
  var valid_589091 = query.getOrDefault("fields")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "fields", valid_589091
  var valid_589092 = query.getOrDefault("quotaUser")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "quotaUser", valid_589092
  var valid_589093 = query.getOrDefault("alt")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = newJString("json"))
  if valid_589093 != nil:
    section.add "alt", valid_589093
  var valid_589094 = query.getOrDefault("oauth_token")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "oauth_token", valid_589094
  var valid_589095 = query.getOrDefault("callback")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "callback", valid_589095
  var valid_589096 = query.getOrDefault("access_token")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "access_token", valid_589096
  var valid_589097 = query.getOrDefault("uploadType")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "uploadType", valid_589097
  var valid_589098 = query.getOrDefault("publicKeyType")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = newJString("TYPE_NONE"))
  if valid_589098 != nil:
    section.add "publicKeyType", valid_589098
  var valid_589099 = query.getOrDefault("key")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "key", valid_589099
  var valid_589100 = query.getOrDefault("$.xgafv")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = newJString("1"))
  if valid_589100 != nil:
    section.add "$.xgafv", valid_589100
  var valid_589101 = query.getOrDefault("prettyPrint")
  valid_589101 = validateParameter(valid_589101, JBool, required = false,
                                 default = newJBool(true))
  if valid_589101 != nil:
    section.add "prettyPrint", valid_589101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589102: Call_IamRolesGet_589072; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Role definition.
  ## 
  let valid = call_589102.validator(path, query, header, formData, body)
  let scheme = call_589102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589102.url(scheme.get, call_589102.host, call_589102.base,
                         call_589102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589102, url, valid)

proc call*(call_589103: Call_IamRolesGet_589072; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          publicKeyType: string = "TYPE_NONE"; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## iamRolesGet
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
  var path_589104 = newJObject()
  var query_589105 = newJObject()
  add(query_589105, "upload_protocol", newJString(uploadProtocol))
  add(query_589105, "fields", newJString(fields))
  add(query_589105, "quotaUser", newJString(quotaUser))
  add(path_589104, "name", newJString(name))
  add(query_589105, "alt", newJString(alt))
  add(query_589105, "oauth_token", newJString(oauthToken))
  add(query_589105, "callback", newJString(callback))
  add(query_589105, "access_token", newJString(accessToken))
  add(query_589105, "uploadType", newJString(uploadType))
  add(query_589105, "publicKeyType", newJString(publicKeyType))
  add(query_589105, "key", newJString(key))
  add(query_589105, "$.xgafv", newJString(Xgafv))
  add(query_589105, "prettyPrint", newJBool(prettyPrint))
  result = call_589103.call(path_589104, query_589105, nil, nil, nil)

var iamRolesGet* = Call_IamRolesGet_589072(name: "iamRolesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "iam.googleapis.com",
                                        route: "/v1/{name}",
                                        validator: validate_IamRolesGet_589073,
                                        base: "/", url: url_IamRolesGet_589074,
                                        schemes: {Scheme.Https})
type
  Call_IamProjectsRolesPatch_589147 = ref object of OpenApiRestCall_588450
proc url_IamProjectsRolesPatch_589149(protocol: Scheme; host: string; base: string;
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

proc validate_IamProjectsRolesPatch_589148(path: JsonNode; query: JsonNode;
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
  var valid_589150 = path.getOrDefault("name")
  valid_589150 = validateParameter(valid_589150, JString, required = true,
                                 default = nil)
  if valid_589150 != nil:
    section.add "name", valid_589150
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
  var valid_589151 = query.getOrDefault("upload_protocol")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "upload_protocol", valid_589151
  var valid_589152 = query.getOrDefault("fields")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "fields", valid_589152
  var valid_589153 = query.getOrDefault("quotaUser")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "quotaUser", valid_589153
  var valid_589154 = query.getOrDefault("alt")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = newJString("json"))
  if valid_589154 != nil:
    section.add "alt", valid_589154
  var valid_589155 = query.getOrDefault("oauth_token")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "oauth_token", valid_589155
  var valid_589156 = query.getOrDefault("callback")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "callback", valid_589156
  var valid_589157 = query.getOrDefault("access_token")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "access_token", valid_589157
  var valid_589158 = query.getOrDefault("uploadType")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "uploadType", valid_589158
  var valid_589159 = query.getOrDefault("key")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "key", valid_589159
  var valid_589160 = query.getOrDefault("$.xgafv")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = newJString("1"))
  if valid_589160 != nil:
    section.add "$.xgafv", valid_589160
  var valid_589161 = query.getOrDefault("prettyPrint")
  valid_589161 = validateParameter(valid_589161, JBool, required = false,
                                 default = newJBool(true))
  if valid_589161 != nil:
    section.add "prettyPrint", valid_589161
  var valid_589162 = query.getOrDefault("updateMask")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "updateMask", valid_589162
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

proc call*(call_589164: Call_IamProjectsRolesPatch_589147; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Role definition.
  ## 
  let valid = call_589164.validator(path, query, header, formData, body)
  let scheme = call_589164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589164.url(scheme.get, call_589164.host, call_589164.base,
                         call_589164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589164, url, valid)

proc call*(call_589165: Call_IamProjectsRolesPatch_589147; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          updateMask: string = ""): Recallable =
  ## iamProjectsRolesPatch
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
  var path_589166 = newJObject()
  var query_589167 = newJObject()
  var body_589168 = newJObject()
  add(query_589167, "upload_protocol", newJString(uploadProtocol))
  add(query_589167, "fields", newJString(fields))
  add(query_589167, "quotaUser", newJString(quotaUser))
  add(path_589166, "name", newJString(name))
  add(query_589167, "alt", newJString(alt))
  add(query_589167, "oauth_token", newJString(oauthToken))
  add(query_589167, "callback", newJString(callback))
  add(query_589167, "access_token", newJString(accessToken))
  add(query_589167, "uploadType", newJString(uploadType))
  add(query_589167, "key", newJString(key))
  add(query_589167, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589168 = body
  add(query_589167, "prettyPrint", newJBool(prettyPrint))
  add(query_589167, "updateMask", newJString(updateMask))
  result = call_589165.call(path_589166, query_589167, nil, nil, body_589168)

var iamProjectsRolesPatch* = Call_IamProjectsRolesPatch_589147(
    name: "iamProjectsRolesPatch", meth: HttpMethod.HttpPatch,
    host: "iam.googleapis.com", route: "/v1/{name}",
    validator: validate_IamProjectsRolesPatch_589148, base: "/",
    url: url_IamProjectsRolesPatch_589149, schemes: {Scheme.Https})
type
  Call_IamProjectsRolesDelete_589127 = ref object of OpenApiRestCall_588450
proc url_IamProjectsRolesDelete_589129(protocol: Scheme; host: string; base: string;
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

proc validate_IamProjectsRolesDelete_589128(path: JsonNode; query: JsonNode;
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
  var valid_589130 = path.getOrDefault("name")
  valid_589130 = validateParameter(valid_589130, JString, required = true,
                                 default = nil)
  if valid_589130 != nil:
    section.add "name", valid_589130
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
  var valid_589131 = query.getOrDefault("upload_protocol")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "upload_protocol", valid_589131
  var valid_589132 = query.getOrDefault("fields")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "fields", valid_589132
  var valid_589133 = query.getOrDefault("quotaUser")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "quotaUser", valid_589133
  var valid_589134 = query.getOrDefault("alt")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = newJString("json"))
  if valid_589134 != nil:
    section.add "alt", valid_589134
  var valid_589135 = query.getOrDefault("oauth_token")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "oauth_token", valid_589135
  var valid_589136 = query.getOrDefault("callback")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "callback", valid_589136
  var valid_589137 = query.getOrDefault("access_token")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "access_token", valid_589137
  var valid_589138 = query.getOrDefault("uploadType")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "uploadType", valid_589138
  var valid_589139 = query.getOrDefault("key")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "key", valid_589139
  var valid_589140 = query.getOrDefault("$.xgafv")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = newJString("1"))
  if valid_589140 != nil:
    section.add "$.xgafv", valid_589140
  var valid_589141 = query.getOrDefault("prettyPrint")
  valid_589141 = validateParameter(valid_589141, JBool, required = false,
                                 default = newJBool(true))
  if valid_589141 != nil:
    section.add "prettyPrint", valid_589141
  var valid_589142 = query.getOrDefault("etag")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "etag", valid_589142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589143: Call_IamProjectsRolesDelete_589127; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Soft deletes a role. The role is suspended and cannot be used to create new
  ## IAM Policy Bindings.
  ## The Role will not be included in `ListRoles()` unless `show_deleted` is set
  ## in the `ListRolesRequest`. The Role contains the deleted boolean set.
  ## Existing Bindings remains, but are inactive. The Role can be undeleted
  ## within 7 days. After 7 days the Role is deleted and all Bindings associated
  ## with the role are removed.
  ## 
  let valid = call_589143.validator(path, query, header, formData, body)
  let scheme = call_589143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589143.url(scheme.get, call_589143.host, call_589143.base,
                         call_589143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589143, url, valid)

proc call*(call_589144: Call_IamProjectsRolesDelete_589127; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true; etag: string = ""): Recallable =
  ## iamProjectsRolesDelete
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
  var path_589145 = newJObject()
  var query_589146 = newJObject()
  add(query_589146, "upload_protocol", newJString(uploadProtocol))
  add(query_589146, "fields", newJString(fields))
  add(query_589146, "quotaUser", newJString(quotaUser))
  add(path_589145, "name", newJString(name))
  add(query_589146, "alt", newJString(alt))
  add(query_589146, "oauth_token", newJString(oauthToken))
  add(query_589146, "callback", newJString(callback))
  add(query_589146, "access_token", newJString(accessToken))
  add(query_589146, "uploadType", newJString(uploadType))
  add(query_589146, "key", newJString(key))
  add(query_589146, "$.xgafv", newJString(Xgafv))
  add(query_589146, "prettyPrint", newJBool(prettyPrint))
  add(query_589146, "etag", newJString(etag))
  result = call_589144.call(path_589145, query_589146, nil, nil, nil)

var iamProjectsRolesDelete* = Call_IamProjectsRolesDelete_589127(
    name: "iamProjectsRolesDelete", meth: HttpMethod.HttpDelete,
    host: "iam.googleapis.com", route: "/v1/{name}",
    validator: validate_IamProjectsRolesDelete_589128, base: "/",
    url: url_IamProjectsRolesDelete_589129, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsKeysCreate_589189 = ref object of OpenApiRestCall_588450
proc url_IamProjectsServiceAccountsKeysCreate_589191(protocol: Scheme;
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

proc validate_IamProjectsServiceAccountsKeysCreate_589190(path: JsonNode;
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
  var valid_589192 = path.getOrDefault("name")
  valid_589192 = validateParameter(valid_589192, JString, required = true,
                                 default = nil)
  if valid_589192 != nil:
    section.add "name", valid_589192
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
  var valid_589193 = query.getOrDefault("upload_protocol")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "upload_protocol", valid_589193
  var valid_589194 = query.getOrDefault("fields")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "fields", valid_589194
  var valid_589195 = query.getOrDefault("quotaUser")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "quotaUser", valid_589195
  var valid_589196 = query.getOrDefault("alt")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = newJString("json"))
  if valid_589196 != nil:
    section.add "alt", valid_589196
  var valid_589197 = query.getOrDefault("oauth_token")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "oauth_token", valid_589197
  var valid_589198 = query.getOrDefault("callback")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "callback", valid_589198
  var valid_589199 = query.getOrDefault("access_token")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "access_token", valid_589199
  var valid_589200 = query.getOrDefault("uploadType")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "uploadType", valid_589200
  var valid_589201 = query.getOrDefault("key")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "key", valid_589201
  var valid_589202 = query.getOrDefault("$.xgafv")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = newJString("1"))
  if valid_589202 != nil:
    section.add "$.xgafv", valid_589202
  var valid_589203 = query.getOrDefault("prettyPrint")
  valid_589203 = validateParameter(valid_589203, JBool, required = false,
                                 default = newJBool(true))
  if valid_589203 != nil:
    section.add "prettyPrint", valid_589203
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

proc call*(call_589205: Call_IamProjectsServiceAccountsKeysCreate_589189;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a ServiceAccountKey
  ## and returns it.
  ## 
  let valid = call_589205.validator(path, query, header, formData, body)
  let scheme = call_589205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589205.url(scheme.get, call_589205.host, call_589205.base,
                         call_589205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589205, url, valid)

proc call*(call_589206: Call_IamProjectsServiceAccountsKeysCreate_589189;
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
  var path_589207 = newJObject()
  var query_589208 = newJObject()
  var body_589209 = newJObject()
  add(query_589208, "upload_protocol", newJString(uploadProtocol))
  add(query_589208, "fields", newJString(fields))
  add(query_589208, "quotaUser", newJString(quotaUser))
  add(path_589207, "name", newJString(name))
  add(query_589208, "alt", newJString(alt))
  add(query_589208, "oauth_token", newJString(oauthToken))
  add(query_589208, "callback", newJString(callback))
  add(query_589208, "access_token", newJString(accessToken))
  add(query_589208, "uploadType", newJString(uploadType))
  add(query_589208, "key", newJString(key))
  add(query_589208, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589209 = body
  add(query_589208, "prettyPrint", newJBool(prettyPrint))
  result = call_589206.call(path_589207, query_589208, nil, nil, body_589209)

var iamProjectsServiceAccountsKeysCreate* = Call_IamProjectsServiceAccountsKeysCreate_589189(
    name: "iamProjectsServiceAccountsKeysCreate", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}/keys",
    validator: validate_IamProjectsServiceAccountsKeysCreate_589190, base: "/",
    url: url_IamProjectsServiceAccountsKeysCreate_589191, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsKeysList_589169 = ref object of OpenApiRestCall_588450
proc url_IamProjectsServiceAccountsKeysList_589171(protocol: Scheme; host: string;
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

proc validate_IamProjectsServiceAccountsKeysList_589170(path: JsonNode;
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
  var valid_589172 = path.getOrDefault("name")
  valid_589172 = validateParameter(valid_589172, JString, required = true,
                                 default = nil)
  if valid_589172 != nil:
    section.add "name", valid_589172
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
  var valid_589173 = query.getOrDefault("upload_protocol")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "upload_protocol", valid_589173
  var valid_589174 = query.getOrDefault("fields")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "fields", valid_589174
  var valid_589175 = query.getOrDefault("quotaUser")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "quotaUser", valid_589175
  var valid_589176 = query.getOrDefault("keyTypes")
  valid_589176 = validateParameter(valid_589176, JArray, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "keyTypes", valid_589176
  var valid_589177 = query.getOrDefault("alt")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = newJString("json"))
  if valid_589177 != nil:
    section.add "alt", valid_589177
  var valid_589178 = query.getOrDefault("oauth_token")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "oauth_token", valid_589178
  var valid_589179 = query.getOrDefault("callback")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "callback", valid_589179
  var valid_589180 = query.getOrDefault("access_token")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "access_token", valid_589180
  var valid_589181 = query.getOrDefault("uploadType")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "uploadType", valid_589181
  var valid_589182 = query.getOrDefault("key")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "key", valid_589182
  var valid_589183 = query.getOrDefault("$.xgafv")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = newJString("1"))
  if valid_589183 != nil:
    section.add "$.xgafv", valid_589183
  var valid_589184 = query.getOrDefault("prettyPrint")
  valid_589184 = validateParameter(valid_589184, JBool, required = false,
                                 default = newJBool(true))
  if valid_589184 != nil:
    section.add "prettyPrint", valid_589184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589185: Call_IamProjectsServiceAccountsKeysList_589169;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists ServiceAccountKeys.
  ## 
  let valid = call_589185.validator(path, query, header, formData, body)
  let scheme = call_589185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589185.url(scheme.get, call_589185.host, call_589185.base,
                         call_589185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589185, url, valid)

proc call*(call_589186: Call_IamProjectsServiceAccountsKeysList_589169;
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
  var path_589187 = newJObject()
  var query_589188 = newJObject()
  add(query_589188, "upload_protocol", newJString(uploadProtocol))
  add(query_589188, "fields", newJString(fields))
  add(query_589188, "quotaUser", newJString(quotaUser))
  if keyTypes != nil:
    query_589188.add "keyTypes", keyTypes
  add(path_589187, "name", newJString(name))
  add(query_589188, "alt", newJString(alt))
  add(query_589188, "oauth_token", newJString(oauthToken))
  add(query_589188, "callback", newJString(callback))
  add(query_589188, "access_token", newJString(accessToken))
  add(query_589188, "uploadType", newJString(uploadType))
  add(query_589188, "key", newJString(key))
  add(query_589188, "$.xgafv", newJString(Xgafv))
  add(query_589188, "prettyPrint", newJBool(prettyPrint))
  result = call_589186.call(path_589187, query_589188, nil, nil, nil)

var iamProjectsServiceAccountsKeysList* = Call_IamProjectsServiceAccountsKeysList_589169(
    name: "iamProjectsServiceAccountsKeysList", meth: HttpMethod.HttpGet,
    host: "iam.googleapis.com", route: "/v1/{name}/keys",
    validator: validate_IamProjectsServiceAccountsKeysList_589170, base: "/",
    url: url_IamProjectsServiceAccountsKeysList_589171, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsKeysUpload_589210 = ref object of OpenApiRestCall_588450
proc url_IamProjectsServiceAccountsKeysUpload_589212(protocol: Scheme;
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

proc validate_IamProjectsServiceAccountsKeysUpload_589211(path: JsonNode;
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
  var valid_589213 = path.getOrDefault("name")
  valid_589213 = validateParameter(valid_589213, JString, required = true,
                                 default = nil)
  if valid_589213 != nil:
    section.add "name", valid_589213
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
  var valid_589214 = query.getOrDefault("upload_protocol")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "upload_protocol", valid_589214
  var valid_589215 = query.getOrDefault("fields")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "fields", valid_589215
  var valid_589216 = query.getOrDefault("quotaUser")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "quotaUser", valid_589216
  var valid_589217 = query.getOrDefault("alt")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = newJString("json"))
  if valid_589217 != nil:
    section.add "alt", valid_589217
  var valid_589218 = query.getOrDefault("oauth_token")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "oauth_token", valid_589218
  var valid_589219 = query.getOrDefault("callback")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "callback", valid_589219
  var valid_589220 = query.getOrDefault("access_token")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "access_token", valid_589220
  var valid_589221 = query.getOrDefault("uploadType")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "uploadType", valid_589221
  var valid_589222 = query.getOrDefault("key")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "key", valid_589222
  var valid_589223 = query.getOrDefault("$.xgafv")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = newJString("1"))
  if valid_589223 != nil:
    section.add "$.xgafv", valid_589223
  var valid_589224 = query.getOrDefault("prettyPrint")
  valid_589224 = validateParameter(valid_589224, JBool, required = false,
                                 default = newJBool(true))
  if valid_589224 != nil:
    section.add "prettyPrint", valid_589224
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

proc call*(call_589226: Call_IamProjectsServiceAccountsKeysUpload_589210;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Upload public key for a given service account.
  ## This rpc will create a
  ## ServiceAccountKey that has the
  ## provided public key and returns it.
  ## 
  let valid = call_589226.validator(path, query, header, formData, body)
  let scheme = call_589226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589226.url(scheme.get, call_589226.host, call_589226.base,
                         call_589226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589226, url, valid)

proc call*(call_589227: Call_IamProjectsServiceAccountsKeysUpload_589210;
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
  var path_589228 = newJObject()
  var query_589229 = newJObject()
  var body_589230 = newJObject()
  add(query_589229, "upload_protocol", newJString(uploadProtocol))
  add(query_589229, "fields", newJString(fields))
  add(query_589229, "quotaUser", newJString(quotaUser))
  add(path_589228, "name", newJString(name))
  add(query_589229, "alt", newJString(alt))
  add(query_589229, "oauth_token", newJString(oauthToken))
  add(query_589229, "callback", newJString(callback))
  add(query_589229, "access_token", newJString(accessToken))
  add(query_589229, "uploadType", newJString(uploadType))
  add(query_589229, "key", newJString(key))
  add(query_589229, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589230 = body
  add(query_589229, "prettyPrint", newJBool(prettyPrint))
  result = call_589227.call(path_589228, query_589229, nil, nil, body_589230)

var iamProjectsServiceAccountsKeysUpload* = Call_IamProjectsServiceAccountsKeysUpload_589210(
    name: "iamProjectsServiceAccountsKeysUpload", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}/keys:upload",
    validator: validate_IamProjectsServiceAccountsKeysUpload_589211, base: "/",
    url: url_IamProjectsServiceAccountsKeysUpload_589212, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsCreate_589252 = ref object of OpenApiRestCall_588450
proc url_IamProjectsServiceAccountsCreate_589254(protocol: Scheme; host: string;
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

proc validate_IamProjectsServiceAccountsCreate_589253(path: JsonNode;
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
  var valid_589255 = path.getOrDefault("name")
  valid_589255 = validateParameter(valid_589255, JString, required = true,
                                 default = nil)
  if valid_589255 != nil:
    section.add "name", valid_589255
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
  var valid_589256 = query.getOrDefault("upload_protocol")
  valid_589256 = validateParameter(valid_589256, JString, required = false,
                                 default = nil)
  if valid_589256 != nil:
    section.add "upload_protocol", valid_589256
  var valid_589257 = query.getOrDefault("fields")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = nil)
  if valid_589257 != nil:
    section.add "fields", valid_589257
  var valid_589258 = query.getOrDefault("quotaUser")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "quotaUser", valid_589258
  var valid_589259 = query.getOrDefault("alt")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = newJString("json"))
  if valid_589259 != nil:
    section.add "alt", valid_589259
  var valid_589260 = query.getOrDefault("oauth_token")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = nil)
  if valid_589260 != nil:
    section.add "oauth_token", valid_589260
  var valid_589261 = query.getOrDefault("callback")
  valid_589261 = validateParameter(valid_589261, JString, required = false,
                                 default = nil)
  if valid_589261 != nil:
    section.add "callback", valid_589261
  var valid_589262 = query.getOrDefault("access_token")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = nil)
  if valid_589262 != nil:
    section.add "access_token", valid_589262
  var valid_589263 = query.getOrDefault("uploadType")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = nil)
  if valid_589263 != nil:
    section.add "uploadType", valid_589263
  var valid_589264 = query.getOrDefault("key")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "key", valid_589264
  var valid_589265 = query.getOrDefault("$.xgafv")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = newJString("1"))
  if valid_589265 != nil:
    section.add "$.xgafv", valid_589265
  var valid_589266 = query.getOrDefault("prettyPrint")
  valid_589266 = validateParameter(valid_589266, JBool, required = false,
                                 default = newJBool(true))
  if valid_589266 != nil:
    section.add "prettyPrint", valid_589266
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

proc call*(call_589268: Call_IamProjectsServiceAccountsCreate_589252;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a ServiceAccount
  ## and returns it.
  ## 
  let valid = call_589268.validator(path, query, header, formData, body)
  let scheme = call_589268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589268.url(scheme.get, call_589268.host, call_589268.base,
                         call_589268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589268, url, valid)

proc call*(call_589269: Call_IamProjectsServiceAccountsCreate_589252; name: string;
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
  var path_589270 = newJObject()
  var query_589271 = newJObject()
  var body_589272 = newJObject()
  add(query_589271, "upload_protocol", newJString(uploadProtocol))
  add(query_589271, "fields", newJString(fields))
  add(query_589271, "quotaUser", newJString(quotaUser))
  add(path_589270, "name", newJString(name))
  add(query_589271, "alt", newJString(alt))
  add(query_589271, "oauth_token", newJString(oauthToken))
  add(query_589271, "callback", newJString(callback))
  add(query_589271, "access_token", newJString(accessToken))
  add(query_589271, "uploadType", newJString(uploadType))
  add(query_589271, "key", newJString(key))
  add(query_589271, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589272 = body
  add(query_589271, "prettyPrint", newJBool(prettyPrint))
  result = call_589269.call(path_589270, query_589271, nil, nil, body_589272)

var iamProjectsServiceAccountsCreate* = Call_IamProjectsServiceAccountsCreate_589252(
    name: "iamProjectsServiceAccountsCreate", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}/serviceAccounts",
    validator: validate_IamProjectsServiceAccountsCreate_589253, base: "/",
    url: url_IamProjectsServiceAccountsCreate_589254, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsList_589231 = ref object of OpenApiRestCall_588450
proc url_IamProjectsServiceAccountsList_589233(protocol: Scheme; host: string;
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

proc validate_IamProjectsServiceAccountsList_589232(path: JsonNode;
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
  var valid_589234 = path.getOrDefault("name")
  valid_589234 = validateParameter(valid_589234, JString, required = true,
                                 default = nil)
  if valid_589234 != nil:
    section.add "name", valid_589234
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
  var valid_589235 = query.getOrDefault("upload_protocol")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = nil)
  if valid_589235 != nil:
    section.add "upload_protocol", valid_589235
  var valid_589236 = query.getOrDefault("fields")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "fields", valid_589236
  var valid_589237 = query.getOrDefault("pageToken")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "pageToken", valid_589237
  var valid_589238 = query.getOrDefault("quotaUser")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "quotaUser", valid_589238
  var valid_589239 = query.getOrDefault("alt")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = newJString("json"))
  if valid_589239 != nil:
    section.add "alt", valid_589239
  var valid_589240 = query.getOrDefault("oauth_token")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = nil)
  if valid_589240 != nil:
    section.add "oauth_token", valid_589240
  var valid_589241 = query.getOrDefault("callback")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "callback", valid_589241
  var valid_589242 = query.getOrDefault("access_token")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "access_token", valid_589242
  var valid_589243 = query.getOrDefault("uploadType")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "uploadType", valid_589243
  var valid_589244 = query.getOrDefault("key")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "key", valid_589244
  var valid_589245 = query.getOrDefault("$.xgafv")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = newJString("1"))
  if valid_589245 != nil:
    section.add "$.xgafv", valid_589245
  var valid_589246 = query.getOrDefault("pageSize")
  valid_589246 = validateParameter(valid_589246, JInt, required = false, default = nil)
  if valid_589246 != nil:
    section.add "pageSize", valid_589246
  var valid_589247 = query.getOrDefault("prettyPrint")
  valid_589247 = validateParameter(valid_589247, JBool, required = false,
                                 default = newJBool(true))
  if valid_589247 != nil:
    section.add "prettyPrint", valid_589247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589248: Call_IamProjectsServiceAccountsList_589231; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists ServiceAccounts for a project.
  ## 
  let valid = call_589248.validator(path, query, header, formData, body)
  let scheme = call_589248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589248.url(scheme.get, call_589248.host, call_589248.base,
                         call_589248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589248, url, valid)

proc call*(call_589249: Call_IamProjectsServiceAccountsList_589231; name: string;
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
  var path_589250 = newJObject()
  var query_589251 = newJObject()
  add(query_589251, "upload_protocol", newJString(uploadProtocol))
  add(query_589251, "fields", newJString(fields))
  add(query_589251, "pageToken", newJString(pageToken))
  add(query_589251, "quotaUser", newJString(quotaUser))
  add(path_589250, "name", newJString(name))
  add(query_589251, "alt", newJString(alt))
  add(query_589251, "oauth_token", newJString(oauthToken))
  add(query_589251, "callback", newJString(callback))
  add(query_589251, "access_token", newJString(accessToken))
  add(query_589251, "uploadType", newJString(uploadType))
  add(query_589251, "key", newJString(key))
  add(query_589251, "$.xgafv", newJString(Xgafv))
  add(query_589251, "pageSize", newJInt(pageSize))
  add(query_589251, "prettyPrint", newJBool(prettyPrint))
  result = call_589249.call(path_589250, query_589251, nil, nil, nil)

var iamProjectsServiceAccountsList* = Call_IamProjectsServiceAccountsList_589231(
    name: "iamProjectsServiceAccountsList", meth: HttpMethod.HttpGet,
    host: "iam.googleapis.com", route: "/v1/{name}/serviceAccounts",
    validator: validate_IamProjectsServiceAccountsList_589232, base: "/",
    url: url_IamProjectsServiceAccountsList_589233, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsDisable_589273 = ref object of OpenApiRestCall_588450
proc url_IamProjectsServiceAccountsDisable_589275(protocol: Scheme; host: string;
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

proc validate_IamProjectsServiceAccountsDisable_589274(path: JsonNode;
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
  var valid_589276 = path.getOrDefault("name")
  valid_589276 = validateParameter(valid_589276, JString, required = true,
                                 default = nil)
  if valid_589276 != nil:
    section.add "name", valid_589276
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
  var valid_589277 = query.getOrDefault("upload_protocol")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = nil)
  if valid_589277 != nil:
    section.add "upload_protocol", valid_589277
  var valid_589278 = query.getOrDefault("fields")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = nil)
  if valid_589278 != nil:
    section.add "fields", valid_589278
  var valid_589279 = query.getOrDefault("quotaUser")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "quotaUser", valid_589279
  var valid_589280 = query.getOrDefault("alt")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = newJString("json"))
  if valid_589280 != nil:
    section.add "alt", valid_589280
  var valid_589281 = query.getOrDefault("oauth_token")
  valid_589281 = validateParameter(valid_589281, JString, required = false,
                                 default = nil)
  if valid_589281 != nil:
    section.add "oauth_token", valid_589281
  var valid_589282 = query.getOrDefault("callback")
  valid_589282 = validateParameter(valid_589282, JString, required = false,
                                 default = nil)
  if valid_589282 != nil:
    section.add "callback", valid_589282
  var valid_589283 = query.getOrDefault("access_token")
  valid_589283 = validateParameter(valid_589283, JString, required = false,
                                 default = nil)
  if valid_589283 != nil:
    section.add "access_token", valid_589283
  var valid_589284 = query.getOrDefault("uploadType")
  valid_589284 = validateParameter(valid_589284, JString, required = false,
                                 default = nil)
  if valid_589284 != nil:
    section.add "uploadType", valid_589284
  var valid_589285 = query.getOrDefault("key")
  valid_589285 = validateParameter(valid_589285, JString, required = false,
                                 default = nil)
  if valid_589285 != nil:
    section.add "key", valid_589285
  var valid_589286 = query.getOrDefault("$.xgafv")
  valid_589286 = validateParameter(valid_589286, JString, required = false,
                                 default = newJString("1"))
  if valid_589286 != nil:
    section.add "$.xgafv", valid_589286
  var valid_589287 = query.getOrDefault("prettyPrint")
  valid_589287 = validateParameter(valid_589287, JBool, required = false,
                                 default = newJBool(true))
  if valid_589287 != nil:
    section.add "prettyPrint", valid_589287
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

proc call*(call_589289: Call_IamProjectsServiceAccountsDisable_589273;
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
  let valid = call_589289.validator(path, query, header, formData, body)
  let scheme = call_589289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589289.url(scheme.get, call_589289.host, call_589289.base,
                         call_589289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589289, url, valid)

proc call*(call_589290: Call_IamProjectsServiceAccountsDisable_589273;
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
  var path_589291 = newJObject()
  var query_589292 = newJObject()
  var body_589293 = newJObject()
  add(query_589292, "upload_protocol", newJString(uploadProtocol))
  add(query_589292, "fields", newJString(fields))
  add(query_589292, "quotaUser", newJString(quotaUser))
  add(path_589291, "name", newJString(name))
  add(query_589292, "alt", newJString(alt))
  add(query_589292, "oauth_token", newJString(oauthToken))
  add(query_589292, "callback", newJString(callback))
  add(query_589292, "access_token", newJString(accessToken))
  add(query_589292, "uploadType", newJString(uploadType))
  add(query_589292, "key", newJString(key))
  add(query_589292, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589293 = body
  add(query_589292, "prettyPrint", newJBool(prettyPrint))
  result = call_589290.call(path_589291, query_589292, nil, nil, body_589293)

var iamProjectsServiceAccountsDisable* = Call_IamProjectsServiceAccountsDisable_589273(
    name: "iamProjectsServiceAccountsDisable", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}:disable",
    validator: validate_IamProjectsServiceAccountsDisable_589274, base: "/",
    url: url_IamProjectsServiceAccountsDisable_589275, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsEnable_589294 = ref object of OpenApiRestCall_588450
proc url_IamProjectsServiceAccountsEnable_589296(protocol: Scheme; host: string;
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

proc validate_IamProjectsServiceAccountsEnable_589295(path: JsonNode;
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
  var valid_589297 = path.getOrDefault("name")
  valid_589297 = validateParameter(valid_589297, JString, required = true,
                                 default = nil)
  if valid_589297 != nil:
    section.add "name", valid_589297
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
  var valid_589298 = query.getOrDefault("upload_protocol")
  valid_589298 = validateParameter(valid_589298, JString, required = false,
                                 default = nil)
  if valid_589298 != nil:
    section.add "upload_protocol", valid_589298
  var valid_589299 = query.getOrDefault("fields")
  valid_589299 = validateParameter(valid_589299, JString, required = false,
                                 default = nil)
  if valid_589299 != nil:
    section.add "fields", valid_589299
  var valid_589300 = query.getOrDefault("quotaUser")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = nil)
  if valid_589300 != nil:
    section.add "quotaUser", valid_589300
  var valid_589301 = query.getOrDefault("alt")
  valid_589301 = validateParameter(valid_589301, JString, required = false,
                                 default = newJString("json"))
  if valid_589301 != nil:
    section.add "alt", valid_589301
  var valid_589302 = query.getOrDefault("oauth_token")
  valid_589302 = validateParameter(valid_589302, JString, required = false,
                                 default = nil)
  if valid_589302 != nil:
    section.add "oauth_token", valid_589302
  var valid_589303 = query.getOrDefault("callback")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = nil)
  if valid_589303 != nil:
    section.add "callback", valid_589303
  var valid_589304 = query.getOrDefault("access_token")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = nil)
  if valid_589304 != nil:
    section.add "access_token", valid_589304
  var valid_589305 = query.getOrDefault("uploadType")
  valid_589305 = validateParameter(valid_589305, JString, required = false,
                                 default = nil)
  if valid_589305 != nil:
    section.add "uploadType", valid_589305
  var valid_589306 = query.getOrDefault("key")
  valid_589306 = validateParameter(valid_589306, JString, required = false,
                                 default = nil)
  if valid_589306 != nil:
    section.add "key", valid_589306
  var valid_589307 = query.getOrDefault("$.xgafv")
  valid_589307 = validateParameter(valid_589307, JString, required = false,
                                 default = newJString("1"))
  if valid_589307 != nil:
    section.add "$.xgafv", valid_589307
  var valid_589308 = query.getOrDefault("prettyPrint")
  valid_589308 = validateParameter(valid_589308, JBool, required = false,
                                 default = newJBool(true))
  if valid_589308 != nil:
    section.add "prettyPrint", valid_589308
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

proc call*(call_589310: Call_IamProjectsServiceAccountsEnable_589294;
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
  let valid = call_589310.validator(path, query, header, formData, body)
  let scheme = call_589310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589310.url(scheme.get, call_589310.host, call_589310.base,
                         call_589310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589310, url, valid)

proc call*(call_589311: Call_IamProjectsServiceAccountsEnable_589294; name: string;
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
  var path_589312 = newJObject()
  var query_589313 = newJObject()
  var body_589314 = newJObject()
  add(query_589313, "upload_protocol", newJString(uploadProtocol))
  add(query_589313, "fields", newJString(fields))
  add(query_589313, "quotaUser", newJString(quotaUser))
  add(path_589312, "name", newJString(name))
  add(query_589313, "alt", newJString(alt))
  add(query_589313, "oauth_token", newJString(oauthToken))
  add(query_589313, "callback", newJString(callback))
  add(query_589313, "access_token", newJString(accessToken))
  add(query_589313, "uploadType", newJString(uploadType))
  add(query_589313, "key", newJString(key))
  add(query_589313, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589314 = body
  add(query_589313, "prettyPrint", newJBool(prettyPrint))
  result = call_589311.call(path_589312, query_589313, nil, nil, body_589314)

var iamProjectsServiceAccountsEnable* = Call_IamProjectsServiceAccountsEnable_589294(
    name: "iamProjectsServiceAccountsEnable", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}:enable",
    validator: validate_IamProjectsServiceAccountsEnable_589295, base: "/",
    url: url_IamProjectsServiceAccountsEnable_589296, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsSignBlob_589315 = ref object of OpenApiRestCall_588450
proc url_IamProjectsServiceAccountsSignBlob_589317(protocol: Scheme; host: string;
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

proc validate_IamProjectsServiceAccountsSignBlob_589316(path: JsonNode;
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
  var valid_589318 = path.getOrDefault("name")
  valid_589318 = validateParameter(valid_589318, JString, required = true,
                                 default = nil)
  if valid_589318 != nil:
    section.add "name", valid_589318
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
  var valid_589319 = query.getOrDefault("upload_protocol")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = nil)
  if valid_589319 != nil:
    section.add "upload_protocol", valid_589319
  var valid_589320 = query.getOrDefault("fields")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "fields", valid_589320
  var valid_589321 = query.getOrDefault("quotaUser")
  valid_589321 = validateParameter(valid_589321, JString, required = false,
                                 default = nil)
  if valid_589321 != nil:
    section.add "quotaUser", valid_589321
  var valid_589322 = query.getOrDefault("alt")
  valid_589322 = validateParameter(valid_589322, JString, required = false,
                                 default = newJString("json"))
  if valid_589322 != nil:
    section.add "alt", valid_589322
  var valid_589323 = query.getOrDefault("oauth_token")
  valid_589323 = validateParameter(valid_589323, JString, required = false,
                                 default = nil)
  if valid_589323 != nil:
    section.add "oauth_token", valid_589323
  var valid_589324 = query.getOrDefault("callback")
  valid_589324 = validateParameter(valid_589324, JString, required = false,
                                 default = nil)
  if valid_589324 != nil:
    section.add "callback", valid_589324
  var valid_589325 = query.getOrDefault("access_token")
  valid_589325 = validateParameter(valid_589325, JString, required = false,
                                 default = nil)
  if valid_589325 != nil:
    section.add "access_token", valid_589325
  var valid_589326 = query.getOrDefault("uploadType")
  valid_589326 = validateParameter(valid_589326, JString, required = false,
                                 default = nil)
  if valid_589326 != nil:
    section.add "uploadType", valid_589326
  var valid_589327 = query.getOrDefault("key")
  valid_589327 = validateParameter(valid_589327, JString, required = false,
                                 default = nil)
  if valid_589327 != nil:
    section.add "key", valid_589327
  var valid_589328 = query.getOrDefault("$.xgafv")
  valid_589328 = validateParameter(valid_589328, JString, required = false,
                                 default = newJString("1"))
  if valid_589328 != nil:
    section.add "$.xgafv", valid_589328
  var valid_589329 = query.getOrDefault("prettyPrint")
  valid_589329 = validateParameter(valid_589329, JBool, required = false,
                                 default = newJBool(true))
  if valid_589329 != nil:
    section.add "prettyPrint", valid_589329
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

proc call*(call_589331: Call_IamProjectsServiceAccountsSignBlob_589315;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## **Note**: This method is in the process of being deprecated. Call the
  ## [`signBlob()`](/iam/credentials/reference/rest/v1/projects.serviceAccounts/signBlob)
  ## method of the Cloud IAM Service Account Credentials API instead.
  ## 
  ## Signs a blob using a service account's system-managed private key.
  ## 
  let valid = call_589331.validator(path, query, header, formData, body)
  let scheme = call_589331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589331.url(scheme.get, call_589331.host, call_589331.base,
                         call_589331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589331, url, valid)

proc call*(call_589332: Call_IamProjectsServiceAccountsSignBlob_589315;
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
  var path_589333 = newJObject()
  var query_589334 = newJObject()
  var body_589335 = newJObject()
  add(query_589334, "upload_protocol", newJString(uploadProtocol))
  add(query_589334, "fields", newJString(fields))
  add(query_589334, "quotaUser", newJString(quotaUser))
  add(path_589333, "name", newJString(name))
  add(query_589334, "alt", newJString(alt))
  add(query_589334, "oauth_token", newJString(oauthToken))
  add(query_589334, "callback", newJString(callback))
  add(query_589334, "access_token", newJString(accessToken))
  add(query_589334, "uploadType", newJString(uploadType))
  add(query_589334, "key", newJString(key))
  add(query_589334, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589335 = body
  add(query_589334, "prettyPrint", newJBool(prettyPrint))
  result = call_589332.call(path_589333, query_589334, nil, nil, body_589335)

var iamProjectsServiceAccountsSignBlob* = Call_IamProjectsServiceAccountsSignBlob_589315(
    name: "iamProjectsServiceAccountsSignBlob", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}:signBlob",
    validator: validate_IamProjectsServiceAccountsSignBlob_589316, base: "/",
    url: url_IamProjectsServiceAccountsSignBlob_589317, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsSignJwt_589336 = ref object of OpenApiRestCall_588450
proc url_IamProjectsServiceAccountsSignJwt_589338(protocol: Scheme; host: string;
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

proc validate_IamProjectsServiceAccountsSignJwt_589337(path: JsonNode;
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
  var valid_589339 = path.getOrDefault("name")
  valid_589339 = validateParameter(valid_589339, JString, required = true,
                                 default = nil)
  if valid_589339 != nil:
    section.add "name", valid_589339
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
  var valid_589340 = query.getOrDefault("upload_protocol")
  valid_589340 = validateParameter(valid_589340, JString, required = false,
                                 default = nil)
  if valid_589340 != nil:
    section.add "upload_protocol", valid_589340
  var valid_589341 = query.getOrDefault("fields")
  valid_589341 = validateParameter(valid_589341, JString, required = false,
                                 default = nil)
  if valid_589341 != nil:
    section.add "fields", valid_589341
  var valid_589342 = query.getOrDefault("quotaUser")
  valid_589342 = validateParameter(valid_589342, JString, required = false,
                                 default = nil)
  if valid_589342 != nil:
    section.add "quotaUser", valid_589342
  var valid_589343 = query.getOrDefault("alt")
  valid_589343 = validateParameter(valid_589343, JString, required = false,
                                 default = newJString("json"))
  if valid_589343 != nil:
    section.add "alt", valid_589343
  var valid_589344 = query.getOrDefault("oauth_token")
  valid_589344 = validateParameter(valid_589344, JString, required = false,
                                 default = nil)
  if valid_589344 != nil:
    section.add "oauth_token", valid_589344
  var valid_589345 = query.getOrDefault("callback")
  valid_589345 = validateParameter(valid_589345, JString, required = false,
                                 default = nil)
  if valid_589345 != nil:
    section.add "callback", valid_589345
  var valid_589346 = query.getOrDefault("access_token")
  valid_589346 = validateParameter(valid_589346, JString, required = false,
                                 default = nil)
  if valid_589346 != nil:
    section.add "access_token", valid_589346
  var valid_589347 = query.getOrDefault("uploadType")
  valid_589347 = validateParameter(valid_589347, JString, required = false,
                                 default = nil)
  if valid_589347 != nil:
    section.add "uploadType", valid_589347
  var valid_589348 = query.getOrDefault("key")
  valid_589348 = validateParameter(valid_589348, JString, required = false,
                                 default = nil)
  if valid_589348 != nil:
    section.add "key", valid_589348
  var valid_589349 = query.getOrDefault("$.xgafv")
  valid_589349 = validateParameter(valid_589349, JString, required = false,
                                 default = newJString("1"))
  if valid_589349 != nil:
    section.add "$.xgafv", valid_589349
  var valid_589350 = query.getOrDefault("prettyPrint")
  valid_589350 = validateParameter(valid_589350, JBool, required = false,
                                 default = newJBool(true))
  if valid_589350 != nil:
    section.add "prettyPrint", valid_589350
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

proc call*(call_589352: Call_IamProjectsServiceAccountsSignJwt_589336;
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
  let valid = call_589352.validator(path, query, header, formData, body)
  let scheme = call_589352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589352.url(scheme.get, call_589352.host, call_589352.base,
                         call_589352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589352, url, valid)

proc call*(call_589353: Call_IamProjectsServiceAccountsSignJwt_589336;
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
  var path_589354 = newJObject()
  var query_589355 = newJObject()
  var body_589356 = newJObject()
  add(query_589355, "upload_protocol", newJString(uploadProtocol))
  add(query_589355, "fields", newJString(fields))
  add(query_589355, "quotaUser", newJString(quotaUser))
  add(path_589354, "name", newJString(name))
  add(query_589355, "alt", newJString(alt))
  add(query_589355, "oauth_token", newJString(oauthToken))
  add(query_589355, "callback", newJString(callback))
  add(query_589355, "access_token", newJString(accessToken))
  add(query_589355, "uploadType", newJString(uploadType))
  add(query_589355, "key", newJString(key))
  add(query_589355, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589356 = body
  add(query_589355, "prettyPrint", newJBool(prettyPrint))
  result = call_589353.call(path_589354, query_589355, nil, nil, body_589356)

var iamProjectsServiceAccountsSignJwt* = Call_IamProjectsServiceAccountsSignJwt_589336(
    name: "iamProjectsServiceAccountsSignJwt", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}:signJwt",
    validator: validate_IamProjectsServiceAccountsSignJwt_589337, base: "/",
    url: url_IamProjectsServiceAccountsSignJwt_589338, schemes: {Scheme.Https})
type
  Call_IamProjectsRolesUndelete_589357 = ref object of OpenApiRestCall_588450
proc url_IamProjectsRolesUndelete_589359(protocol: Scheme; host: string;
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

proc validate_IamProjectsRolesUndelete_589358(path: JsonNode; query: JsonNode;
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
  var valid_589360 = path.getOrDefault("name")
  valid_589360 = validateParameter(valid_589360, JString, required = true,
                                 default = nil)
  if valid_589360 != nil:
    section.add "name", valid_589360
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
  var valid_589361 = query.getOrDefault("upload_protocol")
  valid_589361 = validateParameter(valid_589361, JString, required = false,
                                 default = nil)
  if valid_589361 != nil:
    section.add "upload_protocol", valid_589361
  var valid_589362 = query.getOrDefault("fields")
  valid_589362 = validateParameter(valid_589362, JString, required = false,
                                 default = nil)
  if valid_589362 != nil:
    section.add "fields", valid_589362
  var valid_589363 = query.getOrDefault("quotaUser")
  valid_589363 = validateParameter(valid_589363, JString, required = false,
                                 default = nil)
  if valid_589363 != nil:
    section.add "quotaUser", valid_589363
  var valid_589364 = query.getOrDefault("alt")
  valid_589364 = validateParameter(valid_589364, JString, required = false,
                                 default = newJString("json"))
  if valid_589364 != nil:
    section.add "alt", valid_589364
  var valid_589365 = query.getOrDefault("oauth_token")
  valid_589365 = validateParameter(valid_589365, JString, required = false,
                                 default = nil)
  if valid_589365 != nil:
    section.add "oauth_token", valid_589365
  var valid_589366 = query.getOrDefault("callback")
  valid_589366 = validateParameter(valid_589366, JString, required = false,
                                 default = nil)
  if valid_589366 != nil:
    section.add "callback", valid_589366
  var valid_589367 = query.getOrDefault("access_token")
  valid_589367 = validateParameter(valid_589367, JString, required = false,
                                 default = nil)
  if valid_589367 != nil:
    section.add "access_token", valid_589367
  var valid_589368 = query.getOrDefault("uploadType")
  valid_589368 = validateParameter(valid_589368, JString, required = false,
                                 default = nil)
  if valid_589368 != nil:
    section.add "uploadType", valid_589368
  var valid_589369 = query.getOrDefault("key")
  valid_589369 = validateParameter(valid_589369, JString, required = false,
                                 default = nil)
  if valid_589369 != nil:
    section.add "key", valid_589369
  var valid_589370 = query.getOrDefault("$.xgafv")
  valid_589370 = validateParameter(valid_589370, JString, required = false,
                                 default = newJString("1"))
  if valid_589370 != nil:
    section.add "$.xgafv", valid_589370
  var valid_589371 = query.getOrDefault("prettyPrint")
  valid_589371 = validateParameter(valid_589371, JBool, required = false,
                                 default = newJBool(true))
  if valid_589371 != nil:
    section.add "prettyPrint", valid_589371
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

proc call*(call_589373: Call_IamProjectsRolesUndelete_589357; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Undelete a Role, bringing it back in its previous state.
  ## 
  let valid = call_589373.validator(path, query, header, formData, body)
  let scheme = call_589373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589373.url(scheme.get, call_589373.host, call_589373.base,
                         call_589373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589373, url, valid)

proc call*(call_589374: Call_IamProjectsRolesUndelete_589357; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## iamProjectsRolesUndelete
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
  var path_589375 = newJObject()
  var query_589376 = newJObject()
  var body_589377 = newJObject()
  add(query_589376, "upload_protocol", newJString(uploadProtocol))
  add(query_589376, "fields", newJString(fields))
  add(query_589376, "quotaUser", newJString(quotaUser))
  add(path_589375, "name", newJString(name))
  add(query_589376, "alt", newJString(alt))
  add(query_589376, "oauth_token", newJString(oauthToken))
  add(query_589376, "callback", newJString(callback))
  add(query_589376, "access_token", newJString(accessToken))
  add(query_589376, "uploadType", newJString(uploadType))
  add(query_589376, "key", newJString(key))
  add(query_589376, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589377 = body
  add(query_589376, "prettyPrint", newJBool(prettyPrint))
  result = call_589374.call(path_589375, query_589376, nil, nil, body_589377)

var iamProjectsRolesUndelete* = Call_IamProjectsRolesUndelete_589357(
    name: "iamProjectsRolesUndelete", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}:undelete",
    validator: validate_IamProjectsRolesUndelete_589358, base: "/",
    url: url_IamProjectsRolesUndelete_589359, schemes: {Scheme.Https})
type
  Call_IamProjectsRolesCreate_589401 = ref object of OpenApiRestCall_588450
proc url_IamProjectsRolesCreate_589403(protocol: Scheme; host: string; base: string;
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

proc validate_IamProjectsRolesCreate_589402(path: JsonNode; query: JsonNode;
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
  var valid_589404 = path.getOrDefault("parent")
  valid_589404 = validateParameter(valid_589404, JString, required = true,
                                 default = nil)
  if valid_589404 != nil:
    section.add "parent", valid_589404
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
  var valid_589405 = query.getOrDefault("upload_protocol")
  valid_589405 = validateParameter(valid_589405, JString, required = false,
                                 default = nil)
  if valid_589405 != nil:
    section.add "upload_protocol", valid_589405
  var valid_589406 = query.getOrDefault("fields")
  valid_589406 = validateParameter(valid_589406, JString, required = false,
                                 default = nil)
  if valid_589406 != nil:
    section.add "fields", valid_589406
  var valid_589407 = query.getOrDefault("quotaUser")
  valid_589407 = validateParameter(valid_589407, JString, required = false,
                                 default = nil)
  if valid_589407 != nil:
    section.add "quotaUser", valid_589407
  var valid_589408 = query.getOrDefault("alt")
  valid_589408 = validateParameter(valid_589408, JString, required = false,
                                 default = newJString("json"))
  if valid_589408 != nil:
    section.add "alt", valid_589408
  var valid_589409 = query.getOrDefault("oauth_token")
  valid_589409 = validateParameter(valid_589409, JString, required = false,
                                 default = nil)
  if valid_589409 != nil:
    section.add "oauth_token", valid_589409
  var valid_589410 = query.getOrDefault("callback")
  valid_589410 = validateParameter(valid_589410, JString, required = false,
                                 default = nil)
  if valid_589410 != nil:
    section.add "callback", valid_589410
  var valid_589411 = query.getOrDefault("access_token")
  valid_589411 = validateParameter(valid_589411, JString, required = false,
                                 default = nil)
  if valid_589411 != nil:
    section.add "access_token", valid_589411
  var valid_589412 = query.getOrDefault("uploadType")
  valid_589412 = validateParameter(valid_589412, JString, required = false,
                                 default = nil)
  if valid_589412 != nil:
    section.add "uploadType", valid_589412
  var valid_589413 = query.getOrDefault("key")
  valid_589413 = validateParameter(valid_589413, JString, required = false,
                                 default = nil)
  if valid_589413 != nil:
    section.add "key", valid_589413
  var valid_589414 = query.getOrDefault("$.xgafv")
  valid_589414 = validateParameter(valid_589414, JString, required = false,
                                 default = newJString("1"))
  if valid_589414 != nil:
    section.add "$.xgafv", valid_589414
  var valid_589415 = query.getOrDefault("prettyPrint")
  valid_589415 = validateParameter(valid_589415, JBool, required = false,
                                 default = newJBool(true))
  if valid_589415 != nil:
    section.add "prettyPrint", valid_589415
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

proc call*(call_589417: Call_IamProjectsRolesCreate_589401; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Role.
  ## 
  let valid = call_589417.validator(path, query, header, formData, body)
  let scheme = call_589417.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589417.url(scheme.get, call_589417.host, call_589417.base,
                         call_589417.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589417, url, valid)

proc call*(call_589418: Call_IamProjectsRolesCreate_589401; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## iamProjectsRolesCreate
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
  var path_589419 = newJObject()
  var query_589420 = newJObject()
  var body_589421 = newJObject()
  add(query_589420, "upload_protocol", newJString(uploadProtocol))
  add(query_589420, "fields", newJString(fields))
  add(query_589420, "quotaUser", newJString(quotaUser))
  add(query_589420, "alt", newJString(alt))
  add(query_589420, "oauth_token", newJString(oauthToken))
  add(query_589420, "callback", newJString(callback))
  add(query_589420, "access_token", newJString(accessToken))
  add(query_589420, "uploadType", newJString(uploadType))
  add(path_589419, "parent", newJString(parent))
  add(query_589420, "key", newJString(key))
  add(query_589420, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589421 = body
  add(query_589420, "prettyPrint", newJBool(prettyPrint))
  result = call_589418.call(path_589419, query_589420, nil, nil, body_589421)

var iamProjectsRolesCreate* = Call_IamProjectsRolesCreate_589401(
    name: "iamProjectsRolesCreate", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{parent}/roles",
    validator: validate_IamProjectsRolesCreate_589402, base: "/",
    url: url_IamProjectsRolesCreate_589403, schemes: {Scheme.Https})
type
  Call_IamProjectsRolesList_589378 = ref object of OpenApiRestCall_588450
proc url_IamProjectsRolesList_589380(protocol: Scheme; host: string; base: string;
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

proc validate_IamProjectsRolesList_589379(path: JsonNode; query: JsonNode;
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
  var valid_589381 = path.getOrDefault("parent")
  valid_589381 = validateParameter(valid_589381, JString, required = true,
                                 default = nil)
  if valid_589381 != nil:
    section.add "parent", valid_589381
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
  var valid_589382 = query.getOrDefault("upload_protocol")
  valid_589382 = validateParameter(valid_589382, JString, required = false,
                                 default = nil)
  if valid_589382 != nil:
    section.add "upload_protocol", valid_589382
  var valid_589383 = query.getOrDefault("fields")
  valid_589383 = validateParameter(valid_589383, JString, required = false,
                                 default = nil)
  if valid_589383 != nil:
    section.add "fields", valid_589383
  var valid_589384 = query.getOrDefault("pageToken")
  valid_589384 = validateParameter(valid_589384, JString, required = false,
                                 default = nil)
  if valid_589384 != nil:
    section.add "pageToken", valid_589384
  var valid_589385 = query.getOrDefault("quotaUser")
  valid_589385 = validateParameter(valid_589385, JString, required = false,
                                 default = nil)
  if valid_589385 != nil:
    section.add "quotaUser", valid_589385
  var valid_589386 = query.getOrDefault("view")
  valid_589386 = validateParameter(valid_589386, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_589386 != nil:
    section.add "view", valid_589386
  var valid_589387 = query.getOrDefault("alt")
  valid_589387 = validateParameter(valid_589387, JString, required = false,
                                 default = newJString("json"))
  if valid_589387 != nil:
    section.add "alt", valid_589387
  var valid_589388 = query.getOrDefault("oauth_token")
  valid_589388 = validateParameter(valid_589388, JString, required = false,
                                 default = nil)
  if valid_589388 != nil:
    section.add "oauth_token", valid_589388
  var valid_589389 = query.getOrDefault("callback")
  valid_589389 = validateParameter(valid_589389, JString, required = false,
                                 default = nil)
  if valid_589389 != nil:
    section.add "callback", valid_589389
  var valid_589390 = query.getOrDefault("access_token")
  valid_589390 = validateParameter(valid_589390, JString, required = false,
                                 default = nil)
  if valid_589390 != nil:
    section.add "access_token", valid_589390
  var valid_589391 = query.getOrDefault("uploadType")
  valid_589391 = validateParameter(valid_589391, JString, required = false,
                                 default = nil)
  if valid_589391 != nil:
    section.add "uploadType", valid_589391
  var valid_589392 = query.getOrDefault("showDeleted")
  valid_589392 = validateParameter(valid_589392, JBool, required = false, default = nil)
  if valid_589392 != nil:
    section.add "showDeleted", valid_589392
  var valid_589393 = query.getOrDefault("key")
  valid_589393 = validateParameter(valid_589393, JString, required = false,
                                 default = nil)
  if valid_589393 != nil:
    section.add "key", valid_589393
  var valid_589394 = query.getOrDefault("$.xgafv")
  valid_589394 = validateParameter(valid_589394, JString, required = false,
                                 default = newJString("1"))
  if valid_589394 != nil:
    section.add "$.xgafv", valid_589394
  var valid_589395 = query.getOrDefault("pageSize")
  valid_589395 = validateParameter(valid_589395, JInt, required = false, default = nil)
  if valid_589395 != nil:
    section.add "pageSize", valid_589395
  var valid_589396 = query.getOrDefault("prettyPrint")
  valid_589396 = validateParameter(valid_589396, JBool, required = false,
                                 default = newJBool(true))
  if valid_589396 != nil:
    section.add "prettyPrint", valid_589396
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589397: Call_IamProjectsRolesList_589378; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Roles defined on a resource.
  ## 
  let valid = call_589397.validator(path, query, header, formData, body)
  let scheme = call_589397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589397.url(scheme.get, call_589397.host, call_589397.base,
                         call_589397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589397, url, valid)

proc call*(call_589398: Call_IamProjectsRolesList_589378; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; view: string = "BASIC"; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; showDeleted: bool = false; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## iamProjectsRolesList
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
  var path_589399 = newJObject()
  var query_589400 = newJObject()
  add(query_589400, "upload_protocol", newJString(uploadProtocol))
  add(query_589400, "fields", newJString(fields))
  add(query_589400, "pageToken", newJString(pageToken))
  add(query_589400, "quotaUser", newJString(quotaUser))
  add(query_589400, "view", newJString(view))
  add(query_589400, "alt", newJString(alt))
  add(query_589400, "oauth_token", newJString(oauthToken))
  add(query_589400, "callback", newJString(callback))
  add(query_589400, "access_token", newJString(accessToken))
  add(query_589400, "uploadType", newJString(uploadType))
  add(path_589399, "parent", newJString(parent))
  add(query_589400, "showDeleted", newJBool(showDeleted))
  add(query_589400, "key", newJString(key))
  add(query_589400, "$.xgafv", newJString(Xgafv))
  add(query_589400, "pageSize", newJInt(pageSize))
  add(query_589400, "prettyPrint", newJBool(prettyPrint))
  result = call_589398.call(path_589399, query_589400, nil, nil, nil)

var iamProjectsRolesList* = Call_IamProjectsRolesList_589378(
    name: "iamProjectsRolesList", meth: HttpMethod.HttpGet,
    host: "iam.googleapis.com", route: "/v1/{parent}/roles",
    validator: validate_IamProjectsRolesList_589379, base: "/",
    url: url_IamProjectsRolesList_589380, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsGetIamPolicy_589422 = ref object of OpenApiRestCall_588450
proc url_IamProjectsServiceAccountsGetIamPolicy_589424(protocol: Scheme;
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

proc validate_IamProjectsServiceAccountsGetIamPolicy_589423(path: JsonNode;
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
  var valid_589425 = path.getOrDefault("resource")
  valid_589425 = validateParameter(valid_589425, JString, required = true,
                                 default = nil)
  if valid_589425 != nil:
    section.add "resource", valid_589425
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
  var valid_589426 = query.getOrDefault("upload_protocol")
  valid_589426 = validateParameter(valid_589426, JString, required = false,
                                 default = nil)
  if valid_589426 != nil:
    section.add "upload_protocol", valid_589426
  var valid_589427 = query.getOrDefault("fields")
  valid_589427 = validateParameter(valid_589427, JString, required = false,
                                 default = nil)
  if valid_589427 != nil:
    section.add "fields", valid_589427
  var valid_589428 = query.getOrDefault("quotaUser")
  valid_589428 = validateParameter(valid_589428, JString, required = false,
                                 default = nil)
  if valid_589428 != nil:
    section.add "quotaUser", valid_589428
  var valid_589429 = query.getOrDefault("alt")
  valid_589429 = validateParameter(valid_589429, JString, required = false,
                                 default = newJString("json"))
  if valid_589429 != nil:
    section.add "alt", valid_589429
  var valid_589430 = query.getOrDefault("oauth_token")
  valid_589430 = validateParameter(valid_589430, JString, required = false,
                                 default = nil)
  if valid_589430 != nil:
    section.add "oauth_token", valid_589430
  var valid_589431 = query.getOrDefault("callback")
  valid_589431 = validateParameter(valid_589431, JString, required = false,
                                 default = nil)
  if valid_589431 != nil:
    section.add "callback", valid_589431
  var valid_589432 = query.getOrDefault("access_token")
  valid_589432 = validateParameter(valid_589432, JString, required = false,
                                 default = nil)
  if valid_589432 != nil:
    section.add "access_token", valid_589432
  var valid_589433 = query.getOrDefault("uploadType")
  valid_589433 = validateParameter(valid_589433, JString, required = false,
                                 default = nil)
  if valid_589433 != nil:
    section.add "uploadType", valid_589433
  var valid_589434 = query.getOrDefault("options.requestedPolicyVersion")
  valid_589434 = validateParameter(valid_589434, JInt, required = false, default = nil)
  if valid_589434 != nil:
    section.add "options.requestedPolicyVersion", valid_589434
  var valid_589435 = query.getOrDefault("key")
  valid_589435 = validateParameter(valid_589435, JString, required = false,
                                 default = nil)
  if valid_589435 != nil:
    section.add "key", valid_589435
  var valid_589436 = query.getOrDefault("$.xgafv")
  valid_589436 = validateParameter(valid_589436, JString, required = false,
                                 default = newJString("1"))
  if valid_589436 != nil:
    section.add "$.xgafv", valid_589436
  var valid_589437 = query.getOrDefault("prettyPrint")
  valid_589437 = validateParameter(valid_589437, JBool, required = false,
                                 default = newJBool(true))
  if valid_589437 != nil:
    section.add "prettyPrint", valid_589437
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589438: Call_IamProjectsServiceAccountsGetIamPolicy_589422;
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
  let valid = call_589438.validator(path, query, header, formData, body)
  let scheme = call_589438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589438.url(scheme.get, call_589438.host, call_589438.base,
                         call_589438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589438, url, valid)

proc call*(call_589439: Call_IamProjectsServiceAccountsGetIamPolicy_589422;
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
  var path_589440 = newJObject()
  var query_589441 = newJObject()
  add(query_589441, "upload_protocol", newJString(uploadProtocol))
  add(query_589441, "fields", newJString(fields))
  add(query_589441, "quotaUser", newJString(quotaUser))
  add(query_589441, "alt", newJString(alt))
  add(query_589441, "oauth_token", newJString(oauthToken))
  add(query_589441, "callback", newJString(callback))
  add(query_589441, "access_token", newJString(accessToken))
  add(query_589441, "uploadType", newJString(uploadType))
  add(query_589441, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_589441, "key", newJString(key))
  add(query_589441, "$.xgafv", newJString(Xgafv))
  add(path_589440, "resource", newJString(resource))
  add(query_589441, "prettyPrint", newJBool(prettyPrint))
  result = call_589439.call(path_589440, query_589441, nil, nil, nil)

var iamProjectsServiceAccountsGetIamPolicy* = Call_IamProjectsServiceAccountsGetIamPolicy_589422(
    name: "iamProjectsServiceAccountsGetIamPolicy", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{resource}:getIamPolicy",
    validator: validate_IamProjectsServiceAccountsGetIamPolicy_589423, base: "/",
    url: url_IamProjectsServiceAccountsGetIamPolicy_589424,
    schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsSetIamPolicy_589442 = ref object of OpenApiRestCall_588450
proc url_IamProjectsServiceAccountsSetIamPolicy_589444(protocol: Scheme;
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

proc validate_IamProjectsServiceAccountsSetIamPolicy_589443(path: JsonNode;
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
  var valid_589445 = path.getOrDefault("resource")
  valid_589445 = validateParameter(valid_589445, JString, required = true,
                                 default = nil)
  if valid_589445 != nil:
    section.add "resource", valid_589445
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
  var valid_589446 = query.getOrDefault("upload_protocol")
  valid_589446 = validateParameter(valid_589446, JString, required = false,
                                 default = nil)
  if valid_589446 != nil:
    section.add "upload_protocol", valid_589446
  var valid_589447 = query.getOrDefault("fields")
  valid_589447 = validateParameter(valid_589447, JString, required = false,
                                 default = nil)
  if valid_589447 != nil:
    section.add "fields", valid_589447
  var valid_589448 = query.getOrDefault("quotaUser")
  valid_589448 = validateParameter(valid_589448, JString, required = false,
                                 default = nil)
  if valid_589448 != nil:
    section.add "quotaUser", valid_589448
  var valid_589449 = query.getOrDefault("alt")
  valid_589449 = validateParameter(valid_589449, JString, required = false,
                                 default = newJString("json"))
  if valid_589449 != nil:
    section.add "alt", valid_589449
  var valid_589450 = query.getOrDefault("oauth_token")
  valid_589450 = validateParameter(valid_589450, JString, required = false,
                                 default = nil)
  if valid_589450 != nil:
    section.add "oauth_token", valid_589450
  var valid_589451 = query.getOrDefault("callback")
  valid_589451 = validateParameter(valid_589451, JString, required = false,
                                 default = nil)
  if valid_589451 != nil:
    section.add "callback", valid_589451
  var valid_589452 = query.getOrDefault("access_token")
  valid_589452 = validateParameter(valid_589452, JString, required = false,
                                 default = nil)
  if valid_589452 != nil:
    section.add "access_token", valid_589452
  var valid_589453 = query.getOrDefault("uploadType")
  valid_589453 = validateParameter(valid_589453, JString, required = false,
                                 default = nil)
  if valid_589453 != nil:
    section.add "uploadType", valid_589453
  var valid_589454 = query.getOrDefault("key")
  valid_589454 = validateParameter(valid_589454, JString, required = false,
                                 default = nil)
  if valid_589454 != nil:
    section.add "key", valid_589454
  var valid_589455 = query.getOrDefault("$.xgafv")
  valid_589455 = validateParameter(valid_589455, JString, required = false,
                                 default = newJString("1"))
  if valid_589455 != nil:
    section.add "$.xgafv", valid_589455
  var valid_589456 = query.getOrDefault("prettyPrint")
  valid_589456 = validateParameter(valid_589456, JBool, required = false,
                                 default = newJBool(true))
  if valid_589456 != nil:
    section.add "prettyPrint", valid_589456
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

proc call*(call_589458: Call_IamProjectsServiceAccountsSetIamPolicy_589442;
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
  let valid = call_589458.validator(path, query, header, formData, body)
  let scheme = call_589458.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589458.url(scheme.get, call_589458.host, call_589458.base,
                         call_589458.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589458, url, valid)

proc call*(call_589459: Call_IamProjectsServiceAccountsSetIamPolicy_589442;
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
  var path_589460 = newJObject()
  var query_589461 = newJObject()
  var body_589462 = newJObject()
  add(query_589461, "upload_protocol", newJString(uploadProtocol))
  add(query_589461, "fields", newJString(fields))
  add(query_589461, "quotaUser", newJString(quotaUser))
  add(query_589461, "alt", newJString(alt))
  add(query_589461, "oauth_token", newJString(oauthToken))
  add(query_589461, "callback", newJString(callback))
  add(query_589461, "access_token", newJString(accessToken))
  add(query_589461, "uploadType", newJString(uploadType))
  add(query_589461, "key", newJString(key))
  add(query_589461, "$.xgafv", newJString(Xgafv))
  add(path_589460, "resource", newJString(resource))
  if body != nil:
    body_589462 = body
  add(query_589461, "prettyPrint", newJBool(prettyPrint))
  result = call_589459.call(path_589460, query_589461, nil, nil, body_589462)

var iamProjectsServiceAccountsSetIamPolicy* = Call_IamProjectsServiceAccountsSetIamPolicy_589442(
    name: "iamProjectsServiceAccountsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{resource}:setIamPolicy",
    validator: validate_IamProjectsServiceAccountsSetIamPolicy_589443, base: "/",
    url: url_IamProjectsServiceAccountsSetIamPolicy_589444,
    schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsTestIamPermissions_589463 = ref object of OpenApiRestCall_588450
proc url_IamProjectsServiceAccountsTestIamPermissions_589465(protocol: Scheme;
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

proc validate_IamProjectsServiceAccountsTestIamPermissions_589464(path: JsonNode;
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
  var valid_589466 = path.getOrDefault("resource")
  valid_589466 = validateParameter(valid_589466, JString, required = true,
                                 default = nil)
  if valid_589466 != nil:
    section.add "resource", valid_589466
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
  var valid_589467 = query.getOrDefault("upload_protocol")
  valid_589467 = validateParameter(valid_589467, JString, required = false,
                                 default = nil)
  if valid_589467 != nil:
    section.add "upload_protocol", valid_589467
  var valid_589468 = query.getOrDefault("fields")
  valid_589468 = validateParameter(valid_589468, JString, required = false,
                                 default = nil)
  if valid_589468 != nil:
    section.add "fields", valid_589468
  var valid_589469 = query.getOrDefault("quotaUser")
  valid_589469 = validateParameter(valid_589469, JString, required = false,
                                 default = nil)
  if valid_589469 != nil:
    section.add "quotaUser", valid_589469
  var valid_589470 = query.getOrDefault("alt")
  valid_589470 = validateParameter(valid_589470, JString, required = false,
                                 default = newJString("json"))
  if valid_589470 != nil:
    section.add "alt", valid_589470
  var valid_589471 = query.getOrDefault("oauth_token")
  valid_589471 = validateParameter(valid_589471, JString, required = false,
                                 default = nil)
  if valid_589471 != nil:
    section.add "oauth_token", valid_589471
  var valid_589472 = query.getOrDefault("callback")
  valid_589472 = validateParameter(valid_589472, JString, required = false,
                                 default = nil)
  if valid_589472 != nil:
    section.add "callback", valid_589472
  var valid_589473 = query.getOrDefault("access_token")
  valid_589473 = validateParameter(valid_589473, JString, required = false,
                                 default = nil)
  if valid_589473 != nil:
    section.add "access_token", valid_589473
  var valid_589474 = query.getOrDefault("uploadType")
  valid_589474 = validateParameter(valid_589474, JString, required = false,
                                 default = nil)
  if valid_589474 != nil:
    section.add "uploadType", valid_589474
  var valid_589475 = query.getOrDefault("key")
  valid_589475 = validateParameter(valid_589475, JString, required = false,
                                 default = nil)
  if valid_589475 != nil:
    section.add "key", valid_589475
  var valid_589476 = query.getOrDefault("$.xgafv")
  valid_589476 = validateParameter(valid_589476, JString, required = false,
                                 default = newJString("1"))
  if valid_589476 != nil:
    section.add "$.xgafv", valid_589476
  var valid_589477 = query.getOrDefault("prettyPrint")
  valid_589477 = validateParameter(valid_589477, JBool, required = false,
                                 default = newJBool(true))
  if valid_589477 != nil:
    section.add "prettyPrint", valid_589477
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

proc call*(call_589479: Call_IamProjectsServiceAccountsTestIamPermissions_589463;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Tests the specified permissions against the IAM access control policy
  ## for a ServiceAccount.
  ## 
  let valid = call_589479.validator(path, query, header, formData, body)
  let scheme = call_589479.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589479.url(scheme.get, call_589479.host, call_589479.base,
                         call_589479.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589479, url, valid)

proc call*(call_589480: Call_IamProjectsServiceAccountsTestIamPermissions_589463;
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
  var path_589481 = newJObject()
  var query_589482 = newJObject()
  var body_589483 = newJObject()
  add(query_589482, "upload_protocol", newJString(uploadProtocol))
  add(query_589482, "fields", newJString(fields))
  add(query_589482, "quotaUser", newJString(quotaUser))
  add(query_589482, "alt", newJString(alt))
  add(query_589482, "oauth_token", newJString(oauthToken))
  add(query_589482, "callback", newJString(callback))
  add(query_589482, "access_token", newJString(accessToken))
  add(query_589482, "uploadType", newJString(uploadType))
  add(query_589482, "key", newJString(key))
  add(query_589482, "$.xgafv", newJString(Xgafv))
  add(path_589481, "resource", newJString(resource))
  if body != nil:
    body_589483 = body
  add(query_589482, "prettyPrint", newJBool(prettyPrint))
  result = call_589480.call(path_589481, query_589482, nil, nil, body_589483)

var iamProjectsServiceAccountsTestIamPermissions* = Call_IamProjectsServiceAccountsTestIamPermissions_589463(
    name: "iamProjectsServiceAccountsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "iam.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_IamProjectsServiceAccountsTestIamPermissions_589464,
    base: "/", url: url_IamProjectsServiceAccountsTestIamPermissions_589465,
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
