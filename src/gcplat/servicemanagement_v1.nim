
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Service Management
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Google Service Management allows service producers to publish their services on Google Cloud Platform so that they can be discovered and used by service consumers.
## 
## https://cloud.google.com/service-management/
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
  gcpServiceName = "servicemanagement"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServicemanagementOperationsList_578619 = ref object of OpenApiRestCall_578348
proc url_ServicemanagementOperationsList_578621(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ServicemanagementOperationsList_578620(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists service operations that match the specified filter in the request.
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
  ##   name: JString
  ##       : Not used.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of operations to return. If unspecified, defaults to
  ## 50. The maximum value is 100.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : A string for filtering Operations.
  ##   The following filter fields are supported&#58;
  ## 
  ##   * serviceName&#58; Required. Only `=` operator is allowed.
  ##   * startTime&#58; The time this job was started, in ISO 8601 format.
  ##     Allowed operators are `>=`,  `>`, `<=`, and `<`.
  ##   * status&#58; Can be `done`, `in_progress`, or `failed`. Allowed
  ##     operators are `=`, and `!=`.
  ## 
  ##   Filter expression supports conjunction (AND) and disjunction (OR)
  ##   logical operators. However, the serviceName restriction must be at the
  ##   top-level and can only be combined with other restrictions via the AND
  ##   logical operator.
  ## 
  ##   Examples&#58;
  ## 
  ##   * `serviceName={some-service}.googleapis.com`
  ##   * `serviceName={some-service}.googleapis.com AND startTime>="2017-02-01"`
  ##   * `serviceName={some-service}.googleapis.com AND status=done`
  ##   * `serviceName={some-service}.googleapis.com AND (status=done OR startTime>="2017-02-01")`
  ##   pageToken: JString
  ##            : The standard list page token.
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
  var valid_578749 = query.getOrDefault("name")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = nil)
  if valid_578749 != nil:
    section.add "name", valid_578749
  var valid_578750 = query.getOrDefault("$.xgafv")
  valid_578750 = validateParameter(valid_578750, JString, required = false,
                                 default = newJString("1"))
  if valid_578750 != nil:
    section.add "$.xgafv", valid_578750
  var valid_578751 = query.getOrDefault("pageSize")
  valid_578751 = validateParameter(valid_578751, JInt, required = false, default = nil)
  if valid_578751 != nil:
    section.add "pageSize", valid_578751
  var valid_578752 = query.getOrDefault("alt")
  valid_578752 = validateParameter(valid_578752, JString, required = false,
                                 default = newJString("json"))
  if valid_578752 != nil:
    section.add "alt", valid_578752
  var valid_578753 = query.getOrDefault("uploadType")
  valid_578753 = validateParameter(valid_578753, JString, required = false,
                                 default = nil)
  if valid_578753 != nil:
    section.add "uploadType", valid_578753
  var valid_578754 = query.getOrDefault("quotaUser")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "quotaUser", valid_578754
  var valid_578755 = query.getOrDefault("filter")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "filter", valid_578755
  var valid_578756 = query.getOrDefault("pageToken")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "pageToken", valid_578756
  var valid_578757 = query.getOrDefault("callback")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "callback", valid_578757
  var valid_578758 = query.getOrDefault("fields")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "fields", valid_578758
  var valid_578759 = query.getOrDefault("access_token")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "access_token", valid_578759
  var valid_578760 = query.getOrDefault("upload_protocol")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "upload_protocol", valid_578760
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578783: Call_ServicemanagementOperationsList_578619;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists service operations that match the specified filter in the request.
  ## 
  let valid = call_578783.validator(path, query, header, formData, body)
  let scheme = call_578783.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578783.url(scheme.get, call_578783.host, call_578783.base,
                         call_578783.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578783, url, valid)

proc call*(call_578854: Call_ServicemanagementOperationsList_578619;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          name: string = ""; Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; filter: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicemanagementOperationsList
  ## Lists service operations that match the specified filter in the request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   name: string
  ##       : Not used.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of operations to return. If unspecified, defaults to
  ## 50. The maximum value is 100.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : A string for filtering Operations.
  ##   The following filter fields are supported&#58;
  ## 
  ##   * serviceName&#58; Required. Only `=` operator is allowed.
  ##   * startTime&#58; The time this job was started, in ISO 8601 format.
  ##     Allowed operators are `>=`,  `>`, `<=`, and `<`.
  ##   * status&#58; Can be `done`, `in_progress`, or `failed`. Allowed
  ##     operators are `=`, and `!=`.
  ## 
  ##   Filter expression supports conjunction (AND) and disjunction (OR)
  ##   logical operators. However, the serviceName restriction must be at the
  ##   top-level and can only be combined with other restrictions via the AND
  ##   logical operator.
  ## 
  ##   Examples&#58;
  ## 
  ##   * `serviceName={some-service}.googleapis.com`
  ##   * `serviceName={some-service}.googleapis.com AND startTime>="2017-02-01"`
  ##   * `serviceName={some-service}.googleapis.com AND status=done`
  ##   * `serviceName={some-service}.googleapis.com AND (status=done OR startTime>="2017-02-01")`
  ##   pageToken: string
  ##            : The standard list page token.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578855 = newJObject()
  add(query_578855, "key", newJString(key))
  add(query_578855, "prettyPrint", newJBool(prettyPrint))
  add(query_578855, "oauth_token", newJString(oauthToken))
  add(query_578855, "name", newJString(name))
  add(query_578855, "$.xgafv", newJString(Xgafv))
  add(query_578855, "pageSize", newJInt(pageSize))
  add(query_578855, "alt", newJString(alt))
  add(query_578855, "uploadType", newJString(uploadType))
  add(query_578855, "quotaUser", newJString(quotaUser))
  add(query_578855, "filter", newJString(filter))
  add(query_578855, "pageToken", newJString(pageToken))
  add(query_578855, "callback", newJString(callback))
  add(query_578855, "fields", newJString(fields))
  add(query_578855, "access_token", newJString(accessToken))
  add(query_578855, "upload_protocol", newJString(uploadProtocol))
  result = call_578854.call(nil, query_578855, nil, nil, nil)

var servicemanagementOperationsList* = Call_ServicemanagementOperationsList_578619(
    name: "servicemanagementOperationsList", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com", route: "/v1/operations",
    validator: validate_ServicemanagementOperationsList_578620, base: "/",
    url: url_ServicemanagementOperationsList_578621, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesCreate_578916 = ref object of OpenApiRestCall_578348
proc url_ServicemanagementServicesCreate_578918(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ServicemanagementServicesCreate_578917(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new managed service.
  ## Please note one producer project can own no more than 20 services.
  ## 
  ## Operation<response: ManagedService>
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
  var valid_578919 = query.getOrDefault("key")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "key", valid_578919
  var valid_578920 = query.getOrDefault("prettyPrint")
  valid_578920 = validateParameter(valid_578920, JBool, required = false,
                                 default = newJBool(true))
  if valid_578920 != nil:
    section.add "prettyPrint", valid_578920
  var valid_578921 = query.getOrDefault("oauth_token")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "oauth_token", valid_578921
  var valid_578922 = query.getOrDefault("$.xgafv")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = newJString("1"))
  if valid_578922 != nil:
    section.add "$.xgafv", valid_578922
  var valid_578923 = query.getOrDefault("alt")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = newJString("json"))
  if valid_578923 != nil:
    section.add "alt", valid_578923
  var valid_578924 = query.getOrDefault("uploadType")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "uploadType", valid_578924
  var valid_578925 = query.getOrDefault("quotaUser")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "quotaUser", valid_578925
  var valid_578926 = query.getOrDefault("callback")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "callback", valid_578926
  var valid_578927 = query.getOrDefault("fields")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "fields", valid_578927
  var valid_578928 = query.getOrDefault("access_token")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "access_token", valid_578928
  var valid_578929 = query.getOrDefault("upload_protocol")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "upload_protocol", valid_578929
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

proc call*(call_578931: Call_ServicemanagementServicesCreate_578916;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new managed service.
  ## Please note one producer project can own no more than 20 services.
  ## 
  ## Operation<response: ManagedService>
  ## 
  let valid = call_578931.validator(path, query, header, formData, body)
  let scheme = call_578931.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578931.url(scheme.get, call_578931.host, call_578931.base,
                         call_578931.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578931, url, valid)

proc call*(call_578932: Call_ServicemanagementServicesCreate_578916;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicemanagementServicesCreate
  ## Creates a new managed service.
  ## Please note one producer project can own no more than 20 services.
  ## 
  ## Operation<response: ManagedService>
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
  var query_578933 = newJObject()
  var body_578934 = newJObject()
  add(query_578933, "key", newJString(key))
  add(query_578933, "prettyPrint", newJBool(prettyPrint))
  add(query_578933, "oauth_token", newJString(oauthToken))
  add(query_578933, "$.xgafv", newJString(Xgafv))
  add(query_578933, "alt", newJString(alt))
  add(query_578933, "uploadType", newJString(uploadType))
  add(query_578933, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578934 = body
  add(query_578933, "callback", newJString(callback))
  add(query_578933, "fields", newJString(fields))
  add(query_578933, "access_token", newJString(accessToken))
  add(query_578933, "upload_protocol", newJString(uploadProtocol))
  result = call_578932.call(nil, query_578933, nil, nil, body_578934)

var servicemanagementServicesCreate* = Call_ServicemanagementServicesCreate_578916(
    name: "servicemanagementServicesCreate", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com", route: "/v1/services",
    validator: validate_ServicemanagementServicesCreate_578917, base: "/",
    url: url_ServicemanagementServicesCreate_578918, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesList_578895 = ref object of OpenApiRestCall_578348
proc url_ServicemanagementServicesList_578897(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ServicemanagementServicesList_578896(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists managed services.
  ## 
  ## Returns all public services. For authenticated users, also returns all
  ## services the calling user has "servicemanagement.services.get" permission
  ## for.
  ## 
  ## **BETA:** If the caller specifies the `consumer_id`, it returns only the
  ## services enabled on the consumer. The `consumer_id` must have the format
  ## of "project:{PROJECT-ID}".
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
  ##           : The max number of items to include in the response list. Page size is 50
  ## if not specified. Maximum value is 100.
  ##   producerProjectId: JString
  ##                    : Include services produced by the specified project.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Token identifying which result to start with; returned by a previous list
  ## call.
  ##   consumerId: JString
  ##             : Include services consumed by the specified consumer.
  ## 
  ## The Google Service Management implementation accepts the following
  ## forms:
  ## - project:<project_id>
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578898 = query.getOrDefault("key")
  valid_578898 = validateParameter(valid_578898, JString, required = false,
                                 default = nil)
  if valid_578898 != nil:
    section.add "key", valid_578898
  var valid_578899 = query.getOrDefault("prettyPrint")
  valid_578899 = validateParameter(valid_578899, JBool, required = false,
                                 default = newJBool(true))
  if valid_578899 != nil:
    section.add "prettyPrint", valid_578899
  var valid_578900 = query.getOrDefault("oauth_token")
  valid_578900 = validateParameter(valid_578900, JString, required = false,
                                 default = nil)
  if valid_578900 != nil:
    section.add "oauth_token", valid_578900
  var valid_578901 = query.getOrDefault("$.xgafv")
  valid_578901 = validateParameter(valid_578901, JString, required = false,
                                 default = newJString("1"))
  if valid_578901 != nil:
    section.add "$.xgafv", valid_578901
  var valid_578902 = query.getOrDefault("pageSize")
  valid_578902 = validateParameter(valid_578902, JInt, required = false, default = nil)
  if valid_578902 != nil:
    section.add "pageSize", valid_578902
  var valid_578903 = query.getOrDefault("producerProjectId")
  valid_578903 = validateParameter(valid_578903, JString, required = false,
                                 default = nil)
  if valid_578903 != nil:
    section.add "producerProjectId", valid_578903
  var valid_578904 = query.getOrDefault("alt")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = newJString("json"))
  if valid_578904 != nil:
    section.add "alt", valid_578904
  var valid_578905 = query.getOrDefault("uploadType")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = nil)
  if valid_578905 != nil:
    section.add "uploadType", valid_578905
  var valid_578906 = query.getOrDefault("quotaUser")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = nil)
  if valid_578906 != nil:
    section.add "quotaUser", valid_578906
  var valid_578907 = query.getOrDefault("pageToken")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "pageToken", valid_578907
  var valid_578908 = query.getOrDefault("consumerId")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "consumerId", valid_578908
  var valid_578909 = query.getOrDefault("callback")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "callback", valid_578909
  var valid_578910 = query.getOrDefault("fields")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "fields", valid_578910
  var valid_578911 = query.getOrDefault("access_token")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "access_token", valid_578911
  var valid_578912 = query.getOrDefault("upload_protocol")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "upload_protocol", valid_578912
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578913: Call_ServicemanagementServicesList_578895; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists managed services.
  ## 
  ## Returns all public services. For authenticated users, also returns all
  ## services the calling user has "servicemanagement.services.get" permission
  ## for.
  ## 
  ## **BETA:** If the caller specifies the `consumer_id`, it returns only the
  ## services enabled on the consumer. The `consumer_id` must have the format
  ## of "project:{PROJECT-ID}".
  ## 
  let valid = call_578913.validator(path, query, header, formData, body)
  let scheme = call_578913.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578913.url(scheme.get, call_578913.host, call_578913.base,
                         call_578913.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578913, url, valid)

proc call*(call_578914: Call_ServicemanagementServicesList_578895;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; producerProjectId: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; consumerId: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicemanagementServicesList
  ## Lists managed services.
  ## 
  ## Returns all public services. For authenticated users, also returns all
  ## services the calling user has "servicemanagement.services.get" permission
  ## for.
  ## 
  ## **BETA:** If the caller specifies the `consumer_id`, it returns only the
  ## services enabled on the consumer. The `consumer_id` must have the format
  ## of "project:{PROJECT-ID}".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The max number of items to include in the response list. Page size is 50
  ## if not specified. Maximum value is 100.
  ##   producerProjectId: string
  ##                    : Include services produced by the specified project.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Token identifying which result to start with; returned by a previous list
  ## call.
  ##   consumerId: string
  ##             : Include services consumed by the specified consumer.
  ## 
  ## The Google Service Management implementation accepts the following
  ## forms:
  ## - project:<project_id>
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578915 = newJObject()
  add(query_578915, "key", newJString(key))
  add(query_578915, "prettyPrint", newJBool(prettyPrint))
  add(query_578915, "oauth_token", newJString(oauthToken))
  add(query_578915, "$.xgafv", newJString(Xgafv))
  add(query_578915, "pageSize", newJInt(pageSize))
  add(query_578915, "producerProjectId", newJString(producerProjectId))
  add(query_578915, "alt", newJString(alt))
  add(query_578915, "uploadType", newJString(uploadType))
  add(query_578915, "quotaUser", newJString(quotaUser))
  add(query_578915, "pageToken", newJString(pageToken))
  add(query_578915, "consumerId", newJString(consumerId))
  add(query_578915, "callback", newJString(callback))
  add(query_578915, "fields", newJString(fields))
  add(query_578915, "access_token", newJString(accessToken))
  add(query_578915, "upload_protocol", newJString(uploadProtocol))
  result = call_578914.call(nil, query_578915, nil, nil, nil)

var servicemanagementServicesList* = Call_ServicemanagementServicesList_578895(
    name: "servicemanagementServicesList", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com", route: "/v1/services",
    validator: validate_ServicemanagementServicesList_578896, base: "/",
    url: url_ServicemanagementServicesList_578897, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesGet_578935 = ref object of OpenApiRestCall_578348
proc url_ServicemanagementServicesGet_578937(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/services/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicemanagementServicesGet_578936(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a managed service. Authentication is required unless the service is
  ## public.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.  See the `ServiceManager` overview for naming
  ## requirements.  For example: `example.googleapis.com`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_578952 = path.getOrDefault("serviceName")
  valid_578952 = validateParameter(valid_578952, JString, required = true,
                                 default = nil)
  if valid_578952 != nil:
    section.add "serviceName", valid_578952
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
  var valid_578953 = query.getOrDefault("key")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "key", valid_578953
  var valid_578954 = query.getOrDefault("prettyPrint")
  valid_578954 = validateParameter(valid_578954, JBool, required = false,
                                 default = newJBool(true))
  if valid_578954 != nil:
    section.add "prettyPrint", valid_578954
  var valid_578955 = query.getOrDefault("oauth_token")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "oauth_token", valid_578955
  var valid_578956 = query.getOrDefault("$.xgafv")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = newJString("1"))
  if valid_578956 != nil:
    section.add "$.xgafv", valid_578956
  var valid_578957 = query.getOrDefault("alt")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = newJString("json"))
  if valid_578957 != nil:
    section.add "alt", valid_578957
  var valid_578958 = query.getOrDefault("uploadType")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "uploadType", valid_578958
  var valid_578959 = query.getOrDefault("quotaUser")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "quotaUser", valid_578959
  var valid_578960 = query.getOrDefault("callback")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "callback", valid_578960
  var valid_578961 = query.getOrDefault("fields")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "fields", valid_578961
  var valid_578962 = query.getOrDefault("access_token")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "access_token", valid_578962
  var valid_578963 = query.getOrDefault("upload_protocol")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "upload_protocol", valid_578963
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578964: Call_ServicemanagementServicesGet_578935; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a managed service. Authentication is required unless the service is
  ## public.
  ## 
  let valid = call_578964.validator(path, query, header, formData, body)
  let scheme = call_578964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578964.url(scheme.get, call_578964.host, call_578964.base,
                         call_578964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578964, url, valid)

proc call*(call_578965: Call_ServicemanagementServicesGet_578935;
          serviceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicemanagementServicesGet
  ## Gets a managed service. Authentication is required unless the service is
  ## public.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   serviceName: string (required)
  ##              : The name of the service.  See the `ServiceManager` overview for naming
  ## requirements.  For example: `example.googleapis.com`.
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
  var path_578966 = newJObject()
  var query_578967 = newJObject()
  add(query_578967, "key", newJString(key))
  add(query_578967, "prettyPrint", newJBool(prettyPrint))
  add(query_578967, "oauth_token", newJString(oauthToken))
  add(path_578966, "serviceName", newJString(serviceName))
  add(query_578967, "$.xgafv", newJString(Xgafv))
  add(query_578967, "alt", newJString(alt))
  add(query_578967, "uploadType", newJString(uploadType))
  add(query_578967, "quotaUser", newJString(quotaUser))
  add(query_578967, "callback", newJString(callback))
  add(query_578967, "fields", newJString(fields))
  add(query_578967, "access_token", newJString(accessToken))
  add(query_578967, "upload_protocol", newJString(uploadProtocol))
  result = call_578965.call(path_578966, query_578967, nil, nil, nil)

var servicemanagementServicesGet* = Call_ServicemanagementServicesGet_578935(
    name: "servicemanagementServicesGet", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com", route: "/v1/services/{serviceName}",
    validator: validate_ServicemanagementServicesGet_578936, base: "/",
    url: url_ServicemanagementServicesGet_578937, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesDelete_578968 = ref object of OpenApiRestCall_578348
proc url_ServicemanagementServicesDelete_578970(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/services/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicemanagementServicesDelete_578969(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a managed service. This method will change the service to the
  ## `Soft-Delete` state for 30 days. Within this period, service producers may
  ## call UndeleteService to restore the service.
  ## After 30 days, the service will be permanently deleted.
  ## 
  ## Operation<response: google.protobuf.Empty>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_578971 = path.getOrDefault("serviceName")
  valid_578971 = validateParameter(valid_578971, JString, required = true,
                                 default = nil)
  if valid_578971 != nil:
    section.add "serviceName", valid_578971
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
  var valid_578972 = query.getOrDefault("key")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "key", valid_578972
  var valid_578973 = query.getOrDefault("prettyPrint")
  valid_578973 = validateParameter(valid_578973, JBool, required = false,
                                 default = newJBool(true))
  if valid_578973 != nil:
    section.add "prettyPrint", valid_578973
  var valid_578974 = query.getOrDefault("oauth_token")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "oauth_token", valid_578974
  var valid_578975 = query.getOrDefault("$.xgafv")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = newJString("1"))
  if valid_578975 != nil:
    section.add "$.xgafv", valid_578975
  var valid_578976 = query.getOrDefault("alt")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = newJString("json"))
  if valid_578976 != nil:
    section.add "alt", valid_578976
  var valid_578977 = query.getOrDefault("uploadType")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "uploadType", valid_578977
  var valid_578978 = query.getOrDefault("quotaUser")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "quotaUser", valid_578978
  var valid_578979 = query.getOrDefault("callback")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "callback", valid_578979
  var valid_578980 = query.getOrDefault("fields")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "fields", valid_578980
  var valid_578981 = query.getOrDefault("access_token")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "access_token", valid_578981
  var valid_578982 = query.getOrDefault("upload_protocol")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "upload_protocol", valid_578982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578983: Call_ServicemanagementServicesDelete_578968;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a managed service. This method will change the service to the
  ## `Soft-Delete` state for 30 days. Within this period, service producers may
  ## call UndeleteService to restore the service.
  ## After 30 days, the service will be permanently deleted.
  ## 
  ## Operation<response: google.protobuf.Empty>
  ## 
  let valid = call_578983.validator(path, query, header, formData, body)
  let scheme = call_578983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578983.url(scheme.get, call_578983.host, call_578983.base,
                         call_578983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578983, url, valid)

proc call*(call_578984: Call_ServicemanagementServicesDelete_578968;
          serviceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicemanagementServicesDelete
  ## Deletes a managed service. This method will change the service to the
  ## `Soft-Delete` state for 30 days. Within this period, service producers may
  ## call UndeleteService to restore the service.
  ## After 30 days, the service will be permanently deleted.
  ## 
  ## Operation<response: google.protobuf.Empty>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   serviceName: string (required)
  ##              : The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
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
  var path_578985 = newJObject()
  var query_578986 = newJObject()
  add(query_578986, "key", newJString(key))
  add(query_578986, "prettyPrint", newJBool(prettyPrint))
  add(query_578986, "oauth_token", newJString(oauthToken))
  add(path_578985, "serviceName", newJString(serviceName))
  add(query_578986, "$.xgafv", newJString(Xgafv))
  add(query_578986, "alt", newJString(alt))
  add(query_578986, "uploadType", newJString(uploadType))
  add(query_578986, "quotaUser", newJString(quotaUser))
  add(query_578986, "callback", newJString(callback))
  add(query_578986, "fields", newJString(fields))
  add(query_578986, "access_token", newJString(accessToken))
  add(query_578986, "upload_protocol", newJString(uploadProtocol))
  result = call_578984.call(path_578985, query_578986, nil, nil, nil)

var servicemanagementServicesDelete* = Call_ServicemanagementServicesDelete_578968(
    name: "servicemanagementServicesDelete", meth: HttpMethod.HttpDelete,
    host: "servicemanagement.googleapis.com", route: "/v1/services/{serviceName}",
    validator: validate_ServicemanagementServicesDelete_578969, base: "/",
    url: url_ServicemanagementServicesDelete_578970, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesGetConfig_578987 = ref object of OpenApiRestCall_578348
proc url_ServicemanagementServicesGetConfig_578989(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/config")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicemanagementServicesGetConfig_578988(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a service configuration (version) for a managed service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_578990 = path.getOrDefault("serviceName")
  valid_578990 = validateParameter(valid_578990, JString, required = true,
                                 default = nil)
  if valid_578990 != nil:
    section.add "serviceName", valid_578990
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
  ##   configId: JString
  ##           : The id of the service configuration resource.
  ## 
  ## This field must be specified for the server to return all fields, including
  ## `SourceInfo`.
  ##   view: JString
  ##       : Specifies which parts of the Service Config should be returned in the
  ## response.
  section = newJObject()
  var valid_578991 = query.getOrDefault("key")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "key", valid_578991
  var valid_578992 = query.getOrDefault("prettyPrint")
  valid_578992 = validateParameter(valid_578992, JBool, required = false,
                                 default = newJBool(true))
  if valid_578992 != nil:
    section.add "prettyPrint", valid_578992
  var valid_578993 = query.getOrDefault("oauth_token")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "oauth_token", valid_578993
  var valid_578994 = query.getOrDefault("$.xgafv")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = newJString("1"))
  if valid_578994 != nil:
    section.add "$.xgafv", valid_578994
  var valid_578995 = query.getOrDefault("alt")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = newJString("json"))
  if valid_578995 != nil:
    section.add "alt", valid_578995
  var valid_578996 = query.getOrDefault("uploadType")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "uploadType", valid_578996
  var valid_578997 = query.getOrDefault("quotaUser")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "quotaUser", valid_578997
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
  var valid_579002 = query.getOrDefault("configId")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "configId", valid_579002
  var valid_579003 = query.getOrDefault("view")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_579003 != nil:
    section.add "view", valid_579003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579004: Call_ServicemanagementServicesGetConfig_578987;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a service configuration (version) for a managed service.
  ## 
  let valid = call_579004.validator(path, query, header, formData, body)
  let scheme = call_579004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579004.url(scheme.get, call_579004.host, call_579004.base,
                         call_579004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579004, url, valid)

proc call*(call_579005: Call_ServicemanagementServicesGetConfig_578987;
          serviceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          configId: string = ""; view: string = "BASIC"): Recallable =
  ## servicemanagementServicesGetConfig
  ## Gets a service configuration (version) for a managed service.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   serviceName: string (required)
  ##              : The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
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
  ##   configId: string
  ##           : The id of the service configuration resource.
  ## 
  ## This field must be specified for the server to return all fields, including
  ## `SourceInfo`.
  ##   view: string
  ##       : Specifies which parts of the Service Config should be returned in the
  ## response.
  var path_579006 = newJObject()
  var query_579007 = newJObject()
  add(query_579007, "key", newJString(key))
  add(query_579007, "prettyPrint", newJBool(prettyPrint))
  add(query_579007, "oauth_token", newJString(oauthToken))
  add(path_579006, "serviceName", newJString(serviceName))
  add(query_579007, "$.xgafv", newJString(Xgafv))
  add(query_579007, "alt", newJString(alt))
  add(query_579007, "uploadType", newJString(uploadType))
  add(query_579007, "quotaUser", newJString(quotaUser))
  add(query_579007, "callback", newJString(callback))
  add(query_579007, "fields", newJString(fields))
  add(query_579007, "access_token", newJString(accessToken))
  add(query_579007, "upload_protocol", newJString(uploadProtocol))
  add(query_579007, "configId", newJString(configId))
  add(query_579007, "view", newJString(view))
  result = call_579005.call(path_579006, query_579007, nil, nil, nil)

var servicemanagementServicesGetConfig* = Call_ServicemanagementServicesGetConfig_578987(
    name: "servicemanagementServicesGetConfig", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/config",
    validator: validate_ServicemanagementServicesGetConfig_578988, base: "/",
    url: url_ServicemanagementServicesGetConfig_578989, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConfigsCreate_579029 = ref object of OpenApiRestCall_578348
proc url_ServicemanagementServicesConfigsCreate_579031(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/configs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicemanagementServicesConfigsCreate_579030(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new service configuration (version) for a managed service.
  ## This method only stores the service configuration. To roll out the service
  ## configuration to backend systems please call
  ## CreateServiceRollout.
  ## 
  ## Only the 100 most recent service configurations and ones referenced by
  ## existing rollouts are kept for each service. The rest will be deleted
  ## eventually.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_579032 = path.getOrDefault("serviceName")
  valid_579032 = validateParameter(valid_579032, JString, required = true,
                                 default = nil)
  if valid_579032 != nil:
    section.add "serviceName", valid_579032
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
  var valid_579033 = query.getOrDefault("key")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "key", valid_579033
  var valid_579034 = query.getOrDefault("prettyPrint")
  valid_579034 = validateParameter(valid_579034, JBool, required = false,
                                 default = newJBool(true))
  if valid_579034 != nil:
    section.add "prettyPrint", valid_579034
  var valid_579035 = query.getOrDefault("oauth_token")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "oauth_token", valid_579035
  var valid_579036 = query.getOrDefault("$.xgafv")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = newJString("1"))
  if valid_579036 != nil:
    section.add "$.xgafv", valid_579036
  var valid_579037 = query.getOrDefault("alt")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = newJString("json"))
  if valid_579037 != nil:
    section.add "alt", valid_579037
  var valid_579038 = query.getOrDefault("uploadType")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "uploadType", valid_579038
  var valid_579039 = query.getOrDefault("quotaUser")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "quotaUser", valid_579039
  var valid_579040 = query.getOrDefault("callback")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "callback", valid_579040
  var valid_579041 = query.getOrDefault("fields")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "fields", valid_579041
  var valid_579042 = query.getOrDefault("access_token")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "access_token", valid_579042
  var valid_579043 = query.getOrDefault("upload_protocol")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "upload_protocol", valid_579043
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

proc call*(call_579045: Call_ServicemanagementServicesConfigsCreate_579029;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new service configuration (version) for a managed service.
  ## This method only stores the service configuration. To roll out the service
  ## configuration to backend systems please call
  ## CreateServiceRollout.
  ## 
  ## Only the 100 most recent service configurations and ones referenced by
  ## existing rollouts are kept for each service. The rest will be deleted
  ## eventually.
  ## 
  let valid = call_579045.validator(path, query, header, formData, body)
  let scheme = call_579045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579045.url(scheme.get, call_579045.host, call_579045.base,
                         call_579045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579045, url, valid)

proc call*(call_579046: Call_ServicemanagementServicesConfigsCreate_579029;
          serviceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## servicemanagementServicesConfigsCreate
  ## Creates a new service configuration (version) for a managed service.
  ## This method only stores the service configuration. To roll out the service
  ## configuration to backend systems please call
  ## CreateServiceRollout.
  ## 
  ## Only the 100 most recent service configurations and ones referenced by
  ## existing rollouts are kept for each service. The rest will be deleted
  ## eventually.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   serviceName: string (required)
  ##              : The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
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
  var path_579047 = newJObject()
  var query_579048 = newJObject()
  var body_579049 = newJObject()
  add(query_579048, "key", newJString(key))
  add(query_579048, "prettyPrint", newJBool(prettyPrint))
  add(query_579048, "oauth_token", newJString(oauthToken))
  add(path_579047, "serviceName", newJString(serviceName))
  add(query_579048, "$.xgafv", newJString(Xgafv))
  add(query_579048, "alt", newJString(alt))
  add(query_579048, "uploadType", newJString(uploadType))
  add(query_579048, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579049 = body
  add(query_579048, "callback", newJString(callback))
  add(query_579048, "fields", newJString(fields))
  add(query_579048, "access_token", newJString(accessToken))
  add(query_579048, "upload_protocol", newJString(uploadProtocol))
  result = call_579046.call(path_579047, query_579048, nil, nil, body_579049)

var servicemanagementServicesConfigsCreate* = Call_ServicemanagementServicesConfigsCreate_579029(
    name: "servicemanagementServicesConfigsCreate", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/configs",
    validator: validate_ServicemanagementServicesConfigsCreate_579030, base: "/",
    url: url_ServicemanagementServicesConfigsCreate_579031,
    schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConfigsList_579008 = ref object of OpenApiRestCall_578348
proc url_ServicemanagementServicesConfigsList_579010(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/configs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicemanagementServicesConfigsList_579009(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the history of the service configuration for a managed service,
  ## from the newest to the oldest.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_579011 = path.getOrDefault("serviceName")
  valid_579011 = validateParameter(valid_579011, JString, required = true,
                                 default = nil)
  if valid_579011 != nil:
    section.add "serviceName", valid_579011
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
  ##           : The max number of items to include in the response list. Page size is 50
  ## if not specified. Maximum value is 100.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The token of the page to retrieve.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579012 = query.getOrDefault("key")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "key", valid_579012
  var valid_579013 = query.getOrDefault("prettyPrint")
  valid_579013 = validateParameter(valid_579013, JBool, required = false,
                                 default = newJBool(true))
  if valid_579013 != nil:
    section.add "prettyPrint", valid_579013
  var valid_579014 = query.getOrDefault("oauth_token")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "oauth_token", valid_579014
  var valid_579015 = query.getOrDefault("$.xgafv")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = newJString("1"))
  if valid_579015 != nil:
    section.add "$.xgafv", valid_579015
  var valid_579016 = query.getOrDefault("pageSize")
  valid_579016 = validateParameter(valid_579016, JInt, required = false, default = nil)
  if valid_579016 != nil:
    section.add "pageSize", valid_579016
  var valid_579017 = query.getOrDefault("alt")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = newJString("json"))
  if valid_579017 != nil:
    section.add "alt", valid_579017
  var valid_579018 = query.getOrDefault("uploadType")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "uploadType", valid_579018
  var valid_579019 = query.getOrDefault("quotaUser")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "quotaUser", valid_579019
  var valid_579020 = query.getOrDefault("pageToken")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "pageToken", valid_579020
  var valid_579021 = query.getOrDefault("callback")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "callback", valid_579021
  var valid_579022 = query.getOrDefault("fields")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "fields", valid_579022
  var valid_579023 = query.getOrDefault("access_token")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "access_token", valid_579023
  var valid_579024 = query.getOrDefault("upload_protocol")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "upload_protocol", valid_579024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579025: Call_ServicemanagementServicesConfigsList_579008;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the history of the service configuration for a managed service,
  ## from the newest to the oldest.
  ## 
  let valid = call_579025.validator(path, query, header, formData, body)
  let scheme = call_579025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579025.url(scheme.get, call_579025.host, call_579025.base,
                         call_579025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579025, url, valid)

proc call*(call_579026: Call_ServicemanagementServicesConfigsList_579008;
          serviceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicemanagementServicesConfigsList
  ## Lists the history of the service configuration for a managed service,
  ## from the newest to the oldest.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   serviceName: string (required)
  ##              : The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The max number of items to include in the response list. Page size is 50
  ## if not specified. Maximum value is 100.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The token of the page to retrieve.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579027 = newJObject()
  var query_579028 = newJObject()
  add(query_579028, "key", newJString(key))
  add(query_579028, "prettyPrint", newJBool(prettyPrint))
  add(query_579028, "oauth_token", newJString(oauthToken))
  add(path_579027, "serviceName", newJString(serviceName))
  add(query_579028, "$.xgafv", newJString(Xgafv))
  add(query_579028, "pageSize", newJInt(pageSize))
  add(query_579028, "alt", newJString(alt))
  add(query_579028, "uploadType", newJString(uploadType))
  add(query_579028, "quotaUser", newJString(quotaUser))
  add(query_579028, "pageToken", newJString(pageToken))
  add(query_579028, "callback", newJString(callback))
  add(query_579028, "fields", newJString(fields))
  add(query_579028, "access_token", newJString(accessToken))
  add(query_579028, "upload_protocol", newJString(uploadProtocol))
  result = call_579026.call(path_579027, query_579028, nil, nil, nil)

var servicemanagementServicesConfigsList* = Call_ServicemanagementServicesConfigsList_579008(
    name: "servicemanagementServicesConfigsList", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/configs",
    validator: validate_ServicemanagementServicesConfigsList_579009, base: "/",
    url: url_ServicemanagementServicesConfigsList_579010, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConfigsGet_579050 = ref object of OpenApiRestCall_578348
proc url_ServicemanagementServicesConfigsGet_579052(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "configId" in path, "`configId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/configs/"),
               (kind: VariableSegment, value: "configId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicemanagementServicesConfigsGet_579051(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a service configuration (version) for a managed service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  ##   configId: JString (required)
  ##           : The id of the service configuration resource.
  ## 
  ## This field must be specified for the server to return all fields, including
  ## `SourceInfo`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_579053 = path.getOrDefault("serviceName")
  valid_579053 = validateParameter(valid_579053, JString, required = true,
                                 default = nil)
  if valid_579053 != nil:
    section.add "serviceName", valid_579053
  var valid_579054 = path.getOrDefault("configId")
  valid_579054 = validateParameter(valid_579054, JString, required = true,
                                 default = nil)
  if valid_579054 != nil:
    section.add "configId", valid_579054
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
  ##   view: JString
  ##       : Specifies which parts of the Service Config should be returned in the
  ## response.
  section = newJObject()
  var valid_579055 = query.getOrDefault("key")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "key", valid_579055
  var valid_579056 = query.getOrDefault("prettyPrint")
  valid_579056 = validateParameter(valid_579056, JBool, required = false,
                                 default = newJBool(true))
  if valid_579056 != nil:
    section.add "prettyPrint", valid_579056
  var valid_579057 = query.getOrDefault("oauth_token")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "oauth_token", valid_579057
  var valid_579058 = query.getOrDefault("$.xgafv")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = newJString("1"))
  if valid_579058 != nil:
    section.add "$.xgafv", valid_579058
  var valid_579059 = query.getOrDefault("alt")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = newJString("json"))
  if valid_579059 != nil:
    section.add "alt", valid_579059
  var valid_579060 = query.getOrDefault("uploadType")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "uploadType", valid_579060
  var valid_579061 = query.getOrDefault("quotaUser")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "quotaUser", valid_579061
  var valid_579062 = query.getOrDefault("callback")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "callback", valid_579062
  var valid_579063 = query.getOrDefault("fields")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "fields", valid_579063
  var valid_579064 = query.getOrDefault("access_token")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "access_token", valid_579064
  var valid_579065 = query.getOrDefault("upload_protocol")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "upload_protocol", valid_579065
  var valid_579066 = query.getOrDefault("view")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_579066 != nil:
    section.add "view", valid_579066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579067: Call_ServicemanagementServicesConfigsGet_579050;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a service configuration (version) for a managed service.
  ## 
  let valid = call_579067.validator(path, query, header, formData, body)
  let scheme = call_579067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579067.url(scheme.get, call_579067.host, call_579067.base,
                         call_579067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579067, url, valid)

proc call*(call_579068: Call_ServicemanagementServicesConfigsGet_579050;
          serviceName: string; configId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; view: string = "BASIC"): Recallable =
  ## servicemanagementServicesConfigsGet
  ## Gets a service configuration (version) for a managed service.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   serviceName: string (required)
  ##              : The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   configId: string (required)
  ##           : The id of the service configuration resource.
  ## 
  ## This field must be specified for the server to return all fields, including
  ## `SourceInfo`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: string
  ##       : Specifies which parts of the Service Config should be returned in the
  ## response.
  var path_579069 = newJObject()
  var query_579070 = newJObject()
  add(query_579070, "key", newJString(key))
  add(query_579070, "prettyPrint", newJBool(prettyPrint))
  add(query_579070, "oauth_token", newJString(oauthToken))
  add(path_579069, "serviceName", newJString(serviceName))
  add(query_579070, "$.xgafv", newJString(Xgafv))
  add(query_579070, "alt", newJString(alt))
  add(query_579070, "uploadType", newJString(uploadType))
  add(query_579070, "quotaUser", newJString(quotaUser))
  add(path_579069, "configId", newJString(configId))
  add(query_579070, "callback", newJString(callback))
  add(query_579070, "fields", newJString(fields))
  add(query_579070, "access_token", newJString(accessToken))
  add(query_579070, "upload_protocol", newJString(uploadProtocol))
  add(query_579070, "view", newJString(view))
  result = call_579068.call(path_579069, query_579070, nil, nil, nil)

var servicemanagementServicesConfigsGet* = Call_ServicemanagementServicesConfigsGet_579050(
    name: "servicemanagementServicesConfigsGet", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/configs/{configId}",
    validator: validate_ServicemanagementServicesConfigsGet_579051, base: "/",
    url: url_ServicemanagementServicesConfigsGet_579052, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConfigsSubmit_579071 = ref object of OpenApiRestCall_578348
proc url_ServicemanagementServicesConfigsSubmit_579073(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/configs:submit")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicemanagementServicesConfigsSubmit_579072(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new service configuration (version) for a managed service based
  ## on
  ## user-supplied configuration source files (for example: OpenAPI
  ## Specification). This method stores the source configurations as well as the
  ## generated service configuration. To rollout the service configuration to
  ## other services,
  ## please call CreateServiceRollout.
  ## 
  ## Only the 100 most recent configuration sources and ones referenced by
  ## existing service configurtions are kept for each service. The rest will be
  ## deleted eventually.
  ## 
  ## Operation<response: SubmitConfigSourceResponse>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_579074 = path.getOrDefault("serviceName")
  valid_579074 = validateParameter(valid_579074, JString, required = true,
                                 default = nil)
  if valid_579074 != nil:
    section.add "serviceName", valid_579074
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
  var valid_579075 = query.getOrDefault("key")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "key", valid_579075
  var valid_579076 = query.getOrDefault("prettyPrint")
  valid_579076 = validateParameter(valid_579076, JBool, required = false,
                                 default = newJBool(true))
  if valid_579076 != nil:
    section.add "prettyPrint", valid_579076
  var valid_579077 = query.getOrDefault("oauth_token")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "oauth_token", valid_579077
  var valid_579078 = query.getOrDefault("$.xgafv")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = newJString("1"))
  if valid_579078 != nil:
    section.add "$.xgafv", valid_579078
  var valid_579079 = query.getOrDefault("alt")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = newJString("json"))
  if valid_579079 != nil:
    section.add "alt", valid_579079
  var valid_579080 = query.getOrDefault("uploadType")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "uploadType", valid_579080
  var valid_579081 = query.getOrDefault("quotaUser")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "quotaUser", valid_579081
  var valid_579082 = query.getOrDefault("callback")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "callback", valid_579082
  var valid_579083 = query.getOrDefault("fields")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "fields", valid_579083
  var valid_579084 = query.getOrDefault("access_token")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "access_token", valid_579084
  var valid_579085 = query.getOrDefault("upload_protocol")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "upload_protocol", valid_579085
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

proc call*(call_579087: Call_ServicemanagementServicesConfigsSubmit_579071;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new service configuration (version) for a managed service based
  ## on
  ## user-supplied configuration source files (for example: OpenAPI
  ## Specification). This method stores the source configurations as well as the
  ## generated service configuration. To rollout the service configuration to
  ## other services,
  ## please call CreateServiceRollout.
  ## 
  ## Only the 100 most recent configuration sources and ones referenced by
  ## existing service configurtions are kept for each service. The rest will be
  ## deleted eventually.
  ## 
  ## Operation<response: SubmitConfigSourceResponse>
  ## 
  let valid = call_579087.validator(path, query, header, formData, body)
  let scheme = call_579087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579087.url(scheme.get, call_579087.host, call_579087.base,
                         call_579087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579087, url, valid)

proc call*(call_579088: Call_ServicemanagementServicesConfigsSubmit_579071;
          serviceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## servicemanagementServicesConfigsSubmit
  ## Creates a new service configuration (version) for a managed service based
  ## on
  ## user-supplied configuration source files (for example: OpenAPI
  ## Specification). This method stores the source configurations as well as the
  ## generated service configuration. To rollout the service configuration to
  ## other services,
  ## please call CreateServiceRollout.
  ## 
  ## Only the 100 most recent configuration sources and ones referenced by
  ## existing service configurtions are kept for each service. The rest will be
  ## deleted eventually.
  ## 
  ## Operation<response: SubmitConfigSourceResponse>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   serviceName: string (required)
  ##              : The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
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
  var path_579089 = newJObject()
  var query_579090 = newJObject()
  var body_579091 = newJObject()
  add(query_579090, "key", newJString(key))
  add(query_579090, "prettyPrint", newJBool(prettyPrint))
  add(query_579090, "oauth_token", newJString(oauthToken))
  add(path_579089, "serviceName", newJString(serviceName))
  add(query_579090, "$.xgafv", newJString(Xgafv))
  add(query_579090, "alt", newJString(alt))
  add(query_579090, "uploadType", newJString(uploadType))
  add(query_579090, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579091 = body
  add(query_579090, "callback", newJString(callback))
  add(query_579090, "fields", newJString(fields))
  add(query_579090, "access_token", newJString(accessToken))
  add(query_579090, "upload_protocol", newJString(uploadProtocol))
  result = call_579088.call(path_579089, query_579090, nil, nil, body_579091)

var servicemanagementServicesConfigsSubmit* = Call_ServicemanagementServicesConfigsSubmit_579071(
    name: "servicemanagementServicesConfigsSubmit", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/configs:submit",
    validator: validate_ServicemanagementServicesConfigsSubmit_579072, base: "/",
    url: url_ServicemanagementServicesConfigsSubmit_579073,
    schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesRolloutsCreate_579114 = ref object of OpenApiRestCall_578348
proc url_ServicemanagementServicesRolloutsCreate_579116(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/rollouts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicemanagementServicesRolloutsCreate_579115(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new service configuration rollout. Based on rollout, the
  ## Google Service Management will roll out the service configurations to
  ## different backend services. For example, the logging configuration will be
  ## pushed to Google Cloud Logging.
  ## 
  ## Please note that any previous pending and running Rollouts and associated
  ## Operations will be automatically cancelled so that the latest Rollout will
  ## not be blocked by previous Rollouts.
  ## 
  ## Only the 100 most recent (in any state) and the last 10 successful (if not
  ## already part of the set of 100 most recent) rollouts are kept for each
  ## service. The rest will be deleted eventually.
  ## 
  ## Operation<response: Rollout>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_579117 = path.getOrDefault("serviceName")
  valid_579117 = validateParameter(valid_579117, JString, required = true,
                                 default = nil)
  if valid_579117 != nil:
    section.add "serviceName", valid_579117
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
  ##   baseRolloutId: JString
  ##                : Unimplemented. Do not use this feature until this comment is removed.
  ## 
  ## The rollout id that rollout to be created based on.
  ## 
  ## Rollout should be constructed based on current successful rollout, this
  ## field indicates the current successful rollout id that new rollout based on
  ## to construct, if current successful rollout changed when server receives
  ## the request, request will be rejected for safety.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579118 = query.getOrDefault("key")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "key", valid_579118
  var valid_579119 = query.getOrDefault("prettyPrint")
  valid_579119 = validateParameter(valid_579119, JBool, required = false,
                                 default = newJBool(true))
  if valid_579119 != nil:
    section.add "prettyPrint", valid_579119
  var valid_579120 = query.getOrDefault("oauth_token")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "oauth_token", valid_579120
  var valid_579121 = query.getOrDefault("$.xgafv")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = newJString("1"))
  if valid_579121 != nil:
    section.add "$.xgafv", valid_579121
  var valid_579122 = query.getOrDefault("alt")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = newJString("json"))
  if valid_579122 != nil:
    section.add "alt", valid_579122
  var valid_579123 = query.getOrDefault("uploadType")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "uploadType", valid_579123
  var valid_579124 = query.getOrDefault("quotaUser")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "quotaUser", valid_579124
  var valid_579125 = query.getOrDefault("baseRolloutId")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "baseRolloutId", valid_579125
  var valid_579126 = query.getOrDefault("callback")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "callback", valid_579126
  var valid_579127 = query.getOrDefault("fields")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "fields", valid_579127
  var valid_579128 = query.getOrDefault("access_token")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "access_token", valid_579128
  var valid_579129 = query.getOrDefault("upload_protocol")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "upload_protocol", valid_579129
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

proc call*(call_579131: Call_ServicemanagementServicesRolloutsCreate_579114;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new service configuration rollout. Based on rollout, the
  ## Google Service Management will roll out the service configurations to
  ## different backend services. For example, the logging configuration will be
  ## pushed to Google Cloud Logging.
  ## 
  ## Please note that any previous pending and running Rollouts and associated
  ## Operations will be automatically cancelled so that the latest Rollout will
  ## not be blocked by previous Rollouts.
  ## 
  ## Only the 100 most recent (in any state) and the last 10 successful (if not
  ## already part of the set of 100 most recent) rollouts are kept for each
  ## service. The rest will be deleted eventually.
  ## 
  ## Operation<response: Rollout>
  ## 
  let valid = call_579131.validator(path, query, header, formData, body)
  let scheme = call_579131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579131.url(scheme.get, call_579131.host, call_579131.base,
                         call_579131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579131, url, valid)

proc call*(call_579132: Call_ServicemanagementServicesRolloutsCreate_579114;
          serviceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; baseRolloutId: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicemanagementServicesRolloutsCreate
  ## Creates a new service configuration rollout. Based on rollout, the
  ## Google Service Management will roll out the service configurations to
  ## different backend services. For example, the logging configuration will be
  ## pushed to Google Cloud Logging.
  ## 
  ## Please note that any previous pending and running Rollouts and associated
  ## Operations will be automatically cancelled so that the latest Rollout will
  ## not be blocked by previous Rollouts.
  ## 
  ## Only the 100 most recent (in any state) and the last 10 successful (if not
  ## already part of the set of 100 most recent) rollouts are kept for each
  ## service. The rest will be deleted eventually.
  ## 
  ## Operation<response: Rollout>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   serviceName: string (required)
  ##              : The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   baseRolloutId: string
  ##                : Unimplemented. Do not use this feature until this comment is removed.
  ## 
  ## The rollout id that rollout to be created based on.
  ## 
  ## Rollout should be constructed based on current successful rollout, this
  ## field indicates the current successful rollout id that new rollout based on
  ## to construct, if current successful rollout changed when server receives
  ## the request, request will be rejected for safety.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579133 = newJObject()
  var query_579134 = newJObject()
  var body_579135 = newJObject()
  add(query_579134, "key", newJString(key))
  add(query_579134, "prettyPrint", newJBool(prettyPrint))
  add(query_579134, "oauth_token", newJString(oauthToken))
  add(path_579133, "serviceName", newJString(serviceName))
  add(query_579134, "$.xgafv", newJString(Xgafv))
  add(query_579134, "alt", newJString(alt))
  add(query_579134, "uploadType", newJString(uploadType))
  add(query_579134, "quotaUser", newJString(quotaUser))
  add(query_579134, "baseRolloutId", newJString(baseRolloutId))
  if body != nil:
    body_579135 = body
  add(query_579134, "callback", newJString(callback))
  add(query_579134, "fields", newJString(fields))
  add(query_579134, "access_token", newJString(accessToken))
  add(query_579134, "upload_protocol", newJString(uploadProtocol))
  result = call_579132.call(path_579133, query_579134, nil, nil, body_579135)

var servicemanagementServicesRolloutsCreate* = Call_ServicemanagementServicesRolloutsCreate_579114(
    name: "servicemanagementServicesRolloutsCreate", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/rollouts",
    validator: validate_ServicemanagementServicesRolloutsCreate_579115, base: "/",
    url: url_ServicemanagementServicesRolloutsCreate_579116,
    schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesRolloutsList_579092 = ref object of OpenApiRestCall_578348
proc url_ServicemanagementServicesRolloutsList_579094(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/rollouts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicemanagementServicesRolloutsList_579093(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the history of the service configuration rollouts for a managed
  ## service, from the newest to the oldest.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_579095 = path.getOrDefault("serviceName")
  valid_579095 = validateParameter(valid_579095, JString, required = true,
                                 default = nil)
  if valid_579095 != nil:
    section.add "serviceName", valid_579095
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
  ##           : The max number of items to include in the response list. Page size is 50
  ## if not specified. Maximum value is 100.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : Use `filter` to return subset of rollouts.
  ## The following filters are supported:
  ##   -- To limit the results to only those in
  ##      [status](google.api.servicemanagement.v1.RolloutStatus) 'SUCCESS',
  ##      use filter='status=SUCCESS'
  ##   -- To limit the results to those in
  ##      [status](google.api.servicemanagement.v1.RolloutStatus) 'CANCELLED'
  ##      or 'FAILED', use filter='status=CANCELLED OR status=FAILED'
  ##   pageToken: JString
  ##            : The token of the page to retrieve.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579096 = query.getOrDefault("key")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "key", valid_579096
  var valid_579097 = query.getOrDefault("prettyPrint")
  valid_579097 = validateParameter(valid_579097, JBool, required = false,
                                 default = newJBool(true))
  if valid_579097 != nil:
    section.add "prettyPrint", valid_579097
  var valid_579098 = query.getOrDefault("oauth_token")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "oauth_token", valid_579098
  var valid_579099 = query.getOrDefault("$.xgafv")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = newJString("1"))
  if valid_579099 != nil:
    section.add "$.xgafv", valid_579099
  var valid_579100 = query.getOrDefault("pageSize")
  valid_579100 = validateParameter(valid_579100, JInt, required = false, default = nil)
  if valid_579100 != nil:
    section.add "pageSize", valid_579100
  var valid_579101 = query.getOrDefault("alt")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = newJString("json"))
  if valid_579101 != nil:
    section.add "alt", valid_579101
  var valid_579102 = query.getOrDefault("uploadType")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "uploadType", valid_579102
  var valid_579103 = query.getOrDefault("quotaUser")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "quotaUser", valid_579103
  var valid_579104 = query.getOrDefault("filter")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "filter", valid_579104
  var valid_579105 = query.getOrDefault("pageToken")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "pageToken", valid_579105
  var valid_579106 = query.getOrDefault("callback")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "callback", valid_579106
  var valid_579107 = query.getOrDefault("fields")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "fields", valid_579107
  var valid_579108 = query.getOrDefault("access_token")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "access_token", valid_579108
  var valid_579109 = query.getOrDefault("upload_protocol")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "upload_protocol", valid_579109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579110: Call_ServicemanagementServicesRolloutsList_579092;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the history of the service configuration rollouts for a managed
  ## service, from the newest to the oldest.
  ## 
  let valid = call_579110.validator(path, query, header, formData, body)
  let scheme = call_579110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579110.url(scheme.get, call_579110.host, call_579110.base,
                         call_579110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579110, url, valid)

proc call*(call_579111: Call_ServicemanagementServicesRolloutsList_579092;
          serviceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicemanagementServicesRolloutsList
  ## Lists the history of the service configuration rollouts for a managed
  ## service, from the newest to the oldest.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   serviceName: string (required)
  ##              : The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The max number of items to include in the response list. Page size is 50
  ## if not specified. Maximum value is 100.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : Use `filter` to return subset of rollouts.
  ## The following filters are supported:
  ##   -- To limit the results to only those in
  ##      [status](google.api.servicemanagement.v1.RolloutStatus) 'SUCCESS',
  ##      use filter='status=SUCCESS'
  ##   -- To limit the results to those in
  ##      [status](google.api.servicemanagement.v1.RolloutStatus) 'CANCELLED'
  ##      or 'FAILED', use filter='status=CANCELLED OR status=FAILED'
  ##   pageToken: string
  ##            : The token of the page to retrieve.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579112 = newJObject()
  var query_579113 = newJObject()
  add(query_579113, "key", newJString(key))
  add(query_579113, "prettyPrint", newJBool(prettyPrint))
  add(query_579113, "oauth_token", newJString(oauthToken))
  add(path_579112, "serviceName", newJString(serviceName))
  add(query_579113, "$.xgafv", newJString(Xgafv))
  add(query_579113, "pageSize", newJInt(pageSize))
  add(query_579113, "alt", newJString(alt))
  add(query_579113, "uploadType", newJString(uploadType))
  add(query_579113, "quotaUser", newJString(quotaUser))
  add(query_579113, "filter", newJString(filter))
  add(query_579113, "pageToken", newJString(pageToken))
  add(query_579113, "callback", newJString(callback))
  add(query_579113, "fields", newJString(fields))
  add(query_579113, "access_token", newJString(accessToken))
  add(query_579113, "upload_protocol", newJString(uploadProtocol))
  result = call_579111.call(path_579112, query_579113, nil, nil, nil)

var servicemanagementServicesRolloutsList* = Call_ServicemanagementServicesRolloutsList_579092(
    name: "servicemanagementServicesRolloutsList", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/rollouts",
    validator: validate_ServicemanagementServicesRolloutsList_579093, base: "/",
    url: url_ServicemanagementServicesRolloutsList_579094, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesRolloutsGet_579136 = ref object of OpenApiRestCall_578348
proc url_ServicemanagementServicesRolloutsGet_579138(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "rolloutId" in path, "`rolloutId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/rollouts/"),
               (kind: VariableSegment, value: "rolloutId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicemanagementServicesRolloutsGet_579137(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a service configuration rollout.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  ##   rolloutId: JString (required)
  ##            : The id of the rollout resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_579139 = path.getOrDefault("serviceName")
  valid_579139 = validateParameter(valid_579139, JString, required = true,
                                 default = nil)
  if valid_579139 != nil:
    section.add "serviceName", valid_579139
  var valid_579140 = path.getOrDefault("rolloutId")
  valid_579140 = validateParameter(valid_579140, JString, required = true,
                                 default = nil)
  if valid_579140 != nil:
    section.add "rolloutId", valid_579140
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
  var valid_579141 = query.getOrDefault("key")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "key", valid_579141
  var valid_579142 = query.getOrDefault("prettyPrint")
  valid_579142 = validateParameter(valid_579142, JBool, required = false,
                                 default = newJBool(true))
  if valid_579142 != nil:
    section.add "prettyPrint", valid_579142
  var valid_579143 = query.getOrDefault("oauth_token")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "oauth_token", valid_579143
  var valid_579144 = query.getOrDefault("$.xgafv")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = newJString("1"))
  if valid_579144 != nil:
    section.add "$.xgafv", valid_579144
  var valid_579145 = query.getOrDefault("alt")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = newJString("json"))
  if valid_579145 != nil:
    section.add "alt", valid_579145
  var valid_579146 = query.getOrDefault("uploadType")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "uploadType", valid_579146
  var valid_579147 = query.getOrDefault("quotaUser")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "quotaUser", valid_579147
  var valid_579148 = query.getOrDefault("callback")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "callback", valid_579148
  var valid_579149 = query.getOrDefault("fields")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = nil)
  if valid_579149 != nil:
    section.add "fields", valid_579149
  var valid_579150 = query.getOrDefault("access_token")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = nil)
  if valid_579150 != nil:
    section.add "access_token", valid_579150
  var valid_579151 = query.getOrDefault("upload_protocol")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = nil)
  if valid_579151 != nil:
    section.add "upload_protocol", valid_579151
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579152: Call_ServicemanagementServicesRolloutsGet_579136;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a service configuration rollout.
  ## 
  let valid = call_579152.validator(path, query, header, formData, body)
  let scheme = call_579152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579152.url(scheme.get, call_579152.host, call_579152.base,
                         call_579152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579152, url, valid)

proc call*(call_579153: Call_ServicemanagementServicesRolloutsGet_579136;
          serviceName: string; rolloutId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## servicemanagementServicesRolloutsGet
  ## Gets a service configuration rollout.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   serviceName: string (required)
  ##              : The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   rolloutId: string (required)
  ##            : The id of the rollout resource.
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
  var path_579154 = newJObject()
  var query_579155 = newJObject()
  add(query_579155, "key", newJString(key))
  add(query_579155, "prettyPrint", newJBool(prettyPrint))
  add(query_579155, "oauth_token", newJString(oauthToken))
  add(path_579154, "serviceName", newJString(serviceName))
  add(query_579155, "$.xgafv", newJString(Xgafv))
  add(path_579154, "rolloutId", newJString(rolloutId))
  add(query_579155, "alt", newJString(alt))
  add(query_579155, "uploadType", newJString(uploadType))
  add(query_579155, "quotaUser", newJString(quotaUser))
  add(query_579155, "callback", newJString(callback))
  add(query_579155, "fields", newJString(fields))
  add(query_579155, "access_token", newJString(accessToken))
  add(query_579155, "upload_protocol", newJString(uploadProtocol))
  result = call_579153.call(path_579154, query_579155, nil, nil, nil)

var servicemanagementServicesRolloutsGet* = Call_ServicemanagementServicesRolloutsGet_579136(
    name: "servicemanagementServicesRolloutsGet", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/rollouts/{rolloutId}",
    validator: validate_ServicemanagementServicesRolloutsGet_579137, base: "/",
    url: url_ServicemanagementServicesRolloutsGet_579138, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesDisable_579156 = ref object of OpenApiRestCall_578348
proc url_ServicemanagementServicesDisable_579158(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: ":disable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicemanagementServicesDisable_579157(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Disables a service for a project, so it can no longer be
  ## be used for the project. It prevents accidental usage that may cause
  ## unexpected billing charges or security leaks.
  ## 
  ## Operation<response: DisableServiceResponse>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : Name of the service to disable. Specifying an unknown service name
  ## will cause the request to fail.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_579159 = path.getOrDefault("serviceName")
  valid_579159 = validateParameter(valid_579159, JString, required = true,
                                 default = nil)
  if valid_579159 != nil:
    section.add "serviceName", valid_579159
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
  var valid_579160 = query.getOrDefault("key")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "key", valid_579160
  var valid_579161 = query.getOrDefault("prettyPrint")
  valid_579161 = validateParameter(valid_579161, JBool, required = false,
                                 default = newJBool(true))
  if valid_579161 != nil:
    section.add "prettyPrint", valid_579161
  var valid_579162 = query.getOrDefault("oauth_token")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "oauth_token", valid_579162
  var valid_579163 = query.getOrDefault("$.xgafv")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = newJString("1"))
  if valid_579163 != nil:
    section.add "$.xgafv", valid_579163
  var valid_579164 = query.getOrDefault("alt")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = newJString("json"))
  if valid_579164 != nil:
    section.add "alt", valid_579164
  var valid_579165 = query.getOrDefault("uploadType")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "uploadType", valid_579165
  var valid_579166 = query.getOrDefault("quotaUser")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = nil)
  if valid_579166 != nil:
    section.add "quotaUser", valid_579166
  var valid_579167 = query.getOrDefault("callback")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = nil)
  if valid_579167 != nil:
    section.add "callback", valid_579167
  var valid_579168 = query.getOrDefault("fields")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = nil)
  if valid_579168 != nil:
    section.add "fields", valid_579168
  var valid_579169 = query.getOrDefault("access_token")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "access_token", valid_579169
  var valid_579170 = query.getOrDefault("upload_protocol")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = nil)
  if valid_579170 != nil:
    section.add "upload_protocol", valid_579170
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

proc call*(call_579172: Call_ServicemanagementServicesDisable_579156;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Disables a service for a project, so it can no longer be
  ## be used for the project. It prevents accidental usage that may cause
  ## unexpected billing charges or security leaks.
  ## 
  ## Operation<response: DisableServiceResponse>
  ## 
  let valid = call_579172.validator(path, query, header, formData, body)
  let scheme = call_579172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579172.url(scheme.get, call_579172.host, call_579172.base,
                         call_579172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579172, url, valid)

proc call*(call_579173: Call_ServicemanagementServicesDisable_579156;
          serviceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## servicemanagementServicesDisable
  ## Disables a service for a project, so it can no longer be
  ## be used for the project. It prevents accidental usage that may cause
  ## unexpected billing charges or security leaks.
  ## 
  ## Operation<response: DisableServiceResponse>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   serviceName: string (required)
  ##              : Name of the service to disable. Specifying an unknown service name
  ## will cause the request to fail.
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
  var path_579174 = newJObject()
  var query_579175 = newJObject()
  var body_579176 = newJObject()
  add(query_579175, "key", newJString(key))
  add(query_579175, "prettyPrint", newJBool(prettyPrint))
  add(query_579175, "oauth_token", newJString(oauthToken))
  add(path_579174, "serviceName", newJString(serviceName))
  add(query_579175, "$.xgafv", newJString(Xgafv))
  add(query_579175, "alt", newJString(alt))
  add(query_579175, "uploadType", newJString(uploadType))
  add(query_579175, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579176 = body
  add(query_579175, "callback", newJString(callback))
  add(query_579175, "fields", newJString(fields))
  add(query_579175, "access_token", newJString(accessToken))
  add(query_579175, "upload_protocol", newJString(uploadProtocol))
  result = call_579173.call(path_579174, query_579175, nil, nil, body_579176)

var servicemanagementServicesDisable* = Call_ServicemanagementServicesDisable_579156(
    name: "servicemanagementServicesDisable", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}:disable",
    validator: validate_ServicemanagementServicesDisable_579157, base: "/",
    url: url_ServicemanagementServicesDisable_579158, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesEnable_579177 = ref object of OpenApiRestCall_578348
proc url_ServicemanagementServicesEnable_579179(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: ":enable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicemanagementServicesEnable_579178(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Enables a service for a project, so it can be used
  ## for the project. See
  ## [Cloud Auth Guide](https://cloud.google.com/docs/authentication) for
  ## more information.
  ## 
  ## Operation<response: EnableServiceResponse>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : Name of the service to enable. Specifying an unknown service name will
  ## cause the request to fail.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_579180 = path.getOrDefault("serviceName")
  valid_579180 = validateParameter(valid_579180, JString, required = true,
                                 default = nil)
  if valid_579180 != nil:
    section.add "serviceName", valid_579180
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
  var valid_579181 = query.getOrDefault("key")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "key", valid_579181
  var valid_579182 = query.getOrDefault("prettyPrint")
  valid_579182 = validateParameter(valid_579182, JBool, required = false,
                                 default = newJBool(true))
  if valid_579182 != nil:
    section.add "prettyPrint", valid_579182
  var valid_579183 = query.getOrDefault("oauth_token")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "oauth_token", valid_579183
  var valid_579184 = query.getOrDefault("$.xgafv")
  valid_579184 = validateParameter(valid_579184, JString, required = false,
                                 default = newJString("1"))
  if valid_579184 != nil:
    section.add "$.xgafv", valid_579184
  var valid_579185 = query.getOrDefault("alt")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = newJString("json"))
  if valid_579185 != nil:
    section.add "alt", valid_579185
  var valid_579186 = query.getOrDefault("uploadType")
  valid_579186 = validateParameter(valid_579186, JString, required = false,
                                 default = nil)
  if valid_579186 != nil:
    section.add "uploadType", valid_579186
  var valid_579187 = query.getOrDefault("quotaUser")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = nil)
  if valid_579187 != nil:
    section.add "quotaUser", valid_579187
  var valid_579188 = query.getOrDefault("callback")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = nil)
  if valid_579188 != nil:
    section.add "callback", valid_579188
  var valid_579189 = query.getOrDefault("fields")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "fields", valid_579189
  var valid_579190 = query.getOrDefault("access_token")
  valid_579190 = validateParameter(valid_579190, JString, required = false,
                                 default = nil)
  if valid_579190 != nil:
    section.add "access_token", valid_579190
  var valid_579191 = query.getOrDefault("upload_protocol")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "upload_protocol", valid_579191
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

proc call*(call_579193: Call_ServicemanagementServicesEnable_579177;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables a service for a project, so it can be used
  ## for the project. See
  ## [Cloud Auth Guide](https://cloud.google.com/docs/authentication) for
  ## more information.
  ## 
  ## Operation<response: EnableServiceResponse>
  ## 
  let valid = call_579193.validator(path, query, header, formData, body)
  let scheme = call_579193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579193.url(scheme.get, call_579193.host, call_579193.base,
                         call_579193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579193, url, valid)

proc call*(call_579194: Call_ServicemanagementServicesEnable_579177;
          serviceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## servicemanagementServicesEnable
  ## Enables a service for a project, so it can be used
  ## for the project. See
  ## [Cloud Auth Guide](https://cloud.google.com/docs/authentication) for
  ## more information.
  ## 
  ## Operation<response: EnableServiceResponse>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   serviceName: string (required)
  ##              : Name of the service to enable. Specifying an unknown service name will
  ## cause the request to fail.
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
  var path_579195 = newJObject()
  var query_579196 = newJObject()
  var body_579197 = newJObject()
  add(query_579196, "key", newJString(key))
  add(query_579196, "prettyPrint", newJBool(prettyPrint))
  add(query_579196, "oauth_token", newJString(oauthToken))
  add(path_579195, "serviceName", newJString(serviceName))
  add(query_579196, "$.xgafv", newJString(Xgafv))
  add(query_579196, "alt", newJString(alt))
  add(query_579196, "uploadType", newJString(uploadType))
  add(query_579196, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579197 = body
  add(query_579196, "callback", newJString(callback))
  add(query_579196, "fields", newJString(fields))
  add(query_579196, "access_token", newJString(accessToken))
  add(query_579196, "upload_protocol", newJString(uploadProtocol))
  result = call_579194.call(path_579195, query_579196, nil, nil, body_579197)

var servicemanagementServicesEnable* = Call_ServicemanagementServicesEnable_579177(
    name: "servicemanagementServicesEnable", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}:enable",
    validator: validate_ServicemanagementServicesEnable_579178, base: "/",
    url: url_ServicemanagementServicesEnable_579179, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesUndelete_579198 = ref object of OpenApiRestCall_578348
proc url_ServicemanagementServicesUndelete_579200(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: ":undelete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicemanagementServicesUndelete_579199(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Revives a previously deleted managed service. The method restores the
  ## service using the configuration at the time the service was deleted.
  ## The target service must exist and must have been deleted within the
  ## last 30 days.
  ## 
  ## Operation<response: UndeleteServiceResponse>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the service. See the [overview](/service-management/overview)
  ## for naming requirements. For example: `example.googleapis.com`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_579201 = path.getOrDefault("serviceName")
  valid_579201 = validateParameter(valid_579201, JString, required = true,
                                 default = nil)
  if valid_579201 != nil:
    section.add "serviceName", valid_579201
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
  var valid_579202 = query.getOrDefault("key")
  valid_579202 = validateParameter(valid_579202, JString, required = false,
                                 default = nil)
  if valid_579202 != nil:
    section.add "key", valid_579202
  var valid_579203 = query.getOrDefault("prettyPrint")
  valid_579203 = validateParameter(valid_579203, JBool, required = false,
                                 default = newJBool(true))
  if valid_579203 != nil:
    section.add "prettyPrint", valid_579203
  var valid_579204 = query.getOrDefault("oauth_token")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = nil)
  if valid_579204 != nil:
    section.add "oauth_token", valid_579204
  var valid_579205 = query.getOrDefault("$.xgafv")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = newJString("1"))
  if valid_579205 != nil:
    section.add "$.xgafv", valid_579205
  var valid_579206 = query.getOrDefault("alt")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = newJString("json"))
  if valid_579206 != nil:
    section.add "alt", valid_579206
  var valid_579207 = query.getOrDefault("uploadType")
  valid_579207 = validateParameter(valid_579207, JString, required = false,
                                 default = nil)
  if valid_579207 != nil:
    section.add "uploadType", valid_579207
  var valid_579208 = query.getOrDefault("quotaUser")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = nil)
  if valid_579208 != nil:
    section.add "quotaUser", valid_579208
  var valid_579209 = query.getOrDefault("callback")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = nil)
  if valid_579209 != nil:
    section.add "callback", valid_579209
  var valid_579210 = query.getOrDefault("fields")
  valid_579210 = validateParameter(valid_579210, JString, required = false,
                                 default = nil)
  if valid_579210 != nil:
    section.add "fields", valid_579210
  var valid_579211 = query.getOrDefault("access_token")
  valid_579211 = validateParameter(valid_579211, JString, required = false,
                                 default = nil)
  if valid_579211 != nil:
    section.add "access_token", valid_579211
  var valid_579212 = query.getOrDefault("upload_protocol")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = nil)
  if valid_579212 != nil:
    section.add "upload_protocol", valid_579212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579213: Call_ServicemanagementServicesUndelete_579198;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Revives a previously deleted managed service. The method restores the
  ## service using the configuration at the time the service was deleted.
  ## The target service must exist and must have been deleted within the
  ## last 30 days.
  ## 
  ## Operation<response: UndeleteServiceResponse>
  ## 
  let valid = call_579213.validator(path, query, header, formData, body)
  let scheme = call_579213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579213.url(scheme.get, call_579213.host, call_579213.base,
                         call_579213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579213, url, valid)

proc call*(call_579214: Call_ServicemanagementServicesUndelete_579198;
          serviceName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicemanagementServicesUndelete
  ## Revives a previously deleted managed service. The method restores the
  ## service using the configuration at the time the service was deleted.
  ## The target service must exist and must have been deleted within the
  ## last 30 days.
  ## 
  ## Operation<response: UndeleteServiceResponse>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   serviceName: string (required)
  ##              : The name of the service. See the [overview](/service-management/overview)
  ## for naming requirements. For example: `example.googleapis.com`.
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
  var path_579215 = newJObject()
  var query_579216 = newJObject()
  add(query_579216, "key", newJString(key))
  add(query_579216, "prettyPrint", newJBool(prettyPrint))
  add(query_579216, "oauth_token", newJString(oauthToken))
  add(path_579215, "serviceName", newJString(serviceName))
  add(query_579216, "$.xgafv", newJString(Xgafv))
  add(query_579216, "alt", newJString(alt))
  add(query_579216, "uploadType", newJString(uploadType))
  add(query_579216, "quotaUser", newJString(quotaUser))
  add(query_579216, "callback", newJString(callback))
  add(query_579216, "fields", newJString(fields))
  add(query_579216, "access_token", newJString(accessToken))
  add(query_579216, "upload_protocol", newJString(uploadProtocol))
  result = call_579214.call(path_579215, query_579216, nil, nil, nil)

var servicemanagementServicesUndelete* = Call_ServicemanagementServicesUndelete_579198(
    name: "servicemanagementServicesUndelete", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}:undelete",
    validator: validate_ServicemanagementServicesUndelete_579199, base: "/",
    url: url_ServicemanagementServicesUndelete_579200, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesGenerateConfigReport_579217 = ref object of OpenApiRestCall_578348
proc url_ServicemanagementServicesGenerateConfigReport_579219(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ServicemanagementServicesGenerateConfigReport_579218(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Generates and returns a report (errors, warnings and changes from
  ## existing configurations) associated with
  ## GenerateConfigReportRequest.new_value
  ## 
  ## If GenerateConfigReportRequest.old_value is specified,
  ## GenerateConfigReportRequest will contain a single ChangeReport based on the
  ## comparison between GenerateConfigReportRequest.new_value and
  ## GenerateConfigReportRequest.old_value.
  ## If GenerateConfigReportRequest.old_value is not specified, this method
  ## will compare GenerateConfigReportRequest.new_value with the last pushed
  ## service configuration.
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
  var valid_579220 = query.getOrDefault("key")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = nil)
  if valid_579220 != nil:
    section.add "key", valid_579220
  var valid_579221 = query.getOrDefault("prettyPrint")
  valid_579221 = validateParameter(valid_579221, JBool, required = false,
                                 default = newJBool(true))
  if valid_579221 != nil:
    section.add "prettyPrint", valid_579221
  var valid_579222 = query.getOrDefault("oauth_token")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = nil)
  if valid_579222 != nil:
    section.add "oauth_token", valid_579222
  var valid_579223 = query.getOrDefault("$.xgafv")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = newJString("1"))
  if valid_579223 != nil:
    section.add "$.xgafv", valid_579223
  var valid_579224 = query.getOrDefault("alt")
  valid_579224 = validateParameter(valid_579224, JString, required = false,
                                 default = newJString("json"))
  if valid_579224 != nil:
    section.add "alt", valid_579224
  var valid_579225 = query.getOrDefault("uploadType")
  valid_579225 = validateParameter(valid_579225, JString, required = false,
                                 default = nil)
  if valid_579225 != nil:
    section.add "uploadType", valid_579225
  var valid_579226 = query.getOrDefault("quotaUser")
  valid_579226 = validateParameter(valid_579226, JString, required = false,
                                 default = nil)
  if valid_579226 != nil:
    section.add "quotaUser", valid_579226
  var valid_579227 = query.getOrDefault("callback")
  valid_579227 = validateParameter(valid_579227, JString, required = false,
                                 default = nil)
  if valid_579227 != nil:
    section.add "callback", valid_579227
  var valid_579228 = query.getOrDefault("fields")
  valid_579228 = validateParameter(valid_579228, JString, required = false,
                                 default = nil)
  if valid_579228 != nil:
    section.add "fields", valid_579228
  var valid_579229 = query.getOrDefault("access_token")
  valid_579229 = validateParameter(valid_579229, JString, required = false,
                                 default = nil)
  if valid_579229 != nil:
    section.add "access_token", valid_579229
  var valid_579230 = query.getOrDefault("upload_protocol")
  valid_579230 = validateParameter(valid_579230, JString, required = false,
                                 default = nil)
  if valid_579230 != nil:
    section.add "upload_protocol", valid_579230
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

proc call*(call_579232: Call_ServicemanagementServicesGenerateConfigReport_579217;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates and returns a report (errors, warnings and changes from
  ## existing configurations) associated with
  ## GenerateConfigReportRequest.new_value
  ## 
  ## If GenerateConfigReportRequest.old_value is specified,
  ## GenerateConfigReportRequest will contain a single ChangeReport based on the
  ## comparison between GenerateConfigReportRequest.new_value and
  ## GenerateConfigReportRequest.old_value.
  ## If GenerateConfigReportRequest.old_value is not specified, this method
  ## will compare GenerateConfigReportRequest.new_value with the last pushed
  ## service configuration.
  ## 
  let valid = call_579232.validator(path, query, header, formData, body)
  let scheme = call_579232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579232.url(scheme.get, call_579232.host, call_579232.base,
                         call_579232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579232, url, valid)

proc call*(call_579233: Call_ServicemanagementServicesGenerateConfigReport_579217;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicemanagementServicesGenerateConfigReport
  ## Generates and returns a report (errors, warnings and changes from
  ## existing configurations) associated with
  ## GenerateConfigReportRequest.new_value
  ## 
  ## If GenerateConfigReportRequest.old_value is specified,
  ## GenerateConfigReportRequest will contain a single ChangeReport based on the
  ## comparison between GenerateConfigReportRequest.new_value and
  ## GenerateConfigReportRequest.old_value.
  ## If GenerateConfigReportRequest.old_value is not specified, this method
  ## will compare GenerateConfigReportRequest.new_value with the last pushed
  ## service configuration.
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
  var query_579234 = newJObject()
  var body_579235 = newJObject()
  add(query_579234, "key", newJString(key))
  add(query_579234, "prettyPrint", newJBool(prettyPrint))
  add(query_579234, "oauth_token", newJString(oauthToken))
  add(query_579234, "$.xgafv", newJString(Xgafv))
  add(query_579234, "alt", newJString(alt))
  add(query_579234, "uploadType", newJString(uploadType))
  add(query_579234, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579235 = body
  add(query_579234, "callback", newJString(callback))
  add(query_579234, "fields", newJString(fields))
  add(query_579234, "access_token", newJString(accessToken))
  add(query_579234, "upload_protocol", newJString(uploadProtocol))
  result = call_579233.call(nil, query_579234, nil, nil, body_579235)

var servicemanagementServicesGenerateConfigReport* = Call_ServicemanagementServicesGenerateConfigReport_579217(
    name: "servicemanagementServicesGenerateConfigReport",
    meth: HttpMethod.HttpPost, host: "servicemanagement.googleapis.com",
    route: "/v1/services:generateConfigReport",
    validator: validate_ServicemanagementServicesGenerateConfigReport_579218,
    base: "/", url: url_ServicemanagementServicesGenerateConfigReport_579219,
    schemes: {Scheme.Https})
type
  Call_ServicemanagementOperationsGet_579236 = ref object of OpenApiRestCall_578348
proc url_ServicemanagementOperationsGet_579238(protocol: Scheme; host: string;
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

proc validate_ServicemanagementOperationsGet_579237(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource.
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
  if body != nil:
    result.add "body", body

proc call*(call_579251: Call_ServicemanagementOperationsGet_579236; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_579251.validator(path, query, header, formData, body)
  let scheme = call_579251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579251.url(scheme.get, call_579251.host, call_579251.base,
                         call_579251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579251, url, valid)

proc call*(call_579252: Call_ServicemanagementOperationsGet_579236; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicemanagementOperationsGet
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
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
  ##       : The name of the operation resource.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579253 = newJObject()
  var query_579254 = newJObject()
  add(query_579254, "key", newJString(key))
  add(query_579254, "prettyPrint", newJBool(prettyPrint))
  add(query_579254, "oauth_token", newJString(oauthToken))
  add(query_579254, "$.xgafv", newJString(Xgafv))
  add(query_579254, "alt", newJString(alt))
  add(query_579254, "uploadType", newJString(uploadType))
  add(query_579254, "quotaUser", newJString(quotaUser))
  add(path_579253, "name", newJString(name))
  add(query_579254, "callback", newJString(callback))
  add(query_579254, "fields", newJString(fields))
  add(query_579254, "access_token", newJString(accessToken))
  add(query_579254, "upload_protocol", newJString(uploadProtocol))
  result = call_579252.call(path_579253, query_579254, nil, nil, nil)

var servicemanagementOperationsGet* = Call_ServicemanagementOperationsGet_579236(
    name: "servicemanagementOperationsGet", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com", route: "/v1/{name}",
    validator: validate_ServicemanagementOperationsGet_579237, base: "/",
    url: url_ServicemanagementOperationsGet_579238, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConsumersGetIamPolicy_579255 = ref object of OpenApiRestCall_578348
proc url_ServicemanagementServicesConsumersGetIamPolicy_579257(protocol: Scheme;
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

proc validate_ServicemanagementServicesConsumersGetIamPolicy_579256(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579258 = path.getOrDefault("resource")
  valid_579258 = validateParameter(valid_579258, JString, required = true,
                                 default = nil)
  if valid_579258 != nil:
    section.add "resource", valid_579258
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
  var valid_579259 = query.getOrDefault("key")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = nil)
  if valid_579259 != nil:
    section.add "key", valid_579259
  var valid_579260 = query.getOrDefault("prettyPrint")
  valid_579260 = validateParameter(valid_579260, JBool, required = false,
                                 default = newJBool(true))
  if valid_579260 != nil:
    section.add "prettyPrint", valid_579260
  var valid_579261 = query.getOrDefault("oauth_token")
  valid_579261 = validateParameter(valid_579261, JString, required = false,
                                 default = nil)
  if valid_579261 != nil:
    section.add "oauth_token", valid_579261
  var valid_579262 = query.getOrDefault("$.xgafv")
  valid_579262 = validateParameter(valid_579262, JString, required = false,
                                 default = newJString("1"))
  if valid_579262 != nil:
    section.add "$.xgafv", valid_579262
  var valid_579263 = query.getOrDefault("alt")
  valid_579263 = validateParameter(valid_579263, JString, required = false,
                                 default = newJString("json"))
  if valid_579263 != nil:
    section.add "alt", valid_579263
  var valid_579264 = query.getOrDefault("uploadType")
  valid_579264 = validateParameter(valid_579264, JString, required = false,
                                 default = nil)
  if valid_579264 != nil:
    section.add "uploadType", valid_579264
  var valid_579265 = query.getOrDefault("quotaUser")
  valid_579265 = validateParameter(valid_579265, JString, required = false,
                                 default = nil)
  if valid_579265 != nil:
    section.add "quotaUser", valid_579265
  var valid_579266 = query.getOrDefault("callback")
  valid_579266 = validateParameter(valid_579266, JString, required = false,
                                 default = nil)
  if valid_579266 != nil:
    section.add "callback", valid_579266
  var valid_579267 = query.getOrDefault("fields")
  valid_579267 = validateParameter(valid_579267, JString, required = false,
                                 default = nil)
  if valid_579267 != nil:
    section.add "fields", valid_579267
  var valid_579268 = query.getOrDefault("access_token")
  valid_579268 = validateParameter(valid_579268, JString, required = false,
                                 default = nil)
  if valid_579268 != nil:
    section.add "access_token", valid_579268
  var valid_579269 = query.getOrDefault("upload_protocol")
  valid_579269 = validateParameter(valid_579269, JString, required = false,
                                 default = nil)
  if valid_579269 != nil:
    section.add "upload_protocol", valid_579269
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

proc call*(call_579271: Call_ServicemanagementServicesConsumersGetIamPolicy_579255;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_579271.validator(path, query, header, formData, body)
  let scheme = call_579271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579271.url(scheme.get, call_579271.host, call_579271.base,
                         call_579271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579271, url, valid)

proc call*(call_579272: Call_ServicemanagementServicesConsumersGetIamPolicy_579255;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## servicemanagementServicesConsumersGetIamPolicy
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
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
  ##           : REQUIRED: The resource for which the policy is being requested.
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
  var path_579273 = newJObject()
  var query_579274 = newJObject()
  var body_579275 = newJObject()
  add(query_579274, "key", newJString(key))
  add(query_579274, "prettyPrint", newJBool(prettyPrint))
  add(query_579274, "oauth_token", newJString(oauthToken))
  add(query_579274, "$.xgafv", newJString(Xgafv))
  add(query_579274, "alt", newJString(alt))
  add(query_579274, "uploadType", newJString(uploadType))
  add(query_579274, "quotaUser", newJString(quotaUser))
  add(path_579273, "resource", newJString(resource))
  if body != nil:
    body_579275 = body
  add(query_579274, "callback", newJString(callback))
  add(query_579274, "fields", newJString(fields))
  add(query_579274, "access_token", newJString(accessToken))
  add(query_579274, "upload_protocol", newJString(uploadProtocol))
  result = call_579272.call(path_579273, query_579274, nil, nil, body_579275)

var servicemanagementServicesConsumersGetIamPolicy* = Call_ServicemanagementServicesConsumersGetIamPolicy_579255(
    name: "servicemanagementServicesConsumersGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "servicemanagement.googleapis.com",
    route: "/v1/{resource}:getIamPolicy",
    validator: validate_ServicemanagementServicesConsumersGetIamPolicy_579256,
    base: "/", url: url_ServicemanagementServicesConsumersGetIamPolicy_579257,
    schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConsumersSetIamPolicy_579276 = ref object of OpenApiRestCall_578348
proc url_ServicemanagementServicesConsumersSetIamPolicy_579278(protocol: Scheme;
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

proc validate_ServicemanagementServicesConsumersSetIamPolicy_579277(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579279 = path.getOrDefault("resource")
  valid_579279 = validateParameter(valid_579279, JString, required = true,
                                 default = nil)
  if valid_579279 != nil:
    section.add "resource", valid_579279
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
  var valid_579280 = query.getOrDefault("key")
  valid_579280 = validateParameter(valid_579280, JString, required = false,
                                 default = nil)
  if valid_579280 != nil:
    section.add "key", valid_579280
  var valid_579281 = query.getOrDefault("prettyPrint")
  valid_579281 = validateParameter(valid_579281, JBool, required = false,
                                 default = newJBool(true))
  if valid_579281 != nil:
    section.add "prettyPrint", valid_579281
  var valid_579282 = query.getOrDefault("oauth_token")
  valid_579282 = validateParameter(valid_579282, JString, required = false,
                                 default = nil)
  if valid_579282 != nil:
    section.add "oauth_token", valid_579282
  var valid_579283 = query.getOrDefault("$.xgafv")
  valid_579283 = validateParameter(valid_579283, JString, required = false,
                                 default = newJString("1"))
  if valid_579283 != nil:
    section.add "$.xgafv", valid_579283
  var valid_579284 = query.getOrDefault("alt")
  valid_579284 = validateParameter(valid_579284, JString, required = false,
                                 default = newJString("json"))
  if valid_579284 != nil:
    section.add "alt", valid_579284
  var valid_579285 = query.getOrDefault("uploadType")
  valid_579285 = validateParameter(valid_579285, JString, required = false,
                                 default = nil)
  if valid_579285 != nil:
    section.add "uploadType", valid_579285
  var valid_579286 = query.getOrDefault("quotaUser")
  valid_579286 = validateParameter(valid_579286, JString, required = false,
                                 default = nil)
  if valid_579286 != nil:
    section.add "quotaUser", valid_579286
  var valid_579287 = query.getOrDefault("callback")
  valid_579287 = validateParameter(valid_579287, JString, required = false,
                                 default = nil)
  if valid_579287 != nil:
    section.add "callback", valid_579287
  var valid_579288 = query.getOrDefault("fields")
  valid_579288 = validateParameter(valid_579288, JString, required = false,
                                 default = nil)
  if valid_579288 != nil:
    section.add "fields", valid_579288
  var valid_579289 = query.getOrDefault("access_token")
  valid_579289 = validateParameter(valid_579289, JString, required = false,
                                 default = nil)
  if valid_579289 != nil:
    section.add "access_token", valid_579289
  var valid_579290 = query.getOrDefault("upload_protocol")
  valid_579290 = validateParameter(valid_579290, JString, required = false,
                                 default = nil)
  if valid_579290 != nil:
    section.add "upload_protocol", valid_579290
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

proc call*(call_579292: Call_ServicemanagementServicesConsumersSetIamPolicy_579276;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_579292.validator(path, query, header, formData, body)
  let scheme = call_579292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579292.url(scheme.get, call_579292.host, call_579292.base,
                         call_579292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579292, url, valid)

proc call*(call_579293: Call_ServicemanagementServicesConsumersSetIamPolicy_579276;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## servicemanagementServicesConsumersSetIamPolicy
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
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
  var path_579294 = newJObject()
  var query_579295 = newJObject()
  var body_579296 = newJObject()
  add(query_579295, "key", newJString(key))
  add(query_579295, "prettyPrint", newJBool(prettyPrint))
  add(query_579295, "oauth_token", newJString(oauthToken))
  add(query_579295, "$.xgafv", newJString(Xgafv))
  add(query_579295, "alt", newJString(alt))
  add(query_579295, "uploadType", newJString(uploadType))
  add(query_579295, "quotaUser", newJString(quotaUser))
  add(path_579294, "resource", newJString(resource))
  if body != nil:
    body_579296 = body
  add(query_579295, "callback", newJString(callback))
  add(query_579295, "fields", newJString(fields))
  add(query_579295, "access_token", newJString(accessToken))
  add(query_579295, "upload_protocol", newJString(uploadProtocol))
  result = call_579293.call(path_579294, query_579295, nil, nil, body_579296)

var servicemanagementServicesConsumersSetIamPolicy* = Call_ServicemanagementServicesConsumersSetIamPolicy_579276(
    name: "servicemanagementServicesConsumersSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "servicemanagement.googleapis.com",
    route: "/v1/{resource}:setIamPolicy",
    validator: validate_ServicemanagementServicesConsumersSetIamPolicy_579277,
    base: "/", url: url_ServicemanagementServicesConsumersSetIamPolicy_579278,
    schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConsumersTestIamPermissions_579297 = ref object of OpenApiRestCall_578348
proc url_ServicemanagementServicesConsumersTestIamPermissions_579299(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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

proc validate_ServicemanagementServicesConsumersTestIamPermissions_579298(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579300 = path.getOrDefault("resource")
  valid_579300 = validateParameter(valid_579300, JString, required = true,
                                 default = nil)
  if valid_579300 != nil:
    section.add "resource", valid_579300
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
  var valid_579301 = query.getOrDefault("key")
  valid_579301 = validateParameter(valid_579301, JString, required = false,
                                 default = nil)
  if valid_579301 != nil:
    section.add "key", valid_579301
  var valid_579302 = query.getOrDefault("prettyPrint")
  valid_579302 = validateParameter(valid_579302, JBool, required = false,
                                 default = newJBool(true))
  if valid_579302 != nil:
    section.add "prettyPrint", valid_579302
  var valid_579303 = query.getOrDefault("oauth_token")
  valid_579303 = validateParameter(valid_579303, JString, required = false,
                                 default = nil)
  if valid_579303 != nil:
    section.add "oauth_token", valid_579303
  var valid_579304 = query.getOrDefault("$.xgafv")
  valid_579304 = validateParameter(valid_579304, JString, required = false,
                                 default = newJString("1"))
  if valid_579304 != nil:
    section.add "$.xgafv", valid_579304
  var valid_579305 = query.getOrDefault("alt")
  valid_579305 = validateParameter(valid_579305, JString, required = false,
                                 default = newJString("json"))
  if valid_579305 != nil:
    section.add "alt", valid_579305
  var valid_579306 = query.getOrDefault("uploadType")
  valid_579306 = validateParameter(valid_579306, JString, required = false,
                                 default = nil)
  if valid_579306 != nil:
    section.add "uploadType", valid_579306
  var valid_579307 = query.getOrDefault("quotaUser")
  valid_579307 = validateParameter(valid_579307, JString, required = false,
                                 default = nil)
  if valid_579307 != nil:
    section.add "quotaUser", valid_579307
  var valid_579308 = query.getOrDefault("callback")
  valid_579308 = validateParameter(valid_579308, JString, required = false,
                                 default = nil)
  if valid_579308 != nil:
    section.add "callback", valid_579308
  var valid_579309 = query.getOrDefault("fields")
  valid_579309 = validateParameter(valid_579309, JString, required = false,
                                 default = nil)
  if valid_579309 != nil:
    section.add "fields", valid_579309
  var valid_579310 = query.getOrDefault("access_token")
  valid_579310 = validateParameter(valid_579310, JString, required = false,
                                 default = nil)
  if valid_579310 != nil:
    section.add "access_token", valid_579310
  var valid_579311 = query.getOrDefault("upload_protocol")
  valid_579311 = validateParameter(valid_579311, JString, required = false,
                                 default = nil)
  if valid_579311 != nil:
    section.add "upload_protocol", valid_579311
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

proc call*(call_579313: Call_ServicemanagementServicesConsumersTestIamPermissions_579297;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
  ## 
  let valid = call_579313.validator(path, query, header, formData, body)
  let scheme = call_579313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579313.url(scheme.get, call_579313.host, call_579313.base,
                         call_579313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579313, url, valid)

proc call*(call_579314: Call_ServicemanagementServicesConsumersTestIamPermissions_579297;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## servicemanagementServicesConsumersTestIamPermissions
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
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
  var path_579315 = newJObject()
  var query_579316 = newJObject()
  var body_579317 = newJObject()
  add(query_579316, "key", newJString(key))
  add(query_579316, "prettyPrint", newJBool(prettyPrint))
  add(query_579316, "oauth_token", newJString(oauthToken))
  add(query_579316, "$.xgafv", newJString(Xgafv))
  add(query_579316, "alt", newJString(alt))
  add(query_579316, "uploadType", newJString(uploadType))
  add(query_579316, "quotaUser", newJString(quotaUser))
  add(path_579315, "resource", newJString(resource))
  if body != nil:
    body_579317 = body
  add(query_579316, "callback", newJString(callback))
  add(query_579316, "fields", newJString(fields))
  add(query_579316, "access_token", newJString(accessToken))
  add(query_579316, "upload_protocol", newJString(uploadProtocol))
  result = call_579314.call(path_579315, query_579316, nil, nil, body_579317)

var servicemanagementServicesConsumersTestIamPermissions* = Call_ServicemanagementServicesConsumersTestIamPermissions_579297(
    name: "servicemanagementServicesConsumersTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "servicemanagement.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_ServicemanagementServicesConsumersTestIamPermissions_579298,
    base: "/", url: url_ServicemanagementServicesConsumersTestIamPermissions_579299,
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
