
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  gcpServiceName = "servicemanagement"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServicemanagementOperationsList_593690 = ref object of OpenApiRestCall_593421
proc url_ServicemanagementOperationsList_593692(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ServicemanagementOperationsList_593691(path: JsonNode;
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
  var valid_593806 = query.getOrDefault("pageToken")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "pageToken", valid_593806
  var valid_593807 = query.getOrDefault("quotaUser")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "quotaUser", valid_593807
  var valid_593821 = query.getOrDefault("alt")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = newJString("json"))
  if valid_593821 != nil:
    section.add "alt", valid_593821
  var valid_593822 = query.getOrDefault("oauth_token")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "oauth_token", valid_593822
  var valid_593823 = query.getOrDefault("callback")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "callback", valid_593823
  var valid_593824 = query.getOrDefault("access_token")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "access_token", valid_593824
  var valid_593825 = query.getOrDefault("uploadType")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "uploadType", valid_593825
  var valid_593826 = query.getOrDefault("key")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = nil)
  if valid_593826 != nil:
    section.add "key", valid_593826
  var valid_593827 = query.getOrDefault("name")
  valid_593827 = validateParameter(valid_593827, JString, required = false,
                                 default = nil)
  if valid_593827 != nil:
    section.add "name", valid_593827
  var valid_593828 = query.getOrDefault("$.xgafv")
  valid_593828 = validateParameter(valid_593828, JString, required = false,
                                 default = newJString("1"))
  if valid_593828 != nil:
    section.add "$.xgafv", valid_593828
  var valid_593829 = query.getOrDefault("pageSize")
  valid_593829 = validateParameter(valid_593829, JInt, required = false, default = nil)
  if valid_593829 != nil:
    section.add "pageSize", valid_593829
  var valid_593830 = query.getOrDefault("prettyPrint")
  valid_593830 = validateParameter(valid_593830, JBool, required = false,
                                 default = newJBool(true))
  if valid_593830 != nil:
    section.add "prettyPrint", valid_593830
  var valid_593831 = query.getOrDefault("filter")
  valid_593831 = validateParameter(valid_593831, JString, required = false,
                                 default = nil)
  if valid_593831 != nil:
    section.add "filter", valid_593831
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593854: Call_ServicemanagementOperationsList_593690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists service operations that match the specified filter in the request.
  ## 
  let valid = call_593854.validator(path, query, header, formData, body)
  let scheme = call_593854.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593854.url(scheme.get, call_593854.host, call_593854.base,
                         call_593854.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593854, url, valid)

