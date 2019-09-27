
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597408): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BigquerydatatransferProjectsTransferConfigsRunsGet_597677 = ref object of OpenApiRestCall_597408
proc url_BigquerydatatransferProjectsTransferConfigsRunsGet_597679(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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

proc validate_BigquerydatatransferProjectsTransferConfigsRunsGet_597678(
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
  var valid_597805 = path.getOrDefault("name")
  valid_597805 = validateParameter(valid_597805, JString, required = true,
                                 default = nil)
  if valid_597805 != nil:
    section.add "name", valid_597805
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
  var valid_597806 = query.getOrDefault("upload_protocol")
  valid_597806 = validateParameter(valid_597806, JString, required = false,
                                 default = nil)
  if valid_597806 != nil:
    section.add "upload_protocol", valid_597806
  var valid_597807 = query.getOrDefault("fields")
  valid_597807 = validateParameter(valid_597807, JString, required = false,
                                 default = nil)
  if valid_597807 != nil:
    section.add "fields", valid_597807
  var valid_597808 = query.getOrDefault("quotaUser")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = nil)
  if valid_597808 != nil:
    section.add "quotaUser", valid_597808
  var valid_597822 = query.getOrDefault("alt")
  valid_597822 = validateParameter(valid_597822, JString, required = false,
                                 default = newJString("json"))
  if valid_597822 != nil:
    section.add "alt", valid_597822
  var valid_597823 = query.getOrDefault("oauth_token")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = nil)
  if valid_597823 != nil:
    section.add "oauth_token", valid_597823
  var valid_597824 = query.getOrDefault("callback")
  valid_597824 = validateParameter(valid_597824, JString, required = false,
                                 default = nil)
  if valid_597824 != nil:
    section.add "callback", valid_597824
  var valid_597825 = query.getOrDefault("access_token")
  valid_597825 = validateParameter(valid_597825, JString, required = false,
                                 default = nil)
  if valid_597825 != nil:
    section.add "access_token", valid_597825
  var valid_597826 = query.getOrDefault("uploadType")
  valid_597826 = validateParameter(valid_597826, JString, required = false,
                                 default = nil)
  if valid_597826 != nil:
    section.add "uploadType", valid_597826
  var valid_597827 = query.getOrDefault("key")
  valid_597827 = validateParameter(valid_597827, JString, required = false,
                                 default = nil)
  if valid_597827 != nil:
    section.add "key", valid_597827
  var valid_597828 = query.getOrDefault("$.xgafv")
  valid_597828 = validateParameter(valid_597828, JString, required = false,
                                 default = newJString("1"))
  if valid_597828 != nil:
    section.add "$.xgafv", valid_597828
  var valid_597829 = query.getOrDefault("prettyPrint")
  valid_597829 = validateParameter(valid_597829, JBool, required = false,
                                 default = newJBool(true))
  if valid_597829 != nil:
    section.add "prettyPrint", valid_597829
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597852: Call_BigquerydatatransferProjectsTransferConfigsRunsGet_597677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about the particular transfer run.
  ## 
  let valid = call_597852.validator(path, query, header, formData, body)
  let scheme = call_597852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597852.url(scheme.get, call_597852.host, call_597852.base,
                         call_597852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597852, url, valid)

proc call*(call_597923: Call_BigquerydatatransferProjectsTransferConfigsRunsGet_597677;
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
  var path_597924 = newJObject()
  var query_597926 = newJObject()
  add(query_597926, "upload_protocol", newJString(uploadProtocol))
  add(query_597926, "fields", newJString(fields))
  add(query_597926, "quotaUser", newJString(quotaUser))
  add(path_597924, "name", newJString(name))
  add(query_597926, "alt", newJString(alt))
  add(query_597926, "oauth_token", newJString(oauthToken))
  add(query_597926, "callback", newJString(callback))
  add(query_597926, "access_token", newJString(accessToken))
  add(query_597926, "uploadType", newJString(uploadType))
  add(query_597926, "key", newJString(key))
  add(query_597926, "$.xgafv", newJString(Xgafv))
  add(query_597926, "prettyPrint", newJBool(prettyPrint))
  result = call_597923.call(path_597924, query_597926, nil, nil, nil)

var bigquerydatatransferProjectsTransferConfigsRunsGet* = Call_BigquerydatatransferProjectsTransferConfigsRunsGet_597677(
    name: "bigquerydatatransferProjectsTransferConfigsRunsGet",
    meth: HttpMethod.HttpGet, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{name}",
    validator: validate_BigquerydatatransferProjectsTransferConfigsRunsGet_597678,
    base: "/", url: url_BigquerydatatransferProjectsTransferConfigsRunsGet_597679,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsPatch_597984 = ref object of OpenApiRestCall_597408
proc url_BigquerydatatransferProjectsTransferConfigsPatch_597986(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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

proc validate_BigquerydatatransferProjectsTransferConfigsPatch_597985(
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
  var valid_597987 = path.getOrDefault("name")
  valid_597987 = validateParameter(valid_597987, JString, required = true,
                                 default = nil)
  if valid_597987 != nil:
    section.add "name", valid_597987
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
  var valid_597988 = query.getOrDefault("upload_protocol")
  valid_597988 = validateParameter(valid_597988, JString, required = false,
                                 default = nil)
  if valid_597988 != nil:
    section.add "upload_protocol", valid_597988
  var valid_597989 = query.getOrDefault("authorizationCode")
  valid_597989 = validateParameter(valid_597989, JString, required = false,
                                 default = nil)
  if valid_597989 != nil:
    section.add "authorizationCode", valid_597989
  var valid_597990 = query.getOrDefault("fields")
  valid_597990 = validateParameter(valid_597990, JString, required = false,
                                 default = nil)
  if valid_597990 != nil:
    section.add "fields", valid_597990
  var valid_597991 = query.getOrDefault("quotaUser")
  valid_597991 = validateParameter(valid_597991, JString, required = false,
                                 default = nil)
  if valid_597991 != nil:
    section.add "quotaUser", valid_597991
  var valid_597992 = query.getOrDefault("alt")
  valid_597992 = validateParameter(valid_597992, JString, required = false,
                                 default = newJString("json"))
  if valid_597992 != nil:
    section.add "alt", valid_597992
  var valid_597993 = query.getOrDefault("oauth_token")
  valid_597993 = validateParameter(valid_597993, JString, required = false,
                                 default = nil)
  if valid_597993 != nil:
    section.add "oauth_token", valid_597993
  var valid_597994 = query.getOrDefault("callback")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = nil)
  if valid_597994 != nil:
    section.add "callback", valid_597994
  var valid_597995 = query.getOrDefault("access_token")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = nil)
  if valid_597995 != nil:
    section.add "access_token", valid_597995
  var valid_597996 = query.getOrDefault("uploadType")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "uploadType", valid_597996
  var valid_597997 = query.getOrDefault("versionInfo")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = nil)
  if valid_597997 != nil:
    section.add "versionInfo", valid_597997
  var valid_597998 = query.getOrDefault("key")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = nil)
  if valid_597998 != nil:
    section.add "key", valid_597998
  var valid_597999 = query.getOrDefault("$.xgafv")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = newJString("1"))
  if valid_597999 != nil:
    section.add "$.xgafv", valid_597999
  var valid_598000 = query.getOrDefault("prettyPrint")
  valid_598000 = validateParameter(valid_598000, JBool, required = false,
                                 default = newJBool(true))
  if valid_598000 != nil:
    section.add "prettyPrint", valid_598000
  var valid_598001 = query.getOrDefault("updateMask")
  valid_598001 = validateParameter(valid_598001, JString, required = false,
                                 default = nil)
  if valid_598001 != nil:
    section.add "updateMask", valid_598001
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

