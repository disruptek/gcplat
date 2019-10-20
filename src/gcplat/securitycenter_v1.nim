
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Security Command Center
## version: v1
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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
  gcpServiceName = "securitycenter"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SecuritycenterOrganizationsOperationsGet_578610 = ref object of OpenApiRestCall_578339
proc url_SecuritycenterOrganizationsOperationsGet_578612(protocol: Scheme;
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

proc validate_SecuritycenterOrganizationsOperationsGet_578611(path: JsonNode;
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
  var valid_578738 = path.getOrDefault("name")
  valid_578738 = validateParameter(valid_578738, JString, required = true,
                                 default = nil)
  if valid_578738 != nil:
    section.add "name", valid_578738
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
  var valid_578739 = query.getOrDefault("key")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "key", valid_578739
  var valid_578753 = query.getOrDefault("prettyPrint")
  valid_578753 = validateParameter(valid_578753, JBool, required = false,
                                 default = newJBool(true))
  if valid_578753 != nil:
    section.add "prettyPrint", valid_578753
  var valid_578754 = query.getOrDefault("oauth_token")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "oauth_token", valid_578754
  var valid_578755 = query.getOrDefault("$.xgafv")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = newJString("1"))
  if valid_578755 != nil:
    section.add "$.xgafv", valid_578755
  var valid_578756 = query.getOrDefault("alt")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = newJString("json"))
  if valid_578756 != nil:
    section.add "alt", valid_578756
  var valid_578757 = query.getOrDefault("uploadType")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "uploadType", valid_578757
  var valid_578758 = query.getOrDefault("quotaUser")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "quotaUser", valid_578758
  var valid_578759 = query.getOrDefault("callback")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "callback", valid_578759
  var valid_578760 = query.getOrDefault("fields")
  valid_578760 = validateParameter(valid_578760, JString, required = false,
                                 default = nil)
  if valid_578760 != nil:
    section.add "fields", valid_578760
  var valid_578761 = query.getOrDefault("access_token")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "access_token", valid_578761
  var valid_578762 = query.getOrDefault("upload_protocol")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = nil)
  if valid_578762 != nil:
    section.add "upload_protocol", valid_578762
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578785: Call_SecuritycenterOrganizationsOperationsGet_578610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_578785.validator(path, query, header, formData, body)
  let scheme = call_578785.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578785.url(scheme.get, call_578785.host, call_578785.base,
                         call_578785.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578785, url, valid)

