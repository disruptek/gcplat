
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
  gcpServiceName = "servicemanagement"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServicemanagementOperationsList_579690 = ref object of OpenApiRestCall_579421
proc url_ServicemanagementOperationsList_579692(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ServicemanagementOperationsList_579691(path: JsonNode;
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
  var valid_579806 = query.getOrDefault("pageToken")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "pageToken", valid_579806
  var valid_579807 = query.getOrDefault("quotaUser")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "quotaUser", valid_579807
  var valid_579821 = query.getOrDefault("alt")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = newJString("json"))
  if valid_579821 != nil:
    section.add "alt", valid_579821
  var valid_579822 = query.getOrDefault("oauth_token")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "oauth_token", valid_579822
  var valid_579823 = query.getOrDefault("callback")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "callback", valid_579823
  var valid_579824 = query.getOrDefault("access_token")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "access_token", valid_579824
  var valid_579825 = query.getOrDefault("uploadType")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "uploadType", valid_579825
  var valid_579826 = query.getOrDefault("key")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "key", valid_579826
  var valid_579827 = query.getOrDefault("name")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "name", valid_579827
  var valid_579828 = query.getOrDefault("$.xgafv")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = newJString("1"))
  if valid_579828 != nil:
    section.add "$.xgafv", valid_579828
  var valid_579829 = query.getOrDefault("pageSize")
  valid_579829 = validateParameter(valid_579829, JInt, required = false, default = nil)
  if valid_579829 != nil:
    section.add "pageSize", valid_579829
  var valid_579830 = query.getOrDefault("prettyPrint")
  valid_579830 = validateParameter(valid_579830, JBool, required = false,
                                 default = newJBool(true))
  if valid_579830 != nil:
    section.add "prettyPrint", valid_579830
  var valid_579831 = query.getOrDefault("filter")
  valid_579831 = validateParameter(valid_579831, JString, required = false,
                                 default = nil)
  if valid_579831 != nil:
    section.add "filter", valid_579831
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579854: Call_ServicemanagementOperationsList_579690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists service operations that match the specified filter in the request.
  ## 
  let valid = call_579854.validator(path, query, header, formData, body)
  let scheme = call_579854.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579854.url(scheme.get, call_579854.host, call_579854.base,
                         call_579854.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579854, url, valid)