proc call*(call_598003: Call_BigquerydatatransferProjectsTransferConfigsPatch_597984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a data transfer configuration.
  ## All fields must be set, even if they are not updated.
  ## 
  let valid = call_598003.validator(path, query, header, formData, body)
  let scheme = call_598003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598003.url(scheme.get, call_598003.host, call_598003.base,
                         call_598003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598003, url, valid)

proc call*(call_598004: Call_BigquerydatatransferProjectsTransferConfigsPatch_597984;
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
  var path_598005 = newJObject()
  var query_598006 = newJObject()
  var body_598007 = newJObject()
  add(query_598006, "upload_protocol", newJString(uploadProtocol))
  add(query_598006, "authorizationCode", newJString(authorizationCode))
  add(query_598006, "fields", newJString(fields))
  add(query_598006, "quotaUser", newJString(quotaUser))
  add(path_598005, "name", newJString(name))
  add(query_598006, "alt", newJString(alt))
  add(query_598006, "oauth_token", newJString(oauthToken))
  add(query_598006, "callback", newJString(callback))
  add(query_598006, "access_token", newJString(accessToken))
  add(query_598006, "uploadType", newJString(uploadType))
  add(query_598006, "versionInfo", newJString(versionInfo))
  add(query_598006, "key", newJString(key))
  add(query_598006, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598007 = body
  add(query_598006, "prettyPrint", newJBool(prettyPrint))
  add(query_598006, "updateMask", newJString(updateMask))
  result = call_598004.call(path_598005, query_598006, nil, nil, body_598007)

var bigquerydatatransferProjectsTransferConfigsPatch* = Call_BigquerydatatransferProjectsTransferConfigsPatch_597984(
    name: "bigquerydatatransferProjectsTransferConfigsPatch",
    meth: HttpMethod.HttpPatch, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{name}",
    validator: validate_BigquerydatatransferProjectsTransferConfigsPatch_597985,
    base: "/", url: url_BigquerydatatransferProjectsTransferConfigsPatch_597986,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsRunsDelete_597965 = ref object of OpenApiRestCall_597408
proc url_BigquerydatatransferProjectsTransferConfigsRunsDelete_597967(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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

proc validate_BigquerydatatransferProjectsTransferConfigsRunsDelete_597966(
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
  var valid_597968 = path.getOrDefault("name")
  valid_597968 = validateParameter(valid_597968, JString, required = true,
                                 default = nil)
  if valid_597968 != nil:
    section.add "name", valid_597968
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
  var valid_597969 = query.getOrDefault("upload_protocol")
  valid_597969 = validateParameter(valid_597969, JString, required = false,
                                 default = nil)
  if valid_597969 != nil:
    section.add "upload_protocol", valid_597969
  var valid_597970 = query.getOrDefault("fields")
  valid_597970 = validateParameter(valid_597970, JString, required = false,
                                 default = nil)
  if valid_597970 != nil:
    section.add "fields", valid_597970
  var valid_597971 = query.getOrDefault("quotaUser")
  valid_597971 = validateParameter(valid_597971, JString, required = false,
                                 default = nil)
  if valid_597971 != nil:
    section.add "quotaUser", valid_597971
  var valid_597972 = query.getOrDefault("alt")
  valid_597972 = validateParameter(valid_597972, JString, required = false,
                                 default = newJString("json"))
  if valid_597972 != nil:
    section.add "alt", valid_597972
  var valid_597973 = query.getOrDefault("oauth_token")
  valid_597973 = validateParameter(valid_597973, JString, required = false,
                                 default = nil)
  if valid_597973 != nil:
    section.add "oauth_token", valid_597973
  var valid_597974 = query.getOrDefault("callback")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = nil)
  if valid_597974 != nil:
    section.add "callback", valid_597974
  var valid_597975 = query.getOrDefault("access_token")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = nil)
  if valid_597975 != nil:
    section.add "access_token", valid_597975
  var valid_597976 = query.getOrDefault("uploadType")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = nil)
  if valid_597976 != nil:
    section.add "uploadType", valid_597976
  var valid_597977 = query.getOrDefault("key")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "key", valid_597977
  var valid_597978 = query.getOrDefault("$.xgafv")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = newJString("1"))
  if valid_597978 != nil:
    section.add "$.xgafv", valid_597978
  var valid_597979 = query.getOrDefault("prettyPrint")
  valid_597979 = validateParameter(valid_597979, JBool, required = false,
                                 default = newJBool(true))
  if valid_597979 != nil:
    section.add "prettyPrint", valid_597979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597980: Call_BigquerydatatransferProjectsTransferConfigsRunsDelete_597965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified transfer run.
  ## 
  let valid = call_597980.validator(path, query, header, formData, body)
  let scheme = call_597980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597980.url(scheme.get, call_597980.host, call_597980.base,
                         call_597980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597980, url, valid)

proc call*(call_597981: Call_BigquerydatatransferProjectsTransferConfigsRunsDelete_597965;
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
  var path_597982 = newJObject()
  var query_597983 = newJObject()
  add(query_597983, "upload_protocol", newJString(uploadProtocol))
  add(query_597983, "fields", newJString(fields))
  add(query_597983, "quotaUser", newJString(quotaUser))
  add(path_597982, "name", newJString(name))
  add(query_597983, "alt", newJString(alt))
  add(query_597983, "oauth_token", newJString(oauthToken))
  add(query_597983, "callback", newJString(callback))
  add(query_597983, "access_token", newJString(accessToken))
  add(query_597983, "uploadType", newJString(uploadType))
  add(query_597983, "key", newJString(key))
  add(query_597983, "$.xgafv", newJString(Xgafv))
  add(query_597983, "prettyPrint", newJBool(prettyPrint))
  result = call_597981.call(path_597982, query_597983, nil, nil, nil)

var bigquerydatatransferProjectsTransferConfigsRunsDelete* = Call_BigquerydatatransferProjectsTransferConfigsRunsDelete_597965(
    name: "bigquerydatatransferProjectsTransferConfigsRunsDelete",
    meth: HttpMethod.HttpDelete, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{name}",
    validator: validate_BigquerydatatransferProjectsTransferConfigsRunsDelete_597966,
    base: "/", url: url_BigquerydatatransferProjectsTransferConfigsRunsDelete_597967,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsLocationsList_598008 = ref object of OpenApiRestCall_597408
proc url_BigquerydatatransferProjectsLocationsList_598010(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigquerydatatransferProjectsLocationsList_598009(path: JsonNode;
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
  var valid_598011 = path.getOrDefault("name")
  valid_598011 = validateParameter(valid_598011, JString, required = true,
                                 default = nil)
  if valid_598011 != nil:
    section.add "name", valid_598011
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
  var valid_598012 = query.getOrDefault("upload_protocol")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = nil)
  if valid_598012 != nil:
    section.add "upload_protocol", valid_598012
  var valid_598013 = query.getOrDefault("fields")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = nil)
  if valid_598013 != nil:
    section.add "fields", valid_598013
  var valid_598014 = query.getOrDefault("pageToken")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = nil)
  if valid_598014 != nil:
    section.add "pageToken", valid_598014
  var valid_598015 = query.getOrDefault("quotaUser")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "quotaUser", valid_598015
  var valid_598016 = query.getOrDefault("alt")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = newJString("json"))
  if valid_598016 != nil:
    section.add "alt", valid_598016
  var valid_598017 = query.getOrDefault("oauth_token")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "oauth_token", valid_598017
  var valid_598018 = query.getOrDefault("callback")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = nil)
  if valid_598018 != nil:
    section.add "callback", valid_598018
  var valid_598019 = query.getOrDefault("access_token")
  valid_598019 = validateParameter(valid_598019, JString, required = false,
                                 default = nil)
  if valid_598019 != nil:
    section.add "access_token", valid_598019
  var valid_598020 = query.getOrDefault("uploadType")
  valid_598020 = validateParameter(valid_598020, JString, required = false,
                                 default = nil)
  if valid_598020 != nil:
    section.add "uploadType", valid_598020
  var valid_598021 = query.getOrDefault("key")
  valid_598021 = validateParameter(valid_598021, JString, required = false,
                                 default = nil)
  if valid_598021 != nil:
    section.add "key", valid_598021
  var valid_598022 = query.getOrDefault("$.xgafv")
  valid_598022 = validateParameter(valid_598022, JString, required = false,
                                 default = newJString("1"))
  if valid_598022 != nil:
    section.add "$.xgafv", valid_598022
  var valid_598023 = query.getOrDefault("pageSize")
  valid_598023 = validateParameter(valid_598023, JInt, required = false, default = nil)
  if valid_598023 != nil:
    section.add "pageSize", valid_598023
  var valid_598024 = query.getOrDefault("prettyPrint")
  valid_598024 = validateParameter(valid_598024, JBool, required = false,
                                 default = newJBool(true))
  if valid_598024 != nil:
    section.add "prettyPrint", valid_598024
  var valid_598025 = query.getOrDefault("filter")
  valid_598025 = validateParameter(valid_598025, JString, required = false,
                                 default = nil)
  if valid_598025 != nil:
    section.add "filter", valid_598025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598026: Call_BigquerydatatransferProjectsLocationsList_598008;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_598026.validator(path, query, header, formData, body)
  let scheme = call_598026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598026.url(scheme.get, call_598026.host, call_598026.base,
                         call_598026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598026, url, valid)

proc call*(call_598027: Call_BigquerydatatransferProjectsLocationsList_598008;
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
  var path_598028 = newJObject()
  var query_598029 = newJObject()
  add(query_598029, "upload_protocol", newJString(uploadProtocol))
  add(query_598029, "fields", newJString(fields))
  add(query_598029, "pageToken", newJString(pageToken))
  add(query_598029, "quotaUser", newJString(quotaUser))
  add(path_598028, "name", newJString(name))
  add(query_598029, "alt", newJString(alt))
  add(query_598029, "oauth_token", newJString(oauthToken))
  add(query_598029, "callback", newJString(callback))
  add(query_598029, "access_token", newJString(accessToken))
  add(query_598029, "uploadType", newJString(uploadType))
  add(query_598029, "key", newJString(key))
  add(query_598029, "$.xgafv", newJString(Xgafv))
  add(query_598029, "pageSize", newJInt(pageSize))
  add(query_598029, "prettyPrint", newJBool(prettyPrint))
  add(query_598029, "filter", newJString(filter))
  result = call_598027.call(path_598028, query_598029, nil, nil, nil)

var bigquerydatatransferProjectsLocationsList* = Call_BigquerydatatransferProjectsLocationsList_598008(
    name: "bigquerydatatransferProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "bigquerydatatransfer.googleapis.com", route: "/v1/{name}/locations",
    validator: validate_BigquerydatatransferProjectsLocationsList_598009,
    base: "/", url: url_BigquerydatatransferProjectsLocationsList_598010,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsDataSourcesCheckValidCreds_598030 = ref object of OpenApiRestCall_597408
proc url_BigquerydatatransferProjectsDataSourcesCheckValidCreds_598032(
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
               (kind: ConstantSegment, value: ":checkValidCreds")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigquerydatatransferProjectsDataSourcesCheckValidCreds_598031(
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
  var valid_598033 = path.getOrDefault("name")
  valid_598033 = validateParameter(valid_598033, JString, required = true,
                                 default = nil)
  if valid_598033 != nil:
    section.add "name", valid_598033
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
  var valid_598034 = query.getOrDefault("upload_protocol")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = nil)
  if valid_598034 != nil:
    section.add "upload_protocol", valid_598034
  var valid_598035 = query.getOrDefault("fields")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = nil)
  if valid_598035 != nil:
    section.add "fields", valid_598035
  var valid_598036 = query.getOrDefault("quotaUser")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = nil)
  if valid_598036 != nil:
    section.add "quotaUser", valid_598036
  var valid_598037 = query.getOrDefault("alt")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = newJString("json"))
  if valid_598037 != nil:
    section.add "alt", valid_598037
  var valid_598038 = query.getOrDefault("oauth_token")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = nil)
  if valid_598038 != nil:
    section.add "oauth_token", valid_598038
  var valid_598039 = query.getOrDefault("callback")
  valid_598039 = validateParameter(valid_598039, JString, required = false,
                                 default = nil)
  if valid_598039 != nil:
    section.add "callback", valid_598039
  var valid_598040 = query.getOrDefault("access_token")
  valid_598040 = validateParameter(valid_598040, JString, required = false,
                                 default = nil)
  if valid_598040 != nil:
    section.add "access_token", valid_598040
  var valid_598041 = query.getOrDefault("uploadType")
  valid_598041 = validateParameter(valid_598041, JString, required = false,
                                 default = nil)
  if valid_598041 != nil:
    section.add "uploadType", valid_598041
  var valid_598042 = query.getOrDefault("key")
  valid_598042 = validateParameter(valid_598042, JString, required = false,
                                 default = nil)
  if valid_598042 != nil:
    section.add "key", valid_598042
  var valid_598043 = query.getOrDefault("$.xgafv")
  valid_598043 = validateParameter(valid_598043, JString, required = false,
                                 default = newJString("1"))
  if valid_598043 != nil:
    section.add "$.xgafv", valid_598043
  var valid_598044 = query.getOrDefault("prettyPrint")
  valid_598044 = validateParameter(valid_598044, JBool, required = false,
                                 default = newJBool(true))
  if valid_598044 != nil:
    section.add "prettyPrint", valid_598044
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

