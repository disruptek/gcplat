
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

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

  OpenApiRestCall_579373 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579373](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579373): Option[Scheme] {.used.} =
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
  Call_IamIamPoliciesLintPolicy_579644 = ref object of OpenApiRestCall_579373
proc url_IamIamPoliciesLintPolicy_579646(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_IamIamPoliciesLintPolicy_579645(path: JsonNode; query: JsonNode;
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
  var valid_579758 = query.getOrDefault("key")
  valid_579758 = validateParameter(valid_579758, JString, required = false,
                                 default = nil)
  if valid_579758 != nil:
    section.add "key", valid_579758
  var valid_579772 = query.getOrDefault("prettyPrint")
  valid_579772 = validateParameter(valid_579772, JBool, required = false,
                                 default = newJBool(true))
  if valid_579772 != nil:
    section.add "prettyPrint", valid_579772
  var valid_579773 = query.getOrDefault("oauth_token")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "oauth_token", valid_579773
  var valid_579774 = query.getOrDefault("$.xgafv")
  valid_579774 = validateParameter(valid_579774, JString, required = false,
                                 default = newJString("1"))
  if valid_579774 != nil:
    section.add "$.xgafv", valid_579774
  var valid_579775 = query.getOrDefault("alt")
  valid_579775 = validateParameter(valid_579775, JString, required = false,
                                 default = newJString("json"))
  if valid_579775 != nil:
    section.add "alt", valid_579775
  var valid_579776 = query.getOrDefault("uploadType")
  valid_579776 = validateParameter(valid_579776, JString, required = false,
                                 default = nil)
  if valid_579776 != nil:
    section.add "uploadType", valid_579776
  var valid_579777 = query.getOrDefault("quotaUser")
  valid_579777 = validateParameter(valid_579777, JString, required = false,
                                 default = nil)
  if valid_579777 != nil:
    section.add "quotaUser", valid_579777
  var valid_579778 = query.getOrDefault("callback")
  valid_579778 = validateParameter(valid_579778, JString, required = false,
                                 default = nil)
  if valid_579778 != nil:
    section.add "callback", valid_579778
  var valid_579779 = query.getOrDefault("fields")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = nil)
  if valid_579779 != nil:
    section.add "fields", valid_579779
  var valid_579780 = query.getOrDefault("access_token")
  valid_579780 = validateParameter(valid_579780, JString, required = false,
                                 default = nil)
  if valid_579780 != nil:
    section.add "access_token", valid_579780
  var valid_579781 = query.getOrDefault("upload_protocol")
  valid_579781 = validateParameter(valid_579781, JString, required = false,
                                 default = nil)
  if valid_579781 != nil:
    section.add "upload_protocol", valid_579781
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

proc call*(call_579805: Call_IamIamPoliciesLintPolicy_579644; path: JsonNode;
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
  let valid = call_579805.validator(path, query, header, formData, body)
  let scheme = call_579805.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579805.url(scheme.get, call_579805.host, call_579805.base,
                         call_579805.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579805, url, valid)

proc call*(call_579876: Call_IamIamPoliciesLintPolicy_579644; key: string = "";
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
  var query_579877 = newJObject()
  var body_579879 = newJObject()
  add(query_579877, "key", newJString(key))
  add(query_579877, "prettyPrint", newJBool(prettyPrint))
  add(query_579877, "oauth_token", newJString(oauthToken))
  add(query_579877, "$.xgafv", newJString(Xgafv))
  add(query_579877, "alt", newJString(alt))
  add(query_579877, "uploadType", newJString(uploadType))
  add(query_579877, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579879 = body
  add(query_579877, "callback", newJString(callback))
  add(query_579877, "fields", newJString(fields))
  add(query_579877, "access_token", newJString(accessToken))
  add(query_579877, "upload_protocol", newJString(uploadProtocol))
  result = call_579876.call(nil, query_579877, nil, nil, body_579879)

var iamIamPoliciesLintPolicy* = Call_IamIamPoliciesLintPolicy_579644(
    name: "iamIamPoliciesLintPolicy", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/iamPolicies:lintPolicy",
    validator: validate_IamIamPoliciesLintPolicy_579645, base: "/",
    url: url_IamIamPoliciesLintPolicy_579646, schemes: {Scheme.Https})
type
  Call_IamIamPoliciesQueryAuditableServices_579918 = ref object of OpenApiRestCall_579373
proc url_IamIamPoliciesQueryAuditableServices_579920(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_IamIamPoliciesQueryAuditableServices_579919(path: JsonNode;
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
  var valid_579921 = query.getOrDefault("key")
  valid_579921 = validateParameter(valid_579921, JString, required = false,
                                 default = nil)
  if valid_579921 != nil:
    section.add "key", valid_579921
  var valid_579922 = query.getOrDefault("prettyPrint")
  valid_579922 = validateParameter(valid_579922, JBool, required = false,
                                 default = newJBool(true))
  if valid_579922 != nil:
    section.add "prettyPrint", valid_579922
  var valid_579923 = query.getOrDefault("oauth_token")
  valid_579923 = validateParameter(valid_579923, JString, required = false,
                                 default = nil)
  if valid_579923 != nil:
    section.add "oauth_token", valid_579923
  var valid_579924 = query.getOrDefault("$.xgafv")
  valid_579924 = validateParameter(valid_579924, JString, required = false,
                                 default = newJString("1"))
  if valid_579924 != nil:
    section.add "$.xgafv", valid_579924
  var valid_579925 = query.getOrDefault("alt")
  valid_579925 = validateParameter(valid_579925, JString, required = false,
                                 default = newJString("json"))
  if valid_579925 != nil:
    section.add "alt", valid_579925
  var valid_579926 = query.getOrDefault("uploadType")
  valid_579926 = validateParameter(valid_579926, JString, required = false,
                                 default = nil)
  if valid_579926 != nil:
    section.add "uploadType", valid_579926
  var valid_579927 = query.getOrDefault("quotaUser")
  valid_579927 = validateParameter(valid_579927, JString, required = false,
                                 default = nil)
  if valid_579927 != nil:
    section.add "quotaUser", valid_579927
  var valid_579928 = query.getOrDefault("callback")
  valid_579928 = validateParameter(valid_579928, JString, required = false,
                                 default = nil)
  if valid_579928 != nil:
    section.add "callback", valid_579928
  var valid_579929 = query.getOrDefault("fields")
  valid_579929 = validateParameter(valid_579929, JString, required = false,
                                 default = nil)
  if valid_579929 != nil:
    section.add "fields", valid_579929
  var valid_579930 = query.getOrDefault("access_token")
  valid_579930 = validateParameter(valid_579930, JString, required = false,
                                 default = nil)
  if valid_579930 != nil:
    section.add "access_token", valid_579930
  var valid_579931 = query.getOrDefault("upload_protocol")
  valid_579931 = validateParameter(valid_579931, JString, required = false,
                                 default = nil)
  if valid_579931 != nil:
    section.add "upload_protocol", valid_579931
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

proc call*(call_579933: Call_IamIamPoliciesQueryAuditableServices_579918;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of services that support service level audit logging
  ## configuration for the given resource.
  ## 
  let valid = call_579933.validator(path, query, header, formData, body)
  let scheme = call_579933.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579933.url(scheme.get, call_579933.host, call_579933.base,
                         call_579933.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579933, url, valid)

proc call*(call_579934: Call_IamIamPoliciesQueryAuditableServices_579918;
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
  var query_579935 = newJObject()
  var body_579936 = newJObject()
  add(query_579935, "key", newJString(key))
  add(query_579935, "prettyPrint", newJBool(prettyPrint))
  add(query_579935, "oauth_token", newJString(oauthToken))
  add(query_579935, "$.xgafv", newJString(Xgafv))
  add(query_579935, "alt", newJString(alt))
  add(query_579935, "uploadType", newJString(uploadType))
  add(query_579935, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579936 = body
  add(query_579935, "callback", newJString(callback))
  add(query_579935, "fields", newJString(fields))
  add(query_579935, "access_token", newJString(accessToken))
  add(query_579935, "upload_protocol", newJString(uploadProtocol))
  result = call_579934.call(nil, query_579935, nil, nil, body_579936)

var iamIamPoliciesQueryAuditableServices* = Call_IamIamPoliciesQueryAuditableServices_579918(
    name: "iamIamPoliciesQueryAuditableServices", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/iamPolicies:queryAuditableServices",
    validator: validate_IamIamPoliciesQueryAuditableServices_579919, base: "/",
    url: url_IamIamPoliciesQueryAuditableServices_579920, schemes: {Scheme.Https})
type
  Call_IamPermissionsQueryTestablePermissions_579937 = ref object of OpenApiRestCall_579373
proc url_IamPermissionsQueryTestablePermissions_579939(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_IamPermissionsQueryTestablePermissions_579938(path: JsonNode;
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
  var valid_579940 = query.getOrDefault("key")
  valid_579940 = validateParameter(valid_579940, JString, required = false,
                                 default = nil)
  if valid_579940 != nil:
    section.add "key", valid_579940
  var valid_579941 = query.getOrDefault("prettyPrint")
  valid_579941 = validateParameter(valid_579941, JBool, required = false,
                                 default = newJBool(true))
  if valid_579941 != nil:
    section.add "prettyPrint", valid_579941
  var valid_579942 = query.getOrDefault("oauth_token")
  valid_579942 = validateParameter(valid_579942, JString, required = false,
                                 default = nil)
  if valid_579942 != nil:
    section.add "oauth_token", valid_579942
  var valid_579943 = query.getOrDefault("$.xgafv")
  valid_579943 = validateParameter(valid_579943, JString, required = false,
                                 default = newJString("1"))
  if valid_579943 != nil:
    section.add "$.xgafv", valid_579943
  var valid_579944 = query.getOrDefault("alt")
  valid_579944 = validateParameter(valid_579944, JString, required = false,
                                 default = newJString("json"))
  if valid_579944 != nil:
    section.add "alt", valid_579944
  var valid_579945 = query.getOrDefault("uploadType")
  valid_579945 = validateParameter(valid_579945, JString, required = false,
                                 default = nil)
  if valid_579945 != nil:
    section.add "uploadType", valid_579945
  var valid_579946 = query.getOrDefault("quotaUser")
  valid_579946 = validateParameter(valid_579946, JString, required = false,
                                 default = nil)
  if valid_579946 != nil:
    section.add "quotaUser", valid_579946
  var valid_579947 = query.getOrDefault("callback")
  valid_579947 = validateParameter(valid_579947, JString, required = false,
                                 default = nil)
  if valid_579947 != nil:
    section.add "callback", valid_579947
  var valid_579948 = query.getOrDefault("fields")
  valid_579948 = validateParameter(valid_579948, JString, required = false,
                                 default = nil)
  if valid_579948 != nil:
    section.add "fields", valid_579948
  var valid_579949 = query.getOrDefault("access_token")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = nil)
  if valid_579949 != nil:
    section.add "access_token", valid_579949
  var valid_579950 = query.getOrDefault("upload_protocol")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = nil)
  if valid_579950 != nil:
    section.add "upload_protocol", valid_579950
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

proc call*(call_579952: Call_IamPermissionsQueryTestablePermissions_579937;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the permissions testable on a resource.
  ## A permission is testable if it can be tested for an identity on a resource.
  ## 
  let valid = call_579952.validator(path, query, header, formData, body)
  let scheme = call_579952.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579952.url(scheme.get, call_579952.host, call_579952.base,
                         call_579952.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579952, url, valid)

proc call*(call_579953: Call_IamPermissionsQueryTestablePermissions_579937;
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
  var query_579954 = newJObject()
  var body_579955 = newJObject()
  add(query_579954, "key", newJString(key))
  add(query_579954, "prettyPrint", newJBool(prettyPrint))
  add(query_579954, "oauth_token", newJString(oauthToken))
  add(query_579954, "$.xgafv", newJString(Xgafv))
  add(query_579954, "alt", newJString(alt))
  add(query_579954, "uploadType", newJString(uploadType))
  add(query_579954, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579955 = body
  add(query_579954, "callback", newJString(callback))
  add(query_579954, "fields", newJString(fields))
  add(query_579954, "access_token", newJString(accessToken))
  add(query_579954, "upload_protocol", newJString(uploadProtocol))
  result = call_579953.call(nil, query_579954, nil, nil, body_579955)

var iamPermissionsQueryTestablePermissions* = Call_IamPermissionsQueryTestablePermissions_579937(
    name: "iamPermissionsQueryTestablePermissions", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/permissions:queryTestablePermissions",
    validator: validate_IamPermissionsQueryTestablePermissions_579938, base: "/",
    url: url_IamPermissionsQueryTestablePermissions_579939,
    schemes: {Scheme.Https})
type
  Call_IamRolesList_579956 = ref object of OpenApiRestCall_579373
proc url_IamRolesList_579958(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_IamRolesList_579957(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_579959 = query.getOrDefault("key")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "key", valid_579959
  var valid_579960 = query.getOrDefault("prettyPrint")
  valid_579960 = validateParameter(valid_579960, JBool, required = false,
                                 default = newJBool(true))
  if valid_579960 != nil:
    section.add "prettyPrint", valid_579960
  var valid_579961 = query.getOrDefault("oauth_token")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "oauth_token", valid_579961
  var valid_579962 = query.getOrDefault("$.xgafv")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = newJString("1"))
  if valid_579962 != nil:
    section.add "$.xgafv", valid_579962
  var valid_579963 = query.getOrDefault("pageSize")
  valid_579963 = validateParameter(valid_579963, JInt, required = false, default = nil)
  if valid_579963 != nil:
    section.add "pageSize", valid_579963
  var valid_579964 = query.getOrDefault("alt")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = newJString("json"))
  if valid_579964 != nil:
    section.add "alt", valid_579964
  var valid_579965 = query.getOrDefault("uploadType")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "uploadType", valid_579965
  var valid_579966 = query.getOrDefault("parent")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "parent", valid_579966
  var valid_579967 = query.getOrDefault("quotaUser")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "quotaUser", valid_579967
  var valid_579968 = query.getOrDefault("pageToken")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "pageToken", valid_579968
  var valid_579969 = query.getOrDefault("callback")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "callback", valid_579969
  var valid_579970 = query.getOrDefault("fields")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "fields", valid_579970
  var valid_579971 = query.getOrDefault("access_token")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "access_token", valid_579971
  var valid_579972 = query.getOrDefault("upload_protocol")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "upload_protocol", valid_579972
  var valid_579973 = query.getOrDefault("showDeleted")
  valid_579973 = validateParameter(valid_579973, JBool, required = false, default = nil)
  if valid_579973 != nil:
    section.add "showDeleted", valid_579973
  var valid_579974 = query.getOrDefault("view")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_579974 != nil:
    section.add "view", valid_579974
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579975: Call_IamRolesList_579956; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Roles defined on a resource.
  ## 
  let valid = call_579975.validator(path, query, header, formData, body)
  let scheme = call_579975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579975.url(scheme.get, call_579975.host, call_579975.base,
                         call_579975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579975, url, valid)

proc call*(call_579976: Call_IamRolesList_579956; key: string = "";
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
  var query_579977 = newJObject()
  add(query_579977, "key", newJString(key))
  add(query_579977, "prettyPrint", newJBool(prettyPrint))
  add(query_579977, "oauth_token", newJString(oauthToken))
  add(query_579977, "$.xgafv", newJString(Xgafv))
  add(query_579977, "pageSize", newJInt(pageSize))
  add(query_579977, "alt", newJString(alt))
  add(query_579977, "uploadType", newJString(uploadType))
  add(query_579977, "parent", newJString(parent))
  add(query_579977, "quotaUser", newJString(quotaUser))
  add(query_579977, "pageToken", newJString(pageToken))
  add(query_579977, "callback", newJString(callback))
  add(query_579977, "fields", newJString(fields))
  add(query_579977, "access_token", newJString(accessToken))
  add(query_579977, "upload_protocol", newJString(uploadProtocol))
  add(query_579977, "showDeleted", newJBool(showDeleted))
  add(query_579977, "view", newJString(view))
  result = call_579976.call(nil, query_579977, nil, nil, nil)

var iamRolesList* = Call_IamRolesList_579956(name: "iamRolesList",
    meth: HttpMethod.HttpGet, host: "iam.googleapis.com", route: "/v1/roles",
    validator: validate_IamRolesList_579957, base: "/", url: url_IamRolesList_579958,
    schemes: {Scheme.Https})
type
  Call_IamRolesQueryGrantableRoles_579978 = ref object of OpenApiRestCall_579373
proc url_IamRolesQueryGrantableRoles_579980(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_IamRolesQueryGrantableRoles_579979(path: JsonNode; query: JsonNode;
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
  var valid_579981 = query.getOrDefault("key")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "key", valid_579981
  var valid_579982 = query.getOrDefault("prettyPrint")
  valid_579982 = validateParameter(valid_579982, JBool, required = false,
                                 default = newJBool(true))
  if valid_579982 != nil:
    section.add "prettyPrint", valid_579982
  var valid_579983 = query.getOrDefault("oauth_token")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "oauth_token", valid_579983
  var valid_579984 = query.getOrDefault("$.xgafv")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = newJString("1"))
  if valid_579984 != nil:
    section.add "$.xgafv", valid_579984
  var valid_579985 = query.getOrDefault("alt")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = newJString("json"))
  if valid_579985 != nil:
    section.add "alt", valid_579985
  var valid_579986 = query.getOrDefault("uploadType")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "uploadType", valid_579986
  var valid_579987 = query.getOrDefault("quotaUser")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "quotaUser", valid_579987
  var valid_579988 = query.getOrDefault("callback")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "callback", valid_579988
  var valid_579989 = query.getOrDefault("fields")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "fields", valid_579989
  var valid_579990 = query.getOrDefault("access_token")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "access_token", valid_579990
  var valid_579991 = query.getOrDefault("upload_protocol")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "upload_protocol", valid_579991
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

proc call*(call_579993: Call_IamRolesQueryGrantableRoles_579978; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Queries roles that can be granted on a particular resource.
  ## A role is grantable if it can be used as the role in a binding for a policy
  ## for that resource.
  ## 
  let valid = call_579993.validator(path, query, header, formData, body)
  let scheme = call_579993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579993.url(scheme.get, call_579993.host, call_579993.base,
                         call_579993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579993, url, valid)

proc call*(call_579994: Call_IamRolesQueryGrantableRoles_579978; key: string = "";
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
  var query_579995 = newJObject()
  var body_579996 = newJObject()
  add(query_579995, "key", newJString(key))
  add(query_579995, "prettyPrint", newJBool(prettyPrint))
  add(query_579995, "oauth_token", newJString(oauthToken))
  add(query_579995, "$.xgafv", newJString(Xgafv))
  add(query_579995, "alt", newJString(alt))
  add(query_579995, "uploadType", newJString(uploadType))
  add(query_579995, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579996 = body
  add(query_579995, "callback", newJString(callback))
  add(query_579995, "fields", newJString(fields))
  add(query_579995, "access_token", newJString(accessToken))
  add(query_579995, "upload_protocol", newJString(uploadProtocol))
  result = call_579994.call(nil, query_579995, nil, nil, body_579996)

var iamRolesQueryGrantableRoles* = Call_IamRolesQueryGrantableRoles_579978(
    name: "iamRolesQueryGrantableRoles", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/roles:queryGrantableRoles",
    validator: validate_IamRolesQueryGrantableRoles_579979, base: "/",
    url: url_IamRolesQueryGrantableRoles_579980, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsUpdate_580031 = ref object of OpenApiRestCall_579373
proc url_IamProjectsServiceAccountsUpdate_580033(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_IamProjectsServiceAccountsUpdate_580032(path: JsonNode;
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
  var valid_580034 = path.getOrDefault("name")
  valid_580034 = validateParameter(valid_580034, JString, required = true,
                                 default = nil)
  if valid_580034 != nil:
    section.add "name", valid_580034
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
  var valid_580035 = query.getOrDefault("key")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "key", valid_580035
  var valid_580036 = query.getOrDefault("prettyPrint")
  valid_580036 = validateParameter(valid_580036, JBool, required = false,
                                 default = newJBool(true))
  if valid_580036 != nil:
    section.add "prettyPrint", valid_580036
  var valid_580037 = query.getOrDefault("oauth_token")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "oauth_token", valid_580037
  var valid_580038 = query.getOrDefault("$.xgafv")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = newJString("1"))
  if valid_580038 != nil:
    section.add "$.xgafv", valid_580038
  var valid_580039 = query.getOrDefault("alt")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = newJString("json"))
  if valid_580039 != nil:
    section.add "alt", valid_580039
  var valid_580040 = query.getOrDefault("uploadType")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "uploadType", valid_580040
  var valid_580041 = query.getOrDefault("quotaUser")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "quotaUser", valid_580041
  var valid_580042 = query.getOrDefault("callback")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "callback", valid_580042
  var valid_580043 = query.getOrDefault("fields")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "fields", valid_580043
  var valid_580044 = query.getOrDefault("access_token")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "access_token", valid_580044
  var valid_580045 = query.getOrDefault("upload_protocol")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "upload_protocol", valid_580045
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

proc call*(call_580047: Call_IamProjectsServiceAccountsUpdate_580031;
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
  let valid = call_580047.validator(path, query, header, formData, body)
  let scheme = call_580047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580047.url(scheme.get, call_580047.host, call_580047.base,
                         call_580047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580047, url, valid)

proc call*(call_580048: Call_IamProjectsServiceAccountsUpdate_580031; name: string;
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
  var path_580049 = newJObject()
  var query_580050 = newJObject()
  var body_580051 = newJObject()
  add(query_580050, "key", newJString(key))
  add(query_580050, "prettyPrint", newJBool(prettyPrint))
  add(query_580050, "oauth_token", newJString(oauthToken))
  add(query_580050, "$.xgafv", newJString(Xgafv))
  add(query_580050, "alt", newJString(alt))
  add(query_580050, "uploadType", newJString(uploadType))
  add(query_580050, "quotaUser", newJString(quotaUser))
  add(path_580049, "name", newJString(name))
  if body != nil:
    body_580051 = body
  add(query_580050, "callback", newJString(callback))
  add(query_580050, "fields", newJString(fields))
  add(query_580050, "access_token", newJString(accessToken))
  add(query_580050, "upload_protocol", newJString(uploadProtocol))
  result = call_580048.call(path_580049, query_580050, nil, nil, body_580051)

var iamProjectsServiceAccountsUpdate* = Call_IamProjectsServiceAccountsUpdate_580031(
    name: "iamProjectsServiceAccountsUpdate", meth: HttpMethod.HttpPut,
    host: "iam.googleapis.com", route: "/v1/{name}",
    validator: validate_IamProjectsServiceAccountsUpdate_580032, base: "/",
    url: url_IamProjectsServiceAccountsUpdate_580033, schemes: {Scheme.Https})
type
  Call_IamOrganizationsRolesGet_579997 = ref object of OpenApiRestCall_579373
proc url_IamOrganizationsRolesGet_579999(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_IamOrganizationsRolesGet_579998(path: JsonNode; query: JsonNode;
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
  var valid_580014 = path.getOrDefault("name")
  valid_580014 = validateParameter(valid_580014, JString, required = true,
                                 default = nil)
  if valid_580014 != nil:
    section.add "name", valid_580014
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
  var valid_580015 = query.getOrDefault("key")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "key", valid_580015
  var valid_580016 = query.getOrDefault("prettyPrint")
  valid_580016 = validateParameter(valid_580016, JBool, required = false,
                                 default = newJBool(true))
  if valid_580016 != nil:
    section.add "prettyPrint", valid_580016
  var valid_580017 = query.getOrDefault("oauth_token")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "oauth_token", valid_580017
  var valid_580018 = query.getOrDefault("$.xgafv")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = newJString("1"))
  if valid_580018 != nil:
    section.add "$.xgafv", valid_580018
  var valid_580019 = query.getOrDefault("alt")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = newJString("json"))
  if valid_580019 != nil:
    section.add "alt", valid_580019
  var valid_580020 = query.getOrDefault("uploadType")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "uploadType", valid_580020
  var valid_580021 = query.getOrDefault("quotaUser")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "quotaUser", valid_580021
  var valid_580022 = query.getOrDefault("publicKeyType")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = newJString("TYPE_NONE"))
  if valid_580022 != nil:
    section.add "publicKeyType", valid_580022
  var valid_580023 = query.getOrDefault("callback")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "callback", valid_580023
  var valid_580024 = query.getOrDefault("fields")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "fields", valid_580024
  var valid_580025 = query.getOrDefault("access_token")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "access_token", valid_580025
  var valid_580026 = query.getOrDefault("upload_protocol")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "upload_protocol", valid_580026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580027: Call_IamOrganizationsRolesGet_579997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a Role definition.
  ## 
  let valid = call_580027.validator(path, query, header, formData, body)
  let scheme = call_580027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580027.url(scheme.get, call_580027.host, call_580027.base,
                         call_580027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580027, url, valid)

proc call*(call_580028: Call_IamOrganizationsRolesGet_579997; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; publicKeyType: string = "TYPE_NONE";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## iamOrganizationsRolesGet
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
  var path_580029 = newJObject()
  var query_580030 = newJObject()
  add(query_580030, "key", newJString(key))
  add(query_580030, "prettyPrint", newJBool(prettyPrint))
  add(query_580030, "oauth_token", newJString(oauthToken))
  add(query_580030, "$.xgafv", newJString(Xgafv))
  add(query_580030, "alt", newJString(alt))
  add(query_580030, "uploadType", newJString(uploadType))
  add(query_580030, "quotaUser", newJString(quotaUser))
  add(path_580029, "name", newJString(name))
  add(query_580030, "publicKeyType", newJString(publicKeyType))
  add(query_580030, "callback", newJString(callback))
  add(query_580030, "fields", newJString(fields))
  add(query_580030, "access_token", newJString(accessToken))
  add(query_580030, "upload_protocol", newJString(uploadProtocol))
  result = call_580028.call(path_580029, query_580030, nil, nil, nil)

var iamOrganizationsRolesGet* = Call_IamOrganizationsRolesGet_579997(
    name: "iamOrganizationsRolesGet", meth: HttpMethod.HttpGet,
    host: "iam.googleapis.com", route: "/v1/{name}",
    validator: validate_IamOrganizationsRolesGet_579998, base: "/",
    url: url_IamOrganizationsRolesGet_579999, schemes: {Scheme.Https})
type
  Call_IamOrganizationsRolesPatch_580072 = ref object of OpenApiRestCall_579373
proc url_IamOrganizationsRolesPatch_580074(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_IamOrganizationsRolesPatch_580073(path: JsonNode; query: JsonNode;
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
  var valid_580075 = path.getOrDefault("name")
  valid_580075 = validateParameter(valid_580075, JString, required = true,
                                 default = nil)
  if valid_580075 != nil:
    section.add "name", valid_580075
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
  var valid_580076 = query.getOrDefault("key")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "key", valid_580076
  var valid_580077 = query.getOrDefault("prettyPrint")
  valid_580077 = validateParameter(valid_580077, JBool, required = false,
                                 default = newJBool(true))
  if valid_580077 != nil:
    section.add "prettyPrint", valid_580077
  var valid_580078 = query.getOrDefault("oauth_token")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "oauth_token", valid_580078
  var valid_580079 = query.getOrDefault("$.xgafv")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = newJString("1"))
  if valid_580079 != nil:
    section.add "$.xgafv", valid_580079
  var valid_580080 = query.getOrDefault("alt")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = newJString("json"))
  if valid_580080 != nil:
    section.add "alt", valid_580080
  var valid_580081 = query.getOrDefault("uploadType")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "uploadType", valid_580081
  var valid_580082 = query.getOrDefault("quotaUser")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "quotaUser", valid_580082
  var valid_580083 = query.getOrDefault("updateMask")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "updateMask", valid_580083
  var valid_580084 = query.getOrDefault("callback")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "callback", valid_580084
  var valid_580085 = query.getOrDefault("fields")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "fields", valid_580085
  var valid_580086 = query.getOrDefault("access_token")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "access_token", valid_580086
  var valid_580087 = query.getOrDefault("upload_protocol")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "upload_protocol", valid_580087
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

proc call*(call_580089: Call_IamOrganizationsRolesPatch_580072; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a Role definition.
  ## 
  let valid = call_580089.validator(path, query, header, formData, body)
  let scheme = call_580089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580089.url(scheme.get, call_580089.host, call_580089.base,
                         call_580089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580089, url, valid)

proc call*(call_580090: Call_IamOrganizationsRolesPatch_580072; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; updateMask: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## iamOrganizationsRolesPatch
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
  var path_580091 = newJObject()
  var query_580092 = newJObject()
  var body_580093 = newJObject()
  add(query_580092, "key", newJString(key))
  add(query_580092, "prettyPrint", newJBool(prettyPrint))
  add(query_580092, "oauth_token", newJString(oauthToken))
  add(query_580092, "$.xgafv", newJString(Xgafv))
  add(query_580092, "alt", newJString(alt))
  add(query_580092, "uploadType", newJString(uploadType))
  add(query_580092, "quotaUser", newJString(quotaUser))
  add(path_580091, "name", newJString(name))
  add(query_580092, "updateMask", newJString(updateMask))
  if body != nil:
    body_580093 = body
  add(query_580092, "callback", newJString(callback))
  add(query_580092, "fields", newJString(fields))
  add(query_580092, "access_token", newJString(accessToken))
  add(query_580092, "upload_protocol", newJString(uploadProtocol))
  result = call_580090.call(path_580091, query_580092, nil, nil, body_580093)

var iamOrganizationsRolesPatch* = Call_IamOrganizationsRolesPatch_580072(
    name: "iamOrganizationsRolesPatch", meth: HttpMethod.HttpPatch,
    host: "iam.googleapis.com", route: "/v1/{name}",
    validator: validate_IamOrganizationsRolesPatch_580073, base: "/",
    url: url_IamOrganizationsRolesPatch_580074, schemes: {Scheme.Https})
type
  Call_IamOrganizationsRolesDelete_580052 = ref object of OpenApiRestCall_579373
proc url_IamOrganizationsRolesDelete_580054(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_IamOrganizationsRolesDelete_580053(path: JsonNode; query: JsonNode;
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
  var valid_580055 = path.getOrDefault("name")
  valid_580055 = validateParameter(valid_580055, JString, required = true,
                                 default = nil)
  if valid_580055 != nil:
    section.add "name", valid_580055
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
  var valid_580056 = query.getOrDefault("key")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "key", valid_580056
  var valid_580057 = query.getOrDefault("prettyPrint")
  valid_580057 = validateParameter(valid_580057, JBool, required = false,
                                 default = newJBool(true))
  if valid_580057 != nil:
    section.add "prettyPrint", valid_580057
  var valid_580058 = query.getOrDefault("oauth_token")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "oauth_token", valid_580058
  var valid_580059 = query.getOrDefault("$.xgafv")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = newJString("1"))
  if valid_580059 != nil:
    section.add "$.xgafv", valid_580059
  var valid_580060 = query.getOrDefault("etag")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "etag", valid_580060
  var valid_580061 = query.getOrDefault("alt")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = newJString("json"))
  if valid_580061 != nil:
    section.add "alt", valid_580061
  var valid_580062 = query.getOrDefault("uploadType")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "uploadType", valid_580062
  var valid_580063 = query.getOrDefault("quotaUser")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "quotaUser", valid_580063
  var valid_580064 = query.getOrDefault("callback")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "callback", valid_580064
  var valid_580065 = query.getOrDefault("fields")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "fields", valid_580065
  var valid_580066 = query.getOrDefault("access_token")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "access_token", valid_580066
  var valid_580067 = query.getOrDefault("upload_protocol")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "upload_protocol", valid_580067
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580068: Call_IamOrganizationsRolesDelete_580052; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Soft deletes a role. The role is suspended and cannot be used to create new
  ## IAM Policy Bindings.
  ## The Role will not be included in `ListRoles()` unless `show_deleted` is set
  ## in the `ListRolesRequest`. The Role contains the deleted boolean set.
  ## Existing Bindings remains, but are inactive. The Role can be undeleted
  ## within 7 days. After 7 days the Role is deleted and all Bindings associated
  ## with the role are removed.
  ## 
  let valid = call_580068.validator(path, query, header, formData, body)
  let scheme = call_580068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580068.url(scheme.get, call_580068.host, call_580068.base,
                         call_580068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580068, url, valid)

proc call*(call_580069: Call_IamOrganizationsRolesDelete_580052; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; etag: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## iamOrganizationsRolesDelete
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
  var path_580070 = newJObject()
  var query_580071 = newJObject()
  add(query_580071, "key", newJString(key))
  add(query_580071, "prettyPrint", newJBool(prettyPrint))
  add(query_580071, "oauth_token", newJString(oauthToken))
  add(query_580071, "$.xgafv", newJString(Xgafv))
  add(query_580071, "etag", newJString(etag))
  add(query_580071, "alt", newJString(alt))
  add(query_580071, "uploadType", newJString(uploadType))
  add(query_580071, "quotaUser", newJString(quotaUser))
  add(path_580070, "name", newJString(name))
  add(query_580071, "callback", newJString(callback))
  add(query_580071, "fields", newJString(fields))
  add(query_580071, "access_token", newJString(accessToken))
  add(query_580071, "upload_protocol", newJString(uploadProtocol))
  result = call_580069.call(path_580070, query_580071, nil, nil, nil)

var iamOrganizationsRolesDelete* = Call_IamOrganizationsRolesDelete_580052(
    name: "iamOrganizationsRolesDelete", meth: HttpMethod.HttpDelete,
    host: "iam.googleapis.com", route: "/v1/{name}",
    validator: validate_IamOrganizationsRolesDelete_580053, base: "/",
    url: url_IamOrganizationsRolesDelete_580054, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsKeysCreate_580114 = ref object of OpenApiRestCall_579373
proc url_IamProjectsServiceAccountsKeysCreate_580116(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_IamProjectsServiceAccountsKeysCreate_580115(path: JsonNode;
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
  var valid_580117 = path.getOrDefault("name")
  valid_580117 = validateParameter(valid_580117, JString, required = true,
                                 default = nil)
  if valid_580117 != nil:
    section.add "name", valid_580117
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
  var valid_580118 = query.getOrDefault("key")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "key", valid_580118
  var valid_580119 = query.getOrDefault("prettyPrint")
  valid_580119 = validateParameter(valid_580119, JBool, required = false,
                                 default = newJBool(true))
  if valid_580119 != nil:
    section.add "prettyPrint", valid_580119
  var valid_580120 = query.getOrDefault("oauth_token")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "oauth_token", valid_580120
  var valid_580121 = query.getOrDefault("$.xgafv")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = newJString("1"))
  if valid_580121 != nil:
    section.add "$.xgafv", valid_580121
  var valid_580122 = query.getOrDefault("alt")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = newJString("json"))
  if valid_580122 != nil:
    section.add "alt", valid_580122
  var valid_580123 = query.getOrDefault("uploadType")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "uploadType", valid_580123
  var valid_580124 = query.getOrDefault("quotaUser")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "quotaUser", valid_580124
  var valid_580125 = query.getOrDefault("callback")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = nil)
  if valid_580125 != nil:
    section.add "callback", valid_580125
  var valid_580126 = query.getOrDefault("fields")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "fields", valid_580126
  var valid_580127 = query.getOrDefault("access_token")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "access_token", valid_580127
  var valid_580128 = query.getOrDefault("upload_protocol")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "upload_protocol", valid_580128
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

proc call*(call_580130: Call_IamProjectsServiceAccountsKeysCreate_580114;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a ServiceAccountKey
  ## and returns it.
  ## 
  let valid = call_580130.validator(path, query, header, formData, body)
  let scheme = call_580130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580130.url(scheme.get, call_580130.host, call_580130.base,
                         call_580130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580130, url, valid)

proc call*(call_580131: Call_IamProjectsServiceAccountsKeysCreate_580114;
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
  var path_580132 = newJObject()
  var query_580133 = newJObject()
  var body_580134 = newJObject()
  add(query_580133, "key", newJString(key))
  add(query_580133, "prettyPrint", newJBool(prettyPrint))
  add(query_580133, "oauth_token", newJString(oauthToken))
  add(query_580133, "$.xgafv", newJString(Xgafv))
  add(query_580133, "alt", newJString(alt))
  add(query_580133, "uploadType", newJString(uploadType))
  add(query_580133, "quotaUser", newJString(quotaUser))
  add(path_580132, "name", newJString(name))
  if body != nil:
    body_580134 = body
  add(query_580133, "callback", newJString(callback))
  add(query_580133, "fields", newJString(fields))
  add(query_580133, "access_token", newJString(accessToken))
  add(query_580133, "upload_protocol", newJString(uploadProtocol))
  result = call_580131.call(path_580132, query_580133, nil, nil, body_580134)

var iamProjectsServiceAccountsKeysCreate* = Call_IamProjectsServiceAccountsKeysCreate_580114(
    name: "iamProjectsServiceAccountsKeysCreate", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}/keys",
    validator: validate_IamProjectsServiceAccountsKeysCreate_580115, base: "/",
    url: url_IamProjectsServiceAccountsKeysCreate_580116, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsKeysList_580094 = ref object of OpenApiRestCall_579373
proc url_IamProjectsServiceAccountsKeysList_580096(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_IamProjectsServiceAccountsKeysList_580095(path: JsonNode;
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
  var valid_580097 = path.getOrDefault("name")
  valid_580097 = validateParameter(valid_580097, JString, required = true,
                                 default = nil)
  if valid_580097 != nil:
    section.add "name", valid_580097
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
  var valid_580098 = query.getOrDefault("key")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "key", valid_580098
  var valid_580099 = query.getOrDefault("prettyPrint")
  valid_580099 = validateParameter(valid_580099, JBool, required = false,
                                 default = newJBool(true))
  if valid_580099 != nil:
    section.add "prettyPrint", valid_580099
  var valid_580100 = query.getOrDefault("oauth_token")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "oauth_token", valid_580100
  var valid_580101 = query.getOrDefault("$.xgafv")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = newJString("1"))
  if valid_580101 != nil:
    section.add "$.xgafv", valid_580101
  var valid_580102 = query.getOrDefault("keyTypes")
  valid_580102 = validateParameter(valid_580102, JArray, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "keyTypes", valid_580102
  var valid_580103 = query.getOrDefault("alt")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = newJString("json"))
  if valid_580103 != nil:
    section.add "alt", valid_580103
  var valid_580104 = query.getOrDefault("uploadType")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "uploadType", valid_580104
  var valid_580105 = query.getOrDefault("quotaUser")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "quotaUser", valid_580105
  var valid_580106 = query.getOrDefault("callback")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "callback", valid_580106
  var valid_580107 = query.getOrDefault("fields")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "fields", valid_580107
  var valid_580108 = query.getOrDefault("access_token")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "access_token", valid_580108
  var valid_580109 = query.getOrDefault("upload_protocol")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "upload_protocol", valid_580109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580110: Call_IamProjectsServiceAccountsKeysList_580094;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists ServiceAccountKeys.
  ## 
  let valid = call_580110.validator(path, query, header, formData, body)
  let scheme = call_580110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580110.url(scheme.get, call_580110.host, call_580110.base,
                         call_580110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580110, url, valid)

proc call*(call_580111: Call_IamProjectsServiceAccountsKeysList_580094;
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
  var path_580112 = newJObject()
  var query_580113 = newJObject()
  add(query_580113, "key", newJString(key))
  add(query_580113, "prettyPrint", newJBool(prettyPrint))
  add(query_580113, "oauth_token", newJString(oauthToken))
  add(query_580113, "$.xgafv", newJString(Xgafv))
  if keyTypes != nil:
    query_580113.add "keyTypes", keyTypes
  add(query_580113, "alt", newJString(alt))
  add(query_580113, "uploadType", newJString(uploadType))
  add(query_580113, "quotaUser", newJString(quotaUser))
  add(path_580112, "name", newJString(name))
  add(query_580113, "callback", newJString(callback))
  add(query_580113, "fields", newJString(fields))
  add(query_580113, "access_token", newJString(accessToken))
  add(query_580113, "upload_protocol", newJString(uploadProtocol))
  result = call_580111.call(path_580112, query_580113, nil, nil, nil)

var iamProjectsServiceAccountsKeysList* = Call_IamProjectsServiceAccountsKeysList_580094(
    name: "iamProjectsServiceAccountsKeysList", meth: HttpMethod.HttpGet,
    host: "iam.googleapis.com", route: "/v1/{name}/keys",
    validator: validate_IamProjectsServiceAccountsKeysList_580095, base: "/",
    url: url_IamProjectsServiceAccountsKeysList_580096, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsKeysUpload_580135 = ref object of OpenApiRestCall_579373
proc url_IamProjectsServiceAccountsKeysUpload_580137(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_IamProjectsServiceAccountsKeysUpload_580136(path: JsonNode;
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
  var valid_580138 = path.getOrDefault("name")
  valid_580138 = validateParameter(valid_580138, JString, required = true,
                                 default = nil)
  if valid_580138 != nil:
    section.add "name", valid_580138
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
  var valid_580139 = query.getOrDefault("key")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "key", valid_580139
  var valid_580140 = query.getOrDefault("prettyPrint")
  valid_580140 = validateParameter(valid_580140, JBool, required = false,
                                 default = newJBool(true))
  if valid_580140 != nil:
    section.add "prettyPrint", valid_580140
  var valid_580141 = query.getOrDefault("oauth_token")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "oauth_token", valid_580141
  var valid_580142 = query.getOrDefault("$.xgafv")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = newJString("1"))
  if valid_580142 != nil:
    section.add "$.xgafv", valid_580142
  var valid_580143 = query.getOrDefault("alt")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = newJString("json"))
  if valid_580143 != nil:
    section.add "alt", valid_580143
  var valid_580144 = query.getOrDefault("uploadType")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "uploadType", valid_580144
  var valid_580145 = query.getOrDefault("quotaUser")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "quotaUser", valid_580145
  var valid_580146 = query.getOrDefault("callback")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "callback", valid_580146
  var valid_580147 = query.getOrDefault("fields")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "fields", valid_580147
  var valid_580148 = query.getOrDefault("access_token")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "access_token", valid_580148
  var valid_580149 = query.getOrDefault("upload_protocol")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "upload_protocol", valid_580149
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

proc call*(call_580151: Call_IamProjectsServiceAccountsKeysUpload_580135;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Upload public key for a given service account.
  ## This rpc will create a
  ## ServiceAccountKey that has the
  ## provided public key and returns it.
  ## 
  let valid = call_580151.validator(path, query, header, formData, body)
  let scheme = call_580151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580151.url(scheme.get, call_580151.host, call_580151.base,
                         call_580151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580151, url, valid)

proc call*(call_580152: Call_IamProjectsServiceAccountsKeysUpload_580135;
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
  var path_580153 = newJObject()
  var query_580154 = newJObject()
  var body_580155 = newJObject()
  add(query_580154, "key", newJString(key))
  add(query_580154, "prettyPrint", newJBool(prettyPrint))
  add(query_580154, "oauth_token", newJString(oauthToken))
  add(query_580154, "$.xgafv", newJString(Xgafv))
  add(query_580154, "alt", newJString(alt))
  add(query_580154, "uploadType", newJString(uploadType))
  add(query_580154, "quotaUser", newJString(quotaUser))
  add(path_580153, "name", newJString(name))
  if body != nil:
    body_580155 = body
  add(query_580154, "callback", newJString(callback))
  add(query_580154, "fields", newJString(fields))
  add(query_580154, "access_token", newJString(accessToken))
  add(query_580154, "upload_protocol", newJString(uploadProtocol))
  result = call_580152.call(path_580153, query_580154, nil, nil, body_580155)

var iamProjectsServiceAccountsKeysUpload* = Call_IamProjectsServiceAccountsKeysUpload_580135(
    name: "iamProjectsServiceAccountsKeysUpload", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}/keys:upload",
    validator: validate_IamProjectsServiceAccountsKeysUpload_580136, base: "/",
    url: url_IamProjectsServiceAccountsKeysUpload_580137, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsCreate_580177 = ref object of OpenApiRestCall_579373
proc url_IamProjectsServiceAccountsCreate_580179(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_IamProjectsServiceAccountsCreate_580178(path: JsonNode;
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
  var valid_580180 = path.getOrDefault("name")
  valid_580180 = validateParameter(valid_580180, JString, required = true,
                                 default = nil)
  if valid_580180 != nil:
    section.add "name", valid_580180
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
  var valid_580181 = query.getOrDefault("key")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "key", valid_580181
  var valid_580182 = query.getOrDefault("prettyPrint")
  valid_580182 = validateParameter(valid_580182, JBool, required = false,
                                 default = newJBool(true))
  if valid_580182 != nil:
    section.add "prettyPrint", valid_580182
  var valid_580183 = query.getOrDefault("oauth_token")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "oauth_token", valid_580183
  var valid_580184 = query.getOrDefault("$.xgafv")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = newJString("1"))
  if valid_580184 != nil:
    section.add "$.xgafv", valid_580184
  var valid_580185 = query.getOrDefault("alt")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = newJString("json"))
  if valid_580185 != nil:
    section.add "alt", valid_580185
  var valid_580186 = query.getOrDefault("uploadType")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "uploadType", valid_580186
  var valid_580187 = query.getOrDefault("quotaUser")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "quotaUser", valid_580187
  var valid_580188 = query.getOrDefault("callback")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "callback", valid_580188
  var valid_580189 = query.getOrDefault("fields")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "fields", valid_580189
  var valid_580190 = query.getOrDefault("access_token")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "access_token", valid_580190
  var valid_580191 = query.getOrDefault("upload_protocol")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "upload_protocol", valid_580191
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

proc call*(call_580193: Call_IamProjectsServiceAccountsCreate_580177;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a ServiceAccount
  ## and returns it.
  ## 
  let valid = call_580193.validator(path, query, header, formData, body)
  let scheme = call_580193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580193.url(scheme.get, call_580193.host, call_580193.base,
                         call_580193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580193, url, valid)

proc call*(call_580194: Call_IamProjectsServiceAccountsCreate_580177; name: string;
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
  var path_580195 = newJObject()
  var query_580196 = newJObject()
  var body_580197 = newJObject()
  add(query_580196, "key", newJString(key))
  add(query_580196, "prettyPrint", newJBool(prettyPrint))
  add(query_580196, "oauth_token", newJString(oauthToken))
  add(query_580196, "$.xgafv", newJString(Xgafv))
  add(query_580196, "alt", newJString(alt))
  add(query_580196, "uploadType", newJString(uploadType))
  add(query_580196, "quotaUser", newJString(quotaUser))
  add(path_580195, "name", newJString(name))
  if body != nil:
    body_580197 = body
  add(query_580196, "callback", newJString(callback))
  add(query_580196, "fields", newJString(fields))
  add(query_580196, "access_token", newJString(accessToken))
  add(query_580196, "upload_protocol", newJString(uploadProtocol))
  result = call_580194.call(path_580195, query_580196, nil, nil, body_580197)

var iamProjectsServiceAccountsCreate* = Call_IamProjectsServiceAccountsCreate_580177(
    name: "iamProjectsServiceAccountsCreate", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}/serviceAccounts",
    validator: validate_IamProjectsServiceAccountsCreate_580178, base: "/",
    url: url_IamProjectsServiceAccountsCreate_580179, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsList_580156 = ref object of OpenApiRestCall_579373
proc url_IamProjectsServiceAccountsList_580158(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_IamProjectsServiceAccountsList_580157(path: JsonNode;
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
  var valid_580159 = path.getOrDefault("name")
  valid_580159 = validateParameter(valid_580159, JString, required = true,
                                 default = nil)
  if valid_580159 != nil:
    section.add "name", valid_580159
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
  var valid_580160 = query.getOrDefault("key")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "key", valid_580160
  var valid_580161 = query.getOrDefault("prettyPrint")
  valid_580161 = validateParameter(valid_580161, JBool, required = false,
                                 default = newJBool(true))
  if valid_580161 != nil:
    section.add "prettyPrint", valid_580161
  var valid_580162 = query.getOrDefault("oauth_token")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "oauth_token", valid_580162
  var valid_580163 = query.getOrDefault("$.xgafv")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = newJString("1"))
  if valid_580163 != nil:
    section.add "$.xgafv", valid_580163
  var valid_580164 = query.getOrDefault("pageSize")
  valid_580164 = validateParameter(valid_580164, JInt, required = false, default = nil)
  if valid_580164 != nil:
    section.add "pageSize", valid_580164
  var valid_580165 = query.getOrDefault("alt")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = newJString("json"))
  if valid_580165 != nil:
    section.add "alt", valid_580165
  var valid_580166 = query.getOrDefault("uploadType")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "uploadType", valid_580166
  var valid_580167 = query.getOrDefault("quotaUser")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "quotaUser", valid_580167
  var valid_580168 = query.getOrDefault("pageToken")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "pageToken", valid_580168
  var valid_580169 = query.getOrDefault("callback")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "callback", valid_580169
  var valid_580170 = query.getOrDefault("fields")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "fields", valid_580170
  var valid_580171 = query.getOrDefault("access_token")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "access_token", valid_580171
  var valid_580172 = query.getOrDefault("upload_protocol")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "upload_protocol", valid_580172
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580173: Call_IamProjectsServiceAccountsList_580156; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists ServiceAccounts for a project.
  ## 
  let valid = call_580173.validator(path, query, header, formData, body)
  let scheme = call_580173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580173.url(scheme.get, call_580173.host, call_580173.base,
                         call_580173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580173, url, valid)

proc call*(call_580174: Call_IamProjectsServiceAccountsList_580156; name: string;
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
  var path_580175 = newJObject()
  var query_580176 = newJObject()
  add(query_580176, "key", newJString(key))
  add(query_580176, "prettyPrint", newJBool(prettyPrint))
  add(query_580176, "oauth_token", newJString(oauthToken))
  add(query_580176, "$.xgafv", newJString(Xgafv))
  add(query_580176, "pageSize", newJInt(pageSize))
  add(query_580176, "alt", newJString(alt))
  add(query_580176, "uploadType", newJString(uploadType))
  add(query_580176, "quotaUser", newJString(quotaUser))
  add(path_580175, "name", newJString(name))
  add(query_580176, "pageToken", newJString(pageToken))
  add(query_580176, "callback", newJString(callback))
  add(query_580176, "fields", newJString(fields))
  add(query_580176, "access_token", newJString(accessToken))
  add(query_580176, "upload_protocol", newJString(uploadProtocol))
  result = call_580174.call(path_580175, query_580176, nil, nil, nil)

var iamProjectsServiceAccountsList* = Call_IamProjectsServiceAccountsList_580156(
    name: "iamProjectsServiceAccountsList", meth: HttpMethod.HttpGet,
    host: "iam.googleapis.com", route: "/v1/{name}/serviceAccounts",
    validator: validate_IamProjectsServiceAccountsList_580157, base: "/",
    url: url_IamProjectsServiceAccountsList_580158, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsDisable_580198 = ref object of OpenApiRestCall_579373
proc url_IamProjectsServiceAccountsDisable_580200(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_IamProjectsServiceAccountsDisable_580199(path: JsonNode;
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
  var valid_580201 = path.getOrDefault("name")
  valid_580201 = validateParameter(valid_580201, JString, required = true,
                                 default = nil)
  if valid_580201 != nil:
    section.add "name", valid_580201
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
  var valid_580202 = query.getOrDefault("key")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "key", valid_580202
  var valid_580203 = query.getOrDefault("prettyPrint")
  valid_580203 = validateParameter(valid_580203, JBool, required = false,
                                 default = newJBool(true))
  if valid_580203 != nil:
    section.add "prettyPrint", valid_580203
  var valid_580204 = query.getOrDefault("oauth_token")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "oauth_token", valid_580204
  var valid_580205 = query.getOrDefault("$.xgafv")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = newJString("1"))
  if valid_580205 != nil:
    section.add "$.xgafv", valid_580205
  var valid_580206 = query.getOrDefault("alt")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = newJString("json"))
  if valid_580206 != nil:
    section.add "alt", valid_580206
  var valid_580207 = query.getOrDefault("uploadType")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "uploadType", valid_580207
  var valid_580208 = query.getOrDefault("quotaUser")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "quotaUser", valid_580208
  var valid_580209 = query.getOrDefault("callback")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "callback", valid_580209
  var valid_580210 = query.getOrDefault("fields")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "fields", valid_580210
  var valid_580211 = query.getOrDefault("access_token")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "access_token", valid_580211
  var valid_580212 = query.getOrDefault("upload_protocol")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "upload_protocol", valid_580212
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

proc call*(call_580214: Call_IamProjectsServiceAccountsDisable_580198;
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
  let valid = call_580214.validator(path, query, header, formData, body)
  let scheme = call_580214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580214.url(scheme.get, call_580214.host, call_580214.base,
                         call_580214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580214, url, valid)

proc call*(call_580215: Call_IamProjectsServiceAccountsDisable_580198;
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
  var path_580216 = newJObject()
  var query_580217 = newJObject()
  var body_580218 = newJObject()
  add(query_580217, "key", newJString(key))
  add(query_580217, "prettyPrint", newJBool(prettyPrint))
  add(query_580217, "oauth_token", newJString(oauthToken))
  add(query_580217, "$.xgafv", newJString(Xgafv))
  add(query_580217, "alt", newJString(alt))
  add(query_580217, "uploadType", newJString(uploadType))
  add(query_580217, "quotaUser", newJString(quotaUser))
  add(path_580216, "name", newJString(name))
  if body != nil:
    body_580218 = body
  add(query_580217, "callback", newJString(callback))
  add(query_580217, "fields", newJString(fields))
  add(query_580217, "access_token", newJString(accessToken))
  add(query_580217, "upload_protocol", newJString(uploadProtocol))
  result = call_580215.call(path_580216, query_580217, nil, nil, body_580218)

var iamProjectsServiceAccountsDisable* = Call_IamProjectsServiceAccountsDisable_580198(
    name: "iamProjectsServiceAccountsDisable", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}:disable",
    validator: validate_IamProjectsServiceAccountsDisable_580199, base: "/",
    url: url_IamProjectsServiceAccountsDisable_580200, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsEnable_580219 = ref object of OpenApiRestCall_579373
proc url_IamProjectsServiceAccountsEnable_580221(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_IamProjectsServiceAccountsEnable_580220(path: JsonNode;
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
  var valid_580222 = path.getOrDefault("name")
  valid_580222 = validateParameter(valid_580222, JString, required = true,
                                 default = nil)
  if valid_580222 != nil:
    section.add "name", valid_580222
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
  var valid_580223 = query.getOrDefault("key")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "key", valid_580223
  var valid_580224 = query.getOrDefault("prettyPrint")
  valid_580224 = validateParameter(valid_580224, JBool, required = false,
                                 default = newJBool(true))
  if valid_580224 != nil:
    section.add "prettyPrint", valid_580224
  var valid_580225 = query.getOrDefault("oauth_token")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "oauth_token", valid_580225
  var valid_580226 = query.getOrDefault("$.xgafv")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = newJString("1"))
  if valid_580226 != nil:
    section.add "$.xgafv", valid_580226
  var valid_580227 = query.getOrDefault("alt")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = newJString("json"))
  if valid_580227 != nil:
    section.add "alt", valid_580227
  var valid_580228 = query.getOrDefault("uploadType")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "uploadType", valid_580228
  var valid_580229 = query.getOrDefault("quotaUser")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "quotaUser", valid_580229
  var valid_580230 = query.getOrDefault("callback")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "callback", valid_580230
  var valid_580231 = query.getOrDefault("fields")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "fields", valid_580231
  var valid_580232 = query.getOrDefault("access_token")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "access_token", valid_580232
  var valid_580233 = query.getOrDefault("upload_protocol")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "upload_protocol", valid_580233
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

proc call*(call_580235: Call_IamProjectsServiceAccountsEnable_580219;
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
  let valid = call_580235.validator(path, query, header, formData, body)
  let scheme = call_580235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580235.url(scheme.get, call_580235.host, call_580235.base,
                         call_580235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580235, url, valid)

proc call*(call_580236: Call_IamProjectsServiceAccountsEnable_580219; name: string;
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
  var path_580237 = newJObject()
  var query_580238 = newJObject()
  var body_580239 = newJObject()
  add(query_580238, "key", newJString(key))
  add(query_580238, "prettyPrint", newJBool(prettyPrint))
  add(query_580238, "oauth_token", newJString(oauthToken))
  add(query_580238, "$.xgafv", newJString(Xgafv))
  add(query_580238, "alt", newJString(alt))
  add(query_580238, "uploadType", newJString(uploadType))
  add(query_580238, "quotaUser", newJString(quotaUser))
  add(path_580237, "name", newJString(name))
  if body != nil:
    body_580239 = body
  add(query_580238, "callback", newJString(callback))
  add(query_580238, "fields", newJString(fields))
  add(query_580238, "access_token", newJString(accessToken))
  add(query_580238, "upload_protocol", newJString(uploadProtocol))
  result = call_580236.call(path_580237, query_580238, nil, nil, body_580239)

var iamProjectsServiceAccountsEnable* = Call_IamProjectsServiceAccountsEnable_580219(
    name: "iamProjectsServiceAccountsEnable", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}:enable",
    validator: validate_IamProjectsServiceAccountsEnable_580220, base: "/",
    url: url_IamProjectsServiceAccountsEnable_580221, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsSignBlob_580240 = ref object of OpenApiRestCall_579373
proc url_IamProjectsServiceAccountsSignBlob_580242(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_IamProjectsServiceAccountsSignBlob_580241(path: JsonNode;
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
  var valid_580243 = path.getOrDefault("name")
  valid_580243 = validateParameter(valid_580243, JString, required = true,
                                 default = nil)
  if valid_580243 != nil:
    section.add "name", valid_580243
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
  var valid_580244 = query.getOrDefault("key")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "key", valid_580244
  var valid_580245 = query.getOrDefault("prettyPrint")
  valid_580245 = validateParameter(valid_580245, JBool, required = false,
                                 default = newJBool(true))
  if valid_580245 != nil:
    section.add "prettyPrint", valid_580245
  var valid_580246 = query.getOrDefault("oauth_token")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "oauth_token", valid_580246
  var valid_580247 = query.getOrDefault("$.xgafv")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = newJString("1"))
  if valid_580247 != nil:
    section.add "$.xgafv", valid_580247
  var valid_580248 = query.getOrDefault("alt")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = newJString("json"))
  if valid_580248 != nil:
    section.add "alt", valid_580248
  var valid_580249 = query.getOrDefault("uploadType")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "uploadType", valid_580249
  var valid_580250 = query.getOrDefault("quotaUser")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "quotaUser", valid_580250
  var valid_580251 = query.getOrDefault("callback")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "callback", valid_580251
  var valid_580252 = query.getOrDefault("fields")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "fields", valid_580252
  var valid_580253 = query.getOrDefault("access_token")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "access_token", valid_580253
  var valid_580254 = query.getOrDefault("upload_protocol")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "upload_protocol", valid_580254
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

proc call*(call_580256: Call_IamProjectsServiceAccountsSignBlob_580240;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## **Note**: This method is in the process of being deprecated. Call the
  ## [`signBlob()`](/iam/credentials/reference/rest/v1/projects.serviceAccounts/signBlob)
  ## method of the Cloud IAM Service Account Credentials API instead.
  ## 
  ## Signs a blob using a service account's system-managed private key.
  ## 
  let valid = call_580256.validator(path, query, header, formData, body)
  let scheme = call_580256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580256.url(scheme.get, call_580256.host, call_580256.base,
                         call_580256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580256, url, valid)

proc call*(call_580257: Call_IamProjectsServiceAccountsSignBlob_580240;
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
  var path_580258 = newJObject()
  var query_580259 = newJObject()
  var body_580260 = newJObject()
  add(query_580259, "key", newJString(key))
  add(query_580259, "prettyPrint", newJBool(prettyPrint))
  add(query_580259, "oauth_token", newJString(oauthToken))
  add(query_580259, "$.xgafv", newJString(Xgafv))
  add(query_580259, "alt", newJString(alt))
  add(query_580259, "uploadType", newJString(uploadType))
  add(query_580259, "quotaUser", newJString(quotaUser))
  add(path_580258, "name", newJString(name))
  if body != nil:
    body_580260 = body
  add(query_580259, "callback", newJString(callback))
  add(query_580259, "fields", newJString(fields))
  add(query_580259, "access_token", newJString(accessToken))
  add(query_580259, "upload_protocol", newJString(uploadProtocol))
  result = call_580257.call(path_580258, query_580259, nil, nil, body_580260)

var iamProjectsServiceAccountsSignBlob* = Call_IamProjectsServiceAccountsSignBlob_580240(
    name: "iamProjectsServiceAccountsSignBlob", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}:signBlob",
    validator: validate_IamProjectsServiceAccountsSignBlob_580241, base: "/",
    url: url_IamProjectsServiceAccountsSignBlob_580242, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsSignJwt_580261 = ref object of OpenApiRestCall_579373
proc url_IamProjectsServiceAccountsSignJwt_580263(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_IamProjectsServiceAccountsSignJwt_580262(path: JsonNode;
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
  var valid_580264 = path.getOrDefault("name")
  valid_580264 = validateParameter(valid_580264, JString, required = true,
                                 default = nil)
  if valid_580264 != nil:
    section.add "name", valid_580264
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
  var valid_580265 = query.getOrDefault("key")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "key", valid_580265
  var valid_580266 = query.getOrDefault("prettyPrint")
  valid_580266 = validateParameter(valid_580266, JBool, required = false,
                                 default = newJBool(true))
  if valid_580266 != nil:
    section.add "prettyPrint", valid_580266
  var valid_580267 = query.getOrDefault("oauth_token")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "oauth_token", valid_580267
  var valid_580268 = query.getOrDefault("$.xgafv")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = newJString("1"))
  if valid_580268 != nil:
    section.add "$.xgafv", valid_580268
  var valid_580269 = query.getOrDefault("alt")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = newJString("json"))
  if valid_580269 != nil:
    section.add "alt", valid_580269
  var valid_580270 = query.getOrDefault("uploadType")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "uploadType", valid_580270
  var valid_580271 = query.getOrDefault("quotaUser")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "quotaUser", valid_580271
  var valid_580272 = query.getOrDefault("callback")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "callback", valid_580272
  var valid_580273 = query.getOrDefault("fields")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "fields", valid_580273
  var valid_580274 = query.getOrDefault("access_token")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "access_token", valid_580274
  var valid_580275 = query.getOrDefault("upload_protocol")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = nil)
  if valid_580275 != nil:
    section.add "upload_protocol", valid_580275
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

proc call*(call_580277: Call_IamProjectsServiceAccountsSignJwt_580261;
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
  let valid = call_580277.validator(path, query, header, formData, body)
  let scheme = call_580277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580277.url(scheme.get, call_580277.host, call_580277.base,
                         call_580277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580277, url, valid)

proc call*(call_580278: Call_IamProjectsServiceAccountsSignJwt_580261;
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
  var path_580279 = newJObject()
  var query_580280 = newJObject()
  var body_580281 = newJObject()
  add(query_580280, "key", newJString(key))
  add(query_580280, "prettyPrint", newJBool(prettyPrint))
  add(query_580280, "oauth_token", newJString(oauthToken))
  add(query_580280, "$.xgafv", newJString(Xgafv))
  add(query_580280, "alt", newJString(alt))
  add(query_580280, "uploadType", newJString(uploadType))
  add(query_580280, "quotaUser", newJString(quotaUser))
  add(path_580279, "name", newJString(name))
  if body != nil:
    body_580281 = body
  add(query_580280, "callback", newJString(callback))
  add(query_580280, "fields", newJString(fields))
  add(query_580280, "access_token", newJString(accessToken))
  add(query_580280, "upload_protocol", newJString(uploadProtocol))
  result = call_580278.call(path_580279, query_580280, nil, nil, body_580281)

var iamProjectsServiceAccountsSignJwt* = Call_IamProjectsServiceAccountsSignJwt_580261(
    name: "iamProjectsServiceAccountsSignJwt", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}:signJwt",
    validator: validate_IamProjectsServiceAccountsSignJwt_580262, base: "/",
    url: url_IamProjectsServiceAccountsSignJwt_580263, schemes: {Scheme.Https})
type
  Call_IamOrganizationsRolesUndelete_580282 = ref object of OpenApiRestCall_579373
proc url_IamOrganizationsRolesUndelete_580284(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_IamOrganizationsRolesUndelete_580283(path: JsonNode; query: JsonNode;
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
  var valid_580285 = path.getOrDefault("name")
  valid_580285 = validateParameter(valid_580285, JString, required = true,
                                 default = nil)
  if valid_580285 != nil:
    section.add "name", valid_580285
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
  var valid_580286 = query.getOrDefault("key")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "key", valid_580286
  var valid_580287 = query.getOrDefault("prettyPrint")
  valid_580287 = validateParameter(valid_580287, JBool, required = false,
                                 default = newJBool(true))
  if valid_580287 != nil:
    section.add "prettyPrint", valid_580287
  var valid_580288 = query.getOrDefault("oauth_token")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "oauth_token", valid_580288
  var valid_580289 = query.getOrDefault("$.xgafv")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = newJString("1"))
  if valid_580289 != nil:
    section.add "$.xgafv", valid_580289
  var valid_580290 = query.getOrDefault("alt")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = newJString("json"))
  if valid_580290 != nil:
    section.add "alt", valid_580290
  var valid_580291 = query.getOrDefault("uploadType")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "uploadType", valid_580291
  var valid_580292 = query.getOrDefault("quotaUser")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = nil)
  if valid_580292 != nil:
    section.add "quotaUser", valid_580292
  var valid_580293 = query.getOrDefault("callback")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "callback", valid_580293
  var valid_580294 = query.getOrDefault("fields")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "fields", valid_580294
  var valid_580295 = query.getOrDefault("access_token")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "access_token", valid_580295
  var valid_580296 = query.getOrDefault("upload_protocol")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = nil)
  if valid_580296 != nil:
    section.add "upload_protocol", valid_580296
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

proc call*(call_580298: Call_IamOrganizationsRolesUndelete_580282; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Undelete a Role, bringing it back in its previous state.
  ## 
  let valid = call_580298.validator(path, query, header, formData, body)
  let scheme = call_580298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580298.url(scheme.get, call_580298.host, call_580298.base,
                         call_580298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580298, url, valid)

proc call*(call_580299: Call_IamOrganizationsRolesUndelete_580282; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## iamOrganizationsRolesUndelete
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
  var path_580300 = newJObject()
  var query_580301 = newJObject()
  var body_580302 = newJObject()
  add(query_580301, "key", newJString(key))
  add(query_580301, "prettyPrint", newJBool(prettyPrint))
  add(query_580301, "oauth_token", newJString(oauthToken))
  add(query_580301, "$.xgafv", newJString(Xgafv))
  add(query_580301, "alt", newJString(alt))
  add(query_580301, "uploadType", newJString(uploadType))
  add(query_580301, "quotaUser", newJString(quotaUser))
  add(path_580300, "name", newJString(name))
  if body != nil:
    body_580302 = body
  add(query_580301, "callback", newJString(callback))
  add(query_580301, "fields", newJString(fields))
  add(query_580301, "access_token", newJString(accessToken))
  add(query_580301, "upload_protocol", newJString(uploadProtocol))
  result = call_580299.call(path_580300, query_580301, nil, nil, body_580302)

var iamOrganizationsRolesUndelete* = Call_IamOrganizationsRolesUndelete_580282(
    name: "iamOrganizationsRolesUndelete", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{name}:undelete",
    validator: validate_IamOrganizationsRolesUndelete_580283, base: "/",
    url: url_IamOrganizationsRolesUndelete_580284, schemes: {Scheme.Https})
type
  Call_IamOrganizationsRolesCreate_580326 = ref object of OpenApiRestCall_579373
proc url_IamOrganizationsRolesCreate_580328(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_IamOrganizationsRolesCreate_580327(path: JsonNode; query: JsonNode;
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
  var valid_580329 = path.getOrDefault("parent")
  valid_580329 = validateParameter(valid_580329, JString, required = true,
                                 default = nil)
  if valid_580329 != nil:
    section.add "parent", valid_580329
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
  var valid_580330 = query.getOrDefault("key")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = nil)
  if valid_580330 != nil:
    section.add "key", valid_580330
  var valid_580331 = query.getOrDefault("prettyPrint")
  valid_580331 = validateParameter(valid_580331, JBool, required = false,
                                 default = newJBool(true))
  if valid_580331 != nil:
    section.add "prettyPrint", valid_580331
  var valid_580332 = query.getOrDefault("oauth_token")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = nil)
  if valid_580332 != nil:
    section.add "oauth_token", valid_580332
  var valid_580333 = query.getOrDefault("$.xgafv")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = newJString("1"))
  if valid_580333 != nil:
    section.add "$.xgafv", valid_580333
  var valid_580334 = query.getOrDefault("alt")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = newJString("json"))
  if valid_580334 != nil:
    section.add "alt", valid_580334
  var valid_580335 = query.getOrDefault("uploadType")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = nil)
  if valid_580335 != nil:
    section.add "uploadType", valid_580335
  var valid_580336 = query.getOrDefault("quotaUser")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "quotaUser", valid_580336
  var valid_580337 = query.getOrDefault("callback")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "callback", valid_580337
  var valid_580338 = query.getOrDefault("fields")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "fields", valid_580338
  var valid_580339 = query.getOrDefault("access_token")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "access_token", valid_580339
  var valid_580340 = query.getOrDefault("upload_protocol")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = nil)
  if valid_580340 != nil:
    section.add "upload_protocol", valid_580340
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

proc call*(call_580342: Call_IamOrganizationsRolesCreate_580326; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Role.
  ## 
  let valid = call_580342.validator(path, query, header, formData, body)
  let scheme = call_580342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580342.url(scheme.get, call_580342.host, call_580342.base,
                         call_580342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580342, url, valid)

proc call*(call_580343: Call_IamOrganizationsRolesCreate_580326; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## iamOrganizationsRolesCreate
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
  var path_580344 = newJObject()
  var query_580345 = newJObject()
  var body_580346 = newJObject()
  add(query_580345, "key", newJString(key))
  add(query_580345, "prettyPrint", newJBool(prettyPrint))
  add(query_580345, "oauth_token", newJString(oauthToken))
  add(query_580345, "$.xgafv", newJString(Xgafv))
  add(query_580345, "alt", newJString(alt))
  add(query_580345, "uploadType", newJString(uploadType))
  add(query_580345, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580346 = body
  add(query_580345, "callback", newJString(callback))
  add(path_580344, "parent", newJString(parent))
  add(query_580345, "fields", newJString(fields))
  add(query_580345, "access_token", newJString(accessToken))
  add(query_580345, "upload_protocol", newJString(uploadProtocol))
  result = call_580343.call(path_580344, query_580345, nil, nil, body_580346)

var iamOrganizationsRolesCreate* = Call_IamOrganizationsRolesCreate_580326(
    name: "iamOrganizationsRolesCreate", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{parent}/roles",
    validator: validate_IamOrganizationsRolesCreate_580327, base: "/",
    url: url_IamOrganizationsRolesCreate_580328, schemes: {Scheme.Https})
type
  Call_IamOrganizationsRolesList_580303 = ref object of OpenApiRestCall_579373
proc url_IamOrganizationsRolesList_580305(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_IamOrganizationsRolesList_580304(path: JsonNode; query: JsonNode;
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
  var valid_580306 = path.getOrDefault("parent")
  valid_580306 = validateParameter(valid_580306, JString, required = true,
                                 default = nil)
  if valid_580306 != nil:
    section.add "parent", valid_580306
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
  var valid_580307 = query.getOrDefault("key")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "key", valid_580307
  var valid_580308 = query.getOrDefault("prettyPrint")
  valid_580308 = validateParameter(valid_580308, JBool, required = false,
                                 default = newJBool(true))
  if valid_580308 != nil:
    section.add "prettyPrint", valid_580308
  var valid_580309 = query.getOrDefault("oauth_token")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "oauth_token", valid_580309
  var valid_580310 = query.getOrDefault("$.xgafv")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = newJString("1"))
  if valid_580310 != nil:
    section.add "$.xgafv", valid_580310
  var valid_580311 = query.getOrDefault("pageSize")
  valid_580311 = validateParameter(valid_580311, JInt, required = false, default = nil)
  if valid_580311 != nil:
    section.add "pageSize", valid_580311
  var valid_580312 = query.getOrDefault("alt")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = newJString("json"))
  if valid_580312 != nil:
    section.add "alt", valid_580312
  var valid_580313 = query.getOrDefault("uploadType")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "uploadType", valid_580313
  var valid_580314 = query.getOrDefault("quotaUser")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = nil)
  if valid_580314 != nil:
    section.add "quotaUser", valid_580314
  var valid_580315 = query.getOrDefault("pageToken")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "pageToken", valid_580315
  var valid_580316 = query.getOrDefault("callback")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "callback", valid_580316
  var valid_580317 = query.getOrDefault("fields")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "fields", valid_580317
  var valid_580318 = query.getOrDefault("access_token")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "access_token", valid_580318
  var valid_580319 = query.getOrDefault("upload_protocol")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = nil)
  if valid_580319 != nil:
    section.add "upload_protocol", valid_580319
  var valid_580320 = query.getOrDefault("showDeleted")
  valid_580320 = validateParameter(valid_580320, JBool, required = false, default = nil)
  if valid_580320 != nil:
    section.add "showDeleted", valid_580320
  var valid_580321 = query.getOrDefault("view")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_580321 != nil:
    section.add "view", valid_580321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580322: Call_IamOrganizationsRolesList_580303; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Roles defined on a resource.
  ## 
  let valid = call_580322.validator(path, query, header, formData, body)
  let scheme = call_580322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580322.url(scheme.get, call_580322.host, call_580322.base,
                         call_580322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580322, url, valid)

proc call*(call_580323: Call_IamOrganizationsRolesList_580303; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; showDeleted: bool = false; view: string = "BASIC"): Recallable =
  ## iamOrganizationsRolesList
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
  var path_580324 = newJObject()
  var query_580325 = newJObject()
  add(query_580325, "key", newJString(key))
  add(query_580325, "prettyPrint", newJBool(prettyPrint))
  add(query_580325, "oauth_token", newJString(oauthToken))
  add(query_580325, "$.xgafv", newJString(Xgafv))
  add(query_580325, "pageSize", newJInt(pageSize))
  add(query_580325, "alt", newJString(alt))
  add(query_580325, "uploadType", newJString(uploadType))
  add(query_580325, "quotaUser", newJString(quotaUser))
  add(query_580325, "pageToken", newJString(pageToken))
  add(query_580325, "callback", newJString(callback))
  add(path_580324, "parent", newJString(parent))
  add(query_580325, "fields", newJString(fields))
  add(query_580325, "access_token", newJString(accessToken))
  add(query_580325, "upload_protocol", newJString(uploadProtocol))
  add(query_580325, "showDeleted", newJBool(showDeleted))
  add(query_580325, "view", newJString(view))
  result = call_580323.call(path_580324, query_580325, nil, nil, nil)

var iamOrganizationsRolesList* = Call_IamOrganizationsRolesList_580303(
    name: "iamOrganizationsRolesList", meth: HttpMethod.HttpGet,
    host: "iam.googleapis.com", route: "/v1/{parent}/roles",
    validator: validate_IamOrganizationsRolesList_580304, base: "/",
    url: url_IamOrganizationsRolesList_580305, schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsGetIamPolicy_580347 = ref object of OpenApiRestCall_579373
proc url_IamProjectsServiceAccountsGetIamPolicy_580349(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_IamProjectsServiceAccountsGetIamPolicy_580348(path: JsonNode;
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
  var valid_580350 = path.getOrDefault("resource")
  valid_580350 = validateParameter(valid_580350, JString, required = true,
                                 default = nil)
  if valid_580350 != nil:
    section.add "resource", valid_580350
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
  var valid_580351 = query.getOrDefault("key")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "key", valid_580351
  var valid_580352 = query.getOrDefault("prettyPrint")
  valid_580352 = validateParameter(valid_580352, JBool, required = false,
                                 default = newJBool(true))
  if valid_580352 != nil:
    section.add "prettyPrint", valid_580352
  var valid_580353 = query.getOrDefault("oauth_token")
  valid_580353 = validateParameter(valid_580353, JString, required = false,
                                 default = nil)
  if valid_580353 != nil:
    section.add "oauth_token", valid_580353
  var valid_580354 = query.getOrDefault("$.xgafv")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = newJString("1"))
  if valid_580354 != nil:
    section.add "$.xgafv", valid_580354
  var valid_580355 = query.getOrDefault("options.requestedPolicyVersion")
  valid_580355 = validateParameter(valid_580355, JInt, required = false, default = nil)
  if valid_580355 != nil:
    section.add "options.requestedPolicyVersion", valid_580355
  var valid_580356 = query.getOrDefault("alt")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = newJString("json"))
  if valid_580356 != nil:
    section.add "alt", valid_580356
  var valid_580357 = query.getOrDefault("uploadType")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = nil)
  if valid_580357 != nil:
    section.add "uploadType", valid_580357
  var valid_580358 = query.getOrDefault("quotaUser")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = nil)
  if valid_580358 != nil:
    section.add "quotaUser", valid_580358
  var valid_580359 = query.getOrDefault("callback")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = nil)
  if valid_580359 != nil:
    section.add "callback", valid_580359
  var valid_580360 = query.getOrDefault("fields")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "fields", valid_580360
  var valid_580361 = query.getOrDefault("access_token")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "access_token", valid_580361
  var valid_580362 = query.getOrDefault("upload_protocol")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "upload_protocol", valid_580362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580363: Call_IamProjectsServiceAccountsGetIamPolicy_580347;
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
  let valid = call_580363.validator(path, query, header, formData, body)
  let scheme = call_580363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580363.url(scheme.get, call_580363.host, call_580363.base,
                         call_580363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580363, url, valid)

proc call*(call_580364: Call_IamProjectsServiceAccountsGetIamPolicy_580347;
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
  var path_580365 = newJObject()
  var query_580366 = newJObject()
  add(query_580366, "key", newJString(key))
  add(query_580366, "prettyPrint", newJBool(prettyPrint))
  add(query_580366, "oauth_token", newJString(oauthToken))
  add(query_580366, "$.xgafv", newJString(Xgafv))
  add(query_580366, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_580366, "alt", newJString(alt))
  add(query_580366, "uploadType", newJString(uploadType))
  add(query_580366, "quotaUser", newJString(quotaUser))
  add(path_580365, "resource", newJString(resource))
  add(query_580366, "callback", newJString(callback))
  add(query_580366, "fields", newJString(fields))
  add(query_580366, "access_token", newJString(accessToken))
  add(query_580366, "upload_protocol", newJString(uploadProtocol))
  result = call_580364.call(path_580365, query_580366, nil, nil, nil)

var iamProjectsServiceAccountsGetIamPolicy* = Call_IamProjectsServiceAccountsGetIamPolicy_580347(
    name: "iamProjectsServiceAccountsGetIamPolicy", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{resource}:getIamPolicy",
    validator: validate_IamProjectsServiceAccountsGetIamPolicy_580348, base: "/",
    url: url_IamProjectsServiceAccountsGetIamPolicy_580349,
    schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsSetIamPolicy_580367 = ref object of OpenApiRestCall_579373
proc url_IamProjectsServiceAccountsSetIamPolicy_580369(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_IamProjectsServiceAccountsSetIamPolicy_580368(path: JsonNode;
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
  var valid_580370 = path.getOrDefault("resource")
  valid_580370 = validateParameter(valid_580370, JString, required = true,
                                 default = nil)
  if valid_580370 != nil:
    section.add "resource", valid_580370
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
  var valid_580371 = query.getOrDefault("key")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "key", valid_580371
  var valid_580372 = query.getOrDefault("prettyPrint")
  valid_580372 = validateParameter(valid_580372, JBool, required = false,
                                 default = newJBool(true))
  if valid_580372 != nil:
    section.add "prettyPrint", valid_580372
  var valid_580373 = query.getOrDefault("oauth_token")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = nil)
  if valid_580373 != nil:
    section.add "oauth_token", valid_580373
  var valid_580374 = query.getOrDefault("$.xgafv")
  valid_580374 = validateParameter(valid_580374, JString, required = false,
                                 default = newJString("1"))
  if valid_580374 != nil:
    section.add "$.xgafv", valid_580374
  var valid_580375 = query.getOrDefault("alt")
  valid_580375 = validateParameter(valid_580375, JString, required = false,
                                 default = newJString("json"))
  if valid_580375 != nil:
    section.add "alt", valid_580375
  var valid_580376 = query.getOrDefault("uploadType")
  valid_580376 = validateParameter(valid_580376, JString, required = false,
                                 default = nil)
  if valid_580376 != nil:
    section.add "uploadType", valid_580376
  var valid_580377 = query.getOrDefault("quotaUser")
  valid_580377 = validateParameter(valid_580377, JString, required = false,
                                 default = nil)
  if valid_580377 != nil:
    section.add "quotaUser", valid_580377
  var valid_580378 = query.getOrDefault("callback")
  valid_580378 = validateParameter(valid_580378, JString, required = false,
                                 default = nil)
  if valid_580378 != nil:
    section.add "callback", valid_580378
  var valid_580379 = query.getOrDefault("fields")
  valid_580379 = validateParameter(valid_580379, JString, required = false,
                                 default = nil)
  if valid_580379 != nil:
    section.add "fields", valid_580379
  var valid_580380 = query.getOrDefault("access_token")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = nil)
  if valid_580380 != nil:
    section.add "access_token", valid_580380
  var valid_580381 = query.getOrDefault("upload_protocol")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "upload_protocol", valid_580381
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

proc call*(call_580383: Call_IamProjectsServiceAccountsSetIamPolicy_580367;
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
  let valid = call_580383.validator(path, query, header, formData, body)
  let scheme = call_580383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580383.url(scheme.get, call_580383.host, call_580383.base,
                         call_580383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580383, url, valid)

proc call*(call_580384: Call_IamProjectsServiceAccountsSetIamPolicy_580367;
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
  var path_580385 = newJObject()
  var query_580386 = newJObject()
  var body_580387 = newJObject()
  add(query_580386, "key", newJString(key))
  add(query_580386, "prettyPrint", newJBool(prettyPrint))
  add(query_580386, "oauth_token", newJString(oauthToken))
  add(query_580386, "$.xgafv", newJString(Xgafv))
  add(query_580386, "alt", newJString(alt))
  add(query_580386, "uploadType", newJString(uploadType))
  add(query_580386, "quotaUser", newJString(quotaUser))
  add(path_580385, "resource", newJString(resource))
  if body != nil:
    body_580387 = body
  add(query_580386, "callback", newJString(callback))
  add(query_580386, "fields", newJString(fields))
  add(query_580386, "access_token", newJString(accessToken))
  add(query_580386, "upload_protocol", newJString(uploadProtocol))
  result = call_580384.call(path_580385, query_580386, nil, nil, body_580387)

var iamProjectsServiceAccountsSetIamPolicy* = Call_IamProjectsServiceAccountsSetIamPolicy_580367(
    name: "iamProjectsServiceAccountsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "iam.googleapis.com", route: "/v1/{resource}:setIamPolicy",
    validator: validate_IamProjectsServiceAccountsSetIamPolicy_580368, base: "/",
    url: url_IamProjectsServiceAccountsSetIamPolicy_580369,
    schemes: {Scheme.Https})
type
  Call_IamProjectsServiceAccountsTestIamPermissions_580388 = ref object of OpenApiRestCall_579373
proc url_IamProjectsServiceAccountsTestIamPermissions_580390(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_IamProjectsServiceAccountsTestIamPermissions_580389(path: JsonNode;
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
  var valid_580391 = path.getOrDefault("resource")
  valid_580391 = validateParameter(valid_580391, JString, required = true,
                                 default = nil)
  if valid_580391 != nil:
    section.add "resource", valid_580391
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
  var valid_580392 = query.getOrDefault("key")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = nil)
  if valid_580392 != nil:
    section.add "key", valid_580392
  var valid_580393 = query.getOrDefault("prettyPrint")
  valid_580393 = validateParameter(valid_580393, JBool, required = false,
                                 default = newJBool(true))
  if valid_580393 != nil:
    section.add "prettyPrint", valid_580393
  var valid_580394 = query.getOrDefault("oauth_token")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = nil)
  if valid_580394 != nil:
    section.add "oauth_token", valid_580394
  var valid_580395 = query.getOrDefault("$.xgafv")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = newJString("1"))
  if valid_580395 != nil:
    section.add "$.xgafv", valid_580395
  var valid_580396 = query.getOrDefault("alt")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = newJString("json"))
  if valid_580396 != nil:
    section.add "alt", valid_580396
  var valid_580397 = query.getOrDefault("uploadType")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = nil)
  if valid_580397 != nil:
    section.add "uploadType", valid_580397
  var valid_580398 = query.getOrDefault("quotaUser")
  valid_580398 = validateParameter(valid_580398, JString, required = false,
                                 default = nil)
  if valid_580398 != nil:
    section.add "quotaUser", valid_580398
  var valid_580399 = query.getOrDefault("callback")
  valid_580399 = validateParameter(valid_580399, JString, required = false,
                                 default = nil)
  if valid_580399 != nil:
    section.add "callback", valid_580399
  var valid_580400 = query.getOrDefault("fields")
  valid_580400 = validateParameter(valid_580400, JString, required = false,
                                 default = nil)
  if valid_580400 != nil:
    section.add "fields", valid_580400
  var valid_580401 = query.getOrDefault("access_token")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "access_token", valid_580401
  var valid_580402 = query.getOrDefault("upload_protocol")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "upload_protocol", valid_580402
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

proc call*(call_580404: Call_IamProjectsServiceAccountsTestIamPermissions_580388;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Tests the specified permissions against the IAM access control policy
  ## for a ServiceAccount.
  ## 
  let valid = call_580404.validator(path, query, header, formData, body)
  let scheme = call_580404.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580404.url(scheme.get, call_580404.host, call_580404.base,
                         call_580404.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580404, url, valid)

proc call*(call_580405: Call_IamProjectsServiceAccountsTestIamPermissions_580388;
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
  var path_580406 = newJObject()
  var query_580407 = newJObject()
  var body_580408 = newJObject()
  add(query_580407, "key", newJString(key))
  add(query_580407, "prettyPrint", newJBool(prettyPrint))
  add(query_580407, "oauth_token", newJString(oauthToken))
  add(query_580407, "$.xgafv", newJString(Xgafv))
  add(query_580407, "alt", newJString(alt))
  add(query_580407, "uploadType", newJString(uploadType))
  add(query_580407, "quotaUser", newJString(quotaUser))
  add(path_580406, "resource", newJString(resource))
  if body != nil:
    body_580408 = body
  add(query_580407, "callback", newJString(callback))
  add(query_580407, "fields", newJString(fields))
  add(query_580407, "access_token", newJString(accessToken))
  add(query_580407, "upload_protocol", newJString(uploadProtocol))
  result = call_580405.call(path_580406, query_580407, nil, nil, body_580408)

var iamProjectsServiceAccountsTestIamPermissions* = Call_IamProjectsServiceAccountsTestIamPermissions_580388(
    name: "iamProjectsServiceAccountsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "iam.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_IamProjectsServiceAccountsTestIamPermissions_580389,
    base: "/", url: url_IamProjectsServiceAccountsTestIamPermissions_580390,
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
