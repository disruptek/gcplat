
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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
  gcpServiceName = "servicebroker"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_578610 = ref object of OpenApiRestCall_578339
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_578612(
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_578611(
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
  var valid_578738 = path.getOrDefault("name")
  valid_578738 = validateParameter(valid_578738, JString, required = true,
                                 default = nil)
  if valid_578738 != nil:
    section.add "name", valid_578738
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   serviceId: JString
  ##            : Service id.
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
  ##   planId: JString
  ##         : Plan id.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578739 = query.getOrDefault("key")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "key", valid_578739
  var valid_578740 = query.getOrDefault("serviceId")
  valid_578740 = validateParameter(valid_578740, JString, required = false,
                                 default = nil)
  if valid_578740 != nil:
    section.add "serviceId", valid_578740
  var valid_578754 = query.getOrDefault("prettyPrint")
  valid_578754 = validateParameter(valid_578754, JBool, required = false,
                                 default = newJBool(true))
  if valid_578754 != nil:
    section.add "prettyPrint", valid_578754
  var valid_578755 = query.getOrDefault("oauth_token")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "oauth_token", valid_578755
  var valid_578756 = query.getOrDefault("$.xgafv")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = newJString("1"))
  if valid_578756 != nil:
    section.add "$.xgafv", valid_578756
  var valid_578757 = query.getOrDefault("alt")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = newJString("json"))
  if valid_578757 != nil:
    section.add "alt", valid_578757
  var valid_578758 = query.getOrDefault("uploadType")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "uploadType", valid_578758
  var valid_578759 = query.getOrDefault("quotaUser")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "quotaUser", valid_578759
  var valid_578760 = query.getOrDefault("callback")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "callback", valid_578760
  var valid_578761 = query.getOrDefault("planId")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "planId", valid_578761
  var valid_578762 = query.getOrDefault("fields")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = nil)
  if valid_578762 != nil:
    section.add "fields", valid_578762
  var valid_578763 = query.getOrDefault("access_token")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = nil)
  if valid_578763 != nil:
    section.add "access_token", valid_578763
  var valid_578764 = query.getOrDefault("upload_protocol")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = nil)
  if valid_578764 != nil:
    section.add "upload_protocol", valid_578764
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578787: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_578610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## GetBinding returns the binding information.
  ## 
  let valid = call_578787.validator(path, query, header, formData, body)
  let scheme = call_578787.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578787.url(scheme.get, call_578787.host, call_578787.base,
                         call_578787.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578787, url, valid)

proc call*(call_578858: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_578610;
          name: string; key: string = ""; serviceId: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; planId: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet
  ## GetBinding returns the binding information.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   serviceId: string
  ##            : Service id.
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
  ##       : Name must match
  ## 
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]/v2/service_instances/[INSTANCE_ID]/service_bindings`.
  ##   callback: string
  ##           : JSONP
  ##   planId: string
  ##         : Plan id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578859 = newJObject()
  var query_578861 = newJObject()
  add(query_578861, "key", newJString(key))
  add(query_578861, "serviceId", newJString(serviceId))
  add(query_578861, "prettyPrint", newJBool(prettyPrint))
  add(query_578861, "oauth_token", newJString(oauthToken))
  add(query_578861, "$.xgafv", newJString(Xgafv))
  add(query_578861, "alt", newJString(alt))
  add(query_578861, "uploadType", newJString(uploadType))
  add(query_578861, "quotaUser", newJString(quotaUser))
  add(path_578859, "name", newJString(name))
  add(query_578861, "callback", newJString(callback))
  add(query_578861, "planId", newJString(planId))
  add(query_578861, "fields", newJString(fields))
  add(query_578861, "access_token", newJString(accessToken))
  add(query_578861, "upload_protocol", newJString(uploadProtocol))
  result = call_578858.call(path_578859, query_578861, nil, nil, nil)

var servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_578610(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com",
    route: "/v1beta1/{name}", validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_578611,
    base: "/",
    url: url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_578612,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_578922 = ref object of OpenApiRestCall_578339
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_578924(
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_578923(
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
  var valid_578925 = path.getOrDefault("name")
  valid_578925 = validateParameter(valid_578925, JString, required = true,
                                 default = nil)
  if valid_578925 != nil:
    section.add "name", valid_578925
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
  ##   acceptsIncomplete: JBool
  ##                    : See CreateServiceInstanceRequest for details.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578926 = query.getOrDefault("key")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "key", valid_578926
  var valid_578927 = query.getOrDefault("prettyPrint")
  valid_578927 = validateParameter(valid_578927, JBool, required = false,
                                 default = newJBool(true))
  if valid_578927 != nil:
    section.add "prettyPrint", valid_578927
  var valid_578928 = query.getOrDefault("oauth_token")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "oauth_token", valid_578928
  var valid_578929 = query.getOrDefault("$.xgafv")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = newJString("1"))
  if valid_578929 != nil:
    section.add "$.xgafv", valid_578929
  var valid_578930 = query.getOrDefault("alt")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = newJString("json"))
  if valid_578930 != nil:
    section.add "alt", valid_578930
  var valid_578931 = query.getOrDefault("uploadType")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "uploadType", valid_578931
  var valid_578932 = query.getOrDefault("quotaUser")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "quotaUser", valid_578932
  var valid_578933 = query.getOrDefault("acceptsIncomplete")
  valid_578933 = validateParameter(valid_578933, JBool, required = false, default = nil)
  if valid_578933 != nil:
    section.add "acceptsIncomplete", valid_578933
  var valid_578934 = query.getOrDefault("callback")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "callback", valid_578934
  var valid_578935 = query.getOrDefault("fields")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "fields", valid_578935
  var valid_578936 = query.getOrDefault("access_token")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "access_token", valid_578936
  var valid_578937 = query.getOrDefault("upload_protocol")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "upload_protocol", valid_578937
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

proc call*(call_578939: Call_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_578922;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing service instance.
  ## See CreateServiceInstance for possible response codes.
  ## 
  let valid = call_578939.validator(path, query, header, formData, body)
  let scheme = call_578939.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578939.url(scheme.get, call_578939.host, call_578939.base,
                         call_578939.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578939, url, valid)

proc call*(call_578940: Call_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_578922;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = "";
          acceptsIncomplete: bool = false; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicebrokerProjectsBrokersV2ServiceInstancesPatch
  ## Updates an existing service instance.
  ## See CreateServiceInstance for possible response codes.
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
  ##       : Name must match
  ## 
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]/v2/service_instances/[INSTANCE_ID]`.
  ##   acceptsIncomplete: bool
  ##                    : See CreateServiceInstanceRequest for details.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578941 = newJObject()
  var query_578942 = newJObject()
  var body_578943 = newJObject()
  add(query_578942, "key", newJString(key))
  add(query_578942, "prettyPrint", newJBool(prettyPrint))
  add(query_578942, "oauth_token", newJString(oauthToken))
  add(query_578942, "$.xgafv", newJString(Xgafv))
  add(query_578942, "alt", newJString(alt))
  add(query_578942, "uploadType", newJString(uploadType))
  add(query_578942, "quotaUser", newJString(quotaUser))
  add(path_578941, "name", newJString(name))
  add(query_578942, "acceptsIncomplete", newJBool(acceptsIncomplete))
  if body != nil:
    body_578943 = body
  add(query_578942, "callback", newJString(callback))
  add(query_578942, "fields", newJString(fields))
  add(query_578942, "access_token", newJString(accessToken))
  add(query_578942, "upload_protocol", newJString(uploadProtocol))
  result = call_578940.call(path_578941, query_578942, nil, nil, body_578943)

