
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  gcpServiceName = "servicenetworking"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServicenetworkingOperationsGet_593690 = ref object of OpenApiRestCall_593421
proc url_ServicenetworkingOperationsGet_593692(protocol: Scheme; host: string;
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

proc validate_ServicenetworkingOperationsGet_593691(path: JsonNode;
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
  var valid_593818 = path.getOrDefault("name")
  valid_593818 = validateParameter(valid_593818, JString, required = true,
                                 default = nil)
  if valid_593818 != nil:
    section.add "name", valid_593818
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
  var valid_593819 = query.getOrDefault("upload_protocol")
  valid_593819 = validateParameter(valid_593819, JString, required = false,
                                 default = nil)
  if valid_593819 != nil:
    section.add "upload_protocol", valid_593819
  var valid_593820 = query.getOrDefault("fields")
  valid_593820 = validateParameter(valid_593820, JString, required = false,
                                 default = nil)
  if valid_593820 != nil:
    section.add "fields", valid_593820
  var valid_593821 = query.getOrDefault("quotaUser")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = nil)
  if valid_593821 != nil:
    section.add "quotaUser", valid_593821
  var valid_593835 = query.getOrDefault("alt")
  valid_593835 = validateParameter(valid_593835, JString, required = false,
                                 default = newJString("json"))
  if valid_593835 != nil:
    section.add "alt", valid_593835
  var valid_593836 = query.getOrDefault("oauth_token")
  valid_593836 = validateParameter(valid_593836, JString, required = false,
                                 default = nil)
  if valid_593836 != nil:
    section.add "oauth_token", valid_593836
  var valid_593837 = query.getOrDefault("callback")
  valid_593837 = validateParameter(valid_593837, JString, required = false,
                                 default = nil)
  if valid_593837 != nil:
    section.add "callback", valid_593837
  var valid_593838 = query.getOrDefault("access_token")
  valid_593838 = validateParameter(valid_593838, JString, required = false,
                                 default = nil)
  if valid_593838 != nil:
    section.add "access_token", valid_593838
  var valid_593839 = query.getOrDefault("uploadType")
  valid_593839 = validateParameter(valid_593839, JString, required = false,
                                 default = nil)
  if valid_593839 != nil:
    section.add "uploadType", valid_593839
  var valid_593840 = query.getOrDefault("key")
  valid_593840 = validateParameter(valid_593840, JString, required = false,
                                 default = nil)
  if valid_593840 != nil:
    section.add "key", valid_593840
  var valid_593841 = query.getOrDefault("$.xgafv")
  valid_593841 = validateParameter(valid_593841, JString, required = false,
                                 default = newJString("1"))
  if valid_593841 != nil:
    section.add "$.xgafv", valid_593841
  var valid_593842 = query.getOrDefault("prettyPrint")
  valid_593842 = validateParameter(valid_593842, JBool, required = false,
                                 default = newJBool(true))
  if valid_593842 != nil:
    section.add "prettyPrint", valid_593842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593865: Call_ServicenetworkingOperationsGet_593690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_593865.validator(path, query, header, formData, body)
  let scheme = call_593865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593865.url(scheme.get, call_593865.host, call_593865.base,
                         call_593865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593865, url, valid)

proc call*(call_593936: Call_ServicenetworkingOperationsGet_593690; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## servicenetworkingOperationsGet
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
  var path_593937 = newJObject()
  var query_593939 = newJObject()
  add(query_593939, "upload_protocol", newJString(uploadProtocol))
  add(query_593939, "fields", newJString(fields))
  add(query_593939, "quotaUser", newJString(quotaUser))
  add(path_593937, "name", newJString(name))
  add(query_593939, "alt", newJString(alt))
  add(query_593939, "oauth_token", newJString(oauthToken))
  add(query_593939, "callback", newJString(callback))
  add(query_593939, "access_token", newJString(accessToken))
  add(query_593939, "uploadType", newJString(uploadType))
  add(query_593939, "key", newJString(key))
  add(query_593939, "$.xgafv", newJString(Xgafv))
  add(query_593939, "prettyPrint", newJBool(prettyPrint))
  result = call_593936.call(path_593937, query_593939, nil, nil, nil)

var servicenetworkingOperationsGet* = Call_ServicenetworkingOperationsGet_593690(
    name: "servicenetworkingOperationsGet", meth: HttpMethod.HttpGet,
    host: "servicenetworking.googleapis.com", route: "/v1/{name}",
    validator: validate_ServicenetworkingOperationsGet_593691, base: "/",
    url: url_ServicenetworkingOperationsGet_593692, schemes: {Scheme.Https})
type
  Call_ServicenetworkingServicesConnectionsPatch_593997 = ref object of OpenApiRestCall_593421
proc url_ServicenetworkingServicesConnectionsPatch_593999(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_ServicenetworkingServicesConnectionsPatch_593998(path: JsonNode;
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
  var valid_594000 = path.getOrDefault("name")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "name", valid_594000
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   force: JBool
  ##        : If a previously defined allocated range is removed, force flag must be
  ## set to true.
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
  ##   updateMask: JString
  ##             : The update mask. If this is omitted, it defaults to "*". You can only
  ## update the listed peering ranges.
  section = newJObject()
  var valid_594001 = query.getOrDefault("upload_protocol")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = nil)
  if valid_594001 != nil:
    section.add "upload_protocol", valid_594001
  var valid_594002 = query.getOrDefault("fields")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "fields", valid_594002
  var valid_594003 = query.getOrDefault("force")
  valid_594003 = validateParameter(valid_594003, JBool, required = false, default = nil)
  if valid_594003 != nil:
    section.add "force", valid_594003
  var valid_594004 = query.getOrDefault("quotaUser")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = nil)
  if valid_594004 != nil:
    section.add "quotaUser", valid_594004
  var valid_594005 = query.getOrDefault("alt")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = newJString("json"))
  if valid_594005 != nil:
    section.add "alt", valid_594005
  var valid_594006 = query.getOrDefault("oauth_token")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "oauth_token", valid_594006
  var valid_594007 = query.getOrDefault("callback")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "callback", valid_594007
  var valid_594008 = query.getOrDefault("access_token")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "access_token", valid_594008
  var valid_594009 = query.getOrDefault("uploadType")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "uploadType", valid_594009
  var valid_594010 = query.getOrDefault("key")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "key", valid_594010
  var valid_594011 = query.getOrDefault("$.xgafv")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = newJString("1"))
  if valid_594011 != nil:
    section.add "$.xgafv", valid_594011
  var valid_594012 = query.getOrDefault("prettyPrint")
  valid_594012 = validateParameter(valid_594012, JBool, required = false,
                                 default = newJBool(true))
  if valid_594012 != nil:
    section.add "prettyPrint", valid_594012
  var valid_594013 = query.getOrDefault("updateMask")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "updateMask", valid_594013
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

