
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FirebaseremoteconfigProjectsUpdateRemoteConfig_593967 = ref object of OpenApiRestCall_593408
proc url_FirebaseremoteconfigProjectsUpdateRemoteConfig_593969(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FirebaseremoteconfigProjectsUpdateRemoteConfig_593968(
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
  var valid_593970 = path.getOrDefault("project")
  valid_593970 = validateParameter(valid_593970, JString, required = true,
                                 default = nil)
  if valid_593970 != nil:
    section.add "project", valid_593970
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
  var valid_593971 = query.getOrDefault("upload_protocol")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "upload_protocol", valid_593971
  var valid_593972 = query.getOrDefault("fields")
  valid_593972 = validateParameter(valid_593972, JString, required = false,
                                 default = nil)
  if valid_593972 != nil:
    section.add "fields", valid_593972
  var valid_593973 = query.getOrDefault("quotaUser")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = nil)
  if valid_593973 != nil:
    section.add "quotaUser", valid_593973
  var valid_593974 = query.getOrDefault("alt")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = newJString("json"))
  if valid_593974 != nil:
    section.add "alt", valid_593974
  var valid_593975 = query.getOrDefault("pp")
  valid_593975 = validateParameter(valid_593975, JBool, required = false,
                                 default = newJBool(true))
  if valid_593975 != nil:
    section.add "pp", valid_593975
  var valid_593976 = query.getOrDefault("oauth_token")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "oauth_token", valid_593976
  var valid_593977 = query.getOrDefault("callback")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "callback", valid_593977
  var valid_593978 = query.getOrDefault("access_token")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = nil)
  if valid_593978 != nil:
    section.add "access_token", valid_593978
  var valid_593979 = query.getOrDefault("uploadType")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = nil)
  if valid_593979 != nil:
    section.add "uploadType", valid_593979
  var valid_593980 = query.getOrDefault("validateOnly")
  valid_593980 = validateParameter(valid_593980, JBool, required = false, default = nil)
  if valid_593980 != nil:
    section.add "validateOnly", valid_593980
  var valid_593981 = query.getOrDefault("key")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = nil)
  if valid_593981 != nil:
    section.add "key", valid_593981
  var valid_593982 = query.getOrDefault("$.xgafv")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = newJString("1"))
  if valid_593982 != nil:
    section.add "$.xgafv", valid_593982
  var valid_593983 = query.getOrDefault("prettyPrint")
  valid_593983 = validateParameter(valid_593983, JBool, required = false,
                                 default = newJBool(true))
  if valid_593983 != nil:
    section.add "prettyPrint", valid_593983
  var valid_593984 = query.getOrDefault("bearer_token")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "bearer_token", valid_593984
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

