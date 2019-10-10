
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
  gcpServiceName = "servicemanagement"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServicemanagementOperationsList_588719 = ref object of OpenApiRestCall_588450
proc url_ServicemanagementOperationsList_588721(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ServicemanagementOperationsList_588720(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists service operations that match the specified filter in the request.
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
  ##            : The standard list page token.
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
  ##   name: JString
  ##       : Not used.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of operations to return. If unspecified, defaults to
  ## 50. The maximum value is 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
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
  var valid_588835 = query.getOrDefault("pageToken")
  valid_588835 = validateParameter(valid_588835, JString, required = false,
                                 default = nil)
  if valid_588835 != nil:
    section.add "pageToken", valid_588835
  var valid_588836 = query.getOrDefault("quotaUser")
  valid_588836 = validateParameter(valid_588836, JString, required = false,
                                 default = nil)
  if valid_588836 != nil:
    section.add "quotaUser", valid_588836
  var valid_588850 = query.getOrDefault("alt")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = newJString("json"))
  if valid_588850 != nil:
    section.add "alt", valid_588850
  var valid_588851 = query.getOrDefault("oauth_token")
  valid_588851 = validateParameter(valid_588851, JString, required = false,
                                 default = nil)
  if valid_588851 != nil:
    section.add "oauth_token", valid_588851
  var valid_588852 = query.getOrDefault("callback")
  valid_588852 = validateParameter(valid_588852, JString, required = false,
                                 default = nil)
  if valid_588852 != nil:
    section.add "callback", valid_588852
  var valid_588853 = query.getOrDefault("access_token")
  valid_588853 = validateParameter(valid_588853, JString, required = false,
                                 default = nil)
  if valid_588853 != nil:
    section.add "access_token", valid_588853
  var valid_588854 = query.getOrDefault("uploadType")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = nil)
  if valid_588854 != nil:
    section.add "uploadType", valid_588854
  var valid_588855 = query.getOrDefault("key")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = nil)
  if valid_588855 != nil:
    section.add "key", valid_588855
  var valid_588856 = query.getOrDefault("name")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "name", valid_588856
  var valid_588857 = query.getOrDefault("$.xgafv")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = newJString("1"))
  if valid_588857 != nil:
    section.add "$.xgafv", valid_588857
  var valid_588858 = query.getOrDefault("pageSize")
  valid_588858 = validateParameter(valid_588858, JInt, required = false, default = nil)
  if valid_588858 != nil:
    section.add "pageSize", valid_588858
  var valid_588859 = query.getOrDefault("prettyPrint")
  valid_588859 = validateParameter(valid_588859, JBool, required = false,
                                 default = newJBool(true))
  if valid_588859 != nil:
    section.add "prettyPrint", valid_588859
  var valid_588860 = query.getOrDefault("filter")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "filter", valid_588860
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588883: Call_ServicemanagementOperationsList_588719;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists service operations that match the specified filter in the request.
  ## 
  let valid = call_588883.validator(path, query, header, formData, body)
  let scheme = call_588883.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588883.url(scheme.get, call_588883.host, call_588883.base,
                         call_588883.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588883, url, valid)

