
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

  OpenApiRestCall_579408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579408): Option[Scheme] {.used.} =
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
  gcpServiceName = "servicebroker"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_579677 = ref object of OpenApiRestCall_579408
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_579679(
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_579678(
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
  var valid_579805 = path.getOrDefault("name")
  valid_579805 = validateParameter(valid_579805, JString, required = true,
                                 default = nil)
  if valid_579805 != nil:
    section.add "name", valid_579805
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
  var valid_579806 = query.getOrDefault("upload_protocol")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "upload_protocol", valid_579806
  var valid_579807 = query.getOrDefault("fields")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "fields", valid_579807
  var valid_579808 = query.getOrDefault("quotaUser")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "quotaUser", valid_579808
  var valid_579822 = query.getOrDefault("alt")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = newJString("json"))
  if valid_579822 != nil:
    section.add "alt", valid_579822
  var valid_579823 = query.getOrDefault("oauth_token")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "oauth_token", valid_579823
  var valid_579824 = query.getOrDefault("callback")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "callback", valid_579824
  var valid_579825 = query.getOrDefault("access_token")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "access_token", valid_579825
  var valid_579826 = query.getOrDefault("uploadType")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "uploadType", valid_579826
  var valid_579827 = query.getOrDefault("key")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "key", valid_579827
  var valid_579828 = query.getOrDefault("$.xgafv")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = newJString("1"))
  if valid_579828 != nil:
    section.add "$.xgafv", valid_579828
  var valid_579829 = query.getOrDefault("planId")
  valid_579829 = validateParameter(valid_579829, JString, required = false,
                                 default = nil)
  if valid_579829 != nil:
    section.add "planId", valid_579829
  var valid_579830 = query.getOrDefault("prettyPrint")
  valid_579830 = validateParameter(valid_579830, JBool, required = false,
                                 default = newJBool(true))
  if valid_579830 != nil:
    section.add "prettyPrint", valid_579830
  var valid_579831 = query.getOrDefault("serviceId")
  valid_579831 = validateParameter(valid_579831, JString, required = false,
                                 default = nil)
  if valid_579831 != nil:
    section.add "serviceId", valid_579831
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579854: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_579677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## GetBinding returns the binding information.
  ## 
  let valid = call_579854.validator(path, query, header, formData, body)
  let scheme = call_579854.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579854.url(scheme.get, call_579854.host, call_579854.base,
                         call_579854.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579854, url, valid)