proc call*(call_593925: Call_ServicemanagementOperationsList_593690;
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
  var query_593926 = newJObject()
  add(query_593926, "upload_protocol", newJString(uploadProtocol))
  add(query_593926, "fields", newJString(fields))
  add(query_593926, "pageToken", newJString(pageToken))
  add(query_593926, "quotaUser", newJString(quotaUser))
  add(query_593926, "alt", newJString(alt))
  add(query_593926, "oauth_token", newJString(oauthToken))
  add(query_593926, "callback", newJString(callback))
  add(query_593926, "access_token", newJString(accessToken))
  add(query_593926, "uploadType", newJString(uploadType))
  add(query_593926, "key", newJString(key))
  add(query_593926, "name", newJString(name))
  add(query_593926, "$.xgafv", newJString(Xgafv))
  add(query_593926, "pageSize", newJInt(pageSize))
  add(query_593926, "prettyPrint", newJBool(prettyPrint))
  add(query_593926, "filter", newJString(filter))
  result = call_593925.call(nil, query_593926, nil, nil, nil)

var servicemanagementOperationsList* = Call_ServicemanagementOperationsList_593690(
    name: "servicemanagementOperationsList", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com", route: "/v1/operations",
    validator: validate_ServicemanagementOperationsList_593691, base: "/",
    url: url_ServicemanagementOperationsList_593692, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesCreate_593987 = ref object of OpenApiRestCall_593421
proc url_ServicemanagementServicesCreate_593989(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ServicemanagementServicesCreate_593988(path: JsonNode;
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
  var valid_593990 = query.getOrDefault("upload_protocol")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "upload_protocol", valid_593990
  var valid_593991 = query.getOrDefault("fields")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "fields", valid_593991
  var valid_593992 = query.getOrDefault("quotaUser")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "quotaUser", valid_593992
  var valid_593993 = query.getOrDefault("alt")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = newJString("json"))
  if valid_593993 != nil:
    section.add "alt", valid_593993
  var valid_593994 = query.getOrDefault("oauth_token")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "oauth_token", valid_593994
  var valid_593995 = query.getOrDefault("callback")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "callback", valid_593995
  var valid_593996 = query.getOrDefault("access_token")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "access_token", valid_593996
  var valid_593997 = query.getOrDefault("uploadType")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "uploadType", valid_593997
  var valid_593998 = query.getOrDefault("key")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = nil)
  if valid_593998 != nil:
    section.add "key", valid_593998
  var valid_593999 = query.getOrDefault("$.xgafv")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = newJString("1"))
  if valid_593999 != nil:
    section.add "$.xgafv", valid_593999
  var valid_594000 = query.getOrDefault("prettyPrint")
  valid_594000 = validateParameter(valid_594000, JBool, required = false,
                                 default = newJBool(true))
  if valid_594000 != nil:
    section.add "prettyPrint", valid_594000
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

proc call*(call_594002: Call_ServicemanagementServicesCreate_593987;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new managed service.
  ## Please note one producer project can own no more than 20 services.
  ## 
  ## Operation<response: ManagedService>
  ## 
  let valid = call_594002.validator(path, query, header, formData, body)
  let scheme = call_594002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594002.url(scheme.get, call_594002.host, call_594002.base,
                         call_594002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594002, url, valid)

proc call*(call_594003: Call_ServicemanagementServicesCreate_593987;
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
  var query_594004 = newJObject()
  var body_594005 = newJObject()
  add(query_594004, "upload_protocol", newJString(uploadProtocol))
  add(query_594004, "fields", newJString(fields))
  add(query_594004, "quotaUser", newJString(quotaUser))
  add(query_594004, "alt", newJString(alt))
  add(query_594004, "oauth_token", newJString(oauthToken))
  add(query_594004, "callback", newJString(callback))
  add(query_594004, "access_token", newJString(accessToken))
  add(query_594004, "uploadType", newJString(uploadType))
  add(query_594004, "key", newJString(key))
  add(query_594004, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594005 = body
  add(query_594004, "prettyPrint", newJBool(prettyPrint))
  result = call_594003.call(nil, query_594004, nil, nil, body_594005)

var servicemanagementServicesCreate* = Call_ServicemanagementServicesCreate_593987(
    name: "servicemanagementServicesCreate", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com", route: "/v1/services",
    validator: validate_ServicemanagementServicesCreate_593988, base: "/",
    url: url_ServicemanagementServicesCreate_593989, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesList_593966 = ref object of OpenApiRestCall_593421
proc url_ServicemanagementServicesList_593968(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ServicemanagementServicesList_593967(path: JsonNode; query: JsonNode;
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
  var valid_593969 = query.getOrDefault("upload_protocol")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = nil)
  if valid_593969 != nil:
    section.add "upload_protocol", valid_593969
  var valid_593970 = query.getOrDefault("fields")
  valid_593970 = validateParameter(valid_593970, JString, required = false,
                                 default = nil)
  if valid_593970 != nil:
    section.add "fields", valid_593970
  var valid_593971 = query.getOrDefault("pageToken")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "pageToken", valid_593971
  var valid_593972 = query.getOrDefault("quotaUser")
  valid_593972 = validateParameter(valid_593972, JString, required = false,
                                 default = nil)
  if valid_593972 != nil:
    section.add "quotaUser", valid_593972
  var valid_593973 = query.getOrDefault("alt")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = newJString("json"))
  if valid_593973 != nil:
    section.add "alt", valid_593973
  var valid_593974 = query.getOrDefault("oauth_token")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = nil)
  if valid_593974 != nil:
    section.add "oauth_token", valid_593974
  var valid_593975 = query.getOrDefault("callback")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "callback", valid_593975
  var valid_593976 = query.getOrDefault("access_token")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "access_token", valid_593976
  var valid_593977 = query.getOrDefault("uploadType")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "uploadType", valid_593977
  var valid_593978 = query.getOrDefault("consumerId")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = nil)
  if valid_593978 != nil:
    section.add "consumerId", valid_593978
  var valid_593979 = query.getOrDefault("key")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = nil)
  if valid_593979 != nil:
    section.add "key", valid_593979
  var valid_593980 = query.getOrDefault("producerProjectId")
  valid_593980 = validateParameter(valid_593980, JString, required = false,
                                 default = nil)
  if valid_593980 != nil:
    section.add "producerProjectId", valid_593980
  var valid_593981 = query.getOrDefault("$.xgafv")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = newJString("1"))
  if valid_593981 != nil:
    section.add "$.xgafv", valid_593981
  var valid_593982 = query.getOrDefault("pageSize")
  valid_593982 = validateParameter(valid_593982, JInt, required = false, default = nil)
  if valid_593982 != nil:
    section.add "pageSize", valid_593982
  var valid_593983 = query.getOrDefault("prettyPrint")
  valid_593983 = validateParameter(valid_593983, JBool, required = false,
                                 default = newJBool(true))
  if valid_593983 != nil:
    section.add "prettyPrint", valid_593983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593984: Call_ServicemanagementServicesList_593966; path: JsonNode;
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
  let valid = call_593984.validator(path, query, header, formData, body)
  let scheme = call_593984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593984.url(scheme.get, call_593984.host, call_593984.base,
                         call_593984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593984, url, valid)

proc call*(call_593985: Call_ServicemanagementServicesList_593966;
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
  var query_593986 = newJObject()
  add(query_593986, "upload_protocol", newJString(uploadProtocol))
  add(query_593986, "fields", newJString(fields))
  add(query_593986, "pageToken", newJString(pageToken))
  add(query_593986, "quotaUser", newJString(quotaUser))
  add(query_593986, "alt", newJString(alt))
  add(query_593986, "oauth_token", newJString(oauthToken))
  add(query_593986, "callback", newJString(callback))
  add(query_593986, "access_token", newJString(accessToken))
  add(query_593986, "uploadType", newJString(uploadType))
  add(query_593986, "consumerId", newJString(consumerId))
  add(query_593986, "key", newJString(key))
  add(query_593986, "producerProjectId", newJString(producerProjectId))
  add(query_593986, "$.xgafv", newJString(Xgafv))
  add(query_593986, "pageSize", newJInt(pageSize))
  add(query_593986, "prettyPrint", newJBool(prettyPrint))
  result = call_593985.call(nil, query_593986, nil, nil, nil)

var servicemanagementServicesList* = Call_ServicemanagementServicesList_593966(
    name: "servicemanagementServicesList", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com", route: "/v1/services",
    validator: validate_ServicemanagementServicesList_593967, base: "/",
    url: url_ServicemanagementServicesList_593968, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesGet_594006 = ref object of OpenApiRestCall_593421
proc url_ServicemanagementServicesGet_594008(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/services/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicemanagementServicesGet_594007(path: JsonNode; query: JsonNode;
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
  var valid_594023 = path.getOrDefault("serviceName")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "serviceName", valid_594023
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
  var valid_594024 = query.getOrDefault("upload_protocol")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "upload_protocol", valid_594024
  var valid_594025 = query.getOrDefault("fields")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "fields", valid_594025
  var valid_594026 = query.getOrDefault("quotaUser")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "quotaUser", valid_594026
  var valid_594027 = query.getOrDefault("alt")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = newJString("json"))
  if valid_594027 != nil:
    section.add "alt", valid_594027
  var valid_594028 = query.getOrDefault("oauth_token")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "oauth_token", valid_594028
  var valid_594029 = query.getOrDefault("callback")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "callback", valid_594029
  var valid_594030 = query.getOrDefault("access_token")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "access_token", valid_594030
  var valid_594031 = query.getOrDefault("uploadType")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "uploadType", valid_594031
  var valid_594032 = query.getOrDefault("key")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "key", valid_594032
  var valid_594033 = query.getOrDefault("$.xgafv")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = newJString("1"))
  if valid_594033 != nil:
    section.add "$.xgafv", valid_594033
  var valid_594034 = query.getOrDefault("prettyPrint")
  valid_594034 = validateParameter(valid_594034, JBool, required = false,
                                 default = newJBool(true))
  if valid_594034 != nil:
    section.add "prettyPrint", valid_594034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594035: Call_ServicemanagementServicesGet_594006; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a managed service. Authentication is required unless the service is
  ## public.
  ## 
  let valid = call_594035.validator(path, query, header, formData, body)
  let scheme = call_594035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594035.url(scheme.get, call_594035.host, call_594035.base,
                         call_594035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594035, url, valid)

proc call*(call_594036: Call_ServicemanagementServicesGet_594006;
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
  var path_594037 = newJObject()
  var query_594038 = newJObject()
  add(query_594038, "upload_protocol", newJString(uploadProtocol))
  add(query_594038, "fields", newJString(fields))
  add(query_594038, "quotaUser", newJString(quotaUser))
  add(query_594038, "alt", newJString(alt))
  add(query_594038, "oauth_token", newJString(oauthToken))
  add(query_594038, "callback", newJString(callback))
  add(query_594038, "access_token", newJString(accessToken))
  add(query_594038, "uploadType", newJString(uploadType))
  add(query_594038, "key", newJString(key))
  add(query_594038, "$.xgafv", newJString(Xgafv))
  add(query_594038, "prettyPrint", newJBool(prettyPrint))
  add(path_594037, "serviceName", newJString(serviceName))
  result = call_594036.call(path_594037, query_594038, nil, nil, nil)

var servicemanagementServicesGet* = Call_ServicemanagementServicesGet_594006(
    name: "servicemanagementServicesGet", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com", route: "/v1/services/{serviceName}",
    validator: validate_ServicemanagementServicesGet_594007, base: "/",
    url: url_ServicemanagementServicesGet_594008, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesDelete_594039 = ref object of OpenApiRestCall_593421
proc url_ServicemanagementServicesDelete_594041(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/services/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicemanagementServicesDelete_594040(path: JsonNode;
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
  var valid_594042 = path.getOrDefault("serviceName")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "serviceName", valid_594042
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
  var valid_594043 = query.getOrDefault("upload_protocol")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "upload_protocol", valid_594043
  var valid_594044 = query.getOrDefault("fields")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "fields", valid_594044
  var valid_594045 = query.getOrDefault("quotaUser")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = nil)
  if valid_594045 != nil:
    section.add "quotaUser", valid_594045
  var valid_594046 = query.getOrDefault("alt")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = newJString("json"))
  if valid_594046 != nil:
    section.add "alt", valid_594046
  var valid_594047 = query.getOrDefault("oauth_token")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = nil)
  if valid_594047 != nil:
    section.add "oauth_token", valid_594047
  var valid_594048 = query.getOrDefault("callback")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "callback", valid_594048
  var valid_594049 = query.getOrDefault("access_token")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = nil)
  if valid_594049 != nil:
    section.add "access_token", valid_594049
  var valid_594050 = query.getOrDefault("uploadType")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "uploadType", valid_594050
  var valid_594051 = query.getOrDefault("key")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "key", valid_594051
  var valid_594052 = query.getOrDefault("$.xgafv")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = newJString("1"))
  if valid_594052 != nil:
    section.add "$.xgafv", valid_594052
  var valid_594053 = query.getOrDefault("prettyPrint")
  valid_594053 = validateParameter(valid_594053, JBool, required = false,
                                 default = newJBool(true))
  if valid_594053 != nil:
    section.add "prettyPrint", valid_594053
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594054: Call_ServicemanagementServicesDelete_594039;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a managed service. This method will change the service to the
  ## `Soft-Delete` state for 30 days. Within this period, service producers may
  ## call UndeleteService to restore the service.
  ## After 30 days, the service will be permanently deleted.
  ## 
  ## Operation<response: google.protobuf.Empty>
  ## 
  let valid = call_594054.validator(path, query, header, formData, body)
  let scheme = call_594054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594054.url(scheme.get, call_594054.host, call_594054.base,
                         call_594054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594054, url, valid)

proc call*(call_594055: Call_ServicemanagementServicesDelete_594039;
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
  var path_594056 = newJObject()
  var query_594057 = newJObject()
  add(query_594057, "upload_protocol", newJString(uploadProtocol))
  add(query_594057, "fields", newJString(fields))
  add(query_594057, "quotaUser", newJString(quotaUser))
  add(query_594057, "alt", newJString(alt))
  add(query_594057, "oauth_token", newJString(oauthToken))
  add(query_594057, "callback", newJString(callback))
  add(query_594057, "access_token", newJString(accessToken))
  add(query_594057, "uploadType", newJString(uploadType))
  add(query_594057, "key", newJString(key))
  add(query_594057, "$.xgafv", newJString(Xgafv))
  add(query_594057, "prettyPrint", newJBool(prettyPrint))
  add(path_594056, "serviceName", newJString(serviceName))
  result = call_594055.call(path_594056, query_594057, nil, nil, nil)

var servicemanagementServicesDelete* = Call_ServicemanagementServicesDelete_594039(
    name: "servicemanagementServicesDelete", meth: HttpMethod.HttpDelete,
    host: "servicemanagement.googleapis.com", route: "/v1/services/{serviceName}",
    validator: validate_ServicemanagementServicesDelete_594040, base: "/",
    url: url_ServicemanagementServicesDelete_594041, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesGetConfig_594058 = ref object of OpenApiRestCall_593421
proc url_ServicemanagementServicesGetConfig_594060(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServicemanagementServicesGetConfig_594059(path: JsonNode;
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
  var valid_594061 = path.getOrDefault("serviceName")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "serviceName", valid_594061
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
  var valid_594062 = query.getOrDefault("upload_protocol")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "upload_protocol", valid_594062
  var valid_594063 = query.getOrDefault("fields")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = nil)
  if valid_594063 != nil:
    section.add "fields", valid_594063
  var valid_594064 = query.getOrDefault("view")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_594064 != nil:
    section.add "view", valid_594064
  var valid_594065 = query.getOrDefault("quotaUser")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "quotaUser", valid_594065
  var valid_594066 = query.getOrDefault("alt")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = newJString("json"))
  if valid_594066 != nil:
    section.add "alt", valid_594066
  var valid_594067 = query.getOrDefault("oauth_token")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = nil)
  if valid_594067 != nil:
    section.add "oauth_token", valid_594067
  var valid_594068 = query.getOrDefault("callback")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = nil)
  if valid_594068 != nil:
    section.add "callback", valid_594068
  var valid_594069 = query.getOrDefault("access_token")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "access_token", valid_594069
  var valid_594070 = query.getOrDefault("uploadType")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "uploadType", valid_594070
  var valid_594071 = query.getOrDefault("configId")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "configId", valid_594071
  var valid_594072 = query.getOrDefault("key")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = nil)
  if valid_594072 != nil:
    section.add "key", valid_594072
  var valid_594073 = query.getOrDefault("$.xgafv")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = newJString("1"))
  if valid_594073 != nil:
    section.add "$.xgafv", valid_594073
  var valid_594074 = query.getOrDefault("prettyPrint")
  valid_594074 = validateParameter(valid_594074, JBool, required = false,
                                 default = newJBool(true))
  if valid_594074 != nil:
    section.add "prettyPrint", valid_594074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594075: Call_ServicemanagementServicesGetConfig_594058;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a service configuration (version) for a managed service.
  ## 
  let valid = call_594075.validator(path, query, header, formData, body)
  let scheme = call_594075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594075.url(scheme.get, call_594075.host, call_594075.base,
                         call_594075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594075, url, valid)