proc call*(call_598046: Call_BigquerydatatransferProjectsDataSourcesCheckValidCreds_598030;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns true if valid credentials exist for the given data source and
  ## requesting user.
  ## Some data sources doesn't support service account, so we need to talk to
  ## them on behalf of the end user. This API just checks whether we have OAuth
  ## token for the particular user, which is a pre-requisite before user can
  ## create a transfer config.
  ## 
  let valid = call_598046.validator(path, query, header, formData, body)
  let scheme = call_598046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598046.url(scheme.get, call_598046.host, call_598046.base,
                         call_598046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598046, url, valid)

proc call*(call_598047: Call_BigquerydatatransferProjectsDataSourcesCheckValidCreds_598030;
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
  var path_598048 = newJObject()
  var query_598049 = newJObject()
  var body_598050 = newJObject()
  add(query_598049, "upload_protocol", newJString(uploadProtocol))
  add(query_598049, "fields", newJString(fields))
  add(query_598049, "quotaUser", newJString(quotaUser))
  add(path_598048, "name", newJString(name))
  add(query_598049, "alt", newJString(alt))
  add(query_598049, "oauth_token", newJString(oauthToken))
  add(query_598049, "callback", newJString(callback))
  add(query_598049, "access_token", newJString(accessToken))
  add(query_598049, "uploadType", newJString(uploadType))
  add(query_598049, "key", newJString(key))
  add(query_598049, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598050 = body
  add(query_598049, "prettyPrint", newJBool(prettyPrint))
  result = call_598047.call(path_598048, query_598049, nil, nil, body_598050)

var bigquerydatatransferProjectsDataSourcesCheckValidCreds* = Call_BigquerydatatransferProjectsDataSourcesCheckValidCreds_598030(
    name: "bigquerydatatransferProjectsDataSourcesCheckValidCreds",
    meth: HttpMethod.HttpPost, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{name}:checkValidCreds",
    validator: validate_BigquerydatatransferProjectsDataSourcesCheckValidCreds_598031,
    base: "/", url: url_BigquerydatatransferProjectsDataSourcesCheckValidCreds_598032,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsDataSourcesList_598051 = ref object of OpenApiRestCall_597408
proc url_BigquerydatatransferProjectsDataSourcesList_598053(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigquerydatatransferProjectsDataSourcesList_598052(path: JsonNode;
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
  var valid_598054 = path.getOrDefault("parent")
  valid_598054 = validateParameter(valid_598054, JString, required = true,
                                 default = nil)
  if valid_598054 != nil:
    section.add "parent", valid_598054
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
  var valid_598055 = query.getOrDefault("upload_protocol")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = nil)
  if valid_598055 != nil:
    section.add "upload_protocol", valid_598055
  var valid_598056 = query.getOrDefault("fields")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = nil)
  if valid_598056 != nil:
    section.add "fields", valid_598056
  var valid_598057 = query.getOrDefault("pageToken")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = nil)
  if valid_598057 != nil:
    section.add "pageToken", valid_598057
  var valid_598058 = query.getOrDefault("quotaUser")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = nil)
  if valid_598058 != nil:
    section.add "quotaUser", valid_598058
  var valid_598059 = query.getOrDefault("alt")
  valid_598059 = validateParameter(valid_598059, JString, required = false,
                                 default = newJString("json"))
  if valid_598059 != nil:
    section.add "alt", valid_598059
  var valid_598060 = query.getOrDefault("oauth_token")
  valid_598060 = validateParameter(valid_598060, JString, required = false,
                                 default = nil)
  if valid_598060 != nil:
    section.add "oauth_token", valid_598060
  var valid_598061 = query.getOrDefault("callback")
  valid_598061 = validateParameter(valid_598061, JString, required = false,
                                 default = nil)
  if valid_598061 != nil:
    section.add "callback", valid_598061
  var valid_598062 = query.getOrDefault("access_token")
  valid_598062 = validateParameter(valid_598062, JString, required = false,
                                 default = nil)
  if valid_598062 != nil:
    section.add "access_token", valid_598062
  var valid_598063 = query.getOrDefault("uploadType")
  valid_598063 = validateParameter(valid_598063, JString, required = false,
                                 default = nil)
  if valid_598063 != nil:
    section.add "uploadType", valid_598063
  var valid_598064 = query.getOrDefault("key")
  valid_598064 = validateParameter(valid_598064, JString, required = false,
                                 default = nil)
  if valid_598064 != nil:
    section.add "key", valid_598064
  var valid_598065 = query.getOrDefault("$.xgafv")
  valid_598065 = validateParameter(valid_598065, JString, required = false,
                                 default = newJString("1"))
  if valid_598065 != nil:
    section.add "$.xgafv", valid_598065
  var valid_598066 = query.getOrDefault("pageSize")
  valid_598066 = validateParameter(valid_598066, JInt, required = false, default = nil)
  if valid_598066 != nil:
    section.add "pageSize", valid_598066
  var valid_598067 = query.getOrDefault("prettyPrint")
  valid_598067 = validateParameter(valid_598067, JBool, required = false,
                                 default = newJBool(true))
  if valid_598067 != nil:
    section.add "prettyPrint", valid_598067
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598068: Call_BigquerydatatransferProjectsDataSourcesList_598051;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists supported data sources and returns their settings,
  ## which can be used for UI rendering.
  ## 
  let valid = call_598068.validator(path, query, header, formData, body)
  let scheme = call_598068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598068.url(scheme.get, call_598068.host, call_598068.base,
                         call_598068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598068, url, valid)

proc call*(call_598069: Call_BigquerydatatransferProjectsDataSourcesList_598051;
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
  var path_598070 = newJObject()
  var query_598071 = newJObject()
  add(query_598071, "upload_protocol", newJString(uploadProtocol))
  add(query_598071, "fields", newJString(fields))
  add(query_598071, "pageToken", newJString(pageToken))
  add(query_598071, "quotaUser", newJString(quotaUser))
  add(query_598071, "alt", newJString(alt))
  add(query_598071, "oauth_token", newJString(oauthToken))
  add(query_598071, "callback", newJString(callback))
  add(query_598071, "access_token", newJString(accessToken))
  add(query_598071, "uploadType", newJString(uploadType))
  add(path_598070, "parent", newJString(parent))
  add(query_598071, "key", newJString(key))
  add(query_598071, "$.xgafv", newJString(Xgafv))
  add(query_598071, "pageSize", newJInt(pageSize))
  add(query_598071, "prettyPrint", newJBool(prettyPrint))
  result = call_598069.call(path_598070, query_598071, nil, nil, nil)

var bigquerydatatransferProjectsDataSourcesList* = Call_BigquerydatatransferProjectsDataSourcesList_598051(
    name: "bigquerydatatransferProjectsDataSourcesList", meth: HttpMethod.HttpGet,
    host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}/dataSources",
    validator: validate_BigquerydatatransferProjectsDataSourcesList_598052,
    base: "/", url: url_BigquerydatatransferProjectsDataSourcesList_598053,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsRunsList_598072 = ref object of OpenApiRestCall_597408
proc url_BigquerydatatransferProjectsTransferConfigsRunsList_598074(
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
               (kind: ConstantSegment, value: "/runs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigquerydatatransferProjectsTransferConfigsRunsList_598073(
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
  var valid_598075 = path.getOrDefault("parent")
  valid_598075 = validateParameter(valid_598075, JString, required = true,
                                 default = nil)
  if valid_598075 != nil:
    section.add "parent", valid_598075
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
  var valid_598076 = query.getOrDefault("upload_protocol")
  valid_598076 = validateParameter(valid_598076, JString, required = false,
                                 default = nil)
  if valid_598076 != nil:
    section.add "upload_protocol", valid_598076
  var valid_598077 = query.getOrDefault("fields")
  valid_598077 = validateParameter(valid_598077, JString, required = false,
                                 default = nil)
  if valid_598077 != nil:
    section.add "fields", valid_598077
  var valid_598078 = query.getOrDefault("pageToken")
  valid_598078 = validateParameter(valid_598078, JString, required = false,
                                 default = nil)
  if valid_598078 != nil:
    section.add "pageToken", valid_598078
  var valid_598079 = query.getOrDefault("quotaUser")
  valid_598079 = validateParameter(valid_598079, JString, required = false,
                                 default = nil)
  if valid_598079 != nil:
    section.add "quotaUser", valid_598079
  var valid_598080 = query.getOrDefault("alt")
  valid_598080 = validateParameter(valid_598080, JString, required = false,
                                 default = newJString("json"))
  if valid_598080 != nil:
    section.add "alt", valid_598080
  var valid_598081 = query.getOrDefault("oauth_token")
  valid_598081 = validateParameter(valid_598081, JString, required = false,
                                 default = nil)
  if valid_598081 != nil:
    section.add "oauth_token", valid_598081
  var valid_598082 = query.getOrDefault("callback")
  valid_598082 = validateParameter(valid_598082, JString, required = false,
                                 default = nil)
  if valid_598082 != nil:
    section.add "callback", valid_598082
  var valid_598083 = query.getOrDefault("access_token")
  valid_598083 = validateParameter(valid_598083, JString, required = false,
                                 default = nil)
  if valid_598083 != nil:
    section.add "access_token", valid_598083
  var valid_598084 = query.getOrDefault("uploadType")
  valid_598084 = validateParameter(valid_598084, JString, required = false,
                                 default = nil)
  if valid_598084 != nil:
    section.add "uploadType", valid_598084
  var valid_598085 = query.getOrDefault("key")
  valid_598085 = validateParameter(valid_598085, JString, required = false,
                                 default = nil)
  if valid_598085 != nil:
    section.add "key", valid_598085
  var valid_598086 = query.getOrDefault("states")
  valid_598086 = validateParameter(valid_598086, JArray, required = false,
                                 default = nil)
  if valid_598086 != nil:
    section.add "states", valid_598086
  var valid_598087 = query.getOrDefault("$.xgafv")
  valid_598087 = validateParameter(valid_598087, JString, required = false,
                                 default = newJString("1"))
  if valid_598087 != nil:
    section.add "$.xgafv", valid_598087
  var valid_598088 = query.getOrDefault("pageSize")
  valid_598088 = validateParameter(valid_598088, JInt, required = false, default = nil)
  if valid_598088 != nil:
    section.add "pageSize", valid_598088
  var valid_598089 = query.getOrDefault("runAttempt")
  valid_598089 = validateParameter(valid_598089, JString, required = false, default = newJString(
      "RUN_ATTEMPT_UNSPECIFIED"))
  if valid_598089 != nil:
    section.add "runAttempt", valid_598089
  var valid_598090 = query.getOrDefault("prettyPrint")
  valid_598090 = validateParameter(valid_598090, JBool, required = false,
                                 default = newJBool(true))
  if valid_598090 != nil:
    section.add "prettyPrint", valid_598090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598091: Call_BigquerydatatransferProjectsTransferConfigsRunsList_598072;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about running and completed jobs.
  ## 
  let valid = call_598091.validator(path, query, header, formData, body)
  let scheme = call_598091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598091.url(scheme.get, call_598091.host, call_598091.base,
                         call_598091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598091, url, valid)

proc call*(call_598092: Call_BigquerydatatransferProjectsTransferConfigsRunsList_598072;
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
  var path_598093 = newJObject()
  var query_598094 = newJObject()
  add(query_598094, "upload_protocol", newJString(uploadProtocol))
  add(query_598094, "fields", newJString(fields))
  add(query_598094, "pageToken", newJString(pageToken))
  add(query_598094, "quotaUser", newJString(quotaUser))
  add(query_598094, "alt", newJString(alt))
  add(query_598094, "oauth_token", newJString(oauthToken))
  add(query_598094, "callback", newJString(callback))
  add(query_598094, "access_token", newJString(accessToken))
  add(query_598094, "uploadType", newJString(uploadType))
  add(path_598093, "parent", newJString(parent))
  add(query_598094, "key", newJString(key))
  if states != nil:
    query_598094.add "states", states
  add(query_598094, "$.xgafv", newJString(Xgafv))
  add(query_598094, "pageSize", newJInt(pageSize))
  add(query_598094, "runAttempt", newJString(runAttempt))
  add(query_598094, "prettyPrint", newJBool(prettyPrint))
  result = call_598092.call(path_598093, query_598094, nil, nil, nil)

var bigquerydatatransferProjectsTransferConfigsRunsList* = Call_BigquerydatatransferProjectsTransferConfigsRunsList_598072(
    name: "bigquerydatatransferProjectsTransferConfigsRunsList",
    meth: HttpMethod.HttpGet, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}/runs",
    validator: validate_BigquerydatatransferProjectsTransferConfigsRunsList_598073,
    base: "/", url: url_BigquerydatatransferProjectsTransferConfigsRunsList_598074,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsCreate_598117 = ref object of OpenApiRestCall_597408
proc url_BigquerydatatransferProjectsTransferConfigsCreate_598119(
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
               (kind: ConstantSegment, value: "/transferConfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigquerydatatransferProjectsTransferConfigsCreate_598118(
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
  var valid_598120 = path.getOrDefault("parent")
  valid_598120 = validateParameter(valid_598120, JString, required = true,
                                 default = nil)
  if valid_598120 != nil:
    section.add "parent", valid_598120
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
  var valid_598121 = query.getOrDefault("upload_protocol")
  valid_598121 = validateParameter(valid_598121, JString, required = false,
                                 default = nil)
  if valid_598121 != nil:
    section.add "upload_protocol", valid_598121
  var valid_598122 = query.getOrDefault("authorizationCode")
  valid_598122 = validateParameter(valid_598122, JString, required = false,
                                 default = nil)
  if valid_598122 != nil:
    section.add "authorizationCode", valid_598122
  var valid_598123 = query.getOrDefault("fields")
  valid_598123 = validateParameter(valid_598123, JString, required = false,
                                 default = nil)
  if valid_598123 != nil:
    section.add "fields", valid_598123
  var valid_598124 = query.getOrDefault("quotaUser")
  valid_598124 = validateParameter(valid_598124, JString, required = false,
                                 default = nil)
  if valid_598124 != nil:
    section.add "quotaUser", valid_598124
  var valid_598125 = query.getOrDefault("alt")
  valid_598125 = validateParameter(valid_598125, JString, required = false,
                                 default = newJString("json"))
  if valid_598125 != nil:
    section.add "alt", valid_598125
  var valid_598126 = query.getOrDefault("oauth_token")
  valid_598126 = validateParameter(valid_598126, JString, required = false,
                                 default = nil)
  if valid_598126 != nil:
    section.add "oauth_token", valid_598126
  var valid_598127 = query.getOrDefault("callback")
  valid_598127 = validateParameter(valid_598127, JString, required = false,
                                 default = nil)
  if valid_598127 != nil:
    section.add "callback", valid_598127
  var valid_598128 = query.getOrDefault("access_token")
  valid_598128 = validateParameter(valid_598128, JString, required = false,
                                 default = nil)
  if valid_598128 != nil:
    section.add "access_token", valid_598128
  var valid_598129 = query.getOrDefault("uploadType")
  valid_598129 = validateParameter(valid_598129, JString, required = false,
                                 default = nil)
  if valid_598129 != nil:
    section.add "uploadType", valid_598129
  var valid_598130 = query.getOrDefault("versionInfo")
  valid_598130 = validateParameter(valid_598130, JString, required = false,
                                 default = nil)
  if valid_598130 != nil:
    section.add "versionInfo", valid_598130
  var valid_598131 = query.getOrDefault("key")
  valid_598131 = validateParameter(valid_598131, JString, required = false,
                                 default = nil)
  if valid_598131 != nil:
    section.add "key", valid_598131
  var valid_598132 = query.getOrDefault("$.xgafv")
  valid_598132 = validateParameter(valid_598132, JString, required = false,
                                 default = newJString("1"))
  if valid_598132 != nil:
    section.add "$.xgafv", valid_598132
  var valid_598133 = query.getOrDefault("prettyPrint")
  valid_598133 = validateParameter(valid_598133, JBool, required = false,
                                 default = newJBool(true))
  if valid_598133 != nil:
    section.add "prettyPrint", valid_598133
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

proc call*(call_598135: Call_BigquerydatatransferProjectsTransferConfigsCreate_598117;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new data transfer configuration.
  ## 
  let valid = call_598135.validator(path, query, header, formData, body)
  let scheme = call_598135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598135.url(scheme.get, call_598135.host, call_598135.base,
                         call_598135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598135, url, valid)

proc call*(call_598136: Call_BigquerydatatransferProjectsTransferConfigsCreate_598117;
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
  var path_598137 = newJObject()
  var query_598138 = newJObject()
  var body_598139 = newJObject()
  add(query_598138, "upload_protocol", newJString(uploadProtocol))
  add(query_598138, "authorizationCode", newJString(authorizationCode))
  add(query_598138, "fields", newJString(fields))
  add(query_598138, "quotaUser", newJString(quotaUser))
  add(query_598138, "alt", newJString(alt))
  add(query_598138, "oauth_token", newJString(oauthToken))
  add(query_598138, "callback", newJString(callback))
  add(query_598138, "access_token", newJString(accessToken))
  add(query_598138, "uploadType", newJString(uploadType))
  add(path_598137, "parent", newJString(parent))
  add(query_598138, "versionInfo", newJString(versionInfo))
  add(query_598138, "key", newJString(key))
  add(query_598138, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598139 = body
  add(query_598138, "prettyPrint", newJBool(prettyPrint))
  result = call_598136.call(path_598137, query_598138, nil, nil, body_598139)

var bigquerydatatransferProjectsTransferConfigsCreate* = Call_BigquerydatatransferProjectsTransferConfigsCreate_598117(
    name: "bigquerydatatransferProjectsTransferConfigsCreate",
    meth: HttpMethod.HttpPost, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}/transferConfigs",
    validator: validate_BigquerydatatransferProjectsTransferConfigsCreate_598118,
    base: "/", url: url_BigquerydatatransferProjectsTransferConfigsCreate_598119,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsList_598095 = ref object of OpenApiRestCall_597408
proc url_BigquerydatatransferProjectsTransferConfigsList_598097(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigquerydatatransferProjectsTransferConfigsList_598096(
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
  var valid_598098 = path.getOrDefault("parent")
  valid_598098 = validateParameter(valid_598098, JString, required = true,
                                 default = nil)
  if valid_598098 != nil:
    section.add "parent", valid_598098
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
  var valid_598099 = query.getOrDefault("upload_protocol")
  valid_598099 = validateParameter(valid_598099, JString, required = false,
                                 default = nil)
  if valid_598099 != nil:
    section.add "upload_protocol", valid_598099
  var valid_598100 = query.getOrDefault("fields")
  valid_598100 = validateParameter(valid_598100, JString, required = false,
                                 default = nil)
  if valid_598100 != nil:
    section.add "fields", valid_598100
  var valid_598101 = query.getOrDefault("pageToken")
  valid_598101 = validateParameter(valid_598101, JString, required = false,
                                 default = nil)
  if valid_598101 != nil:
    section.add "pageToken", valid_598101
  var valid_598102 = query.getOrDefault("quotaUser")
  valid_598102 = validateParameter(valid_598102, JString, required = false,
                                 default = nil)
  if valid_598102 != nil:
    section.add "quotaUser", valid_598102
  var valid_598103 = query.getOrDefault("alt")
  valid_598103 = validateParameter(valid_598103, JString, required = false,
                                 default = newJString("json"))
  if valid_598103 != nil:
    section.add "alt", valid_598103
  var valid_598104 = query.getOrDefault("oauth_token")
  valid_598104 = validateParameter(valid_598104, JString, required = false,
                                 default = nil)
  if valid_598104 != nil:
    section.add "oauth_token", valid_598104
  var valid_598105 = query.getOrDefault("callback")
  valid_598105 = validateParameter(valid_598105, JString, required = false,
                                 default = nil)
  if valid_598105 != nil:
    section.add "callback", valid_598105
  var valid_598106 = query.getOrDefault("access_token")
  valid_598106 = validateParameter(valid_598106, JString, required = false,
                                 default = nil)
  if valid_598106 != nil:
    section.add "access_token", valid_598106
  var valid_598107 = query.getOrDefault("uploadType")
  valid_598107 = validateParameter(valid_598107, JString, required = false,
                                 default = nil)
  if valid_598107 != nil:
    section.add "uploadType", valid_598107
  var valid_598108 = query.getOrDefault("key")
  valid_598108 = validateParameter(valid_598108, JString, required = false,
                                 default = nil)
  if valid_598108 != nil:
    section.add "key", valid_598108
  var valid_598109 = query.getOrDefault("$.xgafv")
  valid_598109 = validateParameter(valid_598109, JString, required = false,
                                 default = newJString("1"))
  if valid_598109 != nil:
    section.add "$.xgafv", valid_598109
  var valid_598110 = query.getOrDefault("pageSize")
  valid_598110 = validateParameter(valid_598110, JInt, required = false, default = nil)
  if valid_598110 != nil:
    section.add "pageSize", valid_598110
  var valid_598111 = query.getOrDefault("dataSourceIds")
  valid_598111 = validateParameter(valid_598111, JArray, required = false,
                                 default = nil)
  if valid_598111 != nil:
    section.add "dataSourceIds", valid_598111
  var valid_598112 = query.getOrDefault("prettyPrint")
  valid_598112 = validateParameter(valid_598112, JBool, required = false,
                                 default = newJBool(true))
  if valid_598112 != nil:
    section.add "prettyPrint", valid_598112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598113: Call_BigquerydatatransferProjectsTransferConfigsList_598095;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns information about all data transfers in the project.
  ## 
  let valid = call_598113.validator(path, query, header, formData, body)
  let scheme = call_598113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598113.url(scheme.get, call_598113.host, call_598113.base,
                         call_598113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598113, url, valid)

proc call*(call_598114: Call_BigquerydatatransferProjectsTransferConfigsList_598095;
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
  var path_598115 = newJObject()
  var query_598116 = newJObject()
  add(query_598116, "upload_protocol", newJString(uploadProtocol))
  add(query_598116, "fields", newJString(fields))
  add(query_598116, "pageToken", newJString(pageToken))
  add(query_598116, "quotaUser", newJString(quotaUser))
  add(query_598116, "alt", newJString(alt))
  add(query_598116, "oauth_token", newJString(oauthToken))
  add(query_598116, "callback", newJString(callback))
  add(query_598116, "access_token", newJString(accessToken))
  add(query_598116, "uploadType", newJString(uploadType))
  add(path_598115, "parent", newJString(parent))
  add(query_598116, "key", newJString(key))
  add(query_598116, "$.xgafv", newJString(Xgafv))
  add(query_598116, "pageSize", newJInt(pageSize))
  if dataSourceIds != nil:
    query_598116.add "dataSourceIds", dataSourceIds
  add(query_598116, "prettyPrint", newJBool(prettyPrint))
  result = call_598114.call(path_598115, query_598116, nil, nil, nil)

var bigquerydatatransferProjectsTransferConfigsList* = Call_BigquerydatatransferProjectsTransferConfigsList_598095(
    name: "bigquerydatatransferProjectsTransferConfigsList",
    meth: HttpMethod.HttpGet, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}/transferConfigs",
    validator: validate_BigquerydatatransferProjectsTransferConfigsList_598096,
    base: "/", url: url_BigquerydatatransferProjectsTransferConfigsList_598097,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_598140 = ref object of OpenApiRestCall_597408
proc url_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_598142(
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
               (kind: ConstantSegment, value: "/transferLogs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_598141(
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
  var valid_598143 = path.getOrDefault("parent")
  valid_598143 = validateParameter(valid_598143, JString, required = true,
                                 default = nil)
  if valid_598143 != nil:
    section.add "parent", valid_598143
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
  var valid_598144 = query.getOrDefault("upload_protocol")
  valid_598144 = validateParameter(valid_598144, JString, required = false,
                                 default = nil)
  if valid_598144 != nil:
    section.add "upload_protocol", valid_598144
  var valid_598145 = query.getOrDefault("fields")
  valid_598145 = validateParameter(valid_598145, JString, required = false,
                                 default = nil)
  if valid_598145 != nil:
    section.add "fields", valid_598145
  var valid_598146 = query.getOrDefault("pageToken")
  valid_598146 = validateParameter(valid_598146, JString, required = false,
                                 default = nil)
  if valid_598146 != nil:
    section.add "pageToken", valid_598146
  var valid_598147 = query.getOrDefault("quotaUser")
  valid_598147 = validateParameter(valid_598147, JString, required = false,
                                 default = nil)
  if valid_598147 != nil:
    section.add "quotaUser", valid_598147
  var valid_598148 = query.getOrDefault("alt")
  valid_598148 = validateParameter(valid_598148, JString, required = false,
                                 default = newJString("json"))
  if valid_598148 != nil:
    section.add "alt", valid_598148
  var valid_598149 = query.getOrDefault("oauth_token")
  valid_598149 = validateParameter(valid_598149, JString, required = false,
                                 default = nil)
  if valid_598149 != nil:
    section.add "oauth_token", valid_598149
  var valid_598150 = query.getOrDefault("callback")
  valid_598150 = validateParameter(valid_598150, JString, required = false,
                                 default = nil)
  if valid_598150 != nil:
    section.add "callback", valid_598150
  var valid_598151 = query.getOrDefault("access_token")
  valid_598151 = validateParameter(valid_598151, JString, required = false,
                                 default = nil)
  if valid_598151 != nil:
    section.add "access_token", valid_598151
  var valid_598152 = query.getOrDefault("uploadType")
  valid_598152 = validateParameter(valid_598152, JString, required = false,
                                 default = nil)
  if valid_598152 != nil:
    section.add "uploadType", valid_598152
  var valid_598153 = query.getOrDefault("key")
  valid_598153 = validateParameter(valid_598153, JString, required = false,
                                 default = nil)
  if valid_598153 != nil:
    section.add "key", valid_598153
  var valid_598154 = query.getOrDefault("$.xgafv")
  valid_598154 = validateParameter(valid_598154, JString, required = false,
                                 default = newJString("1"))
  if valid_598154 != nil:
    section.add "$.xgafv", valid_598154
  var valid_598155 = query.getOrDefault("pageSize")
  valid_598155 = validateParameter(valid_598155, JInt, required = false, default = nil)
  if valid_598155 != nil:
    section.add "pageSize", valid_598155
  var valid_598156 = query.getOrDefault("messageTypes")
  valid_598156 = validateParameter(valid_598156, JArray, required = false,
                                 default = nil)
  if valid_598156 != nil:
    section.add "messageTypes", valid_598156
  var valid_598157 = query.getOrDefault("prettyPrint")
  valid_598157 = validateParameter(valid_598157, JBool, required = false,
                                 default = newJBool(true))
  if valid_598157 != nil:
    section.add "prettyPrint", valid_598157
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598158: Call_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_598140;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns user facing log messages for the data transfer run.
  ## 
  let valid = call_598158.validator(path, query, header, formData, body)
  let scheme = call_598158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598158.url(scheme.get, call_598158.host, call_598158.base,
                         call_598158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598158, url, valid)

proc call*(call_598159: Call_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_598140;
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
  var path_598160 = newJObject()
  var query_598161 = newJObject()
  add(query_598161, "upload_protocol", newJString(uploadProtocol))
  add(query_598161, "fields", newJString(fields))
  add(query_598161, "pageToken", newJString(pageToken))
  add(query_598161, "quotaUser", newJString(quotaUser))
  add(query_598161, "alt", newJString(alt))
  add(query_598161, "oauth_token", newJString(oauthToken))
  add(query_598161, "callback", newJString(callback))
  add(query_598161, "access_token", newJString(accessToken))
  add(query_598161, "uploadType", newJString(uploadType))
  add(path_598160, "parent", newJString(parent))
  add(query_598161, "key", newJString(key))
  add(query_598161, "$.xgafv", newJString(Xgafv))
  add(query_598161, "pageSize", newJInt(pageSize))
  if messageTypes != nil:
    query_598161.add "messageTypes", messageTypes
  add(query_598161, "prettyPrint", newJBool(prettyPrint))
  result = call_598159.call(path_598160, query_598161, nil, nil, nil)

var bigquerydatatransferProjectsTransferConfigsRunsTransferLogsList* = Call_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_598140(
    name: "bigquerydatatransferProjectsTransferConfigsRunsTransferLogsList",
    meth: HttpMethod.HttpGet, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}/transferLogs", validator: validate_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_598141,
    base: "/",
    url: url_BigquerydatatransferProjectsTransferConfigsRunsTransferLogsList_598142,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsScheduleRuns_598162 = ref object of OpenApiRestCall_597408
proc url_BigquerydatatransferProjectsTransferConfigsScheduleRuns_598164(
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
               (kind: ConstantSegment, value: ":scheduleRuns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigquerydatatransferProjectsTransferConfigsScheduleRuns_598163(
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
  var valid_598165 = path.getOrDefault("parent")
  valid_598165 = validateParameter(valid_598165, JString, required = true,
                                 default = nil)
  if valid_598165 != nil:
    section.add "parent", valid_598165
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
  var valid_598166 = query.getOrDefault("upload_protocol")
  valid_598166 = validateParameter(valid_598166, JString, required = false,
                                 default = nil)
  if valid_598166 != nil:
    section.add "upload_protocol", valid_598166
  var valid_598167 = query.getOrDefault("fields")
  valid_598167 = validateParameter(valid_598167, JString, required = false,
                                 default = nil)
  if valid_598167 != nil:
    section.add "fields", valid_598167
  var valid_598168 = query.getOrDefault("quotaUser")
  valid_598168 = validateParameter(valid_598168, JString, required = false,
                                 default = nil)
  if valid_598168 != nil:
    section.add "quotaUser", valid_598168
  var valid_598169 = query.getOrDefault("alt")
  valid_598169 = validateParameter(valid_598169, JString, required = false,
                                 default = newJString("json"))
  if valid_598169 != nil:
    section.add "alt", valid_598169
  var valid_598170 = query.getOrDefault("oauth_token")
  valid_598170 = validateParameter(valid_598170, JString, required = false,
                                 default = nil)
  if valid_598170 != nil:
    section.add "oauth_token", valid_598170
  var valid_598171 = query.getOrDefault("callback")
  valid_598171 = validateParameter(valid_598171, JString, required = false,
                                 default = nil)
  if valid_598171 != nil:
    section.add "callback", valid_598171
  var valid_598172 = query.getOrDefault("access_token")
  valid_598172 = validateParameter(valid_598172, JString, required = false,
                                 default = nil)
  if valid_598172 != nil:
    section.add "access_token", valid_598172
  var valid_598173 = query.getOrDefault("uploadType")
  valid_598173 = validateParameter(valid_598173, JString, required = false,
                                 default = nil)
  if valid_598173 != nil:
    section.add "uploadType", valid_598173
  var valid_598174 = query.getOrDefault("key")
  valid_598174 = validateParameter(valid_598174, JString, required = false,
                                 default = nil)
  if valid_598174 != nil:
    section.add "key", valid_598174
  var valid_598175 = query.getOrDefault("$.xgafv")
  valid_598175 = validateParameter(valid_598175, JString, required = false,
                                 default = newJString("1"))
  if valid_598175 != nil:
    section.add "$.xgafv", valid_598175
  var valid_598176 = query.getOrDefault("prettyPrint")
  valid_598176 = validateParameter(valid_598176, JBool, required = false,
                                 default = newJBool(true))
  if valid_598176 != nil:
    section.add "prettyPrint", valid_598176
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

proc call*(call_598178: Call_BigquerydatatransferProjectsTransferConfigsScheduleRuns_598162;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates transfer runs for a time range [start_time, end_time].
  ## For each date - or whatever granularity the data source supports - in the
  ## range, one transfer run is created.
  ## Note that runs are created per UTC time in the time range.
  ## DEPRECATED: use StartManualTransferRuns instead.
  ## 
  let valid = call_598178.validator(path, query, header, formData, body)
  let scheme = call_598178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598178.url(scheme.get, call_598178.host, call_598178.base,
                         call_598178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598178, url, valid)

proc call*(call_598179: Call_BigquerydatatransferProjectsTransferConfigsScheduleRuns_598162;
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
  var path_598180 = newJObject()
  var query_598181 = newJObject()
  var body_598182 = newJObject()
  add(query_598181, "upload_protocol", newJString(uploadProtocol))
  add(query_598181, "fields", newJString(fields))
  add(query_598181, "quotaUser", newJString(quotaUser))
  add(query_598181, "alt", newJString(alt))
  add(query_598181, "oauth_token", newJString(oauthToken))
  add(query_598181, "callback", newJString(callback))
  add(query_598181, "access_token", newJString(accessToken))
  add(query_598181, "uploadType", newJString(uploadType))
  add(path_598180, "parent", newJString(parent))
  add(query_598181, "key", newJString(key))
  add(query_598181, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598182 = body
  add(query_598181, "prettyPrint", newJBool(prettyPrint))
  result = call_598179.call(path_598180, query_598181, nil, nil, body_598182)

var bigquerydatatransferProjectsTransferConfigsScheduleRuns* = Call_BigquerydatatransferProjectsTransferConfigsScheduleRuns_598162(
    name: "bigquerydatatransferProjectsTransferConfigsScheduleRuns",
    meth: HttpMethod.HttpPost, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}:scheduleRuns", validator: validate_BigquerydatatransferProjectsTransferConfigsScheduleRuns_598163,
    base: "/", url: url_BigquerydatatransferProjectsTransferConfigsScheduleRuns_598164,
    schemes: {Scheme.Https})
type
  Call_BigquerydatatransferProjectsTransferConfigsStartManualRuns_598183 = ref object of OpenApiRestCall_597408
proc url_BigquerydatatransferProjectsTransferConfigsStartManualRuns_598185(
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
               (kind: ConstantSegment, value: ":startManualRuns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigquerydatatransferProjectsTransferConfigsStartManualRuns_598184(
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
  var valid_598186 = path.getOrDefault("parent")
  valid_598186 = validateParameter(valid_598186, JString, required = true,
                                 default = nil)
  if valid_598186 != nil:
    section.add "parent", valid_598186
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
  var valid_598187 = query.getOrDefault("upload_protocol")
  valid_598187 = validateParameter(valid_598187, JString, required = false,
                                 default = nil)
  if valid_598187 != nil:
    section.add "upload_protocol", valid_598187
  var valid_598188 = query.getOrDefault("fields")
  valid_598188 = validateParameter(valid_598188, JString, required = false,
                                 default = nil)
  if valid_598188 != nil:
    section.add "fields", valid_598188
  var valid_598189 = query.getOrDefault("quotaUser")
  valid_598189 = validateParameter(valid_598189, JString, required = false,
                                 default = nil)
  if valid_598189 != nil:
    section.add "quotaUser", valid_598189
  var valid_598190 = query.getOrDefault("alt")
  valid_598190 = validateParameter(valid_598190, JString, required = false,
                                 default = newJString("json"))
  if valid_598190 != nil:
    section.add "alt", valid_598190
  var valid_598191 = query.getOrDefault("oauth_token")
  valid_598191 = validateParameter(valid_598191, JString, required = false,
                                 default = nil)
  if valid_598191 != nil:
    section.add "oauth_token", valid_598191
  var valid_598192 = query.getOrDefault("callback")
  valid_598192 = validateParameter(valid_598192, JString, required = false,
                                 default = nil)
  if valid_598192 != nil:
    section.add "callback", valid_598192
  var valid_598193 = query.getOrDefault("access_token")
  valid_598193 = validateParameter(valid_598193, JString, required = false,
                                 default = nil)
  if valid_598193 != nil:
    section.add "access_token", valid_598193
  var valid_598194 = query.getOrDefault("uploadType")
  valid_598194 = validateParameter(valid_598194, JString, required = false,
                                 default = nil)
  if valid_598194 != nil:
    section.add "uploadType", valid_598194
  var valid_598195 = query.getOrDefault("key")
  valid_598195 = validateParameter(valid_598195, JString, required = false,
                                 default = nil)
  if valid_598195 != nil:
    section.add "key", valid_598195
  var valid_598196 = query.getOrDefault("$.xgafv")
  valid_598196 = validateParameter(valid_598196, JString, required = false,
                                 default = newJString("1"))
  if valid_598196 != nil:
    section.add "$.xgafv", valid_598196
  var valid_598197 = query.getOrDefault("prettyPrint")
  valid_598197 = validateParameter(valid_598197, JBool, required = false,
                                 default = newJBool(true))
  if valid_598197 != nil:
    section.add "prettyPrint", valid_598197
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

proc call*(call_598199: Call_BigquerydatatransferProjectsTransferConfigsStartManualRuns_598183;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Start manual transfer runs to be executed now with schedule_time equal to
  ## current time. The transfer runs can be created for a time range where the
  ## run_time is between start_time (inclusive) and end_time (exclusive), or for
  ## a specific run_time.
  ## 
  let valid = call_598199.validator(path, query, header, formData, body)
  let scheme = call_598199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598199.url(scheme.get, call_598199.host, call_598199.base,
                         call_598199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598199, url, valid)

proc call*(call_598200: Call_BigquerydatatransferProjectsTransferConfigsStartManualRuns_598183;
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
  var path_598201 = newJObject()
  var query_598202 = newJObject()
  var body_598203 = newJObject()
  add(query_598202, "upload_protocol", newJString(uploadProtocol))
  add(query_598202, "fields", newJString(fields))
  add(query_598202, "quotaUser", newJString(quotaUser))
  add(query_598202, "alt", newJString(alt))
  add(query_598202, "oauth_token", newJString(oauthToken))
  add(query_598202, "callback", newJString(callback))
  add(query_598202, "access_token", newJString(accessToken))
  add(query_598202, "uploadType", newJString(uploadType))
  add(path_598201, "parent", newJString(parent))
  add(query_598202, "key", newJString(key))
  add(query_598202, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598203 = body
  add(query_598202, "prettyPrint", newJBool(prettyPrint))
  result = call_598200.call(path_598201, query_598202, nil, nil, body_598203)

var bigquerydatatransferProjectsTransferConfigsStartManualRuns* = Call_BigquerydatatransferProjectsTransferConfigsStartManualRuns_598183(
    name: "bigquerydatatransferProjectsTransferConfigsStartManualRuns",
    meth: HttpMethod.HttpPost, host: "bigquerydatatransfer.googleapis.com",
    route: "/v1/{parent}:startManualRuns", validator: validate_BigquerydatatransferProjectsTransferConfigsStartManualRuns_598184,
    base: "/",
    url: url_BigquerydatatransferProjectsTransferConfigsStartManualRuns_598185,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
