
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

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
  gcpServiceName = "servicemanagement"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServicemanagementOperationsList_579644 = ref object of OpenApiRestCall_579373
proc url_ServicemanagementOperationsList_579646(protocol: Scheme; host: string;
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

proc validate_ServicemanagementOperationsList_579645(path: JsonNode;
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
  var valid_579774 = query.getOrDefault("name")
  valid_579774 = validateParameter(valid_579774, JString, required = false,
                                 default = nil)
  if valid_579774 != nil:
    section.add "name", valid_579774
  var valid_579775 = query.getOrDefault("$.xgafv")
  valid_579775 = validateParameter(valid_579775, JString, required = false,
                                 default = newJString("1"))
  if valid_579775 != nil:
    section.add "$.xgafv", valid_579775
  var valid_579776 = query.getOrDefault("pageSize")
  valid_579776 = validateParameter(valid_579776, JInt, required = false, default = nil)
  if valid_579776 != nil:
    section.add "pageSize", valid_579776
  var valid_579777 = query.getOrDefault("alt")
  valid_579777 = validateParameter(valid_579777, JString, required = false,
                                 default = newJString("json"))
  if valid_579777 != nil:
    section.add "alt", valid_579777
  var valid_579778 = query.getOrDefault("uploadType")
  valid_579778 = validateParameter(valid_579778, JString, required = false,
                                 default = nil)
  if valid_579778 != nil:
    section.add "uploadType", valid_579778
  var valid_579779 = query.getOrDefault("quotaUser")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = nil)
  if valid_579779 != nil:
    section.add "quotaUser", valid_579779
  var valid_579780 = query.getOrDefault("filter")
  valid_579780 = validateParameter(valid_579780, JString, required = false,
                                 default = nil)
  if valid_579780 != nil:
    section.add "filter", valid_579780
  var valid_579781 = query.getOrDefault("pageToken")
  valid_579781 = validateParameter(valid_579781, JString, required = false,
                                 default = nil)
  if valid_579781 != nil:
    section.add "pageToken", valid_579781
  var valid_579782 = query.getOrDefault("callback")
  valid_579782 = validateParameter(valid_579782, JString, required = false,
                                 default = nil)
  if valid_579782 != nil:
    section.add "callback", valid_579782
  var valid_579783 = query.getOrDefault("fields")
  valid_579783 = validateParameter(valid_579783, JString, required = false,
                                 default = nil)
  if valid_579783 != nil:
    section.add "fields", valid_579783
  var valid_579784 = query.getOrDefault("access_token")
  valid_579784 = validateParameter(valid_579784, JString, required = false,
                                 default = nil)
  if valid_579784 != nil:
    section.add "access_token", valid_579784
  var valid_579785 = query.getOrDefault("upload_protocol")
  valid_579785 = validateParameter(valid_579785, JString, required = false,
                                 default = nil)
  if valid_579785 != nil:
    section.add "upload_protocol", valid_579785
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579808: Call_ServicemanagementOperationsList_579644;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists service operations that match the specified filter in the request.
  ## 
  let valid = call_579808.validator(path, query, header, formData, body)
  let scheme = call_579808.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579808.url(scheme.get, call_579808.host, call_579808.base,
                         call_579808.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579808, url, valid)

proc call*(call_579879: Call_ServicemanagementOperationsList_579644;
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
  var query_579880 = newJObject()
  add(query_579880, "key", newJString(key))
  add(query_579880, "prettyPrint", newJBool(prettyPrint))
  add(query_579880, "oauth_token", newJString(oauthToken))
  add(query_579880, "name", newJString(name))
  add(query_579880, "$.xgafv", newJString(Xgafv))
  add(query_579880, "pageSize", newJInt(pageSize))
  add(query_579880, "alt", newJString(alt))
  add(query_579880, "uploadType", newJString(uploadType))
  add(query_579880, "quotaUser", newJString(quotaUser))
  add(query_579880, "filter", newJString(filter))
  add(query_579880, "pageToken", newJString(pageToken))
  add(query_579880, "callback", newJString(callback))
  add(query_579880, "fields", newJString(fields))
  add(query_579880, "access_token", newJString(accessToken))
  add(query_579880, "upload_protocol", newJString(uploadProtocol))
  result = call_579879.call(nil, query_579880, nil, nil, nil)

var servicemanagementOperationsList* = Call_ServicemanagementOperationsList_579644(
    name: "servicemanagementOperationsList", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com", route: "/v1/operations",
    validator: validate_ServicemanagementOperationsList_579645, base: "/",
    url: url_ServicemanagementOperationsList_579646, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesCreate_579941 = ref object of OpenApiRestCall_579373
proc url_ServicemanagementServicesCreate_579943(protocol: Scheme; host: string;
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

proc validate_ServicemanagementServicesCreate_579942(path: JsonNode;
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
  var valid_579944 = query.getOrDefault("key")
  valid_579944 = validateParameter(valid_579944, JString, required = false,
                                 default = nil)
  if valid_579944 != nil:
    section.add "key", valid_579944
  var valid_579945 = query.getOrDefault("prettyPrint")
  valid_579945 = validateParameter(valid_579945, JBool, required = false,
                                 default = newJBool(true))
  if valid_579945 != nil:
    section.add "prettyPrint", valid_579945
  var valid_579946 = query.getOrDefault("oauth_token")
  valid_579946 = validateParameter(valid_579946, JString, required = false,
                                 default = nil)
  if valid_579946 != nil:
    section.add "oauth_token", valid_579946
  var valid_579947 = query.getOrDefault("$.xgafv")
  valid_579947 = validateParameter(valid_579947, JString, required = false,
                                 default = newJString("1"))
  if valid_579947 != nil:
    section.add "$.xgafv", valid_579947
  var valid_579948 = query.getOrDefault("alt")
  valid_579948 = validateParameter(valid_579948, JString, required = false,
                                 default = newJString("json"))
  if valid_579948 != nil:
    section.add "alt", valid_579948
  var valid_579949 = query.getOrDefault("uploadType")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = nil)
  if valid_579949 != nil:
    section.add "uploadType", valid_579949
  var valid_579950 = query.getOrDefault("quotaUser")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = nil)
  if valid_579950 != nil:
    section.add "quotaUser", valid_579950
  var valid_579951 = query.getOrDefault("callback")
  valid_579951 = validateParameter(valid_579951, JString, required = false,
                                 default = nil)
  if valid_579951 != nil:
    section.add "callback", valid_579951
  var valid_579952 = query.getOrDefault("fields")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = nil)
  if valid_579952 != nil:
    section.add "fields", valid_579952
  var valid_579953 = query.getOrDefault("access_token")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = nil)
  if valid_579953 != nil:
    section.add "access_token", valid_579953
  var valid_579954 = query.getOrDefault("upload_protocol")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = nil)
  if valid_579954 != nil:
    section.add "upload_protocol", valid_579954
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

