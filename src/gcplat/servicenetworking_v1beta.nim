
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Service Networking
## version: v1beta
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
    segments = @[(kind: ConstantSegment, value: "/v1beta/"),
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
    host: "servicenetworking.googleapis.com", route: "/v1beta/{name}",
    validator: validate_ServicenetworkingOperationsGet_578620, base: "/",
    url: url_ServicenetworkingOperationsGet_578621, schemes: {Scheme.Https})
type
  Call_ServicenetworkingServicesUpdateConnections_578907 = ref object of OpenApiRestCall_578348
proc url_ServicenetworkingServicesUpdateConnections_578909(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/connections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicenetworkingServicesUpdateConnections_578908(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the allocated ranges that are assigned to a connection.
  ## The response from the `get` operation will be of type `Connection` if the
  ## operation successfully completes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The service producer peering service that is managing peering connectivity
  ## for a service producer organization.
  ## For Google services that support this functionality, this is
  ## `services/servicenetworking.googleapis.com`.
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
  var valid_578918 = query.getOrDefault("updateMask")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "updateMask", valid_578918
  var valid_578919 = query.getOrDefault("force")
  valid_578919 = validateParameter(valid_578919, JBool, required = false, default = nil)
  if valid_578919 != nil:
    section.add "force", valid_578919
  var valid_578920 = query.getOrDefault("callback")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "callback", valid_578920
  var valid_578921 = query.getOrDefault("fields")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "fields", valid_578921
  var valid_578922 = query.getOrDefault("access_token")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "access_token", valid_578922
  var valid_578923 = query.getOrDefault("upload_protocol")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "upload_protocol", valid_578923
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

proc call*(call_578925: Call_ServicenetworkingServicesUpdateConnections_578907;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the allocated ranges that are assigned to a connection.
  ## The response from the `get` operation will be of type `Connection` if the
  ## operation successfully completes.
  ## 
  let valid = call_578925.validator(path, query, header, formData, body)
  let scheme = call_578925.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578925.url(scheme.get, call_578925.host, call_578925.base,
                         call_578925.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578925, url, valid)

proc call*(call_578926: Call_ServicenetworkingServicesUpdateConnections_578907;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; updateMask: string = "";
          force: bool = false; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## servicenetworkingServicesUpdateConnections
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
  ##       : The service producer peering service that is managing peering connectivity
  ## for a service producer organization.
  ## For Google services that support this functionality, this is
  ## `services/servicenetworking.googleapis.com`.
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
  var path_578927 = newJObject()
  var query_578928 = newJObject()
  var body_578929 = newJObject()
  add(query_578928, "key", newJString(key))
  add(query_578928, "prettyPrint", newJBool(prettyPrint))
  add(query_578928, "oauth_token", newJString(oauthToken))
  add(query_578928, "$.xgafv", newJString(Xgafv))
  add(query_578928, "alt", newJString(alt))
  add(query_578928, "uploadType", newJString(uploadType))
  add(query_578928, "quotaUser", newJString(quotaUser))
  add(path_578927, "name", newJString(name))
  add(query_578928, "updateMask", newJString(updateMask))
  add(query_578928, "force", newJBool(force))
  if body != nil:
    body_578929 = body
  add(query_578928, "callback", newJString(callback))
  add(query_578928, "fields", newJString(fields))
  add(query_578928, "access_token", newJString(accessToken))
  add(query_578928, "upload_protocol", newJString(uploadProtocol))
  result = call_578926.call(path_578927, query_578928, nil, nil, body_578929)

var servicenetworkingServicesUpdateConnections* = Call_ServicenetworkingServicesUpdateConnections_578907(
    name: "servicenetworkingServicesUpdateConnections",
    meth: HttpMethod.HttpPatch, host: "servicenetworking.googleapis.com",
    route: "/v1beta/{name}/connections",
    validator: validate_ServicenetworkingServicesUpdateConnections_578908,
    base: "/", url: url_ServicenetworkingServicesUpdateConnections_578909,
    schemes: {Scheme.Https})
type
  Call_ServicenetworkingServicesConnectionsCreate_578950 = ref object of OpenApiRestCall_578348
proc url_ServicenetworkingServicesConnectionsCreate_578952(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/connections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicenetworkingServicesConnectionsCreate_578951(path: JsonNode;
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
  var valid_578953 = path.getOrDefault("parent")
  valid_578953 = validateParameter(valid_578953, JString, required = true,
                                 default = nil)
  if valid_578953 != nil:
    section.add "parent", valid_578953
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
  var valid_578954 = query.getOrDefault("key")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "key", valid_578954
  var valid_578955 = query.getOrDefault("prettyPrint")
  valid_578955 = validateParameter(valid_578955, JBool, required = false,
                                 default = newJBool(true))
  if valid_578955 != nil:
    section.add "prettyPrint", valid_578955
  var valid_578956 = query.getOrDefault("oauth_token")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "oauth_token", valid_578956
  var valid_578957 = query.getOrDefault("$.xgafv")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = newJString("1"))
  if valid_578957 != nil:
    section.add "$.xgafv", valid_578957
  var valid_578958 = query.getOrDefault("alt")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = newJString("json"))
  if valid_578958 != nil:
    section.add "alt", valid_578958
  var valid_578959 = query.getOrDefault("uploadType")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "uploadType", valid_578959
  var valid_578960 = query.getOrDefault("quotaUser")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "quotaUser", valid_578960
  var valid_578961 = query.getOrDefault("callback")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "callback", valid_578961
  var valid_578962 = query.getOrDefault("fields")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "fields", valid_578962
  var valid_578963 = query.getOrDefault("access_token")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "access_token", valid_578963
  var valid_578964 = query.getOrDefault("upload_protocol")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "upload_protocol", valid_578964
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

proc call*(call_578966: Call_ServicenetworkingServicesConnectionsCreate_578950;
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
  let valid = call_578966.validator(path, query, header, formData, body)
  let scheme = call_578966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578966.url(scheme.get, call_578966.host, call_578966.base,
                         call_578966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578966, url, valid)

proc call*(call_578967: Call_ServicenetworkingServicesConnectionsCreate_578950;
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
  var path_578968 = newJObject()
  var query_578969 = newJObject()
  var body_578970 = newJObject()
  add(query_578969, "key", newJString(key))
  add(query_578969, "prettyPrint", newJBool(prettyPrint))
  add(query_578969, "oauth_token", newJString(oauthToken))
  add(query_578969, "$.xgafv", newJString(Xgafv))
  add(query_578969, "alt", newJString(alt))
  add(query_578969, "uploadType", newJString(uploadType))
  add(query_578969, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578970 = body
  add(query_578969, "callback", newJString(callback))
  add(path_578968, "parent", newJString(parent))
  add(query_578969, "fields", newJString(fields))
  add(query_578969, "access_token", newJString(accessToken))
  add(query_578969, "upload_protocol", newJString(uploadProtocol))
  result = call_578967.call(path_578968, query_578969, nil, nil, body_578970)

var servicenetworkingServicesConnectionsCreate* = Call_ServicenetworkingServicesConnectionsCreate_578950(
    name: "servicenetworkingServicesConnectionsCreate", meth: HttpMethod.HttpPost,
    host: "servicenetworking.googleapis.com",
    route: "/v1beta/{parent}/connections",
    validator: validate_ServicenetworkingServicesConnectionsCreate_578951,
    base: "/", url: url_ServicenetworkingServicesConnectionsCreate_578952,
    schemes: {Scheme.Https})
type
  Call_ServicenetworkingServicesConnectionsList_578930 = ref object of OpenApiRestCall_578348
proc url_ServicenetworkingServicesConnectionsList_578932(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/connections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicenetworkingServicesConnectionsList_578931(path: JsonNode;
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
  ## If you specify `-` as the parameter value, all configured public peering
  ## services are listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_578933 = path.getOrDefault("parent")
  valid_578933 = validateParameter(valid_578933, JString, required = true,
                                 default = nil)
  if valid_578933 != nil:
    section.add "parent", valid_578933
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
  var valid_578934 = query.getOrDefault("key")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "key", valid_578934
  var valid_578935 = query.getOrDefault("prettyPrint")
  valid_578935 = validateParameter(valid_578935, JBool, required = false,
                                 default = newJBool(true))
  if valid_578935 != nil:
    section.add "prettyPrint", valid_578935
  var valid_578936 = query.getOrDefault("oauth_token")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "oauth_token", valid_578936
  var valid_578937 = query.getOrDefault("$.xgafv")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = newJString("1"))
  if valid_578937 != nil:
    section.add "$.xgafv", valid_578937
  var valid_578938 = query.getOrDefault("alt")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = newJString("json"))
  if valid_578938 != nil:
    section.add "alt", valid_578938
  var valid_578939 = query.getOrDefault("uploadType")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "uploadType", valid_578939
  var valid_578940 = query.getOrDefault("quotaUser")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "quotaUser", valid_578940
  var valid_578941 = query.getOrDefault("callback")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "callback", valid_578941
  var valid_578942 = query.getOrDefault("network")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "network", valid_578942
  var valid_578943 = query.getOrDefault("fields")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "fields", valid_578943
  var valid_578944 = query.getOrDefault("access_token")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "access_token", valid_578944
  var valid_578945 = query.getOrDefault("upload_protocol")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "upload_protocol", valid_578945
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578946: Call_ServicenetworkingServicesConnectionsList_578930;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List the private connections that are configured in a service consumer's
  ## VPC network.
  ## 
  let valid = call_578946.validator(path, query, header, formData, body)
  let scheme = call_578946.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578946.url(scheme.get, call_578946.host, call_578946.base,
                         call_578946.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578946, url, valid)

proc call*(call_578947: Call_ServicenetworkingServicesConnectionsList_578930;
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
  ## If you specify `-` as the parameter value, all configured public peering
  ## services are listed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578948 = newJObject()
  var query_578949 = newJObject()
  add(query_578949, "key", newJString(key))
  add(query_578949, "prettyPrint", newJBool(prettyPrint))
  add(query_578949, "oauth_token", newJString(oauthToken))
  add(query_578949, "$.xgafv", newJString(Xgafv))
  add(query_578949, "alt", newJString(alt))
  add(query_578949, "uploadType", newJString(uploadType))
  add(query_578949, "quotaUser", newJString(quotaUser))
  add(query_578949, "callback", newJString(callback))
  add(query_578949, "network", newJString(network))
  add(path_578948, "parent", newJString(parent))
  add(query_578949, "fields", newJString(fields))
  add(query_578949, "access_token", newJString(accessToken))
  add(query_578949, "upload_protocol", newJString(uploadProtocol))
  result = call_578947.call(path_578948, query_578949, nil, nil, nil)

var servicenetworkingServicesConnectionsList* = Call_ServicenetworkingServicesConnectionsList_578930(
    name: "servicenetworkingServicesConnectionsList", meth: HttpMethod.HttpGet,
    host: "servicenetworking.googleapis.com",
    route: "/v1beta/{parent}/connections",
    validator: validate_ServicenetworkingServicesConnectionsList_578931,
    base: "/", url: url_ServicenetworkingServicesConnectionsList_578932,
    schemes: {Scheme.Https})
type
  Call_ServicenetworkingServicesAddSubnetwork_578971 = ref object of OpenApiRestCall_578348
proc url_ServicenetworkingServicesAddSubnetwork_578973(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: ":addSubnetwork")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicenetworkingServicesAddSubnetwork_578972(path: JsonNode;
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
  var valid_578974 = path.getOrDefault("parent")
  valid_578974 = validateParameter(valid_578974, JString, required = true,
                                 default = nil)
  if valid_578974 != nil:
    section.add "parent", valid_578974
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
  var valid_578975 = query.getOrDefault("key")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "key", valid_578975
  var valid_578976 = query.getOrDefault("prettyPrint")
  valid_578976 = validateParameter(valid_578976, JBool, required = false,
                                 default = newJBool(true))
  if valid_578976 != nil:
    section.add "prettyPrint", valid_578976
  var valid_578977 = query.getOrDefault("oauth_token")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "oauth_token", valid_578977
  var valid_578978 = query.getOrDefault("$.xgafv")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = newJString("1"))
  if valid_578978 != nil:
    section.add "$.xgafv", valid_578978
  var valid_578979 = query.getOrDefault("alt")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = newJString("json"))
  if valid_578979 != nil:
    section.add "alt", valid_578979
  var valid_578980 = query.getOrDefault("uploadType")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "uploadType", valid_578980
  var valid_578981 = query.getOrDefault("quotaUser")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "quotaUser", valid_578981
  var valid_578982 = query.getOrDefault("callback")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "callback", valid_578982
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578987: Call_ServicenetworkingServicesAddSubnetwork_578971;
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
  let valid = call_578987.validator(path, query, header, formData, body)
  let scheme = call_578987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578987.url(scheme.get, call_578987.host, call_578987.base,
                         call_578987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578987, url, valid)

proc call*(call_578988: Call_ServicenetworkingServicesAddSubnetwork_578971;
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
  var path_578989 = newJObject()
  var query_578990 = newJObject()
  var body_578991 = newJObject()
  add(query_578990, "key", newJString(key))
  add(query_578990, "prettyPrint", newJBool(prettyPrint))
  add(query_578990, "oauth_token", newJString(oauthToken))
  add(query_578990, "$.xgafv", newJString(Xgafv))
  add(query_578990, "alt", newJString(alt))
  add(query_578990, "uploadType", newJString(uploadType))
  add(query_578990, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578991 = body
  add(query_578990, "callback", newJString(callback))
  add(path_578989, "parent", newJString(parent))
  add(query_578990, "fields", newJString(fields))
  add(query_578990, "access_token", newJString(accessToken))
  add(query_578990, "upload_protocol", newJString(uploadProtocol))
  result = call_578988.call(path_578989, query_578990, nil, nil, body_578991)

var servicenetworkingServicesAddSubnetwork* = Call_ServicenetworkingServicesAddSubnetwork_578971(
    name: "servicenetworkingServicesAddSubnetwork", meth: HttpMethod.HttpPost,
    host: "servicenetworking.googleapis.com",
    route: "/v1beta/{parent}:addSubnetwork",
    validator: validate_ServicenetworkingServicesAddSubnetwork_578972, base: "/",
    url: url_ServicenetworkingServicesAddSubnetwork_578973,
    schemes: {Scheme.Https})
type
  Call_ServicenetworkingServicesSearchRange_578992 = ref object of OpenApiRestCall_578348
proc url_ServicenetworkingServicesSearchRange_578994(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: ":searchRange")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServicenetworkingServicesSearchRange_578993(path: JsonNode;
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
  var valid_578995 = path.getOrDefault("parent")
  valid_578995 = validateParameter(valid_578995, JString, required = true,
                                 default = nil)
  if valid_578995 != nil:
    section.add "parent", valid_578995
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
  var valid_578996 = query.getOrDefault("key")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "key", valid_578996
  var valid_578997 = query.getOrDefault("prettyPrint")
  valid_578997 = validateParameter(valid_578997, JBool, required = false,
                                 default = newJBool(true))
  if valid_578997 != nil:
    section.add "prettyPrint", valid_578997
  var valid_578998 = query.getOrDefault("oauth_token")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "oauth_token", valid_578998
  var valid_578999 = query.getOrDefault("$.xgafv")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = newJString("1"))
  if valid_578999 != nil:
    section.add "$.xgafv", valid_578999
  var valid_579000 = query.getOrDefault("alt")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = newJString("json"))
  if valid_579000 != nil:
    section.add "alt", valid_579000
  var valid_579001 = query.getOrDefault("uploadType")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "uploadType", valid_579001
  var valid_579002 = query.getOrDefault("quotaUser")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "quotaUser", valid_579002
  var valid_579003 = query.getOrDefault("callback")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "callback", valid_579003
  var valid_579004 = query.getOrDefault("fields")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "fields", valid_579004
  var valid_579005 = query.getOrDefault("access_token")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "access_token", valid_579005
  var valid_579006 = query.getOrDefault("upload_protocol")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "upload_protocol", valid_579006
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

proc call*(call_579008: Call_ServicenetworkingServicesSearchRange_578992;
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
  let valid = call_579008.validator(path, query, header, formData, body)
  let scheme = call_579008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579008.url(scheme.get, call_579008.host, call_579008.base,
                         call_579008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579008, url, valid)

proc call*(call_579009: Call_ServicenetworkingServicesSearchRange_578992;
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
  var path_579010 = newJObject()
  var query_579011 = newJObject()
  var body_579012 = newJObject()
  add(query_579011, "key", newJString(key))
  add(query_579011, "prettyPrint", newJBool(prettyPrint))
  add(query_579011, "oauth_token", newJString(oauthToken))
  add(query_579011, "$.xgafv", newJString(Xgafv))
  add(query_579011, "alt", newJString(alt))
  add(query_579011, "uploadType", newJString(uploadType))
  add(query_579011, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579012 = body
  add(query_579011, "callback", newJString(callback))
  add(path_579010, "parent", newJString(parent))
  add(query_579011, "fields", newJString(fields))
  add(query_579011, "access_token", newJString(accessToken))
  add(query_579011, "upload_protocol", newJString(uploadProtocol))
  result = call_579009.call(path_579010, query_579011, nil, nil, body_579012)

var servicenetworkingServicesSearchRange* = Call_ServicenetworkingServicesSearchRange_578992(
    name: "servicenetworkingServicesSearchRange", meth: HttpMethod.HttpPost,
    host: "servicenetworking.googleapis.com",
    route: "/v1beta/{parent}:searchRange",
    validator: validate_ServicenetworkingServicesSearchRange_578993, base: "/",
    url: url_ServicenetworkingServicesSearchRange_578994, schemes: {Scheme.Https})
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