proc call*(call_579925: Call_ServicemanagementOperationsList_579690;
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
  var query_579926 = newJObject()
  add(query_579926, "upload_protocol", newJString(uploadProtocol))
  add(query_579926, "fields", newJString(fields))
  add(query_579926, "pageToken", newJString(pageToken))
  add(query_579926, "quotaUser", newJString(quotaUser))
  add(query_579926, "alt", newJString(alt))
  add(query_579926, "oauth_token", newJString(oauthToken))
  add(query_579926, "callback", newJString(callback))
  add(query_579926, "access_token", newJString(accessToken))
  add(query_579926, "uploadType", newJString(uploadType))
  add(query_579926, "key", newJString(key))
  add(query_579926, "name", newJString(name))
  add(query_579926, "$.xgafv", newJString(Xgafv))
  add(query_579926, "pageSize", newJInt(pageSize))
  add(query_579926, "prettyPrint", newJBool(prettyPrint))
  add(query_579926, "filter", newJString(filter))
  result = call_579925.call(nil, query_579926, nil, nil, nil)

var servicemanagementOperationsList* = Call_ServicemanagementOperationsList_579690(
    name: "servicemanagementOperationsList", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com", route: "/v1/operations",
    validator: validate_ServicemanagementOperationsList_579691, base: "/",
    url: url_ServicemanagementOperationsList_579692, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesCreate_579987 = ref object of OpenApiRestCall_579421
proc url_ServicemanagementServicesCreate_579989(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ServicemanagementServicesCreate_579988(path: JsonNode;
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
  var valid_579990 = query.getOrDefault("upload_protocol")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "upload_protocol", valid_579990
  var valid_579991 = query.getOrDefault("fields")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "fields", valid_579991
  var valid_579992 = query.getOrDefault("quotaUser")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "quotaUser", valid_579992
  var valid_579993 = query.getOrDefault("alt")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = newJString("json"))
  if valid_579993 != nil:
    section.add "alt", valid_579993
  var valid_579994 = query.getOrDefault("oauth_token")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "oauth_token", valid_579994
  var valid_579995 = query.getOrDefault("callback")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "callback", valid_579995
  var valid_579996 = query.getOrDefault("access_token")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "access_token", valid_579996
  var valid_579997 = query.getOrDefault("uploadType")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "uploadType", valid_579997
  var valid_579998 = query.getOrDefault("key")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "key", valid_579998
  var valid_579999 = query.getOrDefault("$.xgafv")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = newJString("1"))
  if valid_579999 != nil:
    section.add "$.xgafv", valid_579999
  var valid_580000 = query.getOrDefault("prettyPrint")
  valid_580000 = validateParameter(valid_580000, JBool, required = false,
                                 default = newJBool(true))
  if valid_580000 != nil:
    section.add "prettyPrint", valid_580000
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

proc call*(call_580002: Call_ServicemanagementServicesCreate_579987;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new managed service.
  ## Please note one producer project can own no more than 20 services.
  ## 
  ## Operation<response: ManagedService>
  ## 
  let valid = call_580002.validator(path, query, header, formData, body)
  let scheme = call_580002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580002.url(scheme.get, call_580002.host, call_580002.base,
                         call_580002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580002, url, valid)

proc call*(call_580003: Call_ServicemanagementServicesCreate_579987;
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
  var query_580004 = newJObject()
  var body_580005 = newJObject()
  add(query_580004, "upload_protocol", newJString(uploadProtocol))
  add(query_580004, "fields", newJString(fields))
  add(query_580004, "quotaUser", newJString(quotaUser))
  add(query_580004, "alt", newJString(alt))
  add(query_580004, "oauth_token", newJString(oauthToken))
  add(query_580004, "callback", newJString(callback))
  add(query_580004, "access_token", newJString(accessToken))
  add(query_580004, "uploadType", newJString(uploadType))
  add(query_580004, "key", newJString(key))
  add(query_580004, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580005 = body
  add(query_580004, "prettyPrint", newJBool(prettyPrint))
  result = call_580003.call(nil, query_580004, nil, nil, body_580005)

var servicemanagementServicesCreate* = Call_ServicemanagementServicesCreate_579987(
    name: "servicemanagementServicesCreate", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com", route: "/v1/services",
    validator: validate_ServicemanagementServicesCreate_579988, base: "/",
    url: url_ServicemanagementServicesCreate_579989, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesList_579966 = ref object of OpenApiRestCall_579421
proc url_ServicemanagementServicesList_579968(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ServicemanagementServicesList_579967(path: JsonNode; query: JsonNode;
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
  var valid_579969 = query.getOrDefault("upload_protocol")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "upload_protocol", valid_579969
  var valid_579970 = query.getOrDefault("fields")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "fields", valid_579970
  var valid_579971 = query.getOrDefault("pageToken")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "pageToken", valid_579971
  var valid_579972 = query.getOrDefault("quotaUser")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "quotaUser", valid_579972
  var valid_579973 = query.getOrDefault("alt")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = newJString("json"))
  if valid_579973 != nil:
    section.add "alt", valid_579973
  var valid_579974 = query.getOrDefault("oauth_token")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "oauth_token", valid_579974
  var valid_579975 = query.getOrDefault("callback")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "callback", valid_579975
  var valid_579976 = query.getOrDefault("access_token")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "access_token", valid_579976
  var valid_579977 = query.getOrDefault("uploadType")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "uploadType", valid_579977
  var valid_579978 = query.getOrDefault("consumerId")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "consumerId", valid_579978
  var valid_579979 = query.getOrDefault("key")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "key", valid_579979
  var valid_579980 = query.getOrDefault("producerProjectId")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "producerProjectId", valid_579980
  var valid_579981 = query.getOrDefault("$.xgafv")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = newJString("1"))
  if valid_579981 != nil:
    section.add "$.xgafv", valid_579981
  var valid_579982 = query.getOrDefault("pageSize")
  valid_579982 = validateParameter(valid_579982, JInt, required = false, default = nil)
  if valid_579982 != nil:
    section.add "pageSize", valid_579982
  var valid_579983 = query.getOrDefault("prettyPrint")
  valid_579983 = validateParameter(valid_579983, JBool, required = false,
                                 default = newJBool(true))
  if valid_579983 != nil:
    section.add "prettyPrint", valid_579983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579984: Call_ServicemanagementServicesList_579966; path: JsonNode;
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
  let valid = call_579984.validator(path, query, header, formData, body)
  let scheme = call_579984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579984.url(scheme.get, call_579984.host, call_579984.base,
                         call_579984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579984, url, valid)

proc call*(call_579985: Call_ServicemanagementServicesList_579966;
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
  var query_579986 = newJObject()
  add(query_579986, "upload_protocol", newJString(uploadProtocol))
  add(query_579986, "fields", newJString(fields))
  add(query_579986, "pageToken", newJString(pageToken))
  add(query_579986, "quotaUser", newJString(quotaUser))
  add(query_579986, "alt", newJString(alt))
  add(query_579986, "oauth_token", newJString(oauthToken))
  add(query_579986, "callback", newJString(callback))
  add(query_579986, "access_token", newJString(accessToken))
  add(query_579986, "uploadType", newJString(uploadType))
  add(query_579986, "consumerId", newJString(consumerId))
  add(query_579986, "key", newJString(key))
  add(query_579986, "producerProjectId", newJString(producerProjectId))
  add(query_579986, "$.xgafv", newJString(Xgafv))
  add(query_579986, "pageSize", newJInt(pageSize))
  add(query_579986, "prettyPrint", newJBool(prettyPrint))
  result = call_579985.call(nil, query_579986, nil, nil, nil)

var servicemanagementServicesList* = Call_ServicemanagementServicesList_579966(
    name: "servicemanagementServicesList", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com", route: "/v1/services",
    validator: validate_ServicemanagementServicesList_579967, base: "/",
    url: url_ServicemanagementServicesList_579968, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesGet_580006 = ref object of OpenApiRestCall_579421
proc url_ServicemanagementServicesGet_580008(protocol: Scheme; host: string;
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

proc validate_ServicemanagementServicesGet_580007(path: JsonNode; query: JsonNode;
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
  var valid_580023 = path.getOrDefault("serviceName")
  valid_580023 = validateParameter(valid_580023, JString, required = true,
                                 default = nil)
  if valid_580023 != nil:
    section.add "serviceName", valid_580023
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
  var valid_580024 = query.getOrDefault("upload_protocol")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "upload_protocol", valid_580024
  var valid_580025 = query.getOrDefault("fields")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "fields", valid_580025
  var valid_580026 = query.getOrDefault("quotaUser")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "quotaUser", valid_580026
  var valid_580027 = query.getOrDefault("alt")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = newJString("json"))
  if valid_580027 != nil:
    section.add "alt", valid_580027
  var valid_580028 = query.getOrDefault("oauth_token")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "oauth_token", valid_580028
  var valid_580029 = query.getOrDefault("callback")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "callback", valid_580029
  var valid_580030 = query.getOrDefault("access_token")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "access_token", valid_580030
  var valid_580031 = query.getOrDefault("uploadType")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "uploadType", valid_580031
  var valid_580032 = query.getOrDefault("key")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "key", valid_580032
  var valid_580033 = query.getOrDefault("$.xgafv")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = newJString("1"))
  if valid_580033 != nil:
    section.add "$.xgafv", valid_580033
  var valid_580034 = query.getOrDefault("prettyPrint")
  valid_580034 = validateParameter(valid_580034, JBool, required = false,
                                 default = newJBool(true))
  if valid_580034 != nil:
    section.add "prettyPrint", valid_580034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580035: Call_ServicemanagementServicesGet_580006; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a managed service. Authentication is required unless the service is
  ## public.
  ## 
  let valid = call_580035.validator(path, query, header, formData, body)
  let scheme = call_580035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580035.url(scheme.get, call_580035.host, call_580035.base,
                         call_580035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580035, url, valid)

proc call*(call_580036: Call_ServicemanagementServicesGet_580006;
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
  var path_580037 = newJObject()
  var query_580038 = newJObject()
  add(query_580038, "upload_protocol", newJString(uploadProtocol))
  add(query_580038, "fields", newJString(fields))
  add(query_580038, "quotaUser", newJString(quotaUser))
  add(query_580038, "alt", newJString(alt))
  add(query_580038, "oauth_token", newJString(oauthToken))
  add(query_580038, "callback", newJString(callback))
  add(query_580038, "access_token", newJString(accessToken))
  add(query_580038, "uploadType", newJString(uploadType))
  add(query_580038, "key", newJString(key))
  add(query_580038, "$.xgafv", newJString(Xgafv))
  add(query_580038, "prettyPrint", newJBool(prettyPrint))
  add(path_580037, "serviceName", newJString(serviceName))
  result = call_580036.call(path_580037, query_580038, nil, nil, nil)

var servicemanagementServicesGet* = Call_ServicemanagementServicesGet_580006(
    name: "servicemanagementServicesGet", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com", route: "/v1/services/{serviceName}",
    validator: validate_ServicemanagementServicesGet_580007, base: "/",
    url: url_ServicemanagementServicesGet_580008, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesDelete_580039 = ref object of OpenApiRestCall_579421
proc url_ServicemanagementServicesDelete_580041(protocol: Scheme; host: string;
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

proc validate_ServicemanagementServicesDelete_580040(path: JsonNode;
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
  var valid_580042 = path.getOrDefault("serviceName")
  valid_580042 = validateParameter(valid_580042, JString, required = true,
                                 default = nil)
  if valid_580042 != nil:
    section.add "serviceName", valid_580042
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
  var valid_580043 = query.getOrDefault("upload_protocol")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "upload_protocol", valid_580043
  var valid_580044 = query.getOrDefault("fields")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "fields", valid_580044
  var valid_580045 = query.getOrDefault("quotaUser")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "quotaUser", valid_580045
  var valid_580046 = query.getOrDefault("alt")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = newJString("json"))
  if valid_580046 != nil:
    section.add "alt", valid_580046
  var valid_580047 = query.getOrDefault("oauth_token")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "oauth_token", valid_580047
  var valid_580048 = query.getOrDefault("callback")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "callback", valid_580048
  var valid_580049 = query.getOrDefault("access_token")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "access_token", valid_580049
  var valid_580050 = query.getOrDefault("uploadType")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "uploadType", valid_580050
  var valid_580051 = query.getOrDefault("key")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "key", valid_580051
  var valid_580052 = query.getOrDefault("$.xgafv")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = newJString("1"))
  if valid_580052 != nil:
    section.add "$.xgafv", valid_580052
  var valid_580053 = query.getOrDefault("prettyPrint")
  valid_580053 = validateParameter(valid_580053, JBool, required = false,
                                 default = newJBool(true))
  if valid_580053 != nil:
    section.add "prettyPrint", valid_580053
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580054: Call_ServicemanagementServicesDelete_580039;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a managed service. This method will change the service to the
  ## `Soft-Delete` state for 30 days. Within this period, service producers may
  ## call UndeleteService to restore the service.
  ## After 30 days, the service will be permanently deleted.
  ## 
  ## Operation<response: google.protobuf.Empty>
  ## 
  let valid = call_580054.validator(path, query, header, formData, body)
  let scheme = call_580054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580054.url(scheme.get, call_580054.host, call_580054.base,
                         call_580054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580054, url, valid)

proc call*(call_580055: Call_ServicemanagementServicesDelete_580039;
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
  var path_580056 = newJObject()
  var query_580057 = newJObject()
  add(query_580057, "upload_protocol", newJString(uploadProtocol))
  add(query_580057, "fields", newJString(fields))
  add(query_580057, "quotaUser", newJString(quotaUser))
  add(query_580057, "alt", newJString(alt))
  add(query_580057, "oauth_token", newJString(oauthToken))
  add(query_580057, "callback", newJString(callback))
  add(query_580057, "access_token", newJString(accessToken))
  add(query_580057, "uploadType", newJString(uploadType))
  add(query_580057, "key", newJString(key))
  add(query_580057, "$.xgafv", newJString(Xgafv))
  add(query_580057, "prettyPrint", newJBool(prettyPrint))
  add(path_580056, "serviceName", newJString(serviceName))
  result = call_580055.call(path_580056, query_580057, nil, nil, nil)

var servicemanagementServicesDelete* = Call_ServicemanagementServicesDelete_580039(
    name: "servicemanagementServicesDelete", meth: HttpMethod.HttpDelete,
    host: "servicemanagement.googleapis.com", route: "/v1/services/{serviceName}",
    validator: validate_ServicemanagementServicesDelete_580040, base: "/",
    url: url_ServicemanagementServicesDelete_580041, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesGetConfig_580058 = ref object of OpenApiRestCall_579421
proc url_ServicemanagementServicesGetConfig_580060(protocol: Scheme; host: string;
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

proc validate_ServicemanagementServicesGetConfig_580059(path: JsonNode;
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
  var valid_580061 = path.getOrDefault("serviceName")
  valid_580061 = validateParameter(valid_580061, JString, required = true,
                                 default = nil)
  if valid_580061 != nil:
    section.add "serviceName", valid_580061
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
  var valid_580062 = query.getOrDefault("upload_protocol")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "upload_protocol", valid_580062
  var valid_580063 = query.getOrDefault("fields")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "fields", valid_580063
  var valid_580064 = query.getOrDefault("view")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_580064 != nil:
    section.add "view", valid_580064
  var valid_580065 = query.getOrDefault("quotaUser")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "quotaUser", valid_580065
  var valid_580066 = query.getOrDefault("alt")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = newJString("json"))
  if valid_580066 != nil:
    section.add "alt", valid_580066
  var valid_580067 = query.getOrDefault("oauth_token")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "oauth_token", valid_580067
  var valid_580068 = query.getOrDefault("callback")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "callback", valid_580068
  var valid_580069 = query.getOrDefault("access_token")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "access_token", valid_580069
  var valid_580070 = query.getOrDefault("uploadType")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "uploadType", valid_580070
  var valid_580071 = query.getOrDefault("configId")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "configId", valid_580071
  var valid_580072 = query.getOrDefault("key")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "key", valid_580072
  var valid_580073 = query.getOrDefault("$.xgafv")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = newJString("1"))
  if valid_580073 != nil:
    section.add "$.xgafv", valid_580073
  var valid_580074 = query.getOrDefault("prettyPrint")
  valid_580074 = validateParameter(valid_580074, JBool, required = false,
                                 default = newJBool(true))
  if valid_580074 != nil:
    section.add "prettyPrint", valid_580074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580075: Call_ServicemanagementServicesGetConfig_580058;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a service configuration (version) for a managed service.
  ## 
  let valid = call_580075.validator(path, query, header, formData, body)
  let scheme = call_580075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580075.url(scheme.get, call_580075.host, call_580075.base,
                         call_580075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580075, url, valid)

proc call*(call_580076: Call_ServicemanagementServicesGetConfig_580058;
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
  var path_580077 = newJObject()
  var query_580078 = newJObject()
  add(query_580078, "upload_protocol", newJString(uploadProtocol))
  add(query_580078, "fields", newJString(fields))
  add(query_580078, "view", newJString(view))
  add(query_580078, "quotaUser", newJString(quotaUser))
  add(query_580078, "alt", newJString(alt))
  add(query_580078, "oauth_token", newJString(oauthToken))
  add(query_580078, "callback", newJString(callback))
  add(query_580078, "access_token", newJString(accessToken))
  add(query_580078, "uploadType", newJString(uploadType))
  add(query_580078, "configId", newJString(configId))
  add(query_580078, "key", newJString(key))
  add(query_580078, "$.xgafv", newJString(Xgafv))
  add(query_580078, "prettyPrint", newJBool(prettyPrint))
  add(path_580077, "serviceName", newJString(serviceName))
  result = call_580076.call(path_580077, query_580078, nil, nil, nil)

var servicemanagementServicesGetConfig* = Call_ServicemanagementServicesGetConfig_580058(
    name: "servicemanagementServicesGetConfig", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/config",
    validator: validate_ServicemanagementServicesGetConfig_580059, base: "/",
    url: url_ServicemanagementServicesGetConfig_580060, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConfigsCreate_580100 = ref object of OpenApiRestCall_579421
proc url_ServicemanagementServicesConfigsCreate_580102(protocol: Scheme;
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

proc validate_ServicemanagementServicesConfigsCreate_580101(path: JsonNode;
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
  var valid_580103 = path.getOrDefault("serviceName")
  valid_580103 = validateParameter(valid_580103, JString, required = true,
                                 default = nil)
  if valid_580103 != nil:
    section.add "serviceName", valid_580103
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
  var valid_580104 = query.getOrDefault("upload_protocol")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "upload_protocol", valid_580104
  var valid_580105 = query.getOrDefault("fields")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "fields", valid_580105
  var valid_580106 = query.getOrDefault("quotaUser")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "quotaUser", valid_580106
  var valid_580107 = query.getOrDefault("alt")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = newJString("json"))
  if valid_580107 != nil:
    section.add "alt", valid_580107
  var valid_580108 = query.getOrDefault("oauth_token")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "oauth_token", valid_580108
  var valid_580109 = query.getOrDefault("callback")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "callback", valid_580109
  var valid_580110 = query.getOrDefault("access_token")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "access_token", valid_580110
  var valid_580111 = query.getOrDefault("uploadType")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "uploadType", valid_580111
  var valid_580112 = query.getOrDefault("key")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "key", valid_580112
  var valid_580113 = query.getOrDefault("$.xgafv")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = newJString("1"))
  if valid_580113 != nil:
    section.add "$.xgafv", valid_580113
  var valid_580114 = query.getOrDefault("prettyPrint")
  valid_580114 = validateParameter(valid_580114, JBool, required = false,
                                 default = newJBool(true))
  if valid_580114 != nil:
    section.add "prettyPrint", valid_580114
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

proc call*(call_580116: Call_ServicemanagementServicesConfigsCreate_580100;
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
  let valid = call_580116.validator(path, query, header, formData, body)
  let scheme = call_580116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580116.url(scheme.get, call_580116.host, call_580116.base,
                         call_580116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580116, url, valid)

proc call*(call_580117: Call_ServicemanagementServicesConfigsCreate_580100;
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
  var path_580118 = newJObject()
  var query_580119 = newJObject()
  var body_580120 = newJObject()
  add(query_580119, "upload_protocol", newJString(uploadProtocol))
  add(query_580119, "fields", newJString(fields))
  add(query_580119, "quotaUser", newJString(quotaUser))
  add(query_580119, "alt", newJString(alt))
  add(query_580119, "oauth_token", newJString(oauthToken))
  add(query_580119, "callback", newJString(callback))
  add(query_580119, "access_token", newJString(accessToken))
  add(query_580119, "uploadType", newJString(uploadType))
  add(query_580119, "key", newJString(key))
  add(query_580119, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580120 = body
  add(query_580119, "prettyPrint", newJBool(prettyPrint))
  add(path_580118, "serviceName", newJString(serviceName))
  result = call_580117.call(path_580118, query_580119, nil, nil, body_580120)

var servicemanagementServicesConfigsCreate* = Call_ServicemanagementServicesConfigsCreate_580100(
    name: "servicemanagementServicesConfigsCreate", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/configs",
    validator: validate_ServicemanagementServicesConfigsCreate_580101, base: "/",
    url: url_ServicemanagementServicesConfigsCreate_580102,
    schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConfigsList_580079 = ref object of OpenApiRestCall_579421
proc url_ServicemanagementServicesConfigsList_580081(protocol: Scheme;
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

proc validate_ServicemanagementServicesConfigsList_580080(path: JsonNode;
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
  var valid_580082 = path.getOrDefault("serviceName")
  valid_580082 = validateParameter(valid_580082, JString, required = true,
                                 default = nil)
  if valid_580082 != nil:
    section.add "serviceName", valid_580082
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
  var valid_580083 = query.getOrDefault("upload_protocol")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "upload_protocol", valid_580083
  var valid_580084 = query.getOrDefault("fields")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "fields", valid_580084
  var valid_580085 = query.getOrDefault("pageToken")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "pageToken", valid_580085
  var valid_580086 = query.getOrDefault("quotaUser")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "quotaUser", valid_580086
  var valid_580087 = query.getOrDefault("alt")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = newJString("json"))
  if valid_580087 != nil:
    section.add "alt", valid_580087
  var valid_580088 = query.getOrDefault("oauth_token")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "oauth_token", valid_580088
  var valid_580089 = query.getOrDefault("callback")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "callback", valid_580089
  var valid_580090 = query.getOrDefault("access_token")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "access_token", valid_580090
  var valid_580091 = query.getOrDefault("uploadType")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "uploadType", valid_580091
  var valid_580092 = query.getOrDefault("key")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "key", valid_580092
  var valid_580093 = query.getOrDefault("$.xgafv")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = newJString("1"))
  if valid_580093 != nil:
    section.add "$.xgafv", valid_580093
  var valid_580094 = query.getOrDefault("pageSize")
  valid_580094 = validateParameter(valid_580094, JInt, required = false, default = nil)
  if valid_580094 != nil:
    section.add "pageSize", valid_580094
  var valid_580095 = query.getOrDefault("prettyPrint")
  valid_580095 = validateParameter(valid_580095, JBool, required = false,
                                 default = newJBool(true))
  if valid_580095 != nil:
    section.add "prettyPrint", valid_580095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580096: Call_ServicemanagementServicesConfigsList_580079;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the history of the service configuration for a managed service,
  ## from the newest to the oldest.
  ## 
  let valid = call_580096.validator(path, query, header, formData, body)
  let scheme = call_580096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580096.url(scheme.get, call_580096.host, call_580096.base,
                         call_580096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580096, url, valid)

proc call*(call_580097: Call_ServicemanagementServicesConfigsList_580079;
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
  var path_580098 = newJObject()
  var query_580099 = newJObject()
  add(query_580099, "upload_protocol", newJString(uploadProtocol))
  add(query_580099, "fields", newJString(fields))
  add(query_580099, "pageToken", newJString(pageToken))
  add(query_580099, "quotaUser", newJString(quotaUser))
  add(query_580099, "alt", newJString(alt))
  add(query_580099, "oauth_token", newJString(oauthToken))
  add(query_580099, "callback", newJString(callback))
  add(query_580099, "access_token", newJString(accessToken))
  add(query_580099, "uploadType", newJString(uploadType))
  add(query_580099, "key", newJString(key))
  add(query_580099, "$.xgafv", newJString(Xgafv))
  add(query_580099, "pageSize", newJInt(pageSize))
  add(query_580099, "prettyPrint", newJBool(prettyPrint))
  add(path_580098, "serviceName", newJString(serviceName))
  result = call_580097.call(path_580098, query_580099, nil, nil, nil)

var servicemanagementServicesConfigsList* = Call_ServicemanagementServicesConfigsList_580079(
    name: "servicemanagementServicesConfigsList", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/configs",
    validator: validate_ServicemanagementServicesConfigsList_580080, base: "/",
    url: url_ServicemanagementServicesConfigsList_580081, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConfigsGet_580121 = ref object of OpenApiRestCall_579421
proc url_ServicemanagementServicesConfigsGet_580123(protocol: Scheme; host: string;
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

proc validate_ServicemanagementServicesConfigsGet_580122(path: JsonNode;
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
  var valid_580124 = path.getOrDefault("configId")
  valid_580124 = validateParameter(valid_580124, JString, required = true,
                                 default = nil)
  if valid_580124 != nil:
    section.add "configId", valid_580124
  var valid_580125 = path.getOrDefault("serviceName")
  valid_580125 = validateParameter(valid_580125, JString, required = true,
                                 default = nil)
  if valid_580125 != nil:
    section.add "serviceName", valid_580125
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
  var valid_580126 = query.getOrDefault("upload_protocol")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "upload_protocol", valid_580126
  var valid_580127 = query.getOrDefault("fields")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "fields", valid_580127
  var valid_580128 = query.getOrDefault("view")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_580128 != nil:
    section.add "view", valid_580128
  var valid_580129 = query.getOrDefault("quotaUser")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "quotaUser", valid_580129
  var valid_580130 = query.getOrDefault("alt")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = newJString("json"))
  if valid_580130 != nil:
    section.add "alt", valid_580130
  var valid_580131 = query.getOrDefault("oauth_token")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "oauth_token", valid_580131
  var valid_580132 = query.getOrDefault("callback")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "callback", valid_580132
  var valid_580133 = query.getOrDefault("access_token")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "access_token", valid_580133
  var valid_580134 = query.getOrDefault("uploadType")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "uploadType", valid_580134
  var valid_580135 = query.getOrDefault("key")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "key", valid_580135
  var valid_580136 = query.getOrDefault("$.xgafv")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = newJString("1"))
  if valid_580136 != nil:
    section.add "$.xgafv", valid_580136
  var valid_580137 = query.getOrDefault("prettyPrint")
  valid_580137 = validateParameter(valid_580137, JBool, required = false,
                                 default = newJBool(true))
  if valid_580137 != nil:
    section.add "prettyPrint", valid_580137
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580138: Call_ServicemanagementServicesConfigsGet_580121;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a service configuration (version) for a managed service.
  ## 
  let valid = call_580138.validator(path, query, header, formData, body)
  let scheme = call_580138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580138.url(scheme.get, call_580138.host, call_580138.base,
                         call_580138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580138, url, valid)

proc call*(call_580139: Call_ServicemanagementServicesConfigsGet_580121;
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
  var path_580140 = newJObject()
  var query_580141 = newJObject()
  add(query_580141, "upload_protocol", newJString(uploadProtocol))
  add(query_580141, "fields", newJString(fields))
  add(query_580141, "view", newJString(view))
  add(query_580141, "quotaUser", newJString(quotaUser))
  add(query_580141, "alt", newJString(alt))
  add(query_580141, "oauth_token", newJString(oauthToken))
  add(query_580141, "callback", newJString(callback))
  add(query_580141, "access_token", newJString(accessToken))
  add(query_580141, "uploadType", newJString(uploadType))
  add(query_580141, "key", newJString(key))
  add(path_580140, "configId", newJString(configId))
  add(query_580141, "$.xgafv", newJString(Xgafv))
  add(query_580141, "prettyPrint", newJBool(prettyPrint))
  add(path_580140, "serviceName", newJString(serviceName))
  result = call_580139.call(path_580140, query_580141, nil, nil, nil)

var servicemanagementServicesConfigsGet* = Call_ServicemanagementServicesConfigsGet_580121(
    name: "servicemanagementServicesConfigsGet", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/configs/{configId}",
    validator: validate_ServicemanagementServicesConfigsGet_580122, base: "/",
    url: url_ServicemanagementServicesConfigsGet_580123, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConfigsSubmit_580142 = ref object of OpenApiRestCall_579421
proc url_ServicemanagementServicesConfigsSubmit_580144(protocol: Scheme;
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

proc validate_ServicemanagementServicesConfigsSubmit_580143(path: JsonNode;
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
  var valid_580145 = path.getOrDefault("serviceName")
  valid_580145 = validateParameter(valid_580145, JString, required = true,
                                 default = nil)
  if valid_580145 != nil:
    section.add "serviceName", valid_580145
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
  var valid_580146 = query.getOrDefault("upload_protocol")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "upload_protocol", valid_580146
  var valid_580147 = query.getOrDefault("fields")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "fields", valid_580147
  var valid_580148 = query.getOrDefault("quotaUser")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "quotaUser", valid_580148
  var valid_580149 = query.getOrDefault("alt")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = newJString("json"))
  if valid_580149 != nil:
    section.add "alt", valid_580149
  var valid_580150 = query.getOrDefault("oauth_token")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "oauth_token", valid_580150
  var valid_580151 = query.getOrDefault("callback")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "callback", valid_580151
  var valid_580152 = query.getOrDefault("access_token")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "access_token", valid_580152
  var valid_580153 = query.getOrDefault("uploadType")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "uploadType", valid_580153
  var valid_580154 = query.getOrDefault("key")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "key", valid_580154
  var valid_580155 = query.getOrDefault("$.xgafv")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = newJString("1"))
  if valid_580155 != nil:
    section.add "$.xgafv", valid_580155
  var valid_580156 = query.getOrDefault("prettyPrint")
  valid_580156 = validateParameter(valid_580156, JBool, required = false,
                                 default = newJBool(true))
  if valid_580156 != nil:
    section.add "prettyPrint", valid_580156
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

proc call*(call_580158: Call_ServicemanagementServicesConfigsSubmit_580142;
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
  let valid = call_580158.validator(path, query, header, formData, body)
  let scheme = call_580158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580158.url(scheme.get, call_580158.host, call_580158.base,
                         call_580158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580158, url, valid)

proc call*(call_580159: Call_ServicemanagementServicesConfigsSubmit_580142;
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
  var path_580160 = newJObject()
  var query_580161 = newJObject()
  var body_580162 = newJObject()
  add(query_580161, "upload_protocol", newJString(uploadProtocol))
  add(query_580161, "fields", newJString(fields))
  add(query_580161, "quotaUser", newJString(quotaUser))
  add(query_580161, "alt", newJString(alt))
  add(query_580161, "oauth_token", newJString(oauthToken))
  add(query_580161, "callback", newJString(callback))
  add(query_580161, "access_token", newJString(accessToken))
  add(query_580161, "uploadType", newJString(uploadType))
  add(query_580161, "key", newJString(key))
  add(query_580161, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580162 = body
  add(query_580161, "prettyPrint", newJBool(prettyPrint))
  add(path_580160, "serviceName", newJString(serviceName))
  result = call_580159.call(path_580160, query_580161, nil, nil, body_580162)

var servicemanagementServicesConfigsSubmit* = Call_ServicemanagementServicesConfigsSubmit_580142(
    name: "servicemanagementServicesConfigsSubmit", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/configs:submit",
    validator: validate_ServicemanagementServicesConfigsSubmit_580143, base: "/",
    url: url_ServicemanagementServicesConfigsSubmit_580144,
    schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesRolloutsCreate_580185 = ref object of OpenApiRestCall_579421
proc url_ServicemanagementServicesRolloutsCreate_580187(protocol: Scheme;
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

proc validate_ServicemanagementServicesRolloutsCreate_580186(path: JsonNode;
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
  var valid_580188 = path.getOrDefault("serviceName")
  valid_580188 = validateParameter(valid_580188, JString, required = true,
                                 default = nil)
  if valid_580188 != nil:
    section.add "serviceName", valid_580188
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
  var valid_580189 = query.getOrDefault("upload_protocol")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "upload_protocol", valid_580189
  var valid_580190 = query.getOrDefault("fields")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "fields", valid_580190
  var valid_580191 = query.getOrDefault("quotaUser")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "quotaUser", valid_580191
  var valid_580192 = query.getOrDefault("alt")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = newJString("json"))
  if valid_580192 != nil:
    section.add "alt", valid_580192
  var valid_580193 = query.getOrDefault("baseRolloutId")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "baseRolloutId", valid_580193
  var valid_580194 = query.getOrDefault("oauth_token")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "oauth_token", valid_580194
  var valid_580195 = query.getOrDefault("callback")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "callback", valid_580195
  var valid_580196 = query.getOrDefault("access_token")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "access_token", valid_580196
  var valid_580197 = query.getOrDefault("uploadType")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "uploadType", valid_580197
  var valid_580198 = query.getOrDefault("key")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "key", valid_580198
  var valid_580199 = query.getOrDefault("$.xgafv")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = newJString("1"))
  if valid_580199 != nil:
    section.add "$.xgafv", valid_580199
  var valid_580200 = query.getOrDefault("prettyPrint")
  valid_580200 = validateParameter(valid_580200, JBool, required = false,
                                 default = newJBool(true))
  if valid_580200 != nil:
    section.add "prettyPrint", valid_580200
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

proc call*(call_580202: Call_ServicemanagementServicesRolloutsCreate_580185;
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
  let valid = call_580202.validator(path, query, header, formData, body)
  let scheme = call_580202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580202.url(scheme.get, call_580202.host, call_580202.base,
                         call_580202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580202, url, valid)

proc call*(call_580203: Call_ServicemanagementServicesRolloutsCreate_580185;
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
  var path_580204 = newJObject()
  var query_580205 = newJObject()
  var body_580206 = newJObject()
  add(query_580205, "upload_protocol", newJString(uploadProtocol))
  add(query_580205, "fields", newJString(fields))
  add(query_580205, "quotaUser", newJString(quotaUser))
  add(query_580205, "alt", newJString(alt))
  add(query_580205, "baseRolloutId", newJString(baseRolloutId))
  add(query_580205, "oauth_token", newJString(oauthToken))
  add(query_580205, "callback", newJString(callback))
  add(query_580205, "access_token", newJString(accessToken))
  add(query_580205, "uploadType", newJString(uploadType))
  add(query_580205, "key", newJString(key))
  add(query_580205, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580206 = body
  add(query_580205, "prettyPrint", newJBool(prettyPrint))
  add(path_580204, "serviceName", newJString(serviceName))
  result = call_580203.call(path_580204, query_580205, nil, nil, body_580206)

var servicemanagementServicesRolloutsCreate* = Call_ServicemanagementServicesRolloutsCreate_580185(
    name: "servicemanagementServicesRolloutsCreate", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/rollouts",
    validator: validate_ServicemanagementServicesRolloutsCreate_580186, base: "/",
    url: url_ServicemanagementServicesRolloutsCreate_580187,
    schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesRolloutsList_580163 = ref object of OpenApiRestCall_579421
proc url_ServicemanagementServicesRolloutsList_580165(protocol: Scheme;
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

proc validate_ServicemanagementServicesRolloutsList_580164(path: JsonNode;
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
  var valid_580166 = path.getOrDefault("serviceName")
  valid_580166 = validateParameter(valid_580166, JString, required = true,
                                 default = nil)
  if valid_580166 != nil:
    section.add "serviceName", valid_580166
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
  var valid_580167 = query.getOrDefault("upload_protocol")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "upload_protocol", valid_580167
  var valid_580168 = query.getOrDefault("fields")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "fields", valid_580168
  var valid_580169 = query.getOrDefault("pageToken")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "pageToken", valid_580169
  var valid_580170 = query.getOrDefault("quotaUser")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "quotaUser", valid_580170
  var valid_580171 = query.getOrDefault("alt")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = newJString("json"))
  if valid_580171 != nil:
    section.add "alt", valid_580171
  var valid_580172 = query.getOrDefault("oauth_token")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "oauth_token", valid_580172
  var valid_580173 = query.getOrDefault("callback")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "callback", valid_580173
  var valid_580174 = query.getOrDefault("access_token")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "access_token", valid_580174
  var valid_580175 = query.getOrDefault("uploadType")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "uploadType", valid_580175
  var valid_580176 = query.getOrDefault("key")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "key", valid_580176
  var valid_580177 = query.getOrDefault("$.xgafv")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = newJString("1"))
  if valid_580177 != nil:
    section.add "$.xgafv", valid_580177
  var valid_580178 = query.getOrDefault("pageSize")
  valid_580178 = validateParameter(valid_580178, JInt, required = false, default = nil)
  if valid_580178 != nil:
    section.add "pageSize", valid_580178
  var valid_580179 = query.getOrDefault("prettyPrint")
  valid_580179 = validateParameter(valid_580179, JBool, required = false,
                                 default = newJBool(true))
  if valid_580179 != nil:
    section.add "prettyPrint", valid_580179
  var valid_580180 = query.getOrDefault("filter")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "filter", valid_580180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580181: Call_ServicemanagementServicesRolloutsList_580163;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the history of the service configuration rollouts for a managed
  ## service, from the newest to the oldest.
  ## 
  let valid = call_580181.validator(path, query, header, formData, body)
  let scheme = call_580181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580181.url(scheme.get, call_580181.host, call_580181.base,
                         call_580181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580181, url, valid)

proc call*(call_580182: Call_ServicemanagementServicesRolloutsList_580163;
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
  var path_580183 = newJObject()
  var query_580184 = newJObject()
  add(query_580184, "upload_protocol", newJString(uploadProtocol))
  add(query_580184, "fields", newJString(fields))
  add(query_580184, "pageToken", newJString(pageToken))
  add(query_580184, "quotaUser", newJString(quotaUser))
  add(query_580184, "alt", newJString(alt))
  add(query_580184, "oauth_token", newJString(oauthToken))
  add(query_580184, "callback", newJString(callback))
  add(query_580184, "access_token", newJString(accessToken))
  add(query_580184, "uploadType", newJString(uploadType))
  add(query_580184, "key", newJString(key))
  add(query_580184, "$.xgafv", newJString(Xgafv))
  add(query_580184, "pageSize", newJInt(pageSize))
  add(query_580184, "prettyPrint", newJBool(prettyPrint))
  add(path_580183, "serviceName", newJString(serviceName))
  add(query_580184, "filter", newJString(filter))
  result = call_580182.call(path_580183, query_580184, nil, nil, nil)

var servicemanagementServicesRolloutsList* = Call_ServicemanagementServicesRolloutsList_580163(
    name: "servicemanagementServicesRolloutsList", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/rollouts",
    validator: validate_ServicemanagementServicesRolloutsList_580164, base: "/",
    url: url_ServicemanagementServicesRolloutsList_580165, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesRolloutsGet_580207 = ref object of OpenApiRestCall_579421
proc url_ServicemanagementServicesRolloutsGet_580209(protocol: Scheme;
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

proc validate_ServicemanagementServicesRolloutsGet_580208(path: JsonNode;
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
  var valid_580210 = path.getOrDefault("rolloutId")
  valid_580210 = validateParameter(valid_580210, JString, required = true,
                                 default = nil)
  if valid_580210 != nil:
    section.add "rolloutId", valid_580210
  var valid_580211 = path.getOrDefault("serviceName")
  valid_580211 = validateParameter(valid_580211, JString, required = true,
                                 default = nil)
  if valid_580211 != nil:
    section.add "serviceName", valid_580211
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
  var valid_580212 = query.getOrDefault("upload_protocol")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "upload_protocol", valid_580212
  var valid_580213 = query.getOrDefault("fields")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "fields", valid_580213
  var valid_580214 = query.getOrDefault("quotaUser")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "quotaUser", valid_580214
  var valid_580215 = query.getOrDefault("alt")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = newJString("json"))
  if valid_580215 != nil:
    section.add "alt", valid_580215
  var valid_580216 = query.getOrDefault("oauth_token")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "oauth_token", valid_580216
  var valid_580217 = query.getOrDefault("callback")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "callback", valid_580217
  var valid_580218 = query.getOrDefault("access_token")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "access_token", valid_580218
  var valid_580219 = query.getOrDefault("uploadType")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "uploadType", valid_580219
  var valid_580220 = query.getOrDefault("key")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "key", valid_580220
  var valid_580221 = query.getOrDefault("$.xgafv")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = newJString("1"))
  if valid_580221 != nil:
    section.add "$.xgafv", valid_580221
  var valid_580222 = query.getOrDefault("prettyPrint")
  valid_580222 = validateParameter(valid_580222, JBool, required = false,
                                 default = newJBool(true))
  if valid_580222 != nil:
    section.add "prettyPrint", valid_580222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580223: Call_ServicemanagementServicesRolloutsGet_580207;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a service configuration rollout.
  ## 
  let valid = call_580223.validator(path, query, header, formData, body)
  let scheme = call_580223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580223.url(scheme.get, call_580223.host, call_580223.base,
                         call_580223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580223, url, valid)

proc call*(call_580224: Call_ServicemanagementServicesRolloutsGet_580207;
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
  var path_580225 = newJObject()
  var query_580226 = newJObject()
  add(query_580226, "upload_protocol", newJString(uploadProtocol))
  add(query_580226, "fields", newJString(fields))
  add(query_580226, "quotaUser", newJString(quotaUser))
  add(query_580226, "alt", newJString(alt))
  add(path_580225, "rolloutId", newJString(rolloutId))
  add(query_580226, "oauth_token", newJString(oauthToken))
  add(query_580226, "callback", newJString(callback))
  add(query_580226, "access_token", newJString(accessToken))
  add(query_580226, "uploadType", newJString(uploadType))
  add(query_580226, "key", newJString(key))
  add(query_580226, "$.xgafv", newJString(Xgafv))
  add(query_580226, "prettyPrint", newJBool(prettyPrint))
  add(path_580225, "serviceName", newJString(serviceName))
  result = call_580224.call(path_580225, query_580226, nil, nil, nil)

var servicemanagementServicesRolloutsGet* = Call_ServicemanagementServicesRolloutsGet_580207(
    name: "servicemanagementServicesRolloutsGet", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/rollouts/{rolloutId}",
    validator: validate_ServicemanagementServicesRolloutsGet_580208, base: "/",
    url: url_ServicemanagementServicesRolloutsGet_580209, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesDisable_580227 = ref object of OpenApiRestCall_579421
proc url_ServicemanagementServicesDisable_580229(protocol: Scheme; host: string;
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

proc validate_ServicemanagementServicesDisable_580228(path: JsonNode;
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
  var valid_580230 = path.getOrDefault("serviceName")
  valid_580230 = validateParameter(valid_580230, JString, required = true,
                                 default = nil)
  if valid_580230 != nil:
    section.add "serviceName", valid_580230
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
  var valid_580231 = query.getOrDefault("upload_protocol")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "upload_protocol", valid_580231
  var valid_580232 = query.getOrDefault("fields")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "fields", valid_580232
  var valid_580233 = query.getOrDefault("quotaUser")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "quotaUser", valid_580233
  var valid_580234 = query.getOrDefault("alt")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = newJString("json"))
  if valid_580234 != nil:
    section.add "alt", valid_580234
  var valid_580235 = query.getOrDefault("oauth_token")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "oauth_token", valid_580235
  var valid_580236 = query.getOrDefault("callback")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "callback", valid_580236
  var valid_580237 = query.getOrDefault("access_token")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "access_token", valid_580237
  var valid_580238 = query.getOrDefault("uploadType")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = nil)
  if valid_580238 != nil:
    section.add "uploadType", valid_580238
  var valid_580239 = query.getOrDefault("key")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "key", valid_580239
  var valid_580240 = query.getOrDefault("$.xgafv")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = newJString("1"))
  if valid_580240 != nil:
    section.add "$.xgafv", valid_580240
  var valid_580241 = query.getOrDefault("prettyPrint")
  valid_580241 = validateParameter(valid_580241, JBool, required = false,
                                 default = newJBool(true))
  if valid_580241 != nil:
    section.add "prettyPrint", valid_580241
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

proc call*(call_580243: Call_ServicemanagementServicesDisable_580227;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Disables a service for a project, so it can no longer be
  ## be used for the project. It prevents accidental usage that may cause
  ## unexpected billing charges or security leaks.
  ## 
  ## Operation<response: DisableServiceResponse>
  ## 
  let valid = call_580243.validator(path, query, header, formData, body)
  let scheme = call_580243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580243.url(scheme.get, call_580243.host, call_580243.base,
                         call_580243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580243, url, valid)

proc call*(call_580244: Call_ServicemanagementServicesDisable_580227;
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
  var path_580245 = newJObject()
  var query_580246 = newJObject()
  var body_580247 = newJObject()
  add(query_580246, "upload_protocol", newJString(uploadProtocol))
  add(query_580246, "fields", newJString(fields))
  add(query_580246, "quotaUser", newJString(quotaUser))
  add(query_580246, "alt", newJString(alt))
  add(query_580246, "oauth_token", newJString(oauthToken))
  add(query_580246, "callback", newJString(callback))
  add(query_580246, "access_token", newJString(accessToken))
  add(query_580246, "uploadType", newJString(uploadType))
  add(query_580246, "key", newJString(key))
  add(query_580246, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580247 = body
  add(query_580246, "prettyPrint", newJBool(prettyPrint))
  add(path_580245, "serviceName", newJString(serviceName))
  result = call_580244.call(path_580245, query_580246, nil, nil, body_580247)

var servicemanagementServicesDisable* = Call_ServicemanagementServicesDisable_580227(
    name: "servicemanagementServicesDisable", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}:disable",
    validator: validate_ServicemanagementServicesDisable_580228, base: "/",
    url: url_ServicemanagementServicesDisable_580229, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesEnable_580248 = ref object of OpenApiRestCall_579421
proc url_ServicemanagementServicesEnable_580250(protocol: Scheme; host: string;
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

proc validate_ServicemanagementServicesEnable_580249(path: JsonNode;
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
  var valid_580251 = path.getOrDefault("serviceName")
  valid_580251 = validateParameter(valid_580251, JString, required = true,
                                 default = nil)
  if valid_580251 != nil:
    section.add "serviceName", valid_580251
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
  var valid_580252 = query.getOrDefault("upload_protocol")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "upload_protocol", valid_580252
  var valid_580253 = query.getOrDefault("fields")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "fields", valid_580253
  var valid_580254 = query.getOrDefault("quotaUser")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "quotaUser", valid_580254
  var valid_580255 = query.getOrDefault("alt")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = newJString("json"))
  if valid_580255 != nil:
    section.add "alt", valid_580255
  var valid_580256 = query.getOrDefault("oauth_token")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "oauth_token", valid_580256
  var valid_580257 = query.getOrDefault("callback")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "callback", valid_580257
  var valid_580258 = query.getOrDefault("access_token")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "access_token", valid_580258
  var valid_580259 = query.getOrDefault("uploadType")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "uploadType", valid_580259
  var valid_580260 = query.getOrDefault("key")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "key", valid_580260
  var valid_580261 = query.getOrDefault("$.xgafv")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = newJString("1"))
  if valid_580261 != nil:
    section.add "$.xgafv", valid_580261
  var valid_580262 = query.getOrDefault("prettyPrint")
  valid_580262 = validateParameter(valid_580262, JBool, required = false,
                                 default = newJBool(true))
  if valid_580262 != nil:
    section.add "prettyPrint", valid_580262
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

proc call*(call_580264: Call_ServicemanagementServicesEnable_580248;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables a service for a project, so it can be used
  ## for the project. See
  ## [Cloud Auth Guide](https://cloud.google.com/docs/authentication) for
  ## more information.
  ## 
  ## Operation<response: EnableServiceResponse>
  ## 
  let valid = call_580264.validator(path, query, header, formData, body)
  let scheme = call_580264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580264.url(scheme.get, call_580264.host, call_580264.base,
                         call_580264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580264, url, valid)

proc call*(call_580265: Call_ServicemanagementServicesEnable_580248;
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
  var path_580266 = newJObject()
  var query_580267 = newJObject()
  var body_580268 = newJObject()
  add(query_580267, "upload_protocol", newJString(uploadProtocol))
  add(query_580267, "fields", newJString(fields))
  add(query_580267, "quotaUser", newJString(quotaUser))
  add(query_580267, "alt", newJString(alt))
  add(query_580267, "oauth_token", newJString(oauthToken))
  add(query_580267, "callback", newJString(callback))
  add(query_580267, "access_token", newJString(accessToken))
  add(query_580267, "uploadType", newJString(uploadType))
  add(query_580267, "key", newJString(key))
  add(query_580267, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580268 = body
  add(query_580267, "prettyPrint", newJBool(prettyPrint))
  add(path_580266, "serviceName", newJString(serviceName))
  result = call_580265.call(path_580266, query_580267, nil, nil, body_580268)

var servicemanagementServicesEnable* = Call_ServicemanagementServicesEnable_580248(
    name: "servicemanagementServicesEnable", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}:enable",
    validator: validate_ServicemanagementServicesEnable_580249, base: "/",
    url: url_ServicemanagementServicesEnable_580250, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesUndelete_580269 = ref object of OpenApiRestCall_579421
proc url_ServicemanagementServicesUndelete_580271(protocol: Scheme; host: string;
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

proc validate_ServicemanagementServicesUndelete_580270(path: JsonNode;
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
  var valid_580272 = path.getOrDefault("serviceName")
  valid_580272 = validateParameter(valid_580272, JString, required = true,
                                 default = nil)
  if valid_580272 != nil:
    section.add "serviceName", valid_580272
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
  var valid_580273 = query.getOrDefault("upload_protocol")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "upload_protocol", valid_580273
  var valid_580274 = query.getOrDefault("fields")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "fields", valid_580274
  var valid_580275 = query.getOrDefault("quotaUser")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = nil)
  if valid_580275 != nil:
    section.add "quotaUser", valid_580275
  var valid_580276 = query.getOrDefault("alt")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = newJString("json"))
  if valid_580276 != nil:
    section.add "alt", valid_580276
  var valid_580277 = query.getOrDefault("oauth_token")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "oauth_token", valid_580277
  var valid_580278 = query.getOrDefault("callback")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "callback", valid_580278
  var valid_580279 = query.getOrDefault("access_token")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "access_token", valid_580279
  var valid_580280 = query.getOrDefault("uploadType")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "uploadType", valid_580280
  var valid_580281 = query.getOrDefault("key")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "key", valid_580281
  var valid_580282 = query.getOrDefault("$.xgafv")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = newJString("1"))
  if valid_580282 != nil:
    section.add "$.xgafv", valid_580282
  var valid_580283 = query.getOrDefault("prettyPrint")
  valid_580283 = validateParameter(valid_580283, JBool, required = false,
                                 default = newJBool(true))
  if valid_580283 != nil:
    section.add "prettyPrint", valid_580283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580284: Call_ServicemanagementServicesUndelete_580269;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Revives a previously deleted managed service. The method restores the
  ## service using the configuration at the time the service was deleted.
  ## The target service must exist and must have been deleted within the
  ## last 30 days.
  ## 
  ## Operation<response: UndeleteServiceResponse>
  ## 
  let valid = call_580284.validator(path, query, header, formData, body)
  let scheme = call_580284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580284.url(scheme.get, call_580284.host, call_580284.base,
                         call_580284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580284, url, valid)

proc call*(call_580285: Call_ServicemanagementServicesUndelete_580269;
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
  var path_580286 = newJObject()
  var query_580287 = newJObject()
  add(query_580287, "upload_protocol", newJString(uploadProtocol))
  add(query_580287, "fields", newJString(fields))
  add(query_580287, "quotaUser", newJString(quotaUser))
  add(query_580287, "alt", newJString(alt))
  add(query_580287, "oauth_token", newJString(oauthToken))
  add(query_580287, "callback", newJString(callback))
  add(query_580287, "access_token", newJString(accessToken))
  add(query_580287, "uploadType", newJString(uploadType))
  add(query_580287, "key", newJString(key))
  add(query_580287, "$.xgafv", newJString(Xgafv))
  add(query_580287, "prettyPrint", newJBool(prettyPrint))
  add(path_580286, "serviceName", newJString(serviceName))
  result = call_580285.call(path_580286, query_580287, nil, nil, nil)

var servicemanagementServicesUndelete* = Call_ServicemanagementServicesUndelete_580269(
    name: "servicemanagementServicesUndelete", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}:undelete",
    validator: validate_ServicemanagementServicesUndelete_580270, base: "/",
    url: url_ServicemanagementServicesUndelete_580271, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesGenerateConfigReport_580288 = ref object of OpenApiRestCall_579421
proc url_ServicemanagementServicesGenerateConfigReport_580290(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ServicemanagementServicesGenerateConfigReport_580289(
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
  var valid_580291 = query.getOrDefault("upload_protocol")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "upload_protocol", valid_580291
  var valid_580292 = query.getOrDefault("fields")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = nil)
  if valid_580292 != nil:
    section.add "fields", valid_580292
  var valid_580293 = query.getOrDefault("quotaUser")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "quotaUser", valid_580293
  var valid_580294 = query.getOrDefault("alt")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = newJString("json"))
  if valid_580294 != nil:
    section.add "alt", valid_580294
  var valid_580295 = query.getOrDefault("oauth_token")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "oauth_token", valid_580295
  var valid_580296 = query.getOrDefault("callback")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = nil)
  if valid_580296 != nil:
    section.add "callback", valid_580296
  var valid_580297 = query.getOrDefault("access_token")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "access_token", valid_580297
  var valid_580298 = query.getOrDefault("uploadType")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = nil)
  if valid_580298 != nil:
    section.add "uploadType", valid_580298
  var valid_580299 = query.getOrDefault("key")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = nil)
  if valid_580299 != nil:
    section.add "key", valid_580299
  var valid_580300 = query.getOrDefault("$.xgafv")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = newJString("1"))
  if valid_580300 != nil:
    section.add "$.xgafv", valid_580300
  var valid_580301 = query.getOrDefault("prettyPrint")
  valid_580301 = validateParameter(valid_580301, JBool, required = false,
                                 default = newJBool(true))
  if valid_580301 != nil:
    section.add "prettyPrint", valid_580301
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

proc call*(call_580303: Call_ServicemanagementServicesGenerateConfigReport_580288;
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
  let valid = call_580303.validator(path, query, header, formData, body)
  let scheme = call_580303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580303.url(scheme.get, call_580303.host, call_580303.base,
                         call_580303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580303, url, valid)

proc call*(call_580304: Call_ServicemanagementServicesGenerateConfigReport_580288;
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
  var query_580305 = newJObject()
  var body_580306 = newJObject()
  add(query_580305, "upload_protocol", newJString(uploadProtocol))
  add(query_580305, "fields", newJString(fields))
  add(query_580305, "quotaUser", newJString(quotaUser))
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
  result = call_580304.call(nil, query_580305, nil, nil, body_580306)

var servicemanagementServicesGenerateConfigReport* = Call_ServicemanagementServicesGenerateConfigReport_580288(
    name: "servicemanagementServicesGenerateConfigReport",
    meth: HttpMethod.HttpPost, host: "servicemanagement.googleapis.com",
    route: "/v1/services:generateConfigReport",
    validator: validate_ServicemanagementServicesGenerateConfigReport_580289,
    base: "/", url: url_ServicemanagementServicesGenerateConfigReport_580290,
    schemes: {Scheme.Https})
type
  Call_ServicemanagementOperationsGet_580307 = ref object of OpenApiRestCall_579421
proc url_ServicemanagementOperationsGet_580309(protocol: Scheme; host: string;
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

proc validate_ServicemanagementOperationsGet_580308(path: JsonNode;
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
  if body != nil:
    result.add "body", body

proc call*(call_580322: Call_ServicemanagementOperationsGet_580307; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_580322.validator(path, query, header, formData, body)
  let scheme = call_580322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580322.url(scheme.get, call_580322.host, call_580322.base,
                         call_580322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580322, url, valid)

proc call*(call_580323: Call_ServicemanagementOperationsGet_580307; name: string;
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
  var path_580324 = newJObject()
  var query_580325 = newJObject()
  add(query_580325, "upload_protocol", newJString(uploadProtocol))
  add(query_580325, "fields", newJString(fields))
  add(query_580325, "quotaUser", newJString(quotaUser))
  add(path_580324, "name", newJString(name))
  add(query_580325, "alt", newJString(alt))
  add(query_580325, "oauth_token", newJString(oauthToken))
  add(query_580325, "callback", newJString(callback))
  add(query_580325, "access_token", newJString(accessToken))
  add(query_580325, "uploadType", newJString(uploadType))
  add(query_580325, "key", newJString(key))
  add(query_580325, "$.xgafv", newJString(Xgafv))
  add(query_580325, "prettyPrint", newJBool(prettyPrint))
  result = call_580323.call(path_580324, query_580325, nil, nil, nil)

var servicemanagementOperationsGet* = Call_ServicemanagementOperationsGet_580307(
    name: "servicemanagementOperationsGet", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com", route: "/v1/{name}",
    validator: validate_ServicemanagementOperationsGet_580308, base: "/",
    url: url_ServicemanagementOperationsGet_580309, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConsumersGetIamPolicy_580326 = ref object of OpenApiRestCall_579421
proc url_ServicemanagementServicesConsumersGetIamPolicy_580328(protocol: Scheme;
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

proc validate_ServicemanagementServicesConsumersGetIamPolicy_580327(
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
  var valid_580329 = path.getOrDefault("resource")
  valid_580329 = validateParameter(valid_580329, JString, required = true,
                                 default = nil)
  if valid_580329 != nil:
    section.add "resource", valid_580329
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
  var valid_580330 = query.getOrDefault("upload_protocol")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = nil)
  if valid_580330 != nil:
    section.add "upload_protocol", valid_580330
  var valid_580331 = query.getOrDefault("fields")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "fields", valid_580331
  var valid_580332 = query.getOrDefault("quotaUser")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = nil)
  if valid_580332 != nil:
    section.add "quotaUser", valid_580332
  var valid_580333 = query.getOrDefault("alt")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = newJString("json"))
  if valid_580333 != nil:
    section.add "alt", valid_580333
  var valid_580334 = query.getOrDefault("oauth_token")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = nil)
  if valid_580334 != nil:
    section.add "oauth_token", valid_580334
  var valid_580335 = query.getOrDefault("callback")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = nil)
  if valid_580335 != nil:
    section.add "callback", valid_580335
  var valid_580336 = query.getOrDefault("access_token")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "access_token", valid_580336
  var valid_580337 = query.getOrDefault("uploadType")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "uploadType", valid_580337
  var valid_580338 = query.getOrDefault("key")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "key", valid_580338
  var valid_580339 = query.getOrDefault("$.xgafv")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = newJString("1"))
  if valid_580339 != nil:
    section.add "$.xgafv", valid_580339
  var valid_580340 = query.getOrDefault("prettyPrint")
  valid_580340 = validateParameter(valid_580340, JBool, required = false,
                                 default = newJBool(true))
  if valid_580340 != nil:
    section.add "prettyPrint", valid_580340
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

proc call*(call_580342: Call_ServicemanagementServicesConsumersGetIamPolicy_580326;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_580342.validator(path, query, header, formData, body)
  let scheme = call_580342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580342.url(scheme.get, call_580342.host, call_580342.base,
                         call_580342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580342, url, valid)

proc call*(call_580343: Call_ServicemanagementServicesConsumersGetIamPolicy_580326;
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
  var path_580344 = newJObject()
  var query_580345 = newJObject()
  var body_580346 = newJObject()
  add(query_580345, "upload_protocol", newJString(uploadProtocol))
  add(query_580345, "fields", newJString(fields))
  add(query_580345, "quotaUser", newJString(quotaUser))
  add(query_580345, "alt", newJString(alt))
  add(query_580345, "oauth_token", newJString(oauthToken))
  add(query_580345, "callback", newJString(callback))
  add(query_580345, "access_token", newJString(accessToken))
  add(query_580345, "uploadType", newJString(uploadType))
  add(query_580345, "key", newJString(key))
  add(query_580345, "$.xgafv", newJString(Xgafv))
  add(path_580344, "resource", newJString(resource))
  if body != nil:
    body_580346 = body
  add(query_580345, "prettyPrint", newJBool(prettyPrint))
  result = call_580343.call(path_580344, query_580345, nil, nil, body_580346)

var servicemanagementServicesConsumersGetIamPolicy* = Call_ServicemanagementServicesConsumersGetIamPolicy_580326(
    name: "servicemanagementServicesConsumersGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "servicemanagement.googleapis.com",
    route: "/v1/{resource}:getIamPolicy",
    validator: validate_ServicemanagementServicesConsumersGetIamPolicy_580327,
    base: "/", url: url_ServicemanagementServicesConsumersGetIamPolicy_580328,
    schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConsumersSetIamPolicy_580347 = ref object of OpenApiRestCall_579421
proc url_ServicemanagementServicesConsumersSetIamPolicy_580349(protocol: Scheme;
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

proc validate_ServicemanagementServicesConsumersSetIamPolicy_580348(
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
  var valid_580350 = path.getOrDefault("resource")
  valid_580350 = validateParameter(valid_580350, JString, required = true,
                                 default = nil)
  if valid_580350 != nil:
    section.add "resource", valid_580350
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
  var valid_580351 = query.getOrDefault("upload_protocol")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "upload_protocol", valid_580351
  var valid_580352 = query.getOrDefault("fields")
  valid_580352 = validateParameter(valid_580352, JString, required = false,
                                 default = nil)
  if valid_580352 != nil:
    section.add "fields", valid_580352
  var valid_580353 = query.getOrDefault("quotaUser")
  valid_580353 = validateParameter(valid_580353, JString, required = false,
                                 default = nil)
  if valid_580353 != nil:
    section.add "quotaUser", valid_580353
  var valid_580354 = query.getOrDefault("alt")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = newJString("json"))
  if valid_580354 != nil:
    section.add "alt", valid_580354
  var valid_580355 = query.getOrDefault("oauth_token")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "oauth_token", valid_580355
  var valid_580356 = query.getOrDefault("callback")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = nil)
  if valid_580356 != nil:
    section.add "callback", valid_580356
  var valid_580357 = query.getOrDefault("access_token")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = nil)
  if valid_580357 != nil:
    section.add "access_token", valid_580357
  var valid_580358 = query.getOrDefault("uploadType")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = nil)
  if valid_580358 != nil:
    section.add "uploadType", valid_580358
  var valid_580359 = query.getOrDefault("key")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = nil)
  if valid_580359 != nil:
    section.add "key", valid_580359
  var valid_580360 = query.getOrDefault("$.xgafv")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = newJString("1"))
  if valid_580360 != nil:
    section.add "$.xgafv", valid_580360
  var valid_580361 = query.getOrDefault("prettyPrint")
  valid_580361 = validateParameter(valid_580361, JBool, required = false,
                                 default = newJBool(true))
  if valid_580361 != nil:
    section.add "prettyPrint", valid_580361
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

proc call*(call_580363: Call_ServicemanagementServicesConsumersSetIamPolicy_580347;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_580363.validator(path, query, header, formData, body)
  let scheme = call_580363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580363.url(scheme.get, call_580363.host, call_580363.base,
                         call_580363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580363, url, valid)

proc call*(call_580364: Call_ServicemanagementServicesConsumersSetIamPolicy_580347;
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
  var path_580365 = newJObject()
  var query_580366 = newJObject()
  var body_580367 = newJObject()
  add(query_580366, "upload_protocol", newJString(uploadProtocol))
  add(query_580366, "fields", newJString(fields))
  add(query_580366, "quotaUser", newJString(quotaUser))
  add(query_580366, "alt", newJString(alt))
  add(query_580366, "oauth_token", newJString(oauthToken))
  add(query_580366, "callback", newJString(callback))
  add(query_580366, "access_token", newJString(accessToken))
  add(query_580366, "uploadType", newJString(uploadType))
  add(query_580366, "key", newJString(key))
  add(query_580366, "$.xgafv", newJString(Xgafv))
  add(path_580365, "resource", newJString(resource))
  if body != nil:
    body_580367 = body
  add(query_580366, "prettyPrint", newJBool(prettyPrint))
  result = call_580364.call(path_580365, query_580366, nil, nil, body_580367)

var servicemanagementServicesConsumersSetIamPolicy* = Call_ServicemanagementServicesConsumersSetIamPolicy_580347(
    name: "servicemanagementServicesConsumersSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "servicemanagement.googleapis.com",
    route: "/v1/{resource}:setIamPolicy",
    validator: validate_ServicemanagementServicesConsumersSetIamPolicy_580348,
    base: "/", url: url_ServicemanagementServicesConsumersSetIamPolicy_580349,
    schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConsumersTestIamPermissions_580368 = ref object of OpenApiRestCall_579421
proc url_ServicemanagementServicesConsumersTestIamPermissions_580370(
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

proc validate_ServicemanagementServicesConsumersTestIamPermissions_580369(
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
  var valid_580371 = path.getOrDefault("resource")
  valid_580371 = validateParameter(valid_580371, JString, required = true,
                                 default = nil)
  if valid_580371 != nil:
    section.add "resource", valid_580371
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
  var valid_580372 = query.getOrDefault("upload_protocol")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = nil)
  if valid_580372 != nil:
    section.add "upload_protocol", valid_580372
  var valid_580373 = query.getOrDefault("fields")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = nil)
  if valid_580373 != nil:
    section.add "fields", valid_580373
  var valid_580374 = query.getOrDefault("quotaUser")
  valid_580374 = validateParameter(valid_580374, JString, required = false,
                                 default = nil)
  if valid_580374 != nil:
    section.add "quotaUser", valid_580374
  var valid_580375 = query.getOrDefault("alt")
  valid_580375 = validateParameter(valid_580375, JString, required = false,
                                 default = newJString("json"))
  if valid_580375 != nil:
    section.add "alt", valid_580375
  var valid_580376 = query.getOrDefault("oauth_token")
  valid_580376 = validateParameter(valid_580376, JString, required = false,
                                 default = nil)
  if valid_580376 != nil:
    section.add "oauth_token", valid_580376
  var valid_580377 = query.getOrDefault("callback")
  valid_580377 = validateParameter(valid_580377, JString, required = false,
                                 default = nil)
  if valid_580377 != nil:
    section.add "callback", valid_580377
  var valid_580378 = query.getOrDefault("access_token")
  valid_580378 = validateParameter(valid_580378, JString, required = false,
                                 default = nil)
  if valid_580378 != nil:
    section.add "access_token", valid_580378
  var valid_580379 = query.getOrDefault("uploadType")
  valid_580379 = validateParameter(valid_580379, JString, required = false,
                                 default = nil)
  if valid_580379 != nil:
    section.add "uploadType", valid_580379
  var valid_580380 = query.getOrDefault("key")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = nil)
  if valid_580380 != nil:
    section.add "key", valid_580380
  var valid_580381 = query.getOrDefault("$.xgafv")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = newJString("1"))
  if valid_580381 != nil:
    section.add "$.xgafv", valid_580381
  var valid_580382 = query.getOrDefault("prettyPrint")
  valid_580382 = validateParameter(valid_580382, JBool, required = false,
                                 default = newJBool(true))
  if valid_580382 != nil:
    section.add "prettyPrint", valid_580382
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

proc call*(call_580384: Call_ServicemanagementServicesConsumersTestIamPermissions_580368;
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
  let valid = call_580384.validator(path, query, header, formData, body)
  let scheme = call_580384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580384.url(scheme.get, call_580384.host, call_580384.base,
                         call_580384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580384, url, valid)

proc call*(call_580385: Call_ServicemanagementServicesConsumersTestIamPermissions_580368;
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
  var path_580386 = newJObject()
  var query_580387 = newJObject()
  var body_580388 = newJObject()
  add(query_580387, "upload_protocol", newJString(uploadProtocol))
  add(query_580387, "fields", newJString(fields))
  add(query_580387, "quotaUser", newJString(quotaUser))
  add(query_580387, "alt", newJString(alt))
  add(query_580387, "oauth_token", newJString(oauthToken))
  add(query_580387, "callback", newJString(callback))
  add(query_580387, "access_token", newJString(accessToken))
  add(query_580387, "uploadType", newJString(uploadType))
  add(query_580387, "key", newJString(key))
  add(query_580387, "$.xgafv", newJString(Xgafv))
  add(path_580386, "resource", newJString(resource))
  if body != nil:
    body_580388 = body
  add(query_580387, "prettyPrint", newJBool(prettyPrint))
  result = call_580385.call(path_580386, query_580387, nil, nil, body_580388)

var servicemanagementServicesConsumersTestIamPermissions* = Call_ServicemanagementServicesConsumersTestIamPermissions_580368(
    name: "servicemanagementServicesConsumersTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "servicemanagement.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_ServicemanagementServicesConsumersTestIamPermissions_580369,
    base: "/", url: url_ServicemanagementServicesConsumersTestIamPermissions_580370,
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
