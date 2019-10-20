
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Service Networking
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Provides automatic management of network configurations necessary for certain services.
## 
## https://cloud.google.com/service-infrastructure/docs/service-networking/getting-started
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
  gcpServiceName = "servicenetworking"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServicenetworkingOperationsGet_578619 = ref object of OpenApiRestCall_578348
proc url_ServicenetworkingOperationsGet_578621(protocol: Scheme; host: string;
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

proc validate_ServicenetworkingOperationsGet_578620(path: JsonNode;
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
  var valid_578747 = path.getOrDefault("name")
  valid_578747 = validateParameter(valid_578747, JString, required = true,
                                 default = nil)
  if valid_578747 != nil:
    section.add "name", valid_578747
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
  var valid_578748 = query.getOrDefault("key")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "key", valid_578748
  var valid_578762 = query.getOrDefault("prettyPrint")
  valid_578762 = validateParameter(valid_578762, JBool, required = false,
                                 default = newJBool(true))
  if valid_578762 != nil:
    section.add "prettyPrint", valid_578762
  var valid_578763 = query.getOrDefault("oauth_token")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = nil)
  if valid_578763 != nil:
    section.add "oauth_token", valid_578763
  var valid_578764 = query.getOrDefault("$.xgafv")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = newJString("1"))
  if valid_578764 != nil:
    section.add "$.xgafv", valid_578764
  var valid_578765 = query.getOrDefault("alt")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = newJString("json"))
  if valid_578765 != nil:
    section.add "alt", valid_578765
  var valid_578766 = query.getOrDefault("uploadType")
  valid_578766 = validateParameter(valid_578766, JString, required = false,
                                 default = nil)
  if valid_578766 != nil:
    section.add "uploadType", valid_578766
  var valid_578767 = query.getOrDefault("quotaUser")
  valid_578767 = validateParameter(valid_578767, JString, required = false,
                                 default = nil)
  if valid_578767 != nil:
    section.add "quotaUser", valid_578767
  var valid_578768 = query.getOrDefault("callback")
  valid_578768 = validateParameter(valid_578768, JString, required = false,
                                 default = nil)
  if valid_578768 != nil:
    section.add "callback", valid_578768
  var valid_578769 = query.getOrDefault("fields")
  valid_578769 = validateParameter(valid_578769, JString, required = false,
                                 default = nil)
  if valid_578769 != nil:
    section.add "fields", valid_578769
  var valid_578770 = query.getOrDefault("access_token")
  valid_578770 = validateParameter(valid_578770, JString, required = false,
                                 default = nil)
  if valid_578770 != nil:
    section.add "access_token", valid_578770
  var valid_578771 = query.getOrDefault("upload_protocol")
  valid_578771 = validateParameter(valid_578771, JString, required = false,
                                 default = nil)
  if valid_578771 != nil:
    section.add "upload_protocol", valid_578771
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578794: Call_ServicenetworkingOperationsGet_578619; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_578794.validator(path, query, header, formData, body)
  let scheme = call_578794.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578794.url(scheme.get, call_578794.host, call_578794.base,
                         call_578794.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578794, url, valid)

