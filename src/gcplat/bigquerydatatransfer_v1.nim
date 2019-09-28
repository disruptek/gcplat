
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
  gcpServiceName = "bigquerydatatransfer"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BigquerydatatransferProjectsTransferConfigsRunsGet_579677 = ref object of OpenApiRestCall_579408
proc url_BigquerydatatransferProjectsTransferConfigsRunsGet_579679(
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

proc validate_BigquerydatatransferProjectsTransferConfigsRunsGet_579678(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns information about the particular transfer run.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The field will contain name of the resource requested, for example:
  ## `projects/{project_id}/transferConfigs/{config_id}/runs/{run_id}`
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

proc call*(call_579852: Call_BigquerydatatransferProjectsTransferConfigsRunsGet_579677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about the particular transfer run.
  ## 
  let valid = call_579852.validator(path, query, header, formData, body)
  let scheme = call_579852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579852.url(scheme.get, call_579852.host, call_579852.base,
                         call_579852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579852, url, valid)

proc call*(call_579923: Call_BigquerydatatransferProjectsTransferConfigsRunsGet_579677;
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
  ##       : The field will contain name of the resource requested, for example:
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

var bigquerydatatransferProjectsTransferConfigsRunsGet* = Call_BigquerydatatransferProjectsTransferConfigsRunsGet_579677(
    name: "bigquerydatatransferProjectsTransferConfigsRunsGet",
    meth: HttpMethod.HttpGet, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{name}",
    validator: validate_BigquerydatatransferProjectsTransferConfigsRunsGet_579678,
    base: "/", url: url_BigquerydatatransferProjectsTransferConfigsRunsGet_579679,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsPatch_579984 = ref object of OpenApiRestCall_579408
proc url_BigquerydatatransferProjectsTransferConfigsPatch_579986(
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

proc validate_BigquerydatatransferProjectsTransferConfigsPatch_579985(
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
  var valid_579987 = path.getOrDefault("name")
  valid_579987 = validateParameter(valid_579987, JString, required = true,
                                 default = nil)
  if valid_579987 != nil:
    section.add "name", valid_579987
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
  ##             : Required list of fields to be updated in this request.
  section = newJObject()
  var valid_579988 = query.getOrDefault("upload_protocol")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "upload_protocol", valid_579988
  var valid_579989 = query.getOrDefault("authorizationCode")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "authorizationCode", valid_579989
  var valid_579990 = query.getOrDefault("fields")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "fields", valid_579990
  var valid_579991 = query.getOrDefault("quotaUser")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "quotaUser", valid_579991
  var valid_579992 = query.getOrDefault("alt")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = newJString("json"))
  if valid_579992 != nil:
    section.add "alt", valid_579992
  var valid_579993 = query.getOrDefault("oauth_token")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "oauth_token", valid_579993
  var valid_579994 = query.getOrDefault("callback")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "callback", valid_579994
  var valid_579995 = query.getOrDefault("access_token")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "access_token", valid_579995
  var valid_579996 = query.getOrDefault("uploadType")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "uploadType", valid_579996
  var valid_579997 = query.getOrDefault("versionInfo")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "versionInfo", valid_579997
  var valid_579998 = query.getOrDefault("key")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "key", valid_579998
  var valid_579999 = query.getOrDefault("$.xgafv")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = newJString("1"))
  if valid_579999 != nil:
    section.add "$.xgafv", valid_579999
  var valid_580000 = query.getOrDefault("prettyPrint")
  valid_580000 = validateParameter(valid_580000, JBool, required = false,
                                 default = newJBool(true))
  if valid_580000 != nil:
    section.add "prettyPrint", valid_580000
  var valid_580001 = query.getOrDefault("updateMask")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "updateMask", valid_580001
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

proc call*(call_580003: Call_BigquerydatatransferProjectsTransferConfigsPatch_579984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a data transfer configuration.
  ## All fields must be set, even if they are not updated.
  ## 
  let valid = call_580003.validator(path, query, header, formData, body)
  let scheme = call_580003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580003.url(scheme.get, call_580003.host, call_580003.base,
                         call_580003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580003, url, valid)

proc call*(call_580004: Call_BigquerydatatransferProjectsTransferConfigsPatch_579984;
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
  ##             : Required list of fields to be updated in this request.
  var path_580005 = newJObject()
  var query_580006 = newJObject()
  var body_580007 = newJObject()
  add(query_580006, "upload_protocol", newJString(uploadProtocol))
  add(query_580006, "authorizationCode", newJString(authorizationCode))
  add(query_580006, "fields", newJString(fields))
  add(query_580006, "quotaUser", newJString(quotaUser))
  add(path_580005, "name", newJString(name))
  add(query_580006, "alt", newJString(alt))
  add(query_580006, "oauth_token", newJString(oauthToken))
  add(query_580006, "callback", newJString(callback))
  add(query_580006, "access_token", newJString(accessToken))
  add(query_580006, "uploadType", newJString(uploadType))
  add(query_580006, "versionInfo", newJString(versionInfo))
  add(query_580006, "key", newJString(key))
  add(query_580006, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580007 = body
  add(query_580006, "prettyPrint", newJBool(prettyPrint))
  add(query_580006, "updateMask", newJString(updateMask))
  result = call_580004.call(path_580005, query_580006, nil, nil, body_580007)

var bigquerydatatransferProjectsTransferConfigsPatch* = Call_BigquerydatatransferProjectsTransferConfigsPatch_579984(
    name: "bigquerydatatransferProjectsTransferConfigsPatch",
    meth: HttpMethod.HttpPatch, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{name}",
    validator: validate_BigquerydatatransferProjectsTransferConfigsPatch_579985,
    base: "/", url: url_BigquerydatatransferProjectsTransferConfigsPatch_579986,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsRunsDelete_579965 = ref object of OpenApiRestCall_579408
proc url_BigquerydatatransferProjectsTransferConfigsRunsDelete_579967(
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

proc validate_BigquerydatatransferProjectsTransferConfigsRunsDelete_579966(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes the specified transfer run.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The field will contain name of the resource requested, for example:
  ## `projects/{project_id}/transferConfigs/{config_id}/runs/{run_id}`
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

proc call*(call_579980: Call_BigquerydatatransferProjectsTransferConfigsRunsDelete_579965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified transfer run.
  ## 
  let valid = call_579980.validator(path, query, header, formData, body)
  let scheme = call_579980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579980.url(scheme.get, call_579980.host, call_579980.base,
                         call_579980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579980, url, valid)

proc call*(call_579981: Call_BigquerydatatransferProjectsTransferConfigsRunsDelete_579965;
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
  ##       : The field will contain name of the resource requested, for example:
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

var bigquerydatatransferProjectsTransferConfigsRunsDelete* = Call_BigquerydatatransferProjectsTransferConfigsRunsDelete_579965(
    name: "bigquerydatatransferProjectsTransferConfigsRunsDelete",
    meth: HttpMethod.HttpDelete, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{name}",
    validator: validate_BigquerydatatransferProjectsTransferConfigsRunsDelete_579966,
    base: "/", url: url_BigquerydatatransferProjectsTransferConfigsRunsDelete_579967,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsLocationsList_580008 = ref object of OpenApiRestCall_579408
proc url_BigquerydatatransferProjectsLocationsList_580010(protocol: Scheme;
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

proc validate_BigquerydatatransferProjectsLocationsList_580009(path: JsonNode;
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
  var valid_580011 = path.getOrDefault("name")
  valid_580011 = validateParameter(valid_580011, JString, required = true,
                                 default = nil)
  if valid_580011 != nil:
    section.add "name", valid_580011
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
  var valid_580012 = query.getOrDefault("upload_protocol")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "upload_protocol", valid_580012
  var valid_580013 = query.getOrDefault("fields")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "fields", valid_580013
  var valid_580014 = query.getOrDefault("pageToken")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "pageToken", valid_580014
  var valid_580015 = query.getOrDefault("quotaUser")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "quotaUser", valid_580015
  var valid_580016 = query.getOrDefault("alt")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = newJString("json"))
  if valid_580016 != nil:
    section.add "alt", valid_580016
  var valid_580017 = query.getOrDefault("oauth_token")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "oauth_token", valid_580017
  var valid_580018 = query.getOrDefault("callback")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "callback", valid_580018
  var valid_580019 = query.getOrDefault("access_token")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "access_token", valid_580019
  var valid_580020 = query.getOrDefault("uploadType")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "uploadType", valid_580020
  var valid_580021 = query.getOrDefault("key")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "key", valid_580021
  var valid_580022 = query.getOrDefault("$.xgafv")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = newJString("1"))
  if valid_580022 != nil:
    section.add "$.xgafv", valid_580022
  var valid_580023 = query.getOrDefault("pageSize")
  valid_580023 = validateParameter(valid_580023, JInt, required = false, default = nil)
  if valid_580023 != nil:
    section.add "pageSize", valid_580023
  var valid_580024 = query.getOrDefault("prettyPrint")
  valid_580024 = validateParameter(valid_580024, JBool, required = false,
                                 default = newJBool(true))
  if valid_580024 != nil:
    section.add "prettyPrint", valid_580024
  var valid_580025 = query.getOrDefault("filter")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "filter", valid_580025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580026: Call_BigquerydatatransferProjectsLocationsList_580008;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_580026.validator(path, query, header, formData, body)
  let scheme = call_580026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580026.url(scheme.get, call_580026.host, call_580026.base,
                         call_580026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580026, url, valid)

proc call*(call_580027: Call_BigquerydatatransferProjectsLocationsList_580008;
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
  var path_580028 = newJObject()
  var query_580029 = newJObject()
  add(query_580029, "upload_protocol", newJString(uploadProtocol))
  add(query_580029, "fields", newJString(fields))
  add(query_580029, "pageToken", newJString(pageToken))
  add(query_580029, "quotaUser", newJString(quotaUser))
  add(path_580028, "name", newJString(name))
  add(query_580029, "alt", newJString(alt))
  add(query_580029, "oauth_token", newJString(oauthToken))
  add(query_580029, "callback", newJString(callback))
  add(query_580029, "access_token", newJString(accessToken))
  add(query_580029, "uploadType", newJString(uploadType))
  add(query_580029, "key", newJString(key))
  add(query_580029, "$.xgafv", newJString(Xgafv))
  add(query_580029, "pageSize", newJInt(pageSize))
  add(query_580029, "prettyPrint", newJBool(prettyPrint))
  add(query_580029, "filter", newJString(filter))
  result = call_580027.call(path_580028, query_580029, nil, nil, nil)

var bigquerydatatransferProjectsLocationsList* = Call_BigquerydatatransferProjectsLocationsList_580008(
    name: "bigquerydatatransferProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "bigquerydatatransfer.googleapis.com", route: "/v1/{name}/locations",
    validator: validate_BigquerydatatransferProjectsLocationsList_580009,
    base: "/", url: url_BigquerydatatransferProjectsLocationsList_580010,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsDataSourcesCheckValidCreds_580030 = ref object of OpenApiRestCall_579408
proc url_BigquerydatatransferProjectsDataSourcesCheckValidCreds_580032(
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

proc validate_BigquerydatatransferProjectsDataSourcesCheckValidCreds_580031(
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
  ##       : The data source in the form:
  ## `projects/{project_id}/dataSources/{data_source_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580033 = path.getOrDefault("name")
  valid_580033 = validateParameter(valid_580033, JString, required = true,
                                 default = nil)
  if valid_580033 != nil:
    section.add "name", valid_580033
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
  var valid_580034 = query.getOrDefault("upload_protocol")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "upload_protocol", valid_580034
  var valid_580035 = query.getOrDefault("fields")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "fields", valid_580035
  var valid_580036 = query.getOrDefault("quotaUser")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "quotaUser", valid_580036
  var valid_580037 = query.getOrDefault("alt")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = newJString("json"))
  if valid_580037 != nil:
    section.add "alt", valid_580037
  var valid_580038 = query.getOrDefault("oauth_token")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "oauth_token", valid_580038
  var valid_580039 = query.getOrDefault("callback")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "callback", valid_580039
  var valid_580040 = query.getOrDefault("access_token")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "access_token", valid_580040
  var valid_580041 = query.getOrDefault("uploadType")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "uploadType", valid_580041
  var valid_580042 = query.getOrDefault("key")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "key", valid_580042
  var valid_580043 = query.getOrDefault("$.xgafv")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = newJString("1"))
  if valid_580043 != nil:
    section.add "$.xgafv", valid_580043
  var valid_580044 = query.getOrDefault("prettyPrint")
  valid_580044 = validateParameter(valid_580044, JBool, required = false,
                                 default = newJBool(true))
  if valid_580044 != nil:
    section.add "prettyPrint", valid_580044
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

proc call*(call_580046: Call_BigquerydatatransferProjectsDataSourcesCheckValidCreds_580030;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns true if valid credentials exist for the given data source and
  ## requesting user.
  ## Some data sources doesn't support service account, so we need to talk to
  ## them on behalf of the end user. This API just checks whether we have OAuth
  ## token for the particular user, which is a pre-requisite before user can
  ## create a transfer config.
  ## 
  let valid = call_580046.validator(path, query, header, formData, body)
  let scheme = call_580046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580046.url(scheme.get, call_580046.host, call_580046.base,
                         call_580046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580046, url, valid)

proc call*(call_580047: Call_BigquerydatatransferProjectsDataSourcesCheckValidCreds_580030;
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
  ##       : The data source in the form:
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
  var path_580048 = newJObject()
  var query_580049 = newJObject()
  var body_580050 = newJObject()
  add(query_580049, "upload_protocol", newJString(uploadProtocol))
  add(query_580049, "fields", newJString(fields))
  add(query_580049, "quotaUser", newJString(quotaUser))
  add(path_580048, "name", newJString(name))
  add(query_580049, "alt", newJString(alt))
  add(query_580049, "oauth_token", newJString(oauthToken))
  add(query_580049, "callback", newJString(callback))
  add(query_580049, "access_token", newJString(accessToken))
  add(query_580049, "uploadType", newJString(uploadType))
  add(query_580049, "key", newJString(key))
  add(query_580049, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580050 = body
  add(query_580049, "prettyPrint", newJBool(prettyPrint))
  result = call_580047.call(path_580048, query_580049, nil, nil, body_580050)

var bigquerydatatransferProjectsDataSourcesCheckValidCreds* = Call_BigquerydatatransferProjectsDataSourcesCheckValidCreds_580030(
    name: "bigquerydatatransferProjectsDataSourcesCheckValidCreds",
    meth: HttpMethod.HttpPost, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{name}:checkValidCreds",
    validator: validate_BigquerydatatransferProjectsDataSourcesCheckValidCreds_580031,
    base: "/", url: url_BigquerydatatransferProjectsDataSourcesCheckValidCreds_580032,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsDataSourcesList_580051 = ref object of OpenApiRestCall_579408
proc url_BigquerydatatransferProjectsDataSourcesList_580053(protocol: Scheme;
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

proc validate_BigquerydatatransferProjectsDataSourcesList_580052(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists supported data sources and returns their settings,
  ## which can be used for UI rendering.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The BigQuery project id for which data sources should be returned.
  ## Must be in the form: `projects/{project_id}`
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580054 = path.getOrDefault("parent")
  valid_580054 = validateParameter(valid_580054, JString, required = true,
                                 default = nil)
  if valid_580054 != nil:
    section.add "parent", valid_580054
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
  var valid_580055 = query.getOrDefault("upload_protocol")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "upload_protocol", valid_580055
  var valid_580056 = query.getOrDefault("fields")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "fields", valid_580056
  var valid_580057 = query.getOrDefault("pageToken")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "pageToken", valid_580057
  var valid_580058 = query.getOrDefault("quotaUser")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "quotaUser", valid_580058
  var valid_580059 = query.getOrDefault("alt")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = newJString("json"))
  if valid_580059 != nil:
    section.add "alt", valid_580059
  var valid_580060 = query.getOrDefault("oauth_token")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "oauth_token", valid_580060
  var valid_580061 = query.getOrDefault("callback")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "callback", valid_580061
  var valid_580062 = query.getOrDefault("access_token")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "access_token", valid_580062
  var valid_580063 = query.getOrDefault("uploadType")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "uploadType", valid_580063
  var valid_580064 = query.getOrDefault("key")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "key", valid_580064
  var valid_580065 = query.getOrDefault("$.xgafv")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = newJString("1"))
  if valid_580065 != nil:
    section.add "$.xgafv", valid_580065
  var valid_580066 = query.getOrDefault("pageSize")
  valid_580066 = validateParameter(valid_580066, JInt, required = false, default = nil)
  if valid_580066 != nil:
    section.add "pageSize", valid_580066
  var valid_580067 = query.getOrDefault("prettyPrint")
  valid_580067 = validateParameter(valid_580067, JBool, required = false,
                                 default = newJBool(true))
  if valid_580067 != nil:
    section.add "prettyPrint", valid_580067
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580068: Call_BigquerydatatransferProjectsDataSourcesList_580051;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists supported data sources and returns their settings,
  ## which can be used for UI rendering.
  ## 
  let valid = call_580068.validator(path, query, header, formData, body)
  let scheme = call_580068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580068.url(scheme.get, call_580068.host, call_580068.base,
                         call_580068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580068, url, valid)

proc call*(call_580069: Call_BigquerydatatransferProjectsDataSourcesList_580051;
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
  ##         : The BigQuery project id for which data sources should be returned.
  ## Must be in the form: `projects/{project_id}`
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Page size. The default page size is the maximum value of 1000 results.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580070 = newJObject()
  var query_580071 = newJObject()
  add(query_580071, "upload_protocol", newJString(uploadProtocol))
  add(query_580071, "fields", newJString(fields))
  add(query_580071, "pageToken", newJString(pageToken))
  add(query_580071, "quotaUser", newJString(quotaUser))
  add(query_580071, "alt", newJString(alt))
  add(query_580071, "oauth_token", newJString(oauthToken))
  add(query_580071, "callback", newJString(callback))
  add(query_580071, "access_token", newJString(accessToken))
  add(query_580071, "uploadType", newJString(uploadType))
  add(path_580070, "parent", newJString(parent))
  add(query_580071, "key", newJString(key))
  add(query_580071, "$.xgafv", newJString(Xgafv))
  add(query_580071, "pageSize", newJInt(pageSize))
  add(query_580071, "prettyPrint", newJBool(prettyPrint))
  result = call_580069.call(path_580070, query_580071, nil, nil, nil)

var bigquerydatatransferProjectsDataSourcesList* = Call_BigquerydatatransferProjectsDataSourcesList_580051(
    name: "bigquerydatatransferProjectsDataSourcesList", meth: HttpMethod.HttpGet,
    host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}/dataSources",
    validator: validate_BigquerydatatransferProjectsDataSourcesList_580052,
    base: "/", url: url_BigquerydatatransferProjectsDataSourcesList_580053,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsRunsList_580072 = ref object of OpenApiRestCall_579408
proc url_BigquerydatatransferProjectsTransferConfigsRunsList_580074(
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

proc validate_BigquerydatatransferProjectsTransferConfigsRunsList_580073(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns information about running and completed jobs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Name of transfer configuration for which transfer runs should be retrieved.
  ## Format of transfer configuration resource name is:
  ## `projects/{project_id}/transferConfigs/{config_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580075 = path.getOrDefault("parent")
  valid_580075 = validateParameter(valid_580075, JString, required = true,
                                 default = nil)
  if valid_580075 != nil:
    section.add "parent", valid_580075
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
  var valid_580076 = query.getOrDefault("upload_protocol")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "upload_protocol", valid_580076
  var valid_580077 = query.getOrDefault("fields")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "fields", valid_580077
  var valid_580078 = query.getOrDefault("pageToken")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "pageToken", valid_580078
  var valid_580079 = query.getOrDefault("quotaUser")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "quotaUser", valid_580079
  var valid_580080 = query.getOrDefault("alt")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = newJString("json"))
  if valid_580080 != nil:
    section.add "alt", valid_580080
  var valid_580081 = query.getOrDefault("oauth_token")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "oauth_token", valid_580081
  var valid_580082 = query.getOrDefault("callback")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "callback", valid_580082
  var valid_580083 = query.getOrDefault("access_token")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "access_token", valid_580083
  var valid_580084 = query.getOrDefault("uploadType")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "uploadType", valid_580084
  var valid_580085 = query.getOrDefault("key")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "key", valid_580085
  var valid_580086 = query.getOrDefault("states")
  valid_580086 = validateParameter(valid_580086, JArray, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "states", valid_580086
  var valid_580087 = query.getOrDefault("$.xgafv")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = newJString("1"))
  if valid_580087 != nil:
    section.add "$.xgafv", valid_580087
  var valid_580088 = query.getOrDefault("pageSize")
  valid_580088 = validateParameter(valid_580088, JInt, required = false, default = nil)
  if valid_580088 != nil:
    section.add "pageSize", valid_580088
  var valid_580089 = query.getOrDefault("runAttempt")
  valid_580089 = validateParameter(valid_580089, JString, required = false, default = newJString(
      "RUN_ATTEMPT_UNSPECIFIED"))
  if valid_580089 != nil:
    section.add "runAttempt", valid_580089
  var valid_580090 = query.getOrDefault("prettyPrint")
  valid_580090 = validateParameter(valid_580090, JBool, required = false,
                                 default = newJBool(true))
  if valid_580090 != nil:
    section.add "prettyPrint", valid_580090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580091: Call_BigquerydatatransferProjectsTransferConfigsRunsList_580072;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about running and completed jobs.
  ## 
  let valid = call_580091.validator(path, query, header, formData, body)
  let scheme = call_580091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580091.url(scheme.get, call_580091.host, call_580091.base,
                         call_580091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580091, url, valid)

proc call*(call_580092: Call_BigquerydatatransferProjectsTransferConfigsRunsList_580072;
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
  ##         : Name of transfer configuration for which transfer runs should be retrieved.
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
  var path_580093 = newJObject()
  var query_580094 = newJObject()
  add(query_580094, "upload_protocol", newJString(uploadProtocol))
  add(query_580094, "fields", newJString(fields))
  add(query_580094, "pageToken", newJString(pageToken))
  add(query_580094, "quotaUser", newJString(quotaUser))
  add(query_580094, "alt", newJString(alt))
  add(query_580094, "oauth_token", newJString(oauthToken))
  add(query_580094, "callback", newJString(callback))
  add(query_580094, "access_token", newJString(accessToken))
  add(query_580094, "uploadType", newJString(uploadType))
  add(path_580093, "parent", newJString(parent))
  add(query_580094, "key", newJString(key))
  if states != nil:
    query_580094.add "states", states
  add(query_580094, "$.xgafv", newJString(Xgafv))
  add(query_580094, "pageSize", newJInt(pageSize))
  add(query_580094, "runAttempt", newJString(runAttempt))
  add(query_580094, "prettyPrint", newJBool(prettyPrint))
  result = call_580092.call(path_580093, query_580094, nil, nil, nil)

var bigquerydatatransferProjectsTransferConfigsRunsList* = Call_BigquerydatatransferProjectsTransferConfigsRunsList_580072(
    name: "bigquerydatatransferProjectsTransferConfigsRunsList",
    meth: HttpMethod.HttpGet, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}/runs",
    validator: validate_BigquerydatatransferProjectsTransferConfigsRunsList_580073,
    base: "/", url: url_BigquerydatatransferProjectsTransferConfigsRunsList_580074,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsCreate_580117 = ref object of OpenApiRestCall_579408
proc url_BigquerydatatransferProjectsTransferConfigsCreate_580119(
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

proc validate_BigquerydatatransferProjectsTransferConfigsCreate_580118(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a new data transfer configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The BigQuery project id where the transfer configuration should be created.
  ## Must be in the format projects/{project_id}/locations/{location_id}
  ## If specified location and location of the destination bigquery dataset
  ## do not match - the request will fail.
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
  var valid_580121 = query.getOrDefault("upload_protocol")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "upload_protocol", valid_580121
  var valid_580122 = query.getOrDefault("authorizationCode")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "authorizationCode", valid_580122
  var valid_580123 = query.getOrDefault("fields")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "fields", valid_580123
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
  var valid_580126 = query.getOrDefault("oauth_token")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "oauth_token", valid_580126
  var valid_580127 = query.getOrDefault("callback")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "callback", valid_580127
  var valid_580128 = query.getOrDefault("access_token")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "access_token", valid_580128
  var valid_580129 = query.getOrDefault("uploadType")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "uploadType", valid_580129
  var valid_580130 = query.getOrDefault("versionInfo")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "versionInfo", valid_580130
  var valid_580131 = query.getOrDefault("key")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "key", valid_580131
  var valid_580132 = query.getOrDefault("$.xgafv")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = newJString("1"))
  if valid_580132 != nil:
    section.add "$.xgafv", valid_580132
  var valid_580133 = query.getOrDefault("prettyPrint")
  valid_580133 = validateParameter(valid_580133, JBool, required = false,
                                 default = newJBool(true))
  if valid_580133 != nil:
    section.add "prettyPrint", valid_580133
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

proc call*(call_580135: Call_BigquerydatatransferProjectsTransferConfigsCreate_580117;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new data transfer configuration.
  ## 
  let valid = call_580135.validator(path, query, header, formData, body)
  let scheme = call_580135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580135.url(scheme.get, call_580135.host, call_580135.base,
                         call_580135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580135, url, valid)

proc call*(call_580136: Call_BigquerydatatransferProjectsTransferConfigsCreate_580117;
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
  ##         : The BigQuery project id where the transfer configuration should be created.
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
  var path_580137 = newJObject()
  var query_580138 = newJObject()
  var body_580139 = newJObject()
  add(query_580138, "upload_protocol", newJString(uploadProtocol))
  add(query_580138, "authorizationCode", newJString(authorizationCode))
  add(query_580138, "fields", newJString(fields))
  add(query_580138, "quotaUser", newJString(quotaUser))
  add(query_580138, "alt", newJString(alt))
  add(query_580138, "oauth_token", newJString(oauthToken))
  add(query_580138, "callback", newJString(callback))
  add(query_580138, "access_token", newJString(accessToken))
  add(query_580138, "uploadType", newJString(uploadType))
  add(path_580137, "parent", newJString(parent))
  add(query_580138, "versionInfo", newJString(versionInfo))
  add(query_580138, "key", newJString(key))
  add(query_580138, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580139 = body
  add(query_580138, "prettyPrint", newJBool(prettyPrint))
  result = call_580136.call(path_580137, query_580138, nil, nil, body_580139)

var bigquerydatatransferProjectsTransferConfigsCreate* = Call_BigquerydatatransferProjectsTransferConfigsCreate_580117(
    name: "bigquerydatatransferProjectsTransferConfigsCreate",
    meth: HttpMethod.HttpPost, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}/transferConfigs",
    validator: validate_BigquerydatatransferProjectsTransferConfigsCreate_580118,
    base: "/", url: url_BigquerydatatransferProjectsTransferConfigsCreate_580119,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsList_580095 = ref object of OpenApiRestCall_579408
proc url_BigquerydatatransferProjectsTransferConfigsList_580097(protocol: Scheme;
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

proc validate_BigquerydatatransferProjectsTransferConfigsList_580096(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns information about all data transfers in the project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The BigQuery project id for which data sources
  ## should be returned: `projects/{project_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580098 = path.getOrDefault("parent")
  valid_580098 = validateParameter(valid_580098, JString, required = true,
                                 default = nil)
  if valid_580098 != nil:
    section.add "parent", valid_580098
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
  var valid_580099 = query.getOrDefault("upload_protocol")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "upload_protocol", valid_580099
  var valid_580100 = query.getOrDefault("fields")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "fields", valid_580100
  var valid_580101 = query.getOrDefault("pageToken")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "pageToken", valid_580101
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
  var valid_580110 = query.getOrDefault("pageSize")
  valid_580110 = validateParameter(valid_580110, JInt, required = false, default = nil)
  if valid_580110 != nil:
    section.add "pageSize", valid_580110
  var valid_580111 = query.getOrDefault("dataSourceIds")
  valid_580111 = validateParameter(valid_580111, JArray, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "dataSourceIds", valid_580111
  var valid_580112 = query.getOrDefault("prettyPrint")
  valid_580112 = validateParameter(valid_580112, JBool, required = false,
                                 default = newJBool(true))
  if valid_580112 != nil:
    section.add "prettyPrint", valid_580112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580113: Call_BigquerydatatransferProjectsTransferConfigsList_580095;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about all data transfers in the project.
  ## 
  let valid = call_580113.validator(path, query, header, formData, body)
  let scheme = call_580113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580113.url(scheme.get, call_580113.host, call_580113.base,
                         call_580113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580113, url, valid)

proc call*(call_580114: Call_BigquerydatatransferProjectsTransferConfigsList_580095;
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
  ##         : The BigQuery project id for which data sources
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
  var path_580115 = newJObject()
  var query_580116 = newJObject()
  add(query_580116, "upload_protocol", newJString(uploadProtocol))
  add(query_580116, "fields", newJString(fields))
  add(query_580116, "pageToken", newJString(pageToken))
  add(query_580116, "quotaUser", newJString(quotaUser))
  add(query_580116, "alt", newJString(alt))
  add(query_580116, "oauth_token", newJString(oauthToken))
  add(query_580116, "callback", newJString(callback))
  add(query_580116, "access_token", newJString(accessToken))
  add(query_580116, "uploadType", newJString(uploadType))
  add(path_580115, "parent", newJString(parent))
  add(query_580116, "key", newJString(key))
  add(query_580116, "$.xgafv", newJString(Xgafv))
  add(query_580116, "pageSize", newJInt(pageSize))
  if dataSourceIds != nil:
    query_580116.add "dataSourceIds", dataSourceIds
  add(query_580116, "prettyPrint", newJBool(prettyPrint))
  result = call_580114.call(path_580115, query_580116, nil, nil, nil)

var bigquerydatatransferProjectsTransferConfigsList* = Call_BigquerydatatransferProjectsTransferConfigsList_580095(
    name: "bigquerydatatransferProjectsTransferConfigsList",
    meth: HttpMethod.HttpGet, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}/transferConfigs",
    validator: validate_BigquerydatatransferProjectsTransferConfigsList_580096,
    base: "/", url: url_BigquerydatatransferProjectsTransferConfigsList_580097,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_580140 = ref object of OpenApiRestCall_579408
proc url_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_580142(
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

proc validate_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_580141(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns user facing log messages for the data transfer run.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Transfer run name in the form:
  ## `projects/{project_id}/transferConfigs/{config_Id}/runs/{run_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580143 = path.getOrDefault("parent")
  valid_580143 = validateParameter(valid_580143, JString, required = true,
                                 default = nil)
  if valid_580143 != nil:
    section.add "parent", valid_580143
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
  var valid_580144 = query.getOrDefault("upload_protocol")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "upload_protocol", valid_580144
  var valid_580145 = query.getOrDefault("fields")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "fields", valid_580145
  var valid_580146 = query.getOrDefault("pageToken")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "pageToken", valid_580146
  var valid_580147 = query.getOrDefault("quotaUser")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "quotaUser", valid_580147
  var valid_580148 = query.getOrDefault("alt")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = newJString("json"))
  if valid_580148 != nil:
    section.add "alt", valid_580148
  var valid_580149 = query.getOrDefault("oauth_token")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "oauth_token", valid_580149
  var valid_580150 = query.getOrDefault("callback")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "callback", valid_580150
  var valid_580151 = query.getOrDefault("access_token")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "access_token", valid_580151
  var valid_580152 = query.getOrDefault("uploadType")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "uploadType", valid_580152
  var valid_580153 = query.getOrDefault("key")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "key", valid_580153
  var valid_580154 = query.getOrDefault("$.xgafv")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = newJString("1"))
  if valid_580154 != nil:
    section.add "$.xgafv", valid_580154
  var valid_580155 = query.getOrDefault("pageSize")
  valid_580155 = validateParameter(valid_580155, JInt, required = false, default = nil)
  if valid_580155 != nil:
    section.add "pageSize", valid_580155
  var valid_580156 = query.getOrDefault("messageTypes")
  valid_580156 = validateParameter(valid_580156, JArray, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "messageTypes", valid_580156
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
  if body != nil:
    result.add "body", body

proc call*(call_580158: Call_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_580140;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns user facing log messages for the data transfer run.
  ## 
  let valid = call_580158.validator(path, query, header, formData, body)
  let scheme = call_580158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580158.url(scheme.get, call_580158.host, call_580158.base,
                         call_580158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580158, url, valid)

proc call*(call_580159: Call_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_580140;
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
  ##         : Transfer run name in the form:
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
  var path_580160 = newJObject()
  var query_580161 = newJObject()
  add(query_580161, "upload_protocol", newJString(uploadProtocol))
  add(query_580161, "fields", newJString(fields))
  add(query_580161, "pageToken", newJString(pageToken))
  add(query_580161, "quotaUser", newJString(quotaUser))
  add(query_580161, "alt", newJString(alt))
  add(query_580161, "oauth_token", newJString(oauthToken))
  add(query_580161, "callback", newJString(callback))
  add(query_580161, "access_token", newJString(accessToken))
  add(query_580161, "uploadType", newJString(uploadType))
  add(path_580160, "parent", newJString(parent))
  add(query_580161, "key", newJString(key))
  add(query_580161, "$.xgafv", newJString(Xgafv))
  add(query_580161, "pageSize", newJInt(pageSize))
  if messageTypes != nil:
    query_580161.add "messageTypes", messageTypes
  add(query_580161, "prettyPrint", newJBool(prettyPrint))
  result = call_580159.call(path_580160, query_580161, nil, nil, nil)

var bigquerydatatransferProjectsTransferConfigsRunsTransferLogsList* = Call_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_580140(
    name: "bigquerydatatransferProjectsTransferConfigsRunsTransferLogsList",
    meth: HttpMethod.HttpGet, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}/transferLogs", validator: validate_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_580141,
    base: "/",
    url: url_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_580142,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsScheduleRuns_580162 = ref object of OpenApiRestCall_579408
proc url_BigquerydatatransferProjectsTransferConfigsScheduleRuns_580164(
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

proc validate_BigquerydatatransferProjectsTransferConfigsScheduleRuns_580163(
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
  ##         : Transfer configuration name in the form:
  ## `projects/{project_id}/transferConfigs/{config_id}`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580165 = path.getOrDefault("parent")
  valid_580165 = validateParameter(valid_580165, JString, required = true,
                                 default = nil)
  if valid_580165 != nil:
    section.add "parent", valid_580165
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
  var valid_580166 = query.getOrDefault("upload_protocol")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "upload_protocol", valid_580166
  var valid_580167 = query.getOrDefault("fields")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "fields", valid_580167
  var valid_580168 = query.getOrDefault("quotaUser")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "quotaUser", valid_580168
  var valid_580169 = query.getOrDefault("alt")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = newJString("json"))
  if valid_580169 != nil:
    section.add "alt", valid_580169
  var valid_580170 = query.getOrDefault("oauth_token")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "oauth_token", valid_580170
  var valid_580171 = query.getOrDefault("callback")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "callback", valid_580171
  var valid_580172 = query.getOrDefault("access_token")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "access_token", valid_580172
  var valid_580173 = query.getOrDefault("uploadType")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "uploadType", valid_580173
  var valid_580174 = query.getOrDefault("key")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "key", valid_580174
  var valid_580175 = query.getOrDefault("$.xgafv")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = newJString("1"))
  if valid_580175 != nil:
    section.add "$.xgafv", valid_580175
  var valid_580176 = query.getOrDefault("prettyPrint")
  valid_580176 = validateParameter(valid_580176, JBool, required = false,
                                 default = newJBool(true))
  if valid_580176 != nil:
    section.add "prettyPrint", valid_580176
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

proc call*(call_580178: Call_BigquerydatatransferProjectsTransferConfigsScheduleRuns_580162;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates transfer runs for a time range [start_time, end_time].
  ## For each date - or whatever granularity the data source supports - in the
  ## range, one transfer run is created.
  ## Note that runs are created per UTC time in the time range.
  ## DEPRECATED: use StartManualTransferRuns instead.
  ## 
  let valid = call_580178.validator(path, query, header, formData, body)
  let scheme = call_580178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580178.url(scheme.get, call_580178.host, call_580178.base,
                         call_580178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580178, url, valid)

proc call*(call_580179: Call_BigquerydatatransferProjectsTransferConfigsScheduleRuns_580162;
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
  ##         : Transfer configuration name in the form:
  ## `projects/{project_id}/transferConfigs/{config_id}`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580180 = newJObject()
  var query_580181 = newJObject()
  var body_580182 = newJObject()
  add(query_580181, "upload_protocol", newJString(uploadProtocol))
  add(query_580181, "fields", newJString(fields))
  add(query_580181, "quotaUser", newJString(quotaUser))
  add(query_580181, "alt", newJString(alt))
  add(query_580181, "oauth_token", newJString(oauthToken))
  add(query_580181, "callback", newJString(callback))
  add(query_580181, "access_token", newJString(accessToken))
  add(query_580181, "uploadType", newJString(uploadType))
  add(path_580180, "parent", newJString(parent))
  add(query_580181, "key", newJString(key))
  add(query_580181, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580182 = body
  add(query_580181, "prettyPrint", newJBool(prettyPrint))
  result = call_580179.call(path_580180, query_580181, nil, nil, body_580182)

var bigquerydatatransferProjectsTransferConfigsScheduleRuns* = Call_BigquerydatatransferProjectsTransferConfigsScheduleRuns_580162(
    name: "bigquerydatatransferProjectsTransferConfigsScheduleRuns",
    meth: HttpMethod.HttpPost, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}:scheduleRuns", validator: validate_BigquerydatatransferProjectsTransferConfigsScheduleRuns_580163,
    base: "/", url: url_BigquerydatatransferProjectsTransferConfigsScheduleRuns_580164,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsStartManualRuns_580183 = ref object of OpenApiRestCall_579408
proc url_BigquerydatatransferProjectsTransferConfigsStartManualRuns_580185(
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

proc validate_BigquerydatatransferProjectsTransferConfigsStartManualRuns_580184(
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
  var valid_580186 = path.getOrDefault("parent")
  valid_580186 = validateParameter(valid_580186, JString, required = true,
                                 default = nil)
  if valid_580186 != nil:
    section.add "parent", valid_580186
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
  var valid_580187 = query.getOrDefault("upload_protocol")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "upload_protocol", valid_580187
  var valid_580188 = query.getOrDefault("fields")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "fields", valid_580188
  var valid_580189 = query.getOrDefault("quotaUser")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "quotaUser", valid_580189
  var valid_580190 = query.getOrDefault("alt")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = newJString("json"))
  if valid_580190 != nil:
    section.add "alt", valid_580190
  var valid_580191 = query.getOrDefault("oauth_token")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "oauth_token", valid_580191
  var valid_580192 = query.getOrDefault("callback")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "callback", valid_580192
  var valid_580193 = query.getOrDefault("access_token")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "access_token", valid_580193
  var valid_580194 = query.getOrDefault("uploadType")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "uploadType", valid_580194
  var valid_580195 = query.getOrDefault("key")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "key", valid_580195
  var valid_580196 = query.getOrDefault("$.xgafv")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = newJString("1"))
  if valid_580196 != nil:
    section.add "$.xgafv", valid_580196
  var valid_580197 = query.getOrDefault("prettyPrint")
  valid_580197 = validateParameter(valid_580197, JBool, required = false,
                                 default = newJBool(true))
  if valid_580197 != nil:
    section.add "prettyPrint", valid_580197
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

proc call*(call_580199: Call_BigquerydatatransferProjectsTransferConfigsStartManualRuns_580183;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Start manual transfer runs to be executed now with schedule_time equal to
  ## current time. The transfer runs can be created for a time range where the
  ## run_time is between start_time (inclusive) and end_time (exclusive), or for
  ## a specific run_time.
  ## 
  let valid = call_580199.validator(path, query, header, formData, body)
  let scheme = call_580199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580199.url(scheme.get, call_580199.host, call_580199.base,
                         call_580199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580199, url, valid)

proc call*(call_580200: Call_BigquerydatatransferProjectsTransferConfigsStartManualRuns_580183;
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
  var path_580201 = newJObject()
  var query_580202 = newJObject()
  var body_580203 = newJObject()
  add(query_580202, "upload_protocol", newJString(uploadProtocol))
  add(query_580202, "fields", newJString(fields))
  add(query_580202, "quotaUser", newJString(quotaUser))
  add(query_580202, "alt", newJString(alt))
  add(query_580202, "oauth_token", newJString(oauthToken))
  add(query_580202, "callback", newJString(callback))
  add(query_580202, "access_token", newJString(accessToken))
  add(query_580202, "uploadType", newJString(uploadType))
  add(path_580201, "parent", newJString(parent))
  add(query_580202, "key", newJString(key))
  add(query_580202, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580203 = body
  add(query_580202, "prettyPrint", newJBool(prettyPrint))
  result = call_580200.call(path_580201, query_580202, nil, nil, body_580203)

var bigquerydatatransferProjectsTransferConfigsStartManualRuns* = Call_BigquerydatatransferProjectsTransferConfigsStartManualRuns_580183(
    name: "bigquerydatatransferProjectsTransferConfigsStartManualRuns",
    meth: HttpMethod.HttpPost, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}:startManualRuns", validator: validate_BigquerydatatransferProjectsTransferConfigsStartManualRuns_580184,
    base: "/",
    url: url_BigquerydatatransferProjectsTransferConfigsStartManualRuns_580185,
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
