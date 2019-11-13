
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

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

  OpenApiRestCall_579364 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579364](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579364): Option[Scheme] {.used.} =
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
  gcpServiceName = "bigquerydatatransfer"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BigquerydatatransferProjectsLocationsTransferConfigsRunsGet_579635 = ref object of OpenApiRestCall_579364
proc url_BigquerydatatransferProjectsLocationsTransferConfigsRunsGet_579637(
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

proc validate_BigquerydatatransferProjectsLocationsTransferConfigsRunsGet_579636(
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
  var valid_579763 = path.getOrDefault("name")
  valid_579763 = validateParameter(valid_579763, JString, required = true,
                                 default = nil)
  if valid_579763 != nil:
    section.add "name", valid_579763
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
  var valid_579764 = query.getOrDefault("key")
  valid_579764 = validateParameter(valid_579764, JString, required = false,
                                 default = nil)
  if valid_579764 != nil:
    section.add "key", valid_579764
  var valid_579778 = query.getOrDefault("prettyPrint")
  valid_579778 = validateParameter(valid_579778, JBool, required = false,
                                 default = newJBool(true))
  if valid_579778 != nil:
    section.add "prettyPrint", valid_579778
  var valid_579779 = query.getOrDefault("oauth_token")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = nil)
  if valid_579779 != nil:
    section.add "oauth_token", valid_579779
  var valid_579780 = query.getOrDefault("$.xgafv")
  valid_579780 = validateParameter(valid_579780, JString, required = false,
                                 default = newJString("1"))
  if valid_579780 != nil:
    section.add "$.xgafv", valid_579780
  var valid_579781 = query.getOrDefault("alt")
  valid_579781 = validateParameter(valid_579781, JString, required = false,
                                 default = newJString("json"))
  if valid_579781 != nil:
    section.add "alt", valid_579781
  var valid_579782 = query.getOrDefault("uploadType")
  valid_579782 = validateParameter(valid_579782, JString, required = false,
                                 default = nil)
  if valid_579782 != nil:
    section.add "uploadType", valid_579782
  var valid_579783 = query.getOrDefault("quotaUser")
  valid_579783 = validateParameter(valid_579783, JString, required = false,
                                 default = nil)
  if valid_579783 != nil:
    section.add "quotaUser", valid_579783
  var valid_579784 = query.getOrDefault("callback")
  valid_579784 = validateParameter(valid_579784, JString, required = false,
                                 default = nil)
  if valid_579784 != nil:
    section.add "callback", valid_579784
  var valid_579785 = query.getOrDefault("fields")
  valid_579785 = validateParameter(valid_579785, JString, required = false,
                                 default = nil)
  if valid_579785 != nil:
    section.add "fields", valid_579785
  var valid_579786 = query.getOrDefault("access_token")
  valid_579786 = validateParameter(valid_579786, JString, required = false,
                                 default = nil)
  if valid_579786 != nil:
    section.add "access_token", valid_579786
  var valid_579787 = query.getOrDefault("upload_protocol")
  valid_579787 = validateParameter(valid_579787, JString, required = false,
                                 default = nil)
  if valid_579787 != nil:
    section.add "upload_protocol", valid_579787
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579810: Call_BigquerydatatransferProjectsLocationsTransferConfigsRunsGet_579635;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about the particular transfer run.
  ## 
  let valid = call_579810.validator(path, query, header, formData, body)
  let scheme = call_579810.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579810.url(scheme.get, call_579810.host, call_579810.base,
                         call_579810.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579810, url, valid)

proc call*(call_579881: Call_BigquerydatatransferProjectsLocationsTransferConfigsRunsGet_579635;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigquerydatatransferProjectsLocationsTransferConfigsRunsGet
  ## Returns information about the particular transfer run.
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
  ##       : Required. The field will contain name of the resource requested, for example:
  ## `projects/{project_id}/transferConfigs/{config_id}/runs/{run_id}`
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579882 = newJObject()
  var query_579884 = newJObject()
  add(query_579884, "key", newJString(key))
  add(query_579884, "prettyPrint", newJBool(prettyPrint))
  add(query_579884, "oauth_token", newJString(oauthToken))
  add(query_579884, "$.xgafv", newJString(Xgafv))
  add(query_579884, "alt", newJString(alt))
  add(query_579884, "uploadType", newJString(uploadType))
  add(query_579884, "quotaUser", newJString(quotaUser))
  add(path_579882, "name", newJString(name))
  add(query_579884, "callback", newJString(callback))
  add(query_579884, "fields", newJString(fields))
  add(query_579884, "access_token", newJString(accessToken))
  add(query_579884, "upload_protocol", newJString(uploadProtocol))
  result = call_579881.call(path_579882, query_579884, nil, nil, nil)

var bigquerydatatransferProjectsLocationsTransferConfigsRunsGet* = Call_BigquerydatatransferProjectsLocationsTransferConfigsRunsGet_579635(
    name: "bigquerydatatransferProjectsLocationsTransferConfigsRunsGet",
    meth: HttpMethod.HttpGet, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{name}", validator: validate_BigquerydatatransferProjectsLocationsTransferConfigsRunsGet_579636,
    base: "/",
    url: url_BigquerydatatransferProjectsLocationsTransferConfigsRunsGet_579637,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsLocationsTransferConfigsPatch_579942 = ref object of OpenApiRestCall_579364
proc url_BigquerydatatransferProjectsLocationsTransferConfigsPatch_579944(
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

proc validate_BigquerydatatransferProjectsLocationsTransferConfigsPatch_579943(
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
  var valid_579945 = path.getOrDefault("name")
  valid_579945 = validateParameter(valid_579945, JString, required = true,
                                 default = nil)
  if valid_579945 != nil:
    section.add "name", valid_579945
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
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
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   versionInfo: JString
  ##              : Optional version info. If users want to find a very recent access token,
  ## that is, immediately after approving access, users have to set the
  ## version_info claim in the token request. To obtain the version_info, users
  ## must use the "none+gsession" response type. which be return a
  ## version_info back in the authorization response which be be put in a JWT
  ## claim in the token request.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: JString
  ##             : Required. Required list of fields to be updated in this request.
  ##   serviceAccountName: JString
  ##                     : Optional service account name. If this field is set and
  ## "service_account_name" is set in update_mask, transfer config will be
  ## updated to use this service account credentials. It requires that
  ## requesting user calling this API has permissions to act as this service
  ## account.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579946 = query.getOrDefault("key")
  valid_579946 = validateParameter(valid_579946, JString, required = false,
                                 default = nil)
  if valid_579946 != nil:
    section.add "key", valid_579946
  var valid_579947 = query.getOrDefault("prettyPrint")
  valid_579947 = validateParameter(valid_579947, JBool, required = false,
                                 default = newJBool(true))
  if valid_579947 != nil:
    section.add "prettyPrint", valid_579947
  var valid_579948 = query.getOrDefault("oauth_token")
  valid_579948 = validateParameter(valid_579948, JString, required = false,
                                 default = nil)
  if valid_579948 != nil:
    section.add "oauth_token", valid_579948
  var valid_579949 = query.getOrDefault("authorizationCode")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = nil)
  if valid_579949 != nil:
    section.add "authorizationCode", valid_579949
  var valid_579950 = query.getOrDefault("$.xgafv")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = newJString("1"))
  if valid_579950 != nil:
    section.add "$.xgafv", valid_579950
  var valid_579951 = query.getOrDefault("versionInfo")
  valid_579951 = validateParameter(valid_579951, JString, required = false,
                                 default = nil)
  if valid_579951 != nil:
    section.add "versionInfo", valid_579951
  var valid_579952 = query.getOrDefault("alt")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = newJString("json"))
  if valid_579952 != nil:
    section.add "alt", valid_579952
  var valid_579953 = query.getOrDefault("uploadType")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = nil)
  if valid_579953 != nil:
    section.add "uploadType", valid_579953
  var valid_579954 = query.getOrDefault("quotaUser")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = nil)
  if valid_579954 != nil:
    section.add "quotaUser", valid_579954
  var valid_579955 = query.getOrDefault("updateMask")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "updateMask", valid_579955
  var valid_579956 = query.getOrDefault("serviceAccountName")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = nil)
  if valid_579956 != nil:
    section.add "serviceAccountName", valid_579956
  var valid_579957 = query.getOrDefault("callback")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "callback", valid_579957
  var valid_579958 = query.getOrDefault("fields")
  valid_579958 = validateParameter(valid_579958, JString, required = false,
                                 default = nil)
  if valid_579958 != nil:
    section.add "fields", valid_579958
  var valid_579959 = query.getOrDefault("access_token")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "access_token", valid_579959
  var valid_579960 = query.getOrDefault("upload_protocol")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "upload_protocol", valid_579960
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

