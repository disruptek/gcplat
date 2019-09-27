
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Service Control
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Provides control plane functionality to managed services, such as logging, monitoring, and status checks.
## 
## https://cloud.google.com/service-control/
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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
  gcpServiceName = "servicecontrol"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServicecontrolServicesAllocateQuota_593677 = ref object of OpenApiRestCall_593408
proc url_ServicecontrolServicesAllocateQuota_593679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: ":allocateQuota")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicecontrolServicesAllocateQuota_593678(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Attempts to allocate quota for the specified consumer. It should be called
  ## before the operation is executed.
  ## 
  ## This method requires the `servicemanagement.services.quota`
  ## permission on the specified service. For more information, see
  ## [Cloud IAM](https://cloud.google.com/iam).
  ## 
  ## **NOTE:** The client **must** fail-open on server errors `INTERNAL`,
  ## `UNKNOWN`, `DEADLINE_EXCEEDED`, and `UNAVAILABLE`. To ensure system
  ## reliability, the server may inject these errors to prohibit any hard
  ## dependency on the quota functionality.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : Name of the service as specified in the service configuration. For example,
  ## `"pubsub.googleapis.com"`.
  ## 
  ## See google.api.Service for the definition of a service name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_593805 = path.getOrDefault("serviceName")
  valid_593805 = validateParameter(valid_593805, JString, required = true,
                                 default = nil)
  if valid_593805 != nil:
    section.add "serviceName", valid_593805
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
  var valid_593806 = query.getOrDefault("upload_protocol")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "upload_protocol", valid_593806
  var valid_593807 = query.getOrDefault("fields")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "fields", valid_593807
  var valid_593808 = query.getOrDefault("quotaUser")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = nil)
  if valid_593808 != nil:
    section.add "quotaUser", valid_593808
  var valid_593822 = query.getOrDefault("alt")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = newJString("json"))
  if valid_593822 != nil:
    section.add "alt", valid_593822
  var valid_593823 = query.getOrDefault("oauth_token")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "oauth_token", valid_593823
  var valid_593824 = query.getOrDefault("callback")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "callback", valid_593824
  var valid_593825 = query.getOrDefault("access_token")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "access_token", valid_593825
  var valid_593826 = query.getOrDefault("uploadType")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = nil)
  if valid_593826 != nil:
    section.add "uploadType", valid_593826
  var valid_593827 = query.getOrDefault("key")
  valid_593827 = validateParameter(valid_593827, JString, required = false,
                                 default = nil)
  if valid_593827 != nil:
    section.add "key", valid_593827
  var valid_593828 = query.getOrDefault("$.xgafv")
  valid_593828 = validateParameter(valid_593828, JString, required = false,
                                 default = newJString("1"))
  if valid_593828 != nil:
    section.add "$.xgafv", valid_593828
  var valid_593829 = query.getOrDefault("prettyPrint")
  valid_593829 = validateParameter(valid_593829, JBool, required = false,
                                 default = newJBool(true))
  if valid_593829 != nil:
    section.add "prettyPrint", valid_593829
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

