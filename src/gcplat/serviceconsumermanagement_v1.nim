
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  gcpServiceName = "serviceconsumermanagement"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ServiceconsumermanagementOperationsGet_593690 = ref object of OpenApiRestCall_593421
proc url_ServiceconsumermanagementOperationsGet_593692(protocol: Scheme;
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

proc validate_ServiceconsumermanagementOperationsGet_593691(path: JsonNode;
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

proc call*(call_593865: Call_ServiceconsumermanagementOperationsGet_593690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
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

proc call*(call_593936: Call_ServiceconsumermanagementOperationsGet_593690;
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

var serviceconsumermanagementOperationsGet* = Call_ServiceconsumermanagementOperationsGet_593690(
    name: "serviceconsumermanagementOperationsGet", meth: HttpMethod.HttpGet,
    host: "serviceconsumermanagement.googleapis.com", route: "/v1/{name}",
    validator: validate_ServiceconsumermanagementOperationsGet_593691, base: "/",
    url: url_ServiceconsumermanagementOperationsGet_593692,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementOperationsDelete_593978 = ref object of OpenApiRestCall_593421
proc url_ServiceconsumermanagementOperationsDelete_593980(protocol: Scheme;
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

proc validate_ServiceconsumermanagementOperationsDelete_593979(path: JsonNode;
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

proc call*(call_593993: Call_ServiceconsumermanagementOperationsDelete_593978;
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

proc call*(call_593994: Call_ServiceconsumermanagementOperationsDelete_593978;
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

var serviceconsumermanagementOperationsDelete* = Call_ServiceconsumermanagementOperationsDelete_593978(
    name: "serviceconsumermanagementOperationsDelete",
    meth: HttpMethod.HttpDelete, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{name}",
    validator: validate_ServiceconsumermanagementOperationsDelete_593979,
    base: "/", url: url_ServiceconsumermanagementOperationsDelete_593980,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_593997 = ref object of OpenApiRestCall_593421
proc url_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_593999(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_593998(
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
  var valid_594003 = query.getOrDefault("quotaUser")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = nil)
  if valid_594003 != nil:
    section.add "quotaUser", valid_594003
  var valid_594004 = query.getOrDefault("alt")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = newJString("json"))
  if valid_594004 != nil:
    section.add "alt", valid_594004
  var valid_594005 = query.getOrDefault("oauth_token")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "oauth_token", valid_594005
  var valid_594006 = query.getOrDefault("callback")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "callback", valid_594006
  var valid_594007 = query.getOrDefault("access_token")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "access_token", valid_594007
  var valid_594008 = query.getOrDefault("uploadType")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "uploadType", valid_594008
  var valid_594009 = query.getOrDefault("key")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "key", valid_594009
  var valid_594010 = query.getOrDefault("$.xgafv")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = newJString("1"))
  if valid_594010 != nil:
    section.add "$.xgafv", valid_594010
  var valid_594011 = query.getOrDefault("prettyPrint")
  valid_594011 = validateParameter(valid_594011, JBool, required = false,
                                 default = newJBool(true))
  if valid_594011 != nil:
    section.add "prettyPrint", valid_594011
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

proc call*(call_594013: Call_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_593997;
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
  let valid = call_594013.validator(path, query, header, formData, body)
  let scheme = call_594013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594013.url(scheme.get, call_594013.host, call_594013.base,
                         call_594013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594013, url, valid)

proc call*(call_594014: Call_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_593997;
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
  var path_594015 = newJObject()
  var query_594016 = newJObject()
  var body_594017 = newJObject()
  add(query_594016, "upload_protocol", newJString(uploadProtocol))
  add(query_594016, "fields", newJString(fields))
  add(query_594016, "quotaUser", newJString(quotaUser))
  add(path_594015, "name", newJString(name))
  add(query_594016, "alt", newJString(alt))
  add(query_594016, "oauth_token", newJString(oauthToken))
  add(query_594016, "callback", newJString(callback))
  add(query_594016, "access_token", newJString(accessToken))
  add(query_594016, "uploadType", newJString(uploadType))
  add(query_594016, "key", newJString(key))
  add(query_594016, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594017 = body
  add(query_594016, "prettyPrint", newJBool(prettyPrint))
  result = call_594014.call(path_594015, query_594016, nil, nil, body_594017)

var serviceconsumermanagementServicesTenancyUnitsApplyProjectConfig* = Call_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_593997(
    name: "serviceconsumermanagementServicesTenancyUnitsApplyProjectConfig",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{name}:applyProjectConfig", validator: validate_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_593998,
    base: "/",
    url: url_ServiceconsumermanagementServicesTenancyUnitsApplyProjectConfig_593999,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsAttachProject_594018 = ref object of OpenApiRestCall_593421
proc url_ServiceconsumermanagementServicesTenancyUnitsAttachProject_594020(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServiceconsumermanagementServicesTenancyUnitsAttachProject_594019(
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
  var valid_594021 = path.getOrDefault("name")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "name", valid_594021
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
  var valid_594022 = query.getOrDefault("upload_protocol")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "upload_protocol", valid_594022
  var valid_594023 = query.getOrDefault("fields")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "fields", valid_594023
  var valid_594024 = query.getOrDefault("quotaUser")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "quotaUser", valid_594024
  var valid_594025 = query.getOrDefault("alt")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = newJString("json"))
  if valid_594025 != nil:
    section.add "alt", valid_594025
  var valid_594026 = query.getOrDefault("oauth_token")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "oauth_token", valid_594026
  var valid_594027 = query.getOrDefault("callback")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "callback", valid_594027
  var valid_594028 = query.getOrDefault("access_token")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "access_token", valid_594028
  var valid_594029 = query.getOrDefault("uploadType")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "uploadType", valid_594029
  var valid_594030 = query.getOrDefault("key")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "key", valid_594030
  var valid_594031 = query.getOrDefault("$.xgafv")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = newJString("1"))
  if valid_594031 != nil:
    section.add "$.xgafv", valid_594031
  var valid_594032 = query.getOrDefault("prettyPrint")
  valid_594032 = validateParameter(valid_594032, JBool, required = false,
                                 default = newJBool(true))
  if valid_594032 != nil:
    section.add "prettyPrint", valid_594032
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

proc call*(call_594034: Call_ServiceconsumermanagementServicesTenancyUnitsAttachProject_594018;
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
  let valid = call_594034.validator(path, query, header, formData, body)
  let scheme = call_594034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594034.url(scheme.get, call_594034.host, call_594034.base,
                         call_594034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594034, url, valid)

proc call*(call_594035: Call_ServiceconsumermanagementServicesTenancyUnitsAttachProject_594018;
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
  var path_594036 = newJObject()
  var query_594037 = newJObject()
  var body_594038 = newJObject()
  add(query_594037, "upload_protocol", newJString(uploadProtocol))
  add(query_594037, "fields", newJString(fields))
  add(query_594037, "quotaUser", newJString(quotaUser))
  add(path_594036, "name", newJString(name))
  add(query_594037, "alt", newJString(alt))
  add(query_594037, "oauth_token", newJString(oauthToken))
  add(query_594037, "callback", newJString(callback))
  add(query_594037, "access_token", newJString(accessToken))
  add(query_594037, "uploadType", newJString(uploadType))
  add(query_594037, "key", newJString(key))
  add(query_594037, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594038 = body
  add(query_594037, "prettyPrint", newJBool(prettyPrint))
  result = call_594035.call(path_594036, query_594037, nil, nil, body_594038)

var serviceconsumermanagementServicesTenancyUnitsAttachProject* = Call_ServiceconsumermanagementServicesTenancyUnitsAttachProject_594018(
    name: "serviceconsumermanagementServicesTenancyUnitsAttachProject",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{name}:attachProject", validator: validate_ServiceconsumermanagementServicesTenancyUnitsAttachProject_594019,
    base: "/",
    url: url_ServiceconsumermanagementServicesTenancyUnitsAttachProject_594020,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementOperationsCancel_594039 = ref object of OpenApiRestCall_593421
proc url_ServiceconsumermanagementOperationsCancel_594041(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_ServiceconsumermanagementOperationsCancel_594040(path: JsonNode;
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
  var valid_594042 = path.getOrDefault("name")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "name", valid_594042
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
  var valid_594043 = query.getOrDefault("upload_protocol")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "upload_protocol", valid_594043
  var valid_594044 = query.getOrDefault("fields")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "fields", valid_594044
  var valid_594045 = query.getOrDefault("quotaUser")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = nil)
  if valid_594045 != nil:
    section.add "quotaUser", valid_594045
  var valid_594046 = query.getOrDefault("alt")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = newJString("json"))
  if valid_594046 != nil:
    section.add "alt", valid_594046
  var valid_594047 = query.getOrDefault("oauth_token")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = nil)
  if valid_594047 != nil:
    section.add "oauth_token", valid_594047
  var valid_594048 = query.getOrDefault("callback")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "callback", valid_594048
  var valid_594049 = query.getOrDefault("access_token")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = nil)
  if valid_594049 != nil:
    section.add "access_token", valid_594049
  var valid_594050 = query.getOrDefault("uploadType")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "uploadType", valid_594050
  var valid_594051 = query.getOrDefault("key")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "key", valid_594051
  var valid_594052 = query.getOrDefault("$.xgafv")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = newJString("1"))
  if valid_594052 != nil:
    section.add "$.xgafv", valid_594052
  var valid_594053 = query.getOrDefault("prettyPrint")
  valid_594053 = validateParameter(valid_594053, JBool, required = false,
                                 default = newJBool(true))
  if valid_594053 != nil:
    section.add "prettyPrint", valid_594053
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

proc call*(call_594055: Call_ServiceconsumermanagementOperationsCancel_594039;
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
  let valid = call_594055.validator(path, query, header, formData, body)
  let scheme = call_594055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594055.url(scheme.get, call_594055.host, call_594055.base,
                         call_594055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594055, url, valid)

proc call*(call_594056: Call_ServiceconsumermanagementOperationsCancel_594039;
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
  var path_594057 = newJObject()
  var query_594058 = newJObject()
  var body_594059 = newJObject()
  add(query_594058, "upload_protocol", newJString(uploadProtocol))
  add(query_594058, "fields", newJString(fields))
  add(query_594058, "quotaUser", newJString(quotaUser))
  add(path_594057, "name", newJString(name))
  add(query_594058, "alt", newJString(alt))
  add(query_594058, "oauth_token", newJString(oauthToken))
  add(query_594058, "callback", newJString(callback))
  add(query_594058, "access_token", newJString(accessToken))
  add(query_594058, "uploadType", newJString(uploadType))
  add(query_594058, "key", newJString(key))
  add(query_594058, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594059 = body
  add(query_594058, "prettyPrint", newJBool(prettyPrint))
  result = call_594056.call(path_594057, query_594058, nil, nil, body_594059)

var serviceconsumermanagementOperationsCancel* = Call_ServiceconsumermanagementOperationsCancel_594039(
    name: "serviceconsumermanagementOperationsCancel", meth: HttpMethod.HttpPost,
    host: "serviceconsumermanagement.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_ServiceconsumermanagementOperationsCancel_594040,
    base: "/", url: url_ServiceconsumermanagementOperationsCancel_594041,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_594060 = ref object of OpenApiRestCall_593421
proc url_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_594062(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_594061(
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
  var valid_594063 = path.getOrDefault("name")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "name", valid_594063
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
  var valid_594064 = query.getOrDefault("upload_protocol")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = nil)
  if valid_594064 != nil:
    section.add "upload_protocol", valid_594064
  var valid_594065 = query.getOrDefault("fields")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "fields", valid_594065
  var valid_594066 = query.getOrDefault("quotaUser")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = nil)
  if valid_594066 != nil:
    section.add "quotaUser", valid_594066
  var valid_594067 = query.getOrDefault("alt")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = newJString("json"))
  if valid_594067 != nil:
    section.add "alt", valid_594067
  var valid_594068 = query.getOrDefault("oauth_token")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = nil)
  if valid_594068 != nil:
    section.add "oauth_token", valid_594068
  var valid_594069 = query.getOrDefault("callback")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "callback", valid_594069
  var valid_594070 = query.getOrDefault("access_token")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "access_token", valid_594070
  var valid_594071 = query.getOrDefault("uploadType")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "uploadType", valid_594071
  var valid_594072 = query.getOrDefault("key")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = nil)
  if valid_594072 != nil:
    section.add "key", valid_594072
  var valid_594073 = query.getOrDefault("$.xgafv")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = newJString("1"))
  if valid_594073 != nil:
    section.add "$.xgafv", valid_594073
  var valid_594074 = query.getOrDefault("prettyPrint")
  valid_594074 = validateParameter(valid_594074, JBool, required = false,
                                 default = newJBool(true))
  if valid_594074 != nil:
    section.add "prettyPrint", valid_594074
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

proc call*(call_594076: Call_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_594060;
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
  let valid = call_594076.validator(path, query, header, formData, body)
  let scheme = call_594076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594076.url(scheme.get, call_594076.host, call_594076.base,
                         call_594076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594076, url, valid)

proc call*(call_594077: Call_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_594060;
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
  var path_594078 = newJObject()
  var query_594079 = newJObject()
  var body_594080 = newJObject()
  add(query_594079, "upload_protocol", newJString(uploadProtocol))
  add(query_594079, "fields", newJString(fields))
  add(query_594079, "quotaUser", newJString(quotaUser))
  add(path_594078, "name", newJString(name))
  add(query_594079, "alt", newJString(alt))
  add(query_594079, "oauth_token", newJString(oauthToken))
  add(query_594079, "callback", newJString(callback))
  add(query_594079, "access_token", newJString(accessToken))
  add(query_594079, "uploadType", newJString(uploadType))
  add(query_594079, "key", newJString(key))
  add(query_594079, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594080 = body
  add(query_594079, "prettyPrint", newJBool(prettyPrint))
  result = call_594077.call(path_594078, query_594079, nil, nil, body_594080)

var serviceconsumermanagementServicesTenancyUnitsDeleteProject* = Call_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_594060(
    name: "serviceconsumermanagementServicesTenancyUnitsDeleteProject",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{name}:deleteProject", validator: validate_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_594061,
    base: "/",
    url: url_ServiceconsumermanagementServicesTenancyUnitsDeleteProject_594062,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_594081 = ref object of OpenApiRestCall_593421
proc url_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_594083(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_594082(
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
  var valid_594084 = path.getOrDefault("name")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "name", valid_594084
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
  var valid_594085 = query.getOrDefault("upload_protocol")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "upload_protocol", valid_594085
  var valid_594086 = query.getOrDefault("fields")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "fields", valid_594086
  var valid_594087 = query.getOrDefault("quotaUser")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "quotaUser", valid_594087
  var valid_594088 = query.getOrDefault("alt")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = newJString("json"))
  if valid_594088 != nil:
    section.add "alt", valid_594088
  var valid_594089 = query.getOrDefault("oauth_token")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = nil)
  if valid_594089 != nil:
    section.add "oauth_token", valid_594089
  var valid_594090 = query.getOrDefault("callback")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "callback", valid_594090
  var valid_594091 = query.getOrDefault("access_token")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "access_token", valid_594091
  var valid_594092 = query.getOrDefault("uploadType")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "uploadType", valid_594092
  var valid_594093 = query.getOrDefault("key")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "key", valid_594093
  var valid_594094 = query.getOrDefault("$.xgafv")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = newJString("1"))
  if valid_594094 != nil:
    section.add "$.xgafv", valid_594094
  var valid_594095 = query.getOrDefault("prettyPrint")
  valid_594095 = validateParameter(valid_594095, JBool, required = false,
                                 default = newJBool(true))
  if valid_594095 != nil:
    section.add "prettyPrint", valid_594095
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

proc call*(call_594097: Call_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_594081;
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
  let valid = call_594097.validator(path, query, header, formData, body)
  let scheme = call_594097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594097.url(scheme.get, call_594097.host, call_594097.base,
                         call_594097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594097, url, valid)

proc call*(call_594098: Call_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_594081;
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
  var path_594099 = newJObject()
  var query_594100 = newJObject()
  var body_594101 = newJObject()
  add(query_594100, "upload_protocol", newJString(uploadProtocol))
  add(query_594100, "fields", newJString(fields))
  add(query_594100, "quotaUser", newJString(quotaUser))
  add(path_594099, "name", newJString(name))
  add(query_594100, "alt", newJString(alt))
  add(query_594100, "oauth_token", newJString(oauthToken))
  add(query_594100, "callback", newJString(callback))
  add(query_594100, "access_token", newJString(accessToken))
  add(query_594100, "uploadType", newJString(uploadType))
  add(query_594100, "key", newJString(key))
  add(query_594100, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594101 = body
  add(query_594100, "prettyPrint", newJBool(prettyPrint))
  result = call_594098.call(path_594099, query_594100, nil, nil, body_594101)

var serviceconsumermanagementServicesTenancyUnitsRemoveProject* = Call_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_594081(
    name: "serviceconsumermanagementServicesTenancyUnitsRemoveProject",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{name}:removeProject", validator: validate_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_594082,
    base: "/",
    url: url_ServiceconsumermanagementServicesTenancyUnitsRemoveProject_594083,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_594102 = ref object of OpenApiRestCall_593421
proc url_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_594104(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_594103(
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
  var valid_594105 = path.getOrDefault("name")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "name", valid_594105
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
  var valid_594106 = query.getOrDefault("upload_protocol")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = nil)
  if valid_594106 != nil:
    section.add "upload_protocol", valid_594106
  var valid_594107 = query.getOrDefault("fields")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = nil)
  if valid_594107 != nil:
    section.add "fields", valid_594107
  var valid_594108 = query.getOrDefault("quotaUser")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = nil)
  if valid_594108 != nil:
    section.add "quotaUser", valid_594108
  var valid_594109 = query.getOrDefault("alt")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = newJString("json"))
  if valid_594109 != nil:
    section.add "alt", valid_594109
  var valid_594110 = query.getOrDefault("oauth_token")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = nil)
  if valid_594110 != nil:
    section.add "oauth_token", valid_594110
  var valid_594111 = query.getOrDefault("callback")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = nil)
  if valid_594111 != nil:
    section.add "callback", valid_594111
  var valid_594112 = query.getOrDefault("access_token")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = nil)
  if valid_594112 != nil:
    section.add "access_token", valid_594112
  var valid_594113 = query.getOrDefault("uploadType")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = nil)
  if valid_594113 != nil:
    section.add "uploadType", valid_594113
  var valid_594114 = query.getOrDefault("key")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = nil)
  if valid_594114 != nil:
    section.add "key", valid_594114
  var valid_594115 = query.getOrDefault("$.xgafv")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = newJString("1"))
  if valid_594115 != nil:
    section.add "$.xgafv", valid_594115
  var valid_594116 = query.getOrDefault("prettyPrint")
  valid_594116 = validateParameter(valid_594116, JBool, required = false,
                                 default = newJBool(true))
  if valid_594116 != nil:
    section.add "prettyPrint", valid_594116
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

proc call*(call_594118: Call_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_594102;
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
  let valid = call_594118.validator(path, query, header, formData, body)
  let scheme = call_594118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594118.url(scheme.get, call_594118.host, call_594118.base,
                         call_594118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594118, url, valid)

proc call*(call_594119: Call_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_594102;
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
  var path_594120 = newJObject()
  var query_594121 = newJObject()
  var body_594122 = newJObject()
  add(query_594121, "upload_protocol", newJString(uploadProtocol))
  add(query_594121, "fields", newJString(fields))
  add(query_594121, "quotaUser", newJString(quotaUser))
  add(path_594120, "name", newJString(name))
  add(query_594121, "alt", newJString(alt))
  add(query_594121, "oauth_token", newJString(oauthToken))
  add(query_594121, "callback", newJString(callback))
  add(query_594121, "access_token", newJString(accessToken))
  add(query_594121, "uploadType", newJString(uploadType))
  add(query_594121, "key", newJString(key))
  add(query_594121, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594122 = body
  add(query_594121, "prettyPrint", newJBool(prettyPrint))
  result = call_594119.call(path_594120, query_594121, nil, nil, body_594122)

var serviceconsumermanagementServicesTenancyUnitsUndeleteProject* = Call_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_594102(
    name: "serviceconsumermanagementServicesTenancyUnitsUndeleteProject",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{name}:undeleteProject", validator: validate_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_594103,
    base: "/",
    url: url_ServiceconsumermanagementServicesTenancyUnitsUndeleteProject_594104,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsCreate_594145 = ref object of OpenApiRestCall_593421
proc url_ServiceconsumermanagementServicesTenancyUnitsCreate_594147(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServiceconsumermanagementServicesTenancyUnitsCreate_594146(
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
  var valid_594148 = path.getOrDefault("parent")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "parent", valid_594148
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
  var valid_594149 = query.getOrDefault("upload_protocol")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = nil)
  if valid_594149 != nil:
    section.add "upload_protocol", valid_594149
  var valid_594150 = query.getOrDefault("fields")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = nil)
  if valid_594150 != nil:
    section.add "fields", valid_594150
  var valid_594151 = query.getOrDefault("quotaUser")
  valid_594151 = validateParameter(valid_594151, JString, required = false,
                                 default = nil)
  if valid_594151 != nil:
    section.add "quotaUser", valid_594151
  var valid_594152 = query.getOrDefault("alt")
  valid_594152 = validateParameter(valid_594152, JString, required = false,
                                 default = newJString("json"))
  if valid_594152 != nil:
    section.add "alt", valid_594152
  var valid_594153 = query.getOrDefault("oauth_token")
  valid_594153 = validateParameter(valid_594153, JString, required = false,
                                 default = nil)
  if valid_594153 != nil:
    section.add "oauth_token", valid_594153
  var valid_594154 = query.getOrDefault("callback")
  valid_594154 = validateParameter(valid_594154, JString, required = false,
                                 default = nil)
  if valid_594154 != nil:
    section.add "callback", valid_594154
  var valid_594155 = query.getOrDefault("access_token")
  valid_594155 = validateParameter(valid_594155, JString, required = false,
                                 default = nil)
  if valid_594155 != nil:
    section.add "access_token", valid_594155
  var valid_594156 = query.getOrDefault("uploadType")
  valid_594156 = validateParameter(valid_594156, JString, required = false,
                                 default = nil)
  if valid_594156 != nil:
    section.add "uploadType", valid_594156
  var valid_594157 = query.getOrDefault("key")
  valid_594157 = validateParameter(valid_594157, JString, required = false,
                                 default = nil)
  if valid_594157 != nil:
    section.add "key", valid_594157
  var valid_594158 = query.getOrDefault("$.xgafv")
  valid_594158 = validateParameter(valid_594158, JString, required = false,
                                 default = newJString("1"))
  if valid_594158 != nil:
    section.add "$.xgafv", valid_594158
  var valid_594159 = query.getOrDefault("prettyPrint")
  valid_594159 = validateParameter(valid_594159, JBool, required = false,
                                 default = newJBool(true))
  if valid_594159 != nil:
    section.add "prettyPrint", valid_594159
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

proc call*(call_594161: Call_ServiceconsumermanagementServicesTenancyUnitsCreate_594145;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a tenancy unit with no tenant resources.
  ## If tenancy unit already exists, it will be returned,
  ## however, in this case, returned TenancyUnit does not have tenant_resources
  ## field set and ListTenancyUnit has to be used to get a complete
  ## TenancyUnit with all fields populated.
  ## 
  let valid = call_594161.validator(path, query, header, formData, body)
  let scheme = call_594161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594161.url(scheme.get, call_594161.host, call_594161.base,
                         call_594161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594161, url, valid)

proc call*(call_594162: Call_ServiceconsumermanagementServicesTenancyUnitsCreate_594145;
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
  var path_594163 = newJObject()
  var query_594164 = newJObject()
  var body_594165 = newJObject()
  add(query_594164, "upload_protocol", newJString(uploadProtocol))
  add(query_594164, "fields", newJString(fields))
  add(query_594164, "quotaUser", newJString(quotaUser))
  add(query_594164, "alt", newJString(alt))
  add(query_594164, "oauth_token", newJString(oauthToken))
  add(query_594164, "callback", newJString(callback))
  add(query_594164, "access_token", newJString(accessToken))
  add(query_594164, "uploadType", newJString(uploadType))
  add(path_594163, "parent", newJString(parent))
  add(query_594164, "key", newJString(key))
  add(query_594164, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594165 = body
  add(query_594164, "prettyPrint", newJBool(prettyPrint))
  result = call_594162.call(path_594163, query_594164, nil, nil, body_594165)

var serviceconsumermanagementServicesTenancyUnitsCreate* = Call_ServiceconsumermanagementServicesTenancyUnitsCreate_594145(
    name: "serviceconsumermanagementServicesTenancyUnitsCreate",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{parent}/tenancyUnits",
    validator: validate_ServiceconsumermanagementServicesTenancyUnitsCreate_594146,
    base: "/", url: url_ServiceconsumermanagementServicesTenancyUnitsCreate_594147,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsList_594123 = ref object of OpenApiRestCall_593421
proc url_ServiceconsumermanagementServicesTenancyUnitsList_594125(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServiceconsumermanagementServicesTenancyUnitsList_594124(
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
  var valid_594126 = path.getOrDefault("parent")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "parent", valid_594126
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
  var valid_594127 = query.getOrDefault("upload_protocol")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "upload_protocol", valid_594127
  var valid_594128 = query.getOrDefault("fields")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = nil)
  if valid_594128 != nil:
    section.add "fields", valid_594128
  var valid_594129 = query.getOrDefault("pageToken")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = nil)
  if valid_594129 != nil:
    section.add "pageToken", valid_594129
  var valid_594130 = query.getOrDefault("quotaUser")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = nil)
  if valid_594130 != nil:
    section.add "quotaUser", valid_594130
  var valid_594131 = query.getOrDefault("alt")
  valid_594131 = validateParameter(valid_594131, JString, required = false,
                                 default = newJString("json"))
  if valid_594131 != nil:
    section.add "alt", valid_594131
  var valid_594132 = query.getOrDefault("oauth_token")
  valid_594132 = validateParameter(valid_594132, JString, required = false,
                                 default = nil)
  if valid_594132 != nil:
    section.add "oauth_token", valid_594132
  var valid_594133 = query.getOrDefault("callback")
  valid_594133 = validateParameter(valid_594133, JString, required = false,
                                 default = nil)
  if valid_594133 != nil:
    section.add "callback", valid_594133
  var valid_594134 = query.getOrDefault("access_token")
  valid_594134 = validateParameter(valid_594134, JString, required = false,
                                 default = nil)
  if valid_594134 != nil:
    section.add "access_token", valid_594134
  var valid_594135 = query.getOrDefault("uploadType")
  valid_594135 = validateParameter(valid_594135, JString, required = false,
                                 default = nil)
  if valid_594135 != nil:
    section.add "uploadType", valid_594135
  var valid_594136 = query.getOrDefault("key")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = nil)
  if valid_594136 != nil:
    section.add "key", valid_594136
  var valid_594137 = query.getOrDefault("$.xgafv")
  valid_594137 = validateParameter(valid_594137, JString, required = false,
                                 default = newJString("1"))
  if valid_594137 != nil:
    section.add "$.xgafv", valid_594137
  var valid_594138 = query.getOrDefault("pageSize")
  valid_594138 = validateParameter(valid_594138, JInt, required = false, default = nil)
  if valid_594138 != nil:
    section.add "pageSize", valid_594138
  var valid_594139 = query.getOrDefault("prettyPrint")
  valid_594139 = validateParameter(valid_594139, JBool, required = false,
                                 default = newJBool(true))
  if valid_594139 != nil:
    section.add "prettyPrint", valid_594139
  var valid_594140 = query.getOrDefault("filter")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = nil)
  if valid_594140 != nil:
    section.add "filter", valid_594140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594141: Call_ServiceconsumermanagementServicesTenancyUnitsList_594123;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Find the tenancy unit for a managed service and service consumer.
  ## This method shouldn't be used in a service producer's runtime path, for
  ## example to find the tenant project number when creating VMs. Service
  ## producers must persist the tenant project's information after the project
  ## is created.
  ## 
  let valid = call_594141.validator(path, query, header, formData, body)
  let scheme = call_594141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594141.url(scheme.get, call_594141.host, call_594141.base,
                         call_594141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594141, url, valid)

proc call*(call_594142: Call_ServiceconsumermanagementServicesTenancyUnitsList_594123;
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
  var path_594143 = newJObject()
  var query_594144 = newJObject()
  add(query_594144, "upload_protocol", newJString(uploadProtocol))
  add(query_594144, "fields", newJString(fields))
  add(query_594144, "pageToken", newJString(pageToken))
  add(query_594144, "quotaUser", newJString(quotaUser))
  add(query_594144, "alt", newJString(alt))
  add(query_594144, "oauth_token", newJString(oauthToken))
  add(query_594144, "callback", newJString(callback))
  add(query_594144, "access_token", newJString(accessToken))
  add(query_594144, "uploadType", newJString(uploadType))
  add(path_594143, "parent", newJString(parent))
  add(query_594144, "key", newJString(key))
  add(query_594144, "$.xgafv", newJString(Xgafv))
  add(query_594144, "pageSize", newJInt(pageSize))
  add(query_594144, "prettyPrint", newJBool(prettyPrint))
  add(query_594144, "filter", newJString(filter))
  result = call_594142.call(path_594143, query_594144, nil, nil, nil)

var serviceconsumermanagementServicesTenancyUnitsList* = Call_ServiceconsumermanagementServicesTenancyUnitsList_594123(
    name: "serviceconsumermanagementServicesTenancyUnitsList",
    meth: HttpMethod.HttpGet, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{parent}/tenancyUnits",
    validator: validate_ServiceconsumermanagementServicesTenancyUnitsList_594124,
    base: "/", url: url_ServiceconsumermanagementServicesTenancyUnitsList_594125,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesTenancyUnitsAddProject_594166 = ref object of OpenApiRestCall_593421
proc url_ServiceconsumermanagementServicesTenancyUnitsAddProject_594168(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServiceconsumermanagementServicesTenancyUnitsAddProject_594167(
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
  var valid_594169 = path.getOrDefault("parent")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = nil)
  if valid_594169 != nil:
    section.add "parent", valid_594169
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
  var valid_594170 = query.getOrDefault("upload_protocol")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = nil)
  if valid_594170 != nil:
    section.add "upload_protocol", valid_594170
  var valid_594171 = query.getOrDefault("fields")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = nil)
  if valid_594171 != nil:
    section.add "fields", valid_594171
  var valid_594172 = query.getOrDefault("quotaUser")
  valid_594172 = validateParameter(valid_594172, JString, required = false,
                                 default = nil)
  if valid_594172 != nil:
    section.add "quotaUser", valid_594172
  var valid_594173 = query.getOrDefault("alt")
  valid_594173 = validateParameter(valid_594173, JString, required = false,
                                 default = newJString("json"))
  if valid_594173 != nil:
    section.add "alt", valid_594173
  var valid_594174 = query.getOrDefault("oauth_token")
  valid_594174 = validateParameter(valid_594174, JString, required = false,
                                 default = nil)
  if valid_594174 != nil:
    section.add "oauth_token", valid_594174
  var valid_594175 = query.getOrDefault("callback")
  valid_594175 = validateParameter(valid_594175, JString, required = false,
                                 default = nil)
  if valid_594175 != nil:
    section.add "callback", valid_594175
  var valid_594176 = query.getOrDefault("access_token")
  valid_594176 = validateParameter(valid_594176, JString, required = false,
                                 default = nil)
  if valid_594176 != nil:
    section.add "access_token", valid_594176
  var valid_594177 = query.getOrDefault("uploadType")
  valid_594177 = validateParameter(valid_594177, JString, required = false,
                                 default = nil)
  if valid_594177 != nil:
    section.add "uploadType", valid_594177
  var valid_594178 = query.getOrDefault("key")
  valid_594178 = validateParameter(valid_594178, JString, required = false,
                                 default = nil)
  if valid_594178 != nil:
    section.add "key", valid_594178
  var valid_594179 = query.getOrDefault("$.xgafv")
  valid_594179 = validateParameter(valid_594179, JString, required = false,
                                 default = newJString("1"))
  if valid_594179 != nil:
    section.add "$.xgafv", valid_594179
  var valid_594180 = query.getOrDefault("prettyPrint")
  valid_594180 = validateParameter(valid_594180, JBool, required = false,
                                 default = newJBool(true))
  if valid_594180 != nil:
    section.add "prettyPrint", valid_594180
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

proc call*(call_594182: Call_ServiceconsumermanagementServicesTenancyUnitsAddProject_594166;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add a new tenant project to the tenancy unit.
  ## There can be a maximum of 512 tenant projects in a tenancy unit.
  ## If there are previously failed `AddTenantProject` calls, you might need to
  ## call `RemoveTenantProject` first to resolve them before you can make
  ## another call to `AddTenantProject` with the same tag.
  ## Operation<response: Empty>.
  ## 
  let valid = call_594182.validator(path, query, header, formData, body)
  let scheme = call_594182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594182.url(scheme.get, call_594182.host, call_594182.base,
                         call_594182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594182, url, valid)

proc call*(call_594183: Call_ServiceconsumermanagementServicesTenancyUnitsAddProject_594166;
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
  var path_594184 = newJObject()
  var query_594185 = newJObject()
  var body_594186 = newJObject()
  add(query_594185, "upload_protocol", newJString(uploadProtocol))
  add(query_594185, "fields", newJString(fields))
  add(query_594185, "quotaUser", newJString(quotaUser))
  add(query_594185, "alt", newJString(alt))
  add(query_594185, "oauth_token", newJString(oauthToken))
  add(query_594185, "callback", newJString(callback))
  add(query_594185, "access_token", newJString(accessToken))
  add(query_594185, "uploadType", newJString(uploadType))
  add(path_594184, "parent", newJString(parent))
  add(query_594185, "key", newJString(key))
  add(query_594185, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594186 = body
  add(query_594185, "prettyPrint", newJBool(prettyPrint))
  result = call_594183.call(path_594184, query_594185, nil, nil, body_594186)

var serviceconsumermanagementServicesTenancyUnitsAddProject* = Call_ServiceconsumermanagementServicesTenancyUnitsAddProject_594166(
    name: "serviceconsumermanagementServicesTenancyUnitsAddProject",
    meth: HttpMethod.HttpPost, host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{parent}:addProject", validator: validate_ServiceconsumermanagementServicesTenancyUnitsAddProject_594167,
    base: "/", url: url_ServiceconsumermanagementServicesTenancyUnitsAddProject_594168,
    schemes: {Scheme.Https})
type
  Call_ServiceconsumermanagementServicesSearch_594187 = ref object of OpenApiRestCall_593421
proc url_ServiceconsumermanagementServicesSearch_594189(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ServiceconsumermanagementServicesSearch_594188(path: JsonNode;
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
  var valid_594190 = path.getOrDefault("parent")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "parent", valid_594190
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
  var valid_594191 = query.getOrDefault("upload_protocol")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = nil)
  if valid_594191 != nil:
    section.add "upload_protocol", valid_594191
  var valid_594192 = query.getOrDefault("fields")
  valid_594192 = validateParameter(valid_594192, JString, required = false,
                                 default = nil)
  if valid_594192 != nil:
    section.add "fields", valid_594192
  var valid_594193 = query.getOrDefault("pageToken")
  valid_594193 = validateParameter(valid_594193, JString, required = false,
                                 default = nil)
  if valid_594193 != nil:
    section.add "pageToken", valid_594193
  var valid_594194 = query.getOrDefault("quotaUser")
  valid_594194 = validateParameter(valid_594194, JString, required = false,
                                 default = nil)
  if valid_594194 != nil:
    section.add "quotaUser", valid_594194
  var valid_594195 = query.getOrDefault("alt")
  valid_594195 = validateParameter(valid_594195, JString, required = false,
                                 default = newJString("json"))
  if valid_594195 != nil:
    section.add "alt", valid_594195
  var valid_594196 = query.getOrDefault("query")
  valid_594196 = validateParameter(valid_594196, JString, required = false,
                                 default = nil)
  if valid_594196 != nil:
    section.add "query", valid_594196
  var valid_594197 = query.getOrDefault("oauth_token")
  valid_594197 = validateParameter(valid_594197, JString, required = false,
                                 default = nil)
  if valid_594197 != nil:
    section.add "oauth_token", valid_594197
  var valid_594198 = query.getOrDefault("callback")
  valid_594198 = validateParameter(valid_594198, JString, required = false,
                                 default = nil)
  if valid_594198 != nil:
    section.add "callback", valid_594198
  var valid_594199 = query.getOrDefault("access_token")
  valid_594199 = validateParameter(valid_594199, JString, required = false,
                                 default = nil)
  if valid_594199 != nil:
    section.add "access_token", valid_594199
  var valid_594200 = query.getOrDefault("uploadType")
  valid_594200 = validateParameter(valid_594200, JString, required = false,
                                 default = nil)
  if valid_594200 != nil:
    section.add "uploadType", valid_594200
  var valid_594201 = query.getOrDefault("key")
  valid_594201 = validateParameter(valid_594201, JString, required = false,
                                 default = nil)
  if valid_594201 != nil:
    section.add "key", valid_594201
  var valid_594202 = query.getOrDefault("$.xgafv")
  valid_594202 = validateParameter(valid_594202, JString, required = false,
                                 default = newJString("1"))
  if valid_594202 != nil:
    section.add "$.xgafv", valid_594202
  var valid_594203 = query.getOrDefault("pageSize")
  valid_594203 = validateParameter(valid_594203, JInt, required = false, default = nil)
  if valid_594203 != nil:
    section.add "pageSize", valid_594203
  var valid_594204 = query.getOrDefault("prettyPrint")
  valid_594204 = validateParameter(valid_594204, JBool, required = false,
                                 default = newJBool(true))
  if valid_594204 != nil:
    section.add "prettyPrint", valid_594204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594205: Call_ServiceconsumermanagementServicesSearch_594187;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Search tenancy units for a managed service.
  ## 
  let valid = call_594205.validator(path, query, header, formData, body)
  let scheme = call_594205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594205.url(scheme.get, call_594205.host, call_594205.base,
                         call_594205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594205, url, valid)

proc call*(call_594206: Call_ServiceconsumermanagementServicesSearch_594187;
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
  var path_594207 = newJObject()
  var query_594208 = newJObject()
  add(query_594208, "upload_protocol", newJString(uploadProtocol))
  add(query_594208, "fields", newJString(fields))
  add(query_594208, "pageToken", newJString(pageToken))
  add(query_594208, "quotaUser", newJString(quotaUser))
  add(query_594208, "alt", newJString(alt))
  add(query_594208, "query", newJString(query))
  add(query_594208, "oauth_token", newJString(oauthToken))
  add(query_594208, "callback", newJString(callback))
  add(query_594208, "access_token", newJString(accessToken))
  add(query_594208, "uploadType", newJString(uploadType))
  add(path_594207, "parent", newJString(parent))
  add(query_594208, "key", newJString(key))
  add(query_594208, "$.xgafv", newJString(Xgafv))
  add(query_594208, "pageSize", newJInt(pageSize))
  add(query_594208, "prettyPrint", newJBool(prettyPrint))
  result = call_594206.call(path_594207, query_594208, nil, nil, nil)

var serviceconsumermanagementServicesSearch* = Call_ServiceconsumermanagementServicesSearch_594187(
    name: "serviceconsumermanagementServicesSearch", meth: HttpMethod.HttpGet,
    host: "serviceconsumermanagement.googleapis.com",
    route: "/v1/{parent}:search",
    validator: validate_ServiceconsumermanagementServicesSearch_594188, base: "/",
    url: url_ServiceconsumermanagementServicesSearch_594189,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