proc call*(call_588954: Call_ServicemanagementOperationsList_588719;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; name: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## servicemanagementOperationsList
  ## Lists service operations that match the specified filter in the request.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard list page token.
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
  ##   name: string
  ##       : Not used.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of operations to return. If unspecified, defaults to
  ## 50. The maximum value is 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
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
  var query_588955 = newJObject()
  add(query_588955, "upload_protocol", newJString(uploadProtocol))
  add(query_588955, "fields", newJString(fields))
  add(query_588955, "pageToken", newJString(pageToken))
  add(query_588955, "quotaUser", newJString(quotaUser))
  add(query_588955, "alt", newJString(alt))
  add(query_588955, "oauth_token", newJString(oauthToken))
  add(query_588955, "callback", newJString(callback))
  add(query_588955, "access_token", newJString(accessToken))
  add(query_588955, "uploadType", newJString(uploadType))
  add(query_588955, "key", newJString(key))
  add(query_588955, "name", newJString(name))
  add(query_588955, "$.xgafv", newJString(Xgafv))
  add(query_588955, "pageSize", newJInt(pageSize))
  add(query_588955, "prettyPrint", newJBool(prettyPrint))
  add(query_588955, "filter", newJString(filter))
  result = call_588954.call(nil, query_588955, nil, nil, nil)

var servicemanagementOperationsList* = Call_ServicemanagementOperationsList_588719(
    name: "servicemanagementOperationsList", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com", route: "/v1/operations",
    validator: validate_ServicemanagementOperationsList_588720, base: "/",
    url: url_ServicemanagementOperationsList_588721, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesCreate_589016 = ref object of OpenApiRestCall_588450
proc url_ServicemanagementServicesCreate_589018(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ServicemanagementServicesCreate_589017(path: JsonNode;
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
  var valid_589019 = query.getOrDefault("upload_protocol")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "upload_protocol", valid_589019
  var valid_589020 = query.getOrDefault("fields")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "fields", valid_589020
  var valid_589021 = query.getOrDefault("quotaUser")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "quotaUser", valid_589021
  var valid_589022 = query.getOrDefault("alt")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = newJString("json"))
  if valid_589022 != nil:
    section.add "alt", valid_589022
  var valid_589023 = query.getOrDefault("oauth_token")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "oauth_token", valid_589023
  var valid_589024 = query.getOrDefault("callback")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "callback", valid_589024
  var valid_589025 = query.getOrDefault("access_token")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "access_token", valid_589025
  var valid_589026 = query.getOrDefault("uploadType")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "uploadType", valid_589026
  var valid_589027 = query.getOrDefault("key")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "key", valid_589027
  var valid_589028 = query.getOrDefault("$.xgafv")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = newJString("1"))
  if valid_589028 != nil:
    section.add "$.xgafv", valid_589028
  var valid_589029 = query.getOrDefault("prettyPrint")
  valid_589029 = validateParameter(valid_589029, JBool, required = false,
                                 default = newJBool(true))
  if valid_589029 != nil:
    section.add "prettyPrint", valid_589029
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

proc call*(call_589031: Call_ServicemanagementServicesCreate_589016;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new managed service.
  ## Please note one producer project can own no more than 20 services.
  ## 
  ## Operation<response: ManagedService>
  ## 
  let valid = call_589031.validator(path, query, header, formData, body)
  let scheme = call_589031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589031.url(scheme.get, call_589031.host, call_589031.base,
                         call_589031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589031, url, valid)

proc call*(call_589032: Call_ServicemanagementServicesCreate_589016;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## servicemanagementServicesCreate
  ## Creates a new managed service.
  ## Please note one producer project can own no more than 20 services.
  ## 
  ## Operation<response: ManagedService>
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
  var query_589033 = newJObject()
  var body_589034 = newJObject()
  add(query_589033, "upload_protocol", newJString(uploadProtocol))
  add(query_589033, "fields", newJString(fields))
  add(query_589033, "quotaUser", newJString(quotaUser))
  add(query_589033, "alt", newJString(alt))
  add(query_589033, "oauth_token", newJString(oauthToken))
  add(query_589033, "callback", newJString(callback))
  add(query_589033, "access_token", newJString(accessToken))
  add(query_589033, "uploadType", newJString(uploadType))
  add(query_589033, "key", newJString(key))
  add(query_589033, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589034 = body
  add(query_589033, "prettyPrint", newJBool(prettyPrint))
  result = call_589032.call(nil, query_589033, nil, nil, body_589034)

var servicemanagementServicesCreate* = Call_ServicemanagementServicesCreate_589016(
    name: "servicemanagementServicesCreate", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com", route: "/v1/services",
    validator: validate_ServicemanagementServicesCreate_589017, base: "/",
    url: url_ServicemanagementServicesCreate_589018, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesList_588995 = ref object of OpenApiRestCall_588450
proc url_ServicemanagementServicesList_588997(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ServicemanagementServicesList_588996(path: JsonNode; query: JsonNode;
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
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token identifying which result to start with; returned by a previous list
  ## call.
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
  ##   consumerId: JString
  ##             : Include services consumed by the specified consumer.
  ## 
  ## The Google Service Management implementation accepts the following
  ## forms:
  ## - project:<project_id>
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   producerProjectId: JString
  ##                    : Include services produced by the specified project.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The max number of items to include in the response list. Page size is 50
  ## if not specified. Maximum value is 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588998 = query.getOrDefault("upload_protocol")
  valid_588998 = validateParameter(valid_588998, JString, required = false,
                                 default = nil)
  if valid_588998 != nil:
    section.add "upload_protocol", valid_588998
  var valid_588999 = query.getOrDefault("fields")
  valid_588999 = validateParameter(valid_588999, JString, required = false,
                                 default = nil)
  if valid_588999 != nil:
    section.add "fields", valid_588999
  var valid_589000 = query.getOrDefault("pageToken")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = nil)
  if valid_589000 != nil:
    section.add "pageToken", valid_589000
  var valid_589001 = query.getOrDefault("quotaUser")
  valid_589001 = validateParameter(valid_589001, JString, required = false,
                                 default = nil)
  if valid_589001 != nil:
    section.add "quotaUser", valid_589001
  var valid_589002 = query.getOrDefault("alt")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = newJString("json"))
  if valid_589002 != nil:
    section.add "alt", valid_589002
  var valid_589003 = query.getOrDefault("oauth_token")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "oauth_token", valid_589003
  var valid_589004 = query.getOrDefault("callback")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "callback", valid_589004
  var valid_589005 = query.getOrDefault("access_token")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "access_token", valid_589005
  var valid_589006 = query.getOrDefault("uploadType")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "uploadType", valid_589006
  var valid_589007 = query.getOrDefault("consumerId")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "consumerId", valid_589007
  var valid_589008 = query.getOrDefault("key")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "key", valid_589008
  var valid_589009 = query.getOrDefault("producerProjectId")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "producerProjectId", valid_589009
  var valid_589010 = query.getOrDefault("$.xgafv")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = newJString("1"))
  if valid_589010 != nil:
    section.add "$.xgafv", valid_589010
  var valid_589011 = query.getOrDefault("pageSize")
  valid_589011 = validateParameter(valid_589011, JInt, required = false, default = nil)
  if valid_589011 != nil:
    section.add "pageSize", valid_589011
  var valid_589012 = query.getOrDefault("prettyPrint")
  valid_589012 = validateParameter(valid_589012, JBool, required = false,
                                 default = newJBool(true))
  if valid_589012 != nil:
    section.add "prettyPrint", valid_589012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589013: Call_ServicemanagementServicesList_588995; path: JsonNode;
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
  let valid = call_589013.validator(path, query, header, formData, body)
  let scheme = call_589013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589013.url(scheme.get, call_589013.host, call_589013.base,
                         call_589013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589013, url, valid)

proc call*(call_589014: Call_ServicemanagementServicesList_588995;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          consumerId: string = ""; key: string = ""; producerProjectId: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token identifying which result to start with; returned by a previous list
  ## call.
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
  ##   consumerId: string
  ##             : Include services consumed by the specified consumer.
  ## 
  ## The Google Service Management implementation accepts the following
  ## forms:
  ## - project:<project_id>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   producerProjectId: string
  ##                    : Include services produced by the specified project.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The max number of items to include in the response list. Page size is 50
  ## if not specified. Maximum value is 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589015 = newJObject()
  add(query_589015, "upload_protocol", newJString(uploadProtocol))
  add(query_589015, "fields", newJString(fields))
  add(query_589015, "pageToken", newJString(pageToken))
  add(query_589015, "quotaUser", newJString(quotaUser))
  add(query_589015, "alt", newJString(alt))
  add(query_589015, "oauth_token", newJString(oauthToken))
  add(query_589015, "callback", newJString(callback))
  add(query_589015, "access_token", newJString(accessToken))
  add(query_589015, "uploadType", newJString(uploadType))
  add(query_589015, "consumerId", newJString(consumerId))
  add(query_589015, "key", newJString(key))
  add(query_589015, "producerProjectId", newJString(producerProjectId))
  add(query_589015, "$.xgafv", newJString(Xgafv))
  add(query_589015, "pageSize", newJInt(pageSize))
  add(query_589015, "prettyPrint", newJBool(prettyPrint))
  result = call_589014.call(nil, query_589015, nil, nil, nil)

var servicemanagementServicesList* = Call_ServicemanagementServicesList_588995(
    name: "servicemanagementServicesList", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com", route: "/v1/services",
    validator: validate_ServicemanagementServicesList_588996, base: "/",
    url: url_ServicemanagementServicesList_588997, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesGet_589035 = ref object of OpenApiRestCall_588450
proc url_ServicemanagementServicesGet_589037(protocol: Scheme; host: string;
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

proc validate_ServicemanagementServicesGet_589036(path: JsonNode; query: JsonNode;
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
  var valid_589052 = path.getOrDefault("serviceName")
  valid_589052 = validateParameter(valid_589052, JString, required = true,
                                 default = nil)
  if valid_589052 != nil:
    section.add "serviceName", valid_589052
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
  var valid_589053 = query.getOrDefault("upload_protocol")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "upload_protocol", valid_589053
  var valid_589054 = query.getOrDefault("fields")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "fields", valid_589054
  var valid_589055 = query.getOrDefault("quotaUser")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "quotaUser", valid_589055
  var valid_589056 = query.getOrDefault("alt")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = newJString("json"))
  if valid_589056 != nil:
    section.add "alt", valid_589056
  var valid_589057 = query.getOrDefault("oauth_token")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "oauth_token", valid_589057
  var valid_589058 = query.getOrDefault("callback")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "callback", valid_589058
  var valid_589059 = query.getOrDefault("access_token")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "access_token", valid_589059
  var valid_589060 = query.getOrDefault("uploadType")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "uploadType", valid_589060
  var valid_589061 = query.getOrDefault("key")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "key", valid_589061
  var valid_589062 = query.getOrDefault("$.xgafv")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = newJString("1"))
  if valid_589062 != nil:
    section.add "$.xgafv", valid_589062
  var valid_589063 = query.getOrDefault("prettyPrint")
  valid_589063 = validateParameter(valid_589063, JBool, required = false,
                                 default = newJBool(true))
  if valid_589063 != nil:
    section.add "prettyPrint", valid_589063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589064: Call_ServicemanagementServicesGet_589035; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a managed service. Authentication is required unless the service is
  ## public.
  ## 
  let valid = call_589064.validator(path, query, header, formData, body)
  let scheme = call_589064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589064.url(scheme.get, call_589064.host, call_589064.base,
                         call_589064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589064, url, valid)

proc call*(call_589065: Call_ServicemanagementServicesGet_589035;
          serviceName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## servicemanagementServicesGet
  ## Gets a managed service. Authentication is required unless the service is
  ## public.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   serviceName: string (required)
  ##              : The name of the service.  See the `ServiceManager` overview for naming
  ## requirements.  For example: `example.googleapis.com`.
  var path_589066 = newJObject()
  var query_589067 = newJObject()
  add(query_589067, "upload_protocol", newJString(uploadProtocol))
  add(query_589067, "fields", newJString(fields))
  add(query_589067, "quotaUser", newJString(quotaUser))
  add(query_589067, "alt", newJString(alt))
  add(query_589067, "oauth_token", newJString(oauthToken))
  add(query_589067, "callback", newJString(callback))
  add(query_589067, "access_token", newJString(accessToken))
  add(query_589067, "uploadType", newJString(uploadType))
  add(query_589067, "key", newJString(key))
  add(query_589067, "$.xgafv", newJString(Xgafv))
  add(query_589067, "prettyPrint", newJBool(prettyPrint))
  add(path_589066, "serviceName", newJString(serviceName))
  result = call_589065.call(path_589066, query_589067, nil, nil, nil)

var servicemanagementServicesGet* = Call_ServicemanagementServicesGet_589035(
    name: "servicemanagementServicesGet", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com", route: "/v1/services/{serviceName}",
    validator: validate_ServicemanagementServicesGet_589036, base: "/",
    url: url_ServicemanagementServicesGet_589037, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesDelete_589068 = ref object of OpenApiRestCall_588450
proc url_ServicemanagementServicesDelete_589070(protocol: Scheme; host: string;
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

proc validate_ServicemanagementServicesDelete_589069(path: JsonNode;
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
  var valid_589071 = path.getOrDefault("serviceName")
  valid_589071 = validateParameter(valid_589071, JString, required = true,
                                 default = nil)
  if valid_589071 != nil:
    section.add "serviceName", valid_589071
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
  var valid_589072 = query.getOrDefault("upload_protocol")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "upload_protocol", valid_589072
  var valid_589073 = query.getOrDefault("fields")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "fields", valid_589073
  var valid_589074 = query.getOrDefault("quotaUser")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "quotaUser", valid_589074
  var valid_589075 = query.getOrDefault("alt")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = newJString("json"))
  if valid_589075 != nil:
    section.add "alt", valid_589075
  var valid_589076 = query.getOrDefault("oauth_token")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "oauth_token", valid_589076
  var valid_589077 = query.getOrDefault("callback")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "callback", valid_589077
  var valid_589078 = query.getOrDefault("access_token")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "access_token", valid_589078
  var valid_589079 = query.getOrDefault("uploadType")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "uploadType", valid_589079
  var valid_589080 = query.getOrDefault("key")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "key", valid_589080
  var valid_589081 = query.getOrDefault("$.xgafv")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = newJString("1"))
  if valid_589081 != nil:
    section.add "$.xgafv", valid_589081
  var valid_589082 = query.getOrDefault("prettyPrint")
  valid_589082 = validateParameter(valid_589082, JBool, required = false,
                                 default = newJBool(true))
  if valid_589082 != nil:
    section.add "prettyPrint", valid_589082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589083: Call_ServicemanagementServicesDelete_589068;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a managed service. This method will change the service to the
  ## `Soft-Delete` state for 30 days. Within this period, service producers may
  ## call UndeleteService to restore the service.
  ## After 30 days, the service will be permanently deleted.
  ## 
  ## Operation<response: google.protobuf.Empty>
  ## 
  let valid = call_589083.validator(path, query, header, formData, body)
  let scheme = call_589083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589083.url(scheme.get, call_589083.host, call_589083.base,
                         call_589083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589083, url, valid)

proc call*(call_589084: Call_ServicemanagementServicesDelete_589068;
          serviceName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## servicemanagementServicesDelete
  ## Deletes a managed service. This method will change the service to the
  ## `Soft-Delete` state for 30 days. Within this period, service producers may
  ## call UndeleteService to restore the service.
  ## After 30 days, the service will be permanently deleted.
  ## 
  ## Operation<response: google.protobuf.Empty>
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   serviceName: string (required)
  ##              : The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  var path_589085 = newJObject()
  var query_589086 = newJObject()
  add(query_589086, "upload_protocol", newJString(uploadProtocol))
  add(query_589086, "fields", newJString(fields))
  add(query_589086, "quotaUser", newJString(quotaUser))
  add(query_589086, "alt", newJString(alt))
  add(query_589086, "oauth_token", newJString(oauthToken))
  add(query_589086, "callback", newJString(callback))
  add(query_589086, "access_token", newJString(accessToken))
  add(query_589086, "uploadType", newJString(uploadType))
  add(query_589086, "key", newJString(key))
  add(query_589086, "$.xgafv", newJString(Xgafv))
  add(query_589086, "prettyPrint", newJBool(prettyPrint))
  add(path_589085, "serviceName", newJString(serviceName))
  result = call_589084.call(path_589085, query_589086, nil, nil, nil)

var servicemanagementServicesDelete* = Call_ServicemanagementServicesDelete_589068(
    name: "servicemanagementServicesDelete", meth: HttpMethod.HttpDelete,
    host: "servicemanagement.googleapis.com", route: "/v1/services/{serviceName}",
    validator: validate_ServicemanagementServicesDelete_589069, base: "/",
    url: url_ServicemanagementServicesDelete_589070, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesGetConfig_589087 = ref object of OpenApiRestCall_588450
proc url_ServicemanagementServicesGetConfig_589089(protocol: Scheme; host: string;
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

proc validate_ServicemanagementServicesGetConfig_589088(path: JsonNode;
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
  var valid_589090 = path.getOrDefault("serviceName")
  valid_589090 = validateParameter(valid_589090, JString, required = true,
                                 default = nil)
  if valid_589090 != nil:
    section.add "serviceName", valid_589090
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: JString
  ##       : Specifies which parts of the Service Config should be returned in the
  ## response.
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
  ##   configId: JString
  ##           : The id of the service configuration resource.
  ## 
  ## This field must be specified for the server to return all fields, including
  ## `SourceInfo`.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589091 = query.getOrDefault("upload_protocol")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "upload_protocol", valid_589091
  var valid_589092 = query.getOrDefault("fields")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "fields", valid_589092
  var valid_589093 = query.getOrDefault("view")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_589093 != nil:
    section.add "view", valid_589093
  var valid_589094 = query.getOrDefault("quotaUser")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "quotaUser", valid_589094
  var valid_589095 = query.getOrDefault("alt")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = newJString("json"))
  if valid_589095 != nil:
    section.add "alt", valid_589095
  var valid_589096 = query.getOrDefault("oauth_token")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "oauth_token", valid_589096
  var valid_589097 = query.getOrDefault("callback")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "callback", valid_589097
  var valid_589098 = query.getOrDefault("access_token")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "access_token", valid_589098
  var valid_589099 = query.getOrDefault("uploadType")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "uploadType", valid_589099
  var valid_589100 = query.getOrDefault("configId")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "configId", valid_589100
  var valid_589101 = query.getOrDefault("key")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "key", valid_589101
  var valid_589102 = query.getOrDefault("$.xgafv")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = newJString("1"))
  if valid_589102 != nil:
    section.add "$.xgafv", valid_589102
  var valid_589103 = query.getOrDefault("prettyPrint")
  valid_589103 = validateParameter(valid_589103, JBool, required = false,
                                 default = newJBool(true))
  if valid_589103 != nil:
    section.add "prettyPrint", valid_589103
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589104: Call_ServicemanagementServicesGetConfig_589087;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a service configuration (version) for a managed service.
  ## 
  let valid = call_589104.validator(path, query, header, formData, body)
  let scheme = call_589104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589104.url(scheme.get, call_589104.host, call_589104.base,
                         call_589104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589104, url, valid)

proc call*(call_589105: Call_ServicemanagementServicesGetConfig_589087;
          serviceName: string; uploadProtocol: string = ""; fields: string = "";
          view: string = "BASIC"; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; configId: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## servicemanagementServicesGetConfig
  ## Gets a service configuration (version) for a managed service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : Specifies which parts of the Service Config should be returned in the
  ## response.
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
  ##   configId: string
  ##           : The id of the service configuration resource.
  ## 
  ## This field must be specified for the server to return all fields, including
  ## `SourceInfo`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   serviceName: string (required)
  ##              : The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  var path_589106 = newJObject()
  var query_589107 = newJObject()
  add(query_589107, "upload_protocol", newJString(uploadProtocol))
  add(query_589107, "fields", newJString(fields))
  add(query_589107, "view", newJString(view))
  add(query_589107, "quotaUser", newJString(quotaUser))
  add(query_589107, "alt", newJString(alt))
  add(query_589107, "oauth_token", newJString(oauthToken))
  add(query_589107, "callback", newJString(callback))
  add(query_589107, "access_token", newJString(accessToken))
  add(query_589107, "uploadType", newJString(uploadType))
  add(query_589107, "configId", newJString(configId))
  add(query_589107, "key", newJString(key))
  add(query_589107, "$.xgafv", newJString(Xgafv))
  add(query_589107, "prettyPrint", newJBool(prettyPrint))
  add(path_589106, "serviceName", newJString(serviceName))
  result = call_589105.call(path_589106, query_589107, nil, nil, nil)

var servicemanagementServicesGetConfig* = Call_ServicemanagementServicesGetConfig_589087(
    name: "servicemanagementServicesGetConfig", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/config",
    validator: validate_ServicemanagementServicesGetConfig_589088, base: "/",
    url: url_ServicemanagementServicesGetConfig_589089, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConfigsCreate_589129 = ref object of OpenApiRestCall_588450
proc url_ServicemanagementServicesConfigsCreate_589131(protocol: Scheme;
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

proc validate_ServicemanagementServicesConfigsCreate_589130(path: JsonNode;
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
  var valid_589132 = path.getOrDefault("serviceName")
  valid_589132 = validateParameter(valid_589132, JString, required = true,
                                 default = nil)
  if valid_589132 != nil:
    section.add "serviceName", valid_589132
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
  var valid_589133 = query.getOrDefault("upload_protocol")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "upload_protocol", valid_589133
  var valid_589134 = query.getOrDefault("fields")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "fields", valid_589134
  var valid_589135 = query.getOrDefault("quotaUser")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "quotaUser", valid_589135
  var valid_589136 = query.getOrDefault("alt")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = newJString("json"))
  if valid_589136 != nil:
    section.add "alt", valid_589136
  var valid_589137 = query.getOrDefault("oauth_token")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "oauth_token", valid_589137
  var valid_589138 = query.getOrDefault("callback")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "callback", valid_589138
  var valid_589139 = query.getOrDefault("access_token")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "access_token", valid_589139
  var valid_589140 = query.getOrDefault("uploadType")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "uploadType", valid_589140
  var valid_589141 = query.getOrDefault("key")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "key", valid_589141
  var valid_589142 = query.getOrDefault("$.xgafv")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = newJString("1"))
  if valid_589142 != nil:
    section.add "$.xgafv", valid_589142
  var valid_589143 = query.getOrDefault("prettyPrint")
  valid_589143 = validateParameter(valid_589143, JBool, required = false,
                                 default = newJBool(true))
  if valid_589143 != nil:
    section.add "prettyPrint", valid_589143
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

proc call*(call_589145: Call_ServicemanagementServicesConfigsCreate_589129;
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
  let valid = call_589145.validator(path, query, header, formData, body)
  let scheme = call_589145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589145.url(scheme.get, call_589145.host, call_589145.base,
                         call_589145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589145, url, valid)

proc call*(call_589146: Call_ServicemanagementServicesConfigsCreate_589129;
          serviceName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## servicemanagementServicesConfigsCreate
  ## Creates a new service configuration (version) for a managed service.
  ## This method only stores the service configuration. To roll out the service
  ## configuration to backend systems please call
  ## CreateServiceRollout.
  ## 
  ## Only the 100 most recent service configurations and ones referenced by
  ## existing rollouts are kept for each service. The rest will be deleted
  ## eventually.
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
  ##   serviceName: string (required)
  ##              : The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  var path_589147 = newJObject()
  var query_589148 = newJObject()
  var body_589149 = newJObject()
  add(query_589148, "upload_protocol", newJString(uploadProtocol))
  add(query_589148, "fields", newJString(fields))
  add(query_589148, "quotaUser", newJString(quotaUser))
  add(query_589148, "alt", newJString(alt))
  add(query_589148, "oauth_token", newJString(oauthToken))
  add(query_589148, "callback", newJString(callback))
  add(query_589148, "access_token", newJString(accessToken))
  add(query_589148, "uploadType", newJString(uploadType))
  add(query_589148, "key", newJString(key))
  add(query_589148, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589149 = body
  add(query_589148, "prettyPrint", newJBool(prettyPrint))
  add(path_589147, "serviceName", newJString(serviceName))
  result = call_589146.call(path_589147, query_589148, nil, nil, body_589149)

var servicemanagementServicesConfigsCreate* = Call_ServicemanagementServicesConfigsCreate_589129(
    name: "servicemanagementServicesConfigsCreate", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/configs",
    validator: validate_ServicemanagementServicesConfigsCreate_589130, base: "/",
    url: url_ServicemanagementServicesConfigsCreate_589131,
    schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConfigsList_589108 = ref object of OpenApiRestCall_588450
proc url_ServicemanagementServicesConfigsList_589110(protocol: Scheme;
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

proc validate_ServicemanagementServicesConfigsList_589109(path: JsonNode;
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
  var valid_589111 = path.getOrDefault("serviceName")
  valid_589111 = validateParameter(valid_589111, JString, required = true,
                                 default = nil)
  if valid_589111 != nil:
    section.add "serviceName", valid_589111
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token of the page to retrieve.
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
  ##           : The max number of items to include in the response list. Page size is 50
  ## if not specified. Maximum value is 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589112 = query.getOrDefault("upload_protocol")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "upload_protocol", valid_589112
  var valid_589113 = query.getOrDefault("fields")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "fields", valid_589113
  var valid_589114 = query.getOrDefault("pageToken")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "pageToken", valid_589114
  var valid_589115 = query.getOrDefault("quotaUser")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "quotaUser", valid_589115
  var valid_589116 = query.getOrDefault("alt")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = newJString("json"))
  if valid_589116 != nil:
    section.add "alt", valid_589116
  var valid_589117 = query.getOrDefault("oauth_token")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "oauth_token", valid_589117
  var valid_589118 = query.getOrDefault("callback")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "callback", valid_589118
  var valid_589119 = query.getOrDefault("access_token")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "access_token", valid_589119
  var valid_589120 = query.getOrDefault("uploadType")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "uploadType", valid_589120
  var valid_589121 = query.getOrDefault("key")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "key", valid_589121
  var valid_589122 = query.getOrDefault("$.xgafv")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = newJString("1"))
  if valid_589122 != nil:
    section.add "$.xgafv", valid_589122
  var valid_589123 = query.getOrDefault("pageSize")
  valid_589123 = validateParameter(valid_589123, JInt, required = false, default = nil)
  if valid_589123 != nil:
    section.add "pageSize", valid_589123
  var valid_589124 = query.getOrDefault("prettyPrint")
  valid_589124 = validateParameter(valid_589124, JBool, required = false,
                                 default = newJBool(true))
  if valid_589124 != nil:
    section.add "prettyPrint", valid_589124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589125: Call_ServicemanagementServicesConfigsList_589108;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the history of the service configuration for a managed service,
  ## from the newest to the oldest.
  ## 
  let valid = call_589125.validator(path, query, header, formData, body)
  let scheme = call_589125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589125.url(scheme.get, call_589125.host, call_589125.base,
                         call_589125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589125, url, valid)

proc call*(call_589126: Call_ServicemanagementServicesConfigsList_589108;
          serviceName: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## servicemanagementServicesConfigsList
  ## Lists the history of the service configuration for a managed service,
  ## from the newest to the oldest.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token of the page to retrieve.
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
  ##   pageSize: int
  ##           : The max number of items to include in the response list. Page size is 50
  ## if not specified. Maximum value is 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   serviceName: string (required)
  ##              : The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  var path_589127 = newJObject()
  var query_589128 = newJObject()
  add(query_589128, "upload_protocol", newJString(uploadProtocol))
  add(query_589128, "fields", newJString(fields))
  add(query_589128, "pageToken", newJString(pageToken))
  add(query_589128, "quotaUser", newJString(quotaUser))
  add(query_589128, "alt", newJString(alt))
  add(query_589128, "oauth_token", newJString(oauthToken))
  add(query_589128, "callback", newJString(callback))
  add(query_589128, "access_token", newJString(accessToken))
  add(query_589128, "uploadType", newJString(uploadType))
  add(query_589128, "key", newJString(key))
  add(query_589128, "$.xgafv", newJString(Xgafv))
  add(query_589128, "pageSize", newJInt(pageSize))
  add(query_589128, "prettyPrint", newJBool(prettyPrint))
  add(path_589127, "serviceName", newJString(serviceName))
  result = call_589126.call(path_589127, query_589128, nil, nil, nil)

var servicemanagementServicesConfigsList* = Call_ServicemanagementServicesConfigsList_589108(
    name: "servicemanagementServicesConfigsList", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/configs",
    validator: validate_ServicemanagementServicesConfigsList_589109, base: "/",
    url: url_ServicemanagementServicesConfigsList_589110, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConfigsGet_589150 = ref object of OpenApiRestCall_588450
proc url_ServicemanagementServicesConfigsGet_589152(protocol: Scheme; host: string;
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

proc validate_ServicemanagementServicesConfigsGet_589151(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a service configuration (version) for a managed service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   configId: JString (required)
  ##           : The id of the service configuration resource.
  ## 
  ## This field must be specified for the server to return all fields, including
  ## `SourceInfo`.
  ##   serviceName: JString (required)
  ##              : The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `configId` field"
  var valid_589153 = path.getOrDefault("configId")
  valid_589153 = validateParameter(valid_589153, JString, required = true,
                                 default = nil)
  if valid_589153 != nil:
    section.add "configId", valid_589153
  var valid_589154 = path.getOrDefault("serviceName")
  valid_589154 = validateParameter(valid_589154, JString, required = true,
                                 default = nil)
  if valid_589154 != nil:
    section.add "serviceName", valid_589154
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: JString
  ##       : Specifies which parts of the Service Config should be returned in the
  ## response.
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
  var valid_589155 = query.getOrDefault("upload_protocol")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "upload_protocol", valid_589155
  var valid_589156 = query.getOrDefault("fields")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "fields", valid_589156
  var valid_589157 = query.getOrDefault("view")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_589157 != nil:
    section.add "view", valid_589157
  var valid_589158 = query.getOrDefault("quotaUser")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "quotaUser", valid_589158
  var valid_589159 = query.getOrDefault("alt")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = newJString("json"))
  if valid_589159 != nil:
    section.add "alt", valid_589159
  var valid_589160 = query.getOrDefault("oauth_token")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "oauth_token", valid_589160
  var valid_589161 = query.getOrDefault("callback")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "callback", valid_589161
  var valid_589162 = query.getOrDefault("access_token")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "access_token", valid_589162
  var valid_589163 = query.getOrDefault("uploadType")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "uploadType", valid_589163
  var valid_589164 = query.getOrDefault("key")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "key", valid_589164
  var valid_589165 = query.getOrDefault("$.xgafv")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = newJString("1"))
  if valid_589165 != nil:
    section.add "$.xgafv", valid_589165
  var valid_589166 = query.getOrDefault("prettyPrint")
  valid_589166 = validateParameter(valid_589166, JBool, required = false,
                                 default = newJBool(true))
  if valid_589166 != nil:
    section.add "prettyPrint", valid_589166
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589167: Call_ServicemanagementServicesConfigsGet_589150;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a service configuration (version) for a managed service.
  ## 
  let valid = call_589167.validator(path, query, header, formData, body)
  let scheme = call_589167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589167.url(scheme.get, call_589167.host, call_589167.base,
                         call_589167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589167, url, valid)

proc call*(call_589168: Call_ServicemanagementServicesConfigsGet_589150;
          configId: string; serviceName: string; uploadProtocol: string = "";
          fields: string = ""; view: string = "BASIC"; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## servicemanagementServicesConfigsGet
  ## Gets a service configuration (version) for a managed service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : Specifies which parts of the Service Config should be returned in the
  ## response.
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
  ##   configId: string (required)
  ##           : The id of the service configuration resource.
  ## 
  ## This field must be specified for the server to return all fields, including
  ## `SourceInfo`.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   serviceName: string (required)
  ##              : The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  var path_589169 = newJObject()
  var query_589170 = newJObject()
  add(query_589170, "upload_protocol", newJString(uploadProtocol))
  add(query_589170, "fields", newJString(fields))
  add(query_589170, "view", newJString(view))
  add(query_589170, "quotaUser", newJString(quotaUser))
  add(query_589170, "alt", newJString(alt))
  add(query_589170, "oauth_token", newJString(oauthToken))
  add(query_589170, "callback", newJString(callback))
  add(query_589170, "access_token", newJString(accessToken))
  add(query_589170, "uploadType", newJString(uploadType))
  add(query_589170, "key", newJString(key))
  add(path_589169, "configId", newJString(configId))
  add(query_589170, "$.xgafv", newJString(Xgafv))
  add(query_589170, "prettyPrint", newJBool(prettyPrint))
  add(path_589169, "serviceName", newJString(serviceName))
  result = call_589168.call(path_589169, query_589170, nil, nil, nil)

var servicemanagementServicesConfigsGet* = Call_ServicemanagementServicesConfigsGet_589150(
    name: "servicemanagementServicesConfigsGet", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/configs/{configId}",
    validator: validate_ServicemanagementServicesConfigsGet_589151, base: "/",
    url: url_ServicemanagementServicesConfigsGet_589152, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConfigsSubmit_589171 = ref object of OpenApiRestCall_588450
proc url_ServicemanagementServicesConfigsSubmit_589173(protocol: Scheme;
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

proc validate_ServicemanagementServicesConfigsSubmit_589172(path: JsonNode;
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
  var valid_589174 = path.getOrDefault("serviceName")
  valid_589174 = validateParameter(valid_589174, JString, required = true,
                                 default = nil)
  if valid_589174 != nil:
    section.add "serviceName", valid_589174
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
  var valid_589175 = query.getOrDefault("upload_protocol")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "upload_protocol", valid_589175
  var valid_589176 = query.getOrDefault("fields")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "fields", valid_589176
  var valid_589177 = query.getOrDefault("quotaUser")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "quotaUser", valid_589177
  var valid_589178 = query.getOrDefault("alt")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = newJString("json"))
  if valid_589178 != nil:
    section.add "alt", valid_589178
  var valid_589179 = query.getOrDefault("oauth_token")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "oauth_token", valid_589179
  var valid_589180 = query.getOrDefault("callback")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "callback", valid_589180
  var valid_589181 = query.getOrDefault("access_token")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "access_token", valid_589181
  var valid_589182 = query.getOrDefault("uploadType")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "uploadType", valid_589182
  var valid_589183 = query.getOrDefault("key")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "key", valid_589183
  var valid_589184 = query.getOrDefault("$.xgafv")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = newJString("1"))
  if valid_589184 != nil:
    section.add "$.xgafv", valid_589184
  var valid_589185 = query.getOrDefault("prettyPrint")
  valid_589185 = validateParameter(valid_589185, JBool, required = false,
                                 default = newJBool(true))
  if valid_589185 != nil:
    section.add "prettyPrint", valid_589185
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

proc call*(call_589187: Call_ServicemanagementServicesConfigsSubmit_589171;
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
  let valid = call_589187.validator(path, query, header, formData, body)
  let scheme = call_589187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589187.url(scheme.get, call_589187.host, call_589187.base,
                         call_589187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589187, url, valid)

proc call*(call_589188: Call_ServicemanagementServicesConfigsSubmit_589171;
          serviceName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   serviceName: string (required)
  ##              : The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  var path_589189 = newJObject()
  var query_589190 = newJObject()
  var body_589191 = newJObject()
  add(query_589190, "upload_protocol", newJString(uploadProtocol))
  add(query_589190, "fields", newJString(fields))
  add(query_589190, "quotaUser", newJString(quotaUser))
  add(query_589190, "alt", newJString(alt))
  add(query_589190, "oauth_token", newJString(oauthToken))
  add(query_589190, "callback", newJString(callback))
  add(query_589190, "access_token", newJString(accessToken))
  add(query_589190, "uploadType", newJString(uploadType))
  add(query_589190, "key", newJString(key))
  add(query_589190, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589191 = body
  add(query_589190, "prettyPrint", newJBool(prettyPrint))
  add(path_589189, "serviceName", newJString(serviceName))
  result = call_589188.call(path_589189, query_589190, nil, nil, body_589191)

var servicemanagementServicesConfigsSubmit* = Call_ServicemanagementServicesConfigsSubmit_589171(
    name: "servicemanagementServicesConfigsSubmit", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/configs:submit",
    validator: validate_ServicemanagementServicesConfigsSubmit_589172, base: "/",
    url: url_ServicemanagementServicesConfigsSubmit_589173,
    schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesRolloutsCreate_589214 = ref object of OpenApiRestCall_588450
proc url_ServicemanagementServicesRolloutsCreate_589216(protocol: Scheme;
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

proc validate_ServicemanagementServicesRolloutsCreate_589215(path: JsonNode;
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
  var valid_589217 = path.getOrDefault("serviceName")
  valid_589217 = validateParameter(valid_589217, JString, required = true,
                                 default = nil)
  if valid_589217 != nil:
    section.add "serviceName", valid_589217
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
  ##   baseRolloutId: JString
  ##                : Unimplemented. Do not use this feature until this comment is removed.
  ## 
  ## The rollout id that rollout to be created based on.
  ## 
  ## Rollout should be constructed based on current successful rollout, this
  ## field indicates the current successful rollout id that new rollout based on
  ## to construct, if current successful rollout changed when server receives
  ## the request, request will be rejected for safety.
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
  var valid_589218 = query.getOrDefault("upload_protocol")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "upload_protocol", valid_589218
  var valid_589219 = query.getOrDefault("fields")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "fields", valid_589219
  var valid_589220 = query.getOrDefault("quotaUser")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "quotaUser", valid_589220
  var valid_589221 = query.getOrDefault("alt")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = newJString("json"))
  if valid_589221 != nil:
    section.add "alt", valid_589221
  var valid_589222 = query.getOrDefault("baseRolloutId")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "baseRolloutId", valid_589222
  var valid_589223 = query.getOrDefault("oauth_token")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "oauth_token", valid_589223
  var valid_589224 = query.getOrDefault("callback")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "callback", valid_589224
  var valid_589225 = query.getOrDefault("access_token")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "access_token", valid_589225
  var valid_589226 = query.getOrDefault("uploadType")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "uploadType", valid_589226
  var valid_589227 = query.getOrDefault("key")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "key", valid_589227
  var valid_589228 = query.getOrDefault("$.xgafv")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = newJString("1"))
  if valid_589228 != nil:
    section.add "$.xgafv", valid_589228
  var valid_589229 = query.getOrDefault("prettyPrint")
  valid_589229 = validateParameter(valid_589229, JBool, required = false,
                                 default = newJBool(true))
  if valid_589229 != nil:
    section.add "prettyPrint", valid_589229
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

proc call*(call_589231: Call_ServicemanagementServicesRolloutsCreate_589214;
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
  let valid = call_589231.validator(path, query, header, formData, body)
  let scheme = call_589231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589231.url(scheme.get, call_589231.host, call_589231.base,
                         call_589231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589231, url, valid)

proc call*(call_589232: Call_ServicemanagementServicesRolloutsCreate_589214;
          serviceName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; baseRolloutId: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   baseRolloutId: string
  ##                : Unimplemented. Do not use this feature until this comment is removed.
  ## 
  ## The rollout id that rollout to be created based on.
  ## 
  ## Rollout should be constructed based on current successful rollout, this
  ## field indicates the current successful rollout id that new rollout based on
  ## to construct, if current successful rollout changed when server receives
  ## the request, request will be rejected for safety.
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
  ##   serviceName: string (required)
  ##              : The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  var path_589233 = newJObject()
  var query_589234 = newJObject()
  var body_589235 = newJObject()
  add(query_589234, "upload_protocol", newJString(uploadProtocol))
  add(query_589234, "fields", newJString(fields))
  add(query_589234, "quotaUser", newJString(quotaUser))
  add(query_589234, "alt", newJString(alt))
  add(query_589234, "baseRolloutId", newJString(baseRolloutId))
  add(query_589234, "oauth_token", newJString(oauthToken))
  add(query_589234, "callback", newJString(callback))
  add(query_589234, "access_token", newJString(accessToken))
  add(query_589234, "uploadType", newJString(uploadType))
  add(query_589234, "key", newJString(key))
  add(query_589234, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589235 = body
  add(query_589234, "prettyPrint", newJBool(prettyPrint))
  add(path_589233, "serviceName", newJString(serviceName))
  result = call_589232.call(path_589233, query_589234, nil, nil, body_589235)

var servicemanagementServicesRolloutsCreate* = Call_ServicemanagementServicesRolloutsCreate_589214(
    name: "servicemanagementServicesRolloutsCreate", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/rollouts",
    validator: validate_ServicemanagementServicesRolloutsCreate_589215, base: "/",
    url: url_ServicemanagementServicesRolloutsCreate_589216,
    schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesRolloutsList_589192 = ref object of OpenApiRestCall_588450
proc url_ServicemanagementServicesRolloutsList_589194(protocol: Scheme;
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

proc validate_ServicemanagementServicesRolloutsList_589193(path: JsonNode;
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
  var valid_589195 = path.getOrDefault("serviceName")
  valid_589195 = validateParameter(valid_589195, JString, required = true,
                                 default = nil)
  if valid_589195 != nil:
    section.add "serviceName", valid_589195
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token of the page to retrieve.
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
  ##           : The max number of items to include in the response list. Page size is 50
  ## if not specified. Maximum value is 100.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Use `filter` to return subset of rollouts.
  ## The following filters are supported:
  ##   -- To limit the results to only those in
  ##      [status](google.api.servicemanagement.v1.RolloutStatus) 'SUCCESS',
  ##      use filter='status=SUCCESS'
  ##   -- To limit the results to those in
  ##      [status](google.api.servicemanagement.v1.RolloutStatus) 'CANCELLED'
  ##      or 'FAILED', use filter='status=CANCELLED OR status=FAILED'
  section = newJObject()
  var valid_589196 = query.getOrDefault("upload_protocol")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "upload_protocol", valid_589196
  var valid_589197 = query.getOrDefault("fields")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "fields", valid_589197
  var valid_589198 = query.getOrDefault("pageToken")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "pageToken", valid_589198
  var valid_589199 = query.getOrDefault("quotaUser")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "quotaUser", valid_589199
  var valid_589200 = query.getOrDefault("alt")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = newJString("json"))
  if valid_589200 != nil:
    section.add "alt", valid_589200
  var valid_589201 = query.getOrDefault("oauth_token")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "oauth_token", valid_589201
  var valid_589202 = query.getOrDefault("callback")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = nil)
  if valid_589202 != nil:
    section.add "callback", valid_589202
  var valid_589203 = query.getOrDefault("access_token")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "access_token", valid_589203
  var valid_589204 = query.getOrDefault("uploadType")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "uploadType", valid_589204
  var valid_589205 = query.getOrDefault("key")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = nil)
  if valid_589205 != nil:
    section.add "key", valid_589205
  var valid_589206 = query.getOrDefault("$.xgafv")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = newJString("1"))
  if valid_589206 != nil:
    section.add "$.xgafv", valid_589206
  var valid_589207 = query.getOrDefault("pageSize")
  valid_589207 = validateParameter(valid_589207, JInt, required = false, default = nil)
  if valid_589207 != nil:
    section.add "pageSize", valid_589207
  var valid_589208 = query.getOrDefault("prettyPrint")
  valid_589208 = validateParameter(valid_589208, JBool, required = false,
                                 default = newJBool(true))
  if valid_589208 != nil:
    section.add "prettyPrint", valid_589208
  var valid_589209 = query.getOrDefault("filter")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "filter", valid_589209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589210: Call_ServicemanagementServicesRolloutsList_589192;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the history of the service configuration rollouts for a managed
  ## service, from the newest to the oldest.
  ## 
  let valid = call_589210.validator(path, query, header, formData, body)
  let scheme = call_589210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589210.url(scheme.get, call_589210.host, call_589210.base,
                         call_589210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589210, url, valid)

proc call*(call_589211: Call_ServicemanagementServicesRolloutsList_589192;
          serviceName: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## servicemanagementServicesRolloutsList
  ## Lists the history of the service configuration rollouts for a managed
  ## service, from the newest to the oldest.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token of the page to retrieve.
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
  ##   pageSize: int
  ##           : The max number of items to include in the response list. Page size is 50
  ## if not specified. Maximum value is 100.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   serviceName: string (required)
  ##              : The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  ##   filter: string
  ##         : Use `filter` to return subset of rollouts.
  ## The following filters are supported:
  ##   -- To limit the results to only those in
  ##      [status](google.api.servicemanagement.v1.RolloutStatus) 'SUCCESS',
  ##      use filter='status=SUCCESS'
  ##   -- To limit the results to those in
  ##      [status](google.api.servicemanagement.v1.RolloutStatus) 'CANCELLED'
  ##      or 'FAILED', use filter='status=CANCELLED OR status=FAILED'
  var path_589212 = newJObject()
  var query_589213 = newJObject()
  add(query_589213, "upload_protocol", newJString(uploadProtocol))
  add(query_589213, "fields", newJString(fields))
  add(query_589213, "pageToken", newJString(pageToken))
  add(query_589213, "quotaUser", newJString(quotaUser))
  add(query_589213, "alt", newJString(alt))
  add(query_589213, "oauth_token", newJString(oauthToken))
  add(query_589213, "callback", newJString(callback))
  add(query_589213, "access_token", newJString(accessToken))
  add(query_589213, "uploadType", newJString(uploadType))
  add(query_589213, "key", newJString(key))
  add(query_589213, "$.xgafv", newJString(Xgafv))
  add(query_589213, "pageSize", newJInt(pageSize))
  add(query_589213, "prettyPrint", newJBool(prettyPrint))
  add(path_589212, "serviceName", newJString(serviceName))
  add(query_589213, "filter", newJString(filter))
  result = call_589211.call(path_589212, query_589213, nil, nil, nil)

var servicemanagementServicesRolloutsList* = Call_ServicemanagementServicesRolloutsList_589192(
    name: "servicemanagementServicesRolloutsList", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/rollouts",
    validator: validate_ServicemanagementServicesRolloutsList_589193, base: "/",
    url: url_ServicemanagementServicesRolloutsList_589194, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesRolloutsGet_589236 = ref object of OpenApiRestCall_588450
proc url_ServicemanagementServicesRolloutsGet_589238(protocol: Scheme;
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

proc validate_ServicemanagementServicesRolloutsGet_589237(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a service configuration rollout.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   rolloutId: JString (required)
  ##            : The id of the rollout resource.
  ##   serviceName: JString (required)
  ##              : The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `rolloutId` field"
  var valid_589239 = path.getOrDefault("rolloutId")
  valid_589239 = validateParameter(valid_589239, JString, required = true,
                                 default = nil)
  if valid_589239 != nil:
    section.add "rolloutId", valid_589239
  var valid_589240 = path.getOrDefault("serviceName")
  valid_589240 = validateParameter(valid_589240, JString, required = true,
                                 default = nil)
  if valid_589240 != nil:
    section.add "serviceName", valid_589240
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
  var valid_589241 = query.getOrDefault("upload_protocol")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "upload_protocol", valid_589241
  var valid_589242 = query.getOrDefault("fields")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "fields", valid_589242
  var valid_589243 = query.getOrDefault("quotaUser")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "quotaUser", valid_589243
  var valid_589244 = query.getOrDefault("alt")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = newJString("json"))
  if valid_589244 != nil:
    section.add "alt", valid_589244
  var valid_589245 = query.getOrDefault("oauth_token")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = nil)
  if valid_589245 != nil:
    section.add "oauth_token", valid_589245
  var valid_589246 = query.getOrDefault("callback")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = nil)
  if valid_589246 != nil:
    section.add "callback", valid_589246
  var valid_589247 = query.getOrDefault("access_token")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "access_token", valid_589247
  var valid_589248 = query.getOrDefault("uploadType")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "uploadType", valid_589248
  var valid_589249 = query.getOrDefault("key")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "key", valid_589249
  var valid_589250 = query.getOrDefault("$.xgafv")
  valid_589250 = validateParameter(valid_589250, JString, required = false,
                                 default = newJString("1"))
  if valid_589250 != nil:
    section.add "$.xgafv", valid_589250
  var valid_589251 = query.getOrDefault("prettyPrint")
  valid_589251 = validateParameter(valid_589251, JBool, required = false,
                                 default = newJBool(true))
  if valid_589251 != nil:
    section.add "prettyPrint", valid_589251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589252: Call_ServicemanagementServicesRolloutsGet_589236;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a service configuration rollout.
  ## 
  let valid = call_589252.validator(path, query, header, formData, body)
  let scheme = call_589252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589252.url(scheme.get, call_589252.host, call_589252.base,
                         call_589252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589252, url, valid)

proc call*(call_589253: Call_ServicemanagementServicesRolloutsGet_589236;
          rolloutId: string; serviceName: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## servicemanagementServicesRolloutsGet
  ## Gets a service configuration rollout.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   rolloutId: string (required)
  ##            : The id of the rollout resource.
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
  ##   serviceName: string (required)
  ##              : The name of the service.  See the [overview](/service-management/overview)
  ## for naming requirements.  For example: `example.googleapis.com`.
  var path_589254 = newJObject()
  var query_589255 = newJObject()
  add(query_589255, "upload_protocol", newJString(uploadProtocol))
  add(query_589255, "fields", newJString(fields))
  add(query_589255, "quotaUser", newJString(quotaUser))
  add(query_589255, "alt", newJString(alt))
  add(path_589254, "rolloutId", newJString(rolloutId))
  add(query_589255, "oauth_token", newJString(oauthToken))
  add(query_589255, "callback", newJString(callback))
  add(query_589255, "access_token", newJString(accessToken))
  add(query_589255, "uploadType", newJString(uploadType))
  add(query_589255, "key", newJString(key))
  add(query_589255, "$.xgafv", newJString(Xgafv))
  add(query_589255, "prettyPrint", newJBool(prettyPrint))
  add(path_589254, "serviceName", newJString(serviceName))
  result = call_589253.call(path_589254, query_589255, nil, nil, nil)

var servicemanagementServicesRolloutsGet* = Call_ServicemanagementServicesRolloutsGet_589236(
    name: "servicemanagementServicesRolloutsGet", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/rollouts/{rolloutId}",
    validator: validate_ServicemanagementServicesRolloutsGet_589237, base: "/",
    url: url_ServicemanagementServicesRolloutsGet_589238, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesDisable_589256 = ref object of OpenApiRestCall_588450
proc url_ServicemanagementServicesDisable_589258(protocol: Scheme; host: string;
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

proc validate_ServicemanagementServicesDisable_589257(path: JsonNode;
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
  var valid_589259 = path.getOrDefault("serviceName")
  valid_589259 = validateParameter(valid_589259, JString, required = true,
                                 default = nil)
  if valid_589259 != nil:
    section.add "serviceName", valid_589259
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
  var valid_589260 = query.getOrDefault("upload_protocol")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = nil)
  if valid_589260 != nil:
    section.add "upload_protocol", valid_589260
  var valid_589261 = query.getOrDefault("fields")
  valid_589261 = validateParameter(valid_589261, JString, required = false,
                                 default = nil)
  if valid_589261 != nil:
    section.add "fields", valid_589261
  var valid_589262 = query.getOrDefault("quotaUser")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = nil)
  if valid_589262 != nil:
    section.add "quotaUser", valid_589262
  var valid_589263 = query.getOrDefault("alt")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = newJString("json"))
  if valid_589263 != nil:
    section.add "alt", valid_589263
  var valid_589264 = query.getOrDefault("oauth_token")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "oauth_token", valid_589264
  var valid_589265 = query.getOrDefault("callback")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "callback", valid_589265
  var valid_589266 = query.getOrDefault("access_token")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = nil)
  if valid_589266 != nil:
    section.add "access_token", valid_589266
  var valid_589267 = query.getOrDefault("uploadType")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = nil)
  if valid_589267 != nil:
    section.add "uploadType", valid_589267
  var valid_589268 = query.getOrDefault("key")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = nil)
  if valid_589268 != nil:
    section.add "key", valid_589268
  var valid_589269 = query.getOrDefault("$.xgafv")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = newJString("1"))
  if valid_589269 != nil:
    section.add "$.xgafv", valid_589269
  var valid_589270 = query.getOrDefault("prettyPrint")
  valid_589270 = validateParameter(valid_589270, JBool, required = false,
                                 default = newJBool(true))
  if valid_589270 != nil:
    section.add "prettyPrint", valid_589270
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

proc call*(call_589272: Call_ServicemanagementServicesDisable_589256;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Disables a service for a project, so it can no longer be
  ## be used for the project. It prevents accidental usage that may cause
  ## unexpected billing charges or security leaks.
  ## 
  ## Operation<response: DisableServiceResponse>
  ## 
  let valid = call_589272.validator(path, query, header, formData, body)
  let scheme = call_589272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589272.url(scheme.get, call_589272.host, call_589272.base,
                         call_589272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589272, url, valid)

proc call*(call_589273: Call_ServicemanagementServicesDisable_589256;
          serviceName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## servicemanagementServicesDisable
  ## Disables a service for a project, so it can no longer be
  ## be used for the project. It prevents accidental usage that may cause
  ## unexpected billing charges or security leaks.
  ## 
  ## Operation<response: DisableServiceResponse>
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
  ##   serviceName: string (required)
  ##              : Name of the service to disable. Specifying an unknown service name
  ## will cause the request to fail.
  var path_589274 = newJObject()
  var query_589275 = newJObject()
  var body_589276 = newJObject()
  add(query_589275, "upload_protocol", newJString(uploadProtocol))
  add(query_589275, "fields", newJString(fields))
  add(query_589275, "quotaUser", newJString(quotaUser))
  add(query_589275, "alt", newJString(alt))
  add(query_589275, "oauth_token", newJString(oauthToken))
  add(query_589275, "callback", newJString(callback))
  add(query_589275, "access_token", newJString(accessToken))
  add(query_589275, "uploadType", newJString(uploadType))
  add(query_589275, "key", newJString(key))
  add(query_589275, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589276 = body
  add(query_589275, "prettyPrint", newJBool(prettyPrint))
  add(path_589274, "serviceName", newJString(serviceName))
  result = call_589273.call(path_589274, query_589275, nil, nil, body_589276)

var servicemanagementServicesDisable* = Call_ServicemanagementServicesDisable_589256(
    name: "servicemanagementServicesDisable", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}:disable",
    validator: validate_ServicemanagementServicesDisable_589257, base: "/",
    url: url_ServicemanagementServicesDisable_589258, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesEnable_589277 = ref object of OpenApiRestCall_588450
proc url_ServicemanagementServicesEnable_589279(protocol: Scheme; host: string;
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

proc validate_ServicemanagementServicesEnable_589278(path: JsonNode;
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
  var valid_589280 = path.getOrDefault("serviceName")
  valid_589280 = validateParameter(valid_589280, JString, required = true,
                                 default = nil)
  if valid_589280 != nil:
    section.add "serviceName", valid_589280
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
  var valid_589281 = query.getOrDefault("upload_protocol")
  valid_589281 = validateParameter(valid_589281, JString, required = false,
                                 default = nil)
  if valid_589281 != nil:
    section.add "upload_protocol", valid_589281
  var valid_589282 = query.getOrDefault("fields")
  valid_589282 = validateParameter(valid_589282, JString, required = false,
                                 default = nil)
  if valid_589282 != nil:
    section.add "fields", valid_589282
  var valid_589283 = query.getOrDefault("quotaUser")
  valid_589283 = validateParameter(valid_589283, JString, required = false,
                                 default = nil)
  if valid_589283 != nil:
    section.add "quotaUser", valid_589283
  var valid_589284 = query.getOrDefault("alt")
  valid_589284 = validateParameter(valid_589284, JString, required = false,
                                 default = newJString("json"))
  if valid_589284 != nil:
    section.add "alt", valid_589284
  var valid_589285 = query.getOrDefault("oauth_token")
  valid_589285 = validateParameter(valid_589285, JString, required = false,
                                 default = nil)
  if valid_589285 != nil:
    section.add "oauth_token", valid_589285
  var valid_589286 = query.getOrDefault("callback")
  valid_589286 = validateParameter(valid_589286, JString, required = false,
                                 default = nil)
  if valid_589286 != nil:
    section.add "callback", valid_589286
  var valid_589287 = query.getOrDefault("access_token")
  valid_589287 = validateParameter(valid_589287, JString, required = false,
                                 default = nil)
  if valid_589287 != nil:
    section.add "access_token", valid_589287
  var valid_589288 = query.getOrDefault("uploadType")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = nil)
  if valid_589288 != nil:
    section.add "uploadType", valid_589288
  var valid_589289 = query.getOrDefault("key")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = nil)
  if valid_589289 != nil:
    section.add "key", valid_589289
  var valid_589290 = query.getOrDefault("$.xgafv")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = newJString("1"))
  if valid_589290 != nil:
    section.add "$.xgafv", valid_589290
  var valid_589291 = query.getOrDefault("prettyPrint")
  valid_589291 = validateParameter(valid_589291, JBool, required = false,
                                 default = newJBool(true))
  if valid_589291 != nil:
    section.add "prettyPrint", valid_589291
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

proc call*(call_589293: Call_ServicemanagementServicesEnable_589277;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables a service for a project, so it can be used
  ## for the project. See
  ## [Cloud Auth Guide](https://cloud.google.com/docs/authentication) for
  ## more information.
  ## 
  ## Operation<response: EnableServiceResponse>
  ## 
  let valid = call_589293.validator(path, query, header, formData, body)
  let scheme = call_589293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589293.url(scheme.get, call_589293.host, call_589293.base,
                         call_589293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589293, url, valid)

proc call*(call_589294: Call_ServicemanagementServicesEnable_589277;
          serviceName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## servicemanagementServicesEnable
  ## Enables a service for a project, so it can be used
  ## for the project. See
  ## [Cloud Auth Guide](https://cloud.google.com/docs/authentication) for
  ## more information.
  ## 
  ## Operation<response: EnableServiceResponse>
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
  ##   serviceName: string (required)
  ##              : Name of the service to enable. Specifying an unknown service name will
  ## cause the request to fail.
  var path_589295 = newJObject()
  var query_589296 = newJObject()
  var body_589297 = newJObject()
  add(query_589296, "upload_protocol", newJString(uploadProtocol))
  add(query_589296, "fields", newJString(fields))
  add(query_589296, "quotaUser", newJString(quotaUser))
  add(query_589296, "alt", newJString(alt))
  add(query_589296, "oauth_token", newJString(oauthToken))
  add(query_589296, "callback", newJString(callback))
  add(query_589296, "access_token", newJString(accessToken))
  add(query_589296, "uploadType", newJString(uploadType))
  add(query_589296, "key", newJString(key))
  add(query_589296, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589297 = body
  add(query_589296, "prettyPrint", newJBool(prettyPrint))
  add(path_589295, "serviceName", newJString(serviceName))
  result = call_589294.call(path_589295, query_589296, nil, nil, body_589297)

var servicemanagementServicesEnable* = Call_ServicemanagementServicesEnable_589277(
    name: "servicemanagementServicesEnable", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}:enable",
    validator: validate_ServicemanagementServicesEnable_589278, base: "/",
    url: url_ServicemanagementServicesEnable_589279, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesUndelete_589298 = ref object of OpenApiRestCall_588450
proc url_ServicemanagementServicesUndelete_589300(protocol: Scheme; host: string;
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

proc validate_ServicemanagementServicesUndelete_589299(path: JsonNode;
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
  var valid_589301 = path.getOrDefault("serviceName")
  valid_589301 = validateParameter(valid_589301, JString, required = true,
                                 default = nil)
  if valid_589301 != nil:
    section.add "serviceName", valid_589301
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
  var valid_589302 = query.getOrDefault("upload_protocol")
  valid_589302 = validateParameter(valid_589302, JString, required = false,
                                 default = nil)
  if valid_589302 != nil:
    section.add "upload_protocol", valid_589302
  var valid_589303 = query.getOrDefault("fields")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = nil)
  if valid_589303 != nil:
    section.add "fields", valid_589303
  var valid_589304 = query.getOrDefault("quotaUser")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = nil)
  if valid_589304 != nil:
    section.add "quotaUser", valid_589304
  var valid_589305 = query.getOrDefault("alt")
  valid_589305 = validateParameter(valid_589305, JString, required = false,
                                 default = newJString("json"))
  if valid_589305 != nil:
    section.add "alt", valid_589305
  var valid_589306 = query.getOrDefault("oauth_token")
  valid_589306 = validateParameter(valid_589306, JString, required = false,
                                 default = nil)
  if valid_589306 != nil:
    section.add "oauth_token", valid_589306
  var valid_589307 = query.getOrDefault("callback")
  valid_589307 = validateParameter(valid_589307, JString, required = false,
                                 default = nil)
  if valid_589307 != nil:
    section.add "callback", valid_589307
  var valid_589308 = query.getOrDefault("access_token")
  valid_589308 = validateParameter(valid_589308, JString, required = false,
                                 default = nil)
  if valid_589308 != nil:
    section.add "access_token", valid_589308
  var valid_589309 = query.getOrDefault("uploadType")
  valid_589309 = validateParameter(valid_589309, JString, required = false,
                                 default = nil)
  if valid_589309 != nil:
    section.add "uploadType", valid_589309
  var valid_589310 = query.getOrDefault("key")
  valid_589310 = validateParameter(valid_589310, JString, required = false,
                                 default = nil)
  if valid_589310 != nil:
    section.add "key", valid_589310
  var valid_589311 = query.getOrDefault("$.xgafv")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = newJString("1"))
  if valid_589311 != nil:
    section.add "$.xgafv", valid_589311
  var valid_589312 = query.getOrDefault("prettyPrint")
  valid_589312 = validateParameter(valid_589312, JBool, required = false,
                                 default = newJBool(true))
  if valid_589312 != nil:
    section.add "prettyPrint", valid_589312
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589313: Call_ServicemanagementServicesUndelete_589298;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Revives a previously deleted managed service. The method restores the
  ## service using the configuration at the time the service was deleted.
  ## The target service must exist and must have been deleted within the
  ## last 30 days.
  ## 
  ## Operation<response: UndeleteServiceResponse>
  ## 
  let valid = call_589313.validator(path, query, header, formData, body)
  let scheme = call_589313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589313.url(scheme.get, call_589313.host, call_589313.base,
                         call_589313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589313, url, valid)

proc call*(call_589314: Call_ServicemanagementServicesUndelete_589298;
          serviceName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## servicemanagementServicesUndelete
  ## Revives a previously deleted managed service. The method restores the
  ## service using the configuration at the time the service was deleted.
  ## The target service must exist and must have been deleted within the
  ## last 30 days.
  ## 
  ## Operation<response: UndeleteServiceResponse>
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   serviceName: string (required)
  ##              : The name of the service. See the [overview](/service-management/overview)
  ## for naming requirements. For example: `example.googleapis.com`.
  var path_589315 = newJObject()
  var query_589316 = newJObject()
  add(query_589316, "upload_protocol", newJString(uploadProtocol))
  add(query_589316, "fields", newJString(fields))
  add(query_589316, "quotaUser", newJString(quotaUser))
  add(query_589316, "alt", newJString(alt))
  add(query_589316, "oauth_token", newJString(oauthToken))
  add(query_589316, "callback", newJString(callback))
  add(query_589316, "access_token", newJString(accessToken))
  add(query_589316, "uploadType", newJString(uploadType))
  add(query_589316, "key", newJString(key))
  add(query_589316, "$.xgafv", newJString(Xgafv))
  add(query_589316, "prettyPrint", newJBool(prettyPrint))
  add(path_589315, "serviceName", newJString(serviceName))
  result = call_589314.call(path_589315, query_589316, nil, nil, nil)

var servicemanagementServicesUndelete* = Call_ServicemanagementServicesUndelete_589298(
    name: "servicemanagementServicesUndelete", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}:undelete",
    validator: validate_ServicemanagementServicesUndelete_589299, base: "/",
    url: url_ServicemanagementServicesUndelete_589300, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesGenerateConfigReport_589317 = ref object of OpenApiRestCall_588450
proc url_ServicemanagementServicesGenerateConfigReport_589319(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ServicemanagementServicesGenerateConfigReport_589318(
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
  var valid_589320 = query.getOrDefault("upload_protocol")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "upload_protocol", valid_589320
  var valid_589321 = query.getOrDefault("fields")
  valid_589321 = validateParameter(valid_589321, JString, required = false,
                                 default = nil)
  if valid_589321 != nil:
    section.add "fields", valid_589321
  var valid_589322 = query.getOrDefault("quotaUser")
  valid_589322 = validateParameter(valid_589322, JString, required = false,
                                 default = nil)
  if valid_589322 != nil:
    section.add "quotaUser", valid_589322
  var valid_589323 = query.getOrDefault("alt")
  valid_589323 = validateParameter(valid_589323, JString, required = false,
                                 default = newJString("json"))
  if valid_589323 != nil:
    section.add "alt", valid_589323
  var valid_589324 = query.getOrDefault("oauth_token")
  valid_589324 = validateParameter(valid_589324, JString, required = false,
                                 default = nil)
  if valid_589324 != nil:
    section.add "oauth_token", valid_589324
  var valid_589325 = query.getOrDefault("callback")
  valid_589325 = validateParameter(valid_589325, JString, required = false,
                                 default = nil)
  if valid_589325 != nil:
    section.add "callback", valid_589325
  var valid_589326 = query.getOrDefault("access_token")
  valid_589326 = validateParameter(valid_589326, JString, required = false,
                                 default = nil)
  if valid_589326 != nil:
    section.add "access_token", valid_589326
  var valid_589327 = query.getOrDefault("uploadType")
  valid_589327 = validateParameter(valid_589327, JString, required = false,
                                 default = nil)
  if valid_589327 != nil:
    section.add "uploadType", valid_589327
  var valid_589328 = query.getOrDefault("key")
  valid_589328 = validateParameter(valid_589328, JString, required = false,
                                 default = nil)
  if valid_589328 != nil:
    section.add "key", valid_589328
  var valid_589329 = query.getOrDefault("$.xgafv")
  valid_589329 = validateParameter(valid_589329, JString, required = false,
                                 default = newJString("1"))
  if valid_589329 != nil:
    section.add "$.xgafv", valid_589329
  var valid_589330 = query.getOrDefault("prettyPrint")
  valid_589330 = validateParameter(valid_589330, JBool, required = false,
                                 default = newJBool(true))
  if valid_589330 != nil:
    section.add "prettyPrint", valid_589330
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

proc call*(call_589332: Call_ServicemanagementServicesGenerateConfigReport_589317;
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
  let valid = call_589332.validator(path, query, header, formData, body)
  let scheme = call_589332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589332.url(scheme.get, call_589332.host, call_589332.base,
                         call_589332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589332, url, valid)

proc call*(call_589333: Call_ServicemanagementServicesGenerateConfigReport_589317;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
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
  var query_589334 = newJObject()
  var body_589335 = newJObject()
  add(query_589334, "upload_protocol", newJString(uploadProtocol))
  add(query_589334, "fields", newJString(fields))
  add(query_589334, "quotaUser", newJString(quotaUser))
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
  result = call_589333.call(nil, query_589334, nil, nil, body_589335)

var servicemanagementServicesGenerateConfigReport* = Call_ServicemanagementServicesGenerateConfigReport_589317(
    name: "servicemanagementServicesGenerateConfigReport",
    meth: HttpMethod.HttpPost, host: "servicemanagement.googleapis.com",
    route: "/v1/services:generateConfigReport",
    validator: validate_ServicemanagementServicesGenerateConfigReport_589318,
    base: "/", url: url_ServicemanagementServicesGenerateConfigReport_589319,
    schemes: {Scheme.Https})
type
  Call_ServicemanagementOperationsGet_589336 = ref object of OpenApiRestCall_588450
proc url_ServicemanagementOperationsGet_589338(protocol: Scheme; host: string;
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

proc validate_ServicemanagementOperationsGet_589337(path: JsonNode;
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
  if body != nil:
    result.add "body", body

proc call*(call_589351: Call_ServicemanagementOperationsGet_589336; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_589351.validator(path, query, header, formData, body)
  let scheme = call_589351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589351.url(scheme.get, call_589351.host, call_589351.base,
                         call_589351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589351, url, valid)

proc call*(call_589352: Call_ServicemanagementOperationsGet_589336; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## servicemanagementOperationsGet
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource.
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
  var path_589353 = newJObject()
  var query_589354 = newJObject()
  add(query_589354, "upload_protocol", newJString(uploadProtocol))
  add(query_589354, "fields", newJString(fields))
  add(query_589354, "quotaUser", newJString(quotaUser))
  add(path_589353, "name", newJString(name))
  add(query_589354, "alt", newJString(alt))
  add(query_589354, "oauth_token", newJString(oauthToken))
  add(query_589354, "callback", newJString(callback))
  add(query_589354, "access_token", newJString(accessToken))
  add(query_589354, "uploadType", newJString(uploadType))
  add(query_589354, "key", newJString(key))
  add(query_589354, "$.xgafv", newJString(Xgafv))
  add(query_589354, "prettyPrint", newJBool(prettyPrint))
  result = call_589352.call(path_589353, query_589354, nil, nil, nil)

var servicemanagementOperationsGet* = Call_ServicemanagementOperationsGet_589336(
    name: "servicemanagementOperationsGet", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com", route: "/v1/{name}",
    validator: validate_ServicemanagementOperationsGet_589337, base: "/",
    url: url_ServicemanagementOperationsGet_589338, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConsumersGetIamPolicy_589355 = ref object of OpenApiRestCall_588450
proc url_ServicemanagementServicesConsumersGetIamPolicy_589357(protocol: Scheme;
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

proc validate_ServicemanagementServicesConsumersGetIamPolicy_589356(
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
  var valid_589358 = path.getOrDefault("resource")
  valid_589358 = validateParameter(valid_589358, JString, required = true,
                                 default = nil)
  if valid_589358 != nil:
    section.add "resource", valid_589358
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
  var valid_589359 = query.getOrDefault("upload_protocol")
  valid_589359 = validateParameter(valid_589359, JString, required = false,
                                 default = nil)
  if valid_589359 != nil:
    section.add "upload_protocol", valid_589359
  var valid_589360 = query.getOrDefault("fields")
  valid_589360 = validateParameter(valid_589360, JString, required = false,
                                 default = nil)
  if valid_589360 != nil:
    section.add "fields", valid_589360
  var valid_589361 = query.getOrDefault("quotaUser")
  valid_589361 = validateParameter(valid_589361, JString, required = false,
                                 default = nil)
  if valid_589361 != nil:
    section.add "quotaUser", valid_589361
  var valid_589362 = query.getOrDefault("alt")
  valid_589362 = validateParameter(valid_589362, JString, required = false,
                                 default = newJString("json"))
  if valid_589362 != nil:
    section.add "alt", valid_589362
  var valid_589363 = query.getOrDefault("oauth_token")
  valid_589363 = validateParameter(valid_589363, JString, required = false,
                                 default = nil)
  if valid_589363 != nil:
    section.add "oauth_token", valid_589363
  var valid_589364 = query.getOrDefault("callback")
  valid_589364 = validateParameter(valid_589364, JString, required = false,
                                 default = nil)
  if valid_589364 != nil:
    section.add "callback", valid_589364
  var valid_589365 = query.getOrDefault("access_token")
  valid_589365 = validateParameter(valid_589365, JString, required = false,
                                 default = nil)
  if valid_589365 != nil:
    section.add "access_token", valid_589365
  var valid_589366 = query.getOrDefault("uploadType")
  valid_589366 = validateParameter(valid_589366, JString, required = false,
                                 default = nil)
  if valid_589366 != nil:
    section.add "uploadType", valid_589366
  var valid_589367 = query.getOrDefault("key")
  valid_589367 = validateParameter(valid_589367, JString, required = false,
                                 default = nil)
  if valid_589367 != nil:
    section.add "key", valid_589367
  var valid_589368 = query.getOrDefault("$.xgafv")
  valid_589368 = validateParameter(valid_589368, JString, required = false,
                                 default = newJString("1"))
  if valid_589368 != nil:
    section.add "$.xgafv", valid_589368
  var valid_589369 = query.getOrDefault("prettyPrint")
  valid_589369 = validateParameter(valid_589369, JBool, required = false,
                                 default = newJBool(true))
  if valid_589369 != nil:
    section.add "prettyPrint", valid_589369
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

proc call*(call_589371: Call_ServicemanagementServicesConsumersGetIamPolicy_589355;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_589371.validator(path, query, header, formData, body)
  let scheme = call_589371.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589371.url(scheme.get, call_589371.host, call_589371.base,
                         call_589371.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589371, url, valid)

proc call*(call_589372: Call_ServicemanagementServicesConsumersGetIamPolicy_589355;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## servicemanagementServicesConsumersGetIamPolicy
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
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
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589373 = newJObject()
  var query_589374 = newJObject()
  var body_589375 = newJObject()
  add(query_589374, "upload_protocol", newJString(uploadProtocol))
  add(query_589374, "fields", newJString(fields))
  add(query_589374, "quotaUser", newJString(quotaUser))
  add(query_589374, "alt", newJString(alt))
  add(query_589374, "oauth_token", newJString(oauthToken))
  add(query_589374, "callback", newJString(callback))
  add(query_589374, "access_token", newJString(accessToken))
  add(query_589374, "uploadType", newJString(uploadType))
  add(query_589374, "key", newJString(key))
  add(query_589374, "$.xgafv", newJString(Xgafv))
  add(path_589373, "resource", newJString(resource))
  if body != nil:
    body_589375 = body
  add(query_589374, "prettyPrint", newJBool(prettyPrint))
  result = call_589372.call(path_589373, query_589374, nil, nil, body_589375)

var servicemanagementServicesConsumersGetIamPolicy* = Call_ServicemanagementServicesConsumersGetIamPolicy_589355(
    name: "servicemanagementServicesConsumersGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "servicemanagement.googleapis.com",
    route: "/v1/{resource}:getIamPolicy",
    validator: validate_ServicemanagementServicesConsumersGetIamPolicy_589356,
    base: "/", url: url_ServicemanagementServicesConsumersGetIamPolicy_589357,
    schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConsumersSetIamPolicy_589376 = ref object of OpenApiRestCall_588450
proc url_ServicemanagementServicesConsumersSetIamPolicy_589378(protocol: Scheme;
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

proc validate_ServicemanagementServicesConsumersSetIamPolicy_589377(
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
  var valid_589379 = path.getOrDefault("resource")
  valid_589379 = validateParameter(valid_589379, JString, required = true,
                                 default = nil)
  if valid_589379 != nil:
    section.add "resource", valid_589379
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
  var valid_589380 = query.getOrDefault("upload_protocol")
  valid_589380 = validateParameter(valid_589380, JString, required = false,
                                 default = nil)
  if valid_589380 != nil:
    section.add "upload_protocol", valid_589380
  var valid_589381 = query.getOrDefault("fields")
  valid_589381 = validateParameter(valid_589381, JString, required = false,
                                 default = nil)
  if valid_589381 != nil:
    section.add "fields", valid_589381
  var valid_589382 = query.getOrDefault("quotaUser")
  valid_589382 = validateParameter(valid_589382, JString, required = false,
                                 default = nil)
  if valid_589382 != nil:
    section.add "quotaUser", valid_589382
  var valid_589383 = query.getOrDefault("alt")
  valid_589383 = validateParameter(valid_589383, JString, required = false,
                                 default = newJString("json"))
  if valid_589383 != nil:
    section.add "alt", valid_589383
  var valid_589384 = query.getOrDefault("oauth_token")
  valid_589384 = validateParameter(valid_589384, JString, required = false,
                                 default = nil)
  if valid_589384 != nil:
    section.add "oauth_token", valid_589384
  var valid_589385 = query.getOrDefault("callback")
  valid_589385 = validateParameter(valid_589385, JString, required = false,
                                 default = nil)
  if valid_589385 != nil:
    section.add "callback", valid_589385
  var valid_589386 = query.getOrDefault("access_token")
  valid_589386 = validateParameter(valid_589386, JString, required = false,
                                 default = nil)
  if valid_589386 != nil:
    section.add "access_token", valid_589386
  var valid_589387 = query.getOrDefault("uploadType")
  valid_589387 = validateParameter(valid_589387, JString, required = false,
                                 default = nil)
  if valid_589387 != nil:
    section.add "uploadType", valid_589387
  var valid_589388 = query.getOrDefault("key")
  valid_589388 = validateParameter(valid_589388, JString, required = false,
                                 default = nil)
  if valid_589388 != nil:
    section.add "key", valid_589388
  var valid_589389 = query.getOrDefault("$.xgafv")
  valid_589389 = validateParameter(valid_589389, JString, required = false,
                                 default = newJString("1"))
  if valid_589389 != nil:
    section.add "$.xgafv", valid_589389
  var valid_589390 = query.getOrDefault("prettyPrint")
  valid_589390 = validateParameter(valid_589390, JBool, required = false,
                                 default = newJBool(true))
  if valid_589390 != nil:
    section.add "prettyPrint", valid_589390
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

proc call*(call_589392: Call_ServicemanagementServicesConsumersSetIamPolicy_589376;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_589392.validator(path, query, header, formData, body)
  let scheme = call_589392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589392.url(scheme.get, call_589392.host, call_589392.base,
                         call_589392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589392, url, valid)

proc call*(call_589393: Call_ServicemanagementServicesConsumersSetIamPolicy_589376;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## servicemanagementServicesConsumersSetIamPolicy
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
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
  var path_589394 = newJObject()
  var query_589395 = newJObject()
  var body_589396 = newJObject()
  add(query_589395, "upload_protocol", newJString(uploadProtocol))
  add(query_589395, "fields", newJString(fields))
  add(query_589395, "quotaUser", newJString(quotaUser))
  add(query_589395, "alt", newJString(alt))
  add(query_589395, "oauth_token", newJString(oauthToken))
  add(query_589395, "callback", newJString(callback))
  add(query_589395, "access_token", newJString(accessToken))
  add(query_589395, "uploadType", newJString(uploadType))
  add(query_589395, "key", newJString(key))
  add(query_589395, "$.xgafv", newJString(Xgafv))
  add(path_589394, "resource", newJString(resource))
  if body != nil:
    body_589396 = body
  add(query_589395, "prettyPrint", newJBool(prettyPrint))
  result = call_589393.call(path_589394, query_589395, nil, nil, body_589396)

var servicemanagementServicesConsumersSetIamPolicy* = Call_ServicemanagementServicesConsumersSetIamPolicy_589376(
    name: "servicemanagementServicesConsumersSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "servicemanagement.googleapis.com",
    route: "/v1/{resource}:setIamPolicy",
    validator: validate_ServicemanagementServicesConsumersSetIamPolicy_589377,
    base: "/", url: url_ServicemanagementServicesConsumersSetIamPolicy_589378,
    schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConsumersTestIamPermissions_589397 = ref object of OpenApiRestCall_588450
proc url_ServicemanagementServicesConsumersTestIamPermissions_589399(
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

proc validate_ServicemanagementServicesConsumersTestIamPermissions_589398(
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
  var valid_589400 = path.getOrDefault("resource")
  valid_589400 = validateParameter(valid_589400, JString, required = true,
                                 default = nil)
  if valid_589400 != nil:
    section.add "resource", valid_589400
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
  var valid_589401 = query.getOrDefault("upload_protocol")
  valid_589401 = validateParameter(valid_589401, JString, required = false,
                                 default = nil)
  if valid_589401 != nil:
    section.add "upload_protocol", valid_589401
  var valid_589402 = query.getOrDefault("fields")
  valid_589402 = validateParameter(valid_589402, JString, required = false,
                                 default = nil)
  if valid_589402 != nil:
    section.add "fields", valid_589402
  var valid_589403 = query.getOrDefault("quotaUser")
  valid_589403 = validateParameter(valid_589403, JString, required = false,
                                 default = nil)
  if valid_589403 != nil:
    section.add "quotaUser", valid_589403
  var valid_589404 = query.getOrDefault("alt")
  valid_589404 = validateParameter(valid_589404, JString, required = false,
                                 default = newJString("json"))
  if valid_589404 != nil:
    section.add "alt", valid_589404
  var valid_589405 = query.getOrDefault("oauth_token")
  valid_589405 = validateParameter(valid_589405, JString, required = false,
                                 default = nil)
  if valid_589405 != nil:
    section.add "oauth_token", valid_589405
  var valid_589406 = query.getOrDefault("callback")
  valid_589406 = validateParameter(valid_589406, JString, required = false,
                                 default = nil)
  if valid_589406 != nil:
    section.add "callback", valid_589406
  var valid_589407 = query.getOrDefault("access_token")
  valid_589407 = validateParameter(valid_589407, JString, required = false,
                                 default = nil)
  if valid_589407 != nil:
    section.add "access_token", valid_589407
  var valid_589408 = query.getOrDefault("uploadType")
  valid_589408 = validateParameter(valid_589408, JString, required = false,
                                 default = nil)
  if valid_589408 != nil:
    section.add "uploadType", valid_589408
  var valid_589409 = query.getOrDefault("key")
  valid_589409 = validateParameter(valid_589409, JString, required = false,
                                 default = nil)
  if valid_589409 != nil:
    section.add "key", valid_589409
  var valid_589410 = query.getOrDefault("$.xgafv")
  valid_589410 = validateParameter(valid_589410, JString, required = false,
                                 default = newJString("1"))
  if valid_589410 != nil:
    section.add "$.xgafv", valid_589410
  var valid_589411 = query.getOrDefault("prettyPrint")
  valid_589411 = validateParameter(valid_589411, JBool, required = false,
                                 default = newJBool(true))
  if valid_589411 != nil:
    section.add "prettyPrint", valid_589411
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

proc call*(call_589413: Call_ServicemanagementServicesConsumersTestIamPermissions_589397;
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
  let valid = call_589413.validator(path, query, header, formData, body)
  let scheme = call_589413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589413.url(scheme.get, call_589413.host, call_589413.base,
                         call_589413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589413, url, valid)

proc call*(call_589414: Call_ServicemanagementServicesConsumersTestIamPermissions_589397;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## servicemanagementServicesConsumersTestIamPermissions
  ## Returns permissions that a caller has on the specified resource.
  ## If the resource does not exist, this will return an empty set of
  ## permissions, not a NOT_FOUND error.
  ## 
  ## Note: This operation is designed to be used for building permission-aware
  ## UIs and command-line tools, not for authorization checking. This operation
  ## may "fail open" without warning.
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
  var path_589415 = newJObject()
  var query_589416 = newJObject()
  var body_589417 = newJObject()
  add(query_589416, "upload_protocol", newJString(uploadProtocol))
  add(query_589416, "fields", newJString(fields))
  add(query_589416, "quotaUser", newJString(quotaUser))
  add(query_589416, "alt", newJString(alt))
  add(query_589416, "oauth_token", newJString(oauthToken))
  add(query_589416, "callback", newJString(callback))
  add(query_589416, "access_token", newJString(accessToken))
  add(query_589416, "uploadType", newJString(uploadType))
  add(query_589416, "key", newJString(key))
  add(query_589416, "$.xgafv", newJString(Xgafv))
  add(path_589415, "resource", newJString(resource))
  if body != nil:
    body_589417 = body
  add(query_589416, "prettyPrint", newJBool(prettyPrint))
  result = call_589414.call(path_589415, query_589416, nil, nil, body_589417)

var servicemanagementServicesConsumersTestIamPermissions* = Call_ServicemanagementServicesConsumersTestIamPermissions_589397(
    name: "servicemanagementServicesConsumersTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "servicemanagement.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_ServicemanagementServicesConsumersTestIamPermissions_589398,
    base: "/", url: url_ServicemanagementServicesConsumersTestIamPermissions_589399,
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