proc call*(call_579962: Call_BigquerydatatransferProjectsLocationsTransferConfigsPatch_579942;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a data transfer configuration.
  ## All fields must be set, even if they are not updated.
  ## 
  let valid = call_579962.validator(path, query, header, formData, body)
  let scheme = call_579962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579962.url(scheme.get, call_579962.host, call_579962.base,
                         call_579962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579962, url, valid)

proc call*(call_579963: Call_BigquerydatatransferProjectsLocationsTransferConfigsPatch_579942;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; authorizationCode: string = ""; Xgafv: string = "1";
          versionInfo: string = ""; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; updateMask: string = "";
          serviceAccountName: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigquerydatatransferProjectsLocationsTransferConfigsPatch
  ## Updates a data transfer configuration.
  ## All fields must be set, even if they are not updated.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
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
  ##   Xgafv: string
  ##        : V1 error format.
  ##   versionInfo: string
  ##              : Optional version info. If users want to find a very recent access token,
  ## that is, immediately after approving access, users have to set the
  ## version_info claim in the token request. To obtain the version_info, users
  ## must use the "none+gsession" response type. which be return a
  ## version_info back in the authorization response which be be put in a JWT
  ## claim in the token request.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
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
  ##   updateMask: string
  ##             : Required. Required list of fields to be updated in this request.
  ##   serviceAccountName: string
  ##                     : Optional service account name. If this field is set and
  ## "service_account_name" is set in update_mask, transfer config will be
  ## updated to use this service account credentials. It requires that
  ## requesting user calling this API has permissions to act as this service
  ## account.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579964 = newJObject()
  var query_579965 = newJObject()
  var body_579966 = newJObject()
  add(query_579965, "key", newJString(key))
  add(query_579965, "prettyPrint", newJBool(prettyPrint))
  add(query_579965, "oauth_token", newJString(oauthToken))
  add(query_579965, "authorizationCode", newJString(authorizationCode))
  add(query_579965, "$.xgafv", newJString(Xgafv))
  add(query_579965, "versionInfo", newJString(versionInfo))
  add(query_579965, "alt", newJString(alt))
  add(query_579965, "uploadType", newJString(uploadType))
  add(query_579965, "quotaUser", newJString(quotaUser))
  add(path_579964, "name", newJString(name))
  add(query_579965, "updateMask", newJString(updateMask))
  add(query_579965, "serviceAccountName", newJString(serviceAccountName))
  if body != nil:
    body_579966 = body
  add(query_579965, "callback", newJString(callback))
  add(query_579965, "fields", newJString(fields))
  add(query_579965, "access_token", newJString(accessToken))
  add(query_579965, "upload_protocol", newJString(uploadProtocol))
  result = call_579963.call(path_579964, query_579965, nil, nil, body_579966)

var bigquerydatatransferProjectsLocationsTransferConfigsPatch* = Call_BigquerydatatransferProjectsLocationsTransferConfigsPatch_579942(
    name: "bigquerydatatransferProjectsLocationsTransferConfigsPatch",
    meth: HttpMethod.HttpPatch, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{name}", validator: validate_BigquerydatatransferProjectsLocationsTransferConfigsPatch_579943,
    base: "/", url: url_BigquerydatatransferProjectsLocationsTransferConfigsPatch_579944,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsLocationsTransferConfigsRunsDelete_579923 = ref object of OpenApiRestCall_579364
proc url_BigquerydatatransferProjectsLocationsTransferConfigsRunsDelete_579925(
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

proc validate_BigquerydatatransferProjectsLocationsTransferConfigsRunsDelete_579924(
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
  var valid_579926 = path.getOrDefault("name")
  valid_579926 = validateParameter(valid_579926, JString, required = true,
                                 default = nil)
  if valid_579926 != nil:
    section.add "name", valid_579926
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
  var valid_579927 = query.getOrDefault("key")
  valid_579927 = validateParameter(valid_579927, JString, required = false,
                                 default = nil)
  if valid_579927 != nil:
    section.add "key", valid_579927
  var valid_579928 = query.getOrDefault("prettyPrint")
  valid_579928 = validateParameter(valid_579928, JBool, required = false,
                                 default = newJBool(true))
  if valid_579928 != nil:
    section.add "prettyPrint", valid_579928
  var valid_579929 = query.getOrDefault("oauth_token")
  valid_579929 = validateParameter(valid_579929, JString, required = false,
                                 default = nil)
  if valid_579929 != nil:
    section.add "oauth_token", valid_579929
  var valid_579930 = query.getOrDefault("$.xgafv")
  valid_579930 = validateParameter(valid_579930, JString, required = false,
                                 default = newJString("1"))
  if valid_579930 != nil:
    section.add "$.xgafv", valid_579930
  var valid_579931 = query.getOrDefault("alt")
  valid_579931 = validateParameter(valid_579931, JString, required = false,
                                 default = newJString("json"))
  if valid_579931 != nil:
    section.add "alt", valid_579931
  var valid_579932 = query.getOrDefault("uploadType")
  valid_579932 = validateParameter(valid_579932, JString, required = false,
                                 default = nil)
  if valid_579932 != nil:
    section.add "uploadType", valid_579932
  var valid_579933 = query.getOrDefault("quotaUser")
  valid_579933 = validateParameter(valid_579933, JString, required = false,
                                 default = nil)
  if valid_579933 != nil:
    section.add "quotaUser", valid_579933
  var valid_579934 = query.getOrDefault("callback")
  valid_579934 = validateParameter(valid_579934, JString, required = false,
                                 default = nil)
  if valid_579934 != nil:
    section.add "callback", valid_579934
  var valid_579935 = query.getOrDefault("fields")
  valid_579935 = validateParameter(valid_579935, JString, required = false,
                                 default = nil)
  if valid_579935 != nil:
    section.add "fields", valid_579935
  var valid_579936 = query.getOrDefault("access_token")
  valid_579936 = validateParameter(valid_579936, JString, required = false,
                                 default = nil)
  if valid_579936 != nil:
    section.add "access_token", valid_579936
  var valid_579937 = query.getOrDefault("upload_protocol")
  valid_579937 = validateParameter(valid_579937, JString, required = false,
                                 default = nil)
  if valid_579937 != nil:
    section.add "upload_protocol", valid_579937
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579938: Call_BigquerydatatransferProjectsLocationsTransferConfigsRunsDelete_579923;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified transfer run.
  ## 
  let valid = call_579938.validator(path, query, header, formData, body)
  let scheme = call_579938.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579938.url(scheme.get, call_579938.host, call_579938.base,
                         call_579938.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579938, url, valid)

proc call*(call_579939: Call_BigquerydatatransferProjectsLocationsTransferConfigsRunsDelete_579923;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigquerydatatransferProjectsLocationsTransferConfigsRunsDelete
  ## Deletes the specified transfer run.
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
  ##       : Required. The field will contain name of the resource requested, for example:
  ## `projects/{project_id}/transferConfigs/{config_id}/runs/{run_id}`
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579940 = newJObject()
  var query_579941 = newJObject()
  add(query_579941, "key", newJString(key))
  add(query_579941, "prettyPrint", newJBool(prettyPrint))
  add(query_579941, "oauth_token", newJString(oauthToken))
  add(query_579941, "$.xgafv", newJString(Xgafv))
  add(query_579941, "alt", newJString(alt))
  add(query_579941, "uploadType", newJString(uploadType))
  add(query_579941, "quotaUser", newJString(quotaUser))
  add(path_579940, "name", newJString(name))
  add(query_579941, "callback", newJString(callback))
  add(query_579941, "fields", newJString(fields))
  add(query_579941, "access_token", newJString(accessToken))
  add(query_579941, "upload_protocol", newJString(uploadProtocol))
  result = call_579939.call(path_579940, query_579941, nil, nil, nil)

var bigquerydatatransferProjectsLocationsTransferConfigsRunsDelete* = Call_BigquerydatatransferProjectsLocationsTransferConfigsRunsDelete_579923(
    name: "bigquerydatatransferProjectsLocationsTransferConfigsRunsDelete",
    meth: HttpMethod.HttpDelete, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{name}", validator: validate_BigquerydatatransferProjectsLocationsTransferConfigsRunsDelete_579924,
    base: "/",
    url: url_BigquerydatatransferProjectsLocationsTransferConfigsRunsDelete_579925,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsLocationsList_579967 = ref object of OpenApiRestCall_579364
proc url_BigquerydatatransferProjectsLocationsList_579969(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigquerydatatransferProjectsLocationsList_579968(path: JsonNode;
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
  var valid_579970 = path.getOrDefault("name")
  valid_579970 = validateParameter(valid_579970, JString, required = true,
                                 default = nil)
  if valid_579970 != nil:
    section.add "name", valid_579970
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
  ##           : The standard list page size.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The standard list filter.
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579971 = query.getOrDefault("key")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "key", valid_579971
  var valid_579972 = query.getOrDefault("prettyPrint")
  valid_579972 = validateParameter(valid_579972, JBool, required = false,
                                 default = newJBool(true))
  if valid_579972 != nil:
    section.add "prettyPrint", valid_579972
  var valid_579973 = query.getOrDefault("oauth_token")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "oauth_token", valid_579973
  var valid_579974 = query.getOrDefault("$.xgafv")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = newJString("1"))
  if valid_579974 != nil:
    section.add "$.xgafv", valid_579974
  var valid_579975 = query.getOrDefault("pageSize")
  valid_579975 = validateParameter(valid_579975, JInt, required = false, default = nil)
  if valid_579975 != nil:
    section.add "pageSize", valid_579975
  var valid_579976 = query.getOrDefault("alt")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = newJString("json"))
  if valid_579976 != nil:
    section.add "alt", valid_579976
  var valid_579977 = query.getOrDefault("uploadType")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "uploadType", valid_579977
  var valid_579978 = query.getOrDefault("quotaUser")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "quotaUser", valid_579978
  var valid_579979 = query.getOrDefault("filter")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "filter", valid_579979
  var valid_579980 = query.getOrDefault("pageToken")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "pageToken", valid_579980
  var valid_579981 = query.getOrDefault("callback")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "callback", valid_579981
  var valid_579982 = query.getOrDefault("fields")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "fields", valid_579982
  var valid_579983 = query.getOrDefault("access_token")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "access_token", valid_579983
  var valid_579984 = query.getOrDefault("upload_protocol")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "upload_protocol", valid_579984
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579985: Call_BigquerydatatransferProjectsLocationsList_579967;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_579985.validator(path, query, header, formData, body)
  let scheme = call_579985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579985.url(scheme.get, call_579985.host, call_579985.base,
                         call_579985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579985, url, valid)

proc call*(call_579986: Call_BigquerydatatransferProjectsLocationsList_579967;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigquerydatatransferProjectsLocationsList
  ## Lists information about the supported locations for this service.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource that owns the locations collection, if applicable.
  ##   filter: string
  ##         : The standard list filter.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579987 = newJObject()
  var query_579988 = newJObject()
  add(query_579988, "key", newJString(key))
  add(query_579988, "prettyPrint", newJBool(prettyPrint))
  add(query_579988, "oauth_token", newJString(oauthToken))
  add(query_579988, "$.xgafv", newJString(Xgafv))
  add(query_579988, "pageSize", newJInt(pageSize))
  add(query_579988, "alt", newJString(alt))
  add(query_579988, "uploadType", newJString(uploadType))
  add(query_579988, "quotaUser", newJString(quotaUser))
  add(path_579987, "name", newJString(name))
  add(query_579988, "filter", newJString(filter))
  add(query_579988, "pageToken", newJString(pageToken))
  add(query_579988, "callback", newJString(callback))
  add(query_579988, "fields", newJString(fields))
  add(query_579988, "access_token", newJString(accessToken))
  add(query_579988, "upload_protocol", newJString(uploadProtocol))
  result = call_579986.call(path_579987, query_579988, nil, nil, nil)

var bigquerydatatransferProjectsLocationsList* = Call_BigquerydatatransferProjectsLocationsList_579967(
    name: "bigquerydatatransferProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "bigquerydatatransfer.googleapis.com", route: "/v1/{name}/locations",
    validator: validate_BigquerydatatransferProjectsLocationsList_579968,
    base: "/", url: url_BigquerydatatransferProjectsLocationsList_579969,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsLocationsDataSourcesCheckValidCreds_579989 = ref object of OpenApiRestCall_579364
proc url_BigquerydatatransferProjectsLocationsDataSourcesCheckValidCreds_579991(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigquerydatatransferProjectsLocationsDataSourcesCheckValidCreds_579990(
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
  var valid_579992 = path.getOrDefault("name")
  valid_579992 = validateParameter(valid_579992, JString, required = true,
                                 default = nil)
  if valid_579992 != nil:
    section.add "name", valid_579992
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
  var valid_579993 = query.getOrDefault("key")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "key", valid_579993
  var valid_579994 = query.getOrDefault("prettyPrint")
  valid_579994 = validateParameter(valid_579994, JBool, required = false,
                                 default = newJBool(true))
  if valid_579994 != nil:
    section.add "prettyPrint", valid_579994
  var valid_579995 = query.getOrDefault("oauth_token")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "oauth_token", valid_579995
  var valid_579996 = query.getOrDefault("$.xgafv")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = newJString("1"))
  if valid_579996 != nil:
    section.add "$.xgafv", valid_579996
  var valid_579997 = query.getOrDefault("alt")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = newJString("json"))
  if valid_579997 != nil:
    section.add "alt", valid_579997
  var valid_579998 = query.getOrDefault("uploadType")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "uploadType", valid_579998
  var valid_579999 = query.getOrDefault("quotaUser")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "quotaUser", valid_579999
  var valid_580000 = query.getOrDefault("callback")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "callback", valid_580000
  var valid_580001 = query.getOrDefault("fields")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "fields", valid_580001
  var valid_580002 = query.getOrDefault("access_token")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "access_token", valid_580002
  var valid_580003 = query.getOrDefault("upload_protocol")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "upload_protocol", valid_580003
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

proc call*(call_580005: Call_BigquerydatatransferProjectsLocationsDataSourcesCheckValidCreds_579989;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns true if valid credentials exist for the given data source and
  ## requesting user.
  ## Some data sources doesn't support service account, so we need to talk to
  ## them on behalf of the end user. This API just checks whether we have OAuth
  ## token for the particular user, which is a pre-requisite before user can
  ## create a transfer config.
  ## 
  let valid = call_580005.validator(path, query, header, formData, body)
  let scheme = call_580005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580005.url(scheme.get, call_580005.host, call_580005.base,
                         call_580005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580005, url, valid)

proc call*(call_580006: Call_BigquerydatatransferProjectsLocationsDataSourcesCheckValidCreds_579989;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## bigquerydatatransferProjectsLocationsDataSourcesCheckValidCreds
  ## Returns true if valid credentials exist for the given data source and
  ## requesting user.
  ## Some data sources doesn't support service account, so we need to talk to
  ## them on behalf of the end user. This API just checks whether we have OAuth
  ## token for the particular user, which is a pre-requisite before user can
  ## create a transfer config.
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
  ##       : Required. The data source in the form:
  ## `projects/{project_id}/dataSources/{data_source_id}`
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580007 = newJObject()
  var query_580008 = newJObject()
  var body_580009 = newJObject()
  add(query_580008, "key", newJString(key))
  add(query_580008, "prettyPrint", newJBool(prettyPrint))
  add(query_580008, "oauth_token", newJString(oauthToken))
  add(query_580008, "$.xgafv", newJString(Xgafv))
  add(query_580008, "alt", newJString(alt))
  add(query_580008, "uploadType", newJString(uploadType))
  add(query_580008, "quotaUser", newJString(quotaUser))
  add(path_580007, "name", newJString(name))
  if body != nil:
    body_580009 = body
  add(query_580008, "callback", newJString(callback))
  add(query_580008, "fields", newJString(fields))
  add(query_580008, "access_token", newJString(accessToken))
  add(query_580008, "upload_protocol", newJString(uploadProtocol))
  result = call_580006.call(path_580007, query_580008, nil, nil, body_580009)

var bigquerydatatransferProjectsLocationsDataSourcesCheckValidCreds* = Call_BigquerydatatransferProjectsLocationsDataSourcesCheckValidCreds_579989(
    name: "bigquerydatatransferProjectsLocationsDataSourcesCheckValidCreds",
    meth: HttpMethod.HttpPost, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{name}:checkValidCreds", validator: validate_BigquerydatatransferProjectsLocationsDataSourcesCheckValidCreds_579990,
    base: "/",
    url: url_BigquerydatatransferProjectsLocationsDataSourcesCheckValidCreds_579991,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsLocationsDataSourcesList_580010 = ref object of OpenApiRestCall_579364
proc url_BigquerydatatransferProjectsLocationsDataSourcesList_580012(
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
               (kind: ConstantSegment, value: "/dataSources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigquerydatatransferProjectsLocationsDataSourcesList_580011(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
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
  var valid_580013 = path.getOrDefault("parent")
  valid_580013 = validateParameter(valid_580013, JString, required = true,
                                 default = nil)
  if valid_580013 != nil:
    section.add "parent", valid_580013
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
  ##           : Page size. The default page size is the maximum value of 1000 results.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Pagination token, which can be used to request a specific page
  ## of `ListDataSourcesRequest` list results. For multiple-page
  ## results, `ListDataSourcesResponse` outputs
  ## a `next_page` token, which can be used as the
  ## `page_token` value to request the next page of list results.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580014 = query.getOrDefault("key")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "key", valid_580014
  var valid_580015 = query.getOrDefault("prettyPrint")
  valid_580015 = validateParameter(valid_580015, JBool, required = false,
                                 default = newJBool(true))
  if valid_580015 != nil:
    section.add "prettyPrint", valid_580015
  var valid_580016 = query.getOrDefault("oauth_token")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "oauth_token", valid_580016
  var valid_580017 = query.getOrDefault("$.xgafv")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = newJString("1"))
  if valid_580017 != nil:
    section.add "$.xgafv", valid_580017
  var valid_580018 = query.getOrDefault("pageSize")
  valid_580018 = validateParameter(valid_580018, JInt, required = false, default = nil)
  if valid_580018 != nil:
    section.add "pageSize", valid_580018
  var valid_580019 = query.getOrDefault("alt")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = newJString("json"))
  if valid_580019 != nil:
    section.add "alt", valid_580019
  var valid_580020 = query.getOrDefault("uploadType")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "uploadType", valid_580020
  var valid_580021 = query.getOrDefault("quotaUser")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "quotaUser", valid_580021
  var valid_580022 = query.getOrDefault("pageToken")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "pageToken", valid_580022
  var valid_580023 = query.getOrDefault("callback")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "callback", valid_580023
  var valid_580024 = query.getOrDefault("fields")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "fields", valid_580024
  var valid_580025 = query.getOrDefault("access_token")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "access_token", valid_580025
  var valid_580026 = query.getOrDefault("upload_protocol")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "upload_protocol", valid_580026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580027: Call_BigquerydatatransferProjectsLocationsDataSourcesList_580010;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists supported data sources and returns their settings,
  ## which can be used for UI rendering.
  ## 
  let valid = call_580027.validator(path, query, header, formData, body)
  let scheme = call_580027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580027.url(scheme.get, call_580027.host, call_580027.base,
                         call_580027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580027, url, valid)

proc call*(call_580028: Call_BigquerydatatransferProjectsLocationsDataSourcesList_580010;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigquerydatatransferProjectsLocationsDataSourcesList
  ## Lists supported data sources and returns their settings,
  ## which can be used for UI rendering.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Page size. The default page size is the maximum value of 1000 results.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Pagination token, which can be used to request a specific page
  ## of `ListDataSourcesRequest` list results. For multiple-page
  ## results, `ListDataSourcesResponse` outputs
  ## a `next_page` token, which can be used as the
  ## `page_token` value to request the next page of list results.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The BigQuery project id for which data sources should be returned.
  ## Must be in the form: `projects/{project_id}`
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580029 = newJObject()
  var query_580030 = newJObject()
  add(query_580030, "key", newJString(key))
  add(query_580030, "prettyPrint", newJBool(prettyPrint))
  add(query_580030, "oauth_token", newJString(oauthToken))
  add(query_580030, "$.xgafv", newJString(Xgafv))
  add(query_580030, "pageSize", newJInt(pageSize))
  add(query_580030, "alt", newJString(alt))
  add(query_580030, "uploadType", newJString(uploadType))
  add(query_580030, "quotaUser", newJString(quotaUser))
  add(query_580030, "pageToken", newJString(pageToken))
  add(query_580030, "callback", newJString(callback))
  add(path_580029, "parent", newJString(parent))
  add(query_580030, "fields", newJString(fields))
  add(query_580030, "access_token", newJString(accessToken))
  add(query_580030, "upload_protocol", newJString(uploadProtocol))
  result = call_580028.call(path_580029, query_580030, nil, nil, nil)

var bigquerydatatransferProjectsLocationsDataSourcesList* = Call_BigquerydatatransferProjectsLocationsDataSourcesList_580010(
    name: "bigquerydatatransferProjectsLocationsDataSourcesList",
    meth: HttpMethod.HttpGet, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}/dataSources",
    validator: validate_BigquerydatatransferProjectsLocationsDataSourcesList_580011,
    base: "/", url: url_BigquerydatatransferProjectsLocationsDataSourcesList_580012,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsLocationsTransferConfigsRunsList_580031 = ref object of OpenApiRestCall_579364
proc url_BigquerydatatransferProjectsLocationsTransferConfigsRunsList_580033(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigquerydatatransferProjectsLocationsTransferConfigsRunsList_580032(
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
  var valid_580034 = path.getOrDefault("parent")
  valid_580034 = validateParameter(valid_580034, JString, required = true,
                                 default = nil)
  if valid_580034 != nil:
    section.add "parent", valid_580034
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
  ##   runAttempt: JString
  ##             : Indicates how run attempts are to be pulled.
  ##   pageSize: JInt
  ##           : Page size. The default page size is the maximum value of 1000 results.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Pagination token, which can be used to request a specific page
  ## of `ListTransferRunsRequest` list results. For multiple-page
  ## results, `ListTransferRunsResponse` outputs
  ## a `next_page` token, which can be used as the
  ## `page_token` value to request the next page of list results.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   states: JArray
  ##         : When specified, only transfer runs with requested states are returned.
  section = newJObject()
  var valid_580035 = query.getOrDefault("key")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "key", valid_580035
  var valid_580036 = query.getOrDefault("prettyPrint")
  valid_580036 = validateParameter(valid_580036, JBool, required = false,
                                 default = newJBool(true))
  if valid_580036 != nil:
    section.add "prettyPrint", valid_580036
  var valid_580037 = query.getOrDefault("oauth_token")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "oauth_token", valid_580037
  var valid_580038 = query.getOrDefault("$.xgafv")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = newJString("1"))
  if valid_580038 != nil:
    section.add "$.xgafv", valid_580038
  var valid_580039 = query.getOrDefault("runAttempt")
  valid_580039 = validateParameter(valid_580039, JString, required = false, default = newJString(
      "RUN_ATTEMPT_UNSPECIFIED"))
  if valid_580039 != nil:
    section.add "runAttempt", valid_580039
  var valid_580040 = query.getOrDefault("pageSize")
  valid_580040 = validateParameter(valid_580040, JInt, required = false, default = nil)
  if valid_580040 != nil:
    section.add "pageSize", valid_580040
  var valid_580041 = query.getOrDefault("alt")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = newJString("json"))
  if valid_580041 != nil:
    section.add "alt", valid_580041
  var valid_580042 = query.getOrDefault("uploadType")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "uploadType", valid_580042
  var valid_580043 = query.getOrDefault("quotaUser")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "quotaUser", valid_580043
  var valid_580044 = query.getOrDefault("pageToken")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "pageToken", valid_580044
  var valid_580045 = query.getOrDefault("callback")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "callback", valid_580045
  var valid_580046 = query.getOrDefault("fields")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "fields", valid_580046
  var valid_580047 = query.getOrDefault("access_token")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "access_token", valid_580047
  var valid_580048 = query.getOrDefault("upload_protocol")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "upload_protocol", valid_580048
  var valid_580049 = query.getOrDefault("states")
  valid_580049 = validateParameter(valid_580049, JArray, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "states", valid_580049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580050: Call_BigquerydatatransferProjectsLocationsTransferConfigsRunsList_580031;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about running and completed jobs.
  ## 
  let valid = call_580050.validator(path, query, header, formData, body)
  let scheme = call_580050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580050.url(scheme.get, call_580050.host, call_580050.base,
                         call_580050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580050, url, valid)

proc call*(call_580051: Call_BigquerydatatransferProjectsLocationsTransferConfigsRunsList_580031;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1";
          runAttempt: string = "RUN_ATTEMPT_UNSPECIFIED"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""; states: JsonNode = nil): Recallable =
  ## bigquerydatatransferProjectsLocationsTransferConfigsRunsList
  ## Returns information about running and completed jobs.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   runAttempt: string
  ##             : Indicates how run attempts are to be pulled.
  ##   pageSize: int
  ##           : Page size. The default page size is the maximum value of 1000 results.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Pagination token, which can be used to request a specific page
  ## of `ListTransferRunsRequest` list results. For multiple-page
  ## results, `ListTransferRunsResponse` outputs
  ## a `next_page` token, which can be used as the
  ## `page_token` value to request the next page of list results.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. Name of transfer configuration for which transfer runs should be retrieved.
  ## Format of transfer configuration resource name is:
  ## `projects/{project_id}/transferConfigs/{config_id}`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   states: JArray
  ##         : When specified, only transfer runs with requested states are returned.
  var path_580052 = newJObject()
  var query_580053 = newJObject()
  add(query_580053, "key", newJString(key))
  add(query_580053, "prettyPrint", newJBool(prettyPrint))
  add(query_580053, "oauth_token", newJString(oauthToken))
  add(query_580053, "$.xgafv", newJString(Xgafv))
  add(query_580053, "runAttempt", newJString(runAttempt))
  add(query_580053, "pageSize", newJInt(pageSize))
  add(query_580053, "alt", newJString(alt))
  add(query_580053, "uploadType", newJString(uploadType))
  add(query_580053, "quotaUser", newJString(quotaUser))
  add(query_580053, "pageToken", newJString(pageToken))
  add(query_580053, "callback", newJString(callback))
  add(path_580052, "parent", newJString(parent))
  add(query_580053, "fields", newJString(fields))
  add(query_580053, "access_token", newJString(accessToken))
  add(query_580053, "upload_protocol", newJString(uploadProtocol))
  if states != nil:
    query_580053.add "states", states
  result = call_580051.call(path_580052, query_580053, nil, nil, nil)

var bigquerydatatransferProjectsLocationsTransferConfigsRunsList* = Call_BigquerydatatransferProjectsLocationsTransferConfigsRunsList_580031(
    name: "bigquerydatatransferProjectsLocationsTransferConfigsRunsList",
    meth: HttpMethod.HttpGet, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}/runs", validator: validate_BigquerydatatransferProjectsLocationsTransferConfigsRunsList_580032,
    base: "/",
    url: url_BigquerydatatransferProjectsLocationsTransferConfigsRunsList_580033,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsLocationsTransferConfigsCreate_580076 = ref object of OpenApiRestCall_579364
proc url_BigquerydatatransferProjectsLocationsTransferConfigsCreate_580078(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigquerydatatransferProjectsLocationsTransferConfigsCreate_580077(
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
  var valid_580079 = path.getOrDefault("parent")
  valid_580079 = validateParameter(valid_580079, JString, required = true,
                                 default = nil)
  if valid_580079 != nil:
    section.add "parent", valid_580079
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
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
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   versionInfo: JString
  ##              : Optional version info. If users want to find a very recent access token,
  ## that is, immediately after approving access, users have to set the
  ## version_info claim in the token request. To obtain the version_info, users
  ## must use the "none+gsession" response type. which be return a
  ## version_info back in the authorization response which be be put in a JWT
  ## claim in the token request.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   serviceAccountName: JString
  ##                     : Optional service account name. If this field is set, transfer config will
  ## be created with this service account credentials. It requires that
  ## requesting user calling this API has permissions to act as this service
  ## account.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580080 = query.getOrDefault("key")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "key", valid_580080
  var valid_580081 = query.getOrDefault("prettyPrint")
  valid_580081 = validateParameter(valid_580081, JBool, required = false,
                                 default = newJBool(true))
  if valid_580081 != nil:
    section.add "prettyPrint", valid_580081
  var valid_580082 = query.getOrDefault("oauth_token")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "oauth_token", valid_580082
  var valid_580083 = query.getOrDefault("authorizationCode")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "authorizationCode", valid_580083
  var valid_580084 = query.getOrDefault("$.xgafv")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = newJString("1"))
  if valid_580084 != nil:
    section.add "$.xgafv", valid_580084
  var valid_580085 = query.getOrDefault("versionInfo")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "versionInfo", valid_580085
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
  var valid_580089 = query.getOrDefault("serviceAccountName")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "serviceAccountName", valid_580089
  var valid_580090 = query.getOrDefault("callback")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "callback", valid_580090
  var valid_580091 = query.getOrDefault("fields")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "fields", valid_580091
  var valid_580092 = query.getOrDefault("access_token")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "access_token", valid_580092
  var valid_580093 = query.getOrDefault("upload_protocol")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "upload_protocol", valid_580093
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

proc call*(call_580095: Call_BigquerydatatransferProjectsLocationsTransferConfigsCreate_580076;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new data transfer configuration.
  ## 
  let valid = call_580095.validator(path, query, header, formData, body)
  let scheme = call_580095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580095.url(scheme.get, call_580095.host, call_580095.base,
                         call_580095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580095, url, valid)

proc call*(call_580096: Call_BigquerydatatransferProjectsLocationsTransferConfigsCreate_580076;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; authorizationCode: string = ""; Xgafv: string = "1";
          versionInfo: string = ""; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; serviceAccountName: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## bigquerydatatransferProjectsLocationsTransferConfigsCreate
  ## Creates a new data transfer configuration.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
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
  ##   Xgafv: string
  ##        : V1 error format.
  ##   versionInfo: string
  ##              : Optional version info. If users want to find a very recent access token,
  ## that is, immediately after approving access, users have to set the
  ## version_info claim in the token request. To obtain the version_info, users
  ## must use the "none+gsession" response type. which be return a
  ## version_info back in the authorization response which be be put in a JWT
  ## claim in the token request.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   serviceAccountName: string
  ##                     : Optional service account name. If this field is set, transfer config will
  ## be created with this service account credentials. It requires that
  ## requesting user calling this API has permissions to act as this service
  ## account.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The BigQuery project id where the transfer configuration should be created.
  ## Must be in the format projects/{project_id}/locations/{location_id}
  ## If specified location and location of the destination bigquery dataset
  ## do not match - the request will fail.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580097 = newJObject()
  var query_580098 = newJObject()
  var body_580099 = newJObject()
  add(query_580098, "key", newJString(key))
  add(query_580098, "prettyPrint", newJBool(prettyPrint))
  add(query_580098, "oauth_token", newJString(oauthToken))
  add(query_580098, "authorizationCode", newJString(authorizationCode))
  add(query_580098, "$.xgafv", newJString(Xgafv))
  add(query_580098, "versionInfo", newJString(versionInfo))
  add(query_580098, "alt", newJString(alt))
  add(query_580098, "uploadType", newJString(uploadType))
  add(query_580098, "quotaUser", newJString(quotaUser))
  add(query_580098, "serviceAccountName", newJString(serviceAccountName))
  if body != nil:
    body_580099 = body
  add(query_580098, "callback", newJString(callback))
  add(path_580097, "parent", newJString(parent))
  add(query_580098, "fields", newJString(fields))
  add(query_580098, "access_token", newJString(accessToken))
  add(query_580098, "upload_protocol", newJString(uploadProtocol))
  result = call_580096.call(path_580097, query_580098, nil, nil, body_580099)

var bigquerydatatransferProjectsLocationsTransferConfigsCreate* = Call_BigquerydatatransferProjectsLocationsTransferConfigsCreate_580076(
    name: "bigquerydatatransferProjectsLocationsTransferConfigsCreate",
    meth: HttpMethod.HttpPost, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}/transferConfigs", validator: validate_BigquerydatatransferProjectsLocationsTransferConfigsCreate_580077,
    base: "/",
    url: url_BigquerydatatransferProjectsLocationsTransferConfigsCreate_580078,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsLocationsTransferConfigsList_580054 = ref object of OpenApiRestCall_579364
proc url_BigquerydatatransferProjectsLocationsTransferConfigsList_580056(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigquerydatatransferProjectsLocationsTransferConfigsList_580055(
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
  var valid_580057 = path.getOrDefault("parent")
  valid_580057 = validateParameter(valid_580057, JString, required = true,
                                 default = nil)
  if valid_580057 != nil:
    section.add "parent", valid_580057
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   dataSourceIds: JArray
  ##                : When specified, only configurations of requested data sources are returned.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Page size. The default page size is the maximum value of 1000 results.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Pagination token, which can be used to request a specific page
  ## of `ListTransfersRequest` list results. For multiple-page
  ## results, `ListTransfersResponse` outputs
  ## a `next_page` token, which can be used as the
  ## `page_token` value to request the next page of list results.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580058 = query.getOrDefault("key")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "key", valid_580058
  var valid_580059 = query.getOrDefault("prettyPrint")
  valid_580059 = validateParameter(valid_580059, JBool, required = false,
                                 default = newJBool(true))
  if valid_580059 != nil:
    section.add "prettyPrint", valid_580059
  var valid_580060 = query.getOrDefault("oauth_token")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "oauth_token", valid_580060
  var valid_580061 = query.getOrDefault("dataSourceIds")
  valid_580061 = validateParameter(valid_580061, JArray, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "dataSourceIds", valid_580061
  var valid_580062 = query.getOrDefault("$.xgafv")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = newJString("1"))
  if valid_580062 != nil:
    section.add "$.xgafv", valid_580062
  var valid_580063 = query.getOrDefault("pageSize")
  valid_580063 = validateParameter(valid_580063, JInt, required = false, default = nil)
  if valid_580063 != nil:
    section.add "pageSize", valid_580063
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
  var valid_580067 = query.getOrDefault("pageToken")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "pageToken", valid_580067
  var valid_580068 = query.getOrDefault("callback")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "callback", valid_580068
  var valid_580069 = query.getOrDefault("fields")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "fields", valid_580069
  var valid_580070 = query.getOrDefault("access_token")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "access_token", valid_580070
  var valid_580071 = query.getOrDefault("upload_protocol")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "upload_protocol", valid_580071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580072: Call_BigquerydatatransferProjectsLocationsTransferConfigsList_580054;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about all data transfers in the project.
  ## 
  let valid = call_580072.validator(path, query, header, formData, body)
  let scheme = call_580072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580072.url(scheme.get, call_580072.host, call_580072.base,
                         call_580072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580072, url, valid)

proc call*(call_580073: Call_BigquerydatatransferProjectsLocationsTransferConfigsList_580054;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; dataSourceIds: JsonNode = nil; Xgafv: string = "1";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigquerydatatransferProjectsLocationsTransferConfigsList
  ## Returns information about all data transfers in the project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   dataSourceIds: JArray
  ##                : When specified, only configurations of requested data sources are returned.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Page size. The default page size is the maximum value of 1000 results.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Pagination token, which can be used to request a specific page
  ## of `ListTransfersRequest` list results. For multiple-page
  ## results, `ListTransfersResponse` outputs
  ## a `next_page` token, which can be used as the
  ## `page_token` value to request the next page of list results.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The BigQuery project id for which data sources
  ## should be returned: `projects/{project_id}`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580074 = newJObject()
  var query_580075 = newJObject()
  add(query_580075, "key", newJString(key))
  add(query_580075, "prettyPrint", newJBool(prettyPrint))
  add(query_580075, "oauth_token", newJString(oauthToken))
  if dataSourceIds != nil:
    query_580075.add "dataSourceIds", dataSourceIds
  add(query_580075, "$.xgafv", newJString(Xgafv))
  add(query_580075, "pageSize", newJInt(pageSize))
  add(query_580075, "alt", newJString(alt))
  add(query_580075, "uploadType", newJString(uploadType))
  add(query_580075, "quotaUser", newJString(quotaUser))
  add(query_580075, "pageToken", newJString(pageToken))
  add(query_580075, "callback", newJString(callback))
  add(path_580074, "parent", newJString(parent))
  add(query_580075, "fields", newJString(fields))
  add(query_580075, "access_token", newJString(accessToken))
  add(query_580075, "upload_protocol", newJString(uploadProtocol))
  result = call_580073.call(path_580074, query_580075, nil, nil, nil)

var bigquerydatatransferProjectsLocationsTransferConfigsList* = Call_BigquerydatatransferProjectsLocationsTransferConfigsList_580054(
    name: "bigquerydatatransferProjectsLocationsTransferConfigsList",
    meth: HttpMethod.HttpGet, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}/transferConfigs", validator: validate_BigquerydatatransferProjectsLocationsTransferConfigsList_580055,
    base: "/", url: url_BigquerydatatransferProjectsLocationsTransferConfigsList_580056,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsLocationsTransferConfigsRunsTransferLogsList_580100 = ref object of OpenApiRestCall_579364
proc url_BigquerydatatransferProjectsLocationsTransferConfigsRunsTransferLogsList_580102(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigquerydatatransferProjectsLocationsTransferConfigsRunsTransferLogsList_580101(
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
  var valid_580103 = path.getOrDefault("parent")
  valid_580103 = validateParameter(valid_580103, JString, required = true,
                                 default = nil)
  if valid_580103 != nil:
    section.add "parent", valid_580103
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
  ##           : Page size. The default page size is the maximum value of 1000 results.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Pagination token, which can be used to request a specific page
  ## of `ListTransferLogsRequest` list results. For multiple-page
  ## results, `ListTransferLogsResponse` outputs
  ## a `next_page` token, which can be used as the
  ## `page_token` value to request the next page of list results.
  ##   messageTypes: JArray
  ##               : Message types to return. If not populated - INFO, WARNING and ERROR
  ## messages are returned.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_580104 = query.getOrDefault("key")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "key", valid_580104
  var valid_580105 = query.getOrDefault("prettyPrint")
  valid_580105 = validateParameter(valid_580105, JBool, required = false,
                                 default = newJBool(true))
  if valid_580105 != nil:
    section.add "prettyPrint", valid_580105
  var valid_580106 = query.getOrDefault("oauth_token")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "oauth_token", valid_580106
  var valid_580107 = query.getOrDefault("$.xgafv")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = newJString("1"))
  if valid_580107 != nil:
    section.add "$.xgafv", valid_580107
  var valid_580108 = query.getOrDefault("pageSize")
  valid_580108 = validateParameter(valid_580108, JInt, required = false, default = nil)
  if valid_580108 != nil:
    section.add "pageSize", valid_580108
  var valid_580109 = query.getOrDefault("alt")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = newJString("json"))
  if valid_580109 != nil:
    section.add "alt", valid_580109
  var valid_580110 = query.getOrDefault("uploadType")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "uploadType", valid_580110
  var valid_580111 = query.getOrDefault("quotaUser")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "quotaUser", valid_580111
  var valid_580112 = query.getOrDefault("pageToken")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "pageToken", valid_580112
  var valid_580113 = query.getOrDefault("messageTypes")
  valid_580113 = validateParameter(valid_580113, JArray, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "messageTypes", valid_580113
  var valid_580114 = query.getOrDefault("callback")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "callback", valid_580114
  var valid_580115 = query.getOrDefault("fields")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "fields", valid_580115
  var valid_580116 = query.getOrDefault("access_token")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "access_token", valid_580116
  var valid_580117 = query.getOrDefault("upload_protocol")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "upload_protocol", valid_580117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580118: Call_BigquerydatatransferProjectsLocationsTransferConfigsRunsTransferLogsList_580100;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns user facing log messages for the data transfer run.
  ## 
  let valid = call_580118.validator(path, query, header, formData, body)
  let scheme = call_580118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580118.url(scheme.get, call_580118.host, call_580118.base,
                         call_580118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580118, url, valid)

proc call*(call_580119: Call_BigquerydatatransferProjectsLocationsTransferConfigsRunsTransferLogsList_580100;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; messageTypes: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigquerydatatransferProjectsLocationsTransferConfigsRunsTransferLogsList
  ## Returns user facing log messages for the data transfer run.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Page size. The default page size is the maximum value of 1000 results.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Pagination token, which can be used to request a specific page
  ## of `ListTransferLogsRequest` list results. For multiple-page
  ## results, `ListTransferLogsResponse` outputs
  ## a `next_page` token, which can be used as the
  ## `page_token` value to request the next page of list results.
  ##   messageTypes: JArray
  ##               : Message types to return. If not populated - INFO, WARNING and ERROR
  ## messages are returned.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. Transfer run name in the form:
  ## `projects/{project_id}/transferConfigs/{config_Id}/runs/{run_id}`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580120 = newJObject()
  var query_580121 = newJObject()
  add(query_580121, "key", newJString(key))
  add(query_580121, "prettyPrint", newJBool(prettyPrint))
  add(query_580121, "oauth_token", newJString(oauthToken))
  add(query_580121, "$.xgafv", newJString(Xgafv))
  add(query_580121, "pageSize", newJInt(pageSize))
  add(query_580121, "alt", newJString(alt))
  add(query_580121, "uploadType", newJString(uploadType))
  add(query_580121, "quotaUser", newJString(quotaUser))
  add(query_580121, "pageToken", newJString(pageToken))
  if messageTypes != nil:
    query_580121.add "messageTypes", messageTypes
  add(query_580121, "callback", newJString(callback))
  add(path_580120, "parent", newJString(parent))
  add(query_580121, "fields", newJString(fields))
  add(query_580121, "access_token", newJString(accessToken))
  add(query_580121, "upload_protocol", newJString(uploadProtocol))
  result = call_580119.call(path_580120, query_580121, nil, nil, nil)

var bigquerydatatransferProjectsLocationsTransferConfigsRunsTransferLogsList* = Call_BigquerydatatransferProjectsLocationsTransferConfigsRunsTransferLogsList_580100(name: "bigquerydatatransferProjectsLocationsTransferConfigsRunsTransferLogsList",
    meth: HttpMethod.HttpGet, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}/transferLogs", validator: validate_BigquerydatatransferProjectsLocationsTransferConfigsRunsTransferLogsList_580101,
    base: "/", url: url_BigquerydatatransferProjectsLocationsTransferConfigsRunsTransferLogsList_580102,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsLocationsTransferConfigsScheduleRuns_580122 = ref object of OpenApiRestCall_579364
proc url_BigquerydatatransferProjectsLocationsTransferConfigsScheduleRuns_580124(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigquerydatatransferProjectsLocationsTransferConfigsScheduleRuns_580123(
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
  var valid_580125 = path.getOrDefault("parent")
  valid_580125 = validateParameter(valid_580125, JString, required = true,
                                 default = nil)
  if valid_580125 != nil:
    section.add "parent", valid_580125
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
  var valid_580126 = query.getOrDefault("key")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "key", valid_580126
  var valid_580127 = query.getOrDefault("prettyPrint")
  valid_580127 = validateParameter(valid_580127, JBool, required = false,
                                 default = newJBool(true))
  if valid_580127 != nil:
    section.add "prettyPrint", valid_580127
  var valid_580128 = query.getOrDefault("oauth_token")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "oauth_token", valid_580128
  var valid_580129 = query.getOrDefault("$.xgafv")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = newJString("1"))
  if valid_580129 != nil:
    section.add "$.xgafv", valid_580129
  var valid_580130 = query.getOrDefault("alt")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = newJString("json"))
  if valid_580130 != nil:
    section.add "alt", valid_580130
  var valid_580131 = query.getOrDefault("uploadType")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "uploadType", valid_580131
  var valid_580132 = query.getOrDefault("quotaUser")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "quotaUser", valid_580132
  var valid_580133 = query.getOrDefault("callback")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "callback", valid_580133
  var valid_580134 = query.getOrDefault("fields")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "fields", valid_580134
  var valid_580135 = query.getOrDefault("access_token")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "access_token", valid_580135
  var valid_580136 = query.getOrDefault("upload_protocol")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "upload_protocol", valid_580136
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

proc call*(call_580138: Call_BigquerydatatransferProjectsLocationsTransferConfigsScheduleRuns_580122;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates transfer runs for a time range [start_time, end_time].
  ## For each date - or whatever granularity the data source supports - in the
  ## range, one transfer run is created.
  ## Note that runs are created per UTC time in the time range.
  ## DEPRECATED: use StartManualTransferRuns instead.
  ## 
  let valid = call_580138.validator(path, query, header, formData, body)
  let scheme = call_580138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580138.url(scheme.get, call_580138.host, call_580138.base,
                         call_580138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580138, url, valid)

proc call*(call_580139: Call_BigquerydatatransferProjectsLocationsTransferConfigsScheduleRuns_580122;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## bigquerydatatransferProjectsLocationsTransferConfigsScheduleRuns
  ## Creates transfer runs for a time range [start_time, end_time].
  ## For each date - or whatever granularity the data source supports - in the
  ## range, one transfer run is created.
  ## Note that runs are created per UTC time in the time range.
  ## DEPRECATED: use StartManualTransferRuns instead.
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
  ##         : Required. Transfer configuration name in the form:
  ## `projects/{project_id}/transferConfigs/{config_id}`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580140 = newJObject()
  var query_580141 = newJObject()
  var body_580142 = newJObject()
  add(query_580141, "key", newJString(key))
  add(query_580141, "prettyPrint", newJBool(prettyPrint))
  add(query_580141, "oauth_token", newJString(oauthToken))
  add(query_580141, "$.xgafv", newJString(Xgafv))
  add(query_580141, "alt", newJString(alt))
  add(query_580141, "uploadType", newJString(uploadType))
  add(query_580141, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580142 = body
  add(query_580141, "callback", newJString(callback))
  add(path_580140, "parent", newJString(parent))
  add(query_580141, "fields", newJString(fields))
  add(query_580141, "access_token", newJString(accessToken))
  add(query_580141, "upload_protocol", newJString(uploadProtocol))
  result = call_580139.call(path_580140, query_580141, nil, nil, body_580142)

var bigquerydatatransferProjectsLocationsTransferConfigsScheduleRuns* = Call_BigquerydatatransferProjectsLocationsTransferConfigsScheduleRuns_580122(
    name: "bigquerydatatransferProjectsLocationsTransferConfigsScheduleRuns",
    meth: HttpMethod.HttpPost, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}:scheduleRuns", validator: validate_BigquerydatatransferProjectsLocationsTransferConfigsScheduleRuns_580123,
    base: "/",
    url: url_BigquerydatatransferProjectsLocationsTransferConfigsScheduleRuns_580124,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsLocationsTransferConfigsStartManualRuns_580143 = ref object of OpenApiRestCall_579364
proc url_BigquerydatatransferProjectsLocationsTransferConfigsStartManualRuns_580145(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigquerydatatransferProjectsLocationsTransferConfigsStartManualRuns_580144(
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
  var valid_580146 = path.getOrDefault("parent")
  valid_580146 = validateParameter(valid_580146, JString, required = true,
                                 default = nil)
  if valid_580146 != nil:
    section.add "parent", valid_580146
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
  var valid_580147 = query.getOrDefault("key")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "key", valid_580147
  var valid_580148 = query.getOrDefault("prettyPrint")
  valid_580148 = validateParameter(valid_580148, JBool, required = false,
                                 default = newJBool(true))
  if valid_580148 != nil:
    section.add "prettyPrint", valid_580148
  var valid_580149 = query.getOrDefault("oauth_token")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "oauth_token", valid_580149
  var valid_580150 = query.getOrDefault("$.xgafv")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = newJString("1"))
  if valid_580150 != nil:
    section.add "$.xgafv", valid_580150
  var valid_580151 = query.getOrDefault("alt")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = newJString("json"))
  if valid_580151 != nil:
    section.add "alt", valid_580151
  var valid_580152 = query.getOrDefault("uploadType")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "uploadType", valid_580152
  var valid_580153 = query.getOrDefault("quotaUser")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "quotaUser", valid_580153
  var valid_580154 = query.getOrDefault("callback")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "callback", valid_580154
  var valid_580155 = query.getOrDefault("fields")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "fields", valid_580155
  var valid_580156 = query.getOrDefault("access_token")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "access_token", valid_580156
  var valid_580157 = query.getOrDefault("upload_protocol")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "upload_protocol", valid_580157
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

proc call*(call_580159: Call_BigquerydatatransferProjectsLocationsTransferConfigsStartManualRuns_580143;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Start manual transfer runs to be executed now with schedule_time equal to
  ## current time. The transfer runs can be created for a time range where the
  ## run_time is between start_time (inclusive) and end_time (exclusive), or for
  ## a specific run_time.
  ## 
  let valid = call_580159.validator(path, query, header, formData, body)
  let scheme = call_580159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580159.url(scheme.get, call_580159.host, call_580159.base,
                         call_580159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580159, url, valid)

proc call*(call_580160: Call_BigquerydatatransferProjectsLocationsTransferConfigsStartManualRuns_580143;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## bigquerydatatransferProjectsLocationsTransferConfigsStartManualRuns
  ## Start manual transfer runs to be executed now with schedule_time equal to
  ## current time. The transfer runs can be created for a time range where the
  ## run_time is between start_time (inclusive) and end_time (exclusive), or for
  ## a specific run_time.
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
  ##         : Transfer configuration name in the form:
  ## `projects/{project_id}/transferConfigs/{config_id}`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_580161 = newJObject()
  var query_580162 = newJObject()
  var body_580163 = newJObject()
  add(query_580162, "key", newJString(key))
  add(query_580162, "prettyPrint", newJBool(prettyPrint))
  add(query_580162, "oauth_token", newJString(oauthToken))
  add(query_580162, "$.xgafv", newJString(Xgafv))
  add(query_580162, "alt", newJString(alt))
  add(query_580162, "uploadType", newJString(uploadType))
  add(query_580162, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580163 = body
  add(query_580162, "callback", newJString(callback))
  add(path_580161, "parent", newJString(parent))
  add(query_580162, "fields", newJString(fields))
  add(query_580162, "access_token", newJString(accessToken))
  add(query_580162, "upload_protocol", newJString(uploadProtocol))
  result = call_580160.call(path_580161, query_580162, nil, nil, body_580163)

var bigquerydatatransferProjectsLocationsTransferConfigsStartManualRuns* = Call_BigquerydatatransferProjectsLocationsTransferConfigsStartManualRuns_580143(name: "bigquerydatatransferProjectsLocationsTransferConfigsStartManualRuns",
    meth: HttpMethod.HttpPost, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}:startManualRuns", validator: validate_BigquerydatatransferProjectsLocationsTransferConfigsStartManualRuns_580144,
    base: "/", url: url_BigquerydatatransferProjectsLocationsTransferConfigsStartManualRuns_580145,
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