proc call*(call_593853: Call_ServicecontrolServicesAllocateQuota_593677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Attempts to allocate quota for the specified consumer. It should be called
  ## before the operation is executed.
  ## 
  ## This method requires the `servicemanagement.services.quota`
  ## permission on the specified service. For more information, see
  ## [Cloud IAM](https://cloud.google.com/iam).
  ## 
  ## **NOTE:** The client **must** fail-open on server errors `INTERNAL`,
  ## `UNKNOWN`, `DEADLINE_EXCEEDED`, and `UNAVAILABLE`. To ensure system
  ## reliability, the server may inject these errors to prohibit any hard
  ## dependency on the quota functionality.
  ## 
  let valid = call_593853.validator(path, query, header, formData, body)
  let scheme = call_593853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593853.url(scheme.get, call_593853.host, call_593853.base,
                         call_593853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593853, url, valid)

proc call*(call_593924: Call_ServicecontrolServicesAllocateQuota_593677;
          serviceName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## servicecontrolServicesAllocateQuota
  ## Attempts to allocate quota for the specified consumer. It should be called
  ## before the operation is executed.
  ## 
  ## This method requires the `servicemanagement.services.quota`
  ## permission on the specified service. For more information, see
  ## [Cloud IAM](https://cloud.google.com/iam).
  ## 
  ## **NOTE:** The client **must** fail-open on server errors `INTERNAL`,
  ## `UNKNOWN`, `DEADLINE_EXCEEDED`, and `UNAVAILABLE`. To ensure system
  ## reliability, the server may inject these errors to prohibit any hard
  ## dependency on the quota functionality.
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
  ##              : Name of the service as specified in the service configuration. For example,
  ## `"pubsub.googleapis.com"`.
  ## 
  ## See google.api.Service for the definition of a service name.
  var path_593925 = newJObject()
  var query_593927 = newJObject()
  var body_593928 = newJObject()
  add(query_593927, "upload_protocol", newJString(uploadProtocol))
  add(query_593927, "fields", newJString(fields))
  add(query_593927, "quotaUser", newJString(quotaUser))
  add(query_593927, "alt", newJString(alt))
  add(query_593927, "oauth_token", newJString(oauthToken))
  add(query_593927, "callback", newJString(callback))
  add(query_593927, "access_token", newJString(accessToken))
  add(query_593927, "uploadType", newJString(uploadType))
  add(query_593927, "key", newJString(key))
  add(query_593927, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593928 = body
  add(query_593927, "prettyPrint", newJBool(prettyPrint))
  add(path_593925, "serviceName", newJString(serviceName))
  result = call_593924.call(path_593925, query_593927, nil, nil, body_593928)

var servicecontrolServicesAllocateQuota* = Call_ServicecontrolServicesAllocateQuota_593677(
    name: "servicecontrolServicesAllocateQuota", meth: HttpMethod.HttpPost,
    host: "servicecontrol.googleapis.com",
    route: "/v1/services/{serviceName}:allocateQuota",
    validator: validate_ServicecontrolServicesAllocateQuota_593678, base: "/",
    url: url_ServicecontrolServicesAllocateQuota_593679, schemes: {Scheme.Https})
type
  Call_ServicecontrolServicesCheck_593967 = ref object of OpenApiRestCall_593408
proc url_ServicecontrolServicesCheck_593969(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: ":check")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicecontrolServicesCheck_593968(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether an operation on a service should be allowed to proceed
  ## based on the configuration of the service and related policies. It must be
  ## called before the operation is executed.
  ## 
  ## If feasible, the client should cache the check results and reuse them for
  ## 60 seconds. In case of any server errors, the client should rely on the
  ## cached results for much longer time to avoid outage.
  ## WARNING: There is general 60s delay for the configuration and policy
  ## propagation, therefore callers MUST NOT depend on the `Check` method having
  ## the latest policy information.
  ## 
  ## NOTE: the CheckRequest has the size limit of 64KB.
  ## 
  ## This method requires the `servicemanagement.services.check` permission
  ## on the specified service. For more information, see
  ## [Cloud IAM](https://cloud.google.com/iam).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The service name as specified in its service configuration. For example,
  ## `"pubsub.googleapis.com"`.
  ## 
  ## See
  ## 
  ## [google.api.Service](https://cloud.google.com/service-management/reference/rpc/google.api#google.api.Service)
  ## for the definition of a service name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_593970 = path.getOrDefault("serviceName")
  valid_593970 = validateParameter(valid_593970, JString, required = true,
                                 default = nil)
  if valid_593970 != nil:
    section.add "serviceName", valid_593970
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
  var valid_593971 = query.getOrDefault("upload_protocol")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "upload_protocol", valid_593971
  var valid_593972 = query.getOrDefault("fields")
  valid_593972 = validateParameter(valid_593972, JString, required = false,
                                 default = nil)
  if valid_593972 != nil:
    section.add "fields", valid_593972
  var valid_593973 = query.getOrDefault("quotaUser")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = nil)
  if valid_593973 != nil:
    section.add "quotaUser", valid_593973
  var valid_593974 = query.getOrDefault("alt")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = newJString("json"))
  if valid_593974 != nil:
    section.add "alt", valid_593974
  var valid_593975 = query.getOrDefault("oauth_token")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "oauth_token", valid_593975
  var valid_593976 = query.getOrDefault("callback")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "callback", valid_593976
  var valid_593977 = query.getOrDefault("access_token")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "access_token", valid_593977
  var valid_593978 = query.getOrDefault("uploadType")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = nil)
  if valid_593978 != nil:
    section.add "uploadType", valid_593978
  var valid_593979 = query.getOrDefault("key")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = nil)
  if valid_593979 != nil:
    section.add "key", valid_593979
  var valid_593980 = query.getOrDefault("$.xgafv")
  valid_593980 = validateParameter(valid_593980, JString, required = false,
                                 default = newJString("1"))
  if valid_593980 != nil:
    section.add "$.xgafv", valid_593980
  var valid_593981 = query.getOrDefault("prettyPrint")
  valid_593981 = validateParameter(valid_593981, JBool, required = false,
                                 default = newJBool(true))
  if valid_593981 != nil:
    section.add "prettyPrint", valid_593981
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

