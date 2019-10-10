
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Service Broker
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## The Google Cloud Platform Service Broker API provides Google hosted
## implementation of the Open Service Broker API
## (https://www.openservicebrokerapi.org/).
## 
## 
## https://cloud.google.com/kubernetes-engine/docs/concepts/add-on/service-broker
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

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
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
  gcpServiceName = "servicebroker"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_588710 = ref object of OpenApiRestCall_588441
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_588712(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_588711(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## GetBinding returns the binding information.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name must match
  ## 
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]/v2/service_instances/[INSTANCE_ID]/service_bindings`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_588838 = path.getOrDefault("name")
  valid_588838 = validateParameter(valid_588838, JString, required = true,
                                 default = nil)
  if valid_588838 != nil:
    section.add "name", valid_588838
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
  ##   planId: JString
  ##         : Plan id.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   serviceId: JString
  ##            : Service id.
  section = newJObject()
  var valid_588839 = query.getOrDefault("upload_protocol")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "upload_protocol", valid_588839
  var valid_588840 = query.getOrDefault("fields")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "fields", valid_588840
  var valid_588841 = query.getOrDefault("quotaUser")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "quotaUser", valid_588841
  var valid_588855 = query.getOrDefault("alt")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = newJString("json"))
  if valid_588855 != nil:
    section.add "alt", valid_588855
  var valid_588856 = query.getOrDefault("oauth_token")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "oauth_token", valid_588856
  var valid_588857 = query.getOrDefault("callback")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "callback", valid_588857
  var valid_588858 = query.getOrDefault("access_token")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "access_token", valid_588858
  var valid_588859 = query.getOrDefault("uploadType")
  valid_588859 = validateParameter(valid_588859, JString, required = false,
                                 default = nil)
  if valid_588859 != nil:
    section.add "uploadType", valid_588859
  var valid_588860 = query.getOrDefault("key")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "key", valid_588860
  var valid_588861 = query.getOrDefault("$.xgafv")
  valid_588861 = validateParameter(valid_588861, JString, required = false,
                                 default = newJString("1"))
  if valid_588861 != nil:
    section.add "$.xgafv", valid_588861
  var valid_588862 = query.getOrDefault("planId")
  valid_588862 = validateParameter(valid_588862, JString, required = false,
                                 default = nil)
  if valid_588862 != nil:
    section.add "planId", valid_588862
  var valid_588863 = query.getOrDefault("prettyPrint")
  valid_588863 = validateParameter(valid_588863, JBool, required = false,
                                 default = newJBool(true))
  if valid_588863 != nil:
    section.add "prettyPrint", valid_588863
  var valid_588864 = query.getOrDefault("serviceId")
  valid_588864 = validateParameter(valid_588864, JString, required = false,
                                 default = nil)
  if valid_588864 != nil:
    section.add "serviceId", valid_588864
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588887: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_588710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## GetBinding returns the binding information.
  ## 
  let valid = call_588887.validator(path, query, header, formData, body)
  let scheme = call_588887.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588887.url(scheme.get, call_588887.host, call_588887.base,
                         call_588887.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588887, url, valid)

proc call*(call_588958: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_588710;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; planId: string = "";
          prettyPrint: bool = true; serviceId: string = ""): Recallable =
  ## servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet
  ## GetBinding returns the binding information.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name must match
  ## 
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]/v2/service_instances/[INSTANCE_ID]/service_bindings`.
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
  ##   planId: string
  ##         : Plan id.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   serviceId: string
  ##            : Service id.
  var path_588959 = newJObject()
  var query_588961 = newJObject()
  add(query_588961, "upload_protocol", newJString(uploadProtocol))
  add(query_588961, "fields", newJString(fields))
  add(query_588961, "quotaUser", newJString(quotaUser))
  add(path_588959, "name", newJString(name))
  add(query_588961, "alt", newJString(alt))
  add(query_588961, "oauth_token", newJString(oauthToken))
  add(query_588961, "callback", newJString(callback))
  add(query_588961, "access_token", newJString(accessToken))
  add(query_588961, "uploadType", newJString(uploadType))
  add(query_588961, "key", newJString(key))
  add(query_588961, "$.xgafv", newJString(Xgafv))
  add(query_588961, "planId", newJString(planId))
  add(query_588961, "prettyPrint", newJBool(prettyPrint))
  add(query_588961, "serviceId", newJString(serviceId))
  result = call_588958.call(path_588959, query_588961, nil, nil, nil)

var servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_588710(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com",
    route: "/v1beta1/{name}", validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_588711,
    base: "/",
    url: url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_588712,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_589022 = ref object of OpenApiRestCall_588441
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_589024(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_589023(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates an existing service instance.
  ## See CreateServiceInstance for possible response codes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name must match
  ## 
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]/v2/service_instances/[INSTANCE_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589025 = path.getOrDefault("name")
  valid_589025 = validateParameter(valid_589025, JString, required = true,
                                 default = nil)
  if valid_589025 != nil:
    section.add "name", valid_589025
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
  ##   acceptsIncomplete: JBool
  ##                    : See CreateServiceInstanceRequest for details.
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
  var valid_589026 = query.getOrDefault("upload_protocol")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "upload_protocol", valid_589026
  var valid_589027 = query.getOrDefault("fields")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "fields", valid_589027
  var valid_589028 = query.getOrDefault("quotaUser")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "quotaUser", valid_589028
  var valid_589029 = query.getOrDefault("alt")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = newJString("json"))
  if valid_589029 != nil:
    section.add "alt", valid_589029
  var valid_589030 = query.getOrDefault("acceptsIncomplete")
  valid_589030 = validateParameter(valid_589030, JBool, required = false, default = nil)
  if valid_589030 != nil:
    section.add "acceptsIncomplete", valid_589030
  var valid_589031 = query.getOrDefault("oauth_token")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "oauth_token", valid_589031
  var valid_589032 = query.getOrDefault("callback")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "callback", valid_589032
  var valid_589033 = query.getOrDefault("access_token")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "access_token", valid_589033
  var valid_589034 = query.getOrDefault("uploadType")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "uploadType", valid_589034
  var valid_589035 = query.getOrDefault("key")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "key", valid_589035
  var valid_589036 = query.getOrDefault("$.xgafv")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = newJString("1"))
  if valid_589036 != nil:
    section.add "$.xgafv", valid_589036
  var valid_589037 = query.getOrDefault("prettyPrint")
  valid_589037 = validateParameter(valid_589037, JBool, required = false,
                                 default = newJBool(true))
  if valid_589037 != nil:
    section.add "prettyPrint", valid_589037
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

proc call*(call_589039: Call_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_589022;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing service instance.
  ## See CreateServiceInstance for possible response codes.
  ## 
  let valid = call_589039.validator(path, query, header, formData, body)
  let scheme = call_589039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589039.url(scheme.get, call_589039.host, call_589039.base,
                         call_589039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589039, url, valid)

proc call*(call_589040: Call_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_589022;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; acceptsIncomplete: bool = false;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## servicebrokerProjectsBrokersV2ServiceInstancesPatch
  ## Updates an existing service instance.
  ## See CreateServiceInstance for possible response codes.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name must match
  ## 
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]/v2/service_instances/[INSTANCE_ID]`.
  ##   alt: string
  ##      : Data format for response.
  ##   acceptsIncomplete: bool
  ##                    : See CreateServiceInstanceRequest for details.
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
  var path_589041 = newJObject()
  var query_589042 = newJObject()
  var body_589043 = newJObject()
  add(query_589042, "upload_protocol", newJString(uploadProtocol))
  add(query_589042, "fields", newJString(fields))
  add(query_589042, "quotaUser", newJString(quotaUser))
  add(path_589041, "name", newJString(name))
  add(query_589042, "alt", newJString(alt))
  add(query_589042, "acceptsIncomplete", newJBool(acceptsIncomplete))
  add(query_589042, "oauth_token", newJString(oauthToken))
  add(query_589042, "callback", newJString(callback))
  add(query_589042, "access_token", newJString(accessToken))
  add(query_589042, "uploadType", newJString(uploadType))
  add(query_589042, "key", newJString(key))
  add(query_589042, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589043 = body
  add(query_589042, "prettyPrint", newJBool(prettyPrint))
  result = call_589040.call(path_589041, query_589042, nil, nil, body_589043)

var servicebrokerProjectsBrokersV2ServiceInstancesPatch* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_589022(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesPatch",
    meth: HttpMethod.HttpPatch, host: "servicebroker.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_589023,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_589024,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete_589000 = ref object of OpenApiRestCall_588441
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete_589002(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete_589001(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Unbinds from a service instance.
  ## For synchronous/asynchronous request details see CreateServiceInstance
  ## method.
  ## If binding does not exist HTTP 410 status will be returned.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name must match
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]/`
  ## `v2/service_instances/[INSTANCE_ID]/service_bindings/[BINDING_ID]`
  ## or
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]/`
  ## `/instances/[INSTANCE_ID]/bindings/[BINDING_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589003 = path.getOrDefault("name")
  valid_589003 = validateParameter(valid_589003, JString, required = true,
                                 default = nil)
  if valid_589003 != nil:
    section.add "name", valid_589003
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
  ##   acceptsIncomplete: JBool
  ##                    : See CreateServiceInstanceRequest for details.
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
  ##   planId: JString
  ##         : The plan id of the service instance.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   serviceId: JString
  ##            : Additional query parameter hints.
  ## The service id of the service instance.
  section = newJObject()
  var valid_589004 = query.getOrDefault("upload_protocol")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "upload_protocol", valid_589004
  var valid_589005 = query.getOrDefault("fields")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "fields", valid_589005
  var valid_589006 = query.getOrDefault("quotaUser")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "quotaUser", valid_589006
  var valid_589007 = query.getOrDefault("alt")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = newJString("json"))
  if valid_589007 != nil:
    section.add "alt", valid_589007
  var valid_589008 = query.getOrDefault("acceptsIncomplete")
  valid_589008 = validateParameter(valid_589008, JBool, required = false, default = nil)
  if valid_589008 != nil:
    section.add "acceptsIncomplete", valid_589008
  var valid_589009 = query.getOrDefault("oauth_token")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "oauth_token", valid_589009
  var valid_589010 = query.getOrDefault("callback")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "callback", valid_589010
  var valid_589011 = query.getOrDefault("access_token")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "access_token", valid_589011
  var valid_589012 = query.getOrDefault("uploadType")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "uploadType", valid_589012
  var valid_589013 = query.getOrDefault("key")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "key", valid_589013
  var valid_589014 = query.getOrDefault("$.xgafv")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = newJString("1"))
  if valid_589014 != nil:
    section.add "$.xgafv", valid_589014
  var valid_589015 = query.getOrDefault("planId")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "planId", valid_589015
  var valid_589016 = query.getOrDefault("prettyPrint")
  valid_589016 = validateParameter(valid_589016, JBool, required = false,
                                 default = newJBool(true))
  if valid_589016 != nil:
    section.add "prettyPrint", valid_589016
  var valid_589017 = query.getOrDefault("serviceId")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "serviceId", valid_589017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589018: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete_589000;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unbinds from a service instance.
  ## For synchronous/asynchronous request details see CreateServiceInstance
  ## method.
  ## If binding does not exist HTTP 410 status will be returned.
  ## 
  let valid = call_589018.validator(path, query, header, formData, body)
  let scheme = call_589018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589018.url(scheme.get, call_589018.host, call_589018.base,
                         call_589018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589018, url, valid)

proc call*(call_589019: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete_589000;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; acceptsIncomplete: bool = false;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          planId: string = ""; prettyPrint: bool = true; serviceId: string = ""): Recallable =
  ## servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete
  ## Unbinds from a service instance.
  ## For synchronous/asynchronous request details see CreateServiceInstance
  ## method.
  ## If binding does not exist HTTP 410 status will be returned.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name must match
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]/`
  ## `v2/service_instances/[INSTANCE_ID]/service_bindings/[BINDING_ID]`
  ## or
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]/`
  ## `/instances/[INSTANCE_ID]/bindings/[BINDING_ID]`.
  ##   alt: string
  ##      : Data format for response.
  ##   acceptsIncomplete: bool
  ##                    : See CreateServiceInstanceRequest for details.
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
  ##   planId: string
  ##         : The plan id of the service instance.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   serviceId: string
  ##            : Additional query parameter hints.
  ## The service id of the service instance.
  var path_589020 = newJObject()
  var query_589021 = newJObject()
  add(query_589021, "upload_protocol", newJString(uploadProtocol))
  add(query_589021, "fields", newJString(fields))
  add(query_589021, "quotaUser", newJString(quotaUser))
  add(path_589020, "name", newJString(name))
  add(query_589021, "alt", newJString(alt))
  add(query_589021, "acceptsIncomplete", newJBool(acceptsIncomplete))
  add(query_589021, "oauth_token", newJString(oauthToken))
  add(query_589021, "callback", newJString(callback))
  add(query_589021, "access_token", newJString(accessToken))
  add(query_589021, "uploadType", newJString(uploadType))
  add(query_589021, "key", newJString(key))
  add(query_589021, "$.xgafv", newJString(Xgafv))
  add(query_589021, "planId", newJString(planId))
  add(query_589021, "prettyPrint", newJBool(prettyPrint))
  add(query_589021, "serviceId", newJString(serviceId))
  result = call_589019.call(path_589020, query_589021, nil, nil, nil)

var servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete_589000(name: "servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete",
    meth: HttpMethod.HttpDelete, host: "servicebroker.googleapis.com",
    route: "/v1beta1/{name}", validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete_589001,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete_589002,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_589044 = ref object of OpenApiRestCall_588441
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_589046(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/last_operation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_589045(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns the state of the last operation for the binding.
  ## Only last (or current) operation can be polled.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name must match
  ## 
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]/v2/service_instances/[INSTANCE_ID]/service_binding/[BINDING_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589047 = path.getOrDefault("name")
  valid_589047 = validateParameter(valid_589047, JString, required = true,
                                 default = nil)
  if valid_589047 != nil:
    section.add "name", valid_589047
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
  ##   planId: JString
  ##         : Plan id.
  ##   operation: JString
  ##            : If `operation` was returned during mutation operation, this field must be
  ## populated with the provided value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   serviceId: JString
  ##            : Service id.
  section = newJObject()
  var valid_589048 = query.getOrDefault("upload_protocol")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "upload_protocol", valid_589048
  var valid_589049 = query.getOrDefault("fields")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "fields", valid_589049
  var valid_589050 = query.getOrDefault("quotaUser")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "quotaUser", valid_589050
  var valid_589051 = query.getOrDefault("alt")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = newJString("json"))
  if valid_589051 != nil:
    section.add "alt", valid_589051
  var valid_589052 = query.getOrDefault("oauth_token")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "oauth_token", valid_589052
  var valid_589053 = query.getOrDefault("callback")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "callback", valid_589053
  var valid_589054 = query.getOrDefault("access_token")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "access_token", valid_589054
  var valid_589055 = query.getOrDefault("uploadType")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "uploadType", valid_589055
  var valid_589056 = query.getOrDefault("key")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "key", valid_589056
  var valid_589057 = query.getOrDefault("$.xgafv")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = newJString("1"))
  if valid_589057 != nil:
    section.add "$.xgafv", valid_589057
  var valid_589058 = query.getOrDefault("planId")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "planId", valid_589058
  var valid_589059 = query.getOrDefault("operation")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "operation", valid_589059
  var valid_589060 = query.getOrDefault("prettyPrint")
  valid_589060 = validateParameter(valid_589060, JBool, required = false,
                                 default = newJBool(true))
  if valid_589060 != nil:
    section.add "prettyPrint", valid_589060
  var valid_589061 = query.getOrDefault("serviceId")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "serviceId", valid_589061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589062: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_589044;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the state of the last operation for the binding.
  ## Only last (or current) operation can be polled.
  ## 
  let valid = call_589062.validator(path, query, header, formData, body)
  let scheme = call_589062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589062.url(scheme.get, call_589062.host, call_589062.base,
                         call_589062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589062, url, valid)

proc call*(call_589063: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_589044;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; planId: string = "";
          operation: string = ""; prettyPrint: bool = true; serviceId: string = ""): Recallable =
  ## servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation
  ## Returns the state of the last operation for the binding.
  ## Only last (or current) operation can be polled.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name must match
  ## 
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]/v2/service_instances/[INSTANCE_ID]/service_binding/[BINDING_ID]`.
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
  ##   planId: string
  ##         : Plan id.
  ##   operation: string
  ##            : If `operation` was returned during mutation operation, this field must be
  ## populated with the provided value.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   serviceId: string
  ##            : Service id.
  var path_589064 = newJObject()
  var query_589065 = newJObject()
  add(query_589065, "upload_protocol", newJString(uploadProtocol))
  add(query_589065, "fields", newJString(fields))
  add(query_589065, "quotaUser", newJString(quotaUser))
  add(path_589064, "name", newJString(name))
  add(query_589065, "alt", newJString(alt))
  add(query_589065, "oauth_token", newJString(oauthToken))
  add(query_589065, "callback", newJString(callback))
  add(query_589065, "access_token", newJString(accessToken))
  add(query_589065, "uploadType", newJString(uploadType))
  add(query_589065, "key", newJString(key))
  add(query_589065, "$.xgafv", newJString(Xgafv))
  add(query_589065, "planId", newJString(planId))
  add(query_589065, "operation", newJString(operation))
  add(query_589065, "prettyPrint", newJBool(prettyPrint))
  add(query_589065, "serviceId", newJString(serviceId))
  result = call_589063.call(path_589064, query_589065, nil, nil, nil)

var servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_589044(name: "servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com",
    route: "/v1beta1/{name}/last_operation", validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_589045,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_589046,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersInstancesBindingsList_589066 = ref object of OpenApiRestCall_588441
proc url_ServicebrokerProjectsBrokersInstancesBindingsList_589068(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/bindings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicebrokerProjectsBrokersInstancesBindingsList_589067(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all the bindings in the instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Parent must match
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]/` +
  ## `v2/service_instances/[INSTANCE_ID]`
  ## or
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]/instances/[INSTANCE_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589069 = path.getOrDefault("parent")
  valid_589069 = validateParameter(valid_589069, JString, required = true,
                                 default = nil)
  if valid_589069 != nil:
    section.add "parent", valid_589069
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
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
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ## Optional. Acceptable values are 0 to 200, inclusive. (Default: 100)
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589070 = query.getOrDefault("upload_protocol")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "upload_protocol", valid_589070
  var valid_589071 = query.getOrDefault("fields")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "fields", valid_589071
  var valid_589072 = query.getOrDefault("pageToken")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "pageToken", valid_589072
  var valid_589073 = query.getOrDefault("quotaUser")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "quotaUser", valid_589073
  var valid_589074 = query.getOrDefault("alt")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = newJString("json"))
  if valid_589074 != nil:
    section.add "alt", valid_589074
  var valid_589075 = query.getOrDefault("oauth_token")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "oauth_token", valid_589075
  var valid_589076 = query.getOrDefault("callback")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "callback", valid_589076
  var valid_589077 = query.getOrDefault("access_token")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "access_token", valid_589077
  var valid_589078 = query.getOrDefault("uploadType")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "uploadType", valid_589078
  var valid_589079 = query.getOrDefault("key")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "key", valid_589079
  var valid_589080 = query.getOrDefault("$.xgafv")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = newJString("1"))
  if valid_589080 != nil:
    section.add "$.xgafv", valid_589080
  var valid_589081 = query.getOrDefault("pageSize")
  valid_589081 = validateParameter(valid_589081, JInt, required = false, default = nil)
  if valid_589081 != nil:
    section.add "pageSize", valid_589081
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

