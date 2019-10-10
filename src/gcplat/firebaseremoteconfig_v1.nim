
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
  gcpServiceName = "firebaseremoteconfig"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FirebaseremoteconfigProjectsUpdateRemoteConfig_589000 = ref object of OpenApiRestCall_588441
proc url_FirebaseremoteconfigProjectsUpdateRemoteConfig_589002(protocol: Scheme;
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

proc validate_FirebaseremoteconfigProjectsUpdateRemoteConfig_589001(
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
  var valid_589003 = path.getOrDefault("project")
  valid_589003 = validateParameter(valid_589003, JString, required = true,
                                 default = nil)
  if valid_589003 != nil:
    section.add "project", valid_589003
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
  var valid_589004 = query.getOrDefault("upload_protocol")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "upload_protocol", valid_589004
  var valid_589005 = query.getOrDefault("fields")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "fields", valid_589005
  var valid_589006 = query.getOrDefault("quotaUser")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "quotaUser", valid_589006
  var valid_589007 = query.getOrDefault("alt")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = newJString("json"))
  if valid_589007 != nil:
    section.add "alt", valid_589007
  var valid_589008 = query.getOrDefault("pp")
  valid_589008 = validateParameter(valid_589008, JBool, required = false,
                                 default = newJBool(true))
  if valid_589008 != nil:
    section.add "pp", valid_589008
  var valid_589009 = query.getOrDefault("oauth_token")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "oauth_token", valid_589009
  var valid_589010 = query.getOrDefault("callback")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "callback", valid_589010
  var valid_589011 = query.getOrDefault("access_token")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "access_token", valid_589011
  var valid_589012 = query.getOrDefault("uploadType")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "uploadType", valid_589012
  var valid_589013 = query.getOrDefault("validateOnly")
  valid_589013 = validateParameter(valid_589013, JBool, required = false, default = nil)
  if valid_589013 != nil:
    section.add "validateOnly", valid_589013
  var valid_589014 = query.getOrDefault("key")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "key", valid_589014
  var valid_589015 = query.getOrDefault("$.xgafv")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = newJString("1"))
  if valid_589015 != nil:
    section.add "$.xgafv", valid_589015
  var valid_589016 = query.getOrDefault("prettyPrint")
  valid_589016 = validateParameter(valid_589016, JBool, required = false,
                                 default = newJBool(true))
  if valid_589016 != nil:
    section.add "prettyPrint", valid_589016
  var valid_589017 = query.getOrDefault("bearer_token")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "bearer_token", valid_589017
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