proc call*(call_594015: Call_ServicenetworkingServicesConnectionsPatch_593997;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the allocated ranges that are assigned to a connection.
  ## The response from the `get` operation will be of type `Connection` if the
  ## operation successfully completes.
  ## 
  let valid = call_594015.validator(path, query, header, formData, body)
  let scheme = call_594015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594015.url(scheme.get, call_594015.host, call_594015.base,
                         call_594015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594015, url, valid)

proc call*(call_594016: Call_ServicenetworkingServicesConnectionsPatch_593997;
          name: string; uploadProtocol: string = ""; fields: string = "";
          force: bool = false; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## servicenetworkingServicesConnectionsPatch
  ## Updates the allocated ranges that are assigned to a connection.
  ## The response from the `get` operation will be of type `Connection` if the
  ## operation successfully completes.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   force: bool
  ##        : If a previously defined allocated range is removed, force flag must be
  ## set to true.
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
  ##   updateMask: string
  ##             : The update mask. If this is omitted, it defaults to "*". You can only
  ## update the listed peering ranges.
  var path_594017 = newJObject()
  var query_594018 = newJObject()
  var body_594019 = newJObject()
  add(query_594018, "upload_protocol", newJString(uploadProtocol))
  add(query_594018, "fields", newJString(fields))
  add(query_594018, "force", newJBool(force))
  add(query_594018, "quotaUser", newJString(quotaUser))
  add(path_594017, "name", newJString(name))
  add(query_594018, "alt", newJString(alt))
  add(query_594018, "oauth_token", newJString(oauthToken))
  add(query_594018, "callback", newJString(callback))
  add(query_594018, "access_token", newJString(accessToken))
  add(query_594018, "uploadType", newJString(uploadType))
  add(query_594018, "key", newJString(key))
  add(query_594018, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594019 = body
  add(query_594018, "prettyPrint", newJBool(prettyPrint))
  add(query_594018, "updateMask", newJString(updateMask))
  result = call_594016.call(path_594017, query_594018, nil, nil, body_594019)

var servicenetworkingServicesConnectionsPatch* = Call_ServicenetworkingServicesConnectionsPatch_593997(
    name: "servicenetworkingServicesConnectionsPatch", meth: HttpMethod.HttpPatch,
    host: "servicenetworking.googleapis.com", route: "/v1/{name}",
    validator: validate_ServicenetworkingServicesConnectionsPatch_593998,
    base: "/", url: url_ServicenetworkingServicesConnectionsPatch_593999,
    schemes: {Scheme.Https})
type
  Call_ServicenetworkingOperationsDelete_593978 = ref object of OpenApiRestCall_593421
proc url_ServicenetworkingOperationsDelete_593980(protocol: Scheme; host: string;
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

proc validate_ServicenetworkingOperationsDelete_593979(path: JsonNode;
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
  var valid_593981 = path.getOrDefault("name")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "name", valid_593981
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
  var valid_593982 = query.getOrDefault("upload_protocol")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "upload_protocol", valid_593982
  var valid_593983 = query.getOrDefault("fields")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "fields", valid_593983
  var valid_593984 = query.getOrDefault("quotaUser")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "quotaUser", valid_593984
  var valid_593985 = query.getOrDefault("alt")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = newJString("json"))
  if valid_593985 != nil:
    section.add "alt", valid_593985
  var valid_593986 = query.getOrDefault("oauth_token")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "oauth_token", valid_593986
  var valid_593987 = query.getOrDefault("callback")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "callback", valid_593987
  var valid_593988 = query.getOrDefault("access_token")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "access_token", valid_593988
  var valid_593989 = query.getOrDefault("uploadType")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "uploadType", valid_593989
  var valid_593990 = query.getOrDefault("key")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "key", valid_593990
  var valid_593991 = query.getOrDefault("$.xgafv")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = newJString("1"))
  if valid_593991 != nil:
    section.add "$.xgafv", valid_593991
  var valid_593992 = query.getOrDefault("prettyPrint")
  valid_593992 = validateParameter(valid_593992, JBool, required = false,
                                 default = newJBool(true))
  if valid_593992 != nil:
    section.add "prettyPrint", valid_593992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593993: Call_ServicenetworkingOperationsDelete_593978;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_593993.validator(path, query, header, formData, body)
  let scheme = call_593993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593993.url(scheme.get, call_593993.host, call_593993.base,
                         call_593993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593993, url, valid)

proc call*(call_593994: Call_ServicenetworkingOperationsDelete_593978;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## servicenetworkingOperationsDelete
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be deleted.
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
  var path_593995 = newJObject()
  var query_593996 = newJObject()
  add(query_593996, "upload_protocol", newJString(uploadProtocol))
  add(query_593996, "fields", newJString(fields))
  add(query_593996, "quotaUser", newJString(quotaUser))
  add(path_593995, "name", newJString(name))
  add(query_593996, "alt", newJString(alt))
  add(query_593996, "oauth_token", newJString(oauthToken))
  add(query_593996, "callback", newJString(callback))
  add(query_593996, "access_token", newJString(accessToken))
  add(query_593996, "uploadType", newJString(uploadType))
  add(query_593996, "key", newJString(key))
  add(query_593996, "$.xgafv", newJString(Xgafv))
  add(query_593996, "prettyPrint", newJBool(prettyPrint))
  result = call_593994.call(path_593995, query_593996, nil, nil, nil)

var servicenetworkingOperationsDelete* = Call_ServicenetworkingOperationsDelete_593978(
    name: "servicenetworkingOperationsDelete", meth: HttpMethod.HttpDelete,
    host: "servicenetworking.googleapis.com", route: "/v1/{name}",
    validator: validate_ServicenetworkingOperationsDelete_593979, base: "/",
    url: url_ServicenetworkingOperationsDelete_593980, schemes: {Scheme.Https})
type
  Call_ServicenetworkingOperationsCancel_594020 = ref object of OpenApiRestCall_593421
proc url_ServicenetworkingOperationsCancel_594022(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServicenetworkingOperationsCancel_594021(path: JsonNode;
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
  var valid_594023 = path.getOrDefault("name")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "name", valid_594023
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594036: Call_ServicenetworkingOperationsCancel_594020;
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
  let valid = call_594036.validator(path, query, header, formData, body)
  let scheme = call_594036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594036.url(scheme.get, call_594036.host, call_594036.base,
                         call_594036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594036, url, valid)

proc call*(call_594037: Call_ServicenetworkingOperationsCancel_594020;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be cancelled.
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
  var path_594038 = newJObject()
  var query_594039 = newJObject()
  var body_594040 = newJObject()
  add(query_594039, "upload_protocol", newJString(uploadProtocol))
  add(query_594039, "fields", newJString(fields))
  add(query_594039, "quotaUser", newJString(quotaUser))
  add(path_594038, "name", newJString(name))
  add(query_594039, "alt", newJString(alt))
  add(query_594039, "oauth_token", newJString(oauthToken))
  add(query_594039, "callback", newJString(callback))
  add(query_594039, "access_token", newJString(accessToken))
  add(query_594039, "uploadType", newJString(uploadType))
  add(query_594039, "key", newJString(key))
  add(query_594039, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594040 = body
  add(query_594039, "prettyPrint", newJBool(prettyPrint))
  result = call_594037.call(path_594038, query_594039, nil, nil, body_594040)

var servicenetworkingOperationsCancel* = Call_ServicenetworkingOperationsCancel_594020(
    name: "servicenetworkingOperationsCancel", meth: HttpMethod.HttpPost,
    host: "servicenetworking.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_ServicenetworkingOperationsCancel_594021, base: "/",
    url: url_ServicenetworkingOperationsCancel_594022, schemes: {Scheme.Https})
type
  Call_ServicenetworkingServicesConnectionsCreate_594061 = ref object of OpenApiRestCall_593421
proc url_ServicenetworkingServicesConnectionsCreate_594063(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServicenetworkingServicesConnectionsCreate_594062(path: JsonNode;
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
  var valid_594064 = path.getOrDefault("parent")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "parent", valid_594064
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
  var valid_594065 = query.getOrDefault("upload_protocol")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "upload_protocol", valid_594065
  var valid_594066 = query.getOrDefault("fields")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = nil)
  if valid_594066 != nil:
    section.add "fields", valid_594066
  var valid_594067 = query.getOrDefault("quotaUser")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = nil)
  if valid_594067 != nil:
    section.add "quotaUser", valid_594067
  var valid_594068 = query.getOrDefault("alt")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = newJString("json"))
  if valid_594068 != nil:
    section.add "alt", valid_594068
  var valid_594069 = query.getOrDefault("oauth_token")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "oauth_token", valid_594069
  var valid_594070 = query.getOrDefault("callback")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "callback", valid_594070
  var valid_594071 = query.getOrDefault("access_token")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "access_token", valid_594071
  var valid_594072 = query.getOrDefault("uploadType")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = nil)
  if valid_594072 != nil:
    section.add "uploadType", valid_594072
  var valid_594073 = query.getOrDefault("key")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "key", valid_594073
  var valid_594074 = query.getOrDefault("$.xgafv")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = newJString("1"))
  if valid_594074 != nil:
    section.add "$.xgafv", valid_594074
  var valid_594075 = query.getOrDefault("prettyPrint")
  valid_594075 = validateParameter(valid_594075, JBool, required = false,
                                 default = newJBool(true))
  if valid_594075 != nil:
    section.add "prettyPrint", valid_594075
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

proc call*(call_594077: Call_ServicenetworkingServicesConnectionsCreate_594061;
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
  let valid = call_594077.validator(path, query, header, formData, body)
  let scheme = call_594077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594077.url(scheme.get, call_594077.host, call_594077.base,
                         call_594077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594077, url, valid)

proc call*(call_594078: Call_ServicenetworkingServicesConnectionsCreate_594061;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##         : The service that is managing peering connectivity for a service producer's
  ## organization. For Google services that support this functionality, this
  ## value is `services/servicenetworking.googleapis.com`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594079 = newJObject()
  var query_594080 = newJObject()
  var body_594081 = newJObject()
  add(query_594080, "upload_protocol", newJString(uploadProtocol))
  add(query_594080, "fields", newJString(fields))
  add(query_594080, "quotaUser", newJString(quotaUser))
  add(query_594080, "alt", newJString(alt))
  add(query_594080, "oauth_token", newJString(oauthToken))
  add(query_594080, "callback", newJString(callback))
  add(query_594080, "access_token", newJString(accessToken))
  add(query_594080, "uploadType", newJString(uploadType))
  add(path_594079, "parent", newJString(parent))
  add(query_594080, "key", newJString(key))
  add(query_594080, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594081 = body
  add(query_594080, "prettyPrint", newJBool(prettyPrint))
  result = call_594078.call(path_594079, query_594080, nil, nil, body_594081)

var servicenetworkingServicesConnectionsCreate* = Call_ServicenetworkingServicesConnectionsCreate_594061(
    name: "servicenetworkingServicesConnectionsCreate", meth: HttpMethod.HttpPost,
    host: "servicenetworking.googleapis.com", route: "/v1/{parent}/connections",
    validator: validate_ServicenetworkingServicesConnectionsCreate_594062,
    base: "/", url: url_ServicenetworkingServicesConnectionsCreate_594063,
    schemes: {Scheme.Https})
type
  Call_ServicenetworkingServicesConnectionsList_594041 = ref object of OpenApiRestCall_593421
proc url_ServicenetworkingServicesConnectionsList_594043(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServicenetworkingServicesConnectionsList_594042(path: JsonNode;
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
  var valid_594044 = path.getOrDefault("parent")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "parent", valid_594044
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
  ##   network: JString
  ##          : The name of service consumer's VPC network that's connected with service
  ## producer network through a private connection. The network name must be in
  ## the following format:
  ## `projects/{project}/global/networks/{network}`. {project} is a
  ## project number, such as in `12345` that includes the VPC service
  ## consumer's VPC network. {network} is the name of the service consumer's VPC
  ## network.
  section = newJObject()
  var valid_594045 = query.getOrDefault("upload_protocol")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = nil)
  if valid_594045 != nil:
    section.add "upload_protocol", valid_594045
  var valid_594046 = query.getOrDefault("fields")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "fields", valid_594046
  var valid_594047 = query.getOrDefault("quotaUser")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = nil)
  if valid_594047 != nil:
    section.add "quotaUser", valid_594047
  var valid_594048 = query.getOrDefault("alt")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = newJString("json"))
  if valid_594048 != nil:
    section.add "alt", valid_594048
  var valid_594049 = query.getOrDefault("oauth_token")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = nil)
  if valid_594049 != nil:
    section.add "oauth_token", valid_594049
  var valid_594050 = query.getOrDefault("callback")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "callback", valid_594050
  var valid_594051 = query.getOrDefault("access_token")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "access_token", valid_594051
  var valid_594052 = query.getOrDefault("uploadType")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "uploadType", valid_594052
  var valid_594053 = query.getOrDefault("key")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = nil)
  if valid_594053 != nil:
    section.add "key", valid_594053
  var valid_594054 = query.getOrDefault("$.xgafv")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = newJString("1"))
  if valid_594054 != nil:
    section.add "$.xgafv", valid_594054
  var valid_594055 = query.getOrDefault("prettyPrint")
  valid_594055 = validateParameter(valid_594055, JBool, required = false,
                                 default = newJBool(true))
  if valid_594055 != nil:
    section.add "prettyPrint", valid_594055
  var valid_594056 = query.getOrDefault("network")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "network", valid_594056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594057: Call_ServicenetworkingServicesConnectionsList_594041;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the private connections that are configured in a service consumer's
  ## VPC network.
  ## 
  let valid = call_594057.validator(path, query, header, formData, body)
  let scheme = call_594057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594057.url(scheme.get, call_594057.host, call_594057.base,
                         call_594057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594057, url, valid)

proc call*(call_594058: Call_ServicenetworkingServicesConnectionsList_594041;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          network: string = ""): Recallable =
  ## servicenetworkingServicesConnectionsList
  ## List the private connections that are configured in a service consumer's
  ## VPC network.
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
  ##         : The service that is managing peering connectivity for a service producer's
  ## organization. For Google services that support this functionality, this
  ## value is `services/servicenetworking.googleapis.com`.
  ## If you specify `services/-` as the parameter value, all configured peering
  ## services are listed.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   network: string
  ##          : The name of service consumer's VPC network that's connected with service
  ## producer network through a private connection. The network name must be in
  ## the following format:
  ## `projects/{project}/global/networks/{network}`. {project} is a
  ## project number, such as in `12345` that includes the VPC service
  ## consumer's VPC network. {network} is the name of the service consumer's VPC
  ## network.
  var path_594059 = newJObject()
  var query_594060 = newJObject()
  add(query_594060, "upload_protocol", newJString(uploadProtocol))
  add(query_594060, "fields", newJString(fields))
  add(query_594060, "quotaUser", newJString(quotaUser))
  add(query_594060, "alt", newJString(alt))
  add(query_594060, "oauth_token", newJString(oauthToken))
  add(query_594060, "callback", newJString(callback))
  add(query_594060, "access_token", newJString(accessToken))
  add(query_594060, "uploadType", newJString(uploadType))
  add(path_594059, "parent", newJString(parent))
  add(query_594060, "key", newJString(key))
  add(query_594060, "$.xgafv", newJString(Xgafv))
  add(query_594060, "prettyPrint", newJBool(prettyPrint))
  add(query_594060, "network", newJString(network))
  result = call_594058.call(path_594059, query_594060, nil, nil, nil)

var servicenetworkingServicesConnectionsList* = Call_ServicenetworkingServicesConnectionsList_594041(
    name: "servicenetworkingServicesConnectionsList", meth: HttpMethod.HttpGet,
    host: "servicenetworking.googleapis.com", route: "/v1/{parent}/connections",
    validator: validate_ServicenetworkingServicesConnectionsList_594042,
    base: "/", url: url_ServicenetworkingServicesConnectionsList_594043,
    schemes: {Scheme.Https})
type
  Call_ServicenetworkingServicesAddSubnetwork_594082 = ref object of OpenApiRestCall_593421
proc url_ServicenetworkingServicesAddSubnetwork_594084(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServicenetworkingServicesAddSubnetwork_594083(path: JsonNode;
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
  var valid_594085 = path.getOrDefault("parent")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "parent", valid_594085
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
  var valid_594086 = query.getOrDefault("upload_protocol")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "upload_protocol", valid_594086
  var valid_594087 = query.getOrDefault("fields")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "fields", valid_594087
  var valid_594088 = query.getOrDefault("quotaUser")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = nil)
  if valid_594088 != nil:
    section.add "quotaUser", valid_594088
  var valid_594089 = query.getOrDefault("alt")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = newJString("json"))
  if valid_594089 != nil:
    section.add "alt", valid_594089
  var valid_594090 = query.getOrDefault("oauth_token")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "oauth_token", valid_594090
  var valid_594091 = query.getOrDefault("callback")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "callback", valid_594091
  var valid_594092 = query.getOrDefault("access_token")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "access_token", valid_594092
  var valid_594093 = query.getOrDefault("uploadType")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "uploadType", valid_594093
  var valid_594094 = query.getOrDefault("key")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "key", valid_594094
  var valid_594095 = query.getOrDefault("$.xgafv")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = newJString("1"))
  if valid_594095 != nil:
    section.add "$.xgafv", valid_594095
  var valid_594096 = query.getOrDefault("prettyPrint")
  valid_594096 = validateParameter(valid_594096, JBool, required = false,
                                 default = newJBool(true))
  if valid_594096 != nil:
    section.add "prettyPrint", valid_594096
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

proc call*(call_594098: Call_ServicenetworkingServicesAddSubnetwork_594082;
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
  let valid = call_594098.validator(path, query, header, formData, body)
  let scheme = call_594098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594098.url(scheme.get, call_594098.host, call_594098.base,
                         call_594098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594098, url, valid)

proc call*(call_594099: Call_ServicenetworkingServicesAddSubnetwork_594082;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##         : Required. A tenant project in the service producer organization, in the
  ## following format: services/{service}/{collection-id}/{resource-id}.
  ## {collection-id} is the cloud resource collection type that represents the
  ## tenant project. Only `projects` are supported.
  ## {resource-id} is the tenant project numeric id, such as
  ## `123456`. {service} the name of the peering service, such as
  ## `service-peering.example.com`. This service must already be
  ## enabled in the service consumer's project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594100 = newJObject()
  var query_594101 = newJObject()
  var body_594102 = newJObject()
  add(query_594101, "upload_protocol", newJString(uploadProtocol))
  add(query_594101, "fields", newJString(fields))
  add(query_594101, "quotaUser", newJString(quotaUser))
  add(query_594101, "alt", newJString(alt))
  add(query_594101, "oauth_token", newJString(oauthToken))
  add(query_594101, "callback", newJString(callback))
  add(query_594101, "access_token", newJString(accessToken))
  add(query_594101, "uploadType", newJString(uploadType))
  add(path_594100, "parent", newJString(parent))
  add(query_594101, "key", newJString(key))
  add(query_594101, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594102 = body
  add(query_594101, "prettyPrint", newJBool(prettyPrint))
  result = call_594099.call(path_594100, query_594101, nil, nil, body_594102)

var servicenetworkingServicesAddSubnetwork* = Call_ServicenetworkingServicesAddSubnetwork_594082(
    name: "servicenetworkingServicesAddSubnetwork", meth: HttpMethod.HttpPost,
    host: "servicenetworking.googleapis.com", route: "/v1/{parent}:addSubnetwork",
    validator: validate_ServicenetworkingServicesAddSubnetwork_594083, base: "/",
    url: url_ServicenetworkingServicesAddSubnetwork_594084,
    schemes: {Scheme.Https})
type
  Call_ServicenetworkingServicesSearchRange_594103 = ref object of OpenApiRestCall_593421
proc url_ServicenetworkingServicesSearchRange_594105(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServicenetworkingServicesSearchRange_594104(path: JsonNode;
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
  var valid_594106 = path.getOrDefault("parent")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "parent", valid_594106
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
  var valid_594107 = query.getOrDefault("upload_protocol")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = nil)
  if valid_594107 != nil:
    section.add "upload_protocol", valid_594107
  var valid_594108 = query.getOrDefault("fields")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = nil)
  if valid_594108 != nil:
    section.add "fields", valid_594108
  var valid_594109 = query.getOrDefault("quotaUser")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = nil)
  if valid_594109 != nil:
    section.add "quotaUser", valid_594109
  var valid_594110 = query.getOrDefault("alt")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = newJString("json"))
  if valid_594110 != nil:
    section.add "alt", valid_594110
  var valid_594111 = query.getOrDefault("oauth_token")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = nil)
  if valid_594111 != nil:
    section.add "oauth_token", valid_594111
  var valid_594112 = query.getOrDefault("callback")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = nil)
  if valid_594112 != nil:
    section.add "callback", valid_594112
  var valid_594113 = query.getOrDefault("access_token")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = nil)
  if valid_594113 != nil:
    section.add "access_token", valid_594113
  var valid_594114 = query.getOrDefault("uploadType")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = nil)
  if valid_594114 != nil:
    section.add "uploadType", valid_594114
  var valid_594115 = query.getOrDefault("key")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = nil)
  if valid_594115 != nil:
    section.add "key", valid_594115
  var valid_594116 = query.getOrDefault("$.xgafv")
  valid_594116 = validateParameter(valid_594116, JString, required = false,
                                 default = newJString("1"))
  if valid_594116 != nil:
    section.add "$.xgafv", valid_594116
  var valid_594117 = query.getOrDefault("prettyPrint")
  valid_594117 = validateParameter(valid_594117, JBool, required = false,
                                 default = newJBool(true))
  if valid_594117 != nil:
    section.add "prettyPrint", valid_594117
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