proc call*(call_589083: Call_ServicebrokerProjectsBrokersInstancesBindingsList_589066;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the bindings in the instance.
  ## 
  let valid = call_589083.validator(path, query, header, formData, body)
  let scheme = call_589083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589083.url(scheme.get, call_589083.host, call_589083.base,
                         call_589083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589083, url, valid)

proc call*(call_589084: Call_ServicebrokerProjectsBrokersInstancesBindingsList_589066;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## servicebrokerProjectsBrokersInstancesBindingsList
  ## Lists all the bindings in the instance.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
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
  ##         : Parent must match
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]/` +
  ## `v2/service_instances/[INSTANCE_ID]`
  ## or
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]/instances/[INSTANCE_ID]`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ## Optional. Acceptable values are 0 to 200, inclusive. (Default: 100)
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589085 = newJObject()
  var query_589086 = newJObject()
  add(query_589086, "upload_protocol", newJString(uploadProtocol))
  add(query_589086, "fields", newJString(fields))
  add(query_589086, "pageToken", newJString(pageToken))
  add(query_589086, "quotaUser", newJString(quotaUser))
  add(query_589086, "alt", newJString(alt))
  add(query_589086, "oauth_token", newJString(oauthToken))
  add(query_589086, "callback", newJString(callback))
  add(query_589086, "access_token", newJString(accessToken))
  add(query_589086, "uploadType", newJString(uploadType))
  add(path_589085, "parent", newJString(parent))
  add(query_589086, "key", newJString(key))
  add(query_589086, "$.xgafv", newJString(Xgafv))
  add(query_589086, "pageSize", newJInt(pageSize))
  add(query_589086, "prettyPrint", newJBool(prettyPrint))
  result = call_589084.call(path_589085, query_589086, nil, nil, nil)

var servicebrokerProjectsBrokersInstancesBindingsList* = Call_ServicebrokerProjectsBrokersInstancesBindingsList_589066(
    name: "servicebrokerProjectsBrokersInstancesBindingsList",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com",
    route: "/v1beta1/{parent}/bindings",
    validator: validate_ServicebrokerProjectsBrokersInstancesBindingsList_589067,
    base: "/", url: url_ServicebrokerProjectsBrokersInstancesBindingsList_589068,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersCreate_589108 = ref object of OpenApiRestCall_588441
proc url_ServicebrokerProjectsBrokersCreate_589110(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/brokers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicebrokerProjectsBrokersCreate_589109(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## CreateBroker creates a Broker.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project in which to create broker.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589111 = path.getOrDefault("parent")
  valid_589111 = validateParameter(valid_589111, JString, required = true,
                                 default = nil)
  if valid_589111 != nil:
    section.add "parent", valid_589111
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
  var valid_589114 = query.getOrDefault("quotaUser")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "quotaUser", valid_589114
  var valid_589115 = query.getOrDefault("alt")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = newJString("json"))
  if valid_589115 != nil:
    section.add "alt", valid_589115
  var valid_589116 = query.getOrDefault("oauth_token")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "oauth_token", valid_589116
  var valid_589117 = query.getOrDefault("callback")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "callback", valid_589117
  var valid_589118 = query.getOrDefault("access_token")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "access_token", valid_589118
  var valid_589119 = query.getOrDefault("uploadType")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "uploadType", valid_589119
  var valid_589120 = query.getOrDefault("key")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "key", valid_589120
  var valid_589121 = query.getOrDefault("$.xgafv")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = newJString("1"))
  if valid_589121 != nil:
    section.add "$.xgafv", valid_589121
  var valid_589122 = query.getOrDefault("prettyPrint")
  valid_589122 = validateParameter(valid_589122, JBool, required = false,
                                 default = newJBool(true))
  if valid_589122 != nil:
    section.add "prettyPrint", valid_589122
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

proc call*(call_589124: Call_ServicebrokerProjectsBrokersCreate_589108;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## CreateBroker creates a Broker.
  ## 
  let valid = call_589124.validator(path, query, header, formData, body)
  let scheme = call_589124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589124.url(scheme.get, call_589124.host, call_589124.base,
                         call_589124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589124, url, valid)

proc call*(call_589125: Call_ServicebrokerProjectsBrokersCreate_589108;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## servicebrokerProjectsBrokersCreate
  ## CreateBroker creates a Broker.
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
  ##         : The project in which to create broker.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589126 = newJObject()
  var query_589127 = newJObject()
  var body_589128 = newJObject()
  add(query_589127, "upload_protocol", newJString(uploadProtocol))
  add(query_589127, "fields", newJString(fields))
  add(query_589127, "quotaUser", newJString(quotaUser))
  add(query_589127, "alt", newJString(alt))
  add(query_589127, "oauth_token", newJString(oauthToken))
  add(query_589127, "callback", newJString(callback))
  add(query_589127, "access_token", newJString(accessToken))
  add(query_589127, "uploadType", newJString(uploadType))
  add(path_589126, "parent", newJString(parent))
  add(query_589127, "key", newJString(key))
  add(query_589127, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589128 = body
  add(query_589127, "prettyPrint", newJBool(prettyPrint))
  result = call_589125.call(path_589126, query_589127, nil, nil, body_589128)

var servicebrokerProjectsBrokersCreate* = Call_ServicebrokerProjectsBrokersCreate_589108(
    name: "servicebrokerProjectsBrokersCreate", meth: HttpMethod.HttpPost,
    host: "servicebroker.googleapis.com", route: "/v1beta1/{parent}/brokers",
    validator: validate_ServicebrokerProjectsBrokersCreate_589109, base: "/",
    url: url_ServicebrokerProjectsBrokersCreate_589110, schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersList_589087 = ref object of OpenApiRestCall_588441
proc url_ServicebrokerProjectsBrokersList_589089(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/brokers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicebrokerProjectsBrokersList_589088(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## ListBrokers lists brokers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589090 = path.getOrDefault("parent")
  valid_589090 = validateParameter(valid_589090, JString, required = true,
                                 default = nil)
  if valid_589090 != nil:
    section.add "parent", valid_589090
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
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
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ## Optional. Acceptable values are 0 to 200, inclusive. (Default: 100)
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
  var valid_589093 = query.getOrDefault("pageToken")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "pageToken", valid_589093
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
  var valid_589100 = query.getOrDefault("key")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "key", valid_589100
  var valid_589101 = query.getOrDefault("$.xgafv")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = newJString("1"))
  if valid_589101 != nil:
    section.add "$.xgafv", valid_589101
  var valid_589102 = query.getOrDefault("pageSize")
  valid_589102 = validateParameter(valid_589102, JInt, required = false, default = nil)
  if valid_589102 != nil:
    section.add "pageSize", valid_589102
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

proc call*(call_589104: Call_ServicebrokerProjectsBrokersList_589087;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## ListBrokers lists brokers.
  ## 
  let valid = call_589104.validator(path, query, header, formData, body)
  let scheme = call_589104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589104.url(scheme.get, call_589104.host, call_589104.base,
                         call_589104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589104, url, valid)

proc call*(call_589105: Call_ServicebrokerProjectsBrokersList_589087;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## servicebrokerProjectsBrokersList
  ## ListBrokers lists brokers.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
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
  ##         : Parent must match `projects/[PROJECT_ID]/brokers`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ## Optional. Acceptable values are 0 to 200, inclusive. (Default: 100)
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589106 = newJObject()
  var query_589107 = newJObject()
  add(query_589107, "upload_protocol", newJString(uploadProtocol))
  add(query_589107, "fields", newJString(fields))
  add(query_589107, "pageToken", newJString(pageToken))
  add(query_589107, "quotaUser", newJString(quotaUser))
  add(query_589107, "alt", newJString(alt))
  add(query_589107, "oauth_token", newJString(oauthToken))
  add(query_589107, "callback", newJString(callback))
  add(query_589107, "access_token", newJString(accessToken))
  add(query_589107, "uploadType", newJString(uploadType))
  add(path_589106, "parent", newJString(parent))
  add(query_589107, "key", newJString(key))
  add(query_589107, "$.xgafv", newJString(Xgafv))
  add(query_589107, "pageSize", newJInt(pageSize))
  add(query_589107, "prettyPrint", newJBool(prettyPrint))
  result = call_589105.call(path_589106, query_589107, nil, nil, nil)

var servicebrokerProjectsBrokersList* = Call_ServicebrokerProjectsBrokersList_589087(
    name: "servicebrokerProjectsBrokersList", meth: HttpMethod.HttpGet,
    host: "servicebroker.googleapis.com", route: "/v1beta1/{parent}/brokers",
    validator: validate_ServicebrokerProjectsBrokersList_589088, base: "/",
    url: url_ServicebrokerProjectsBrokersList_589089, schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersInstancesList_589129 = ref object of OpenApiRestCall_588441
proc url_ServicebrokerProjectsBrokersInstancesList_589131(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/instances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicebrokerProjectsBrokersInstancesList_589130(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the instances in the brokers
  ## This API is an extension and not part of the OSB spec.
  ## Hence the path is a standard Google API URL.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589132 = path.getOrDefault("parent")
  valid_589132 = validateParameter(valid_589132, JString, required = true,
                                 default = nil)
  if valid_589132 != nil:
    section.add "parent", valid_589132
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
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
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ## Optional. Acceptable values are 0 to 200, inclusive. (Default: 100)
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
  var valid_589135 = query.getOrDefault("pageToken")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "pageToken", valid_589135
  var valid_589136 = query.getOrDefault("quotaUser")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "quotaUser", valid_589136
  var valid_589137 = query.getOrDefault("alt")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = newJString("json"))
  if valid_589137 != nil:
    section.add "alt", valid_589137
  var valid_589138 = query.getOrDefault("oauth_token")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "oauth_token", valid_589138
  var valid_589139 = query.getOrDefault("callback")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "callback", valid_589139
  var valid_589140 = query.getOrDefault("access_token")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "access_token", valid_589140
  var valid_589141 = query.getOrDefault("uploadType")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "uploadType", valid_589141
  var valid_589142 = query.getOrDefault("key")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "key", valid_589142
  var valid_589143 = query.getOrDefault("$.xgafv")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = newJString("1"))
  if valid_589143 != nil:
    section.add "$.xgafv", valid_589143
  var valid_589144 = query.getOrDefault("pageSize")
  valid_589144 = validateParameter(valid_589144, JInt, required = false, default = nil)
  if valid_589144 != nil:
    section.add "pageSize", valid_589144
  var valid_589145 = query.getOrDefault("prettyPrint")
  valid_589145 = validateParameter(valid_589145, JBool, required = false,
                                 default = newJBool(true))
  if valid_589145 != nil:
    section.add "prettyPrint", valid_589145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589146: Call_ServicebrokerProjectsBrokersInstancesList_589129;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the instances in the brokers
  ## This API is an extension and not part of the OSB spec.
  ## Hence the path is a standard Google API URL.
  ## 
  let valid = call_589146.validator(path, query, header, formData, body)
  let scheme = call_589146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589146.url(scheme.get, call_589146.host, call_589146.base,
                         call_589146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589146, url, valid)

proc call*(call_589147: Call_ServicebrokerProjectsBrokersInstancesList_589129;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## servicebrokerProjectsBrokersInstancesList
  ## Lists all the instances in the brokers
  ## This API is an extension and not part of the OSB spec.
  ## Hence the path is a standard Google API URL.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
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
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ## Optional. Acceptable values are 0 to 200, inclusive. (Default: 100)
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589148 = newJObject()
  var query_589149 = newJObject()
  add(query_589149, "upload_protocol", newJString(uploadProtocol))
  add(query_589149, "fields", newJString(fields))
  add(query_589149, "pageToken", newJString(pageToken))
  add(query_589149, "quotaUser", newJString(quotaUser))
  add(query_589149, "alt", newJString(alt))
  add(query_589149, "oauth_token", newJString(oauthToken))
  add(query_589149, "callback", newJString(callback))
  add(query_589149, "access_token", newJString(accessToken))
  add(query_589149, "uploadType", newJString(uploadType))
  add(path_589148, "parent", newJString(parent))
  add(query_589149, "key", newJString(key))
  add(query_589149, "$.xgafv", newJString(Xgafv))
  add(query_589149, "pageSize", newJInt(pageSize))
  add(query_589149, "prettyPrint", newJBool(prettyPrint))
  result = call_589147.call(path_589148, query_589149, nil, nil, nil)

var servicebrokerProjectsBrokersInstancesList* = Call_ServicebrokerProjectsBrokersInstancesList_589129(
    name: "servicebrokerProjectsBrokersInstancesList", meth: HttpMethod.HttpGet,
    host: "servicebroker.googleapis.com", route: "/v1beta1/{parent}/instances",
    validator: validate_ServicebrokerProjectsBrokersInstancesList_589130,
    base: "/", url: url_ServicebrokerProjectsBrokersInstancesList_589131,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_589150 = ref object of OpenApiRestCall_588441
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_589152(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "binding_id" in path, "`binding_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/service_bindings/"),
               (kind: VariableSegment, value: "binding_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_589151(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## CreateBinding generates a service binding to an existing service instance.
  ## See ProviServiceInstance for async operation details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The GCP container.
  ## Must match
  ## 
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]/v2/service_instances/[INSTANCE_ID]`.
  ##   binding_id: JString (required)
  ##             : The id of the binding. Must be unique within GCP project.
  ## Maximum length is 64, GUID recommended.
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589153 = path.getOrDefault("parent")
  valid_589153 = validateParameter(valid_589153, JString, required = true,
                                 default = nil)
  if valid_589153 != nil:
    section.add "parent", valid_589153
  var valid_589154 = path.getOrDefault("binding_id")
  valid_589154 = validateParameter(valid_589154, JString, required = true,
                                 default = nil)
  if valid_589154 != nil:
    section.add "binding_id", valid_589154
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
  ##   acceptsIncomplete: JBool
  ##                    : See CreateServiceInstanceRequest for details.
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
  var valid_589157 = query.getOrDefault("quotaUser")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "quotaUser", valid_589157
  var valid_589158 = query.getOrDefault("alt")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = newJString("json"))
  if valid_589158 != nil:
    section.add "alt", valid_589158
  var valid_589159 = query.getOrDefault("acceptsIncomplete")
  valid_589159 = validateParameter(valid_589159, JBool, required = false, default = nil)
  if valid_589159 != nil:
    section.add "acceptsIncomplete", valid_589159
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589168: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_589150;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## CreateBinding generates a service binding to an existing service instance.
  ## See ProviServiceInstance for async operation details.
  ## 
  let valid = call_589168.validator(path, query, header, formData, body)
  let scheme = call_589168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589168.url(scheme.get, call_589168.host, call_589168.base,
                         call_589168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589168, url, valid)

proc call*(call_589169: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_589150;
          parent: string; bindingId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          acceptsIncomplete: bool = false; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate
  ## CreateBinding generates a service binding to an existing service instance.
  ## See ProviServiceInstance for async operation details.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   acceptsIncomplete: bool
  ##                    : See CreateServiceInstanceRequest for details.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : The GCP container.
  ## Must match
  ## 
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]/v2/service_instances/[INSTANCE_ID]`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bindingId: string (required)
  ##            : The id of the binding. Must be unique within GCP project.
  ## Maximum length is 64, GUID recommended.
  ## Required.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589170 = newJObject()
  var query_589171 = newJObject()
  var body_589172 = newJObject()
  add(query_589171, "upload_protocol", newJString(uploadProtocol))
  add(query_589171, "fields", newJString(fields))
  add(query_589171, "quotaUser", newJString(quotaUser))
  add(query_589171, "alt", newJString(alt))
  add(query_589171, "acceptsIncomplete", newJBool(acceptsIncomplete))
  add(query_589171, "oauth_token", newJString(oauthToken))
  add(query_589171, "callback", newJString(callback))
  add(query_589171, "access_token", newJString(accessToken))
  add(query_589171, "uploadType", newJString(uploadType))
  add(path_589170, "parent", newJString(parent))
  add(query_589171, "key", newJString(key))
  add(query_589171, "$.xgafv", newJString(Xgafv))
  add(path_589170, "binding_id", newJString(bindingId))
  if body != nil:
    body_589172 = body
  add(query_589171, "prettyPrint", newJBool(prettyPrint))
  result = call_589169.call(path_589170, query_589171, nil, nil, body_589172)

var servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_589150(name: "servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate",
    meth: HttpMethod.HttpPut, host: "servicebroker.googleapis.com",
    route: "/v1beta1/{parent}/service_bindings/{binding_id}", validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_589151,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_589152,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2CatalogList_589173 = ref object of OpenApiRestCall_588441
proc url_ServicebrokerProjectsBrokersV2CatalogList_589175(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/v2/catalog")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicebrokerProjectsBrokersV2CatalogList_589174(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the Services registered with this broker for consumption for
  ## given service registry broker, which contains an set of services.
  ## Note, that Service producer API is separate from Broker API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589176 = path.getOrDefault("parent")
  valid_589176 = validateParameter(valid_589176, JString, required = true,
                                 default = nil)
  if valid_589176 != nil:
    section.add "parent", valid_589176
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
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
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ## Optional. If unset or 0, all the results will be returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589177 = query.getOrDefault("upload_protocol")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "upload_protocol", valid_589177
  var valid_589178 = query.getOrDefault("fields")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "fields", valid_589178
  var valid_589179 = query.getOrDefault("pageToken")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "pageToken", valid_589179
  var valid_589180 = query.getOrDefault("quotaUser")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "quotaUser", valid_589180
  var valid_589181 = query.getOrDefault("alt")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = newJString("json"))
  if valid_589181 != nil:
    section.add "alt", valid_589181
  var valid_589182 = query.getOrDefault("oauth_token")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "oauth_token", valid_589182
  var valid_589183 = query.getOrDefault("callback")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "callback", valid_589183
  var valid_589184 = query.getOrDefault("access_token")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "access_token", valid_589184
  var valid_589185 = query.getOrDefault("uploadType")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "uploadType", valid_589185
  var valid_589186 = query.getOrDefault("key")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "key", valid_589186
  var valid_589187 = query.getOrDefault("$.xgafv")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = newJString("1"))
  if valid_589187 != nil:
    section.add "$.xgafv", valid_589187
  var valid_589188 = query.getOrDefault("pageSize")
  valid_589188 = validateParameter(valid_589188, JInt, required = false, default = nil)
  if valid_589188 != nil:
    section.add "pageSize", valid_589188
  var valid_589189 = query.getOrDefault("prettyPrint")
  valid_589189 = validateParameter(valid_589189, JBool, required = false,
                                 default = newJBool(true))
  if valid_589189 != nil:
    section.add "prettyPrint", valid_589189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589190: Call_ServicebrokerProjectsBrokersV2CatalogList_589173;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the Services registered with this broker for consumption for
  ## given service registry broker, which contains an set of services.
  ## Note, that Service producer API is separate from Broker API.
  ## 
  let valid = call_589190.validator(path, query, header, formData, body)
  let scheme = call_589190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589190.url(scheme.get, call_589190.host, call_589190.base,
                         call_589190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589190, url, valid)

proc call*(call_589191: Call_ServicebrokerProjectsBrokersV2CatalogList_589173;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## servicebrokerProjectsBrokersV2CatalogList
  ## Lists all the Services registered with this broker for consumption for
  ## given service registry broker, which contains an set of services.
  ## Note, that Service producer API is separate from Broker API.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
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
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ## Optional. If unset or 0, all the results will be returned.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589192 = newJObject()
  var query_589193 = newJObject()
  add(query_589193, "upload_protocol", newJString(uploadProtocol))
  add(query_589193, "fields", newJString(fields))
  add(query_589193, "pageToken", newJString(pageToken))
  add(query_589193, "quotaUser", newJString(quotaUser))
  add(query_589193, "alt", newJString(alt))
  add(query_589193, "oauth_token", newJString(oauthToken))
  add(query_589193, "callback", newJString(callback))
  add(query_589193, "access_token", newJString(accessToken))
  add(query_589193, "uploadType", newJString(uploadType))
  add(path_589192, "parent", newJString(parent))
  add(query_589193, "key", newJString(key))
  add(query_589193, "$.xgafv", newJString(Xgafv))
  add(query_589193, "pageSize", newJInt(pageSize))
  add(query_589193, "prettyPrint", newJBool(prettyPrint))
  result = call_589191.call(path_589192, query_589193, nil, nil, nil)

var servicebrokerProjectsBrokersV2CatalogList* = Call_ServicebrokerProjectsBrokersV2CatalogList_589173(
    name: "servicebrokerProjectsBrokersV2CatalogList", meth: HttpMethod.HttpGet,
    host: "servicebroker.googleapis.com", route: "/v1beta1/{parent}/v2/catalog",
    validator: validate_ServicebrokerProjectsBrokersV2CatalogList_589174,
    base: "/", url: url_ServicebrokerProjectsBrokersV2CatalogList_589175,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_589194 = ref object of OpenApiRestCall_588441
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_589196(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  assert "instance_id" in path, "`instance_id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/v2/service_instances/"),
               (kind: VariableSegment, value: "instance_id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_589195(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Provisions a service instance.
  ## If `request.accepts_incomplete` is false and Broker cannot execute request
  ## synchronously HTTP 422 error will be returned along with
  ## FAILED_PRECONDITION status.
  ## If `request.accepts_incomplete` is true and the Broker decides to execute
  ## resource asynchronously then HTTP 202 response code will be returned and a
  ## valid polling operation in the response will be included.
  ## If Broker executes the request synchronously and it succeeds HTTP 201
  ## response will be furnished.
  ## If identical instance exists, then HTTP 200 response will be returned.
  ## If an instance with identical ID but mismatching parameters exists, then
  ## HTTP 409 status code will be returned.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   instance_id: JString (required)
  ##              : The id of the service instance. Must be unique within GCP project.
  ## Maximum length is 64, GUID recommended.
  ## Required.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589197 = path.getOrDefault("parent")
  valid_589197 = validateParameter(valid_589197, JString, required = true,
                                 default = nil)
  if valid_589197 != nil:
    section.add "parent", valid_589197
  var valid_589198 = path.getOrDefault("instance_id")
  valid_589198 = validateParameter(valid_589198, JString, required = true,
                                 default = nil)
  if valid_589198 != nil:
    section.add "instance_id", valid_589198
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
  ##   acceptsIncomplete: JBool
  ##                    : Value indicating that API client supports asynchronous operations. If
  ## Broker cannot execute the request synchronously HTTP 422 code will be
  ## returned to HTTP clients along with FAILED_PRECONDITION error.
  ## If true and broker will execute request asynchronously 202 HTTP code will
  ## be returned.
  ## This broker always requires this to be true as all mutator operations are
  ## asynchronous.
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
  var valid_589199 = query.getOrDefault("upload_protocol")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "upload_protocol", valid_589199
  var valid_589200 = query.getOrDefault("fields")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "fields", valid_589200
  var valid_589201 = query.getOrDefault("quotaUser")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "quotaUser", valid_589201
  var valid_589202 = query.getOrDefault("alt")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = newJString("json"))
  if valid_589202 != nil:
    section.add "alt", valid_589202
  var valid_589203 = query.getOrDefault("acceptsIncomplete")
  valid_589203 = validateParameter(valid_589203, JBool, required = false, default = nil)
  if valid_589203 != nil:
    section.add "acceptsIncomplete", valid_589203
  var valid_589204 = query.getOrDefault("oauth_token")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "oauth_token", valid_589204
  var valid_589205 = query.getOrDefault("callback")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = nil)
  if valid_589205 != nil:
    section.add "callback", valid_589205
  var valid_589206 = query.getOrDefault("access_token")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "access_token", valid_589206
  var valid_589207 = query.getOrDefault("uploadType")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "uploadType", valid_589207
  var valid_589208 = query.getOrDefault("key")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "key", valid_589208
  var valid_589209 = query.getOrDefault("$.xgafv")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = newJString("1"))
  if valid_589209 != nil:
    section.add "$.xgafv", valid_589209
  var valid_589210 = query.getOrDefault("prettyPrint")
  valid_589210 = validateParameter(valid_589210, JBool, required = false,
                                 default = newJBool(true))
  if valid_589210 != nil:
    section.add "prettyPrint", valid_589210
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

proc call*(call_589212: Call_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_589194;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provisions a service instance.
  ## If `request.accepts_incomplete` is false and Broker cannot execute request
  ## synchronously HTTP 422 error will be returned along with
  ## FAILED_PRECONDITION status.
  ## If `request.accepts_incomplete` is true and the Broker decides to execute
  ## resource asynchronously then HTTP 202 response code will be returned and a
  ## valid polling operation in the response will be included.
  ## If Broker executes the request synchronously and it succeeds HTTP 201
  ## response will be furnished.
  ## If identical instance exists, then HTTP 200 response will be returned.
  ## If an instance with identical ID but mismatching parameters exists, then
  ## HTTP 409 status code will be returned.
  ## 
  let valid = call_589212.validator(path, query, header, formData, body)
  let scheme = call_589212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589212.url(scheme.get, call_589212.host, call_589212.base,
                         call_589212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589212, url, valid)

proc call*(call_589213: Call_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_589194;
          parent: string; instanceId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          acceptsIncomplete: bool = false; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## servicebrokerProjectsBrokersV2ServiceInstancesCreate
  ## Provisions a service instance.
  ## If `request.accepts_incomplete` is false and Broker cannot execute request
  ## synchronously HTTP 422 error will be returned along with
  ## FAILED_PRECONDITION status.
  ## If `request.accepts_incomplete` is true and the Broker decides to execute
  ## resource asynchronously then HTTP 202 response code will be returned and a
  ## valid polling operation in the response will be included.
  ## If Broker executes the request synchronously and it succeeds HTTP 201
  ## response will be furnished.
  ## If identical instance exists, then HTTP 200 response will be returned.
  ## If an instance with identical ID but mismatching parameters exists, then
  ## HTTP 409 status code will be returned.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   acceptsIncomplete: bool
  ##                    : Value indicating that API client supports asynchronous operations. If
  ## Broker cannot execute the request synchronously HTTP 422 code will be
  ## returned to HTTP clients along with FAILED_PRECONDITION error.
  ## If true and broker will execute request asynchronously 202 HTTP code will
  ## be returned.
  ## This broker always requires this to be true as all mutator operations are
  ## asynchronous.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   instanceId: string (required)
  ##             : The id of the service instance. Must be unique within GCP project.
  ## Maximum length is 64, GUID recommended.
  ## Required.
  var path_589214 = newJObject()
  var query_589215 = newJObject()
  var body_589216 = newJObject()
  add(query_589215, "upload_protocol", newJString(uploadProtocol))
  add(query_589215, "fields", newJString(fields))
  add(query_589215, "quotaUser", newJString(quotaUser))
  add(query_589215, "alt", newJString(alt))
  add(query_589215, "acceptsIncomplete", newJBool(acceptsIncomplete))
  add(query_589215, "oauth_token", newJString(oauthToken))
  add(query_589215, "callback", newJString(callback))
  add(query_589215, "access_token", newJString(accessToken))
  add(query_589215, "uploadType", newJString(uploadType))
  add(path_589214, "parent", newJString(parent))
  add(query_589215, "key", newJString(key))
  add(query_589215, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589216 = body
  add(query_589215, "prettyPrint", newJBool(prettyPrint))
  add(path_589214, "instance_id", newJString(instanceId))
  result = call_589213.call(path_589214, query_589215, nil, nil, body_589216)

var servicebrokerProjectsBrokersV2ServiceInstancesCreate* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_589194(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesCreate",
    meth: HttpMethod.HttpPut, host: "servicebroker.googleapis.com",
    route: "/v1beta1/{parent}/v2/service_instances/{instance_id}",
    validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_589195,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_589196,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerGetIamPolicy_589217 = ref object of OpenApiRestCall_588441
proc url_ServicebrokerGetIamPolicy_589219(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicebrokerGetIamPolicy_589218(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_589220 = path.getOrDefault("resource")
  valid_589220 = validateParameter(valid_589220, JString, required = true,
                                 default = nil)
  if valid_589220 != nil:
    section.add "resource", valid_589220
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
  var valid_589221 = query.getOrDefault("upload_protocol")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "upload_protocol", valid_589221
  var valid_589222 = query.getOrDefault("fields")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "fields", valid_589222
  var valid_589223 = query.getOrDefault("quotaUser")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "quotaUser", valid_589223
  var valid_589224 = query.getOrDefault("alt")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = newJString("json"))
  if valid_589224 != nil:
    section.add "alt", valid_589224
  var valid_589225 = query.getOrDefault("oauth_token")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "oauth_token", valid_589225
  var valid_589226 = query.getOrDefault("callback")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "callback", valid_589226
  var valid_589227 = query.getOrDefault("access_token")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "access_token", valid_589227
  var valid_589228 = query.getOrDefault("uploadType")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "uploadType", valid_589228
  var valid_589229 = query.getOrDefault("options.requestedPolicyVersion")
  valid_589229 = validateParameter(valid_589229, JInt, required = false, default = nil)
  if valid_589229 != nil:
    section.add "options.requestedPolicyVersion", valid_589229
  var valid_589230 = query.getOrDefault("key")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "key", valid_589230
  var valid_589231 = query.getOrDefault("$.xgafv")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = newJString("1"))
  if valid_589231 != nil:
    section.add "$.xgafv", valid_589231
  var valid_589232 = query.getOrDefault("prettyPrint")
  valid_589232 = validateParameter(valid_589232, JBool, required = false,
                                 default = newJBool(true))
  if valid_589232 != nil:
    section.add "prettyPrint", valid_589232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589233: Call_ServicebrokerGetIamPolicy_589217; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_589233.validator(path, query, header, formData, body)
  let scheme = call_589233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589233.url(scheme.get, call_589233.host, call_589233.base,
                         call_589233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589233, url, valid)

proc call*(call_589234: Call_ServicebrokerGetIamPolicy_589217; resource: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          optionsRequestedPolicyVersion: int = 0; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## servicebrokerGetIamPolicy
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
  var path_589235 = newJObject()
  var query_589236 = newJObject()
  add(query_589236, "upload_protocol", newJString(uploadProtocol))
  add(query_589236, "fields", newJString(fields))
  add(query_589236, "quotaUser", newJString(quotaUser))
  add(query_589236, "alt", newJString(alt))
  add(query_589236, "oauth_token", newJString(oauthToken))
  add(query_589236, "callback", newJString(callback))
  add(query_589236, "access_token", newJString(accessToken))
  add(query_589236, "uploadType", newJString(uploadType))
  add(query_589236, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_589236, "key", newJString(key))
  add(query_589236, "$.xgafv", newJString(Xgafv))
  add(path_589235, "resource", newJString(resource))
  add(query_589236, "prettyPrint", newJBool(prettyPrint))
  result = call_589234.call(path_589235, query_589236, nil, nil, nil)

var servicebrokerGetIamPolicy* = Call_ServicebrokerGetIamPolicy_589217(
    name: "servicebrokerGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "servicebroker.googleapis.com",
    route: "/v1beta1/{resource}:getIamPolicy",
    validator: validate_ServicebrokerGetIamPolicy_589218, base: "/",
    url: url_ServicebrokerGetIamPolicy_589219, schemes: {Scheme.Https})
type
  Call_ServicebrokerSetIamPolicy_589237 = ref object of OpenApiRestCall_588441
proc url_ServicebrokerSetIamPolicy_589239(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicebrokerSetIamPolicy_589238(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_589240 = path.getOrDefault("resource")
  valid_589240 = validateParameter(valid_589240, JString, required = true,
                                 default = nil)
  if valid_589240 != nil:
    section.add "resource", valid_589240
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589253: Call_ServicebrokerSetIamPolicy_589237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_589253.validator(path, query, header, formData, body)
  let scheme = call_589253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589253.url(scheme.get, call_589253.host, call_589253.base,
                         call_589253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589253, url, valid)

proc call*(call_589254: Call_ServicebrokerSetIamPolicy_589237; resource: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## servicebrokerSetIamPolicy
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
  var path_589255 = newJObject()
  var query_589256 = newJObject()
  var body_589257 = newJObject()
  add(query_589256, "upload_protocol", newJString(uploadProtocol))
  add(query_589256, "fields", newJString(fields))
  add(query_589256, "quotaUser", newJString(quotaUser))
  add(query_589256, "alt", newJString(alt))
  add(query_589256, "oauth_token", newJString(oauthToken))
  add(query_589256, "callback", newJString(callback))
  add(query_589256, "access_token", newJString(accessToken))
  add(query_589256, "uploadType", newJString(uploadType))
  add(query_589256, "key", newJString(key))
  add(query_589256, "$.xgafv", newJString(Xgafv))
  add(path_589255, "resource", newJString(resource))
  if body != nil:
    body_589257 = body
  add(query_589256, "prettyPrint", newJBool(prettyPrint))
  result = call_589254.call(path_589255, query_589256, nil, nil, body_589257)

var servicebrokerSetIamPolicy* = Call_ServicebrokerSetIamPolicy_589237(
    name: "servicebrokerSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "servicebroker.googleapis.com",
    route: "/v1beta1/{resource}:setIamPolicy",
    validator: validate_ServicebrokerSetIamPolicy_589238, base: "/",
    url: url_ServicebrokerSetIamPolicy_589239, schemes: {Scheme.Https})
type
  Call_ServicebrokerTestIamPermissions_589258 = ref object of OpenApiRestCall_588441
proc url_ServicebrokerTestIamPermissions_589260(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicebrokerTestIamPermissions_589259(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_589261 = path.getOrDefault("resource")
  valid_589261 = validateParameter(valid_589261, JString, required = true,
                                 default = nil)
  if valid_589261 != nil:
    section.add "resource", valid_589261
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
  var valid_589262 = query.getOrDefault("upload_protocol")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = nil)
  if valid_589262 != nil:
    section.add "upload_protocol", valid_589262
  var valid_589263 = query.getOrDefault("fields")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = nil)
  if valid_589263 != nil:
    section.add "fields", valid_589263
  var valid_589264 = query.getOrDefault("quotaUser")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "quotaUser", valid_589264
  var valid_589265 = query.getOrDefault("alt")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = newJString("json"))
  if valid_589265 != nil:
    section.add "alt", valid_589265
  var valid_589266 = query.getOrDefault("oauth_token")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = nil)
  if valid_589266 != nil:
    section.add "oauth_token", valid_589266
  var valid_589267 = query.getOrDefault("callback")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = nil)
  if valid_589267 != nil:
    section.add "callback", valid_589267
  var valid_589268 = query.getOrDefault("access_token")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = nil)
  if valid_589268 != nil:
    section.add "access_token", valid_589268
  var valid_589269 = query.getOrDefault("uploadType")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "uploadType", valid_589269
  var valid_589270 = query.getOrDefault("key")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "key", valid_589270
  var valid_589271 = query.getOrDefault("$.xgafv")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = newJString("1"))
  if valid_589271 != nil:
    section.add "$.xgafv", valid_589271
  var valid_589272 = query.getOrDefault("prettyPrint")
  valid_589272 = validateParameter(valid_589272, JBool, required = false,
                                 default = newJBool(true))
  if valid_589272 != nil:
    section.add "prettyPrint", valid_589272
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

proc call*(call_589274: Call_ServicebrokerTestIamPermissions_589258;
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
  let valid = call_589274.validator(path, query, header, formData, body)
  let scheme = call_589274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589274.url(scheme.get, call_589274.host, call_589274.base,
                         call_589274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589274, url, valid)

proc call*(call_589275: Call_ServicebrokerTestIamPermissions_589258;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## servicebrokerTestIamPermissions
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
  var path_589276 = newJObject()
  var query_589277 = newJObject()
  var body_589278 = newJObject()
  add(query_589277, "upload_protocol", newJString(uploadProtocol))
  add(query_589277, "fields", newJString(fields))
  add(query_589277, "quotaUser", newJString(quotaUser))
  add(query_589277, "alt", newJString(alt))
  add(query_589277, "oauth_token", newJString(oauthToken))
  add(query_589277, "callback", newJString(callback))
  add(query_589277, "access_token", newJString(accessToken))
  add(query_589277, "uploadType", newJString(uploadType))
  add(query_589277, "key", newJString(key))
  add(query_589277, "$.xgafv", newJString(Xgafv))
  add(path_589276, "resource", newJString(resource))
  if body != nil:
    body_589278 = body
  add(query_589277, "prettyPrint", newJBool(prettyPrint))
  result = call_589275.call(path_589276, query_589277, nil, nil, body_589278)

var servicebrokerTestIamPermissions* = Call_ServicebrokerTestIamPermissions_589258(
    name: "servicebrokerTestIamPermissions", meth: HttpMethod.HttpPost,
    host: "servicebroker.googleapis.com",
    route: "/v1beta1/{resource}:testIamPermissions",
    validator: validate_ServicebrokerTestIamPermissions_589259, base: "/",
    url: url_ServicebrokerTestIamPermissions_589260, schemes: {Scheme.Https})
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
