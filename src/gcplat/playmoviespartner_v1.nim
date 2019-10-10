
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Play Movies Partner
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Gets the delivery status of titles for Google Play Movies Partners.
## 
## https://developers.google.com/playmoviespartner/
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
  gcpServiceName = "playmoviespartner"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PlaymoviespartnerAccountsAvailsList_588710 = ref object of OpenApiRestCall_588441
proc url_PlaymoviespartnerAccountsAvailsList_588712(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/avails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlaymoviespartnerAccountsAvailsList_588711(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List Avails owned or managed by the partner.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _List methods rules_ for more information about this method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_588838 = path.getOrDefault("accountId")
  valid_588838 = validateParameter(valid_588838, JString, required = true,
                                 default = nil)
  if valid_588838 != nil:
    section.add "accountId", valid_588838
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : See _List methods rules_ for info about this field.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   studioNames: JArray
  ##              : See _List methods rules_ for info about this field.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   videoIds: JArray
  ##           : Filter Avails that match any of the given `video_id`s.
  ##   pphNames: JArray
  ##           : See _List methods rules_ for info about this field.
  ##   altIds: JArray
  ##         : Filter Avails that match (case-insensitive) any of the given partner-specific custom ids.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  ##   callback: JString
  ##           : JSONP
  ##   altId: JString
  ##        : Filter Avails that match a case-insensitive, partner-specific custom id.
  ## NOTE: this field is deprecated and will be removed on V2; `alt_ids`
  ## should be used instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   title: JString
  ##        : Filter that matches Avails with a `title_internal_alias`,
  ## `series_title_internal_alias`, `season_title_internal_alias`,
  ## or `episode_title_internal_alias` that contains the given
  ## case-insensitive title.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : See _List methods rules_ for info about this field.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   territories: JArray
  ##              : Filter Avails that match (case-insensitive) any of the given country codes,
  ## using the "ISO 3166-1 alpha-2" format (examples: "US", "us", "Us").
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
  var valid_588841 = query.getOrDefault("pageToken")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "pageToken", valid_588841
  var valid_588842 = query.getOrDefault("quotaUser")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = nil)
  if valid_588842 != nil:
    section.add "quotaUser", valid_588842
  var valid_588843 = query.getOrDefault("studioNames")
  valid_588843 = validateParameter(valid_588843, JArray, required = false,
                                 default = nil)
  if valid_588843 != nil:
    section.add "studioNames", valid_588843
  var valid_588857 = query.getOrDefault("alt")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = newJString("json"))
  if valid_588857 != nil:
    section.add "alt", valid_588857
  var valid_588858 = query.getOrDefault("pp")
  valid_588858 = validateParameter(valid_588858, JBool, required = false,
                                 default = newJBool(true))
  if valid_588858 != nil:
    section.add "pp", valid_588858
  var valid_588859 = query.getOrDefault("videoIds")
  valid_588859 = validateParameter(valid_588859, JArray, required = false,
                                 default = nil)
  if valid_588859 != nil:
    section.add "videoIds", valid_588859
  var valid_588860 = query.getOrDefault("pphNames")
  valid_588860 = validateParameter(valid_588860, JArray, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "pphNames", valid_588860
  var valid_588861 = query.getOrDefault("altIds")
  valid_588861 = validateParameter(valid_588861, JArray, required = false,
                                 default = nil)
  if valid_588861 != nil:
    section.add "altIds", valid_588861
  var valid_588862 = query.getOrDefault("oauth_token")
  valid_588862 = validateParameter(valid_588862, JString, required = false,
                                 default = nil)
  if valid_588862 != nil:
    section.add "oauth_token", valid_588862
  var valid_588863 = query.getOrDefault("uploadType")
  valid_588863 = validateParameter(valid_588863, JString, required = false,
                                 default = nil)
  if valid_588863 != nil:
    section.add "uploadType", valid_588863
  var valid_588864 = query.getOrDefault("access_token")
  valid_588864 = validateParameter(valid_588864, JString, required = false,
                                 default = nil)
  if valid_588864 != nil:
    section.add "access_token", valid_588864
  var valid_588865 = query.getOrDefault("callback")
  valid_588865 = validateParameter(valid_588865, JString, required = false,
                                 default = nil)
  if valid_588865 != nil:
    section.add "callback", valid_588865
  var valid_588866 = query.getOrDefault("altId")
  valid_588866 = validateParameter(valid_588866, JString, required = false,
                                 default = nil)
  if valid_588866 != nil:
    section.add "altId", valid_588866
  var valid_588867 = query.getOrDefault("key")
  valid_588867 = validateParameter(valid_588867, JString, required = false,
                                 default = nil)
  if valid_588867 != nil:
    section.add "key", valid_588867
  var valid_588868 = query.getOrDefault("title")
  valid_588868 = validateParameter(valid_588868, JString, required = false,
                                 default = nil)
  if valid_588868 != nil:
    section.add "title", valid_588868
  var valid_588869 = query.getOrDefault("$.xgafv")
  valid_588869 = validateParameter(valid_588869, JString, required = false,
                                 default = newJString("1"))
  if valid_588869 != nil:
    section.add "$.xgafv", valid_588869
  var valid_588870 = query.getOrDefault("pageSize")
  valid_588870 = validateParameter(valid_588870, JInt, required = false, default = nil)
  if valid_588870 != nil:
    section.add "pageSize", valid_588870
  var valid_588871 = query.getOrDefault("prettyPrint")
  valid_588871 = validateParameter(valid_588871, JBool, required = false,
                                 default = newJBool(true))
  if valid_588871 != nil:
    section.add "prettyPrint", valid_588871
  var valid_588872 = query.getOrDefault("territories")
  valid_588872 = validateParameter(valid_588872, JArray, required = false,
                                 default = nil)
  if valid_588872 != nil:
    section.add "territories", valid_588872
  var valid_588873 = query.getOrDefault("bearer_token")
  valid_588873 = validateParameter(valid_588873, JString, required = false,
                                 default = nil)
  if valid_588873 != nil:
    section.add "bearer_token", valid_588873
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588896: Call_PlaymoviespartnerAccountsAvailsList_588710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Avails owned or managed by the partner.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _List methods rules_ for more information about this method.
  ## 
  let valid = call_588896.validator(path, query, header, formData, body)
  let scheme = call_588896.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588896.url(scheme.get, call_588896.host, call_588896.base,
                         call_588896.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588896, url, valid)

proc call*(call_588967: Call_PlaymoviespartnerAccountsAvailsList_588710;
          accountId: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; studioNames: JsonNode = nil;
          alt: string = "json"; pp: bool = true; videoIds: JsonNode = nil;
          pphNames: JsonNode = nil; altIds: JsonNode = nil; oauthToken: string = "";
          uploadType: string = ""; accessToken: string = ""; callback: string = "";
          altId: string = ""; key: string = ""; title: string = ""; Xgafv: string = "1";
          pageSize: int = 0; prettyPrint: bool = true; territories: JsonNode = nil;
          bearerToken: string = ""): Recallable =
  ## playmoviespartnerAccountsAvailsList
  ## List Avails owned or managed by the partner.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _List methods rules_ for more information about this method.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : See _List methods rules_ for info about this field.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   studioNames: JArray
  ##              : See _List methods rules_ for info about this field.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   videoIds: JArray
  ##           : Filter Avails that match any of the given `video_id`s.
  ##   pphNames: JArray
  ##           : See _List methods rules_ for info about this field.
  ##   altIds: JArray
  ##         : Filter Avails that match (case-insensitive) any of the given partner-specific custom ids.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  ##   altId: string
  ##        : Filter Avails that match a case-insensitive, partner-specific custom id.
  ## NOTE: this field is deprecated and will be removed on V2; `alt_ids`
  ## should be used instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   title: string
  ##        : Filter that matches Avails with a `title_internal_alias`,
  ## `series_title_internal_alias`, `season_title_internal_alias`,
  ## or `episode_title_internal_alias` that contains the given
  ## case-insensitive title.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : See _List methods rules_ for info about this field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   territories: JArray
  ##              : Filter Avails that match (case-insensitive) any of the given country codes,
  ## using the "ISO 3166-1 alpha-2" format (examples: "US", "us", "Us").
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_588968 = newJObject()
  var query_588970 = newJObject()
  add(query_588970, "upload_protocol", newJString(uploadProtocol))
  add(query_588970, "fields", newJString(fields))
  add(query_588970, "pageToken", newJString(pageToken))
  add(query_588970, "quotaUser", newJString(quotaUser))
  if studioNames != nil:
    query_588970.add "studioNames", studioNames
  add(query_588970, "alt", newJString(alt))
  add(query_588970, "pp", newJBool(pp))
  if videoIds != nil:
    query_588970.add "videoIds", videoIds
  if pphNames != nil:
    query_588970.add "pphNames", pphNames
  if altIds != nil:
    query_588970.add "altIds", altIds
  add(query_588970, "oauth_token", newJString(oauthToken))
  add(query_588970, "uploadType", newJString(uploadType))
  add(query_588970, "access_token", newJString(accessToken))
  add(query_588970, "callback", newJString(callback))
  add(path_588968, "accountId", newJString(accountId))
  add(query_588970, "altId", newJString(altId))
  add(query_588970, "key", newJString(key))
  add(query_588970, "title", newJString(title))
  add(query_588970, "$.xgafv", newJString(Xgafv))
  add(query_588970, "pageSize", newJInt(pageSize))
  add(query_588970, "prettyPrint", newJBool(prettyPrint))
  if territories != nil:
    query_588970.add "territories", territories
  add(query_588970, "bearer_token", newJString(bearerToken))
  result = call_588967.call(path_588968, query_588970, nil, nil, nil)

var playmoviespartnerAccountsAvailsList* = Call_PlaymoviespartnerAccountsAvailsList_588710(
    name: "playmoviespartnerAccountsAvailsList", meth: HttpMethod.HttpGet,
    host: "playmoviespartner.googleapis.com",
    route: "/v1/accounts/{accountId}/avails",
    validator: validate_PlaymoviespartnerAccountsAvailsList_588711, base: "/",
    url: url_PlaymoviespartnerAccountsAvailsList_588712, schemes: {Scheme.Https})
type
  Call_PlaymoviespartnerAccountsAvailsGet_589009 = ref object of OpenApiRestCall_588441
proc url_PlaymoviespartnerAccountsAvailsGet_589011(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "availId" in path, "`availId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/avails/"),
               (kind: VariableSegment, value: "availId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlaymoviespartnerAccountsAvailsGet_589010(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get an Avail given its avail group id and avail id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  ##   availId: JString (required)
  ##          : REQUIRED. Avail ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589012 = path.getOrDefault("accountId")
  valid_589012 = validateParameter(valid_589012, JString, required = true,
                                 default = nil)
  if valid_589012 != nil:
    section.add "accountId", valid_589012
  var valid_589013 = path.getOrDefault("availId")
  valid_589013 = validateParameter(valid_589013, JString, required = true,
                                 default = nil)
  if valid_589013 != nil:
    section.add "availId", valid_589013
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  ##   callback: JString
  ##           : JSONP
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589014 = query.getOrDefault("upload_protocol")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "upload_protocol", valid_589014
  var valid_589015 = query.getOrDefault("fields")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "fields", valid_589015
  var valid_589016 = query.getOrDefault("quotaUser")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "quotaUser", valid_589016
  var valid_589017 = query.getOrDefault("alt")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = newJString("json"))
  if valid_589017 != nil:
    section.add "alt", valid_589017
  var valid_589018 = query.getOrDefault("pp")
  valid_589018 = validateParameter(valid_589018, JBool, required = false,
                                 default = newJBool(true))
  if valid_589018 != nil:
    section.add "pp", valid_589018
  var valid_589019 = query.getOrDefault("oauth_token")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "oauth_token", valid_589019
  var valid_589020 = query.getOrDefault("uploadType")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "uploadType", valid_589020
  var valid_589021 = query.getOrDefault("access_token")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "access_token", valid_589021
  var valid_589022 = query.getOrDefault("callback")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "callback", valid_589022
  var valid_589023 = query.getOrDefault("key")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "key", valid_589023
  var valid_589024 = query.getOrDefault("$.xgafv")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = newJString("1"))
  if valid_589024 != nil:
    section.add "$.xgafv", valid_589024
  var valid_589025 = query.getOrDefault("prettyPrint")
  valid_589025 = validateParameter(valid_589025, JBool, required = false,
                                 default = newJBool(true))
  if valid_589025 != nil:
    section.add "prettyPrint", valid_589025
  var valid_589026 = query.getOrDefault("bearer_token")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "bearer_token", valid_589026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589027: Call_PlaymoviespartnerAccountsAvailsGet_589009;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get an Avail given its avail group id and avail id.
  ## 
  let valid = call_589027.validator(path, query, header, formData, body)
  let scheme = call_589027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589027.url(scheme.get, call_589027.host, call_589027.base,
                         call_589027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589027, url, valid)

