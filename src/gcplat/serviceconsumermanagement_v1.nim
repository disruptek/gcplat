
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

## auto-generated via openapi macro
## title: Service Consumer Management
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Manages the service consumers of a Service Infrastructure service.
## 
## https://cloud.google.com/service-consumer-management/docs/overview
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

  OpenApiRestCall_579373 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579373](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579373): Option[Scheme] {.used.} =
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
  gcpServiceName = "serviceconsumermanagement"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServiceconsumermanagementOperationsGet_579644 = ref object of OpenApiRestCall_579373
proc url_ServiceconsumermanagementOperationsGet_579646(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ServiceconsumermanagementOperationsGet_579645(path: JsonNode;
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
  var valid_579772 = path.getOrDefault("name")
  valid_579772 = validateParameter(valid_579772, JString, required = true,
                                 default = nil)
  if valid_579772 != nil:
    section.add "name", valid_579772
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
  var valid_579773 = query.getOrDefault("key")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "key", valid_579773
  var valid_579787 = query.getOrDefault("prettyPrint")
  valid_579787 = validateParameter(valid_579787, JBool, required = false,
                                 default = newJBool(true))
  if valid_579787 != nil:
    section.add "prettyPrint", valid_579787
  var valid_579788 = query.getOrDefault("oauth_token")
  valid_579788 = validateParameter(valid_579788, JString, required = false,
                                 default = nil)
  if valid_579788 != nil:
    section.add "oauth_token", valid_579788
  var valid_579789 = query.getOrDefault("$.xgafv")
  valid_579789 = validateParameter(valid_579789, JString, required = false,
                                 default = newJString("1"))
  if valid_579789 != nil:
    section.add "$.xgafv", valid_579789
  var valid_579790 = query.getOrDefault("alt")
  valid_579790 = validateParameter(valid_579790, JString, required = false,
                                 default = newJString("json"))
  if valid_579790 != nil:
    section.add "alt", valid_579790
  var valid_579791 = query.getOrDefault("uploadType")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "uploadType", valid_579791
  var valid_579792 = query.getOrDefault("quotaUser")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "quotaUser", valid_579792
  var valid_579793 = query.getOrDefault("callback")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = nil)
  if valid_579793 != nil:
    section.add "callback", valid_579793
  var valid_579794 = query.getOrDefault("fields")
  valid_579794 = validateParameter(valid_579794, JString, required = false,
                                 default = nil)
  if valid_579794 != nil:
    section.add "fields", valid_579794
  var valid_579795 = query.getOrDefault("access_token")
  valid_579795 = validateParameter(valid_579795, JString, required = false,
                                 default = nil)
  if valid_579795 != nil:
    section.add "access_token", valid_579795
  var valid_579796 = query.getOrDefault("upload_protocol")
  valid_579796 = validateParameter(valid_579796, JString, required = false,
                                 default = nil)
  if valid_579796 != nil:
    section.add "upload_protocol", valid_579796
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579819: Call_ServiceconsumermanagementOperationsGet_579644;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_579819.validator(path, query, header, formData, body)
  let scheme = call_579819.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579819.url(scheme.get, call_579819.host, call_579819.base,
                         call_579819.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579819, url, valid)

proc call*(call_579890: Call_ServiceconsumermanagementOperationsGet_579644;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## serviceconsumermanagementOperationsGet
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
  var path_579891 = newJObject()
  var query_579893 = newJObject()
  add(query_579893, "key", newJString(key))
  add(query_579893, "prettyPrint", newJBool(prettyPrint))
  add(query_579893, "oauth_token", newJString(oauthToken))
  add(query_579893, "$.xgafv", newJString(Xgafv))
  add(query_579893, "alt", newJString(alt))
  add(query_579893, "uploadType", newJString(uploadType))
  add(query_579893, "quotaUser", newJString(quotaUser))
  add(path_579891, "name", newJString(name))
  add(query_579893, "callback", newJString(callback))
  add(query_579893, "fields", newJString(fields))
  add(query_579893, "access_token", newJString(accessToken))
  add(query_579893, "upload_protocol", newJString(uploadProtocol))
  result = call_579890.call(path_579891, query_579893, nil, nil, nil)

var serviceconsumermanagementOperationsGet* = Call_ServiceconsumermanagementOperationsGet_579644(
    name: "serviceconsumermanagementOperationsGet", meth: HttpMethod.HttpGet,
    host: "serviceconsumermanagement.googleapis.com", route: "/v1/{name}",
    validator: validate_ServiceconsumermanagementOperationsGet_579645, base: "/",
    url: url_ServiceconsumermanagementOperationsGet_579646,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsDelete_579932 = ref object of OpenApiRestCall_579373
proc url_ServiceconsumermanagementServicesTenancyUnitsDelete_579934(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ServiceconsumermanagementServicesTenancyUnitsDelete_579933(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Delete a tenancy unit. Before you delete the tenancy unit, there should be
  ## no tenant resources in it that aren't in a DELETED state.
  ## Operation<response: Empty>.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the tenancy unit to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579935 = path.getOrDefault("name")
  valid_579935 = validateParameter(valid_579935, JString, required = true,
                                 default = nil)
  if valid_579935 != nil:
    section.add "name", valid_579935
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
  var valid_579936 = query.getOrDefault("key")
  valid_579936 = validateParameter(valid_579936, JString, required = false,
                                 default = nil)
  if valid_579936 != nil:
    section.add "key", valid_579936
  var valid_579937 = query.getOrDefault("prettyPrint")
  valid_579937 = validateParameter(valid_579937, JBool, required = false,
                                 default = newJBool(true))
  if valid_579937 != nil:
    section.add "prettyPrint", valid_579937
  var valid_579938 = query.getOrDefault("oauth_token")
  valid_579938 = validateParameter(valid_579938, JString, required = false,
                                 default = nil)
  if valid_579938 != nil:
    section.add "oauth_token", valid_579938
  var valid_579939 = query.getOrDefault("$.xgafv")
  valid_579939 = validateParameter(valid_579939, JString, required = false,
                                 default = newJString("1"))
  if valid_579939 != nil:
    section.add "$.xgafv", valid_579939
  var valid_579940 = query.getOrDefault("alt")
  valid_579940 = validateParameter(valid_579940, JString, required = false,
                                 default = newJString("json"))
  if valid_579940 != nil:
    section.add "alt", valid_579940
  var valid_579941 = query.getOrDefault("uploadType")
  valid_579941 = validateParameter(valid_579941, JString, required = false,
                                 default = nil)
  if valid_579941 != nil:
    section.add "uploadType", valid_579941
  var valid_579942 = query.getOrDefault("quotaUser")
  valid_579942 = validateParameter(valid_579942, JString, required = false,
                                 default = nil)
  if valid_579942 != nil:
    section.add "quotaUser", valid_579942
  var valid_579943 = query.getOrDefault("callback")
  valid_579943 = validateParameter(valid_579943, JString, required = false,
                                 default = nil)
  if valid_579943 != nil:
    section.add "callback", valid_579943
  var valid_579944 = query.getOrDefault("fields")
  valid_579944 = validateParameter(valid_579944, JString, required = false,
                                 default = nil)
  if valid_579944 != nil:
    section.add "fields", valid_579944
  var valid_579945 = query.getOrDefault("access_token")
  valid_579945 = validateParameter(valid_579945, JString, required = false,
                                 default = nil)
  if valid_579945 != nil:
    section.add "access_token", valid_579945
  var valid_579946 = query.getOrDefault("upload_protocol")
  valid_579946 = validateParameter(valid_579946, JString, required = false,
                                 default = nil)
  if valid_579946 != nil:
    section.add "upload_protocol", valid_579946
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579947: Call_ServiceconsumermanagementServicesTenancyUnitsDelete_579932;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a tenancy unit. Before you delete the tenancy unit, there should be
  ## no tenant resources in it that aren't in a DELETED state.
  ## Operation<response: Empty>.
  ## 
  let valid = call_579947.validator(path, query, header, formData, body)
  let scheme = call_579947.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579947.url(scheme.get, call_579947.host, call_579947.base,
                         call_579947.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579947, url, valid)

proc call*(call_579948: Call_ServiceconsumermanagementServicesTenancyUnitsDelete_579932;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## serviceconsumermanagementServicesTenancyUnitsDelete
  ## Delete a tenancy unit. Before you delete the tenancy unit, there should be
  ## no tenant resources in it that aren't in a DELETED state.
  ## Operation<response: Empty>.
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
  ##       : Name of the tenancy unit to be deleted.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579949 = newJObject()
  var query_579950 = newJObject()
  add(query_579950, "key", newJString(key))
  add(query_579950, "prettyPrint", newJBool(prettyPrint))
  add(query_579950, "oauth_token", newJString(oauthToken))
  add(query_579950, "$.xgafv", newJString(Xgafv))
  add(query_579950, "alt", newJString(alt))
  add(query_579950, "uploadType", newJString(uploadType))
  add(query_579950, "quotaUser", newJString(quotaUser))
  add(path_579949, "name", newJString(name))
  add(query_579950, "callback", newJString(callback))
  add(query_579950, "fields", newJString(fields))
  add(query_579950, "access_token", newJString(accessToken))
  add(query_579950, "upload_protocol", newJString(uploadProtocol))
  result = call_579948.call(path_579949, query_579950, nil, nil, nil)

var serviceconsumermanagementServicesTenancyUnitsDelete* = Call_ServiceconsumermanagementServicesTenancyUnitsDelete_579932(
    name: "serviceconsumermanagementServicesTenancyUnitsDelete",
    meth: HttpMethod.HttpDelete, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{name}",
    validator: validate_ServiceconsumermanagementServicesTenancyUnitsDelete_579933,
    base: "/", url: url_ServiceconsumermanagementServicesTenancyUnitsDelete_579934,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_579951 = ref object of OpenApiRestCall_579373
proc url_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_579953(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":applyProjectConfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_579952(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Apply a configuration to an existing tenant project.
  ## This project must exist in an active state and have the original owner
  ## account. The caller must have permission to add a project to the given
  ## tenancy unit. The configuration is applied, but any existing settings on
  ## the project aren't modified.
  ## Specified policy bindings are applied. Existing bindings aren't modified.
  ## Specified services are activated. No service is deactivated.
  ## If specified, new billing configuration is applied.
  ## Omit a billing configuration to keep the existing one.
  ## A service account in the project is created if previously non existed.
  ## Specified labels will be appended to tenant project, note that the value of
  ## existing label key will be updated if the same label key is requested.
  ## The specified folder is ignored, as moving a tenant project to a different
  ## folder isn't supported.
  ## The operation fails if any of the steps fail, but no rollback of already
  ## applied configuration changes is attempted.
  ## Operation<response: Empty>.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the tenancy unit.
  ## Such as 'services/service.googleapis.com/projects/12345/tenancyUnits/abcd'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579954 = path.getOrDefault("name")
  valid_579954 = validateParameter(valid_579954, JString, required = true,
                                 default = nil)
  if valid_579954 != nil:
    section.add "name", valid_579954
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
  var valid_579955 = query.getOrDefault("key")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "key", valid_579955
  var valid_579956 = query.getOrDefault("prettyPrint")
  valid_579956 = validateParameter(valid_579956, JBool, required = false,
                                 default = newJBool(true))
  if valid_579956 != nil:
    section.add "prettyPrint", valid_579956
  var valid_579957 = query.getOrDefault("oauth_token")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "oauth_token", valid_579957
  var valid_579958 = query.getOrDefault("$.xgafv")
  valid_579958 = validateParameter(valid_579958, JString, required = false,
                                 default = newJString("1"))
  if valid_579958 != nil:
    section.add "$.xgafv", valid_579958
  var valid_579959 = query.getOrDefault("alt")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = newJString("json"))
  if valid_579959 != nil:
    section.add "alt", valid_579959
  var valid_579960 = query.getOrDefault("uploadType")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "uploadType", valid_579960
  var valid_579961 = query.getOrDefault("quotaUser")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "quotaUser", valid_579961
  var valid_579962 = query.getOrDefault("callback")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "callback", valid_579962
  var valid_579963 = query.getOrDefault("fields")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "fields", valid_579963
  var valid_579964 = query.getOrDefault("access_token")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "access_token", valid_579964
  var valid_579965 = query.getOrDefault("upload_protocol")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "upload_protocol", valid_579965
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

proc call*(call_579967: Call_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_579951;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Apply a configuration to an existing tenant project.
  ## This project must exist in an active state and have the original owner
  ## account. The caller must have permission to add a project to the given
  ## tenancy unit. The configuration is applied, but any existing settings on
  ## the project aren't modified.
  ## Specified policy bindings are applied. Existing bindings aren't modified.
  ## Specified services are activated. No service is deactivated.
  ## If specified, new billing configuration is applied.
  ## Omit a billing configuration to keep the existing one.
  ## A service account in the project is created if previously non existed.
  ## Specified labels will be appended to tenant project, note that the value of
  ## existing label key will be updated if the same label key is requested.
  ## The specified folder is ignored, as moving a tenant project to a different
  ## folder isn't supported.
  ## The operation fails if any of the steps fail, but no rollback of already
  ## applied configuration changes is attempted.
  ## Operation<response: Empty>.
  ## 
  let valid = call_579967.validator(path, query, header, formData, body)
  let scheme = call_579967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579967.url(scheme.get, call_579967.host, call_579967.base,
                         call_579967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579967, url, valid)

proc call*(call_579968: Call_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_579951;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## serviceconsumermanagementServicesTenancyUnitsApplyProjectConfig
  ## Apply a configuration to an existing tenant project.
  ## This project must exist in an active state and have the original owner
  ## account. The caller must have permission to add a project to the given
  ## tenancy unit. The configuration is applied, but any existing settings on
  ## the project aren't modified.
  ## Specified policy bindings are applied. Existing bindings aren't modified.
  ## Specified services are activated. No service is deactivated.
  ## If specified, new billing configuration is applied.
  ## Omit a billing configuration to keep the existing one.
  ## A service account in the project is created if previously non existed.
  ## Specified labels will be appended to tenant project, note that the value of
  ## existing label key will be updated if the same label key is requested.
  ## The specified folder is ignored, as moving a tenant project to a different
  ## folder isn't supported.
  ## The operation fails if any of the steps fail, but no rollback of already
  ## applied configuration changes is attempted.
  ## Operation<response: Empty>.
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
  ##       : Name of the tenancy unit.
  ## Such as 'services/service.googleapis.com/projects/12345/tenancyUnits/abcd'.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579969 = newJObject()
  var query_579970 = newJObject()
  var body_579971 = newJObject()
  add(query_579970, "key", newJString(key))
  add(query_579970, "prettyPrint", newJBool(prettyPrint))
  add(query_579970, "oauth_token", newJString(oauthToken))
  add(query_579970, "$.xgafv", newJString(Xgafv))
  add(query_579970, "alt", newJString(alt))
  add(query_579970, "uploadType", newJString(uploadType))
  add(query_579970, "quotaUser", newJString(quotaUser))
  add(path_579969, "name", newJString(name))
  if body != nil:
    body_579971 = body
  add(query_579970, "callback", newJString(callback))
  add(query_579970, "fields", newJString(fields))
  add(query_579970, "access_token", newJString(accessToken))
  add(query_579970, "upload_protocol", newJString(uploadProtocol))
  result = call_579968.call(path_579969, query_579970, nil, nil, body_579971)

var serviceconsumermanagementServicesTenancyUnitsApplyProjectConfig* = Call_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_579951(
    name: "serviceconsumermanagementServicesTenancyUnitsApplyProjectConfig",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{name}:applyProjectConfig", validator: validate_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_579952,
    base: "/",
    url: url_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_579953,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsAttachProject_579972 = ref object of OpenApiRestCall_579373
proc url_ServiceconsumermanagementServicesTenancyUnitsAttachProject_579974(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":attachProject")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ServiceconsumermanagementServicesTenancyUnitsAttachProject_579973(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Attach an existing project to the tenancy unit as a new tenant
  ## resource. The project could either be the tenant project reserved by
  ## calling `AddTenantProject` under a tenancy unit of a service producer's
  ## project of a managed service, or from a separate project.
  ## The caller is checked against a set of permissions as if calling
  ## `AddTenantProject` on the same service consumer.
  ## To trigger the attachment, the targeted tenant project must be in a
  ## folder. Make sure the ServiceConsumerManagement service account is
  ## the owner of that project. These two requirements are already met
  ## if the project is reserved by calling `AddTenantProject`.
  ## Operation<response: Empty>.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the tenancy unit that the project will be attached to.
  ## Such as 'services/service.googleapis.com/projects/12345/tenancyUnits/abcd'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579975 = path.getOrDefault("name")
  valid_579975 = validateParameter(valid_579975, JString, required = true,
                                 default = nil)
  if valid_579975 != nil:
    section.add "name", valid_579975
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
  var valid_579976 = query.getOrDefault("key")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "key", valid_579976
  var valid_579977 = query.getOrDefault("prettyPrint")
  valid_579977 = validateParameter(valid_579977, JBool, required = false,
                                 default = newJBool(true))
  if valid_579977 != nil:
    section.add "prettyPrint", valid_579977
  var valid_579978 = query.getOrDefault("oauth_token")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "oauth_token", valid_579978
  var valid_579979 = query.getOrDefault("$.xgafv")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = newJString("1"))
  if valid_579979 != nil:
    section.add "$.xgafv", valid_579979
  var valid_579980 = query.getOrDefault("alt")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = newJString("json"))
  if valid_579980 != nil:
    section.add "alt", valid_579980
  var valid_579981 = query.getOrDefault("uploadType")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "uploadType", valid_579981
  var valid_579982 = query.getOrDefault("quotaUser")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "quotaUser", valid_579982
  var valid_579983 = query.getOrDefault("callback")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "callback", valid_579983
  var valid_579984 = query.getOrDefault("fields")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "fields", valid_579984
  var valid_579985 = query.getOrDefault("access_token")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "access_token", valid_579985
  var valid_579986 = query.getOrDefault("upload_protocol")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "upload_protocol", valid_579986
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

proc call*(call_579988: Call_ServiceconsumermanagementServicesTenancyUnitsAttachProject_579972;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Attach an existing project to the tenancy unit as a new tenant
  ## resource. The project could either be the tenant project reserved by
  ## calling `AddTenantProject` under a tenancy unit of a service producer's
  ## project of a managed service, or from a separate project.
  ## The caller is checked against a set of permissions as if calling
  ## `AddTenantProject` on the same service consumer.
  ## To trigger the attachment, the targeted tenant project must be in a
  ## folder. Make sure the ServiceConsumerManagement service account is
  ## the owner of that project. These two requirements are already met
  ## if the project is reserved by calling `AddTenantProject`.
  ## Operation<response: Empty>.
  ## 
  let valid = call_579988.validator(path, query, header, formData, body)
  let scheme = call_579988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579988.url(scheme.get, call_579988.host, call_579988.base,
                         call_579988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579988, url, valid)

proc call*(call_579989: Call_ServiceconsumermanagementServicesTenancyUnitsAttachProject_579972;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## serviceconsumermanagementServicesTenancyUnitsAttachProject
  ## Attach an existing project to the tenancy unit as a new tenant
  ## resource. The project could either be the tenant project reserved by
  ## calling `AddTenantProject` under a tenancy unit of a service producer's
  ## project of a managed service, or from a separate project.
  ## The caller is checked against a set of permissions as if calling
  ## `AddTenantProject` on the same service consumer.
  ## To trigger the attachment, the targeted tenant project must be in a
  ## folder. Make sure the ServiceConsumerManagement service account is
  ## the owner of that project. These two requirements are already met
  ## if the project is reserved by calling `AddTenantProject`.
  ## Operation<response: Empty>.
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
  ##       : Name of the tenancy unit that the project will be attached to.
  ## Such as 'services/service.googleapis.com/projects/12345/tenancyUnits/abcd'.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579990 = newJObject()
  var query_579991 = newJObject()
  var body_579992 = newJObject()
  add(query_579991, "key", newJString(key))
  add(query_579991, "prettyPrint", newJBool(prettyPrint))
  add(query_579991, "oauth_token", newJString(oauthToken))
  add(query_579991, "$.xgafv", newJString(Xgafv))
  add(query_579991, "alt", newJString(alt))
  add(query_579991, "uploadType", newJString(uploadType))
  add(query_579991, "quotaUser", newJString(quotaUser))
  add(path_579990, "name", newJString(name))
  if body != nil:
    body_579992 = body
  add(query_579991, "callback", newJString(callback))
  add(query_579991, "fields", newJString(fields))
  add(query_579991, "access_token", newJString(accessToken))
  add(query_579991, "upload_protocol", newJString(uploadProtocol))
  result = call_579989.call(path_579990, query_579991, nil, nil, body_579992)

var serviceconsumermanagementServicesTenancyUnitsAttachProject* = Call_ServiceconsumermanagementServicesTenancyUnitsAttachProject_579972(
    name: "serviceconsumermanagementServicesTenancyUnitsAttachProject",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{name}:attachProject", validator: validate_ServiceconsumermanagementServicesTenancyUnitsAttachProject_579973,
    base: "/",
    url: url_ServiceconsumermanagementServicesTenancyUnitsAttachProject_579974,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementOperationsCancel_579993 = ref object of OpenApiRestCall_579373
proc url_ServiceconsumermanagementOperationsCancel_579995(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ServiceconsumermanagementOperationsCancel_579994(path: JsonNode;
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
  var valid_579996 = path.getOrDefault("name")
  valid_579996 = validateParameter(valid_579996, JString, required = true,
                                 default = nil)
  if valid_579996 != nil:
    section.add "name", valid_579996
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
  var valid_579997 = query.getOrDefault("key")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "key", valid_579997
  var valid_579998 = query.getOrDefault("prettyPrint")
  valid_579998 = validateParameter(valid_579998, JBool, required = false,
                                 default = newJBool(true))
  if valid_579998 != nil:
    section.add "prettyPrint", valid_579998
  var valid_579999 = query.getOrDefault("oauth_token")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "oauth_token", valid_579999
  var valid_580000 = query.getOrDefault("$.xgafv")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = newJString("1"))
  if valid_580000 != nil:
    section.add "$.xgafv", valid_580000
  var valid_580001 = query.getOrDefault("alt")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = newJString("json"))
  if valid_580001 != nil:
    section.add "alt", valid_580001
  var valid_580002 = query.getOrDefault("uploadType")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "uploadType", valid_580002
  var valid_580003 = query.getOrDefault("quotaUser")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "quotaUser", valid_580003
  var valid_580004 = query.getOrDefault("callback")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "callback", valid_580004
  var valid_580005 = query.getOrDefault("fields")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "fields", valid_580005
  var valid_580006 = query.getOrDefault("access_token")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "access_token", valid_580006
  var valid_580007 = query.getOrDefault("upload_protocol")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "upload_protocol", valid_580007
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

proc call*(call_580009: Call_ServiceconsumermanagementOperationsCancel_579993;
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
  let valid = call_580009.validator(path, query, header, formData, body)
  let scheme = call_580009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580009.url(scheme.get, call_580009.host, call_580009.base,
                         call_580009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580009, url, valid)

proc call*(call_580010: Call_ServiceconsumermanagementOperationsCancel_579993;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## serviceconsumermanagementOperationsCancel
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
  var path_580011 = newJObject()
  var query_580012 = newJObject()
  var body_580013 = newJObject()
  add(query_580012, "key", newJString(key))
  add(query_580012, "prettyPrint", newJBool(prettyPrint))
  add(query_580012, "oauth_token", newJString(oauthToken))
  add(query_580012, "$.xgafv", newJString(Xgafv))
  add(query_580012, "alt", newJString(alt))
  add(query_580012, "uploadType", newJString(uploadType))
  add(query_580012, "quotaUser", newJString(quotaUser))
  add(path_580011, "name", newJString(name))
  if body != nil:
    body_580013 = body
  add(query_580012, "callback", newJString(callback))
  add(query_580012, "fields", newJString(fields))
  add(query_580012, "access_token", newJString(accessToken))
  add(query_580012, "upload_protocol", newJString(uploadProtocol))
  result = call_580010.call(path_580011, query_580012, nil, nil, body_580013)

var serviceconsumermanagementOperationsCancel* = Call_ServiceconsumermanagementOperationsCancel_579993(
    name: "serviceconsumermanagementOperationsCancel", meth: HttpMethod.HttpPost,
    host: "serviceconsumermanagement.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_ServiceconsumermanagementOperationsCancel_579994,
    base: "/", url: url_ServiceconsumermanagementOperationsCancel_579995,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_580014 = ref object of OpenApiRestCall_579373
proc url_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_580016(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":deleteProject")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_580015(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes the specified project resource identified by a tenant resource tag.
  ## The mothod removes a project lien with a 'TenantManager' origin if that was
  ## added. It will then attempt to delete the project. If that operation fails,
  ## this method also fails.
  ## After the project has been deleted, the tenant resource state is set to
  ## DELETED.  To permanently remove resource metadata, call the
  ## `RemoveTenantProject` method.
  ## New resources with the same tag can't be added if there are existing
  ## resources in a DELETED state.
  ## Operation<response: Empty>.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the tenancy unit.
  ## Such as 'services/service.googleapis.com/projects/12345/tenancyUnits/abcd'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580017 = path.getOrDefault("name")
  valid_580017 = validateParameter(valid_580017, JString, required = true,
                                 default = nil)
  if valid_580017 != nil:
    section.add "name", valid_580017
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
  var valid_580018 = query.getOrDefault("key")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "key", valid_580018
  var valid_580019 = query.getOrDefault("prettyPrint")
  valid_580019 = validateParameter(valid_580019, JBool, required = false,
                                 default = newJBool(true))
  if valid_580019 != nil:
    section.add "prettyPrint", valid_580019
  var valid_580020 = query.getOrDefault("oauth_token")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "oauth_token", valid_580020
  var valid_580021 = query.getOrDefault("$.xgafv")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = newJString("1"))
  if valid_580021 != nil:
    section.add "$.xgafv", valid_580021
  var valid_580022 = query.getOrDefault("alt")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = newJString("json"))
  if valid_580022 != nil:
    section.add "alt", valid_580022
  var valid_580023 = query.getOrDefault("uploadType")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "uploadType", valid_580023
  var valid_580024 = query.getOrDefault("quotaUser")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "quotaUser", valid_580024
  var valid_580025 = query.getOrDefault("callback")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "callback", valid_580025
  var valid_580026 = query.getOrDefault("fields")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "fields", valid_580026
  var valid_580027 = query.getOrDefault("access_token")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "access_token", valid_580027
  var valid_580028 = query.getOrDefault("upload_protocol")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "upload_protocol", valid_580028
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

proc call*(call_580030: Call_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_580014;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified project resource identified by a tenant resource tag.
  ## The mothod removes a project lien with a 'TenantManager' origin if that was
  ## added. It will then attempt to delete the project. If that operation fails,
  ## this method also fails.
  ## After the project has been deleted, the tenant resource state is set to
  ## DELETED.  To permanently remove resource metadata, call the
  ## `RemoveTenantProject` method.
  ## New resources with the same tag can't be added if there are existing
  ## resources in a DELETED state.
  ## Operation<response: Empty>.
  ## 
  let valid = call_580030.validator(path, query, header, formData, body)
  let scheme = call_580030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580030.url(scheme.get, call_580030.host, call_580030.base,
                         call_580030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580030, url, valid)

proc call*(call_580031: Call_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_580014;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## serviceconsumermanagementServicesTenancyUnitsDeleteProject
  ## Deletes the specified project resource identified by a tenant resource tag.
  ## The mothod removes a project lien with a 'TenantManager' origin if that was
  ## added. It will then attempt to delete the project. If that operation fails,
  ## this method also fails.
  ## After the project has been deleted, the tenant resource state is set to
  ## DELETED.  To permanently remove resource metadata, call the
  ## `RemoveTenantProject` method.
  ## New resources with the same tag can't be added if there are existing
  ## resources in a DELETED state.
  ## Operation<response: Empty>.
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
  ##       : Name of the tenancy unit.
  ## Such as 'services/service.googleapis.com/projects/12345/tenancyUnits/abcd'.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580032 = newJObject()
  var query_580033 = newJObject()
  var body_580034 = newJObject()
  add(query_580033, "key", newJString(key))
  add(query_580033, "prettyPrint", newJBool(prettyPrint))
  add(query_580033, "oauth_token", newJString(oauthToken))
  add(query_580033, "$.xgafv", newJString(Xgafv))
  add(query_580033, "alt", newJString(alt))
  add(query_580033, "uploadType", newJString(uploadType))
  add(query_580033, "quotaUser", newJString(quotaUser))
  add(path_580032, "name", newJString(name))
  if body != nil:
    body_580034 = body
  add(query_580033, "callback", newJString(callback))
  add(query_580033, "fields", newJString(fields))
  add(query_580033, "access_token", newJString(accessToken))
  add(query_580033, "upload_protocol", newJString(uploadProtocol))
  result = call_580031.call(path_580032, query_580033, nil, nil, body_580034)

var serviceconsumermanagementServicesTenancyUnitsDeleteProject* = Call_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_580014(
    name: "serviceconsumermanagementServicesTenancyUnitsDeleteProject",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{name}:deleteProject", validator: validate_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_580015,
    base: "/",
    url: url_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_580016,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_580035 = ref object of OpenApiRestCall_579373
proc url_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_580037(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":removeProject")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_580036(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Removes the specified project resource identified by a tenant resource tag.
  ## The method removes the project lien with 'TenantManager' origin if that
  ## was added. It then attempts to delete the project. If that operation
  ## fails, this method also fails.
  ## Calls to remove already removed or non-existent tenant project succeed.
  ## After the project has been deleted, or if was already in a DELETED state,
  ## resource metadata is permanently removed from the tenancy unit.
  ## Operation<response: Empty>.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the tenancy unit.
  ## Such as 'services/service.googleapis.com/projects/12345/tenancyUnits/abcd'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580038 = path.getOrDefault("name")
  valid_580038 = validateParameter(valid_580038, JString, required = true,
                                 default = nil)
  if valid_580038 != nil:
    section.add "name", valid_580038
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
  var valid_580039 = query.getOrDefault("key")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "key", valid_580039
  var valid_580040 = query.getOrDefault("prettyPrint")
  valid_580040 = validateParameter(valid_580040, JBool, required = false,
                                 default = newJBool(true))
  if valid_580040 != nil:
    section.add "prettyPrint", valid_580040
  var valid_580041 = query.getOrDefault("oauth_token")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "oauth_token", valid_580041
  var valid_580042 = query.getOrDefault("$.xgafv")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = newJString("1"))
  if valid_580042 != nil:
    section.add "$.xgafv", valid_580042
  var valid_580043 = query.getOrDefault("alt")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = newJString("json"))
  if valid_580043 != nil:
    section.add "alt", valid_580043
  var valid_580044 = query.getOrDefault("uploadType")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "uploadType", valid_580044
  var valid_580045 = query.getOrDefault("quotaUser")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "quotaUser", valid_580045
  var valid_580046 = query.getOrDefault("callback")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "callback", valid_580046
  var valid_580047 = query.getOrDefault("fields")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "fields", valid_580047
  var valid_580048 = query.getOrDefault("access_token")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "access_token", valid_580048
  var valid_580049 = query.getOrDefault("upload_protocol")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "upload_protocol", valid_580049
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

proc call*(call_580051: Call_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_580035;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes the specified project resource identified by a tenant resource tag.
  ## The method removes the project lien with 'TenantManager' origin if that
  ## was added. It then attempts to delete the project. If that operation
  ## fails, this method also fails.
  ## Calls to remove already removed or non-existent tenant project succeed.
  ## After the project has been deleted, or if was already in a DELETED state,
  ## resource metadata is permanently removed from the tenancy unit.
  ## Operation<response: Empty>.
  ## 
  let valid = call_580051.validator(path, query, header, formData, body)
  let scheme = call_580051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580051.url(scheme.get, call_580051.host, call_580051.base,
                         call_580051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580051, url, valid)

proc call*(call_580052: Call_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_580035;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## serviceconsumermanagementServicesTenancyUnitsRemoveProject
  ## Removes the specified project resource identified by a tenant resource tag.
  ## The method removes the project lien with 'TenantManager' origin if that
  ## was added. It then attempts to delete the project. If that operation
  ## fails, this method also fails.
  ## Calls to remove already removed or non-existent tenant project succeed.
  ## After the project has been deleted, or if was already in a DELETED state,
  ## resource metadata is permanently removed from the tenancy unit.
  ## Operation<response: Empty>.
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
  ##       : Name of the tenancy unit.
  ## Such as 'services/service.googleapis.com/projects/12345/tenancyUnits/abcd'.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580053 = newJObject()
  var query_580054 = newJObject()
  var body_580055 = newJObject()
  add(query_580054, "key", newJString(key))
  add(query_580054, "prettyPrint", newJBool(prettyPrint))
  add(query_580054, "oauth_token", newJString(oauthToken))
  add(query_580054, "$.xgafv", newJString(Xgafv))
  add(query_580054, "alt", newJString(alt))
  add(query_580054, "uploadType", newJString(uploadType))
  add(query_580054, "quotaUser", newJString(quotaUser))
  add(path_580053, "name", newJString(name))
  if body != nil:
    body_580055 = body
  add(query_580054, "callback", newJString(callback))
  add(query_580054, "fields", newJString(fields))
  add(query_580054, "access_token", newJString(accessToken))
  add(query_580054, "upload_protocol", newJString(uploadProtocol))
  result = call_580052.call(path_580053, query_580054, nil, nil, body_580055)

var serviceconsumermanagementServicesTenancyUnitsRemoveProject* = Call_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_580035(
    name: "serviceconsumermanagementServicesTenancyUnitsRemoveProject",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{name}:removeProject", validator: validate_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_580036,
    base: "/",
    url: url_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_580037,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_580056 = ref object of OpenApiRestCall_579373
proc url_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_580058(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":undeleteProject")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_580057(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Attempts to undelete a previously deleted tenant project. The project must
  ## be in a DELETED state.
  ## There are no guarantees that an undeleted project will be in
  ## a fully restored and functional state. Call the `ApplyTenantProjectConfig`
  ## method to update its configuration and then validate all managed service
  ## resources.
  ## Operation<response: Empty>.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the tenancy unit.
  ## Such as 'services/service.googleapis.com/projects/12345/tenancyUnits/abcd'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580059 = path.getOrDefault("name")
  valid_580059 = validateParameter(valid_580059, JString, required = true,
                                 default = nil)
  if valid_580059 != nil:
    section.add "name", valid_580059
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
  var valid_580060 = query.getOrDefault("key")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "key", valid_580060
  var valid_580061 = query.getOrDefault("prettyPrint")
  valid_580061 = validateParameter(valid_580061, JBool, required = false,
                                 default = newJBool(true))
  if valid_580061 != nil:
    section.add "prettyPrint", valid_580061
  var valid_580062 = query.getOrDefault("oauth_token")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "oauth_token", valid_580062
  var valid_580063 = query.getOrDefault("$.xgafv")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = newJString("1"))
  if valid_580063 != nil:
    section.add "$.xgafv", valid_580063
  var valid_580064 = query.getOrDefault("alt")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = newJString("json"))
  if valid_580064 != nil:
    section.add "alt", valid_580064
  var valid_580065 = query.getOrDefault("uploadType")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "uploadType", valid_580065
  var valid_580066 = query.getOrDefault("quotaUser")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "quotaUser", valid_580066
  var valid_580067 = query.getOrDefault("callback")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "callback", valid_580067
  var valid_580068 = query.getOrDefault("fields")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "fields", valid_580068
  var valid_580069 = query.getOrDefault("access_token")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "access_token", valid_580069
  var valid_580070 = query.getOrDefault("upload_protocol")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "upload_protocol", valid_580070
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

proc call*(call_580072: Call_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_580056;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Attempts to undelete a previously deleted tenant project. The project must
  ## be in a DELETED state.
  ## There are no guarantees that an undeleted project will be in
  ## a fully restored and functional state. Call the `ApplyTenantProjectConfig`
  ## method to update its configuration and then validate all managed service
  ## resources.
  ## Operation<response: Empty>.
  ## 
  let valid = call_580072.validator(path, query, header, formData, body)
  let scheme = call_580072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580072.url(scheme.get, call_580072.host, call_580072.base,
                         call_580072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580072, url, valid)

proc call*(call_580073: Call_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_580056;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## serviceconsumermanagementServicesTenancyUnitsUndeleteProject
  ## Attempts to undelete a previously deleted tenant project. The project must
  ## be in a DELETED state.
  ## There are no guarantees that an undeleted project will be in
  ## a fully restored and functional state. Call the `ApplyTenantProjectConfig`
  ## method to update its configuration and then validate all managed service
  ## resources.
  ## Operation<response: Empty>.
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
  ##       : Name of the tenancy unit.
  ## Such as 'services/service.googleapis.com/projects/12345/tenancyUnits/abcd'.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580074 = newJObject()
  var query_580075 = newJObject()
  var body_580076 = newJObject()
  add(query_580075, "key", newJString(key))
  add(query_580075, "prettyPrint", newJBool(prettyPrint))
  add(query_580075, "oauth_token", newJString(oauthToken))
  add(query_580075, "$.xgafv", newJString(Xgafv))
  add(query_580075, "alt", newJString(alt))
  add(query_580075, "uploadType", newJString(uploadType))
  add(query_580075, "quotaUser", newJString(quotaUser))
  add(path_580074, "name", newJString(name))
  if body != nil:
    body_580076 = body
  add(query_580075, "callback", newJString(callback))
  add(query_580075, "fields", newJString(fields))
  add(query_580075, "access_token", newJString(accessToken))
  add(query_580075, "upload_protocol", newJString(uploadProtocol))
  result = call_580073.call(path_580074, query_580075, nil, nil, body_580076)

var serviceconsumermanagementServicesTenancyUnitsUndeleteProject* = Call_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_580056(
    name: "serviceconsumermanagementServicesTenancyUnitsUndeleteProject",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{name}:undeleteProject", validator: validate_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_580057,
    base: "/",
    url: url_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_580058,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsCreate_580099 = ref object of OpenApiRestCall_579373
proc url_ServiceconsumermanagementServicesTenancyUnitsCreate_580101(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/tenancyUnits")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ServiceconsumermanagementServicesTenancyUnitsCreate_580100(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a tenancy unit with no tenant resources.
  ## If tenancy unit already exists, it will be returned,
  ## however, in this case, returned TenancyUnit does not have tenant_resources
  ## field set and ListTenancyUnit has to be used to get a complete
  ## TenancyUnit with all fields populated.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : services/{service}/{collection id}/{resource id}
  ## {collection id} is the cloud resource collection type representing the
  ## service consumer, for example 'projects', or 'organizations'.
  ## {resource id} is the consumer numeric id, such as project number: '123456'.
  ## {service} the name of a managed service, such as 'service.googleapis.com'.
  ## Enables service binding using the new tenancy unit.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580102 = path.getOrDefault("parent")
  valid_580102 = validateParameter(valid_580102, JString, required = true,
                                 default = nil)
  if valid_580102 != nil:
    section.add "parent", valid_580102
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
  var valid_580103 = query.getOrDefault("key")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "key", valid_580103
  var valid_580104 = query.getOrDefault("prettyPrint")
  valid_580104 = validateParameter(valid_580104, JBool, required = false,
                                 default = newJBool(true))
  if valid_580104 != nil:
    section.add "prettyPrint", valid_580104
  var valid_580105 = query.getOrDefault("oauth_token")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "oauth_token", valid_580105
  var valid_580106 = query.getOrDefault("$.xgafv")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = newJString("1"))
  if valid_580106 != nil:
    section.add "$.xgafv", valid_580106
  var valid_580107 = query.getOrDefault("alt")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = newJString("json"))
  if valid_580107 != nil:
    section.add "alt", valid_580107
  var valid_580108 = query.getOrDefault("uploadType")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "uploadType", valid_580108
  var valid_580109 = query.getOrDefault("quotaUser")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "quotaUser", valid_580109
  var valid_580110 = query.getOrDefault("callback")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "callback", valid_580110
  var valid_580111 = query.getOrDefault("fields")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "fields", valid_580111
  var valid_580112 = query.getOrDefault("access_token")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "access_token", valid_580112
  var valid_580113 = query.getOrDefault("upload_protocol")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "upload_protocol", valid_580113
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

proc call*(call_580115: Call_ServiceconsumermanagementServicesTenancyUnitsCreate_580099;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a tenancy unit with no tenant resources.
  ## If tenancy unit already exists, it will be returned,
  ## however, in this case, returned TenancyUnit does not have tenant_resources
  ## field set and ListTenancyUnit has to be used to get a complete
  ## TenancyUnit with all fields populated.
  ## 
  let valid = call_580115.validator(path, query, header, formData, body)
  let scheme = call_580115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580115.url(scheme.get, call_580115.host, call_580115.base,
                         call_580115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580115, url, valid)

proc call*(call_580116: Call_ServiceconsumermanagementServicesTenancyUnitsCreate_580099;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## serviceconsumermanagementServicesTenancyUnitsCreate
  ## Creates a tenancy unit with no tenant resources.
  ## If tenancy unit already exists, it will be returned,
  ## however, in this case, returned TenancyUnit does not have tenant_resources
  ## field set and ListTenancyUnit has to be used to get a complete
  ## TenancyUnit with all fields populated.
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
  ##         : services/{service}/{collection id}/{resource id}
  ## {collection id} is the cloud resource collection type representing the
  ## service consumer, for example 'projects', or 'organizations'.
  ## {resource id} is the consumer numeric id, such as project number: '123456'.
  ## {service} the name of a managed service, such as 'service.googleapis.com'.
  ## Enables service binding using the new tenancy unit.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580117 = newJObject()
  var query_580118 = newJObject()
  var body_580119 = newJObject()
  add(query_580118, "key", newJString(key))
  add(query_580118, "prettyPrint", newJBool(prettyPrint))
  add(query_580118, "oauth_token", newJString(oauthToken))
  add(query_580118, "$.xgafv", newJString(Xgafv))
  add(query_580118, "alt", newJString(alt))
  add(query_580118, "uploadType", newJString(uploadType))
  add(query_580118, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580119 = body
  add(query_580118, "callback", newJString(callback))
  add(path_580117, "parent", newJString(parent))
  add(query_580118, "fields", newJString(fields))
  add(query_580118, "access_token", newJString(accessToken))
  add(query_580118, "upload_protocol", newJString(uploadProtocol))
  result = call_580116.call(path_580117, query_580118, nil, nil, body_580119)

var serviceconsumermanagementServicesTenancyUnitsCreate* = Call_ServiceconsumermanagementServicesTenancyUnitsCreate_580099(
    name: "serviceconsumermanagementServicesTenancyUnitsCreate",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{parent}/tenancyUnits",
    validator: validate_ServiceconsumermanagementServicesTenancyUnitsCreate_580100,
    base: "/", url: url_ServiceconsumermanagementServicesTenancyUnitsCreate_580101,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsList_580077 = ref object of OpenApiRestCall_579373
proc url_ServiceconsumermanagementServicesTenancyUnitsList_580079(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/tenancyUnits")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ServiceconsumermanagementServicesTenancyUnitsList_580078(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Find the tenancy unit for a managed service and service consumer.
  ## This method shouldn't be used in a service producer's runtime path, for
  ## example to find the tenant project number when creating VMs. Service
  ## producers must persist the tenant project's information after the project
  ## is created.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Managed service and service consumer. Required.
  ## services/{service}/{collection id}/{resource id}
  ## {collection id} is the cloud resource collection type representing the
  ## service consumer, for example 'projects', or 'organizations'.
  ## {resource id} is the consumer numeric id, such as project number: '123456'.
  ## {service} the name of a service, such as 'service.googleapis.com'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580080 = path.getOrDefault("parent")
  valid_580080 = validateParameter(valid_580080, JString, required = true,
                                 default = nil)
  if valid_580080 != nil:
    section.add "parent", valid_580080
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
  ##           : The maximum number of results returned by this request.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : Filter expression over tenancy resources field. Optional.
  ##   pageToken: JString
  ##            : The continuation token, which is used to page through large result sets.
  ## To get the next page of results, set this parameter to the value of
  ## `nextPageToken` from the previous response.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580081 = query.getOrDefault("key")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "key", valid_580081
  var valid_580082 = query.getOrDefault("prettyPrint")
  valid_580082 = validateParameter(valid_580082, JBool, required = false,
                                 default = newJBool(true))
  if valid_580082 != nil:
    section.add "prettyPrint", valid_580082
  var valid_580083 = query.getOrDefault("oauth_token")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "oauth_token", valid_580083
  var valid_580084 = query.getOrDefault("$.xgafv")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = newJString("1"))
  if valid_580084 != nil:
    section.add "$.xgafv", valid_580084
  var valid_580085 = query.getOrDefault("pageSize")
  valid_580085 = validateParameter(valid_580085, JInt, required = false, default = nil)
  if valid_580085 != nil:
    section.add "pageSize", valid_580085
  var valid_580086 = query.getOrDefault("alt")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = newJString("json"))
  if valid_580086 != nil:
    section.add "alt", valid_580086
  var valid_580087 = query.getOrDefault("uploadType")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "uploadType", valid_580087
  var valid_580088 = query.getOrDefault("quotaUser")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "quotaUser", valid_580088
  var valid_580089 = query.getOrDefault("filter")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "filter", valid_580089
  var valid_580090 = query.getOrDefault("pageToken")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "pageToken", valid_580090
  var valid_580091 = query.getOrDefault("callback")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "callback", valid_580091
  var valid_580092 = query.getOrDefault("fields")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "fields", valid_580092
  var valid_580093 = query.getOrDefault("access_token")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "access_token", valid_580093
  var valid_580094 = query.getOrDefault("upload_protocol")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "upload_protocol", valid_580094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580095: Call_ServiceconsumermanagementServicesTenancyUnitsList_580077;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Find the tenancy unit for a managed service and service consumer.
  ## This method shouldn't be used in a service producer's runtime path, for
  ## example to find the tenant project number when creating VMs. Service
  ## producers must persist the tenant project's information after the project
  ## is created.
  ## 
  let valid = call_580095.validator(path, query, header, formData, body)
  let scheme = call_580095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580095.url(scheme.get, call_580095.host, call_580095.base,
                         call_580095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580095, url, valid)

proc call*(call_580096: Call_ServiceconsumermanagementServicesTenancyUnitsList_580077;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## serviceconsumermanagementServicesTenancyUnitsList
  ## Find the tenancy unit for a managed service and service consumer.
  ## This method shouldn't be used in a service producer's runtime path, for
  ## example to find the tenant project number when creating VMs. Service
  ## producers must persist the tenant project's information after the project
  ## is created.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of results returned by this request.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : Filter expression over tenancy resources field. Optional.
  ##   pageToken: string
  ##            : The continuation token, which is used to page through large result sets.
  ## To get the next page of results, set this parameter to the value of
  ## `nextPageToken` from the previous response.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Managed service and service consumer. Required.
  ## services/{service}/{collection id}/{resource id}
  ## {collection id} is the cloud resource collection type representing the
  ## service consumer, for example 'projects', or 'organizations'.
  ## {resource id} is the consumer numeric id, such as project number: '123456'.
  ## {service} the name of a service, such as 'service.googleapis.com'.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580097 = newJObject()
  var query_580098 = newJObject()
  add(query_580098, "key", newJString(key))
  add(query_580098, "prettyPrint", newJBool(prettyPrint))
  add(query_580098, "oauth_token", newJString(oauthToken))
  add(query_580098, "$.xgafv", newJString(Xgafv))
  add(query_580098, "pageSize", newJInt(pageSize))
  add(query_580098, "alt", newJString(alt))
  add(query_580098, "uploadType", newJString(uploadType))
  add(query_580098, "quotaUser", newJString(quotaUser))
  add(query_580098, "filter", newJString(filter))
  add(query_580098, "pageToken", newJString(pageToken))
  add(query_580098, "callback", newJString(callback))
  add(path_580097, "parent", newJString(parent))
  add(query_580098, "fields", newJString(fields))
  add(query_580098, "access_token", newJString(accessToken))
  add(query_580098, "upload_protocol", newJString(uploadProtocol))
  result = call_580096.call(path_580097, query_580098, nil, nil, nil)

var serviceconsumermanagementServicesTenancyUnitsList* = Call_ServiceconsumermanagementServicesTenancyUnitsList_580077(
    name: "serviceconsumermanagementServicesTenancyUnitsList",
    meth: HttpMethod.HttpGet, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{parent}/tenancyUnits",
    validator: validate_ServiceconsumermanagementServicesTenancyUnitsList_580078,
    base: "/", url: url_ServiceconsumermanagementServicesTenancyUnitsList_580079,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsAddProject_580120 = ref object of OpenApiRestCall_579373
proc url_ServiceconsumermanagementServicesTenancyUnitsAddProject_580122(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: ":addProject")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ServiceconsumermanagementServicesTenancyUnitsAddProject_580121(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Add a new tenant project to the tenancy unit.
  ## There can be a maximum of 512 tenant projects in a tenancy unit.
  ## If there are previously failed `AddTenantProject` calls, you might need to
  ## call `RemoveTenantProject` first to resolve them before you can make
  ## another call to `AddTenantProject` with the same tag.
  ## Operation<response: Empty>.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the tenancy unit.
  ## Such as 'services/service.googleapis.com/projects/12345/tenancyUnits/abcd'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580123 = path.getOrDefault("parent")
  valid_580123 = validateParameter(valid_580123, JString, required = true,
                                 default = nil)
  if valid_580123 != nil:
    section.add "parent", valid_580123
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
  var valid_580124 = query.getOrDefault("key")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "key", valid_580124
  var valid_580125 = query.getOrDefault("prettyPrint")
  valid_580125 = validateParameter(valid_580125, JBool, required = false,
                                 default = newJBool(true))
  if valid_580125 != nil:
    section.add "prettyPrint", valid_580125
  var valid_580126 = query.getOrDefault("oauth_token")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "oauth_token", valid_580126
  var valid_580127 = query.getOrDefault("$.xgafv")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = newJString("1"))
  if valid_580127 != nil:
    section.add "$.xgafv", valid_580127
  var valid_580128 = query.getOrDefault("alt")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = newJString("json"))
  if valid_580128 != nil:
    section.add "alt", valid_580128
  var valid_580129 = query.getOrDefault("uploadType")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "uploadType", valid_580129
  var valid_580130 = query.getOrDefault("quotaUser")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "quotaUser", valid_580130
  var valid_580131 = query.getOrDefault("callback")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "callback", valid_580131
  var valid_580132 = query.getOrDefault("fields")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "fields", valid_580132
  var valid_580133 = query.getOrDefault("access_token")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "access_token", valid_580133
  var valid_580134 = query.getOrDefault("upload_protocol")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "upload_protocol", valid_580134
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

proc call*(call_580136: Call_ServiceconsumermanagementServicesTenancyUnitsAddProject_580120;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add a new tenant project to the tenancy unit.
  ## There can be a maximum of 512 tenant projects in a tenancy unit.
  ## If there are previously failed `AddTenantProject` calls, you might need to
  ## call `RemoveTenantProject` first to resolve them before you can make
  ## another call to `AddTenantProject` with the same tag.
  ## Operation<response: Empty>.
  ## 
  let valid = call_580136.validator(path, query, header, formData, body)
  let scheme = call_580136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580136.url(scheme.get, call_580136.host, call_580136.base,
                         call_580136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580136, url, valid)

proc call*(call_580137: Call_ServiceconsumermanagementServicesTenancyUnitsAddProject_580120;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## serviceconsumermanagementServicesTenancyUnitsAddProject
  ## Add a new tenant project to the tenancy unit.
  ## There can be a maximum of 512 tenant projects in a tenancy unit.
  ## If there are previously failed `AddTenantProject` calls, you might need to
  ## call `RemoveTenantProject` first to resolve them before you can make
  ## another call to `AddTenantProject` with the same tag.
  ## Operation<response: Empty>.
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
  ##         : Name of the tenancy unit.
  ## Such as 'services/service.googleapis.com/projects/12345/tenancyUnits/abcd'.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580138 = newJObject()
  var query_580139 = newJObject()
  var body_580140 = newJObject()
  add(query_580139, "key", newJString(key))
  add(query_580139, "prettyPrint", newJBool(prettyPrint))
  add(query_580139, "oauth_token", newJString(oauthToken))
  add(query_580139, "$.xgafv", newJString(Xgafv))
  add(query_580139, "alt", newJString(alt))
  add(query_580139, "uploadType", newJString(uploadType))
  add(query_580139, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580140 = body
  add(query_580139, "callback", newJString(callback))
  add(path_580138, "parent", newJString(parent))
  add(query_580139, "fields", newJString(fields))
  add(query_580139, "access_token", newJString(accessToken))
  add(query_580139, "upload_protocol", newJString(uploadProtocol))
  result = call_580137.call(path_580138, query_580139, nil, nil, body_580140)

var serviceconsumermanagementServicesTenancyUnitsAddProject* = Call_ServiceconsumermanagementServicesTenancyUnitsAddProject_580120(
    name: "serviceconsumermanagementServicesTenancyUnitsAddProject",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{parent}:addProject", validator: validate_ServiceconsumermanagementServicesTenancyUnitsAddProject_580121,
    base: "/", url: url_ServiceconsumermanagementServicesTenancyUnitsAddProject_580122,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesSearch_580141 = ref object of OpenApiRestCall_579373
proc url_ServiceconsumermanagementServicesSearch_580143(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: ":search")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_ServiceconsumermanagementServicesSearch_580142(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Search tenancy units for a managed service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Service for which search is performed.
  ## services/{service}
  ## {service} the name of a service, for example 'service.googleapis.com'.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580144 = path.getOrDefault("parent")
  valid_580144 = validateParameter(valid_580144, JString, required = true,
                                 default = nil)
  if valid_580144 != nil:
    section.add "parent", valid_580144
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
  ##           : The maximum number of results returned by this request. Currently, the
  ## default maximum is set to 1000. If `page_size` isn't provided or the size
  ## provided is a number larger than 1000, it's automatically set to 1000.
  ## 
  ## Optional.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The continuation token, which is used to page through large result sets.
  ## To get the next page of results, set this parameter to the value of
  ## `nextPageToken` from the previous response.
  ## 
  ## Optional.
  ##   query: JString
  ##        : Set a query `{expression}` for querying tenancy units. Your `{expression}`
  ## must be in the format: `field_name=literal_string`. The `field_name` is the
  ## name of the field you want to compare. Supported fields are
  ## `tenant_resources.tag` and `tenant_resources.resource`.
  ## 
  ## For example, to search tenancy units that contain at least one tenant
  ## resource with a given tag 'xyz', use the query `tenant_resources.tag=xyz`.
  ## To search tenancy units that contain at least one tenant resource with
  ## a given resource name 'projects/123456', use the query
  ## `tenant_resources.resource=projects/123456`.
  ## 
  ## Multiple expressions can be joined with `AND`s. Tenancy units must match
  ## all expressions to be included in the result set. For example,
  ## `tenant_resources.tag=xyz AND tenant_resources.resource=projects/123456`
  ## 
  ## Optional.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580145 = query.getOrDefault("key")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "key", valid_580145
  var valid_580146 = query.getOrDefault("prettyPrint")
  valid_580146 = validateParameter(valid_580146, JBool, required = false,
                                 default = newJBool(true))
  if valid_580146 != nil:
    section.add "prettyPrint", valid_580146
  var valid_580147 = query.getOrDefault("oauth_token")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "oauth_token", valid_580147
  var valid_580148 = query.getOrDefault("$.xgafv")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = newJString("1"))
  if valid_580148 != nil:
    section.add "$.xgafv", valid_580148
  var valid_580149 = query.getOrDefault("pageSize")
  valid_580149 = validateParameter(valid_580149, JInt, required = false, default = nil)
  if valid_580149 != nil:
    section.add "pageSize", valid_580149
  var valid_580150 = query.getOrDefault("alt")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = newJString("json"))
  if valid_580150 != nil:
    section.add "alt", valid_580150
  var valid_580151 = query.getOrDefault("uploadType")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "uploadType", valid_580151
  var valid_580152 = query.getOrDefault("quotaUser")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "quotaUser", valid_580152
  var valid_580153 = query.getOrDefault("pageToken")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "pageToken", valid_580153
  var valid_580154 = query.getOrDefault("query")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "query", valid_580154
  var valid_580155 = query.getOrDefault("callback")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "callback", valid_580155
  var valid_580156 = query.getOrDefault("fields")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "fields", valid_580156
  var valid_580157 = query.getOrDefault("access_token")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "access_token", valid_580157
  var valid_580158 = query.getOrDefault("upload_protocol")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "upload_protocol", valid_580158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580159: Call_ServiceconsumermanagementServicesSearch_580141;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Search tenancy units for a managed service.
  ## 
  let valid = call_580159.validator(path, query, header, formData, body)
  let scheme = call_580159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580159.url(scheme.get, call_580159.host, call_580159.base,
                         call_580159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580159, url, valid)

proc call*(call_580160: Call_ServiceconsumermanagementServicesSearch_580141;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; query: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## serviceconsumermanagementServicesSearch
  ## Search tenancy units for a managed service.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of results returned by this request. Currently, the
  ## default maximum is set to 1000. If `page_size` isn't provided or the size
  ## provided is a number larger than 1000, it's automatically set to 1000.
  ## 
  ## Optional.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The continuation token, which is used to page through large result sets.
  ## To get the next page of results, set this parameter to the value of
  ## `nextPageToken` from the previous response.
  ## 
  ## Optional.
  ##   query: string
  ##        : Set a query `{expression}` for querying tenancy units. Your `{expression}`
  ## must be in the format: `field_name=literal_string`. The `field_name` is the
  ## name of the field you want to compare. Supported fields are
  ## `tenant_resources.tag` and `tenant_resources.resource`.
  ## 
  ## For example, to search tenancy units that contain at least one tenant
  ## resource with a given tag 'xyz', use the query `tenant_resources.tag=xyz`.
  ## To search tenancy units that contain at least one tenant resource with
  ## a given resource name 'projects/123456', use the query
  ## `tenant_resources.resource=projects/123456`.
  ## 
  ## Multiple expressions can be joined with `AND`s. Tenancy units must match
  ## all expressions to be included in the result set. For example,
  ## `tenant_resources.tag=xyz AND tenant_resources.resource=projects/123456`
  ## 
  ## Optional.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Service for which search is performed.
  ## services/{service}
  ## {service} the name of a service, for example 'service.googleapis.com'.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580161 = newJObject()
  var query_580162 = newJObject()
  add(query_580162, "key", newJString(key))
  add(query_580162, "prettyPrint", newJBool(prettyPrint))
  add(query_580162, "oauth_token", newJString(oauthToken))
  add(query_580162, "$.xgafv", newJString(Xgafv))
  add(query_580162, "pageSize", newJInt(pageSize))
  add(query_580162, "alt", newJString(alt))
  add(query_580162, "uploadType", newJString(uploadType))
  add(query_580162, "quotaUser", newJString(quotaUser))
  add(query_580162, "pageToken", newJString(pageToken))
  add(query_580162, "query", newJString(query))
  add(query_580162, "callback", newJString(callback))
  add(path_580161, "parent", newJString(parent))
  add(query_580162, "fields", newJString(fields))
  add(query_580162, "access_token", newJString(accessToken))
  add(query_580162, "upload_protocol", newJString(uploadProtocol))
  result = call_580160.call(path_580161, query_580162, nil, nil, nil)

var serviceconsumermanagementServicesSearch* = Call_ServiceconsumermanagementServicesSearch_580141(
    name: "serviceconsumermanagementServicesSearch", meth: HttpMethod.HttpGet,
    host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{parent}:search",
    validator: validate_ServiceconsumermanagementServicesSearch_580142, base: "/",
    url: url_ServiceconsumermanagementServicesSearch_580143,
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
