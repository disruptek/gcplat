
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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

  OpenApiRestCall_588450 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588450](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588450): Option[Scheme] {.used.} =
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
  gcpServiceName = "serviceconsumermanagement"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServiceconsumermanagementOperationsGet_588719 = ref object of OpenApiRestCall_588450
proc url_ServiceconsumermanagementOperationsGet_588721(protocol: Scheme;
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

proc validate_ServiceconsumermanagementOperationsGet_588720(path: JsonNode;
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
  var valid_588847 = path.getOrDefault("name")
  valid_588847 = validateParameter(valid_588847, JString, required = true,
                                 default = nil)
  if valid_588847 != nil:
    section.add "name", valid_588847
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
  var valid_588848 = query.getOrDefault("upload_protocol")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = nil)
  if valid_588848 != nil:
    section.add "upload_protocol", valid_588848
  var valid_588849 = query.getOrDefault("fields")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = nil)
  if valid_588849 != nil:
    section.add "fields", valid_588849
  var valid_588850 = query.getOrDefault("quotaUser")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "quotaUser", valid_588850
  var valid_588864 = query.getOrDefault("alt")
  valid_588864 = validateParameter(valid_588864, JString, required = false,
                                 default = newJString("json"))
  if valid_588864 != nil:
    section.add "alt", valid_588864
  var valid_588865 = query.getOrDefault("oauth_token")
  valid_588865 = validateParameter(valid_588865, JString, required = false,
                                 default = nil)
  if valid_588865 != nil:
    section.add "oauth_token", valid_588865
  var valid_588866 = query.getOrDefault("callback")
  valid_588866 = validateParameter(valid_588866, JString, required = false,
                                 default = nil)
  if valid_588866 != nil:
    section.add "callback", valid_588866
  var valid_588867 = query.getOrDefault("access_token")
  valid_588867 = validateParameter(valid_588867, JString, required = false,
                                 default = nil)
  if valid_588867 != nil:
    section.add "access_token", valid_588867
  var valid_588868 = query.getOrDefault("uploadType")
  valid_588868 = validateParameter(valid_588868, JString, required = false,
                                 default = nil)
  if valid_588868 != nil:
    section.add "uploadType", valid_588868
  var valid_588869 = query.getOrDefault("key")
  valid_588869 = validateParameter(valid_588869, JString, required = false,
                                 default = nil)
  if valid_588869 != nil:
    section.add "key", valid_588869
  var valid_588870 = query.getOrDefault("$.xgafv")
  valid_588870 = validateParameter(valid_588870, JString, required = false,
                                 default = newJString("1"))
  if valid_588870 != nil:
    section.add "$.xgafv", valid_588870
  var valid_588871 = query.getOrDefault("prettyPrint")
  valid_588871 = validateParameter(valid_588871, JBool, required = false,
                                 default = newJBool(true))
  if valid_588871 != nil:
    section.add "prettyPrint", valid_588871
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588894: Call_ServiceconsumermanagementOperationsGet_588719;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_588894.validator(path, query, header, formData, body)
  let scheme = call_588894.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588894.url(scheme.get, call_588894.host, call_588894.base,
                         call_588894.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588894, url, valid)