proc call*(call_579925: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_579677;
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
  var path_579926 = newJObject()
  var query_579928 = newJObject()
  add(query_579928, "upload_protocol", newJString(uploadProtocol))
  add(query_579928, "fields", newJString(fields))
  add(query_579928, "quotaUser", newJString(quotaUser))
  add(path_579926, "name", newJString(name))
  add(query_579928, "alt", newJString(alt))
  add(query_579928, "oauth_token", newJString(oauthToken))
  add(query_579928, "callback", newJString(callback))
  add(query_579928, "access_token", newJString(accessToken))
  add(query_579928, "uploadType", newJString(uploadType))
  add(query_579928, "key", newJString(key))
  add(query_579928, "$.xgafv", newJString(Xgafv))
  add(query_579928, "planId", newJString(planId))
  add(query_579928, "prettyPrint", newJBool(prettyPrint))
  add(query_579928, "serviceId", newJString(serviceId))
  result = call_579925.call(path_579926, query_579928, nil, nil, nil)

var servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_579677(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com",
    route: "/v1beta1/{name}", validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_579678,
    base: "/",
    url: url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGet_579679,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_579989 = ref object of OpenApiRestCall_579408
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_579991(
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_579990(
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
  var valid_579992 = path.getOrDefault("name")
  valid_579992 = validateParameter(valid_579992, JString, required = true,
                                 default = nil)
  if valid_579992 != nil:
    section.add "name", valid_579992
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
  var valid_579993 = query.getOrDefault("upload_protocol")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "upload_protocol", valid_579993
  var valid_579994 = query.getOrDefault("fields")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "fields", valid_579994
  var valid_579995 = query.getOrDefault("quotaUser")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "quotaUser", valid_579995
  var valid_579996 = query.getOrDefault("alt")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = newJString("json"))
  if valid_579996 != nil:
    section.add "alt", valid_579996
  var valid_579997 = query.getOrDefault("acceptsIncomplete")
  valid_579997 = validateParameter(valid_579997, JBool, required = false, default = nil)
  if valid_579997 != nil:
    section.add "acceptsIncomplete", valid_579997
  var valid_579998 = query.getOrDefault("oauth_token")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "oauth_token", valid_579998
  var valid_579999 = query.getOrDefault("callback")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "callback", valid_579999
  var valid_580000 = query.getOrDefault("access_token")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "access_token", valid_580000
  var valid_580001 = query.getOrDefault("uploadType")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "uploadType", valid_580001
  var valid_580002 = query.getOrDefault("key")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "key", valid_580002
  var valid_580003 = query.getOrDefault("$.xgafv")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = newJString("1"))
  if valid_580003 != nil:
    section.add "$.xgafv", valid_580003
  var valid_580004 = query.getOrDefault("prettyPrint")
  valid_580004 = validateParameter(valid_580004, JBool, required = false,
                                 default = newJBool(true))
  if valid_580004 != nil:
    section.add "prettyPrint", valid_580004
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

proc call*(call_580006: Call_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_579989;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing service instance.
  ## See CreateServiceInstance for possible response codes.
  ## 
  let valid = call_580006.validator(path, query, header, formData, body)
  let scheme = call_580006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580006.url(scheme.get, call_580006.host, call_580006.base,
                         call_580006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580006, url, valid)

proc call*(call_580007: Call_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_579989;
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
  var path_580008 = newJObject()
  var query_580009 = newJObject()
  var body_580010 = newJObject()
  add(query_580009, "upload_protocol", newJString(uploadProtocol))
  add(query_580009, "fields", newJString(fields))
  add(query_580009, "quotaUser", newJString(quotaUser))
  add(path_580008, "name", newJString(name))
  add(query_580009, "alt", newJString(alt))
  add(query_580009, "acceptsIncomplete", newJBool(acceptsIncomplete))
  add(query_580009, "oauth_token", newJString(oauthToken))
  add(query_580009, "callback", newJString(callback))
  add(query_580009, "access_token", newJString(accessToken))
  add(query_580009, "uploadType", newJString(uploadType))
  add(query_580009, "key", newJString(key))
  add(query_580009, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580010 = body
  add(query_580009, "prettyPrint", newJBool(prettyPrint))
  result = call_580007.call(path_580008, query_580009, nil, nil, body_580010)

var servicebrokerProjectsBrokersV2ServiceInstancesPatch* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_579989(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesPatch",
    meth: HttpMethod.HttpPatch, host: "servicebroker.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_579990,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesPatch_579991,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete_579967 = ref object of OpenApiRestCall_579408
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete_579969(
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete_579968(
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
  var valid_579970 = path.getOrDefault("name")
  valid_579970 = validateParameter(valid_579970, JString, required = true,
                                 default = nil)
  if valid_579970 != nil:
    section.add "name", valid_579970
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
  var valid_579971 = query.getOrDefault("upload_protocol")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "upload_protocol", valid_579971
  var valid_579972 = query.getOrDefault("fields")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "fields", valid_579972
  var valid_579973 = query.getOrDefault("quotaUser")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "quotaUser", valid_579973
  var valid_579974 = query.getOrDefault("alt")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = newJString("json"))
  if valid_579974 != nil:
    section.add "alt", valid_579974
  var valid_579975 = query.getOrDefault("acceptsIncomplete")
  valid_579975 = validateParameter(valid_579975, JBool, required = false, default = nil)
  if valid_579975 != nil:
    section.add "acceptsIncomplete", valid_579975
  var valid_579976 = query.getOrDefault("oauth_token")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "oauth_token", valid_579976
  var valid_579977 = query.getOrDefault("callback")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "callback", valid_579977
  var valid_579978 = query.getOrDefault("access_token")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "access_token", valid_579978
  var valid_579979 = query.getOrDefault("uploadType")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "uploadType", valid_579979
  var valid_579980 = query.getOrDefault("key")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "key", valid_579980
  var valid_579981 = query.getOrDefault("$.xgafv")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = newJString("1"))
  if valid_579981 != nil:
    section.add "$.xgafv", valid_579981
  var valid_579982 = query.getOrDefault("planId")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "planId", valid_579982
  var valid_579983 = query.getOrDefault("prettyPrint")
  valid_579983 = validateParameter(valid_579983, JBool, required = false,
                                 default = newJBool(true))
  if valid_579983 != nil:
    section.add "prettyPrint", valid_579983
  var valid_579984 = query.getOrDefault("serviceId")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "serviceId", valid_579984
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579985: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete_579967;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unbinds from a service instance.
  ## For synchronous/asynchronous request details see CreateServiceInstance
  ## method.
  ## If binding does not exist HTTP 410 status will be returned.
  ## 
  let valid = call_579985.validator(path, query, header, formData, body)
  let scheme = call_579985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579985.url(scheme.get, call_579985.host, call_579985.base,
                         call_579985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579985, url, valid)

proc call*(call_579986: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete_579967;
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
  var path_579987 = newJObject()
  var query_579988 = newJObject()
  add(query_579988, "upload_protocol", newJString(uploadProtocol))
  add(query_579988, "fields", newJString(fields))
  add(query_579988, "quotaUser", newJString(quotaUser))
  add(path_579987, "name", newJString(name))
  add(query_579988, "alt", newJString(alt))
  add(query_579988, "acceptsIncomplete", newJBool(acceptsIncomplete))
  add(query_579988, "oauth_token", newJString(oauthToken))
  add(query_579988, "callback", newJString(callback))
  add(query_579988, "access_token", newJString(accessToken))
  add(query_579988, "uploadType", newJString(uploadType))
  add(query_579988, "key", newJString(key))
  add(query_579988, "$.xgafv", newJString(Xgafv))
  add(query_579988, "planId", newJString(planId))
  add(query_579988, "prettyPrint", newJBool(prettyPrint))
  add(query_579988, "serviceId", newJString(serviceId))
  result = call_579986.call(path_579987, query_579988, nil, nil, nil)

var servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete_579967(name: "servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete",
    meth: HttpMethod.HttpDelete, host: "servicebroker.googleapis.com",
    route: "/v1beta1/{name}", validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete_579968,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsDelete_579969,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_580011 = ref object of OpenApiRestCall_579408
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_580013(
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_580012(
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
  var valid_580014 = path.getOrDefault("name")
  valid_580014 = validateParameter(valid_580014, JString, required = true,
                                 default = nil)
  if valid_580014 != nil:
    section.add "name", valid_580014
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
  var valid_580015 = query.getOrDefault("upload_protocol")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "upload_protocol", valid_580015
  var valid_580016 = query.getOrDefault("fields")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "fields", valid_580016
  var valid_580017 = query.getOrDefault("quotaUser")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "quotaUser", valid_580017
  var valid_580018 = query.getOrDefault("alt")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = newJString("json"))
  if valid_580018 != nil:
    section.add "alt", valid_580018
  var valid_580019 = query.getOrDefault("oauth_token")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "oauth_token", valid_580019
  var valid_580020 = query.getOrDefault("callback")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "callback", valid_580020
  var valid_580021 = query.getOrDefault("access_token")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "access_token", valid_580021
  var valid_580022 = query.getOrDefault("uploadType")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "uploadType", valid_580022
  var valid_580023 = query.getOrDefault("key")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "key", valid_580023
  var valid_580024 = query.getOrDefault("$.xgafv")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = newJString("1"))
  if valid_580024 != nil:
    section.add "$.xgafv", valid_580024
  var valid_580025 = query.getOrDefault("planId")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "planId", valid_580025
  var valid_580026 = query.getOrDefault("operation")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "operation", valid_580026
  var valid_580027 = query.getOrDefault("prettyPrint")
  valid_580027 = validateParameter(valid_580027, JBool, required = false,
                                 default = newJBool(true))
  if valid_580027 != nil:
    section.add "prettyPrint", valid_580027
  var valid_580028 = query.getOrDefault("serviceId")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "serviceId", valid_580028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580029: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_580011;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the state of the last operation for the binding.
  ## Only last (or current) operation can be polled.
  ## 
  let valid = call_580029.validator(path, query, header, formData, body)
  let scheme = call_580029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580029.url(scheme.get, call_580029.host, call_580029.base,
                         call_580029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580029, url, valid)

proc call*(call_580030: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_580011;
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
  var path_580031 = newJObject()
  var query_580032 = newJObject()
  add(query_580032, "upload_protocol", newJString(uploadProtocol))
  add(query_580032, "fields", newJString(fields))
  add(query_580032, "quotaUser", newJString(quotaUser))
  add(path_580031, "name", newJString(name))
  add(query_580032, "alt", newJString(alt))
  add(query_580032, "oauth_token", newJString(oauthToken))
  add(query_580032, "callback", newJString(callback))
  add(query_580032, "access_token", newJString(accessToken))
  add(query_580032, "uploadType", newJString(uploadType))
  add(query_580032, "key", newJString(key))
  add(query_580032, "$.xgafv", newJString(Xgafv))
  add(query_580032, "planId", newJString(planId))
  add(query_580032, "operation", newJString(operation))
  add(query_580032, "prettyPrint", newJBool(prettyPrint))
  add(query_580032, "serviceId", newJString(serviceId))
  result = call_580030.call(path_580031, query_580032, nil, nil, nil)

var servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_580011(name: "servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com",
    route: "/v1beta1/{name}/last_operation", validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_580012,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsGetLastOperation_580013,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersInstancesBindingsList_580033 = ref object of OpenApiRestCall_579408
proc url_ServicebrokerProjectsBrokersInstancesBindingsList_580035(
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

proc validate_ServicebrokerProjectsBrokersInstancesBindingsList_580034(
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
  var valid_580036 = path.getOrDefault("parent")
  valid_580036 = validateParameter(valid_580036, JString, required = true,
                                 default = nil)
  if valid_580036 != nil:
    section.add "parent", valid_580036
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
  var valid_580037 = query.getOrDefault("upload_protocol")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "upload_protocol", valid_580037
  var valid_580038 = query.getOrDefault("fields")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "fields", valid_580038
  var valid_580039 = query.getOrDefault("pageToken")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "pageToken", valid_580039
  var valid_580040 = query.getOrDefault("quotaUser")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "quotaUser", valid_580040
  var valid_580041 = query.getOrDefault("alt")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = newJString("json"))
  if valid_580041 != nil:
    section.add "alt", valid_580041
  var valid_580042 = query.getOrDefault("oauth_token")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "oauth_token", valid_580042
  var valid_580043 = query.getOrDefault("callback")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "callback", valid_580043
  var valid_580044 = query.getOrDefault("access_token")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "access_token", valid_580044
  var valid_580045 = query.getOrDefault("uploadType")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "uploadType", valid_580045
  var valid_580046 = query.getOrDefault("key")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "key", valid_580046
  var valid_580047 = query.getOrDefault("$.xgafv")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = newJString("1"))
  if valid_580047 != nil:
    section.add "$.xgafv", valid_580047
  var valid_580048 = query.getOrDefault("pageSize")
  valid_580048 = validateParameter(valid_580048, JInt, required = false, default = nil)
  if valid_580048 != nil:
    section.add "pageSize", valid_580048
  var valid_580049 = query.getOrDefault("prettyPrint")
  valid_580049 = validateParameter(valid_580049, JBool, required = false,
                                 default = newJBool(true))
  if valid_580049 != nil:
    section.add "prettyPrint", valid_580049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580050: Call_ServicebrokerProjectsBrokersInstancesBindingsList_580033;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the bindings in the instance.
  ## 
  let valid = call_580050.validator(path, query, header, formData, body)
  let scheme = call_580050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580050.url(scheme.get, call_580050.host, call_580050.base,
                         call_580050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580050, url, valid)

proc call*(call_580051: Call_ServicebrokerProjectsBrokersInstancesBindingsList_580033;
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
  var path_580052 = newJObject()
  var query_580053 = newJObject()
  add(query_580053, "upload_protocol", newJString(uploadProtocol))
  add(query_580053, "fields", newJString(fields))
  add(query_580053, "pageToken", newJString(pageToken))
  add(query_580053, "quotaUser", newJString(quotaUser))
  add(query_580053, "alt", newJString(alt))
  add(query_580053, "oauth_token", newJString(oauthToken))
  add(query_580053, "callback", newJString(callback))
  add(query_580053, "access_token", newJString(accessToken))
  add(query_580053, "uploadType", newJString(uploadType))
  add(path_580052, "parent", newJString(parent))
  add(query_580053, "key", newJString(key))
  add(query_580053, "$.xgafv", newJString(Xgafv))
  add(query_580053, "pageSize", newJInt(pageSize))
  add(query_580053, "prettyPrint", newJBool(prettyPrint))
  result = call_580051.call(path_580052, query_580053, nil, nil, nil)

var servicebrokerProjectsBrokersInstancesBindingsList* = Call_ServicebrokerProjectsBrokersInstancesBindingsList_580033(
    name: "servicebrokerProjectsBrokersInstancesBindingsList",
    meth: HttpMethod.HttpGet, host: "servicebroker.googleapis.com",
    route: "/v1beta1/{parent}/bindings",
    validator: validate_ServicebrokerProjectsBrokersInstancesBindingsList_580034,
    base: "/", url: url_ServicebrokerProjectsBrokersInstancesBindingsList_580035,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersCreate_580075 = ref object of OpenApiRestCall_579408
proc url_ServicebrokerProjectsBrokersCreate_580077(protocol: Scheme; host: string;
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

proc validate_ServicebrokerProjectsBrokersCreate_580076(path: JsonNode;
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
  var valid_580078 = path.getOrDefault("parent")
  valid_580078 = validateParameter(valid_580078, JString, required = true,
                                 default = nil)
  if valid_580078 != nil:
    section.add "parent", valid_580078
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
  var valid_580079 = query.getOrDefault("upload_protocol")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "upload_protocol", valid_580079
  var valid_580080 = query.getOrDefault("fields")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "fields", valid_580080
  var valid_580081 = query.getOrDefault("quotaUser")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "quotaUser", valid_580081
  var valid_580082 = query.getOrDefault("alt")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = newJString("json"))
  if valid_580082 != nil:
    section.add "alt", valid_580082
  var valid_580083 = query.getOrDefault("oauth_token")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "oauth_token", valid_580083
  var valid_580084 = query.getOrDefault("callback")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "callback", valid_580084
  var valid_580085 = query.getOrDefault("access_token")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "access_token", valid_580085
  var valid_580086 = query.getOrDefault("uploadType")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "uploadType", valid_580086
  var valid_580087 = query.getOrDefault("key")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "key", valid_580087
  var valid_580088 = query.getOrDefault("$.xgafv")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = newJString("1"))
  if valid_580088 != nil:
    section.add "$.xgafv", valid_580088
  var valid_580089 = query.getOrDefault("prettyPrint")
  valid_580089 = validateParameter(valid_580089, JBool, required = false,
                                 default = newJBool(true))
  if valid_580089 != nil:
    section.add "prettyPrint", valid_580089
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

proc call*(call_580091: Call_ServicebrokerProjectsBrokersCreate_580075;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## CreateBroker creates a Broker.
  ## 
  let valid = call_580091.validator(path, query, header, formData, body)
  let scheme = call_580091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580091.url(scheme.get, call_580091.host, call_580091.base,
                         call_580091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580091, url, valid)

proc call*(call_580092: Call_ServicebrokerProjectsBrokersCreate_580075;
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
  var path_580093 = newJObject()
  var query_580094 = newJObject()
  var body_580095 = newJObject()
  add(query_580094, "upload_protocol", newJString(uploadProtocol))
  add(query_580094, "fields", newJString(fields))
  add(query_580094, "quotaUser", newJString(quotaUser))
  add(query_580094, "alt", newJString(alt))
  add(query_580094, "oauth_token", newJString(oauthToken))
  add(query_580094, "callback", newJString(callback))
  add(query_580094, "access_token", newJString(accessToken))
  add(query_580094, "uploadType", newJString(uploadType))
  add(path_580093, "parent", newJString(parent))
  add(query_580094, "key", newJString(key))
  add(query_580094, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580095 = body
  add(query_580094, "prettyPrint", newJBool(prettyPrint))
  result = call_580092.call(path_580093, query_580094, nil, nil, body_580095)

var servicebrokerProjectsBrokersCreate* = Call_ServicebrokerProjectsBrokersCreate_580075(
    name: "servicebrokerProjectsBrokersCreate", meth: HttpMethod.HttpPost,
    host: "servicebroker.googleapis.com", route: "/v1beta1/{parent}/brokers",
    validator: validate_ServicebrokerProjectsBrokersCreate_580076, base: "/",
    url: url_ServicebrokerProjectsBrokersCreate_580077, schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersList_580054 = ref object of OpenApiRestCall_579408
proc url_ServicebrokerProjectsBrokersList_580056(protocol: Scheme; host: string;
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

proc validate_ServicebrokerProjectsBrokersList_580055(path: JsonNode;
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
  var valid_580057 = path.getOrDefault("parent")
  valid_580057 = validateParameter(valid_580057, JString, required = true,
                                 default = nil)
  if valid_580057 != nil:
    section.add "parent", valid_580057
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
  var valid_580058 = query.getOrDefault("upload_protocol")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "upload_protocol", valid_580058
  var valid_580059 = query.getOrDefault("fields")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "fields", valid_580059
  var valid_580060 = query.getOrDefault("pageToken")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "pageToken", valid_580060
  var valid_580061 = query.getOrDefault("quotaUser")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "quotaUser", valid_580061
  var valid_580062 = query.getOrDefault("alt")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = newJString("json"))
  if valid_580062 != nil:
    section.add "alt", valid_580062
  var valid_580063 = query.getOrDefault("oauth_token")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "oauth_token", valid_580063
  var valid_580064 = query.getOrDefault("callback")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "callback", valid_580064
  var valid_580065 = query.getOrDefault("access_token")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "access_token", valid_580065
  var valid_580066 = query.getOrDefault("uploadType")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "uploadType", valid_580066
  var valid_580067 = query.getOrDefault("key")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "key", valid_580067
  var valid_580068 = query.getOrDefault("$.xgafv")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = newJString("1"))
  if valid_580068 != nil:
    section.add "$.xgafv", valid_580068
  var valid_580069 = query.getOrDefault("pageSize")
  valid_580069 = validateParameter(valid_580069, JInt, required = false, default = nil)
  if valid_580069 != nil:
    section.add "pageSize", valid_580069
  var valid_580070 = query.getOrDefault("prettyPrint")
  valid_580070 = validateParameter(valid_580070, JBool, required = false,
                                 default = newJBool(true))
  if valid_580070 != nil:
    section.add "prettyPrint", valid_580070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580071: Call_ServicebrokerProjectsBrokersList_580054;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## ListBrokers lists brokers.
  ## 
  let valid = call_580071.validator(path, query, header, formData, body)
  let scheme = call_580071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580071.url(scheme.get, call_580071.host, call_580071.base,
                         call_580071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580071, url, valid)

proc call*(call_580072: Call_ServicebrokerProjectsBrokersList_580054;
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
  var path_580073 = newJObject()
  var query_580074 = newJObject()
  add(query_580074, "upload_protocol", newJString(uploadProtocol))
  add(query_580074, "fields", newJString(fields))
  add(query_580074, "pageToken", newJString(pageToken))
  add(query_580074, "quotaUser", newJString(quotaUser))
  add(query_580074, "alt", newJString(alt))
  add(query_580074, "oauth_token", newJString(oauthToken))
  add(query_580074, "callback", newJString(callback))
  add(query_580074, "access_token", newJString(accessToken))
  add(query_580074, "uploadType", newJString(uploadType))
  add(path_580073, "parent", newJString(parent))
  add(query_580074, "key", newJString(key))
  add(query_580074, "$.xgafv", newJString(Xgafv))
  add(query_580074, "pageSize", newJInt(pageSize))
  add(query_580074, "prettyPrint", newJBool(prettyPrint))
  result = call_580072.call(path_580073, query_580074, nil, nil, nil)

var servicebrokerProjectsBrokersList* = Call_ServicebrokerProjectsBrokersList_580054(
    name: "servicebrokerProjectsBrokersList", meth: HttpMethod.HttpGet,
    host: "servicebroker.googleapis.com", route: "/v1beta1/{parent}/brokers",
    validator: validate_ServicebrokerProjectsBrokersList_580055, base: "/",
    url: url_ServicebrokerProjectsBrokersList_580056, schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersInstancesList_580096 = ref object of OpenApiRestCall_579408
proc url_ServicebrokerProjectsBrokersInstancesList_580098(protocol: Scheme;
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

proc validate_ServicebrokerProjectsBrokersInstancesList_580097(path: JsonNode;
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
  var valid_580099 = path.getOrDefault("parent")
  valid_580099 = validateParameter(valid_580099, JString, required = true,
                                 default = nil)
  if valid_580099 != nil:
    section.add "parent", valid_580099
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
  var valid_580100 = query.getOrDefault("upload_protocol")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "upload_protocol", valid_580100
  var valid_580101 = query.getOrDefault("fields")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "fields", valid_580101
  var valid_580102 = query.getOrDefault("pageToken")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "pageToken", valid_580102
  var valid_580103 = query.getOrDefault("quotaUser")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "quotaUser", valid_580103
  var valid_580104 = query.getOrDefault("alt")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = newJString("json"))
  if valid_580104 != nil:
    section.add "alt", valid_580104
  var valid_580105 = query.getOrDefault("oauth_token")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "oauth_token", valid_580105
  var valid_580106 = query.getOrDefault("callback")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "callback", valid_580106
  var valid_580107 = query.getOrDefault("access_token")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "access_token", valid_580107
  var valid_580108 = query.getOrDefault("uploadType")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "uploadType", valid_580108
  var valid_580109 = query.getOrDefault("key")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "key", valid_580109
  var valid_580110 = query.getOrDefault("$.xgafv")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = newJString("1"))
  if valid_580110 != nil:
    section.add "$.xgafv", valid_580110
  var valid_580111 = query.getOrDefault("pageSize")
  valid_580111 = validateParameter(valid_580111, JInt, required = false, default = nil)
  if valid_580111 != nil:
    section.add "pageSize", valid_580111
  var valid_580112 = query.getOrDefault("prettyPrint")
  valid_580112 = validateParameter(valid_580112, JBool, required = false,
                                 default = newJBool(true))
  if valid_580112 != nil:
    section.add "prettyPrint", valid_580112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580113: Call_ServicebrokerProjectsBrokersInstancesList_580096;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the instances in the brokers
  ## This API is an extension and not part of the OSB spec.
  ## Hence the path is a standard Google API URL.
  ## 
  let valid = call_580113.validator(path, query, header, formData, body)
  let scheme = call_580113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580113.url(scheme.get, call_580113.host, call_580113.base,
                         call_580113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580113, url, valid)

proc call*(call_580114: Call_ServicebrokerProjectsBrokersInstancesList_580096;
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
  var path_580115 = newJObject()
  var query_580116 = newJObject()
  add(query_580116, "upload_protocol", newJString(uploadProtocol))
  add(query_580116, "fields", newJString(fields))
  add(query_580116, "pageToken", newJString(pageToken))
  add(query_580116, "quotaUser", newJString(quotaUser))
  add(query_580116, "alt", newJString(alt))
  add(query_580116, "oauth_token", newJString(oauthToken))
  add(query_580116, "callback", newJString(callback))
  add(query_580116, "access_token", newJString(accessToken))
  add(query_580116, "uploadType", newJString(uploadType))
  add(path_580115, "parent", newJString(parent))
  add(query_580116, "key", newJString(key))
  add(query_580116, "$.xgafv", newJString(Xgafv))
  add(query_580116, "pageSize", newJInt(pageSize))
  add(query_580116, "prettyPrint", newJBool(prettyPrint))
  result = call_580114.call(path_580115, query_580116, nil, nil, nil)

var servicebrokerProjectsBrokersInstancesList* = Call_ServicebrokerProjectsBrokersInstancesList_580096(
    name: "servicebrokerProjectsBrokersInstancesList", meth: HttpMethod.HttpGet,
    host: "servicebroker.googleapis.com", route: "/v1beta1/{parent}/instances",
    validator: validate_ServicebrokerProjectsBrokersInstancesList_580097,
    base: "/", url: url_ServicebrokerProjectsBrokersInstancesList_580098,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_580117 = ref object of OpenApiRestCall_579408
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_580119(
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_580118(
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
  var valid_580120 = path.getOrDefault("parent")
  valid_580120 = validateParameter(valid_580120, JString, required = true,
                                 default = nil)
  if valid_580120 != nil:
    section.add "parent", valid_580120
  var valid_580121 = path.getOrDefault("binding_id")
  valid_580121 = validateParameter(valid_580121, JString, required = true,
                                 default = nil)
  if valid_580121 != nil:
    section.add "binding_id", valid_580121
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
  var valid_580122 = query.getOrDefault("upload_protocol")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "upload_protocol", valid_580122
  var valid_580123 = query.getOrDefault("fields")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "fields", valid_580123
  var valid_580124 = query.getOrDefault("quotaUser")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "quotaUser", valid_580124
  var valid_580125 = query.getOrDefault("alt")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = newJString("json"))
  if valid_580125 != nil:
    section.add "alt", valid_580125
  var valid_580126 = query.getOrDefault("acceptsIncomplete")
  valid_580126 = validateParameter(valid_580126, JBool, required = false, default = nil)
  if valid_580126 != nil:
    section.add "acceptsIncomplete", valid_580126
  var valid_580127 = query.getOrDefault("oauth_token")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "oauth_token", valid_580127
  var valid_580128 = query.getOrDefault("callback")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "callback", valid_580128
  var valid_580129 = query.getOrDefault("access_token")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "access_token", valid_580129
  var valid_580130 = query.getOrDefault("uploadType")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "uploadType", valid_580130
  var valid_580131 = query.getOrDefault("key")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "key", valid_580131
  var valid_580132 = query.getOrDefault("$.xgafv")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = newJString("1"))
  if valid_580132 != nil:
    section.add "$.xgafv", valid_580132
  var valid_580133 = query.getOrDefault("prettyPrint")
  valid_580133 = validateParameter(valid_580133, JBool, required = false,
                                 default = newJBool(true))
  if valid_580133 != nil:
    section.add "prettyPrint", valid_580133
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

proc call*(call_580135: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_580117;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## CreateBinding generates a service binding to an existing service instance.
  ## See ProviServiceInstance for async operation details.
  ## 
  let valid = call_580135.validator(path, query, header, formData, body)
  let scheme = call_580135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580135.url(scheme.get, call_580135.host, call_580135.base,
                         call_580135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580135, url, valid)

proc call*(call_580136: Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_580117;
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
  var path_580137 = newJObject()
  var query_580138 = newJObject()
  var body_580139 = newJObject()
  add(query_580138, "upload_protocol", newJString(uploadProtocol))
  add(query_580138, "fields", newJString(fields))
  add(query_580138, "quotaUser", newJString(quotaUser))
  add(query_580138, "alt", newJString(alt))
  add(query_580138, "acceptsIncomplete", newJBool(acceptsIncomplete))
  add(query_580138, "oauth_token", newJString(oauthToken))
  add(query_580138, "callback", newJString(callback))
  add(query_580138, "access_token", newJString(accessToken))
  add(query_580138, "uploadType", newJString(uploadType))
  add(path_580137, "parent", newJString(parent))
  add(query_580138, "key", newJString(key))
  add(query_580138, "$.xgafv", newJString(Xgafv))
  add(path_580137, "binding_id", newJString(bindingId))
  if body != nil:
    body_580139 = body
  add(query_580138, "prettyPrint", newJBool(prettyPrint))
  result = call_580136.call(path_580137, query_580138, nil, nil, body_580139)

var servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_580117(name: "servicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate",
    meth: HttpMethod.HttpPut, host: "servicebroker.googleapis.com",
    route: "/v1beta1/{parent}/service_bindings/{binding_id}", validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_580118,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesServiceBindingsCreate_580119,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2CatalogList_580140 = ref object of OpenApiRestCall_579408
proc url_ServicebrokerProjectsBrokersV2CatalogList_580142(protocol: Scheme;
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

proc validate_ServicebrokerProjectsBrokersV2CatalogList_580141(path: JsonNode;
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
  var valid_580143 = path.getOrDefault("parent")
  valid_580143 = validateParameter(valid_580143, JString, required = true,
                                 default = nil)
  if valid_580143 != nil:
    section.add "parent", valid_580143
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
  var valid_580144 = query.getOrDefault("upload_protocol")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "upload_protocol", valid_580144
  var valid_580145 = query.getOrDefault("fields")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "fields", valid_580145
  var valid_580146 = query.getOrDefault("pageToken")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "pageToken", valid_580146
  var valid_580147 = query.getOrDefault("quotaUser")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "quotaUser", valid_580147
  var valid_580148 = query.getOrDefault("alt")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = newJString("json"))
  if valid_580148 != nil:
    section.add "alt", valid_580148
  var valid_580149 = query.getOrDefault("oauth_token")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "oauth_token", valid_580149
  var valid_580150 = query.getOrDefault("callback")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "callback", valid_580150
  var valid_580151 = query.getOrDefault("access_token")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "access_token", valid_580151
  var valid_580152 = query.getOrDefault("uploadType")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "uploadType", valid_580152
  var valid_580153 = query.getOrDefault("key")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "key", valid_580153
  var valid_580154 = query.getOrDefault("$.xgafv")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = newJString("1"))
  if valid_580154 != nil:
    section.add "$.xgafv", valid_580154
  var valid_580155 = query.getOrDefault("pageSize")
  valid_580155 = validateParameter(valid_580155, JInt, required = false, default = nil)
  if valid_580155 != nil:
    section.add "pageSize", valid_580155
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
  if body != nil:
    result.add "body", body

proc call*(call_580157: Call_ServicebrokerProjectsBrokersV2CatalogList_580140;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the Services registered with this broker for consumption for
  ## given service registry broker, which contains an set of services.
  ## Note, that Service producer API is separate from Broker API.
  ## 
  let valid = call_580157.validator(path, query, header, formData, body)
  let scheme = call_580157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580157.url(scheme.get, call_580157.host, call_580157.base,
                         call_580157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580157, url, valid)

proc call*(call_580158: Call_ServicebrokerProjectsBrokersV2CatalogList_580140;
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
  var path_580159 = newJObject()
  var query_580160 = newJObject()
  add(query_580160, "upload_protocol", newJString(uploadProtocol))
  add(query_580160, "fields", newJString(fields))
  add(query_580160, "pageToken", newJString(pageToken))
  add(query_580160, "quotaUser", newJString(quotaUser))
  add(query_580160, "alt", newJString(alt))
  add(query_580160, "oauth_token", newJString(oauthToken))
  add(query_580160, "callback", newJString(callback))
  add(query_580160, "access_token", newJString(accessToken))
  add(query_580160, "uploadType", newJString(uploadType))
  add(path_580159, "parent", newJString(parent))
  add(query_580160, "key", newJString(key))
  add(query_580160, "$.xgafv", newJString(Xgafv))
  add(query_580160, "pageSize", newJInt(pageSize))
  add(query_580160, "prettyPrint", newJBool(prettyPrint))
  result = call_580158.call(path_580159, query_580160, nil, nil, nil)

var servicebrokerProjectsBrokersV2CatalogList* = Call_ServicebrokerProjectsBrokersV2CatalogList_580140(
    name: "servicebrokerProjectsBrokersV2CatalogList", meth: HttpMethod.HttpGet,
    host: "servicebroker.googleapis.com", route: "/v1beta1/{parent}/v2/catalog",
    validator: validate_ServicebrokerProjectsBrokersV2CatalogList_580141,
    base: "/", url: url_ServicebrokerProjectsBrokersV2CatalogList_580142,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_580161 = ref object of OpenApiRestCall_579408
proc url_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_580163(
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

proc validate_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_580162(
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
  var valid_580164 = path.getOrDefault("parent")
  valid_580164 = validateParameter(valid_580164, JString, required = true,
                                 default = nil)
  if valid_580164 != nil:
    section.add "parent", valid_580164
  var valid_580165 = path.getOrDefault("instance_id")
  valid_580165 = validateParameter(valid_580165, JString, required = true,
                                 default = nil)
  if valid_580165 != nil:
    section.add "instance_id", valid_580165
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
  var valid_580166 = query.getOrDefault("upload_protocol")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "upload_protocol", valid_580166
  var valid_580167 = query.getOrDefault("fields")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "fields", valid_580167
  var valid_580168 = query.getOrDefault("quotaUser")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "quotaUser", valid_580168
  var valid_580169 = query.getOrDefault("alt")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = newJString("json"))
  if valid_580169 != nil:
    section.add "alt", valid_580169
  var valid_580170 = query.getOrDefault("acceptsIncomplete")
  valid_580170 = validateParameter(valid_580170, JBool, required = false, default = nil)
  if valid_580170 != nil:
    section.add "acceptsIncomplete", valid_580170
  var valid_580171 = query.getOrDefault("oauth_token")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "oauth_token", valid_580171
  var valid_580172 = query.getOrDefault("callback")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "callback", valid_580172
  var valid_580173 = query.getOrDefault("access_token")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "access_token", valid_580173
  var valid_580174 = query.getOrDefault("uploadType")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "uploadType", valid_580174
  var valid_580175 = query.getOrDefault("key")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "key", valid_580175
  var valid_580176 = query.getOrDefault("$.xgafv")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = newJString("1"))
  if valid_580176 != nil:
    section.add "$.xgafv", valid_580176
  var valid_580177 = query.getOrDefault("prettyPrint")
  valid_580177 = validateParameter(valid_580177, JBool, required = false,
                                 default = newJBool(true))
  if valid_580177 != nil:
    section.add "prettyPrint", valid_580177
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

proc call*(call_580179: Call_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_580161;
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
  let valid = call_580179.validator(path, query, header, formData, body)
  let scheme = call_580179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580179.url(scheme.get, call_580179.host, call_580179.base,
                         call_580179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580179, url, valid)

proc call*(call_580180: Call_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_580161;
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
  var path_580181 = newJObject()
  var query_580182 = newJObject()
  var body_580183 = newJObject()
  add(query_580182, "upload_protocol", newJString(uploadProtocol))
  add(query_580182, "fields", newJString(fields))
  add(query_580182, "quotaUser", newJString(quotaUser))
  add(query_580182, "alt", newJString(alt))
  add(query_580182, "acceptsIncomplete", newJBool(acceptsIncomplete))
  add(query_580182, "oauth_token", newJString(oauthToken))
  add(query_580182, "callback", newJString(callback))
  add(query_580182, "access_token", newJString(accessToken))
  add(query_580182, "uploadType", newJString(uploadType))
  add(path_580181, "parent", newJString(parent))
  add(query_580182, "key", newJString(key))
  add(query_580182, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580183 = body
  add(query_580182, "prettyPrint", newJBool(prettyPrint))
  add(path_580181, "instance_id", newJString(instanceId))
  result = call_580180.call(path_580181, query_580182, nil, nil, body_580183)

var servicebrokerProjectsBrokersV2ServiceInstancesCreate* = Call_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_580161(
    name: "servicebrokerProjectsBrokersV2ServiceInstancesCreate",
    meth: HttpMethod.HttpPut, host: "servicebroker.googleapis.com",
    route: "/v1beta1/{parent}/v2/service_instances/{instance_id}",
    validator: validate_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_580162,
    base: "/", url: url_ServicebrokerProjectsBrokersV2ServiceInstancesCreate_580163,
    schemes: {Scheme.Https})
type
  Call_ServicebrokerGetIamPolicy_580184 = ref object of OpenApiRestCall_579408
proc url_ServicebrokerGetIamPolicy_580186(protocol: Scheme; host: string;
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

proc validate_ServicebrokerGetIamPolicy_580185(path: JsonNode; query: JsonNode;
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
  var valid_580187 = path.getOrDefault("resource")
  valid_580187 = validateParameter(valid_580187, JString, required = true,
                                 default = nil)
  if valid_580187 != nil:
    section.add "resource", valid_580187
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
  var valid_580188 = query.getOrDefault("upload_protocol")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "upload_protocol", valid_580188
  var valid_580189 = query.getOrDefault("fields")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "fields", valid_580189
  var valid_580190 = query.getOrDefault("quotaUser")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "quotaUser", valid_580190
  var valid_580191 = query.getOrDefault("alt")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = newJString("json"))
  if valid_580191 != nil:
    section.add "alt", valid_580191
  var valid_580192 = query.getOrDefault("oauth_token")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "oauth_token", valid_580192
  var valid_580193 = query.getOrDefault("callback")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "callback", valid_580193
  var valid_580194 = query.getOrDefault("access_token")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "access_token", valid_580194
  var valid_580195 = query.getOrDefault("uploadType")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "uploadType", valid_580195
  var valid_580196 = query.getOrDefault("options.requestedPolicyVersion")
  valid_580196 = validateParameter(valid_580196, JInt, required = false, default = nil)
  if valid_580196 != nil:
    section.add "options.requestedPolicyVersion", valid_580196
  var valid_580197 = query.getOrDefault("key")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "key", valid_580197
  var valid_580198 = query.getOrDefault("$.xgafv")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = newJString("1"))
  if valid_580198 != nil:
    section.add "$.xgafv", valid_580198
  var valid_580199 = query.getOrDefault("prettyPrint")
  valid_580199 = validateParameter(valid_580199, JBool, required = false,
                                 default = newJBool(true))
  if valid_580199 != nil:
    section.add "prettyPrint", valid_580199
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580200: Call_ServicebrokerGetIamPolicy_580184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the access control policy for a resource.
  ## Returns an empty policy if the resource exists and does not have a policy
  ## set.
  ## 
  let valid = call_580200.validator(path, query, header, formData, body)
  let scheme = call_580200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580200.url(scheme.get, call_580200.host, call_580200.base,
                         call_580200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580200, url, valid)

proc call*(call_580201: Call_ServicebrokerGetIamPolicy_580184; resource: string;
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
  var path_580202 = newJObject()
  var query_580203 = newJObject()
  add(query_580203, "upload_protocol", newJString(uploadProtocol))
  add(query_580203, "fields", newJString(fields))
  add(query_580203, "quotaUser", newJString(quotaUser))
  add(query_580203, "alt", newJString(alt))
  add(query_580203, "oauth_token", newJString(oauthToken))
  add(query_580203, "callback", newJString(callback))
  add(query_580203, "access_token", newJString(accessToken))
  add(query_580203, "uploadType", newJString(uploadType))
  add(query_580203, "options.requestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_580203, "key", newJString(key))
  add(query_580203, "$.xgafv", newJString(Xgafv))
  add(path_580202, "resource", newJString(resource))
  add(query_580203, "prettyPrint", newJBool(prettyPrint))
  result = call_580201.call(path_580202, query_580203, nil, nil, nil)

var servicebrokerGetIamPolicy* = Call_ServicebrokerGetIamPolicy_580184(
    name: "servicebrokerGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "servicebroker.googleapis.com",
    route: "/v1beta1/{resource}:getIamPolicy",
    validator: validate_ServicebrokerGetIamPolicy_580185, base: "/",
    url: url_ServicebrokerGetIamPolicy_580186, schemes: {Scheme.Https})
type
  Call_ServicebrokerSetIamPolicy_580204 = ref object of OpenApiRestCall_579408
proc url_ServicebrokerSetIamPolicy_580206(protocol: Scheme; host: string;
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

proc validate_ServicebrokerSetIamPolicy_580205(path: JsonNode; query: JsonNode;
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
  var valid_580207 = path.getOrDefault("resource")
  valid_580207 = validateParameter(valid_580207, JString, required = true,
                                 default = nil)
  if valid_580207 != nil:
    section.add "resource", valid_580207
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
  var valid_580208 = query.getOrDefault("upload_protocol")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "upload_protocol", valid_580208
  var valid_580209 = query.getOrDefault("fields")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "fields", valid_580209
  var valid_580210 = query.getOrDefault("quotaUser")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "quotaUser", valid_580210
  var valid_580211 = query.getOrDefault("alt")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = newJString("json"))
  if valid_580211 != nil:
    section.add "alt", valid_580211
  var valid_580212 = query.getOrDefault("oauth_token")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "oauth_token", valid_580212
  var valid_580213 = query.getOrDefault("callback")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "callback", valid_580213
  var valid_580214 = query.getOrDefault("access_token")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "access_token", valid_580214
  var valid_580215 = query.getOrDefault("uploadType")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "uploadType", valid_580215
  var valid_580216 = query.getOrDefault("key")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "key", valid_580216
  var valid_580217 = query.getOrDefault("$.xgafv")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = newJString("1"))
  if valid_580217 != nil:
    section.add "$.xgafv", valid_580217
  var valid_580218 = query.getOrDefault("prettyPrint")
  valid_580218 = validateParameter(valid_580218, JBool, required = false,
                                 default = newJBool(true))
  if valid_580218 != nil:
    section.add "prettyPrint", valid_580218
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

proc call*(call_580220: Call_ServicebrokerSetIamPolicy_580204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_580220.validator(path, query, header, formData, body)
  let scheme = call_580220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580220.url(scheme.get, call_580220.host, call_580220.base,
                         call_580220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580220, url, valid)

proc call*(call_580221: Call_ServicebrokerSetIamPolicy_580204; resource: string;
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
  var path_580222 = newJObject()
  var query_580223 = newJObject()
  var body_580224 = newJObject()
  add(query_580223, "upload_protocol", newJString(uploadProtocol))
  add(query_580223, "fields", newJString(fields))
  add(query_580223, "quotaUser", newJString(quotaUser))
  add(query_580223, "alt", newJString(alt))
  add(query_580223, "oauth_token", newJString(oauthToken))
  add(query_580223, "callback", newJString(callback))
  add(query_580223, "access_token", newJString(accessToken))
  add(query_580223, "uploadType", newJString(uploadType))
  add(query_580223, "key", newJString(key))
  add(query_580223, "$.xgafv", newJString(Xgafv))
  add(path_580222, "resource", newJString(resource))
  if body != nil:
    body_580224 = body
  add(query_580223, "prettyPrint", newJBool(prettyPrint))
  result = call_580221.call(path_580222, query_580223, nil, nil, body_580224)

var servicebrokerSetIamPolicy* = Call_ServicebrokerSetIamPolicy_580204(
    name: "servicebrokerSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "servicebroker.googleapis.com",
    route: "/v1beta1/{resource}:setIamPolicy",
    validator: validate_ServicebrokerSetIamPolicy_580205, base: "/",
    url: url_ServicebrokerSetIamPolicy_580206, schemes: {Scheme.Https})
type
  Call_ServicebrokerTestIamPermissions_580225 = ref object of OpenApiRestCall_579408
proc url_ServicebrokerTestIamPermissions_580227(protocol: Scheme; host: string;
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

proc validate_ServicebrokerTestIamPermissions_580226(path: JsonNode;
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
  var valid_580228 = path.getOrDefault("resource")
  valid_580228 = validateParameter(valid_580228, JString, required = true,
                                 default = nil)
  if valid_580228 != nil:
    section.add "resource", valid_580228
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
  var valid_580229 = query.getOrDefault("upload_protocol")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "upload_protocol", valid_580229
  var valid_580230 = query.getOrDefault("fields")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "fields", valid_580230
  var valid_580231 = query.getOrDefault("quotaUser")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "quotaUser", valid_580231
  var valid_580232 = query.getOrDefault("alt")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = newJString("json"))
  if valid_580232 != nil:
    section.add "alt", valid_580232
  var valid_580233 = query.getOrDefault("oauth_token")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "oauth_token", valid_580233
  var valid_580234 = query.getOrDefault("callback")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "callback", valid_580234
  var valid_580235 = query.getOrDefault("access_token")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "access_token", valid_580235
  var valid_580236 = query.getOrDefault("uploadType")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "uploadType", valid_580236
  var valid_580237 = query.getOrDefault("key")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "key", valid_580237
  var valid_580238 = query.getOrDefault("$.xgafv")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = newJString("1"))
  if valid_580238 != nil:
    section.add "$.xgafv", valid_580238
  var valid_580239 = query.getOrDefault("prettyPrint")
  valid_580239 = validateParameter(valid_580239, JBool, required = false,
                                 default = newJBool(true))
  if valid_580239 != nil:
    section.add "prettyPrint", valid_580239
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

proc call*(call_580241: Call_ServicebrokerTestIamPermissions_580225;
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
  let valid = call_580241.validator(path, query, header, formData, body)
  let scheme = call_580241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580241.url(scheme.get, call_580241.host, call_580241.base,
                         call_580241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580241, url, valid)

proc call*(call_580242: Call_ServicebrokerTestIamPermissions_580225;
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
  var path_580243 = newJObject()
  var query_580244 = newJObject()
  var body_580245 = newJObject()
  add(query_580244, "upload_protocol", newJString(uploadProtocol))
  add(query_580244, "fields", newJString(fields))
  add(query_580244, "quotaUser", newJString(quotaUser))
  add(query_580244, "alt", newJString(alt))
  add(query_580244, "oauth_token", newJString(oauthToken))
  add(query_580244, "callback", newJString(callback))
  add(query_580244, "access_token", newJString(accessToken))
  add(query_580244, "uploadType", newJString(uploadType))
  add(query_580244, "key", newJString(key))
  add(query_580244, "$.xgafv", newJString(Xgafv))
  add(path_580243, "resource", newJString(resource))
  if body != nil:
    body_580245 = body
  add(query_580244, "prettyPrint", newJBool(prettyPrint))
  result = call_580242.call(path_580243, query_580244, nil, nil, body_580245)

var servicebrokerTestIamPermissions* = Call_ServicebrokerTestIamPermissions_580225(
    name: "servicebrokerTestIamPermissions", meth: HttpMethod.HttpPost,
    host: "servicebroker.googleapis.com",
    route: "/v1beta1/{resource}:testIamPermissions",
    validator: validate_ServicebrokerTestIamPermissions_580226, base: "/",
    url: url_ServicebrokerTestIamPermissions_580227, schemes: {Scheme.Https})
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