proc call*(call_578865: Call_ServicenetworkingOperationsGet_578619; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicenetworkingOperationsGet
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
  var path_578866 = newJObject()
  var query_578868 = newJObject()
  add(query_578868, "key", newJString(key))
  add(query_578868, "prettyPrint", newJBool(prettyPrint))
  add(query_578868, "oauth_token", newJString(oauthToken))
  add(query_578868, "$.xgafv", newJString(Xgafv))
  add(query_578868, "alt", newJString(alt))
  add(query_578868, "uploadType", newJString(uploadType))
  add(query_578868, "quotaUser", newJString(quotaUser))
  add(path_578866, "name", newJString(name))
  add(query_578868, "callback", newJString(callback))
  add(query_578868, "fields", newJString(fields))
  add(query_578868, "access_token", newJString(accessToken))
  add(query_578868, "upload_protocol", newJString(uploadProtocol))
  result = call_578865.call(path_578866, query_578868, nil, nil, nil)

var servicenetworkingOperationsGet* = Call_ServicenetworkingOperationsGet_578619(
    name: "servicenetworkingOperationsGet", meth: HttpMethod.HttpGet,
    host: "servicenetworking.googleapis.com", route: "/v1/{name}",
    validator: validate_ServicenetworkingOperationsGet_578620, base: "/",
    url: url_ServicenetworkingOperationsGet_578621, schemes: {Scheme.Https})
type
  Call_ServicenetworkingServicesConnectionsPatch_578926 = ref object of OpenApiRestCall_578348
proc url_ServicenetworkingServicesConnectionsPatch_578928(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_ServicenetworkingServicesConnectionsPatch_578927(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the allocated ranges that are assigned to a connection.
  ## The response from the `get` operation will be of type `Connection` if the
  ## operation successfully completes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The private service connection that connects to a service producer
  ## organization. The name includes both the private service name and the VPC
  ## network peering name in the format of
  ## `services/{peering_service_name}/connections/{vpc_peering_name}`. For
  ## Google services that support this functionality, this is
  ## 
  ## `services/servicenetworking.googleapis.com/connections/servicenetworking-googleapis-com`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578929 = path.getOrDefault("name")
  valid_578929 = validateParameter(valid_578929, JString, required = true,
                                 default = nil)
  if valid_578929 != nil:
    section.add "name", valid_578929
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
  ##             : The update mask. If this is omitted, it defaults to "*". You can only
  ## update the listed peering ranges.
  ##   force: JBool
  ##        : If a previously defined allocated range is removed, force flag must be
  ## set to true.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578930 = query.getOrDefault("key")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "key", valid_578930
  var valid_578931 = query.getOrDefault("prettyPrint")
  valid_578931 = validateParameter(valid_578931, JBool, required = false,
                                 default = newJBool(true))
  if valid_578931 != nil:
    section.add "prettyPrint", valid_578931
  var valid_578932 = query.getOrDefault("oauth_token")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "oauth_token", valid_578932
  var valid_578933 = query.getOrDefault("$.xgafv")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = newJString("1"))
  if valid_578933 != nil:
    section.add "$.xgafv", valid_578933
  var valid_578934 = query.getOrDefault("alt")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = newJString("json"))
  if valid_578934 != nil:
    section.add "alt", valid_578934
  var valid_578935 = query.getOrDefault("uploadType")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "uploadType", valid_578935
  var valid_578936 = query.getOrDefault("quotaUser")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "quotaUser", valid_578936
  var valid_578937 = query.getOrDefault("updateMask")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "updateMask", valid_578937
  var valid_578938 = query.getOrDefault("force")
  valid_578938 = validateParameter(valid_578938, JBool, required = false, default = nil)
  if valid_578938 != nil:
    section.add "force", valid_578938
  var valid_578939 = query.getOrDefault("callback")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "callback", valid_578939
  var valid_578940 = query.getOrDefault("fields")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "fields", valid_578940
  var valid_578941 = query.getOrDefault("access_token")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "access_token", valid_578941
  var valid_578942 = query.getOrDefault("upload_protocol")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "upload_protocol", valid_578942
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

proc call*(call_578944: Call_ServicenetworkingServicesConnectionsPatch_578926;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the allocated ranges that are assigned to a connection.
  ## The response from the `get` operation will be of type `Connection` if the
  ## operation successfully completes.
  ## 
  let valid = call_578944.validator(path, query, header, formData, body)
  let scheme = call_578944.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578944.url(scheme.get, call_578944.host, call_578944.base,
                         call_578944.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578944, url, valid)

proc call*(call_578945: Call_ServicenetworkingServicesConnectionsPatch_578926;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; updateMask: string = "";
          force: bool = false; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicenetworkingServicesConnectionsPatch
  ## Updates the allocated ranges that are assigned to a connection.
  ## The response from the `get` operation will be of type `Connection` if the
  ## operation successfully completes.
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
  ##       : The private service connection that connects to a service producer
  ## organization. The name includes both the private service name and the VPC
  ## network peering name in the format of
  ## `services/{peering_service_name}/connections/{vpc_peering_name}`. For
  ## Google services that support this functionality, this is
  ## 
  ## `services/servicenetworking.googleapis.com/connections/servicenetworking-googleapis-com`.
  ##   updateMask: string
  ##             : The update mask. If this is omitted, it defaults to "*". You can only
  ## update the listed peering ranges.
  ##   force: bool
  ##        : If a previously defined allocated range is removed, force flag must be
  ## set to true.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578946 = newJObject()
  var query_578947 = newJObject()
  var body_578948 = newJObject()
  add(query_578947, "key", newJString(key))
  add(query_578947, "prettyPrint", newJBool(prettyPrint))
  add(query_578947, "oauth_token", newJString(oauthToken))
  add(query_578947, "$.xgafv", newJString(Xgafv))
  add(query_578947, "alt", newJString(alt))
  add(query_578947, "uploadType", newJString(uploadType))
  add(query_578947, "quotaUser", newJString(quotaUser))
  add(path_578946, "name", newJString(name))
  add(query_578947, "updateMask", newJString(updateMask))
  add(query_578947, "force", newJBool(force))
  if body != nil:
    body_578948 = body
  add(query_578947, "callback", newJString(callback))
  add(query_578947, "fields", newJString(fields))
  add(query_578947, "access_token", newJString(accessToken))
  add(query_578947, "upload_protocol", newJString(uploadProtocol))
  result = call_578945.call(path_578946, query_578947, nil, nil, body_578948)

var servicenetworkingServicesConnectionsPatch* = Call_ServicenetworkingServicesConnectionsPatch_578926(
    name: "servicenetworkingServicesConnectionsPatch", meth: HttpMethod.HttpPatch,
    host: "servicenetworking.googleapis.com", route: "/v1/{name}",
    validator: validate_ServicenetworkingServicesConnectionsPatch_578927,
    base: "/", url: url_ServicenetworkingServicesConnectionsPatch_578928,
    schemes: {Scheme.Https})
type
  Call_ServicenetworkingOperationsDelete_578907 = ref object of OpenApiRestCall_578348
proc url_ServicenetworkingOperationsDelete_578909(protocol: Scheme; host: string;
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

proc validate_ServicenetworkingOperationsDelete_578908(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578910 = path.getOrDefault("name")
  valid_578910 = validateParameter(valid_578910, JString, required = true,
                                 default = nil)
  if valid_578910 != nil:
    section.add "name", valid_578910
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
  var valid_578911 = query.getOrDefault("key")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "key", valid_578911
  var valid_578912 = query.getOrDefault("prettyPrint")
  valid_578912 = validateParameter(valid_578912, JBool, required = false,
                                 default = newJBool(true))
  if valid_578912 != nil:
    section.add "prettyPrint", valid_578912
  var valid_578913 = query.getOrDefault("oauth_token")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "oauth_token", valid_578913
  var valid_578914 = query.getOrDefault("$.xgafv")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = newJString("1"))
  if valid_578914 != nil:
    section.add "$.xgafv", valid_578914
  var valid_578915 = query.getOrDefault("alt")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = newJString("json"))
  if valid_578915 != nil:
    section.add "alt", valid_578915
  var valid_578916 = query.getOrDefault("uploadType")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "uploadType", valid_578916
  var valid_578917 = query.getOrDefault("quotaUser")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "quotaUser", valid_578917
  var valid_578918 = query.getOrDefault("callback")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "callback", valid_578918
  var valid_578919 = query.getOrDefault("fields")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "fields", valid_578919
  var valid_578920 = query.getOrDefault("access_token")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "access_token", valid_578920
  var valid_578921 = query.getOrDefault("upload_protocol")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "upload_protocol", valid_578921
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578922: Call_ServicenetworkingOperationsDelete_578907;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_578922.validator(path, query, header, formData, body)
  let scheme = call_578922.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578922.url(scheme.get, call_578922.host, call_578922.base,
                         call_578922.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578922, url, valid)

proc call*(call_578923: Call_ServicenetworkingOperationsDelete_578907;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicenetworkingOperationsDelete
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
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
  ##       : The name of the operation resource to be deleted.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578924 = newJObject()
  var query_578925 = newJObject()
  add(query_578925, "key", newJString(key))
  add(query_578925, "prettyPrint", newJBool(prettyPrint))
  add(query_578925, "oauth_token", newJString(oauthToken))
  add(query_578925, "$.xgafv", newJString(Xgafv))
  add(query_578925, "alt", newJString(alt))
  add(query_578925, "uploadType", newJString(uploadType))
  add(query_578925, "quotaUser", newJString(quotaUser))
  add(path_578924, "name", newJString(name))
  add(query_578925, "callback", newJString(callback))
  add(query_578925, "fields", newJString(fields))
  add(query_578925, "access_token", newJString(accessToken))
  add(query_578925, "upload_protocol", newJString(uploadProtocol))
  result = call_578923.call(path_578924, query_578925, nil, nil, nil)

var servicenetworkingOperationsDelete* = Call_ServicenetworkingOperationsDelete_578907(
    name: "servicenetworkingOperationsDelete", meth: HttpMethod.HttpDelete,
    host: "servicenetworking.googleapis.com", route: "/v1/{name}",
    validator: validate_ServicenetworkingOperationsDelete_578908, base: "/",
    url: url_ServicenetworkingOperationsDelete_578909, schemes: {Scheme.Https})
type
  Call_ServicenetworkingOperationsCancel_578949 = ref object of OpenApiRestCall_578348
proc url_ServicenetworkingOperationsCancel_578951(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicenetworkingOperationsCancel_578950(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be cancelled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578952 = path.getOrDefault("name")
  valid_578952 = validateParameter(valid_578952, JString, required = true,
                                 default = nil)
  if valid_578952 != nil:
    section.add "name", valid_578952
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578965: Call_ServicenetworkingOperationsCancel_578949;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  let valid = call_578965.validator(path, query, header, formData, body)
  let scheme = call_578965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578965.url(scheme.get, call_578965.host, call_578965.base,
                         call_578965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578965, url, valid)

proc call*(call_578966: Call_ServicenetworkingOperationsCancel_578949;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## servicenetworkingOperationsCancel
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
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
  ##       : The name of the operation resource to be cancelled.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578967 = newJObject()
  var query_578968 = newJObject()
  var body_578969 = newJObject()
  add(query_578968, "key", newJString(key))
  add(query_578968, "prettyPrint", newJBool(prettyPrint))
  add(query_578968, "oauth_token", newJString(oauthToken))
  add(query_578968, "$.xgafv", newJString(Xgafv))
  add(query_578968, "alt", newJString(alt))
  add(query_578968, "uploadType", newJString(uploadType))
  add(query_578968, "quotaUser", newJString(quotaUser))
  add(path_578967, "name", newJString(name))
  if body != nil:
    body_578969 = body
  add(query_578968, "callback", newJString(callback))
  add(query_578968, "fields", newJString(fields))
  add(query_578968, "access_token", newJString(accessToken))
  add(query_578968, "upload_protocol", newJString(uploadProtocol))
  result = call_578966.call(path_578967, query_578968, nil, nil, body_578969)

var servicenetworkingOperationsCancel* = Call_ServicenetworkingOperationsCancel_578949(
    name: "servicenetworkingOperationsCancel", meth: HttpMethod.HttpPost,
    host: "servicenetworking.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_ServicenetworkingOperationsCancel_578950, base: "/",
    url: url_ServicenetworkingOperationsCancel_578951, schemes: {Scheme.Https})
type
  Call_ServicenetworkingServicesConnectionsCreate_578990 = ref object of OpenApiRestCall_578348
proc url_ServicenetworkingServicesConnectionsCreate_578992(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/connections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicenetworkingServicesConnectionsCreate_578991(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a private connection that establishes a VPC Network Peering
  ## connection to a VPC network in the service producer's organization.
  ## The administrator of the service consumer's VPC network invokes this
  ## method. The administrator must assign one or more allocated IP ranges for
  ## provisioning subnetworks in the service producer's VPC network. This
  ## connection is used for all supported services in the service producer's
  ## organization, so it only needs to be invoked once. The response from the
  ## `get` operation will be of type `Connection` if the operation successfully
  ## completes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The service that is managing peering connectivity for a service producer's
  ## organization. For Google services that support this functionality, this
  ## value is `services/servicenetworking.googleapis.com`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_578993 = path.getOrDefault("parent")
  valid_578993 = validateParameter(valid_578993, JString, required = true,
                                 default = nil)
  if valid_578993 != nil:
    section.add "parent", valid_578993
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
  var valid_578994 = query.getOrDefault("key")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "key", valid_578994
  var valid_578995 = query.getOrDefault("prettyPrint")
  valid_578995 = validateParameter(valid_578995, JBool, required = false,
                                 default = newJBool(true))
  if valid_578995 != nil:
    section.add "prettyPrint", valid_578995
  var valid_578996 = query.getOrDefault("oauth_token")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "oauth_token", valid_578996
  var valid_578997 = query.getOrDefault("$.xgafv")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = newJString("1"))
  if valid_578997 != nil:
    section.add "$.xgafv", valid_578997
  var valid_578998 = query.getOrDefault("alt")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = newJString("json"))
  if valid_578998 != nil:
    section.add "alt", valid_578998
  var valid_578999 = query.getOrDefault("uploadType")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "uploadType", valid_578999
  var valid_579000 = query.getOrDefault("quotaUser")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "quotaUser", valid_579000
  var valid_579001 = query.getOrDefault("callback")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "callback", valid_579001
  var valid_579002 = query.getOrDefault("fields")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "fields", valid_579002
  var valid_579003 = query.getOrDefault("access_token")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "access_token", valid_579003
  var valid_579004 = query.getOrDefault("upload_protocol")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "upload_protocol", valid_579004
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

proc call*(call_579006: Call_ServicenetworkingServicesConnectionsCreate_578990;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a private connection that establishes a VPC Network Peering
  ## connection to a VPC network in the service producer's organization.
  ## The administrator of the service consumer's VPC network invokes this
  ## method. The administrator must assign one or more allocated IP ranges for
  ## provisioning subnetworks in the service producer's VPC network. This
  ## connection is used for all supported services in the service producer's
  ## organization, so it only needs to be invoked once. The response from the
  ## `get` operation will be of type `Connection` if the operation successfully
  ## completes.
  ## 
  let valid = call_579006.validator(path, query, header, formData, body)
  let scheme = call_579006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579006.url(scheme.get, call_579006.host, call_579006.base,
                         call_579006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579006, url, valid)

proc call*(call_579007: Call_ServicenetworkingServicesConnectionsCreate_578990;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## servicenetworkingServicesConnectionsCreate
  ## Creates a private connection that establishes a VPC Network Peering
  ## connection to a VPC network in the service producer's organization.
  ## The administrator of the service consumer's VPC network invokes this
  ## method. The administrator must assign one or more allocated IP ranges for
  ## provisioning subnetworks in the service producer's VPC network. This
  ## connection is used for all supported services in the service producer's
  ## organization, so it only needs to be invoked once. The response from the
  ## `get` operation will be of type `Connection` if the operation successfully
  ## completes.
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
  ##         : The service that is managing peering connectivity for a service producer's
  ## organization. For Google services that support this functionality, this
  ## value is `services/servicenetworking.googleapis.com`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579008 = newJObject()
  var query_579009 = newJObject()
  var body_579010 = newJObject()
  add(query_579009, "key", newJString(key))
  add(query_579009, "prettyPrint", newJBool(prettyPrint))
  add(query_579009, "oauth_token", newJString(oauthToken))
  add(query_579009, "$.xgafv", newJString(Xgafv))
  add(query_579009, "alt", newJString(alt))
  add(query_579009, "uploadType", newJString(uploadType))
  add(query_579009, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579010 = body
  add(query_579009, "callback", newJString(callback))
  add(path_579008, "parent", newJString(parent))
  add(query_579009, "fields", newJString(fields))
  add(query_579009, "access_token", newJString(accessToken))
  add(query_579009, "upload_protocol", newJString(uploadProtocol))
  result = call_579007.call(path_579008, query_579009, nil, nil, body_579010)

var servicenetworkingServicesConnectionsCreate* = Call_ServicenetworkingServicesConnectionsCreate_578990(
    name: "servicenetworkingServicesConnectionsCreate", meth: HttpMethod.HttpPost,
    host: "servicenetworking.googleapis.com", route: "/v1/{parent}/connections",
    validator: validate_ServicenetworkingServicesConnectionsCreate_578991,
    base: "/", url: url_ServicenetworkingServicesConnectionsCreate_578992,
    schemes: {Scheme.Https})
type
  Call_ServicenetworkingServicesConnectionsList_578970 = ref object of OpenApiRestCall_578348
proc url_ServicenetworkingServicesConnectionsList_578972(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/connections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicenetworkingServicesConnectionsList_578971(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the private connections that are configured in a service consumer's
  ## VPC network.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The service that is managing peering connectivity for a service producer's
  ## organization. For Google services that support this functionality, this
  ## value is `services/servicenetworking.googleapis.com`.
  ## If you specify `services/-` as the parameter value, all configured peering
  ## services are listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_578973 = path.getOrDefault("parent")
  valid_578973 = validateParameter(valid_578973, JString, required = true,
                                 default = nil)
  if valid_578973 != nil:
    section.add "parent", valid_578973
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
  ##   network: JString
  ##          : The name of service consumer's VPC network that's connected with service
  ## producer network through a private connection. The network name must be in
  ## the following format:
  ## `projects/{project}/global/networks/{network}`. {project} is a
  ## project number, such as in `12345` that includes the VPC service
  ## consumer's VPC network. {network} is the name of the service consumer's VPC
  ## network.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578974 = query.getOrDefault("key")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "key", valid_578974
  var valid_578975 = query.getOrDefault("prettyPrint")
  valid_578975 = validateParameter(valid_578975, JBool, required = false,
                                 default = newJBool(true))
  if valid_578975 != nil:
    section.add "prettyPrint", valid_578975
  var valid_578976 = query.getOrDefault("oauth_token")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "oauth_token", valid_578976
  var valid_578977 = query.getOrDefault("$.xgafv")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = newJString("1"))
  if valid_578977 != nil:
    section.add "$.xgafv", valid_578977
  var valid_578978 = query.getOrDefault("alt")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = newJString("json"))
  if valid_578978 != nil:
    section.add "alt", valid_578978
  var valid_578979 = query.getOrDefault("uploadType")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "uploadType", valid_578979
  var valid_578980 = query.getOrDefault("quotaUser")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "quotaUser", valid_578980
  var valid_578981 = query.getOrDefault("callback")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "callback", valid_578981
  var valid_578982 = query.getOrDefault("network")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "network", valid_578982
  var valid_578983 = query.getOrDefault("fields")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "fields", valid_578983
  var valid_578984 = query.getOrDefault("access_token")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "access_token", valid_578984
  var valid_578985 = query.getOrDefault("upload_protocol")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "upload_protocol", valid_578985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578986: Call_ServicenetworkingServicesConnectionsList_578970;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the private connections that are configured in a service consumer's
  ## VPC network.
  ## 
  let valid = call_578986.validator(path, query, header, formData, body)
  let scheme = call_578986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578986.url(scheme.get, call_578986.host, call_578986.base,
                         call_578986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578986, url, valid)

proc call*(call_578987: Call_ServicenetworkingServicesConnectionsList_578970;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          network: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## servicenetworkingServicesConnectionsList
  ## List the private connections that are configured in a service consumer's
  ## VPC network.
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
  ##   callback: string
  ##           : JSONP
  ##   network: string
  ##          : The name of service consumer's VPC network that's connected with service
  ## producer network through a private connection. The network name must be in
  ## the following format:
  ## `projects/{project}/global/networks/{network}`. {project} is a
  ## project number, such as in `12345` that includes the VPC service
  ## consumer's VPC network. {network} is the name of the service consumer's VPC
  ## network.
  ##   parent: string (required)
  ##         : The service that is managing peering connectivity for a service producer's
  ## organization. For Google services that support this functionality, this
  ## value is `services/servicenetworking.googleapis.com`.
  ## If you specify `services/-` as the parameter value, all configured peering
  ## services are listed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578988 = newJObject()
  var query_578989 = newJObject()
  add(query_578989, "key", newJString(key))
  add(query_578989, "prettyPrint", newJBool(prettyPrint))
  add(query_578989, "oauth_token", newJString(oauthToken))
  add(query_578989, "$.xgafv", newJString(Xgafv))
  add(query_578989, "alt", newJString(alt))
  add(query_578989, "uploadType", newJString(uploadType))
  add(query_578989, "quotaUser", newJString(quotaUser))
  add(query_578989, "callback", newJString(callback))
  add(query_578989, "network", newJString(network))
  add(path_578988, "parent", newJString(parent))
  add(query_578989, "fields", newJString(fields))
  add(query_578989, "access_token", newJString(accessToken))
  add(query_578989, "upload_protocol", newJString(uploadProtocol))
  result = call_578987.call(path_578988, query_578989, nil, nil, nil)

var servicenetworkingServicesConnectionsList* = Call_ServicenetworkingServicesConnectionsList_578970(
    name: "servicenetworkingServicesConnectionsList", meth: HttpMethod.HttpGet,
    host: "servicenetworking.googleapis.com", route: "/v1/{parent}/connections",
    validator: validate_ServicenetworkingServicesConnectionsList_578971,
    base: "/", url: url_ServicenetworkingServicesConnectionsList_578972,
    schemes: {Scheme.Https})
type
  Call_ServicenetworkingServicesAddSubnetwork_579011 = ref object of OpenApiRestCall_578348
proc url_ServicenetworkingServicesAddSubnetwork_579013(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: ":addSubnetwork")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicenetworkingServicesAddSubnetwork_579012(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## For service producers, provisions a new subnet in a
  ## peered service's shared VPC network in the requested region and with the
  ## requested size that's expressed as a CIDR range (number of leading bits of
  ## ipV4 network mask). The method checks against the assigned allocated ranges
  ## to find a non-conflicting IP address range. The method will reuse a subnet
  ## if subsequent calls contain the same subnet name, region, and prefix
  ## length. This method will make producer's tenant project to be a shared VPC
  ## service project as needed. The response from the `get` operation will be of
  ## type `Subnetwork` if the operation successfully completes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. A tenant project in the service producer organization, in the
  ## following format: services/{service}/{collection-id}/{resource-id}.
  ## {collection-id} is the cloud resource collection type that represents the
  ## tenant project. Only `projects` are supported.
  ## {resource-id} is the tenant project numeric id, such as
  ## `123456`. {service} the name of the peering service, such as
  ## `service-peering.example.com`. This service must already be
  ## enabled in the service consumer's project.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579014 = path.getOrDefault("parent")
  valid_579014 = validateParameter(valid_579014, JString, required = true,
                                 default = nil)
  if valid_579014 != nil:
    section.add "parent", valid_579014
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
  var valid_579015 = query.getOrDefault("key")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "key", valid_579015
  var valid_579016 = query.getOrDefault("prettyPrint")
  valid_579016 = validateParameter(valid_579016, JBool, required = false,
                                 default = newJBool(true))
  if valid_579016 != nil:
    section.add "prettyPrint", valid_579016
  var valid_579017 = query.getOrDefault("oauth_token")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "oauth_token", valid_579017
  var valid_579018 = query.getOrDefault("$.xgafv")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = newJString("1"))
  if valid_579018 != nil:
    section.add "$.xgafv", valid_579018
  var valid_579019 = query.getOrDefault("alt")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = newJString("json"))
  if valid_579019 != nil:
    section.add "alt", valid_579019
  var valid_579020 = query.getOrDefault("uploadType")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "uploadType", valid_579020
  var valid_579021 = query.getOrDefault("quotaUser")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "quotaUser", valid_579021
  var valid_579022 = query.getOrDefault("callback")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "callback", valid_579022
  var valid_579023 = query.getOrDefault("fields")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "fields", valid_579023
  var valid_579024 = query.getOrDefault("access_token")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "access_token", valid_579024
  var valid_579025 = query.getOrDefault("upload_protocol")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "upload_protocol", valid_579025
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

proc call*(call_579027: Call_ServicenetworkingServicesAddSubnetwork_579011;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## For service producers, provisions a new subnet in a
  ## peered service's shared VPC network in the requested region and with the
  ## requested size that's expressed as a CIDR range (number of leading bits of
  ## ipV4 network mask). The method checks against the assigned allocated ranges
  ## to find a non-conflicting IP address range. The method will reuse a subnet
  ## if subsequent calls contain the same subnet name, region, and prefix
  ## length. This method will make producer's tenant project to be a shared VPC
  ## service project as needed. The response from the `get` operation will be of
  ## type `Subnetwork` if the operation successfully completes.
  ## 
  let valid = call_579027.validator(path, query, header, formData, body)
  let scheme = call_579027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579027.url(scheme.get, call_579027.host, call_579027.base,
                         call_579027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579027, url, valid)

proc call*(call_579028: Call_ServicenetworkingServicesAddSubnetwork_579011;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## servicenetworkingServicesAddSubnetwork
  ## For service producers, provisions a new subnet in a
  ## peered service's shared VPC network in the requested region and with the
  ## requested size that's expressed as a CIDR range (number of leading bits of
  ## ipV4 network mask). The method checks against the assigned allocated ranges
  ## to find a non-conflicting IP address range. The method will reuse a subnet
  ## if subsequent calls contain the same subnet name, region, and prefix
  ## length. This method will make producer's tenant project to be a shared VPC
  ## service project as needed. The response from the `get` operation will be of
  ## type `Subnetwork` if the operation successfully completes.
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
  ##         : Required. A tenant project in the service producer organization, in the
  ## following format: services/{service}/{collection-id}/{resource-id}.
  ## {collection-id} is the cloud resource collection type that represents the
  ## tenant project. Only `projects` are supported.
  ## {resource-id} is the tenant project numeric id, such as
  ## `123456`. {service} the name of the peering service, such as
  ## `service-peering.example.com`. This service must already be
  ## enabled in the service consumer's project.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579029 = newJObject()
  var query_579030 = newJObject()
  var body_579031 = newJObject()
  add(query_579030, "key", newJString(key))
  add(query_579030, "prettyPrint", newJBool(prettyPrint))
  add(query_579030, "oauth_token", newJString(oauthToken))
  add(query_579030, "$.xgafv", newJString(Xgafv))
  add(query_579030, "alt", newJString(alt))
  add(query_579030, "uploadType", newJString(uploadType))
  add(query_579030, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579031 = body
  add(query_579030, "callback", newJString(callback))
  add(path_579029, "parent", newJString(parent))
  add(query_579030, "fields", newJString(fields))
  add(query_579030, "access_token", newJString(accessToken))
  add(query_579030, "upload_protocol", newJString(uploadProtocol))
  result = call_579028.call(path_579029, query_579030, nil, nil, body_579031)

var servicenetworkingServicesAddSubnetwork* = Call_ServicenetworkingServicesAddSubnetwork_579011(
    name: "servicenetworkingServicesAddSubnetwork", meth: HttpMethod.HttpPost,
    host: "servicenetworking.googleapis.com", route: "/v1/{parent}:addSubnetwork",
    validator: validate_ServicenetworkingServicesAddSubnetwork_579012, base: "/",
    url: url_ServicenetworkingServicesAddSubnetwork_579013,
    schemes: {Scheme.Https})
type
  Call_ServicenetworkingServicesSearchRange_579032 = ref object of OpenApiRestCall_578348
proc url_ServicenetworkingServicesSearchRange_579034(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: ":searchRange")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicenetworkingServicesSearchRange_579033(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Service producers can use this method to find a currently unused range
  ## within consumer allocated ranges.   This returned range is not reserved,
  ## and not guaranteed to remain unused.
  ## It will validate previously provided allocated ranges, find
  ## non-conflicting sub-range of requested size (expressed in
  ## number of leading bits of ipv4 network mask, as in CIDR range
  ## notation).
  ## Operation<response: Range>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. This is in a form services/{service}.
  ## {service} the name of the private access management service, for example
  ## 'service-peering.example.com'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579035 = path.getOrDefault("parent")
  valid_579035 = validateParameter(valid_579035, JString, required = true,
                                 default = nil)
  if valid_579035 != nil:
    section.add "parent", valid_579035
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
  var valid_579036 = query.getOrDefault("key")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "key", valid_579036
  var valid_579037 = query.getOrDefault("prettyPrint")
  valid_579037 = validateParameter(valid_579037, JBool, required = false,
                                 default = newJBool(true))
  if valid_579037 != nil:
    section.add "prettyPrint", valid_579037
  var valid_579038 = query.getOrDefault("oauth_token")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "oauth_token", valid_579038
  var valid_579039 = query.getOrDefault("$.xgafv")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = newJString("1"))
  if valid_579039 != nil:
    section.add "$.xgafv", valid_579039
  var valid_579040 = query.getOrDefault("alt")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = newJString("json"))
  if valid_579040 != nil:
    section.add "alt", valid_579040
  var valid_579041 = query.getOrDefault("uploadType")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "uploadType", valid_579041
  var valid_579042 = query.getOrDefault("quotaUser")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "quotaUser", valid_579042
  var valid_579043 = query.getOrDefault("callback")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "callback", valid_579043
  var valid_579044 = query.getOrDefault("fields")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "fields", valid_579044
  var valid_579045 = query.getOrDefault("access_token")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "access_token", valid_579045
  var valid_579046 = query.getOrDefault("upload_protocol")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "upload_protocol", valid_579046
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

proc call*(call_579048: Call_ServicenetworkingServicesSearchRange_579032;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Service producers can use this method to find a currently unused range
  ## within consumer allocated ranges.   This returned range is not reserved,
  ## and not guaranteed to remain unused.
  ## It will validate previously provided allocated ranges, find
  ## non-conflicting sub-range of requested size (expressed in
  ## number of leading bits of ipv4 network mask, as in CIDR range
  ## notation).
  ## Operation<response: Range>
  ## 
  let valid = call_579048.validator(path, query, header, formData, body)
  let scheme = call_579048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579048.url(scheme.get, call_579048.host, call_579048.base,
                         call_579048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579048, url, valid)

proc call*(call_579049: Call_ServicenetworkingServicesSearchRange_579032;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## servicenetworkingServicesSearchRange
  ## Service producers can use this method to find a currently unused range
  ## within consumer allocated ranges.   This returned range is not reserved,
  ## and not guaranteed to remain unused.
  ## It will validate previously provided allocated ranges, find
  ## non-conflicting sub-range of requested size (expressed in
  ## number of leading bits of ipv4 network mask, as in CIDR range
  ## notation).
  ## Operation<response: Range>
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
  ##         : Required. This is in a form services/{service}.
  ## {service} the name of the private access management service, for example
  ## 'service-peering.example.com'.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579050 = newJObject()
  var query_579051 = newJObject()
  var body_579052 = newJObject()
  add(query_579051, "key", newJString(key))
  add(query_579051, "prettyPrint", newJBool(prettyPrint))
  add(query_579051, "oauth_token", newJString(oauthToken))
  add(query_579051, "$.xgafv", newJString(Xgafv))
  add(query_579051, "alt", newJString(alt))
  add(query_579051, "uploadType", newJString(uploadType))
  add(query_579051, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579052 = body
  add(query_579051, "callback", newJString(callback))
  add(path_579050, "parent", newJString(parent))
  add(query_579051, "fields", newJString(fields))
  add(query_579051, "access_token", newJString(accessToken))
  add(query_579051, "upload_protocol", newJString(uploadProtocol))
  result = call_579049.call(path_579050, query_579051, nil, nil, body_579052)

var servicenetworkingServicesSearchRange* = Call_ServicenetworkingServicesSearchRange_579032(
    name: "servicenetworkingServicesSearchRange", meth: HttpMethod.HttpPost,
    host: "servicenetworking.googleapis.com", route: "/v1/{parent}:searchRange",
    validator: validate_ServicenetworkingServicesSearchRange_579033, base: "/",
    url: url_ServicenetworkingServicesSearchRange_579034, schemes: {Scheme.Https})
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
