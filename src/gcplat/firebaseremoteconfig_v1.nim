
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Firebase Remote Config
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Firebase Remote Config API allows the 3P clients to manage Remote Config conditions and parameters for Firebase applications.
## 
## https://firebase.google.com/docs/remote-config/
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
  gcpServiceName = "firebaseremoteconfig"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FirebaseremoteconfigProjectsUpdateRemoteConfig_579967 = ref object of OpenApiRestCall_579408
proc url_FirebaseremoteconfigProjectsUpdateRemoteConfig_579969(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/remoteConfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseremoteconfigProjectsUpdateRemoteConfig_579968(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Update a RemoteConfig. We treat this as an always-existing
  ## resource (when it is not found in our data store, we treat it as version
  ## 0, a template with zero conditions and zero parameters). Hence there are
  ## no Create or Delete operations. Returns the updated template when
  ## successful (and the updated eTag as a response header), or an error if
  ## things go wrong.
  ## Possible error messages:
  ## * VALIDATION_ERROR (HTTP status 400) with additional details if the
  ## template being passed in can not be validated.
  ## * AUTHENTICATION_ERROR (HTTP status 401) if the request can not be
  ## authenticate (e.g. no access token, or invalid access token).
  ## * AUTHORIZATION_ERROR (HTTP status 403) if the request can not be
  ## authorized (e.g. the user has no access to the specified project id).
  ## * VERSION_MISMATCH (HTTP status 412) when trying to update when the
  ## expected eTag (passed in via the "If-match" header) is not specified, or
  ## is specified but does does not match the current eTag.
  ## * Internal error (HTTP status 500) for Database problems or other internal
  ## errors.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The GMP project identifier. Required.
  ## See note at the beginning of this file regarding project ids.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_579970 = path.getOrDefault("project")
  valid_579970 = validateParameter(valid_579970, JString, required = true,
                                 default = nil)
  if valid_579970 != nil:
    section.add "project", valid_579970
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
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   validateOnly: JBool
  ##               : Optional. Defaults to <code>false</code> (UpdateRemoteConfig call should
  ## update the backend if there are no validation/interal errors). May be set
  ## to <code>true</code> to indicate that, should no validation errors occur,
  ## the call should return a "200 OK" instead of performing the update. Note
  ## that other error messages (500 Internal Error, 412 Version Mismatch, etc)
  ## may still result after flipping to <code>false</code>, even if getting a
  ## "200 OK" when calling with <code>true</code>.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_579971 = query.getOrDefault("upload_protocol")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "upload_protocol", valid_579971
  var valid_579972 = query.getOrDefault("fields")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "fields", valid_579972
  var valid_579973 = query.getOrDefault("quotaUser")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "quotaUser", valid_579973
  var valid_579974 = query.getOrDefault("alt")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = newJString("json"))
  if valid_579974 != nil:
    section.add "alt", valid_579974
  var valid_579975 = query.getOrDefault("pp")
  valid_579975 = validateParameter(valid_579975, JBool, required = false,
                                 default = newJBool(true))
  if valid_579975 != nil:
    section.add "pp", valid_579975
  var valid_579976 = query.getOrDefault("oauth_token")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "oauth_token", valid_579976
  var valid_579977 = query.getOrDefault("callback")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "callback", valid_579977
  var valid_579978 = query.getOrDefault("access_token")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "access_token", valid_579978
  var valid_579979 = query.getOrDefault("uploadType")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "uploadType", valid_579979
  var valid_579980 = query.getOrDefault("validateOnly")
  valid_579980 = validateParameter(valid_579980, JBool, required = false, default = nil)
  if valid_579980 != nil:
    section.add "validateOnly", valid_579980
  var valid_579981 = query.getOrDefault("key")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "key", valid_579981
  var valid_579982 = query.getOrDefault("$.xgafv")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = newJString("1"))
  if valid_579982 != nil:
    section.add "$.xgafv", valid_579982
  var valid_579983 = query.getOrDefault("prettyPrint")
  valid_579983 = validateParameter(valid_579983, JBool, required = false,
                                 default = newJBool(true))
  if valid_579983 != nil:
    section.add "prettyPrint", valid_579983
  var valid_579984 = query.getOrDefault("bearer_token")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "bearer_token", valid_579984
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