proc call*(call_593983: Call_ServicecontrolServicesCheck_593967; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether an operation on a service should be allowed to proceed
  ## based on the configuration of the service and related policies. It must be
  ## called before the operation is executed.
  ## 
  ## If feasible, the client should cache the check results and reuse them for
  ## 60 seconds. In case of any server errors, the client should rely on the
  ## cached results for much longer time to avoid outage.
  ## WARNING: There is general 60s delay for the configuration and policy
  ## propagation, therefore callers MUST NOT depend on the `Check` method having
  ## the latest policy information.
  ## 
  ## NOTE: the CheckRequest has the size limit of 64KB.
  ## 
  ## This method requires the `servicemanagement.services.check` permission
  ## on the specified service. For more information, see
  ## [Cloud IAM](https://cloud.google.com/iam).
  ## 
  let valid = call_593983.validator(path, query, header, formData, body)
  let scheme = call_593983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593983.url(scheme.get, call_593983.host, call_593983.base,
                         call_593983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593983, url, valid)

proc call*(call_593984: Call_ServicecontrolServicesCheck_593967;
          serviceName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## servicecontrolServicesCheck
  ## Checks whether an operation on a service should be allowed to proceed
  ## based on the configuration of the service and related policies. It must be
  ## called before the operation is executed.
  ## 
  ## If feasible, the client should cache the check results and reuse them for
  ## 60 seconds. In case of any server errors, the client should rely on the
  ## cached results for much longer time to avoid outage.
  ## WARNING: There is general 60s delay for the configuration and policy
  ## propagation, therefore callers MUST NOT depend on the `Check` method having
  ## the latest policy information.
  ## 
  ## NOTE: the CheckRequest has the size limit of 64KB.
  ## 
  ## This method requires the `servicemanagement.services.check` permission
  ## on the specified service. For more information, see
  ## [Cloud IAM](https://cloud.google.com/iam).
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
  ##              : The service name as specified in its service configuration. For example,
  ## `"pubsub.googleapis.com"`.
  ## 
  ## See
  ## 
  ## [google.api.Service](https://cloud.google.com/service-management/reference/rpc/google.api#google.api.Service)
  ## for the definition of a service name.
  var path_593985 = newJObject()
  var query_593986 = newJObject()
  var body_593987 = newJObject()
  add(query_593986, "upload_protocol", newJString(uploadProtocol))
  add(query_593986, "fields", newJString(fields))
  add(query_593986, "quotaUser", newJString(quotaUser))
  add(query_593986, "alt", newJString(alt))
  add(query_593986, "oauth_token", newJString(oauthToken))
  add(query_593986, "callback", newJString(callback))
  add(query_593986, "access_token", newJString(accessToken))
  add(query_593986, "uploadType", newJString(uploadType))
  add(query_593986, "key", newJString(key))
  add(query_593986, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593987 = body
  add(query_593986, "prettyPrint", newJBool(prettyPrint))
  add(path_593985, "serviceName", newJString(serviceName))
  result = call_593984.call(path_593985, query_593986, nil, nil, body_593987)

var servicecontrolServicesCheck* = Call_ServicecontrolServicesCheck_593967(
    name: "servicecontrolServicesCheck", meth: HttpMethod.HttpPost,
    host: "servicecontrol.googleapis.com",
    route: "/v1/services/{serviceName}:check",
    validator: validate_ServicecontrolServicesCheck_593968, base: "/",
    url: url_ServicecontrolServicesCheck_593969, schemes: {Scheme.Https})
type
  Call_ServicecontrolServicesReport_593988 = ref object of OpenApiRestCall_593408
proc url_ServicecontrolServicesReport_593990(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: ":report")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicecontrolServicesReport_593989(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reports operation results to Google Service Control, such as logs and
  ## metrics. It should be called after an operation is completed.
  ## 
  ## If feasible, the client should aggregate reporting data for up to 5
  ## seconds to reduce API traffic. Limiting aggregation to 5 seconds is to
  ## reduce data loss during client crashes. Clients should carefully choose
  ## the aggregation time window to avoid data loss risk more than 0.01%
  ## for business and compliance reasons.
  ## 
  ## NOTE: the ReportRequest has the size limit of 1MB.
  ## 
  ## This method requires the `servicemanagement.services.report` permission
  ## on the specified service. For more information, see
  ## [Google Cloud IAM](https://cloud.google.com/iam).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The service name as specified in its service configuration. For example,
  ## `"pubsub.googleapis.com"`.
  ## 
  ## See
  ## 
  ## [google.api.Service](https://cloud.google.com/service-management/reference/rpc/google.api#google.api.Service)
  ## for the definition of a service name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_593991 = path.getOrDefault("serviceName")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "serviceName", valid_593991
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
  var valid_593992 = query.getOrDefault("upload_protocol")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "upload_protocol", valid_593992
  var valid_593993 = query.getOrDefault("fields")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "fields", valid_593993
  var valid_593994 = query.getOrDefault("quotaUser")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "quotaUser", valid_593994
  var valid_593995 = query.getOrDefault("alt")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = newJString("json"))
  if valid_593995 != nil:
    section.add "alt", valid_593995
  var valid_593996 = query.getOrDefault("oauth_token")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "oauth_token", valid_593996
  var valid_593997 = query.getOrDefault("callback")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "callback", valid_593997
  var valid_593998 = query.getOrDefault("access_token")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = nil)
  if valid_593998 != nil:
    section.add "access_token", valid_593998
  var valid_593999 = query.getOrDefault("uploadType")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "uploadType", valid_593999
  var valid_594000 = query.getOrDefault("key")
  valid_594000 = validateParameter(valid_594000, JString, required = false,
                                 default = nil)
  if valid_594000 != nil:
    section.add "key", valid_594000
  var valid_594001 = query.getOrDefault("$.xgafv")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = newJString("1"))
  if valid_594001 != nil:
    section.add "$.xgafv", valid_594001
  var valid_594002 = query.getOrDefault("prettyPrint")
  valid_594002 = validateParameter(valid_594002, JBool, required = false,
                                 default = newJBool(true))
  if valid_594002 != nil:
    section.add "prettyPrint", valid_594002
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

proc call*(call_594004: Call_ServicecontrolServicesReport_593988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reports operation results to Google Service Control, such as logs and
  ## metrics. It should be called after an operation is completed.
  ## 
  ## If feasible, the client should aggregate reporting data for up to 5
  ## seconds to reduce API traffic. Limiting aggregation to 5 seconds is to
  ## reduce data loss during client crashes. Clients should carefully choose
  ## the aggregation time window to avoid data loss risk more than 0.01%
  ## for business and compliance reasons.
  ## 
  ## NOTE: the ReportRequest has the size limit of 1MB.
  ## 
  ## This method requires the `servicemanagement.services.report` permission
  ## on the specified service. For more information, see
  ## [Google Cloud IAM](https://cloud.google.com/iam).
  ## 
  let valid = call_594004.validator(path, query, header, formData, body)
  let scheme = call_594004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594004.url(scheme.get, call_594004.host, call_594004.base,
                         call_594004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594004, url, valid)

proc call*(call_594005: Call_ServicecontrolServicesReport_593988;
          serviceName: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## servicecontrolServicesReport
  ## Reports operation results to Google Service Control, such as logs and
  ## metrics. It should be called after an operation is completed.
  ## 
  ## If feasible, the client should aggregate reporting data for up to 5
  ## seconds to reduce API traffic. Limiting aggregation to 5 seconds is to
  ## reduce data loss during client crashes. Clients should carefully choose
  ## the aggregation time window to avoid data loss risk more than 0.01%
  ## for business and compliance reasons.
  ## 
  ## NOTE: the ReportRequest has the size limit of 1MB.
  ## 
  ## This method requires the `servicemanagement.services.report` permission
  ## on the specified service. For more information, see
  ## [Google Cloud IAM](https://cloud.google.com/iam).
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
  ##              : The service name as specified in its service configuration. For example,
  ## `"pubsub.googleapis.com"`.
  ## 
  ## See
  ## 
  ## [google.api.Service](https://cloud.google.com/service-management/reference/rpc/google.api#google.api.Service)
  ## for the definition of a service name.
  var path_594006 = newJObject()
  var query_594007 = newJObject()
  var body_594008 = newJObject()
  add(query_594007, "upload_protocol", newJString(uploadProtocol))
  add(query_594007, "fields", newJString(fields))
  add(query_594007, "quotaUser", newJString(quotaUser))
  add(query_594007, "alt", newJString(alt))
  add(query_594007, "oauth_token", newJString(oauthToken))
  add(query_594007, "callback", newJString(callback))
  add(query_594007, "access_token", newJString(accessToken))
  add(query_594007, "uploadType", newJString(uploadType))
  add(query_594007, "key", newJString(key))
  add(query_594007, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594008 = body
  add(query_594007, "prettyPrint", newJBool(prettyPrint))
  add(path_594006, "serviceName", newJString(serviceName))
  result = call_594005.call(path_594006, query_594007, nil, nil, body_594008)

var servicecontrolServicesReport* = Call_ServicecontrolServicesReport_593988(
    name: "servicecontrolServicesReport", meth: HttpMethod.HttpPost,
    host: "servicecontrol.googleapis.com",
    route: "/v1/services/{serviceName}:report",
    validator: validate_ServicecontrolServicesReport_593989, base: "/",
    url: url_ServicecontrolServicesReport_593990, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
