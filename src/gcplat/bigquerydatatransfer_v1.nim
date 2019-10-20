
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
  gcpServiceName = "bigquerydatatransfer"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BigquerydatatransferProjectsTransferConfigsRunsGet_578610 = ref object of OpenApiRestCall_578339
proc url_BigquerydatatransferProjectsTransferConfigsRunsGet_578612(
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

proc validate_BigquerydatatransferProjectsTransferConfigsRunsGet_578611(
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

proc call*(call_578785: Call_BigquerydatatransferProjectsTransferConfigsRunsGet_578610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about the particular transfer run.
  ## 
  let valid = call_578785.validator(path, query, header, formData, body)
  let scheme = call_578785.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578785.url(scheme.get, call_578785.host, call_578785.base,
                         call_578785.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578785, url, valid)

proc call*(call_578856: Call_BigquerydatatransferProjectsTransferConfigsRunsGet_578610;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigquerydatatransferProjectsTransferConfigsRunsGet
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

var bigquerydatatransferProjectsTransferConfigsRunsGet* = Call_BigquerydatatransferProjectsTransferConfigsRunsGet_578610(
    name: "bigquerydatatransferProjectsTransferConfigsRunsGet",
    meth: HttpMethod.HttpGet, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{name}",
    validator: validate_BigquerydatatransferProjectsTransferConfigsRunsGet_578611,
    base: "/", url: url_BigquerydatatransferProjectsTransferConfigsRunsGet_578612,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsPatch_578917 = ref object of OpenApiRestCall_578339
proc url_BigquerydatatransferProjectsTransferConfigsPatch_578919(
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

proc validate_BigquerydatatransferProjectsTransferConfigsPatch_578918(
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
  var valid_578924 = query.getOrDefault("authorizationCode")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "authorizationCode", valid_578924
  var valid_578925 = query.getOrDefault("$.xgafv")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = newJString("1"))
  if valid_578925 != nil:
    section.add "$.xgafv", valid_578925
  var valid_578926 = query.getOrDefault("versionInfo")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "versionInfo", valid_578926
  var valid_578927 = query.getOrDefault("alt")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = newJString("json"))
  if valid_578927 != nil:
    section.add "alt", valid_578927
  var valid_578928 = query.getOrDefault("uploadType")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "uploadType", valid_578928
  var valid_578929 = query.getOrDefault("quotaUser")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "quotaUser", valid_578929
  var valid_578930 = query.getOrDefault("updateMask")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "updateMask", valid_578930
  var valid_578931 = query.getOrDefault("callback")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "callback", valid_578931
  var valid_578932 = query.getOrDefault("fields")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "fields", valid_578932
  var valid_578933 = query.getOrDefault("access_token")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "access_token", valid_578933
  var valid_578934 = query.getOrDefault("upload_protocol")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "upload_protocol", valid_578934
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

proc call*(call_578936: Call_BigquerydatatransferProjectsTransferConfigsPatch_578917;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a data transfer configuration.
  ## All fields must be set, even if they are not updated.
  ## 
  let valid = call_578936.validator(path, query, header, formData, body)
  let scheme = call_578936.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578936.url(scheme.get, call_578936.host, call_578936.base,
                         call_578936.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578936, url, valid)

proc call*(call_578937: Call_BigquerydatatransferProjectsTransferConfigsPatch_578917;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; authorizationCode: string = ""; Xgafv: string = "1";
          versionInfo: string = ""; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; updateMask: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## bigquerydatatransferProjectsTransferConfigsPatch
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
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578938 = newJObject()
  var query_578939 = newJObject()
  var body_578940 = newJObject()
  add(query_578939, "key", newJString(key))
  add(query_578939, "prettyPrint", newJBool(prettyPrint))
  add(query_578939, "oauth_token", newJString(oauthToken))
  add(query_578939, "authorizationCode", newJString(authorizationCode))
  add(query_578939, "$.xgafv", newJString(Xgafv))
  add(query_578939, "versionInfo", newJString(versionInfo))
  add(query_578939, "alt", newJString(alt))
  add(query_578939, "uploadType", newJString(uploadType))
  add(query_578939, "quotaUser", newJString(quotaUser))
  add(path_578938, "name", newJString(name))
  add(query_578939, "updateMask", newJString(updateMask))
  if body != nil:
    body_578940 = body
  add(query_578939, "callback", newJString(callback))
  add(query_578939, "fields", newJString(fields))
  add(query_578939, "access_token", newJString(accessToken))
  add(query_578939, "upload_protocol", newJString(uploadProtocol))
  result = call_578937.call(path_578938, query_578939, nil, nil, body_578940)

var bigquerydatatransferProjectsTransferConfigsPatch* = Call_BigquerydatatransferProjectsTransferConfigsPatch_578917(
    name: "bigquerydatatransferProjectsTransferConfigsPatch",
    meth: HttpMethod.HttpPatch, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{name}",
    validator: validate_BigquerydatatransferProjectsTransferConfigsPatch_578918,
    base: "/", url: url_BigquerydatatransferProjectsTransferConfigsPatch_578919,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsRunsDelete_578898 = ref object of OpenApiRestCall_578339
proc url_BigquerydatatransferProjectsTransferConfigsRunsDelete_578900(
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

proc validate_BigquerydatatransferProjectsTransferConfigsRunsDelete_578899(
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

proc call*(call_578913: Call_BigquerydatatransferProjectsTransferConfigsRunsDelete_578898;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified transfer run.
  ## 
  let valid = call_578913.validator(path, query, header, formData, body)
  let scheme = call_578913.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578913.url(scheme.get, call_578913.host, call_578913.base,
                         call_578913.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578913, url, valid)

proc call*(call_578914: Call_BigquerydatatransferProjectsTransferConfigsRunsDelete_578898;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigquerydatatransferProjectsTransferConfigsRunsDelete
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

var bigquerydatatransferProjectsTransferConfigsRunsDelete* = Call_BigquerydatatransferProjectsTransferConfigsRunsDelete_578898(
    name: "bigquerydatatransferProjectsTransferConfigsRunsDelete",
    meth: HttpMethod.HttpDelete, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{name}",
    validator: validate_BigquerydatatransferProjectsTransferConfigsRunsDelete_578899,
    base: "/", url: url_BigquerydatatransferProjectsTransferConfigsRunsDelete_578900,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsLocationsList_578941 = ref object of OpenApiRestCall_578339
proc url_BigquerydatatransferProjectsLocationsList_578943(protocol: Scheme;
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

proc validate_BigquerydatatransferProjectsLocationsList_578942(path: JsonNode;
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
  var valid_578944 = path.getOrDefault("name")
  valid_578944 = validateParameter(valid_578944, JString, required = true,
                                 default = nil)
  if valid_578944 != nil:
    section.add "name", valid_578944
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
  var valid_578945 = query.getOrDefault("key")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "key", valid_578945
  var valid_578946 = query.getOrDefault("prettyPrint")
  valid_578946 = validateParameter(valid_578946, JBool, required = false,
                                 default = newJBool(true))
  if valid_578946 != nil:
    section.add "prettyPrint", valid_578946
  var valid_578947 = query.getOrDefault("oauth_token")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "oauth_token", valid_578947
  var valid_578948 = query.getOrDefault("$.xgafv")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = newJString("1"))
  if valid_578948 != nil:
    section.add "$.xgafv", valid_578948
  var valid_578949 = query.getOrDefault("pageSize")
  valid_578949 = validateParameter(valid_578949, JInt, required = false, default = nil)
  if valid_578949 != nil:
    section.add "pageSize", valid_578949
  var valid_578950 = query.getOrDefault("alt")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = newJString("json"))
  if valid_578950 != nil:
    section.add "alt", valid_578950
  var valid_578951 = query.getOrDefault("uploadType")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "uploadType", valid_578951
  var valid_578952 = query.getOrDefault("quotaUser")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "quotaUser", valid_578952
  var valid_578953 = query.getOrDefault("filter")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "filter", valid_578953
  var valid_578954 = query.getOrDefault("pageToken")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "pageToken", valid_578954
  var valid_578955 = query.getOrDefault("callback")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "callback", valid_578955
  var valid_578956 = query.getOrDefault("fields")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "fields", valid_578956
  var valid_578957 = query.getOrDefault("access_token")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "access_token", valid_578957
  var valid_578958 = query.getOrDefault("upload_protocol")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "upload_protocol", valid_578958
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578959: Call_BigquerydatatransferProjectsLocationsList_578941;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_578959.validator(path, query, header, formData, body)
  let scheme = call_578959.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578959.url(scheme.get, call_578959.host, call_578959.base,
                         call_578959.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578959, url, valid)

proc call*(call_578960: Call_BigquerydatatransferProjectsLocationsList_578941;
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
  var path_578961 = newJObject()
  var query_578962 = newJObject()
  add(query_578962, "key", newJString(key))
  add(query_578962, "prettyPrint", newJBool(prettyPrint))
  add(query_578962, "oauth_token", newJString(oauthToken))
  add(query_578962, "$.xgafv", newJString(Xgafv))
  add(query_578962, "pageSize", newJInt(pageSize))
  add(query_578962, "alt", newJString(alt))
  add(query_578962, "uploadType", newJString(uploadType))
  add(query_578962, "quotaUser", newJString(quotaUser))
  add(path_578961, "name", newJString(name))
  add(query_578962, "filter", newJString(filter))
  add(query_578962, "pageToken", newJString(pageToken))
  add(query_578962, "callback", newJString(callback))
  add(query_578962, "fields", newJString(fields))
  add(query_578962, "access_token", newJString(accessToken))
  add(query_578962, "upload_protocol", newJString(uploadProtocol))
  result = call_578960.call(path_578961, query_578962, nil, nil, nil)

var bigquerydatatransferProjectsLocationsList* = Call_BigquerydatatransferProjectsLocationsList_578941(
    name: "bigquerydatatransferProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "bigquerydatatransfer.googleapis.com", route: "/v1/{name}/locations",
    validator: validate_BigquerydatatransferProjectsLocationsList_578942,
    base: "/", url: url_BigquerydatatransferProjectsLocationsList_578943,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsDataSourcesCheckValidCreds_578963 = ref object of OpenApiRestCall_578339
proc url_BigquerydatatransferProjectsDataSourcesCheckValidCreds_578965(
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

proc validate_BigquerydatatransferProjectsDataSourcesCheckValidCreds_578964(
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
  var valid_578966 = path.getOrDefault("name")
  valid_578966 = validateParameter(valid_578966, JString, required = true,
                                 default = nil)
  if valid_578966 != nil:
    section.add "name", valid_578966
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
  var valid_578967 = query.getOrDefault("key")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "key", valid_578967
  var valid_578968 = query.getOrDefault("prettyPrint")
  valid_578968 = validateParameter(valid_578968, JBool, required = false,
                                 default = newJBool(true))
  if valid_578968 != nil:
    section.add "prettyPrint", valid_578968
  var valid_578969 = query.getOrDefault("oauth_token")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "oauth_token", valid_578969
  var valid_578970 = query.getOrDefault("$.xgafv")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = newJString("1"))
  if valid_578970 != nil:
    section.add "$.xgafv", valid_578970
  var valid_578971 = query.getOrDefault("alt")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = newJString("json"))
  if valid_578971 != nil:
    section.add "alt", valid_578971
  var valid_578972 = query.getOrDefault("uploadType")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "uploadType", valid_578972
  var valid_578973 = query.getOrDefault("quotaUser")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "quotaUser", valid_578973
  var valid_578974 = query.getOrDefault("callback")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "callback", valid_578974
  var valid_578975 = query.getOrDefault("fields")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "fields", valid_578975
  var valid_578976 = query.getOrDefault("access_token")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "access_token", valid_578976
  var valid_578977 = query.getOrDefault("upload_protocol")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "upload_protocol", valid_578977
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

proc call*(call_578979: Call_BigquerydatatransferProjectsDataSourcesCheckValidCreds_578963;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns true if valid credentials exist for the given data source and
  ## requesting user.
  ## Some data sources doesn't support service account, so we need to talk to
  ## them on behalf of the end user. This API just checks whether we have OAuth
  ## token for the particular user, which is a pre-requisite before user can
  ## create a transfer config.
  ## 
  let valid = call_578979.validator(path, query, header, formData, body)
  let scheme = call_578979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578979.url(scheme.get, call_578979.host, call_578979.base,
                         call_578979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578979, url, valid)

proc call*(call_578980: Call_BigquerydatatransferProjectsDataSourcesCheckValidCreds_578963;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## bigquerydatatransferProjectsDataSourcesCheckValidCreds
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
  var path_578981 = newJObject()
  var query_578982 = newJObject()
  var body_578983 = newJObject()
  add(query_578982, "key", newJString(key))
  add(query_578982, "prettyPrint", newJBool(prettyPrint))
  add(query_578982, "oauth_token", newJString(oauthToken))
  add(query_578982, "$.xgafv", newJString(Xgafv))
  add(query_578982, "alt", newJString(alt))
  add(query_578982, "uploadType", newJString(uploadType))
  add(query_578982, "quotaUser", newJString(quotaUser))
  add(path_578981, "name", newJString(name))
  if body != nil:
    body_578983 = body
  add(query_578982, "callback", newJString(callback))
  add(query_578982, "fields", newJString(fields))
  add(query_578982, "access_token", newJString(accessToken))
  add(query_578982, "upload_protocol", newJString(uploadProtocol))
  result = call_578980.call(path_578981, query_578982, nil, nil, body_578983)

var bigquerydatatransferProjectsDataSourcesCheckValidCreds* = Call_BigquerydatatransferProjectsDataSourcesCheckValidCreds_578963(
    name: "bigquerydatatransferProjectsDataSourcesCheckValidCreds",
    meth: HttpMethod.HttpPost, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{name}:checkValidCreds",
    validator: validate_BigquerydatatransferProjectsDataSourcesCheckValidCreds_578964,
    base: "/", url: url_BigquerydatatransferProjectsDataSourcesCheckValidCreds_578965,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsDataSourcesList_578984 = ref object of OpenApiRestCall_578339
proc url_BigquerydatatransferProjectsDataSourcesList_578986(protocol: Scheme;
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

proc validate_BigquerydatatransferProjectsDataSourcesList_578985(path: JsonNode;
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
  var valid_578987 = path.getOrDefault("parent")
  valid_578987 = validateParameter(valid_578987, JString, required = true,
                                 default = nil)
  if valid_578987 != nil:
    section.add "parent", valid_578987
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
  var valid_578988 = query.getOrDefault("key")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "key", valid_578988
  var valid_578989 = query.getOrDefault("prettyPrint")
  valid_578989 = validateParameter(valid_578989, JBool, required = false,
                                 default = newJBool(true))
  if valid_578989 != nil:
    section.add "prettyPrint", valid_578989
  var valid_578990 = query.getOrDefault("oauth_token")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "oauth_token", valid_578990
  var valid_578991 = query.getOrDefault("$.xgafv")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = newJString("1"))
  if valid_578991 != nil:
    section.add "$.xgafv", valid_578991
  var valid_578992 = query.getOrDefault("pageSize")
  valid_578992 = validateParameter(valid_578992, JInt, required = false, default = nil)
  if valid_578992 != nil:
    section.add "pageSize", valid_578992
  var valid_578993 = query.getOrDefault("alt")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = newJString("json"))
  if valid_578993 != nil:
    section.add "alt", valid_578993
  var valid_578994 = query.getOrDefault("uploadType")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "uploadType", valid_578994
  var valid_578995 = query.getOrDefault("quotaUser")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "quotaUser", valid_578995
  var valid_578996 = query.getOrDefault("pageToken")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "pageToken", valid_578996
  var valid_578997 = query.getOrDefault("callback")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "callback", valid_578997
  var valid_578998 = query.getOrDefault("fields")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "fields", valid_578998
  var valid_578999 = query.getOrDefault("access_token")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "access_token", valid_578999
  var valid_579000 = query.getOrDefault("upload_protocol")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "upload_protocol", valid_579000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579001: Call_BigquerydatatransferProjectsDataSourcesList_578984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists supported data sources and returns their settings,
  ## which can be used for UI rendering.
  ## 
  let valid = call_579001.validator(path, query, header, formData, body)
  let scheme = call_579001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579001.url(scheme.get, call_579001.host, call_579001.base,
                         call_579001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579001, url, valid)

proc call*(call_579002: Call_BigquerydatatransferProjectsDataSourcesList_578984;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigquerydatatransferProjectsDataSourcesList
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
  var path_579003 = newJObject()
  var query_579004 = newJObject()
  add(query_579004, "key", newJString(key))
  add(query_579004, "prettyPrint", newJBool(prettyPrint))
  add(query_579004, "oauth_token", newJString(oauthToken))
  add(query_579004, "$.xgafv", newJString(Xgafv))
  add(query_579004, "pageSize", newJInt(pageSize))
  add(query_579004, "alt", newJString(alt))
  add(query_579004, "uploadType", newJString(uploadType))
  add(query_579004, "quotaUser", newJString(quotaUser))
  add(query_579004, "pageToken", newJString(pageToken))
  add(query_579004, "callback", newJString(callback))
  add(path_579003, "parent", newJString(parent))
  add(query_579004, "fields", newJString(fields))
  add(query_579004, "access_token", newJString(accessToken))
  add(query_579004, "upload_protocol", newJString(uploadProtocol))
  result = call_579002.call(path_579003, query_579004, nil, nil, nil)

var bigquerydatatransferProjectsDataSourcesList* = Call_BigquerydatatransferProjectsDataSourcesList_578984(
    name: "bigquerydatatransferProjectsDataSourcesList", meth: HttpMethod.HttpGet,
    host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}/dataSources",
    validator: validate_BigquerydatatransferProjectsDataSourcesList_578985,
    base: "/", url: url_BigquerydatatransferProjectsDataSourcesList_578986,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsRunsList_579005 = ref object of OpenApiRestCall_578339
proc url_BigquerydatatransferProjectsTransferConfigsRunsList_579007(
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

proc validate_BigquerydatatransferProjectsTransferConfigsRunsList_579006(
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
  var valid_579008 = path.getOrDefault("parent")
  valid_579008 = validateParameter(valid_579008, JString, required = true,
                                 default = nil)
  if valid_579008 != nil:
    section.add "parent", valid_579008
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
  var valid_579009 = query.getOrDefault("key")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "key", valid_579009
  var valid_579010 = query.getOrDefault("prettyPrint")
  valid_579010 = validateParameter(valid_579010, JBool, required = false,
                                 default = newJBool(true))
  if valid_579010 != nil:
    section.add "prettyPrint", valid_579010
  var valid_579011 = query.getOrDefault("oauth_token")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "oauth_token", valid_579011
  var valid_579012 = query.getOrDefault("$.xgafv")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = newJString("1"))
  if valid_579012 != nil:
    section.add "$.xgafv", valid_579012
  var valid_579013 = query.getOrDefault("runAttempt")
  valid_579013 = validateParameter(valid_579013, JString, required = false, default = newJString(
      "RUN_ATTEMPT_UNSPECIFIED"))
  if valid_579013 != nil:
    section.add "runAttempt", valid_579013
  var valid_579014 = query.getOrDefault("pageSize")
  valid_579014 = validateParameter(valid_579014, JInt, required = false, default = nil)
  if valid_579014 != nil:
    section.add "pageSize", valid_579014
  var valid_579015 = query.getOrDefault("alt")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = newJString("json"))
  if valid_579015 != nil:
    section.add "alt", valid_579015
  var valid_579016 = query.getOrDefault("uploadType")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "uploadType", valid_579016
  var valid_579017 = query.getOrDefault("quotaUser")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "quotaUser", valid_579017
  var valid_579018 = query.getOrDefault("pageToken")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "pageToken", valid_579018
  var valid_579019 = query.getOrDefault("callback")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "callback", valid_579019
  var valid_579020 = query.getOrDefault("fields")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "fields", valid_579020
  var valid_579021 = query.getOrDefault("access_token")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "access_token", valid_579021
  var valid_579022 = query.getOrDefault("upload_protocol")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "upload_protocol", valid_579022
  var valid_579023 = query.getOrDefault("states")
  valid_579023 = validateParameter(valid_579023, JArray, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "states", valid_579023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579024: Call_BigquerydatatransferProjectsTransferConfigsRunsList_579005;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about running and completed jobs.
  ## 
  let valid = call_579024.validator(path, query, header, formData, body)
  let scheme = call_579024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579024.url(scheme.get, call_579024.host, call_579024.base,
                         call_579024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579024, url, valid)

proc call*(call_579025: Call_BigquerydatatransferProjectsTransferConfigsRunsList_579005;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1";
          runAttempt: string = "RUN_ATTEMPT_UNSPECIFIED"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""; states: JsonNode = nil): Recallable =
  ## bigquerydatatransferProjectsTransferConfigsRunsList
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
  var path_579026 = newJObject()
  var query_579027 = newJObject()
  add(query_579027, "key", newJString(key))
  add(query_579027, "prettyPrint", newJBool(prettyPrint))
  add(query_579027, "oauth_token", newJString(oauthToken))
  add(query_579027, "$.xgafv", newJString(Xgafv))
  add(query_579027, "runAttempt", newJString(runAttempt))
  add(query_579027, "pageSize", newJInt(pageSize))
  add(query_579027, "alt", newJString(alt))
  add(query_579027, "uploadType", newJString(uploadType))
  add(query_579027, "quotaUser", newJString(quotaUser))
  add(query_579027, "pageToken", newJString(pageToken))
  add(query_579027, "callback", newJString(callback))
  add(path_579026, "parent", newJString(parent))
  add(query_579027, "fields", newJString(fields))
  add(query_579027, "access_token", newJString(accessToken))
  add(query_579027, "upload_protocol", newJString(uploadProtocol))
  if states != nil:
    query_579027.add "states", states
  result = call_579025.call(path_579026, query_579027, nil, nil, nil)

var bigquerydatatransferProjectsTransferConfigsRunsList* = Call_BigquerydatatransferProjectsTransferConfigsRunsList_579005(
    name: "bigquerydatatransferProjectsTransferConfigsRunsList",
    meth: HttpMethod.HttpGet, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}/runs",
    validator: validate_BigquerydatatransferProjectsTransferConfigsRunsList_579006,
    base: "/", url: url_BigquerydatatransferProjectsTransferConfigsRunsList_579007,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsCreate_579050 = ref object of OpenApiRestCall_578339
proc url_BigquerydatatransferProjectsTransferConfigsCreate_579052(
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

proc validate_BigquerydatatransferProjectsTransferConfigsCreate_579051(
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
  var valid_579053 = path.getOrDefault("parent")
  valid_579053 = validateParameter(valid_579053, JString, required = true,
                                 default = nil)
  if valid_579053 != nil:
    section.add "parent", valid_579053
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
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579054 = query.getOrDefault("key")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "key", valid_579054
  var valid_579055 = query.getOrDefault("prettyPrint")
  valid_579055 = validateParameter(valid_579055, JBool, required = false,
                                 default = newJBool(true))
  if valid_579055 != nil:
    section.add "prettyPrint", valid_579055
  var valid_579056 = query.getOrDefault("oauth_token")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "oauth_token", valid_579056
  var valid_579057 = query.getOrDefault("authorizationCode")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "authorizationCode", valid_579057
  var valid_579058 = query.getOrDefault("$.xgafv")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = newJString("1"))
  if valid_579058 != nil:
    section.add "$.xgafv", valid_579058
  var valid_579059 = query.getOrDefault("versionInfo")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "versionInfo", valid_579059
  var valid_579060 = query.getOrDefault("alt")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = newJString("json"))
  if valid_579060 != nil:
    section.add "alt", valid_579060
  var valid_579061 = query.getOrDefault("uploadType")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "uploadType", valid_579061
  var valid_579062 = query.getOrDefault("quotaUser")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "quotaUser", valid_579062
  var valid_579063 = query.getOrDefault("callback")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "callback", valid_579063
  var valid_579064 = query.getOrDefault("fields")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "fields", valid_579064
  var valid_579065 = query.getOrDefault("access_token")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "access_token", valid_579065
  var valid_579066 = query.getOrDefault("upload_protocol")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "upload_protocol", valid_579066
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

proc call*(call_579068: Call_BigquerydatatransferProjectsTransferConfigsCreate_579050;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new data transfer configuration.
  ## 
  let valid = call_579068.validator(path, query, header, formData, body)
  let scheme = call_579068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579068.url(scheme.get, call_579068.host, call_579068.base,
                         call_579068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579068, url, valid)

proc call*(call_579069: Call_BigquerydatatransferProjectsTransferConfigsCreate_579050;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; authorizationCode: string = ""; Xgafv: string = "1";
          versionInfo: string = ""; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigquerydatatransferProjectsTransferConfigsCreate
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
  var path_579070 = newJObject()
  var query_579071 = newJObject()
  var body_579072 = newJObject()
  add(query_579071, "key", newJString(key))
  add(query_579071, "prettyPrint", newJBool(prettyPrint))
  add(query_579071, "oauth_token", newJString(oauthToken))
  add(query_579071, "authorizationCode", newJString(authorizationCode))
  add(query_579071, "$.xgafv", newJString(Xgafv))
  add(query_579071, "versionInfo", newJString(versionInfo))
  add(query_579071, "alt", newJString(alt))
  add(query_579071, "uploadType", newJString(uploadType))
  add(query_579071, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579072 = body
  add(query_579071, "callback", newJString(callback))
  add(path_579070, "parent", newJString(parent))
  add(query_579071, "fields", newJString(fields))
  add(query_579071, "access_token", newJString(accessToken))
  add(query_579071, "upload_protocol", newJString(uploadProtocol))
  result = call_579069.call(path_579070, query_579071, nil, nil, body_579072)

var bigquerydatatransferProjectsTransferConfigsCreate* = Call_BigquerydatatransferProjectsTransferConfigsCreate_579050(
    name: "bigquerydatatransferProjectsTransferConfigsCreate",
    meth: HttpMethod.HttpPost, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}/transferConfigs",
    validator: validate_BigquerydatatransferProjectsTransferConfigsCreate_579051,
    base: "/", url: url_BigquerydatatransferProjectsTransferConfigsCreate_579052,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsList_579028 = ref object of OpenApiRestCall_578339
proc url_BigquerydatatransferProjectsTransferConfigsList_579030(protocol: Scheme;
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

proc validate_BigquerydatatransferProjectsTransferConfigsList_579029(
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
  var valid_579031 = path.getOrDefault("parent")
  valid_579031 = validateParameter(valid_579031, JString, required = true,
                                 default = nil)
  if valid_579031 != nil:
    section.add "parent", valid_579031
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
  var valid_579032 = query.getOrDefault("key")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "key", valid_579032
  var valid_579033 = query.getOrDefault("prettyPrint")
  valid_579033 = validateParameter(valid_579033, JBool, required = false,
                                 default = newJBool(true))
  if valid_579033 != nil:
    section.add "prettyPrint", valid_579033
  var valid_579034 = query.getOrDefault("oauth_token")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "oauth_token", valid_579034
  var valid_579035 = query.getOrDefault("dataSourceIds")
  valid_579035 = validateParameter(valid_579035, JArray, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "dataSourceIds", valid_579035
  var valid_579036 = query.getOrDefault("$.xgafv")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = newJString("1"))
  if valid_579036 != nil:
    section.add "$.xgafv", valid_579036
  var valid_579037 = query.getOrDefault("pageSize")
  valid_579037 = validateParameter(valid_579037, JInt, required = false, default = nil)
  if valid_579037 != nil:
    section.add "pageSize", valid_579037
  var valid_579038 = query.getOrDefault("alt")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = newJString("json"))
  if valid_579038 != nil:
    section.add "alt", valid_579038
  var valid_579039 = query.getOrDefault("uploadType")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "uploadType", valid_579039
  var valid_579040 = query.getOrDefault("quotaUser")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "quotaUser", valid_579040
  var valid_579041 = query.getOrDefault("pageToken")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "pageToken", valid_579041
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
  if body != nil:
    result.add "body", body

proc call*(call_579046: Call_BigquerydatatransferProjectsTransferConfigsList_579028;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about all data transfers in the project.
  ## 
  let valid = call_579046.validator(path, query, header, formData, body)
  let scheme = call_579046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579046.url(scheme.get, call_579046.host, call_579046.base,
                         call_579046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579046, url, valid)

proc call*(call_579047: Call_BigquerydatatransferProjectsTransferConfigsList_579028;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; dataSourceIds: JsonNode = nil; Xgafv: string = "1";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigquerydatatransferProjectsTransferConfigsList
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
  var path_579048 = newJObject()
  var query_579049 = newJObject()
  add(query_579049, "key", newJString(key))
  add(query_579049, "prettyPrint", newJBool(prettyPrint))
  add(query_579049, "oauth_token", newJString(oauthToken))
  if dataSourceIds != nil:
    query_579049.add "dataSourceIds", dataSourceIds
  add(query_579049, "$.xgafv", newJString(Xgafv))
  add(query_579049, "pageSize", newJInt(pageSize))
  add(query_579049, "alt", newJString(alt))
  add(query_579049, "uploadType", newJString(uploadType))
  add(query_579049, "quotaUser", newJString(quotaUser))
  add(query_579049, "pageToken", newJString(pageToken))
  add(query_579049, "callback", newJString(callback))
  add(path_579048, "parent", newJString(parent))
  add(query_579049, "fields", newJString(fields))
  add(query_579049, "access_token", newJString(accessToken))
  add(query_579049, "upload_protocol", newJString(uploadProtocol))
  result = call_579047.call(path_579048, query_579049, nil, nil, nil)

var bigquerydatatransferProjectsTransferConfigsList* = Call_BigquerydatatransferProjectsTransferConfigsList_579028(
    name: "bigquerydatatransferProjectsTransferConfigsList",
    meth: HttpMethod.HttpGet, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}/transferConfigs",
    validator: validate_BigquerydatatransferProjectsTransferConfigsList_579029,
    base: "/", url: url_BigquerydatatransferProjectsTransferConfigsList_579030,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_579073 = ref object of OpenApiRestCall_578339
proc url_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_579075(
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

proc validate_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_579074(
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
  var valid_579076 = path.getOrDefault("parent")
  valid_579076 = validateParameter(valid_579076, JString, required = true,
                                 default = nil)
  if valid_579076 != nil:
    section.add "parent", valid_579076
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
  var valid_579077 = query.getOrDefault("key")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "key", valid_579077
  var valid_579078 = query.getOrDefault("prettyPrint")
  valid_579078 = validateParameter(valid_579078, JBool, required = false,
                                 default = newJBool(true))
  if valid_579078 != nil:
    section.add "prettyPrint", valid_579078
  var valid_579079 = query.getOrDefault("oauth_token")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "oauth_token", valid_579079
  var valid_579080 = query.getOrDefault("$.xgafv")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = newJString("1"))
  if valid_579080 != nil:
    section.add "$.xgafv", valid_579080
  var valid_579081 = query.getOrDefault("pageSize")
  valid_579081 = validateParameter(valid_579081, JInt, required = false, default = nil)
  if valid_579081 != nil:
    section.add "pageSize", valid_579081
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
  var valid_579085 = query.getOrDefault("pageToken")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "pageToken", valid_579085
  var valid_579086 = query.getOrDefault("messageTypes")
  valid_579086 = validateParameter(valid_579086, JArray, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "messageTypes", valid_579086
  var valid_579087 = query.getOrDefault("callback")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "callback", valid_579087
  var valid_579088 = query.getOrDefault("fields")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "fields", valid_579088
  var valid_579089 = query.getOrDefault("access_token")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "access_token", valid_579089
  var valid_579090 = query.getOrDefault("upload_protocol")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "upload_protocol", valid_579090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579091: Call_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_579073;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns user facing log messages for the data transfer run.
  ## 
  let valid = call_579091.validator(path, query, header, formData, body)
  let scheme = call_579091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579091.url(scheme.get, call_579091.host, call_579091.base,
                         call_579091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579091, url, valid)

proc call*(call_579092: Call_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_579073;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; messageTypes: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigquerydatatransferProjectsTransferConfigsRunsTransferLogsList
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
  var path_579093 = newJObject()
  var query_579094 = newJObject()
  add(query_579094, "key", newJString(key))
  add(query_579094, "prettyPrint", newJBool(prettyPrint))
  add(query_579094, "oauth_token", newJString(oauthToken))
  add(query_579094, "$.xgafv", newJString(Xgafv))
  add(query_579094, "pageSize", newJInt(pageSize))
  add(query_579094, "alt", newJString(alt))
  add(query_579094, "uploadType", newJString(uploadType))
  add(query_579094, "quotaUser", newJString(quotaUser))
  add(query_579094, "pageToken", newJString(pageToken))
  if messageTypes != nil:
    query_579094.add "messageTypes", messageTypes
  add(query_579094, "callback", newJString(callback))
  add(path_579093, "parent", newJString(parent))
  add(query_579094, "fields", newJString(fields))
  add(query_579094, "access_token", newJString(accessToken))
  add(query_579094, "upload_protocol", newJString(uploadProtocol))
  result = call_579092.call(path_579093, query_579094, nil, nil, nil)

var bigquerydatatransferProjectsTransferConfigsRunsTransferLogsList* = Call_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_579073(
    name: "bigquerydatatransferProjectsTransferConfigsRunsTransferLogsList",
    meth: HttpMethod.HttpGet, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}/transferLogs", validator: validate_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_579074,
    base: "/",
    url: url_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_579075,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsScheduleRuns_579095 = ref object of OpenApiRestCall_578339
proc url_BigquerydatatransferProjectsTransferConfigsScheduleRuns_579097(
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

proc validate_BigquerydatatransferProjectsTransferConfigsScheduleRuns_579096(
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

proc call*(call_579111: Call_BigquerydatatransferProjectsTransferConfigsScheduleRuns_579095;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates transfer runs for a time range [start_time, end_time].
  ## For each date - or whatever granularity the data source supports - in the
  ## range, one transfer run is created.
  ## Note that runs are created per UTC time in the time range.
  ## DEPRECATED: use StartManualTransferRuns instead.
  ## 
  let valid = call_579111.validator(path, query, header, formData, body)
  let scheme = call_579111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579111.url(scheme.get, call_579111.host, call_579111.base,
                         call_579111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579111, url, valid)

proc call*(call_579112: Call_BigquerydatatransferProjectsTransferConfigsScheduleRuns_579095;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## bigquerydatatransferProjectsTransferConfigsScheduleRuns
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

var bigquerydatatransferProjectsTransferConfigsScheduleRuns* = Call_BigquerydatatransferProjectsTransferConfigsScheduleRuns_579095(
    name: "bigquerydatatransferProjectsTransferConfigsScheduleRuns",
    meth: HttpMethod.HttpPost, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}:scheduleRuns", validator: validate_BigquerydatatransferProjectsTransferConfigsScheduleRuns_579096,
    base: "/", url: url_BigquerydatatransferProjectsTransferConfigsScheduleRuns_579097,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsStartManualRuns_579116 = ref object of OpenApiRestCall_578339
proc url_BigquerydatatransferProjectsTransferConfigsStartManualRuns_579118(
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

proc validate_BigquerydatatransferProjectsTransferConfigsStartManualRuns_579117(
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
  var valid_579124 = query.getOrDefault("alt")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = newJString("json"))
  if valid_579124 != nil:
    section.add "alt", valid_579124
  var valid_579125 = query.getOrDefault("uploadType")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "uploadType", valid_579125
  var valid_579126 = query.getOrDefault("quotaUser")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "quotaUser", valid_579126
  var valid_579127 = query.getOrDefault("callback")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "callback", valid_579127
  var valid_579128 = query.getOrDefault("fields")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "fields", valid_579128
  var valid_579129 = query.getOrDefault("access_token")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "access_token", valid_579129
  var valid_579130 = query.getOrDefault("upload_protocol")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "upload_protocol", valid_579130
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

proc call*(call_579132: Call_BigquerydatatransferProjectsTransferConfigsStartManualRuns_579116;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Start manual transfer runs to be executed now with schedule_time equal to
  ## current time. The transfer runs can be created for a time range where the
  ## run_time is between start_time (inclusive) and end_time (exclusive), or for
  ## a specific run_time.
  ## 
  let valid = call_579132.validator(path, query, header, formData, body)
  let scheme = call_579132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579132.url(scheme.get, call_579132.host, call_579132.base,
                         call_579132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579132, url, valid)

proc call*(call_579133: Call_BigquerydatatransferProjectsTransferConfigsStartManualRuns_579116;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## bigquerydatatransferProjectsTransferConfigsStartManualRuns
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
  var path_579134 = newJObject()
  var query_579135 = newJObject()
  var body_579136 = newJObject()
  add(query_579135, "key", newJString(key))
  add(query_579135, "prettyPrint", newJBool(prettyPrint))
  add(query_579135, "oauth_token", newJString(oauthToken))
  add(query_579135, "$.xgafv", newJString(Xgafv))
  add(query_579135, "alt", newJString(alt))
  add(query_579135, "uploadType", newJString(uploadType))
  add(query_579135, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579136 = body
  add(query_579135, "callback", newJString(callback))
  add(path_579134, "parent", newJString(parent))
  add(query_579135, "fields", newJString(fields))
  add(query_579135, "access_token", newJString(accessToken))
  add(query_579135, "upload_protocol", newJString(uploadProtocol))
  result = call_579133.call(path_579134, query_579135, nil, nil, body_579136)

var bigquerydatatransferProjectsTransferConfigsStartManualRuns* = Call_BigquerydatatransferProjectsTransferConfigsStartManualRuns_579116(
    name: "bigquerydatatransferProjectsTransferConfigsStartManualRuns",
    meth: HttpMethod.HttpPost, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}:startManualRuns", validator: validate_BigquerydatatransferProjectsTransferConfigsStartManualRuns_579117,
    base: "/",
    url: url_BigquerydatatransferProjectsTransferConfigsStartManualRuns_579118,
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