var servicebrokerProjectsBrokersV2ServiceInstancesPatch* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_578922(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesPatch",
    meth: HttpMethod.HttpPatch, host: "servicebroker.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_578923,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_578924,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete_578900 = ref object of OpenApiRestCall_578339
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete_578902(
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete_578901(
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
  var valid_578903 = path.getOrDefault("name")
  valid_578903 = validateParameter(valid_578903, JString, required = true,
                                 default = nil)
  if valid_578903 != nil:
    section.add "name", valid_578903
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   serviceId: JString
  ##            : Additional query parameter hints.
  ## The service id of the service instance.
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
  ##   acceptsIncomplete: JBool
  ##                    : See CreateServiceInstanceRequest for details.
  ##   callback: JString
  ##           : JSONP
  ##   planId: JString
  ##         : The plan id of the service instance.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578904 = query.getOrDefault("key")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "key", valid_578904
  var valid_578905 = query.getOrDefault("serviceId")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = nil)
  if valid_578905 != nil:
    section.add "serviceId", valid_578905
  var valid_578906 = query.getOrDefault("prettyPrint")
  valid_578906 = validateParameter(valid_578906, JBool, required = false,
                                 default = newJBool(true))
  if valid_578906 != nil:
    section.add "prettyPrint", valid_578906
  var valid_578907 = query.getOrDefault("oauth_token")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "oauth_token", valid_578907
  var valid_578908 = query.getOrDefault("$.xgafv")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = newJString("1"))
  if valid_578908 != nil:
    section.add "$.xgafv", valid_578908
  var valid_578909 = query.getOrDefault("alt")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = newJString("json"))
  if valid_578909 != nil:
    section.add "alt", valid_578909
  var valid_578910 = query.getOrDefault("uploadType")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "uploadType", valid_578910
  var valid_578911 = query.getOrDefault("quotaUser")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "quotaUser", valid_578911
  var valid_578912 = query.getOrDefault("acceptsIncomplete")
  valid_578912 = validateParameter(valid_578912, JBool, required = false, default = nil)
  if valid_578912 != nil:
    section.add "acceptsIncomplete", valid_578912
  var valid_578913 = query.getOrDefault("callback")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "callback", valid_578913
  var valid_578914 = query.getOrDefault("planId")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "planId", valid_578914
  var valid_578915 = query.getOrDefault("fields")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "fields", valid_578915
  var valid_578916 = query.getOrDefault("access_token")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "access_token", valid_578916
  var valid_578917 = query.getOrDefault("upload_protocol")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "upload_protocol", valid_578917
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578918: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete_578900;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unbinds from a service instance.
  ## For synchronous/asynchronous request details see CreateServiceInstance
  ## method.
  ## If binding does not exist HTTP 410 status will be returned.
  ## 
  let valid = call_578918.validator(path, query, header, formData, body)
  let scheme = call_578918.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578918.url(scheme.get, call_578918.host, call_578918.base,
                         call_578918.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578918, url, valid)

proc call*(call_578919: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete_578900;
          name: string; key: string = ""; serviceId: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          acceptsIncomplete: bool = false; callback: string = ""; planId: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete
  ## Unbinds from a service instance.
  ## For synchronous/asynchronous request details see CreateServiceInstance
  ## method.
  ## If binding does not exist HTTP 410 status will be returned.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   serviceId: string
  ##            : Additional query parameter hints.
  ## The service id of the service instance.
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
  ##       : Name must match
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]/`
  ## `v2/service_instances/[INSTANCE_ID]/service_bindings/[BINDING_ID]`
  ## or
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]/`
  ## `/instances/[INSTANCE_ID]/bindings/[BINDING_ID]`.
  ##   acceptsIncomplete: bool
  ##                    : See CreateServiceInstanceRequest for details.
  ##   callback: string
  ##           : JSONP
  ##   planId: string
  ##         : The plan id of the service instance.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578920 = newJObject()
  var query_578921 = newJObject()
  add(query_578921, "key", newJString(key))
  add(query_578921, "serviceId", newJString(serviceId))
  add(query_578921, "prettyPrint", newJBool(prettyPrint))
  add(query_578921, "oauth_token", newJString(oauthToken))
  add(query_578921, "$.xgafv", newJString(Xgafv))
  add(query_578921, "alt", newJString(alt))
  add(query_578921, "uploadType", newJString(uploadType))
  add(query_578921, "quotaUser", newJString(quotaUser))
  add(path_578920, "name", newJString(name))
  add(query_578921, "acceptsIncomplete", newJBool(acceptsIncomplete))
  add(query_578921, "callback", newJString(callback))
  add(query_578921, "planId", newJString(planId))
  add(query_578921, "fields", newJString(fields))
  add(query_578921, "access_token", newJString(accessToken))
  add(query_578921, "upload_protocol", newJString(uploadProtocol))
  result = call_578919.call(path_578920, query_578921, nil, nil, nil)

var servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete_578900(name: "servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete",
    meth: HttpMethod.HttpDelete, host: "servicebroker.googleapis.com",
    route: "/v1beta1/{name}", validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete_578901,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete_578902,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_578944 = ref object of OpenApiRestCall_578339
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_578946(
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_578945(
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
  var valid_578947 = path.getOrDefault("name")
  valid_578947 = validateParameter(valid_578947, JString, required = true,
                                 default = nil)
  if valid_578947 != nil:
    section.add "name", valid_578947
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   serviceId: JString
  ##            : Service id.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   operation: JString
  ##            : If `operation` was returned during mutation operation, this field must be
  ## populated with the provided value.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   planId: JString
  ##         : Plan id.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578948 = query.getOrDefault("key")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "key", valid_578948
  var valid_578949 = query.getOrDefault("serviceId")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "serviceId", valid_578949
  var valid_578950 = query.getOrDefault("prettyPrint")
  valid_578950 = validateParameter(valid_578950, JBool, required = false,
                                 default = newJBool(true))
  if valid_578950 != nil:
    section.add "prettyPrint", valid_578950
  var valid_578951 = query.getOrDefault("oauth_token")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "oauth_token", valid_578951
  var valid_578952 = query.getOrDefault("$.xgafv")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = newJString("1"))
  if valid_578952 != nil:
    section.add "$.xgafv", valid_578952
  var valid_578953 = query.getOrDefault("operation")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "operation", valid_578953
  var valid_578954 = query.getOrDefault("alt")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = newJString("json"))
  if valid_578954 != nil:
    section.add "alt", valid_578954
  var valid_578955 = query.getOrDefault("uploadType")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "uploadType", valid_578955
  var valid_578956 = query.getOrDefault("quotaUser")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "quotaUser", valid_578956
  var valid_578957 = query.getOrDefault("callback")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "callback", valid_578957
  var valid_578958 = query.getOrDefault("planId")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "planId", valid_578958
  var valid_578959 = query.getOrDefault("fields")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "fields", valid_578959
  var valid_578960 = query.getOrDefault("access_token")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "access_token", valid_578960
  var valid_578961 = query.getOrDefault("upload_protocol")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "upload_protocol", valid_578961
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578962: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_578944;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the state of the last operation for the binding.
  ## Only last (or current) operation can be polled.
  ## 
  let valid = call_578962.validator(path, query, header, formData, body)
  let scheme = call_578962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578962.url(scheme.get, call_578962.host, call_578962.base,
                         call_578962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578962, url, valid)

proc call*(call_578963: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_578944;
          name: string; key: string = ""; serviceId: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          operation: string = ""; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; planId: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation
  ## Returns the state of the last operation for the binding.
  ## Only last (or current) operation can be polled.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   serviceId: string
  ##            : Service id.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   operation: string
  ##            : If `operation` was returned during mutation operation, this field must be
  ## populated with the provided value.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name must match
  ## 
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]/v2/service_instances/[INSTANCE_ID]/service_binding/[BINDING_ID]`.
  ##   callback: string
  ##           : JSONP
  ##   planId: string
  ##         : Plan id.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578964 = newJObject()
  var query_578965 = newJObject()
  add(query_578965, "key", newJString(key))
  add(query_578965, "serviceId", newJString(serviceId))
  add(query_578965, "prettyPrint", newJBool(prettyPrint))
  add(query_578965, "oauth_token", newJString(oauthToken))
  add(query_578965, "$.xgafv", newJString(Xgafv))
  add(query_578965, "operation", newJString(operation))
  add(query_578965, "alt", newJString(alt))
  add(query_578965, "uploadType", newJString(uploadType))
  add(query_578965, "quotaUser", newJString(quotaUser))
  add(path_578964, "name", newJString(name))
  add(query_578965, "callback", newJString(callback))
  add(query_578965, "planId", newJString(planId))
  add(query_578965, "fields", newJString(fields))
  add(query_578965, "access_token", newJString(accessToken))
  add(query_578965, "upload_protocol", newJString(uploadProtocol))
  result = call_578963.call(path_578964, query_578965, nil, nil, nil)

var servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_578944(name: "servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com",
    route: "/v1beta1/{name}/last_operation", validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_578945,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_578946,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersInstancesBindingsList_578966 = ref object of OpenApiRestCall_578339
proc url_ServicebrokerProjectsBrokersInstancesBindingsList_578968(
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

proc validate_ServicebrokerProjectsBrokersInstancesBindingsList_578967(
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
  var valid_578969 = path.getOrDefault("parent")
  valid_578969 = validateParameter(valid_578969, JString, required = true,
                                 default = nil)
  if valid_578969 != nil:
    section.add "parent", valid_578969
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
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ## Optional. Acceptable values are 0 to 200, inclusive. (Default: 100)
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578970 = query.getOrDefault("key")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "key", valid_578970
  var valid_578971 = query.getOrDefault("prettyPrint")
  valid_578971 = validateParameter(valid_578971, JBool, required = false,
                                 default = newJBool(true))
  if valid_578971 != nil:
    section.add "prettyPrint", valid_578971
  var valid_578972 = query.getOrDefault("oauth_token")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "oauth_token", valid_578972
  var valid_578973 = query.getOrDefault("$.xgafv")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = newJString("1"))
  if valid_578973 != nil:
    section.add "$.xgafv", valid_578973
  var valid_578974 = query.getOrDefault("pageSize")
  valid_578974 = validateParameter(valid_578974, JInt, required = false, default = nil)
  if valid_578974 != nil:
    section.add "pageSize", valid_578974
  var valid_578975 = query.getOrDefault("alt")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = newJString("json"))
  if valid_578975 != nil:
    section.add "alt", valid_578975
  var valid_578976 = query.getOrDefault("uploadType")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "uploadType", valid_578976
  var valid_578977 = query.getOrDefault("quotaUser")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "quotaUser", valid_578977
  var valid_578978 = query.getOrDefault("pageToken")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "pageToken", valid_578978
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

proc call*(call_578983: Call_ServicebrokerProjectsBrokersInstancesBindingsList_578966;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the bindings in the instance.
  ## 
  let valid = call_578983.validator(path, query, header, formData, body)
  let scheme = call_578983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578983.url(scheme.get, call_578983.host, call_578983.base,
                         call_578983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578983, url, valid)

proc call*(call_578984: Call_ServicebrokerProjectsBrokersInstancesBindingsList_578966;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicebrokerProjectsBrokersInstancesBindingsList
  ## Lists all the bindings in the instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ## Optional. Acceptable values are 0 to 200, inclusive. (Default: 100)
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Parent must match
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]/` +
  ## `v2/service_instances/[INSTANCE_ID]`
  ## or
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]/instances/[INSTANCE_ID]`.
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
  add(query_578986, "$.xgafv", newJString(Xgafv))
  add(query_578986, "pageSize", newJInt(pageSize))
  add(query_578986, "alt", newJString(alt))
  add(query_578986, "uploadType", newJString(uploadType))
  add(query_578986, "quotaUser", newJString(quotaUser))
  add(query_578986, "pageToken", newJString(pageToken))
  add(query_578986, "callback", newJString(callback))
  add(path_578985, "parent", newJString(parent))
  add(query_578986, "fields", newJString(fields))
  add(query_578986, "access_token", newJString(accessToken))
  add(query_578986, "upload_protocol", newJString(uploadProtocol))
  result = call_578984.call(path_578985, query_578986, nil, nil, nil)

var servicebrokerProjectsBrokersInstancesBindingsList* = Call_ServicebrokerProjectsBrokersInstancesBindingsList_578966(
    name: "servicebrokerProjectsBrokersInstancesBindingsList",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com",
    route: "/v1beta1/{parent}/bindings",
    validator: validate_ServicebrokerProjectsBrokersInstancesBindingsList_578967,
    base: "/", url: url_ServicebrokerProjectsBrokersInstancesBindingsList_578968,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersCreate_579008 = ref object of OpenApiRestCall_578339
proc url_ServicebrokerProjectsBrokersCreate_579010(protocol: Scheme; host: string;
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

proc validate_ServicebrokerProjectsBrokersCreate_579009(path: JsonNode;
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
  var valid_579011 = path.getOrDefault("parent")
  valid_579011 = validateParameter(valid_579011, JString, required = true,
                                 default = nil)
  if valid_579011 != nil:
    section.add "parent", valid_579011
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
  var valid_579016 = query.getOrDefault("alt")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = newJString("json"))
  if valid_579016 != nil:
    section.add "alt", valid_579016
  var valid_579017 = query.getOrDefault("uploadType")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "uploadType", valid_579017
  var valid_579018 = query.getOrDefault("quotaUser")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "quotaUser", valid_579018
  var valid_579019 = query.getOrDefault("callback")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "callback", valid_579019
  var valid_579020 = query.getOrDefault("fields")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "fields", valid_579020
  var valid_579021 = query.getOrDefault("access_token")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "access_token", valid_579021
  var valid_579022 = query.getOrDefault("upload_protocol")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "upload_protocol", valid_579022
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

proc call*(call_579024: Call_ServicebrokerProjectsBrokersCreate_579008;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## CreateBroker creates a Broker.
  ## 
  let valid = call_579024.validator(path, query, header, formData, body)
  let scheme = call_579024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579024.url(scheme.get, call_579024.host, call_579024.base,
                         call_579024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579024, url, valid)

proc call*(call_579025: Call_ServicebrokerProjectsBrokersCreate_579008;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## servicebrokerProjectsBrokersCreate
  ## CreateBroker creates a Broker.
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
  ##         : The project in which to create broker.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579026 = newJObject()
  var query_579027 = newJObject()
  var body_579028 = newJObject()
  add(query_579027, "key", newJString(key))
  add(query_579027, "prettyPrint", newJBool(prettyPrint))
  add(query_579027, "oauth_token", newJString(oauthToken))
  add(query_579027, "$.xgafv", newJString(Xgafv))
  add(query_579027, "alt", newJString(alt))
  add(query_579027, "uploadType", newJString(uploadType))
  add(query_579027, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579028 = body
  add(query_579027, "callback", newJString(callback))
  add(path_579026, "parent", newJString(parent))
  add(query_579027, "fields", newJString(fields))
  add(query_579027, "access_token", newJString(accessToken))
  add(query_579027, "upload_protocol", newJString(uploadProtocol))
  result = call_579025.call(path_579026, query_579027, nil, nil, body_579028)

var servicebrokerProjectsBrokersCreate* = Call_ServicebrokerProjectsBrokersCreate_579008(
    name: "servicebrokerProjectsBrokersCreate", meth: HttpMethod.HttpPost,
    host: "servicebroker.googleapis.com", route: "/v1beta1/{parent}/brokers",
    validator: validate_ServicebrokerProjectsBrokersCreate_579009, base: "/",
    url: url_ServicebrokerProjectsBrokersCreate_579010, schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersList_578987 = ref object of OpenApiRestCall_578339
proc url_ServicebrokerProjectsBrokersList_578989(protocol: Scheme; host: string;
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

proc validate_ServicebrokerProjectsBrokersList_578988(path: JsonNode;
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
  var valid_578990 = path.getOrDefault("parent")
  valid_578990 = validateParameter(valid_578990, JString, required = true,
                                 default = nil)
  if valid_578990 != nil:
    section.add "parent", valid_578990
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
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ## Optional. Acceptable values are 0 to 200, inclusive. (Default: 100)
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
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
  var valid_578995 = query.getOrDefault("pageSize")
  valid_578995 = validateParameter(valid_578995, JInt, required = false, default = nil)
  if valid_578995 != nil:
    section.add "pageSize", valid_578995
  var valid_578996 = query.getOrDefault("alt")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = newJString("json"))
  if valid_578996 != nil:
    section.add "alt", valid_578996
  var valid_578997 = query.getOrDefault("uploadType")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "uploadType", valid_578997
  var valid_578998 = query.getOrDefault("quotaUser")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "quotaUser", valid_578998
  var valid_578999 = query.getOrDefault("pageToken")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "pageToken", valid_578999
  var valid_579000 = query.getOrDefault("callback")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "callback", valid_579000
  var valid_579001 = query.getOrDefault("fields")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "fields", valid_579001
  var valid_579002 = query.getOrDefault("access_token")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "access_token", valid_579002
  var valid_579003 = query.getOrDefault("upload_protocol")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "upload_protocol", valid_579003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579004: Call_ServicebrokerProjectsBrokersList_578987;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## ListBrokers lists brokers.
  ## 
  let valid = call_579004.validator(path, query, header, formData, body)
  let scheme = call_579004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579004.url(scheme.get, call_579004.host, call_579004.base,
                         call_579004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579004, url, valid)

proc call*(call_579005: Call_ServicebrokerProjectsBrokersList_578987;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicebrokerProjectsBrokersList
  ## ListBrokers lists brokers.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ## Optional. Acceptable values are 0 to 200, inclusive. (Default: 100)
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579006 = newJObject()
  var query_579007 = newJObject()
  add(query_579007, "key", newJString(key))
  add(query_579007, "prettyPrint", newJBool(prettyPrint))
  add(query_579007, "oauth_token", newJString(oauthToken))
  add(query_579007, "$.xgafv", newJString(Xgafv))
  add(query_579007, "pageSize", newJInt(pageSize))
  add(query_579007, "alt", newJString(alt))
  add(query_579007, "uploadType", newJString(uploadType))
  add(query_579007, "quotaUser", newJString(quotaUser))
  add(query_579007, "pageToken", newJString(pageToken))
  add(query_579007, "callback", newJString(callback))
  add(path_579006, "parent", newJString(parent))
  add(query_579007, "fields", newJString(fields))
  add(query_579007, "access_token", newJString(accessToken))
  add(query_579007, "upload_protocol", newJString(uploadProtocol))
  result = call_579005.call(path_579006, query_579007, nil, nil, nil)

var servicebrokerProjectsBrokersList* = Call_ServicebrokerProjectsBrokersList_578987(
    name: "servicebrokerProjectsBrokersList", meth: HttpMethod.HttpGet,
    host: "servicebroker.googleapis.com", route: "/v1beta1/{parent}/brokers",
    validator: validate_ServicebrokerProjectsBrokersList_578988, base: "/",
    url: url_ServicebrokerProjectsBrokersList_578989, schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersInstancesList_579029 = ref object of OpenApiRestCall_578339
proc url_ServicebrokerProjectsBrokersInstancesList_579031(protocol: Scheme;
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

proc validate_ServicebrokerProjectsBrokersInstancesList_579030(path: JsonNode;
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
  var valid_579032 = path.getOrDefault("parent")
  valid_579032 = validateParameter(valid_579032, JString, required = true,
                                 default = nil)
  if valid_579032 != nil:
    section.add "parent", valid_579032
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
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ## Optional. Acceptable values are 0 to 200, inclusive. (Default: 100)
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
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
  var valid_579037 = query.getOrDefault("pageSize")
  valid_579037 = validateParameter(valid_579037, JInt, required = false, default = nil)
  if valid_579037 != nil:
    section.add "pageSize", valid_579037
  var valid_579038 = query.getOrDefault("alt")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = newJString("json"))
  if valid_579038 != nil:
    section.add "alt", valid_579038
  var valid_579039 = query.getOrDefault("uploadType")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "uploadType", valid_579039
  var valid_579040 = query.getOrDefault("quotaUser")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "quotaUser", valid_579040
  var valid_579041 = query.getOrDefault("pageToken")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "pageToken", valid_579041
  var valid_579042 = query.getOrDefault("callback")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "callback", valid_579042
  var valid_579043 = query.getOrDefault("fields")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "fields", valid_579043
  var valid_579044 = query.getOrDefault("access_token")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "access_token", valid_579044
  var valid_579045 = query.getOrDefault("upload_protocol")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "upload_protocol", valid_579045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579046: Call_ServicebrokerProjectsBrokersInstancesList_579029;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the instances in the brokers
  ## This API is an extension and not part of the OSB spec.
  ## Hence the path is a standard Google API URL.
  ## 
  let valid = call_579046.validator(path, query, header, formData, body)
  let scheme = call_579046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579046.url(scheme.get, call_579046.host, call_579046.base,
                         call_579046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579046, url, valid)

proc call*(call_579047: Call_ServicebrokerProjectsBrokersInstancesList_579029;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicebrokerProjectsBrokersInstancesList
  ## Lists all the instances in the brokers
  ## This API is an extension and not part of the OSB spec.
  ## Hence the path is a standard Google API URL.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ## Optional. Acceptable values are 0 to 200, inclusive. (Default: 100)
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579048 = newJObject()
  var query_579049 = newJObject()
  add(query_579049, "key", newJString(key))
  add(query_579049, "prettyPrint", newJBool(prettyPrint))
  add(query_579049, "oauth_token", newJString(oauthToken))
  add(query_579049, "$.xgafv", newJString(Xgafv))
  add(query_579049, "pageSize", newJInt(pageSize))
  add(query_579049, "alt", newJString(alt))
  add(query_579049, "uploadType", newJString(uploadType))
  add(query_579049, "quotaUser", newJString(quotaUser))
  add(query_579049, "pageToken", newJString(pageToken))
  add(query_579049, "callback", newJString(callback))
  add(path_579048, "parent", newJString(parent))
  add(query_579049, "fields", newJString(fields))
  add(query_579049, "access_token", newJString(accessToken))
  add(query_579049, "upload_protocol", newJString(uploadProtocol))
  result = call_579047.call(path_579048, query_579049, nil, nil, nil)

var servicebrokerProjectsBrokersInstancesList* = Call_ServicebrokerProjectsBrokersInstancesList_579029(
    name: "servicebrokerProjectsBrokersInstancesList", meth: HttpMethod.HttpGet,
    host: "servicebroker.googleapis.com", route: "/v1beta1/{parent}/instances",
    validator: validate_ServicebrokerProjectsBrokersInstancesList_579030,
    base: "/", url: url_ServicebrokerProjectsBrokersInstancesList_579031,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_579050 = ref object of OpenApiRestCall_578339
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_579052(
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_579051(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## CreateBinding generates a service binding to an existing service instance.
  ## See ProviServiceInstance for async operation details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   binding_id: JString (required)
  ##             : The id of the binding. Must be unique within GCP project.
  ## Maximum length is 64, GUID recommended.
  ## Required.
  ##   parent: JString (required)
  ##         : The GCP container.
  ## Must match
  ## 
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]/v2/service_instances/[INSTANCE_ID]`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `binding_id` field"
  var valid_579053 = path.getOrDefault("binding_id")
  valid_579053 = validateParameter(valid_579053, JString, required = true,
                                 default = nil)
  if valid_579053 != nil:
    section.add "binding_id", valid_579053
  var valid_579054 = path.getOrDefault("parent")
  valid_579054 = validateParameter(valid_579054, JString, required = true,
                                 default = nil)
  if valid_579054 != nil:
    section.add "parent", valid_579054
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
  ##   acceptsIncomplete: JBool
  ##                    : See CreateServiceInstanceRequest for details.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
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
  var valid_579062 = query.getOrDefault("acceptsIncomplete")
  valid_579062 = validateParameter(valid_579062, JBool, required = false, default = nil)
  if valid_579062 != nil:
    section.add "acceptsIncomplete", valid_579062
  var valid_579063 = query.getOrDefault("callback")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "callback", valid_579063
  var valid_579064 = query.getOrDefault("fields")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "fields", valid_579064
  var valid_579065 = query.getOrDefault("access_token")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "access_token", valid_579065
  var valid_579066 = query.getOrDefault("upload_protocol")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "upload_protocol", valid_579066
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