proc call*(call_578856: Call_SecuritycenterOrganizationsOperationsGet_578610;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## securitycenterOrganizationsOperationsGet
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
  var path_578857 = newJObject()
  var query_578859 = newJObject()
  add(query_578859, "key", newJString(key))
  add(query_578859, "prettyPrint", newJBool(prettyPrint))
  add(query_578859, "oauth_token", newJString(oauthToken))
  add(query_578859, "$.xgafv", newJString(Xgafv))
  add(query_578859, "alt", newJString(alt))
  add(query_578859, "uploadType", newJString(uploadType))
  add(query_578859, "quotaUser", newJString(quotaUser))
  add(path_578857, "name", newJString(name))
  add(query_578859, "callback", newJString(callback))
  add(query_578859, "fields", newJString(fields))
  add(query_578859, "access_token", newJString(accessToken))
  add(query_578859, "upload_protocol", newJString(uploadProtocol))
  result = call_578856.call(path_578857, query_578859, nil, nil, nil)

var securitycenterOrganizationsOperationsGet* = Call_SecuritycenterOrganizationsOperationsGet_578610(
    name: "securitycenterOrganizationsOperationsGet", meth: HttpMethod.HttpGet,
    host: "securitycenter.googleapis.com", route: "/v1/{name}",
    validator: validate_SecuritycenterOrganizationsOperationsGet_578611,
    base: "/", url: url_SecuritycenterOrganizationsOperationsGet_578612,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsAssetsUpdateSecurityMarks_578917 = ref object of OpenApiRestCall_578339
proc url_SecuritycenterOrganizationsAssetsUpdateSecurityMarks_578919(
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

proc validate_SecuritycenterOrganizationsAssetsUpdateSecurityMarks_578918(
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
  var valid_578920 = path.getOrDefault("name")
  valid_578920 = validateParameter(valid_578920, JString, required = true,
                                 default = nil)
  if valid_578920 != nil:
    section.add "name", valid_578920
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
  ##   startTime: JString
  ##            : The time at which the updated SecurityMarks take effect.
  ## If not set uses current server time.  Updates will be applied to the
  ## SecurityMarks that are active immediately preceding this time.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: JString
  ##             : The FieldMask to use when updating the security marks resource.
  ## 
  ## The field mask must not contain duplicate fields.
  ## If empty or set to "marks", all marks will be replaced.  Individual
  ## marks can be updated using "marks.<mark_key>".
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578921 = query.getOrDefault("key")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "key", valid_578921
  var valid_578922 = query.getOrDefault("prettyPrint")
  valid_578922 = validateParameter(valid_578922, JBool, required = false,
                                 default = newJBool(true))
  if valid_578922 != nil:
    section.add "prettyPrint", valid_578922
  var valid_578923 = query.getOrDefault("oauth_token")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "oauth_token", valid_578923
  var valid_578924 = query.getOrDefault("$.xgafv")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = newJString("1"))
  if valid_578924 != nil:
    section.add "$.xgafv", valid_578924
  var valid_578925 = query.getOrDefault("startTime")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "startTime", valid_578925
  var valid_578926 = query.getOrDefault("alt")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = newJString("json"))
  if valid_578926 != nil:
    section.add "alt", valid_578926
  var valid_578927 = query.getOrDefault("uploadType")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "uploadType", valid_578927
  var valid_578928 = query.getOrDefault("quotaUser")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "quotaUser", valid_578928
  var valid_578929 = query.getOrDefault("updateMask")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "updateMask", valid_578929
  var valid_578930 = query.getOrDefault("callback")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "callback", valid_578930
  var valid_578931 = query.getOrDefault("fields")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "fields", valid_578931
  var valid_578932 = query.getOrDefault("access_token")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "access_token", valid_578932
  var valid_578933 = query.getOrDefault("upload_protocol")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "upload_protocol", valid_578933
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

proc call*(call_578935: Call_SecuritycenterOrganizationsAssetsUpdateSecurityMarks_578917;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates security marks.
  ## 
  let valid = call_578935.validator(path, query, header, formData, body)
  let scheme = call_578935.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578935.url(scheme.get, call_578935.host, call_578935.base,
                         call_578935.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578935, url, valid)

proc call*(call_578936: Call_SecuritycenterOrganizationsAssetsUpdateSecurityMarks_578917;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; startTime: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          updateMask: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## securitycenterOrganizationsAssetsUpdateSecurityMarks
  ## Updates security marks.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   startTime: string
  ##            : The time at which the updated SecurityMarks take effect.
  ## If not set uses current server time.  Updates will be applied to the
  ## SecurityMarks that are active immediately preceding this time.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The relative resource name of the SecurityMarks. See:
  ## https://cloud.google.com/apis/design/resource_names#relative_resource_name
  ## Examples:
  ## "organizations/123/assets/456/securityMarks"
  ## "organizations/123/sources/456/findings/789/securityMarks".
  ##   updateMask: string
  ##             : The FieldMask to use when updating the security marks resource.
  ## 
  ## The field mask must not contain duplicate fields.
  ## If empty or set to "marks", all marks will be replaced.  Individual
  ## marks can be updated using "marks.<mark_key>".
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578937 = newJObject()
  var query_578938 = newJObject()
  var body_578939 = newJObject()
  add(query_578938, "key", newJString(key))
  add(query_578938, "prettyPrint", newJBool(prettyPrint))
  add(query_578938, "oauth_token", newJString(oauthToken))
  add(query_578938, "$.xgafv", newJString(Xgafv))
  add(query_578938, "startTime", newJString(startTime))
  add(query_578938, "alt", newJString(alt))
  add(query_578938, "uploadType", newJString(uploadType))
  add(query_578938, "quotaUser", newJString(quotaUser))
  add(path_578937, "name", newJString(name))
  add(query_578938, "updateMask", newJString(updateMask))
  if body != nil:
    body_578939 = body
  add(query_578938, "callback", newJString(callback))
  add(query_578938, "fields", newJString(fields))
  add(query_578938, "access_token", newJString(accessToken))
  add(query_578938, "upload_protocol", newJString(uploadProtocol))
  result = call_578936.call(path_578937, query_578938, nil, nil, body_578939)

var securitycenterOrganizationsAssetsUpdateSecurityMarks* = Call_SecuritycenterOrganizationsAssetsUpdateSecurityMarks_578917(
    name: "securitycenterOrganizationsAssetsUpdateSecurityMarks",
    meth: HttpMethod.HttpPatch, host: "securitycenter.googleapis.com",
    route: "/v1/{name}",
    validator: validate_SecuritycenterOrganizationsAssetsUpdateSecurityMarks_578918,
    base: "/", url: url_SecuritycenterOrganizationsAssetsUpdateSecurityMarks_578919,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsOperationsDelete_578898 = ref object of OpenApiRestCall_578339
proc url_SecuritycenterOrganizationsOperationsDelete_578900(protocol: Scheme;
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

proc validate_SecuritycenterOrganizationsOperationsDelete_578899(path: JsonNode;
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
  var valid_578901 = path.getOrDefault("name")
  valid_578901 = validateParameter(valid_578901, JString, required = true,
                                 default = nil)
  if valid_578901 != nil:
    section.add "name", valid_578901
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
  var valid_578902 = query.getOrDefault("key")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = nil)
  if valid_578902 != nil:
    section.add "key", valid_578902
  var valid_578903 = query.getOrDefault("prettyPrint")
  valid_578903 = validateParameter(valid_578903, JBool, required = false,
                                 default = newJBool(true))
  if valid_578903 != nil:
    section.add "prettyPrint", valid_578903
  var valid_578904 = query.getOrDefault("oauth_token")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "oauth_token", valid_578904
  var valid_578905 = query.getOrDefault("$.xgafv")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = newJString("1"))
  if valid_578905 != nil:
    section.add "$.xgafv", valid_578905
  var valid_578906 = query.getOrDefault("alt")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = newJString("json"))
  if valid_578906 != nil:
    section.add "alt", valid_578906
  var valid_578907 = query.getOrDefault("uploadType")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "uploadType", valid_578907
  var valid_578908 = query.getOrDefault("quotaUser")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "quotaUser", valid_578908
  var valid_578909 = query.getOrDefault("callback")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "callback", valid_578909
  var valid_578910 = query.getOrDefault("fields")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "fields", valid_578910
  var valid_578911 = query.getOrDefault("access_token")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "access_token", valid_578911
  var valid_578912 = query.getOrDefault("upload_protocol")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "upload_protocol", valid_578912
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578913: Call_SecuritycenterOrganizationsOperationsDelete_578898;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_578913.validator(path, query, header, formData, body)
  let scheme = call_578913.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578913.url(scheme.get, call_578913.host, call_578913.base,
                         call_578913.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578913, url, valid)

proc call*(call_578914: Call_SecuritycenterOrganizationsOperationsDelete_578898;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## securitycenterOrganizationsOperationsDelete
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
  var path_578915 = newJObject()
  var query_578916 = newJObject()
  add(query_578916, "key", newJString(key))
  add(query_578916, "prettyPrint", newJBool(prettyPrint))
  add(query_578916, "oauth_token", newJString(oauthToken))
  add(query_578916, "$.xgafv", newJString(Xgafv))
  add(query_578916, "alt", newJString(alt))
  add(query_578916, "uploadType", newJString(uploadType))
  add(query_578916, "quotaUser", newJString(quotaUser))
  add(path_578915, "name", newJString(name))
  add(query_578916, "callback", newJString(callback))
  add(query_578916, "fields", newJString(fields))
  add(query_578916, "access_token", newJString(accessToken))
  add(query_578916, "upload_protocol", newJString(uploadProtocol))
  result = call_578914.call(path_578915, query_578916, nil, nil, nil)

var securitycenterOrganizationsOperationsDelete* = Call_SecuritycenterOrganizationsOperationsDelete_578898(
    name: "securitycenterOrganizationsOperationsDelete",
    meth: HttpMethod.HttpDelete, host: "securitycenter.googleapis.com",
    route: "/v1/{name}",
    validator: validate_SecuritycenterOrganizationsOperationsDelete_578899,
    base: "/", url: url_SecuritycenterOrganizationsOperationsDelete_578900,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsOperationsCancel_578940 = ref object of OpenApiRestCall_578339
proc url_SecuritycenterOrganizationsOperationsCancel_578942(protocol: Scheme;
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

proc validate_SecuritycenterOrganizationsOperationsCancel_578941(path: JsonNode;
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
  var valid_578943 = path.getOrDefault("name")
  valid_578943 = validateParameter(valid_578943, JString, required = true,
                                 default = nil)
  if valid_578943 != nil:
    section.add "name", valid_578943
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
  var valid_578944 = query.getOrDefault("key")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "key", valid_578944
  var valid_578945 = query.getOrDefault("prettyPrint")
  valid_578945 = validateParameter(valid_578945, JBool, required = false,
                                 default = newJBool(true))
  if valid_578945 != nil:
    section.add "prettyPrint", valid_578945
  var valid_578946 = query.getOrDefault("oauth_token")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "oauth_token", valid_578946
  var valid_578947 = query.getOrDefault("$.xgafv")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = newJString("1"))
  if valid_578947 != nil:
    section.add "$.xgafv", valid_578947
  var valid_578948 = query.getOrDefault("alt")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = newJString("json"))
  if valid_578948 != nil:
    section.add "alt", valid_578948
  var valid_578949 = query.getOrDefault("uploadType")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "uploadType", valid_578949
  var valid_578950 = query.getOrDefault("quotaUser")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "quotaUser", valid_578950
  var valid_578951 = query.getOrDefault("callback")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "callback", valid_578951
  var valid_578952 = query.getOrDefault("fields")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "fields", valid_578952
  var valid_578953 = query.getOrDefault("access_token")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "access_token", valid_578953
  var valid_578954 = query.getOrDefault("upload_protocol")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "upload_protocol", valid_578954
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578955: Call_SecuritycenterOrganizationsOperationsCancel_578940;
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
  let valid = call_578955.validator(path, query, header, formData, body)
  let scheme = call_578955.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578955.url(scheme.get, call_578955.host, call_578955.base,
                         call_578955.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578955, url, valid)

proc call*(call_578956: Call_SecuritycenterOrganizationsOperationsCancel_578940;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578957 = newJObject()
  var query_578958 = newJObject()
  add(query_578958, "key", newJString(key))
  add(query_578958, "prettyPrint", newJBool(prettyPrint))
  add(query_578958, "oauth_token", newJString(oauthToken))
  add(query_578958, "$.xgafv", newJString(Xgafv))
  add(query_578958, "alt", newJString(alt))
  add(query_578958, "uploadType", newJString(uploadType))
  add(query_578958, "quotaUser", newJString(quotaUser))
  add(path_578957, "name", newJString(name))
  add(query_578958, "callback", newJString(callback))
  add(query_578958, "fields", newJString(fields))
  add(query_578958, "access_token", newJString(accessToken))
  add(query_578958, "upload_protocol", newJString(uploadProtocol))
  result = call_578956.call(path_578957, query_578958, nil, nil, nil)

var securitycenterOrganizationsOperationsCancel* = Call_SecuritycenterOrganizationsOperationsCancel_578940(
    name: "securitycenterOrganizationsOperationsCancel",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{name}:cancel",
    validator: validate_SecuritycenterOrganizationsOperationsCancel_578941,
    base: "/", url: url_SecuritycenterOrganizationsOperationsCancel_578942,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesFindingsSetState_578959 = ref object of OpenApiRestCall_578339
proc url_SecuritycenterOrganizationsSourcesFindingsSetState_578961(
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
               (kind: ConstantSegment, value: ":setState")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsSourcesFindingsSetState_578960(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the state of a finding.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The relative resource name of the finding. See:
  ## https://cloud.google.com/apis/design/resource_names#relative_resource_name
  ## Example:
  ## "organizations/123/sources/456/finding/789".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578962 = path.getOrDefault("name")
  valid_578962 = validateParameter(valid_578962, JString, required = true,
                                 default = nil)
  if valid_578962 != nil:
    section.add "name", valid_578962
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
  var valid_578963 = query.getOrDefault("key")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "key", valid_578963
  var valid_578964 = query.getOrDefault("prettyPrint")
  valid_578964 = validateParameter(valid_578964, JBool, required = false,
                                 default = newJBool(true))
  if valid_578964 != nil:
    section.add "prettyPrint", valid_578964
  var valid_578965 = query.getOrDefault("oauth_token")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "oauth_token", valid_578965
  var valid_578966 = query.getOrDefault("$.xgafv")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = newJString("1"))
  if valid_578966 != nil:
    section.add "$.xgafv", valid_578966
  var valid_578967 = query.getOrDefault("alt")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = newJString("json"))
  if valid_578967 != nil:
    section.add "alt", valid_578967
  var valid_578968 = query.getOrDefault("uploadType")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "uploadType", valid_578968
  var valid_578969 = query.getOrDefault("quotaUser")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "quotaUser", valid_578969
  var valid_578970 = query.getOrDefault("callback")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "callback", valid_578970
  var valid_578971 = query.getOrDefault("fields")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "fields", valid_578971
  var valid_578972 = query.getOrDefault("access_token")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "access_token", valid_578972
  var valid_578973 = query.getOrDefault("upload_protocol")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "upload_protocol", valid_578973
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

proc call*(call_578975: Call_SecuritycenterOrganizationsSourcesFindingsSetState_578959;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the state of a finding.
  ## 
  let valid = call_578975.validator(path, query, header, formData, body)
  let scheme = call_578975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578975.url(scheme.get, call_578975.host, call_578975.base,
                         call_578975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578975, url, valid)

proc call*(call_578976: Call_SecuritycenterOrganizationsSourcesFindingsSetState_578959;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## securitycenterOrganizationsSourcesFindingsSetState
  ## Updates the state of a finding.
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
  ##       : Required. The relative resource name of the finding. See:
  ## https://cloud.google.com/apis/design/resource_names#relative_resource_name
  ## Example:
  ## "organizations/123/sources/456/finding/789".
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578977 = newJObject()
  var query_578978 = newJObject()
  var body_578979 = newJObject()
  add(query_578978, "key", newJString(key))
  add(query_578978, "prettyPrint", newJBool(prettyPrint))
  add(query_578978, "oauth_token", newJString(oauthToken))
  add(query_578978, "$.xgafv", newJString(Xgafv))
  add(query_578978, "alt", newJString(alt))
  add(query_578978, "uploadType", newJString(uploadType))
  add(query_578978, "quotaUser", newJString(quotaUser))
  add(path_578977, "name", newJString(name))
  if body != nil:
    body_578979 = body
  add(query_578978, "callback", newJString(callback))
  add(query_578978, "fields", newJString(fields))
  add(query_578978, "access_token", newJString(accessToken))
  add(query_578978, "upload_protocol", newJString(uploadProtocol))
  result = call_578976.call(path_578977, query_578978, nil, nil, body_578979)

var securitycenterOrganizationsSourcesFindingsSetState* = Call_SecuritycenterOrganizationsSourcesFindingsSetState_578959(
    name: "securitycenterOrganizationsSourcesFindingsSetState",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{name}:setState",
    validator: validate_SecuritycenterOrganizationsSourcesFindingsSetState_578960,
    base: "/", url: url_SecuritycenterOrganizationsSourcesFindingsSetState_578961,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsAssetsList_578980 = ref object of OpenApiRestCall_578339
proc url_SecuritycenterOrganizationsAssetsList_578982(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/assets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsAssetsList_578981(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists an organization's assets.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. Name of the organization assets should belong to. Its format is
  ## "organizations/[organization_id]".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_578983 = path.getOrDefault("parent")
  valid_578983 = validateParameter(valid_578983, JString, required = true,
                                 default = nil)
  if valid_578983 != nil:
    section.add "parent", valid_578983
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
  ##           : The maximum number of results to return in a single response. Default is
  ## 10, minimum is 1, maximum is 1000.
  ##   compareDuration: JString
  ##                  : When compare_duration is set, the ListAssetsResult's "state_change"
  ## attribute is updated to indicate whether the asset was added, removed, or
  ## remained present during the compare_duration period of time that precedes
  ## the read_time. This is the time between (read_time - compare_duration) and
  ## read_time.
  ## 
  ## The state_change value is derived based on the presence of the asset at the
  ## two points in time. Intermediate state changes between the two times don't
  ## affect the result. For example, the results aren't affected if the asset is
  ## removed and re-created again.
  ## 
  ## Possible "state_change" values when compare_duration is specified:
  ## 
  ## * "ADDED":   indicates that the asset was not present at the start of
  ##                compare_duration, but present at read_time.
  ## * "REMOVED": indicates that the asset was present at the start of
  ##                compare_duration, but not present at read_time.
  ## * "ACTIVE":  indicates that the asset was present at both the
  ##                start and the end of the time period defined by
  ##                compare_duration and read_time.
  ## 
  ## If compare_duration is not specified, then the only possible state_change
  ## is "UNUSED",  which will be the state_change set for all assets present at
  ## read_time.
  ##   readTime: JString
  ##           : Time used as a reference point when filtering assets. The filter is limited
  ## to assets existing at the supplied time and their values are those at that
  ## specific time. Absence of this field will default to the API's version of
  ## NOW.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   fieldMask: JString
  ##            : Optional. A field mask to specify the ListAssetsResult fields to be listed in the
  ## response.
  ## An empty field mask will list all fields.
  ##   orderBy: JString
  ##          : Expression that defines what fields and order to use for sorting. The
  ## string value should follow SQL syntax: comma separated list of fields. For
  ## example: "name,resource_properties.a_property". The default sorting order
  ## is ascending. To specify descending order for a field, a suffix " desc"
  ## should be appended to the field name. For example: "name
  ## desc,resource_properties.a_property". Redundant space characters in the
  ## syntax are insignificant. "name desc,resource_properties.a_property" and "
  ## name     desc  ,   resource_properties.a_property  " are equivalent.
  ## 
  ## The following fields are supported:
  ## name
  ## update_time
  ## resource_properties
  ## security_marks.marks
  ## security_center_properties.resource_name
  ## security_center_properties.resource_parent
  ## security_center_properties.resource_project
  ## security_center_properties.resource_type
  ##   filter: JString
  ##         : Expression that defines the filter to apply across assets.
  ## The expression is a list of zero or more restrictions combined via logical
  ## operators `AND` and `OR`.
  ## Parentheses are supported, and `OR` has higher precedence than `AND`.
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
  ## The following are the allowed field and operator combinations:
  ## 
  ## * name: `=`
  ## * update_time: `=`, `>`, `<`, `>=`, `<=`
  ## 
  ##   Usage: This should be milliseconds since epoch or an RFC3339 string.
  ##   Examples:
  ##     "update_time = \"2019-06-10T16:07:18-07:00\""
  ##     "update_time = 1560208038000"
  ## 
  ## * create_time: `=`, `>`, `<`, `>=`, `<=`
  ## 
  ##   Usage: This should be milliseconds since epoch or an RFC3339 string.
  ##   Examples:
  ##     "create_time = \"2019-06-10T16:07:18-07:00\""
  ##     "create_time = 1560208038000"
  ## 
  ## * iam_policy.policy_blob: `=`, `:`
  ## * resource_properties: `=`, `:`, `>`, `<`, `>=`, `<=`
  ## * security_marks.marks: `=`, `:`
  ## * security_center_properties.resource_name: `=`, `:`
  ## * security_center_properties.resource_type: `=`, `:`
  ## * security_center_properties.resource_parent: `=`, `:`
  ## * security_center_properties.resource_project: `=`, `:`
  ## * security_center_properties.resource_owners: `=`, `:`
  ## 
  ## For example, `resource_properties.size = 100` is a valid filter string.
  ##   pageToken: JString
  ##            : The value returned by the last `ListAssetsResponse`; indicates
  ## that this is a continuation of a prior `ListAssets` call, and
  ## that the system should return the next page of data.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578984 = query.getOrDefault("key")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "key", valid_578984
  var valid_578985 = query.getOrDefault("prettyPrint")
  valid_578985 = validateParameter(valid_578985, JBool, required = false,
                                 default = newJBool(true))
  if valid_578985 != nil:
    section.add "prettyPrint", valid_578985
  var valid_578986 = query.getOrDefault("oauth_token")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "oauth_token", valid_578986
  var valid_578987 = query.getOrDefault("$.xgafv")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = newJString("1"))
  if valid_578987 != nil:
    section.add "$.xgafv", valid_578987
  var valid_578988 = query.getOrDefault("pageSize")
  valid_578988 = validateParameter(valid_578988, JInt, required = false, default = nil)
  if valid_578988 != nil:
    section.add "pageSize", valid_578988
  var valid_578989 = query.getOrDefault("compareDuration")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "compareDuration", valid_578989
  var valid_578990 = query.getOrDefault("readTime")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "readTime", valid_578990
  var valid_578991 = query.getOrDefault("alt")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = newJString("json"))
  if valid_578991 != nil:
    section.add "alt", valid_578991
  var valid_578992 = query.getOrDefault("uploadType")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "uploadType", valid_578992
  var valid_578993 = query.getOrDefault("quotaUser")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "quotaUser", valid_578993
  var valid_578994 = query.getOrDefault("fieldMask")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "fieldMask", valid_578994
  var valid_578995 = query.getOrDefault("orderBy")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "orderBy", valid_578995
  var valid_578996 = query.getOrDefault("filter")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "filter", valid_578996
  var valid_578997 = query.getOrDefault("pageToken")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "pageToken", valid_578997
  var valid_578998 = query.getOrDefault("callback")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "callback", valid_578998
  var valid_578999 = query.getOrDefault("fields")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "fields", valid_578999
  var valid_579000 = query.getOrDefault("access_token")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "access_token", valid_579000
  var valid_579001 = query.getOrDefault("upload_protocol")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "upload_protocol", valid_579001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579002: Call_SecuritycenterOrganizationsAssetsList_578980;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists an organization's assets.
  ## 
  let valid = call_579002.validator(path, query, header, formData, body)
  let scheme = call_579002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579002.url(scheme.get, call_579002.host, call_579002.base,
                         call_579002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579002, url, valid)

proc call*(call_579003: Call_SecuritycenterOrganizationsAssetsList_578980;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          compareDuration: string = ""; readTime: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; fieldMask: string = "";
          orderBy: string = ""; filter: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## securitycenterOrganizationsAssetsList
  ## Lists an organization's assets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of results to return in a single response. Default is
  ## 10, minimum is 1, maximum is 1000.
  ##   compareDuration: string
  ##                  : When compare_duration is set, the ListAssetsResult's "state_change"
  ## attribute is updated to indicate whether the asset was added, removed, or
  ## remained present during the compare_duration period of time that precedes
  ## the read_time. This is the time between (read_time - compare_duration) and
  ## read_time.
  ## 
  ## The state_change value is derived based on the presence of the asset at the
  ## two points in time. Intermediate state changes between the two times don't
  ## affect the result. For example, the results aren't affected if the asset is
  ## removed and re-created again.
  ## 
  ## Possible "state_change" values when compare_duration is specified:
  ## 
  ## * "ADDED":   indicates that the asset was not present at the start of
  ##                compare_duration, but present at read_time.
  ## * "REMOVED": indicates that the asset was present at the start of
  ##                compare_duration, but not present at read_time.
  ## * "ACTIVE":  indicates that the asset was present at both the
  ##                start and the end of the time period defined by
  ##                compare_duration and read_time.
  ## 
  ## If compare_duration is not specified, then the only possible state_change
  ## is "UNUSED",  which will be the state_change set for all assets present at
  ## read_time.
  ##   readTime: string
  ##           : Time used as a reference point when filtering assets. The filter is limited
  ## to assets existing at the supplied time and their values are those at that
  ## specific time. Absence of this field will default to the API's version of
  ## NOW.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   fieldMask: string
  ##            : Optional. A field mask to specify the ListAssetsResult fields to be listed in the
  ## response.
  ## An empty field mask will list all fields.
  ##   orderBy: string
  ##          : Expression that defines what fields and order to use for sorting. The
  ## string value should follow SQL syntax: comma separated list of fields. For
  ## example: "name,resource_properties.a_property". The default sorting order
  ## is ascending. To specify descending order for a field, a suffix " desc"
  ## should be appended to the field name. For example: "name
  ## desc,resource_properties.a_property". Redundant space characters in the
  ## syntax are insignificant. "name desc,resource_properties.a_property" and "
  ## name     desc  ,   resource_properties.a_property  " are equivalent.
  ## 
  ## The following fields are supported:
  ## name
  ## update_time
  ## resource_properties
  ## security_marks.marks
  ## security_center_properties.resource_name
  ## security_center_properties.resource_parent
  ## security_center_properties.resource_project
  ## security_center_properties.resource_type
  ##   filter: string
  ##         : Expression that defines the filter to apply across assets.
  ## The expression is a list of zero or more restrictions combined via logical
  ## operators `AND` and `OR`.
  ## Parentheses are supported, and `OR` has higher precedence than `AND`.
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
  ## The following are the allowed field and operator combinations:
  ## 
  ## * name: `=`
  ## * update_time: `=`, `>`, `<`, `>=`, `<=`
  ## 
  ##   Usage: This should be milliseconds since epoch or an RFC3339 string.
  ##   Examples:
  ##     "update_time = \"2019-06-10T16:07:18-07:00\""
  ##     "update_time = 1560208038000"
  ## 
  ## * create_time: `=`, `>`, `<`, `>=`, `<=`
  ## 
  ##   Usage: This should be milliseconds since epoch or an RFC3339 string.
  ##   Examples:
  ##     "create_time = \"2019-06-10T16:07:18-07:00\""
  ##     "create_time = 1560208038000"
  ## 
  ## * iam_policy.policy_blob: `=`, `:`
  ## * resource_properties: `=`, `:`, `>`, `<`, `>=`, `<=`
  ## * security_marks.marks: `=`, `:`
  ## * security_center_properties.resource_name: `=`, `:`
  ## * security_center_properties.resource_type: `=`, `:`
  ## * security_center_properties.resource_parent: `=`, `:`
  ## * security_center_properties.resource_project: `=`, `:`
  ## * security_center_properties.resource_owners: `=`, `:`
  ## 
  ## For example, `resource_properties.size = 100` is a valid filter string.
  ##   pageToken: string
  ##            : The value returned by the last `ListAssetsResponse`; indicates
  ## that this is a continuation of a prior `ListAssets` call, and
  ## that the system should return the next page of data.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. Name of the organization assets should belong to. Its format is
  ## "organizations/[organization_id]".
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579004 = newJObject()
  var query_579005 = newJObject()
  add(query_579005, "key", newJString(key))
  add(query_579005, "prettyPrint", newJBool(prettyPrint))
  add(query_579005, "oauth_token", newJString(oauthToken))
  add(query_579005, "$.xgafv", newJString(Xgafv))
  add(query_579005, "pageSize", newJInt(pageSize))
  add(query_579005, "compareDuration", newJString(compareDuration))
  add(query_579005, "readTime", newJString(readTime))
  add(query_579005, "alt", newJString(alt))
  add(query_579005, "uploadType", newJString(uploadType))
  add(query_579005, "quotaUser", newJString(quotaUser))
  add(query_579005, "fieldMask", newJString(fieldMask))
  add(query_579005, "orderBy", newJString(orderBy))
  add(query_579005, "filter", newJString(filter))
  add(query_579005, "pageToken", newJString(pageToken))
  add(query_579005, "callback", newJString(callback))
  add(path_579004, "parent", newJString(parent))
  add(query_579005, "fields", newJString(fields))
  add(query_579005, "access_token", newJString(accessToken))
  add(query_579005, "upload_protocol", newJString(uploadProtocol))
  result = call_579003.call(path_579004, query_579005, nil, nil, nil)

var securitycenterOrganizationsAssetsList* = Call_SecuritycenterOrganizationsAssetsList_578980(
    name: "securitycenterOrganizationsAssetsList", meth: HttpMethod.HttpGet,
    host: "securitycenter.googleapis.com", route: "/v1/{parent}/assets",
    validator: validate_SecuritycenterOrganizationsAssetsList_578981, base: "/",
    url: url_SecuritycenterOrganizationsAssetsList_578982, schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsAssetsGroup_579006 = ref object of OpenApiRestCall_578339
proc url_SecuritycenterOrganizationsAssetsGroup_579008(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/assets:group")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsAssetsGroup_579007(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Filters an organization's assets and  groups them by their specified
  ## properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. Name of the organization to groupBy. Its format is
  ## "organizations/[organization_id]".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579009 = path.getOrDefault("parent")
  valid_579009 = validateParameter(valid_579009, JString, required = true,
                                 default = nil)
  if valid_579009 != nil:
    section.add "parent", valid_579009
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
  var valid_579010 = query.getOrDefault("key")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "key", valid_579010
  var valid_579011 = query.getOrDefault("prettyPrint")
  valid_579011 = validateParameter(valid_579011, JBool, required = false,
                                 default = newJBool(true))
  if valid_579011 != nil:
    section.add "prettyPrint", valid_579011
  var valid_579012 = query.getOrDefault("oauth_token")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "oauth_token", valid_579012
  var valid_579013 = query.getOrDefault("$.xgafv")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = newJString("1"))
  if valid_579013 != nil:
    section.add "$.xgafv", valid_579013
  var valid_579014 = query.getOrDefault("alt")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = newJString("json"))
  if valid_579014 != nil:
    section.add "alt", valid_579014
  var valid_579015 = query.getOrDefault("uploadType")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "uploadType", valid_579015
  var valid_579016 = query.getOrDefault("quotaUser")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "quotaUser", valid_579016
  var valid_579017 = query.getOrDefault("callback")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "callback", valid_579017
  var valid_579018 = query.getOrDefault("fields")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "fields", valid_579018
  var valid_579019 = query.getOrDefault("access_token")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "access_token", valid_579019
  var valid_579020 = query.getOrDefault("upload_protocol")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "upload_protocol", valid_579020
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

proc call*(call_579022: Call_SecuritycenterOrganizationsAssetsGroup_579006;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Filters an organization's assets and  groups them by their specified
  ## properties.
  ## 
  let valid = call_579022.validator(path, query, header, formData, body)
  let scheme = call_579022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579022.url(scheme.get, call_579022.host, call_579022.base,
                         call_579022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579022, url, valid)

proc call*(call_579023: Call_SecuritycenterOrganizationsAssetsGroup_579006;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## securitycenterOrganizationsAssetsGroup
  ## Filters an organization's assets and  groups them by their specified
  ## properties.
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
  ##         : Required. Name of the organization to groupBy. Its format is
  ## "organizations/[organization_id]".
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579024 = newJObject()
  var query_579025 = newJObject()
  var body_579026 = newJObject()
  add(query_579025, "key", newJString(key))
  add(query_579025, "prettyPrint", newJBool(prettyPrint))
  add(query_579025, "oauth_token", newJString(oauthToken))
  add(query_579025, "$.xgafv", newJString(Xgafv))
  add(query_579025, "alt", newJString(alt))
  add(query_579025, "uploadType", newJString(uploadType))
  add(query_579025, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579026 = body
  add(query_579025, "callback", newJString(callback))
  add(path_579024, "parent", newJString(parent))
  add(query_579025, "fields", newJString(fields))
  add(query_579025, "access_token", newJString(accessToken))
  add(query_579025, "upload_protocol", newJString(uploadProtocol))
  result = call_579023.call(path_579024, query_579025, nil, nil, body_579026)

var securitycenterOrganizationsAssetsGroup* = Call_SecuritycenterOrganizationsAssetsGroup_579006(
    name: "securitycenterOrganizationsAssetsGroup", meth: HttpMethod.HttpPost,
    host: "securitycenter.googleapis.com", route: "/v1/{parent}/assets:group",
    validator: validate_SecuritycenterOrganizationsAssetsGroup_579007, base: "/",
    url: url_SecuritycenterOrganizationsAssetsGroup_579008,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsAssetsRunDiscovery_579027 = ref object of OpenApiRestCall_578339
proc url_SecuritycenterOrganizationsAssetsRunDiscovery_579029(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/assets:runDiscovery")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsAssetsRunDiscovery_579028(
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
  ##         : Required. Name of the organization to run asset discovery for. Its format is
  ## "organizations/[organization_id]".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579030 = path.getOrDefault("parent")
  valid_579030 = validateParameter(valid_579030, JString, required = true,
                                 default = nil)
  if valid_579030 != nil:
    section.add "parent", valid_579030
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
  var valid_579031 = query.getOrDefault("key")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "key", valid_579031
  var valid_579032 = query.getOrDefault("prettyPrint")
  valid_579032 = validateParameter(valid_579032, JBool, required = false,
                                 default = newJBool(true))
  if valid_579032 != nil:
    section.add "prettyPrint", valid_579032
  var valid_579033 = query.getOrDefault("oauth_token")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "oauth_token", valid_579033
  var valid_579034 = query.getOrDefault("$.xgafv")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = newJString("1"))
  if valid_579034 != nil:
    section.add "$.xgafv", valid_579034
  var valid_579035 = query.getOrDefault("alt")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = newJString("json"))
  if valid_579035 != nil:
    section.add "alt", valid_579035
  var valid_579036 = query.getOrDefault("uploadType")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "uploadType", valid_579036
  var valid_579037 = query.getOrDefault("quotaUser")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "quotaUser", valid_579037
  var valid_579038 = query.getOrDefault("callback")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "callback", valid_579038
  var valid_579039 = query.getOrDefault("fields")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "fields", valid_579039
  var valid_579040 = query.getOrDefault("access_token")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "access_token", valid_579040
  var valid_579041 = query.getOrDefault("upload_protocol")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "upload_protocol", valid_579041
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

proc call*(call_579043: Call_SecuritycenterOrganizationsAssetsRunDiscovery_579027;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Runs asset discovery. The discovery is tracked with a long-running
  ## operation.
  ## 
  ## This API can only be called with limited frequency for an organization. If
  ## it is called too frequently the caller will receive a TOO_MANY_REQUESTS
  ## error.
  ## 
  let valid = call_579043.validator(path, query, header, formData, body)
  let scheme = call_579043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579043.url(scheme.get, call_579043.host, call_579043.base,
                         call_579043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579043, url, valid)

proc call*(call_579044: Call_SecuritycenterOrganizationsAssetsRunDiscovery_579027;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## securitycenterOrganizationsAssetsRunDiscovery
  ## Runs asset discovery. The discovery is tracked with a long-running
  ## operation.
  ## 
  ## This API can only be called with limited frequency for an organization. If
  ## it is called too frequently the caller will receive a TOO_MANY_REQUESTS
  ## error.
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
  ##         : Required. Name of the organization to run asset discovery for. Its format is
  ## "organizations/[organization_id]".
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579045 = newJObject()
  var query_579046 = newJObject()
  var body_579047 = newJObject()
  add(query_579046, "key", newJString(key))
  add(query_579046, "prettyPrint", newJBool(prettyPrint))
  add(query_579046, "oauth_token", newJString(oauthToken))
  add(query_579046, "$.xgafv", newJString(Xgafv))
  add(query_579046, "alt", newJString(alt))
  add(query_579046, "uploadType", newJString(uploadType))
  add(query_579046, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579047 = body
  add(query_579046, "callback", newJString(callback))
  add(path_579045, "parent", newJString(parent))
  add(query_579046, "fields", newJString(fields))
  add(query_579046, "access_token", newJString(accessToken))
  add(query_579046, "upload_protocol", newJString(uploadProtocol))
  result = call_579044.call(path_579045, query_579046, nil, nil, body_579047)

var securitycenterOrganizationsAssetsRunDiscovery* = Call_SecuritycenterOrganizationsAssetsRunDiscovery_579027(
    name: "securitycenterOrganizationsAssetsRunDiscovery",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{parent}/assets:runDiscovery",
    validator: validate_SecuritycenterOrganizationsAssetsRunDiscovery_579028,
    base: "/", url: url_SecuritycenterOrganizationsAssetsRunDiscovery_579029,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesFindingsCreate_579074 = ref object of OpenApiRestCall_578339
proc url_SecuritycenterOrganizationsSourcesFindingsCreate_579076(
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
               (kind: ConstantSegment, value: "/findings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsSourcesFindingsCreate_579075(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a finding. The corresponding source must exist for finding creation
  ## to succeed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. Resource name of the new finding's parent. Its format should be
  ## "organizations/[organization_id]/sources/[source_id]".
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
  ##   findingId: JString
  ##            : Required. Unique identifier provided by the client within the parent scope.
  ## It must be alphanumeric and less than or equal to 32 characters and
  ## greater than 0 characters in length.
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
  var valid_579085 = query.getOrDefault("findingId")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "findingId", valid_579085
  var valid_579086 = query.getOrDefault("callback")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "callback", valid_579086
  var valid_579087 = query.getOrDefault("fields")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "fields", valid_579087
  var valid_579088 = query.getOrDefault("access_token")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "access_token", valid_579088
  var valid_579089 = query.getOrDefault("upload_protocol")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "upload_protocol", valid_579089
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

proc call*(call_579091: Call_SecuritycenterOrganizationsSourcesFindingsCreate_579074;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a finding. The corresponding source must exist for finding creation
  ## to succeed.
  ## 
  let valid = call_579091.validator(path, query, header, formData, body)
  let scheme = call_579091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579091.url(scheme.get, call_579091.host, call_579091.base,
                         call_579091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579091, url, valid)

proc call*(call_579092: Call_SecuritycenterOrganizationsSourcesFindingsCreate_579074;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; findingId: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## securitycenterOrganizationsSourcesFindingsCreate
  ## Creates a finding. The corresponding source must exist for finding creation
  ## to succeed.
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
  ##   findingId: string
  ##            : Required. Unique identifier provided by the client within the parent scope.
  ## It must be alphanumeric and less than or equal to 32 characters and
  ## greater than 0 characters in length.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. Resource name of the new finding's parent. Its format should be
  ## "organizations/[organization_id]/sources/[source_id]".
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579093 = newJObject()
  var query_579094 = newJObject()
  var body_579095 = newJObject()
  add(query_579094, "key", newJString(key))
  add(query_579094, "prettyPrint", newJBool(prettyPrint))
  add(query_579094, "oauth_token", newJString(oauthToken))
  add(query_579094, "$.xgafv", newJString(Xgafv))
  add(query_579094, "alt", newJString(alt))
  add(query_579094, "uploadType", newJString(uploadType))
  add(query_579094, "quotaUser", newJString(quotaUser))
  add(query_579094, "findingId", newJString(findingId))
  if body != nil:
    body_579095 = body
  add(query_579094, "callback", newJString(callback))
  add(path_579093, "parent", newJString(parent))
  add(query_579094, "fields", newJString(fields))
  add(query_579094, "access_token", newJString(accessToken))
  add(query_579094, "upload_protocol", newJString(uploadProtocol))
  result = call_579092.call(path_579093, query_579094, nil, nil, body_579095)

var securitycenterOrganizationsSourcesFindingsCreate* = Call_SecuritycenterOrganizationsSourcesFindingsCreate_579074(
    name: "securitycenterOrganizationsSourcesFindingsCreate",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{parent}/findings",
    validator: validate_SecuritycenterOrganizationsSourcesFindingsCreate_579075,
    base: "/", url: url_SecuritycenterOrganizationsSourcesFindingsCreate_579076,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesFindingsList_579048 = ref object of OpenApiRestCall_578339
proc url_SecuritycenterOrganizationsSourcesFindingsList_579050(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/findings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsSourcesFindingsList_579049(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists an organization or source's findings.
  ## 
  ## To list across all sources provide a `-` as the source id.
  ## Example: /v1/organizations/123/sources/-/findings
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. Name of the source the findings belong to. Its format is
  ## "organizations/[organization_id]/sources/[source_id]". To list across all
  ## sources provide a source_id of `-`. For example:
  ## organizations/123/sources/-
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579051 = path.getOrDefault("parent")
  valid_579051 = validateParameter(valid_579051, JString, required = true,
                                 default = nil)
  if valid_579051 != nil:
    section.add "parent", valid_579051
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
  ##           : The maximum number of results to return in a single response. Default is
  ## 10, minimum is 1, maximum is 1000.
  ##   compareDuration: JString
  ##                  : When compare_duration is set, the ListFindingsResult's "state_change"
  ## attribute is updated to indicate whether the finding had its state changed,
  ## the finding's state remained unchanged, or if the finding was added in any
  ## state during the compare_duration period of time that precedes the
  ## read_time. This is the time between (read_time - compare_duration) and
  ## read_time.
  ## 
  ## The state_change value is derived based on the presence and state of the
  ## finding at the two points in time. Intermediate state changes between the
  ## two times don't affect the result. For example, the results aren't affected
  ## if the finding is made inactive and then active again.
  ## 
  ## Possible "state_change" values when compare_duration is specified:
  ## 
  ## * "CHANGED":   indicates that the finding was present at the start of
  ##                  compare_duration, but changed its state at read_time.
  ## * "UNCHANGED": indicates that the finding was present at the start of
  ##                  compare_duration and did not change state at read_time.
  ## * "ADDED":     indicates that the finding was not present at the start
  ##                  of compare_duration, but was present at read_time.
  ## 
  ## If compare_duration is not specified, then the only possible state_change
  ## is "UNUSED", which will be the state_change set for all findings present at
  ## read_time.
  ##   readTime: JString
  ##           : Time used as a reference point when filtering findings. The filter is
  ## limited to findings existing at the supplied time and their values are
  ## those at that specific time. Absence of this field will default to the
  ## API's version of NOW.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   fieldMask: JString
  ##            : Optional. A field mask to specify the Finding fields to be listed in the response.
  ## An empty field mask will list all fields.
  ##   orderBy: JString
  ##          : Expression that defines what fields and order to use for sorting. The
  ## string value should follow SQL syntax: comma separated list of fields. For
  ## example: "name,resource_properties.a_property". The default sorting order
  ## is ascending. To specify descending order for a field, a suffix " desc"
  ## should be appended to the field name. For example: "name
  ## desc,source_properties.a_property". Redundant space characters in the
  ## syntax are insignificant. "name desc,source_properties.a_property" and "
  ## name     desc  ,   source_properties.a_property  " are equivalent.
  ## 
  ## The following fields are supported:
  ## name
  ## parent
  ## state
  ## category
  ## resource_name
  ## event_time
  ## source_properties
  ## security_marks.marks
  ##   filter: JString
  ##         : Expression that defines the filter to apply across findings.
  ## The expression is a list of one or more restrictions combined via logical
  ## operators `AND` and `OR`.
  ## Parentheses are supported, and `OR` has higher precedence than `AND`.
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
  ## The following field and operator combinations are supported:
  ## 
  ## name: `=`
  ## parent: `=`, `:`
  ## resource_name: `=`, `:`
  ## state: `=`, `:`
  ## category: `=`, `:`
  ## external_uri: `=`, `:`
  ## event_time: `=`, `>`, `<`, `>=`, `<=`
  ## 
  ##   Usage: This should be milliseconds since epoch or an RFC3339 string.
  ##   Examples:
  ##     "event_time = \"2019-06-10T16:07:18-07:00\""
  ##     "event_time = 1560208038000"
  ## 
  ## security_marks.marks: `=`, `:`
  ## source_properties: `=`, `:`, `>`, `<`, `>=`, `<=`
  ## 
  ## For example, `source_properties.size = 100` is a valid filter string.
  ##   pageToken: JString
  ##            : The value returned by the last `ListFindingsResponse`; indicates
  ## that this is a continuation of a prior `ListFindings` call, and
  ## that the system should return the next page of data.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579052 = query.getOrDefault("key")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "key", valid_579052
  var valid_579053 = query.getOrDefault("prettyPrint")
  valid_579053 = validateParameter(valid_579053, JBool, required = false,
                                 default = newJBool(true))
  if valid_579053 != nil:
    section.add "prettyPrint", valid_579053
  var valid_579054 = query.getOrDefault("oauth_token")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "oauth_token", valid_579054
  var valid_579055 = query.getOrDefault("$.xgafv")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = newJString("1"))
  if valid_579055 != nil:
    section.add "$.xgafv", valid_579055
  var valid_579056 = query.getOrDefault("pageSize")
  valid_579056 = validateParameter(valid_579056, JInt, required = false, default = nil)
  if valid_579056 != nil:
    section.add "pageSize", valid_579056
  var valid_579057 = query.getOrDefault("compareDuration")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "compareDuration", valid_579057
  var valid_579058 = query.getOrDefault("readTime")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "readTime", valid_579058
  var valid_579059 = query.getOrDefault("alt")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = newJString("json"))
  if valid_579059 != nil:
    section.add "alt", valid_579059
  var valid_579060 = query.getOrDefault("uploadType")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "uploadType", valid_579060
  var valid_579061 = query.getOrDefault("quotaUser")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "quotaUser", valid_579061
  var valid_579062 = query.getOrDefault("fieldMask")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "fieldMask", valid_579062
  var valid_579063 = query.getOrDefault("orderBy")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "orderBy", valid_579063
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

proc call*(call_579070: Call_SecuritycenterOrganizationsSourcesFindingsList_579048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists an organization or source's findings.
  ## 
  ## To list across all sources provide a `-` as the source id.
  ## Example: /v1/organizations/123/sources/-/findings
  ## 
  let valid = call_579070.validator(path, query, header, formData, body)
  let scheme = call_579070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579070.url(scheme.get, call_579070.host, call_579070.base,
                         call_579070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579070, url, valid)

proc call*(call_579071: Call_SecuritycenterOrganizationsSourcesFindingsList_579048;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          compareDuration: string = ""; readTime: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; fieldMask: string = "";
          orderBy: string = ""; filter: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## securitycenterOrganizationsSourcesFindingsList
  ## Lists an organization or source's findings.
  ## 
  ## To list across all sources provide a `-` as the source id.
  ## Example: /v1/organizations/123/sources/-/findings
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of results to return in a single response. Default is
  ## 10, minimum is 1, maximum is 1000.
  ##   compareDuration: string
  ##                  : When compare_duration is set, the ListFindingsResult's "state_change"
  ## attribute is updated to indicate whether the finding had its state changed,
  ## the finding's state remained unchanged, or if the finding was added in any
  ## state during the compare_duration period of time that precedes the
  ## read_time. This is the time between (read_time - compare_duration) and
  ## read_time.
  ## 
  ## The state_change value is derived based on the presence and state of the
  ## finding at the two points in time. Intermediate state changes between the
  ## two times don't affect the result. For example, the results aren't affected
  ## if the finding is made inactive and then active again.
  ## 
  ## Possible "state_change" values when compare_duration is specified:
  ## 
  ## * "CHANGED":   indicates that the finding was present at the start of
  ##                  compare_duration, but changed its state at read_time.
  ## * "UNCHANGED": indicates that the finding was present at the start of
  ##                  compare_duration and did not change state at read_time.
  ## * "ADDED":     indicates that the finding was not present at the start
  ##                  of compare_duration, but was present at read_time.
  ## 
  ## If compare_duration is not specified, then the only possible state_change
  ## is "UNUSED", which will be the state_change set for all findings present at
  ## read_time.
  ##   readTime: string
  ##           : Time used as a reference point when filtering findings. The filter is
  ## limited to findings existing at the supplied time and their values are
  ## those at that specific time. Absence of this field will default to the
  ## API's version of NOW.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   fieldMask: string
  ##            : Optional. A field mask to specify the Finding fields to be listed in the response.
  ## An empty field mask will list all fields.
  ##   orderBy: string
  ##          : Expression that defines what fields and order to use for sorting. The
  ## string value should follow SQL syntax: comma separated list of fields. For
  ## example: "name,resource_properties.a_property". The default sorting order
  ## is ascending. To specify descending order for a field, a suffix " desc"
  ## should be appended to the field name. For example: "name
  ## desc,source_properties.a_property". Redundant space characters in the
  ## syntax are insignificant. "name desc,source_properties.a_property" and "
  ## name     desc  ,   source_properties.a_property  " are equivalent.
  ## 
  ## The following fields are supported:
  ## name
  ## parent
  ## state
  ## category
  ## resource_name
  ## event_time
  ## source_properties
  ## security_marks.marks
  ##   filter: string
  ##         : Expression that defines the filter to apply across findings.
  ## The expression is a list of one or more restrictions combined via logical
  ## operators `AND` and `OR`.
  ## Parentheses are supported, and `OR` has higher precedence than `AND`.
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
  ## The following field and operator combinations are supported:
  ## 
  ## name: `=`
  ## parent: `=`, `:`
  ## resource_name: `=`, `:`
  ## state: `=`, `:`
  ## category: `=`, `:`
  ## external_uri: `=`, `:`
  ## event_time: `=`, `>`, `<`, `>=`, `<=`
  ## 
  ##   Usage: This should be milliseconds since epoch or an RFC3339 string.
  ##   Examples:
  ##     "event_time = \"2019-06-10T16:07:18-07:00\""
  ##     "event_time = 1560208038000"
  ## 
  ## security_marks.marks: `=`, `:`
  ## source_properties: `=`, `:`, `>`, `<`, `>=`, `<=`
  ## 
  ## For example, `source_properties.size = 100` is a valid filter string.
  ##   pageToken: string
  ##            : The value returned by the last `ListFindingsResponse`; indicates
  ## that this is a continuation of a prior `ListFindings` call, and
  ## that the system should return the next page of data.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. Name of the source the findings belong to. Its format is
  ## "organizations/[organization_id]/sources/[source_id]". To list across all
  ## sources provide a source_id of `-`. For example:
  ## organizations/123/sources/-
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
  add(query_579073, "compareDuration", newJString(compareDuration))
  add(query_579073, "readTime", newJString(readTime))
  add(query_579073, "alt", newJString(alt))
  add(query_579073, "uploadType", newJString(uploadType))
  add(query_579073, "quotaUser", newJString(quotaUser))
  add(query_579073, "fieldMask", newJString(fieldMask))
  add(query_579073, "orderBy", newJString(orderBy))
  add(query_579073, "filter", newJString(filter))
  add(query_579073, "pageToken", newJString(pageToken))
  add(query_579073, "callback", newJString(callback))
  add(path_579072, "parent", newJString(parent))
  add(query_579073, "fields", newJString(fields))
  add(query_579073, "access_token", newJString(accessToken))
  add(query_579073, "upload_protocol", newJString(uploadProtocol))
  result = call_579071.call(path_579072, query_579073, nil, nil, nil)

var securitycenterOrganizationsSourcesFindingsList* = Call_SecuritycenterOrganizationsSourcesFindingsList_579048(
    name: "securitycenterOrganizationsSourcesFindingsList",
    meth: HttpMethod.HttpGet, host: "securitycenter.googleapis.com",
    route: "/v1/{parent}/findings",
    validator: validate_SecuritycenterOrganizationsSourcesFindingsList_579049,
    base: "/", url: url_SecuritycenterOrganizationsSourcesFindingsList_579050,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesFindingsGroup_579096 = ref object of OpenApiRestCall_578339
proc url_SecuritycenterOrganizationsSourcesFindingsGroup_579098(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/findings:group")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsSourcesFindingsGroup_579097(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Filters an organization or source's findings and  groups them by their
  ## specified properties.
  ## 
  ## To group across all sources provide a `-` as the source id.
  ## Example: /v1/organizations/123/sources/-/findings
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. Name of the source to groupBy. Its format is
  ## "organizations/[organization_id]/sources/[source_id]". To groupBy across
  ## all sources provide a source_id of `-`. For example:
  ## organizations/123/sources/-
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579099 = path.getOrDefault("parent")
  valid_579099 = validateParameter(valid_579099, JString, required = true,
                                 default = nil)
  if valid_579099 != nil:
    section.add "parent", valid_579099
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
  var valid_579100 = query.getOrDefault("key")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "key", valid_579100
  var valid_579101 = query.getOrDefault("prettyPrint")
  valid_579101 = validateParameter(valid_579101, JBool, required = false,
                                 default = newJBool(true))
  if valid_579101 != nil:
    section.add "prettyPrint", valid_579101
  var valid_579102 = query.getOrDefault("oauth_token")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "oauth_token", valid_579102
  var valid_579103 = query.getOrDefault("$.xgafv")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = newJString("1"))
  if valid_579103 != nil:
    section.add "$.xgafv", valid_579103
  var valid_579104 = query.getOrDefault("alt")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = newJString("json"))
  if valid_579104 != nil:
    section.add "alt", valid_579104
  var valid_579105 = query.getOrDefault("uploadType")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "uploadType", valid_579105
  var valid_579106 = query.getOrDefault("quotaUser")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "quotaUser", valid_579106
  var valid_579107 = query.getOrDefault("callback")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "callback", valid_579107
  var valid_579108 = query.getOrDefault("fields")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "fields", valid_579108
  var valid_579109 = query.getOrDefault("access_token")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "access_token", valid_579109
  var valid_579110 = query.getOrDefault("upload_protocol")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "upload_protocol", valid_579110
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

proc call*(call_579112: Call_SecuritycenterOrganizationsSourcesFindingsGroup_579096;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Filters an organization or source's findings and  groups them by their
  ## specified properties.
  ## 
  ## To group across all sources provide a `-` as the source id.
  ## Example: /v1/organizations/123/sources/-/findings
  ## 
  let valid = call_579112.validator(path, query, header, formData, body)
  let scheme = call_579112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579112.url(scheme.get, call_579112.host, call_579112.base,
                         call_579112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579112, url, valid)

proc call*(call_579113: Call_SecuritycenterOrganizationsSourcesFindingsGroup_579096;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## securitycenterOrganizationsSourcesFindingsGroup
  ## Filters an organization or source's findings and  groups them by their
  ## specified properties.
  ## 
  ## To group across all sources provide a `-` as the source id.
  ## Example: /v1/organizations/123/sources/-/findings
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
  ##         : Required. Name of the source to groupBy. Its format is
  ## "organizations/[organization_id]/sources/[source_id]". To groupBy across
  ## all sources provide a source_id of `-`. For example:
  ## organizations/123/sources/-
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579114 = newJObject()
  var query_579115 = newJObject()
  var body_579116 = newJObject()
  add(query_579115, "key", newJString(key))
  add(query_579115, "prettyPrint", newJBool(prettyPrint))
  add(query_579115, "oauth_token", newJString(oauthToken))
  add(query_579115, "$.xgafv", newJString(Xgafv))
  add(query_579115, "alt", newJString(alt))
  add(query_579115, "uploadType", newJString(uploadType))
  add(query_579115, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579116 = body
  add(query_579115, "callback", newJString(callback))
  add(path_579114, "parent", newJString(parent))
  add(query_579115, "fields", newJString(fields))
  add(query_579115, "access_token", newJString(accessToken))
  add(query_579115, "upload_protocol", newJString(uploadProtocol))
  result = call_579113.call(path_579114, query_579115, nil, nil, body_579116)

var securitycenterOrganizationsSourcesFindingsGroup* = Call_SecuritycenterOrganizationsSourcesFindingsGroup_579096(
    name: "securitycenterOrganizationsSourcesFindingsGroup",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{parent}/findings:group",
    validator: validate_SecuritycenterOrganizationsSourcesFindingsGroup_579097,
    base: "/", url: url_SecuritycenterOrganizationsSourcesFindingsGroup_579098,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesCreate_579138 = ref object of OpenApiRestCall_578339
proc url_SecuritycenterOrganizationsSourcesCreate_579140(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/sources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsSourcesCreate_579139(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. Resource name of the new source's parent. Its format should be
  ## "organizations/[organization_id]".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579141 = path.getOrDefault("parent")
  valid_579141 = validateParameter(valid_579141, JString, required = true,
                                 default = nil)
  if valid_579141 != nil:
    section.add "parent", valid_579141
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
  var valid_579142 = query.getOrDefault("key")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "key", valid_579142
  var valid_579143 = query.getOrDefault("prettyPrint")
  valid_579143 = validateParameter(valid_579143, JBool, required = false,
                                 default = newJBool(true))
  if valid_579143 != nil:
    section.add "prettyPrint", valid_579143
  var valid_579144 = query.getOrDefault("oauth_token")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "oauth_token", valid_579144
  var valid_579145 = query.getOrDefault("$.xgafv")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = newJString("1"))
  if valid_579145 != nil:
    section.add "$.xgafv", valid_579145
  var valid_579146 = query.getOrDefault("alt")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = newJString("json"))
  if valid_579146 != nil:
    section.add "alt", valid_579146
  var valid_579147 = query.getOrDefault("uploadType")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "uploadType", valid_579147
  var valid_579148 = query.getOrDefault("quotaUser")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "quotaUser", valid_579148
  var valid_579149 = query.getOrDefault("callback")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = nil)
  if valid_579149 != nil:
    section.add "callback", valid_579149
  var valid_579150 = query.getOrDefault("fields")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = nil)
  if valid_579150 != nil:
    section.add "fields", valid_579150
  var valid_579151 = query.getOrDefault("access_token")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = nil)
  if valid_579151 != nil:
    section.add "access_token", valid_579151
  var valid_579152 = query.getOrDefault("upload_protocol")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = nil)
  if valid_579152 != nil:
    section.add "upload_protocol", valid_579152
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

proc call*(call_579154: Call_SecuritycenterOrganizationsSourcesCreate_579138;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a source.
  ## 
  let valid = call_579154.validator(path, query, header, formData, body)
  let scheme = call_579154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579154.url(scheme.get, call_579154.host, call_579154.base,
                         call_579154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579154, url, valid)

proc call*(call_579155: Call_SecuritycenterOrganizationsSourcesCreate_579138;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## securitycenterOrganizationsSourcesCreate
  ## Creates a source.
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
  ##         : Required. Resource name of the new source's parent. Its format should be
  ## "organizations/[organization_id]".
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579156 = newJObject()
  var query_579157 = newJObject()
  var body_579158 = newJObject()
  add(query_579157, "key", newJString(key))
  add(query_579157, "prettyPrint", newJBool(prettyPrint))
  add(query_579157, "oauth_token", newJString(oauthToken))
  add(query_579157, "$.xgafv", newJString(Xgafv))
  add(query_579157, "alt", newJString(alt))
  add(query_579157, "uploadType", newJString(uploadType))
  add(query_579157, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579158 = body
  add(query_579157, "callback", newJString(callback))
  add(path_579156, "parent", newJString(parent))
  add(query_579157, "fields", newJString(fields))
  add(query_579157, "access_token", newJString(accessToken))
  add(query_579157, "upload_protocol", newJString(uploadProtocol))
  result = call_579155.call(path_579156, query_579157, nil, nil, body_579158)

var securitycenterOrganizationsSourcesCreate* = Call_SecuritycenterOrganizationsSourcesCreate_579138(
    name: "securitycenterOrganizationsSourcesCreate", meth: HttpMethod.HttpPost,
    host: "securitycenter.googleapis.com", route: "/v1/{parent}/sources",
    validator: validate_SecuritycenterOrganizationsSourcesCreate_579139,
    base: "/", url: url_SecuritycenterOrganizationsSourcesCreate_579140,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesList_579117 = ref object of OpenApiRestCall_578339
proc url_SecuritycenterOrganizationsSourcesList_579119(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/sources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsSourcesList_579118(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all sources belonging to an organization.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. Resource name of the parent of sources to list. Its format should be
  ## "organizations/[organization_id]".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579120 = path.getOrDefault("parent")
  valid_579120 = validateParameter(valid_579120, JString, required = true,
                                 default = nil)
  if valid_579120 != nil:
    section.add "parent", valid_579120
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
  ##           : The maximum number of results to return in a single response. Default is
  ## 10, minimum is 1, maximum is 1000.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The value returned by the last `ListSourcesResponse`; indicates
  ## that this is a continuation of a prior `ListSources` call, and
  ## that the system should return the next page of data.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579121 = query.getOrDefault("key")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "key", valid_579121
  var valid_579122 = query.getOrDefault("prettyPrint")
  valid_579122 = validateParameter(valid_579122, JBool, required = false,
                                 default = newJBool(true))
  if valid_579122 != nil:
    section.add "prettyPrint", valid_579122
  var valid_579123 = query.getOrDefault("oauth_token")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "oauth_token", valid_579123
  var valid_579124 = query.getOrDefault("$.xgafv")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = newJString("1"))
  if valid_579124 != nil:
    section.add "$.xgafv", valid_579124
  var valid_579125 = query.getOrDefault("pageSize")
  valid_579125 = validateParameter(valid_579125, JInt, required = false, default = nil)
  if valid_579125 != nil:
    section.add "pageSize", valid_579125
  var valid_579126 = query.getOrDefault("alt")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = newJString("json"))
  if valid_579126 != nil:
    section.add "alt", valid_579126
  var valid_579127 = query.getOrDefault("uploadType")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "uploadType", valid_579127
  var valid_579128 = query.getOrDefault("quotaUser")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "quotaUser", valid_579128
  var valid_579129 = query.getOrDefault("pageToken")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "pageToken", valid_579129
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

proc call*(call_579134: Call_SecuritycenterOrganizationsSourcesList_579117;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all sources belonging to an organization.
  ## 
  let valid = call_579134.validator(path, query, header, formData, body)
  let scheme = call_579134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579134.url(scheme.get, call_579134.host, call_579134.base,
                         call_579134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579134, url, valid)

proc call*(call_579135: Call_SecuritycenterOrganizationsSourcesList_579117;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## securitycenterOrganizationsSourcesList
  ## Lists all sources belonging to an organization.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of results to return in a single response. Default is
  ## 10, minimum is 1, maximum is 1000.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The value returned by the last `ListSourcesResponse`; indicates
  ## that this is a continuation of a prior `ListSources` call, and
  ## that the system should return the next page of data.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. Resource name of the parent of sources to list. Its format should be
  ## "organizations/[organization_id]".
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
  add(query_579137, "callback", newJString(callback))
  add(path_579136, "parent", newJString(parent))
  add(query_579137, "fields", newJString(fields))
  add(query_579137, "access_token", newJString(accessToken))
  add(query_579137, "upload_protocol", newJString(uploadProtocol))
  result = call_579135.call(path_579136, query_579137, nil, nil, nil)

var securitycenterOrganizationsSourcesList* = Call_SecuritycenterOrganizationsSourcesList_579117(
    name: "securitycenterOrganizationsSourcesList", meth: HttpMethod.HttpGet,
    host: "securitycenter.googleapis.com", route: "/v1/{parent}/sources",
    validator: validate_SecuritycenterOrganizationsSourcesList_579118, base: "/",
    url: url_SecuritycenterOrganizationsSourcesList_579119,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesGetIamPolicy_579159 = ref object of OpenApiRestCall_578339
proc url_SecuritycenterOrganizationsSourcesGetIamPolicy_579161(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsSourcesGetIamPolicy_579160(
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
  var valid_579162 = path.getOrDefault("resource")
  valid_579162 = validateParameter(valid_579162, JString, required = true,
                                 default = nil)
  if valid_579162 != nil:
    section.add "resource", valid_579162
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
  var valid_579163 = query.getOrDefault("key")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "key", valid_579163
  var valid_579164 = query.getOrDefault("prettyPrint")
  valid_579164 = validateParameter(valid_579164, JBool, required = false,
                                 default = newJBool(true))
  if valid_579164 != nil:
    section.add "prettyPrint", valid_579164
  var valid_579165 = query.getOrDefault("oauth_token")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "oauth_token", valid_579165
  var valid_579166 = query.getOrDefault("$.xgafv")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = newJString("1"))
  if valid_579166 != nil:
    section.add "$.xgafv", valid_579166
  var valid_579167 = query.getOrDefault("alt")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = newJString("json"))
  if valid_579167 != nil:
    section.add "alt", valid_579167
  var valid_579168 = query.getOrDefault("uploadType")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = nil)
  if valid_579168 != nil:
    section.add "uploadType", valid_579168
  var valid_579169 = query.getOrDefault("quotaUser")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "quotaUser", valid_579169
  var valid_579170 = query.getOrDefault("callback")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = nil)
  if valid_579170 != nil:
    section.add "callback", valid_579170
  var valid_579171 = query.getOrDefault("fields")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = nil)
  if valid_579171 != nil:
    section.add "fields", valid_579171
  var valid_579172 = query.getOrDefault("access_token")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = nil)
  if valid_579172 != nil:
    section.add "access_token", valid_579172
  var valid_579173 = query.getOrDefault("upload_protocol")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "upload_protocol", valid_579173
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

proc call*(call_579175: Call_SecuritycenterOrganizationsSourcesGetIamPolicy_579159;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy on the specified Source.
  ## 
  let valid = call_579175.validator(path, query, header, formData, body)
  let scheme = call_579175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579175.url(scheme.get, call_579175.host, call_579175.base,
                         call_579175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579175, url, valid)

proc call*(call_579176: Call_SecuritycenterOrganizationsSourcesGetIamPolicy_579159;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## securitycenterOrganizationsSourcesGetIamPolicy
  ## Gets the access control policy on the specified Source.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579177 = newJObject()
  var query_579178 = newJObject()
  var body_579179 = newJObject()
  add(query_579178, "key", newJString(key))
  add(query_579178, "prettyPrint", newJBool(prettyPrint))
  add(query_579178, "oauth_token", newJString(oauthToken))
  add(query_579178, "$.xgafv", newJString(Xgafv))
  add(query_579178, "alt", newJString(alt))
  add(query_579178, "uploadType", newJString(uploadType))
  add(query_579178, "quotaUser", newJString(quotaUser))
  add(path_579177, "resource", newJString(resource))
  if body != nil:
    body_579179 = body
  add(query_579178, "callback", newJString(callback))
  add(query_579178, "fields", newJString(fields))
  add(query_579178, "access_token", newJString(accessToken))
  add(query_579178, "upload_protocol", newJString(uploadProtocol))
  result = call_579176.call(path_579177, query_579178, nil, nil, body_579179)

var securitycenterOrganizationsSourcesGetIamPolicy* = Call_SecuritycenterOrganizationsSourcesGetIamPolicy_579159(
    name: "securitycenterOrganizationsSourcesGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{resource}:getIamPolicy",
    validator: validate_SecuritycenterOrganizationsSourcesGetIamPolicy_579160,
    base: "/", url: url_SecuritycenterOrganizationsSourcesGetIamPolicy_579161,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesSetIamPolicy_579180 = ref object of OpenApiRestCall_578339
proc url_SecuritycenterOrganizationsSourcesSetIamPolicy_579182(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsSourcesSetIamPolicy_579181(
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
  var valid_579183 = path.getOrDefault("resource")
  valid_579183 = validateParameter(valid_579183, JString, required = true,
                                 default = nil)
  if valid_579183 != nil:
    section.add "resource", valid_579183
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
  var valid_579184 = query.getOrDefault("key")
  valid_579184 = validateParameter(valid_579184, JString, required = false,
                                 default = nil)
  if valid_579184 != nil:
    section.add "key", valid_579184
  var valid_579185 = query.getOrDefault("prettyPrint")
  valid_579185 = validateParameter(valid_579185, JBool, required = false,
                                 default = newJBool(true))
  if valid_579185 != nil:
    section.add "prettyPrint", valid_579185
  var valid_579186 = query.getOrDefault("oauth_token")
  valid_579186 = validateParameter(valid_579186, JString, required = false,
                                 default = nil)
  if valid_579186 != nil:
    section.add "oauth_token", valid_579186
  var valid_579187 = query.getOrDefault("$.xgafv")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = newJString("1"))
  if valid_579187 != nil:
    section.add "$.xgafv", valid_579187
  var valid_579188 = query.getOrDefault("alt")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = newJString("json"))
  if valid_579188 != nil:
    section.add "alt", valid_579188
  var valid_579189 = query.getOrDefault("uploadType")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "uploadType", valid_579189
  var valid_579190 = query.getOrDefault("quotaUser")
  valid_579190 = validateParameter(valid_579190, JString, required = false,
                                 default = nil)
  if valid_579190 != nil:
    section.add "quotaUser", valid_579190
  var valid_579191 = query.getOrDefault("callback")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "callback", valid_579191
  var valid_579192 = query.getOrDefault("fields")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = nil)
  if valid_579192 != nil:
    section.add "fields", valid_579192
  var valid_579193 = query.getOrDefault("access_token")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = nil)
  if valid_579193 != nil:
    section.add "access_token", valid_579193
  var valid_579194 = query.getOrDefault("upload_protocol")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "upload_protocol", valid_579194
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

proc call*(call_579196: Call_SecuritycenterOrganizationsSourcesSetIamPolicy_579180;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified Source.
  ## 
  let valid = call_579196.validator(path, query, header, formData, body)
  let scheme = call_579196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579196.url(scheme.get, call_579196.host, call_579196.base,
                         call_579196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579196, url, valid)

proc call*(call_579197: Call_SecuritycenterOrganizationsSourcesSetIamPolicy_579180;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## securitycenterOrganizationsSourcesSetIamPolicy
  ## Sets the access control policy on the specified Source.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579198 = newJObject()
  var query_579199 = newJObject()
  var body_579200 = newJObject()
  add(query_579199, "key", newJString(key))
  add(query_579199, "prettyPrint", newJBool(prettyPrint))
  add(query_579199, "oauth_token", newJString(oauthToken))
  add(query_579199, "$.xgafv", newJString(Xgafv))
  add(query_579199, "alt", newJString(alt))
  add(query_579199, "uploadType", newJString(uploadType))
  add(query_579199, "quotaUser", newJString(quotaUser))
  add(path_579198, "resource", newJString(resource))
  if body != nil:
    body_579200 = body
  add(query_579199, "callback", newJString(callback))
  add(query_579199, "fields", newJString(fields))
  add(query_579199, "access_token", newJString(accessToken))
  add(query_579199, "upload_protocol", newJString(uploadProtocol))
  result = call_579197.call(path_579198, query_579199, nil, nil, body_579200)

var securitycenterOrganizationsSourcesSetIamPolicy* = Call_SecuritycenterOrganizationsSourcesSetIamPolicy_579180(
    name: "securitycenterOrganizationsSourcesSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{resource}:setIamPolicy",
    validator: validate_SecuritycenterOrganizationsSourcesSetIamPolicy_579181,
    base: "/", url: url_SecuritycenterOrganizationsSourcesSetIamPolicy_579182,
    schemes: {Scheme.Https})
type
  Call_SecuritycenterOrganizationsSourcesTestIamPermissions_579201 = ref object of OpenApiRestCall_578339
proc url_SecuritycenterOrganizationsSourcesTestIamPermissions_579203(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SecuritycenterOrganizationsSourcesTestIamPermissions_579202(
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
  var valid_579204 = path.getOrDefault("resource")
  valid_579204 = validateParameter(valid_579204, JString, required = true,
                                 default = nil)
  if valid_579204 != nil:
    section.add "resource", valid_579204
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
  var valid_579205 = query.getOrDefault("key")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = nil)
  if valid_579205 != nil:
    section.add "key", valid_579205
  var valid_579206 = query.getOrDefault("prettyPrint")
  valid_579206 = validateParameter(valid_579206, JBool, required = false,
                                 default = newJBool(true))
  if valid_579206 != nil:
    section.add "prettyPrint", valid_579206
  var valid_579207 = query.getOrDefault("oauth_token")
  valid_579207 = validateParameter(valid_579207, JString, required = false,
                                 default = nil)
  if valid_579207 != nil:
    section.add "oauth_token", valid_579207
  var valid_579208 = query.getOrDefault("$.xgafv")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = newJString("1"))
  if valid_579208 != nil:
    section.add "$.xgafv", valid_579208
  var valid_579209 = query.getOrDefault("alt")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = newJString("json"))
  if valid_579209 != nil:
    section.add "alt", valid_579209
  var valid_579210 = query.getOrDefault("uploadType")
  valid_579210 = validateParameter(valid_579210, JString, required = false,
                                 default = nil)
  if valid_579210 != nil:
    section.add "uploadType", valid_579210
  var valid_579211 = query.getOrDefault("quotaUser")
  valid_579211 = validateParameter(valid_579211, JString, required = false,
                                 default = nil)
  if valid_579211 != nil:
    section.add "quotaUser", valid_579211
  var valid_579212 = query.getOrDefault("callback")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = nil)
  if valid_579212 != nil:
    section.add "callback", valid_579212
  var valid_579213 = query.getOrDefault("fields")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = nil)
  if valid_579213 != nil:
    section.add "fields", valid_579213
  var valid_579214 = query.getOrDefault("access_token")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = nil)
  if valid_579214 != nil:
    section.add "access_token", valid_579214
  var valid_579215 = query.getOrDefault("upload_protocol")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "upload_protocol", valid_579215
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

proc call*(call_579217: Call_SecuritycenterOrganizationsSourcesTestIamPermissions_579201;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the permissions that a caller has on the specified source.
  ## 
  let valid = call_579217.validator(path, query, header, formData, body)
  let scheme = call_579217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579217.url(scheme.get, call_579217.host, call_579217.base,
                         call_579217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579217, url, valid)

proc call*(call_579218: Call_SecuritycenterOrganizationsSourcesTestIamPermissions_579201;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## securitycenterOrganizationsSourcesTestIamPermissions
  ## Returns the permissions that a caller has on the specified source.
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579219 = newJObject()
  var query_579220 = newJObject()
  var body_579221 = newJObject()
  add(query_579220, "key", newJString(key))
  add(query_579220, "prettyPrint", newJBool(prettyPrint))
  add(query_579220, "oauth_token", newJString(oauthToken))
  add(query_579220, "$.xgafv", newJString(Xgafv))
  add(query_579220, "alt", newJString(alt))
  add(query_579220, "uploadType", newJString(uploadType))
  add(query_579220, "quotaUser", newJString(quotaUser))
  add(path_579219, "resource", newJString(resource))
  if body != nil:
    body_579221 = body
  add(query_579220, "callback", newJString(callback))
  add(query_579220, "fields", newJString(fields))
  add(query_579220, "access_token", newJString(accessToken))
  add(query_579220, "upload_protocol", newJString(uploadProtocol))
  result = call_579218.call(path_579219, query_579220, nil, nil, body_579221)

var securitycenterOrganizationsSourcesTestIamPermissions* = Call_SecuritycenterOrganizationsSourcesTestIamPermissions_579201(
    name: "securitycenterOrganizationsSourcesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "securitycenter.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_SecuritycenterOrganizationsSourcesTestIamPermissions_579202,
    base: "/", url: url_SecuritycenterOrganizationsSourcesTestIamPermissions_579203,
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