proc call*(call_588965: Call_ServiceconsumermanagementOperationsGet_588719;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## serviceconsumermanagementOperationsGet
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
  var path_588966 = newJObject()
  var query_588968 = newJObject()
  add(query_588968, "upload_protocol", newJString(uploadProtocol))
  add(query_588968, "fields", newJString(fields))
  add(query_588968, "quotaUser", newJString(quotaUser))
  add(path_588966, "name", newJString(name))
  add(query_588968, "alt", newJString(alt))
  add(query_588968, "oauth_token", newJString(oauthToken))
  add(query_588968, "callback", newJString(callback))
  add(query_588968, "access_token", newJString(accessToken))
  add(query_588968, "uploadType", newJString(uploadType))
  add(query_588968, "key", newJString(key))
  add(query_588968, "$.xgafv", newJString(Xgafv))
  add(query_588968, "prettyPrint", newJBool(prettyPrint))
  result = call_588965.call(path_588966, query_588968, nil, nil, nil)

var serviceconsumermanagementOperationsGet* = Call_ServiceconsumermanagementOperationsGet_588719(
    name: "serviceconsumermanagementOperationsGet", meth: HttpMethod.HttpGet,
    host: "serviceconsumermanagement.googleapis.com", route: "/v1/{name}",
    validator: validate_ServiceconsumermanagementOperationsGet_588720, base: "/",
    url: url_ServiceconsumermanagementOperationsGet_588721,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsDelete_589007 = ref object of OpenApiRestCall_588450
proc url_ServiceconsumermanagementServicesTenancyUnitsDelete_589009(
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
  result.path = base & hydrated.get

proc validate_ServiceconsumermanagementServicesTenancyUnitsDelete_589008(
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
  var valid_589010 = path.getOrDefault("name")
  valid_589010 = validateParameter(valid_589010, JString, required = true,
                                 default = nil)
  if valid_589010 != nil:
    section.add "name", valid_589010
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
  var valid_589011 = query.getOrDefault("upload_protocol")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "upload_protocol", valid_589011
  var valid_589012 = query.getOrDefault("fields")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "fields", valid_589012
  var valid_589013 = query.getOrDefault("quotaUser")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "quotaUser", valid_589013
  var valid_589014 = query.getOrDefault("alt")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = newJString("json"))
  if valid_589014 != nil:
    section.add "alt", valid_589014
  var valid_589015 = query.getOrDefault("oauth_token")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "oauth_token", valid_589015
  var valid_589016 = query.getOrDefault("callback")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "callback", valid_589016
  var valid_589017 = query.getOrDefault("access_token")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "access_token", valid_589017
  var valid_589018 = query.getOrDefault("uploadType")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "uploadType", valid_589018
  var valid_589019 = query.getOrDefault("key")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "key", valid_589019
  var valid_589020 = query.getOrDefault("$.xgafv")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = newJString("1"))
  if valid_589020 != nil:
    section.add "$.xgafv", valid_589020
  var valid_589021 = query.getOrDefault("prettyPrint")
  valid_589021 = validateParameter(valid_589021, JBool, required = false,
                                 default = newJBool(true))
  if valid_589021 != nil:
    section.add "prettyPrint", valid_589021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589022: Call_ServiceconsumermanagementServicesTenancyUnitsDelete_589007;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a tenancy unit. Before you delete the tenancy unit, there should be
  ## no tenant resources in it that aren't in a DELETED state.
  ## Operation<response: Empty>.
  ## 
  let valid = call_589022.validator(path, query, header, formData, body)
  let scheme = call_589022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589022.url(scheme.get, call_589022.host, call_589022.base,
                         call_589022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589022, url, valid)

proc call*(call_589023: Call_ServiceconsumermanagementServicesTenancyUnitsDelete_589007;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## serviceconsumermanagementServicesTenancyUnitsDelete
  ## Delete a tenancy unit. Before you delete the tenancy unit, there should be
  ## no tenant resources in it that aren't in a DELETED state.
  ## Operation<response: Empty>.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the tenancy unit to be deleted.
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
  var path_589024 = newJObject()
  var query_589025 = newJObject()
  add(query_589025, "upload_protocol", newJString(uploadProtocol))
  add(query_589025, "fields", newJString(fields))
  add(query_589025, "quotaUser", newJString(quotaUser))
  add(path_589024, "name", newJString(name))
  add(query_589025, "alt", newJString(alt))
  add(query_589025, "oauth_token", newJString(oauthToken))
  add(query_589025, "callback", newJString(callback))
  add(query_589025, "access_token", newJString(accessToken))
  add(query_589025, "uploadType", newJString(uploadType))
  add(query_589025, "key", newJString(key))
  add(query_589025, "$.xgafv", newJString(Xgafv))
  add(query_589025, "prettyPrint", newJBool(prettyPrint))
  result = call_589023.call(path_589024, query_589025, nil, nil, nil)

var serviceconsumermanagementServicesTenancyUnitsDelete* = Call_ServiceconsumermanagementServicesTenancyUnitsDelete_589007(
    name: "serviceconsumermanagementServicesTenancyUnitsDelete",
    meth: HttpMethod.HttpDelete, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{name}",
    validator: validate_ServiceconsumermanagementServicesTenancyUnitsDelete_589008,
    base: "/", url: url_ServiceconsumermanagementServicesTenancyUnitsDelete_589009,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_589026 = ref object of OpenApiRestCall_588450
proc url_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_589028(
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
  result.path = base & hydrated.get

proc validate_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_589027(
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
  var valid_589029 = path.getOrDefault("name")
  valid_589029 = validateParameter(valid_589029, JString, required = true,
                                 default = nil)
  if valid_589029 != nil:
    section.add "name", valid_589029
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
  var valid_589030 = query.getOrDefault("upload_protocol")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "upload_protocol", valid_589030
  var valid_589031 = query.getOrDefault("fields")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "fields", valid_589031
  var valid_589032 = query.getOrDefault("quotaUser")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "quotaUser", valid_589032
  var valid_589033 = query.getOrDefault("alt")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = newJString("json"))
  if valid_589033 != nil:
    section.add "alt", valid_589033
  var valid_589034 = query.getOrDefault("oauth_token")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "oauth_token", valid_589034
  var valid_589035 = query.getOrDefault("callback")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "callback", valid_589035
  var valid_589036 = query.getOrDefault("access_token")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "access_token", valid_589036
  var valid_589037 = query.getOrDefault("uploadType")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "uploadType", valid_589037
  var valid_589038 = query.getOrDefault("key")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "key", valid_589038
  var valid_589039 = query.getOrDefault("$.xgafv")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = newJString("1"))
  if valid_589039 != nil:
    section.add "$.xgafv", valid_589039
  var valid_589040 = query.getOrDefault("prettyPrint")
  valid_589040 = validateParameter(valid_589040, JBool, required = false,
                                 default = newJBool(true))
  if valid_589040 != nil:
    section.add "prettyPrint", valid_589040
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

proc call*(call_589042: Call_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_589026;
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
  let valid = call_589042.validator(path, query, header, formData, body)
  let scheme = call_589042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589042.url(scheme.get, call_589042.host, call_589042.base,
                         call_589042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589042, url, valid)

proc call*(call_589043: Call_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_589026;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the tenancy unit.
  ## Such as 'services/service.googleapis.com/projects/12345/tenancyUnits/abcd'.
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
  var path_589044 = newJObject()
  var query_589045 = newJObject()
  var body_589046 = newJObject()
  add(query_589045, "upload_protocol", newJString(uploadProtocol))
  add(query_589045, "fields", newJString(fields))
  add(query_589045, "quotaUser", newJString(quotaUser))
  add(path_589044, "name", newJString(name))
  add(query_589045, "alt", newJString(alt))
  add(query_589045, "oauth_token", newJString(oauthToken))
  add(query_589045, "callback", newJString(callback))
  add(query_589045, "access_token", newJString(accessToken))
  add(query_589045, "uploadType", newJString(uploadType))
  add(query_589045, "key", newJString(key))
  add(query_589045, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589046 = body
  add(query_589045, "prettyPrint", newJBool(prettyPrint))
  result = call_589043.call(path_589044, query_589045, nil, nil, body_589046)

var serviceconsumermanagementServicesTenancyUnitsApplyProjectConfig* = Call_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_589026(
    name: "serviceconsumermanagementServicesTenancyUnitsApplyProjectConfig",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{name}:applyProjectConfig", validator: validate_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_589027,
    base: "/",
    url: url_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_589028,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsAttachProject_589047 = ref object of OpenApiRestCall_588450
proc url_ServiceconsumermanagementServicesTenancyUnitsAttachProject_589049(
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
  result.path = base & hydrated.get

proc validate_ServiceconsumermanagementServicesTenancyUnitsAttachProject_589048(
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
  var valid_589050 = path.getOrDefault("name")
  valid_589050 = validateParameter(valid_589050, JString, required = true,
                                 default = nil)
  if valid_589050 != nil:
    section.add "name", valid_589050
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
  var valid_589051 = query.getOrDefault("upload_protocol")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "upload_protocol", valid_589051
  var valid_589052 = query.getOrDefault("fields")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "fields", valid_589052
  var valid_589053 = query.getOrDefault("quotaUser")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "quotaUser", valid_589053
  var valid_589054 = query.getOrDefault("alt")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = newJString("json"))
  if valid_589054 != nil:
    section.add "alt", valid_589054
  var valid_589055 = query.getOrDefault("oauth_token")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "oauth_token", valid_589055
  var valid_589056 = query.getOrDefault("callback")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "callback", valid_589056
  var valid_589057 = query.getOrDefault("access_token")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "access_token", valid_589057
  var valid_589058 = query.getOrDefault("uploadType")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "uploadType", valid_589058
  var valid_589059 = query.getOrDefault("key")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "key", valid_589059
  var valid_589060 = query.getOrDefault("$.xgafv")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = newJString("1"))
  if valid_589060 != nil:
    section.add "$.xgafv", valid_589060
  var valid_589061 = query.getOrDefault("prettyPrint")
  valid_589061 = validateParameter(valid_589061, JBool, required = false,
                                 default = newJBool(true))
  if valid_589061 != nil:
    section.add "prettyPrint", valid_589061
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

proc call*(call_589063: Call_ServiceconsumermanagementServicesTenancyUnitsAttachProject_589047;
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
  let valid = call_589063.validator(path, query, header, formData, body)
  let scheme = call_589063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589063.url(scheme.get, call_589063.host, call_589063.base,
                         call_589063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589063, url, valid)

proc call*(call_589064: Call_ServiceconsumermanagementServicesTenancyUnitsAttachProject_589047;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the tenancy unit that the project will be attached to.
  ## Such as 'services/service.googleapis.com/projects/12345/tenancyUnits/abcd'.
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
  var path_589065 = newJObject()
  var query_589066 = newJObject()
  var body_589067 = newJObject()
  add(query_589066, "upload_protocol", newJString(uploadProtocol))
  add(query_589066, "fields", newJString(fields))
  add(query_589066, "quotaUser", newJString(quotaUser))
  add(path_589065, "name", newJString(name))
  add(query_589066, "alt", newJString(alt))
  add(query_589066, "oauth_token", newJString(oauthToken))
  add(query_589066, "callback", newJString(callback))
  add(query_589066, "access_token", newJString(accessToken))
  add(query_589066, "uploadType", newJString(uploadType))
  add(query_589066, "key", newJString(key))
  add(query_589066, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589067 = body
  add(query_589066, "prettyPrint", newJBool(prettyPrint))
  result = call_589064.call(path_589065, query_589066, nil, nil, body_589067)

var serviceconsumermanagementServicesTenancyUnitsAttachProject* = Call_ServiceconsumermanagementServicesTenancyUnitsAttachProject_589047(
    name: "serviceconsumermanagementServicesTenancyUnitsAttachProject",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{name}:attachProject", validator: validate_ServiceconsumermanagementServicesTenancyUnitsAttachProject_589048,
    base: "/",
    url: url_ServiceconsumermanagementServicesTenancyUnitsAttachProject_589049,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementOperationsCancel_589068 = ref object of OpenApiRestCall_588450
proc url_ServiceconsumermanagementOperationsCancel_589070(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_ServiceconsumermanagementOperationsCancel_589069(path: JsonNode;
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
  var valid_589071 = path.getOrDefault("name")
  valid_589071 = validateParameter(valid_589071, JString, required = true,
                                 default = nil)
  if valid_589071 != nil:
    section.add "name", valid_589071
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
  var valid_589072 = query.getOrDefault("upload_protocol")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "upload_protocol", valid_589072
  var valid_589073 = query.getOrDefault("fields")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "fields", valid_589073
  var valid_589074 = query.getOrDefault("quotaUser")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "quotaUser", valid_589074
  var valid_589075 = query.getOrDefault("alt")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = newJString("json"))
  if valid_589075 != nil:
    section.add "alt", valid_589075
  var valid_589076 = query.getOrDefault("oauth_token")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "oauth_token", valid_589076
  var valid_589077 = query.getOrDefault("callback")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "callback", valid_589077
  var valid_589078 = query.getOrDefault("access_token")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "access_token", valid_589078
  var valid_589079 = query.getOrDefault("uploadType")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "uploadType", valid_589079
  var valid_589080 = query.getOrDefault("key")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "key", valid_589080
  var valid_589081 = query.getOrDefault("$.xgafv")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = newJString("1"))
  if valid_589081 != nil:
    section.add "$.xgafv", valid_589081
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589084: Call_ServiceconsumermanagementOperationsCancel_589068;
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
  let valid = call_589084.validator(path, query, header, formData, body)
  let scheme = call_589084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589084.url(scheme.get, call_589084.host, call_589084.base,
                         call_589084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589084, url, valid)

proc call*(call_589085: Call_ServiceconsumermanagementOperationsCancel_589068;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  var path_589086 = newJObject()
  var query_589087 = newJObject()
  var body_589088 = newJObject()
  add(query_589087, "upload_protocol", newJString(uploadProtocol))
  add(query_589087, "fields", newJString(fields))
  add(query_589087, "quotaUser", newJString(quotaUser))
  add(path_589086, "name", newJString(name))
  add(query_589087, "alt", newJString(alt))
  add(query_589087, "oauth_token", newJString(oauthToken))
  add(query_589087, "callback", newJString(callback))
  add(query_589087, "access_token", newJString(accessToken))
  add(query_589087, "uploadType", newJString(uploadType))
  add(query_589087, "key", newJString(key))
  add(query_589087, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589088 = body
  add(query_589087, "prettyPrint", newJBool(prettyPrint))
  result = call_589085.call(path_589086, query_589087, nil, nil, body_589088)

var serviceconsumermanagementOperationsCancel* = Call_ServiceconsumermanagementOperationsCancel_589068(
    name: "serviceconsumermanagementOperationsCancel", meth: HttpMethod.HttpPost,
    host: "serviceconsumermanagement.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_ServiceconsumermanagementOperationsCancel_589069,
    base: "/", url: url_ServiceconsumermanagementOperationsCancel_589070,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_589089 = ref object of OpenApiRestCall_588450
proc url_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_589091(
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
  result.path = base & hydrated.get

proc validate_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_589090(
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
  var valid_589092 = path.getOrDefault("name")
  valid_589092 = validateParameter(valid_589092, JString, required = true,
                                 default = nil)
  if valid_589092 != nil:
    section.add "name", valid_589092
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
  var valid_589093 = query.getOrDefault("upload_protocol")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "upload_protocol", valid_589093
  var valid_589094 = query.getOrDefault("fields")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "fields", valid_589094
  var valid_589095 = query.getOrDefault("quotaUser")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "quotaUser", valid_589095
  var valid_589096 = query.getOrDefault("alt")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = newJString("json"))
  if valid_589096 != nil:
    section.add "alt", valid_589096
  var valid_589097 = query.getOrDefault("oauth_token")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "oauth_token", valid_589097
  var valid_589098 = query.getOrDefault("callback")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "callback", valid_589098
  var valid_589099 = query.getOrDefault("access_token")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "access_token", valid_589099
  var valid_589100 = query.getOrDefault("uploadType")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "uploadType", valid_589100
  var valid_589101 = query.getOrDefault("key")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "key", valid_589101
  var valid_589102 = query.getOrDefault("$.xgafv")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = newJString("1"))
  if valid_589102 != nil:
    section.add "$.xgafv", valid_589102
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589105: Call_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_589089;
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
  let valid = call_589105.validator(path, query, header, formData, body)
  let scheme = call_589105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589105.url(scheme.get, call_589105.host, call_589105.base,
                         call_589105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589105, url, valid)

proc call*(call_589106: Call_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_589089;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the tenancy unit.
  ## Such as 'services/service.googleapis.com/projects/12345/tenancyUnits/abcd'.
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
  var path_589107 = newJObject()
  var query_589108 = newJObject()
  var body_589109 = newJObject()
  add(query_589108, "upload_protocol", newJString(uploadProtocol))
  add(query_589108, "fields", newJString(fields))
  add(query_589108, "quotaUser", newJString(quotaUser))
  add(path_589107, "name", newJString(name))
  add(query_589108, "alt", newJString(alt))
  add(query_589108, "oauth_token", newJString(oauthToken))
  add(query_589108, "callback", newJString(callback))
  add(query_589108, "access_token", newJString(accessToken))
  add(query_589108, "uploadType", newJString(uploadType))
  add(query_589108, "key", newJString(key))
  add(query_589108, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589109 = body
  add(query_589108, "prettyPrint", newJBool(prettyPrint))
  result = call_589106.call(path_589107, query_589108, nil, nil, body_589109)

var serviceconsumermanagementServicesTenancyUnitsDeleteProject* = Call_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_589089(
    name: "serviceconsumermanagementServicesTenancyUnitsDeleteProject",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{name}:deleteProject", validator: validate_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_589090,
    base: "/",
    url: url_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_589091,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_589110 = ref object of OpenApiRestCall_588450
proc url_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_589112(
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
  result.path = base & hydrated.get

proc validate_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_589111(
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
  var valid_589113 = path.getOrDefault("name")
  valid_589113 = validateParameter(valid_589113, JString, required = true,
                                 default = nil)
  if valid_589113 != nil:
    section.add "name", valid_589113
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
  var valid_589114 = query.getOrDefault("upload_protocol")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "upload_protocol", valid_589114
  var valid_589115 = query.getOrDefault("fields")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "fields", valid_589115
  var valid_589116 = query.getOrDefault("quotaUser")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "quotaUser", valid_589116
  var valid_589117 = query.getOrDefault("alt")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = newJString("json"))
  if valid_589117 != nil:
    section.add "alt", valid_589117
  var valid_589118 = query.getOrDefault("oauth_token")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "oauth_token", valid_589118
  var valid_589119 = query.getOrDefault("callback")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "callback", valid_589119
  var valid_589120 = query.getOrDefault("access_token")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "access_token", valid_589120
  var valid_589121 = query.getOrDefault("uploadType")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "uploadType", valid_589121
  var valid_589122 = query.getOrDefault("key")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "key", valid_589122
  var valid_589123 = query.getOrDefault("$.xgafv")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = newJString("1"))
  if valid_589123 != nil:
    section.add "$.xgafv", valid_589123
  var valid_589124 = query.getOrDefault("prettyPrint")
  valid_589124 = validateParameter(valid_589124, JBool, required = false,
                                 default = newJBool(true))
  if valid_589124 != nil:
    section.add "prettyPrint", valid_589124
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

proc call*(call_589126: Call_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_589110;
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
  let valid = call_589126.validator(path, query, header, formData, body)
  let scheme = call_589126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589126.url(scheme.get, call_589126.host, call_589126.base,
                         call_589126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589126, url, valid)

proc call*(call_589127: Call_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_589110;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## serviceconsumermanagementServicesTenancyUnitsRemoveProject
  ## Removes the specified project resource identified by a tenant resource tag.
  ## The method removes the project lien with 'TenantManager' origin if that
  ## was added. It then attempts to delete the project. If that operation
  ## fails, this method also fails.
  ## Calls to remove already removed or non-existent tenant project succeed.
  ## After the project has been deleted, or if was already in a DELETED state,
  ## resource metadata is permanently removed from the tenancy unit.
  ## Operation<response: Empty>.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the tenancy unit.
  ## Such as 'services/service.googleapis.com/projects/12345/tenancyUnits/abcd'.
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
  var path_589128 = newJObject()
  var query_589129 = newJObject()
  var body_589130 = newJObject()
  add(query_589129, "upload_protocol", newJString(uploadProtocol))
  add(query_589129, "fields", newJString(fields))
  add(query_589129, "quotaUser", newJString(quotaUser))
  add(path_589128, "name", newJString(name))
  add(query_589129, "alt", newJString(alt))
  add(query_589129, "oauth_token", newJString(oauthToken))
  add(query_589129, "callback", newJString(callback))
  add(query_589129, "access_token", newJString(accessToken))
  add(query_589129, "uploadType", newJString(uploadType))
  add(query_589129, "key", newJString(key))
  add(query_589129, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589130 = body
  add(query_589129, "prettyPrint", newJBool(prettyPrint))
  result = call_589127.call(path_589128, query_589129, nil, nil, body_589130)

var serviceconsumermanagementServicesTenancyUnitsRemoveProject* = Call_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_589110(
    name: "serviceconsumermanagementServicesTenancyUnitsRemoveProject",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{name}:removeProject", validator: validate_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_589111,
    base: "/",
    url: url_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_589112,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_589131 = ref object of OpenApiRestCall_588450
proc url_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_589133(
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
  result.path = base & hydrated.get

proc validate_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_589132(
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
  var valid_589134 = path.getOrDefault("name")
  valid_589134 = validateParameter(valid_589134, JString, required = true,
                                 default = nil)
  if valid_589134 != nil:
    section.add "name", valid_589134
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
  var valid_589135 = query.getOrDefault("upload_protocol")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "upload_protocol", valid_589135
  var valid_589136 = query.getOrDefault("fields")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "fields", valid_589136
  var valid_589137 = query.getOrDefault("quotaUser")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "quotaUser", valid_589137
  var valid_589138 = query.getOrDefault("alt")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = newJString("json"))
  if valid_589138 != nil:
    section.add "alt", valid_589138
  var valid_589139 = query.getOrDefault("oauth_token")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "oauth_token", valid_589139
  var valid_589140 = query.getOrDefault("callback")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "callback", valid_589140
  var valid_589141 = query.getOrDefault("access_token")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "access_token", valid_589141
  var valid_589142 = query.getOrDefault("uploadType")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "uploadType", valid_589142
  var valid_589143 = query.getOrDefault("key")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "key", valid_589143
  var valid_589144 = query.getOrDefault("$.xgafv")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = newJString("1"))
  if valid_589144 != nil:
    section.add "$.xgafv", valid_589144
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589147: Call_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_589131;
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
  let valid = call_589147.validator(path, query, header, formData, body)
  let scheme = call_589147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589147.url(scheme.get, call_589147.host, call_589147.base,
                         call_589147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589147, url, valid)

proc call*(call_589148: Call_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_589131;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## serviceconsumermanagementServicesTenancyUnitsUndeleteProject
  ## Attempts to undelete a previously deleted tenant project. The project must
  ## be in a DELETED state.
  ## There are no guarantees that an undeleted project will be in
  ## a fully restored and functional state. Call the `ApplyTenantProjectConfig`
  ## method to update its configuration and then validate all managed service
  ## resources.
  ## Operation<response: Empty>.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Name of the tenancy unit.
  ## Such as 'services/service.googleapis.com/projects/12345/tenancyUnits/abcd'.
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
  var path_589149 = newJObject()
  var query_589150 = newJObject()
  var body_589151 = newJObject()
  add(query_589150, "upload_protocol", newJString(uploadProtocol))
  add(query_589150, "fields", newJString(fields))
  add(query_589150, "quotaUser", newJString(quotaUser))
  add(path_589149, "name", newJString(name))
  add(query_589150, "alt", newJString(alt))
  add(query_589150, "oauth_token", newJString(oauthToken))
  add(query_589150, "callback", newJString(callback))
  add(query_589150, "access_token", newJString(accessToken))
  add(query_589150, "uploadType", newJString(uploadType))
  add(query_589150, "key", newJString(key))
  add(query_589150, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589151 = body
  add(query_589150, "prettyPrint", newJBool(prettyPrint))
  result = call_589148.call(path_589149, query_589150, nil, nil, body_589151)

var serviceconsumermanagementServicesTenancyUnitsUndeleteProject* = Call_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_589131(
    name: "serviceconsumermanagementServicesTenancyUnitsUndeleteProject",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{name}:undeleteProject", validator: validate_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_589132,
    base: "/",
    url: url_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_589133,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsCreate_589174 = ref object of OpenApiRestCall_588450
proc url_ServiceconsumermanagementServicesTenancyUnitsCreate_589176(
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
  result.path = base & hydrated.get

proc validate_ServiceconsumermanagementServicesTenancyUnitsCreate_589175(
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
  var valid_589177 = path.getOrDefault("parent")
  valid_589177 = validateParameter(valid_589177, JString, required = true,
                                 default = nil)
  if valid_589177 != nil:
    section.add "parent", valid_589177
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
  var valid_589178 = query.getOrDefault("upload_protocol")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "upload_protocol", valid_589178
  var valid_589179 = query.getOrDefault("fields")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "fields", valid_589179
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
  var valid_589188 = query.getOrDefault("prettyPrint")
  valid_589188 = validateParameter(valid_589188, JBool, required = false,
                                 default = newJBool(true))
  if valid_589188 != nil:
    section.add "prettyPrint", valid_589188
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

proc call*(call_589190: Call_ServiceconsumermanagementServicesTenancyUnitsCreate_589174;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a tenancy unit with no tenant resources.
  ## If tenancy unit already exists, it will be returned,
  ## however, in this case, returned TenancyUnit does not have tenant_resources
  ## field set and ListTenancyUnit has to be used to get a complete
  ## TenancyUnit with all fields populated.
  ## 
  let valid = call_589190.validator(path, query, header, formData, body)
  let scheme = call_589190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589190.url(scheme.get, call_589190.host, call_589190.base,
                         call_589190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589190, url, valid)

proc call*(call_589191: Call_ServiceconsumermanagementServicesTenancyUnitsCreate_589174;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## serviceconsumermanagementServicesTenancyUnitsCreate
  ## Creates a tenancy unit with no tenant resources.
  ## If tenancy unit already exists, it will be returned,
  ## however, in this case, returned TenancyUnit does not have tenant_resources
  ## field set and ListTenancyUnit has to be used to get a complete
  ## TenancyUnit with all fields populated.
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
  ##         : services/{service}/{collection id}/{resource id}
  ## {collection id} is the cloud resource collection type representing the
  ## service consumer, for example 'projects', or 'organizations'.
  ## {resource id} is the consumer numeric id, such as project number: '123456'.
  ## {service} the name of a managed service, such as 'service.googleapis.com'.
  ## Enables service binding using the new tenancy unit.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589192 = newJObject()
  var query_589193 = newJObject()
  var body_589194 = newJObject()
  add(query_589193, "upload_protocol", newJString(uploadProtocol))
  add(query_589193, "fields", newJString(fields))
  add(query_589193, "quotaUser", newJString(quotaUser))
  add(query_589193, "alt", newJString(alt))
  add(query_589193, "oauth_token", newJString(oauthToken))
  add(query_589193, "callback", newJString(callback))
  add(query_589193, "access_token", newJString(accessToken))
  add(query_589193, "uploadType", newJString(uploadType))
  add(path_589192, "parent", newJString(parent))
  add(query_589193, "key", newJString(key))
  add(query_589193, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589194 = body
  add(query_589193, "prettyPrint", newJBool(prettyPrint))
  result = call_589191.call(path_589192, query_589193, nil, nil, body_589194)

var serviceconsumermanagementServicesTenancyUnitsCreate* = Call_ServiceconsumermanagementServicesTenancyUnitsCreate_589174(
    name: "serviceconsumermanagementServicesTenancyUnitsCreate",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{parent}/tenancyUnits",
    validator: validate_ServiceconsumermanagementServicesTenancyUnitsCreate_589175,
    base: "/", url: url_ServiceconsumermanagementServicesTenancyUnitsCreate_589176,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsList_589152 = ref object of OpenApiRestCall_588450
proc url_ServiceconsumermanagementServicesTenancyUnitsList_589154(
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
  result.path = base & hydrated.get

proc validate_ServiceconsumermanagementServicesTenancyUnitsList_589153(
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
  var valid_589155 = path.getOrDefault("parent")
  valid_589155 = validateParameter(valid_589155, JString, required = true,
                                 default = nil)
  if valid_589155 != nil:
    section.add "parent", valid_589155
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The continuation token, which is used to page through large result sets.
  ## To get the next page of results, set this parameter to the value of
  ## `nextPageToken` from the previous response.
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
  ##           : The maximum number of results returned by this request.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Filter expression over tenancy resources field. Optional.
  section = newJObject()
  var valid_589156 = query.getOrDefault("upload_protocol")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "upload_protocol", valid_589156
  var valid_589157 = query.getOrDefault("fields")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "fields", valid_589157
  var valid_589158 = query.getOrDefault("pageToken")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "pageToken", valid_589158
  var valid_589159 = query.getOrDefault("quotaUser")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "quotaUser", valid_589159
  var valid_589160 = query.getOrDefault("alt")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = newJString("json"))
  if valid_589160 != nil:
    section.add "alt", valid_589160
  var valid_589161 = query.getOrDefault("oauth_token")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "oauth_token", valid_589161
  var valid_589162 = query.getOrDefault("callback")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "callback", valid_589162
  var valid_589163 = query.getOrDefault("access_token")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "access_token", valid_589163
  var valid_589164 = query.getOrDefault("uploadType")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "uploadType", valid_589164
  var valid_589165 = query.getOrDefault("key")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "key", valid_589165
  var valid_589166 = query.getOrDefault("$.xgafv")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = newJString("1"))
  if valid_589166 != nil:
    section.add "$.xgafv", valid_589166
  var valid_589167 = query.getOrDefault("pageSize")
  valid_589167 = validateParameter(valid_589167, JInt, required = false, default = nil)
  if valid_589167 != nil:
    section.add "pageSize", valid_589167
  var valid_589168 = query.getOrDefault("prettyPrint")
  valid_589168 = validateParameter(valid_589168, JBool, required = false,
                                 default = newJBool(true))
  if valid_589168 != nil:
    section.add "prettyPrint", valid_589168
  var valid_589169 = query.getOrDefault("filter")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "filter", valid_589169
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589170: Call_ServiceconsumermanagementServicesTenancyUnitsList_589152;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Find the tenancy unit for a managed service and service consumer.
  ## This method shouldn't be used in a service producer's runtime path, for
  ## example to find the tenant project number when creating VMs. Service
  ## producers must persist the tenant project's information after the project
  ## is created.
  ## 
  let valid = call_589170.validator(path, query, header, formData, body)
  let scheme = call_589170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589170.url(scheme.get, call_589170.host, call_589170.base,
                         call_589170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589170, url, valid)

proc call*(call_589171: Call_ServiceconsumermanagementServicesTenancyUnitsList_589152;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## serviceconsumermanagementServicesTenancyUnitsList
  ## Find the tenancy unit for a managed service and service consumer.
  ## This method shouldn't be used in a service producer's runtime path, for
  ## example to find the tenant project number when creating VMs. Service
  ## producers must persist the tenant project's information after the project
  ## is created.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The continuation token, which is used to page through large result sets.
  ## To get the next page of results, set this parameter to the value of
  ## `nextPageToken` from the previous response.
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
  ##         : Managed service and service consumer. Required.
  ## services/{service}/{collection id}/{resource id}
  ## {collection id} is the cloud resource collection type representing the
  ## service consumer, for example 'projects', or 'organizations'.
  ## {resource id} is the consumer numeric id, such as project number: '123456'.
  ## {service} the name of a service, such as 'service.googleapis.com'.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of results returned by this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Filter expression over tenancy resources field. Optional.
  var path_589172 = newJObject()
  var query_589173 = newJObject()
  add(query_589173, "upload_protocol", newJString(uploadProtocol))
  add(query_589173, "fields", newJString(fields))
  add(query_589173, "pageToken", newJString(pageToken))
  add(query_589173, "quotaUser", newJString(quotaUser))
  add(query_589173, "alt", newJString(alt))
  add(query_589173, "oauth_token", newJString(oauthToken))
  add(query_589173, "callback", newJString(callback))
  add(query_589173, "access_token", newJString(accessToken))
  add(query_589173, "uploadType", newJString(uploadType))
  add(path_589172, "parent", newJString(parent))
  add(query_589173, "key", newJString(key))
  add(query_589173, "$.xgafv", newJString(Xgafv))
  add(query_589173, "pageSize", newJInt(pageSize))
  add(query_589173, "prettyPrint", newJBool(prettyPrint))
  add(query_589173, "filter", newJString(filter))
  result = call_589171.call(path_589172, query_589173, nil, nil, nil)

var serviceconsumermanagementServicesTenancyUnitsList* = Call_ServiceconsumermanagementServicesTenancyUnitsList_589152(
    name: "serviceconsumermanagementServicesTenancyUnitsList",
    meth: HttpMethod.HttpGet, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{parent}/tenancyUnits",
    validator: validate_ServiceconsumermanagementServicesTenancyUnitsList_589153,
    base: "/", url: url_ServiceconsumermanagementServicesTenancyUnitsList_589154,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsAddProject_589195 = ref object of OpenApiRestCall_588450
proc url_ServiceconsumermanagementServicesTenancyUnitsAddProject_589197(
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
  result.path = base & hydrated.get

proc validate_ServiceconsumermanagementServicesTenancyUnitsAddProject_589196(
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
  var valid_589198 = path.getOrDefault("parent")
  valid_589198 = validateParameter(valid_589198, JString, required = true,
                                 default = nil)
  if valid_589198 != nil:
    section.add "parent", valid_589198
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
  var valid_589203 = query.getOrDefault("oauth_token")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "oauth_token", valid_589203
  var valid_589204 = query.getOrDefault("callback")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "callback", valid_589204
  var valid_589205 = query.getOrDefault("access_token")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = nil)
  if valid_589205 != nil:
    section.add "access_token", valid_589205
  var valid_589206 = query.getOrDefault("uploadType")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "uploadType", valid_589206
  var valid_589207 = query.getOrDefault("key")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "key", valid_589207
  var valid_589208 = query.getOrDefault("$.xgafv")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = newJString("1"))
  if valid_589208 != nil:
    section.add "$.xgafv", valid_589208
  var valid_589209 = query.getOrDefault("prettyPrint")
  valid_589209 = validateParameter(valid_589209, JBool, required = false,
                                 default = newJBool(true))
  if valid_589209 != nil:
    section.add "prettyPrint", valid_589209
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

proc call*(call_589211: Call_ServiceconsumermanagementServicesTenancyUnitsAddProject_589195;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add a new tenant project to the tenancy unit.
  ## There can be a maximum of 512 tenant projects in a tenancy unit.
  ## If there are previously failed `AddTenantProject` calls, you might need to
  ## call `RemoveTenantProject` first to resolve them before you can make
  ## another call to `AddTenantProject` with the same tag.
  ## Operation<response: Empty>.
  ## 
  let valid = call_589211.validator(path, query, header, formData, body)
  let scheme = call_589211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589211.url(scheme.get, call_589211.host, call_589211.base,
                         call_589211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589211, url, valid)

proc call*(call_589212: Call_ServiceconsumermanagementServicesTenancyUnitsAddProject_589195;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## serviceconsumermanagementServicesTenancyUnitsAddProject
  ## Add a new tenant project to the tenancy unit.
  ## There can be a maximum of 512 tenant projects in a tenancy unit.
  ## If there are previously failed `AddTenantProject` calls, you might need to
  ## call `RemoveTenantProject` first to resolve them before you can make
  ## another call to `AddTenantProject` with the same tag.
  ## Operation<response: Empty>.
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
  ##         : Name of the tenancy unit.
  ## Such as 'services/service.googleapis.com/projects/12345/tenancyUnits/abcd'.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589213 = newJObject()
  var query_589214 = newJObject()
  var body_589215 = newJObject()
  add(query_589214, "upload_protocol", newJString(uploadProtocol))
  add(query_589214, "fields", newJString(fields))
  add(query_589214, "quotaUser", newJString(quotaUser))
  add(query_589214, "alt", newJString(alt))
  add(query_589214, "oauth_token", newJString(oauthToken))
  add(query_589214, "callback", newJString(callback))
  add(query_589214, "access_token", newJString(accessToken))
  add(query_589214, "uploadType", newJString(uploadType))
  add(path_589213, "parent", newJString(parent))
  add(query_589214, "key", newJString(key))
  add(query_589214, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589215 = body
  add(query_589214, "prettyPrint", newJBool(prettyPrint))
  result = call_589212.call(path_589213, query_589214, nil, nil, body_589215)

var serviceconsumermanagementServicesTenancyUnitsAddProject* = Call_ServiceconsumermanagementServicesTenancyUnitsAddProject_589195(
    name: "serviceconsumermanagementServicesTenancyUnitsAddProject",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{parent}:addProject", validator: validate_ServiceconsumermanagementServicesTenancyUnitsAddProject_589196,
    base: "/", url: url_ServiceconsumermanagementServicesTenancyUnitsAddProject_589197,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesSearch_589216 = ref object of OpenApiRestCall_588450
proc url_ServiceconsumermanagementServicesSearch_589218(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_ServiceconsumermanagementServicesSearch_589217(path: JsonNode;
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
  var valid_589219 = path.getOrDefault("parent")
  valid_589219 = validateParameter(valid_589219, JString, required = true,
                                 default = nil)
  if valid_589219 != nil:
    section.add "parent", valid_589219
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The continuation token, which is used to page through large result sets.
  ## To get the next page of results, set this parameter to the value of
  ## `nextPageToken` from the previous response.
  ## 
  ## Optional.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
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
  ##           : The maximum number of results returned by this request. Currently, the
  ## default maximum is set to 1000. If `page_size` isn't provided or the size
  ## provided is a number larger than 1000, it's automatically set to 1000.
  ## 
  ## Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589220 = query.getOrDefault("upload_protocol")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "upload_protocol", valid_589220
  var valid_589221 = query.getOrDefault("fields")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "fields", valid_589221
  var valid_589222 = query.getOrDefault("pageToken")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "pageToken", valid_589222
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
  var valid_589225 = query.getOrDefault("query")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "query", valid_589225
  var valid_589226 = query.getOrDefault("oauth_token")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "oauth_token", valid_589226
  var valid_589227 = query.getOrDefault("callback")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "callback", valid_589227
  var valid_589228 = query.getOrDefault("access_token")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "access_token", valid_589228
  var valid_589229 = query.getOrDefault("uploadType")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = nil)
  if valid_589229 != nil:
    section.add "uploadType", valid_589229
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
  var valid_589232 = query.getOrDefault("pageSize")
  valid_589232 = validateParameter(valid_589232, JInt, required = false, default = nil)
  if valid_589232 != nil:
    section.add "pageSize", valid_589232
  var valid_589233 = query.getOrDefault("prettyPrint")
  valid_589233 = validateParameter(valid_589233, JBool, required = false,
                                 default = newJBool(true))
  if valid_589233 != nil:
    section.add "prettyPrint", valid_589233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589234: Call_ServiceconsumermanagementServicesSearch_589216;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Search tenancy units for a managed service.
  ## 
  let valid = call_589234.validator(path, query, header, formData, body)
  let scheme = call_589234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589234.url(scheme.get, call_589234.host, call_589234.base,
                         call_589234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589234, url, valid)

proc call*(call_589235: Call_ServiceconsumermanagementServicesSearch_589216;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          query: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## serviceconsumermanagementServicesSearch
  ## Search tenancy units for a managed service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The continuation token, which is used to page through large result sets.
  ## To get the next page of results, set this parameter to the value of
  ## `nextPageToken` from the previous response.
  ## 
  ## Optional.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Service for which search is performed.
  ## services/{service}
  ## {service} the name of a service, for example 'service.googleapis.com'.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of results returned by this request. Currently, the
  ## default maximum is set to 1000. If `page_size` isn't provided or the size
  ## provided is a number larger than 1000, it's automatically set to 1000.
  ## 
  ## Optional.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589236 = newJObject()
  var query_589237 = newJObject()
  add(query_589237, "upload_protocol", newJString(uploadProtocol))
  add(query_589237, "fields", newJString(fields))
  add(query_589237, "pageToken", newJString(pageToken))
  add(query_589237, "quotaUser", newJString(quotaUser))
  add(query_589237, "alt", newJString(alt))
  add(query_589237, "query", newJString(query))
  add(query_589237, "oauth_token", newJString(oauthToken))
  add(query_589237, "callback", newJString(callback))
  add(query_589237, "access_token", newJString(accessToken))
  add(query_589237, "uploadType", newJString(uploadType))
  add(path_589236, "parent", newJString(parent))
  add(query_589237, "key", newJString(key))
  add(query_589237, "$.xgafv", newJString(Xgafv))
  add(query_589237, "pageSize", newJInt(pageSize))
  add(query_589237, "prettyPrint", newJBool(prettyPrint))
  result = call_589235.call(path_589236, query_589237, nil, nil, nil)

var serviceconsumermanagementServicesSearch* = Call_ServiceconsumermanagementServicesSearch_589216(
    name: "serviceconsumermanagementServicesSearch", meth: HttpMethod.HttpGet,
    host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{parent}:search",
    validator: validate_ServiceconsumermanagementServicesSearch_589217, base: "/",
    url: url_ServiceconsumermanagementServicesSearch_589218,
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