proc call*(call_589019: Call_FirebaseremoteconfigProjectsUpdateRemoteConfig_589000;
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
  let valid = call_589019.validator(path, query, header, formData, body)
  let scheme = call_589019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589019.url(scheme.get, call_589019.host, call_589019.base,
                         call_589019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589019, url, valid)

proc call*(call_589020: Call_FirebaseremoteconfigProjectsUpdateRemoteConfig_589000;
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
  var path_589021 = newJObject()
  var query_589022 = newJObject()
  var body_589023 = newJObject()
  add(query_589022, "upload_protocol", newJString(uploadProtocol))
  add(query_589022, "fields", newJString(fields))
  add(query_589022, "quotaUser", newJString(quotaUser))
  add(query_589022, "alt", newJString(alt))
  add(query_589022, "pp", newJBool(pp))
  add(query_589022, "oauth_token", newJString(oauthToken))
  add(query_589022, "callback", newJString(callback))
  add(query_589022, "access_token", newJString(accessToken))
  add(query_589022, "uploadType", newJString(uploadType))
  add(query_589022, "validateOnly", newJBool(validateOnly))
  add(query_589022, "key", newJString(key))
  add(query_589022, "$.xgafv", newJString(Xgafv))
  add(path_589021, "project", newJString(project))
  if body != nil:
    body_589023 = body
  add(query_589022, "prettyPrint", newJBool(prettyPrint))
  add(query_589022, "bearer_token", newJString(bearerToken))
  result = call_589020.call(path_589021, query_589022, nil, nil, body_589023)

var firebaseremoteconfigProjectsUpdateRemoteConfig* = Call_FirebaseremoteconfigProjectsUpdateRemoteConfig_589000(
    name: "firebaseremoteconfigProjectsUpdateRemoteConfig",
    meth: HttpMethod.HttpPut, host: "firebaseremoteconfig.googleapis.com",
    route: "/v1/{project}/remoteConfig",
    validator: validate_FirebaseremoteconfigProjectsUpdateRemoteConfig_589001,
    base: "/", url: url_FirebaseremoteconfigProjectsUpdateRemoteConfig_589002,
    schemes: {Scheme.Https})
type
  Call_FirebaseremoteconfigProjectsGetRemoteConfig_588710 = ref object of OpenApiRestCall_588441
proc url_FirebaseremoteconfigProjectsGetRemoteConfig_588712(protocol: Scheme;
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

proc validate_FirebaseremoteconfigProjectsGetRemoteConfig_588711(path: JsonNode;
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
  var valid_588838 = path.getOrDefault("project")
  valid_588838 = validateParameter(valid_588838, JString, required = true,
                                 default = nil)
  if valid_588838 != nil:
    section.add "project", valid_588838
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
  var valid_588856 = query.getOrDefault("pp")
  valid_588856 = validateParameter(valid_588856, JBool, required = false,
                                 default = newJBool(true))
  if valid_588856 != nil:
    section.add "pp", valid_588856
  var valid_588857 = query.getOrDefault("oauth_token")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "oauth_token", valid_588857
  var valid_588858 = query.getOrDefault("callback")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "callback", valid_588858
  var valid_588859 = query.getOrDefault("access_token")
  valid_588859 = validateParameter(valid_588859, JString, required = false,
                                 default = nil)
  if valid_588859 != nil:
    section.add "access_token", valid_588859
  var valid_588860 = query.getOrDefault("uploadType")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "uploadType", valid_588860
  var valid_588861 = query.getOrDefault("key")
  valid_588861 = validateParameter(valid_588861, JString, required = false,
                                 default = nil)
  if valid_588861 != nil:
    section.add "key", valid_588861
  var valid_588862 = query.getOrDefault("$.xgafv")
  valid_588862 = validateParameter(valid_588862, JString, required = false,
                                 default = newJString("1"))
  if valid_588862 != nil:
    section.add "$.xgafv", valid_588862
  var valid_588863 = query.getOrDefault("prettyPrint")
  valid_588863 = validateParameter(valid_588863, JBool, required = false,
                                 default = newJBool(true))
  if valid_588863 != nil:
    section.add "prettyPrint", valid_588863
  var valid_588864 = query.getOrDefault("bearer_token")
  valid_588864 = validateParameter(valid_588864, JString, required = false,
                                 default = nil)
  if valid_588864 != nil:
    section.add "bearer_token", valid_588864
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588887: Call_FirebaseremoteconfigProjectsGetRemoteConfig_588710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the latest version Remote Configuration for a project.
  ## Returns the RemoteConfig as the payload, and also the eTag as a
  ## response header.
  ## 
  let valid = call_588887.validator(path, query, header, formData, body)
  let scheme = call_588887.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588887.url(scheme.get, call_588887.host, call_588887.base,
                         call_588887.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588887, url, valid)

proc call*(call_588958: Call_FirebaseremoteconfigProjectsGetRemoteConfig_588710;
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
  var path_588959 = newJObject()
  var query_588961 = newJObject()
  add(query_588961, "upload_protocol", newJString(uploadProtocol))
  add(query_588961, "fields", newJString(fields))
  add(query_588961, "quotaUser", newJString(quotaUser))
  add(query_588961, "alt", newJString(alt))
  add(query_588961, "pp", newJBool(pp))
  add(query_588961, "oauth_token", newJString(oauthToken))
  add(query_588961, "callback", newJString(callback))
  add(query_588961, "access_token", newJString(accessToken))
  add(query_588961, "uploadType", newJString(uploadType))
  add(query_588961, "key", newJString(key))
  add(query_588961, "$.xgafv", newJString(Xgafv))
  add(path_588959, "project", newJString(project))
  add(query_588961, "prettyPrint", newJBool(prettyPrint))
  add(query_588961, "bearer_token", newJString(bearerToken))
  result = call_588958.call(path_588959, query_588961, nil, nil, nil)

var firebaseremoteconfigProjectsGetRemoteConfig* = Call_FirebaseremoteconfigProjectsGetRemoteConfig_588710(
    name: "firebaseremoteconfigProjectsGetRemoteConfig", meth: HttpMethod.HttpGet,
    host: "firebaseremoteconfig.googleapis.com",
    route: "/v1/{project}/remoteConfig",
    validator: validate_FirebaseremoteconfigProjectsGetRemoteConfig_588711,
    base: "/", url: url_FirebaseremoteconfigProjectsGetRemoteConfig_588712,
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
