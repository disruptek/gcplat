
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

  OpenApiRestCall_579421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579421): Option[Scheme] {.used.} =
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
  gcpServiceName = "serviceconsumermanagement"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServiceconsumermanagementOperationsGet_579690 = ref object of OpenApiRestCall_579421
proc url_ServiceconsumermanagementOperationsGet_579692(protocol: Scheme;
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

proc validate_ServiceconsumermanagementOperationsGet_579691(path: JsonNode;
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
  var valid_579818 = path.getOrDefault("name")
  valid_579818 = validateParameter(valid_579818, JString, required = true,
                                 default = nil)
  if valid_579818 != nil:
    section.add "name", valid_579818
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
  var valid_579819 = query.getOrDefault("upload_protocol")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = nil)
  if valid_579819 != nil:
    section.add "upload_protocol", valid_579819
  var valid_579820 = query.getOrDefault("fields")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "fields", valid_579820
  var valid_579821 = query.getOrDefault("quotaUser")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "quotaUser", valid_579821
  var valid_579835 = query.getOrDefault("alt")
  valid_579835 = validateParameter(valid_579835, JString, required = false,
                                 default = newJString("json"))
  if valid_579835 != nil:
    section.add "alt", valid_579835
  var valid_579836 = query.getOrDefault("oauth_token")
  valid_579836 = validateParameter(valid_579836, JString, required = false,
                                 default = nil)
  if valid_579836 != nil:
    section.add "oauth_token", valid_579836
  var valid_579837 = query.getOrDefault("callback")
  valid_579837 = validateParameter(valid_579837, JString, required = false,
                                 default = nil)
  if valid_579837 != nil:
    section.add "callback", valid_579837
  var valid_579838 = query.getOrDefault("access_token")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = nil)
  if valid_579838 != nil:
    section.add "access_token", valid_579838
  var valid_579839 = query.getOrDefault("uploadType")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "uploadType", valid_579839
  var valid_579840 = query.getOrDefault("key")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = nil)
  if valid_579840 != nil:
    section.add "key", valid_579840
  var valid_579841 = query.getOrDefault("$.xgafv")
  valid_579841 = validateParameter(valid_579841, JString, required = false,
                                 default = newJString("1"))
  if valid_579841 != nil:
    section.add "$.xgafv", valid_579841
  var valid_579842 = query.getOrDefault("prettyPrint")
  valid_579842 = validateParameter(valid_579842, JBool, required = false,
                                 default = newJBool(true))
  if valid_579842 != nil:
    section.add "prettyPrint", valid_579842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579865: Call_ServiceconsumermanagementOperationsGet_579690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_579865.validator(path, query, header, formData, body)
  let scheme = call_579865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579865.url(scheme.get, call_579865.host, call_579865.base,
                         call_579865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579865, url, valid)