proc call*(call_593986: Call_FirebaseremoteconfigProjectsUpdateRemoteConfig_593967;
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
  let valid = call_593986.validator(path, query, header, formData, body)
  let scheme = call_593986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593986.url(scheme.get, call_593986.host, call_593986.base,
                         call_593986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593986, url, valid)

proc call*(call_593987: Call_FirebaseremoteconfigProjectsUpdateRemoteConfig_593967;
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
  var path_593988 = newJObject()
  var query_593989 = newJObject()
  var body_593990 = newJObject()
  add(query_593989, "upload_protocol", newJString(uploadProtocol))
  add(query_593989, "fields", newJString(fields))
  add(query_593989, "quotaUser", newJString(quotaUser))
  add(query_593989, "alt", newJString(alt))
  add(query_593989, "pp", newJBool(pp))
  add(query_593989, "oauth_token", newJString(oauthToken))
  add(query_593989, "callback", newJString(callback))
  add(query_593989, "access_token", newJString(accessToken))
  add(query_593989, "uploadType", newJString(uploadType))
  add(query_593989, "validateOnly", newJBool(validateOnly))
  add(query_593989, "key", newJString(key))
  add(query_593989, "$.xgafv", newJString(Xgafv))
  add(path_593988, "project", newJString(project))
  if body != nil:
    body_593990 = body
  add(query_593989, "prettyPrint", newJBool(prettyPrint))
  add(query_593989, "bearer_token", newJString(bearerToken))
  result = call_593987.call(path_593988, query_593989, nil, nil, body_593990)

var firebaseremoteconfigProjectsUpdateRemoteConfig* = Call_FirebaseremoteconfigProjectsUpdateRemoteConfig_593967(
    name: "firebaseremoteconfigProjectsUpdateRemoteConfig",
    meth: HttpMethod.HttpPut, host: "firebaseremoteconfig.googleapis.com",
    route: "/v1/{project}/remoteConfig",
    validator: validate_FirebaseremoteconfigProjectsUpdateRemoteConfig_593968,
    base: "/", url: url_FirebaseremoteconfigProjectsUpdateRemoteConfig_593969,
    schemes: {Scheme.Https})
type
  Call_FirebaseremoteconfigProjectsGetRemoteConfig_593677 = ref object of OpenApiRestCall_593408
proc url_FirebaseremoteconfigProjectsGetRemoteConfig_593679(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FirebaseremoteconfigProjectsGetRemoteConfig_593678(path: JsonNode;
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
  var valid_593805 = path.getOrDefault("project")
  valid_593805 = validateParameter(valid_593805, JString, required = true,
                                 default = nil)
  if valid_593805 != nil:
    section.add "project", valid_593805
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
  var valid_593806 = query.getOrDefault("upload_protocol")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "upload_protocol", valid_593806
  var valid_593807 = query.getOrDefault("fields")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "fields", valid_593807
  var valid_593808 = query.getOrDefault("quotaUser")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = nil)
  if valid_593808 != nil:
    section.add "quotaUser", valid_593808
  var valid_593822 = query.getOrDefault("alt")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = newJString("json"))
  if valid_593822 != nil:
    section.add "alt", valid_593822
  var valid_593823 = query.getOrDefault("pp")
  valid_593823 = validateParameter(valid_593823, JBool, required = false,
                                 default = newJBool(true))
  if valid_593823 != nil:
    section.add "pp", valid_593823
  var valid_593824 = query.getOrDefault("oauth_token")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "oauth_token", valid_593824
  var valid_593825 = query.getOrDefault("callback")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "callback", valid_593825
  var valid_593826 = query.getOrDefault("access_token")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = nil)
  if valid_593826 != nil:
    section.add "access_token", valid_593826
  var valid_593827 = query.getOrDefault("uploadType")
  valid_593827 = validateParameter(valid_593827, JString, required = false,
                                 default = nil)
  if valid_593827 != nil:
    section.add "uploadType", valid_593827
  var valid_593828 = query.getOrDefault("key")
  valid_593828 = validateParameter(valid_593828, JString, required = false,
                                 default = nil)
  if valid_593828 != nil:
    section.add "key", valid_593828
  var valid_593829 = query.getOrDefault("$.xgafv")
  valid_593829 = validateParameter(valid_593829, JString, required = false,
                                 default = newJString("1"))
  if valid_593829 != nil:
    section.add "$.xgafv", valid_593829
  var valid_593830 = query.getOrDefault("prettyPrint")
  valid_593830 = validateParameter(valid_593830, JBool, required = false,
                                 default = newJBool(true))
  if valid_593830 != nil:
    section.add "prettyPrint", valid_593830
  var valid_593831 = query.getOrDefault("bearer_token")
  valid_593831 = validateParameter(valid_593831, JString, required = false,
                                 default = nil)
  if valid_593831 != nil:
    section.add "bearer_token", valid_593831
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593854: Call_FirebaseremoteconfigProjectsGetRemoteConfig_593677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the latest version Remote Configuration for a project.
  ## Returns the RemoteConfig as the payload, and also the eTag as a
  ## response header.
  ## 
  let valid = call_593854.validator(path, query, header, formData, body)
  let scheme = call_593854.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593854.url(scheme.get, call_593854.host, call_593854.base,
                         call_593854.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593854, url, valid)

proc call*(call_593925: Call_FirebaseremoteconfigProjectsGetRemoteConfig_593677;
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
  var path_593926 = newJObject()
  var query_593928 = newJObject()
  add(query_593928, "upload_protocol", newJString(uploadProtocol))
  add(query_593928, "fields", newJString(fields))
  add(query_593928, "quotaUser", newJString(quotaUser))
  add(query_593928, "alt", newJString(alt))
  add(query_593928, "pp", newJBool(pp))
  add(query_593928, "oauth_token", newJString(oauthToken))
  add(query_593928, "callback", newJString(callback))
  add(query_593928, "access_token", newJString(accessToken))
  add(query_593928, "uploadType", newJString(uploadType))
  add(query_593928, "key", newJString(key))
  add(query_593928, "$.xgafv", newJString(Xgafv))
  add(path_593926, "project", newJString(project))
  add(query_593928, "prettyPrint", newJBool(prettyPrint))
  add(query_593928, "bearer_token", newJString(bearerToken))
  result = call_593925.call(path_593926, query_593928, nil, nil, nil)

var firebaseremoteconfigProjectsGetRemoteConfig* = Call_FirebaseremoteconfigProjectsGetRemoteConfig_593677(
    name: "firebaseremoteconfigProjectsGetRemoteConfig", meth: HttpMethod.HttpGet,
    host: "firebaseremoteconfig.googleapis.com",
    route: "/v1/{project}/remoteConfig",
    validator: validate_FirebaseremoteconfigProjectsGetRemoteConfig_593678,
    base: "/", url: url_FirebaseremoteconfigProjectsGetRemoteConfig_593679,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