proc call*(call_579986: Call_FirebaseremoteconfigProjectsUpdateRemoteConfig_579967;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update a RemoteConfig. We treat this as an always-existing
  ## resource (when it is not found in our data store, we treat it as version
  ## 0, a template with zero conditions and zero parameters). Hence there are
  ## no Create or Delete operations. Returns the updated template when
  ## successful (and the updated eTag as a response header), or an error if
  ## things go wrong.
  ## Possible error messages:
  ## * VALIDATION_ERROR (HTTP status 400) with additional details if the
  ## template being passed in can not be validated.
  ## * AUTHENTICATION_ERROR (HTTP status 401) if the request can not be
  ## authenticate (e.g. no access token, or invalid access token).
  ## * AUTHORIZATION_ERROR (HTTP status 403) if the request can not be
  ## authorized (e.g. the user has no access to the specified project id).
  ## * VERSION_MISMATCH (HTTP status 412) when trying to update when the
  ## expected eTag (passed in via the "If-match" header) is not specified, or
  ## is specified but does does not match the current eTag.
  ## * Internal error (HTTP status 500) for Database problems or other internal
  ## errors.
  ## 
  let valid = call_579986.validator(path, query, header, formData, body)
  let scheme = call_579986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579986.url(scheme.get, call_579986.host, call_579986.base,
                         call_579986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579986, url, valid)

proc call*(call_579987: Call_FirebaseremoteconfigProjectsUpdateRemoteConfig_579967;
          project: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; validateOnly: bool = false; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## firebaseremoteconfigProjectsUpdateRemoteConfig
  ## Update a RemoteConfig. We treat this as an always-existing
  ## resource (when it is not found in our data store, we treat it as version
  ## 0, a template with zero conditions and zero parameters). Hence there are
  ## no Create or Delete operations. Returns the updated template when
  ## successful (and the updated eTag as a response header), or an error if
  ## things go wrong.
  ## Possible error messages:
  ## * VALIDATION_ERROR (HTTP status 400) with additional details if the
  ## template being passed in can not be validated.
  ## * AUTHENTICATION_ERROR (HTTP status 401) if the request can not be
  ## authenticate (e.g. no access token, or invalid access token).
  ## * AUTHORIZATION_ERROR (HTTP status 403) if the request can not be
  ## authorized (e.g. the user has no access to the specified project id).
  ## * VERSION_MISMATCH (HTTP status 412) when trying to update when the
  ## expected eTag (passed in via the "If-match" header) is not specified, or
  ## is specified but does does not match the current eTag.
  ## * Internal error (HTTP status 500) for Database problems or other internal
  ## errors.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   validateOnly: bool
  ##               : Optional. Defaults to <code>false</code> (UpdateRemoteConfig call should
  ## update the backend if there are no validation/interal errors). May be set
  ## to <code>true</code> to indicate that, should no validation errors occur,
  ## the call should return a "200 OK" instead of performing the update. Note
  ## that other error messages (500 Internal Error, 412 Version Mismatch, etc)
  ## may still result after flipping to <code>false</code>, even if getting a
  ## "200 OK" when calling with <code>true</code>.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   project: string (required)
  ##          : The GMP project identifier. Required.
  ## See note at the beginning of this file regarding project ids.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_579988 = newJObject()
  var query_579989 = newJObject()
  var body_579990 = newJObject()
  add(query_579989, "upload_protocol", newJString(uploadProtocol))
  add(query_579989, "fields", newJString(fields))
  add(query_579989, "quotaUser", newJString(quotaUser))
  add(query_579989, "alt", newJString(alt))
  add(query_579989, "pp", newJBool(pp))
  add(query_579989, "oauth_token", newJString(oauthToken))
  add(query_579989, "callback", newJString(callback))
  add(query_579989, "access_token", newJString(accessToken))
  add(query_579989, "uploadType", newJString(uploadType))
  add(query_579989, "validateOnly", newJBool(validateOnly))
  add(query_579989, "key", newJString(key))
  add(query_579989, "$.xgafv", newJString(Xgafv))
  add(path_579988, "project", newJString(project))
  if body != nil:
    body_579990 = body
  add(query_579989, "prettyPrint", newJBool(prettyPrint))
  add(query_579989, "bearer_token", newJString(bearerToken))
  result = call_579987.call(path_579988, query_579989, nil, nil, body_579990)

var firebaseremoteconfigProjectsUpdateRemoteConfig* = Call_FirebaseremoteconfigProjectsUpdateRemoteConfig_579967(
    name: "firebaseremoteconfigProjectsUpdateRemoteConfig",
    meth: HttpMethod.HttpPut, host: "firebaseremoteconfig.googleapis.com",
    route: "/v1/{project}/remoteConfig",
    validator: validate_FirebaseremoteconfigProjectsUpdateRemoteConfig_579968,
    base: "/", url: url_FirebaseremoteconfigProjectsUpdateRemoteConfig_579969,
    schemes: {Scheme.Https})
type
  Call_FirebaseremoteconfigProjectsGetRemoteConfig_579677 = ref object of OpenApiRestCall_579408
proc url_FirebaseremoteconfigProjectsGetRemoteConfig_579679(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/remoteConfig")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FirebaseremoteconfigProjectsGetRemoteConfig_579678(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the latest version Remote Configuration for a project.
  ## Returns the RemoteConfig as the payload, and also the eTag as a
  ## response header.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The GMP project identifier. Required.
  ## See note at the beginning of this file regarding project ids.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_579805 = path.getOrDefault("project")
  valid_579805 = validateParameter(valid_579805, JString, required = true,
                                 default = nil)
  if valid_579805 != nil:
    section.add "project", valid_579805
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_579823 = query.getOrDefault("pp")
  valid_579823 = validateParameter(valid_579823, JBool, required = false,
                                 default = newJBool(true))
  if valid_579823 != nil:
    section.add "pp", valid_579823
  var valid_579824 = query.getOrDefault("oauth_token")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "oauth_token", valid_579824
  var valid_579825 = query.getOrDefault("callback")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "callback", valid_579825
  var valid_579826 = query.getOrDefault("access_token")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "access_token", valid_579826
  var valid_579827 = query.getOrDefault("uploadType")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "uploadType", valid_579827
  var valid_579828 = query.getOrDefault("key")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = nil)
  if valid_579828 != nil:
    section.add "key", valid_579828
  var valid_579829 = query.getOrDefault("$.xgafv")
  valid_579829 = validateParameter(valid_579829, JString, required = false,
                                 default = newJString("1"))
  if valid_579829 != nil:
    section.add "$.xgafv", valid_579829
  var valid_579830 = query.getOrDefault("prettyPrint")
  valid_579830 = validateParameter(valid_579830, JBool, required = false,
                                 default = newJBool(true))
  if valid_579830 != nil:
    section.add "prettyPrint", valid_579830
  var valid_579831 = query.getOrDefault("bearer_token")
  valid_579831 = validateParameter(valid_579831, JString, required = false,
                                 default = nil)
  if valid_579831 != nil:
    section.add "bearer_token", valid_579831
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579854: Call_FirebaseremoteconfigProjectsGetRemoteConfig_579677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the latest version Remote Configuration for a project.
  ## Returns the RemoteConfig as the payload, and also the eTag as a
  ## response header.
  ## 
  let valid = call_579854.validator(path, query, header, formData, body)
  let scheme = call_579854.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579854.url(scheme.get, call_579854.host, call_579854.base,
                         call_579854.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579854, url, valid)

proc call*(call_579925: Call_FirebaseremoteconfigProjectsGetRemoteConfig_579677;
          project: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## firebaseremoteconfigProjectsGetRemoteConfig
  ## Get the latest version Remote Configuration for a project.
  ## Returns the RemoteConfig as the payload, and also the eTag as a
  ## response header.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   project: string (required)
  ##          : The GMP project identifier. Required.
  ## See note at the beginning of this file regarding project ids.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_579926 = newJObject()
  var query_579928 = newJObject()
  add(query_579928, "upload_protocol", newJString(uploadProtocol))
  add(query_579928, "fields", newJString(fields))
  add(query_579928, "quotaUser", newJString(quotaUser))
  add(query_579928, "alt", newJString(alt))
  add(query_579928, "pp", newJBool(pp))
  add(query_579928, "oauth_token", newJString(oauthToken))
  add(query_579928, "callback", newJString(callback))
  add(query_579928, "access_token", newJString(accessToken))
  add(query_579928, "uploadType", newJString(uploadType))
  add(query_579928, "key", newJString(key))
  add(query_579928, "$.xgafv", newJString(Xgafv))
  add(path_579926, "project", newJString(project))
  add(query_579928, "prettyPrint", newJBool(prettyPrint))
  add(query_579928, "bearer_token", newJString(bearerToken))
  result = call_579925.call(path_579926, query_579928, nil, nil, nil)

var firebaseremoteconfigProjectsGetRemoteConfig* = Call_FirebaseremoteconfigProjectsGetRemoteConfig_579677(
    name: "firebaseremoteconfigProjectsGetRemoteConfig", meth: HttpMethod.HttpGet,
    host: "firebaseremoteconfig.googleapis.com",
    route: "/v1/{project}/remoteConfig",
    validator: validate_FirebaseremoteconfigProjectsGetRemoteConfig_579678,
    base: "/", url: url_FirebaseremoteconfigProjectsGetRemoteConfig_579679,
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
