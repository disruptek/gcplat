
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Security Command Center
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Cloud Security Command Center API provides access to temporal views of assets and findings within an organization.
## 
## https://console.cloud.google.com/apis/api/securitycenter.googleapis.com/overview
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
  gcpServiceName = "securitycenter"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SecuritycenterOrganizationsOperationsGet_579677 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsOperationsGet_579679(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_SecuritycenterOrganizationsOperationsGet_579678(path: JsonNode;
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
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
  var valid_579829 = query.getOrDefault("prettyPrint")
  valid_579829 = validateParameter(valid_579829, JBool, required = false,
                                 default = newJBool(true))
  if valid_579829 != nil:
    section.add "prettyPrint", valid_579829
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579852: Call_SecuritycenterOrganizationsOperationsGet_579677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_579852.validator(path, query, header, formData, body)
  let scheme = call_579852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579852.url(scheme.get, call_579852.host, call_579852.base,
                         call_579852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579852, url, valid)

proc call*(call_579923: Call_SecuritycenterOrganizationsOperationsGet_579677;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## securitycenterOrganizationsOperationsGet
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
  var path_579924 = newJObject()
  var query_579926 = newJObject()
  add(query_579926, "upload_protocol", newJString(uploadProtocol))
  add(query_579926, "fields", newJString(fields))
  add(query_579926, "quotaUser", newJString(quotaUser))
  add(path_579924, "name", newJString(name))
  add(query_579926, "alt", newJString(alt))
  add(query_579926, "oauth_token", newJString(oauthToken))
  add(query_579926, "callback", newJString(callback))
  add(query_579926, "access_token", newJString(accessToken))
  add(query_579926, "uploadType", newJString(uploadType))
  add(query_579926, "key", newJString(key))
  add(query_579926, "$.xgafv", newJString(Xgafv))
  add(query_579926, "prettyPrint", newJBool(prettyPrint))
  result = call_579923.call(path_579924, query_579926, nil, nil, nil)

var securitycenterOrganizationsOperationsGet* = Call_SecuritycenterOrganizationsOperationsGet_579677(
    name: "securitycenterOrganizationsOperationsGet", meth: HttpMethod.HttpGet,
    host: "securitycenter.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_SecuritycenterOrganizationsOperationsGet_579678,
    base: "/", url: url_SecuritycenterOrganizationsOperationsGet_579679,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesFindingsUpdateSecurityMarks_579984 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsSourcesFindingsUpdateSecurityMarks_579986(
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

proc validate_SecuritycenterOrganizationsSourcesFindingsUpdateSecurityMarks_579985(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates security marks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The relative resource name of the SecurityMarks. See:
  ## https://cloud.google.com/apis/design/resource_names#relative_resource_name
  ## Examples:
  ## "organizations/123/assets/456/securityMarks"
  ## "organizations/123/sources/456/findings/789/securityMarks".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579987 = path.getOrDefault("name")
  valid_579987 = validateParameter(valid_579987, JString, required = true,
                                 default = nil)
  if valid_579987 != nil:
    section.add "name", valid_579987
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
  ##   startTime: JString
  ##            : The time at which the updated SecurityMarks take effect.
  ##   updateMask: JString
  ##             : The FieldMask to use when updating the security marks resource.
  section = newJObject()
  var valid_579988 = query.getOrDefault("upload_protocol")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "upload_protocol", valid_579988
  var valid_579989 = query.getOrDefault("fields")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "fields", valid_579989
  var valid_579990 = query.getOrDefault("quotaUser")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "quotaUser", valid_579990
  var valid_579991 = query.getOrDefault("alt")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = newJString("json"))
  if valid_579991 != nil:
    section.add "alt", valid_579991
  var valid_579992 = query.getOrDefault("oauth_token")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "oauth_token", valid_579992
  var valid_579993 = query.getOrDefault("callback")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "callback", valid_579993
  var valid_579994 = query.getOrDefault("access_token")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "access_token", valid_579994
  var valid_579995 = query.getOrDefault("uploadType")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "uploadType", valid_579995
  var valid_579996 = query.getOrDefault("key")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "key", valid_579996
  var valid_579997 = query.getOrDefault("$.xgafv")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = newJString("1"))
  if valid_579997 != nil:
    section.add "$.xgafv", valid_579997
  var valid_579998 = query.getOrDefault("prettyPrint")
  valid_579998 = validateParameter(valid_579998, JBool, required = false,
                                 default = newJBool(true))
  if valid_579998 != nil:
    section.add "prettyPrint", valid_579998
  var valid_579999 = query.getOrDefault("startTime")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "startTime", valid_579999
  var valid_580000 = query.getOrDefault("updateMask")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "updateMask", valid_580000
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

proc call*(call_580002: Call_SecuritycenterOrganizationsSourcesFindingsUpdateSecurityMarks_579984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates security marks.
  ## 
  let valid = call_580002.validator(path, query, header, formData, body)
  let scheme = call_580002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580002.url(scheme.get, call_580002.host, call_580002.base,
                         call_580002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580002, url, valid)

proc call*(call_580003: Call_SecuritycenterOrganizationsSourcesFindingsUpdateSecurityMarks_579984;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; startTime: string = ""; updateMask: string = ""): Recallable =
  ## securitycenterOrganizationsSourcesFindingsUpdateSecurityMarks
  ## Updates security marks.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The relative resource name of the SecurityMarks. See:
  ## https://cloud.google.com/apis/design/resource_names#relative_resource_name
  ## Examples:
  ## "organizations/123/assets/456/securityMarks"
  ## "organizations/123/sources/456/findings/789/securityMarks".
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
  ##   startTime: string
  ##            : The time at which the updated SecurityMarks take effect.
  ##   updateMask: string
  ##             : The FieldMask to use when updating the security marks resource.
  var path_580004 = newJObject()
  var query_580005 = newJObject()
  var body_580006 = newJObject()
  add(query_580005, "upload_protocol", newJString(uploadProtocol))
  add(query_580005, "fields", newJString(fields))
  add(query_580005, "quotaUser", newJString(quotaUser))
  add(path_580004, "name", newJString(name))
  add(query_580005, "alt", newJString(alt))
  add(query_580005, "oauth_token", newJString(oauthToken))
  add(query_580005, "callback", newJString(callback))
  add(query_580005, "access_token", newJString(accessToken))
  add(query_580005, "uploadType", newJString(uploadType))
  add(query_580005, "key", newJString(key))
  add(query_580005, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580006 = body
  add(query_580005, "prettyPrint", newJBool(prettyPrint))
  add(query_580005, "startTime", newJString(startTime))
  add(query_580005, "updateMask", newJString(updateMask))
  result = call_580003.call(path_580004, query_580005, nil, nil, body_580006)

var securitycenterOrganizationsSourcesFindingsUpdateSecurityMarks* = Call_SecuritycenterOrganizationsSourcesFindingsUpdateSecurityMarks_579984(
    name: "securitycenterOrganizationsSourcesFindingsUpdateSecurityMarks",
    meth: HttpMethod.HttpPatch, host: "securitycenter.googleapis.com",
    route: "/v1beta1/{name}", validator: validate_SecuritycenterOrganizationsSourcesFindingsUpdateSecurityMarks_579985,
    base: "/",
    url: url_SecuritycenterOrganizationsSourcesFindingsUpdateSecurityMarks_579986,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsOperationsDelete_579965 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsOperationsDelete_579967(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_SecuritycenterOrganizationsOperationsDelete_579966(path: JsonNode;
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
  var valid_579968 = path.getOrDefault("name")
  valid_579968 = validateParameter(valid_579968, JString, required = true,
                                 default = nil)
  if valid_579968 != nil:
    section.add "name", valid_579968
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
  var valid_579969 = query.getOrDefault("upload_protocol")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "upload_protocol", valid_579969
  var valid_579970 = query.getOrDefault("fields")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "fields", valid_579970
  var valid_579971 = query.getOrDefault("quotaUser")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "quotaUser", valid_579971
  var valid_579972 = query.getOrDefault("alt")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = newJString("json"))
  if valid_579972 != nil:
    section.add "alt", valid_579972
  var valid_579973 = query.getOrDefault("oauth_token")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "oauth_token", valid_579973
  var valid_579974 = query.getOrDefault("callback")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "callback", valid_579974
  var valid_579975 = query.getOrDefault("access_token")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "access_token", valid_579975
  var valid_579976 = query.getOrDefault("uploadType")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "uploadType", valid_579976
  var valid_579977 = query.getOrDefault("key")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "key", valid_579977
  var valid_579978 = query.getOrDefault("$.xgafv")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = newJString("1"))
  if valid_579978 != nil:
    section.add "$.xgafv", valid_579978
  var valid_579979 = query.getOrDefault("prettyPrint")
  valid_579979 = validateParameter(valid_579979, JBool, required = false,
                                 default = newJBool(true))
  if valid_579979 != nil:
    section.add "prettyPrint", valid_579979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579980: Call_SecuritycenterOrganizationsOperationsDelete_579965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_579980.validator(path, query, header, formData, body)
  let scheme = call_579980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579980.url(scheme.get, call_579980.host, call_579980.base,
                         call_579980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579980, url, valid)

proc call*(call_579981: Call_SecuritycenterOrganizationsOperationsDelete_579965;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## securitycenterOrganizationsOperationsDelete
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
  var path_579982 = newJObject()
  var query_579983 = newJObject()
  add(query_579983, "upload_protocol", newJString(uploadProtocol))
  add(query_579983, "fields", newJString(fields))
  add(query_579983, "quotaUser", newJString(quotaUser))
  add(path_579982, "name", newJString(name))
  add(query_579983, "alt", newJString(alt))
  add(query_579983, "oauth_token", newJString(oauthToken))
  add(query_579983, "callback", newJString(callback))
  add(query_579983, "access_token", newJString(accessToken))
  add(query_579983, "uploadType", newJString(uploadType))
  add(query_579983, "key", newJString(key))
  add(query_579983, "$.xgafv", newJString(Xgafv))
  add(query_579983, "prettyPrint", newJBool(prettyPrint))
  result = call_579981.call(path_579982, query_579983, nil, nil, nil)

var securitycenterOrganizationsOperationsDelete* = Call_SecuritycenterOrganizationsOperationsDelete_579965(
    name: "securitycenterOrganizationsOperationsDelete",
    meth: HttpMethod.HttpDelete, host: "securitycenter.googleapis.com",
    route: "/v1beta1/{name}",
    validator: validate_SecuritycenterOrganizationsOperationsDelete_579966,
    base: "/", url: url_SecuritycenterOrganizationsOperationsDelete_579967,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsOperationsCancel_580007 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsOperationsCancel_580009(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsOperationsCancel_580008(path: JsonNode;
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
  var valid_580010 = path.getOrDefault("name")
  valid_580010 = validateParameter(valid_580010, JString, required = true,
                                 default = nil)
  if valid_580010 != nil:
    section.add "name", valid_580010
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
  var valid_580011 = query.getOrDefault("upload_protocol")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "upload_protocol", valid_580011
  var valid_580012 = query.getOrDefault("fields")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "fields", valid_580012
  var valid_580013 = query.getOrDefault("quotaUser")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "quotaUser", valid_580013
  var valid_580014 = query.getOrDefault("alt")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = newJString("json"))
  if valid_580014 != nil:
    section.add "alt", valid_580014
  var valid_580015 = query.getOrDefault("oauth_token")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "oauth_token", valid_580015
  var valid_580016 = query.getOrDefault("callback")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "callback", valid_580016
  var valid_580017 = query.getOrDefault("access_token")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "access_token", valid_580017
  var valid_580018 = query.getOrDefault("uploadType")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "uploadType", valid_580018
  var valid_580019 = query.getOrDefault("key")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "key", valid_580019
  var valid_580020 = query.getOrDefault("$.xgafv")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = newJString("1"))
  if valid_580020 != nil:
    section.add "$.xgafv", valid_580020
  var valid_580021 = query.getOrDefault("prettyPrint")
  valid_580021 = validateParameter(valid_580021, JBool, required = false,
                                 default = newJBool(true))
  if valid_580021 != nil:
    section.add "prettyPrint", valid_580021
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

proc call*(call_580023: Call_SecuritycenterOrganizationsOperationsCancel_580007;
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
  let valid = call_580023.validator(path, query, header, formData, body)
  let scheme = call_580023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580023.url(scheme.get, call_580023.host, call_580023.base,
                         call_580023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580023, url, valid)

proc call*(call_580024: Call_SecuritycenterOrganizationsOperationsCancel_580007;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## securitycenterOrganizationsOperationsCancel
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
  var path_580025 = newJObject()
  var query_580026 = newJObject()
  var body_580027 = newJObject()
  add(query_580026, "upload_protocol", newJString(uploadProtocol))
  add(query_580026, "fields", newJString(fields))
  add(query_580026, "quotaUser", newJString(quotaUser))
  add(path_580025, "name", newJString(name))
  add(query_580026, "alt", newJString(alt))
  add(query_580026, "oauth_token", newJString(oauthToken))
  add(query_580026, "callback", newJString(callback))
  add(query_580026, "access_token", newJString(accessToken))
  add(query_580026, "uploadType", newJString(uploadType))
  add(query_580026, "key", newJString(key))
  add(query_580026, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580027 = body
  add(query_580026, "prettyPrint", newJBool(prettyPrint))
  result = call_580024.call(path_580025, query_580026, nil, nil, body_580027)

var securitycenterOrganizationsOperationsCancel* = Call_SecuritycenterOrganizationsOperationsCancel_580007(
    name: "securitycenterOrganizationsOperationsCancel",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1beta1/{name}:cancel",
    validator: validate_SecuritycenterOrganizationsOperationsCancel_580008,
    base: "/", url: url_SecuritycenterOrganizationsOperationsCancel_580009,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesFindingsSetState_580028 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsSourcesFindingsSetState_580030(
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
               (kind: ConstantSegment, value: ":setState")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsSourcesFindingsSetState_580029(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the state of a finding.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The relative resource name of the finding. See:
  ## https://cloud.google.com/apis/design/resource_names#relative_resource_name
  ## Example:
  ## "organizations/123/sources/456/finding/789".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580031 = path.getOrDefault("name")
  valid_580031 = validateParameter(valid_580031, JString, required = true,
                                 default = nil)
  if valid_580031 != nil:
    section.add "name", valid_580031
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
  var valid_580032 = query.getOrDefault("upload_protocol")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "upload_protocol", valid_580032
  var valid_580033 = query.getOrDefault("fields")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "fields", valid_580033
  var valid_580034 = query.getOrDefault("quotaUser")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "quotaUser", valid_580034
  var valid_580035 = query.getOrDefault("alt")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = newJString("json"))
  if valid_580035 != nil:
    section.add "alt", valid_580035
  var valid_580036 = query.getOrDefault("oauth_token")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "oauth_token", valid_580036
  var valid_580037 = query.getOrDefault("callback")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "callback", valid_580037
  var valid_580038 = query.getOrDefault("access_token")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "access_token", valid_580038
  var valid_580039 = query.getOrDefault("uploadType")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "uploadType", valid_580039
  var valid_580040 = query.getOrDefault("key")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "key", valid_580040
  var valid_580041 = query.getOrDefault("$.xgafv")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = newJString("1"))
  if valid_580041 != nil:
    section.add "$.xgafv", valid_580041
  var valid_580042 = query.getOrDefault("prettyPrint")
  valid_580042 = validateParameter(valid_580042, JBool, required = false,
                                 default = newJBool(true))
  if valid_580042 != nil:
    section.add "prettyPrint", valid_580042
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

proc call*(call_580044: Call_SecuritycenterOrganizationsSourcesFindingsSetState_580028;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the state of a finding.
  ## 
  let valid = call_580044.validator(path, query, header, formData, body)
  let scheme = call_580044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580044.url(scheme.get, call_580044.host, call_580044.base,
                         call_580044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580044, url, valid)

proc call*(call_580045: Call_SecuritycenterOrganizationsSourcesFindingsSetState_580028;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## securitycenterOrganizationsSourcesFindingsSetState
  ## Updates the state of a finding.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The relative resource name of the finding. See:
  ## https://cloud.google.com/apis/design/resource_names#relative_resource_name
  ## Example:
  ## "organizations/123/sources/456/finding/789".
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
  var path_580046 = newJObject()
  var query_580047 = newJObject()
  var body_580048 = newJObject()
  add(query_580047, "upload_protocol", newJString(uploadProtocol))
  add(query_580047, "fields", newJString(fields))
  add(query_580047, "quotaUser", newJString(quotaUser))
  add(path_580046, "name", newJString(name))
  add(query_580047, "alt", newJString(alt))
  add(query_580047, "oauth_token", newJString(oauthToken))
  add(query_580047, "callback", newJString(callback))
  add(query_580047, "access_token", newJString(accessToken))
  add(query_580047, "uploadType", newJString(uploadType))
  add(query_580047, "key", newJString(key))
  add(query_580047, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580048 = body
  add(query_580047, "prettyPrint", newJBool(prettyPrint))
  result = call_580045.call(path_580046, query_580047, nil, nil, body_580048)

var securitycenterOrganizationsSourcesFindingsSetState* = Call_SecuritycenterOrganizationsSourcesFindingsSetState_580028(
    name: "securitycenterOrganizationsSourcesFindingsSetState",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1beta1/{name}:setState",
    validator: validate_SecuritycenterOrganizationsSourcesFindingsSetState_580029,
    base: "/", url: url_SecuritycenterOrganizationsSourcesFindingsSetState_580030,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsAssetsList_580049 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsAssetsList_580051(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/assets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsAssetsList_580050(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists an organization's assets.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the organization assets should belong to. Its format is
  ## "organizations/[organization_id]".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580052 = path.getOrDefault("parent")
  valid_580052 = validateParameter(valid_580052, JString, required = true,
                                 default = nil)
  if valid_580052 != nil:
    section.add "parent", valid_580052
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The value returned by the last `ListAssetsResponse`; indicates
  ## that this is a continuation of a prior `ListAssets` call, and
  ## that the system should return the next page of data.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   readTime: JString
  ##           : Time used as a reference point when filtering assets. The filter is limited
  ## to assets existing at the supplied time and their values are those at that
  ## specific time. Absence of this field will default to the API's version of
  ## NOW.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   orderBy: JString
  ##          : Expression that defines what fields and order to use for sorting. The
  ## string value should follow SQL syntax: comma separated list of fields. For
  ## example: "name,resource_properties.a_property". The default sorting order
  ## is ascending. To specify descending order for a field, a suffix " desc"
  ## should be appended to the field name. For example: "name
  ## desc,resource_properties.a_property". Redundant space characters in the
  ## syntax are insignificant. "name desc,resource_properties.a_property" and "
  ## name     desc  ,   resource_properties.a_property  " are equivalent.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   fieldMask: JString
  ##            : Optional. A field mask to specify the ListAssetsResult fields to be listed in the
  ## response.
  ## An empty field mask will list all fields.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   compareDuration: JString
  ##                  : When compare_duration is set, the ListAssetResult's "state" attribute is
  ## updated to indicate whether the asset was added, removed, or remained
  ## present during the compare_duration period of time that precedes the
  ## read_time. This is the time between (read_time -
  ## compare_duration) and read_time.
  ## 
  ## The state value is derived based on the presence of the asset at the two
  ## points in time. Intermediate state changes between the two times don't
  ## affect the result. For example, the results aren't affected if the asset is
  ## removed and re-created again.
  ## 
  ## Possible "state" values when compare_duration is specified:
  ## 
  ## * "ADDED": indicates that the asset was not present before
  ##              compare_duration, but present at read_time.
  ## * "REMOVED": indicates that the asset was present at the start of
  ##              compare_duration, but not present at read_time.
  ## * "ACTIVE": indicates that the asset was present at both the
  ##              start and the end of the time period defined by
  ##              compare_duration and read_time.
  ## 
  ## If compare_duration is not specified, then the only possible state is
  ## "UNUSED", which indicates that the asset is present at read_time.
  ##   pageSize: JInt
  ##           : The maximum number of results to return in a single response. Default is
  ## 10, minimum is 1, maximum is 1000.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Expression that defines the filter to apply across assets.
  ## The expression is a list of zero or more restrictions combined via logical
  ## operators `AND` and `OR`.
  ## Parentheses are not supported, and `OR` has higher precedence than `AND`.
  ## 
  ## Restrictions have the form `<field> <operator> <value>` and may have a `-`
  ## character in front of them to indicate negation. The fields map to those
  ## defined in the Asset resource. Examples include:
  ## 
  ## * name
  ## * security_center_properties.resource_name
  ## * resource_properties.a_property
  ## * security_marks.marks.marka
  ## 
  ## The supported operators are:
  ## 
  ## * `=` for all value types.
  ## * `>`, `<`, `>=`, `<=` for integer values.
  ## * `:`, meaning substring matching, for strings.
  ## 
  ## The supported value types are:
  ## 
  ## * string literals in quotes.
  ## * integer literals without quotes.
  ## * boolean literals `true` and `false` without quotes.
  ## 
  ## For example, `resource_properties.size = 100` is a valid filter string.
  section = newJObject()
  var valid_580053 = query.getOrDefault("upload_protocol")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "upload_protocol", valid_580053
  var valid_580054 = query.getOrDefault("fields")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "fields", valid_580054
  var valid_580055 = query.getOrDefault("pageToken")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "pageToken", valid_580055
  var valid_580056 = query.getOrDefault("quotaUser")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "quotaUser", valid_580056
  var valid_580057 = query.getOrDefault("alt")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = newJString("json"))
  if valid_580057 != nil:
    section.add "alt", valid_580057
  var valid_580058 = query.getOrDefault("readTime")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "readTime", valid_580058
  var valid_580059 = query.getOrDefault("oauth_token")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "oauth_token", valid_580059
  var valid_580060 = query.getOrDefault("callback")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "callback", valid_580060
  var valid_580061 = query.getOrDefault("access_token")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "access_token", valid_580061
  var valid_580062 = query.getOrDefault("uploadType")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "uploadType", valid_580062
  var valid_580063 = query.getOrDefault("orderBy")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "orderBy", valid_580063
  var valid_580064 = query.getOrDefault("key")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "key", valid_580064
  var valid_580065 = query.getOrDefault("fieldMask")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "fieldMask", valid_580065
  var valid_580066 = query.getOrDefault("$.xgafv")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = newJString("1"))
  if valid_580066 != nil:
    section.add "$.xgafv", valid_580066
  var valid_580067 = query.getOrDefault("compareDuration")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "compareDuration", valid_580067
  var valid_580068 = query.getOrDefault("pageSize")
  valid_580068 = validateParameter(valid_580068, JInt, required = false, default = nil)
  if valid_580068 != nil:
    section.add "pageSize", valid_580068
  var valid_580069 = query.getOrDefault("prettyPrint")
  valid_580069 = validateParameter(valid_580069, JBool, required = false,
                                 default = newJBool(true))
  if valid_580069 != nil:
    section.add "prettyPrint", valid_580069
  var valid_580070 = query.getOrDefault("filter")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "filter", valid_580070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580071: Call_SecuritycenterOrganizationsAssetsList_580049;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists an organization's assets.
  ## 
  let valid = call_580071.validator(path, query, header, formData, body)
  let scheme = call_580071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580071.url(scheme.get, call_580071.host, call_580071.base,
                         call_580071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580071, url, valid)

proc call*(call_580072: Call_SecuritycenterOrganizationsAssetsList_580049;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          readTime: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; orderBy: string = "";
          key: string = ""; fieldMask: string = ""; Xgafv: string = "1";
          compareDuration: string = ""; pageSize: int = 0; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## securitycenterOrganizationsAssetsList
  ## Lists an organization's assets.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The value returned by the last `ListAssetsResponse`; indicates
  ## that this is a continuation of a prior `ListAssets` call, and
  ## that the system should return the next page of data.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   readTime: string
  ##           : Time used as a reference point when filtering assets. The filter is limited
  ## to assets existing at the supplied time and their values are those at that
  ## specific time. Absence of this field will default to the API's version of
  ## NOW.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Name of the organization assets should belong to. Its format is
  ## "organizations/[organization_id]".
  ##   orderBy: string
  ##          : Expression that defines what fields and order to use for sorting. The
  ## string value should follow SQL syntax: comma separated list of fields. For
  ## example: "name,resource_properties.a_property". The default sorting order
  ## is ascending. To specify descending order for a field, a suffix " desc"
  ## should be appended to the field name. For example: "name
  ## desc,resource_properties.a_property". Redundant space characters in the
  ## syntax are insignificant. "name desc,resource_properties.a_property" and "
  ## name     desc  ,   resource_properties.a_property  " are equivalent.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   fieldMask: string
  ##            : Optional. A field mask to specify the ListAssetsResult fields to be listed in the
  ## response.
  ## An empty field mask will list all fields.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   compareDuration: string
  ##                  : When compare_duration is set, the ListAssetResult's "state" attribute is
  ## updated to indicate whether the asset was added, removed, or remained
  ## present during the compare_duration period of time that precedes the
  ## read_time. This is the time between (read_time -
  ## compare_duration) and read_time.
  ## 
  ## The state value is derived based on the presence of the asset at the two
  ## points in time. Intermediate state changes between the two times don't
  ## affect the result. For example, the results aren't affected if the asset is
  ## removed and re-created again.
  ## 
  ## Possible "state" values when compare_duration is specified:
  ## 
  ## * "ADDED": indicates that the asset was not present before
  ##              compare_duration, but present at read_time.
  ## * "REMOVED": indicates that the asset was present at the start of
  ##              compare_duration, but not present at read_time.
  ## * "ACTIVE": indicates that the asset was present at both the
  ##              start and the end of the time period defined by
  ##              compare_duration and read_time.
  ## 
  ## If compare_duration is not specified, then the only possible state is
  ## "UNUSED", which indicates that the asset is present at read_time.
  ##   pageSize: int
  ##           : The maximum number of results to return in a single response. Default is
  ## 10, minimum is 1, maximum is 1000.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Expression that defines the filter to apply across assets.
  ## The expression is a list of zero or more restrictions combined via logical
  ## operators `AND` and `OR`.
  ## Parentheses are not supported, and `OR` has higher precedence than `AND`.
  ## 
  ## Restrictions have the form `<field> <operator> <value>` and may have a `-`
  ## character in front of them to indicate negation. The fields map to those
  ## defined in the Asset resource. Examples include:
  ## 
  ## * name
  ## * security_center_properties.resource_name
  ## * resource_properties.a_property
  ## * security_marks.marks.marka
  ## 
  ## The supported operators are:
  ## 
  ## * `=` for all value types.
  ## * `>`, `<`, `>=`, `<=` for integer values.
  ## * `:`, meaning substring matching, for strings.
  ## 
  ## The supported value types are:
  ## 
  ## * string literals in quotes.
  ## * integer literals without quotes.
  ## * boolean literals `true` and `false` without quotes.
  ## 
  ## For example, `resource_properties.size = 100` is a valid filter string.
  var path_580073 = newJObject()
  var query_580074 = newJObject()
  add(query_580074, "upload_protocol", newJString(uploadProtocol))
  add(query_580074, "fields", newJString(fields))
  add(query_580074, "pageToken", newJString(pageToken))
  add(query_580074, "quotaUser", newJString(quotaUser))
  add(query_580074, "alt", newJString(alt))
  add(query_580074, "readTime", newJString(readTime))
  add(query_580074, "oauth_token", newJString(oauthToken))
  add(query_580074, "callback", newJString(callback))
  add(query_580074, "access_token", newJString(accessToken))
  add(query_580074, "uploadType", newJString(uploadType))
  add(path_580073, "parent", newJString(parent))
  add(query_580074, "orderBy", newJString(orderBy))
  add(query_580074, "key", newJString(key))
  add(query_580074, "fieldMask", newJString(fieldMask))
  add(query_580074, "$.xgafv", newJString(Xgafv))
  add(query_580074, "compareDuration", newJString(compareDuration))
  add(query_580074, "pageSize", newJInt(pageSize))
  add(query_580074, "prettyPrint", newJBool(prettyPrint))
  add(query_580074, "filter", newJString(filter))
  result = call_580072.call(path_580073, query_580074, nil, nil, nil)

var securitycenterOrganizationsAssetsList* = Call_SecuritycenterOrganizationsAssetsList_580049(
    name: "securitycenterOrganizationsAssetsList", meth: HttpMethod.HttpGet,
    host: "securitycenter.googleapis.com", route: "/v1beta1/{parent}/assets",
    validator: validate_SecuritycenterOrganizationsAssetsList_580050, base: "/",
    url: url_SecuritycenterOrganizationsAssetsList_580051, schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsAssetsGroup_580075 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsAssetsGroup_580077(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/assets:group")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsAssetsGroup_580076(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Filters an organization's assets and  groups them by their specified
  ## properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the organization to groupBy. Its format is
  ## "organizations/[organization_id]".
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

proc call*(call_580091: Call_SecuritycenterOrganizationsAssetsGroup_580075;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Filters an organization's assets and  groups them by their specified
  ## properties.
  ## 
  let valid = call_580091.validator(path, query, header, formData, body)
  let scheme = call_580091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580091.url(scheme.get, call_580091.host, call_580091.base,
                         call_580091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580091, url, valid)

proc call*(call_580092: Call_SecuritycenterOrganizationsAssetsGroup_580075;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## securitycenterOrganizationsAssetsGroup
  ## Filters an organization's assets and  groups them by their specified
  ## properties.
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
  ##         : Name of the organization to groupBy. Its format is
  ## "organizations/[organization_id]".
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

var securitycenterOrganizationsAssetsGroup* = Call_SecuritycenterOrganizationsAssetsGroup_580075(
    name: "securitycenterOrganizationsAssetsGroup", meth: HttpMethod.HttpPost,
    host: "securitycenter.googleapis.com",
    route: "/v1beta1/{parent}/assets:group",
    validator: validate_SecuritycenterOrganizationsAssetsGroup_580076, base: "/",
    url: url_SecuritycenterOrganizationsAssetsGroup_580077,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsAssetsRunDiscovery_580096 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsAssetsRunDiscovery_580098(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/assets:runDiscovery")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsAssetsRunDiscovery_580097(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Runs asset discovery. The discovery is tracked with a long-running
  ## operation.
  ## 
  ## This API can only be called with limited frequency for an organization. If
  ## it is called too frequently the caller will receive a TOO_MANY_REQUESTS
  ## error.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the organization to run asset discovery for. Its format is
  ## "organizations/[organization_id]".
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
  var valid_580102 = query.getOrDefault("quotaUser")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "quotaUser", valid_580102
  var valid_580103 = query.getOrDefault("alt")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = newJString("json"))
  if valid_580103 != nil:
    section.add "alt", valid_580103
  var valid_580104 = query.getOrDefault("oauth_token")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "oauth_token", valid_580104
  var valid_580105 = query.getOrDefault("callback")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "callback", valid_580105
  var valid_580106 = query.getOrDefault("access_token")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "access_token", valid_580106
  var valid_580107 = query.getOrDefault("uploadType")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "uploadType", valid_580107
  var valid_580108 = query.getOrDefault("key")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "key", valid_580108
  var valid_580109 = query.getOrDefault("$.xgafv")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = newJString("1"))
  if valid_580109 != nil:
    section.add "$.xgafv", valid_580109
  var valid_580110 = query.getOrDefault("prettyPrint")
  valid_580110 = validateParameter(valid_580110, JBool, required = false,
                                 default = newJBool(true))
  if valid_580110 != nil:
    section.add "prettyPrint", valid_580110
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

proc call*(call_580112: Call_SecuritycenterOrganizationsAssetsRunDiscovery_580096;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Runs asset discovery. The discovery is tracked with a long-running
  ## operation.
  ## 
  ## This API can only be called with limited frequency for an organization. If
  ## it is called too frequently the caller will receive a TOO_MANY_REQUESTS
  ## error.
  ## 
  let valid = call_580112.validator(path, query, header, formData, body)
  let scheme = call_580112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580112.url(scheme.get, call_580112.host, call_580112.base,
                         call_580112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580112, url, valid)

proc call*(call_580113: Call_SecuritycenterOrganizationsAssetsRunDiscovery_580096;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## securitycenterOrganizationsAssetsRunDiscovery
  ## Runs asset discovery. The discovery is tracked with a long-running
  ## operation.
  ## 
  ## This API can only be called with limited frequency for an organization. If
  ## it is called too frequently the caller will receive a TOO_MANY_REQUESTS
  ## error.
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
  ##         : Name of the organization to run asset discovery for. Its format is
  ## "organizations/[organization_id]".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580114 = newJObject()
  var query_580115 = newJObject()
  var body_580116 = newJObject()
  add(query_580115, "upload_protocol", newJString(uploadProtocol))
  add(query_580115, "fields", newJString(fields))
  add(query_580115, "quotaUser", newJString(quotaUser))
  add(query_580115, "alt", newJString(alt))
  add(query_580115, "oauth_token", newJString(oauthToken))
  add(query_580115, "callback", newJString(callback))
  add(query_580115, "access_token", newJString(accessToken))
  add(query_580115, "uploadType", newJString(uploadType))
  add(path_580114, "parent", newJString(parent))
  add(query_580115, "key", newJString(key))
  add(query_580115, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580116 = body
  add(query_580115, "prettyPrint", newJBool(prettyPrint))
  result = call_580113.call(path_580114, query_580115, nil, nil, body_580116)

var securitycenterOrganizationsAssetsRunDiscovery* = Call_SecuritycenterOrganizationsAssetsRunDiscovery_580096(
    name: "securitycenterOrganizationsAssetsRunDiscovery",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1beta1/{parent}/assets:runDiscovery",
    validator: validate_SecuritycenterOrganizationsAssetsRunDiscovery_580097,
    base: "/", url: url_SecuritycenterOrganizationsAssetsRunDiscovery_580098,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesFindingsCreate_580142 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsSourcesFindingsCreate_580144(
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
               (kind: ConstantSegment, value: "/findings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsSourcesFindingsCreate_580143(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a finding. The corresponding source must exist for finding creation
  ## to succeed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Resource name of the new finding's parent. Its format should be
  ## "organizations/[organization_id]/sources/[source_id]".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580145 = path.getOrDefault("parent")
  valid_580145 = validateParameter(valid_580145, JString, required = true,
                                 default = nil)
  if valid_580145 != nil:
    section.add "parent", valid_580145
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   findingId: JString
  ##            : Unique identifier provided by the client within the parent scope.
  ## It must be alphanumeric and less than or equal to 32 characters and
  ## greater than 0 characters in length.
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
  var valid_580146 = query.getOrDefault("upload_protocol")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "upload_protocol", valid_580146
  var valid_580147 = query.getOrDefault("fields")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "fields", valid_580147
  var valid_580148 = query.getOrDefault("quotaUser")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "quotaUser", valid_580148
  var valid_580149 = query.getOrDefault("findingId")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "findingId", valid_580149
  var valid_580150 = query.getOrDefault("alt")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = newJString("json"))
  if valid_580150 != nil:
    section.add "alt", valid_580150
  var valid_580151 = query.getOrDefault("oauth_token")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "oauth_token", valid_580151
  var valid_580152 = query.getOrDefault("callback")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "callback", valid_580152
  var valid_580153 = query.getOrDefault("access_token")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "access_token", valid_580153
  var valid_580154 = query.getOrDefault("uploadType")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "uploadType", valid_580154
  var valid_580155 = query.getOrDefault("key")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "key", valid_580155
  var valid_580156 = query.getOrDefault("$.xgafv")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = newJString("1"))
  if valid_580156 != nil:
    section.add "$.xgafv", valid_580156
  var valid_580157 = query.getOrDefault("prettyPrint")
  valid_580157 = validateParameter(valid_580157, JBool, required = false,
                                 default = newJBool(true))
  if valid_580157 != nil:
    section.add "prettyPrint", valid_580157
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

proc call*(call_580159: Call_SecuritycenterOrganizationsSourcesFindingsCreate_580142;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a finding. The corresponding source must exist for finding creation
  ## to succeed.
  ## 
  let valid = call_580159.validator(path, query, header, formData, body)
  let scheme = call_580159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580159.url(scheme.get, call_580159.host, call_580159.base,
                         call_580159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580159, url, valid)

proc call*(call_580160: Call_SecuritycenterOrganizationsSourcesFindingsCreate_580142;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; findingId: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## securitycenterOrganizationsSourcesFindingsCreate
  ## Creates a finding. The corresponding source must exist for finding creation
  ## to succeed.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   findingId: string
  ##            : Unique identifier provided by the client within the parent scope.
  ## It must be alphanumeric and less than or equal to 32 characters and
  ## greater than 0 characters in length.
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
  ##         : Resource name of the new finding's parent. Its format should be
  ## "organizations/[organization_id]/sources/[source_id]".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580161 = newJObject()
  var query_580162 = newJObject()
  var body_580163 = newJObject()
  add(query_580162, "upload_protocol", newJString(uploadProtocol))
  add(query_580162, "fields", newJString(fields))
  add(query_580162, "quotaUser", newJString(quotaUser))
  add(query_580162, "findingId", newJString(findingId))
  add(query_580162, "alt", newJString(alt))
  add(query_580162, "oauth_token", newJString(oauthToken))
  add(query_580162, "callback", newJString(callback))
  add(query_580162, "access_token", newJString(accessToken))
  add(query_580162, "uploadType", newJString(uploadType))
  add(path_580161, "parent", newJString(parent))
  add(query_580162, "key", newJString(key))
  add(query_580162, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580163 = body
  add(query_580162, "prettyPrint", newJBool(prettyPrint))
  result = call_580160.call(path_580161, query_580162, nil, nil, body_580163)

var securitycenterOrganizationsSourcesFindingsCreate* = Call_SecuritycenterOrganizationsSourcesFindingsCreate_580142(
    name: "securitycenterOrganizationsSourcesFindingsCreate",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1beta1/{parent}/findings",
    validator: validate_SecuritycenterOrganizationsSourcesFindingsCreate_580143,
    base: "/", url: url_SecuritycenterOrganizationsSourcesFindingsCreate_580144,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesFindingsList_580117 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsSourcesFindingsList_580119(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/findings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsSourcesFindingsList_580118(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists an organization or source's findings.
  ## 
  ## To list across all sources provide a `-` as the source id.
  ## Example: /v1beta1/organizations/123/sources/-/findings
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the source the findings belong to. Its format is
  ## "organizations/[organization_id]/sources/[source_id]". To list across all
  ## sources provide a source_id of `-`. For example:
  ## organizations/123/sources/-
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580120 = path.getOrDefault("parent")
  valid_580120 = validateParameter(valid_580120, JString, required = true,
                                 default = nil)
  if valid_580120 != nil:
    section.add "parent", valid_580120
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The value returned by the last `ListFindingsResponse`; indicates
  ## that this is a continuation of a prior `ListFindings` call, and
  ## that the system should return the next page of data.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   readTime: JString
  ##           : Time used as a reference point when filtering findings. The filter is
  ## limited to findings existing at the supplied time and their values are
  ## those at that specific time. Absence of this field will default to the
  ## API's version of NOW.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   orderBy: JString
  ##          : Expression that defines what fields and order to use for sorting. The
  ## string value should follow SQL syntax: comma separated list of fields. For
  ## example: "name,resource_properties.a_property". The default sorting order
  ## is ascending. To specify descending order for a field, a suffix " desc"
  ## should be appended to the field name. For example: "name
  ## desc,source_properties.a_property". Redundant space characters in the
  ## syntax are insignificant. "name desc,source_properties.a_property" and "
  ## name     desc  ,   source_properties.a_property  " are equivalent.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   fieldMask: JString
  ##            : Optional. A field mask to specify the Finding fields to be listed in the response.
  ## An empty field mask will list all fields.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of results to return in a single response. Default is
  ## 10, minimum is 1, maximum is 1000.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : Expression that defines the filter to apply across findings.
  ## The expression is a list of one or more restrictions combined via logical
  ## operators `AND` and `OR`.
  ## Parentheses are not supported, and `OR` has higher precedence than `AND`.
  ## 
  ## Restrictions have the form `<field> <operator> <value>` and may have a `-`
  ## character in front of them to indicate negation. Examples include:
  ## 
  ##  * name
  ##  * source_properties.a_property
  ##  * security_marks.marks.marka
  ## 
  ## The supported operators are:
  ## 
  ## * `=` for all value types.
  ## * `>`, `<`, `>=`, `<=` for integer values.
  ## * `:`, meaning substring matching, for strings.
  ## 
  ## The supported value types are:
  ## 
  ## * string literals in quotes.
  ## * integer literals without quotes.
  ## * boolean literals `true` and `false` without quotes.
  ## 
  ## For example, `source_properties.size = 100` is a valid filter string.
  section = newJObject()
  var valid_580121 = query.getOrDefault("upload_protocol")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "upload_protocol", valid_580121
  var valid_580122 = query.getOrDefault("fields")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "fields", valid_580122
  var valid_580123 = query.getOrDefault("pageToken")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "pageToken", valid_580123
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
  var valid_580126 = query.getOrDefault("readTime")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "readTime", valid_580126
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
  var valid_580131 = query.getOrDefault("orderBy")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "orderBy", valid_580131
  var valid_580132 = query.getOrDefault("key")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "key", valid_580132
  var valid_580133 = query.getOrDefault("fieldMask")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "fieldMask", valid_580133
  var valid_580134 = query.getOrDefault("$.xgafv")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = newJString("1"))
  if valid_580134 != nil:
    section.add "$.xgafv", valid_580134
  var valid_580135 = query.getOrDefault("pageSize")
  valid_580135 = validateParameter(valid_580135, JInt, required = false, default = nil)
  if valid_580135 != nil:
    section.add "pageSize", valid_580135
  var valid_580136 = query.getOrDefault("prettyPrint")
  valid_580136 = validateParameter(valid_580136, JBool, required = false,
                                 default = newJBool(true))
  if valid_580136 != nil:
    section.add "prettyPrint", valid_580136
  var valid_580137 = query.getOrDefault("filter")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "filter", valid_580137
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580138: Call_SecuritycenterOrganizationsSourcesFindingsList_580117;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists an organization or source's findings.
  ## 
  ## To list across all sources provide a `-` as the source id.
  ## Example: /v1beta1/organizations/123/sources/-/findings
  ## 
  let valid = call_580138.validator(path, query, header, formData, body)
  let scheme = call_580138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580138.url(scheme.get, call_580138.host, call_580138.base,
                         call_580138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580138, url, valid)

proc call*(call_580139: Call_SecuritycenterOrganizationsSourcesFindingsList_580117;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          readTime: string = ""; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; orderBy: string = "";
          key: string = ""; fieldMask: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## securitycenterOrganizationsSourcesFindingsList
  ## Lists an organization or source's findings.
  ## 
  ## To list across all sources provide a `-` as the source id.
  ## Example: /v1beta1/organizations/123/sources/-/findings
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The value returned by the last `ListFindingsResponse`; indicates
  ## that this is a continuation of a prior `ListFindings` call, and
  ## that the system should return the next page of data.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   readTime: string
  ##           : Time used as a reference point when filtering findings. The filter is
  ## limited to findings existing at the supplied time and their values are
  ## those at that specific time. Absence of this field will default to the
  ## API's version of NOW.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Name of the source the findings belong to. Its format is
  ## "organizations/[organization_id]/sources/[source_id]". To list across all
  ## sources provide a source_id of `-`. For example:
  ## organizations/123/sources/-
  ##   orderBy: string
  ##          : Expression that defines what fields and order to use for sorting. The
  ## string value should follow SQL syntax: comma separated list of fields. For
  ## example: "name,resource_properties.a_property". The default sorting order
  ## is ascending. To specify descending order for a field, a suffix " desc"
  ## should be appended to the field name. For example: "name
  ## desc,source_properties.a_property". Redundant space characters in the
  ## syntax are insignificant. "name desc,source_properties.a_property" and "
  ## name     desc  ,   source_properties.a_property  " are equivalent.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   fieldMask: string
  ##            : Optional. A field mask to specify the Finding fields to be listed in the response.
  ## An empty field mask will list all fields.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of results to return in a single response. Default is
  ## 10, minimum is 1, maximum is 1000.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : Expression that defines the filter to apply across findings.
  ## The expression is a list of one or more restrictions combined via logical
  ## operators `AND` and `OR`.
  ## Parentheses are not supported, and `OR` has higher precedence than `AND`.
  ## 
  ## Restrictions have the form `<field> <operator> <value>` and may have a `-`
  ## character in front of them to indicate negation. Examples include:
  ## 
  ##  * name
  ##  * source_properties.a_property
  ##  * security_marks.marks.marka
  ## 
  ## The supported operators are:
  ## 
  ## * `=` for all value types.
  ## * `>`, `<`, `>=`, `<=` for integer values.
  ## * `:`, meaning substring matching, for strings.
  ## 
  ## The supported value types are:
  ## 
  ## * string literals in quotes.
  ## * integer literals without quotes.
  ## * boolean literals `true` and `false` without quotes.
  ## 
  ## For example, `source_properties.size = 100` is a valid filter string.
  var path_580140 = newJObject()
  var query_580141 = newJObject()
  add(query_580141, "upload_protocol", newJString(uploadProtocol))
  add(query_580141, "fields", newJString(fields))
  add(query_580141, "pageToken", newJString(pageToken))
  add(query_580141, "quotaUser", newJString(quotaUser))
  add(query_580141, "alt", newJString(alt))
  add(query_580141, "readTime", newJString(readTime))
  add(query_580141, "oauth_token", newJString(oauthToken))
  add(query_580141, "callback", newJString(callback))
  add(query_580141, "access_token", newJString(accessToken))
  add(query_580141, "uploadType", newJString(uploadType))
  add(path_580140, "parent", newJString(parent))
  add(query_580141, "orderBy", newJString(orderBy))
  add(query_580141, "key", newJString(key))
  add(query_580141, "fieldMask", newJString(fieldMask))
  add(query_580141, "$.xgafv", newJString(Xgafv))
  add(query_580141, "pageSize", newJInt(pageSize))
  add(query_580141, "prettyPrint", newJBool(prettyPrint))
  add(query_580141, "filter", newJString(filter))
  result = call_580139.call(path_580140, query_580141, nil, nil, nil)

var securitycenterOrganizationsSourcesFindingsList* = Call_SecuritycenterOrganizationsSourcesFindingsList_580117(
    name: "securitycenterOrganizationsSourcesFindingsList",
    meth: HttpMethod.HttpGet, host: "securitycenter.googleapis.com",
    route: "/v1beta1/{parent}/findings",
    validator: validate_SecuritycenterOrganizationsSourcesFindingsList_580118,
    base: "/", url: url_SecuritycenterOrganizationsSourcesFindingsList_580119,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesFindingsGroup_580164 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsSourcesFindingsGroup_580166(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/findings:group")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsSourcesFindingsGroup_580165(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Filters an organization or source's findings and  groups them by their
  ## specified properties.
  ## 
  ## To group across all sources provide a `-` as the source id.
  ## Example: /v1beta1/organizations/123/sources/-/findings
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of the source to groupBy. Its format is
  ## "organizations/[organization_id]/sources/[source_id]". To groupBy across
  ## all sources provide a source_id of `-`. For example:
  ## organizations/123/sources/-
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580167 = path.getOrDefault("parent")
  valid_580167 = validateParameter(valid_580167, JString, required = true,
                                 default = nil)
  if valid_580167 != nil:
    section.add "parent", valid_580167
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
  var valid_580168 = query.getOrDefault("upload_protocol")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "upload_protocol", valid_580168
  var valid_580169 = query.getOrDefault("fields")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "fields", valid_580169
  var valid_580170 = query.getOrDefault("quotaUser")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "quotaUser", valid_580170
  var valid_580171 = query.getOrDefault("alt")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = newJString("json"))
  if valid_580171 != nil:
    section.add "alt", valid_580171
  var valid_580172 = query.getOrDefault("oauth_token")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "oauth_token", valid_580172
  var valid_580173 = query.getOrDefault("callback")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "callback", valid_580173
  var valid_580174 = query.getOrDefault("access_token")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "access_token", valid_580174
  var valid_580175 = query.getOrDefault("uploadType")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "uploadType", valid_580175
  var valid_580176 = query.getOrDefault("key")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "key", valid_580176
  var valid_580177 = query.getOrDefault("$.xgafv")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = newJString("1"))
  if valid_580177 != nil:
    section.add "$.xgafv", valid_580177
  var valid_580178 = query.getOrDefault("prettyPrint")
  valid_580178 = validateParameter(valid_580178, JBool, required = false,
                                 default = newJBool(true))
  if valid_580178 != nil:
    section.add "prettyPrint", valid_580178
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

proc call*(call_580180: Call_SecuritycenterOrganizationsSourcesFindingsGroup_580164;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Filters an organization or source's findings and  groups them by their
  ## specified properties.
  ## 
  ## To group across all sources provide a `-` as the source id.
  ## Example: /v1beta1/organizations/123/sources/-/findings
  ## 
  let valid = call_580180.validator(path, query, header, formData, body)
  let scheme = call_580180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580180.url(scheme.get, call_580180.host, call_580180.base,
                         call_580180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580180, url, valid)

proc call*(call_580181: Call_SecuritycenterOrganizationsSourcesFindingsGroup_580164;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## securitycenterOrganizationsSourcesFindingsGroup
  ## Filters an organization or source's findings and  groups them by their
  ## specified properties.
  ## 
  ## To group across all sources provide a `-` as the source id.
  ## Example: /v1beta1/organizations/123/sources/-/findings
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
  ##         : Name of the source to groupBy. Its format is
  ## "organizations/[organization_id]/sources/[source_id]". To groupBy across
  ## all sources provide a source_id of `-`. For example:
  ## organizations/123/sources/-
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580182 = newJObject()
  var query_580183 = newJObject()
  var body_580184 = newJObject()
  add(query_580183, "upload_protocol", newJString(uploadProtocol))
  add(query_580183, "fields", newJString(fields))
  add(query_580183, "quotaUser", newJString(quotaUser))
  add(query_580183, "alt", newJString(alt))
  add(query_580183, "oauth_token", newJString(oauthToken))
  add(query_580183, "callback", newJString(callback))
  add(query_580183, "access_token", newJString(accessToken))
  add(query_580183, "uploadType", newJString(uploadType))
  add(path_580182, "parent", newJString(parent))
  add(query_580183, "key", newJString(key))
  add(query_580183, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580184 = body
  add(query_580183, "prettyPrint", newJBool(prettyPrint))
  result = call_580181.call(path_580182, query_580183, nil, nil, body_580184)

var securitycenterOrganizationsSourcesFindingsGroup* = Call_SecuritycenterOrganizationsSourcesFindingsGroup_580164(
    name: "securitycenterOrganizationsSourcesFindingsGroup",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1beta1/{parent}/findings:group",
    validator: validate_SecuritycenterOrganizationsSourcesFindingsGroup_580165,
    base: "/", url: url_SecuritycenterOrganizationsSourcesFindingsGroup_580166,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesCreate_580206 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsSourcesCreate_580208(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/sources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsSourcesCreate_580207(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Resource name of the new source's parent. Its format should be
  ## "organizations/[organization_id]".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580209 = path.getOrDefault("parent")
  valid_580209 = validateParameter(valid_580209, JString, required = true,
                                 default = nil)
  if valid_580209 != nil:
    section.add "parent", valid_580209
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
  var valid_580210 = query.getOrDefault("upload_protocol")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "upload_protocol", valid_580210
  var valid_580211 = query.getOrDefault("fields")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "fields", valid_580211
  var valid_580212 = query.getOrDefault("quotaUser")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "quotaUser", valid_580212
  var valid_580213 = query.getOrDefault("alt")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = newJString("json"))
  if valid_580213 != nil:
    section.add "alt", valid_580213
  var valid_580214 = query.getOrDefault("oauth_token")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "oauth_token", valid_580214
  var valid_580215 = query.getOrDefault("callback")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "callback", valid_580215
  var valid_580216 = query.getOrDefault("access_token")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "access_token", valid_580216
  var valid_580217 = query.getOrDefault("uploadType")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "uploadType", valid_580217
  var valid_580218 = query.getOrDefault("key")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "key", valid_580218
  var valid_580219 = query.getOrDefault("$.xgafv")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = newJString("1"))
  if valid_580219 != nil:
    section.add "$.xgafv", valid_580219
  var valid_580220 = query.getOrDefault("prettyPrint")
  valid_580220 = validateParameter(valid_580220, JBool, required = false,
                                 default = newJBool(true))
  if valid_580220 != nil:
    section.add "prettyPrint", valid_580220
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

proc call*(call_580222: Call_SecuritycenterOrganizationsSourcesCreate_580206;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a source.
  ## 
  let valid = call_580222.validator(path, query, header, formData, body)
  let scheme = call_580222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580222.url(scheme.get, call_580222.host, call_580222.base,
                         call_580222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580222, url, valid)

proc call*(call_580223: Call_SecuritycenterOrganizationsSourcesCreate_580206;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## securitycenterOrganizationsSourcesCreate
  ## Creates a source.
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
  ##         : Resource name of the new source's parent. Its format should be
  ## "organizations/[organization_id]".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580224 = newJObject()
  var query_580225 = newJObject()
  var body_580226 = newJObject()
  add(query_580225, "upload_protocol", newJString(uploadProtocol))
  add(query_580225, "fields", newJString(fields))
  add(query_580225, "quotaUser", newJString(quotaUser))
  add(query_580225, "alt", newJString(alt))
  add(query_580225, "oauth_token", newJString(oauthToken))
  add(query_580225, "callback", newJString(callback))
  add(query_580225, "access_token", newJString(accessToken))
  add(query_580225, "uploadType", newJString(uploadType))
  add(path_580224, "parent", newJString(parent))
  add(query_580225, "key", newJString(key))
  add(query_580225, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580226 = body
  add(query_580225, "prettyPrint", newJBool(prettyPrint))
  result = call_580223.call(path_580224, query_580225, nil, nil, body_580226)

var securitycenterOrganizationsSourcesCreate* = Call_SecuritycenterOrganizationsSourcesCreate_580206(
    name: "securitycenterOrganizationsSourcesCreate", meth: HttpMethod.HttpPost,
    host: "securitycenter.googleapis.com", route: "/v1beta1/{parent}/sources",
    validator: validate_SecuritycenterOrganizationsSourcesCreate_580207,
    base: "/", url: url_SecuritycenterOrganizationsSourcesCreate_580208,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesList_580185 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsSourcesList_580187(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/sources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsSourcesList_580186(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all sources belonging to an organization.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Resource name of the parent of sources to list. Its format should be
  ## "organizations/[organization_id]".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580188 = path.getOrDefault("parent")
  valid_580188 = validateParameter(valid_580188, JString, required = true,
                                 default = nil)
  if valid_580188 != nil:
    section.add "parent", valid_580188
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The value returned by the last `ListSourcesResponse`; indicates
  ## that this is a continuation of a prior `ListSources` call, and
  ## that the system should return the next page of data.
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
  ##           : The maximum number of results to return in a single response. Default is
  ## 10, minimum is 1, maximum is 1000.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580189 = query.getOrDefault("upload_protocol")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "upload_protocol", valid_580189
  var valid_580190 = query.getOrDefault("fields")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "fields", valid_580190
  var valid_580191 = query.getOrDefault("pageToken")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "pageToken", valid_580191
  var valid_580192 = query.getOrDefault("quotaUser")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "quotaUser", valid_580192
  var valid_580193 = query.getOrDefault("alt")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = newJString("json"))
  if valid_580193 != nil:
    section.add "alt", valid_580193
  var valid_580194 = query.getOrDefault("oauth_token")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "oauth_token", valid_580194
  var valid_580195 = query.getOrDefault("callback")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "callback", valid_580195
  var valid_580196 = query.getOrDefault("access_token")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "access_token", valid_580196
  var valid_580197 = query.getOrDefault("uploadType")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "uploadType", valid_580197
  var valid_580198 = query.getOrDefault("key")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "key", valid_580198
  var valid_580199 = query.getOrDefault("$.xgafv")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = newJString("1"))
  if valid_580199 != nil:
    section.add "$.xgafv", valid_580199
  var valid_580200 = query.getOrDefault("pageSize")
  valid_580200 = validateParameter(valid_580200, JInt, required = false, default = nil)
  if valid_580200 != nil:
    section.add "pageSize", valid_580200
  var valid_580201 = query.getOrDefault("prettyPrint")
  valid_580201 = validateParameter(valid_580201, JBool, required = false,
                                 default = newJBool(true))
  if valid_580201 != nil:
    section.add "prettyPrint", valid_580201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580202: Call_SecuritycenterOrganizationsSourcesList_580185;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all sources belonging to an organization.
  ## 
  let valid = call_580202.validator(path, query, header, formData, body)
  let scheme = call_580202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580202.url(scheme.get, call_580202.host, call_580202.base,
                         call_580202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580202, url, valid)

proc call*(call_580203: Call_SecuritycenterOrganizationsSourcesList_580185;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## securitycenterOrganizationsSourcesList
  ## Lists all sources belonging to an organization.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The value returned by the last `ListSourcesResponse`; indicates
  ## that this is a continuation of a prior `ListSources` call, and
  ## that the system should return the next page of data.
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
  ##         : Resource name of the parent of sources to list. Its format should be
  ## "organizations/[organization_id]".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of results to return in a single response. Default is
  ## 10, minimum is 1, maximum is 1000.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580204 = newJObject()
  var query_580205 = newJObject()
  add(query_580205, "upload_protocol", newJString(uploadProtocol))
  add(query_580205, "fields", newJString(fields))
  add(query_580205, "pageToken", newJString(pageToken))
  add(query_580205, "quotaUser", newJString(quotaUser))
  add(query_580205, "alt", newJString(alt))
  add(query_580205, "oauth_token", newJString(oauthToken))
  add(query_580205, "callback", newJString(callback))
  add(query_580205, "access_token", newJString(accessToken))
  add(query_580205, "uploadType", newJString(uploadType))
  add(path_580204, "parent", newJString(parent))
  add(query_580205, "key", newJString(key))
  add(query_580205, "$.xgafv", newJString(Xgafv))
  add(query_580205, "pageSize", newJInt(pageSize))
  add(query_580205, "prettyPrint", newJBool(prettyPrint))
  result = call_580203.call(path_580204, query_580205, nil, nil, nil)

var securitycenterOrganizationsSourcesList* = Call_SecuritycenterOrganizationsSourcesList_580185(
    name: "securitycenterOrganizationsSourcesList", meth: HttpMethod.HttpGet,
    host: "securitycenter.googleapis.com", route: "/v1beta1/{parent}/sources",
    validator: validate_SecuritycenterOrganizationsSourcesList_580186, base: "/",
    url: url_SecuritycenterOrganizationsSourcesList_580187,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesGetIamPolicy_580227 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsSourcesGetIamPolicy_580229(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_SecuritycenterOrganizationsSourcesGetIamPolicy_580228(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the access control policy on the specified Source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580230 = path.getOrDefault("resource")
  valid_580230 = validateParameter(valid_580230, JString, required = true,
                                 default = nil)
  if valid_580230 != nil:
    section.add "resource", valid_580230
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
  var valid_580231 = query.getOrDefault("upload_protocol")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "upload_protocol", valid_580231
  var valid_580232 = query.getOrDefault("fields")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "fields", valid_580232
  var valid_580233 = query.getOrDefault("quotaUser")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "quotaUser", valid_580233
  var valid_580234 = query.getOrDefault("alt")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = newJString("json"))
  if valid_580234 != nil:
    section.add "alt", valid_580234
  var valid_580235 = query.getOrDefault("oauth_token")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "oauth_token", valid_580235
  var valid_580236 = query.getOrDefault("callback")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "callback", valid_580236
  var valid_580237 = query.getOrDefault("access_token")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "access_token", valid_580237
  var valid_580238 = query.getOrDefault("uploadType")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = nil)
  if valid_580238 != nil:
    section.add "uploadType", valid_580238
  var valid_580239 = query.getOrDefault("key")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "key", valid_580239
  var valid_580240 = query.getOrDefault("$.xgafv")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = newJString("1"))
  if valid_580240 != nil:
    section.add "$.xgafv", valid_580240
  var valid_580241 = query.getOrDefault("prettyPrint")
  valid_580241 = validateParameter(valid_580241, JBool, required = false,
                                 default = newJBool(true))
  if valid_580241 != nil:
    section.add "prettyPrint", valid_580241
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

proc call*(call_580243: Call_SecuritycenterOrganizationsSourcesGetIamPolicy_580227;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy on the specified Source.
  ## 
  let valid = call_580243.validator(path, query, header, formData, body)
  let scheme = call_580243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580243.url(scheme.get, call_580243.host, call_580243.base,
                         call_580243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580243, url, valid)

proc call*(call_580244: Call_SecuritycenterOrganizationsSourcesGetIamPolicy_580227;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## securitycenterOrganizationsSourcesGetIamPolicy
  ## Gets the access control policy on the specified Source.
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
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580245 = newJObject()
  var query_580246 = newJObject()
  var body_580247 = newJObject()
  add(query_580246, "upload_protocol", newJString(uploadProtocol))
  add(query_580246, "fields", newJString(fields))
  add(query_580246, "quotaUser", newJString(quotaUser))
  add(query_580246, "alt", newJString(alt))
  add(query_580246, "oauth_token", newJString(oauthToken))
  add(query_580246, "callback", newJString(callback))
  add(query_580246, "access_token", newJString(accessToken))
  add(query_580246, "uploadType", newJString(uploadType))
  add(query_580246, "key", newJString(key))
  add(query_580246, "$.xgafv", newJString(Xgafv))
  add(path_580245, "resource", newJString(resource))
  if body != nil:
    body_580247 = body
  add(query_580246, "prettyPrint", newJBool(prettyPrint))
  result = call_580244.call(path_580245, query_580246, nil, nil, body_580247)

var securitycenterOrganizationsSourcesGetIamPolicy* = Call_SecuritycenterOrganizationsSourcesGetIamPolicy_580227(
    name: "securitycenterOrganizationsSourcesGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1beta1/{resource}:getIamPolicy",
    validator: validate_SecuritycenterOrganizationsSourcesGetIamPolicy_580228,
    base: "/", url: url_SecuritycenterOrganizationsSourcesGetIamPolicy_580229,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesSetIamPolicy_580248 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsSourcesSetIamPolicy_580250(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_SecuritycenterOrganizationsSourcesSetIamPolicy_580249(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the access control policy on the specified Source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580251 = path.getOrDefault("resource")
  valid_580251 = validateParameter(valid_580251, JString, required = true,
                                 default = nil)
  if valid_580251 != nil:
    section.add "resource", valid_580251
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
  var valid_580252 = query.getOrDefault("upload_protocol")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "upload_protocol", valid_580252
  var valid_580253 = query.getOrDefault("fields")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "fields", valid_580253
  var valid_580254 = query.getOrDefault("quotaUser")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "quotaUser", valid_580254
  var valid_580255 = query.getOrDefault("alt")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = newJString("json"))
  if valid_580255 != nil:
    section.add "alt", valid_580255
  var valid_580256 = query.getOrDefault("oauth_token")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "oauth_token", valid_580256
  var valid_580257 = query.getOrDefault("callback")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "callback", valid_580257
  var valid_580258 = query.getOrDefault("access_token")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "access_token", valid_580258
  var valid_580259 = query.getOrDefault("uploadType")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "uploadType", valid_580259
  var valid_580260 = query.getOrDefault("key")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "key", valid_580260
  var valid_580261 = query.getOrDefault("$.xgafv")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = newJString("1"))
  if valid_580261 != nil:
    section.add "$.xgafv", valid_580261
  var valid_580262 = query.getOrDefault("prettyPrint")
  valid_580262 = validateParameter(valid_580262, JBool, required = false,
                                 default = newJBool(true))
  if valid_580262 != nil:
    section.add "prettyPrint", valid_580262
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

proc call*(call_580264: Call_SecuritycenterOrganizationsSourcesSetIamPolicy_580248;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified Source.
  ## 
  let valid = call_580264.validator(path, query, header, formData, body)
  let scheme = call_580264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580264.url(scheme.get, call_580264.host, call_580264.base,
                         call_580264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580264, url, valid)

proc call*(call_580265: Call_SecuritycenterOrganizationsSourcesSetIamPolicy_580248;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## securitycenterOrganizationsSourcesSetIamPolicy
  ## Sets the access control policy on the specified Source.
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
  var path_580266 = newJObject()
  var query_580267 = newJObject()
  var body_580268 = newJObject()
  add(query_580267, "upload_protocol", newJString(uploadProtocol))
  add(query_580267, "fields", newJString(fields))
  add(query_580267, "quotaUser", newJString(quotaUser))
  add(query_580267, "alt", newJString(alt))
  add(query_580267, "oauth_token", newJString(oauthToken))
  add(query_580267, "callback", newJString(callback))
  add(query_580267, "access_token", newJString(accessToken))
  add(query_580267, "uploadType", newJString(uploadType))
  add(query_580267, "key", newJString(key))
  add(query_580267, "$.xgafv", newJString(Xgafv))
  add(path_580266, "resource", newJString(resource))
  if body != nil:
    body_580268 = body
  add(query_580267, "prettyPrint", newJBool(prettyPrint))
  result = call_580265.call(path_580266, query_580267, nil, nil, body_580268)

var securitycenterOrganizationsSourcesSetIamPolicy* = Call_SecuritycenterOrganizationsSourcesSetIamPolicy_580248(
    name: "securitycenterOrganizationsSourcesSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1beta1/{resource}:setIamPolicy",
    validator: validate_SecuritycenterOrganizationsSourcesSetIamPolicy_580249,
    base: "/", url: url_SecuritycenterOrganizationsSourcesSetIamPolicy_580250,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesTestIamPermissions_580269 = ref object of OpenApiRestCall_579408
proc url_SecuritycenterOrganizationsSourcesTestIamPermissions_580271(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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

proc validate_SecuritycenterOrganizationsSourcesTestIamPermissions_580270(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns the permissions that a caller has on the specified source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_580272 = path.getOrDefault("resource")
  valid_580272 = validateParameter(valid_580272, JString, required = true,
                                 default = nil)
  if valid_580272 != nil:
    section.add "resource", valid_580272
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
  var valid_580273 = query.getOrDefault("upload_protocol")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "upload_protocol", valid_580273
  var valid_580274 = query.getOrDefault("fields")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "fields", valid_580274
  var valid_580275 = query.getOrDefault("quotaUser")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = nil)
  if valid_580275 != nil:
    section.add "quotaUser", valid_580275
  var valid_580276 = query.getOrDefault("alt")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = newJString("json"))
  if valid_580276 != nil:
    section.add "alt", valid_580276
  var valid_580277 = query.getOrDefault("oauth_token")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "oauth_token", valid_580277
  var valid_580278 = query.getOrDefault("callback")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "callback", valid_580278
  var valid_580279 = query.getOrDefault("access_token")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "access_token", valid_580279
  var valid_580280 = query.getOrDefault("uploadType")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "uploadType", valid_580280
  var valid_580281 = query.getOrDefault("key")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "key", valid_580281
  var valid_580282 = query.getOrDefault("$.xgafv")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = newJString("1"))
  if valid_580282 != nil:
    section.add "$.xgafv", valid_580282
  var valid_580283 = query.getOrDefault("prettyPrint")
  valid_580283 = validateParameter(valid_580283, JBool, required = false,
                                 default = newJBool(true))
  if valid_580283 != nil:
    section.add "prettyPrint", valid_580283
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

proc call*(call_580285: Call_SecuritycenterOrganizationsSourcesTestIamPermissions_580269;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the permissions that a caller has on the specified source.
  ## 
  let valid = call_580285.validator(path, query, header, formData, body)
  let scheme = call_580285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580285.url(scheme.get, call_580285.host, call_580285.base,
                         call_580285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580285, url, valid)

proc call*(call_580286: Call_SecuritycenterOrganizationsSourcesTestIamPermissions_580269;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## securitycenterOrganizationsSourcesTestIamPermissions
  ## Returns the permissions that a caller has on the specified source.
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
  var path_580287 = newJObject()
  var query_580288 = newJObject()
  var body_580289 = newJObject()
  add(query_580288, "upload_protocol", newJString(uploadProtocol))
  add(query_580288, "fields", newJString(fields))
  add(query_580288, "quotaUser", newJString(quotaUser))
  add(query_580288, "alt", newJString(alt))
  add(query_580288, "oauth_token", newJString(oauthToken))
  add(query_580288, "callback", newJString(callback))
  add(query_580288, "access_token", newJString(accessToken))
  add(query_580288, "uploadType", newJString(uploadType))
  add(query_580288, "key", newJString(key))
  add(query_580288, "$.xgafv", newJString(Xgafv))
  add(path_580287, "resource", newJString(resource))
  if body != nil:
    body_580289 = body
  add(query_580288, "prettyPrint", newJBool(prettyPrint))
  result = call_580286.call(path_580287, query_580288, nil, nil, body_580289)

var securitycenterOrganizationsSourcesTestIamPermissions* = Call_SecuritycenterOrganizationsSourcesTestIamPermissions_580269(
    name: "securitycenterOrganizationsSourcesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1beta1/{resource}:testIamPermissions",
    validator: validate_SecuritycenterOrganizationsSourcesTestIamPermissions_580270,
    base: "/", url: url_SecuritycenterOrganizationsSourcesTestIamPermissions_580271,
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