proc call*(call_579956: Call_ServicemanagementServicesCreate_579941;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new managed service.
  ## Please note one producer project can own no more than 20 services.
  ## 
  ## Operation<response: ManagedService>
  ## 
  let valid = call_579956.validator(path, query, header, formData, body)
  let scheme = call_579956.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579956.url(scheme.get, call_579956.host, call_579956.base,
                         call_579956.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579956, url, valid)

proc call*(call_579957: Call_ServicemanagementServicesCreate_579941;
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
  var query_579958 = newJObject()
  var body_579959 = newJObject()
  add(query_579958, "key", newJString(key))
  add(query_579958, "prettyPrint", newJBool(prettyPrint))
  add(query_579958, "oauth_token", newJString(oauthToken))
  add(query_579958, "$.xgafv", newJString(Xgafv))
  add(query_579958, "alt", newJString(alt))
  add(query_579958, "uploadType", newJString(uploadType))
  add(query_579958, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579959 = body
  add(query_579958, "callback", newJString(callback))
  add(query_579958, "fields", newJString(fields))
  add(query_579958, "access_token", newJString(accessToken))
  add(query_579958, "upload_protocol", newJString(uploadProtocol))
  result = call_579957.call(nil, query_579958, nil, nil, body_579959)

var servicemanagementServicesCreate* = Call_ServicemanagementServicesCreate_579941(
    name: "servicemanagementServicesCreate", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com", route: "/v1/services",
    validator: validate_ServicemanagementServicesCreate_579942, base: "/",
    url: url_ServicemanagementServicesCreate_579943, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesList_579920 = ref object of OpenApiRestCall_579373
proc url_ServicemanagementServicesList_579922(protocol: Scheme; host: string;
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

proc validate_ServicemanagementServicesList_579921(path: JsonNode; query: JsonNode;
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
  var valid_579923 = query.getOrDefault("key")
  valid_579923 = validateParameter(valid_579923, JString, required = false,
                                 default = nil)
  if valid_579923 != nil:
    section.add "key", valid_579923
  var valid_579924 = query.getOrDefault("prettyPrint")
  valid_579924 = validateParameter(valid_579924, JBool, required = false,
                                 default = newJBool(true))
  if valid_579924 != nil:
    section.add "prettyPrint", valid_579924
  var valid_579925 = query.getOrDefault("oauth_token")
  valid_579925 = validateParameter(valid_579925, JString, required = false,
                                 default = nil)
  if valid_579925 != nil:
    section.add "oauth_token", valid_579925
  var valid_579926 = query.getOrDefault("$.xgafv")
  valid_579926 = validateParameter(valid_579926, JString, required = false,
                                 default = newJString("1"))
  if valid_579926 != nil:
    section.add "$.xgafv", valid_579926
  var valid_579927 = query.getOrDefault("pageSize")
  valid_579927 = validateParameter(valid_579927, JInt, required = false, default = nil)
  if valid_579927 != nil:
    section.add "pageSize", valid_579927
  var valid_579928 = query.getOrDefault("producerProjectId")
  valid_579928 = validateParameter(valid_579928, JString, required = false,
                                 default = nil)
  if valid_579928 != nil:
    section.add "producerProjectId", valid_579928
  var valid_579929 = query.getOrDefault("alt")
  valid_579929 = validateParameter(valid_579929, JString, required = false,
                                 default = newJString("json"))
  if valid_579929 != nil:
    section.add "alt", valid_579929
  var valid_579930 = query.getOrDefault("uploadType")
  valid_579930 = validateParameter(valid_579930, JString, required = false,
                                 default = nil)
  if valid_579930 != nil:
    section.add "uploadType", valid_579930
  var valid_579931 = query.getOrDefault("quotaUser")
  valid_579931 = validateParameter(valid_579931, JString, required = false,
                                 default = nil)
  if valid_579931 != nil:
    section.add "quotaUser", valid_579931
  var valid_579932 = query.getOrDefault("pageToken")
  valid_579932 = validateParameter(valid_579932, JString, required = false,
                                 default = nil)
  if valid_579932 != nil:
    section.add "pageToken", valid_579932
  var valid_579933 = query.getOrDefault("consumerId")
  valid_579933 = validateParameter(valid_579933, JString, required = false,
                                 default = nil)
  if valid_579933 != nil:
    section.add "consumerId", valid_579933
  var valid_579934 = query.getOrDefault("callback")
  valid_579934 = validateParameter(valid_579934, JString, required = false,
                                 default = nil)
  if valid_579934 != nil:
    section.add "callback", valid_579934
  var valid_579935 = query.getOrDefault("fields")
  valid_579935 = validateParameter(valid_579935, JString, required = false,
                                 default = nil)
  if valid_579935 != nil:
    section.add "fields", valid_579935
  var valid_579936 = query.getOrDefault("access_token")
  valid_579936 = validateParameter(valid_579936, JString, required = false,
                                 default = nil)
  if valid_579936 != nil:
    section.add "access_token", valid_579936
  var valid_579937 = query.getOrDefault("upload_protocol")
  valid_579937 = validateParameter(valid_579937, JString, required = false,
                                 default = nil)
  if valid_579937 != nil:
    section.add "upload_protocol", valid_579937
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579938: Call_ServicemanagementServicesList_579920; path: JsonNode;
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
  let valid = call_579938.validator(path, query, header, formData, body)
  let scheme = call_579938.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579938.url(scheme.get, call_579938.host, call_579938.base,
                         call_579938.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579938, url, valid)

proc call*(call_579939: Call_ServicemanagementServicesList_579920;
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
  var query_579940 = newJObject()
  add(query_579940, "key", newJString(key))
  add(query_579940, "prettyPrint", newJBool(prettyPrint))
  add(query_579940, "oauth_token", newJString(oauthToken))
  add(query_579940, "$.xgafv", newJString(Xgafv))
  add(query_579940, "pageSize", newJInt(pageSize))
  add(query_579940, "producerProjectId", newJString(producerProjectId))
  add(query_579940, "alt", newJString(alt))
  add(query_579940, "uploadType", newJString(uploadType))
  add(query_579940, "quotaUser", newJString(quotaUser))
  add(query_579940, "pageToken", newJString(pageToken))
  add(query_579940, "consumerId", newJString(consumerId))
  add(query_579940, "callback", newJString(callback))
  add(query_579940, "fields", newJString(fields))
  add(query_579940, "access_token", newJString(accessToken))
  add(query_579940, "upload_protocol", newJString(uploadProtocol))
  result = call_579939.call(nil, query_579940, nil, nil, nil)

var servicemanagementServicesList* = Call_ServicemanagementServicesList_579920(
    name: "servicemanagementServicesList", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com", route: "/v1/services",
    validator: validate_ServicemanagementServicesList_579921, base: "/",
    url: url_ServicemanagementServicesList_579922, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesGet_579960 = ref object of OpenApiRestCall_579373
proc url_ServicemanagementServicesGet_579962(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ServicemanagementServicesGet_579961(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a managed service. Authentication is required unless the service is
  ## public.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : Required. The name of the service.  See the `ServiceManager` overview for naming
  ## requirements.  For example: `example.googleapis.com`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_579977 = path.getOrDefault("serviceName")
  valid_579977 = validateParameter(valid_579977, JString, required = true,
                                 default = nil)
  if valid_579977 != nil:
    section.add "serviceName", valid_579977
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
  var valid_579978 = query.getOrDefault("key")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "key", valid_579978
  var valid_579979 = query.getOrDefault("prettyPrint")
  valid_579979 = validateParameter(valid_579979, JBool, required = false,
                                 default = newJBool(true))
  if valid_579979 != nil:
    section.add "prettyPrint", valid_579979
  var valid_579980 = query.getOrDefault("oauth_token")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "oauth_token", valid_579980
  var valid_579981 = query.getOrDefault("$.xgafv")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = newJString("1"))
  if valid_579981 != nil:
    section.add "$.xgafv", valid_579981
  var valid_579982 = query.getOrDefault("alt")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = newJString("json"))
  if valid_579982 != nil:
    section.add "alt", valid_579982
  var valid_579983 = query.getOrDefault("uploadType")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "uploadType", valid_579983
  var valid_579984 = query.getOrDefault("quotaUser")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "quotaUser", valid_579984
  var valid_579985 = query.getOrDefault("callback")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "callback", valid_579985
  var valid_579986 = query.getOrDefault("fields")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "fields", valid_579986
  var valid_579987 = query.getOrDefault("access_token")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "access_token", valid_579987
  var valid_579988 = query.getOrDefault("upload_protocol")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "upload_protocol", valid_579988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579989: Call_ServicemanagementServicesGet_579960; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a managed service. Authentication is required unless the service is
  ## public.
  ## 
  let valid = call_579989.validator(path, query, header, formData, body)
  let scheme = call_579989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579989.url(scheme.get, call_579989.host, call_579989.base,
                         call_579989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579989, url, valid)

proc call*(call_579990: Call_ServicemanagementServicesGet_579960;
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
  ##              : Required. The name of the service.  See the `ServiceManager` overview for naming
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
  var path_579991 = newJObject()
  var query_579992 = newJObject()
  add(query_579992, "key", newJString(key))
  add(query_579992, "prettyPrint", newJBool(prettyPrint))
  add(query_579992, "oauth_token", newJString(oauthToken))
  add(path_579991, "serviceName", newJString(serviceName))
  add(query_579992, "$.xgafv", newJString(Xgafv))
  add(query_579992, "alt", newJString(alt))
  add(query_579992, "uploadType", newJString(uploadType))
  add(query_579992, "quotaUser", newJString(quotaUser))
  add(query_579992, "callback", newJString(callback))
  add(query_579992, "fields", newJString(fields))
  add(query_579992, "access_token", newJString(accessToken))
  add(query_579992, "upload_protocol", newJString(uploadProtocol))
  result = call_579990.call(path_579991, query_579992, nil, nil, nil)

var servicemanagementServicesGet* = Call_ServicemanagementServicesGet_579960(
    name: "servicemanagementServicesGet", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com", route: "/v1/services/{serviceName}",
    validator: validate_ServicemanagementServicesGet_579961, base: "/",
    url: url_ServicemanagementServicesGet_579962, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesDelete_579993 = ref object of OpenApiRestCall_579373
proc url_ServicemanagementServicesDelete_579995(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ServicemanagementServicesDelete_579994(path: JsonNode;
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
  ##              : Required. The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_579996 = path.getOrDefault("serviceName")
  valid_579996 = validateParameter(valid_579996, JString, required = true,
                                 default = nil)
  if valid_579996 != nil:
    section.add "serviceName", valid_579996
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
  var valid_579997 = query.getOrDefault("key")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "key", valid_579997
  var valid_579998 = query.getOrDefault("prettyPrint")
  valid_579998 = validateParameter(valid_579998, JBool, required = false,
                                 default = newJBool(true))
  if valid_579998 != nil:
    section.add "prettyPrint", valid_579998
  var valid_579999 = query.getOrDefault("oauth_token")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "oauth_token", valid_579999
  var valid_580000 = query.getOrDefault("$.xgafv")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = newJString("1"))
  if valid_580000 != nil:
    section.add "$.xgafv", valid_580000
  var valid_580001 = query.getOrDefault("alt")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = newJString("json"))
  if valid_580001 != nil:
    section.add "alt", valid_580001
  var valid_580002 = query.getOrDefault("uploadType")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "uploadType", valid_580002
  var valid_580003 = query.getOrDefault("quotaUser")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "quotaUser", valid_580003
  var valid_580004 = query.getOrDefault("callback")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "callback", valid_580004
  var valid_580005 = query.getOrDefault("fields")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "fields", valid_580005
  var valid_580006 = query.getOrDefault("access_token")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "access_token", valid_580006
  var valid_580007 = query.getOrDefault("upload_protocol")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "upload_protocol", valid_580007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580008: Call_ServicemanagementServicesDelete_579993;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a managed service. This method will change the service to the
  ## `Soft-Delete` state for 30 days. Within this period, service producers may
  ## call UndeleteService to restore the service.
  ## After 30 days, the service will be permanently deleted.
  ## 
  ## Operation<response: google.protobuf.Empty>
  ## 
  let valid = call_580008.validator(path, query, header, formData, body)
  let scheme = call_580008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580008.url(scheme.get, call_580008.host, call_580008.base,
                         call_580008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580008, url, valid)

proc call*(call_580009: Call_ServicemanagementServicesDelete_579993;
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
  ##              : Required. The name of the service.  See the [overview](/service-management/overview)
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
  var path_580010 = newJObject()
  var query_580011 = newJObject()
  add(query_580011, "key", newJString(key))
  add(query_580011, "prettyPrint", newJBool(prettyPrint))
  add(query_580011, "oauth_token", newJString(oauthToken))
  add(path_580010, "serviceName", newJString(serviceName))
  add(query_580011, "$.xgafv", newJString(Xgafv))
  add(query_580011, "alt", newJString(alt))
  add(query_580011, "uploadType", newJString(uploadType))
  add(query_580011, "quotaUser", newJString(quotaUser))
  add(query_580011, "callback", newJString(callback))
  add(query_580011, "fields", newJString(fields))
  add(query_580011, "access_token", newJString(accessToken))
  add(query_580011, "upload_protocol", newJString(uploadProtocol))
  result = call_580009.call(path_580010, query_580011, nil, nil, nil)

var servicemanagementServicesDelete* = Call_ServicemanagementServicesDelete_579993(
    name: "servicemanagementServicesDelete", meth: HttpMethod.HttpDelete,
    host: "servicemanagement.googleapis.com", route: "/v1/services/{serviceName}",
    validator: validate_ServicemanagementServicesDelete_579994, base: "/",
    url: url_ServicemanagementServicesDelete_579995, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesGetConfig_580012 = ref object of OpenApiRestCall_579373
proc url_ServicemanagementServicesGetConfig_580014(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ServicemanagementServicesGetConfig_580013(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a service configuration (version) for a managed service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : Required. The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_580015 = path.getOrDefault("serviceName")
  valid_580015 = validateParameter(valid_580015, JString, required = true,
                                 default = nil)
  if valid_580015 != nil:
    section.add "serviceName", valid_580015
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
  ##           : Required. The id of the service configuration resource.
  ## 
  ## This field must be specified for the server to return all fields, including
  ## `SourceInfo`.
  ##   view: JString
  ##       : Specifies which parts of the Service Config should be returned in the
  ## response.
  section = newJObject()
  var valid_580016 = query.getOrDefault("key")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "key", valid_580016
  var valid_580017 = query.getOrDefault("prettyPrint")
  valid_580017 = validateParameter(valid_580017, JBool, required = false,
                                 default = newJBool(true))
  if valid_580017 != nil:
    section.add "prettyPrint", valid_580017
  var valid_580018 = query.getOrDefault("oauth_token")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "oauth_token", valid_580018
  var valid_580019 = query.getOrDefault("$.xgafv")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = newJString("1"))
  if valid_580019 != nil:
    section.add "$.xgafv", valid_580019
  var valid_580020 = query.getOrDefault("alt")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = newJString("json"))
  if valid_580020 != nil:
    section.add "alt", valid_580020
  var valid_580021 = query.getOrDefault("uploadType")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "uploadType", valid_580021
  var valid_580022 = query.getOrDefault("quotaUser")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "quotaUser", valid_580022
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
  var valid_580027 = query.getOrDefault("configId")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "configId", valid_580027
  var valid_580028 = query.getOrDefault("view")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_580028 != nil:
    section.add "view", valid_580028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580029: Call_ServicemanagementServicesGetConfig_580012;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a service configuration (version) for a managed service.
  ## 
  let valid = call_580029.validator(path, query, header, formData, body)
  let scheme = call_580029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580029.url(scheme.get, call_580029.host, call_580029.base,
                         call_580029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580029, url, valid)

proc call*(call_580030: Call_ServicemanagementServicesGetConfig_580012;
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
  ##              : Required. The name of the service.  See the [overview](/service-management/overview)
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
  ##           : Required. The id of the service configuration resource.
  ## 
  ## This field must be specified for the server to return all fields, including
  ## `SourceInfo`.
  ##   view: string
  ##       : Specifies which parts of the Service Config should be returned in the
  ## response.
  var path_580031 = newJObject()
  var query_580032 = newJObject()
  add(query_580032, "key", newJString(key))
  add(query_580032, "prettyPrint", newJBool(prettyPrint))
  add(query_580032, "oauth_token", newJString(oauthToken))
  add(path_580031, "serviceName", newJString(serviceName))
  add(query_580032, "$.xgafv", newJString(Xgafv))
  add(query_580032, "alt", newJString(alt))
  add(query_580032, "uploadType", newJString(uploadType))
  add(query_580032, "quotaUser", newJString(quotaUser))
  add(query_580032, "callback", newJString(callback))
  add(query_580032, "fields", newJString(fields))
  add(query_580032, "access_token", newJString(accessToken))
  add(query_580032, "upload_protocol", newJString(uploadProtocol))
  add(query_580032, "configId", newJString(configId))
  add(query_580032, "view", newJString(view))
  result = call_580030.call(path_580031, query_580032, nil, nil, nil)

var servicemanagementServicesGetConfig* = Call_ServicemanagementServicesGetConfig_580012(
    name: "servicemanagementServicesGetConfig", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/config",
    validator: validate_ServicemanagementServicesGetConfig_580013, base: "/",
    url: url_ServicemanagementServicesGetConfig_580014, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConfigsCreate_580054 = ref object of OpenApiRestCall_579373
proc url_ServicemanagementServicesConfigsCreate_580056(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ServicemanagementServicesConfigsCreate_580055(path: JsonNode;
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
  ##              : Required. The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_580057 = path.getOrDefault("serviceName")
  valid_580057 = validateParameter(valid_580057, JString, required = true,
                                 default = nil)
  if valid_580057 != nil:
    section.add "serviceName", valid_580057
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
  var valid_580058 = query.getOrDefault("key")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "key", valid_580058
  var valid_580059 = query.getOrDefault("prettyPrint")
  valid_580059 = validateParameter(valid_580059, JBool, required = false,
                                 default = newJBool(true))
  if valid_580059 != nil:
    section.add "prettyPrint", valid_580059
  var valid_580060 = query.getOrDefault("oauth_token")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "oauth_token", valid_580060
  var valid_580061 = query.getOrDefault("$.xgafv")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = newJString("1"))
  if valid_580061 != nil:
    section.add "$.xgafv", valid_580061
  var valid_580062 = query.getOrDefault("alt")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = newJString("json"))
  if valid_580062 != nil:
    section.add "alt", valid_580062
  var valid_580063 = query.getOrDefault("uploadType")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "uploadType", valid_580063
  var valid_580064 = query.getOrDefault("quotaUser")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "quotaUser", valid_580064
  var valid_580065 = query.getOrDefault("callback")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "callback", valid_580065
  var valid_580066 = query.getOrDefault("fields")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "fields", valid_580066
  var valid_580067 = query.getOrDefault("access_token")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "access_token", valid_580067
  var valid_580068 = query.getOrDefault("upload_protocol")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "upload_protocol", valid_580068
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

proc call*(call_580070: Call_ServicemanagementServicesConfigsCreate_580054;
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
  let valid = call_580070.validator(path, query, header, formData, body)
  let scheme = call_580070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580070.url(scheme.get, call_580070.host, call_580070.base,
                         call_580070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580070, url, valid)

proc call*(call_580071: Call_ServicemanagementServicesConfigsCreate_580054;
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
  ##              : Required. The name of the service.  See the [overview](/service-management/overview)
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
  var path_580072 = newJObject()
  var query_580073 = newJObject()
  var body_580074 = newJObject()
  add(query_580073, "key", newJString(key))
  add(query_580073, "prettyPrint", newJBool(prettyPrint))
  add(query_580073, "oauth_token", newJString(oauthToken))
  add(path_580072, "serviceName", newJString(serviceName))
  add(query_580073, "$.xgafv", newJString(Xgafv))
  add(query_580073, "alt", newJString(alt))
  add(query_580073, "uploadType", newJString(uploadType))
  add(query_580073, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580074 = body
  add(query_580073, "callback", newJString(callback))
  add(query_580073, "fields", newJString(fields))
  add(query_580073, "access_token", newJString(accessToken))
  add(query_580073, "upload_protocol", newJString(uploadProtocol))
  result = call_580071.call(path_580072, query_580073, nil, nil, body_580074)

var servicemanagementServicesConfigsCreate* = Call_ServicemanagementServicesConfigsCreate_580054(
    name: "servicemanagementServicesConfigsCreate", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/configs",
    validator: validate_ServicemanagementServicesConfigsCreate_580055, base: "/",
    url: url_ServicemanagementServicesConfigsCreate_580056,
    schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConfigsList_580033 = ref object of OpenApiRestCall_579373
proc url_ServicemanagementServicesConfigsList_580035(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ServicemanagementServicesConfigsList_580034(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the history of the service configuration for a managed service,
  ## from the newest to the oldest.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : Required. The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_580036 = path.getOrDefault("serviceName")
  valid_580036 = validateParameter(valid_580036, JString, required = true,
                                 default = nil)
  if valid_580036 != nil:
    section.add "serviceName", valid_580036
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
  var valid_580037 = query.getOrDefault("key")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "key", valid_580037
  var valid_580038 = query.getOrDefault("prettyPrint")
  valid_580038 = validateParameter(valid_580038, JBool, required = false,
                                 default = newJBool(true))
  if valid_580038 != nil:
    section.add "prettyPrint", valid_580038
  var valid_580039 = query.getOrDefault("oauth_token")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "oauth_token", valid_580039
  var valid_580040 = query.getOrDefault("$.xgafv")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = newJString("1"))
  if valid_580040 != nil:
    section.add "$.xgafv", valid_580040
  var valid_580041 = query.getOrDefault("pageSize")
  valid_580041 = validateParameter(valid_580041, JInt, required = false, default = nil)
  if valid_580041 != nil:
    section.add "pageSize", valid_580041
  var valid_580042 = query.getOrDefault("alt")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = newJString("json"))
  if valid_580042 != nil:
    section.add "alt", valid_580042
  var valid_580043 = query.getOrDefault("uploadType")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "uploadType", valid_580043
  var valid_580044 = query.getOrDefault("quotaUser")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "quotaUser", valid_580044
  var valid_580045 = query.getOrDefault("pageToken")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "pageToken", valid_580045
  var valid_580046 = query.getOrDefault("callback")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "callback", valid_580046
  var valid_580047 = query.getOrDefault("fields")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "fields", valid_580047
  var valid_580048 = query.getOrDefault("access_token")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "access_token", valid_580048
  var valid_580049 = query.getOrDefault("upload_protocol")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "upload_protocol", valid_580049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580050: Call_ServicemanagementServicesConfigsList_580033;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the history of the service configuration for a managed service,
  ## from the newest to the oldest.
  ## 
  let valid = call_580050.validator(path, query, header, formData, body)
  let scheme = call_580050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580050.url(scheme.get, call_580050.host, call_580050.base,
                         call_580050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580050, url, valid)

proc call*(call_580051: Call_ServicemanagementServicesConfigsList_580033;
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
  ##              : Required. The name of the service.  See the [overview](/service-management/overview)
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
  var path_580052 = newJObject()
  var query_580053 = newJObject()
  add(query_580053, "key", newJString(key))
  add(query_580053, "prettyPrint", newJBool(prettyPrint))
  add(query_580053, "oauth_token", newJString(oauthToken))
  add(path_580052, "serviceName", newJString(serviceName))
  add(query_580053, "$.xgafv", newJString(Xgafv))
  add(query_580053, "pageSize", newJInt(pageSize))
  add(query_580053, "alt", newJString(alt))
  add(query_580053, "uploadType", newJString(uploadType))
  add(query_580053, "quotaUser", newJString(quotaUser))
  add(query_580053, "pageToken", newJString(pageToken))
  add(query_580053, "callback", newJString(callback))
  add(query_580053, "fields", newJString(fields))
  add(query_580053, "access_token", newJString(accessToken))
  add(query_580053, "upload_protocol", newJString(uploadProtocol))
  result = call_580051.call(path_580052, query_580053, nil, nil, nil)

var servicemanagementServicesConfigsList* = Call_ServicemanagementServicesConfigsList_580033(
    name: "servicemanagementServicesConfigsList", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/configs",
    validator: validate_ServicemanagementServicesConfigsList_580034, base: "/",
    url: url_ServicemanagementServicesConfigsList_580035, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConfigsGet_580075 = ref object of OpenApiRestCall_579373
proc url_ServicemanagementServicesConfigsGet_580077(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ServicemanagementServicesConfigsGet_580076(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a service configuration (version) for a managed service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : Required. The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  ##   configId: JString (required)
  ##           : Required. The id of the service configuration resource.
  ## 
  ## This field must be specified for the server to return all fields, including
  ## `SourceInfo`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_580078 = path.getOrDefault("serviceName")
  valid_580078 = validateParameter(valid_580078, JString, required = true,
                                 default = nil)
  if valid_580078 != nil:
    section.add "serviceName", valid_580078
  var valid_580079 = path.getOrDefault("configId")
  valid_580079 = validateParameter(valid_580079, JString, required = true,
                                 default = nil)
  if valid_580079 != nil:
    section.add "configId", valid_580079
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
  var valid_580080 = query.getOrDefault("key")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "key", valid_580080
  var valid_580081 = query.getOrDefault("prettyPrint")
  valid_580081 = validateParameter(valid_580081, JBool, required = false,
                                 default = newJBool(true))
  if valid_580081 != nil:
    section.add "prettyPrint", valid_580081
  var valid_580082 = query.getOrDefault("oauth_token")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "oauth_token", valid_580082
  var valid_580083 = query.getOrDefault("$.xgafv")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = newJString("1"))
  if valid_580083 != nil:
    section.add "$.xgafv", valid_580083
  var valid_580084 = query.getOrDefault("alt")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = newJString("json"))
  if valid_580084 != nil:
    section.add "alt", valid_580084
  var valid_580085 = query.getOrDefault("uploadType")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "uploadType", valid_580085
  var valid_580086 = query.getOrDefault("quotaUser")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "quotaUser", valid_580086
  var valid_580087 = query.getOrDefault("callback")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "callback", valid_580087
  var valid_580088 = query.getOrDefault("fields")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "fields", valid_580088
  var valid_580089 = query.getOrDefault("access_token")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "access_token", valid_580089
  var valid_580090 = query.getOrDefault("upload_protocol")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "upload_protocol", valid_580090
  var valid_580091 = query.getOrDefault("view")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_580091 != nil:
    section.add "view", valid_580091
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580092: Call_ServicemanagementServicesConfigsGet_580075;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a service configuration (version) for a managed service.
  ## 
  let valid = call_580092.validator(path, query, header, formData, body)
  let scheme = call_580092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580092.url(scheme.get, call_580092.host, call_580092.base,
                         call_580092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580092, url, valid)

proc call*(call_580093: Call_ServicemanagementServicesConfigsGet_580075;
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
  ##              : Required. The name of the service.  See the [overview](/service-management/overview)
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
  ##           : Required. The id of the service configuration resource.
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
  var path_580094 = newJObject()
  var query_580095 = newJObject()
  add(query_580095, "key", newJString(key))
  add(query_580095, "prettyPrint", newJBool(prettyPrint))
  add(query_580095, "oauth_token", newJString(oauthToken))
  add(path_580094, "serviceName", newJString(serviceName))
  add(query_580095, "$.xgafv", newJString(Xgafv))
  add(query_580095, "alt", newJString(alt))
  add(query_580095, "uploadType", newJString(uploadType))
  add(query_580095, "quotaUser", newJString(quotaUser))
  add(path_580094, "configId", newJString(configId))
  add(query_580095, "callback", newJString(callback))
  add(query_580095, "fields", newJString(fields))
  add(query_580095, "access_token", newJString(accessToken))
  add(query_580095, "upload_protocol", newJString(uploadProtocol))
  add(query_580095, "view", newJString(view))
  result = call_580093.call(path_580094, query_580095, nil, nil, nil)

var servicemanagementServicesConfigsGet* = Call_ServicemanagementServicesConfigsGet_580075(
    name: "servicemanagementServicesConfigsGet", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/configs/{configId}",
    validator: validate_ServicemanagementServicesConfigsGet_580076, base: "/",
    url: url_ServicemanagementServicesConfigsGet_580077, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConfigsSubmit_580096 = ref object of OpenApiRestCall_579373
proc url_ServicemanagementServicesConfigsSubmit_580098(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ServicemanagementServicesConfigsSubmit_580097(path: JsonNode;
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
  ##              : Required. The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_580099 = path.getOrDefault("serviceName")
  valid_580099 = validateParameter(valid_580099, JString, required = true,
                                 default = nil)
  if valid_580099 != nil:
    section.add "serviceName", valid_580099
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
  var valid_580100 = query.getOrDefault("key")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "key", valid_580100
  var valid_580101 = query.getOrDefault("prettyPrint")
  valid_580101 = validateParameter(valid_580101, JBool, required = false,
                                 default = newJBool(true))
  if valid_580101 != nil:
    section.add "prettyPrint", valid_580101
  var valid_580102 = query.getOrDefault("oauth_token")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "oauth_token", valid_580102
  var valid_580103 = query.getOrDefault("$.xgafv")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = newJString("1"))
  if valid_580103 != nil:
    section.add "$.xgafv", valid_580103
  var valid_580104 = query.getOrDefault("alt")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = newJString("json"))
  if valid_580104 != nil:
    section.add "alt", valid_580104
  var valid_580105 = query.getOrDefault("uploadType")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "uploadType", valid_580105
  var valid_580106 = query.getOrDefault("quotaUser")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "quotaUser", valid_580106
  var valid_580107 = query.getOrDefault("callback")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "callback", valid_580107
  var valid_580108 = query.getOrDefault("fields")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "fields", valid_580108
  var valid_580109 = query.getOrDefault("access_token")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "access_token", valid_580109
  var valid_580110 = query.getOrDefault("upload_protocol")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "upload_protocol", valid_580110
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

proc call*(call_580112: Call_ServicemanagementServicesConfigsSubmit_580096;
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
  let valid = call_580112.validator(path, query, header, formData, body)
  let scheme = call_580112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580112.url(scheme.get, call_580112.host, call_580112.base,
                         call_580112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580112, url, valid)

proc call*(call_580113: Call_ServicemanagementServicesConfigsSubmit_580096;
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
  ##              : Required. The name of the service.  See the [overview](/service-management/overview)
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
  var path_580114 = newJObject()
  var query_580115 = newJObject()
  var body_580116 = newJObject()
  add(query_580115, "key", newJString(key))
  add(query_580115, "prettyPrint", newJBool(prettyPrint))
  add(query_580115, "oauth_token", newJString(oauthToken))
  add(path_580114, "serviceName", newJString(serviceName))
  add(query_580115, "$.xgafv", newJString(Xgafv))
  add(query_580115, "alt", newJString(alt))
  add(query_580115, "uploadType", newJString(uploadType))
  add(query_580115, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580116 = body
  add(query_580115, "callback", newJString(callback))
  add(query_580115, "fields", newJString(fields))
  add(query_580115, "access_token", newJString(accessToken))
  add(query_580115, "upload_protocol", newJString(uploadProtocol))
  result = call_580113.call(path_580114, query_580115, nil, nil, body_580116)

var servicemanagementServicesConfigsSubmit* = Call_ServicemanagementServicesConfigsSubmit_580096(
    name: "servicemanagementServicesConfigsSubmit", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/configs:submit",
    validator: validate_ServicemanagementServicesConfigsSubmit_580097, base: "/",
    url: url_ServicemanagementServicesConfigsSubmit_580098,
    schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesRolloutsCreate_580139 = ref object of OpenApiRestCall_579373
proc url_ServicemanagementServicesRolloutsCreate_580141(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ServicemanagementServicesRolloutsCreate_580140(path: JsonNode;
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
  ##              : Required. The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_580142 = path.getOrDefault("serviceName")
  valid_580142 = validateParameter(valid_580142, JString, required = true,
                                 default = nil)
  if valid_580142 != nil:
    section.add "serviceName", valid_580142
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
  var valid_580143 = query.getOrDefault("key")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "key", valid_580143
  var valid_580144 = query.getOrDefault("prettyPrint")
  valid_580144 = validateParameter(valid_580144, JBool, required = false,
                                 default = newJBool(true))
  if valid_580144 != nil:
    section.add "prettyPrint", valid_580144
  var valid_580145 = query.getOrDefault("oauth_token")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "oauth_token", valid_580145
  var valid_580146 = query.getOrDefault("$.xgafv")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = newJString("1"))
  if valid_580146 != nil:
    section.add "$.xgafv", valid_580146
  var valid_580147 = query.getOrDefault("alt")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = newJString("json"))
  if valid_580147 != nil:
    section.add "alt", valid_580147
  var valid_580148 = query.getOrDefault("uploadType")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "uploadType", valid_580148
  var valid_580149 = query.getOrDefault("quotaUser")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "quotaUser", valid_580149
  var valid_580150 = query.getOrDefault("baseRolloutId")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "baseRolloutId", valid_580150
  var valid_580151 = query.getOrDefault("callback")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "callback", valid_580151
  var valid_580152 = query.getOrDefault("fields")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "fields", valid_580152
  var valid_580153 = query.getOrDefault("access_token")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "access_token", valid_580153
  var valid_580154 = query.getOrDefault("upload_protocol")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "upload_protocol", valid_580154
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

proc call*(call_580156: Call_ServicemanagementServicesRolloutsCreate_580139;
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
  let valid = call_580156.validator(path, query, header, formData, body)
  let scheme = call_580156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580156.url(scheme.get, call_580156.host, call_580156.base,
                         call_580156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580156, url, valid)

proc call*(call_580157: Call_ServicemanagementServicesRolloutsCreate_580139;
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
  ##              : Required. The name of the service.  See the [overview](/service-management/overview)
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
  var path_580158 = newJObject()
  var query_580159 = newJObject()
  var body_580160 = newJObject()
  add(query_580159, "key", newJString(key))
  add(query_580159, "prettyPrint", newJBool(prettyPrint))
  add(query_580159, "oauth_token", newJString(oauthToken))
  add(path_580158, "serviceName", newJString(serviceName))
  add(query_580159, "$.xgafv", newJString(Xgafv))
  add(query_580159, "alt", newJString(alt))
  add(query_580159, "uploadType", newJString(uploadType))
  add(query_580159, "quotaUser", newJString(quotaUser))
  add(query_580159, "baseRolloutId", newJString(baseRolloutId))
  if body != nil:
    body_580160 = body
  add(query_580159, "callback", newJString(callback))
  add(query_580159, "fields", newJString(fields))
  add(query_580159, "access_token", newJString(accessToken))
  add(query_580159, "upload_protocol", newJString(uploadProtocol))
  result = call_580157.call(path_580158, query_580159, nil, nil, body_580160)

var servicemanagementServicesRolloutsCreate* = Call_ServicemanagementServicesRolloutsCreate_580139(
    name: "servicemanagementServicesRolloutsCreate", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/rollouts",
    validator: validate_ServicemanagementServicesRolloutsCreate_580140, base: "/",
    url: url_ServicemanagementServicesRolloutsCreate_580141,
    schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesRolloutsList_580117 = ref object of OpenApiRestCall_579373
proc url_ServicemanagementServicesRolloutsList_580119(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ServicemanagementServicesRolloutsList_580118(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the history of the service configuration rollouts for a managed
  ## service, from the newest to the oldest.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : Required. The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_580120 = path.getOrDefault("serviceName")
  valid_580120 = validateParameter(valid_580120, JString, required = true,
                                 default = nil)
  if valid_580120 != nil:
    section.add "serviceName", valid_580120
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
  ##         : Required. Use `filter` to return subset of rollouts.
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
  var valid_580121 = query.getOrDefault("key")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "key", valid_580121
  var valid_580122 = query.getOrDefault("prettyPrint")
  valid_580122 = validateParameter(valid_580122, JBool, required = false,
                                 default = newJBool(true))
  if valid_580122 != nil:
    section.add "prettyPrint", valid_580122
  var valid_580123 = query.getOrDefault("oauth_token")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "oauth_token", valid_580123
  var valid_580124 = query.getOrDefault("$.xgafv")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = newJString("1"))
  if valid_580124 != nil:
    section.add "$.xgafv", valid_580124
  var valid_580125 = query.getOrDefault("pageSize")
  valid_580125 = validateParameter(valid_580125, JInt, required = false, default = nil)
  if valid_580125 != nil:
    section.add "pageSize", valid_580125
  var valid_580126 = query.getOrDefault("alt")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = newJString("json"))
  if valid_580126 != nil:
    section.add "alt", valid_580126
  var valid_580127 = query.getOrDefault("uploadType")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "uploadType", valid_580127
  var valid_580128 = query.getOrDefault("quotaUser")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "quotaUser", valid_580128
  var valid_580129 = query.getOrDefault("filter")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "filter", valid_580129
  var valid_580130 = query.getOrDefault("pageToken")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "pageToken", valid_580130
  var valid_580131 = query.getOrDefault("callback")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "callback", valid_580131
  var valid_580132 = query.getOrDefault("fields")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "fields", valid_580132
  var valid_580133 = query.getOrDefault("access_token")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "access_token", valid_580133
  var valid_580134 = query.getOrDefault("upload_protocol")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "upload_protocol", valid_580134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580135: Call_ServicemanagementServicesRolloutsList_580117;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the history of the service configuration rollouts for a managed
  ## service, from the newest to the oldest.
  ## 
  let valid = call_580135.validator(path, query, header, formData, body)
  let scheme = call_580135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580135.url(scheme.get, call_580135.host, call_580135.base,
                         call_580135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580135, url, valid)

proc call*(call_580136: Call_ServicemanagementServicesRolloutsList_580117;
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
  ##              : Required. The name of the service.  See the [overview](/service-management/overview)
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
  ##         : Required. Use `filter` to return subset of rollouts.
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
  var path_580137 = newJObject()
  var query_580138 = newJObject()
  add(query_580138, "key", newJString(key))
  add(query_580138, "prettyPrint", newJBool(prettyPrint))
  add(query_580138, "oauth_token", newJString(oauthToken))
  add(path_580137, "serviceName", newJString(serviceName))
  add(query_580138, "$.xgafv", newJString(Xgafv))
  add(query_580138, "pageSize", newJInt(pageSize))
  add(query_580138, "alt", newJString(alt))
  add(query_580138, "uploadType", newJString(uploadType))
  add(query_580138, "quotaUser", newJString(quotaUser))
  add(query_580138, "filter", newJString(filter))
  add(query_580138, "pageToken", newJString(pageToken))
  add(query_580138, "callback", newJString(callback))
  add(query_580138, "fields", newJString(fields))
  add(query_580138, "access_token", newJString(accessToken))
  add(query_580138, "upload_protocol", newJString(uploadProtocol))
  result = call_580136.call(path_580137, query_580138, nil, nil, nil)

var servicemanagementServicesRolloutsList* = Call_ServicemanagementServicesRolloutsList_580117(
    name: "servicemanagementServicesRolloutsList", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/rollouts",
    validator: validate_ServicemanagementServicesRolloutsList_580118, base: "/",
    url: url_ServicemanagementServicesRolloutsList_580119, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesRolloutsGet_580161 = ref object of OpenApiRestCall_579373
proc url_ServicemanagementServicesRolloutsGet_580163(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ServicemanagementServicesRolloutsGet_580162(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a service configuration rollout.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : Required. The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  ##   rolloutId: JString (required)
  ##            : Required. The id of the rollout resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_580164 = path.getOrDefault("serviceName")
  valid_580164 = validateParameter(valid_580164, JString, required = true,
                                 default = nil)
  if valid_580164 != nil:
    section.add "serviceName", valid_580164
  var valid_580165 = path.getOrDefault("rolloutId")
  valid_580165 = validateParameter(valid_580165, JString, required = true,
                                 default = nil)
  if valid_580165 != nil:
    section.add "rolloutId", valid_580165
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
  var valid_580166 = query.getOrDefault("key")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "key", valid_580166
  var valid_580167 = query.getOrDefault("prettyPrint")
  valid_580167 = validateParameter(valid_580167, JBool, required = false,
                                 default = newJBool(true))
  if valid_580167 != nil:
    section.add "prettyPrint", valid_580167
  var valid_580168 = query.getOrDefault("oauth_token")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "oauth_token", valid_580168
  var valid_580169 = query.getOrDefault("$.xgafv")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = newJString("1"))
  if valid_580169 != nil:
    section.add "$.xgafv", valid_580169
  var valid_580170 = query.getOrDefault("alt")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = newJString("json"))
  if valid_580170 != nil:
    section.add "alt", valid_580170
  var valid_580171 = query.getOrDefault("uploadType")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "uploadType", valid_580171
  var valid_580172 = query.getOrDefault("quotaUser")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "quotaUser", valid_580172
  var valid_580173 = query.getOrDefault("callback")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "callback", valid_580173
  var valid_580174 = query.getOrDefault("fields")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "fields", valid_580174
  var valid_580175 = query.getOrDefault("access_token")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "access_token", valid_580175
  var valid_580176 = query.getOrDefault("upload_protocol")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "upload_protocol", valid_580176
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580177: Call_ServicemanagementServicesRolloutsGet_580161;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a service configuration rollout.
  ## 
  let valid = call_580177.validator(path, query, header, formData, body)
  let scheme = call_580177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580177.url(scheme.get, call_580177.host, call_580177.base,
                         call_580177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580177, url, valid)

proc call*(call_580178: Call_ServicemanagementServicesRolloutsGet_580161;
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
  ##              : Required. The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   rolloutId: string (required)
  ##            : Required. The id of the rollout resource.
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
  var path_580179 = newJObject()
  var query_580180 = newJObject()
  add(query_580180, "key", newJString(key))
  add(query_580180, "prettyPrint", newJBool(prettyPrint))
  add(query_580180, "oauth_token", newJString(oauthToken))
  add(path_580179, "serviceName", newJString(serviceName))
  add(query_580180, "$.xgafv", newJString(Xgafv))
  add(path_580179, "rolloutId", newJString(rolloutId))
  add(query_580180, "alt", newJString(alt))
  add(query_580180, "uploadType", newJString(uploadType))
  add(query_580180, "quotaUser", newJString(quotaUser))
  add(query_580180, "callback", newJString(callback))
  add(query_580180, "fields", newJString(fields))
  add(query_580180, "access_token", newJString(accessToken))
  add(query_580180, "upload_protocol", newJString(uploadProtocol))
  result = call_580178.call(path_580179, query_580180, nil, nil, nil)

var servicemanagementServicesRolloutsGet* = Call_ServicemanagementServicesRolloutsGet_580161(
    name: "servicemanagementServicesRolloutsGet", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/rollouts/{rolloutId}",
    validator: validate_ServicemanagementServicesRolloutsGet_580162, base: "/",
    url: url_ServicemanagementServicesRolloutsGet_580163, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesDisable_580181 = ref object of OpenApiRestCall_579373
proc url_ServicemanagementServicesDisable_580183(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ServicemanagementServicesDisable_580182(path: JsonNode;
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
  ##              : Required. Name of the service to disable. Specifying an unknown service name
  ## will cause the request to fail.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_580184 = path.getOrDefault("serviceName")
  valid_580184 = validateParameter(valid_580184, JString, required = true,
                                 default = nil)
  if valid_580184 != nil:
    section.add "serviceName", valid_580184
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
  var valid_580185 = query.getOrDefault("key")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "key", valid_580185
  var valid_580186 = query.getOrDefault("prettyPrint")
  valid_580186 = validateParameter(valid_580186, JBool, required = false,
                                 default = newJBool(true))
  if valid_580186 != nil:
    section.add "prettyPrint", valid_580186
  var valid_580187 = query.getOrDefault("oauth_token")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "oauth_token", valid_580187
  var valid_580188 = query.getOrDefault("$.xgafv")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = newJString("1"))
  if valid_580188 != nil:
    section.add "$.xgafv", valid_580188
  var valid_580189 = query.getOrDefault("alt")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = newJString("json"))
  if valid_580189 != nil:
    section.add "alt", valid_580189
  var valid_580190 = query.getOrDefault("uploadType")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "uploadType", valid_580190
  var valid_580191 = query.getOrDefault("quotaUser")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "quotaUser", valid_580191
  var valid_580192 = query.getOrDefault("callback")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "callback", valid_580192
  var valid_580193 = query.getOrDefault("fields")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "fields", valid_580193
  var valid_580194 = query.getOrDefault("access_token")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "access_token", valid_580194
  var valid_580195 = query.getOrDefault("upload_protocol")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "upload_protocol", valid_580195
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

proc call*(call_580197: Call_ServicemanagementServicesDisable_580181;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Disables a service for a project, so it can no longer be
  ## be used for the project. It prevents accidental usage that may cause
  ## unexpected billing charges or security leaks.
  ## 
  ## Operation<response: DisableServiceResponse>
  ## 
  let valid = call_580197.validator(path, query, header, formData, body)
  let scheme = call_580197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580197.url(scheme.get, call_580197.host, call_580197.base,
                         call_580197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580197, url, valid)

proc call*(call_580198: Call_ServicemanagementServicesDisable_580181;
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
  ##              : Required. Name of the service to disable. Specifying an unknown service name
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
  var path_580199 = newJObject()
  var query_580200 = newJObject()
  var body_580201 = newJObject()
  add(query_580200, "key", newJString(key))
  add(query_580200, "prettyPrint", newJBool(prettyPrint))
  add(query_580200, "oauth_token", newJString(oauthToken))
  add(path_580199, "serviceName", newJString(serviceName))
  add(query_580200, "$.xgafv", newJString(Xgafv))
  add(query_580200, "alt", newJString(alt))
  add(query_580200, "uploadType", newJString(uploadType))
  add(query_580200, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580201 = body
  add(query_580200, "callback", newJString(callback))
  add(query_580200, "fields", newJString(fields))
  add(query_580200, "access_token", newJString(accessToken))
  add(query_580200, "upload_protocol", newJString(uploadProtocol))
  result = call_580198.call(path_580199, query_580200, nil, nil, body_580201)

var servicemanagementServicesDisable* = Call_ServicemanagementServicesDisable_580181(
    name: "servicemanagementServicesDisable", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}:disable",
    validator: validate_ServicemanagementServicesDisable_580182, base: "/",
    url: url_ServicemanagementServicesDisable_580183, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesEnable_580202 = ref object of OpenApiRestCall_579373
proc url_ServicemanagementServicesEnable_580204(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ServicemanagementServicesEnable_580203(path: JsonNode;
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
  ##              : Required. Name of the service to enable. Specifying an unknown service name will
  ## cause the request to fail.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_580205 = path.getOrDefault("serviceName")
  valid_580205 = validateParameter(valid_580205, JString, required = true,
                                 default = nil)
  if valid_580205 != nil:
    section.add "serviceName", valid_580205
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
  var valid_580206 = query.getOrDefault("key")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "key", valid_580206
  var valid_580207 = query.getOrDefault("prettyPrint")
  valid_580207 = validateParameter(valid_580207, JBool, required = false,
                                 default = newJBool(true))
  if valid_580207 != nil:
    section.add "prettyPrint", valid_580207
  var valid_580208 = query.getOrDefault("oauth_token")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "oauth_token", valid_580208
  var valid_580209 = query.getOrDefault("$.xgafv")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = newJString("1"))
  if valid_580209 != nil:
    section.add "$.xgafv", valid_580209
  var valid_580210 = query.getOrDefault("alt")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = newJString("json"))
  if valid_580210 != nil:
    section.add "alt", valid_580210
  var valid_580211 = query.getOrDefault("uploadType")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "uploadType", valid_580211
  var valid_580212 = query.getOrDefault("quotaUser")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "quotaUser", valid_580212
  var valid_580213 = query.getOrDefault("callback")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "callback", valid_580213
  var valid_580214 = query.getOrDefault("fields")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "fields", valid_580214
  var valid_580215 = query.getOrDefault("access_token")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "access_token", valid_580215
  var valid_580216 = query.getOrDefault("upload_protocol")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "upload_protocol", valid_580216
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

proc call*(call_580218: Call_ServicemanagementServicesEnable_580202;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables a service for a project, so it can be used
  ## for the project. See
  ## [Cloud Auth Guide](https://cloud.google.com/docs/authentication) for
  ## more information.
  ## 
  ## Operation<response: EnableServiceResponse>
  ## 
  let valid = call_580218.validator(path, query, header, formData, body)
  let scheme = call_580218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580218.url(scheme.get, call_580218.host, call_580218.base,
                         call_580218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580218, url, valid)

proc call*(call_580219: Call_ServicemanagementServicesEnable_580202;
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
  ##              : Required. Name of the service to enable. Specifying an unknown service name will
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
  var path_580220 = newJObject()
  var query_580221 = newJObject()
  var body_580222 = newJObject()
  add(query_580221, "key", newJString(key))
  add(query_580221, "prettyPrint", newJBool(prettyPrint))
  add(query_580221, "oauth_token", newJString(oauthToken))
  add(path_580220, "serviceName", newJString(serviceName))
  add(query_580221, "$.xgafv", newJString(Xgafv))
  add(query_580221, "alt", newJString(alt))
  add(query_580221, "uploadType", newJString(uploadType))
  add(query_580221, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580222 = body
  add(query_580221, "callback", newJString(callback))
  add(query_580221, "fields", newJString(fields))
  add(query_580221, "access_token", newJString(accessToken))
  add(query_580221, "upload_protocol", newJString(uploadProtocol))
  result = call_580219.call(path_580220, query_580221, nil, nil, body_580222)

var servicemanagementServicesEnable* = Call_ServicemanagementServicesEnable_580202(
    name: "servicemanagementServicesEnable", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}:enable",
    validator: validate_ServicemanagementServicesEnable_580203, base: "/",
    url: url_ServicemanagementServicesEnable_580204, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesUndelete_580223 = ref object of OpenApiRestCall_579373
proc url_ServicemanagementServicesUndelete_580225(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ServicemanagementServicesUndelete_580224(path: JsonNode;
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
  ##              : Required. The name of the service. See the [overview](/service-management/overview)
  ## for naming requirements. For example: `example.googleapis.com`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_580226 = path.getOrDefault("serviceName")
  valid_580226 = validateParameter(valid_580226, JString, required = true,
                                 default = nil)
  if valid_580226 != nil:
    section.add "serviceName", valid_580226
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
  var valid_580227 = query.getOrDefault("key")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "key", valid_580227
  var valid_580228 = query.getOrDefault("prettyPrint")
  valid_580228 = validateParameter(valid_580228, JBool, required = false,
                                 default = newJBool(true))
  if valid_580228 != nil:
    section.add "prettyPrint", valid_580228
  var valid_580229 = query.getOrDefault("oauth_token")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "oauth_token", valid_580229
  var valid_580230 = query.getOrDefault("$.xgafv")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = newJString("1"))
  if valid_580230 != nil:
    section.add "$.xgafv", valid_580230
  var valid_580231 = query.getOrDefault("alt")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = newJString("json"))
  if valid_580231 != nil:
    section.add "alt", valid_580231
  var valid_580232 = query.getOrDefault("uploadType")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "uploadType", valid_580232
  var valid_580233 = query.getOrDefault("quotaUser")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "quotaUser", valid_580233
  var valid_580234 = query.getOrDefault("callback")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "callback", valid_580234
  var valid_580235 = query.getOrDefault("fields")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "fields", valid_580235
  var valid_580236 = query.getOrDefault("access_token")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "access_token", valid_580236
  var valid_580237 = query.getOrDefault("upload_protocol")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "upload_protocol", valid_580237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580238: Call_ServicemanagementServicesUndelete_580223;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Revives a previously deleted managed service. The method restores the
  ## service using the configuration at the time the service was deleted.
  ## The target service must exist and must have been deleted within the
  ## last 30 days.
  ## 
  ## Operation<response: UndeleteServiceResponse>
  ## 
  let valid = call_580238.validator(path, query, header, formData, body)
  let scheme = call_580238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580238.url(scheme.get, call_580238.host, call_580238.base,
                         call_580238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580238, url, valid)

proc call*(call_580239: Call_ServicemanagementServicesUndelete_580223;
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
  ##              : Required. The name of the service. See the [overview](/service-management/overview)
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
  var path_580240 = newJObject()
  var query_580241 = newJObject()
  add(query_580241, "key", newJString(key))
  add(query_580241, "prettyPrint", newJBool(prettyPrint))
  add(query_580241, "oauth_token", newJString(oauthToken))
  add(path_580240, "serviceName", newJString(serviceName))
  add(query_580241, "$.xgafv", newJString(Xgafv))
  add(query_580241, "alt", newJString(alt))
  add(query_580241, "uploadType", newJString(uploadType))
  add(query_580241, "quotaUser", newJString(quotaUser))
  add(query_580241, "callback", newJString(callback))
  add(query_580241, "fields", newJString(fields))
  add(query_580241, "access_token", newJString(accessToken))
  add(query_580241, "upload_protocol", newJString(uploadProtocol))
  result = call_580239.call(path_580240, query_580241, nil, nil, nil)

var servicemanagementServicesUndelete* = Call_ServicemanagementServicesUndelete_580223(
    name: "servicemanagementServicesUndelete", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}:undelete",
    validator: validate_ServicemanagementServicesUndelete_580224, base: "/",
    url: url_ServicemanagementServicesUndelete_580225, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesGenerateConfigReport_580242 = ref object of OpenApiRestCall_579373
proc url_ServicemanagementServicesGenerateConfigReport_580244(protocol: Scheme;
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

proc validate_ServicemanagementServicesGenerateConfigReport_580243(
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
  var valid_580245 = query.getOrDefault("key")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "key", valid_580245
  var valid_580246 = query.getOrDefault("prettyPrint")
  valid_580246 = validateParameter(valid_580246, JBool, required = false,
                                 default = newJBool(true))
  if valid_580246 != nil:
    section.add "prettyPrint", valid_580246
  var valid_580247 = query.getOrDefault("oauth_token")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "oauth_token", valid_580247
  var valid_580248 = query.getOrDefault("$.xgafv")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = newJString("1"))
  if valid_580248 != nil:
    section.add "$.xgafv", valid_580248
  var valid_580249 = query.getOrDefault("alt")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = newJString("json"))
  if valid_580249 != nil:
    section.add "alt", valid_580249
  var valid_580250 = query.getOrDefault("uploadType")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "uploadType", valid_580250
  var valid_580251 = query.getOrDefault("quotaUser")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "quotaUser", valid_580251
  var valid_580252 = query.getOrDefault("callback")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "callback", valid_580252
  var valid_580253 = query.getOrDefault("fields")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "fields", valid_580253
  var valid_580254 = query.getOrDefault("access_token")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "access_token", valid_580254
  var valid_580255 = query.getOrDefault("upload_protocol")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "upload_protocol", valid_580255
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

proc call*(call_580257: Call_ServicemanagementServicesGenerateConfigReport_580242;
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
  let valid = call_580257.validator(path, query, header, formData, body)
  let scheme = call_580257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580257.url(scheme.get, call_580257.host, call_580257.base,
                         call_580257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580257, url, valid)

proc call*(call_580258: Call_ServicemanagementServicesGenerateConfigReport_580242;
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
  var query_580259 = newJObject()
  var body_580260 = newJObject()
  add(query_580259, "key", newJString(key))
  add(query_580259, "prettyPrint", newJBool(prettyPrint))
  add(query_580259, "oauth_token", newJString(oauthToken))
  add(query_580259, "$.xgafv", newJString(Xgafv))
  add(query_580259, "alt", newJString(alt))
  add(query_580259, "uploadType", newJString(uploadType))
  add(query_580259, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580260 = body
  add(query_580259, "callback", newJString(callback))
  add(query_580259, "fields", newJString(fields))
  add(query_580259, "access_token", newJString(accessToken))
  add(query_580259, "upload_protocol", newJString(uploadProtocol))
  result = call_580258.call(nil, query_580259, nil, nil, body_580260)

var servicemanagementServicesGenerateConfigReport* = Call_ServicemanagementServicesGenerateConfigReport_580242(
    name: "servicemanagementServicesGenerateConfigReport",
    meth: HttpMethod.HttpPost, host: "servicemanagement.googleapis.com",
    route: "/v1/services:generateConfigReport",
    validator: validate_ServicemanagementServicesGenerateConfigReport_580243,
    base: "/", url: url_ServicemanagementServicesGenerateConfigReport_580244,
    schemes: {Scheme.Https})
type
  Call_ServicemanagementOperationsGet_580261 = ref object of OpenApiRestCall_579373
proc url_ServicemanagementOperationsGet_580263(protocol: Scheme; host: string;
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

proc validate_ServicemanagementOperationsGet_580262(path: JsonNode;
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
  if body != nil:
    result.add "body", body

proc call*(call_580276: Call_ServicemanagementOperationsGet_580261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_580276.validator(path, query, header, formData, body)
  let scheme = call_580276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580276.url(scheme.get, call_580276.host, call_580276.base,
                         call_580276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580276, url, valid)

proc call*(call_580277: Call_ServicemanagementOperationsGet_580261; name: string;
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
  var path_580278 = newJObject()
  var query_580279 = newJObject()
  add(query_580279, "key", newJString(key))
  add(query_580279, "prettyPrint", newJBool(prettyPrint))
  add(query_580279, "oauth_token", newJString(oauthToken))
  add(query_580279, "$.xgafv", newJString(Xgafv))
  add(query_580279, "alt", newJString(alt))
  add(query_580279, "uploadType", newJString(uploadType))
  add(query_580279, "quotaUser", newJString(quotaUser))
  add(path_580278, "name", newJString(name))
  add(query_580279, "callback", newJString(callback))
  add(query_580279, "fields", newJString(fields))
  add(query_580279, "access_token", newJString(accessToken))
  add(query_580279, "upload_protocol", newJString(uploadProtocol))
  result = call_580277.call(path_580278, query_580279, nil, nil, nil)

var servicemanagementOperationsGet* = Call_ServicemanagementOperationsGet_580261(
    name: "servicemanagementOperationsGet", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com", route: "/v1/{name}",
    validator: validate_ServicemanagementOperationsGet_580262, base: "/",
    url: url_ServicemanagementOperationsGet_580263, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConsumersGetIamPolicy_580280 = ref object of OpenApiRestCall_579373
proc url_ServicemanagementServicesConsumersGetIamPolicy_580282(protocol: Scheme;
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

proc validate_ServicemanagementServicesConsumersGetIamPolicy_580281(
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
  var valid_580283 = path.getOrDefault("resource")
  valid_580283 = validateParameter(valid_580283, JString, required = true,
                                 default = nil)
  if valid_580283 != nil:
    section.add "resource", valid_580283
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
  var valid_580284 = query.getOrDefault("key")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "key", valid_580284
  var valid_580285 = query.getOrDefault("prettyPrint")
  valid_580285 = validateParameter(valid_580285, JBool, required = false,
                                 default = newJBool(true))
  if valid_580285 != nil:
    section.add "prettyPrint", valid_580285
  var valid_580286 = query.getOrDefault("oauth_token")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "oauth_token", valid_580286
  var valid_580287 = query.getOrDefault("$.xgafv")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = newJString("1"))
  if valid_580287 != nil:
    section.add "$.xgafv", valid_580287
  var valid_580288 = query.getOrDefault("alt")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = newJString("json"))
  if valid_580288 != nil:
    section.add "alt", valid_580288
  var valid_580289 = query.getOrDefault("uploadType")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "uploadType", valid_580289
  var valid_580290 = query.getOrDefault("quotaUser")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "quotaUser", valid_580290
  var valid_580291 = query.getOrDefault("callback")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "callback", valid_580291
  var valid_580292 = query.getOrDefault("fields")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = nil)
  if valid_580292 != nil:
    section.add "fields", valid_580292
  var valid_580293 = query.getOrDefault("access_token")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "access_token", valid_580293
  var valid_580294 = query.getOrDefault("upload_protocol")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "upload_protocol", valid_580294
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

proc call*(call_580296: Call_ServicemanagementServicesConsumersGetIamPolicy_580280;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_580296.validator(path, query, header, formData, body)
  let scheme = call_580296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580296.url(scheme.get, call_580296.host, call_580296.base,
                         call_580296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580296, url, valid)

proc call*(call_580297: Call_ServicemanagementServicesConsumersGetIamPolicy_580280;
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
  var path_580298 = newJObject()
  var query_580299 = newJObject()
  var body_580300 = newJObject()
  add(query_580299, "key", newJString(key))
  add(query_580299, "prettyPrint", newJBool(prettyPrint))
  add(query_580299, "oauth_token", newJString(oauthToken))
  add(query_580299, "$.xgafv", newJString(Xgafv))
  add(query_580299, "alt", newJString(alt))
  add(query_580299, "uploadType", newJString(uploadType))
  add(query_580299, "quotaUser", newJString(quotaUser))
  add(path_580298, "resource", newJString(resource))
  if body != nil:
    body_580300 = body
  add(query_580299, "callback", newJString(callback))
  add(query_580299, "fields", newJString(fields))
  add(query_580299, "access_token", newJString(accessToken))
  add(query_580299, "upload_protocol", newJString(uploadProtocol))
  result = call_580297.call(path_580298, query_580299, nil, nil, body_580300)

var servicemanagementServicesConsumersGetIamPolicy* = Call_ServicemanagementServicesConsumersGetIamPolicy_580280(
    name: "servicemanagementServicesConsumersGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "servicemanagement.googleapis.com",
    route: "/v1/{resource}:getIamPolicy",
    validator: validate_ServicemanagementServicesConsumersGetIamPolicy_580281,
    base: "/", url: url_ServicemanagementServicesConsumersGetIamPolicy_580282,
    schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConsumersSetIamPolicy_580301 = ref object of OpenApiRestCall_579373
proc url_ServicemanagementServicesConsumersSetIamPolicy_580303(protocol: Scheme;
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

proc validate_ServicemanagementServicesConsumersSetIamPolicy_580302(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  ## Can return Public Errors: NOT_FOUND, INVALID_ARGUMENT and PERMISSION_DENIED
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580304 = path.getOrDefault("resource")
  valid_580304 = validateParameter(valid_580304, JString, required = true,
                                 default = nil)
  if valid_580304 != nil:
    section.add "resource", valid_580304
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
  var valid_580305 = query.getOrDefault("key")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = nil)
  if valid_580305 != nil:
    section.add "key", valid_580305
  var valid_580306 = query.getOrDefault("prettyPrint")
  valid_580306 = validateParameter(valid_580306, JBool, required = false,
                                 default = newJBool(true))
  if valid_580306 != nil:
    section.add "prettyPrint", valid_580306
  var valid_580307 = query.getOrDefault("oauth_token")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "oauth_token", valid_580307
  var valid_580308 = query.getOrDefault("$.xgafv")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = newJString("1"))
  if valid_580308 != nil:
    section.add "$.xgafv", valid_580308
  var valid_580309 = query.getOrDefault("alt")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = newJString("json"))
  if valid_580309 != nil:
    section.add "alt", valid_580309
  var valid_580310 = query.getOrDefault("uploadType")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = nil)
  if valid_580310 != nil:
    section.add "uploadType", valid_580310
  var valid_580311 = query.getOrDefault("quotaUser")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "quotaUser", valid_580311
  var valid_580312 = query.getOrDefault("callback")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = nil)
  if valid_580312 != nil:
    section.add "callback", valid_580312
  var valid_580313 = query.getOrDefault("fields")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "fields", valid_580313
  var valid_580314 = query.getOrDefault("access_token")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = nil)
  if valid_580314 != nil:
    section.add "access_token", valid_580314
  var valid_580315 = query.getOrDefault("upload_protocol")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "upload_protocol", valid_580315
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

proc call*(call_580317: Call_ServicemanagementServicesConsumersSetIamPolicy_580301;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  ## Can return Public Errors: NOT_FOUND, INVALID_ARGUMENT and PERMISSION_DENIED
  ## 
  let valid = call_580317.validator(path, query, header, formData, body)
  let scheme = call_580317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580317.url(scheme.get, call_580317.host, call_580317.base,
                         call_580317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580317, url, valid)

proc call*(call_580318: Call_ServicemanagementServicesConsumersSetIamPolicy_580301;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## servicemanagementServicesConsumersSetIamPolicy
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  ## Can return Public Errors: NOT_FOUND, INVALID_ARGUMENT and PERMISSION_DENIED
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
  var path_580319 = newJObject()
  var query_580320 = newJObject()
  var body_580321 = newJObject()
  add(query_580320, "key", newJString(key))
  add(query_580320, "prettyPrint", newJBool(prettyPrint))
  add(query_580320, "oauth_token", newJString(oauthToken))
  add(query_580320, "$.xgafv", newJString(Xgafv))
  add(query_580320, "alt", newJString(alt))
  add(query_580320, "uploadType", newJString(uploadType))
  add(query_580320, "quotaUser", newJString(quotaUser))
  add(path_580319, "resource", newJString(resource))
  if body != nil:
    body_580321 = body
  add(query_580320, "callback", newJString(callback))
  add(query_580320, "fields", newJString(fields))
  add(query_580320, "access_token", newJString(accessToken))
  add(query_580320, "upload_protocol", newJString(uploadProtocol))
  result = call_580318.call(path_580319, query_580320, nil, nil, body_580321)

var servicemanagementServicesConsumersSetIamPolicy* = Call_ServicemanagementServicesConsumersSetIamPolicy_580301(
    name: "servicemanagementServicesConsumersSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "servicemanagement.googleapis.com",
    route: "/v1/{resource}:setIamPolicy",
    validator: validate_ServicemanagementServicesConsumersSetIamPolicy_580302,
    base: "/", url: url_ServicemanagementServicesConsumersSetIamPolicy_580303,
    schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConsumersTestIamPermissions_580322 = ref object of OpenApiRestCall_579373
proc url_ServicemanagementServicesConsumersTestIamPermissions_580324(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ServicemanagementServicesConsumersTestIamPermissions_580323(
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
  var valid_580325 = path.getOrDefault("resource")
  valid_580325 = validateParameter(valid_580325, JString, required = true,
                                 default = nil)
  if valid_580325 != nil:
    section.add "resource", valid_580325
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
  var valid_580326 = query.getOrDefault("key")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = nil)
  if valid_580326 != nil:
    section.add "key", valid_580326
  var valid_580327 = query.getOrDefault("prettyPrint")
  valid_580327 = validateParameter(valid_580327, JBool, required = false,
                                 default = newJBool(true))
  if valid_580327 != nil:
    section.add "prettyPrint", valid_580327
  var valid_580328 = query.getOrDefault("oauth_token")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "oauth_token", valid_580328
  var valid_580329 = query.getOrDefault("$.xgafv")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = newJString("1"))
  if valid_580329 != nil:
    section.add "$.xgafv", valid_580329
  var valid_580330 = query.getOrDefault("alt")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = newJString("json"))
  if valid_580330 != nil:
    section.add "alt", valid_580330
  var valid_580331 = query.getOrDefault("uploadType")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "uploadType", valid_580331
  var valid_580332 = query.getOrDefault("quotaUser")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = nil)
  if valid_580332 != nil:
    section.add "quotaUser", valid_580332
  var valid_580333 = query.getOrDefault("callback")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "callback", valid_580333
  var valid_580334 = query.getOrDefault("fields")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = nil)
  if valid_580334 != nil:
    section.add "fields", valid_580334
  var valid_580335 = query.getOrDefault("access_token")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = nil)
  if valid_580335 != nil:
    section.add "access_token", valid_580335
  var valid_580336 = query.getOrDefault("upload_protocol")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "upload_protocol", valid_580336
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

proc call*(call_580338: Call_ServicemanagementServicesConsumersTestIamPermissions_580322;
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
  let valid = call_580338.validator(path, query, header, formData, body)
  let scheme = call_580338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580338.url(scheme.get, call_580338.host, call_580338.base,
                         call_580338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580338, url, valid)

proc call*(call_580339: Call_ServicemanagementServicesConsumersTestIamPermissions_580322;
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
  var path_580340 = newJObject()
  var query_580341 = newJObject()
  var body_580342 = newJObject()
  add(query_580341, "key", newJString(key))
  add(query_580341, "prettyPrint", newJBool(prettyPrint))
  add(query_580341, "oauth_token", newJString(oauthToken))
  add(query_580341, "$.xgafv", newJString(Xgafv))
  add(query_580341, "alt", newJString(alt))
  add(query_580341, "uploadType", newJString(uploadType))
  add(query_580341, "quotaUser", newJString(quotaUser))
  add(path_580340, "resource", newJString(resource))
  if body != nil:
    body_580342 = body
  add(query_580341, "callback", newJString(callback))
  add(query_580341, "fields", newJString(fields))
  add(query_580341, "access_token", newJString(accessToken))
  add(query_580341, "upload_protocol", newJString(uploadProtocol))
  result = call_580339.call(path_580340, query_580341, nil, nil, body_580342)

var servicemanagementServicesConsumersTestIamPermissions* = Call_ServicemanagementServicesConsumersTestIamPermissions_580322(
    name: "servicemanagementServicesConsumersTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "servicemanagement.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_ServicemanagementServicesConsumersTestIamPermissions_580323,
    base: "/", url: url_ServicemanagementServicesConsumersTestIamPermissions_580324,
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