proc call*(call_589028: Call_PlaymoviespartnerAccountsAvailsGet_589009;
          accountId: string; availId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; uploadType: string = "";
          accessToken: string = ""; callback: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## playmoviespartnerAccountsAvailsGet
  ## Get an Avail given its avail group id and avail id.
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
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  ##   availId: string (required)
  ##          : REQUIRED. Avail ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589029 = newJObject()
  var query_589030 = newJObject()
  add(query_589030, "upload_protocol", newJString(uploadProtocol))
  add(query_589030, "fields", newJString(fields))
  add(query_589030, "quotaUser", newJString(quotaUser))
  add(query_589030, "alt", newJString(alt))
  add(query_589030, "pp", newJBool(pp))
  add(query_589030, "oauth_token", newJString(oauthToken))
  add(query_589030, "uploadType", newJString(uploadType))
  add(query_589030, "access_token", newJString(accessToken))
  add(query_589030, "callback", newJString(callback))
  add(path_589029, "accountId", newJString(accountId))
  add(path_589029, "availId", newJString(availId))
  add(query_589030, "key", newJString(key))
  add(query_589030, "$.xgafv", newJString(Xgafv))
  add(query_589030, "prettyPrint", newJBool(prettyPrint))
  add(query_589030, "bearer_token", newJString(bearerToken))
  result = call_589028.call(path_589029, query_589030, nil, nil, nil)

var playmoviespartnerAccountsAvailsGet* = Call_PlaymoviespartnerAccountsAvailsGet_589009(
    name: "playmoviespartnerAccountsAvailsGet", meth: HttpMethod.HttpGet,
    host: "playmoviespartner.googleapis.com",
    route: "/v1/accounts/{accountId}/avails/{availId}",
    validator: validate_PlaymoviespartnerAccountsAvailsGet_589010, base: "/",
    url: url_PlaymoviespartnerAccountsAvailsGet_589011, schemes: {Scheme.Https})
type
  Call_PlaymoviespartnerAccountsOrdersList_589031 = ref object of OpenApiRestCall_588441
proc url_PlaymoviespartnerAccountsOrdersList_589033(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/orders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlaymoviespartnerAccountsOrdersList_589032(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List Orders owned or managed by the partner.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _List methods rules_ for more information about this method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589034 = path.getOrDefault("accountId")
  valid_589034 = validateParameter(valid_589034, JString, required = true,
                                 default = nil)
  if valid_589034 != nil:
    section.add "accountId", valid_589034
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : See _List methods rules_ for info about this field.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   studioNames: JArray
  ##              : See _List methods rules_ for info about this field.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   videoIds: JArray
  ##           : Filter Orders that match any of the given `video_id`s.
  ##   pphNames: JArray
  ##           : See _List methods rules_ for info about this field.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  ##   callback: JString
  ##           : JSONP
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: JString
  ##       : Filter that matches Orders with a `name`, `show`, `season` or `episode`
  ## that contains the given case-insensitive name.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   customId: JString
  ##           : Filter Orders that match a case-insensitive, partner-specific custom id.
  ##   pageSize: JInt
  ##           : See _List methods rules_ for info about this field.
  ##   status: JArray
  ##         : Filter Orders that match one of the given status.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589035 = query.getOrDefault("upload_protocol")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "upload_protocol", valid_589035
  var valid_589036 = query.getOrDefault("fields")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "fields", valid_589036
  var valid_589037 = query.getOrDefault("pageToken")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "pageToken", valid_589037
  var valid_589038 = query.getOrDefault("quotaUser")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "quotaUser", valid_589038
  var valid_589039 = query.getOrDefault("studioNames")
  valid_589039 = validateParameter(valid_589039, JArray, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "studioNames", valid_589039
  var valid_589040 = query.getOrDefault("alt")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = newJString("json"))
  if valid_589040 != nil:
    section.add "alt", valid_589040
  var valid_589041 = query.getOrDefault("pp")
  valid_589041 = validateParameter(valid_589041, JBool, required = false,
                                 default = newJBool(true))
  if valid_589041 != nil:
    section.add "pp", valid_589041
  var valid_589042 = query.getOrDefault("videoIds")
  valid_589042 = validateParameter(valid_589042, JArray, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "videoIds", valid_589042
  var valid_589043 = query.getOrDefault("pphNames")
  valid_589043 = validateParameter(valid_589043, JArray, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "pphNames", valid_589043
  var valid_589044 = query.getOrDefault("oauth_token")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "oauth_token", valid_589044
  var valid_589045 = query.getOrDefault("uploadType")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "uploadType", valid_589045
  var valid_589046 = query.getOrDefault("access_token")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "access_token", valid_589046
  var valid_589047 = query.getOrDefault("callback")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "callback", valid_589047
  var valid_589048 = query.getOrDefault("key")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "key", valid_589048
  var valid_589049 = query.getOrDefault("name")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "name", valid_589049
  var valid_589050 = query.getOrDefault("$.xgafv")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = newJString("1"))
  if valid_589050 != nil:
    section.add "$.xgafv", valid_589050
  var valid_589051 = query.getOrDefault("customId")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "customId", valid_589051
  var valid_589052 = query.getOrDefault("pageSize")
  valid_589052 = validateParameter(valid_589052, JInt, required = false, default = nil)
  if valid_589052 != nil:
    section.add "pageSize", valid_589052
  var valid_589053 = query.getOrDefault("status")
  valid_589053 = validateParameter(valid_589053, JArray, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "status", valid_589053
  var valid_589054 = query.getOrDefault("prettyPrint")
  valid_589054 = validateParameter(valid_589054, JBool, required = false,
                                 default = newJBool(true))
  if valid_589054 != nil:
    section.add "prettyPrint", valid_589054
  var valid_589055 = query.getOrDefault("bearer_token")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "bearer_token", valid_589055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589056: Call_PlaymoviespartnerAccountsOrdersList_589031;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List Orders owned or managed by the partner.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _List methods rules_ for more information about this method.
  ## 
  let valid = call_589056.validator(path, query, header, formData, body)
  let scheme = call_589056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589056.url(scheme.get, call_589056.host, call_589056.base,
                         call_589056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589056, url, valid)

proc call*(call_589057: Call_PlaymoviespartnerAccountsOrdersList_589031;
          accountId: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; studioNames: JsonNode = nil;
          alt: string = "json"; pp: bool = true; videoIds: JsonNode = nil;
          pphNames: JsonNode = nil; oauthToken: string = ""; uploadType: string = "";
          accessToken: string = ""; callback: string = ""; key: string = "";
          name: string = ""; Xgafv: string = "1"; customId: string = ""; pageSize: int = 0;
          status: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## playmoviespartnerAccountsOrdersList
  ## List Orders owned or managed by the partner.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _List methods rules_ for more information about this method.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : See _List methods rules_ for info about this field.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   studioNames: JArray
  ##              : See _List methods rules_ for info about this field.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   videoIds: JArray
  ##           : Filter Orders that match any of the given `video_id`s.
  ##   pphNames: JArray
  ##           : See _List methods rules_ for info about this field.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : Filter that matches Orders with a `name`, `show`, `season` or `episode`
  ## that contains the given case-insensitive name.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   customId: string
  ##           : Filter Orders that match a case-insensitive, partner-specific custom id.
  ##   pageSize: int
  ##           : See _List methods rules_ for info about this field.
  ##   status: JArray
  ##         : Filter Orders that match one of the given status.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589058 = newJObject()
  var query_589059 = newJObject()
  add(query_589059, "upload_protocol", newJString(uploadProtocol))
  add(query_589059, "fields", newJString(fields))
  add(query_589059, "pageToken", newJString(pageToken))
  add(query_589059, "quotaUser", newJString(quotaUser))
  if studioNames != nil:
    query_589059.add "studioNames", studioNames
  add(query_589059, "alt", newJString(alt))
  add(query_589059, "pp", newJBool(pp))
  if videoIds != nil:
    query_589059.add "videoIds", videoIds
  if pphNames != nil:
    query_589059.add "pphNames", pphNames
  add(query_589059, "oauth_token", newJString(oauthToken))
  add(query_589059, "uploadType", newJString(uploadType))
  add(query_589059, "access_token", newJString(accessToken))
  add(query_589059, "callback", newJString(callback))
  add(path_589058, "accountId", newJString(accountId))
  add(query_589059, "key", newJString(key))
  add(query_589059, "name", newJString(name))
  add(query_589059, "$.xgafv", newJString(Xgafv))
  add(query_589059, "customId", newJString(customId))
  add(query_589059, "pageSize", newJInt(pageSize))
  if status != nil:
    query_589059.add "status", status
  add(query_589059, "prettyPrint", newJBool(prettyPrint))
  add(query_589059, "bearer_token", newJString(bearerToken))
  result = call_589057.call(path_589058, query_589059, nil, nil, nil)

var playmoviespartnerAccountsOrdersList* = Call_PlaymoviespartnerAccountsOrdersList_589031(
    name: "playmoviespartnerAccountsOrdersList", meth: HttpMethod.HttpGet,
    host: "playmoviespartner.googleapis.com",
    route: "/v1/accounts/{accountId}/orders",
    validator: validate_PlaymoviespartnerAccountsOrdersList_589032, base: "/",
    url: url_PlaymoviespartnerAccountsOrdersList_589033, schemes: {Scheme.Https})
type
  Call_PlaymoviespartnerAccountsOrdersGet_589060 = ref object of OpenApiRestCall_588441
proc url_PlaymoviespartnerAccountsOrdersGet_589062(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "orderId" in path, "`orderId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/orders/"),
               (kind: VariableSegment, value: "orderId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlaymoviespartnerAccountsOrdersGet_589061(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get an Order given its id.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _Get methods rules_ for more information about this method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  ##   orderId: JString (required)
  ##          : REQUIRED. Order ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589063 = path.getOrDefault("accountId")
  valid_589063 = validateParameter(valid_589063, JString, required = true,
                                 default = nil)
  if valid_589063 != nil:
    section.add "accountId", valid_589063
  var valid_589064 = path.getOrDefault("orderId")
  valid_589064 = validateParameter(valid_589064, JString, required = true,
                                 default = nil)
  if valid_589064 != nil:
    section.add "orderId", valid_589064
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  ##   callback: JString
  ##           : JSONP
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589065 = query.getOrDefault("upload_protocol")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "upload_protocol", valid_589065
  var valid_589066 = query.getOrDefault("fields")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "fields", valid_589066
  var valid_589067 = query.getOrDefault("quotaUser")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "quotaUser", valid_589067
  var valid_589068 = query.getOrDefault("alt")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = newJString("json"))
  if valid_589068 != nil:
    section.add "alt", valid_589068
  var valid_589069 = query.getOrDefault("pp")
  valid_589069 = validateParameter(valid_589069, JBool, required = false,
                                 default = newJBool(true))
  if valid_589069 != nil:
    section.add "pp", valid_589069
  var valid_589070 = query.getOrDefault("oauth_token")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "oauth_token", valid_589070
  var valid_589071 = query.getOrDefault("uploadType")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "uploadType", valid_589071
  var valid_589072 = query.getOrDefault("access_token")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "access_token", valid_589072
  var valid_589073 = query.getOrDefault("callback")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "callback", valid_589073
  var valid_589074 = query.getOrDefault("key")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "key", valid_589074
  var valid_589075 = query.getOrDefault("$.xgafv")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = newJString("1"))
  if valid_589075 != nil:
    section.add "$.xgafv", valid_589075
  var valid_589076 = query.getOrDefault("prettyPrint")
  valid_589076 = validateParameter(valid_589076, JBool, required = false,
                                 default = newJBool(true))
  if valid_589076 != nil:
    section.add "prettyPrint", valid_589076
  var valid_589077 = query.getOrDefault("bearer_token")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "bearer_token", valid_589077
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589078: Call_PlaymoviespartnerAccountsOrdersGet_589060;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get an Order given its id.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _Get methods rules_ for more information about this method.
  ## 
  let valid = call_589078.validator(path, query, header, formData, body)
  let scheme = call_589078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589078.url(scheme.get, call_589078.host, call_589078.base,
                         call_589078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589078, url, valid)

proc call*(call_589079: Call_PlaymoviespartnerAccountsOrdersGet_589060;
          accountId: string; orderId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; uploadType: string = "";
          accessToken: string = ""; callback: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## playmoviespartnerAccountsOrdersGet
  ## Get an Order given its id.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _Get methods rules_ for more information about this method.
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
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  ##   orderId: string (required)
  ##          : REQUIRED. Order ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589080 = newJObject()
  var query_589081 = newJObject()
  add(query_589081, "upload_protocol", newJString(uploadProtocol))
  add(query_589081, "fields", newJString(fields))
  add(query_589081, "quotaUser", newJString(quotaUser))
  add(query_589081, "alt", newJString(alt))
  add(query_589081, "pp", newJBool(pp))
  add(query_589081, "oauth_token", newJString(oauthToken))
  add(query_589081, "uploadType", newJString(uploadType))
  add(query_589081, "access_token", newJString(accessToken))
  add(query_589081, "callback", newJString(callback))
  add(path_589080, "accountId", newJString(accountId))
  add(path_589080, "orderId", newJString(orderId))
  add(query_589081, "key", newJString(key))
  add(query_589081, "$.xgafv", newJString(Xgafv))
  add(query_589081, "prettyPrint", newJBool(prettyPrint))
  add(query_589081, "bearer_token", newJString(bearerToken))
  result = call_589079.call(path_589080, query_589081, nil, nil, nil)

var playmoviespartnerAccountsOrdersGet* = Call_PlaymoviespartnerAccountsOrdersGet_589060(
    name: "playmoviespartnerAccountsOrdersGet", meth: HttpMethod.HttpGet,
    host: "playmoviespartner.googleapis.com",
    route: "/v1/accounts/{accountId}/orders/{orderId}",
    validator: validate_PlaymoviespartnerAccountsOrdersGet_589061, base: "/",
    url: url_PlaymoviespartnerAccountsOrdersGet_589062, schemes: {Scheme.Https})
type
  Call_PlaymoviespartnerAccountsStoreInfosList_589082 = ref object of OpenApiRestCall_588441
proc url_PlaymoviespartnerAccountsStoreInfosList_589084(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/storeInfos")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlaymoviespartnerAccountsStoreInfosList_589083(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List StoreInfos owned or managed by the partner.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _List methods rules_ for more information about this method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589085 = path.getOrDefault("accountId")
  valid_589085 = validateParameter(valid_589085, JString, required = true,
                                 default = nil)
  if valid_589085 != nil:
    section.add "accountId", valid_589085
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : See _List methods rules_ for info about this field.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   studioNames: JArray
  ##              : See _List methods rules_ for info about this field.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   videoIds: JArray
  ##           : Filter StoreInfos that match any of the given `video_id`s.
  ##   pphNames: JArray
  ##           : See _List methods rules_ for info about this field.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  ##   callback: JString
  ##           : JSONP
  ##   seasonIds: JArray
  ##            : Filter StoreInfos that match any of the given `season_id`s.
  ##   mids: JArray
  ##       : Filter StoreInfos that match any of the given `mid`s.
  ##   videoId: JString
  ##          : Filter StoreInfos that match a given `video_id`.
  ## NOTE: this field is deprecated and will be removed on V2; `video_ids`
  ## should be used instead.
  ##   countries: JArray
  ##            : Filter StoreInfos that match (case-insensitive) any of the given country
  ## codes, using the "ISO 3166-1 alpha-2" format (examples: "US", "us", "Us").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: JString
  ##       : Filter that matches StoreInfos with a `name` or `show_name`
  ## that contains the given case-insensitive name.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : See _List methods rules_ for info about this field.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589086 = query.getOrDefault("upload_protocol")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "upload_protocol", valid_589086
  var valid_589087 = query.getOrDefault("fields")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "fields", valid_589087
  var valid_589088 = query.getOrDefault("pageToken")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "pageToken", valid_589088
  var valid_589089 = query.getOrDefault("quotaUser")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "quotaUser", valid_589089
  var valid_589090 = query.getOrDefault("studioNames")
  valid_589090 = validateParameter(valid_589090, JArray, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "studioNames", valid_589090
  var valid_589091 = query.getOrDefault("alt")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = newJString("json"))
  if valid_589091 != nil:
    section.add "alt", valid_589091
  var valid_589092 = query.getOrDefault("pp")
  valid_589092 = validateParameter(valid_589092, JBool, required = false,
                                 default = newJBool(true))
  if valid_589092 != nil:
    section.add "pp", valid_589092
  var valid_589093 = query.getOrDefault("videoIds")
  valid_589093 = validateParameter(valid_589093, JArray, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "videoIds", valid_589093
  var valid_589094 = query.getOrDefault("pphNames")
  valid_589094 = validateParameter(valid_589094, JArray, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "pphNames", valid_589094
  var valid_589095 = query.getOrDefault("oauth_token")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "oauth_token", valid_589095
  var valid_589096 = query.getOrDefault("uploadType")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "uploadType", valid_589096
  var valid_589097 = query.getOrDefault("access_token")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "access_token", valid_589097
  var valid_589098 = query.getOrDefault("callback")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "callback", valid_589098
  var valid_589099 = query.getOrDefault("seasonIds")
  valid_589099 = validateParameter(valid_589099, JArray, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "seasonIds", valid_589099
  var valid_589100 = query.getOrDefault("mids")
  valid_589100 = validateParameter(valid_589100, JArray, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "mids", valid_589100
  var valid_589101 = query.getOrDefault("videoId")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "videoId", valid_589101
  var valid_589102 = query.getOrDefault("countries")
  valid_589102 = validateParameter(valid_589102, JArray, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "countries", valid_589102
  var valid_589103 = query.getOrDefault("key")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "key", valid_589103
  var valid_589104 = query.getOrDefault("name")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "name", valid_589104
  var valid_589105 = query.getOrDefault("$.xgafv")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = newJString("1"))
  if valid_589105 != nil:
    section.add "$.xgafv", valid_589105
  var valid_589106 = query.getOrDefault("pageSize")
  valid_589106 = validateParameter(valid_589106, JInt, required = false, default = nil)
  if valid_589106 != nil:
    section.add "pageSize", valid_589106
  var valid_589107 = query.getOrDefault("prettyPrint")
  valid_589107 = validateParameter(valid_589107, JBool, required = false,
                                 default = newJBool(true))
  if valid_589107 != nil:
    section.add "prettyPrint", valid_589107
  var valid_589108 = query.getOrDefault("bearer_token")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "bearer_token", valid_589108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589109: Call_PlaymoviespartnerAccountsStoreInfosList_589082;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List StoreInfos owned or managed by the partner.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _List methods rules_ for more information about this method.
  ## 
  let valid = call_589109.validator(path, query, header, formData, body)
  let scheme = call_589109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589109.url(scheme.get, call_589109.host, call_589109.base,
                         call_589109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589109, url, valid)

proc call*(call_589110: Call_PlaymoviespartnerAccountsStoreInfosList_589082;
          accountId: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; studioNames: JsonNode = nil;
          alt: string = "json"; pp: bool = true; videoIds: JsonNode = nil;
          pphNames: JsonNode = nil; oauthToken: string = ""; uploadType: string = "";
          accessToken: string = ""; callback: string = ""; seasonIds: JsonNode = nil;
          mids: JsonNode = nil; videoId: string = ""; countries: JsonNode = nil;
          key: string = ""; name: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## playmoviespartnerAccountsStoreInfosList
  ## List StoreInfos owned or managed by the partner.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _List methods rules_ for more information about this method.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : See _List methods rules_ for info about this field.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   studioNames: JArray
  ##              : See _List methods rules_ for info about this field.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   videoIds: JArray
  ##           : Filter StoreInfos that match any of the given `video_id`s.
  ##   pphNames: JArray
  ##           : See _List methods rules_ for info about this field.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  ##   seasonIds: JArray
  ##            : Filter StoreInfos that match any of the given `season_id`s.
  ##   mids: JArray
  ##       : Filter StoreInfos that match any of the given `mid`s.
  ##   videoId: string
  ##          : Filter StoreInfos that match a given `video_id`.
  ## NOTE: this field is deprecated and will be removed on V2; `video_ids`
  ## should be used instead.
  ##   countries: JArray
  ##            : Filter StoreInfos that match (case-insensitive) any of the given country
  ## codes, using the "ISO 3166-1 alpha-2" format (examples: "US", "us", "Us").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : Filter that matches StoreInfos with a `name` or `show_name`
  ## that contains the given case-insensitive name.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : See _List methods rules_ for info about this field.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589111 = newJObject()
  var query_589112 = newJObject()
  add(query_589112, "upload_protocol", newJString(uploadProtocol))
  add(query_589112, "fields", newJString(fields))
  add(query_589112, "pageToken", newJString(pageToken))
  add(query_589112, "quotaUser", newJString(quotaUser))
  if studioNames != nil:
    query_589112.add "studioNames", studioNames
  add(query_589112, "alt", newJString(alt))
  add(query_589112, "pp", newJBool(pp))
  if videoIds != nil:
    query_589112.add "videoIds", videoIds
  if pphNames != nil:
    query_589112.add "pphNames", pphNames
  add(query_589112, "oauth_token", newJString(oauthToken))
  add(query_589112, "uploadType", newJString(uploadType))
  add(query_589112, "access_token", newJString(accessToken))
  add(query_589112, "callback", newJString(callback))
  add(path_589111, "accountId", newJString(accountId))
  if seasonIds != nil:
    query_589112.add "seasonIds", seasonIds
  if mids != nil:
    query_589112.add "mids", mids
  add(query_589112, "videoId", newJString(videoId))
  if countries != nil:
    query_589112.add "countries", countries
  add(query_589112, "key", newJString(key))
  add(query_589112, "name", newJString(name))
  add(query_589112, "$.xgafv", newJString(Xgafv))
  add(query_589112, "pageSize", newJInt(pageSize))
  add(query_589112, "prettyPrint", newJBool(prettyPrint))
  add(query_589112, "bearer_token", newJString(bearerToken))
  result = call_589110.call(path_589111, query_589112, nil, nil, nil)

var playmoviespartnerAccountsStoreInfosList* = Call_PlaymoviespartnerAccountsStoreInfosList_589082(
    name: "playmoviespartnerAccountsStoreInfosList", meth: HttpMethod.HttpGet,
    host: "playmoviespartner.googleapis.com",
    route: "/v1/accounts/{accountId}/storeInfos",
    validator: validate_PlaymoviespartnerAccountsStoreInfosList_589083, base: "/",
    url: url_PlaymoviespartnerAccountsStoreInfosList_589084,
    schemes: {Scheme.Https})
type
  Call_PlaymoviespartnerAccountsStoreInfosCountryGet_589113 = ref object of OpenApiRestCall_588441
proc url_PlaymoviespartnerAccountsStoreInfosCountryGet_589115(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "videoId" in path, "`videoId` is a required path parameter"
  assert "country" in path, "`country` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/storeInfos/"),
               (kind: VariableSegment, value: "videoId"),
               (kind: ConstantSegment, value: "/country/"),
               (kind: VariableSegment, value: "country")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlaymoviespartnerAccountsStoreInfosCountryGet_589114(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get a StoreInfo given its video id and country.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _Get methods rules_ for more information about this method.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   country: JString (required)
  ##          : REQUIRED. Edit country.
  ##   accountId: JString (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  ##   videoId: JString (required)
  ##          : REQUIRED. Video ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `country` field"
  var valid_589116 = path.getOrDefault("country")
  valid_589116 = validateParameter(valid_589116, JString, required = true,
                                 default = nil)
  if valid_589116 != nil:
    section.add "country", valid_589116
  var valid_589117 = path.getOrDefault("accountId")
  valid_589117 = validateParameter(valid_589117, JString, required = true,
                                 default = nil)
  if valid_589117 != nil:
    section.add "accountId", valid_589117
  var valid_589118 = path.getOrDefault("videoId")
  valid_589118 = validateParameter(valid_589118, JString, required = true,
                                 default = nil)
  if valid_589118 != nil:
    section.add "videoId", valid_589118
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
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   access_token: JString
  ##               : OAuth access token.
  ##   callback: JString
  ##           : JSONP
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589119 = query.getOrDefault("upload_protocol")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "upload_protocol", valid_589119
  var valid_589120 = query.getOrDefault("fields")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "fields", valid_589120
  var valid_589121 = query.getOrDefault("quotaUser")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "quotaUser", valid_589121
  var valid_589122 = query.getOrDefault("alt")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = newJString("json"))
  if valid_589122 != nil:
    section.add "alt", valid_589122
  var valid_589123 = query.getOrDefault("pp")
  valid_589123 = validateParameter(valid_589123, JBool, required = false,
                                 default = newJBool(true))
  if valid_589123 != nil:
    section.add "pp", valid_589123
  var valid_589124 = query.getOrDefault("oauth_token")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "oauth_token", valid_589124
  var valid_589125 = query.getOrDefault("uploadType")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "uploadType", valid_589125
  var valid_589126 = query.getOrDefault("access_token")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "access_token", valid_589126
  var valid_589127 = query.getOrDefault("callback")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "callback", valid_589127
  var valid_589128 = query.getOrDefault("key")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "key", valid_589128
  var valid_589129 = query.getOrDefault("$.xgafv")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = newJString("1"))
  if valid_589129 != nil:
    section.add "$.xgafv", valid_589129
  var valid_589130 = query.getOrDefault("prettyPrint")
  valid_589130 = validateParameter(valid_589130, JBool, required = false,
                                 default = newJBool(true))
  if valid_589130 != nil:
    section.add "prettyPrint", valid_589130
  var valid_589131 = query.getOrDefault("bearer_token")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "bearer_token", valid_589131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589132: Call_PlaymoviespartnerAccountsStoreInfosCountryGet_589113;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a StoreInfo given its video id and country.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _Get methods rules_ for more information about this method.
  ## 
  let valid = call_589132.validator(path, query, header, formData, body)
  let scheme = call_589132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589132.url(scheme.get, call_589132.host, call_589132.base,
                         call_589132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589132, url, valid)

proc call*(call_589133: Call_PlaymoviespartnerAccountsStoreInfosCountryGet_589113;
          country: string; accountId: string; videoId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          uploadType: string = ""; accessToken: string = ""; callback: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true;
          bearerToken: string = ""): Recallable =
  ## playmoviespartnerAccountsStoreInfosCountryGet
  ## Get a StoreInfo given its video id and country.
  ## 
  ## See _Authentication and Authorization rules_ and
  ## _Get methods rules_ for more information about this method.
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
  ##   country: string (required)
  ##          : REQUIRED. Edit country.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   accessToken: string
  ##              : OAuth access token.
  ##   callback: string
  ##           : JSONP
  ##   accountId: string (required)
  ##            : REQUIRED. See _General rules_ for more information about this field.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   videoId: string (required)
  ##          : REQUIRED. Video ID.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589134 = newJObject()
  var query_589135 = newJObject()
  add(query_589135, "upload_protocol", newJString(uploadProtocol))
  add(query_589135, "fields", newJString(fields))
  add(query_589135, "quotaUser", newJString(quotaUser))
  add(query_589135, "alt", newJString(alt))
  add(query_589135, "pp", newJBool(pp))
  add(path_589134, "country", newJString(country))
  add(query_589135, "oauth_token", newJString(oauthToken))
  add(query_589135, "uploadType", newJString(uploadType))
  add(query_589135, "access_token", newJString(accessToken))
  add(query_589135, "callback", newJString(callback))
  add(path_589134, "accountId", newJString(accountId))
  add(query_589135, "key", newJString(key))
  add(query_589135, "$.xgafv", newJString(Xgafv))
  add(path_589134, "videoId", newJString(videoId))
  add(query_589135, "prettyPrint", newJBool(prettyPrint))
  add(query_589135, "bearer_token", newJString(bearerToken))
  result = call_589133.call(path_589134, query_589135, nil, nil, nil)

var playmoviespartnerAccountsStoreInfosCountryGet* = Call_PlaymoviespartnerAccountsStoreInfosCountryGet_589113(
    name: "playmoviespartnerAccountsStoreInfosCountryGet",
    meth: HttpMethod.HttpGet, host: "playmoviespartner.googleapis.com",
    route: "/v1/accounts/{accountId}/storeInfos/{videoId}/country/{country}",
    validator: validate_PlaymoviespartnerAccountsStoreInfosCountryGet_589114,
    base: "/", url: url_PlaymoviespartnerAccountsStoreInfosCountryGet_589115,
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
