
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: BigQuery Data Transfer
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Schedule queries or transfer external data from SaaS applications to Google BigQuery on a regular basis.
## 
## https://cloud.google.com/bigquery/
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

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
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
  gcpServiceName = "bigquerydatatransfer"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BigquerydatatransferProjectsTransferConfigsRunsGet_588710 = ref object of OpenApiRestCall_588441
proc url_BigquerydatatransferProjectsTransferConfigsRunsGet_588712(
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

proc validate_BigquerydatatransferProjectsTransferConfigsRunsGet_588711(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns information about the particular transfer run.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The field will contain name of the resource requested, for example:
  ## `projects/{project_id}/transferConfigs/{config_id}/runs/{run_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_588838 = path.getOrDefault("name")
  valid_588838 = validateParameter(valid_588838, JString, required = true,
                                 default = nil)
  if valid_588838 != nil:
    section.add "name", valid_588838
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
  var valid_588839 = query.getOrDefault("upload_protocol")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "upload_protocol", valid_588839
  var valid_588840 = query.getOrDefault("fields")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "fields", valid_588840
  var valid_588841 = query.getOrDefault("quotaUser")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "quotaUser", valid_588841
  var valid_588855 = query.getOrDefault("alt")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = newJString("json"))
  if valid_588855 != nil:
    section.add "alt", valid_588855
  var valid_588856 = query.getOrDefault("oauth_token")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "oauth_token", valid_588856
  var valid_588857 = query.getOrDefault("callback")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "callback", valid_588857
  var valid_588858 = query.getOrDefault("access_token")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "access_token", valid_588858
  var valid_588859 = query.getOrDefault("uploadType")
  valid_588859 = validateParameter(valid_588859, JString, required = false,
                                 default = nil)
  if valid_588859 != nil:
    section.add "uploadType", valid_588859
  var valid_588860 = query.getOrDefault("key")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "key", valid_588860
  var valid_588861 = query.getOrDefault("$.xgafv")
  valid_588861 = validateParameter(valid_588861, JString, required = false,
                                 default = newJString("1"))
  if valid_588861 != nil:
    section.add "$.xgafv", valid_588861
  var valid_588862 = query.getOrDefault("prettyPrint")
  valid_588862 = validateParameter(valid_588862, JBool, required = false,
                                 default = newJBool(true))
  if valid_588862 != nil:
    section.add "prettyPrint", valid_588862
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588885: Call_BigquerydatatransferProjectsTransferConfigsRunsGet_588710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about the particular transfer run.
  ## 
  let valid = call_588885.validator(path, query, header, formData, body)
  let scheme = call_588885.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588885.url(scheme.get, call_588885.host, call_588885.base,
                         call_588885.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588885, url, valid)

proc call*(call_588956: Call_BigquerydatatransferProjectsTransferConfigsRunsGet_588710;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## bigquerydatatransferProjectsTransferConfigsRunsGet
  ## Returns information about the particular transfer run.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The field will contain name of the resource requested, for example:
  ## `projects/{project_id}/transferConfigs/{config_id}/runs/{run_id}`
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
  var path_588957 = newJObject()
  var query_588959 = newJObject()
  add(query_588959, "upload_protocol", newJString(uploadProtocol))
  add(query_588959, "fields", newJString(fields))
  add(query_588959, "quotaUser", newJString(quotaUser))
  add(path_588957, "name", newJString(name))
  add(query_588959, "alt", newJString(alt))
  add(query_588959, "oauth_token", newJString(oauthToken))
  add(query_588959, "callback", newJString(callback))
  add(query_588959, "access_token", newJString(accessToken))
  add(query_588959, "uploadType", newJString(uploadType))
  add(query_588959, "key", newJString(key))
  add(query_588959, "$.xgafv", newJString(Xgafv))
  add(query_588959, "prettyPrint", newJBool(prettyPrint))
  result = call_588956.call(path_588957, query_588959, nil, nil, nil)

var bigquerydatatransferProjectsTransferConfigsRunsGet* = Call_BigquerydatatransferProjectsTransferConfigsRunsGet_588710(
    name: "bigquerydatatransferProjectsTransferConfigsRunsGet",
    meth: HttpMethod.HttpGet, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{name}",
    validator: validate_BigquerydatatransferProjectsTransferConfigsRunsGet_588711,
    base: "/", url: url_BigquerydatatransferProjectsTransferConfigsRunsGet_588712,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsPatch_589017 = ref object of OpenApiRestCall_588441
proc url_BigquerydatatransferProjectsTransferConfigsPatch_589019(
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

proc validate_BigquerydatatransferProjectsTransferConfigsPatch_589018(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates a data transfer configuration.
  ## All fields must be set, even if they are not updated.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the transfer config.
  ## Transfer config names have the form of
  ## `projects/{project_id}/locations/{region}/transferConfigs/{config_id}`.
  ## The name is automatically generated based on the config_id specified in
  ## CreateTransferConfigRequest along with project_id and region. If config_id
  ## is not provided, usually a uuid, even though it is not guaranteed or
  ## required, will be generated for config_id.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589020 = path.getOrDefault("name")
  valid_589020 = validateParameter(valid_589020, JString, required = true,
                                 default = nil)
  if valid_589020 != nil:
    section.add "name", valid_589020
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   authorizationCode: JString
  ##                    : Optional OAuth2 authorization code to use with this transfer configuration.
  ## If it is provided, the transfer configuration will be associated with the
  ## authorizing user.
  ## In order to obtain authorization_code, please make a
  ## request to
  ## 
  ## https://www.gstatic.com/bigquerydatatransfer/oauthz/auth?client_id=<datatransferapiclientid>&scope=<data_source_scopes>&redirect_uri=<redirect_uri>
  ## 
  ## * client_id should be OAuth client_id of BigQuery DTS API for the given
  ##   data source returned by ListDataSources method.
  ## * data_source_scopes are the scopes returned by ListDataSources method.
  ## * redirect_uri is an optional parameter. If not specified, then
  ##   authorization code is posted to the opener of authorization flow window.
  ##   Otherwise it will be sent to the redirect uri. A special value of
  ##   urn:ietf:wg:oauth:2.0:oob means that authorization code should be
  ##   returned in the title bar of the browser, with the page text prompting
  ##   the user to copy the code and paste it in the application.
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
  ##   versionInfo: JString
  ##              : Optional version info. If users want to find a very recent access token,
  ## that is, immediately after approving access, users have to set the
  ## version_info claim in the token request. To obtain the version_info, users
  ## must use the "none+gsession" response type. which be return a
  ## version_info back in the authorization response which be be put in a JWT
  ## claim in the token request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: JString
  ##             : Required. Required list of fields to be updated in this request.
  section = newJObject()
  var valid_589021 = query.getOrDefault("upload_protocol")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "upload_protocol", valid_589021
  var valid_589022 = query.getOrDefault("authorizationCode")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "authorizationCode", valid_589022
  var valid_589023 = query.getOrDefault("fields")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "fields", valid_589023
  var valid_589024 = query.getOrDefault("quotaUser")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "quotaUser", valid_589024
  var valid_589025 = query.getOrDefault("alt")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = newJString("json"))
  if valid_589025 != nil:
    section.add "alt", valid_589025
  var valid_589026 = query.getOrDefault("oauth_token")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "oauth_token", valid_589026
  var valid_589027 = query.getOrDefault("callback")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "callback", valid_589027
  var valid_589028 = query.getOrDefault("access_token")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "access_token", valid_589028
  var valid_589029 = query.getOrDefault("uploadType")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "uploadType", valid_589029
  var valid_589030 = query.getOrDefault("versionInfo")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "versionInfo", valid_589030
  var valid_589031 = query.getOrDefault("key")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "key", valid_589031
  var valid_589032 = query.getOrDefault("$.xgafv")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = newJString("1"))
  if valid_589032 != nil:
    section.add "$.xgafv", valid_589032
  var valid_589033 = query.getOrDefault("prettyPrint")
  valid_589033 = validateParameter(valid_589033, JBool, required = false,
                                 default = newJBool(true))
  if valid_589033 != nil:
    section.add "prettyPrint", valid_589033
  var valid_589034 = query.getOrDefault("updateMask")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "updateMask", valid_589034
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

proc call*(call_589036: Call_BigquerydatatransferProjectsTransferConfigsPatch_589017;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a data transfer configuration.
  ## All fields must be set, even if they are not updated.
  ## 
  let valid = call_589036.validator(path, query, header, formData, body)
  let scheme = call_589036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589036.url(scheme.get, call_589036.host, call_589036.base,
                         call_589036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589036, url, valid)

proc call*(call_589037: Call_BigquerydatatransferProjectsTransferConfigsPatch_589017;
          name: string; uploadProtocol: string = ""; authorizationCode: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; versionInfo: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          updateMask: string = ""): Recallable =
  ## bigquerydatatransferProjectsTransferConfigsPatch
  ## Updates a data transfer configuration.
  ## All fields must be set, even if they are not updated.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   authorizationCode: string
  ##                    : Optional OAuth2 authorization code to use with this transfer configuration.
  ## If it is provided, the transfer configuration will be associated with the
  ## authorizing user.
  ## In order to obtain authorization_code, please make a
  ## request to
  ## 
  ## https://www.gstatic.com/bigquerydatatransfer/oauthz/auth?client_id=<datatransferapiclientid>&scope=<data_source_scopes>&redirect_uri=<redirect_uri>
  ## 
  ## * client_id should be OAuth client_id of BigQuery DTS API for the given
  ##   data source returned by ListDataSources method.
  ## * data_source_scopes are the scopes returned by ListDataSources method.
  ## * redirect_uri is an optional parameter. If not specified, then
  ##   authorization code is posted to the opener of authorization flow window.
  ##   Otherwise it will be sent to the redirect uri. A special value of
  ##   urn:ietf:wg:oauth:2.0:oob means that authorization code should be
  ##   returned in the title bar of the browser, with the page text prompting
  ##   the user to copy the code and paste it in the application.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the transfer config.
  ## Transfer config names have the form of
  ## `projects/{project_id}/locations/{region}/transferConfigs/{config_id}`.
  ## The name is automatically generated based on the config_id specified in
  ## CreateTransferConfigRequest along with project_id and region. If config_id
  ## is not provided, usually a uuid, even though it is not guaranteed or
  ## required, will be generated for config_id.
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
  ##   versionInfo: string
  ##              : Optional version info. If users want to find a very recent access token,
  ## that is, immediately after approving access, users have to set the
  ## version_info claim in the token request. To obtain the version_info, users
  ## must use the "none+gsession" response type. which be return a
  ## version_info back in the authorization response which be be put in a JWT
  ## claim in the token request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : Required. Required list of fields to be updated in this request.
  var path_589038 = newJObject()
  var query_589039 = newJObject()
  var body_589040 = newJObject()
  add(query_589039, "upload_protocol", newJString(uploadProtocol))
  add(query_589039, "authorizationCode", newJString(authorizationCode))
  add(query_589039, "fields", newJString(fields))
  add(query_589039, "quotaUser", newJString(quotaUser))
  add(path_589038, "name", newJString(name))
  add(query_589039, "alt", newJString(alt))
  add(query_589039, "oauth_token", newJString(oauthToken))
  add(query_589039, "callback", newJString(callback))
  add(query_589039, "access_token", newJString(accessToken))
  add(query_589039, "uploadType", newJString(uploadType))
  add(query_589039, "versionInfo", newJString(versionInfo))
  add(query_589039, "key", newJString(key))
  add(query_589039, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589040 = body
  add(query_589039, "prettyPrint", newJBool(prettyPrint))
  add(query_589039, "updateMask", newJString(updateMask))
  result = call_589037.call(path_589038, query_589039, nil, nil, body_589040)

var bigquerydatatransferProjectsTransferConfigsPatch* = Call_BigquerydatatransferProjectsTransferConfigsPatch_589017(
    name: "bigquerydatatransferProjectsTransferConfigsPatch",
    meth: HttpMethod.HttpPatch, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{name}",
    validator: validate_BigquerydatatransferProjectsTransferConfigsPatch_589018,
    base: "/", url: url_BigquerydatatransferProjectsTransferConfigsPatch_589019,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsRunsDelete_588998 = ref object of OpenApiRestCall_588441
proc url_BigquerydatatransferProjectsTransferConfigsRunsDelete_589000(
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

proc validate_BigquerydatatransferProjectsTransferConfigsRunsDelete_588999(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes the specified transfer run.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The field will contain name of the resource requested, for example:
  ## `projects/{project_id}/transferConfigs/{config_id}/runs/{run_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589001 = path.getOrDefault("name")
  valid_589001 = validateParameter(valid_589001, JString, required = true,
                                 default = nil)
  if valid_589001 != nil:
    section.add "name", valid_589001
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
  var valid_589002 = query.getOrDefault("upload_protocol")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "upload_protocol", valid_589002
  var valid_589003 = query.getOrDefault("fields")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "fields", valid_589003
  var valid_589004 = query.getOrDefault("quotaUser")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "quotaUser", valid_589004
  var valid_589005 = query.getOrDefault("alt")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = newJString("json"))
  if valid_589005 != nil:
    section.add "alt", valid_589005
  var valid_589006 = query.getOrDefault("oauth_token")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "oauth_token", valid_589006
  var valid_589007 = query.getOrDefault("callback")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "callback", valid_589007
  var valid_589008 = query.getOrDefault("access_token")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "access_token", valid_589008
  var valid_589009 = query.getOrDefault("uploadType")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "uploadType", valid_589009
  var valid_589010 = query.getOrDefault("key")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "key", valid_589010
  var valid_589011 = query.getOrDefault("$.xgafv")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = newJString("1"))
  if valid_589011 != nil:
    section.add "$.xgafv", valid_589011
  var valid_589012 = query.getOrDefault("prettyPrint")
  valid_589012 = validateParameter(valid_589012, JBool, required = false,
                                 default = newJBool(true))
  if valid_589012 != nil:
    section.add "prettyPrint", valid_589012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589013: Call_BigquerydatatransferProjectsTransferConfigsRunsDelete_588998;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified transfer run.
  ## 
  let valid = call_589013.validator(path, query, header, formData, body)
  let scheme = call_589013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589013.url(scheme.get, call_589013.host, call_589013.base,
                         call_589013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589013, url, valid)

proc call*(call_589014: Call_BigquerydatatransferProjectsTransferConfigsRunsDelete_588998;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## bigquerydatatransferProjectsTransferConfigsRunsDelete
  ## Deletes the specified transfer run.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The field will contain name of the resource requested, for example:
  ## `projects/{project_id}/transferConfigs/{config_id}/runs/{run_id}`
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
  var path_589015 = newJObject()
  var query_589016 = newJObject()
  add(query_589016, "upload_protocol", newJString(uploadProtocol))
  add(query_589016, "fields", newJString(fields))
  add(query_589016, "quotaUser", newJString(quotaUser))
  add(path_589015, "name", newJString(name))
  add(query_589016, "alt", newJString(alt))
  add(query_589016, "oauth_token", newJString(oauthToken))
  add(query_589016, "callback", newJString(callback))
  add(query_589016, "access_token", newJString(accessToken))
  add(query_589016, "uploadType", newJString(uploadType))
  add(query_589016, "key", newJString(key))
  add(query_589016, "$.xgafv", newJString(Xgafv))
  add(query_589016, "prettyPrint", newJBool(prettyPrint))
  result = call_589014.call(path_589015, query_589016, nil, nil, nil)

var bigquerydatatransferProjectsTransferConfigsRunsDelete* = Call_BigquerydatatransferProjectsTransferConfigsRunsDelete_588998(
    name: "bigquerydatatransferProjectsTransferConfigsRunsDelete",
    meth: HttpMethod.HttpDelete, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{name}",
    validator: validate_BigquerydatatransferProjectsTransferConfigsRunsDelete_588999,
    base: "/", url: url_BigquerydatatransferProjectsTransferConfigsRunsDelete_589000,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsLocationsList_589041 = ref object of OpenApiRestCall_588441
proc url_BigquerydatatransferProjectsLocationsList_589043(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigquerydatatransferProjectsLocationsList_589042(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists information about the supported locations for this service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource that owns the locations collection, if applicable.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589044 = path.getOrDefault("name")
  valid_589044 = validateParameter(valid_589044, JString, required = true,
                                 default = nil)
  if valid_589044 != nil:
    section.add "name", valid_589044
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The standard list page token.
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
  ##           : The standard list page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The standard list filter.
  section = newJObject()
  var valid_589045 = query.getOrDefault("upload_protocol")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "upload_protocol", valid_589045
  var valid_589046 = query.getOrDefault("fields")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "fields", valid_589046
  var valid_589047 = query.getOrDefault("pageToken")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "pageToken", valid_589047
  var valid_589048 = query.getOrDefault("quotaUser")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "quotaUser", valid_589048
  var valid_589049 = query.getOrDefault("alt")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = newJString("json"))
  if valid_589049 != nil:
    section.add "alt", valid_589049
  var valid_589050 = query.getOrDefault("oauth_token")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "oauth_token", valid_589050
  var valid_589051 = query.getOrDefault("callback")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "callback", valid_589051
  var valid_589052 = query.getOrDefault("access_token")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "access_token", valid_589052
  var valid_589053 = query.getOrDefault("uploadType")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "uploadType", valid_589053
  var valid_589054 = query.getOrDefault("key")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "key", valid_589054
  var valid_589055 = query.getOrDefault("$.xgafv")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = newJString("1"))
  if valid_589055 != nil:
    section.add "$.xgafv", valid_589055
  var valid_589056 = query.getOrDefault("pageSize")
  valid_589056 = validateParameter(valid_589056, JInt, required = false, default = nil)
  if valid_589056 != nil:
    section.add "pageSize", valid_589056
  var valid_589057 = query.getOrDefault("prettyPrint")
  valid_589057 = validateParameter(valid_589057, JBool, required = false,
                                 default = newJBool(true))
  if valid_589057 != nil:
    section.add "prettyPrint", valid_589057
  var valid_589058 = query.getOrDefault("filter")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "filter", valid_589058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589059: Call_BigquerydatatransferProjectsLocationsList_589041;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_589059.validator(path, query, header, formData, body)
  let scheme = call_589059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589059.url(scheme.get, call_589059.host, call_589059.base,
                         call_589059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589059, url, valid)

proc call*(call_589060: Call_BigquerydatatransferProjectsLocationsList_589041;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## bigquerydatatransferProjectsLocationsList
  ## Lists information about the supported locations for this service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource that owns the locations collection, if applicable.
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
  ##   pageSize: int
  ##           : The standard list page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The standard list filter.
  var path_589061 = newJObject()
  var query_589062 = newJObject()
  add(query_589062, "upload_protocol", newJString(uploadProtocol))
  add(query_589062, "fields", newJString(fields))
  add(query_589062, "pageToken", newJString(pageToken))
  add(query_589062, "quotaUser", newJString(quotaUser))
  add(path_589061, "name", newJString(name))
  add(query_589062, "alt", newJString(alt))
  add(query_589062, "oauth_token", newJString(oauthToken))
  add(query_589062, "callback", newJString(callback))
  add(query_589062, "access_token", newJString(accessToken))
  add(query_589062, "uploadType", newJString(uploadType))
  add(query_589062, "key", newJString(key))
  add(query_589062, "$.xgafv", newJString(Xgafv))
  add(query_589062, "pageSize", newJInt(pageSize))
  add(query_589062, "prettyPrint", newJBool(prettyPrint))
  add(query_589062, "filter", newJString(filter))
  result = call_589060.call(path_589061, query_589062, nil, nil, nil)

var bigquerydatatransferProjectsLocationsList* = Call_BigquerydatatransferProjectsLocationsList_589041(
    name: "bigquerydatatransferProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "bigquerydatatransfer.googleapis.com", route: "/v1/{name}/locations",
    validator: validate_BigquerydatatransferProjectsLocationsList_589042,
    base: "/", url: url_BigquerydatatransferProjectsLocationsList_589043,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsDataSourcesCheckValidCreds_589063 = ref object of OpenApiRestCall_588441
proc url_BigquerydatatransferProjectsDataSourcesCheckValidCreds_589065(
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
               (kind: ConstantSegment, value: ":checkValidCreds")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigquerydatatransferProjectsDataSourcesCheckValidCreds_589064(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns true if valid credentials exist for the given data source and
  ## requesting user.
  ## Some data sources doesn't support service account, so we need to talk to
  ## them on behalf of the end user. This API just checks whether we have OAuth
  ## token for the particular user, which is a pre-requisite before user can
  ## create a transfer config.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The data source in the form:
  ## `projects/{project_id}/dataSources/{data_source_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589066 = path.getOrDefault("name")
  valid_589066 = validateParameter(valid_589066, JString, required = true,
                                 default = nil)
  if valid_589066 != nil:
    section.add "name", valid_589066
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
  var valid_589067 = query.getOrDefault("upload_protocol")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "upload_protocol", valid_589067
  var valid_589068 = query.getOrDefault("fields")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "fields", valid_589068
  var valid_589069 = query.getOrDefault("quotaUser")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "quotaUser", valid_589069
  var valid_589070 = query.getOrDefault("alt")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = newJString("json"))
  if valid_589070 != nil:
    section.add "alt", valid_589070
  var valid_589071 = query.getOrDefault("oauth_token")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "oauth_token", valid_589071
  var valid_589072 = query.getOrDefault("callback")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "callback", valid_589072
  var valid_589073 = query.getOrDefault("access_token")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "access_token", valid_589073
  var valid_589074 = query.getOrDefault("uploadType")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "uploadType", valid_589074
  var valid_589075 = query.getOrDefault("key")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "key", valid_589075
  var valid_589076 = query.getOrDefault("$.xgafv")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = newJString("1"))
  if valid_589076 != nil:
    section.add "$.xgafv", valid_589076
  var valid_589077 = query.getOrDefault("prettyPrint")
  valid_589077 = validateParameter(valid_589077, JBool, required = false,
                                 default = newJBool(true))
  if valid_589077 != nil:
    section.add "prettyPrint", valid_589077
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

proc call*(call_589079: Call_BigquerydatatransferProjectsDataSourcesCheckValidCreds_589063;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns true if valid credentials exist for the given data source and
  ## requesting user.
  ## Some data sources doesn't support service account, so we need to talk to
  ## them on behalf of the end user. This API just checks whether we have OAuth
  ## token for the particular user, which is a pre-requisite before user can
  ## create a transfer config.
  ## 
  let valid = call_589079.validator(path, query, header, formData, body)
  let scheme = call_589079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589079.url(scheme.get, call_589079.host, call_589079.base,
                         call_589079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589079, url, valid)

proc call*(call_589080: Call_BigquerydatatransferProjectsDataSourcesCheckValidCreds_589063;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## bigquerydatatransferProjectsDataSourcesCheckValidCreds
  ## Returns true if valid credentials exist for the given data source and
  ## requesting user.
  ## Some data sources doesn't support service account, so we need to talk to
  ## them on behalf of the end user. This API just checks whether we have OAuth
  ## token for the particular user, which is a pre-requisite before user can
  ## create a transfer config.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The data source in the form:
  ## `projects/{project_id}/dataSources/{data_source_id}`
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
  var path_589081 = newJObject()
  var query_589082 = newJObject()
  var body_589083 = newJObject()
  add(query_589082, "upload_protocol", newJString(uploadProtocol))
  add(query_589082, "fields", newJString(fields))
  add(query_589082, "quotaUser", newJString(quotaUser))
  add(path_589081, "name", newJString(name))
  add(query_589082, "alt", newJString(alt))
  add(query_589082, "oauth_token", newJString(oauthToken))
  add(query_589082, "callback", newJString(callback))
  add(query_589082, "access_token", newJString(accessToken))
  add(query_589082, "uploadType", newJString(uploadType))
  add(query_589082, "key", newJString(key))
  add(query_589082, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589083 = body
  add(query_589082, "prettyPrint", newJBool(prettyPrint))
  result = call_589080.call(path_589081, query_589082, nil, nil, body_589083)

var bigquerydatatransferProjectsDataSourcesCheckValidCreds* = Call_BigquerydatatransferProjectsDataSourcesCheckValidCreds_589063(
    name: "bigquerydatatransferProjectsDataSourcesCheckValidCreds",
    meth: HttpMethod.HttpPost, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{name}:checkValidCreds",
    validator: validate_BigquerydatatransferProjectsDataSourcesCheckValidCreds_589064,
    base: "/", url: url_BigquerydatatransferProjectsDataSourcesCheckValidCreds_589065,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsDataSourcesList_589084 = ref object of OpenApiRestCall_588441
proc url_BigquerydatatransferProjectsDataSourcesList_589086(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/dataSources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigquerydatatransferProjectsDataSourcesList_589085(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists supported data sources and returns their settings,
  ## which can be used for UI rendering.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The BigQuery project id for which data sources should be returned.
  ## Must be in the form: `projects/{project_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589087 = path.getOrDefault("parent")
  valid_589087 = validateParameter(valid_589087, JString, required = true,
                                 default = nil)
  if valid_589087 != nil:
    section.add "parent", valid_589087
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Pagination token, which can be used to request a specific page
  ## of `ListDataSourcesRequest` list results. For multiple-page
  ## results, `ListDataSourcesResponse` outputs
  ## a `next_page` token, which can be used as the
  ## `page_token` value to request the next page of list results.
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
  ##           : Page size. The default page size is the maximum value of 1000 results.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589088 = query.getOrDefault("upload_protocol")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "upload_protocol", valid_589088
  var valid_589089 = query.getOrDefault("fields")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "fields", valid_589089
  var valid_589090 = query.getOrDefault("pageToken")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "pageToken", valid_589090
  var valid_589091 = query.getOrDefault("quotaUser")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "quotaUser", valid_589091
  var valid_589092 = query.getOrDefault("alt")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = newJString("json"))
  if valid_589092 != nil:
    section.add "alt", valid_589092
  var valid_589093 = query.getOrDefault("oauth_token")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "oauth_token", valid_589093
  var valid_589094 = query.getOrDefault("callback")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "callback", valid_589094
  var valid_589095 = query.getOrDefault("access_token")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "access_token", valid_589095
  var valid_589096 = query.getOrDefault("uploadType")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "uploadType", valid_589096
  var valid_589097 = query.getOrDefault("key")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "key", valid_589097
  var valid_589098 = query.getOrDefault("$.xgafv")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = newJString("1"))
  if valid_589098 != nil:
    section.add "$.xgafv", valid_589098
  var valid_589099 = query.getOrDefault("pageSize")
  valid_589099 = validateParameter(valid_589099, JInt, required = false, default = nil)
  if valid_589099 != nil:
    section.add "pageSize", valid_589099
  var valid_589100 = query.getOrDefault("prettyPrint")
  valid_589100 = validateParameter(valid_589100, JBool, required = false,
                                 default = newJBool(true))
  if valid_589100 != nil:
    section.add "prettyPrint", valid_589100
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589101: Call_BigquerydatatransferProjectsDataSourcesList_589084;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists supported data sources and returns their settings,
  ## which can be used for UI rendering.
  ## 
  let valid = call_589101.validator(path, query, header, formData, body)
  let scheme = call_589101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589101.url(scheme.get, call_589101.host, call_589101.base,
                         call_589101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589101, url, valid)

proc call*(call_589102: Call_BigquerydatatransferProjectsDataSourcesList_589084;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## bigquerydatatransferProjectsDataSourcesList
  ## Lists supported data sources and returns their settings,
  ## which can be used for UI rendering.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Pagination token, which can be used to request a specific page
  ## of `ListDataSourcesRequest` list results. For multiple-page
  ## results, `ListDataSourcesResponse` outputs
  ## a `next_page` token, which can be used as the
  ## `page_token` value to request the next page of list results.
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
  ##         : Required. The BigQuery project id for which data sources should be returned.
  ## Must be in the form: `projects/{project_id}`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Page size. The default page size is the maximum value of 1000 results.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589103 = newJObject()
  var query_589104 = newJObject()
  add(query_589104, "upload_protocol", newJString(uploadProtocol))
  add(query_589104, "fields", newJString(fields))
  add(query_589104, "pageToken", newJString(pageToken))
  add(query_589104, "quotaUser", newJString(quotaUser))
  add(query_589104, "alt", newJString(alt))
  add(query_589104, "oauth_token", newJString(oauthToken))
  add(query_589104, "callback", newJString(callback))
  add(query_589104, "access_token", newJString(accessToken))
  add(query_589104, "uploadType", newJString(uploadType))
  add(path_589103, "parent", newJString(parent))
  add(query_589104, "key", newJString(key))
  add(query_589104, "$.xgafv", newJString(Xgafv))
  add(query_589104, "pageSize", newJInt(pageSize))
  add(query_589104, "prettyPrint", newJBool(prettyPrint))
  result = call_589102.call(path_589103, query_589104, nil, nil, nil)

var bigquerydatatransferProjectsDataSourcesList* = Call_BigquerydatatransferProjectsDataSourcesList_589084(
    name: "bigquerydatatransferProjectsDataSourcesList", meth: HttpMethod.HttpGet,
    host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}/dataSources",
    validator: validate_BigquerydatatransferProjectsDataSourcesList_589085,
    base: "/", url: url_BigquerydatatransferProjectsDataSourcesList_589086,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsRunsList_589105 = ref object of OpenApiRestCall_588441
proc url_BigquerydatatransferProjectsTransferConfigsRunsList_589107(
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
               (kind: ConstantSegment, value: "/runs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigquerydatatransferProjectsTransferConfigsRunsList_589106(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns information about running and completed jobs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. Name of transfer configuration for which transfer runs should be retrieved.
  ## Format of transfer configuration resource name is:
  ## `projects/{project_id}/transferConfigs/{config_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589108 = path.getOrDefault("parent")
  valid_589108 = validateParameter(valid_589108, JString, required = true,
                                 default = nil)
  if valid_589108 != nil:
    section.add "parent", valid_589108
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Pagination token, which can be used to request a specific page
  ## of `ListTransferRunsRequest` list results. For multiple-page
  ## results, `ListTransferRunsResponse` outputs
  ## a `next_page` token, which can be used as the
  ## `page_token` value to request the next page of list results.
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
  ##   states: JArray
  ##         : When specified, only transfer runs with requested states are returned.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Page size. The default page size is the maximum value of 1000 results.
  ##   runAttempt: JString
  ##             : Indicates how run attempts are to be pulled.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589109 = query.getOrDefault("upload_protocol")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "upload_protocol", valid_589109
  var valid_589110 = query.getOrDefault("fields")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "fields", valid_589110
  var valid_589111 = query.getOrDefault("pageToken")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "pageToken", valid_589111
  var valid_589112 = query.getOrDefault("quotaUser")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "quotaUser", valid_589112
  var valid_589113 = query.getOrDefault("alt")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = newJString("json"))
  if valid_589113 != nil:
    section.add "alt", valid_589113
  var valid_589114 = query.getOrDefault("oauth_token")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "oauth_token", valid_589114
  var valid_589115 = query.getOrDefault("callback")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "callback", valid_589115
  var valid_589116 = query.getOrDefault("access_token")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "access_token", valid_589116
  var valid_589117 = query.getOrDefault("uploadType")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "uploadType", valid_589117
  var valid_589118 = query.getOrDefault("key")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "key", valid_589118
  var valid_589119 = query.getOrDefault("states")
  valid_589119 = validateParameter(valid_589119, JArray, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "states", valid_589119
  var valid_589120 = query.getOrDefault("$.xgafv")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = newJString("1"))
  if valid_589120 != nil:
    section.add "$.xgafv", valid_589120
  var valid_589121 = query.getOrDefault("pageSize")
  valid_589121 = validateParameter(valid_589121, JInt, required = false, default = nil)
  if valid_589121 != nil:
    section.add "pageSize", valid_589121
  var valid_589122 = query.getOrDefault("runAttempt")
  valid_589122 = validateParameter(valid_589122, JString, required = false, default = newJString(
      "RUN_ATTEMPT_UNSPECIFIED"))
  if valid_589122 != nil:
    section.add "runAttempt", valid_589122
  var valid_589123 = query.getOrDefault("prettyPrint")
  valid_589123 = validateParameter(valid_589123, JBool, required = false,
                                 default = newJBool(true))
  if valid_589123 != nil:
    section.add "prettyPrint", valid_589123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589124: Call_BigquerydatatransferProjectsTransferConfigsRunsList_589105;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about running and completed jobs.
  ## 
  let valid = call_589124.validator(path, query, header, formData, body)
  let scheme = call_589124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589124.url(scheme.get, call_589124.host, call_589124.base,
                         call_589124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589124, url, valid)

proc call*(call_589125: Call_BigquerydatatransferProjectsTransferConfigsRunsList_589105;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; states: JsonNode = nil;
          Xgafv: string = "1"; pageSize: int = 0;
          runAttempt: string = "RUN_ATTEMPT_UNSPECIFIED"; prettyPrint: bool = true): Recallable =
  ## bigquerydatatransferProjectsTransferConfigsRunsList
  ## Returns information about running and completed jobs.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Pagination token, which can be used to request a specific page
  ## of `ListTransferRunsRequest` list results. For multiple-page
  ## results, `ListTransferRunsResponse` outputs
  ## a `next_page` token, which can be used as the
  ## `page_token` value to request the next page of list results.
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
  ##         : Required. Name of transfer configuration for which transfer runs should be retrieved.
  ## Format of transfer configuration resource name is:
  ## `projects/{project_id}/transferConfigs/{config_id}`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   states: JArray
  ##         : When specified, only transfer runs with requested states are returned.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Page size. The default page size is the maximum value of 1000 results.
  ##   runAttempt: string
  ##             : Indicates how run attempts are to be pulled.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589126 = newJObject()
  var query_589127 = newJObject()
  add(query_589127, "upload_protocol", newJString(uploadProtocol))
  add(query_589127, "fields", newJString(fields))
  add(query_589127, "pageToken", newJString(pageToken))
  add(query_589127, "quotaUser", newJString(quotaUser))
  add(query_589127, "alt", newJString(alt))
  add(query_589127, "oauth_token", newJString(oauthToken))
  add(query_589127, "callback", newJString(callback))
  add(query_589127, "access_token", newJString(accessToken))
  add(query_589127, "uploadType", newJString(uploadType))
  add(path_589126, "parent", newJString(parent))
  add(query_589127, "key", newJString(key))
  if states != nil:
    query_589127.add "states", states
  add(query_589127, "$.xgafv", newJString(Xgafv))
  add(query_589127, "pageSize", newJInt(pageSize))
  add(query_589127, "runAttempt", newJString(runAttempt))
  add(query_589127, "prettyPrint", newJBool(prettyPrint))
  result = call_589125.call(path_589126, query_589127, nil, nil, nil)

var bigquerydatatransferProjectsTransferConfigsRunsList* = Call_BigquerydatatransferProjectsTransferConfigsRunsList_589105(
    name: "bigquerydatatransferProjectsTransferConfigsRunsList",
    meth: HttpMethod.HttpGet, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}/runs",
    validator: validate_BigquerydatatransferProjectsTransferConfigsRunsList_589106,
    base: "/", url: url_BigquerydatatransferProjectsTransferConfigsRunsList_589107,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsCreate_589150 = ref object of OpenApiRestCall_588441
proc url_BigquerydatatransferProjectsTransferConfigsCreate_589152(
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
               (kind: ConstantSegment, value: "/transferConfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigquerydatatransferProjectsTransferConfigsCreate_589151(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a new data transfer configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The BigQuery project id where the transfer configuration should be created.
  ## Must be in the format projects/{project_id}/locations/{location_id}
  ## If specified location and location of the destination bigquery dataset
  ## do not match - the request will fail.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589153 = path.getOrDefault("parent")
  valid_589153 = validateParameter(valid_589153, JString, required = true,
                                 default = nil)
  if valid_589153 != nil:
    section.add "parent", valid_589153
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   authorizationCode: JString
  ##                    : Optional OAuth2 authorization code to use with this transfer configuration.
  ## This is required if new credentials are needed, as indicated by
  ## `CheckValidCreds`.
  ## In order to obtain authorization_code, please make a
  ## request to
  ## 
  ## https://www.gstatic.com/bigquerydatatransfer/oauthz/auth?client_id=<datatransferapiclientid>&scope=<data_source_scopes>&redirect_uri=<redirect_uri>
  ## 
  ## * client_id should be OAuth client_id of BigQuery DTS API for the given
  ##   data source returned by ListDataSources method.
  ## * data_source_scopes are the scopes returned by ListDataSources method.
  ## * redirect_uri is an optional parameter. If not specified, then
  ##   authorization code is posted to the opener of authorization flow window.
  ##   Otherwise it will be sent to the redirect uri. A special value of
  ##   urn:ietf:wg:oauth:2.0:oob means that authorization code should be
  ##   returned in the title bar of the browser, with the page text prompting
  ##   the user to copy the code and paste it in the application.
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
  ##   versionInfo: JString
  ##              : Optional version info. If users want to find a very recent access token,
  ## that is, immediately after approving access, users have to set the
  ## version_info claim in the token request. To obtain the version_info, users
  ## must use the "none+gsession" response type. which be return a
  ## version_info back in the authorization response which be be put in a JWT
  ## claim in the token request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589154 = query.getOrDefault("upload_protocol")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "upload_protocol", valid_589154
  var valid_589155 = query.getOrDefault("authorizationCode")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "authorizationCode", valid_589155
  var valid_589156 = query.getOrDefault("fields")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "fields", valid_589156
  var valid_589157 = query.getOrDefault("quotaUser")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "quotaUser", valid_589157
  var valid_589158 = query.getOrDefault("alt")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = newJString("json"))
  if valid_589158 != nil:
    section.add "alt", valid_589158
  var valid_589159 = query.getOrDefault("oauth_token")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "oauth_token", valid_589159
  var valid_589160 = query.getOrDefault("callback")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "callback", valid_589160
  var valid_589161 = query.getOrDefault("access_token")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "access_token", valid_589161
  var valid_589162 = query.getOrDefault("uploadType")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "uploadType", valid_589162
  var valid_589163 = query.getOrDefault("versionInfo")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "versionInfo", valid_589163
  var valid_589164 = query.getOrDefault("key")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "key", valid_589164
  var valid_589165 = query.getOrDefault("$.xgafv")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = newJString("1"))
  if valid_589165 != nil:
    section.add "$.xgafv", valid_589165
  var valid_589166 = query.getOrDefault("prettyPrint")
  valid_589166 = validateParameter(valid_589166, JBool, required = false,
                                 default = newJBool(true))
  if valid_589166 != nil:
    section.add "prettyPrint", valid_589166
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

proc call*(call_589168: Call_BigquerydatatransferProjectsTransferConfigsCreate_589150;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new data transfer configuration.
  ## 
  let valid = call_589168.validator(path, query, header, formData, body)
  let scheme = call_589168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589168.url(scheme.get, call_589168.host, call_589168.base,
                         call_589168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589168, url, valid)

proc call*(call_589169: Call_BigquerydatatransferProjectsTransferConfigsCreate_589150;
          parent: string; uploadProtocol: string = ""; authorizationCode: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; versionInfo: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## bigquerydatatransferProjectsTransferConfigsCreate
  ## Creates a new data transfer configuration.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   authorizationCode: string
  ##                    : Optional OAuth2 authorization code to use with this transfer configuration.
  ## This is required if new credentials are needed, as indicated by
  ## `CheckValidCreds`.
  ## In order to obtain authorization_code, please make a
  ## request to
  ## 
  ## https://www.gstatic.com/bigquerydatatransfer/oauthz/auth?client_id=<datatransferapiclientid>&scope=<data_source_scopes>&redirect_uri=<redirect_uri>
  ## 
  ## * client_id should be OAuth client_id of BigQuery DTS API for the given
  ##   data source returned by ListDataSources method.
  ## * data_source_scopes are the scopes returned by ListDataSources method.
  ## * redirect_uri is an optional parameter. If not specified, then
  ##   authorization code is posted to the opener of authorization flow window.
  ##   Otherwise it will be sent to the redirect uri. A special value of
  ##   urn:ietf:wg:oauth:2.0:oob means that authorization code should be
  ##   returned in the title bar of the browser, with the page text prompting
  ##   the user to copy the code and paste it in the application.
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
  ##         : Required. The BigQuery project id where the transfer configuration should be created.
  ## Must be in the format projects/{project_id}/locations/{location_id}
  ## If specified location and location of the destination bigquery dataset
  ## do not match - the request will fail.
  ##   versionInfo: string
  ##              : Optional version info. If users want to find a very recent access token,
  ## that is, immediately after approving access, users have to set the
  ## version_info claim in the token request. To obtain the version_info, users
  ## must use the "none+gsession" response type. which be return a
  ## version_info back in the authorization response which be be put in a JWT
  ## claim in the token request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589170 = newJObject()
  var query_589171 = newJObject()
  var body_589172 = newJObject()
  add(query_589171, "upload_protocol", newJString(uploadProtocol))
  add(query_589171, "authorizationCode", newJString(authorizationCode))
  add(query_589171, "fields", newJString(fields))
  add(query_589171, "quotaUser", newJString(quotaUser))
  add(query_589171, "alt", newJString(alt))
  add(query_589171, "oauth_token", newJString(oauthToken))
  add(query_589171, "callback", newJString(callback))
  add(query_589171, "access_token", newJString(accessToken))
  add(query_589171, "uploadType", newJString(uploadType))
  add(path_589170, "parent", newJString(parent))
  add(query_589171, "versionInfo", newJString(versionInfo))
  add(query_589171, "key", newJString(key))
  add(query_589171, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589172 = body
  add(query_589171, "prettyPrint", newJBool(prettyPrint))
  result = call_589169.call(path_589170, query_589171, nil, nil, body_589172)

var bigquerydatatransferProjectsTransferConfigsCreate* = Call_BigquerydatatransferProjectsTransferConfigsCreate_589150(
    name: "bigquerydatatransferProjectsTransferConfigsCreate",
    meth: HttpMethod.HttpPost, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}/transferConfigs",
    validator: validate_BigquerydatatransferProjectsTransferConfigsCreate_589151,
    base: "/", url: url_BigquerydatatransferProjectsTransferConfigsCreate_589152,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsList_589128 = ref object of OpenApiRestCall_588441
proc url_BigquerydatatransferProjectsTransferConfigsList_589130(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/transferConfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigquerydatatransferProjectsTransferConfigsList_589129(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns information about all data transfers in the project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The BigQuery project id for which data sources
  ## should be returned: `projects/{project_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589131 = path.getOrDefault("parent")
  valid_589131 = validateParameter(valid_589131, JString, required = true,
                                 default = nil)
  if valid_589131 != nil:
    section.add "parent", valid_589131
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Pagination token, which can be used to request a specific page
  ## of `ListTransfersRequest` list results. For multiple-page
  ## results, `ListTransfersResponse` outputs
  ## a `next_page` token, which can be used as the
  ## `page_token` value to request the next page of list results.
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
  ##           : Page size. The default page size is the maximum value of 1000 results.
  ##   dataSourceIds: JArray
  ##                : When specified, only configurations of requested data sources are returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589132 = query.getOrDefault("upload_protocol")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "upload_protocol", valid_589132
  var valid_589133 = query.getOrDefault("fields")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "fields", valid_589133
  var valid_589134 = query.getOrDefault("pageToken")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "pageToken", valid_589134
  var valid_589135 = query.getOrDefault("quotaUser")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "quotaUser", valid_589135
  var valid_589136 = query.getOrDefault("alt")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = newJString("json"))
  if valid_589136 != nil:
    section.add "alt", valid_589136
  var valid_589137 = query.getOrDefault("oauth_token")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "oauth_token", valid_589137
  var valid_589138 = query.getOrDefault("callback")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "callback", valid_589138
  var valid_589139 = query.getOrDefault("access_token")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "access_token", valid_589139
  var valid_589140 = query.getOrDefault("uploadType")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "uploadType", valid_589140
  var valid_589141 = query.getOrDefault("key")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "key", valid_589141
  var valid_589142 = query.getOrDefault("$.xgafv")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = newJString("1"))
  if valid_589142 != nil:
    section.add "$.xgafv", valid_589142
  var valid_589143 = query.getOrDefault("pageSize")
  valid_589143 = validateParameter(valid_589143, JInt, required = false, default = nil)
  if valid_589143 != nil:
    section.add "pageSize", valid_589143
  var valid_589144 = query.getOrDefault("dataSourceIds")
  valid_589144 = validateParameter(valid_589144, JArray, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "dataSourceIds", valid_589144
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
  if body != nil:
    result.add "body", body

proc call*(call_589146: Call_BigquerydatatransferProjectsTransferConfigsList_589128;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about all data transfers in the project.
  ## 
  let valid = call_589146.validator(path, query, header, formData, body)
  let scheme = call_589146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589146.url(scheme.get, call_589146.host, call_589146.base,
                         call_589146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589146, url, valid)

proc call*(call_589147: Call_BigquerydatatransferProjectsTransferConfigsList_589128;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          dataSourceIds: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## bigquerydatatransferProjectsTransferConfigsList
  ## Returns information about all data transfers in the project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Pagination token, which can be used to request a specific page
  ## of `ListTransfersRequest` list results. For multiple-page
  ## results, `ListTransfersResponse` outputs
  ## a `next_page` token, which can be used as the
  ## `page_token` value to request the next page of list results.
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
  ##         : Required. The BigQuery project id for which data sources
  ## should be returned: `projects/{project_id}`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Page size. The default page size is the maximum value of 1000 results.
  ##   dataSourceIds: JArray
  ##                : When specified, only configurations of requested data sources are returned.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589148 = newJObject()
  var query_589149 = newJObject()
  add(query_589149, "upload_protocol", newJString(uploadProtocol))
  add(query_589149, "fields", newJString(fields))
  add(query_589149, "pageToken", newJString(pageToken))
  add(query_589149, "quotaUser", newJString(quotaUser))
  add(query_589149, "alt", newJString(alt))
  add(query_589149, "oauth_token", newJString(oauthToken))
  add(query_589149, "callback", newJString(callback))
  add(query_589149, "access_token", newJString(accessToken))
  add(query_589149, "uploadType", newJString(uploadType))
  add(path_589148, "parent", newJString(parent))
  add(query_589149, "key", newJString(key))
  add(query_589149, "$.xgafv", newJString(Xgafv))
  add(query_589149, "pageSize", newJInt(pageSize))
  if dataSourceIds != nil:
    query_589149.add "dataSourceIds", dataSourceIds
  add(query_589149, "prettyPrint", newJBool(prettyPrint))
  result = call_589147.call(path_589148, query_589149, nil, nil, nil)

var bigquerydatatransferProjectsTransferConfigsList* = Call_BigquerydatatransferProjectsTransferConfigsList_589128(
    name: "bigquerydatatransferProjectsTransferConfigsList",
    meth: HttpMethod.HttpGet, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}/transferConfigs",
    validator: validate_BigquerydatatransferProjectsTransferConfigsList_589129,
    base: "/", url: url_BigquerydatatransferProjectsTransferConfigsList_589130,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_589173 = ref object of OpenApiRestCall_588441
proc url_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_589175(
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
               (kind: ConstantSegment, value: "/transferLogs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_589174(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns user facing log messages for the data transfer run.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. Transfer run name in the form:
  ## `projects/{project_id}/transferConfigs/{config_Id}/runs/{run_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589176 = path.getOrDefault("parent")
  valid_589176 = validateParameter(valid_589176, JString, required = true,
                                 default = nil)
  if valid_589176 != nil:
    section.add "parent", valid_589176
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Pagination token, which can be used to request a specific page
  ## of `ListTransferLogsRequest` list results. For multiple-page
  ## results, `ListTransferLogsResponse` outputs
  ## a `next_page` token, which can be used as the
  ## `page_token` value to request the next page of list results.
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
  ##           : Page size. The default page size is the maximum value of 1000 results.
  ##   messageTypes: JArray
  ##               : Message types to return. If not populated - INFO, WARNING and ERROR
  ## messages are returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589177 = query.getOrDefault("upload_protocol")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "upload_protocol", valid_589177
  var valid_589178 = query.getOrDefault("fields")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "fields", valid_589178
  var valid_589179 = query.getOrDefault("pageToken")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "pageToken", valid_589179
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
  var valid_589188 = query.getOrDefault("pageSize")
  valid_589188 = validateParameter(valid_589188, JInt, required = false, default = nil)
  if valid_589188 != nil:
    section.add "pageSize", valid_589188
  var valid_589189 = query.getOrDefault("messageTypes")
  valid_589189 = validateParameter(valid_589189, JArray, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "messageTypes", valid_589189
  var valid_589190 = query.getOrDefault("prettyPrint")
  valid_589190 = validateParameter(valid_589190, JBool, required = false,
                                 default = newJBool(true))
  if valid_589190 != nil:
    section.add "prettyPrint", valid_589190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589191: Call_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_589173;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns user facing log messages for the data transfer run.
  ## 
  let valid = call_589191.validator(path, query, header, formData, body)
  let scheme = call_589191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589191.url(scheme.get, call_589191.host, call_589191.base,
                         call_589191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589191, url, valid)

proc call*(call_589192: Call_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_589173;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          messageTypes: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## bigquerydatatransferProjectsTransferConfigsRunsTransferLogsList
  ## Returns user facing log messages for the data transfer run.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Pagination token, which can be used to request a specific page
  ## of `ListTransferLogsRequest` list results. For multiple-page
  ## results, `ListTransferLogsResponse` outputs
  ## a `next_page` token, which can be used as the
  ## `page_token` value to request the next page of list results.
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
  ##         : Required. Transfer run name in the form:
  ## `projects/{project_id}/transferConfigs/{config_Id}/runs/{run_id}`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Page size. The default page size is the maximum value of 1000 results.
  ##   messageTypes: JArray
  ##               : Message types to return. If not populated - INFO, WARNING and ERROR
  ## messages are returned.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589193 = newJObject()
  var query_589194 = newJObject()
  add(query_589194, "upload_protocol", newJString(uploadProtocol))
  add(query_589194, "fields", newJString(fields))
  add(query_589194, "pageToken", newJString(pageToken))
  add(query_589194, "quotaUser", newJString(quotaUser))
  add(query_589194, "alt", newJString(alt))
  add(query_589194, "oauth_token", newJString(oauthToken))
  add(query_589194, "callback", newJString(callback))
  add(query_589194, "access_token", newJString(accessToken))
  add(query_589194, "uploadType", newJString(uploadType))
  add(path_589193, "parent", newJString(parent))
  add(query_589194, "key", newJString(key))
  add(query_589194, "$.xgafv", newJString(Xgafv))
  add(query_589194, "pageSize", newJInt(pageSize))
  if messageTypes != nil:
    query_589194.add "messageTypes", messageTypes
  add(query_589194, "prettyPrint", newJBool(prettyPrint))
  result = call_589192.call(path_589193, query_589194, nil, nil, nil)

var bigquerydatatransferProjectsTransferConfigsRunsTransferLogsList* = Call_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_589173(
    name: "bigquerydatatransferProjectsTransferConfigsRunsTransferLogsList",
    meth: HttpMethod.HttpGet, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}/transferLogs", validator: validate_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_589174,
    base: "/",
    url: url_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_589175,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsScheduleRuns_589195 = ref object of OpenApiRestCall_588441
proc url_BigquerydatatransferProjectsTransferConfigsScheduleRuns_589197(
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
               (kind: ConstantSegment, value: ":scheduleRuns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigquerydatatransferProjectsTransferConfigsScheduleRuns_589196(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates transfer runs for a time range [start_time, end_time].
  ## For each date - or whatever granularity the data source supports - in the
  ## range, one transfer run is created.
  ## Note that runs are created per UTC time in the time range.
  ## DEPRECATED: use StartManualTransferRuns instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. Transfer configuration name in the form:
  ## `projects/{project_id}/transferConfigs/{config_id}`.
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

proc call*(call_589211: Call_BigquerydatatransferProjectsTransferConfigsScheduleRuns_589195;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates transfer runs for a time range [start_time, end_time].
  ## For each date - or whatever granularity the data source supports - in the
  ## range, one transfer run is created.
  ## Note that runs are created per UTC time in the time range.
  ## DEPRECATED: use StartManualTransferRuns instead.
  ## 
  let valid = call_589211.validator(path, query, header, formData, body)
  let scheme = call_589211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589211.url(scheme.get, call_589211.host, call_589211.base,
                         call_589211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589211, url, valid)

proc call*(call_589212: Call_BigquerydatatransferProjectsTransferConfigsScheduleRuns_589195;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## bigquerydatatransferProjectsTransferConfigsScheduleRuns
  ## Creates transfer runs for a time range [start_time, end_time].
  ## For each date - or whatever granularity the data source supports - in the
  ## range, one transfer run is created.
  ## Note that runs are created per UTC time in the time range.
  ## DEPRECATED: use StartManualTransferRuns instead.
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
  ##         : Required. Transfer configuration name in the form:
  ## `projects/{project_id}/transferConfigs/{config_id}`.
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

var bigquerydatatransferProjectsTransferConfigsScheduleRuns* = Call_BigquerydatatransferProjectsTransferConfigsScheduleRuns_589195(
    name: "bigquerydatatransferProjectsTransferConfigsScheduleRuns",
    meth: HttpMethod.HttpPost, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}:scheduleRuns", validator: validate_BigquerydatatransferProjectsTransferConfigsScheduleRuns_589196,
    base: "/", url: url_BigquerydatatransferProjectsTransferConfigsScheduleRuns_589197,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsStartManualRuns_589216 = ref object of OpenApiRestCall_588441
proc url_BigquerydatatransferProjectsTransferConfigsStartManualRuns_589218(
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
               (kind: ConstantSegment, value: ":startManualRuns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigquerydatatransferProjectsTransferConfigsStartManualRuns_589217(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Start manual transfer runs to be executed now with schedule_time equal to
  ## current time. The transfer runs can be created for a time range where the
  ## run_time is between start_time (inclusive) and end_time (exclusive), or for
  ## a specific run_time.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Transfer configuration name in the form:
  ## `projects/{project_id}/transferConfigs/{config_id}`.
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
  var valid_589222 = query.getOrDefault("quotaUser")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "quotaUser", valid_589222
  var valid_589223 = query.getOrDefault("alt")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = newJString("json"))
  if valid_589223 != nil:
    section.add "alt", valid_589223
  var valid_589224 = query.getOrDefault("oauth_token")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "oauth_token", valid_589224
  var valid_589225 = query.getOrDefault("callback")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "callback", valid_589225
  var valid_589226 = query.getOrDefault("access_token")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "access_token", valid_589226
  var valid_589227 = query.getOrDefault("uploadType")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "uploadType", valid_589227
  var valid_589228 = query.getOrDefault("key")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "key", valid_589228
  var valid_589229 = query.getOrDefault("$.xgafv")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = newJString("1"))
  if valid_589229 != nil:
    section.add "$.xgafv", valid_589229
  var valid_589230 = query.getOrDefault("prettyPrint")
  valid_589230 = validateParameter(valid_589230, JBool, required = false,
                                 default = newJBool(true))
  if valid_589230 != nil:
    section.add "prettyPrint", valid_589230
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

proc call*(call_589232: Call_BigquerydatatransferProjectsTransferConfigsStartManualRuns_589216;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Start manual transfer runs to be executed now with schedule_time equal to
  ## current time. The transfer runs can be created for a time range where the
  ## run_time is between start_time (inclusive) and end_time (exclusive), or for
  ## a specific run_time.
  ## 
  let valid = call_589232.validator(path, query, header, formData, body)
  let scheme = call_589232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589232.url(scheme.get, call_589232.host, call_589232.base,
                         call_589232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589232, url, valid)

proc call*(call_589233: Call_BigquerydatatransferProjectsTransferConfigsStartManualRuns_589216;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## bigquerydatatransferProjectsTransferConfigsStartManualRuns
  ## Start manual transfer runs to be executed now with schedule_time equal to
  ## current time. The transfer runs can be created for a time range where the
  ## run_time is between start_time (inclusive) and end_time (exclusive), or for
  ## a specific run_time.
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
  ##         : Transfer configuration name in the form:
  ## `projects/{project_id}/transferConfigs/{config_id}`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589234 = newJObject()
  var query_589235 = newJObject()
  var body_589236 = newJObject()
  add(query_589235, "upload_protocol", newJString(uploadProtocol))
  add(query_589235, "fields", newJString(fields))
  add(query_589235, "quotaUser", newJString(quotaUser))
  add(query_589235, "alt", newJString(alt))
  add(query_589235, "oauth_token", newJString(oauthToken))
  add(query_589235, "callback", newJString(callback))
  add(query_589235, "access_token", newJString(accessToken))
  add(query_589235, "uploadType", newJString(uploadType))
  add(path_589234, "parent", newJString(parent))
  add(query_589235, "key", newJString(key))
  add(query_589235, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589236 = body
  add(query_589235, "prettyPrint", newJBool(prettyPrint))
  result = call_589233.call(path_589234, query_589235, nil, nil, body_589236)

var bigquerydatatransferProjectsTransferConfigsStartManualRuns* = Call_BigquerydatatransferProjectsTransferConfigsStartManualRuns_589216(
    name: "bigquerydatatransferProjectsTransferConfigsStartManualRuns",
    meth: HttpMethod.HttpPost, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}:startManualRuns", validator: validate_BigquerydatatransferProjectsTransferConfigsStartManualRuns_589217,
    base: "/",
    url: url_BigquerydatatransferProjectsTransferConfigsStartManualRuns_589218,
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