proc call*(call_579068: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_579050;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## CreateBinding generates a service binding to an existing service instance.
  ## See ProviServiceInstance for async operation details.
  ## 
  let valid = call_579068.validator(path, query, header, formData, body)
  let scheme = call_579068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579068.url(scheme.get, call_579068.host, call_579068.base,
                         call_579068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579068, url, valid)

proc call*(call_579069: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_579050;
          bindingId: string; parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = "";
          acceptsIncomplete: bool = false; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate
  ## CreateBinding generates a service binding to an existing service instance.
  ## See ProviServiceInstance for async operation details.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   bindingId: string (required)
  ##            : The id of the binding. Must be unique within GCP project.
  ## Maximum length is 64, GUID recommended.
  ## Required.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   acceptsIncomplete: bool
  ##                    : See CreateServiceInstanceRequest for details.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The GCP container.
  ## Must match
  ## 
  ## `projects/[PROJECT_ID]/brokers/[BROKER_ID]/v2/service_instances/[INSTANCE_ID]`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579070 = newJObject()
  var query_579071 = newJObject()
  var body_579072 = newJObject()
  add(query_579071, "key", newJString(key))
  add(query_579071, "prettyPrint", newJBool(prettyPrint))
  add(query_579071, "oauth_token", newJString(oauthToken))
  add(query_579071, "$.xgafv", newJString(Xgafv))
  add(path_579070, "binding_id", newJString(bindingId))
  add(query_579071, "alt", newJString(alt))
  add(query_579071, "uploadType", newJString(uploadType))
  add(query_579071, "quotaUser", newJString(quotaUser))
  add(query_579071, "acceptsIncomplete", newJBool(acceptsIncomplete))
  if body != nil:
    body_579072 = body
  add(query_579071, "callback", newJString(callback))
  add(path_579070, "parent", newJString(parent))
  add(query_579071, "fields", newJString(fields))
  add(query_579071, "access_token", newJString(accessToken))
  add(query_579071, "upload_protocol", newJString(uploadProtocol))
  result = call_579069.call(path_579070, query_579071, nil, nil, body_579072)

var servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_579050(name: "servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate",
    meth: HttpMethod.HttpPut, host: "servicebroker.googleapis.com",
    route: "/v1beta1/{parent}/service_bindings/{binding_id}", validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_579051,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_579052,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2CatalogList_579073 = ref object of OpenApiRestCall_578339
proc url_ServicebrokerProjectsBrokersV2CatalogList_579075(protocol: Scheme;
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

proc validate_ServicebrokerProjectsBrokersV2CatalogList_579074(path: JsonNode;
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
  var valid_579076 = path.getOrDefault("parent")
  valid_579076 = validateParameter(valid_579076, JString, required = true,
                                 default = nil)
  if valid_579076 != nil:
    section.add "parent", valid_579076
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
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ## Optional. If unset or 0, all the results will be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579077 = query.getOrDefault("key")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "key", valid_579077
  var valid_579078 = query.getOrDefault("prettyPrint")
  valid_579078 = validateParameter(valid_579078, JBool, required = false,
                                 default = newJBool(true))
  if valid_579078 != nil:
    section.add "prettyPrint", valid_579078
  var valid_579079 = query.getOrDefault("oauth_token")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "oauth_token", valid_579079
  var valid_579080 = query.getOrDefault("$.xgafv")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = newJString("1"))
  if valid_579080 != nil:
    section.add "$.xgafv", valid_579080
  var valid_579081 = query.getOrDefault("pageSize")
  valid_579081 = validateParameter(valid_579081, JInt, required = false, default = nil)
  if valid_579081 != nil:
    section.add "pageSize", valid_579081
  var valid_579082 = query.getOrDefault("alt")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = newJString("json"))
  if valid_579082 != nil:
    section.add "alt", valid_579082
  var valid_579083 = query.getOrDefault("uploadType")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "uploadType", valid_579083
  var valid_579084 = query.getOrDefault("quotaUser")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "quotaUser", valid_579084
  var valid_579085 = query.getOrDefault("pageToken")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "pageToken", valid_579085
  var valid_579086 = query.getOrDefault("callback")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "callback", valid_579086
  var valid_579087 = query.getOrDefault("fields")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "fields", valid_579087
  var valid_579088 = query.getOrDefault("access_token")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "access_token", valid_579088
  var valid_579089 = query.getOrDefault("upload_protocol")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "upload_protocol", valid_579089
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579090: Call_ServicebrokerProjectsBrokersV2CatalogList_579073;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the Services registered with this broker for consumption for
  ## given service registry broker, which contains an set of services.
  ## Note, that Service producer API is separate from Broker API.
  ## 
  let valid = call_579090.validator(path, query, header, formData, body)
  let scheme = call_579090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579090.url(scheme.get, call_579090.host, call_579090.base,
                         call_579090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579090, url, valid)

proc call*(call_579091: Call_ServicebrokerProjectsBrokersV2CatalogList_579073;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicebrokerProjectsBrokersV2CatalogList
  ## Lists all the Services registered with this broker for consumption for
  ## given service registry broker, which contains an set of services.
  ## Note, that Service producer API is separate from Broker API.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Specifies the number of results to return per page. If there are fewer
  ## elements than the specified number, returns all elements.
  ## Optional. If unset or 0, all the results will be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set `pageToken` to a `nextPageToken`
  ## returned by a previous list request to get the next page of results.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579092 = newJObject()
  var query_579093 = newJObject()
  add(query_579093, "key", newJString(key))
  add(query_579093, "prettyPrint", newJBool(prettyPrint))
  add(query_579093, "oauth_token", newJString(oauthToken))
  add(query_579093, "$.xgafv", newJString(Xgafv))
  add(query_579093, "pageSize", newJInt(pageSize))
  add(query_579093, "alt", newJString(alt))
  add(query_579093, "uploadType", newJString(uploadType))
  add(query_579093, "quotaUser", newJString(quotaUser))
  add(query_579093, "pageToken", newJString(pageToken))
  add(query_579093, "callback", newJString(callback))
  add(path_579092, "parent", newJString(parent))
  add(query_579093, "fields", newJString(fields))
  add(query_579093, "access_token", newJString(accessToken))
  add(query_579093, "upload_protocol", newJString(uploadProtocol))
  result = call_579091.call(path_579092, query_579093, nil, nil, nil)

var servicebrokerProjectsBrokersV2CatalogList* = Call_ServicebrokerProjectsBrokersV2CatalogList_579073(
    name: "servicebrokerProjectsBrokersV2CatalogList", meth: HttpMethod.HttpGet,
    host: "servicebroker.googleapis.com", route: "/v1beta1/{parent}/v2/catalog",
    validator: validate_ServicebrokerProjectsBrokersV2CatalogList_579074,
    base: "/", url: url_ServicebrokerProjectsBrokersV2CatalogList_579075,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_579094 = ref object of OpenApiRestCall_578339
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_579096(
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_579095(
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
  ##   instance_id: JString (required)
  ##              : The id of the service instance. Must be unique within GCP project.
  ## Maximum length is 64, GUID recommended.
  ## Required.
  ##   parent: JString (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `instance_id` field"
  var valid_579097 = path.getOrDefault("instance_id")
  valid_579097 = validateParameter(valid_579097, JString, required = true,
                                 default = nil)
  if valid_579097 != nil:
    section.add "instance_id", valid_579097
  var valid_579098 = path.getOrDefault("parent")
  valid_579098 = validateParameter(valid_579098, JString, required = true,
                                 default = nil)
  if valid_579098 != nil:
    section.add "parent", valid_579098
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
  ##   acceptsIncomplete: JBool
  ##                    : Value indicating that API client supports asynchronous operations. If
  ## Broker cannot execute the request synchronously HTTP 422 code will be
  ## returned to HTTP clients along with FAILED_PRECONDITION error.
  ## If true and broker will execute request asynchronously 202 HTTP code will
  ## be returned.
  ## This broker always requires this to be true as all mutator operations are
  ## asynchronous.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579099 = query.getOrDefault("key")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "key", valid_579099
  var valid_579100 = query.getOrDefault("prettyPrint")
  valid_579100 = validateParameter(valid_579100, JBool, required = false,
                                 default = newJBool(true))
  if valid_579100 != nil:
    section.add "prettyPrint", valid_579100
  var valid_579101 = query.getOrDefault("oauth_token")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "oauth_token", valid_579101
  var valid_579102 = query.getOrDefault("$.xgafv")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = newJString("1"))
  if valid_579102 != nil:
    section.add "$.xgafv", valid_579102
  var valid_579103 = query.getOrDefault("alt")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = newJString("json"))
  if valid_579103 != nil:
    section.add "alt", valid_579103
  var valid_579104 = query.getOrDefault("uploadType")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "uploadType", valid_579104
  var valid_579105 = query.getOrDefault("quotaUser")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "quotaUser", valid_579105
  var valid_579106 = query.getOrDefault("acceptsIncomplete")
  valid_579106 = validateParameter(valid_579106, JBool, required = false, default = nil)
  if valid_579106 != nil:
    section.add "acceptsIncomplete", valid_579106
  var valid_579107 = query.getOrDefault("callback")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "callback", valid_579107
  var valid_579108 = query.getOrDefault("fields")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "fields", valid_579108
  var valid_579109 = query.getOrDefault("access_token")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "access_token", valid_579109
  var valid_579110 = query.getOrDefault("upload_protocol")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "upload_protocol", valid_579110
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

proc call*(call_579112: Call_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_579094;
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
  let valid = call_579112.validator(path, query, header, formData, body)
  let scheme = call_579112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579112.url(scheme.get, call_579112.host, call_579112.base,
                         call_579112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579112, url, valid)

proc call*(call_579113: Call_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_579094;
          instanceId: string; parent: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          acceptsIncomplete: bool = false; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   acceptsIncomplete: bool
  ##                    : Value indicating that API client supports asynchronous operations. If
  ## Broker cannot execute the request synchronously HTTP 422 code will be
  ## returned to HTTP clients along with FAILED_PRECONDITION error.
  ## If true and broker will execute request asynchronously 202 HTTP code will
  ## be returned.
  ## This broker always requires this to be true as all mutator operations are
  ## asynchronous.
  ##   instanceId: string (required)
  ##             : The id of the service instance. Must be unique within GCP project.
  ## Maximum length is 64, GUID recommended.
  ## Required.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Parent must match `projects/[PROJECT_ID]/brokers/[BROKER_ID]`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579114 = newJObject()
  var query_579115 = newJObject()
  var body_579116 = newJObject()
  add(query_579115, "key", newJString(key))
  add(query_579115, "prettyPrint", newJBool(prettyPrint))
  add(query_579115, "oauth_token", newJString(oauthToken))
  add(query_579115, "$.xgafv", newJString(Xgafv))
  add(query_579115, "alt", newJString(alt))
  add(query_579115, "uploadType", newJString(uploadType))
  add(query_579115, "quotaUser", newJString(quotaUser))
  add(query_579115, "acceptsIncomplete", newJBool(acceptsIncomplete))
  add(path_579114, "instance_id", newJString(instanceId))
  if body != nil:
    body_579116 = body
  add(query_579115, "callback", newJString(callback))
  add(path_579114, "parent", newJString(parent))
  add(query_579115, "fields", newJString(fields))
  add(query_579115, "access_token", newJString(accessToken))
  add(query_579115, "upload_protocol", newJString(uploadProtocol))
  result = call_579113.call(path_579114, query_579115, nil, nil, body_579116)

var servicebrokerProjectsBrokersV2ServiceInstancesCreate* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_579094(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesCreate",
    meth: HttpMethod.HttpPut, host: "servicebroker.googleapis.com",
    route: "/v1beta1/{parent}/v2/service_instances/{instance_id}",
    validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_579095,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_579096,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerGetIamPolicy_579117 = ref object of OpenApiRestCall_578339
proc url_ServicebrokerGetIamPolicy_579119(protocol: Scheme; host: string;
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

proc validate_ServicebrokerGetIamPolicy_579118(path: JsonNode; query: JsonNode;
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
  var valid_579120 = path.getOrDefault("resource")
  valid_579120 = validateParameter(valid_579120, JString, required = true,
                                 default = nil)
  if valid_579120 != nil:
    section.add "resource", valid_579120
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
  var valid_579121 = query.getOrDefault("key")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "key", valid_579121
  var valid_579122 = query.getOrDefault("prettyPrint")
  valid_579122 = validateParameter(valid_579122, JBool, required = false,
                                 default = newJBool(true))
  if valid_579122 != nil:
    section.add "prettyPrint", valid_579122
  var valid_579123 = query.getOrDefault("oauth_token")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "oauth_token", valid_579123
  var valid_579124 = query.getOrDefault("$.xgafv")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = newJString("1"))
  if valid_579124 != nil:
    section.add "$.xgafv", valid_579124
  var valid_579125 = query.getOrDefault("options.requestedPolicyVersion")
  valid_579125 = validateParameter(valid_579125, JInt, required = false, default = nil)
  if valid_579125 != nil:
    section.add "options.requestedPolicyVersion", valid_579125
  var valid_579126 = query.getOrDefault("alt")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = newJString("json"))
  if valid_579126 != nil:
    section.add "alt", valid_579126
  var valid_579127 = query.getOrDefault("uploadType")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "uploadType", valid_579127
  var valid_579128 = query.getOrDefault("quotaUser")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "quotaUser", valid_579128
  var valid_579129 = query.getOrDefault("callback")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "callback", valid_579129
  var valid_579130 = query.getOrDefault("fields")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "fields", valid_579130
  var valid_579131 = query.getOrDefault("access_token")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "access_token", valid_579131
  var valid_579132 = query.getOrDefault("upload_protocol")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "upload_protocol", valid_579132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579133: Call_ServicebrokerGetIamPolicy_579117; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_579133.validator(path, query, header, formData, body)
  let scheme = call_579133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579133.url(scheme.get, call_579133.host, call_579133.base,
                         call_579133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579133, url, valid)

proc call*(call_579134: Call_ServicebrokerGetIamPolicy_579117; resource: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; optionsRequestedPolicyVersion: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## servicebrokerGetIamPolicy
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
  var path_579135 = newJObject()
  var query_579136 = newJObject()
  add(query_579136, "key", newJString(key))
  add(query_579136, "prettyPrint", newJBool(prettyPrint))
  add(query_579136, "oauth_token", newJString(oauthToken))
  add(query_579136, "$.xgafv", newJString(Xgafv))
  add(query_579136, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_579136, "alt", newJString(alt))
  add(query_579136, "uploadType", newJString(uploadType))
  add(query_579136, "quotaUser", newJString(quotaUser))
  add(path_579135, "resource", newJString(resource))
  add(query_579136, "callback", newJString(callback))
  add(query_579136, "fields", newJString(fields))
  add(query_579136, "access_token", newJString(accessToken))
  add(query_579136, "upload_protocol", newJString(uploadProtocol))
  result = call_579134.call(path_579135, query_579136, nil, nil, nil)

var servicebrokerGetIamPolicy* = Call_ServicebrokerGetIamPolicy_579117(
    name: "servicebrokerGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "servicebroker.googleapis.com",
    route: "/v1beta1/{resource}:getIamPolicy",
    validator: validate_ServicebrokerGetIamPolicy_579118, base: "/",
    url: url_ServicebrokerGetIamPolicy_579119, schemes: {Scheme.Https})
type
  Call_ServicebrokerSetIamPolicy_579137 = ref object of OpenApiRestCall_578339
proc url_ServicebrokerSetIamPolicy_579139(protocol: Scheme; host: string;
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

proc validate_ServicebrokerSetIamPolicy_579138(path: JsonNode; query: JsonNode;
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
  var valid_579140 = path.getOrDefault("resource")
  valid_579140 = validateParameter(valid_579140, JString, required = true,
                                 default = nil)
  if valid_579140 != nil:
    section.add "resource", valid_579140
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579153: Call_ServicebrokerSetIamPolicy_579137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_579153.validator(path, query, header, formData, body)
  let scheme = call_579153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579153.url(scheme.get, call_579153.host, call_579153.base,
                         call_579153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579153, url, valid)

proc call*(call_579154: Call_ServicebrokerSetIamPolicy_579137; resource: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicebrokerSetIamPolicy
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
  var path_579155 = newJObject()
  var query_579156 = newJObject()
  var body_579157 = newJObject()
  add(query_579156, "key", newJString(key))
  add(query_579156, "prettyPrint", newJBool(prettyPrint))
  add(query_579156, "oauth_token", newJString(oauthToken))
  add(query_579156, "$.xgafv", newJString(Xgafv))
  add(query_579156, "alt", newJString(alt))
  add(query_579156, "uploadType", newJString(uploadType))
  add(query_579156, "quotaUser", newJString(quotaUser))
  add(path_579155, "resource", newJString(resource))
  if body != nil:
    body_579157 = body
  add(query_579156, "callback", newJString(callback))
  add(query_579156, "fields", newJString(fields))
  add(query_579156, "access_token", newJString(accessToken))
  add(query_579156, "upload_protocol", newJString(uploadProtocol))
  result = call_579154.call(path_579155, query_579156, nil, nil, body_579157)

var servicebrokerSetIamPolicy* = Call_ServicebrokerSetIamPolicy_579137(
    name: "servicebrokerSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "servicebroker.googleapis.com",
    route: "/v1beta1/{resource}:setIamPolicy",
    validator: validate_ServicebrokerSetIamPolicy_579138, base: "/",
    url: url_ServicebrokerSetIamPolicy_579139, schemes: {Scheme.Https})
type
  Call_ServicebrokerTestIamPermissions_579158 = ref object of OpenApiRestCall_578339
proc url_ServicebrokerTestIamPermissions_579160(protocol: Scheme; host: string;
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

proc validate_ServicebrokerTestIamPermissions_579159(path: JsonNode;
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
  var valid_579161 = path.getOrDefault("resource")
  valid_579161 = validateParameter(valid_579161, JString, required = true,
                                 default = nil)
  if valid_579161 != nil:
    section.add "resource", valid_579161
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
  var valid_579162 = query.getOrDefault("key")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "key", valid_579162
  var valid_579163 = query.getOrDefault("prettyPrint")
  valid_579163 = validateParameter(valid_579163, JBool, required = false,
                                 default = newJBool(true))
  if valid_579163 != nil:
    section.add "prettyPrint", valid_579163
  var valid_579164 = query.getOrDefault("oauth_token")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "oauth_token", valid_579164
  var valid_579165 = query.getOrDefault("$.xgafv")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = newJString("1"))
  if valid_579165 != nil:
    section.add "$.xgafv", valid_579165
  var valid_579166 = query.getOrDefault("alt")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = newJString("json"))
  if valid_579166 != nil:
    section.add "alt", valid_579166
  var valid_579167 = query.getOrDefault("uploadType")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = nil)
  if valid_579167 != nil:
    section.add "uploadType", valid_579167
  var valid_579168 = query.getOrDefault("quotaUser")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = nil)
  if valid_579168 != nil:
    section.add "quotaUser", valid_579168
  var valid_579169 = query.getOrDefault("callback")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "callback", valid_579169
  var valid_579170 = query.getOrDefault("fields")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = nil)
  if valid_579170 != nil:
    section.add "fields", valid_579170
  var valid_579171 = query.getOrDefault("access_token")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = nil)
  if valid_579171 != nil:
    section.add "access_token", valid_579171
  var valid_579172 = query.getOrDefault("upload_protocol")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = nil)
  if valid_579172 != nil:
    section.add "upload_protocol", valid_579172
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

proc call*(call_579174: Call_ServicebrokerTestIamPermissions_579158;
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
  let valid = call_579174.validator(path, query, header, formData, body)
  let scheme = call_579174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579174.url(scheme.get, call_579174.host, call_579174.base,
                         call_579174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579174, url, valid)

proc call*(call_579175: Call_ServicebrokerTestIamPermissions_579158;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## servicebrokerTestIamPermissions
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
  var path_579176 = newJObject()
  var query_579177 = newJObject()
  var body_579178 = newJObject()
  add(query_579177, "key", newJString(key))
  add(query_579177, "prettyPrint", newJBool(prettyPrint))
  add(query_579177, "oauth_token", newJString(oauthToken))
  add(query_579177, "$.xgafv", newJString(Xgafv))
  add(query_579177, "alt", newJString(alt))
  add(query_579177, "uploadType", newJString(uploadType))
  add(query_579177, "quotaUser", newJString(quotaUser))
  add(path_579176, "resource", newJString(resource))
  if body != nil:
    body_579178 = body
  add(query_579177, "callback", newJString(callback))
  add(query_579177, "fields", newJString(fields))
  add(query_579177, "access_token", newJString(accessToken))
  add(query_579177, "upload_protocol", newJString(uploadProtocol))
  result = call_579175.call(path_579176, query_579177, nil, nil, body_579178)

var servicebrokerTestIamPermissions* = Call_ServicebrokerTestIamPermissions_579158(
    name: "servicebrokerTestIamPermissions", meth: HttpMethod.HttpPost,
    host: "servicebroker.googleapis.com",
    route: "/v1beta1/{resource}:testIamPermissions",
    validator: validate_ServicebrokerTestIamPermissions_579159, base: "/",
    url: url_ServicebrokerTestIamPermissions_579160, schemes: {Scheme.Https})
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