proc call*(call_594076: Call_ServicemanagementServicesGetConfig_594058;
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
  var path_594077 = newJObject()
  var query_594078 = newJObject()
  add(query_594078, "upload_protocol", newJString(uploadProtocol))
  add(query_594078, "fields", newJString(fields))
  add(query_594078, "view", newJString(view))
  add(query_594078, "quotaUser", newJString(quotaUser))
  add(query_594078, "alt", newJString(alt))
  add(query_594078, "oauth_token", newJString(oauthToken))
  add(query_594078, "callback", newJString(callback))
  add(query_594078, "access_token", newJString(accessToken))
  add(query_594078, "uploadType", newJString(uploadType))
  add(query_594078, "configId", newJString(configId))
  add(query_594078, "key", newJString(key))
  add(query_594078, "$.xgafv", newJString(Xgafv))
  add(query_594078, "prettyPrint", newJBool(prettyPrint))
  add(path_594077, "serviceName", newJString(serviceName))
  result = call_594076.call(path_594077, query_594078, nil, nil, nil)

var servicemanagementServicesGetConfig* = Call_ServicemanagementServicesGetConfig_594058(
    name: "servicemanagementServicesGetConfig", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/config",
    validator: validate_ServicemanagementServicesGetConfig_594059, base: "/",
    url: url_ServicemanagementServicesGetConfig_594060, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConfigsCreate_594100 = ref object of OpenApiRestCall_593421
proc url_ServicemanagementServicesConfigsCreate_594102(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServicemanagementServicesConfigsCreate_594101(path: JsonNode;
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
  var valid_594103 = path.getOrDefault("serviceName")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "serviceName", valid_594103
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
  var valid_594104 = query.getOrDefault("upload_protocol")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = nil)
  if valid_594104 != nil:
    section.add "upload_protocol", valid_594104
  var valid_594105 = query.getOrDefault("fields")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "fields", valid_594105
  var valid_594106 = query.getOrDefault("quotaUser")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = nil)
  if valid_594106 != nil:
    section.add "quotaUser", valid_594106
  var valid_594107 = query.getOrDefault("alt")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = newJString("json"))
  if valid_594107 != nil:
    section.add "alt", valid_594107
  var valid_594108 = query.getOrDefault("oauth_token")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = nil)
  if valid_594108 != nil:
    section.add "oauth_token", valid_594108
  var valid_594109 = query.getOrDefault("callback")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = nil)
  if valid_594109 != nil:
    section.add "callback", valid_594109
  var valid_594110 = query.getOrDefault("access_token")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = nil)
  if valid_594110 != nil:
    section.add "access_token", valid_594110
  var valid_594111 = query.getOrDefault("uploadType")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = nil)
  if valid_594111 != nil:
    section.add "uploadType", valid_594111
  var valid_594112 = query.getOrDefault("key")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = nil)
  if valid_594112 != nil:
    section.add "key", valid_594112
  var valid_594113 = query.getOrDefault("$.xgafv")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = newJString("1"))
  if valid_594113 != nil:
    section.add "$.xgafv", valid_594113
  var valid_594114 = query.getOrDefault("prettyPrint")
  valid_594114 = validateParameter(valid_594114, JBool, required = false,
                                 default = newJBool(true))
  if valid_594114 != nil:
    section.add "prettyPrint", valid_594114
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