proc call*(call_594119: Call_ServicenetworkingServicesSearchRange_594103;
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
  let valid = call_594119.validator(path, query, header, formData, body)
  let scheme = call_594119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594119.url(scheme.get, call_594119.host, call_594119.base,
                         call_594119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594119, url, valid)

proc call*(call_594120: Call_ServicenetworkingServicesSearchRange_594103;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## servicenetworkingServicesSearchRange
  ## Service producers can use this method to find a currently unused range
  ## within consumer allocated ranges.   This returned range is not reserved,
  ## and not guaranteed to remain unused.
  ## It will validate previously provided allocated ranges, find
  ## non-conflicting sub-range of requested size (expressed in
  ## number of leading bits of ipv4 network mask, as in CIDR range
  ## notation).
  ## Operation<response: Range>
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
  ##         : Required. This is in a form services/{service}.
  ## {service} the name of the private access management service, for example
  ## 'service-peering.example.com'.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594121 = newJObject()
  var query_594122 = newJObject()
  var body_594123 = newJObject()
  add(query_594122, "upload_protocol", newJString(uploadProtocol))
  add(query_594122, "fields", newJString(fields))
  add(query_594122, "quotaUser", newJString(quotaUser))
  add(query_594122, "alt", newJString(alt))
  add(query_594122, "oauth_token", newJString(oauthToken))
  add(query_594122, "callback", newJString(callback))
  add(query_594122, "access_token", newJString(accessToken))
  add(query_594122, "uploadType", newJString(uploadType))
  add(path_594121, "parent", newJString(parent))
  add(query_594122, "key", newJString(key))
  add(query_594122, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594123 = body
  add(query_594122, "prettyPrint", newJBool(prettyPrint))
  result = call_594120.call(path_594121, query_594122, nil, nil, body_594123)

var servicenetworkingServicesSearchRange* = Call_ServicenetworkingServicesSearchRange_594103(
    name: "servicenetworkingServicesSearchRange", meth: HttpMethod.HttpPost,
    host: "servicenetworking.googleapis.com", route: "/v1/{parent}:searchRange",
    validator: validate_ServicenetworkingServicesSearchRange_594104, base: "/",
    url: url_ServicenetworkingServicesSearchRange_594105, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