proc call*(call_579936: Call_ServiceconsumermanagementOperationsGet_579690;
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
  var path_579937 = newJObject()
  var query_579939 = newJObject()
  add(query_579939, "upload_protocol", newJString(uploadProtocol))
  add(query_579939, "fields", newJString(fields))
  add(query_579939, "quotaUser", newJString(quotaUser))
  add(path_579937, "name", newJString(name))
  add(query_579939, "alt", newJString(alt))
  add(query_579939, "oauth_token", newJString(oauthToken))
  add(query_579939, "callback", newJString(callback))
  add(query_579939, "access_token", newJString(accessToken))
  add(query_579939, "uploadType", newJString(uploadType))
  add(query_579939, "key", newJString(key))
  add(query_579939, "$.xgafv", newJString(Xgafv))
  add(query_579939, "prettyPrint", newJBool(prettyPrint))
  result = call_579936.call(path_579937, query_579939, nil, nil, nil)

var serviceconsumermanagementOperationsGet* = Call_ServiceconsumermanagementOperationsGet_579690(
    name: "serviceconsumermanagementOperationsGet", meth: HttpMethod.HttpGet,
    host: "serviceconsumermanagement.googleapis.com", route: "/v1/{name}",
    validator: validate_ServiceconsumermanagementOperationsGet_579691, base: "/",
    url: url_ServiceconsumermanagementOperationsGet_579692,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementOperationsDelete_579978 = ref object of OpenApiRestCall_579421
proc url_ServiceconsumermanagementOperationsDelete_579980(protocol: Scheme;
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

proc validate_ServiceconsumermanagementOperationsDelete_579979(path: JsonNode;
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
  var valid_579981 = path.getOrDefault("name")
  valid_579981 = validateParameter(valid_579981, JString, required = true,
                                 default = nil)
  if valid_579981 != nil:
    section.add "name", valid_579981
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
  var valid_579982 = query.getOrDefault("upload_protocol")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "upload_protocol", valid_579982
  var valid_579983 = query.getOrDefault("fields")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "fields", valid_579983
  var valid_579984 = query.getOrDefault("quotaUser")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "quotaUser", valid_579984
  var valid_579985 = query.getOrDefault("alt")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = newJString("json"))
  if valid_579985 != nil:
    section.add "alt", valid_579985
  var valid_579986 = query.getOrDefault("oauth_token")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "oauth_token", valid_579986
  var valid_579987 = query.getOrDefault("callback")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "callback", valid_579987
  var valid_579988 = query.getOrDefault("access_token")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "access_token", valid_579988
  var valid_579989 = query.getOrDefault("uploadType")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "uploadType", valid_579989
  var valid_579990 = query.getOrDefault("key")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "key", valid_579990
  var valid_579991 = query.getOrDefault("$.xgafv")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = newJString("1"))
  if valid_579991 != nil:
    section.add "$.xgafv", valid_579991
  var valid_579992 = query.getOrDefault("prettyPrint")
  valid_579992 = validateParameter(valid_579992, JBool, required = false,
                                 default = newJBool(true))
  if valid_579992 != nil:
    section.add "prettyPrint", valid_579992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579993: Call_ServiceconsumermanagementOperationsDelete_579978;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_579993.validator(path, query, header, formData, body)
  let scheme = call_579993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579993.url(scheme.get, call_579993.host, call_579993.base,
                         call_579993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579993, url, valid)

proc call*(call_579994: Call_ServiceconsumermanagementOperationsDelete_579978;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## serviceconsumermanagementOperationsDelete
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
  var path_579995 = newJObject()
  var query_579996 = newJObject()
  add(query_579996, "upload_protocol", newJString(uploadProtocol))
  add(query_579996, "fields", newJString(fields))
  add(query_579996, "quotaUser", newJString(quotaUser))
  add(path_579995, "name", newJString(name))
  add(query_579996, "alt", newJString(alt))
  add(query_579996, "oauth_token", newJString(oauthToken))
  add(query_579996, "callback", newJString(callback))
  add(query_579996, "access_token", newJString(accessToken))
  add(query_579996, "uploadType", newJString(uploadType))
  add(query_579996, "key", newJString(key))
  add(query_579996, "$.xgafv", newJString(Xgafv))
  add(query_579996, "prettyPrint", newJBool(prettyPrint))
  result = call_579994.call(path_579995, query_579996, nil, nil, nil)

var serviceconsumermanagementOperationsDelete* = Call_ServiceconsumermanagementOperationsDelete_579978(
    name: "serviceconsumermanagementOperationsDelete",
    meth: HttpMethod.HttpDelete, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{name}",
    validator: validate_ServiceconsumermanagementOperationsDelete_579979,
    base: "/", url: url_ServiceconsumermanagementOperationsDelete_579980,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_579997 = ref object of OpenApiRestCall_579421
proc url_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_579999(
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

proc validate_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_579998(
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
  var valid_580000 = path.getOrDefault("name")
  valid_580000 = validateParameter(valid_580000, JString, required = true,
                                 default = nil)
  if valid_580000 != nil:
    section.add "name", valid_580000
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
  var valid_580001 = query.getOrDefault("upload_protocol")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "upload_protocol", valid_580001
  var valid_580002 = query.getOrDefault("fields")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "fields", valid_580002
  var valid_580003 = query.getOrDefault("quotaUser")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "quotaUser", valid_580003
  var valid_580004 = query.getOrDefault("alt")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = newJString("json"))
  if valid_580004 != nil:
    section.add "alt", valid_580004
  var valid_580005 = query.getOrDefault("oauth_token")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "oauth_token", valid_580005
  var valid_580006 = query.getOrDefault("callback")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "callback", valid_580006
  var valid_580007 = query.getOrDefault("access_token")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "access_token", valid_580007
  var valid_580008 = query.getOrDefault("uploadType")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "uploadType", valid_580008
  var valid_580009 = query.getOrDefault("key")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "key", valid_580009
  var valid_580010 = query.getOrDefault("$.xgafv")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = newJString("1"))
  if valid_580010 != nil:
    section.add "$.xgafv", valid_580010
  var valid_580011 = query.getOrDefault("prettyPrint")
  valid_580011 = validateParameter(valid_580011, JBool, required = false,
                                 default = newJBool(true))
  if valid_580011 != nil:
    section.add "prettyPrint", valid_580011
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

proc call*(call_580013: Call_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_579997;
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
  let valid = call_580013.validator(path, query, header, formData, body)
  let scheme = call_580013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580013.url(scheme.get, call_580013.host, call_580013.base,
                         call_580013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580013, url, valid)

proc call*(call_580014: Call_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_579997;
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
  var path_580015 = newJObject()
  var query_580016 = newJObject()
  var body_580017 = newJObject()
  add(query_580016, "upload_protocol", newJString(uploadProtocol))
  add(query_580016, "fields", newJString(fields))
  add(query_580016, "quotaUser", newJString(quotaUser))
  add(path_580015, "name", newJString(name))
  add(query_580016, "alt", newJString(alt))
  add(query_580016, "oauth_token", newJString(oauthToken))
  add(query_580016, "callback", newJString(callback))
  add(query_580016, "access_token", newJString(accessToken))
  add(query_580016, "uploadType", newJString(uploadType))
  add(query_580016, "key", newJString(key))
  add(query_580016, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580017 = body
  add(query_580016, "prettyPrint", newJBool(prettyPrint))
  result = call_580014.call(path_580015, query_580016, nil, nil, body_580017)

var serviceconsumermanagementServicesTenancyUnitsApplyProjectConfig* = Call_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_579997(
    name: "serviceconsumermanagementServicesTenancyUnitsApplyProjectConfig",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{name}:applyProjectConfig", validator: validate_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_579998,
    base: "/",
    url: url_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_579999,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsAttachProject_580018 = ref object of OpenApiRestCall_579421
proc url_ServiceconsumermanagementServicesTenancyUnitsAttachProject_580020(
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

proc validate_ServiceconsumermanagementServicesTenancyUnitsAttachProject_580019(
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
  var valid_580021 = path.getOrDefault("name")
  valid_580021 = validateParameter(valid_580021, JString, required = true,
                                 default = nil)
  if valid_580021 != nil:
    section.add "name", valid_580021
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
  var valid_580022 = query.getOrDefault("upload_protocol")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "upload_protocol", valid_580022
  var valid_580023 = query.getOrDefault("fields")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "fields", valid_580023
  var valid_580024 = query.getOrDefault("quotaUser")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "quotaUser", valid_580024
  var valid_580025 = query.getOrDefault("alt")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = newJString("json"))
  if valid_580025 != nil:
    section.add "alt", valid_580025
  var valid_580026 = query.getOrDefault("oauth_token")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "oauth_token", valid_580026
  var valid_580027 = query.getOrDefault("callback")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "callback", valid_580027
  var valid_580028 = query.getOrDefault("access_token")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "access_token", valid_580028
  var valid_580029 = query.getOrDefault("uploadType")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "uploadType", valid_580029
  var valid_580030 = query.getOrDefault("key")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "key", valid_580030
  var valid_580031 = query.getOrDefault("$.xgafv")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = newJString("1"))
  if valid_580031 != nil:
    section.add "$.xgafv", valid_580031
  var valid_580032 = query.getOrDefault("prettyPrint")
  valid_580032 = validateParameter(valid_580032, JBool, required = false,
                                 default = newJBool(true))
  if valid_580032 != nil:
    section.add "prettyPrint", valid_580032
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

proc call*(call_580034: Call_ServiceconsumermanagementServicesTenancyUnitsAttachProject_580018;
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
  let valid = call_580034.validator(path, query, header, formData, body)
  let scheme = call_580034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580034.url(scheme.get, call_580034.host, call_580034.base,
                         call_580034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580034, url, valid)

proc call*(call_580035: Call_ServiceconsumermanagementServicesTenancyUnitsAttachProject_580018;
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
  var path_580036 = newJObject()
  var query_580037 = newJObject()
  var body_580038 = newJObject()
  add(query_580037, "upload_protocol", newJString(uploadProtocol))
  add(query_580037, "fields", newJString(fields))
  add(query_580037, "quotaUser", newJString(quotaUser))
  add(path_580036, "name", newJString(name))
  add(query_580037, "alt", newJString(alt))
  add(query_580037, "oauth_token", newJString(oauthToken))
  add(query_580037, "callback", newJString(callback))
  add(query_580037, "access_token", newJString(accessToken))
  add(query_580037, "uploadType", newJString(uploadType))
  add(query_580037, "key", newJString(key))
  add(query_580037, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580038 = body
  add(query_580037, "prettyPrint", newJBool(prettyPrint))
  result = call_580035.call(path_580036, query_580037, nil, nil, body_580038)

var serviceconsumermanagementServicesTenancyUnitsAttachProject* = Call_ServiceconsumermanagementServicesTenancyUnitsAttachProject_580018(
    name: "serviceconsumermanagementServicesTenancyUnitsAttachProject",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{name}:attachProject", validator: validate_ServiceconsumermanagementServicesTenancyUnitsAttachProject_580019,
    base: "/",
    url: url_ServiceconsumermanagementServicesTenancyUnitsAttachProject_580020,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementOperationsCancel_580039 = ref object of OpenApiRestCall_579421
proc url_ServiceconsumermanagementOperationsCancel_580041(protocol: Scheme;
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

proc validate_ServiceconsumermanagementOperationsCancel_580040(path: JsonNode;
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
  var valid_580042 = path.getOrDefault("name")
  valid_580042 = validateParameter(valid_580042, JString, required = true,
                                 default = nil)
  if valid_580042 != nil:
    section.add "name", valid_580042
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
  var valid_580043 = query.getOrDefault("upload_protocol")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "upload_protocol", valid_580043
  var valid_580044 = query.getOrDefault("fields")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "fields", valid_580044
  var valid_580045 = query.getOrDefault("quotaUser")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "quotaUser", valid_580045
  var valid_580046 = query.getOrDefault("alt")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = newJString("json"))
  if valid_580046 != nil:
    section.add "alt", valid_580046
  var valid_580047 = query.getOrDefault("oauth_token")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "oauth_token", valid_580047
  var valid_580048 = query.getOrDefault("callback")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "callback", valid_580048
  var valid_580049 = query.getOrDefault("access_token")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "access_token", valid_580049
  var valid_580050 = query.getOrDefault("uploadType")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "uploadType", valid_580050
  var valid_580051 = query.getOrDefault("key")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "key", valid_580051
  var valid_580052 = query.getOrDefault("$.xgafv")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = newJString("1"))
  if valid_580052 != nil:
    section.add "$.xgafv", valid_580052
  var valid_580053 = query.getOrDefault("prettyPrint")
  valid_580053 = validateParameter(valid_580053, JBool, required = false,
                                 default = newJBool(true))
  if valid_580053 != nil:
    section.add "prettyPrint", valid_580053
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

proc call*(call_580055: Call_ServiceconsumermanagementOperationsCancel_580039;
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
  let valid = call_580055.validator(path, query, header, formData, body)
  let scheme = call_580055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580055.url(scheme.get, call_580055.host, call_580055.base,
                         call_580055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580055, url, valid)

proc call*(call_580056: Call_ServiceconsumermanagementOperationsCancel_580039;
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
  var path_580057 = newJObject()
  var query_580058 = newJObject()
  var body_580059 = newJObject()
  add(query_580058, "upload_protocol", newJString(uploadProtocol))
  add(query_580058, "fields", newJString(fields))
  add(query_580058, "quotaUser", newJString(quotaUser))
  add(path_580057, "name", newJString(name))
  add(query_580058, "alt", newJString(alt))
  add(query_580058, "oauth_token", newJString(oauthToken))
  add(query_580058, "callback", newJString(callback))
  add(query_580058, "access_token", newJString(accessToken))
  add(query_580058, "uploadType", newJString(uploadType))
  add(query_580058, "key", newJString(key))
  add(query_580058, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580059 = body
  add(query_580058, "prettyPrint", newJBool(prettyPrint))
  result = call_580056.call(path_580057, query_580058, nil, nil, body_580059)

var serviceconsumermanagementOperationsCancel* = Call_ServiceconsumermanagementOperationsCancel_580039(
    name: "serviceconsumermanagementOperationsCancel", meth: HttpMethod.HttpPost,
    host: "serviceconsumermanagement.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_ServiceconsumermanagementOperationsCancel_580040,
    base: "/", url: url_ServiceconsumermanagementOperationsCancel_580041,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_580060 = ref object of OpenApiRestCall_579421
proc url_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_580062(
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

proc validate_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_580061(
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
  var valid_580063 = path.getOrDefault("name")
  valid_580063 = validateParameter(valid_580063, JString, required = true,
                                 default = nil)
  if valid_580063 != nil:
    section.add "name", valid_580063
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
  var valid_580064 = query.getOrDefault("upload_protocol")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "upload_protocol", valid_580064
  var valid_580065 = query.getOrDefault("fields")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "fields", valid_580065
  var valid_580066 = query.getOrDefault("quotaUser")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "quotaUser", valid_580066
  var valid_580067 = query.getOrDefault("alt")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = newJString("json"))
  if valid_580067 != nil:
    section.add "alt", valid_580067
  var valid_580068 = query.getOrDefault("oauth_token")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "oauth_token", valid_580068
  var valid_580069 = query.getOrDefault("callback")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "callback", valid_580069
  var valid_580070 = query.getOrDefault("access_token")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "access_token", valid_580070
  var valid_580071 = query.getOrDefault("uploadType")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "uploadType", valid_580071
  var valid_580072 = query.getOrDefault("key")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "key", valid_580072
  var valid_580073 = query.getOrDefault("$.xgafv")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = newJString("1"))
  if valid_580073 != nil:
    section.add "$.xgafv", valid_580073
  var valid_580074 = query.getOrDefault("prettyPrint")
  valid_580074 = validateParameter(valid_580074, JBool, required = false,
                                 default = newJBool(true))
  if valid_580074 != nil:
    section.add "prettyPrint", valid_580074
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

proc call*(call_580076: Call_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_580060;
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
  let valid = call_580076.validator(path, query, header, formData, body)
  let scheme = call_580076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580076.url(scheme.get, call_580076.host, call_580076.base,
                         call_580076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580076, url, valid)

proc call*(call_580077: Call_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_580060;
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
  var path_580078 = newJObject()
  var query_580079 = newJObject()
  var body_580080 = newJObject()
  add(query_580079, "upload_protocol", newJString(uploadProtocol))
  add(query_580079, "fields", newJString(fields))
  add(query_580079, "quotaUser", newJString(quotaUser))
  add(path_580078, "name", newJString(name))
  add(query_580079, "alt", newJString(alt))
  add(query_580079, "oauth_token", newJString(oauthToken))
  add(query_580079, "callback", newJString(callback))
  add(query_580079, "access_token", newJString(accessToken))
  add(query_580079, "uploadType", newJString(uploadType))
  add(query_580079, "key", newJString(key))
  add(query_580079, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580080 = body
  add(query_580079, "prettyPrint", newJBool(prettyPrint))
  result = call_580077.call(path_580078, query_580079, nil, nil, body_580080)

var serviceconsumermanagementServicesTenancyUnitsDeleteProject* = Call_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_580060(
    name: "serviceconsumermanagementServicesTenancyUnitsDeleteProject",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{name}:deleteProject", validator: validate_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_580061,
    base: "/",
    url: url_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_580062,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_580081 = ref object of OpenApiRestCall_579421
proc url_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_580083(
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

proc validate_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_580082(
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
  var valid_580084 = path.getOrDefault("name")
  valid_580084 = validateParameter(valid_580084, JString, required = true,
                                 default = nil)
  if valid_580084 != nil:
    section.add "name", valid_580084
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
  var valid_580085 = query.getOrDefault("upload_protocol")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "upload_protocol", valid_580085
  var valid_580086 = query.getOrDefault("fields")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "fields", valid_580086
  var valid_580087 = query.getOrDefault("quotaUser")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "quotaUser", valid_580087
  var valid_580088 = query.getOrDefault("alt")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = newJString("json"))
  if valid_580088 != nil:
    section.add "alt", valid_580088
  var valid_580089 = query.getOrDefault("oauth_token")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "oauth_token", valid_580089
  var valid_580090 = query.getOrDefault("callback")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "callback", valid_580090
  var valid_580091 = query.getOrDefault("access_token")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "access_token", valid_580091
  var valid_580092 = query.getOrDefault("uploadType")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "uploadType", valid_580092
  var valid_580093 = query.getOrDefault("key")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "key", valid_580093
  var valid_580094 = query.getOrDefault("$.xgafv")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = newJString("1"))
  if valid_580094 != nil:
    section.add "$.xgafv", valid_580094
  var valid_580095 = query.getOrDefault("prettyPrint")
  valid_580095 = validateParameter(valid_580095, JBool, required = false,
                                 default = newJBool(true))
  if valid_580095 != nil:
    section.add "prettyPrint", valid_580095
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

proc call*(call_580097: Call_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_580081;
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
  let valid = call_580097.validator(path, query, header, formData, body)
  let scheme = call_580097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580097.url(scheme.get, call_580097.host, call_580097.base,
                         call_580097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580097, url, valid)

proc call*(call_580098: Call_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_580081;
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
  var path_580099 = newJObject()
  var query_580100 = newJObject()
  var body_580101 = newJObject()
  add(query_580100, "upload_protocol", newJString(uploadProtocol))
  add(query_580100, "fields", newJString(fields))
  add(query_580100, "quotaUser", newJString(quotaUser))
  add(path_580099, "name", newJString(name))
  add(query_580100, "alt", newJString(alt))
  add(query_580100, "oauth_token", newJString(oauthToken))
  add(query_580100, "callback", newJString(callback))
  add(query_580100, "access_token", newJString(accessToken))
  add(query_580100, "uploadType", newJString(uploadType))
  add(query_580100, "key", newJString(key))
  add(query_580100, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580101 = body
  add(query_580100, "prettyPrint", newJBool(prettyPrint))
  result = call_580098.call(path_580099, query_580100, nil, nil, body_580101)

var serviceconsumermanagementServicesTenancyUnitsRemoveProject* = Call_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_580081(
    name: "serviceconsumermanagementServicesTenancyUnitsRemoveProject",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{name}:removeProject", validator: validate_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_580082,
    base: "/",
    url: url_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_580083,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_580102 = ref object of OpenApiRestCall_579421
proc url_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_580104(
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

proc validate_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_580103(
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
  var valid_580105 = path.getOrDefault("name")
  valid_580105 = validateParameter(valid_580105, JString, required = true,
                                 default = nil)
  if valid_580105 != nil:
    section.add "name", valid_580105
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
  var valid_580106 = query.getOrDefault("upload_protocol")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "upload_protocol", valid_580106
  var valid_580107 = query.getOrDefault("fields")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "fields", valid_580107
  var valid_580108 = query.getOrDefault("quotaUser")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "quotaUser", valid_580108
  var valid_580109 = query.getOrDefault("alt")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = newJString("json"))
  if valid_580109 != nil:
    section.add "alt", valid_580109
  var valid_580110 = query.getOrDefault("oauth_token")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "oauth_token", valid_580110
  var valid_580111 = query.getOrDefault("callback")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "callback", valid_580111
  var valid_580112 = query.getOrDefault("access_token")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "access_token", valid_580112
  var valid_580113 = query.getOrDefault("uploadType")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "uploadType", valid_580113
  var valid_580114 = query.getOrDefault("key")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "key", valid_580114
  var valid_580115 = query.getOrDefault("$.xgafv")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = newJString("1"))
  if valid_580115 != nil:
    section.add "$.xgafv", valid_580115
  var valid_580116 = query.getOrDefault("prettyPrint")
  valid_580116 = validateParameter(valid_580116, JBool, required = false,
                                 default = newJBool(true))
  if valid_580116 != nil:
    section.add "prettyPrint", valid_580116
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

proc call*(call_580118: Call_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_580102;
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
  let valid = call_580118.validator(path, query, header, formData, body)
  let scheme = call_580118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580118.url(scheme.get, call_580118.host, call_580118.base,
                         call_580118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580118, url, valid)

proc call*(call_580119: Call_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_580102;
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
  var path_580120 = newJObject()
  var query_580121 = newJObject()
  var body_580122 = newJObject()
  add(query_580121, "upload_protocol", newJString(uploadProtocol))
  add(query_580121, "fields", newJString(fields))
  add(query_580121, "quotaUser", newJString(quotaUser))
  add(path_580120, "name", newJString(name))
  add(query_580121, "alt", newJString(alt))
  add(query_580121, "oauth_token", newJString(oauthToken))
  add(query_580121, "callback", newJString(callback))
  add(query_580121, "access_token", newJString(accessToken))
  add(query_580121, "uploadType", newJString(uploadType))
  add(query_580121, "key", newJString(key))
  add(query_580121, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580122 = body
  add(query_580121, "prettyPrint", newJBool(prettyPrint))
  result = call_580119.call(path_580120, query_580121, nil, nil, body_580122)

var serviceconsumermanagementServicesTenancyUnitsUndeleteProject* = Call_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_580102(
    name: "serviceconsumermanagementServicesTenancyUnitsUndeleteProject",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{name}:undeleteProject", validator: validate_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_580103,
    base: "/",
    url: url_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_580104,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsCreate_580145 = ref object of OpenApiRestCall_579421
proc url_ServiceconsumermanagementServicesTenancyUnitsCreate_580147(
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

proc validate_ServiceconsumermanagementServicesTenancyUnitsCreate_580146(
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
  var valid_580148 = path.getOrDefault("parent")
  valid_580148 = validateParameter(valid_580148, JString, required = true,
                                 default = nil)
  if valid_580148 != nil:
    section.add "parent", valid_580148
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
  var valid_580149 = query.getOrDefault("upload_protocol")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "upload_protocol", valid_580149
  var valid_580150 = query.getOrDefault("fields")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "fields", valid_580150
  var valid_580151 = query.getOrDefault("quotaUser")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "quotaUser", valid_580151
  var valid_580152 = query.getOrDefault("alt")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = newJString("json"))
  if valid_580152 != nil:
    section.add "alt", valid_580152
  var valid_580153 = query.getOrDefault("oauth_token")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "oauth_token", valid_580153
  var valid_580154 = query.getOrDefault("callback")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "callback", valid_580154
  var valid_580155 = query.getOrDefault("access_token")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "access_token", valid_580155
  var valid_580156 = query.getOrDefault("uploadType")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "uploadType", valid_580156
  var valid_580157 = query.getOrDefault("key")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "key", valid_580157
  var valid_580158 = query.getOrDefault("$.xgafv")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = newJString("1"))
  if valid_580158 != nil:
    section.add "$.xgafv", valid_580158
  var valid_580159 = query.getOrDefault("prettyPrint")
  valid_580159 = validateParameter(valid_580159, JBool, required = false,
                                 default = newJBool(true))
  if valid_580159 != nil:
    section.add "prettyPrint", valid_580159
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

proc call*(call_580161: Call_ServiceconsumermanagementServicesTenancyUnitsCreate_580145;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a tenancy unit with no tenant resources.
  ## If tenancy unit already exists, it will be returned,
  ## however, in this case, returned TenancyUnit does not have tenant_resources
  ## field set and ListTenancyUnit has to be used to get a complete
  ## TenancyUnit with all fields populated.
  ## 
  let valid = call_580161.validator(path, query, header, formData, body)
  let scheme = call_580161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580161.url(scheme.get, call_580161.host, call_580161.base,
                         call_580161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580161, url, valid)

proc call*(call_580162: Call_ServiceconsumermanagementServicesTenancyUnitsCreate_580145;
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
  var path_580163 = newJObject()
  var query_580164 = newJObject()
  var body_580165 = newJObject()
  add(query_580164, "upload_protocol", newJString(uploadProtocol))
  add(query_580164, "fields", newJString(fields))
  add(query_580164, "quotaUser", newJString(quotaUser))
  add(query_580164, "alt", newJString(alt))
  add(query_580164, "oauth_token", newJString(oauthToken))
  add(query_580164, "callback", newJString(callback))
  add(query_580164, "access_token", newJString(accessToken))
  add(query_580164, "uploadType", newJString(uploadType))
  add(path_580163, "parent", newJString(parent))
  add(query_580164, "key", newJString(key))
  add(query_580164, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580165 = body
  add(query_580164, "prettyPrint", newJBool(prettyPrint))
  result = call_580162.call(path_580163, query_580164, nil, nil, body_580165)

var serviceconsumermanagementServicesTenancyUnitsCreate* = Call_ServiceconsumermanagementServicesTenancyUnitsCreate_580145(
    name: "serviceconsumermanagementServicesTenancyUnitsCreate",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{parent}/tenancyUnits",
    validator: validate_ServiceconsumermanagementServicesTenancyUnitsCreate_580146,
    base: "/", url: url_ServiceconsumermanagementServicesTenancyUnitsCreate_580147,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsList_580123 = ref object of OpenApiRestCall_579421
proc url_ServiceconsumermanagementServicesTenancyUnitsList_580125(
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

proc validate_ServiceconsumermanagementServicesTenancyUnitsList_580124(
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
  var valid_580126 = path.getOrDefault("parent")
  valid_580126 = validateParameter(valid_580126, JString, required = true,
                                 default = nil)
  if valid_580126 != nil:
    section.add "parent", valid_580126
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
  var valid_580127 = query.getOrDefault("upload_protocol")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "upload_protocol", valid_580127
  var valid_580128 = query.getOrDefault("fields")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "fields", valid_580128
  var valid_580129 = query.getOrDefault("pageToken")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "pageToken", valid_580129
  var valid_580130 = query.getOrDefault("quotaUser")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "quotaUser", valid_580130
  var valid_580131 = query.getOrDefault("alt")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = newJString("json"))
  if valid_580131 != nil:
    section.add "alt", valid_580131
  var valid_580132 = query.getOrDefault("oauth_token")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "oauth_token", valid_580132
  var valid_580133 = query.getOrDefault("callback")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "callback", valid_580133
  var valid_580134 = query.getOrDefault("access_token")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "access_token", valid_580134
  var valid_580135 = query.getOrDefault("uploadType")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "uploadType", valid_580135
  var valid_580136 = query.getOrDefault("key")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "key", valid_580136
  var valid_580137 = query.getOrDefault("$.xgafv")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = newJString("1"))
  if valid_580137 != nil:
    section.add "$.xgafv", valid_580137
  var valid_580138 = query.getOrDefault("pageSize")
  valid_580138 = validateParameter(valid_580138, JInt, required = false, default = nil)
  if valid_580138 != nil:
    section.add "pageSize", valid_580138
  var valid_580139 = query.getOrDefault("prettyPrint")
  valid_580139 = validateParameter(valid_580139, JBool, required = false,
                                 default = newJBool(true))
  if valid_580139 != nil:
    section.add "prettyPrint", valid_580139
  var valid_580140 = query.getOrDefault("filter")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "filter", valid_580140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580141: Call_ServiceconsumermanagementServicesTenancyUnitsList_580123;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Find the tenancy unit for a managed service and service consumer.
  ## This method shouldn't be used in a service producer's runtime path, for
  ## example to find the tenant project number when creating VMs. Service
  ## producers must persist the tenant project's information after the project
  ## is created.
  ## 
  let valid = call_580141.validator(path, query, header, formData, body)
  let scheme = call_580141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580141.url(scheme.get, call_580141.host, call_580141.base,
                         call_580141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580141, url, valid)

proc call*(call_580142: Call_ServiceconsumermanagementServicesTenancyUnitsList_580123;
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
  var path_580143 = newJObject()
  var query_580144 = newJObject()
  add(query_580144, "upload_protocol", newJString(uploadProtocol))
  add(query_580144, "fields", newJString(fields))
  add(query_580144, "pageToken", newJString(pageToken))
  add(query_580144, "quotaUser", newJString(quotaUser))
  add(query_580144, "alt", newJString(alt))
  add(query_580144, "oauth_token", newJString(oauthToken))
  add(query_580144, "callback", newJString(callback))
  add(query_580144, "access_token", newJString(accessToken))
  add(query_580144, "uploadType", newJString(uploadType))
  add(path_580143, "parent", newJString(parent))
  add(query_580144, "key", newJString(key))
  add(query_580144, "$.xgafv", newJString(Xgafv))
  add(query_580144, "pageSize", newJInt(pageSize))
  add(query_580144, "prettyPrint", newJBool(prettyPrint))
  add(query_580144, "filter", newJString(filter))
  result = call_580142.call(path_580143, query_580144, nil, nil, nil)

var serviceconsumermanagementServicesTenancyUnitsList* = Call_ServiceconsumermanagementServicesTenancyUnitsList_580123(
    name: "serviceconsumermanagementServicesTenancyUnitsList",
    meth: HttpMethod.HttpGet, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{parent}/tenancyUnits",
    validator: validate_ServiceconsumermanagementServicesTenancyUnitsList_580124,
    base: "/", url: url_ServiceconsumermanagementServicesTenancyUnitsList_580125,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsAddProject_580166 = ref object of OpenApiRestCall_579421
proc url_ServiceconsumermanagementServicesTenancyUnitsAddProject_580168(
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

proc validate_ServiceconsumermanagementServicesTenancyUnitsAddProject_580167(
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
  var valid_580169 = path.getOrDefault("parent")
  valid_580169 = validateParameter(valid_580169, JString, required = true,
                                 default = nil)
  if valid_580169 != nil:
    section.add "parent", valid_580169
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
  var valid_580170 = query.getOrDefault("upload_protocol")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "upload_protocol", valid_580170
  var valid_580171 = query.getOrDefault("fields")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "fields", valid_580171
  var valid_580172 = query.getOrDefault("quotaUser")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "quotaUser", valid_580172
  var valid_580173 = query.getOrDefault("alt")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = newJString("json"))
  if valid_580173 != nil:
    section.add "alt", valid_580173
  var valid_580174 = query.getOrDefault("oauth_token")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "oauth_token", valid_580174
  var valid_580175 = query.getOrDefault("callback")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "callback", valid_580175
  var valid_580176 = query.getOrDefault("access_token")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "access_token", valid_580176
  var valid_580177 = query.getOrDefault("uploadType")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "uploadType", valid_580177
  var valid_580178 = query.getOrDefault("key")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "key", valid_580178
  var valid_580179 = query.getOrDefault("$.xgafv")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = newJString("1"))
  if valid_580179 != nil:
    section.add "$.xgafv", valid_580179
  var valid_580180 = query.getOrDefault("prettyPrint")
  valid_580180 = validateParameter(valid_580180, JBool, required = false,
                                 default = newJBool(true))
  if valid_580180 != nil:
    section.add "prettyPrint", valid_580180
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

proc call*(call_580182: Call_ServiceconsumermanagementServicesTenancyUnitsAddProject_580166;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add a new tenant project to the tenancy unit.
  ## There can be a maximum of 512 tenant projects in a tenancy unit.
  ## If there are previously failed `AddTenantProject` calls, you might need to
  ## call `RemoveTenantProject` first to resolve them before you can make
  ## another call to `AddTenantProject` with the same tag.
  ## Operation<response: Empty>.
  ## 
  let valid = call_580182.validator(path, query, header, formData, body)
  let scheme = call_580182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580182.url(scheme.get, call_580182.host, call_580182.base,
                         call_580182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580182, url, valid)

proc call*(call_580183: Call_ServiceconsumermanagementServicesTenancyUnitsAddProject_580166;
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
  var path_580184 = newJObject()
  var query_580185 = newJObject()
  var body_580186 = newJObject()
  add(query_580185, "upload_protocol", newJString(uploadProtocol))
  add(query_580185, "fields", newJString(fields))
  add(query_580185, "quotaUser", newJString(quotaUser))
  add(query_580185, "alt", newJString(alt))
  add(query_580185, "oauth_token", newJString(oauthToken))
  add(query_580185, "callback", newJString(callback))
  add(query_580185, "access_token", newJString(accessToken))
  add(query_580185, "uploadType", newJString(uploadType))
  add(path_580184, "parent", newJString(parent))
  add(query_580185, "key", newJString(key))
  add(query_580185, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580186 = body
  add(query_580185, "prettyPrint", newJBool(prettyPrint))
  result = call_580183.call(path_580184, query_580185, nil, nil, body_580186)

var serviceconsumermanagementServicesTenancyUnitsAddProject* = Call_ServiceconsumermanagementServicesTenancyUnitsAddProject_580166(
    name: "serviceconsumermanagementServicesTenancyUnitsAddProject",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{parent}:addProject", validator: validate_ServiceconsumermanagementServicesTenancyUnitsAddProject_580167,
    base: "/", url: url_ServiceconsumermanagementServicesTenancyUnitsAddProject_580168,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesSearch_580187 = ref object of OpenApiRestCall_579421
proc url_ServiceconsumermanagementServicesSearch_580189(protocol: Scheme;
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

proc validate_ServiceconsumermanagementServicesSearch_580188(path: JsonNode;
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
  var valid_580190 = path.getOrDefault("parent")
  valid_580190 = validateParameter(valid_580190, JString, required = true,
                                 default = nil)
  if valid_580190 != nil:
    section.add "parent", valid_580190
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
  var valid_580191 = query.getOrDefault("upload_protocol")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "upload_protocol", valid_580191
  var valid_580192 = query.getOrDefault("fields")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "fields", valid_580192
  var valid_580193 = query.getOrDefault("pageToken")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "pageToken", valid_580193
  var valid_580194 = query.getOrDefault("quotaUser")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "quotaUser", valid_580194
  var valid_580195 = query.getOrDefault("alt")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = newJString("json"))
  if valid_580195 != nil:
    section.add "alt", valid_580195
  var valid_580196 = query.getOrDefault("query")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "query", valid_580196
  var valid_580197 = query.getOrDefault("oauth_token")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "oauth_token", valid_580197
  var valid_580198 = query.getOrDefault("callback")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "callback", valid_580198
  var valid_580199 = query.getOrDefault("access_token")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "access_token", valid_580199
  var valid_580200 = query.getOrDefault("uploadType")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "uploadType", valid_580200
  var valid_580201 = query.getOrDefault("key")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "key", valid_580201
  var valid_580202 = query.getOrDefault("$.xgafv")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = newJString("1"))
  if valid_580202 != nil:
    section.add "$.xgafv", valid_580202
  var valid_580203 = query.getOrDefault("pageSize")
  valid_580203 = validateParameter(valid_580203, JInt, required = false, default = nil)
  if valid_580203 != nil:
    section.add "pageSize", valid_580203
  var valid_580204 = query.getOrDefault("prettyPrint")
  valid_580204 = validateParameter(valid_580204, JBool, required = false,
                                 default = newJBool(true))
  if valid_580204 != nil:
    section.add "prettyPrint", valid_580204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580205: Call_ServiceconsumermanagementServicesSearch_580187;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Search tenancy units for a managed service.
  ## 
  let valid = call_580205.validator(path, query, header, formData, body)
  let scheme = call_580205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580205.url(scheme.get, call_580205.host, call_580205.base,
                         call_580205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580205, url, valid)

proc call*(call_580206: Call_ServiceconsumermanagementServicesSearch_580187;
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
  var path_580207 = newJObject()
  var query_580208 = newJObject()
  add(query_580208, "upload_protocol", newJString(uploadProtocol))
  add(query_580208, "fields", newJString(fields))
  add(query_580208, "pageToken", newJString(pageToken))
  add(query_580208, "quotaUser", newJString(quotaUser))
  add(query_580208, "alt", newJString(alt))
  add(query_580208, "query", newJString(query))
  add(query_580208, "oauth_token", newJString(oauthToken))
  add(query_580208, "callback", newJString(callback))
  add(query_580208, "access_token", newJString(accessToken))
  add(query_580208, "uploadType", newJString(uploadType))
  add(path_580207, "parent", newJString(parent))
  add(query_580208, "key", newJString(key))
  add(query_580208, "$.xgafv", newJString(Xgafv))
  add(query_580208, "pageSize", newJInt(pageSize))
  add(query_580208, "prettyPrint", newJBool(prettyPrint))
  result = call_580206.call(path_580207, query_580208, nil, nil, nil)

var serviceconsumermanagementServicesSearch* = Call_ServiceconsumermanagementServicesSearch_580187(
    name: "serviceconsumermanagementServicesSearch", meth: HttpMethod.HttpGet,
    host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{parent}:search",
    validator: validate_ServiceconsumermanagementServicesSearch_580188, base: "/",
    url: url_ServiceconsumermanagementServicesSearch_580189,
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