proc call*(call_594116: Call_ServicemanagementServicesConfigsCreate_594100;
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
  let valid = call_594116.validator(path, query, header, formData, body)
  let scheme = call_594116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594116.url(scheme.get, call_594116.host, call_594116.base,
                         call_594116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594116, url, valid)

proc call*(call_594117: Call_ServicemanagementServicesConfigsCreate_594100;
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
  var path_594118 = newJObject()
  var query_594119 = newJObject()
  var body_594120 = newJObject()
  add(query_594119, "upload_protocol", newJString(uploadProtocol))
  add(query_594119, "fields", newJString(fields))
  add(query_594119, "quotaUser", newJString(quotaUser))
  add(query_594119, "alt", newJString(alt))
  add(query_594119, "oauth_token", newJString(oauthToken))
  add(query_594119, "callback", newJString(callback))
  add(query_594119, "access_token", newJString(accessToken))
  add(query_594119, "uploadType", newJString(uploadType))
  add(query_594119, "key", newJString(key))
  add(query_594119, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594120 = body
  add(query_594119, "prettyPrint", newJBool(prettyPrint))
  add(path_594118, "serviceName", newJString(serviceName))
  result = call_594117.call(path_594118, query_594119, nil, nil, body_594120)

var servicemanagementServicesConfigsCreate* = Call_ServicemanagementServicesConfigsCreate_594100(
    name: "servicemanagementServicesConfigsCreate", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/configs",
    validator: validate_ServicemanagementServicesConfigsCreate_594101, base: "/",
    url: url_ServicemanagementServicesConfigsCreate_594102,
    schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConfigsList_594079 = ref object of OpenApiRestCall_593421
proc url_ServicemanagementServicesConfigsList_594081(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServicemanagementServicesConfigsList_594080(path: JsonNode;
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
  var valid_594082 = path.getOrDefault("serviceName")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "serviceName", valid_594082
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
  var valid_594083 = query.getOrDefault("upload_protocol")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "upload_protocol", valid_594083
  var valid_594084 = query.getOrDefault("fields")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "fields", valid_594084
  var valid_594085 = query.getOrDefault("pageToken")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "pageToken", valid_594085
  var valid_594086 = query.getOrDefault("quotaUser")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "quotaUser", valid_594086
  var valid_594087 = query.getOrDefault("alt")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = newJString("json"))
  if valid_594087 != nil:
    section.add "alt", valid_594087
  var valid_594088 = query.getOrDefault("oauth_token")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = nil)
  if valid_594088 != nil:
    section.add "oauth_token", valid_594088
  var valid_594089 = query.getOrDefault("callback")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = nil)
  if valid_594089 != nil:
    section.add "callback", valid_594089
  var valid_594090 = query.getOrDefault("access_token")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "access_token", valid_594090
  var valid_594091 = query.getOrDefault("uploadType")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "uploadType", valid_594091
  var valid_594092 = query.getOrDefault("key")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "key", valid_594092
  var valid_594093 = query.getOrDefault("$.xgafv")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = newJString("1"))
  if valid_594093 != nil:
    section.add "$.xgafv", valid_594093
  var valid_594094 = query.getOrDefault("pageSize")
  valid_594094 = validateParameter(valid_594094, JInt, required = false, default = nil)
  if valid_594094 != nil:
    section.add "pageSize", valid_594094
  var valid_594095 = query.getOrDefault("prettyPrint")
  valid_594095 = validateParameter(valid_594095, JBool, required = false,
                                 default = newJBool(true))
  if valid_594095 != nil:
    section.add "prettyPrint", valid_594095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594096: Call_ServicemanagementServicesConfigsList_594079;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the history of the service configuration for a managed service,
  ## from the newest to the oldest.
  ## 
  let valid = call_594096.validator(path, query, header, formData, body)
  let scheme = call_594096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594096.url(scheme.get, call_594096.host, call_594096.base,
                         call_594096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594096, url, valid)

proc call*(call_594097: Call_ServicemanagementServicesConfigsList_594079;
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
  var path_594098 = newJObject()
  var query_594099 = newJObject()
  add(query_594099, "upload_protocol", newJString(uploadProtocol))
  add(query_594099, "fields", newJString(fields))
  add(query_594099, "pageToken", newJString(pageToken))
  add(query_594099, "quotaUser", newJString(quotaUser))
  add(query_594099, "alt", newJString(alt))
  add(query_594099, "oauth_token", newJString(oauthToken))
  add(query_594099, "callback", newJString(callback))
  add(query_594099, "access_token", newJString(accessToken))
  add(query_594099, "uploadType", newJString(uploadType))
  add(query_594099, "key", newJString(key))
  add(query_594099, "$.xgafv", newJString(Xgafv))
  add(query_594099, "pageSize", newJInt(pageSize))
  add(query_594099, "prettyPrint", newJBool(prettyPrint))
  add(path_594098, "serviceName", newJString(serviceName))
  result = call_594097.call(path_594098, query_594099, nil, nil, nil)

var servicemanagementServicesConfigsList* = Call_ServicemanagementServicesConfigsList_594079(
    name: "servicemanagementServicesConfigsList", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/configs",
    validator: validate_ServicemanagementServicesConfigsList_594080, base: "/",
    url: url_ServicemanagementServicesConfigsList_594081, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConfigsGet_594121 = ref object of OpenApiRestCall_593421
proc url_ServicemanagementServicesConfigsGet_594123(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServicemanagementServicesConfigsGet_594122(path: JsonNode;
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
  var valid_594124 = path.getOrDefault("configId")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "configId", valid_594124
  var valid_594125 = path.getOrDefault("serviceName")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "serviceName", valid_594125
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
  var valid_594126 = query.getOrDefault("upload_protocol")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = nil)
  if valid_594126 != nil:
    section.add "upload_protocol", valid_594126
  var valid_594127 = query.getOrDefault("fields")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "fields", valid_594127
  var valid_594128 = query.getOrDefault("view")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_594128 != nil:
    section.add "view", valid_594128
  var valid_594129 = query.getOrDefault("quotaUser")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = nil)
  if valid_594129 != nil:
    section.add "quotaUser", valid_594129
  var valid_594130 = query.getOrDefault("alt")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = newJString("json"))
  if valid_594130 != nil:
    section.add "alt", valid_594130
  var valid_594131 = query.getOrDefault("oauth_token")
  valid_594131 = validateParameter(valid_594131, JString, required = false,
                                 default = nil)
  if valid_594131 != nil:
    section.add "oauth_token", valid_594131
  var valid_594132 = query.getOrDefault("callback")
  valid_594132 = validateParameter(valid_594132, JString, required = false,
                                 default = nil)
  if valid_594132 != nil:
    section.add "callback", valid_594132
  var valid_594133 = query.getOrDefault("access_token")
  valid_594133 = validateParameter(valid_594133, JString, required = false,
                                 default = nil)
  if valid_594133 != nil:
    section.add "access_token", valid_594133
  var valid_594134 = query.getOrDefault("uploadType")
  valid_594134 = validateParameter(valid_594134, JString, required = false,
                                 default = nil)
  if valid_594134 != nil:
    section.add "uploadType", valid_594134
  var valid_594135 = query.getOrDefault("key")
  valid_594135 = validateParameter(valid_594135, JString, required = false,
                                 default = nil)
  if valid_594135 != nil:
    section.add "key", valid_594135
  var valid_594136 = query.getOrDefault("$.xgafv")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = newJString("1"))
  if valid_594136 != nil:
    section.add "$.xgafv", valid_594136
  var valid_594137 = query.getOrDefault("prettyPrint")
  valid_594137 = validateParameter(valid_594137, JBool, required = false,
                                 default = newJBool(true))
  if valid_594137 != nil:
    section.add "prettyPrint", valid_594137
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594138: Call_ServicemanagementServicesConfigsGet_594121;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a service configuration (version) for a managed service.
  ## 
  let valid = call_594138.validator(path, query, header, formData, body)
  let scheme = call_594138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594138.url(scheme.get, call_594138.host, call_594138.base,
                         call_594138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594138, url, valid)

proc call*(call_594139: Call_ServicemanagementServicesConfigsGet_594121;
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
  var path_594140 = newJObject()
  var query_594141 = newJObject()
  add(query_594141, "upload_protocol", newJString(uploadProtocol))
  add(query_594141, "fields", newJString(fields))
  add(query_594141, "view", newJString(view))
  add(query_594141, "quotaUser", newJString(quotaUser))
  add(query_594141, "alt", newJString(alt))
  add(query_594141, "oauth_token", newJString(oauthToken))
  add(query_594141, "callback", newJString(callback))
  add(query_594141, "access_token", newJString(accessToken))
  add(query_594141, "uploadType", newJString(uploadType))
  add(query_594141, "key", newJString(key))
  add(path_594140, "configId", newJString(configId))
  add(query_594141, "$.xgafv", newJString(Xgafv))
  add(query_594141, "prettyPrint", newJBool(prettyPrint))
  add(path_594140, "serviceName", newJString(serviceName))
  result = call_594139.call(path_594140, query_594141, nil, nil, nil)

var servicemanagementServicesConfigsGet* = Call_ServicemanagementServicesConfigsGet_594121(
    name: "servicemanagementServicesConfigsGet", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/configs/{configId}",
    validator: validate_ServicemanagementServicesConfigsGet_594122, base: "/",
    url: url_ServicemanagementServicesConfigsGet_594123, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConfigsSubmit_594142 = ref object of OpenApiRestCall_593421
proc url_ServicemanagementServicesConfigsSubmit_594144(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServicemanagementServicesConfigsSubmit_594143(path: JsonNode;
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
  var valid_594145 = path.getOrDefault("serviceName")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "serviceName", valid_594145
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
  var valid_594146 = query.getOrDefault("upload_protocol")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = nil)
  if valid_594146 != nil:
    section.add "upload_protocol", valid_594146
  var valid_594147 = query.getOrDefault("fields")
  valid_594147 = validateParameter(valid_594147, JString, required = false,
                                 default = nil)
  if valid_594147 != nil:
    section.add "fields", valid_594147
  var valid_594148 = query.getOrDefault("quotaUser")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = nil)
  if valid_594148 != nil:
    section.add "quotaUser", valid_594148
  var valid_594149 = query.getOrDefault("alt")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = newJString("json"))
  if valid_594149 != nil:
    section.add "alt", valid_594149
  var valid_594150 = query.getOrDefault("oauth_token")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = nil)
  if valid_594150 != nil:
    section.add "oauth_token", valid_594150
  var valid_594151 = query.getOrDefault("callback")
  valid_594151 = validateParameter(valid_594151, JString, required = false,
                                 default = nil)
  if valid_594151 != nil:
    section.add "callback", valid_594151
  var valid_594152 = query.getOrDefault("access_token")
  valid_594152 = validateParameter(valid_594152, JString, required = false,
                                 default = nil)
  if valid_594152 != nil:
    section.add "access_token", valid_594152
  var valid_594153 = query.getOrDefault("uploadType")
  valid_594153 = validateParameter(valid_594153, JString, required = false,
                                 default = nil)
  if valid_594153 != nil:
    section.add "uploadType", valid_594153
  var valid_594154 = query.getOrDefault("key")
  valid_594154 = validateParameter(valid_594154, JString, required = false,
                                 default = nil)
  if valid_594154 != nil:
    section.add "key", valid_594154
  var valid_594155 = query.getOrDefault("$.xgafv")
  valid_594155 = validateParameter(valid_594155, JString, required = false,
                                 default = newJString("1"))
  if valid_594155 != nil:
    section.add "$.xgafv", valid_594155
  var valid_594156 = query.getOrDefault("prettyPrint")
  valid_594156 = validateParameter(valid_594156, JBool, required = false,
                                 default = newJBool(true))
  if valid_594156 != nil:
    section.add "prettyPrint", valid_594156
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

proc call*(call_594158: Call_ServicemanagementServicesConfigsSubmit_594142;
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
  let valid = call_594158.validator(path, query, header, formData, body)
  let scheme = call_594158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594158.url(scheme.get, call_594158.host, call_594158.base,
                         call_594158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594158, url, valid)

proc call*(call_594159: Call_ServicemanagementServicesConfigsSubmit_594142;
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
  var path_594160 = newJObject()
  var query_594161 = newJObject()
  var body_594162 = newJObject()
  add(query_594161, "upload_protocol", newJString(uploadProtocol))
  add(query_594161, "fields", newJString(fields))
  add(query_594161, "quotaUser", newJString(quotaUser))
  add(query_594161, "alt", newJString(alt))
  add(query_594161, "oauth_token", newJString(oauthToken))
  add(query_594161, "callback", newJString(callback))
  add(query_594161, "access_token", newJString(accessToken))
  add(query_594161, "uploadType", newJString(uploadType))
  add(query_594161, "key", newJString(key))
  add(query_594161, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594162 = body
  add(query_594161, "prettyPrint", newJBool(prettyPrint))
  add(path_594160, "serviceName", newJString(serviceName))
  result = call_594159.call(path_594160, query_594161, nil, nil, body_594162)

var servicemanagementServicesConfigsSubmit* = Call_ServicemanagementServicesConfigsSubmit_594142(
    name: "servicemanagementServicesConfigsSubmit", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/configs:submit",
    validator: validate_ServicemanagementServicesConfigsSubmit_594143, base: "/",
    url: url_ServicemanagementServicesConfigsSubmit_594144,
    schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesRolloutsCreate_594185 = ref object of OpenApiRestCall_593421
proc url_ServicemanagementServicesRolloutsCreate_594187(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServicemanagementServicesRolloutsCreate_594186(path: JsonNode;
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
  var valid_594188 = path.getOrDefault("serviceName")
  valid_594188 = validateParameter(valid_594188, JString, required = true,
                                 default = nil)
  if valid_594188 != nil:
    section.add "serviceName", valid_594188
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
  var valid_594189 = query.getOrDefault("upload_protocol")
  valid_594189 = validateParameter(valid_594189, JString, required = false,
                                 default = nil)
  if valid_594189 != nil:
    section.add "upload_protocol", valid_594189
  var valid_594190 = query.getOrDefault("fields")
  valid_594190 = validateParameter(valid_594190, JString, required = false,
                                 default = nil)
  if valid_594190 != nil:
    section.add "fields", valid_594190
  var valid_594191 = query.getOrDefault("quotaUser")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = nil)
  if valid_594191 != nil:
    section.add "quotaUser", valid_594191
  var valid_594192 = query.getOrDefault("alt")
  valid_594192 = validateParameter(valid_594192, JString, required = false,
                                 default = newJString("json"))
  if valid_594192 != nil:
    section.add "alt", valid_594192
  var valid_594193 = query.getOrDefault("baseRolloutId")
  valid_594193 = validateParameter(valid_594193, JString, required = false,
                                 default = nil)
  if valid_594193 != nil:
    section.add "baseRolloutId", valid_594193
  var valid_594194 = query.getOrDefault("oauth_token")
  valid_594194 = validateParameter(valid_594194, JString, required = false,
                                 default = nil)
  if valid_594194 != nil:
    section.add "oauth_token", valid_594194
  var valid_594195 = query.getOrDefault("callback")
  valid_594195 = validateParameter(valid_594195, JString, required = false,
                                 default = nil)
  if valid_594195 != nil:
    section.add "callback", valid_594195
  var valid_594196 = query.getOrDefault("access_token")
  valid_594196 = validateParameter(valid_594196, JString, required = false,
                                 default = nil)
  if valid_594196 != nil:
    section.add "access_token", valid_594196
  var valid_594197 = query.getOrDefault("uploadType")
  valid_594197 = validateParameter(valid_594197, JString, required = false,
                                 default = nil)
  if valid_594197 != nil:
    section.add "uploadType", valid_594197
  var valid_594198 = query.getOrDefault("key")
  valid_594198 = validateParameter(valid_594198, JString, required = false,
                                 default = nil)
  if valid_594198 != nil:
    section.add "key", valid_594198
  var valid_594199 = query.getOrDefault("$.xgafv")
  valid_594199 = validateParameter(valid_594199, JString, required = false,
                                 default = newJString("1"))
  if valid_594199 != nil:
    section.add "$.xgafv", valid_594199
  var valid_594200 = query.getOrDefault("prettyPrint")
  valid_594200 = validateParameter(valid_594200, JBool, required = false,
                                 default = newJBool(true))
  if valid_594200 != nil:
    section.add "prettyPrint", valid_594200
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

proc call*(call_594202: Call_ServicemanagementServicesRolloutsCreate_594185;
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
  let valid = call_594202.validator(path, query, header, formData, body)
  let scheme = call_594202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594202.url(scheme.get, call_594202.host, call_594202.base,
                         call_594202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594202, url, valid)

proc call*(call_594203: Call_ServicemanagementServicesRolloutsCreate_594185;
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
  var path_594204 = newJObject()
  var query_594205 = newJObject()
  var body_594206 = newJObject()
  add(query_594205, "upload_protocol", newJString(uploadProtocol))
  add(query_594205, "fields", newJString(fields))
  add(query_594205, "quotaUser", newJString(quotaUser))
  add(query_594205, "alt", newJString(alt))
  add(query_594205, "baseRolloutId", newJString(baseRolloutId))
  add(query_594205, "oauth_token", newJString(oauthToken))
  add(query_594205, "callback", newJString(callback))
  add(query_594205, "access_token", newJString(accessToken))
  add(query_594205, "uploadType", newJString(uploadType))
  add(query_594205, "key", newJString(key))
  add(query_594205, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594206 = body
  add(query_594205, "prettyPrint", newJBool(prettyPrint))
  add(path_594204, "serviceName", newJString(serviceName))
  result = call_594203.call(path_594204, query_594205, nil, nil, body_594206)

var servicemanagementServicesRolloutsCreate* = Call_ServicemanagementServicesRolloutsCreate_594185(
    name: "servicemanagementServicesRolloutsCreate", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/rollouts",
    validator: validate_ServicemanagementServicesRolloutsCreate_594186, base: "/",
    url: url_ServicemanagementServicesRolloutsCreate_594187,
    schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesRolloutsList_594163 = ref object of OpenApiRestCall_593421
proc url_ServicemanagementServicesRolloutsList_594165(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServicemanagementServicesRolloutsList_594164(path: JsonNode;
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
  var valid_594166 = path.getOrDefault("serviceName")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "serviceName", valid_594166
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
  var valid_594167 = query.getOrDefault("upload_protocol")
  valid_594167 = validateParameter(valid_594167, JString, required = false,
                                 default = nil)
  if valid_594167 != nil:
    section.add "upload_protocol", valid_594167
  var valid_594168 = query.getOrDefault("fields")
  valid_594168 = validateParameter(valid_594168, JString, required = false,
                                 default = nil)
  if valid_594168 != nil:
    section.add "fields", valid_594168
  var valid_594169 = query.getOrDefault("pageToken")
  valid_594169 = validateParameter(valid_594169, JString, required = false,
                                 default = nil)
  if valid_594169 != nil:
    section.add "pageToken", valid_594169
  var valid_594170 = query.getOrDefault("quotaUser")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = nil)
  if valid_594170 != nil:
    section.add "quotaUser", valid_594170
  var valid_594171 = query.getOrDefault("alt")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = newJString("json"))
  if valid_594171 != nil:
    section.add "alt", valid_594171
  var valid_594172 = query.getOrDefault("oauth_token")
  valid_594172 = validateParameter(valid_594172, JString, required = false,
                                 default = nil)
  if valid_594172 != nil:
    section.add "oauth_token", valid_594172
  var valid_594173 = query.getOrDefault("callback")
  valid_594173 = validateParameter(valid_594173, JString, required = false,
                                 default = nil)
  if valid_594173 != nil:
    section.add "callback", valid_594173
  var valid_594174 = query.getOrDefault("access_token")
  valid_594174 = validateParameter(valid_594174, JString, required = false,
                                 default = nil)
  if valid_594174 != nil:
    section.add "access_token", valid_594174
  var valid_594175 = query.getOrDefault("uploadType")
  valid_594175 = validateParameter(valid_594175, JString, required = false,
                                 default = nil)
  if valid_594175 != nil:
    section.add "uploadType", valid_594175
  var valid_594176 = query.getOrDefault("key")
  valid_594176 = validateParameter(valid_594176, JString, required = false,
                                 default = nil)
  if valid_594176 != nil:
    section.add "key", valid_594176
  var valid_594177 = query.getOrDefault("$.xgafv")
  valid_594177 = validateParameter(valid_594177, JString, required = false,
                                 default = newJString("1"))
  if valid_594177 != nil:
    section.add "$.xgafv", valid_594177
  var valid_594178 = query.getOrDefault("pageSize")
  valid_594178 = validateParameter(valid_594178, JInt, required = false, default = nil)
  if valid_594178 != nil:
    section.add "pageSize", valid_594178
  var valid_594179 = query.getOrDefault("prettyPrint")
  valid_594179 = validateParameter(valid_594179, JBool, required = false,
                                 default = newJBool(true))
  if valid_594179 != nil:
    section.add "prettyPrint", valid_594179
  var valid_594180 = query.getOrDefault("filter")
  valid_594180 = validateParameter(valid_594180, JString, required = false,
                                 default = nil)
  if valid_594180 != nil:
    section.add "filter", valid_594180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594181: Call_ServicemanagementServicesRolloutsList_594163;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the history of the service configuration rollouts for a managed
  ## service, from the newest to the oldest.
  ## 
  let valid = call_594181.validator(path, query, header, formData, body)
  let scheme = call_594181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594181.url(scheme.get, call_594181.host, call_594181.base,
                         call_594181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594181, url, valid)

proc call*(call_594182: Call_ServicemanagementServicesRolloutsList_594163;
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
  var path_594183 = newJObject()
  var query_594184 = newJObject()
  add(query_594184, "upload_protocol", newJString(uploadProtocol))
  add(query_594184, "fields", newJString(fields))
  add(query_594184, "pageToken", newJString(pageToken))
  add(query_594184, "quotaUser", newJString(quotaUser))
  add(query_594184, "alt", newJString(alt))
  add(query_594184, "oauth_token", newJString(oauthToken))
  add(query_594184, "callback", newJString(callback))
  add(query_594184, "access_token", newJString(accessToken))
  add(query_594184, "uploadType", newJString(uploadType))
  add(query_594184, "key", newJString(key))
  add(query_594184, "$.xgafv", newJString(Xgafv))
  add(query_594184, "pageSize", newJInt(pageSize))
  add(query_594184, "prettyPrint", newJBool(prettyPrint))
  add(path_594183, "serviceName", newJString(serviceName))
  add(query_594184, "filter", newJString(filter))
  result = call_594182.call(path_594183, query_594184, nil, nil, nil)

var servicemanagementServicesRolloutsList* = Call_ServicemanagementServicesRolloutsList_594163(
    name: "servicemanagementServicesRolloutsList", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/rollouts",
    validator: validate_ServicemanagementServicesRolloutsList_594164, base: "/",
    url: url_ServicemanagementServicesRolloutsList_594165, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesRolloutsGet_594207 = ref object of OpenApiRestCall_593421
proc url_ServicemanagementServicesRolloutsGet_594209(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServicemanagementServicesRolloutsGet_594208(path: JsonNode;
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
  var valid_594210 = path.getOrDefault("rolloutId")
  valid_594210 = validateParameter(valid_594210, JString, required = true,
                                 default = nil)
  if valid_594210 != nil:
    section.add "rolloutId", valid_594210
  var valid_594211 = path.getOrDefault("serviceName")
  valid_594211 = validateParameter(valid_594211, JString, required = true,
                                 default = nil)
  if valid_594211 != nil:
    section.add "serviceName", valid_594211
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
  var valid_594212 = query.getOrDefault("upload_protocol")
  valid_594212 = validateParameter(valid_594212, JString, required = false,
                                 default = nil)
  if valid_594212 != nil:
    section.add "upload_protocol", valid_594212
  var valid_594213 = query.getOrDefault("fields")
  valid_594213 = validateParameter(valid_594213, JString, required = false,
                                 default = nil)
  if valid_594213 != nil:
    section.add "fields", valid_594213
  var valid_594214 = query.getOrDefault("quotaUser")
  valid_594214 = validateParameter(valid_594214, JString, required = false,
                                 default = nil)
  if valid_594214 != nil:
    section.add "quotaUser", valid_594214
  var valid_594215 = query.getOrDefault("alt")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = newJString("json"))
  if valid_594215 != nil:
    section.add "alt", valid_594215
  var valid_594216 = query.getOrDefault("oauth_token")
  valid_594216 = validateParameter(valid_594216, JString, required = false,
                                 default = nil)
  if valid_594216 != nil:
    section.add "oauth_token", valid_594216
  var valid_594217 = query.getOrDefault("callback")
  valid_594217 = validateParameter(valid_594217, JString, required = false,
                                 default = nil)
  if valid_594217 != nil:
    section.add "callback", valid_594217
  var valid_594218 = query.getOrDefault("access_token")
  valid_594218 = validateParameter(valid_594218, JString, required = false,
                                 default = nil)
  if valid_594218 != nil:
    section.add "access_token", valid_594218
  var valid_594219 = query.getOrDefault("uploadType")
  valid_594219 = validateParameter(valid_594219, JString, required = false,
                                 default = nil)
  if valid_594219 != nil:
    section.add "uploadType", valid_594219
  var valid_594220 = query.getOrDefault("key")
  valid_594220 = validateParameter(valid_594220, JString, required = false,
                                 default = nil)
  if valid_594220 != nil:
    section.add "key", valid_594220
  var valid_594221 = query.getOrDefault("$.xgafv")
  valid_594221 = validateParameter(valid_594221, JString, required = false,
                                 default = newJString("1"))
  if valid_594221 != nil:
    section.add "$.xgafv", valid_594221
  var valid_594222 = query.getOrDefault("prettyPrint")
  valid_594222 = validateParameter(valid_594222, JBool, required = false,
                                 default = newJBool(true))
  if valid_594222 != nil:
    section.add "prettyPrint", valid_594222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594223: Call_ServicemanagementServicesRolloutsGet_594207;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a service configuration rollout.
  ## 
  let valid = call_594223.validator(path, query, header, formData, body)
  let scheme = call_594223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594223.url(scheme.get, call_594223.host, call_594223.base,
                         call_594223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594223, url, valid)

proc call*(call_594224: Call_ServicemanagementServicesRolloutsGet_594207;
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
  var path_594225 = newJObject()
  var query_594226 = newJObject()
  add(query_594226, "upload_protocol", newJString(uploadProtocol))
  add(query_594226, "fields", newJString(fields))
  add(query_594226, "quotaUser", newJString(quotaUser))
  add(query_594226, "alt", newJString(alt))
  add(path_594225, "rolloutId", newJString(rolloutId))
  add(query_594226, "oauth_token", newJString(oauthToken))
  add(query_594226, "callback", newJString(callback))
  add(query_594226, "access_token", newJString(accessToken))
  add(query_594226, "uploadType", newJString(uploadType))
  add(query_594226, "key", newJString(key))
  add(query_594226, "$.xgafv", newJString(Xgafv))
  add(query_594226, "prettyPrint", newJBool(prettyPrint))
  add(path_594225, "serviceName", newJString(serviceName))
  result = call_594224.call(path_594225, query_594226, nil, nil, nil)

var servicemanagementServicesRolloutsGet* = Call_ServicemanagementServicesRolloutsGet_594207(
    name: "servicemanagementServicesRolloutsGet", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}/rollouts/{rolloutId}",
    validator: validate_ServicemanagementServicesRolloutsGet_594208, base: "/",
    url: url_ServicemanagementServicesRolloutsGet_594209, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesDisable_594227 = ref object of OpenApiRestCall_593421
proc url_ServicemanagementServicesDisable_594229(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServicemanagementServicesDisable_594228(path: JsonNode;
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
  var valid_594230 = path.getOrDefault("serviceName")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "serviceName", valid_594230
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
  var valid_594231 = query.getOrDefault("upload_protocol")
  valid_594231 = validateParameter(valid_594231, JString, required = false,
                                 default = nil)
  if valid_594231 != nil:
    section.add "upload_protocol", valid_594231
  var valid_594232 = query.getOrDefault("fields")
  valid_594232 = validateParameter(valid_594232, JString, required = false,
                                 default = nil)
  if valid_594232 != nil:
    section.add "fields", valid_594232
  var valid_594233 = query.getOrDefault("quotaUser")
  valid_594233 = validateParameter(valid_594233, JString, required = false,
                                 default = nil)
  if valid_594233 != nil:
    section.add "quotaUser", valid_594233
  var valid_594234 = query.getOrDefault("alt")
  valid_594234 = validateParameter(valid_594234, JString, required = false,
                                 default = newJString("json"))
  if valid_594234 != nil:
    section.add "alt", valid_594234
  var valid_594235 = query.getOrDefault("oauth_token")
  valid_594235 = validateParameter(valid_594235, JString, required = false,
                                 default = nil)
  if valid_594235 != nil:
    section.add "oauth_token", valid_594235
  var valid_594236 = query.getOrDefault("callback")
  valid_594236 = validateParameter(valid_594236, JString, required = false,
                                 default = nil)
  if valid_594236 != nil:
    section.add "callback", valid_594236
  var valid_594237 = query.getOrDefault("access_token")
  valid_594237 = validateParameter(valid_594237, JString, required = false,
                                 default = nil)
  if valid_594237 != nil:
    section.add "access_token", valid_594237
  var valid_594238 = query.getOrDefault("uploadType")
  valid_594238 = validateParameter(valid_594238, JString, required = false,
                                 default = nil)
  if valid_594238 != nil:
    section.add "uploadType", valid_594238
  var valid_594239 = query.getOrDefault("key")
  valid_594239 = validateParameter(valid_594239, JString, required = false,
                                 default = nil)
  if valid_594239 != nil:
    section.add "key", valid_594239
  var valid_594240 = query.getOrDefault("$.xgafv")
  valid_594240 = validateParameter(valid_594240, JString, required = false,
                                 default = newJString("1"))
  if valid_594240 != nil:
    section.add "$.xgafv", valid_594240
  var valid_594241 = query.getOrDefault("prettyPrint")
  valid_594241 = validateParameter(valid_594241, JBool, required = false,
                                 default = newJBool(true))
  if valid_594241 != nil:
    section.add "prettyPrint", valid_594241
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

proc call*(call_594243: Call_ServicemanagementServicesDisable_594227;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Disables a service for a project, so it can no longer be
  ## be used for the project. It prevents accidental usage that may cause
  ## unexpected billing charges or security leaks.
  ## 
  ## Operation<response: DisableServiceResponse>
  ## 
  let valid = call_594243.validator(path, query, header, formData, body)
  let scheme = call_594243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594243.url(scheme.get, call_594243.host, call_594243.base,
                         call_594243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594243, url, valid)

proc call*(call_594244: Call_ServicemanagementServicesDisable_594227;
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
  var path_594245 = newJObject()
  var query_594246 = newJObject()
  var body_594247 = newJObject()
  add(query_594246, "upload_protocol", newJString(uploadProtocol))
  add(query_594246, "fields", newJString(fields))
  add(query_594246, "quotaUser", newJString(quotaUser))
  add(query_594246, "alt", newJString(alt))
  add(query_594246, "oauth_token", newJString(oauthToken))
  add(query_594246, "callback", newJString(callback))
  add(query_594246, "access_token", newJString(accessToken))
  add(query_594246, "uploadType", newJString(uploadType))
  add(query_594246, "key", newJString(key))
  add(query_594246, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594247 = body
  add(query_594246, "prettyPrint", newJBool(prettyPrint))
  add(path_594245, "serviceName", newJString(serviceName))
  result = call_594244.call(path_594245, query_594246, nil, nil, body_594247)

var servicemanagementServicesDisable* = Call_ServicemanagementServicesDisable_594227(
    name: "servicemanagementServicesDisable", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}:disable",
    validator: validate_ServicemanagementServicesDisable_594228, base: "/",
    url: url_ServicemanagementServicesDisable_594229, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesEnable_594248 = ref object of OpenApiRestCall_593421
proc url_ServicemanagementServicesEnable_594250(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServicemanagementServicesEnable_594249(path: JsonNode;
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
  var valid_594251 = path.getOrDefault("serviceName")
  valid_594251 = validateParameter(valid_594251, JString, required = true,
                                 default = nil)
  if valid_594251 != nil:
    section.add "serviceName", valid_594251
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
  var valid_594252 = query.getOrDefault("upload_protocol")
  valid_594252 = validateParameter(valid_594252, JString, required = false,
                                 default = nil)
  if valid_594252 != nil:
    section.add "upload_protocol", valid_594252
  var valid_594253 = query.getOrDefault("fields")
  valid_594253 = validateParameter(valid_594253, JString, required = false,
                                 default = nil)
  if valid_594253 != nil:
    section.add "fields", valid_594253
  var valid_594254 = query.getOrDefault("quotaUser")
  valid_594254 = validateParameter(valid_594254, JString, required = false,
                                 default = nil)
  if valid_594254 != nil:
    section.add "quotaUser", valid_594254
  var valid_594255 = query.getOrDefault("alt")
  valid_594255 = validateParameter(valid_594255, JString, required = false,
                                 default = newJString("json"))
  if valid_594255 != nil:
    section.add "alt", valid_594255
  var valid_594256 = query.getOrDefault("oauth_token")
  valid_594256 = validateParameter(valid_594256, JString, required = false,
                                 default = nil)
  if valid_594256 != nil:
    section.add "oauth_token", valid_594256
  var valid_594257 = query.getOrDefault("callback")
  valid_594257 = validateParameter(valid_594257, JString, required = false,
                                 default = nil)
  if valid_594257 != nil:
    section.add "callback", valid_594257
  var valid_594258 = query.getOrDefault("access_token")
  valid_594258 = validateParameter(valid_594258, JString, required = false,
                                 default = nil)
  if valid_594258 != nil:
    section.add "access_token", valid_594258
  var valid_594259 = query.getOrDefault("uploadType")
  valid_594259 = validateParameter(valid_594259, JString, required = false,
                                 default = nil)
  if valid_594259 != nil:
    section.add "uploadType", valid_594259
  var valid_594260 = query.getOrDefault("key")
  valid_594260 = validateParameter(valid_594260, JString, required = false,
                                 default = nil)
  if valid_594260 != nil:
    section.add "key", valid_594260
  var valid_594261 = query.getOrDefault("$.xgafv")
  valid_594261 = validateParameter(valid_594261, JString, required = false,
                                 default = newJString("1"))
  if valid_594261 != nil:
    section.add "$.xgafv", valid_594261
  var valid_594262 = query.getOrDefault("prettyPrint")
  valid_594262 = validateParameter(valid_594262, JBool, required = false,
                                 default = newJBool(true))
  if valid_594262 != nil:
    section.add "prettyPrint", valid_594262
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

proc call*(call_594264: Call_ServicemanagementServicesEnable_594248;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables a service for a project, so it can be used
  ## for the project. See
  ## [Cloud Auth Guide](https://cloud.google.com/docs/authentication) for
  ## more information.
  ## 
  ## Operation<response: EnableServiceResponse>
  ## 
  let valid = call_594264.validator(path, query, header, formData, body)
  let scheme = call_594264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594264.url(scheme.get, call_594264.host, call_594264.base,
                         call_594264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594264, url, valid)

proc call*(call_594265: Call_ServicemanagementServicesEnable_594248;
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
  var path_594266 = newJObject()
  var query_594267 = newJObject()
  var body_594268 = newJObject()
  add(query_594267, "upload_protocol", newJString(uploadProtocol))
  add(query_594267, "fields", newJString(fields))
  add(query_594267, "quotaUser", newJString(quotaUser))
  add(query_594267, "alt", newJString(alt))
  add(query_594267, "oauth_token", newJString(oauthToken))
  add(query_594267, "callback", newJString(callback))
  add(query_594267, "access_token", newJString(accessToken))
  add(query_594267, "uploadType", newJString(uploadType))
  add(query_594267, "key", newJString(key))
  add(query_594267, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594268 = body
  add(query_594267, "prettyPrint", newJBool(prettyPrint))
  add(path_594266, "serviceName", newJString(serviceName))
  result = call_594265.call(path_594266, query_594267, nil, nil, body_594268)

var servicemanagementServicesEnable* = Call_ServicemanagementServicesEnable_594248(
    name: "servicemanagementServicesEnable", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}:enable",
    validator: validate_ServicemanagementServicesEnable_594249, base: "/",
    url: url_ServicemanagementServicesEnable_594250, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesUndelete_594269 = ref object of OpenApiRestCall_593421
proc url_ServicemanagementServicesUndelete_594271(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServicemanagementServicesUndelete_594270(path: JsonNode;
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
  var valid_594272 = path.getOrDefault("serviceName")
  valid_594272 = validateParameter(valid_594272, JString, required = true,
                                 default = nil)
  if valid_594272 != nil:
    section.add "serviceName", valid_594272
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
  var valid_594273 = query.getOrDefault("upload_protocol")
  valid_594273 = validateParameter(valid_594273, JString, required = false,
                                 default = nil)
  if valid_594273 != nil:
    section.add "upload_protocol", valid_594273
  var valid_594274 = query.getOrDefault("fields")
  valid_594274 = validateParameter(valid_594274, JString, required = false,
                                 default = nil)
  if valid_594274 != nil:
    section.add "fields", valid_594274
  var valid_594275 = query.getOrDefault("quotaUser")
  valid_594275 = validateParameter(valid_594275, JString, required = false,
                                 default = nil)
  if valid_594275 != nil:
    section.add "quotaUser", valid_594275
  var valid_594276 = query.getOrDefault("alt")
  valid_594276 = validateParameter(valid_594276, JString, required = false,
                                 default = newJString("json"))
  if valid_594276 != nil:
    section.add "alt", valid_594276
  var valid_594277 = query.getOrDefault("oauth_token")
  valid_594277 = validateParameter(valid_594277, JString, required = false,
                                 default = nil)
  if valid_594277 != nil:
    section.add "oauth_token", valid_594277
  var valid_594278 = query.getOrDefault("callback")
  valid_594278 = validateParameter(valid_594278, JString, required = false,
                                 default = nil)
  if valid_594278 != nil:
    section.add "callback", valid_594278
  var valid_594279 = query.getOrDefault("access_token")
  valid_594279 = validateParameter(valid_594279, JString, required = false,
                                 default = nil)
  if valid_594279 != nil:
    section.add "access_token", valid_594279
  var valid_594280 = query.getOrDefault("uploadType")
  valid_594280 = validateParameter(valid_594280, JString, required = false,
                                 default = nil)
  if valid_594280 != nil:
    section.add "uploadType", valid_594280
  var valid_594281 = query.getOrDefault("key")
  valid_594281 = validateParameter(valid_594281, JString, required = false,
                                 default = nil)
  if valid_594281 != nil:
    section.add "key", valid_594281
  var valid_594282 = query.getOrDefault("$.xgafv")
  valid_594282 = validateParameter(valid_594282, JString, required = false,
                                 default = newJString("1"))
  if valid_594282 != nil:
    section.add "$.xgafv", valid_594282
  var valid_594283 = query.getOrDefault("prettyPrint")
  valid_594283 = validateParameter(valid_594283, JBool, required = false,
                                 default = newJBool(true))
  if valid_594283 != nil:
    section.add "prettyPrint", valid_594283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594284: Call_ServicemanagementServicesUndelete_594269;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Revives a previously deleted managed service. The method restores the
  ## service using the configuration at the time the service was deleted.
  ## The target service must exist and must have been deleted within the
  ## last 30 days.
  ## 
  ## Operation<response: UndeleteServiceResponse>
  ## 
  let valid = call_594284.validator(path, query, header, formData, body)
  let scheme = call_594284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594284.url(scheme.get, call_594284.host, call_594284.base,
                         call_594284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594284, url, valid)

proc call*(call_594285: Call_ServicemanagementServicesUndelete_594269;
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
  var path_594286 = newJObject()
  var query_594287 = newJObject()
  add(query_594287, "upload_protocol", newJString(uploadProtocol))
  add(query_594287, "fields", newJString(fields))
  add(query_594287, "quotaUser", newJString(quotaUser))
  add(query_594287, "alt", newJString(alt))
  add(query_594287, "oauth_token", newJString(oauthToken))
  add(query_594287, "callback", newJString(callback))
  add(query_594287, "access_token", newJString(accessToken))
  add(query_594287, "uploadType", newJString(uploadType))
  add(query_594287, "key", newJString(key))
  add(query_594287, "$.xgafv", newJString(Xgafv))
  add(query_594287, "prettyPrint", newJBool(prettyPrint))
  add(path_594286, "serviceName", newJString(serviceName))
  result = call_594285.call(path_594286, query_594287, nil, nil, nil)

var servicemanagementServicesUndelete* = Call_ServicemanagementServicesUndelete_594269(
    name: "servicemanagementServicesUndelete", meth: HttpMethod.HttpPost,
    host: "servicemanagement.googleapis.com",
    route: "/v1/services/{serviceName}:undelete",
    validator: validate_ServicemanagementServicesUndelete_594270, base: "/",
    url: url_ServicemanagementServicesUndelete_594271, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesGenerateConfigReport_594288 = ref object of OpenApiRestCall_593421
proc url_ServicemanagementServicesGenerateConfigReport_594290(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ServicemanagementServicesGenerateConfigReport_594289(
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
  var valid_594291 = query.getOrDefault("upload_protocol")
  valid_594291 = validateParameter(valid_594291, JString, required = false,
                                 default = nil)
  if valid_594291 != nil:
    section.add "upload_protocol", valid_594291
  var valid_594292 = query.getOrDefault("fields")
  valid_594292 = validateParameter(valid_594292, JString, required = false,
                                 default = nil)
  if valid_594292 != nil:
    section.add "fields", valid_594292
  var valid_594293 = query.getOrDefault("quotaUser")
  valid_594293 = validateParameter(valid_594293, JString, required = false,
                                 default = nil)
  if valid_594293 != nil:
    section.add "quotaUser", valid_594293
  var valid_594294 = query.getOrDefault("alt")
  valid_594294 = validateParameter(valid_594294, JString, required = false,
                                 default = newJString("json"))
  if valid_594294 != nil:
    section.add "alt", valid_594294
  var valid_594295 = query.getOrDefault("oauth_token")
  valid_594295 = validateParameter(valid_594295, JString, required = false,
                                 default = nil)
  if valid_594295 != nil:
    section.add "oauth_token", valid_594295
  var valid_594296 = query.getOrDefault("callback")
  valid_594296 = validateParameter(valid_594296, JString, required = false,
                                 default = nil)
  if valid_594296 != nil:
    section.add "callback", valid_594296
  var valid_594297 = query.getOrDefault("access_token")
  valid_594297 = validateParameter(valid_594297, JString, required = false,
                                 default = nil)
  if valid_594297 != nil:
    section.add "access_token", valid_594297
  var valid_594298 = query.getOrDefault("uploadType")
  valid_594298 = validateParameter(valid_594298, JString, required = false,
                                 default = nil)
  if valid_594298 != nil:
    section.add "uploadType", valid_594298
  var valid_594299 = query.getOrDefault("key")
  valid_594299 = validateParameter(valid_594299, JString, required = false,
                                 default = nil)
  if valid_594299 != nil:
    section.add "key", valid_594299
  var valid_594300 = query.getOrDefault("$.xgafv")
  valid_594300 = validateParameter(valid_594300, JString, required = false,
                                 default = newJString("1"))
  if valid_594300 != nil:
    section.add "$.xgafv", valid_594300
  var valid_594301 = query.getOrDefault("prettyPrint")
  valid_594301 = validateParameter(valid_594301, JBool, required = false,
                                 default = newJBool(true))
  if valid_594301 != nil:
    section.add "prettyPrint", valid_594301
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

proc call*(call_594303: Call_ServicemanagementServicesGenerateConfigReport_594288;
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
  let valid = call_594303.validator(path, query, header, formData, body)
  let scheme = call_594303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594303.url(scheme.get, call_594303.host, call_594303.base,
                         call_594303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594303, url, valid)

proc call*(call_594304: Call_ServicemanagementServicesGenerateConfigReport_594288;
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
  var query_594305 = newJObject()
  var body_594306 = newJObject()
  add(query_594305, "upload_protocol", newJString(uploadProtocol))
  add(query_594305, "fields", newJString(fields))
  add(query_594305, "quotaUser", newJString(quotaUser))
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
  result = call_594304.call(nil, query_594305, nil, nil, body_594306)

var servicemanagementServicesGenerateConfigReport* = Call_ServicemanagementServicesGenerateConfigReport_594288(
    name: "servicemanagementServicesGenerateConfigReport",
    meth: HttpMethod.HttpPost, host: "servicemanagement.googleapis.com",
    route: "/v1/services:generateConfigReport",
    validator: validate_ServicemanagementServicesGenerateConfigReport_594289,
    base: "/", url: url_ServicemanagementServicesGenerateConfigReport_594290,
    schemes: {Scheme.Https})
type
  Call_ServicemanagementOperationsGet_594307 = ref object of OpenApiRestCall_593421
proc url_ServicemanagementOperationsGet_594309(protocol: Scheme; host: string;
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

proc validate_ServicemanagementOperationsGet_594308(path: JsonNode;
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
  if body != nil:
    result.add "body", body

proc call*(call_594322: Call_ServicemanagementOperationsGet_594307; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_594322.validator(path, query, header, formData, body)
  let scheme = call_594322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594322.url(scheme.get, call_594322.host, call_594322.base,
                         call_594322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594322, url, valid)

proc call*(call_594323: Call_ServicemanagementOperationsGet_594307; name: string;
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
  var path_594324 = newJObject()
  var query_594325 = newJObject()
  add(query_594325, "upload_protocol", newJString(uploadProtocol))
  add(query_594325, "fields", newJString(fields))
  add(query_594325, "quotaUser", newJString(quotaUser))
  add(path_594324, "name", newJString(name))
  add(query_594325, "alt", newJString(alt))
  add(query_594325, "oauth_token", newJString(oauthToken))
  add(query_594325, "callback", newJString(callback))
  add(query_594325, "access_token", newJString(accessToken))
  add(query_594325, "uploadType", newJString(uploadType))
  add(query_594325, "key", newJString(key))
  add(query_594325, "$.xgafv", newJString(Xgafv))
  add(query_594325, "prettyPrint", newJBool(prettyPrint))
  result = call_594323.call(path_594324, query_594325, nil, nil, nil)

var servicemanagementOperationsGet* = Call_ServicemanagementOperationsGet_594307(
    name: "servicemanagementOperationsGet", meth: HttpMethod.HttpGet,
    host: "servicemanagement.googleapis.com", route: "/v1/{name}",
    validator: validate_ServicemanagementOperationsGet_594308, base: "/",
    url: url_ServicemanagementOperationsGet_594309, schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConsumersGetIamPolicy_594326 = ref object of OpenApiRestCall_593421
proc url_ServicemanagementServicesConsumersGetIamPolicy_594328(protocol: Scheme;
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

proc validate_ServicemanagementServicesConsumersGetIamPolicy_594327(
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
  var valid_594329 = path.getOrDefault("resource")
  valid_594329 = validateParameter(valid_594329, JString, required = true,
                                 default = nil)
  if valid_594329 != nil:
    section.add "resource", valid_594329
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
  var valid_594330 = query.getOrDefault("upload_protocol")
  valid_594330 = validateParameter(valid_594330, JString, required = false,
                                 default = nil)
  if valid_594330 != nil:
    section.add "upload_protocol", valid_594330
  var valid_594331 = query.getOrDefault("fields")
  valid_594331 = validateParameter(valid_594331, JString, required = false,
                                 default = nil)
  if valid_594331 != nil:
    section.add "fields", valid_594331
  var valid_594332 = query.getOrDefault("quotaUser")
  valid_594332 = validateParameter(valid_594332, JString, required = false,
                                 default = nil)
  if valid_594332 != nil:
    section.add "quotaUser", valid_594332
  var valid_594333 = query.getOrDefault("alt")
  valid_594333 = validateParameter(valid_594333, JString, required = false,
                                 default = newJString("json"))
  if valid_594333 != nil:
    section.add "alt", valid_594333
  var valid_594334 = query.getOrDefault("oauth_token")
  valid_594334 = validateParameter(valid_594334, JString, required = false,
                                 default = nil)
  if valid_594334 != nil:
    section.add "oauth_token", valid_594334
  var valid_594335 = query.getOrDefault("callback")
  valid_594335 = validateParameter(valid_594335, JString, required = false,
                                 default = nil)
  if valid_594335 != nil:
    section.add "callback", valid_594335
  var valid_594336 = query.getOrDefault("access_token")
  valid_594336 = validateParameter(valid_594336, JString, required = false,
                                 default = nil)
  if valid_594336 != nil:
    section.add "access_token", valid_594336
  var valid_594337 = query.getOrDefault("uploadType")
  valid_594337 = validateParameter(valid_594337, JString, required = false,
                                 default = nil)
  if valid_594337 != nil:
    section.add "uploadType", valid_594337
  var valid_594338 = query.getOrDefault("key")
  valid_594338 = validateParameter(valid_594338, JString, required = false,
                                 default = nil)
  if valid_594338 != nil:
    section.add "key", valid_594338
  var valid_594339 = query.getOrDefault("$.xgafv")
  valid_594339 = validateParameter(valid_594339, JString, required = false,
                                 default = newJString("1"))
  if valid_594339 != nil:
    section.add "$.xgafv", valid_594339
  var valid_594340 = query.getOrDefault("prettyPrint")
  valid_594340 = validateParameter(valid_594340, JBool, required = false,
                                 default = newJBool(true))
  if valid_594340 != nil:
    section.add "prettyPrint", valid_594340
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

proc call*(call_594342: Call_ServicemanagementServicesConsumersGetIamPolicy_594326;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_594342.validator(path, query, header, formData, body)
  let scheme = call_594342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594342.url(scheme.get, call_594342.host, call_594342.base,
                         call_594342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594342, url, valid)

proc call*(call_594343: Call_ServicemanagementServicesConsumersGetIamPolicy_594326;
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
  var path_594344 = newJObject()
  var query_594345 = newJObject()
  var body_594346 = newJObject()
  add(query_594345, "upload_protocol", newJString(uploadProtocol))
  add(query_594345, "fields", newJString(fields))
  add(query_594345, "quotaUser", newJString(quotaUser))
  add(query_594345, "alt", newJString(alt))
  add(query_594345, "oauth_token", newJString(oauthToken))
  add(query_594345, "callback", newJString(callback))
  add(query_594345, "access_token", newJString(accessToken))
  add(query_594345, "uploadType", newJString(uploadType))
  add(query_594345, "key", newJString(key))
  add(query_594345, "$.xgafv", newJString(Xgafv))
  add(path_594344, "resource", newJString(resource))
  if body != nil:
    body_594346 = body
  add(query_594345, "prettyPrint", newJBool(prettyPrint))
  result = call_594343.call(path_594344, query_594345, nil, nil, body_594346)

var servicemanagementServicesConsumersGetIamPolicy* = Call_ServicemanagementServicesConsumersGetIamPolicy_594326(
    name: "servicemanagementServicesConsumersGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "servicemanagement.googleapis.com",
    route: "/v1/{resource}:getIamPolicy",
    validator: validate_ServicemanagementServicesConsumersGetIamPolicy_594327,
    base: "/", url: url_ServicemanagementServicesConsumersGetIamPolicy_594328,
    schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConsumersSetIamPolicy_594347 = ref object of OpenApiRestCall_593421
proc url_ServicemanagementServicesConsumersSetIamPolicy_594349(protocol: Scheme;
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

proc validate_ServicemanagementServicesConsumersSetIamPolicy_594348(
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
  var valid_594350 = path.getOrDefault("resource")
  valid_594350 = validateParameter(valid_594350, JString, required = true,
                                 default = nil)
  if valid_594350 != nil:
    section.add "resource", valid_594350
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
  var valid_594351 = query.getOrDefault("upload_protocol")
  valid_594351 = validateParameter(valid_594351, JString, required = false,
                                 default = nil)
  if valid_594351 != nil:
    section.add "upload_protocol", valid_594351
  var valid_594352 = query.getOrDefault("fields")
  valid_594352 = validateParameter(valid_594352, JString, required = false,
                                 default = nil)
  if valid_594352 != nil:
    section.add "fields", valid_594352
  var valid_594353 = query.getOrDefault("quotaUser")
  valid_594353 = validateParameter(valid_594353, JString, required = false,
                                 default = nil)
  if valid_594353 != nil:
    section.add "quotaUser", valid_594353
  var valid_594354 = query.getOrDefault("alt")
  valid_594354 = validateParameter(valid_594354, JString, required = false,
                                 default = newJString("json"))
  if valid_594354 != nil:
    section.add "alt", valid_594354
  var valid_594355 = query.getOrDefault("oauth_token")
  valid_594355 = validateParameter(valid_594355, JString, required = false,
                                 default = nil)
  if valid_594355 != nil:
    section.add "oauth_token", valid_594355
  var valid_594356 = query.getOrDefault("callback")
  valid_594356 = validateParameter(valid_594356, JString, required = false,
                                 default = nil)
  if valid_594356 != nil:
    section.add "callback", valid_594356
  var valid_594357 = query.getOrDefault("access_token")
  valid_594357 = validateParameter(valid_594357, JString, required = false,
                                 default = nil)
  if valid_594357 != nil:
    section.add "access_token", valid_594357
  var valid_594358 = query.getOrDefault("uploadType")
  valid_594358 = validateParameter(valid_594358, JString, required = false,
                                 default = nil)
  if valid_594358 != nil:
    section.add "uploadType", valid_594358
  var valid_594359 = query.getOrDefault("key")
  valid_594359 = validateParameter(valid_594359, JString, required = false,
                                 default = nil)
  if valid_594359 != nil:
    section.add "key", valid_594359
  var valid_594360 = query.getOrDefault("$.xgafv")
  valid_594360 = validateParameter(valid_594360, JString, required = false,
                                 default = newJString("1"))
  if valid_594360 != nil:
    section.add "$.xgafv", valid_594360
  var valid_594361 = query.getOrDefault("prettyPrint")
  valid_594361 = validateParameter(valid_594361, JBool, required = false,
                                 default = newJBool(true))
  if valid_594361 != nil:
    section.add "prettyPrint", valid_594361
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

proc call*(call_594363: Call_ServicemanagementServicesConsumersSetIamPolicy_594347;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_594363.validator(path, query, header, formData, body)
  let scheme = call_594363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594363.url(scheme.get, call_594363.host, call_594363.base,
                         call_594363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594363, url, valid)

proc call*(call_594364: Call_ServicemanagementServicesConsumersSetIamPolicy_594347;
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
  var path_594365 = newJObject()
  var query_594366 = newJObject()
  var body_594367 = newJObject()
  add(query_594366, "upload_protocol", newJString(uploadProtocol))
  add(query_594366, "fields", newJString(fields))
  add(query_594366, "quotaUser", newJString(quotaUser))
  add(query_594366, "alt", newJString(alt))
  add(query_594366, "oauth_token", newJString(oauthToken))
  add(query_594366, "callback", newJString(callback))
  add(query_594366, "access_token", newJString(accessToken))
  add(query_594366, "uploadType", newJString(uploadType))
  add(query_594366, "key", newJString(key))
  add(query_594366, "$.xgafv", newJString(Xgafv))
  add(path_594365, "resource", newJString(resource))
  if body != nil:
    body_594367 = body
  add(query_594366, "prettyPrint", newJBool(prettyPrint))
  result = call_594364.call(path_594365, query_594366, nil, nil, body_594367)

var servicemanagementServicesConsumersSetIamPolicy* = Call_ServicemanagementServicesConsumersSetIamPolicy_594347(
    name: "servicemanagementServicesConsumersSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "servicemanagement.googleapis.com",
    route: "/v1/{resource}:setIamPolicy",
    validator: validate_ServicemanagementServicesConsumersSetIamPolicy_594348,
    base: "/", url: url_ServicemanagementServicesConsumersSetIamPolicy_594349,
    schemes: {Scheme.Https})
type
  Call_ServicemanagementServicesConsumersTestIamPermissions_594368 = ref object of OpenApiRestCall_593421
proc url_ServicemanagementServicesConsumersTestIamPermissions_594370(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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

proc validate_ServicemanagementServicesConsumersTestIamPermissions_594369(
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
  var valid_594371 = path.getOrDefault("resource")
  valid_594371 = validateParameter(valid_594371, JString, required = true,
                                 default = nil)
  if valid_594371 != nil:
    section.add "resource", valid_594371
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
  var valid_594372 = query.getOrDefault("upload_protocol")
  valid_594372 = validateParameter(valid_594372, JString, required = false,
                                 default = nil)
  if valid_594372 != nil:
    section.add "upload_protocol", valid_594372
  var valid_594373 = query.getOrDefault("fields")
  valid_594373 = validateParameter(valid_594373, JString, required = false,
                                 default = nil)
  if valid_594373 != nil:
    section.add "fields", valid_594373
  var valid_594374 = query.getOrDefault("quotaUser")
  valid_594374 = validateParameter(valid_594374, JString, required = false,
                                 default = nil)
  if valid_594374 != nil:
    section.add "quotaUser", valid_594374
  var valid_594375 = query.getOrDefault("alt")
  valid_594375 = validateParameter(valid_594375, JString, required = false,
                                 default = newJString("json"))
  if valid_594375 != nil:
    section.add "alt", valid_594375
  var valid_594376 = query.getOrDefault("oauth_token")
  valid_594376 = validateParameter(valid_594376, JString, required = false,
                                 default = nil)
  if valid_594376 != nil:
    section.add "oauth_token", valid_594376
  var valid_594377 = query.getOrDefault("callback")
  valid_594377 = validateParameter(valid_594377, JString, required = false,
                                 default = nil)
  if valid_594377 != nil:
    section.add "callback", valid_594377
  var valid_594378 = query.getOrDefault("access_token")
  valid_594378 = validateParameter(valid_594378, JString, required = false,
                                 default = nil)
  if valid_594378 != nil:
    section.add "access_token", valid_594378
  var valid_594379 = query.getOrDefault("uploadType")
  valid_594379 = validateParameter(valid_594379, JString, required = false,
                                 default = nil)
  if valid_594379 != nil:
    section.add "uploadType", valid_594379
  var valid_594380 = query.getOrDefault("key")
  valid_594380 = validateParameter(valid_594380, JString, required = false,
                                 default = nil)
  if valid_594380 != nil:
    section.add "key", valid_594380
  var valid_594381 = query.getOrDefault("$.xgafv")
  valid_594381 = validateParameter(valid_594381, JString, required = false,
                                 default = newJString("1"))
  if valid_594381 != nil:
    section.add "$.xgafv", valid_594381
  var valid_594382 = query.getOrDefault("prettyPrint")
  valid_594382 = validateParameter(valid_594382, JBool, required = false,
                                 default = newJBool(true))
  if valid_594382 != nil:
    section.add "prettyPrint", valid_594382
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

proc call*(call_594384: Call_ServicemanagementServicesConsumersTestIamPermissions_594368;
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
  let valid = call_594384.validator(path, query, header, formData, body)
  let scheme = call_594384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594384.url(scheme.get, call_594384.host, call_594384.base,
                         call_594384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594384, url, valid)

proc call*(call_594385: Call_ServicemanagementServicesConsumersTestIamPermissions_594368;
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
  var path_594386 = newJObject()
  var query_594387 = newJObject()
  var body_594388 = newJObject()
  add(query_594387, "upload_protocol", newJString(uploadProtocol))
  add(query_594387, "fields", newJString(fields))
  add(query_594387, "quotaUser", newJString(quotaUser))
  add(query_594387, "alt", newJString(alt))
  add(query_594387, "oauth_token", newJString(oauthToken))
  add(query_594387, "callback", newJString(callback))
  add(query_594387, "access_token", newJString(accessToken))
  add(query_594387, "uploadType", newJString(uploadType))
  add(query_594387, "key", newJString(key))
  add(query_594387, "$.xgafv", newJString(Xgafv))
  add(path_594386, "resource", newJString(resource))
  if body != nil:
    body_594388 = body
  add(query_594387, "prettyPrint", newJBool(prettyPrint))
  result = call_594385.call(path_594386, query_594387, nil, nil, body_594388)

var servicemanagementServicesConsumersTestIamPermissions* = Call_ServicemanagementServicesConsumersTestIamPermissions_594368(
    name: "servicemanagementServicesConsumersTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "servicemanagement.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_ServicemanagementServicesConsumersTestIamPermissions_594369,
    base: "/", url: url_ServicemanagementServicesConsumersTestIamPermissions_594370,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
