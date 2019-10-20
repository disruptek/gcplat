
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
  gcpServiceName = "serviceconsumermanagement"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServiceconsumermanagementOperationsGet_578619 = ref object of OpenApiRestCall_578348
proc url_ServiceconsumermanagementOperationsGet_578621(protocol: Scheme;
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

proc validate_ServiceconsumermanagementOperationsGet_578620(path: JsonNode;
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

proc call*(call_578794: Call_ServiceconsumermanagementOperationsGet_578619;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
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

proc call*(call_578865: Call_ServiceconsumermanagementOperationsGet_578619;
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

var serviceconsumermanagementOperationsGet* = Call_ServiceconsumermanagementOperationsGet_578619(
    name: "serviceconsumermanagementOperationsGet", meth: HttpMethod.HttpGet,
    host: "serviceconsumermanagement.googleapis.com", route: "/v1/{name}",
    validator: validate_ServiceconsumermanagementOperationsGet_578620, base: "/",
    url: url_ServiceconsumermanagementOperationsGet_578621,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsDelete_578907 = ref object of OpenApiRestCall_578348
proc url_ServiceconsumermanagementServicesTenancyUnitsDelete_578909(
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

proc validate_ServiceconsumermanagementServicesTenancyUnitsDelete_578908(
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

proc call*(call_578922: Call_ServiceconsumermanagementServicesTenancyUnitsDelete_578907;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a tenancy unit. Before you delete the tenancy unit, there should be
  ## no tenant resources in it that aren't in a DELETED state.
  ## Operation<response: Empty>.
  ## 
  let valid = call_578922.validator(path, query, header, formData, body)
  let scheme = call_578922.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578922.url(scheme.get, call_578922.host, call_578922.base,
                         call_578922.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578922, url, valid)

proc call*(call_578923: Call_ServiceconsumermanagementServicesTenancyUnitsDelete_578907;
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

var serviceconsumermanagementServicesTenancyUnitsDelete* = Call_ServiceconsumermanagementServicesTenancyUnitsDelete_578907(
    name: "serviceconsumermanagementServicesTenancyUnitsDelete",
    meth: HttpMethod.HttpDelete, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{name}",
    validator: validate_ServiceconsumermanagementServicesTenancyUnitsDelete_578908,
    base: "/", url: url_ServiceconsumermanagementServicesTenancyUnitsDelete_578909,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_578926 = ref object of OpenApiRestCall_578348
proc url_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_578928(
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

proc validate_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_578927(
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
  var valid_578937 = query.getOrDefault("callback")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "callback", valid_578937
  var valid_578938 = query.getOrDefault("fields")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "fields", valid_578938
  var valid_578939 = query.getOrDefault("access_token")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "access_token", valid_578939
  var valid_578940 = query.getOrDefault("upload_protocol")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "upload_protocol", valid_578940
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

proc call*(call_578942: Call_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_578926;
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
  let valid = call_578942.validator(path, query, header, formData, body)
  let scheme = call_578942.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578942.url(scheme.get, call_578942.host, call_578942.base,
                         call_578942.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578942, url, valid)

proc call*(call_578943: Call_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_578926;
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
  var path_578944 = newJObject()
  var query_578945 = newJObject()
  var body_578946 = newJObject()
  add(query_578945, "key", newJString(key))
  add(query_578945, "prettyPrint", newJBool(prettyPrint))
  add(query_578945, "oauth_token", newJString(oauthToken))
  add(query_578945, "$.xgafv", newJString(Xgafv))
  add(query_578945, "alt", newJString(alt))
  add(query_578945, "uploadType", newJString(uploadType))
  add(query_578945, "quotaUser", newJString(quotaUser))
  add(path_578944, "name", newJString(name))
  if body != nil:
    body_578946 = body
  add(query_578945, "callback", newJString(callback))
  add(query_578945, "fields", newJString(fields))
  add(query_578945, "access_token", newJString(accessToken))
  add(query_578945, "upload_protocol", newJString(uploadProtocol))
  result = call_578943.call(path_578944, query_578945, nil, nil, body_578946)

var serviceconsumermanagementServicesTenancyUnitsApplyProjectConfig* = Call_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_578926(
    name: "serviceconsumermanagementServicesTenancyUnitsApplyProjectConfig",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{name}:applyProjectConfig", validator: validate_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_578927,
    base: "/",
    url: url_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_578928,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsAttachProject_578947 = ref object of OpenApiRestCall_578348
proc url_ServiceconsumermanagementServicesTenancyUnitsAttachProject_578949(
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

proc validate_ServiceconsumermanagementServicesTenancyUnitsAttachProject_578948(
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
  var valid_578950 = path.getOrDefault("name")
  valid_578950 = validateParameter(valid_578950, JString, required = true,
                                 default = nil)
  if valid_578950 != nil:
    section.add "name", valid_578950
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
  var valid_578951 = query.getOrDefault("key")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "key", valid_578951
  var valid_578952 = query.getOrDefault("prettyPrint")
  valid_578952 = validateParameter(valid_578952, JBool, required = false,
                                 default = newJBool(true))
  if valid_578952 != nil:
    section.add "prettyPrint", valid_578952
  var valid_578953 = query.getOrDefault("oauth_token")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "oauth_token", valid_578953
  var valid_578954 = query.getOrDefault("$.xgafv")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = newJString("1"))
  if valid_578954 != nil:
    section.add "$.xgafv", valid_578954
  var valid_578955 = query.getOrDefault("alt")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = newJString("json"))
  if valid_578955 != nil:
    section.add "alt", valid_578955
  var valid_578956 = query.getOrDefault("uploadType")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "uploadType", valid_578956
  var valid_578957 = query.getOrDefault("quotaUser")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "quotaUser", valid_578957
  var valid_578958 = query.getOrDefault("callback")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "callback", valid_578958
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578963: Call_ServiceconsumermanagementServicesTenancyUnitsAttachProject_578947;
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
  let valid = call_578963.validator(path, query, header, formData, body)
  let scheme = call_578963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578963.url(scheme.get, call_578963.host, call_578963.base,
                         call_578963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578963, url, valid)

proc call*(call_578964: Call_ServiceconsumermanagementServicesTenancyUnitsAttachProject_578947;
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
  var path_578965 = newJObject()
  var query_578966 = newJObject()
  var body_578967 = newJObject()
  add(query_578966, "key", newJString(key))
  add(query_578966, "prettyPrint", newJBool(prettyPrint))
  add(query_578966, "oauth_token", newJString(oauthToken))
  add(query_578966, "$.xgafv", newJString(Xgafv))
  add(query_578966, "alt", newJString(alt))
  add(query_578966, "uploadType", newJString(uploadType))
  add(query_578966, "quotaUser", newJString(quotaUser))
  add(path_578965, "name", newJString(name))
  if body != nil:
    body_578967 = body
  add(query_578966, "callback", newJString(callback))
  add(query_578966, "fields", newJString(fields))
  add(query_578966, "access_token", newJString(accessToken))
  add(query_578966, "upload_protocol", newJString(uploadProtocol))
  result = call_578964.call(path_578965, query_578966, nil, nil, body_578967)

var serviceconsumermanagementServicesTenancyUnitsAttachProject* = Call_ServiceconsumermanagementServicesTenancyUnitsAttachProject_578947(
    name: "serviceconsumermanagementServicesTenancyUnitsAttachProject",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{name}:attachProject", validator: validate_ServiceconsumermanagementServicesTenancyUnitsAttachProject_578948,
    base: "/",
    url: url_ServiceconsumermanagementServicesTenancyUnitsAttachProject_578949,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementOperationsCancel_578968 = ref object of OpenApiRestCall_578348
proc url_ServiceconsumermanagementOperationsCancel_578970(protocol: Scheme;
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

proc validate_ServiceconsumermanagementOperationsCancel_578969(path: JsonNode;
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
  var valid_578971 = path.getOrDefault("name")
  valid_578971 = validateParameter(valid_578971, JString, required = true,
                                 default = nil)
  if valid_578971 != nil:
    section.add "name", valid_578971
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
  var valid_578972 = query.getOrDefault("key")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "key", valid_578972
  var valid_578973 = query.getOrDefault("prettyPrint")
  valid_578973 = validateParameter(valid_578973, JBool, required = false,
                                 default = newJBool(true))
  if valid_578973 != nil:
    section.add "prettyPrint", valid_578973
  var valid_578974 = query.getOrDefault("oauth_token")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "oauth_token", valid_578974
  var valid_578975 = query.getOrDefault("$.xgafv")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = newJString("1"))
  if valid_578975 != nil:
    section.add "$.xgafv", valid_578975
  var valid_578976 = query.getOrDefault("alt")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = newJString("json"))
  if valid_578976 != nil:
    section.add "alt", valid_578976
  var valid_578977 = query.getOrDefault("uploadType")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "uploadType", valid_578977
  var valid_578978 = query.getOrDefault("quotaUser")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "quotaUser", valid_578978
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578984: Call_ServiceconsumermanagementOperationsCancel_578968;
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
  let valid = call_578984.validator(path, query, header, formData, body)
  let scheme = call_578984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578984.url(scheme.get, call_578984.host, call_578984.base,
                         call_578984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578984, url, valid)

proc call*(call_578985: Call_ServiceconsumermanagementOperationsCancel_578968;
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
  var path_578986 = newJObject()
  var query_578987 = newJObject()
  var body_578988 = newJObject()
  add(query_578987, "key", newJString(key))
  add(query_578987, "prettyPrint", newJBool(prettyPrint))
  add(query_578987, "oauth_token", newJString(oauthToken))
  add(query_578987, "$.xgafv", newJString(Xgafv))
  add(query_578987, "alt", newJString(alt))
  add(query_578987, "uploadType", newJString(uploadType))
  add(query_578987, "quotaUser", newJString(quotaUser))
  add(path_578986, "name", newJString(name))
  if body != nil:
    body_578988 = body
  add(query_578987, "callback", newJString(callback))
  add(query_578987, "fields", newJString(fields))
  add(query_578987, "access_token", newJString(accessToken))
  add(query_578987, "upload_protocol", newJString(uploadProtocol))
  result = call_578985.call(path_578986, query_578987, nil, nil, body_578988)

var serviceconsumermanagementOperationsCancel* = Call_ServiceconsumermanagementOperationsCancel_578968(
    name: "serviceconsumermanagementOperationsCancel", meth: HttpMethod.HttpPost,
    host: "serviceconsumermanagement.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_ServiceconsumermanagementOperationsCancel_578969,
    base: "/", url: url_ServiceconsumermanagementOperationsCancel_578970,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_578989 = ref object of OpenApiRestCall_578348
proc url_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_578991(
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

proc validate_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_578990(
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
  var valid_578992 = path.getOrDefault("name")
  valid_578992 = validateParameter(valid_578992, JString, required = true,
                                 default = nil)
  if valid_578992 != nil:
    section.add "name", valid_578992
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
  var valid_578993 = query.getOrDefault("key")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "key", valid_578993
  var valid_578994 = query.getOrDefault("prettyPrint")
  valid_578994 = validateParameter(valid_578994, JBool, required = false,
                                 default = newJBool(true))
  if valid_578994 != nil:
    section.add "prettyPrint", valid_578994
  var valid_578995 = query.getOrDefault("oauth_token")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "oauth_token", valid_578995
  var valid_578996 = query.getOrDefault("$.xgafv")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = newJString("1"))
  if valid_578996 != nil:
    section.add "$.xgafv", valid_578996
  var valid_578997 = query.getOrDefault("alt")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = newJString("json"))
  if valid_578997 != nil:
    section.add "alt", valid_578997
  var valid_578998 = query.getOrDefault("uploadType")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "uploadType", valid_578998
  var valid_578999 = query.getOrDefault("quotaUser")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "quotaUser", valid_578999
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579005: Call_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_578989;
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
  let valid = call_579005.validator(path, query, header, formData, body)
  let scheme = call_579005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579005.url(scheme.get, call_579005.host, call_579005.base,
                         call_579005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579005, url, valid)

proc call*(call_579006: Call_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_578989;
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
  var path_579007 = newJObject()
  var query_579008 = newJObject()
  var body_579009 = newJObject()
  add(query_579008, "key", newJString(key))
  add(query_579008, "prettyPrint", newJBool(prettyPrint))
  add(query_579008, "oauth_token", newJString(oauthToken))
  add(query_579008, "$.xgafv", newJString(Xgafv))
  add(query_579008, "alt", newJString(alt))
  add(query_579008, "uploadType", newJString(uploadType))
  add(query_579008, "quotaUser", newJString(quotaUser))
  add(path_579007, "name", newJString(name))
  if body != nil:
    body_579009 = body
  add(query_579008, "callback", newJString(callback))
  add(query_579008, "fields", newJString(fields))
  add(query_579008, "access_token", newJString(accessToken))
  add(query_579008, "upload_protocol", newJString(uploadProtocol))
  result = call_579006.call(path_579007, query_579008, nil, nil, body_579009)

var serviceconsumermanagementServicesTenancyUnitsDeleteProject* = Call_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_578989(
    name: "serviceconsumermanagementServicesTenancyUnitsDeleteProject",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{name}:deleteProject", validator: validate_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_578990,
    base: "/",
    url: url_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_578991,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_579010 = ref object of OpenApiRestCall_578348
proc url_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_579012(
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

proc validate_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_579011(
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
  var valid_579013 = path.getOrDefault("name")
  valid_579013 = validateParameter(valid_579013, JString, required = true,
                                 default = nil)
  if valid_579013 != nil:
    section.add "name", valid_579013
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
  var valid_579014 = query.getOrDefault("key")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "key", valid_579014
  var valid_579015 = query.getOrDefault("prettyPrint")
  valid_579015 = validateParameter(valid_579015, JBool, required = false,
                                 default = newJBool(true))
  if valid_579015 != nil:
    section.add "prettyPrint", valid_579015
  var valid_579016 = query.getOrDefault("oauth_token")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "oauth_token", valid_579016
  var valid_579017 = query.getOrDefault("$.xgafv")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = newJString("1"))
  if valid_579017 != nil:
    section.add "$.xgafv", valid_579017
  var valid_579018 = query.getOrDefault("alt")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = newJString("json"))
  if valid_579018 != nil:
    section.add "alt", valid_579018
  var valid_579019 = query.getOrDefault("uploadType")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "uploadType", valid_579019
  var valid_579020 = query.getOrDefault("quotaUser")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "quotaUser", valid_579020
  var valid_579021 = query.getOrDefault("callback")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "callback", valid_579021
  var valid_579022 = query.getOrDefault("fields")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "fields", valid_579022
  var valid_579023 = query.getOrDefault("access_token")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "access_token", valid_579023
  var valid_579024 = query.getOrDefault("upload_protocol")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "upload_protocol", valid_579024
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

proc call*(call_579026: Call_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_579010;
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
  let valid = call_579026.validator(path, query, header, formData, body)
  let scheme = call_579026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579026.url(scheme.get, call_579026.host, call_579026.base,
                         call_579026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579026, url, valid)

proc call*(call_579027: Call_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_579010;
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
  var path_579028 = newJObject()
  var query_579029 = newJObject()
  var body_579030 = newJObject()
  add(query_579029, "key", newJString(key))
  add(query_579029, "prettyPrint", newJBool(prettyPrint))
  add(query_579029, "oauth_token", newJString(oauthToken))
  add(query_579029, "$.xgafv", newJString(Xgafv))
  add(query_579029, "alt", newJString(alt))
  add(query_579029, "uploadType", newJString(uploadType))
  add(query_579029, "quotaUser", newJString(quotaUser))
  add(path_579028, "name", newJString(name))
  if body != nil:
    body_579030 = body
  add(query_579029, "callback", newJString(callback))
  add(query_579029, "fields", newJString(fields))
  add(query_579029, "access_token", newJString(accessToken))
  add(query_579029, "upload_protocol", newJString(uploadProtocol))
  result = call_579027.call(path_579028, query_579029, nil, nil, body_579030)

var serviceconsumermanagementServicesTenancyUnitsRemoveProject* = Call_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_579010(
    name: "serviceconsumermanagementServicesTenancyUnitsRemoveProject",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{name}:removeProject", validator: validate_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_579011,
    base: "/",
    url: url_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_579012,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_579031 = ref object of OpenApiRestCall_578348
proc url_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_579033(
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

proc validate_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_579032(
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
  var valid_579034 = path.getOrDefault("name")
  valid_579034 = validateParameter(valid_579034, JString, required = true,
                                 default = nil)
  if valid_579034 != nil:
    section.add "name", valid_579034
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
  var valid_579035 = query.getOrDefault("key")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "key", valid_579035
  var valid_579036 = query.getOrDefault("prettyPrint")
  valid_579036 = validateParameter(valid_579036, JBool, required = false,
                                 default = newJBool(true))
  if valid_579036 != nil:
    section.add "prettyPrint", valid_579036
  var valid_579037 = query.getOrDefault("oauth_token")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "oauth_token", valid_579037
  var valid_579038 = query.getOrDefault("$.xgafv")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = newJString("1"))
  if valid_579038 != nil:
    section.add "$.xgafv", valid_579038
  var valid_579039 = query.getOrDefault("alt")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = newJString("json"))
  if valid_579039 != nil:
    section.add "alt", valid_579039
  var valid_579040 = query.getOrDefault("uploadType")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "uploadType", valid_579040
  var valid_579041 = query.getOrDefault("quotaUser")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "quotaUser", valid_579041
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579047: Call_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_579031;
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
  let valid = call_579047.validator(path, query, header, formData, body)
  let scheme = call_579047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579047.url(scheme.get, call_579047.host, call_579047.base,
                         call_579047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579047, url, valid)

proc call*(call_579048: Call_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_579031;
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
  var path_579049 = newJObject()
  var query_579050 = newJObject()
  var body_579051 = newJObject()
  add(query_579050, "key", newJString(key))
  add(query_579050, "prettyPrint", newJBool(prettyPrint))
  add(query_579050, "oauth_token", newJString(oauthToken))
  add(query_579050, "$.xgafv", newJString(Xgafv))
  add(query_579050, "alt", newJString(alt))
  add(query_579050, "uploadType", newJString(uploadType))
  add(query_579050, "quotaUser", newJString(quotaUser))
  add(path_579049, "name", newJString(name))
  if body != nil:
    body_579051 = body
  add(query_579050, "callback", newJString(callback))
  add(query_579050, "fields", newJString(fields))
  add(query_579050, "access_token", newJString(accessToken))
  add(query_579050, "upload_protocol", newJString(uploadProtocol))
  result = call_579048.call(path_579049, query_579050, nil, nil, body_579051)

var serviceconsumermanagementServicesTenancyUnitsUndeleteProject* = Call_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_579031(
    name: "serviceconsumermanagementServicesTenancyUnitsUndeleteProject",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{name}:undeleteProject", validator: validate_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_579032,
    base: "/",
    url: url_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_579033,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsCreate_579074 = ref object of OpenApiRestCall_578348
proc url_ServiceconsumermanagementServicesTenancyUnitsCreate_579076(
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

proc validate_ServiceconsumermanagementServicesTenancyUnitsCreate_579075(
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
  var valid_579077 = path.getOrDefault("parent")
  valid_579077 = validateParameter(valid_579077, JString, required = true,
                                 default = nil)
  if valid_579077 != nil:
    section.add "parent", valid_579077
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
  var valid_579078 = query.getOrDefault("key")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "key", valid_579078
  var valid_579079 = query.getOrDefault("prettyPrint")
  valid_579079 = validateParameter(valid_579079, JBool, required = false,
                                 default = newJBool(true))
  if valid_579079 != nil:
    section.add "prettyPrint", valid_579079
  var valid_579080 = query.getOrDefault("oauth_token")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "oauth_token", valid_579080
  var valid_579081 = query.getOrDefault("$.xgafv")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = newJString("1"))
  if valid_579081 != nil:
    section.add "$.xgafv", valid_579081
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
  var valid_579085 = query.getOrDefault("callback")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "callback", valid_579085
  var valid_579086 = query.getOrDefault("fields")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "fields", valid_579086
  var valid_579087 = query.getOrDefault("access_token")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "access_token", valid_579087
  var valid_579088 = query.getOrDefault("upload_protocol")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "upload_protocol", valid_579088
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

proc call*(call_579090: Call_ServiceconsumermanagementServicesTenancyUnitsCreate_579074;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a tenancy unit with no tenant resources.
  ## If tenancy unit already exists, it will be returned,
  ## however, in this case, returned TenancyUnit does not have tenant_resources
  ## field set and ListTenancyUnit has to be used to get a complete
  ## TenancyUnit with all fields populated.
  ## 
  let valid = call_579090.validator(path, query, header, formData, body)
  let scheme = call_579090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579090.url(scheme.get, call_579090.host, call_579090.base,
                         call_579090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579090, url, valid)

proc call*(call_579091: Call_ServiceconsumermanagementServicesTenancyUnitsCreate_579074;
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
  var path_579092 = newJObject()
  var query_579093 = newJObject()
  var body_579094 = newJObject()
  add(query_579093, "key", newJString(key))
  add(query_579093, "prettyPrint", newJBool(prettyPrint))
  add(query_579093, "oauth_token", newJString(oauthToken))
  add(query_579093, "$.xgafv", newJString(Xgafv))
  add(query_579093, "alt", newJString(alt))
  add(query_579093, "uploadType", newJString(uploadType))
  add(query_579093, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579094 = body
  add(query_579093, "callback", newJString(callback))
  add(path_579092, "parent", newJString(parent))
  add(query_579093, "fields", newJString(fields))
  add(query_579093, "access_token", newJString(accessToken))
  add(query_579093, "upload_protocol", newJString(uploadProtocol))
  result = call_579091.call(path_579092, query_579093, nil, nil, body_579094)

var serviceconsumermanagementServicesTenancyUnitsCreate* = Call_ServiceconsumermanagementServicesTenancyUnitsCreate_579074(
    name: "serviceconsumermanagementServicesTenancyUnitsCreate",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{parent}/tenancyUnits",
    validator: validate_ServiceconsumermanagementServicesTenancyUnitsCreate_579075,
    base: "/", url: url_ServiceconsumermanagementServicesTenancyUnitsCreate_579076,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsList_579052 = ref object of OpenApiRestCall_578348
proc url_ServiceconsumermanagementServicesTenancyUnitsList_579054(
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

proc validate_ServiceconsumermanagementServicesTenancyUnitsList_579053(
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
  var valid_579055 = path.getOrDefault("parent")
  valid_579055 = validateParameter(valid_579055, JString, required = true,
                                 default = nil)
  if valid_579055 != nil:
    section.add "parent", valid_579055
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
  var valid_579056 = query.getOrDefault("key")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "key", valid_579056
  var valid_579057 = query.getOrDefault("prettyPrint")
  valid_579057 = validateParameter(valid_579057, JBool, required = false,
                                 default = newJBool(true))
  if valid_579057 != nil:
    section.add "prettyPrint", valid_579057
  var valid_579058 = query.getOrDefault("oauth_token")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "oauth_token", valid_579058
  var valid_579059 = query.getOrDefault("$.xgafv")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = newJString("1"))
  if valid_579059 != nil:
    section.add "$.xgafv", valid_579059
  var valid_579060 = query.getOrDefault("pageSize")
  valid_579060 = validateParameter(valid_579060, JInt, required = false, default = nil)
  if valid_579060 != nil:
    section.add "pageSize", valid_579060
  var valid_579061 = query.getOrDefault("alt")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = newJString("json"))
  if valid_579061 != nil:
    section.add "alt", valid_579061
  var valid_579062 = query.getOrDefault("uploadType")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "uploadType", valid_579062
  var valid_579063 = query.getOrDefault("quotaUser")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "quotaUser", valid_579063
  var valid_579064 = query.getOrDefault("filter")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "filter", valid_579064
  var valid_579065 = query.getOrDefault("pageToken")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "pageToken", valid_579065
  var valid_579066 = query.getOrDefault("callback")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "callback", valid_579066
  var valid_579067 = query.getOrDefault("fields")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "fields", valid_579067
  var valid_579068 = query.getOrDefault("access_token")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "access_token", valid_579068
  var valid_579069 = query.getOrDefault("upload_protocol")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "upload_protocol", valid_579069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579070: Call_ServiceconsumermanagementServicesTenancyUnitsList_579052;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Find the tenancy unit for a managed service and service consumer.
  ## This method shouldn't be used in a service producer's runtime path, for
  ## example to find the tenant project number when creating VMs. Service
  ## producers must persist the tenant project's information after the project
  ## is created.
  ## 
  let valid = call_579070.validator(path, query, header, formData, body)
  let scheme = call_579070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579070.url(scheme.get, call_579070.host, call_579070.base,
                         call_579070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579070, url, valid)

proc call*(call_579071: Call_ServiceconsumermanagementServicesTenancyUnitsList_579052;
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
  var path_579072 = newJObject()
  var query_579073 = newJObject()
  add(query_579073, "key", newJString(key))
  add(query_579073, "prettyPrint", newJBool(prettyPrint))
  add(query_579073, "oauth_token", newJString(oauthToken))
  add(query_579073, "$.xgafv", newJString(Xgafv))
  add(query_579073, "pageSize", newJInt(pageSize))
  add(query_579073, "alt", newJString(alt))
  add(query_579073, "uploadType", newJString(uploadType))
  add(query_579073, "quotaUser", newJString(quotaUser))
  add(query_579073, "filter", newJString(filter))
  add(query_579073, "pageToken", newJString(pageToken))
  add(query_579073, "callback", newJString(callback))
  add(path_579072, "parent", newJString(parent))
  add(query_579073, "fields", newJString(fields))
  add(query_579073, "access_token", newJString(accessToken))
  add(query_579073, "upload_protocol", newJString(uploadProtocol))
  result = call_579071.call(path_579072, query_579073, nil, nil, nil)

var serviceconsumermanagementServicesTenancyUnitsList* = Call_ServiceconsumermanagementServicesTenancyUnitsList_579052(
    name: "serviceconsumermanagementServicesTenancyUnitsList",
    meth: HttpMethod.HttpGet, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{parent}/tenancyUnits",
    validator: validate_ServiceconsumermanagementServicesTenancyUnitsList_579053,
    base: "/", url: url_ServiceconsumermanagementServicesTenancyUnitsList_579054,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsAddProject_579095 = ref object of OpenApiRestCall_578348
proc url_ServiceconsumermanagementServicesTenancyUnitsAddProject_579097(
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

proc validate_ServiceconsumermanagementServicesTenancyUnitsAddProject_579096(
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
  var valid_579106 = query.getOrDefault("callback")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "callback", valid_579106
  var valid_579107 = query.getOrDefault("fields")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "fields", valid_579107
  var valid_579108 = query.getOrDefault("access_token")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "access_token", valid_579108
  var valid_579109 = query.getOrDefault("upload_protocol")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "upload_protocol", valid_579109
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

proc call*(call_579111: Call_ServiceconsumermanagementServicesTenancyUnitsAddProject_579095;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add a new tenant project to the tenancy unit.
  ## There can be a maximum of 512 tenant projects in a tenancy unit.
  ## If there are previously failed `AddTenantProject` calls, you might need to
  ## call `RemoveTenantProject` first to resolve them before you can make
  ## another call to `AddTenantProject` with the same tag.
  ## Operation<response: Empty>.
  ## 
  let valid = call_579111.validator(path, query, header, formData, body)
  let scheme = call_579111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579111.url(scheme.get, call_579111.host, call_579111.base,
                         call_579111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579111, url, valid)

proc call*(call_579112: Call_ServiceconsumermanagementServicesTenancyUnitsAddProject_579095;
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
  var path_579113 = newJObject()
  var query_579114 = newJObject()
  var body_579115 = newJObject()
  add(query_579114, "key", newJString(key))
  add(query_579114, "prettyPrint", newJBool(prettyPrint))
  add(query_579114, "oauth_token", newJString(oauthToken))
  add(query_579114, "$.xgafv", newJString(Xgafv))
  add(query_579114, "alt", newJString(alt))
  add(query_579114, "uploadType", newJString(uploadType))
  add(query_579114, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579115 = body
  add(query_579114, "callback", newJString(callback))
  add(path_579113, "parent", newJString(parent))
  add(query_579114, "fields", newJString(fields))
  add(query_579114, "access_token", newJString(accessToken))
  add(query_579114, "upload_protocol", newJString(uploadProtocol))
  result = call_579112.call(path_579113, query_579114, nil, nil, body_579115)

var serviceconsumermanagementServicesTenancyUnitsAddProject* = Call_ServiceconsumermanagementServicesTenancyUnitsAddProject_579095(
    name: "serviceconsumermanagementServicesTenancyUnitsAddProject",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{parent}:addProject", validator: validate_ServiceconsumermanagementServicesTenancyUnitsAddProject_579096,
    base: "/", url: url_ServiceconsumermanagementServicesTenancyUnitsAddProject_579097,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesSearch_579116 = ref object of OpenApiRestCall_578348
proc url_ServiceconsumermanagementServicesSearch_579118(protocol: Scheme;
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

proc validate_ServiceconsumermanagementServicesSearch_579117(path: JsonNode;
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
  var valid_579119 = path.getOrDefault("parent")
  valid_579119 = validateParameter(valid_579119, JString, required = true,
                                 default = nil)
  if valid_579119 != nil:
    section.add "parent", valid_579119
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
  var valid_579120 = query.getOrDefault("key")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "key", valid_579120
  var valid_579121 = query.getOrDefault("prettyPrint")
  valid_579121 = validateParameter(valid_579121, JBool, required = false,
                                 default = newJBool(true))
  if valid_579121 != nil:
    section.add "prettyPrint", valid_579121
  var valid_579122 = query.getOrDefault("oauth_token")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "oauth_token", valid_579122
  var valid_579123 = query.getOrDefault("$.xgafv")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = newJString("1"))
  if valid_579123 != nil:
    section.add "$.xgafv", valid_579123
  var valid_579124 = query.getOrDefault("pageSize")
  valid_579124 = validateParameter(valid_579124, JInt, required = false, default = nil)
  if valid_579124 != nil:
    section.add "pageSize", valid_579124
  var valid_579125 = query.getOrDefault("alt")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = newJString("json"))
  if valid_579125 != nil:
    section.add "alt", valid_579125
  var valid_579126 = query.getOrDefault("uploadType")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "uploadType", valid_579126
  var valid_579127 = query.getOrDefault("quotaUser")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "quotaUser", valid_579127
  var valid_579128 = query.getOrDefault("pageToken")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "pageToken", valid_579128
  var valid_579129 = query.getOrDefault("query")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "query", valid_579129
  var valid_579130 = query.getOrDefault("callback")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "callback", valid_579130
  var valid_579131 = query.getOrDefault("fields")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "fields", valid_579131
  var valid_579132 = query.getOrDefault("access_token")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "access_token", valid_579132
  var valid_579133 = query.getOrDefault("upload_protocol")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = nil)
  if valid_579133 != nil:
    section.add "upload_protocol", valid_579133
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579134: Call_ServiceconsumermanagementServicesSearch_579116;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Search tenancy units for a managed service.
  ## 
  let valid = call_579134.validator(path, query, header, formData, body)
  let scheme = call_579134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579134.url(scheme.get, call_579134.host, call_579134.base,
                         call_579134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579134, url, valid)

proc call*(call_579135: Call_ServiceconsumermanagementServicesSearch_579116;
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
  var path_579136 = newJObject()
  var query_579137 = newJObject()
  add(query_579137, "key", newJString(key))
  add(query_579137, "prettyPrint", newJBool(prettyPrint))
  add(query_579137, "oauth_token", newJString(oauthToken))
  add(query_579137, "$.xgafv", newJString(Xgafv))
  add(query_579137, "pageSize", newJInt(pageSize))
  add(query_579137, "alt", newJString(alt))
  add(query_579137, "uploadType", newJString(uploadType))
  add(query_579137, "quotaUser", newJString(quotaUser))
  add(query_579137, "pageToken", newJString(pageToken))
  add(query_579137, "query", newJString(query))
  add(query_579137, "callback", newJString(callback))
  add(path_579136, "parent", newJString(parent))
  add(query_579137, "fields", newJString(fields))
  add(query_579137, "access_token", newJString(accessToken))
  add(query_579137, "upload_protocol", newJString(uploadProtocol))
  result = call_579135.call(path_579136, query_579137, nil, nil, nil)

var serviceconsumermanagementServicesSearch* = Call_ServiceconsumermanagementServicesSearch_579116(
    name: "serviceconsumermanagementServicesSearch", meth: HttpMethod.HttpGet,
    host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{parent}:search",
    validator: validate_ServiceconsumermanagementServicesSearch_579117, base: "/",
    url: url_ServiceconsumermanagementServicesSearch_579118,
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
