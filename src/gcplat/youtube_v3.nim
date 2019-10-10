
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: YouTube Data
## version: v3
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Supports core YouTube features, such as uploading videos, creating and managing playlists, searching for content, and much more.
## 
## https://developers.google.com/youtube/v3
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

  OpenApiRestCall_588466 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588466](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588466): Option[Scheme] {.used.} =
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
  gcpServiceName = "youtube"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_YoutubeActivitiesInsert_589012 = ref object of OpenApiRestCall_588466
proc url_YoutubeActivitiesInsert_589014(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeActivitiesInsert_589013(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Posts a bulletin for a specific channel. (The user submitting the request must be authorized to act on the channel's behalf.)
  ## 
  ## Note: Even though an activity resource can contain information about actions like a user rating a video or marking a video as a favorite, you need to use other API methods to generate those activity resources. For example, you would use the API's videos.rate() method to rate a video and the playlistItems.insert() method to mark a video as a favorite.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
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
  var valid_589018 = query.getOrDefault("oauth_token")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "oauth_token", valid_589018
  var valid_589019 = query.getOrDefault("userIp")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "userIp", valid_589019
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589020 = query.getOrDefault("part")
  valid_589020 = validateParameter(valid_589020, JString, required = true,
                                 default = nil)
  if valid_589020 != nil:
    section.add "part", valid_589020
  var valid_589021 = query.getOrDefault("key")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "key", valid_589021
  var valid_589022 = query.getOrDefault("prettyPrint")
  valid_589022 = validateParameter(valid_589022, JBool, required = false,
                                 default = newJBool(true))
  if valid_589022 != nil:
    section.add "prettyPrint", valid_589022
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

proc call*(call_589024: Call_YoutubeActivitiesInsert_589012; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Posts a bulletin for a specific channel. (The user submitting the request must be authorized to act on the channel's behalf.)
  ## 
  ## Note: Even though an activity resource can contain information about actions like a user rating a video or marking a video as a favorite, you need to use other API methods to generate those activity resources. For example, you would use the API's videos.rate() method to rate a video and the playlistItems.insert() method to mark a video as a favorite.
  ## 
  let valid = call_589024.validator(path, query, header, formData, body)
  let scheme = call_589024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589024.url(scheme.get, call_589024.host, call_589024.base,
                         call_589024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589024, url, valid)

proc call*(call_589025: Call_YoutubeActivitiesInsert_589012; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeActivitiesInsert
  ## Posts a bulletin for a specific channel. (The user submitting the request must be authorized to act on the channel's behalf.)
  ## 
  ## Note: Even though an activity resource can contain information about actions like a user rating a video or marking a video as a favorite, you need to use other API methods to generate those activity resources. For example, you would use the API's videos.rate() method to rate a video and the playlistItems.insert() method to mark a video as a favorite.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589026 = newJObject()
  var body_589027 = newJObject()
  add(query_589026, "fields", newJString(fields))
  add(query_589026, "quotaUser", newJString(quotaUser))
  add(query_589026, "alt", newJString(alt))
  add(query_589026, "oauth_token", newJString(oauthToken))
  add(query_589026, "userIp", newJString(userIp))
  add(query_589026, "part", newJString(part))
  add(query_589026, "key", newJString(key))
  if body != nil:
    body_589027 = body
  add(query_589026, "prettyPrint", newJBool(prettyPrint))
  result = call_589025.call(nil, query_589026, nil, nil, body_589027)

var youtubeActivitiesInsert* = Call_YoutubeActivitiesInsert_589012(
    name: "youtubeActivitiesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/activities",
    validator: validate_YoutubeActivitiesInsert_589013, base: "/youtube/v3",
    url: url_YoutubeActivitiesInsert_589014, schemes: {Scheme.Https})
type
  Call_YoutubeActivitiesList_588734 = ref object of OpenApiRestCall_588466
proc url_YoutubeActivitiesList_588736(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeActivitiesList_588735(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of channel activity events that match the request criteria. For example, you can retrieve events associated with a particular channel, events associated with the user's subscriptions and Google+ friends, or the YouTube home page feed, which is customized for each user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   mine: JBool
  ##       : Set this parameter's value to true to retrieve a feed of the authenticated user's activities.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   publishedAfter: JString
  ##                 : The publishedAfter parameter specifies the earliest date and time that an activity could have occurred for that activity to be included in the API response. If the parameter value specifies a day, but not a time, then any activities that occurred that day will be included in the result set. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   alt: JString
  ##      : Data format for the response.
  ##   home: JBool
  ##       : Set this parameter's value to true to retrieve the activity feed that displays on the YouTube home page for the currently authenticated user.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more activity resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in an activity resource, the snippet property contains other properties that identify the type of activity, a display title for the activity, and so forth. If you set part=snippet, the API response will also contain all of those nested properties.
  ##   channelId: JString
  ##            : The channelId parameter specifies a unique YouTube channel ID. The API will then return a list of that channel's activities.
  ##   regionCode: JString
  ##             : The regionCode parameter instructs the API to return results for the specified country. The parameter value is an ISO 3166-1 alpha-2 country code. YouTube uses this value when the authorized user's previous activity on YouTube does not provide enough information to generate the activity feed.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   publishedBefore: JString
  ##                  : The publishedBefore parameter specifies the date and time before which an activity must have occurred for that activity to be included in the API response. If the parameter value specifies a day, but not a time, then any activities that occurred that day will be excluded from the result set. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588848 = query.getOrDefault("mine")
  valid_588848 = validateParameter(valid_588848, JBool, required = false, default = nil)
  if valid_588848 != nil:
    section.add "mine", valid_588848
  var valid_588849 = query.getOrDefault("fields")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = nil)
  if valid_588849 != nil:
    section.add "fields", valid_588849
  var valid_588850 = query.getOrDefault("publishedAfter")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "publishedAfter", valid_588850
  var valid_588851 = query.getOrDefault("quotaUser")
  valid_588851 = validateParameter(valid_588851, JString, required = false,
                                 default = nil)
  if valid_588851 != nil:
    section.add "quotaUser", valid_588851
  var valid_588852 = query.getOrDefault("pageToken")
  valid_588852 = validateParameter(valid_588852, JString, required = false,
                                 default = nil)
  if valid_588852 != nil:
    section.add "pageToken", valid_588852
  var valid_588866 = query.getOrDefault("alt")
  valid_588866 = validateParameter(valid_588866, JString, required = false,
                                 default = newJString("json"))
  if valid_588866 != nil:
    section.add "alt", valid_588866
  var valid_588867 = query.getOrDefault("home")
  valid_588867 = validateParameter(valid_588867, JBool, required = false, default = nil)
  if valid_588867 != nil:
    section.add "home", valid_588867
  var valid_588868 = query.getOrDefault("oauth_token")
  valid_588868 = validateParameter(valid_588868, JString, required = false,
                                 default = nil)
  if valid_588868 != nil:
    section.add "oauth_token", valid_588868
  var valid_588869 = query.getOrDefault("userIp")
  valid_588869 = validateParameter(valid_588869, JString, required = false,
                                 default = nil)
  if valid_588869 != nil:
    section.add "userIp", valid_588869
  var valid_588871 = query.getOrDefault("maxResults")
  valid_588871 = validateParameter(valid_588871, JInt, required = false,
                                 default = newJInt(5))
  if valid_588871 != nil:
    section.add "maxResults", valid_588871
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_588872 = query.getOrDefault("part")
  valid_588872 = validateParameter(valid_588872, JString, required = true,
                                 default = nil)
  if valid_588872 != nil:
    section.add "part", valid_588872
  var valid_588873 = query.getOrDefault("channelId")
  valid_588873 = validateParameter(valid_588873, JString, required = false,
                                 default = nil)
  if valid_588873 != nil:
    section.add "channelId", valid_588873
  var valid_588874 = query.getOrDefault("regionCode")
  valid_588874 = validateParameter(valid_588874, JString, required = false,
                                 default = nil)
  if valid_588874 != nil:
    section.add "regionCode", valid_588874
  var valid_588875 = query.getOrDefault("key")
  valid_588875 = validateParameter(valid_588875, JString, required = false,
                                 default = nil)
  if valid_588875 != nil:
    section.add "key", valid_588875
  var valid_588876 = query.getOrDefault("publishedBefore")
  valid_588876 = validateParameter(valid_588876, JString, required = false,
                                 default = nil)
  if valid_588876 != nil:
    section.add "publishedBefore", valid_588876
  var valid_588877 = query.getOrDefault("prettyPrint")
  valid_588877 = validateParameter(valid_588877, JBool, required = false,
                                 default = newJBool(true))
  if valid_588877 != nil:
    section.add "prettyPrint", valid_588877
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588900: Call_YoutubeActivitiesList_588734; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of channel activity events that match the request criteria. For example, you can retrieve events associated with a particular channel, events associated with the user's subscriptions and Google+ friends, or the YouTube home page feed, which is customized for each user.
  ## 
  let valid = call_588900.validator(path, query, header, formData, body)
  let scheme = call_588900.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588900.url(scheme.get, call_588900.host, call_588900.base,
                         call_588900.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588900, url, valid)

proc call*(call_588971: Call_YoutubeActivitiesList_588734; part: string;
          mine: bool = false; fields: string = ""; publishedAfter: string = "";
          quotaUser: string = ""; pageToken: string = ""; alt: string = "json";
          home: bool = false; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 5; channelId: string = ""; regionCode: string = "";
          key: string = ""; publishedBefore: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeActivitiesList
  ## Returns a list of channel activity events that match the request criteria. For example, you can retrieve events associated with a particular channel, events associated with the user's subscriptions and Google+ friends, or the YouTube home page feed, which is customized for each user.
  ##   mine: bool
  ##       : Set this parameter's value to true to retrieve a feed of the authenticated user's activities.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   publishedAfter: string
  ##                 : The publishedAfter parameter specifies the earliest date and time that an activity could have occurred for that activity to be included in the API response. If the parameter value specifies a day, but not a time, then any activities that occurred that day will be included in the result set. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   alt: string
  ##      : Data format for the response.
  ##   home: bool
  ##       : Set this parameter's value to true to retrieve the activity feed that displays on the YouTube home page for the currently authenticated user.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more activity resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in an activity resource, the snippet property contains other properties that identify the type of activity, a display title for the activity, and so forth. If you set part=snippet, the API response will also contain all of those nested properties.
  ##   channelId: string
  ##            : The channelId parameter specifies a unique YouTube channel ID. The API will then return a list of that channel's activities.
  ##   regionCode: string
  ##             : The regionCode parameter instructs the API to return results for the specified country. The parameter value is an ISO 3166-1 alpha-2 country code. YouTube uses this value when the authorized user's previous activity on YouTube does not provide enough information to generate the activity feed.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   publishedBefore: string
  ##                  : The publishedBefore parameter specifies the date and time before which an activity must have occurred for that activity to be included in the API response. If the parameter value specifies a day, but not a time, then any activities that occurred that day will be excluded from the result set. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_588972 = newJObject()
  add(query_588972, "mine", newJBool(mine))
  add(query_588972, "fields", newJString(fields))
  add(query_588972, "publishedAfter", newJString(publishedAfter))
  add(query_588972, "quotaUser", newJString(quotaUser))
  add(query_588972, "pageToken", newJString(pageToken))
  add(query_588972, "alt", newJString(alt))
  add(query_588972, "home", newJBool(home))
  add(query_588972, "oauth_token", newJString(oauthToken))
  add(query_588972, "userIp", newJString(userIp))
  add(query_588972, "maxResults", newJInt(maxResults))
  add(query_588972, "part", newJString(part))
  add(query_588972, "channelId", newJString(channelId))
  add(query_588972, "regionCode", newJString(regionCode))
  add(query_588972, "key", newJString(key))
  add(query_588972, "publishedBefore", newJString(publishedBefore))
  add(query_588972, "prettyPrint", newJBool(prettyPrint))
  result = call_588971.call(nil, query_588972, nil, nil, nil)

var youtubeActivitiesList* = Call_YoutubeActivitiesList_588734(
    name: "youtubeActivitiesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/activities",
    validator: validate_YoutubeActivitiesList_588735, base: "/youtube/v3",
    url: url_YoutubeActivitiesList_588736, schemes: {Scheme.Https})
type
  Call_YoutubeCaptionsUpdate_589046 = ref object of OpenApiRestCall_588466
proc url_YoutubeCaptionsUpdate_589048(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCaptionsUpdate_589047(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a caption track. When updating a caption track, you can change the track's draft status, upload a new caption file for the track, or both.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   sync: JBool
  ##       : Note: The API server only processes the parameter value if the request contains an updated caption file.
  ## 
  ## The sync parameter indicates whether YouTube should automatically synchronize the caption file with the audio track of the video. If you set the value to true, YouTube will automatically synchronize the caption track with the audio track.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   onBehalfOf: JString
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include. Set the property value to snippet if you are updating the track's draft status. Otherwise, set the property value to id.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589049 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "onBehalfOfContentOwner", valid_589049
  var valid_589050 = query.getOrDefault("fields")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "fields", valid_589050
  var valid_589051 = query.getOrDefault("quotaUser")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "quotaUser", valid_589051
  var valid_589052 = query.getOrDefault("sync")
  valid_589052 = validateParameter(valid_589052, JBool, required = false, default = nil)
  if valid_589052 != nil:
    section.add "sync", valid_589052
  var valid_589053 = query.getOrDefault("alt")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = newJString("json"))
  if valid_589053 != nil:
    section.add "alt", valid_589053
  var valid_589054 = query.getOrDefault("oauth_token")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "oauth_token", valid_589054
  var valid_589055 = query.getOrDefault("userIp")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "userIp", valid_589055
  var valid_589056 = query.getOrDefault("onBehalfOf")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "onBehalfOf", valid_589056
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589057 = query.getOrDefault("part")
  valid_589057 = validateParameter(valid_589057, JString, required = true,
                                 default = nil)
  if valid_589057 != nil:
    section.add "part", valid_589057
  var valid_589058 = query.getOrDefault("key")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "key", valid_589058
  var valid_589059 = query.getOrDefault("prettyPrint")
  valid_589059 = validateParameter(valid_589059, JBool, required = false,
                                 default = newJBool(true))
  if valid_589059 != nil:
    section.add "prettyPrint", valid_589059
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

proc call*(call_589061: Call_YoutubeCaptionsUpdate_589046; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a caption track. When updating a caption track, you can change the track's draft status, upload a new caption file for the track, or both.
  ## 
  let valid = call_589061.validator(path, query, header, formData, body)
  let scheme = call_589061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589061.url(scheme.get, call_589061.host, call_589061.base,
                         call_589061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589061, url, valid)

proc call*(call_589062: Call_YoutubeCaptionsUpdate_589046; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; sync: bool = false; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; onBehalfOf: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeCaptionsUpdate
  ## Updates a caption track. When updating a caption track, you can change the track's draft status, upload a new caption file for the track, or both.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   sync: bool
  ##       : Note: The API server only processes the parameter value if the request contains an updated caption file.
  ## 
  ## The sync parameter indicates whether YouTube should automatically synchronize the caption file with the audio track of the video. If you set the value to true, YouTube will automatically synchronize the caption track with the audio track.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   onBehalfOf: string
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include. Set the property value to snippet if you are updating the track's draft status. Otherwise, set the property value to id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589063 = newJObject()
  var body_589064 = newJObject()
  add(query_589063, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589063, "fields", newJString(fields))
  add(query_589063, "quotaUser", newJString(quotaUser))
  add(query_589063, "sync", newJBool(sync))
  add(query_589063, "alt", newJString(alt))
  add(query_589063, "oauth_token", newJString(oauthToken))
  add(query_589063, "userIp", newJString(userIp))
  add(query_589063, "onBehalfOf", newJString(onBehalfOf))
  add(query_589063, "part", newJString(part))
  add(query_589063, "key", newJString(key))
  if body != nil:
    body_589064 = body
  add(query_589063, "prettyPrint", newJBool(prettyPrint))
  result = call_589062.call(nil, query_589063, nil, nil, body_589064)

var youtubeCaptionsUpdate* = Call_YoutubeCaptionsUpdate_589046(
    name: "youtubeCaptionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/captions",
    validator: validate_YoutubeCaptionsUpdate_589047, base: "/youtube/v3",
    url: url_YoutubeCaptionsUpdate_589048, schemes: {Scheme.Https})
type
  Call_YoutubeCaptionsInsert_589065 = ref object of OpenApiRestCall_588466
proc url_YoutubeCaptionsInsert_589067(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCaptionsInsert_589066(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads a caption track.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   sync: JBool
  ##       : The sync parameter indicates whether YouTube should automatically synchronize the caption file with the audio track of the video. If you set the value to true, YouTube will disregard any time codes that are in the uploaded caption file and generate new time codes for the captions.
  ## 
  ## You should set the sync parameter to true if you are uploading a transcript, which has no time codes, or if you suspect the time codes in your file are incorrect and want YouTube to try to fix them.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   onBehalfOf: JString
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
  ##   part: JString (required)
  ##       : The part parameter specifies the caption resource parts that the API response will include. Set the parameter value to snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589068 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "onBehalfOfContentOwner", valid_589068
  var valid_589069 = query.getOrDefault("fields")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "fields", valid_589069
  var valid_589070 = query.getOrDefault("quotaUser")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "quotaUser", valid_589070
  var valid_589071 = query.getOrDefault("sync")
  valid_589071 = validateParameter(valid_589071, JBool, required = false, default = nil)
  if valid_589071 != nil:
    section.add "sync", valid_589071
  var valid_589072 = query.getOrDefault("alt")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = newJString("json"))
  if valid_589072 != nil:
    section.add "alt", valid_589072
  var valid_589073 = query.getOrDefault("oauth_token")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "oauth_token", valid_589073
  var valid_589074 = query.getOrDefault("userIp")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "userIp", valid_589074
  var valid_589075 = query.getOrDefault("onBehalfOf")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "onBehalfOf", valid_589075
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589076 = query.getOrDefault("part")
  valid_589076 = validateParameter(valid_589076, JString, required = true,
                                 default = nil)
  if valid_589076 != nil:
    section.add "part", valid_589076
  var valid_589077 = query.getOrDefault("key")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "key", valid_589077
  var valid_589078 = query.getOrDefault("prettyPrint")
  valid_589078 = validateParameter(valid_589078, JBool, required = false,
                                 default = newJBool(true))
  if valid_589078 != nil:
    section.add "prettyPrint", valid_589078
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

proc call*(call_589080: Call_YoutubeCaptionsInsert_589065; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads a caption track.
  ## 
  let valid = call_589080.validator(path, query, header, formData, body)
  let scheme = call_589080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589080.url(scheme.get, call_589080.host, call_589080.base,
                         call_589080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589080, url, valid)

proc call*(call_589081: Call_YoutubeCaptionsInsert_589065; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; sync: bool = false; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; onBehalfOf: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeCaptionsInsert
  ## Uploads a caption track.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   sync: bool
  ##       : The sync parameter indicates whether YouTube should automatically synchronize the caption file with the audio track of the video. If you set the value to true, YouTube will disregard any time codes that are in the uploaded caption file and generate new time codes for the captions.
  ## 
  ## You should set the sync parameter to true if you are uploading a transcript, which has no time codes, or if you suspect the time codes in your file are incorrect and want YouTube to try to fix them.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   onBehalfOf: string
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
  ##   part: string (required)
  ##       : The part parameter specifies the caption resource parts that the API response will include. Set the parameter value to snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589082 = newJObject()
  var body_589083 = newJObject()
  add(query_589082, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589082, "fields", newJString(fields))
  add(query_589082, "quotaUser", newJString(quotaUser))
  add(query_589082, "sync", newJBool(sync))
  add(query_589082, "alt", newJString(alt))
  add(query_589082, "oauth_token", newJString(oauthToken))
  add(query_589082, "userIp", newJString(userIp))
  add(query_589082, "onBehalfOf", newJString(onBehalfOf))
  add(query_589082, "part", newJString(part))
  add(query_589082, "key", newJString(key))
  if body != nil:
    body_589083 = body
  add(query_589082, "prettyPrint", newJBool(prettyPrint))
  result = call_589081.call(nil, query_589082, nil, nil, body_589083)

var youtubeCaptionsInsert* = Call_YoutubeCaptionsInsert_589065(
    name: "youtubeCaptionsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/captions",
    validator: validate_YoutubeCaptionsInsert_589066, base: "/youtube/v3",
    url: url_YoutubeCaptionsInsert_589067, schemes: {Scheme.Https})
type
  Call_YoutubeCaptionsList_589028 = ref object of OpenApiRestCall_588466
proc url_YoutubeCaptionsList_589030(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCaptionsList_589029(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns a list of caption tracks that are associated with a specified video. Note that the API response does not contain the actual captions and that the captions.download method provides the ability to retrieve a caption track.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of IDs that identify the caption resources that should be retrieved. Each ID must identify a caption track associated with the specified video.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   onBehalfOf: JString
  ##             : ID of the Google+ Page for the channel that the request is on behalf of.
  ##   videoId: JString (required)
  ##          : The videoId parameter specifies the YouTube video ID of the video for which the API should return caption tracks.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more caption resource parts that the API response will include. The part names that you can include in the parameter value are id and snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589031 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "onBehalfOfContentOwner", valid_589031
  var valid_589032 = query.getOrDefault("fields")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "fields", valid_589032
  var valid_589033 = query.getOrDefault("quotaUser")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "quotaUser", valid_589033
  var valid_589034 = query.getOrDefault("id")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "id", valid_589034
  var valid_589035 = query.getOrDefault("alt")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = newJString("json"))
  if valid_589035 != nil:
    section.add "alt", valid_589035
  var valid_589036 = query.getOrDefault("oauth_token")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "oauth_token", valid_589036
  var valid_589037 = query.getOrDefault("userIp")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "userIp", valid_589037
  var valid_589038 = query.getOrDefault("onBehalfOf")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "onBehalfOf", valid_589038
  assert query != nil, "query argument is necessary due to required `videoId` field"
  var valid_589039 = query.getOrDefault("videoId")
  valid_589039 = validateParameter(valid_589039, JString, required = true,
                                 default = nil)
  if valid_589039 != nil:
    section.add "videoId", valid_589039
  var valid_589040 = query.getOrDefault("part")
  valid_589040 = validateParameter(valid_589040, JString, required = true,
                                 default = nil)
  if valid_589040 != nil:
    section.add "part", valid_589040
  var valid_589041 = query.getOrDefault("key")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "key", valid_589041
  var valid_589042 = query.getOrDefault("prettyPrint")
  valid_589042 = validateParameter(valid_589042, JBool, required = false,
                                 default = newJBool(true))
  if valid_589042 != nil:
    section.add "prettyPrint", valid_589042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589043: Call_YoutubeCaptionsList_589028; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of caption tracks that are associated with a specified video. Note that the API response does not contain the actual captions and that the captions.download method provides the ability to retrieve a caption track.
  ## 
  let valid = call_589043.validator(path, query, header, formData, body)
  let scheme = call_589043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589043.url(scheme.get, call_589043.host, call_589043.base,
                         call_589043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589043, url, valid)

proc call*(call_589044: Call_YoutubeCaptionsList_589028; videoId: string;
          part: string; onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; id: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; onBehalfOf: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeCaptionsList
  ## Returns a list of caption tracks that are associated with a specified video. Note that the API response does not contain the actual captions and that the captions.download method provides the ability to retrieve a caption track.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of IDs that identify the caption resources that should be retrieved. Each ID must identify a caption track associated with the specified video.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   onBehalfOf: string
  ##             : ID of the Google+ Page for the channel that the request is on behalf of.
  ##   videoId: string (required)
  ##          : The videoId parameter specifies the YouTube video ID of the video for which the API should return caption tracks.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more caption resource parts that the API response will include. The part names that you can include in the parameter value are id and snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589045 = newJObject()
  add(query_589045, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589045, "fields", newJString(fields))
  add(query_589045, "quotaUser", newJString(quotaUser))
  add(query_589045, "id", newJString(id))
  add(query_589045, "alt", newJString(alt))
  add(query_589045, "oauth_token", newJString(oauthToken))
  add(query_589045, "userIp", newJString(userIp))
  add(query_589045, "onBehalfOf", newJString(onBehalfOf))
  add(query_589045, "videoId", newJString(videoId))
  add(query_589045, "part", newJString(part))
  add(query_589045, "key", newJString(key))
  add(query_589045, "prettyPrint", newJBool(prettyPrint))
  result = call_589044.call(nil, query_589045, nil, nil, nil)

var youtubeCaptionsList* = Call_YoutubeCaptionsList_589028(
    name: "youtubeCaptionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/captions",
    validator: validate_YoutubeCaptionsList_589029, base: "/youtube/v3",
    url: url_YoutubeCaptionsList_589030, schemes: {Scheme.Https})
type
  Call_YoutubeCaptionsDelete_589084 = ref object of OpenApiRestCall_588466
proc url_YoutubeCaptionsDelete_589086(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCaptionsDelete_589085(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a specified caption track.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter identifies the caption track that is being deleted. The value is a caption track ID as identified by the id property in a caption resource.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   onBehalfOf: JString
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589087 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "onBehalfOfContentOwner", valid_589087
  var valid_589088 = query.getOrDefault("fields")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "fields", valid_589088
  var valid_589089 = query.getOrDefault("quotaUser")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "quotaUser", valid_589089
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_589090 = query.getOrDefault("id")
  valid_589090 = validateParameter(valid_589090, JString, required = true,
                                 default = nil)
  if valid_589090 != nil:
    section.add "id", valid_589090
  var valid_589091 = query.getOrDefault("alt")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = newJString("json"))
  if valid_589091 != nil:
    section.add "alt", valid_589091
  var valid_589092 = query.getOrDefault("oauth_token")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "oauth_token", valid_589092
  var valid_589093 = query.getOrDefault("userIp")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "userIp", valid_589093
  var valid_589094 = query.getOrDefault("onBehalfOf")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "onBehalfOf", valid_589094
  var valid_589095 = query.getOrDefault("key")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "key", valid_589095
  var valid_589096 = query.getOrDefault("prettyPrint")
  valid_589096 = validateParameter(valid_589096, JBool, required = false,
                                 default = newJBool(true))
  if valid_589096 != nil:
    section.add "prettyPrint", valid_589096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589097: Call_YoutubeCaptionsDelete_589084; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a specified caption track.
  ## 
  let valid = call_589097.validator(path, query, header, formData, body)
  let scheme = call_589097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589097.url(scheme.get, call_589097.host, call_589097.base,
                         call_589097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589097, url, valid)

proc call*(call_589098: Call_YoutubeCaptionsDelete_589084; id: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; onBehalfOf: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## youtubeCaptionsDelete
  ## Deletes a specified caption track.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter identifies the caption track that is being deleted. The value is a caption track ID as identified by the id property in a caption resource.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   onBehalfOf: string
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589099 = newJObject()
  add(query_589099, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589099, "fields", newJString(fields))
  add(query_589099, "quotaUser", newJString(quotaUser))
  add(query_589099, "id", newJString(id))
  add(query_589099, "alt", newJString(alt))
  add(query_589099, "oauth_token", newJString(oauthToken))
  add(query_589099, "userIp", newJString(userIp))
  add(query_589099, "onBehalfOf", newJString(onBehalfOf))
  add(query_589099, "key", newJString(key))
  add(query_589099, "prettyPrint", newJBool(prettyPrint))
  result = call_589098.call(nil, query_589099, nil, nil, nil)

var youtubeCaptionsDelete* = Call_YoutubeCaptionsDelete_589084(
    name: "youtubeCaptionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/captions",
    validator: validate_YoutubeCaptionsDelete_589085, base: "/youtube/v3",
    url: url_YoutubeCaptionsDelete_589086, schemes: {Scheme.Https})
type
  Call_YoutubeCaptionsDownload_589100 = ref object of OpenApiRestCall_588466
proc url_YoutubeCaptionsDownload_589102(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/captions/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_YoutubeCaptionsDownload_589101(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Downloads a caption track. The caption track is returned in its original format unless the request specifies a value for the tfmt parameter and in its original language unless the request specifies a value for the tlang parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The id parameter identifies the caption track that is being retrieved. The value is a caption track ID as identified by the id property in a caption resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_589117 = path.getOrDefault("id")
  valid_589117 = validateParameter(valid_589117, JString, required = true,
                                 default = nil)
  if valid_589117 != nil:
    section.add "id", valid_589117
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   tfmt: JString
  ##       : The tfmt parameter specifies that the caption track should be returned in a specific format. If the parameter is not included in the request, the track is returned in its original format.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   onBehalfOf: JString
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
  ##   tlang: JString
  ##        : The tlang parameter specifies that the API response should return a translation of the specified caption track. The parameter value is an ISO 639-1 two-letter language code that identifies the desired caption language. The translation is generated by using machine translation, such as Google Translate.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589118 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "onBehalfOfContentOwner", valid_589118
  var valid_589119 = query.getOrDefault("tfmt")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = newJString("sbv"))
  if valid_589119 != nil:
    section.add "tfmt", valid_589119
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
  var valid_589123 = query.getOrDefault("oauth_token")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "oauth_token", valid_589123
  var valid_589124 = query.getOrDefault("userIp")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "userIp", valid_589124
  var valid_589125 = query.getOrDefault("onBehalfOf")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "onBehalfOf", valid_589125
  var valid_589126 = query.getOrDefault("tlang")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "tlang", valid_589126
  var valid_589127 = query.getOrDefault("key")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "key", valid_589127
  var valid_589128 = query.getOrDefault("prettyPrint")
  valid_589128 = validateParameter(valid_589128, JBool, required = false,
                                 default = newJBool(true))
  if valid_589128 != nil:
    section.add "prettyPrint", valid_589128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589129: Call_YoutubeCaptionsDownload_589100; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Downloads a caption track. The caption track is returned in its original format unless the request specifies a value for the tfmt parameter and in its original language unless the request specifies a value for the tlang parameter.
  ## 
  let valid = call_589129.validator(path, query, header, formData, body)
  let scheme = call_589129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589129.url(scheme.get, call_589129.host, call_589129.base,
                         call_589129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589129, url, valid)

proc call*(call_589130: Call_YoutubeCaptionsDownload_589100; id: string;
          onBehalfOfContentOwner: string = ""; tfmt: string = "sbv";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; onBehalfOf: string = "";
          tlang: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeCaptionsDownload
  ## Downloads a caption track. The caption track is returned in its original format unless the request specifies a value for the tfmt parameter and in its original language unless the request specifies a value for the tlang parameter.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   tfmt: string
  ##       : The tfmt parameter specifies that the caption track should be returned in a specific format. If the parameter is not included in the request, the track is returned in its original format.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   onBehalfOf: string
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
  ##   tlang: string
  ##        : The tlang parameter specifies that the API response should return a translation of the specified caption track. The parameter value is an ISO 639-1 two-letter language code that identifies the desired caption language. The translation is generated by using machine translation, such as Google Translate.
  ##   id: string (required)
  ##     : The id parameter identifies the caption track that is being retrieved. The value is a caption track ID as identified by the id property in a caption resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589131 = newJObject()
  var query_589132 = newJObject()
  add(query_589132, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589132, "tfmt", newJString(tfmt))
  add(query_589132, "fields", newJString(fields))
  add(query_589132, "quotaUser", newJString(quotaUser))
  add(query_589132, "alt", newJString(alt))
  add(query_589132, "oauth_token", newJString(oauthToken))
  add(query_589132, "userIp", newJString(userIp))
  add(query_589132, "onBehalfOf", newJString(onBehalfOf))
  add(query_589132, "tlang", newJString(tlang))
  add(path_589131, "id", newJString(id))
  add(query_589132, "key", newJString(key))
  add(query_589132, "prettyPrint", newJBool(prettyPrint))
  result = call_589130.call(path_589131, query_589132, nil, nil, nil)

var youtubeCaptionsDownload* = Call_YoutubeCaptionsDownload_589100(
    name: "youtubeCaptionsDownload", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/captions/{id}",
    validator: validate_YoutubeCaptionsDownload_589101, base: "/youtube/v3",
    url: url_YoutubeCaptionsDownload_589102, schemes: {Scheme.Https})
type
  Call_YoutubeChannelBannersInsert_589133 = ref object of OpenApiRestCall_588466
proc url_YoutubeChannelBannersInsert_589135(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeChannelBannersInsert_589134(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads a channel banner image to YouTube. This method represents the first two steps in a three-step process to update the banner image for a channel:
  ## 
  ## - Call the channelBanners.insert method to upload the binary image data to YouTube. The image must have a 16:9 aspect ratio and be at least 2120x1192 pixels.
  ## - Extract the url property's value from the response that the API returns for step 1.
  ## - Call the channels.update method to update the channel's branding settings. Set the brandingSettings.image.bannerExternalUrl property's value to the URL obtained in step 2.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   channelId: JString
  ##            : The channelId parameter identifies the YouTube channel to which the banner is uploaded. The channelId parameter was introduced as a required parameter in May 2017. As this was a backward-incompatible change, channelBanners.insert requests that do not specify this parameter will not return an error until six months have passed from the time that the parameter was introduced. Please see the API Terms of Service for the official policy regarding backward incompatible changes and the API revision history for the exact date that the parameter was introduced.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589136 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "onBehalfOfContentOwner", valid_589136
  var valid_589137 = query.getOrDefault("fields")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "fields", valid_589137
  var valid_589138 = query.getOrDefault("quotaUser")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "quotaUser", valid_589138
  var valid_589139 = query.getOrDefault("alt")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = newJString("json"))
  if valid_589139 != nil:
    section.add "alt", valid_589139
  var valid_589140 = query.getOrDefault("oauth_token")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "oauth_token", valid_589140
  var valid_589141 = query.getOrDefault("userIp")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "userIp", valid_589141
  var valid_589142 = query.getOrDefault("channelId")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "channelId", valid_589142
  var valid_589143 = query.getOrDefault("key")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "key", valid_589143
  var valid_589144 = query.getOrDefault("prettyPrint")
  valid_589144 = validateParameter(valid_589144, JBool, required = false,
                                 default = newJBool(true))
  if valid_589144 != nil:
    section.add "prettyPrint", valid_589144
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

proc call*(call_589146: Call_YoutubeChannelBannersInsert_589133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads a channel banner image to YouTube. This method represents the first two steps in a three-step process to update the banner image for a channel:
  ## 
  ## - Call the channelBanners.insert method to upload the binary image data to YouTube. The image must have a 16:9 aspect ratio and be at least 2120x1192 pixels.
  ## - Extract the url property's value from the response that the API returns for step 1.
  ## - Call the channels.update method to update the channel's branding settings. Set the brandingSettings.image.bannerExternalUrl property's value to the URL obtained in step 2.
  ## 
  let valid = call_589146.validator(path, query, header, formData, body)
  let scheme = call_589146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589146.url(scheme.get, call_589146.host, call_589146.base,
                         call_589146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589146, url, valid)

proc call*(call_589147: Call_YoutubeChannelBannersInsert_589133;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; channelId: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeChannelBannersInsert
  ## Uploads a channel banner image to YouTube. This method represents the first two steps in a three-step process to update the banner image for a channel:
  ## 
  ## - Call the channelBanners.insert method to upload the binary image data to YouTube. The image must have a 16:9 aspect ratio and be at least 2120x1192 pixels.
  ## - Extract the url property's value from the response that the API returns for step 1.
  ## - Call the channels.update method to update the channel's branding settings. Set the brandingSettings.image.bannerExternalUrl property's value to the URL obtained in step 2.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   channelId: string
  ##            : The channelId parameter identifies the YouTube channel to which the banner is uploaded. The channelId parameter was introduced as a required parameter in May 2017. As this was a backward-incompatible change, channelBanners.insert requests that do not specify this parameter will not return an error until six months have passed from the time that the parameter was introduced. Please see the API Terms of Service for the official policy regarding backward incompatible changes and the API revision history for the exact date that the parameter was introduced.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589148 = newJObject()
  var body_589149 = newJObject()
  add(query_589148, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589148, "fields", newJString(fields))
  add(query_589148, "quotaUser", newJString(quotaUser))
  add(query_589148, "alt", newJString(alt))
  add(query_589148, "oauth_token", newJString(oauthToken))
  add(query_589148, "userIp", newJString(userIp))
  add(query_589148, "channelId", newJString(channelId))
  add(query_589148, "key", newJString(key))
  if body != nil:
    body_589149 = body
  add(query_589148, "prettyPrint", newJBool(prettyPrint))
  result = call_589147.call(nil, query_589148, nil, nil, body_589149)

var youtubeChannelBannersInsert* = Call_YoutubeChannelBannersInsert_589133(
    name: "youtubeChannelBannersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/channelBanners/insert",
    validator: validate_YoutubeChannelBannersInsert_589134, base: "/youtube/v3",
    url: url_YoutubeChannelBannersInsert_589135, schemes: {Scheme.Https})
type
  Call_YoutubeChannelSectionsUpdate_589169 = ref object of OpenApiRestCall_588466
proc url_YoutubeChannelSectionsUpdate_589171(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeChannelSectionsUpdate_589170(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a channelSection.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part names that you can include in the parameter value are snippet and contentDetails.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589172 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "onBehalfOfContentOwner", valid_589172
  var valid_589173 = query.getOrDefault("fields")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "fields", valid_589173
  var valid_589174 = query.getOrDefault("quotaUser")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "quotaUser", valid_589174
  var valid_589175 = query.getOrDefault("alt")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = newJString("json"))
  if valid_589175 != nil:
    section.add "alt", valid_589175
  var valid_589176 = query.getOrDefault("oauth_token")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "oauth_token", valid_589176
  var valid_589177 = query.getOrDefault("userIp")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "userIp", valid_589177
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589178 = query.getOrDefault("part")
  valid_589178 = validateParameter(valid_589178, JString, required = true,
                                 default = nil)
  if valid_589178 != nil:
    section.add "part", valid_589178
  var valid_589179 = query.getOrDefault("key")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "key", valid_589179
  var valid_589180 = query.getOrDefault("prettyPrint")
  valid_589180 = validateParameter(valid_589180, JBool, required = false,
                                 default = newJBool(true))
  if valid_589180 != nil:
    section.add "prettyPrint", valid_589180
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

proc call*(call_589182: Call_YoutubeChannelSectionsUpdate_589169; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a channelSection.
  ## 
  let valid = call_589182.validator(path, query, header, formData, body)
  let scheme = call_589182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589182.url(scheme.get, call_589182.host, call_589182.base,
                         call_589182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589182, url, valid)

proc call*(call_589183: Call_YoutubeChannelSectionsUpdate_589169; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## youtubeChannelSectionsUpdate
  ## Update a channelSection.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part names that you can include in the parameter value are snippet and contentDetails.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589184 = newJObject()
  var body_589185 = newJObject()
  add(query_589184, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589184, "fields", newJString(fields))
  add(query_589184, "quotaUser", newJString(quotaUser))
  add(query_589184, "alt", newJString(alt))
  add(query_589184, "oauth_token", newJString(oauthToken))
  add(query_589184, "userIp", newJString(userIp))
  add(query_589184, "part", newJString(part))
  add(query_589184, "key", newJString(key))
  if body != nil:
    body_589185 = body
  add(query_589184, "prettyPrint", newJBool(prettyPrint))
  result = call_589183.call(nil, query_589184, nil, nil, body_589185)

var youtubeChannelSectionsUpdate* = Call_YoutubeChannelSectionsUpdate_589169(
    name: "youtubeChannelSectionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/channelSections",
    validator: validate_YoutubeChannelSectionsUpdate_589170, base: "/youtube/v3",
    url: url_YoutubeChannelSectionsUpdate_589171, schemes: {Scheme.Https})
type
  Call_YoutubeChannelSectionsInsert_589186 = ref object of OpenApiRestCall_588466
proc url_YoutubeChannelSectionsInsert_589188(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeChannelSectionsInsert_589187(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a channelSection for the authenticated user's channel.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part names that you can include in the parameter value are snippet and contentDetails.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_589189 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "onBehalfOfContentOwner", valid_589189
  var valid_589190 = query.getOrDefault("fields")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "fields", valid_589190
  var valid_589191 = query.getOrDefault("quotaUser")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "quotaUser", valid_589191
  var valid_589192 = query.getOrDefault("alt")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = newJString("json"))
  if valid_589192 != nil:
    section.add "alt", valid_589192
  var valid_589193 = query.getOrDefault("oauth_token")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "oauth_token", valid_589193
  var valid_589194 = query.getOrDefault("userIp")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "userIp", valid_589194
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589195 = query.getOrDefault("part")
  valid_589195 = validateParameter(valid_589195, JString, required = true,
                                 default = nil)
  if valid_589195 != nil:
    section.add "part", valid_589195
  var valid_589196 = query.getOrDefault("key")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "key", valid_589196
  var valid_589197 = query.getOrDefault("prettyPrint")
  valid_589197 = validateParameter(valid_589197, JBool, required = false,
                                 default = newJBool(true))
  if valid_589197 != nil:
    section.add "prettyPrint", valid_589197
  var valid_589198 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_589198
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

proc call*(call_589200: Call_YoutubeChannelSectionsInsert_589186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a channelSection for the authenticated user's channel.
  ## 
  let valid = call_589200.validator(path, query, header, formData, body)
  let scheme = call_589200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589200.url(scheme.get, call_589200.host, call_589200.base,
                         call_589200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589200, url, valid)

proc call*(call_589201: Call_YoutubeChannelSectionsInsert_589186; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeChannelSectionsInsert
  ## Adds a channelSection for the authenticated user's channel.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part names that you can include in the parameter value are snippet and contentDetails.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_589202 = newJObject()
  var body_589203 = newJObject()
  add(query_589202, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589202, "fields", newJString(fields))
  add(query_589202, "quotaUser", newJString(quotaUser))
  add(query_589202, "alt", newJString(alt))
  add(query_589202, "oauth_token", newJString(oauthToken))
  add(query_589202, "userIp", newJString(userIp))
  add(query_589202, "part", newJString(part))
  add(query_589202, "key", newJString(key))
  if body != nil:
    body_589203 = body
  add(query_589202, "prettyPrint", newJBool(prettyPrint))
  add(query_589202, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_589201.call(nil, query_589202, nil, nil, body_589203)

var youtubeChannelSectionsInsert* = Call_YoutubeChannelSectionsInsert_589186(
    name: "youtubeChannelSectionsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/channelSections",
    validator: validate_YoutubeChannelSectionsInsert_589187, base: "/youtube/v3",
    url: url_YoutubeChannelSectionsInsert_589188, schemes: {Scheme.Https})
type
  Call_YoutubeChannelSectionsList_589150 = ref object of OpenApiRestCall_588466
proc url_YoutubeChannelSectionsList_589152(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeChannelSectionsList_589151(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns channelSection resources that match the API request criteria.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: JBool
  ##       : Set this parameter's value to true to retrieve a feed of the authenticated user's channelSections.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of the YouTube channelSection ID(s) for the resource(s) that are being retrieved. In a channelSection resource, the id property specifies the YouTube channelSection ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more channelSection resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, and contentDetails.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a channelSection resource, the snippet property contains other properties, such as a display title for the channelSection. If you set part=snippet, the API response will also contain all of those nested properties.
  ##   channelId: JString
  ##            : The channelId parameter specifies a YouTube channel ID. The API will only return that channel's channelSections.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   hl: JString
  ##     : The hl parameter indicates that the snippet.localized property values in the returned channelSection resources should be in the specified language if localized values for that language are available. For example, if the API request specifies hl=de, the snippet.localized properties in the API response will contain German titles if German titles are available. Channel owners can provide localized channel section titles using either the channelSections.insert or channelSections.update method.
  section = newJObject()
  var valid_589153 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "onBehalfOfContentOwner", valid_589153
  var valid_589154 = query.getOrDefault("mine")
  valid_589154 = validateParameter(valid_589154, JBool, required = false, default = nil)
  if valid_589154 != nil:
    section.add "mine", valid_589154
  var valid_589155 = query.getOrDefault("fields")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "fields", valid_589155
  var valid_589156 = query.getOrDefault("quotaUser")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "quotaUser", valid_589156
  var valid_589157 = query.getOrDefault("id")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "id", valid_589157
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
  var valid_589160 = query.getOrDefault("userIp")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "userIp", valid_589160
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589161 = query.getOrDefault("part")
  valid_589161 = validateParameter(valid_589161, JString, required = true,
                                 default = nil)
  if valid_589161 != nil:
    section.add "part", valid_589161
  var valid_589162 = query.getOrDefault("channelId")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "channelId", valid_589162
  var valid_589163 = query.getOrDefault("key")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "key", valid_589163
  var valid_589164 = query.getOrDefault("prettyPrint")
  valid_589164 = validateParameter(valid_589164, JBool, required = false,
                                 default = newJBool(true))
  if valid_589164 != nil:
    section.add "prettyPrint", valid_589164
  var valid_589165 = query.getOrDefault("hl")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "hl", valid_589165
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589166: Call_YoutubeChannelSectionsList_589150; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns channelSection resources that match the API request criteria.
  ## 
  let valid = call_589166.validator(path, query, header, formData, body)
  let scheme = call_589166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589166.url(scheme.get, call_589166.host, call_589166.base,
                         call_589166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589166, url, valid)

proc call*(call_589167: Call_YoutubeChannelSectionsList_589150; part: string;
          onBehalfOfContentOwner: string = ""; mine: bool = false; fields: string = "";
          quotaUser: string = ""; id: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; channelId: string = "";
          key: string = ""; prettyPrint: bool = true; hl: string = ""): Recallable =
  ## youtubeChannelSectionsList
  ## Returns channelSection resources that match the API request criteria.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: bool
  ##       : Set this parameter's value to true to retrieve a feed of the authenticated user's channelSections.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of the YouTube channelSection ID(s) for the resource(s) that are being retrieved. In a channelSection resource, the id property specifies the YouTube channelSection ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more channelSection resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, and contentDetails.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a channelSection resource, the snippet property contains other properties, such as a display title for the channelSection. If you set part=snippet, the API response will also contain all of those nested properties.
  ##   channelId: string
  ##            : The channelId parameter specifies a YouTube channel ID. The API will only return that channel's channelSections.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   hl: string
  ##     : The hl parameter indicates that the snippet.localized property values in the returned channelSection resources should be in the specified language if localized values for that language are available. For example, if the API request specifies hl=de, the snippet.localized properties in the API response will contain German titles if German titles are available. Channel owners can provide localized channel section titles using either the channelSections.insert or channelSections.update method.
  var query_589168 = newJObject()
  add(query_589168, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589168, "mine", newJBool(mine))
  add(query_589168, "fields", newJString(fields))
  add(query_589168, "quotaUser", newJString(quotaUser))
  add(query_589168, "id", newJString(id))
  add(query_589168, "alt", newJString(alt))
  add(query_589168, "oauth_token", newJString(oauthToken))
  add(query_589168, "userIp", newJString(userIp))
  add(query_589168, "part", newJString(part))
  add(query_589168, "channelId", newJString(channelId))
  add(query_589168, "key", newJString(key))
  add(query_589168, "prettyPrint", newJBool(prettyPrint))
  add(query_589168, "hl", newJString(hl))
  result = call_589167.call(nil, query_589168, nil, nil, nil)

var youtubeChannelSectionsList* = Call_YoutubeChannelSectionsList_589150(
    name: "youtubeChannelSectionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/channelSections",
    validator: validate_YoutubeChannelSectionsList_589151, base: "/youtube/v3",
    url: url_YoutubeChannelSectionsList_589152, schemes: {Scheme.Https})
type
  Call_YoutubeChannelSectionsDelete_589204 = ref object of OpenApiRestCall_588466
proc url_YoutubeChannelSectionsDelete_589206(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeChannelSectionsDelete_589205(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a channelSection.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube channelSection ID for the resource that is being deleted. In a channelSection resource, the id property specifies the YouTube channelSection ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589207 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "onBehalfOfContentOwner", valid_589207
  var valid_589208 = query.getOrDefault("fields")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "fields", valid_589208
  var valid_589209 = query.getOrDefault("quotaUser")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "quotaUser", valid_589209
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_589210 = query.getOrDefault("id")
  valid_589210 = validateParameter(valid_589210, JString, required = true,
                                 default = nil)
  if valid_589210 != nil:
    section.add "id", valid_589210
  var valid_589211 = query.getOrDefault("alt")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = newJString("json"))
  if valid_589211 != nil:
    section.add "alt", valid_589211
  var valid_589212 = query.getOrDefault("oauth_token")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = nil)
  if valid_589212 != nil:
    section.add "oauth_token", valid_589212
  var valid_589213 = query.getOrDefault("userIp")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "userIp", valid_589213
  var valid_589214 = query.getOrDefault("key")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "key", valid_589214
  var valid_589215 = query.getOrDefault("prettyPrint")
  valid_589215 = validateParameter(valid_589215, JBool, required = false,
                                 default = newJBool(true))
  if valid_589215 != nil:
    section.add "prettyPrint", valid_589215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589216: Call_YoutubeChannelSectionsDelete_589204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a channelSection.
  ## 
  let valid = call_589216.validator(path, query, header, formData, body)
  let scheme = call_589216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589216.url(scheme.get, call_589216.host, call_589216.base,
                         call_589216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589216, url, valid)

proc call*(call_589217: Call_YoutubeChannelSectionsDelete_589204; id: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeChannelSectionsDelete
  ## Deletes a channelSection.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube channelSection ID for the resource that is being deleted. In a channelSection resource, the id property specifies the YouTube channelSection ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589218 = newJObject()
  add(query_589218, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589218, "fields", newJString(fields))
  add(query_589218, "quotaUser", newJString(quotaUser))
  add(query_589218, "id", newJString(id))
  add(query_589218, "alt", newJString(alt))
  add(query_589218, "oauth_token", newJString(oauthToken))
  add(query_589218, "userIp", newJString(userIp))
  add(query_589218, "key", newJString(key))
  add(query_589218, "prettyPrint", newJBool(prettyPrint))
  result = call_589217.call(nil, query_589218, nil, nil, nil)

var youtubeChannelSectionsDelete* = Call_YoutubeChannelSectionsDelete_589204(
    name: "youtubeChannelSectionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/channelSections",
    validator: validate_YoutubeChannelSectionsDelete_589205, base: "/youtube/v3",
    url: url_YoutubeChannelSectionsDelete_589206, schemes: {Scheme.Https})
type
  Call_YoutubeChannelsUpdate_589243 = ref object of OpenApiRestCall_588466
proc url_YoutubeChannelsUpdate_589245(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeChannelsUpdate_589244(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a channel's metadata. Note that this method currently only supports updates to the channel resource's brandingSettings and invideoPromotion objects and their child properties.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : The onBehalfOfContentOwner parameter indicates that the authenticated user is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with needs to be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The API currently only allows the parameter value to be set to either brandingSettings or invideoPromotion. (You cannot update both of those parts with a single request.)
  ## 
  ## Note that this method overrides the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589246 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = nil)
  if valid_589246 != nil:
    section.add "onBehalfOfContentOwner", valid_589246
  var valid_589247 = query.getOrDefault("fields")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "fields", valid_589247
  var valid_589248 = query.getOrDefault("quotaUser")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "quotaUser", valid_589248
  var valid_589249 = query.getOrDefault("alt")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = newJString("json"))
  if valid_589249 != nil:
    section.add "alt", valid_589249
  var valid_589250 = query.getOrDefault("oauth_token")
  valid_589250 = validateParameter(valid_589250, JString, required = false,
                                 default = nil)
  if valid_589250 != nil:
    section.add "oauth_token", valid_589250
  var valid_589251 = query.getOrDefault("userIp")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "userIp", valid_589251
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589252 = query.getOrDefault("part")
  valid_589252 = validateParameter(valid_589252, JString, required = true,
                                 default = nil)
  if valid_589252 != nil:
    section.add "part", valid_589252
  var valid_589253 = query.getOrDefault("key")
  valid_589253 = validateParameter(valid_589253, JString, required = false,
                                 default = nil)
  if valid_589253 != nil:
    section.add "key", valid_589253
  var valid_589254 = query.getOrDefault("prettyPrint")
  valid_589254 = validateParameter(valid_589254, JBool, required = false,
                                 default = newJBool(true))
  if valid_589254 != nil:
    section.add "prettyPrint", valid_589254
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

proc call*(call_589256: Call_YoutubeChannelsUpdate_589243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a channel's metadata. Note that this method currently only supports updates to the channel resource's brandingSettings and invideoPromotion objects and their child properties.
  ## 
  let valid = call_589256.validator(path, query, header, formData, body)
  let scheme = call_589256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589256.url(scheme.get, call_589256.host, call_589256.base,
                         call_589256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589256, url, valid)

proc call*(call_589257: Call_YoutubeChannelsUpdate_589243; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## youtubeChannelsUpdate
  ## Updates a channel's metadata. Note that this method currently only supports updates to the channel resource's brandingSettings and invideoPromotion objects and their child properties.
  ##   onBehalfOfContentOwner: string
  ##                         : The onBehalfOfContentOwner parameter indicates that the authenticated user is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with needs to be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The API currently only allows the parameter value to be set to either brandingSettings or invideoPromotion. (You cannot update both of those parts with a single request.)
  ## 
  ## Note that this method overrides the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589258 = newJObject()
  var body_589259 = newJObject()
  add(query_589258, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589258, "fields", newJString(fields))
  add(query_589258, "quotaUser", newJString(quotaUser))
  add(query_589258, "alt", newJString(alt))
  add(query_589258, "oauth_token", newJString(oauthToken))
  add(query_589258, "userIp", newJString(userIp))
  add(query_589258, "part", newJString(part))
  add(query_589258, "key", newJString(key))
  if body != nil:
    body_589259 = body
  add(query_589258, "prettyPrint", newJBool(prettyPrint))
  result = call_589257.call(nil, query_589258, nil, nil, body_589259)

var youtubeChannelsUpdate* = Call_YoutubeChannelsUpdate_589243(
    name: "youtubeChannelsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/channels",
    validator: validate_YoutubeChannelsUpdate_589244, base: "/youtube/v3",
    url: url_YoutubeChannelsUpdate_589245, schemes: {Scheme.Https})
type
  Call_YoutubeChannelsList_589219 = ref object of OpenApiRestCall_588466
proc url_YoutubeChannelsList_589221(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeChannelsList_589220(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns a collection of zero or more channel resources that match the request criteria.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: JBool
  ##       : Set this parameter's value to true to instruct the API to only return channels owned by the authenticated user.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of the YouTube channel ID(s) for the resource(s) that are being retrieved. In a channel resource, the id property specifies the channel's YouTube channel ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   mySubscribers: JBool
  ##                : Use the subscriptions.list method and its mySubscribers parameter to retrieve a list of subscribers to the authenticated user's channel.
  ##   forUsername: JString
  ##              : The forUsername parameter specifies a YouTube username, thereby requesting the channel associated with that username.
  ##   categoryId: JString
  ##             : The categoryId parameter specifies a YouTube guide category, thereby requesting YouTube channels associated with that category.
  ##   managedByMe: JBool
  ##              : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## Set this parameter's value to true to instruct the API to only return channels managed by the content owner that the onBehalfOfContentOwner parameter specifies. The user must be authenticated as a CMS account linked to the specified content owner and onBehalfOfContentOwner must be provided.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more channel resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a channel resource, the contentDetails property contains other properties, such as the uploads properties. As such, if you set part=contentDetails, the API response will also contain all of those nested properties.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   hl: JString
  ##     : The hl parameter should be used for filter out the properties that are not in the given language. Used for the brandingSettings part.
  section = newJObject()
  var valid_589222 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "onBehalfOfContentOwner", valid_589222
  var valid_589223 = query.getOrDefault("mine")
  valid_589223 = validateParameter(valid_589223, JBool, required = false, default = nil)
  if valid_589223 != nil:
    section.add "mine", valid_589223
  var valid_589224 = query.getOrDefault("fields")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "fields", valid_589224
  var valid_589225 = query.getOrDefault("pageToken")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "pageToken", valid_589225
  var valid_589226 = query.getOrDefault("quotaUser")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "quotaUser", valid_589226
  var valid_589227 = query.getOrDefault("id")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "id", valid_589227
  var valid_589228 = query.getOrDefault("alt")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = newJString("json"))
  if valid_589228 != nil:
    section.add "alt", valid_589228
  var valid_589229 = query.getOrDefault("mySubscribers")
  valid_589229 = validateParameter(valid_589229, JBool, required = false, default = nil)
  if valid_589229 != nil:
    section.add "mySubscribers", valid_589229
  var valid_589230 = query.getOrDefault("forUsername")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "forUsername", valid_589230
  var valid_589231 = query.getOrDefault("categoryId")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "categoryId", valid_589231
  var valid_589232 = query.getOrDefault("managedByMe")
  valid_589232 = validateParameter(valid_589232, JBool, required = false, default = nil)
  if valid_589232 != nil:
    section.add "managedByMe", valid_589232
  var valid_589233 = query.getOrDefault("oauth_token")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = nil)
  if valid_589233 != nil:
    section.add "oauth_token", valid_589233
  var valid_589234 = query.getOrDefault("userIp")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "userIp", valid_589234
  var valid_589235 = query.getOrDefault("maxResults")
  valid_589235 = validateParameter(valid_589235, JInt, required = false,
                                 default = newJInt(5))
  if valid_589235 != nil:
    section.add "maxResults", valid_589235
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589236 = query.getOrDefault("part")
  valid_589236 = validateParameter(valid_589236, JString, required = true,
                                 default = nil)
  if valid_589236 != nil:
    section.add "part", valid_589236
  var valid_589237 = query.getOrDefault("key")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "key", valid_589237
  var valid_589238 = query.getOrDefault("prettyPrint")
  valid_589238 = validateParameter(valid_589238, JBool, required = false,
                                 default = newJBool(true))
  if valid_589238 != nil:
    section.add "prettyPrint", valid_589238
  var valid_589239 = query.getOrDefault("hl")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = nil)
  if valid_589239 != nil:
    section.add "hl", valid_589239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589240: Call_YoutubeChannelsList_589219; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of zero or more channel resources that match the request criteria.
  ## 
  let valid = call_589240.validator(path, query, header, formData, body)
  let scheme = call_589240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589240.url(scheme.get, call_589240.host, call_589240.base,
                         call_589240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589240, url, valid)

proc call*(call_589241: Call_YoutubeChannelsList_589219; part: string;
          onBehalfOfContentOwner: string = ""; mine: bool = false; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; id: string = "";
          alt: string = "json"; mySubscribers: bool = false; forUsername: string = "";
          categoryId: string = ""; managedByMe: bool = false; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 5; key: string = "";
          prettyPrint: bool = true; hl: string = ""): Recallable =
  ## youtubeChannelsList
  ## Returns a collection of zero or more channel resources that match the request criteria.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: bool
  ##       : Set this parameter's value to true to instruct the API to only return channels owned by the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of the YouTube channel ID(s) for the resource(s) that are being retrieved. In a channel resource, the id property specifies the channel's YouTube channel ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   mySubscribers: bool
  ##                : Use the subscriptions.list method and its mySubscribers parameter to retrieve a list of subscribers to the authenticated user's channel.
  ##   forUsername: string
  ##              : The forUsername parameter specifies a YouTube username, thereby requesting the channel associated with that username.
  ##   categoryId: string
  ##             : The categoryId parameter specifies a YouTube guide category, thereby requesting YouTube channels associated with that category.
  ##   managedByMe: bool
  ##              : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## Set this parameter's value to true to instruct the API to only return channels managed by the content owner that the onBehalfOfContentOwner parameter specifies. The user must be authenticated as a CMS account linked to the specified content owner and onBehalfOfContentOwner must be provided.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more channel resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a channel resource, the contentDetails property contains other properties, such as the uploads properties. As such, if you set part=contentDetails, the API response will also contain all of those nested properties.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   hl: string
  ##     : The hl parameter should be used for filter out the properties that are not in the given language. Used for the brandingSettings part.
  var query_589242 = newJObject()
  add(query_589242, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589242, "mine", newJBool(mine))
  add(query_589242, "fields", newJString(fields))
  add(query_589242, "pageToken", newJString(pageToken))
  add(query_589242, "quotaUser", newJString(quotaUser))
  add(query_589242, "id", newJString(id))
  add(query_589242, "alt", newJString(alt))
  add(query_589242, "mySubscribers", newJBool(mySubscribers))
  add(query_589242, "forUsername", newJString(forUsername))
  add(query_589242, "categoryId", newJString(categoryId))
  add(query_589242, "managedByMe", newJBool(managedByMe))
  add(query_589242, "oauth_token", newJString(oauthToken))
  add(query_589242, "userIp", newJString(userIp))
  add(query_589242, "maxResults", newJInt(maxResults))
  add(query_589242, "part", newJString(part))
  add(query_589242, "key", newJString(key))
  add(query_589242, "prettyPrint", newJBool(prettyPrint))
  add(query_589242, "hl", newJString(hl))
  result = call_589241.call(nil, query_589242, nil, nil, nil)

var youtubeChannelsList* = Call_YoutubeChannelsList_589219(
    name: "youtubeChannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/channels",
    validator: validate_YoutubeChannelsList_589220, base: "/youtube/v3",
    url: url_YoutubeChannelsList_589221, schemes: {Scheme.Https})
type
  Call_YoutubeCommentThreadsUpdate_589284 = ref object of OpenApiRestCall_588466
proc url_YoutubeCommentThreadsUpdate_589286(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCommentThreadsUpdate_589285(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies the top-level comment in a comment thread.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of commentThread resource properties that the API response will include. You must at least include the snippet part in the parameter value since that part contains all of the properties that the API request can update.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589287 = query.getOrDefault("fields")
  valid_589287 = validateParameter(valid_589287, JString, required = false,
                                 default = nil)
  if valid_589287 != nil:
    section.add "fields", valid_589287
  var valid_589288 = query.getOrDefault("quotaUser")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = nil)
  if valid_589288 != nil:
    section.add "quotaUser", valid_589288
  var valid_589289 = query.getOrDefault("alt")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = newJString("json"))
  if valid_589289 != nil:
    section.add "alt", valid_589289
  var valid_589290 = query.getOrDefault("oauth_token")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = nil)
  if valid_589290 != nil:
    section.add "oauth_token", valid_589290
  var valid_589291 = query.getOrDefault("userIp")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = nil)
  if valid_589291 != nil:
    section.add "userIp", valid_589291
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589292 = query.getOrDefault("part")
  valid_589292 = validateParameter(valid_589292, JString, required = true,
                                 default = nil)
  if valid_589292 != nil:
    section.add "part", valid_589292
  var valid_589293 = query.getOrDefault("key")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "key", valid_589293
  var valid_589294 = query.getOrDefault("prettyPrint")
  valid_589294 = validateParameter(valid_589294, JBool, required = false,
                                 default = newJBool(true))
  if valid_589294 != nil:
    section.add "prettyPrint", valid_589294
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

proc call*(call_589296: Call_YoutubeCommentThreadsUpdate_589284; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies the top-level comment in a comment thread.
  ## 
  let valid = call_589296.validator(path, query, header, formData, body)
  let scheme = call_589296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589296.url(scheme.get, call_589296.host, call_589296.base,
                         call_589296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589296, url, valid)

proc call*(call_589297: Call_YoutubeCommentThreadsUpdate_589284; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeCommentThreadsUpdate
  ## Modifies the top-level comment in a comment thread.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of commentThread resource properties that the API response will include. You must at least include the snippet part in the parameter value since that part contains all of the properties that the API request can update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589298 = newJObject()
  var body_589299 = newJObject()
  add(query_589298, "fields", newJString(fields))
  add(query_589298, "quotaUser", newJString(quotaUser))
  add(query_589298, "alt", newJString(alt))
  add(query_589298, "oauth_token", newJString(oauthToken))
  add(query_589298, "userIp", newJString(userIp))
  add(query_589298, "part", newJString(part))
  add(query_589298, "key", newJString(key))
  if body != nil:
    body_589299 = body
  add(query_589298, "prettyPrint", newJBool(prettyPrint))
  result = call_589297.call(nil, query_589298, nil, nil, body_589299)

var youtubeCommentThreadsUpdate* = Call_YoutubeCommentThreadsUpdate_589284(
    name: "youtubeCommentThreadsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/commentThreads",
    validator: validate_YoutubeCommentThreadsUpdate_589285, base: "/youtube/v3",
    url: url_YoutubeCommentThreadsUpdate_589286, schemes: {Scheme.Https})
type
  Call_YoutubeCommentThreadsInsert_589300 = ref object of OpenApiRestCall_588466
proc url_YoutubeCommentThreadsInsert_589302(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCommentThreadsInsert_589301(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new top-level comment. To add a reply to an existing comment, use the comments.insert method instead.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter identifies the properties that the API response will include. Set the parameter value to snippet. The snippet part has a quota cost of 2 units.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589303 = query.getOrDefault("fields")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = nil)
  if valid_589303 != nil:
    section.add "fields", valid_589303
  var valid_589304 = query.getOrDefault("quotaUser")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = nil)
  if valid_589304 != nil:
    section.add "quotaUser", valid_589304
  var valid_589305 = query.getOrDefault("alt")
  valid_589305 = validateParameter(valid_589305, JString, required = false,
                                 default = newJString("json"))
  if valid_589305 != nil:
    section.add "alt", valid_589305
  var valid_589306 = query.getOrDefault("oauth_token")
  valid_589306 = validateParameter(valid_589306, JString, required = false,
                                 default = nil)
  if valid_589306 != nil:
    section.add "oauth_token", valid_589306
  var valid_589307 = query.getOrDefault("userIp")
  valid_589307 = validateParameter(valid_589307, JString, required = false,
                                 default = nil)
  if valid_589307 != nil:
    section.add "userIp", valid_589307
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589308 = query.getOrDefault("part")
  valid_589308 = validateParameter(valid_589308, JString, required = true,
                                 default = nil)
  if valid_589308 != nil:
    section.add "part", valid_589308
  var valid_589309 = query.getOrDefault("key")
  valid_589309 = validateParameter(valid_589309, JString, required = false,
                                 default = nil)
  if valid_589309 != nil:
    section.add "key", valid_589309
  var valid_589310 = query.getOrDefault("prettyPrint")
  valid_589310 = validateParameter(valid_589310, JBool, required = false,
                                 default = newJBool(true))
  if valid_589310 != nil:
    section.add "prettyPrint", valid_589310
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

proc call*(call_589312: Call_YoutubeCommentThreadsInsert_589300; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new top-level comment. To add a reply to an existing comment, use the comments.insert method instead.
  ## 
  let valid = call_589312.validator(path, query, header, formData, body)
  let scheme = call_589312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589312.url(scheme.get, call_589312.host, call_589312.base,
                         call_589312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589312, url, valid)

proc call*(call_589313: Call_YoutubeCommentThreadsInsert_589300; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeCommentThreadsInsert
  ## Creates a new top-level comment. To add a reply to an existing comment, use the comments.insert method instead.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter identifies the properties that the API response will include. Set the parameter value to snippet. The snippet part has a quota cost of 2 units.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589314 = newJObject()
  var body_589315 = newJObject()
  add(query_589314, "fields", newJString(fields))
  add(query_589314, "quotaUser", newJString(quotaUser))
  add(query_589314, "alt", newJString(alt))
  add(query_589314, "oauth_token", newJString(oauthToken))
  add(query_589314, "userIp", newJString(userIp))
  add(query_589314, "part", newJString(part))
  add(query_589314, "key", newJString(key))
  if body != nil:
    body_589315 = body
  add(query_589314, "prettyPrint", newJBool(prettyPrint))
  result = call_589313.call(nil, query_589314, nil, nil, body_589315)

var youtubeCommentThreadsInsert* = Call_YoutubeCommentThreadsInsert_589300(
    name: "youtubeCommentThreadsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/commentThreads",
    validator: validate_YoutubeCommentThreadsInsert_589301, base: "/youtube/v3",
    url: url_YoutubeCommentThreadsInsert_589302, schemes: {Scheme.Https})
type
  Call_YoutubeCommentThreadsList_589260 = ref object of OpenApiRestCall_588466
proc url_YoutubeCommentThreadsList_589262(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCommentThreadsList_589261(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of comment threads that match the API request parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   textFormat: JString
  ##             : Set this parameter's value to html or plainText to instruct the API to return the comments left by users in html formatted or in plain text.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken property identifies the next page of the result that can be retrieved.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of comment thread IDs for the resources that should be retrieved.
  ##   alt: JString
  ##      : Data format for the response.
  ##   order: JString
  ##        : The order parameter specifies the order in which the API response should list comment threads. Valid values are: 
  ## - time - Comment threads are ordered by time. This is the default behavior.
  ## - relevance - Comment threads are ordered by relevance.Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   videoId: JString
  ##          : The videoId parameter instructs the API to return comment threads associated with the specified video ID.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more commentThread resource properties that the API response will include.
  ##   channelId: JString
  ##            : The channelId parameter instructs the API to return comment threads containing comments about the specified channel. (The response will not include comments left on videos that the channel uploaded.)
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   moderationStatus: JString
  ##                   : Set this parameter to limit the returned comment threads to a particular moderation state.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   allThreadsRelatedToChannelId: JString
  ##                               : The allThreadsRelatedToChannelId parameter instructs the API to return all comment threads associated with the specified channel. The response can include comments about the channel or about the channel's videos.
  ##   searchTerms: JString
  ##              : The searchTerms parameter instructs the API to limit the API response to only contain comments that contain the specified search terms.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  section = newJObject()
  var valid_589263 = query.getOrDefault("textFormat")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = newJString("html"))
  if valid_589263 != nil:
    section.add "textFormat", valid_589263
  var valid_589264 = query.getOrDefault("fields")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "fields", valid_589264
  var valid_589265 = query.getOrDefault("pageToken")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "pageToken", valid_589265
  var valid_589266 = query.getOrDefault("quotaUser")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = nil)
  if valid_589266 != nil:
    section.add "quotaUser", valid_589266
  var valid_589267 = query.getOrDefault("id")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = nil)
  if valid_589267 != nil:
    section.add "id", valid_589267
  var valid_589268 = query.getOrDefault("alt")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = newJString("json"))
  if valid_589268 != nil:
    section.add "alt", valid_589268
  var valid_589269 = query.getOrDefault("order")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = newJString("relevance"))
  if valid_589269 != nil:
    section.add "order", valid_589269
  var valid_589270 = query.getOrDefault("oauth_token")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "oauth_token", valid_589270
  var valid_589271 = query.getOrDefault("userIp")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = nil)
  if valid_589271 != nil:
    section.add "userIp", valid_589271
  var valid_589272 = query.getOrDefault("videoId")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = nil)
  if valid_589272 != nil:
    section.add "videoId", valid_589272
  var valid_589273 = query.getOrDefault("maxResults")
  valid_589273 = validateParameter(valid_589273, JInt, required = false,
                                 default = newJInt(20))
  if valid_589273 != nil:
    section.add "maxResults", valid_589273
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589274 = query.getOrDefault("part")
  valid_589274 = validateParameter(valid_589274, JString, required = true,
                                 default = nil)
  if valid_589274 != nil:
    section.add "part", valid_589274
  var valid_589275 = query.getOrDefault("channelId")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "channelId", valid_589275
  var valid_589276 = query.getOrDefault("key")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = nil)
  if valid_589276 != nil:
    section.add "key", valid_589276
  var valid_589277 = query.getOrDefault("moderationStatus")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = newJString("published"))
  if valid_589277 != nil:
    section.add "moderationStatus", valid_589277
  var valid_589278 = query.getOrDefault("prettyPrint")
  valid_589278 = validateParameter(valid_589278, JBool, required = false,
                                 default = newJBool(true))
  if valid_589278 != nil:
    section.add "prettyPrint", valid_589278
  var valid_589279 = query.getOrDefault("allThreadsRelatedToChannelId")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "allThreadsRelatedToChannelId", valid_589279
  var valid_589280 = query.getOrDefault("searchTerms")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = nil)
  if valid_589280 != nil:
    section.add "searchTerms", valid_589280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589281: Call_YoutubeCommentThreadsList_589260; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of comment threads that match the API request parameters.
  ## 
  let valid = call_589281.validator(path, query, header, formData, body)
  let scheme = call_589281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589281.url(scheme.get, call_589281.host, call_589281.base,
                         call_589281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589281, url, valid)

proc call*(call_589282: Call_YoutubeCommentThreadsList_589260; part: string;
          textFormat: string = "html"; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; id: string = ""; alt: string = "json";
          order: string = "relevance"; oauthToken: string = ""; userIp: string = "";
          videoId: string = ""; maxResults: int = 20; channelId: string = "";
          key: string = ""; moderationStatus: string = "published";
          prettyPrint: bool = true; allThreadsRelatedToChannelId: string = "";
          searchTerms: string = ""): Recallable =
  ## youtubeCommentThreadsList
  ## Returns a list of comment threads that match the API request parameters.
  ##   textFormat: string
  ##             : Set this parameter's value to html or plainText to instruct the API to return the comments left by users in html formatted or in plain text.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken property identifies the next page of the result that can be retrieved.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of comment thread IDs for the resources that should be retrieved.
  ##   alt: string
  ##      : Data format for the response.
  ##   order: string
  ##        : The order parameter specifies the order in which the API response should list comment threads. Valid values are: 
  ## - time - Comment threads are ordered by time. This is the default behavior.
  ## - relevance - Comment threads are ordered by relevance.Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   videoId: string
  ##          : The videoId parameter instructs the API to return comment threads associated with the specified video ID.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more commentThread resource properties that the API response will include.
  ##   channelId: string
  ##            : The channelId parameter instructs the API to return comment threads containing comments about the specified channel. (The response will not include comments left on videos that the channel uploaded.)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   moderationStatus: string
  ##                   : Set this parameter to limit the returned comment threads to a particular moderation state.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   allThreadsRelatedToChannelId: string
  ##                               : The allThreadsRelatedToChannelId parameter instructs the API to return all comment threads associated with the specified channel. The response can include comments about the channel or about the channel's videos.
  ##   searchTerms: string
  ##              : The searchTerms parameter instructs the API to limit the API response to only contain comments that contain the specified search terms.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  var query_589283 = newJObject()
  add(query_589283, "textFormat", newJString(textFormat))
  add(query_589283, "fields", newJString(fields))
  add(query_589283, "pageToken", newJString(pageToken))
  add(query_589283, "quotaUser", newJString(quotaUser))
  add(query_589283, "id", newJString(id))
  add(query_589283, "alt", newJString(alt))
  add(query_589283, "order", newJString(order))
  add(query_589283, "oauth_token", newJString(oauthToken))
  add(query_589283, "userIp", newJString(userIp))
  add(query_589283, "videoId", newJString(videoId))
  add(query_589283, "maxResults", newJInt(maxResults))
  add(query_589283, "part", newJString(part))
  add(query_589283, "channelId", newJString(channelId))
  add(query_589283, "key", newJString(key))
  add(query_589283, "moderationStatus", newJString(moderationStatus))
  add(query_589283, "prettyPrint", newJBool(prettyPrint))
  add(query_589283, "allThreadsRelatedToChannelId",
      newJString(allThreadsRelatedToChannelId))
  add(query_589283, "searchTerms", newJString(searchTerms))
  result = call_589282.call(nil, query_589283, nil, nil, nil)

var youtubeCommentThreadsList* = Call_YoutubeCommentThreadsList_589260(
    name: "youtubeCommentThreadsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/commentThreads",
    validator: validate_YoutubeCommentThreadsList_589261, base: "/youtube/v3",
    url: url_YoutubeCommentThreadsList_589262, schemes: {Scheme.Https})
type
  Call_YoutubeCommentsUpdate_589335 = ref object of OpenApiRestCall_588466
proc url_YoutubeCommentsUpdate_589337(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCommentsUpdate_589336(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies a comment.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter identifies the properties that the API response will include. You must at least include the snippet part in the parameter value since that part contains all of the properties that the API request can update.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589338 = query.getOrDefault("fields")
  valid_589338 = validateParameter(valid_589338, JString, required = false,
                                 default = nil)
  if valid_589338 != nil:
    section.add "fields", valid_589338
  var valid_589339 = query.getOrDefault("quotaUser")
  valid_589339 = validateParameter(valid_589339, JString, required = false,
                                 default = nil)
  if valid_589339 != nil:
    section.add "quotaUser", valid_589339
  var valid_589340 = query.getOrDefault("alt")
  valid_589340 = validateParameter(valid_589340, JString, required = false,
                                 default = newJString("json"))
  if valid_589340 != nil:
    section.add "alt", valid_589340
  var valid_589341 = query.getOrDefault("oauth_token")
  valid_589341 = validateParameter(valid_589341, JString, required = false,
                                 default = nil)
  if valid_589341 != nil:
    section.add "oauth_token", valid_589341
  var valid_589342 = query.getOrDefault("userIp")
  valid_589342 = validateParameter(valid_589342, JString, required = false,
                                 default = nil)
  if valid_589342 != nil:
    section.add "userIp", valid_589342
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589343 = query.getOrDefault("part")
  valid_589343 = validateParameter(valid_589343, JString, required = true,
                                 default = nil)
  if valid_589343 != nil:
    section.add "part", valid_589343
  var valid_589344 = query.getOrDefault("key")
  valid_589344 = validateParameter(valid_589344, JString, required = false,
                                 default = nil)
  if valid_589344 != nil:
    section.add "key", valid_589344
  var valid_589345 = query.getOrDefault("prettyPrint")
  valid_589345 = validateParameter(valid_589345, JBool, required = false,
                                 default = newJBool(true))
  if valid_589345 != nil:
    section.add "prettyPrint", valid_589345
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

proc call*(call_589347: Call_YoutubeCommentsUpdate_589335; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies a comment.
  ## 
  let valid = call_589347.validator(path, query, header, formData, body)
  let scheme = call_589347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589347.url(scheme.get, call_589347.host, call_589347.base,
                         call_589347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589347, url, valid)

proc call*(call_589348: Call_YoutubeCommentsUpdate_589335; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeCommentsUpdate
  ## Modifies a comment.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter identifies the properties that the API response will include. You must at least include the snippet part in the parameter value since that part contains all of the properties that the API request can update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589349 = newJObject()
  var body_589350 = newJObject()
  add(query_589349, "fields", newJString(fields))
  add(query_589349, "quotaUser", newJString(quotaUser))
  add(query_589349, "alt", newJString(alt))
  add(query_589349, "oauth_token", newJString(oauthToken))
  add(query_589349, "userIp", newJString(userIp))
  add(query_589349, "part", newJString(part))
  add(query_589349, "key", newJString(key))
  if body != nil:
    body_589350 = body
  add(query_589349, "prettyPrint", newJBool(prettyPrint))
  result = call_589348.call(nil, query_589349, nil, nil, body_589350)

var youtubeCommentsUpdate* = Call_YoutubeCommentsUpdate_589335(
    name: "youtubeCommentsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/comments",
    validator: validate_YoutubeCommentsUpdate_589336, base: "/youtube/v3",
    url: url_YoutubeCommentsUpdate_589337, schemes: {Scheme.Https})
type
  Call_YoutubeCommentsInsert_589351 = ref object of OpenApiRestCall_588466
proc url_YoutubeCommentsInsert_589353(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCommentsInsert_589352(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a reply to an existing comment. Note: To create a top-level comment, use the commentThreads.insert method.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter identifies the properties that the API response will include. Set the parameter value to snippet. The snippet part has a quota cost of 2 units.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589354 = query.getOrDefault("fields")
  valid_589354 = validateParameter(valid_589354, JString, required = false,
                                 default = nil)
  if valid_589354 != nil:
    section.add "fields", valid_589354
  var valid_589355 = query.getOrDefault("quotaUser")
  valid_589355 = validateParameter(valid_589355, JString, required = false,
                                 default = nil)
  if valid_589355 != nil:
    section.add "quotaUser", valid_589355
  var valid_589356 = query.getOrDefault("alt")
  valid_589356 = validateParameter(valid_589356, JString, required = false,
                                 default = newJString("json"))
  if valid_589356 != nil:
    section.add "alt", valid_589356
  var valid_589357 = query.getOrDefault("oauth_token")
  valid_589357 = validateParameter(valid_589357, JString, required = false,
                                 default = nil)
  if valid_589357 != nil:
    section.add "oauth_token", valid_589357
  var valid_589358 = query.getOrDefault("userIp")
  valid_589358 = validateParameter(valid_589358, JString, required = false,
                                 default = nil)
  if valid_589358 != nil:
    section.add "userIp", valid_589358
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589359 = query.getOrDefault("part")
  valid_589359 = validateParameter(valid_589359, JString, required = true,
                                 default = nil)
  if valid_589359 != nil:
    section.add "part", valid_589359
  var valid_589360 = query.getOrDefault("key")
  valid_589360 = validateParameter(valid_589360, JString, required = false,
                                 default = nil)
  if valid_589360 != nil:
    section.add "key", valid_589360
  var valid_589361 = query.getOrDefault("prettyPrint")
  valid_589361 = validateParameter(valid_589361, JBool, required = false,
                                 default = newJBool(true))
  if valid_589361 != nil:
    section.add "prettyPrint", valid_589361
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

proc call*(call_589363: Call_YoutubeCommentsInsert_589351; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a reply to an existing comment. Note: To create a top-level comment, use the commentThreads.insert method.
  ## 
  let valid = call_589363.validator(path, query, header, formData, body)
  let scheme = call_589363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589363.url(scheme.get, call_589363.host, call_589363.base,
                         call_589363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589363, url, valid)

proc call*(call_589364: Call_YoutubeCommentsInsert_589351; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeCommentsInsert
  ## Creates a reply to an existing comment. Note: To create a top-level comment, use the commentThreads.insert method.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter identifies the properties that the API response will include. Set the parameter value to snippet. The snippet part has a quota cost of 2 units.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589365 = newJObject()
  var body_589366 = newJObject()
  add(query_589365, "fields", newJString(fields))
  add(query_589365, "quotaUser", newJString(quotaUser))
  add(query_589365, "alt", newJString(alt))
  add(query_589365, "oauth_token", newJString(oauthToken))
  add(query_589365, "userIp", newJString(userIp))
  add(query_589365, "part", newJString(part))
  add(query_589365, "key", newJString(key))
  if body != nil:
    body_589366 = body
  add(query_589365, "prettyPrint", newJBool(prettyPrint))
  result = call_589364.call(nil, query_589365, nil, nil, body_589366)

var youtubeCommentsInsert* = Call_YoutubeCommentsInsert_589351(
    name: "youtubeCommentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/comments",
    validator: validate_YoutubeCommentsInsert_589352, base: "/youtube/v3",
    url: url_YoutubeCommentsInsert_589353, schemes: {Scheme.Https})
type
  Call_YoutubeCommentsList_589316 = ref object of OpenApiRestCall_588466
proc url_YoutubeCommentsList_589318(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCommentsList_589317(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns a list of comments that match the API request parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   textFormat: JString
  ##             : This parameter indicates whether the API should return comments formatted as HTML or as plain text.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken property identifies the next page of the result that can be retrieved.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of comment IDs for the resources that are being retrieved. In a comment resource, the id property specifies the comment's ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more comment resource properties that the API response will include.
  ##   parentId: JString
  ##           : The parentId parameter specifies the ID of the comment for which replies should be retrieved.
  ## 
  ## Note: YouTube currently supports replies only for top-level comments. However, replies to replies may be supported in the future.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589319 = query.getOrDefault("textFormat")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = newJString("html"))
  if valid_589319 != nil:
    section.add "textFormat", valid_589319
  var valid_589320 = query.getOrDefault("fields")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "fields", valid_589320
  var valid_589321 = query.getOrDefault("pageToken")
  valid_589321 = validateParameter(valid_589321, JString, required = false,
                                 default = nil)
  if valid_589321 != nil:
    section.add "pageToken", valid_589321
  var valid_589322 = query.getOrDefault("quotaUser")
  valid_589322 = validateParameter(valid_589322, JString, required = false,
                                 default = nil)
  if valid_589322 != nil:
    section.add "quotaUser", valid_589322
  var valid_589323 = query.getOrDefault("id")
  valid_589323 = validateParameter(valid_589323, JString, required = false,
                                 default = nil)
  if valid_589323 != nil:
    section.add "id", valid_589323
  var valid_589324 = query.getOrDefault("alt")
  valid_589324 = validateParameter(valid_589324, JString, required = false,
                                 default = newJString("json"))
  if valid_589324 != nil:
    section.add "alt", valid_589324
  var valid_589325 = query.getOrDefault("oauth_token")
  valid_589325 = validateParameter(valid_589325, JString, required = false,
                                 default = nil)
  if valid_589325 != nil:
    section.add "oauth_token", valid_589325
  var valid_589326 = query.getOrDefault("userIp")
  valid_589326 = validateParameter(valid_589326, JString, required = false,
                                 default = nil)
  if valid_589326 != nil:
    section.add "userIp", valid_589326
  var valid_589327 = query.getOrDefault("maxResults")
  valid_589327 = validateParameter(valid_589327, JInt, required = false,
                                 default = newJInt(20))
  if valid_589327 != nil:
    section.add "maxResults", valid_589327
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589328 = query.getOrDefault("part")
  valid_589328 = validateParameter(valid_589328, JString, required = true,
                                 default = nil)
  if valid_589328 != nil:
    section.add "part", valid_589328
  var valid_589329 = query.getOrDefault("parentId")
  valid_589329 = validateParameter(valid_589329, JString, required = false,
                                 default = nil)
  if valid_589329 != nil:
    section.add "parentId", valid_589329
  var valid_589330 = query.getOrDefault("key")
  valid_589330 = validateParameter(valid_589330, JString, required = false,
                                 default = nil)
  if valid_589330 != nil:
    section.add "key", valid_589330
  var valid_589331 = query.getOrDefault("prettyPrint")
  valid_589331 = validateParameter(valid_589331, JBool, required = false,
                                 default = newJBool(true))
  if valid_589331 != nil:
    section.add "prettyPrint", valid_589331
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589332: Call_YoutubeCommentsList_589316; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of comments that match the API request parameters.
  ## 
  let valid = call_589332.validator(path, query, header, formData, body)
  let scheme = call_589332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589332.url(scheme.get, call_589332.host, call_589332.base,
                         call_589332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589332, url, valid)

proc call*(call_589333: Call_YoutubeCommentsList_589316; part: string;
          textFormat: string = "html"; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; id: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 20;
          parentId: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeCommentsList
  ## Returns a list of comments that match the API request parameters.
  ##   textFormat: string
  ##             : This parameter indicates whether the API should return comments formatted as HTML or as plain text.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken property identifies the next page of the result that can be retrieved.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of comment IDs for the resources that are being retrieved. In a comment resource, the id property specifies the comment's ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more comment resource properties that the API response will include.
  ##   parentId: string
  ##           : The parentId parameter specifies the ID of the comment for which replies should be retrieved.
  ## 
  ## Note: YouTube currently supports replies only for top-level comments. However, replies to replies may be supported in the future.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589334 = newJObject()
  add(query_589334, "textFormat", newJString(textFormat))
  add(query_589334, "fields", newJString(fields))
  add(query_589334, "pageToken", newJString(pageToken))
  add(query_589334, "quotaUser", newJString(quotaUser))
  add(query_589334, "id", newJString(id))
  add(query_589334, "alt", newJString(alt))
  add(query_589334, "oauth_token", newJString(oauthToken))
  add(query_589334, "userIp", newJString(userIp))
  add(query_589334, "maxResults", newJInt(maxResults))
  add(query_589334, "part", newJString(part))
  add(query_589334, "parentId", newJString(parentId))
  add(query_589334, "key", newJString(key))
  add(query_589334, "prettyPrint", newJBool(prettyPrint))
  result = call_589333.call(nil, query_589334, nil, nil, nil)

var youtubeCommentsList* = Call_YoutubeCommentsList_589316(
    name: "youtubeCommentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/comments",
    validator: validate_YoutubeCommentsList_589317, base: "/youtube/v3",
    url: url_YoutubeCommentsList_589318, schemes: {Scheme.Https})
type
  Call_YoutubeCommentsDelete_589367 = ref object of OpenApiRestCall_588466
proc url_YoutubeCommentsDelete_589369(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCommentsDelete_589368(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a comment.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the comment ID for the resource that is being deleted.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589370 = query.getOrDefault("fields")
  valid_589370 = validateParameter(valid_589370, JString, required = false,
                                 default = nil)
  if valid_589370 != nil:
    section.add "fields", valid_589370
  var valid_589371 = query.getOrDefault("quotaUser")
  valid_589371 = validateParameter(valid_589371, JString, required = false,
                                 default = nil)
  if valid_589371 != nil:
    section.add "quotaUser", valid_589371
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_589372 = query.getOrDefault("id")
  valid_589372 = validateParameter(valid_589372, JString, required = true,
                                 default = nil)
  if valid_589372 != nil:
    section.add "id", valid_589372
  var valid_589373 = query.getOrDefault("alt")
  valid_589373 = validateParameter(valid_589373, JString, required = false,
                                 default = newJString("json"))
  if valid_589373 != nil:
    section.add "alt", valid_589373
  var valid_589374 = query.getOrDefault("oauth_token")
  valid_589374 = validateParameter(valid_589374, JString, required = false,
                                 default = nil)
  if valid_589374 != nil:
    section.add "oauth_token", valid_589374
  var valid_589375 = query.getOrDefault("userIp")
  valid_589375 = validateParameter(valid_589375, JString, required = false,
                                 default = nil)
  if valid_589375 != nil:
    section.add "userIp", valid_589375
  var valid_589376 = query.getOrDefault("key")
  valid_589376 = validateParameter(valid_589376, JString, required = false,
                                 default = nil)
  if valid_589376 != nil:
    section.add "key", valid_589376
  var valid_589377 = query.getOrDefault("prettyPrint")
  valid_589377 = validateParameter(valid_589377, JBool, required = false,
                                 default = newJBool(true))
  if valid_589377 != nil:
    section.add "prettyPrint", valid_589377
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589378: Call_YoutubeCommentsDelete_589367; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a comment.
  ## 
  let valid = call_589378.validator(path, query, header, formData, body)
  let scheme = call_589378.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589378.url(scheme.get, call_589378.host, call_589378.base,
                         call_589378.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589378, url, valid)

proc call*(call_589379: Call_YoutubeCommentsDelete_589367; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## youtubeCommentsDelete
  ## Deletes a comment.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the comment ID for the resource that is being deleted.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589380 = newJObject()
  add(query_589380, "fields", newJString(fields))
  add(query_589380, "quotaUser", newJString(quotaUser))
  add(query_589380, "id", newJString(id))
  add(query_589380, "alt", newJString(alt))
  add(query_589380, "oauth_token", newJString(oauthToken))
  add(query_589380, "userIp", newJString(userIp))
  add(query_589380, "key", newJString(key))
  add(query_589380, "prettyPrint", newJBool(prettyPrint))
  result = call_589379.call(nil, query_589380, nil, nil, nil)

var youtubeCommentsDelete* = Call_YoutubeCommentsDelete_589367(
    name: "youtubeCommentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/comments",
    validator: validate_YoutubeCommentsDelete_589368, base: "/youtube/v3",
    url: url_YoutubeCommentsDelete_589369, schemes: {Scheme.Https})
type
  Call_YoutubeCommentsMarkAsSpam_589381 = ref object of OpenApiRestCall_588466
proc url_YoutubeCommentsMarkAsSpam_589383(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCommentsMarkAsSpam_589382(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Expresses the caller's opinion that one or more comments should be flagged as spam.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies a comma-separated list of IDs of comments that the caller believes should be classified as spam.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589384 = query.getOrDefault("fields")
  valid_589384 = validateParameter(valid_589384, JString, required = false,
                                 default = nil)
  if valid_589384 != nil:
    section.add "fields", valid_589384
  var valid_589385 = query.getOrDefault("quotaUser")
  valid_589385 = validateParameter(valid_589385, JString, required = false,
                                 default = nil)
  if valid_589385 != nil:
    section.add "quotaUser", valid_589385
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_589386 = query.getOrDefault("id")
  valid_589386 = validateParameter(valid_589386, JString, required = true,
                                 default = nil)
  if valid_589386 != nil:
    section.add "id", valid_589386
  var valid_589387 = query.getOrDefault("alt")
  valid_589387 = validateParameter(valid_589387, JString, required = false,
                                 default = newJString("json"))
  if valid_589387 != nil:
    section.add "alt", valid_589387
  var valid_589388 = query.getOrDefault("oauth_token")
  valid_589388 = validateParameter(valid_589388, JString, required = false,
                                 default = nil)
  if valid_589388 != nil:
    section.add "oauth_token", valid_589388
  var valid_589389 = query.getOrDefault("userIp")
  valid_589389 = validateParameter(valid_589389, JString, required = false,
                                 default = nil)
  if valid_589389 != nil:
    section.add "userIp", valid_589389
  var valid_589390 = query.getOrDefault("key")
  valid_589390 = validateParameter(valid_589390, JString, required = false,
                                 default = nil)
  if valid_589390 != nil:
    section.add "key", valid_589390
  var valid_589391 = query.getOrDefault("prettyPrint")
  valid_589391 = validateParameter(valid_589391, JBool, required = false,
                                 default = newJBool(true))
  if valid_589391 != nil:
    section.add "prettyPrint", valid_589391
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589392: Call_YoutubeCommentsMarkAsSpam_589381; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Expresses the caller's opinion that one or more comments should be flagged as spam.
  ## 
  let valid = call_589392.validator(path, query, header, formData, body)
  let scheme = call_589392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589392.url(scheme.get, call_589392.host, call_589392.base,
                         call_589392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589392, url, valid)

proc call*(call_589393: Call_YoutubeCommentsMarkAsSpam_589381; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## youtubeCommentsMarkAsSpam
  ## Expresses the caller's opinion that one or more comments should be flagged as spam.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies a comma-separated list of IDs of comments that the caller believes should be classified as spam.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589394 = newJObject()
  add(query_589394, "fields", newJString(fields))
  add(query_589394, "quotaUser", newJString(quotaUser))
  add(query_589394, "id", newJString(id))
  add(query_589394, "alt", newJString(alt))
  add(query_589394, "oauth_token", newJString(oauthToken))
  add(query_589394, "userIp", newJString(userIp))
  add(query_589394, "key", newJString(key))
  add(query_589394, "prettyPrint", newJBool(prettyPrint))
  result = call_589393.call(nil, query_589394, nil, nil, nil)

var youtubeCommentsMarkAsSpam* = Call_YoutubeCommentsMarkAsSpam_589381(
    name: "youtubeCommentsMarkAsSpam", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/comments/markAsSpam",
    validator: validate_YoutubeCommentsMarkAsSpam_589382, base: "/youtube/v3",
    url: url_YoutubeCommentsMarkAsSpam_589383, schemes: {Scheme.Https})
type
  Call_YoutubeCommentsSetModerationStatus_589395 = ref object of OpenApiRestCall_588466
proc url_YoutubeCommentsSetModerationStatus_589397(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCommentsSetModerationStatus_589396(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the moderation status of one or more comments. The API request must be authorized by the owner of the channel or video associated with the comments.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies a comma-separated list of IDs that identify the comments for which you are updating the moderation status.
  ##   alt: JString
  ##      : Data format for the response.
  ##   banAuthor: JBool
  ##            : The banAuthor parameter lets you indicate that you want to automatically reject any additional comments written by the comment's author. Set the parameter value to true to ban the author.
  ## 
  ## Note: This parameter is only valid if the moderationStatus parameter is also set to rejected.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   moderationStatus: JString (required)
  ##                   : Identifies the new moderation status of the specified comments.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589398 = query.getOrDefault("fields")
  valid_589398 = validateParameter(valid_589398, JString, required = false,
                                 default = nil)
  if valid_589398 != nil:
    section.add "fields", valid_589398
  var valid_589399 = query.getOrDefault("quotaUser")
  valid_589399 = validateParameter(valid_589399, JString, required = false,
                                 default = nil)
  if valid_589399 != nil:
    section.add "quotaUser", valid_589399
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_589400 = query.getOrDefault("id")
  valid_589400 = validateParameter(valid_589400, JString, required = true,
                                 default = nil)
  if valid_589400 != nil:
    section.add "id", valid_589400
  var valid_589401 = query.getOrDefault("alt")
  valid_589401 = validateParameter(valid_589401, JString, required = false,
                                 default = newJString("json"))
  if valid_589401 != nil:
    section.add "alt", valid_589401
  var valid_589402 = query.getOrDefault("banAuthor")
  valid_589402 = validateParameter(valid_589402, JBool, required = false,
                                 default = newJBool(false))
  if valid_589402 != nil:
    section.add "banAuthor", valid_589402
  var valid_589403 = query.getOrDefault("oauth_token")
  valid_589403 = validateParameter(valid_589403, JString, required = false,
                                 default = nil)
  if valid_589403 != nil:
    section.add "oauth_token", valid_589403
  var valid_589404 = query.getOrDefault("userIp")
  valid_589404 = validateParameter(valid_589404, JString, required = false,
                                 default = nil)
  if valid_589404 != nil:
    section.add "userIp", valid_589404
  var valid_589405 = query.getOrDefault("key")
  valid_589405 = validateParameter(valid_589405, JString, required = false,
                                 default = nil)
  if valid_589405 != nil:
    section.add "key", valid_589405
  var valid_589406 = query.getOrDefault("moderationStatus")
  valid_589406 = validateParameter(valid_589406, JString, required = true,
                                 default = newJString("heldForReview"))
  if valid_589406 != nil:
    section.add "moderationStatus", valid_589406
  var valid_589407 = query.getOrDefault("prettyPrint")
  valid_589407 = validateParameter(valid_589407, JBool, required = false,
                                 default = newJBool(true))
  if valid_589407 != nil:
    section.add "prettyPrint", valid_589407
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589408: Call_YoutubeCommentsSetModerationStatus_589395;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the moderation status of one or more comments. The API request must be authorized by the owner of the channel or video associated with the comments.
  ## 
  let valid = call_589408.validator(path, query, header, formData, body)
  let scheme = call_589408.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589408.url(scheme.get, call_589408.host, call_589408.base,
                         call_589408.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589408, url, valid)

proc call*(call_589409: Call_YoutubeCommentsSetModerationStatus_589395; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          banAuthor: bool = false; oauthToken: string = ""; userIp: string = "";
          key: string = ""; moderationStatus: string = "heldForReview";
          prettyPrint: bool = true): Recallable =
  ## youtubeCommentsSetModerationStatus
  ## Sets the moderation status of one or more comments. The API request must be authorized by the owner of the channel or video associated with the comments.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies a comma-separated list of IDs that identify the comments for which you are updating the moderation status.
  ##   alt: string
  ##      : Data format for the response.
  ##   banAuthor: bool
  ##            : The banAuthor parameter lets you indicate that you want to automatically reject any additional comments written by the comment's author. Set the parameter value to true to ban the author.
  ## 
  ## Note: This parameter is only valid if the moderationStatus parameter is also set to rejected.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   moderationStatus: string (required)
  ##                   : Identifies the new moderation status of the specified comments.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589410 = newJObject()
  add(query_589410, "fields", newJString(fields))
  add(query_589410, "quotaUser", newJString(quotaUser))
  add(query_589410, "id", newJString(id))
  add(query_589410, "alt", newJString(alt))
  add(query_589410, "banAuthor", newJBool(banAuthor))
  add(query_589410, "oauth_token", newJString(oauthToken))
  add(query_589410, "userIp", newJString(userIp))
  add(query_589410, "key", newJString(key))
  add(query_589410, "moderationStatus", newJString(moderationStatus))
  add(query_589410, "prettyPrint", newJBool(prettyPrint))
  result = call_589409.call(nil, query_589410, nil, nil, nil)

var youtubeCommentsSetModerationStatus* = Call_YoutubeCommentsSetModerationStatus_589395(
    name: "youtubeCommentsSetModerationStatus", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/comments/setModerationStatus",
    validator: validate_YoutubeCommentsSetModerationStatus_589396,
    base: "/youtube/v3", url: url_YoutubeCommentsSetModerationStatus_589397,
    schemes: {Scheme.Https})
type
  Call_YoutubeGuideCategoriesList_589411 = ref object of OpenApiRestCall_588466
proc url_YoutubeGuideCategoriesList_589413(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeGuideCategoriesList_589412(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of categories that can be associated with YouTube channels.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of the YouTube channel category ID(s) for the resource(s) that are being retrieved. In a guideCategory resource, the id property specifies the YouTube channel category ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter specifies the guideCategory resource properties that the API response will include. Set the parameter value to snippet.
  ##   regionCode: JString
  ##             : The regionCode parameter instructs the API to return the list of guide categories available in the specified country. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   hl: JString
  ##     : The hl parameter specifies the language that will be used for text values in the API response.
  section = newJObject()
  var valid_589414 = query.getOrDefault("fields")
  valid_589414 = validateParameter(valid_589414, JString, required = false,
                                 default = nil)
  if valid_589414 != nil:
    section.add "fields", valid_589414
  var valid_589415 = query.getOrDefault("quotaUser")
  valid_589415 = validateParameter(valid_589415, JString, required = false,
                                 default = nil)
  if valid_589415 != nil:
    section.add "quotaUser", valid_589415
  var valid_589416 = query.getOrDefault("id")
  valid_589416 = validateParameter(valid_589416, JString, required = false,
                                 default = nil)
  if valid_589416 != nil:
    section.add "id", valid_589416
  var valid_589417 = query.getOrDefault("alt")
  valid_589417 = validateParameter(valid_589417, JString, required = false,
                                 default = newJString("json"))
  if valid_589417 != nil:
    section.add "alt", valid_589417
  var valid_589418 = query.getOrDefault("oauth_token")
  valid_589418 = validateParameter(valid_589418, JString, required = false,
                                 default = nil)
  if valid_589418 != nil:
    section.add "oauth_token", valid_589418
  var valid_589419 = query.getOrDefault("userIp")
  valid_589419 = validateParameter(valid_589419, JString, required = false,
                                 default = nil)
  if valid_589419 != nil:
    section.add "userIp", valid_589419
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589420 = query.getOrDefault("part")
  valid_589420 = validateParameter(valid_589420, JString, required = true,
                                 default = nil)
  if valid_589420 != nil:
    section.add "part", valid_589420
  var valid_589421 = query.getOrDefault("regionCode")
  valid_589421 = validateParameter(valid_589421, JString, required = false,
                                 default = nil)
  if valid_589421 != nil:
    section.add "regionCode", valid_589421
  var valid_589422 = query.getOrDefault("key")
  valid_589422 = validateParameter(valid_589422, JString, required = false,
                                 default = nil)
  if valid_589422 != nil:
    section.add "key", valid_589422
  var valid_589423 = query.getOrDefault("prettyPrint")
  valid_589423 = validateParameter(valid_589423, JBool, required = false,
                                 default = newJBool(true))
  if valid_589423 != nil:
    section.add "prettyPrint", valid_589423
  var valid_589424 = query.getOrDefault("hl")
  valid_589424 = validateParameter(valid_589424, JString, required = false,
                                 default = newJString("en-US"))
  if valid_589424 != nil:
    section.add "hl", valid_589424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589425: Call_YoutubeGuideCategoriesList_589411; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of categories that can be associated with YouTube channels.
  ## 
  let valid = call_589425.validator(path, query, header, formData, body)
  let scheme = call_589425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589425.url(scheme.get, call_589425.host, call_589425.base,
                         call_589425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589425, url, valid)

proc call*(call_589426: Call_YoutubeGuideCategoriesList_589411; part: string;
          fields: string = ""; quotaUser: string = ""; id: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          regionCode: string = ""; key: string = ""; prettyPrint: bool = true;
          hl: string = "en-US"): Recallable =
  ## youtubeGuideCategoriesList
  ## Returns a list of categories that can be associated with YouTube channels.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of the YouTube channel category ID(s) for the resource(s) that are being retrieved. In a guideCategory resource, the id property specifies the YouTube channel category ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter specifies the guideCategory resource properties that the API response will include. Set the parameter value to snippet.
  ##   regionCode: string
  ##             : The regionCode parameter instructs the API to return the list of guide categories available in the specified country. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   hl: string
  ##     : The hl parameter specifies the language that will be used for text values in the API response.
  var query_589427 = newJObject()
  add(query_589427, "fields", newJString(fields))
  add(query_589427, "quotaUser", newJString(quotaUser))
  add(query_589427, "id", newJString(id))
  add(query_589427, "alt", newJString(alt))
  add(query_589427, "oauth_token", newJString(oauthToken))
  add(query_589427, "userIp", newJString(userIp))
  add(query_589427, "part", newJString(part))
  add(query_589427, "regionCode", newJString(regionCode))
  add(query_589427, "key", newJString(key))
  add(query_589427, "prettyPrint", newJBool(prettyPrint))
  add(query_589427, "hl", newJString(hl))
  result = call_589426.call(nil, query_589427, nil, nil, nil)

var youtubeGuideCategoriesList* = Call_YoutubeGuideCategoriesList_589411(
    name: "youtubeGuideCategoriesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/guideCategories",
    validator: validate_YoutubeGuideCategoriesList_589412, base: "/youtube/v3",
    url: url_YoutubeGuideCategoriesList_589413, schemes: {Scheme.Https})
type
  Call_YoutubeI18nLanguagesList_589428 = ref object of OpenApiRestCall_588466
proc url_YoutubeI18nLanguagesList_589430(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeI18nLanguagesList_589429(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of application languages that the YouTube website supports.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter specifies the i18nLanguage resource properties that the API response will include. Set the parameter value to snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   hl: JString
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
  section = newJObject()
  var valid_589431 = query.getOrDefault("fields")
  valid_589431 = validateParameter(valid_589431, JString, required = false,
                                 default = nil)
  if valid_589431 != nil:
    section.add "fields", valid_589431
  var valid_589432 = query.getOrDefault("quotaUser")
  valid_589432 = validateParameter(valid_589432, JString, required = false,
                                 default = nil)
  if valid_589432 != nil:
    section.add "quotaUser", valid_589432
  var valid_589433 = query.getOrDefault("alt")
  valid_589433 = validateParameter(valid_589433, JString, required = false,
                                 default = newJString("json"))
  if valid_589433 != nil:
    section.add "alt", valid_589433
  var valid_589434 = query.getOrDefault("oauth_token")
  valid_589434 = validateParameter(valid_589434, JString, required = false,
                                 default = nil)
  if valid_589434 != nil:
    section.add "oauth_token", valid_589434
  var valid_589435 = query.getOrDefault("userIp")
  valid_589435 = validateParameter(valid_589435, JString, required = false,
                                 default = nil)
  if valid_589435 != nil:
    section.add "userIp", valid_589435
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589436 = query.getOrDefault("part")
  valid_589436 = validateParameter(valid_589436, JString, required = true,
                                 default = nil)
  if valid_589436 != nil:
    section.add "part", valid_589436
  var valid_589437 = query.getOrDefault("key")
  valid_589437 = validateParameter(valid_589437, JString, required = false,
                                 default = nil)
  if valid_589437 != nil:
    section.add "key", valid_589437
  var valid_589438 = query.getOrDefault("prettyPrint")
  valid_589438 = validateParameter(valid_589438, JBool, required = false,
                                 default = newJBool(true))
  if valid_589438 != nil:
    section.add "prettyPrint", valid_589438
  var valid_589439 = query.getOrDefault("hl")
  valid_589439 = validateParameter(valid_589439, JString, required = false,
                                 default = newJString("en_US"))
  if valid_589439 != nil:
    section.add "hl", valid_589439
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589440: Call_YoutubeI18nLanguagesList_589428; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of application languages that the YouTube website supports.
  ## 
  let valid = call_589440.validator(path, query, header, formData, body)
  let scheme = call_589440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589440.url(scheme.get, call_589440.host, call_589440.base,
                         call_589440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589440, url, valid)

proc call*(call_589441: Call_YoutubeI18nLanguagesList_589428; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; hl: string = "en_US"): Recallable =
  ## youtubeI18nLanguagesList
  ## Returns a list of application languages that the YouTube website supports.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter specifies the i18nLanguage resource properties that the API response will include. Set the parameter value to snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   hl: string
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
  var query_589442 = newJObject()
  add(query_589442, "fields", newJString(fields))
  add(query_589442, "quotaUser", newJString(quotaUser))
  add(query_589442, "alt", newJString(alt))
  add(query_589442, "oauth_token", newJString(oauthToken))
  add(query_589442, "userIp", newJString(userIp))
  add(query_589442, "part", newJString(part))
  add(query_589442, "key", newJString(key))
  add(query_589442, "prettyPrint", newJBool(prettyPrint))
  add(query_589442, "hl", newJString(hl))
  result = call_589441.call(nil, query_589442, nil, nil, nil)

var youtubeI18nLanguagesList* = Call_YoutubeI18nLanguagesList_589428(
    name: "youtubeI18nLanguagesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/i18nLanguages",
    validator: validate_YoutubeI18nLanguagesList_589429, base: "/youtube/v3",
    url: url_YoutubeI18nLanguagesList_589430, schemes: {Scheme.Https})
type
  Call_YoutubeI18nRegionsList_589443 = ref object of OpenApiRestCall_588466
proc url_YoutubeI18nRegionsList_589445(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeI18nRegionsList_589444(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of content regions that the YouTube website supports.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter specifies the i18nRegion resource properties that the API response will include. Set the parameter value to snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   hl: JString
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
  section = newJObject()
  var valid_589446 = query.getOrDefault("fields")
  valid_589446 = validateParameter(valid_589446, JString, required = false,
                                 default = nil)
  if valid_589446 != nil:
    section.add "fields", valid_589446
  var valid_589447 = query.getOrDefault("quotaUser")
  valid_589447 = validateParameter(valid_589447, JString, required = false,
                                 default = nil)
  if valid_589447 != nil:
    section.add "quotaUser", valid_589447
  var valid_589448 = query.getOrDefault("alt")
  valid_589448 = validateParameter(valid_589448, JString, required = false,
                                 default = newJString("json"))
  if valid_589448 != nil:
    section.add "alt", valid_589448
  var valid_589449 = query.getOrDefault("oauth_token")
  valid_589449 = validateParameter(valid_589449, JString, required = false,
                                 default = nil)
  if valid_589449 != nil:
    section.add "oauth_token", valid_589449
  var valid_589450 = query.getOrDefault("userIp")
  valid_589450 = validateParameter(valid_589450, JString, required = false,
                                 default = nil)
  if valid_589450 != nil:
    section.add "userIp", valid_589450
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589451 = query.getOrDefault("part")
  valid_589451 = validateParameter(valid_589451, JString, required = true,
                                 default = nil)
  if valid_589451 != nil:
    section.add "part", valid_589451
  var valid_589452 = query.getOrDefault("key")
  valid_589452 = validateParameter(valid_589452, JString, required = false,
                                 default = nil)
  if valid_589452 != nil:
    section.add "key", valid_589452
  var valid_589453 = query.getOrDefault("prettyPrint")
  valid_589453 = validateParameter(valid_589453, JBool, required = false,
                                 default = newJBool(true))
  if valid_589453 != nil:
    section.add "prettyPrint", valid_589453
  var valid_589454 = query.getOrDefault("hl")
  valid_589454 = validateParameter(valid_589454, JString, required = false,
                                 default = newJString("en_US"))
  if valid_589454 != nil:
    section.add "hl", valid_589454
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589455: Call_YoutubeI18nRegionsList_589443; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of content regions that the YouTube website supports.
  ## 
  let valid = call_589455.validator(path, query, header, formData, body)
  let scheme = call_589455.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589455.url(scheme.get, call_589455.host, call_589455.base,
                         call_589455.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589455, url, valid)

proc call*(call_589456: Call_YoutubeI18nRegionsList_589443; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; hl: string = "en_US"): Recallable =
  ## youtubeI18nRegionsList
  ## Returns a list of content regions that the YouTube website supports.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter specifies the i18nRegion resource properties that the API response will include. Set the parameter value to snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   hl: string
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
  var query_589457 = newJObject()
  add(query_589457, "fields", newJString(fields))
  add(query_589457, "quotaUser", newJString(quotaUser))
  add(query_589457, "alt", newJString(alt))
  add(query_589457, "oauth_token", newJString(oauthToken))
  add(query_589457, "userIp", newJString(userIp))
  add(query_589457, "part", newJString(part))
  add(query_589457, "key", newJString(key))
  add(query_589457, "prettyPrint", newJBool(prettyPrint))
  add(query_589457, "hl", newJString(hl))
  result = call_589456.call(nil, query_589457, nil, nil, nil)

var youtubeI18nRegionsList* = Call_YoutubeI18nRegionsList_589443(
    name: "youtubeI18nRegionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/i18nRegions",
    validator: validate_YoutubeI18nRegionsList_589444, base: "/youtube/v3",
    url: url_YoutubeI18nRegionsList_589445, schemes: {Scheme.Https})
type
  Call_YoutubeLiveBroadcastsUpdate_589480 = ref object of OpenApiRestCall_588466
proc url_YoutubeLiveBroadcastsUpdate_589482(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveBroadcastsUpdate_589481(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a broadcast. For example, you could modify the broadcast settings defined in the liveBroadcast resource's contentDetails object.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, contentDetails, and status.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. For example, a broadcast's privacy status is defined in the status part. As such, if your request is updating a private or unlisted broadcast, and the request's part parameter value includes the status part, the broadcast's privacy setting will be updated to whatever value the request body specifies. If the request body does not specify a value, the existing privacy setting will be removed and the broadcast will revert to the default privacy setting.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_589483 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589483 = validateParameter(valid_589483, JString, required = false,
                                 default = nil)
  if valid_589483 != nil:
    section.add "onBehalfOfContentOwner", valid_589483
  var valid_589484 = query.getOrDefault("fields")
  valid_589484 = validateParameter(valid_589484, JString, required = false,
                                 default = nil)
  if valid_589484 != nil:
    section.add "fields", valid_589484
  var valid_589485 = query.getOrDefault("quotaUser")
  valid_589485 = validateParameter(valid_589485, JString, required = false,
                                 default = nil)
  if valid_589485 != nil:
    section.add "quotaUser", valid_589485
  var valid_589486 = query.getOrDefault("alt")
  valid_589486 = validateParameter(valid_589486, JString, required = false,
                                 default = newJString("json"))
  if valid_589486 != nil:
    section.add "alt", valid_589486
  var valid_589487 = query.getOrDefault("oauth_token")
  valid_589487 = validateParameter(valid_589487, JString, required = false,
                                 default = nil)
  if valid_589487 != nil:
    section.add "oauth_token", valid_589487
  var valid_589488 = query.getOrDefault("userIp")
  valid_589488 = validateParameter(valid_589488, JString, required = false,
                                 default = nil)
  if valid_589488 != nil:
    section.add "userIp", valid_589488
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589489 = query.getOrDefault("part")
  valid_589489 = validateParameter(valid_589489, JString, required = true,
                                 default = nil)
  if valid_589489 != nil:
    section.add "part", valid_589489
  var valid_589490 = query.getOrDefault("key")
  valid_589490 = validateParameter(valid_589490, JString, required = false,
                                 default = nil)
  if valid_589490 != nil:
    section.add "key", valid_589490
  var valid_589491 = query.getOrDefault("prettyPrint")
  valid_589491 = validateParameter(valid_589491, JBool, required = false,
                                 default = newJBool(true))
  if valid_589491 != nil:
    section.add "prettyPrint", valid_589491
  var valid_589492 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_589492 = validateParameter(valid_589492, JString, required = false,
                                 default = nil)
  if valid_589492 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_589492
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

proc call*(call_589494: Call_YoutubeLiveBroadcastsUpdate_589480; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a broadcast. For example, you could modify the broadcast settings defined in the liveBroadcast resource's contentDetails object.
  ## 
  let valid = call_589494.validator(path, query, header, formData, body)
  let scheme = call_589494.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589494.url(scheme.get, call_589494.host, call_589494.base,
                         call_589494.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589494, url, valid)

proc call*(call_589495: Call_YoutubeLiveBroadcastsUpdate_589480; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeLiveBroadcastsUpdate
  ## Updates a broadcast. For example, you could modify the broadcast settings defined in the liveBroadcast resource's contentDetails object.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, contentDetails, and status.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. For example, a broadcast's privacy status is defined in the status part. As such, if your request is updating a private or unlisted broadcast, and the request's part parameter value includes the status part, the broadcast's privacy setting will be updated to whatever value the request body specifies. If the request body does not specify a value, the existing privacy setting will be removed and the broadcast will revert to the default privacy setting.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_589496 = newJObject()
  var body_589497 = newJObject()
  add(query_589496, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589496, "fields", newJString(fields))
  add(query_589496, "quotaUser", newJString(quotaUser))
  add(query_589496, "alt", newJString(alt))
  add(query_589496, "oauth_token", newJString(oauthToken))
  add(query_589496, "userIp", newJString(userIp))
  add(query_589496, "part", newJString(part))
  add(query_589496, "key", newJString(key))
  if body != nil:
    body_589497 = body
  add(query_589496, "prettyPrint", newJBool(prettyPrint))
  add(query_589496, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_589495.call(nil, query_589496, nil, nil, body_589497)

var youtubeLiveBroadcastsUpdate* = Call_YoutubeLiveBroadcastsUpdate_589480(
    name: "youtubeLiveBroadcastsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/liveBroadcasts",
    validator: validate_YoutubeLiveBroadcastsUpdate_589481, base: "/youtube/v3",
    url: url_YoutubeLiveBroadcastsUpdate_589482, schemes: {Scheme.Https})
type
  Call_YoutubeLiveBroadcastsInsert_589498 = ref object of OpenApiRestCall_588466
proc url_YoutubeLiveBroadcastsInsert_589500(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveBroadcastsInsert_589499(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a broadcast.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_589501 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589501 = validateParameter(valid_589501, JString, required = false,
                                 default = nil)
  if valid_589501 != nil:
    section.add "onBehalfOfContentOwner", valid_589501
  var valid_589502 = query.getOrDefault("fields")
  valid_589502 = validateParameter(valid_589502, JString, required = false,
                                 default = nil)
  if valid_589502 != nil:
    section.add "fields", valid_589502
  var valid_589503 = query.getOrDefault("quotaUser")
  valid_589503 = validateParameter(valid_589503, JString, required = false,
                                 default = nil)
  if valid_589503 != nil:
    section.add "quotaUser", valid_589503
  var valid_589504 = query.getOrDefault("alt")
  valid_589504 = validateParameter(valid_589504, JString, required = false,
                                 default = newJString("json"))
  if valid_589504 != nil:
    section.add "alt", valid_589504
  var valid_589505 = query.getOrDefault("oauth_token")
  valid_589505 = validateParameter(valid_589505, JString, required = false,
                                 default = nil)
  if valid_589505 != nil:
    section.add "oauth_token", valid_589505
  var valid_589506 = query.getOrDefault("userIp")
  valid_589506 = validateParameter(valid_589506, JString, required = false,
                                 default = nil)
  if valid_589506 != nil:
    section.add "userIp", valid_589506
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589507 = query.getOrDefault("part")
  valid_589507 = validateParameter(valid_589507, JString, required = true,
                                 default = nil)
  if valid_589507 != nil:
    section.add "part", valid_589507
  var valid_589508 = query.getOrDefault("key")
  valid_589508 = validateParameter(valid_589508, JString, required = false,
                                 default = nil)
  if valid_589508 != nil:
    section.add "key", valid_589508
  var valid_589509 = query.getOrDefault("prettyPrint")
  valid_589509 = validateParameter(valid_589509, JBool, required = false,
                                 default = newJBool(true))
  if valid_589509 != nil:
    section.add "prettyPrint", valid_589509
  var valid_589510 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_589510 = validateParameter(valid_589510, JString, required = false,
                                 default = nil)
  if valid_589510 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_589510
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

proc call*(call_589512: Call_YoutubeLiveBroadcastsInsert_589498; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a broadcast.
  ## 
  let valid = call_589512.validator(path, query, header, formData, body)
  let scheme = call_589512.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589512.url(scheme.get, call_589512.host, call_589512.base,
                         call_589512.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589512, url, valid)

proc call*(call_589513: Call_YoutubeLiveBroadcastsInsert_589498; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeLiveBroadcastsInsert
  ## Creates a broadcast.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_589514 = newJObject()
  var body_589515 = newJObject()
  add(query_589514, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589514, "fields", newJString(fields))
  add(query_589514, "quotaUser", newJString(quotaUser))
  add(query_589514, "alt", newJString(alt))
  add(query_589514, "oauth_token", newJString(oauthToken))
  add(query_589514, "userIp", newJString(userIp))
  add(query_589514, "part", newJString(part))
  add(query_589514, "key", newJString(key))
  if body != nil:
    body_589515 = body
  add(query_589514, "prettyPrint", newJBool(prettyPrint))
  add(query_589514, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_589513.call(nil, query_589514, nil, nil, body_589515)

var youtubeLiveBroadcastsInsert* = Call_YoutubeLiveBroadcastsInsert_589498(
    name: "youtubeLiveBroadcastsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveBroadcasts",
    validator: validate_YoutubeLiveBroadcastsInsert_589499, base: "/youtube/v3",
    url: url_YoutubeLiveBroadcastsInsert_589500, schemes: {Scheme.Https})
type
  Call_YoutubeLiveBroadcastsList_589458 = ref object of OpenApiRestCall_588466
proc url_YoutubeLiveBroadcastsList_589460(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveBroadcastsList_589459(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of YouTube broadcasts that match the API request parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: JBool
  ##       : The mine parameter can be used to instruct the API to only return broadcasts owned by the authenticated user. Set the parameter value to true to only retrieve your own broadcasts.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of YouTube broadcast IDs that identify the broadcasts being retrieved. In a liveBroadcast resource, the id property specifies the broadcast's ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   broadcastType: JString
  ##                : The broadcastType parameter filters the API response to only include broadcasts with the specified type. This is only compatible with the mine filter for now.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   broadcastStatus: JString
  ##                  : The broadcastStatus parameter filters the API response to only include broadcasts with the specified status.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_589461 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589461 = validateParameter(valid_589461, JString, required = false,
                                 default = nil)
  if valid_589461 != nil:
    section.add "onBehalfOfContentOwner", valid_589461
  var valid_589462 = query.getOrDefault("mine")
  valid_589462 = validateParameter(valid_589462, JBool, required = false, default = nil)
  if valid_589462 != nil:
    section.add "mine", valid_589462
  var valid_589463 = query.getOrDefault("fields")
  valid_589463 = validateParameter(valid_589463, JString, required = false,
                                 default = nil)
  if valid_589463 != nil:
    section.add "fields", valid_589463
  var valid_589464 = query.getOrDefault("pageToken")
  valid_589464 = validateParameter(valid_589464, JString, required = false,
                                 default = nil)
  if valid_589464 != nil:
    section.add "pageToken", valid_589464
  var valid_589465 = query.getOrDefault("quotaUser")
  valid_589465 = validateParameter(valid_589465, JString, required = false,
                                 default = nil)
  if valid_589465 != nil:
    section.add "quotaUser", valid_589465
  var valid_589466 = query.getOrDefault("id")
  valid_589466 = validateParameter(valid_589466, JString, required = false,
                                 default = nil)
  if valid_589466 != nil:
    section.add "id", valid_589466
  var valid_589467 = query.getOrDefault("alt")
  valid_589467 = validateParameter(valid_589467, JString, required = false,
                                 default = newJString("json"))
  if valid_589467 != nil:
    section.add "alt", valid_589467
  var valid_589468 = query.getOrDefault("broadcastType")
  valid_589468 = validateParameter(valid_589468, JString, required = false,
                                 default = newJString("event"))
  if valid_589468 != nil:
    section.add "broadcastType", valid_589468
  var valid_589469 = query.getOrDefault("oauth_token")
  valid_589469 = validateParameter(valid_589469, JString, required = false,
                                 default = nil)
  if valid_589469 != nil:
    section.add "oauth_token", valid_589469
  var valid_589470 = query.getOrDefault("userIp")
  valid_589470 = validateParameter(valid_589470, JString, required = false,
                                 default = nil)
  if valid_589470 != nil:
    section.add "userIp", valid_589470
  var valid_589471 = query.getOrDefault("maxResults")
  valid_589471 = validateParameter(valid_589471, JInt, required = false,
                                 default = newJInt(5))
  if valid_589471 != nil:
    section.add "maxResults", valid_589471
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589472 = query.getOrDefault("part")
  valid_589472 = validateParameter(valid_589472, JString, required = true,
                                 default = nil)
  if valid_589472 != nil:
    section.add "part", valid_589472
  var valid_589473 = query.getOrDefault("key")
  valid_589473 = validateParameter(valid_589473, JString, required = false,
                                 default = nil)
  if valid_589473 != nil:
    section.add "key", valid_589473
  var valid_589474 = query.getOrDefault("broadcastStatus")
  valid_589474 = validateParameter(valid_589474, JString, required = false,
                                 default = newJString("active"))
  if valid_589474 != nil:
    section.add "broadcastStatus", valid_589474
  var valid_589475 = query.getOrDefault("prettyPrint")
  valid_589475 = validateParameter(valid_589475, JBool, required = false,
                                 default = newJBool(true))
  if valid_589475 != nil:
    section.add "prettyPrint", valid_589475
  var valid_589476 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_589476 = validateParameter(valid_589476, JString, required = false,
                                 default = nil)
  if valid_589476 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_589476
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589477: Call_YoutubeLiveBroadcastsList_589458; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of YouTube broadcasts that match the API request parameters.
  ## 
  let valid = call_589477.validator(path, query, header, formData, body)
  let scheme = call_589477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589477.url(scheme.get, call_589477.host, call_589477.base,
                         call_589477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589477, url, valid)

proc call*(call_589478: Call_YoutubeLiveBroadcastsList_589458; part: string;
          onBehalfOfContentOwner: string = ""; mine: bool = false; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; id: string = "";
          alt: string = "json"; broadcastType: string = "event";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 5;
          key: string = ""; broadcastStatus: string = "active";
          prettyPrint: bool = true; onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeLiveBroadcastsList
  ## Returns a list of YouTube broadcasts that match the API request parameters.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: bool
  ##       : The mine parameter can be used to instruct the API to only return broadcasts owned by the authenticated user. Set the parameter value to true to only retrieve your own broadcasts.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of YouTube broadcast IDs that identify the broadcasts being retrieved. In a liveBroadcast resource, the id property specifies the broadcast's ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   broadcastType: string
  ##                : The broadcastType parameter filters the API response to only include broadcasts with the specified type. This is only compatible with the mine filter for now.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   broadcastStatus: string
  ##                  : The broadcastStatus parameter filters the API response to only include broadcasts with the specified status.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_589479 = newJObject()
  add(query_589479, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589479, "mine", newJBool(mine))
  add(query_589479, "fields", newJString(fields))
  add(query_589479, "pageToken", newJString(pageToken))
  add(query_589479, "quotaUser", newJString(quotaUser))
  add(query_589479, "id", newJString(id))
  add(query_589479, "alt", newJString(alt))
  add(query_589479, "broadcastType", newJString(broadcastType))
  add(query_589479, "oauth_token", newJString(oauthToken))
  add(query_589479, "userIp", newJString(userIp))
  add(query_589479, "maxResults", newJInt(maxResults))
  add(query_589479, "part", newJString(part))
  add(query_589479, "key", newJString(key))
  add(query_589479, "broadcastStatus", newJString(broadcastStatus))
  add(query_589479, "prettyPrint", newJBool(prettyPrint))
  add(query_589479, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_589478.call(nil, query_589479, nil, nil, nil)

var youtubeLiveBroadcastsList* = Call_YoutubeLiveBroadcastsList_589458(
    name: "youtubeLiveBroadcastsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/liveBroadcasts",
    validator: validate_YoutubeLiveBroadcastsList_589459, base: "/youtube/v3",
    url: url_YoutubeLiveBroadcastsList_589460, schemes: {Scheme.Https})
type
  Call_YoutubeLiveBroadcastsDelete_589516 = ref object of OpenApiRestCall_588466
proc url_YoutubeLiveBroadcastsDelete_589518(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveBroadcastsDelete_589517(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a broadcast.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube live broadcast ID for the resource that is being deleted.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_589519 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589519 = validateParameter(valid_589519, JString, required = false,
                                 default = nil)
  if valid_589519 != nil:
    section.add "onBehalfOfContentOwner", valid_589519
  var valid_589520 = query.getOrDefault("fields")
  valid_589520 = validateParameter(valid_589520, JString, required = false,
                                 default = nil)
  if valid_589520 != nil:
    section.add "fields", valid_589520
  var valid_589521 = query.getOrDefault("quotaUser")
  valid_589521 = validateParameter(valid_589521, JString, required = false,
                                 default = nil)
  if valid_589521 != nil:
    section.add "quotaUser", valid_589521
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_589522 = query.getOrDefault("id")
  valid_589522 = validateParameter(valid_589522, JString, required = true,
                                 default = nil)
  if valid_589522 != nil:
    section.add "id", valid_589522
  var valid_589523 = query.getOrDefault("alt")
  valid_589523 = validateParameter(valid_589523, JString, required = false,
                                 default = newJString("json"))
  if valid_589523 != nil:
    section.add "alt", valid_589523
  var valid_589524 = query.getOrDefault("oauth_token")
  valid_589524 = validateParameter(valid_589524, JString, required = false,
                                 default = nil)
  if valid_589524 != nil:
    section.add "oauth_token", valid_589524
  var valid_589525 = query.getOrDefault("userIp")
  valid_589525 = validateParameter(valid_589525, JString, required = false,
                                 default = nil)
  if valid_589525 != nil:
    section.add "userIp", valid_589525
  var valid_589526 = query.getOrDefault("key")
  valid_589526 = validateParameter(valid_589526, JString, required = false,
                                 default = nil)
  if valid_589526 != nil:
    section.add "key", valid_589526
  var valid_589527 = query.getOrDefault("prettyPrint")
  valid_589527 = validateParameter(valid_589527, JBool, required = false,
                                 default = newJBool(true))
  if valid_589527 != nil:
    section.add "prettyPrint", valid_589527
  var valid_589528 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_589528 = validateParameter(valid_589528, JString, required = false,
                                 default = nil)
  if valid_589528 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_589528
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589529: Call_YoutubeLiveBroadcastsDelete_589516; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a broadcast.
  ## 
  let valid = call_589529.validator(path, query, header, formData, body)
  let scheme = call_589529.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589529.url(scheme.get, call_589529.host, call_589529.base,
                         call_589529.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589529, url, valid)

proc call*(call_589530: Call_YoutubeLiveBroadcastsDelete_589516; id: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true;
          onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeLiveBroadcastsDelete
  ## Deletes a broadcast.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube live broadcast ID for the resource that is being deleted.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_589531 = newJObject()
  add(query_589531, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589531, "fields", newJString(fields))
  add(query_589531, "quotaUser", newJString(quotaUser))
  add(query_589531, "id", newJString(id))
  add(query_589531, "alt", newJString(alt))
  add(query_589531, "oauth_token", newJString(oauthToken))
  add(query_589531, "userIp", newJString(userIp))
  add(query_589531, "key", newJString(key))
  add(query_589531, "prettyPrint", newJBool(prettyPrint))
  add(query_589531, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_589530.call(nil, query_589531, nil, nil, nil)

var youtubeLiveBroadcastsDelete* = Call_YoutubeLiveBroadcastsDelete_589516(
    name: "youtubeLiveBroadcastsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/liveBroadcasts",
    validator: validate_YoutubeLiveBroadcastsDelete_589517, base: "/youtube/v3",
    url: url_YoutubeLiveBroadcastsDelete_589518, schemes: {Scheme.Https})
type
  Call_YoutubeLiveBroadcastsBind_589532 = ref object of OpenApiRestCall_588466
proc url_YoutubeLiveBroadcastsBind_589534(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveBroadcastsBind_589533(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Binds a YouTube broadcast to a stream or removes an existing binding between a broadcast and a stream. A broadcast can only be bound to one video stream, though a video stream may be bound to more than one broadcast.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the unique ID of the broadcast that is being bound to a video stream.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   streamId: JString
  ##           : The streamId parameter specifies the unique ID of the video stream that is being bound to a broadcast. If this parameter is omitted, the API will remove any existing binding between the broadcast and a video stream.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_589535 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589535 = validateParameter(valid_589535, JString, required = false,
                                 default = nil)
  if valid_589535 != nil:
    section.add "onBehalfOfContentOwner", valid_589535
  var valid_589536 = query.getOrDefault("fields")
  valid_589536 = validateParameter(valid_589536, JString, required = false,
                                 default = nil)
  if valid_589536 != nil:
    section.add "fields", valid_589536
  var valid_589537 = query.getOrDefault("quotaUser")
  valid_589537 = validateParameter(valid_589537, JString, required = false,
                                 default = nil)
  if valid_589537 != nil:
    section.add "quotaUser", valid_589537
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_589538 = query.getOrDefault("id")
  valid_589538 = validateParameter(valid_589538, JString, required = true,
                                 default = nil)
  if valid_589538 != nil:
    section.add "id", valid_589538
  var valid_589539 = query.getOrDefault("alt")
  valid_589539 = validateParameter(valid_589539, JString, required = false,
                                 default = newJString("json"))
  if valid_589539 != nil:
    section.add "alt", valid_589539
  var valid_589540 = query.getOrDefault("oauth_token")
  valid_589540 = validateParameter(valid_589540, JString, required = false,
                                 default = nil)
  if valid_589540 != nil:
    section.add "oauth_token", valid_589540
  var valid_589541 = query.getOrDefault("userIp")
  valid_589541 = validateParameter(valid_589541, JString, required = false,
                                 default = nil)
  if valid_589541 != nil:
    section.add "userIp", valid_589541
  var valid_589542 = query.getOrDefault("part")
  valid_589542 = validateParameter(valid_589542, JString, required = true,
                                 default = nil)
  if valid_589542 != nil:
    section.add "part", valid_589542
  var valid_589543 = query.getOrDefault("key")
  valid_589543 = validateParameter(valid_589543, JString, required = false,
                                 default = nil)
  if valid_589543 != nil:
    section.add "key", valid_589543
  var valid_589544 = query.getOrDefault("streamId")
  valid_589544 = validateParameter(valid_589544, JString, required = false,
                                 default = nil)
  if valid_589544 != nil:
    section.add "streamId", valid_589544
  var valid_589545 = query.getOrDefault("prettyPrint")
  valid_589545 = validateParameter(valid_589545, JBool, required = false,
                                 default = newJBool(true))
  if valid_589545 != nil:
    section.add "prettyPrint", valid_589545
  var valid_589546 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_589546 = validateParameter(valid_589546, JString, required = false,
                                 default = nil)
  if valid_589546 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_589546
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589547: Call_YoutubeLiveBroadcastsBind_589532; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Binds a YouTube broadcast to a stream or removes an existing binding between a broadcast and a stream. A broadcast can only be bound to one video stream, though a video stream may be bound to more than one broadcast.
  ## 
  let valid = call_589547.validator(path, query, header, formData, body)
  let scheme = call_589547.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589547.url(scheme.get, call_589547.host, call_589547.base,
                         call_589547.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589547, url, valid)

proc call*(call_589548: Call_YoutubeLiveBroadcastsBind_589532; id: string;
          part: string; onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; streamId: string = "";
          prettyPrint: bool = true; onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeLiveBroadcastsBind
  ## Binds a YouTube broadcast to a stream or removes an existing binding between a broadcast and a stream. A broadcast can only be bound to one video stream, though a video stream may be bound to more than one broadcast.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the unique ID of the broadcast that is being bound to a video stream.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   streamId: string
  ##           : The streamId parameter specifies the unique ID of the video stream that is being bound to a broadcast. If this parameter is omitted, the API will remove any existing binding between the broadcast and a video stream.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_589549 = newJObject()
  add(query_589549, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589549, "fields", newJString(fields))
  add(query_589549, "quotaUser", newJString(quotaUser))
  add(query_589549, "id", newJString(id))
  add(query_589549, "alt", newJString(alt))
  add(query_589549, "oauth_token", newJString(oauthToken))
  add(query_589549, "userIp", newJString(userIp))
  add(query_589549, "part", newJString(part))
  add(query_589549, "key", newJString(key))
  add(query_589549, "streamId", newJString(streamId))
  add(query_589549, "prettyPrint", newJBool(prettyPrint))
  add(query_589549, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_589548.call(nil, query_589549, nil, nil, nil)

var youtubeLiveBroadcastsBind* = Call_YoutubeLiveBroadcastsBind_589532(
    name: "youtubeLiveBroadcastsBind", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveBroadcasts/bind",
    validator: validate_YoutubeLiveBroadcastsBind_589533, base: "/youtube/v3",
    url: url_YoutubeLiveBroadcastsBind_589534, schemes: {Scheme.Https})
type
  Call_YoutubeLiveBroadcastsControl_589550 = ref object of OpenApiRestCall_588466
proc url_YoutubeLiveBroadcastsControl_589552(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveBroadcastsControl_589551(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Controls the settings for a slate that can be displayed in the broadcast stream.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   offsetTimeMs: JString
  ##               : The offsetTimeMs parameter specifies a positive time offset when the specified slate change will occur. The value is measured in milliseconds from the beginning of the broadcast's monitor stream, which is the time that the testing phase for the broadcast began. Even though it is specified in milliseconds, the value is actually an approximation, and YouTube completes the requested action as closely as possible to that time.
  ## 
  ## If you do not specify a value for this parameter, then YouTube performs the action as soon as possible. See the Getting started guide for more details.
  ## 
  ## Important: You should only specify a value for this parameter if your broadcast stream is delayed.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube live broadcast ID that uniquely identifies the broadcast in which the slate is being updated.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   walltime: JString
  ##           : The walltime parameter specifies the wall clock time at which the specified slate change will occur. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sssZ) format.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   displaySlate: JBool
  ##               : The displaySlate parameter specifies whether the slate is being enabled or disabled.
  section = newJObject()
  var valid_589553 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589553 = validateParameter(valid_589553, JString, required = false,
                                 default = nil)
  if valid_589553 != nil:
    section.add "onBehalfOfContentOwner", valid_589553
  var valid_589554 = query.getOrDefault("offsetTimeMs")
  valid_589554 = validateParameter(valid_589554, JString, required = false,
                                 default = nil)
  if valid_589554 != nil:
    section.add "offsetTimeMs", valid_589554
  var valid_589555 = query.getOrDefault("fields")
  valid_589555 = validateParameter(valid_589555, JString, required = false,
                                 default = nil)
  if valid_589555 != nil:
    section.add "fields", valid_589555
  var valid_589556 = query.getOrDefault("quotaUser")
  valid_589556 = validateParameter(valid_589556, JString, required = false,
                                 default = nil)
  if valid_589556 != nil:
    section.add "quotaUser", valid_589556
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_589557 = query.getOrDefault("id")
  valid_589557 = validateParameter(valid_589557, JString, required = true,
                                 default = nil)
  if valid_589557 != nil:
    section.add "id", valid_589557
  var valid_589558 = query.getOrDefault("alt")
  valid_589558 = validateParameter(valid_589558, JString, required = false,
                                 default = newJString("json"))
  if valid_589558 != nil:
    section.add "alt", valid_589558
  var valid_589559 = query.getOrDefault("oauth_token")
  valid_589559 = validateParameter(valid_589559, JString, required = false,
                                 default = nil)
  if valid_589559 != nil:
    section.add "oauth_token", valid_589559
  var valid_589560 = query.getOrDefault("userIp")
  valid_589560 = validateParameter(valid_589560, JString, required = false,
                                 default = nil)
  if valid_589560 != nil:
    section.add "userIp", valid_589560
  var valid_589561 = query.getOrDefault("part")
  valid_589561 = validateParameter(valid_589561, JString, required = true,
                                 default = nil)
  if valid_589561 != nil:
    section.add "part", valid_589561
  var valid_589562 = query.getOrDefault("walltime")
  valid_589562 = validateParameter(valid_589562, JString, required = false,
                                 default = nil)
  if valid_589562 != nil:
    section.add "walltime", valid_589562
  var valid_589563 = query.getOrDefault("key")
  valid_589563 = validateParameter(valid_589563, JString, required = false,
                                 default = nil)
  if valid_589563 != nil:
    section.add "key", valid_589563
  var valid_589564 = query.getOrDefault("prettyPrint")
  valid_589564 = validateParameter(valid_589564, JBool, required = false,
                                 default = newJBool(true))
  if valid_589564 != nil:
    section.add "prettyPrint", valid_589564
  var valid_589565 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_589565 = validateParameter(valid_589565, JString, required = false,
                                 default = nil)
  if valid_589565 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_589565
  var valid_589566 = query.getOrDefault("displaySlate")
  valid_589566 = validateParameter(valid_589566, JBool, required = false, default = nil)
  if valid_589566 != nil:
    section.add "displaySlate", valid_589566
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589567: Call_YoutubeLiveBroadcastsControl_589550; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Controls the settings for a slate that can be displayed in the broadcast stream.
  ## 
  let valid = call_589567.validator(path, query, header, formData, body)
  let scheme = call_589567.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589567.url(scheme.get, call_589567.host, call_589567.base,
                         call_589567.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589567, url, valid)

proc call*(call_589568: Call_YoutubeLiveBroadcastsControl_589550; id: string;
          part: string; onBehalfOfContentOwner: string = "";
          offsetTimeMs: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          walltime: string = ""; key: string = ""; prettyPrint: bool = true;
          onBehalfOfContentOwnerChannel: string = ""; displaySlate: bool = false): Recallable =
  ## youtubeLiveBroadcastsControl
  ## Controls the settings for a slate that can be displayed in the broadcast stream.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   offsetTimeMs: string
  ##               : The offsetTimeMs parameter specifies a positive time offset when the specified slate change will occur. The value is measured in milliseconds from the beginning of the broadcast's monitor stream, which is the time that the testing phase for the broadcast began. Even though it is specified in milliseconds, the value is actually an approximation, and YouTube completes the requested action as closely as possible to that time.
  ## 
  ## If you do not specify a value for this parameter, then YouTube performs the action as soon as possible. See the Getting started guide for more details.
  ## 
  ## Important: You should only specify a value for this parameter if your broadcast stream is delayed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube live broadcast ID that uniquely identifies the broadcast in which the slate is being updated.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   walltime: string
  ##           : The walltime parameter specifies the wall clock time at which the specified slate change will occur. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sssZ) format.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   displaySlate: bool
  ##               : The displaySlate parameter specifies whether the slate is being enabled or disabled.
  var query_589569 = newJObject()
  add(query_589569, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589569, "offsetTimeMs", newJString(offsetTimeMs))
  add(query_589569, "fields", newJString(fields))
  add(query_589569, "quotaUser", newJString(quotaUser))
  add(query_589569, "id", newJString(id))
  add(query_589569, "alt", newJString(alt))
  add(query_589569, "oauth_token", newJString(oauthToken))
  add(query_589569, "userIp", newJString(userIp))
  add(query_589569, "part", newJString(part))
  add(query_589569, "walltime", newJString(walltime))
  add(query_589569, "key", newJString(key))
  add(query_589569, "prettyPrint", newJBool(prettyPrint))
  add(query_589569, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  add(query_589569, "displaySlate", newJBool(displaySlate))
  result = call_589568.call(nil, query_589569, nil, nil, nil)

var youtubeLiveBroadcastsControl* = Call_YoutubeLiveBroadcastsControl_589550(
    name: "youtubeLiveBroadcastsControl", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveBroadcasts/control",
    validator: validate_YoutubeLiveBroadcastsControl_589551, base: "/youtube/v3",
    url: url_YoutubeLiveBroadcastsControl_589552, schemes: {Scheme.Https})
type
  Call_YoutubeLiveBroadcastsTransition_589570 = ref object of OpenApiRestCall_588466
proc url_YoutubeLiveBroadcastsTransition_589572(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveBroadcastsTransition_589571(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Changes the status of a YouTube live broadcast and initiates any processes associated with the new status. For example, when you transition a broadcast's status to testing, YouTube starts to transmit video to that broadcast's monitor stream. Before calling this method, you should confirm that the value of the status.streamStatus property for the stream bound to your broadcast is active.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the unique ID of the broadcast that is transitioning to another status.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   broadcastStatus: JString (required)
  ##                  : The broadcastStatus parameter identifies the state to which the broadcast is changing. Note that to transition a broadcast to either the testing or live state, the status.streamStatus must be active for the stream that the broadcast is bound to.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_589573 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589573 = validateParameter(valid_589573, JString, required = false,
                                 default = nil)
  if valid_589573 != nil:
    section.add "onBehalfOfContentOwner", valid_589573
  var valid_589574 = query.getOrDefault("fields")
  valid_589574 = validateParameter(valid_589574, JString, required = false,
                                 default = nil)
  if valid_589574 != nil:
    section.add "fields", valid_589574
  var valid_589575 = query.getOrDefault("quotaUser")
  valid_589575 = validateParameter(valid_589575, JString, required = false,
                                 default = nil)
  if valid_589575 != nil:
    section.add "quotaUser", valid_589575
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_589576 = query.getOrDefault("id")
  valid_589576 = validateParameter(valid_589576, JString, required = true,
                                 default = nil)
  if valid_589576 != nil:
    section.add "id", valid_589576
  var valid_589577 = query.getOrDefault("alt")
  valid_589577 = validateParameter(valid_589577, JString, required = false,
                                 default = newJString("json"))
  if valid_589577 != nil:
    section.add "alt", valid_589577
  var valid_589578 = query.getOrDefault("oauth_token")
  valid_589578 = validateParameter(valid_589578, JString, required = false,
                                 default = nil)
  if valid_589578 != nil:
    section.add "oauth_token", valid_589578
  var valid_589579 = query.getOrDefault("userIp")
  valid_589579 = validateParameter(valid_589579, JString, required = false,
                                 default = nil)
  if valid_589579 != nil:
    section.add "userIp", valid_589579
  var valid_589580 = query.getOrDefault("part")
  valid_589580 = validateParameter(valid_589580, JString, required = true,
                                 default = nil)
  if valid_589580 != nil:
    section.add "part", valid_589580
  var valid_589581 = query.getOrDefault("key")
  valid_589581 = validateParameter(valid_589581, JString, required = false,
                                 default = nil)
  if valid_589581 != nil:
    section.add "key", valid_589581
  var valid_589582 = query.getOrDefault("broadcastStatus")
  valid_589582 = validateParameter(valid_589582, JString, required = true,
                                 default = newJString("complete"))
  if valid_589582 != nil:
    section.add "broadcastStatus", valid_589582
  var valid_589583 = query.getOrDefault("prettyPrint")
  valid_589583 = validateParameter(valid_589583, JBool, required = false,
                                 default = newJBool(true))
  if valid_589583 != nil:
    section.add "prettyPrint", valid_589583
  var valid_589584 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_589584 = validateParameter(valid_589584, JString, required = false,
                                 default = nil)
  if valid_589584 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_589584
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589585: Call_YoutubeLiveBroadcastsTransition_589570;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Changes the status of a YouTube live broadcast and initiates any processes associated with the new status. For example, when you transition a broadcast's status to testing, YouTube starts to transmit video to that broadcast's monitor stream. Before calling this method, you should confirm that the value of the status.streamStatus property for the stream bound to your broadcast is active.
  ## 
  let valid = call_589585.validator(path, query, header, formData, body)
  let scheme = call_589585.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589585.url(scheme.get, call_589585.host, call_589585.base,
                         call_589585.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589585, url, valid)

proc call*(call_589586: Call_YoutubeLiveBroadcastsTransition_589570; id: string;
          part: string; onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; broadcastStatus: string = "complete";
          prettyPrint: bool = true; onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeLiveBroadcastsTransition
  ## Changes the status of a YouTube live broadcast and initiates any processes associated with the new status. For example, when you transition a broadcast's status to testing, YouTube starts to transmit video to that broadcast's monitor stream. Before calling this method, you should confirm that the value of the status.streamStatus property for the stream bound to your broadcast is active.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the unique ID of the broadcast that is transitioning to another status.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   broadcastStatus: string (required)
  ##                  : The broadcastStatus parameter identifies the state to which the broadcast is changing. Note that to transition a broadcast to either the testing or live state, the status.streamStatus must be active for the stream that the broadcast is bound to.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_589587 = newJObject()
  add(query_589587, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589587, "fields", newJString(fields))
  add(query_589587, "quotaUser", newJString(quotaUser))
  add(query_589587, "id", newJString(id))
  add(query_589587, "alt", newJString(alt))
  add(query_589587, "oauth_token", newJString(oauthToken))
  add(query_589587, "userIp", newJString(userIp))
  add(query_589587, "part", newJString(part))
  add(query_589587, "key", newJString(key))
  add(query_589587, "broadcastStatus", newJString(broadcastStatus))
  add(query_589587, "prettyPrint", newJBool(prettyPrint))
  add(query_589587, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_589586.call(nil, query_589587, nil, nil, nil)

var youtubeLiveBroadcastsTransition* = Call_YoutubeLiveBroadcastsTransition_589570(
    name: "youtubeLiveBroadcastsTransition", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveBroadcasts/transition",
    validator: validate_YoutubeLiveBroadcastsTransition_589571,
    base: "/youtube/v3", url: url_YoutubeLiveBroadcastsTransition_589572,
    schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatBansInsert_589588 = ref object of OpenApiRestCall_588466
proc url_YoutubeLiveChatBansInsert_589590(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatBansInsert_589589(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a new ban to the chat.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response returns. Set the parameter value to snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589591 = query.getOrDefault("fields")
  valid_589591 = validateParameter(valid_589591, JString, required = false,
                                 default = nil)
  if valid_589591 != nil:
    section.add "fields", valid_589591
  var valid_589592 = query.getOrDefault("quotaUser")
  valid_589592 = validateParameter(valid_589592, JString, required = false,
                                 default = nil)
  if valid_589592 != nil:
    section.add "quotaUser", valid_589592
  var valid_589593 = query.getOrDefault("alt")
  valid_589593 = validateParameter(valid_589593, JString, required = false,
                                 default = newJString("json"))
  if valid_589593 != nil:
    section.add "alt", valid_589593
  var valid_589594 = query.getOrDefault("oauth_token")
  valid_589594 = validateParameter(valid_589594, JString, required = false,
                                 default = nil)
  if valid_589594 != nil:
    section.add "oauth_token", valid_589594
  var valid_589595 = query.getOrDefault("userIp")
  valid_589595 = validateParameter(valid_589595, JString, required = false,
                                 default = nil)
  if valid_589595 != nil:
    section.add "userIp", valid_589595
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589596 = query.getOrDefault("part")
  valid_589596 = validateParameter(valid_589596, JString, required = true,
                                 default = nil)
  if valid_589596 != nil:
    section.add "part", valid_589596
  var valid_589597 = query.getOrDefault("key")
  valid_589597 = validateParameter(valid_589597, JString, required = false,
                                 default = nil)
  if valid_589597 != nil:
    section.add "key", valid_589597
  var valid_589598 = query.getOrDefault("prettyPrint")
  valid_589598 = validateParameter(valid_589598, JBool, required = false,
                                 default = newJBool(true))
  if valid_589598 != nil:
    section.add "prettyPrint", valid_589598
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

proc call*(call_589600: Call_YoutubeLiveChatBansInsert_589588; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a new ban to the chat.
  ## 
  let valid = call_589600.validator(path, query, header, formData, body)
  let scheme = call_589600.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589600.url(scheme.get, call_589600.host, call_589600.base,
                         call_589600.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589600, url, valid)

proc call*(call_589601: Call_YoutubeLiveChatBansInsert_589588; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeLiveChatBansInsert
  ## Adds a new ban to the chat.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response returns. Set the parameter value to snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589602 = newJObject()
  var body_589603 = newJObject()
  add(query_589602, "fields", newJString(fields))
  add(query_589602, "quotaUser", newJString(quotaUser))
  add(query_589602, "alt", newJString(alt))
  add(query_589602, "oauth_token", newJString(oauthToken))
  add(query_589602, "userIp", newJString(userIp))
  add(query_589602, "part", newJString(part))
  add(query_589602, "key", newJString(key))
  if body != nil:
    body_589603 = body
  add(query_589602, "prettyPrint", newJBool(prettyPrint))
  result = call_589601.call(nil, query_589602, nil, nil, body_589603)

var youtubeLiveChatBansInsert* = Call_YoutubeLiveChatBansInsert_589588(
    name: "youtubeLiveChatBansInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveChat/bans",
    validator: validate_YoutubeLiveChatBansInsert_589589, base: "/youtube/v3",
    url: url_YoutubeLiveChatBansInsert_589590, schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatBansDelete_589604 = ref object of OpenApiRestCall_588466
proc url_YoutubeLiveChatBansDelete_589606(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatBansDelete_589605(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a chat ban.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter identifies the chat ban to remove. The value uniquely identifies both the ban and the chat.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589607 = query.getOrDefault("fields")
  valid_589607 = validateParameter(valid_589607, JString, required = false,
                                 default = nil)
  if valid_589607 != nil:
    section.add "fields", valid_589607
  var valid_589608 = query.getOrDefault("quotaUser")
  valid_589608 = validateParameter(valid_589608, JString, required = false,
                                 default = nil)
  if valid_589608 != nil:
    section.add "quotaUser", valid_589608
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_589609 = query.getOrDefault("id")
  valid_589609 = validateParameter(valid_589609, JString, required = true,
                                 default = nil)
  if valid_589609 != nil:
    section.add "id", valid_589609
  var valid_589610 = query.getOrDefault("alt")
  valid_589610 = validateParameter(valid_589610, JString, required = false,
                                 default = newJString("json"))
  if valid_589610 != nil:
    section.add "alt", valid_589610
  var valid_589611 = query.getOrDefault("oauth_token")
  valid_589611 = validateParameter(valid_589611, JString, required = false,
                                 default = nil)
  if valid_589611 != nil:
    section.add "oauth_token", valid_589611
  var valid_589612 = query.getOrDefault("userIp")
  valid_589612 = validateParameter(valid_589612, JString, required = false,
                                 default = nil)
  if valid_589612 != nil:
    section.add "userIp", valid_589612
  var valid_589613 = query.getOrDefault("key")
  valid_589613 = validateParameter(valid_589613, JString, required = false,
                                 default = nil)
  if valid_589613 != nil:
    section.add "key", valid_589613
  var valid_589614 = query.getOrDefault("prettyPrint")
  valid_589614 = validateParameter(valid_589614, JBool, required = false,
                                 default = newJBool(true))
  if valid_589614 != nil:
    section.add "prettyPrint", valid_589614
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589615: Call_YoutubeLiveChatBansDelete_589604; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a chat ban.
  ## 
  let valid = call_589615.validator(path, query, header, formData, body)
  let scheme = call_589615.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589615.url(scheme.get, call_589615.host, call_589615.base,
                         call_589615.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589615, url, valid)

proc call*(call_589616: Call_YoutubeLiveChatBansDelete_589604; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## youtubeLiveChatBansDelete
  ## Removes a chat ban.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter identifies the chat ban to remove. The value uniquely identifies both the ban and the chat.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589617 = newJObject()
  add(query_589617, "fields", newJString(fields))
  add(query_589617, "quotaUser", newJString(quotaUser))
  add(query_589617, "id", newJString(id))
  add(query_589617, "alt", newJString(alt))
  add(query_589617, "oauth_token", newJString(oauthToken))
  add(query_589617, "userIp", newJString(userIp))
  add(query_589617, "key", newJString(key))
  add(query_589617, "prettyPrint", newJBool(prettyPrint))
  result = call_589616.call(nil, query_589617, nil, nil, nil)

var youtubeLiveChatBansDelete* = Call_YoutubeLiveChatBansDelete_589604(
    name: "youtubeLiveChatBansDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/liveChat/bans",
    validator: validate_YoutubeLiveChatBansDelete_589605, base: "/youtube/v3",
    url: url_YoutubeLiveChatBansDelete_589606, schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatMessagesInsert_589637 = ref object of OpenApiRestCall_588466
proc url_YoutubeLiveChatMessagesInsert_589639(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatMessagesInsert_589638(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a message to a live chat.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter serves two purposes. It identifies the properties that the write operation will set as well as the properties that the API response will include. Set the parameter value to snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589640 = query.getOrDefault("fields")
  valid_589640 = validateParameter(valid_589640, JString, required = false,
                                 default = nil)
  if valid_589640 != nil:
    section.add "fields", valid_589640
  var valid_589641 = query.getOrDefault("quotaUser")
  valid_589641 = validateParameter(valid_589641, JString, required = false,
                                 default = nil)
  if valid_589641 != nil:
    section.add "quotaUser", valid_589641
  var valid_589642 = query.getOrDefault("alt")
  valid_589642 = validateParameter(valid_589642, JString, required = false,
                                 default = newJString("json"))
  if valid_589642 != nil:
    section.add "alt", valid_589642
  var valid_589643 = query.getOrDefault("oauth_token")
  valid_589643 = validateParameter(valid_589643, JString, required = false,
                                 default = nil)
  if valid_589643 != nil:
    section.add "oauth_token", valid_589643
  var valid_589644 = query.getOrDefault("userIp")
  valid_589644 = validateParameter(valid_589644, JString, required = false,
                                 default = nil)
  if valid_589644 != nil:
    section.add "userIp", valid_589644
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589645 = query.getOrDefault("part")
  valid_589645 = validateParameter(valid_589645, JString, required = true,
                                 default = nil)
  if valid_589645 != nil:
    section.add "part", valid_589645
  var valid_589646 = query.getOrDefault("key")
  valid_589646 = validateParameter(valid_589646, JString, required = false,
                                 default = nil)
  if valid_589646 != nil:
    section.add "key", valid_589646
  var valid_589647 = query.getOrDefault("prettyPrint")
  valid_589647 = validateParameter(valid_589647, JBool, required = false,
                                 default = newJBool(true))
  if valid_589647 != nil:
    section.add "prettyPrint", valid_589647
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

proc call*(call_589649: Call_YoutubeLiveChatMessagesInsert_589637; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a message to a live chat.
  ## 
  let valid = call_589649.validator(path, query, header, formData, body)
  let scheme = call_589649.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589649.url(scheme.get, call_589649.host, call_589649.base,
                         call_589649.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589649, url, valid)

proc call*(call_589650: Call_YoutubeLiveChatMessagesInsert_589637; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeLiveChatMessagesInsert
  ## Adds a message to a live chat.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter serves two purposes. It identifies the properties that the write operation will set as well as the properties that the API response will include. Set the parameter value to snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589651 = newJObject()
  var body_589652 = newJObject()
  add(query_589651, "fields", newJString(fields))
  add(query_589651, "quotaUser", newJString(quotaUser))
  add(query_589651, "alt", newJString(alt))
  add(query_589651, "oauth_token", newJString(oauthToken))
  add(query_589651, "userIp", newJString(userIp))
  add(query_589651, "part", newJString(part))
  add(query_589651, "key", newJString(key))
  if body != nil:
    body_589652 = body
  add(query_589651, "prettyPrint", newJBool(prettyPrint))
  result = call_589650.call(nil, query_589651, nil, nil, body_589652)

var youtubeLiveChatMessagesInsert* = Call_YoutubeLiveChatMessagesInsert_589637(
    name: "youtubeLiveChatMessagesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveChat/messages",
    validator: validate_YoutubeLiveChatMessagesInsert_589638, base: "/youtube/v3",
    url: url_YoutubeLiveChatMessagesInsert_589639, schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatMessagesList_589618 = ref object of OpenApiRestCall_588466
proc url_YoutubeLiveChatMessagesList_589620(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatMessagesList_589619(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists live chat messages for a specific chat.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken property identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of messages that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies the liveChatComment resource parts that the API response will include. Supported values are id and snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   liveChatId: JString (required)
  ##             : The liveChatId parameter specifies the ID of the chat whose messages will be returned.
  ##   profileImageSize: JInt
  ##                   : The profileImageSize parameter specifies the size of the user profile pictures that should be returned in the result set. Default: 88.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   hl: JString
  ##     : The hl parameter instructs the API to retrieve localized resource metadata for a specific application language that the YouTube website supports. The parameter value must be a language code included in the list returned by the i18nLanguages.list method.
  ## 
  ## If localized resource details are available in that language, the resource's snippet.localized object will contain the localized values. However, if localized details are not available, the snippet.localized object will contain resource details in the resource's default language.
  section = newJObject()
  var valid_589621 = query.getOrDefault("fields")
  valid_589621 = validateParameter(valid_589621, JString, required = false,
                                 default = nil)
  if valid_589621 != nil:
    section.add "fields", valid_589621
  var valid_589622 = query.getOrDefault("pageToken")
  valid_589622 = validateParameter(valid_589622, JString, required = false,
                                 default = nil)
  if valid_589622 != nil:
    section.add "pageToken", valid_589622
  var valid_589623 = query.getOrDefault("quotaUser")
  valid_589623 = validateParameter(valid_589623, JString, required = false,
                                 default = nil)
  if valid_589623 != nil:
    section.add "quotaUser", valid_589623
  var valid_589624 = query.getOrDefault("alt")
  valid_589624 = validateParameter(valid_589624, JString, required = false,
                                 default = newJString("json"))
  if valid_589624 != nil:
    section.add "alt", valid_589624
  var valid_589625 = query.getOrDefault("oauth_token")
  valid_589625 = validateParameter(valid_589625, JString, required = false,
                                 default = nil)
  if valid_589625 != nil:
    section.add "oauth_token", valid_589625
  var valid_589626 = query.getOrDefault("userIp")
  valid_589626 = validateParameter(valid_589626, JString, required = false,
                                 default = nil)
  if valid_589626 != nil:
    section.add "userIp", valid_589626
  var valid_589627 = query.getOrDefault("maxResults")
  valid_589627 = validateParameter(valid_589627, JInt, required = false,
                                 default = newJInt(500))
  if valid_589627 != nil:
    section.add "maxResults", valid_589627
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589628 = query.getOrDefault("part")
  valid_589628 = validateParameter(valid_589628, JString, required = true,
                                 default = nil)
  if valid_589628 != nil:
    section.add "part", valid_589628
  var valid_589629 = query.getOrDefault("key")
  valid_589629 = validateParameter(valid_589629, JString, required = false,
                                 default = nil)
  if valid_589629 != nil:
    section.add "key", valid_589629
  var valid_589630 = query.getOrDefault("liveChatId")
  valid_589630 = validateParameter(valid_589630, JString, required = true,
                                 default = nil)
  if valid_589630 != nil:
    section.add "liveChatId", valid_589630
  var valid_589631 = query.getOrDefault("profileImageSize")
  valid_589631 = validateParameter(valid_589631, JInt, required = false, default = nil)
  if valid_589631 != nil:
    section.add "profileImageSize", valid_589631
  var valid_589632 = query.getOrDefault("prettyPrint")
  valid_589632 = validateParameter(valid_589632, JBool, required = false,
                                 default = newJBool(true))
  if valid_589632 != nil:
    section.add "prettyPrint", valid_589632
  var valid_589633 = query.getOrDefault("hl")
  valid_589633 = validateParameter(valid_589633, JString, required = false,
                                 default = nil)
  if valid_589633 != nil:
    section.add "hl", valid_589633
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589634: Call_YoutubeLiveChatMessagesList_589618; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists live chat messages for a specific chat.
  ## 
  let valid = call_589634.validator(path, query, header, formData, body)
  let scheme = call_589634.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589634.url(scheme.get, call_589634.host, call_589634.base,
                         call_589634.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589634, url, valid)

proc call*(call_589635: Call_YoutubeLiveChatMessagesList_589618; part: string;
          liveChatId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 500; key: string = "";
          profileImageSize: int = 0; prettyPrint: bool = true; hl: string = ""): Recallable =
  ## youtubeLiveChatMessagesList
  ## Lists live chat messages for a specific chat.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken property identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of messages that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies the liveChatComment resource parts that the API response will include. Supported values are id and snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   liveChatId: string (required)
  ##             : The liveChatId parameter specifies the ID of the chat whose messages will be returned.
  ##   profileImageSize: int
  ##                   : The profileImageSize parameter specifies the size of the user profile pictures that should be returned in the result set. Default: 88.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   hl: string
  ##     : The hl parameter instructs the API to retrieve localized resource metadata for a specific application language that the YouTube website supports. The parameter value must be a language code included in the list returned by the i18nLanguages.list method.
  ## 
  ## If localized resource details are available in that language, the resource's snippet.localized object will contain the localized values. However, if localized details are not available, the snippet.localized object will contain resource details in the resource's default language.
  var query_589636 = newJObject()
  add(query_589636, "fields", newJString(fields))
  add(query_589636, "pageToken", newJString(pageToken))
  add(query_589636, "quotaUser", newJString(quotaUser))
  add(query_589636, "alt", newJString(alt))
  add(query_589636, "oauth_token", newJString(oauthToken))
  add(query_589636, "userIp", newJString(userIp))
  add(query_589636, "maxResults", newJInt(maxResults))
  add(query_589636, "part", newJString(part))
  add(query_589636, "key", newJString(key))
  add(query_589636, "liveChatId", newJString(liveChatId))
  add(query_589636, "profileImageSize", newJInt(profileImageSize))
  add(query_589636, "prettyPrint", newJBool(prettyPrint))
  add(query_589636, "hl", newJString(hl))
  result = call_589635.call(nil, query_589636, nil, nil, nil)

var youtubeLiveChatMessagesList* = Call_YoutubeLiveChatMessagesList_589618(
    name: "youtubeLiveChatMessagesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/liveChat/messages",
    validator: validate_YoutubeLiveChatMessagesList_589619, base: "/youtube/v3",
    url: url_YoutubeLiveChatMessagesList_589620, schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatMessagesDelete_589653 = ref object of OpenApiRestCall_588466
proc url_YoutubeLiveChatMessagesDelete_589655(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatMessagesDelete_589654(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a chat message.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube chat message ID of the resource that is being deleted.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589656 = query.getOrDefault("fields")
  valid_589656 = validateParameter(valid_589656, JString, required = false,
                                 default = nil)
  if valid_589656 != nil:
    section.add "fields", valid_589656
  var valid_589657 = query.getOrDefault("quotaUser")
  valid_589657 = validateParameter(valid_589657, JString, required = false,
                                 default = nil)
  if valid_589657 != nil:
    section.add "quotaUser", valid_589657
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_589658 = query.getOrDefault("id")
  valid_589658 = validateParameter(valid_589658, JString, required = true,
                                 default = nil)
  if valid_589658 != nil:
    section.add "id", valid_589658
  var valid_589659 = query.getOrDefault("alt")
  valid_589659 = validateParameter(valid_589659, JString, required = false,
                                 default = newJString("json"))
  if valid_589659 != nil:
    section.add "alt", valid_589659
  var valid_589660 = query.getOrDefault("oauth_token")
  valid_589660 = validateParameter(valid_589660, JString, required = false,
                                 default = nil)
  if valid_589660 != nil:
    section.add "oauth_token", valid_589660
  var valid_589661 = query.getOrDefault("userIp")
  valid_589661 = validateParameter(valid_589661, JString, required = false,
                                 default = nil)
  if valid_589661 != nil:
    section.add "userIp", valid_589661
  var valid_589662 = query.getOrDefault("key")
  valid_589662 = validateParameter(valid_589662, JString, required = false,
                                 default = nil)
  if valid_589662 != nil:
    section.add "key", valid_589662
  var valid_589663 = query.getOrDefault("prettyPrint")
  valid_589663 = validateParameter(valid_589663, JBool, required = false,
                                 default = newJBool(true))
  if valid_589663 != nil:
    section.add "prettyPrint", valid_589663
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589664: Call_YoutubeLiveChatMessagesDelete_589653; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a chat message.
  ## 
  let valid = call_589664.validator(path, query, header, formData, body)
  let scheme = call_589664.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589664.url(scheme.get, call_589664.host, call_589664.base,
                         call_589664.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589664, url, valid)

proc call*(call_589665: Call_YoutubeLiveChatMessagesDelete_589653; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## youtubeLiveChatMessagesDelete
  ## Deletes a chat message.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube chat message ID of the resource that is being deleted.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589666 = newJObject()
  add(query_589666, "fields", newJString(fields))
  add(query_589666, "quotaUser", newJString(quotaUser))
  add(query_589666, "id", newJString(id))
  add(query_589666, "alt", newJString(alt))
  add(query_589666, "oauth_token", newJString(oauthToken))
  add(query_589666, "userIp", newJString(userIp))
  add(query_589666, "key", newJString(key))
  add(query_589666, "prettyPrint", newJBool(prettyPrint))
  result = call_589665.call(nil, query_589666, nil, nil, nil)

var youtubeLiveChatMessagesDelete* = Call_YoutubeLiveChatMessagesDelete_589653(
    name: "youtubeLiveChatMessagesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/liveChat/messages",
    validator: validate_YoutubeLiveChatMessagesDelete_589654, base: "/youtube/v3",
    url: url_YoutubeLiveChatMessagesDelete_589655, schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatModeratorsInsert_589684 = ref object of OpenApiRestCall_588466
proc url_YoutubeLiveChatModeratorsInsert_589686(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatModeratorsInsert_589685(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a new moderator for the chat.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response returns. Set the parameter value to snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589687 = query.getOrDefault("fields")
  valid_589687 = validateParameter(valid_589687, JString, required = false,
                                 default = nil)
  if valid_589687 != nil:
    section.add "fields", valid_589687
  var valid_589688 = query.getOrDefault("quotaUser")
  valid_589688 = validateParameter(valid_589688, JString, required = false,
                                 default = nil)
  if valid_589688 != nil:
    section.add "quotaUser", valid_589688
  var valid_589689 = query.getOrDefault("alt")
  valid_589689 = validateParameter(valid_589689, JString, required = false,
                                 default = newJString("json"))
  if valid_589689 != nil:
    section.add "alt", valid_589689
  var valid_589690 = query.getOrDefault("oauth_token")
  valid_589690 = validateParameter(valid_589690, JString, required = false,
                                 default = nil)
  if valid_589690 != nil:
    section.add "oauth_token", valid_589690
  var valid_589691 = query.getOrDefault("userIp")
  valid_589691 = validateParameter(valid_589691, JString, required = false,
                                 default = nil)
  if valid_589691 != nil:
    section.add "userIp", valid_589691
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589692 = query.getOrDefault("part")
  valid_589692 = validateParameter(valid_589692, JString, required = true,
                                 default = nil)
  if valid_589692 != nil:
    section.add "part", valid_589692
  var valid_589693 = query.getOrDefault("key")
  valid_589693 = validateParameter(valid_589693, JString, required = false,
                                 default = nil)
  if valid_589693 != nil:
    section.add "key", valid_589693
  var valid_589694 = query.getOrDefault("prettyPrint")
  valid_589694 = validateParameter(valid_589694, JBool, required = false,
                                 default = newJBool(true))
  if valid_589694 != nil:
    section.add "prettyPrint", valid_589694
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

proc call*(call_589696: Call_YoutubeLiveChatModeratorsInsert_589684;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a new moderator for the chat.
  ## 
  let valid = call_589696.validator(path, query, header, formData, body)
  let scheme = call_589696.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589696.url(scheme.get, call_589696.host, call_589696.base,
                         call_589696.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589696, url, valid)

proc call*(call_589697: Call_YoutubeLiveChatModeratorsInsert_589684; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeLiveChatModeratorsInsert
  ## Adds a new moderator for the chat.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response returns. Set the parameter value to snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589698 = newJObject()
  var body_589699 = newJObject()
  add(query_589698, "fields", newJString(fields))
  add(query_589698, "quotaUser", newJString(quotaUser))
  add(query_589698, "alt", newJString(alt))
  add(query_589698, "oauth_token", newJString(oauthToken))
  add(query_589698, "userIp", newJString(userIp))
  add(query_589698, "part", newJString(part))
  add(query_589698, "key", newJString(key))
  if body != nil:
    body_589699 = body
  add(query_589698, "prettyPrint", newJBool(prettyPrint))
  result = call_589697.call(nil, query_589698, nil, nil, body_589699)

var youtubeLiveChatModeratorsInsert* = Call_YoutubeLiveChatModeratorsInsert_589684(
    name: "youtubeLiveChatModeratorsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveChat/moderators",
    validator: validate_YoutubeLiveChatModeratorsInsert_589685,
    base: "/youtube/v3", url: url_YoutubeLiveChatModeratorsInsert_589686,
    schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatModeratorsList_589667 = ref object of OpenApiRestCall_588466
proc url_YoutubeLiveChatModeratorsList_589669(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatModeratorsList_589668(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists moderators for a live chat.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies the liveChatModerator resource parts that the API response will include. Supported values are id and snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   liveChatId: JString (required)
  ##             : The liveChatId parameter specifies the YouTube live chat for which the API should return moderators.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589670 = query.getOrDefault("fields")
  valid_589670 = validateParameter(valid_589670, JString, required = false,
                                 default = nil)
  if valid_589670 != nil:
    section.add "fields", valid_589670
  var valid_589671 = query.getOrDefault("pageToken")
  valid_589671 = validateParameter(valid_589671, JString, required = false,
                                 default = nil)
  if valid_589671 != nil:
    section.add "pageToken", valid_589671
  var valid_589672 = query.getOrDefault("quotaUser")
  valid_589672 = validateParameter(valid_589672, JString, required = false,
                                 default = nil)
  if valid_589672 != nil:
    section.add "quotaUser", valid_589672
  var valid_589673 = query.getOrDefault("alt")
  valid_589673 = validateParameter(valid_589673, JString, required = false,
                                 default = newJString("json"))
  if valid_589673 != nil:
    section.add "alt", valid_589673
  var valid_589674 = query.getOrDefault("oauth_token")
  valid_589674 = validateParameter(valid_589674, JString, required = false,
                                 default = nil)
  if valid_589674 != nil:
    section.add "oauth_token", valid_589674
  var valid_589675 = query.getOrDefault("userIp")
  valid_589675 = validateParameter(valid_589675, JString, required = false,
                                 default = nil)
  if valid_589675 != nil:
    section.add "userIp", valid_589675
  var valid_589676 = query.getOrDefault("maxResults")
  valid_589676 = validateParameter(valid_589676, JInt, required = false,
                                 default = newJInt(5))
  if valid_589676 != nil:
    section.add "maxResults", valid_589676
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589677 = query.getOrDefault("part")
  valid_589677 = validateParameter(valid_589677, JString, required = true,
                                 default = nil)
  if valid_589677 != nil:
    section.add "part", valid_589677
  var valid_589678 = query.getOrDefault("key")
  valid_589678 = validateParameter(valid_589678, JString, required = false,
                                 default = nil)
  if valid_589678 != nil:
    section.add "key", valid_589678
  var valid_589679 = query.getOrDefault("liveChatId")
  valid_589679 = validateParameter(valid_589679, JString, required = true,
                                 default = nil)
  if valid_589679 != nil:
    section.add "liveChatId", valid_589679
  var valid_589680 = query.getOrDefault("prettyPrint")
  valid_589680 = validateParameter(valid_589680, JBool, required = false,
                                 default = newJBool(true))
  if valid_589680 != nil:
    section.add "prettyPrint", valid_589680
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589681: Call_YoutubeLiveChatModeratorsList_589667; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists moderators for a live chat.
  ## 
  let valid = call_589681.validator(path, query, header, formData, body)
  let scheme = call_589681.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589681.url(scheme.get, call_589681.host, call_589681.base,
                         call_589681.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589681, url, valid)

proc call*(call_589682: Call_YoutubeLiveChatModeratorsList_589667; part: string;
          liveChatId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 5; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## youtubeLiveChatModeratorsList
  ## Lists moderators for a live chat.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies the liveChatModerator resource parts that the API response will include. Supported values are id and snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   liveChatId: string (required)
  ##             : The liveChatId parameter specifies the YouTube live chat for which the API should return moderators.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589683 = newJObject()
  add(query_589683, "fields", newJString(fields))
  add(query_589683, "pageToken", newJString(pageToken))
  add(query_589683, "quotaUser", newJString(quotaUser))
  add(query_589683, "alt", newJString(alt))
  add(query_589683, "oauth_token", newJString(oauthToken))
  add(query_589683, "userIp", newJString(userIp))
  add(query_589683, "maxResults", newJInt(maxResults))
  add(query_589683, "part", newJString(part))
  add(query_589683, "key", newJString(key))
  add(query_589683, "liveChatId", newJString(liveChatId))
  add(query_589683, "prettyPrint", newJBool(prettyPrint))
  result = call_589682.call(nil, query_589683, nil, nil, nil)

var youtubeLiveChatModeratorsList* = Call_YoutubeLiveChatModeratorsList_589667(
    name: "youtubeLiveChatModeratorsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/liveChat/moderators",
    validator: validate_YoutubeLiveChatModeratorsList_589668, base: "/youtube/v3",
    url: url_YoutubeLiveChatModeratorsList_589669, schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatModeratorsDelete_589700 = ref object of OpenApiRestCall_588466
proc url_YoutubeLiveChatModeratorsDelete_589702(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatModeratorsDelete_589701(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a chat moderator.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter identifies the chat moderator to remove. The value uniquely identifies both the moderator and the chat.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589703 = query.getOrDefault("fields")
  valid_589703 = validateParameter(valid_589703, JString, required = false,
                                 default = nil)
  if valid_589703 != nil:
    section.add "fields", valid_589703
  var valid_589704 = query.getOrDefault("quotaUser")
  valid_589704 = validateParameter(valid_589704, JString, required = false,
                                 default = nil)
  if valid_589704 != nil:
    section.add "quotaUser", valid_589704
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_589705 = query.getOrDefault("id")
  valid_589705 = validateParameter(valid_589705, JString, required = true,
                                 default = nil)
  if valid_589705 != nil:
    section.add "id", valid_589705
  var valid_589706 = query.getOrDefault("alt")
  valid_589706 = validateParameter(valid_589706, JString, required = false,
                                 default = newJString("json"))
  if valid_589706 != nil:
    section.add "alt", valid_589706
  var valid_589707 = query.getOrDefault("oauth_token")
  valid_589707 = validateParameter(valid_589707, JString, required = false,
                                 default = nil)
  if valid_589707 != nil:
    section.add "oauth_token", valid_589707
  var valid_589708 = query.getOrDefault("userIp")
  valid_589708 = validateParameter(valid_589708, JString, required = false,
                                 default = nil)
  if valid_589708 != nil:
    section.add "userIp", valid_589708
  var valid_589709 = query.getOrDefault("key")
  valid_589709 = validateParameter(valid_589709, JString, required = false,
                                 default = nil)
  if valid_589709 != nil:
    section.add "key", valid_589709
  var valid_589710 = query.getOrDefault("prettyPrint")
  valid_589710 = validateParameter(valid_589710, JBool, required = false,
                                 default = newJBool(true))
  if valid_589710 != nil:
    section.add "prettyPrint", valid_589710
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589711: Call_YoutubeLiveChatModeratorsDelete_589700;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a chat moderator.
  ## 
  let valid = call_589711.validator(path, query, header, formData, body)
  let scheme = call_589711.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589711.url(scheme.get, call_589711.host, call_589711.base,
                         call_589711.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589711, url, valid)

proc call*(call_589712: Call_YoutubeLiveChatModeratorsDelete_589700; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## youtubeLiveChatModeratorsDelete
  ## Removes a chat moderator.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter identifies the chat moderator to remove. The value uniquely identifies both the moderator and the chat.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589713 = newJObject()
  add(query_589713, "fields", newJString(fields))
  add(query_589713, "quotaUser", newJString(quotaUser))
  add(query_589713, "id", newJString(id))
  add(query_589713, "alt", newJString(alt))
  add(query_589713, "oauth_token", newJString(oauthToken))
  add(query_589713, "userIp", newJString(userIp))
  add(query_589713, "key", newJString(key))
  add(query_589713, "prettyPrint", newJBool(prettyPrint))
  result = call_589712.call(nil, query_589713, nil, nil, nil)

var youtubeLiveChatModeratorsDelete* = Call_YoutubeLiveChatModeratorsDelete_589700(
    name: "youtubeLiveChatModeratorsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/liveChat/moderators",
    validator: validate_YoutubeLiveChatModeratorsDelete_589701,
    base: "/youtube/v3", url: url_YoutubeLiveChatModeratorsDelete_589702,
    schemes: {Scheme.Https})
type
  Call_YoutubeLiveStreamsUpdate_589734 = ref object of OpenApiRestCall_588466
proc url_YoutubeLiveStreamsUpdate_589736(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveStreamsUpdate_589735(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a video stream. If the properties that you want to change cannot be updated, then you need to create a new stream with the proper settings.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, cdn, and status.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. If the request body does not specify a value for a mutable property, the existing value for that property will be removed.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_589737 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589737 = validateParameter(valid_589737, JString, required = false,
                                 default = nil)
  if valid_589737 != nil:
    section.add "onBehalfOfContentOwner", valid_589737
  var valid_589738 = query.getOrDefault("fields")
  valid_589738 = validateParameter(valid_589738, JString, required = false,
                                 default = nil)
  if valid_589738 != nil:
    section.add "fields", valid_589738
  var valid_589739 = query.getOrDefault("quotaUser")
  valid_589739 = validateParameter(valid_589739, JString, required = false,
                                 default = nil)
  if valid_589739 != nil:
    section.add "quotaUser", valid_589739
  var valid_589740 = query.getOrDefault("alt")
  valid_589740 = validateParameter(valid_589740, JString, required = false,
                                 default = newJString("json"))
  if valid_589740 != nil:
    section.add "alt", valid_589740
  var valid_589741 = query.getOrDefault("oauth_token")
  valid_589741 = validateParameter(valid_589741, JString, required = false,
                                 default = nil)
  if valid_589741 != nil:
    section.add "oauth_token", valid_589741
  var valid_589742 = query.getOrDefault("userIp")
  valid_589742 = validateParameter(valid_589742, JString, required = false,
                                 default = nil)
  if valid_589742 != nil:
    section.add "userIp", valid_589742
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589743 = query.getOrDefault("part")
  valid_589743 = validateParameter(valid_589743, JString, required = true,
                                 default = nil)
  if valid_589743 != nil:
    section.add "part", valid_589743
  var valid_589744 = query.getOrDefault("key")
  valid_589744 = validateParameter(valid_589744, JString, required = false,
                                 default = nil)
  if valid_589744 != nil:
    section.add "key", valid_589744
  var valid_589745 = query.getOrDefault("prettyPrint")
  valid_589745 = validateParameter(valid_589745, JBool, required = false,
                                 default = newJBool(true))
  if valid_589745 != nil:
    section.add "prettyPrint", valid_589745
  var valid_589746 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_589746 = validateParameter(valid_589746, JString, required = false,
                                 default = nil)
  if valid_589746 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_589746
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

proc call*(call_589748: Call_YoutubeLiveStreamsUpdate_589734; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a video stream. If the properties that you want to change cannot be updated, then you need to create a new stream with the proper settings.
  ## 
  let valid = call_589748.validator(path, query, header, formData, body)
  let scheme = call_589748.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589748.url(scheme.get, call_589748.host, call_589748.base,
                         call_589748.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589748, url, valid)

proc call*(call_589749: Call_YoutubeLiveStreamsUpdate_589734; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeLiveStreamsUpdate
  ## Updates a video stream. If the properties that you want to change cannot be updated, then you need to create a new stream with the proper settings.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, cdn, and status.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. If the request body does not specify a value for a mutable property, the existing value for that property will be removed.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_589750 = newJObject()
  var body_589751 = newJObject()
  add(query_589750, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589750, "fields", newJString(fields))
  add(query_589750, "quotaUser", newJString(quotaUser))
  add(query_589750, "alt", newJString(alt))
  add(query_589750, "oauth_token", newJString(oauthToken))
  add(query_589750, "userIp", newJString(userIp))
  add(query_589750, "part", newJString(part))
  add(query_589750, "key", newJString(key))
  if body != nil:
    body_589751 = body
  add(query_589750, "prettyPrint", newJBool(prettyPrint))
  add(query_589750, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_589749.call(nil, query_589750, nil, nil, body_589751)

var youtubeLiveStreamsUpdate* = Call_YoutubeLiveStreamsUpdate_589734(
    name: "youtubeLiveStreamsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/liveStreams",
    validator: validate_YoutubeLiveStreamsUpdate_589735, base: "/youtube/v3",
    url: url_YoutubeLiveStreamsUpdate_589736, schemes: {Scheme.Https})
type
  Call_YoutubeLiveStreamsInsert_589752 = ref object of OpenApiRestCall_588466
proc url_YoutubeLiveStreamsInsert_589754(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveStreamsInsert_589753(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a video stream. The stream enables you to send your video to YouTube, which can then broadcast the video to your audience.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, cdn, and status.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_589755 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589755 = validateParameter(valid_589755, JString, required = false,
                                 default = nil)
  if valid_589755 != nil:
    section.add "onBehalfOfContentOwner", valid_589755
  var valid_589756 = query.getOrDefault("fields")
  valid_589756 = validateParameter(valid_589756, JString, required = false,
                                 default = nil)
  if valid_589756 != nil:
    section.add "fields", valid_589756
  var valid_589757 = query.getOrDefault("quotaUser")
  valid_589757 = validateParameter(valid_589757, JString, required = false,
                                 default = nil)
  if valid_589757 != nil:
    section.add "quotaUser", valid_589757
  var valid_589758 = query.getOrDefault("alt")
  valid_589758 = validateParameter(valid_589758, JString, required = false,
                                 default = newJString("json"))
  if valid_589758 != nil:
    section.add "alt", valid_589758
  var valid_589759 = query.getOrDefault("oauth_token")
  valid_589759 = validateParameter(valid_589759, JString, required = false,
                                 default = nil)
  if valid_589759 != nil:
    section.add "oauth_token", valid_589759
  var valid_589760 = query.getOrDefault("userIp")
  valid_589760 = validateParameter(valid_589760, JString, required = false,
                                 default = nil)
  if valid_589760 != nil:
    section.add "userIp", valid_589760
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589761 = query.getOrDefault("part")
  valid_589761 = validateParameter(valid_589761, JString, required = true,
                                 default = nil)
  if valid_589761 != nil:
    section.add "part", valid_589761
  var valid_589762 = query.getOrDefault("key")
  valid_589762 = validateParameter(valid_589762, JString, required = false,
                                 default = nil)
  if valid_589762 != nil:
    section.add "key", valid_589762
  var valid_589763 = query.getOrDefault("prettyPrint")
  valid_589763 = validateParameter(valid_589763, JBool, required = false,
                                 default = newJBool(true))
  if valid_589763 != nil:
    section.add "prettyPrint", valid_589763
  var valid_589764 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_589764 = validateParameter(valid_589764, JString, required = false,
                                 default = nil)
  if valid_589764 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_589764
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

proc call*(call_589766: Call_YoutubeLiveStreamsInsert_589752; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a video stream. The stream enables you to send your video to YouTube, which can then broadcast the video to your audience.
  ## 
  let valid = call_589766.validator(path, query, header, formData, body)
  let scheme = call_589766.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589766.url(scheme.get, call_589766.host, call_589766.base,
                         call_589766.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589766, url, valid)

proc call*(call_589767: Call_YoutubeLiveStreamsInsert_589752; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeLiveStreamsInsert
  ## Creates a video stream. The stream enables you to send your video to YouTube, which can then broadcast the video to your audience.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, cdn, and status.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_589768 = newJObject()
  var body_589769 = newJObject()
  add(query_589768, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589768, "fields", newJString(fields))
  add(query_589768, "quotaUser", newJString(quotaUser))
  add(query_589768, "alt", newJString(alt))
  add(query_589768, "oauth_token", newJString(oauthToken))
  add(query_589768, "userIp", newJString(userIp))
  add(query_589768, "part", newJString(part))
  add(query_589768, "key", newJString(key))
  if body != nil:
    body_589769 = body
  add(query_589768, "prettyPrint", newJBool(prettyPrint))
  add(query_589768, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_589767.call(nil, query_589768, nil, nil, body_589769)

var youtubeLiveStreamsInsert* = Call_YoutubeLiveStreamsInsert_589752(
    name: "youtubeLiveStreamsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveStreams",
    validator: validate_YoutubeLiveStreamsInsert_589753, base: "/youtube/v3",
    url: url_YoutubeLiveStreamsInsert_589754, schemes: {Scheme.Https})
type
  Call_YoutubeLiveStreamsList_589714 = ref object of OpenApiRestCall_588466
proc url_YoutubeLiveStreamsList_589716(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveStreamsList_589715(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of video streams that match the API request parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: JBool
  ##       : The mine parameter can be used to instruct the API to only return streams owned by the authenticated user. Set the parameter value to true to only retrieve your own streams.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of YouTube stream IDs that identify the streams being retrieved. In a liveStream resource, the id property specifies the stream's ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveStream resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, cdn, and status.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_589717 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589717 = validateParameter(valid_589717, JString, required = false,
                                 default = nil)
  if valid_589717 != nil:
    section.add "onBehalfOfContentOwner", valid_589717
  var valid_589718 = query.getOrDefault("mine")
  valid_589718 = validateParameter(valid_589718, JBool, required = false, default = nil)
  if valid_589718 != nil:
    section.add "mine", valid_589718
  var valid_589719 = query.getOrDefault("fields")
  valid_589719 = validateParameter(valid_589719, JString, required = false,
                                 default = nil)
  if valid_589719 != nil:
    section.add "fields", valid_589719
  var valid_589720 = query.getOrDefault("pageToken")
  valid_589720 = validateParameter(valid_589720, JString, required = false,
                                 default = nil)
  if valid_589720 != nil:
    section.add "pageToken", valid_589720
  var valid_589721 = query.getOrDefault("quotaUser")
  valid_589721 = validateParameter(valid_589721, JString, required = false,
                                 default = nil)
  if valid_589721 != nil:
    section.add "quotaUser", valid_589721
  var valid_589722 = query.getOrDefault("id")
  valid_589722 = validateParameter(valid_589722, JString, required = false,
                                 default = nil)
  if valid_589722 != nil:
    section.add "id", valid_589722
  var valid_589723 = query.getOrDefault("alt")
  valid_589723 = validateParameter(valid_589723, JString, required = false,
                                 default = newJString("json"))
  if valid_589723 != nil:
    section.add "alt", valid_589723
  var valid_589724 = query.getOrDefault("oauth_token")
  valid_589724 = validateParameter(valid_589724, JString, required = false,
                                 default = nil)
  if valid_589724 != nil:
    section.add "oauth_token", valid_589724
  var valid_589725 = query.getOrDefault("userIp")
  valid_589725 = validateParameter(valid_589725, JString, required = false,
                                 default = nil)
  if valid_589725 != nil:
    section.add "userIp", valid_589725
  var valid_589726 = query.getOrDefault("maxResults")
  valid_589726 = validateParameter(valid_589726, JInt, required = false,
                                 default = newJInt(5))
  if valid_589726 != nil:
    section.add "maxResults", valid_589726
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589727 = query.getOrDefault("part")
  valid_589727 = validateParameter(valid_589727, JString, required = true,
                                 default = nil)
  if valid_589727 != nil:
    section.add "part", valid_589727
  var valid_589728 = query.getOrDefault("key")
  valid_589728 = validateParameter(valid_589728, JString, required = false,
                                 default = nil)
  if valid_589728 != nil:
    section.add "key", valid_589728
  var valid_589729 = query.getOrDefault("prettyPrint")
  valid_589729 = validateParameter(valid_589729, JBool, required = false,
                                 default = newJBool(true))
  if valid_589729 != nil:
    section.add "prettyPrint", valid_589729
  var valid_589730 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_589730 = validateParameter(valid_589730, JString, required = false,
                                 default = nil)
  if valid_589730 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_589730
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589731: Call_YoutubeLiveStreamsList_589714; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of video streams that match the API request parameters.
  ## 
  let valid = call_589731.validator(path, query, header, formData, body)
  let scheme = call_589731.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589731.url(scheme.get, call_589731.host, call_589731.base,
                         call_589731.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589731, url, valid)

proc call*(call_589732: Call_YoutubeLiveStreamsList_589714; part: string;
          onBehalfOfContentOwner: string = ""; mine: bool = false; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; id: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 5; key: string = ""; prettyPrint: bool = true;
          onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeLiveStreamsList
  ## Returns a list of video streams that match the API request parameters.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: bool
  ##       : The mine parameter can be used to instruct the API to only return streams owned by the authenticated user. Set the parameter value to true to only retrieve your own streams.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of YouTube stream IDs that identify the streams being retrieved. In a liveStream resource, the id property specifies the stream's ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveStream resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, cdn, and status.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_589733 = newJObject()
  add(query_589733, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589733, "mine", newJBool(mine))
  add(query_589733, "fields", newJString(fields))
  add(query_589733, "pageToken", newJString(pageToken))
  add(query_589733, "quotaUser", newJString(quotaUser))
  add(query_589733, "id", newJString(id))
  add(query_589733, "alt", newJString(alt))
  add(query_589733, "oauth_token", newJString(oauthToken))
  add(query_589733, "userIp", newJString(userIp))
  add(query_589733, "maxResults", newJInt(maxResults))
  add(query_589733, "part", newJString(part))
  add(query_589733, "key", newJString(key))
  add(query_589733, "prettyPrint", newJBool(prettyPrint))
  add(query_589733, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_589732.call(nil, query_589733, nil, nil, nil)

var youtubeLiveStreamsList* = Call_YoutubeLiveStreamsList_589714(
    name: "youtubeLiveStreamsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/liveStreams",
    validator: validate_YoutubeLiveStreamsList_589715, base: "/youtube/v3",
    url: url_YoutubeLiveStreamsList_589716, schemes: {Scheme.Https})
type
  Call_YoutubeLiveStreamsDelete_589770 = ref object of OpenApiRestCall_588466
proc url_YoutubeLiveStreamsDelete_589772(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveStreamsDelete_589771(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a video stream.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube live stream ID for the resource that is being deleted.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_589773 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589773 = validateParameter(valid_589773, JString, required = false,
                                 default = nil)
  if valid_589773 != nil:
    section.add "onBehalfOfContentOwner", valid_589773
  var valid_589774 = query.getOrDefault("fields")
  valid_589774 = validateParameter(valid_589774, JString, required = false,
                                 default = nil)
  if valid_589774 != nil:
    section.add "fields", valid_589774
  var valid_589775 = query.getOrDefault("quotaUser")
  valid_589775 = validateParameter(valid_589775, JString, required = false,
                                 default = nil)
  if valid_589775 != nil:
    section.add "quotaUser", valid_589775
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_589776 = query.getOrDefault("id")
  valid_589776 = validateParameter(valid_589776, JString, required = true,
                                 default = nil)
  if valid_589776 != nil:
    section.add "id", valid_589776
  var valid_589777 = query.getOrDefault("alt")
  valid_589777 = validateParameter(valid_589777, JString, required = false,
                                 default = newJString("json"))
  if valid_589777 != nil:
    section.add "alt", valid_589777
  var valid_589778 = query.getOrDefault("oauth_token")
  valid_589778 = validateParameter(valid_589778, JString, required = false,
                                 default = nil)
  if valid_589778 != nil:
    section.add "oauth_token", valid_589778
  var valid_589779 = query.getOrDefault("userIp")
  valid_589779 = validateParameter(valid_589779, JString, required = false,
                                 default = nil)
  if valid_589779 != nil:
    section.add "userIp", valid_589779
  var valid_589780 = query.getOrDefault("key")
  valid_589780 = validateParameter(valid_589780, JString, required = false,
                                 default = nil)
  if valid_589780 != nil:
    section.add "key", valid_589780
  var valid_589781 = query.getOrDefault("prettyPrint")
  valid_589781 = validateParameter(valid_589781, JBool, required = false,
                                 default = newJBool(true))
  if valid_589781 != nil:
    section.add "prettyPrint", valid_589781
  var valid_589782 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_589782 = validateParameter(valid_589782, JString, required = false,
                                 default = nil)
  if valid_589782 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_589782
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589783: Call_YoutubeLiveStreamsDelete_589770; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a video stream.
  ## 
  let valid = call_589783.validator(path, query, header, formData, body)
  let scheme = call_589783.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589783.url(scheme.get, call_589783.host, call_589783.base,
                         call_589783.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589783, url, valid)

proc call*(call_589784: Call_YoutubeLiveStreamsDelete_589770; id: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true;
          onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeLiveStreamsDelete
  ## Deletes a video stream.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube live stream ID for the resource that is being deleted.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_589785 = newJObject()
  add(query_589785, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589785, "fields", newJString(fields))
  add(query_589785, "quotaUser", newJString(quotaUser))
  add(query_589785, "id", newJString(id))
  add(query_589785, "alt", newJString(alt))
  add(query_589785, "oauth_token", newJString(oauthToken))
  add(query_589785, "userIp", newJString(userIp))
  add(query_589785, "key", newJString(key))
  add(query_589785, "prettyPrint", newJBool(prettyPrint))
  add(query_589785, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_589784.call(nil, query_589785, nil, nil, nil)

var youtubeLiveStreamsDelete* = Call_YoutubeLiveStreamsDelete_589770(
    name: "youtubeLiveStreamsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/liveStreams",
    validator: validate_YoutubeLiveStreamsDelete_589771, base: "/youtube/v3",
    url: url_YoutubeLiveStreamsDelete_589772, schemes: {Scheme.Https})
type
  Call_YoutubeMembersList_589786 = ref object of OpenApiRestCall_588466
proc url_YoutubeMembersList_589788(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeMembersList_589787(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists members for a channel.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   mode: JString
  ##       : The mode parameter specifies which channel members to return.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   hasAccessToLevel: JString
  ##                   : The hasAccessToLevel parameter specifies, when set, the ID of a pricing level that members from the results set should have access to. When not set, all members will be considered, regardless of their active pricing level.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies the member resource parts that the API response will include. Supported values are id and snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589789 = query.getOrDefault("fields")
  valid_589789 = validateParameter(valid_589789, JString, required = false,
                                 default = nil)
  if valid_589789 != nil:
    section.add "fields", valid_589789
  var valid_589790 = query.getOrDefault("pageToken")
  valid_589790 = validateParameter(valid_589790, JString, required = false,
                                 default = nil)
  if valid_589790 != nil:
    section.add "pageToken", valid_589790
  var valid_589791 = query.getOrDefault("quotaUser")
  valid_589791 = validateParameter(valid_589791, JString, required = false,
                                 default = nil)
  if valid_589791 != nil:
    section.add "quotaUser", valid_589791
  var valid_589792 = query.getOrDefault("alt")
  valid_589792 = validateParameter(valid_589792, JString, required = false,
                                 default = newJString("json"))
  if valid_589792 != nil:
    section.add "alt", valid_589792
  var valid_589793 = query.getOrDefault("oauth_token")
  valid_589793 = validateParameter(valid_589793, JString, required = false,
                                 default = nil)
  if valid_589793 != nil:
    section.add "oauth_token", valid_589793
  var valid_589794 = query.getOrDefault("mode")
  valid_589794 = validateParameter(valid_589794, JString, required = false,
                                 default = newJString("all_current"))
  if valid_589794 != nil:
    section.add "mode", valid_589794
  var valid_589795 = query.getOrDefault("userIp")
  valid_589795 = validateParameter(valid_589795, JString, required = false,
                                 default = nil)
  if valid_589795 != nil:
    section.add "userIp", valid_589795
  var valid_589796 = query.getOrDefault("hasAccessToLevel")
  valid_589796 = validateParameter(valid_589796, JString, required = false,
                                 default = nil)
  if valid_589796 != nil:
    section.add "hasAccessToLevel", valid_589796
  var valid_589797 = query.getOrDefault("maxResults")
  valid_589797 = validateParameter(valid_589797, JInt, required = false,
                                 default = newJInt(5))
  if valid_589797 != nil:
    section.add "maxResults", valid_589797
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589798 = query.getOrDefault("part")
  valid_589798 = validateParameter(valid_589798, JString, required = true,
                                 default = nil)
  if valid_589798 != nil:
    section.add "part", valid_589798
  var valid_589799 = query.getOrDefault("key")
  valid_589799 = validateParameter(valid_589799, JString, required = false,
                                 default = nil)
  if valid_589799 != nil:
    section.add "key", valid_589799
  var valid_589800 = query.getOrDefault("prettyPrint")
  valid_589800 = validateParameter(valid_589800, JBool, required = false,
                                 default = newJBool(true))
  if valid_589800 != nil:
    section.add "prettyPrint", valid_589800
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589801: Call_YoutubeMembersList_589786; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists members for a channel.
  ## 
  let valid = call_589801.validator(path, query, header, formData, body)
  let scheme = call_589801.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589801.url(scheme.get, call_589801.host, call_589801.base,
                         call_589801.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589801, url, valid)

proc call*(call_589802: Call_YoutubeMembersList_589786; part: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; mode: string = "all_current";
          userIp: string = ""; hasAccessToLevel: string = ""; maxResults: int = 5;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeMembersList
  ## Lists members for a channel.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   mode: string
  ##       : The mode parameter specifies which channel members to return.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   hasAccessToLevel: string
  ##                   : The hasAccessToLevel parameter specifies, when set, the ID of a pricing level that members from the results set should have access to. When not set, all members will be considered, regardless of their active pricing level.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies the member resource parts that the API response will include. Supported values are id and snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589803 = newJObject()
  add(query_589803, "fields", newJString(fields))
  add(query_589803, "pageToken", newJString(pageToken))
  add(query_589803, "quotaUser", newJString(quotaUser))
  add(query_589803, "alt", newJString(alt))
  add(query_589803, "oauth_token", newJString(oauthToken))
  add(query_589803, "mode", newJString(mode))
  add(query_589803, "userIp", newJString(userIp))
  add(query_589803, "hasAccessToLevel", newJString(hasAccessToLevel))
  add(query_589803, "maxResults", newJInt(maxResults))
  add(query_589803, "part", newJString(part))
  add(query_589803, "key", newJString(key))
  add(query_589803, "prettyPrint", newJBool(prettyPrint))
  result = call_589802.call(nil, query_589803, nil, nil, nil)

var youtubeMembersList* = Call_YoutubeMembersList_589786(
    name: "youtubeMembersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/members",
    validator: validate_YoutubeMembersList_589787, base: "/youtube/v3",
    url: url_YoutubeMembersList_589788, schemes: {Scheme.Https})
type
  Call_YoutubeMembershipsLevelsList_589804 = ref object of OpenApiRestCall_588466
proc url_YoutubeMembershipsLevelsList_589806(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeMembershipsLevelsList_589805(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists pricing levels for a channel.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter specifies the membershipsLevel resource parts that the API response will include. Supported values are id and snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589807 = query.getOrDefault("fields")
  valid_589807 = validateParameter(valid_589807, JString, required = false,
                                 default = nil)
  if valid_589807 != nil:
    section.add "fields", valid_589807
  var valid_589808 = query.getOrDefault("quotaUser")
  valid_589808 = validateParameter(valid_589808, JString, required = false,
                                 default = nil)
  if valid_589808 != nil:
    section.add "quotaUser", valid_589808
  var valid_589809 = query.getOrDefault("alt")
  valid_589809 = validateParameter(valid_589809, JString, required = false,
                                 default = newJString("json"))
  if valid_589809 != nil:
    section.add "alt", valid_589809
  var valid_589810 = query.getOrDefault("oauth_token")
  valid_589810 = validateParameter(valid_589810, JString, required = false,
                                 default = nil)
  if valid_589810 != nil:
    section.add "oauth_token", valid_589810
  var valid_589811 = query.getOrDefault("userIp")
  valid_589811 = validateParameter(valid_589811, JString, required = false,
                                 default = nil)
  if valid_589811 != nil:
    section.add "userIp", valid_589811
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589812 = query.getOrDefault("part")
  valid_589812 = validateParameter(valid_589812, JString, required = true,
                                 default = nil)
  if valid_589812 != nil:
    section.add "part", valid_589812
  var valid_589813 = query.getOrDefault("key")
  valid_589813 = validateParameter(valid_589813, JString, required = false,
                                 default = nil)
  if valid_589813 != nil:
    section.add "key", valid_589813
  var valid_589814 = query.getOrDefault("prettyPrint")
  valid_589814 = validateParameter(valid_589814, JBool, required = false,
                                 default = newJBool(true))
  if valid_589814 != nil:
    section.add "prettyPrint", valid_589814
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589815: Call_YoutubeMembershipsLevelsList_589804; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists pricing levels for a channel.
  ## 
  let valid = call_589815.validator(path, query, header, formData, body)
  let scheme = call_589815.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589815.url(scheme.get, call_589815.host, call_589815.base,
                         call_589815.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589815, url, valid)

proc call*(call_589816: Call_YoutubeMembershipsLevelsList_589804; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## youtubeMembershipsLevelsList
  ## Lists pricing levels for a channel.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter specifies the membershipsLevel resource parts that the API response will include. Supported values are id and snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589817 = newJObject()
  add(query_589817, "fields", newJString(fields))
  add(query_589817, "quotaUser", newJString(quotaUser))
  add(query_589817, "alt", newJString(alt))
  add(query_589817, "oauth_token", newJString(oauthToken))
  add(query_589817, "userIp", newJString(userIp))
  add(query_589817, "part", newJString(part))
  add(query_589817, "key", newJString(key))
  add(query_589817, "prettyPrint", newJBool(prettyPrint))
  result = call_589816.call(nil, query_589817, nil, nil, nil)

var youtubeMembershipsLevelsList* = Call_YoutubeMembershipsLevelsList_589804(
    name: "youtubeMembershipsLevelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/membershipsLevels",
    validator: validate_YoutubeMembershipsLevelsList_589805, base: "/youtube/v3",
    url: url_YoutubeMembershipsLevelsList_589806, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistItemsUpdate_589838 = ref object of OpenApiRestCall_588466
proc url_YoutubePlaylistItemsUpdate_589840(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubePlaylistItemsUpdate_589839(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies a playlist item. For example, you could update the item's position in the playlist.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. For example, a playlist item can specify a start time and end time, which identify the times portion of the video that should play when users watch the video in the playlist. If your request is updating a playlist item that sets these values, and the request's part parameter value includes the contentDetails part, the playlist item's start and end times will be updated to whatever value the request body specifies. If the request body does not specify values, the existing start and end times will be removed and replaced with the default settings.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589841 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589841 = validateParameter(valid_589841, JString, required = false,
                                 default = nil)
  if valid_589841 != nil:
    section.add "onBehalfOfContentOwner", valid_589841
  var valid_589842 = query.getOrDefault("fields")
  valid_589842 = validateParameter(valid_589842, JString, required = false,
                                 default = nil)
  if valid_589842 != nil:
    section.add "fields", valid_589842
  var valid_589843 = query.getOrDefault("quotaUser")
  valid_589843 = validateParameter(valid_589843, JString, required = false,
                                 default = nil)
  if valid_589843 != nil:
    section.add "quotaUser", valid_589843
  var valid_589844 = query.getOrDefault("alt")
  valid_589844 = validateParameter(valid_589844, JString, required = false,
                                 default = newJString("json"))
  if valid_589844 != nil:
    section.add "alt", valid_589844
  var valid_589845 = query.getOrDefault("oauth_token")
  valid_589845 = validateParameter(valid_589845, JString, required = false,
                                 default = nil)
  if valid_589845 != nil:
    section.add "oauth_token", valid_589845
  var valid_589846 = query.getOrDefault("userIp")
  valid_589846 = validateParameter(valid_589846, JString, required = false,
                                 default = nil)
  if valid_589846 != nil:
    section.add "userIp", valid_589846
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589847 = query.getOrDefault("part")
  valid_589847 = validateParameter(valid_589847, JString, required = true,
                                 default = nil)
  if valid_589847 != nil:
    section.add "part", valid_589847
  var valid_589848 = query.getOrDefault("key")
  valid_589848 = validateParameter(valid_589848, JString, required = false,
                                 default = nil)
  if valid_589848 != nil:
    section.add "key", valid_589848
  var valid_589849 = query.getOrDefault("prettyPrint")
  valid_589849 = validateParameter(valid_589849, JBool, required = false,
                                 default = newJBool(true))
  if valid_589849 != nil:
    section.add "prettyPrint", valid_589849
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

proc call*(call_589851: Call_YoutubePlaylistItemsUpdate_589838; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies a playlist item. For example, you could update the item's position in the playlist.
  ## 
  let valid = call_589851.validator(path, query, header, formData, body)
  let scheme = call_589851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589851.url(scheme.get, call_589851.host, call_589851.base,
                         call_589851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589851, url, valid)

proc call*(call_589852: Call_YoutubePlaylistItemsUpdate_589838; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## youtubePlaylistItemsUpdate
  ## Modifies a playlist item. For example, you could update the item's position in the playlist.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. For example, a playlist item can specify a start time and end time, which identify the times portion of the video that should play when users watch the video in the playlist. If your request is updating a playlist item that sets these values, and the request's part parameter value includes the contentDetails part, the playlist item's start and end times will be updated to whatever value the request body specifies. If the request body does not specify values, the existing start and end times will be removed and replaced with the default settings.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589853 = newJObject()
  var body_589854 = newJObject()
  add(query_589853, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589853, "fields", newJString(fields))
  add(query_589853, "quotaUser", newJString(quotaUser))
  add(query_589853, "alt", newJString(alt))
  add(query_589853, "oauth_token", newJString(oauthToken))
  add(query_589853, "userIp", newJString(userIp))
  add(query_589853, "part", newJString(part))
  add(query_589853, "key", newJString(key))
  if body != nil:
    body_589854 = body
  add(query_589853, "prettyPrint", newJBool(prettyPrint))
  result = call_589852.call(nil, query_589853, nil, nil, body_589854)

var youtubePlaylistItemsUpdate* = Call_YoutubePlaylistItemsUpdate_589838(
    name: "youtubePlaylistItemsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/playlistItems",
    validator: validate_YoutubePlaylistItemsUpdate_589839, base: "/youtube/v3",
    url: url_YoutubePlaylistItemsUpdate_589840, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistItemsInsert_589855 = ref object of OpenApiRestCall_588466
proc url_YoutubePlaylistItemsInsert_589857(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubePlaylistItemsInsert_589856(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a resource to a playlist.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589858 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589858 = validateParameter(valid_589858, JString, required = false,
                                 default = nil)
  if valid_589858 != nil:
    section.add "onBehalfOfContentOwner", valid_589858
  var valid_589859 = query.getOrDefault("fields")
  valid_589859 = validateParameter(valid_589859, JString, required = false,
                                 default = nil)
  if valid_589859 != nil:
    section.add "fields", valid_589859
  var valid_589860 = query.getOrDefault("quotaUser")
  valid_589860 = validateParameter(valid_589860, JString, required = false,
                                 default = nil)
  if valid_589860 != nil:
    section.add "quotaUser", valid_589860
  var valid_589861 = query.getOrDefault("alt")
  valid_589861 = validateParameter(valid_589861, JString, required = false,
                                 default = newJString("json"))
  if valid_589861 != nil:
    section.add "alt", valid_589861
  var valid_589862 = query.getOrDefault("oauth_token")
  valid_589862 = validateParameter(valid_589862, JString, required = false,
                                 default = nil)
  if valid_589862 != nil:
    section.add "oauth_token", valid_589862
  var valid_589863 = query.getOrDefault("userIp")
  valid_589863 = validateParameter(valid_589863, JString, required = false,
                                 default = nil)
  if valid_589863 != nil:
    section.add "userIp", valid_589863
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589864 = query.getOrDefault("part")
  valid_589864 = validateParameter(valid_589864, JString, required = true,
                                 default = nil)
  if valid_589864 != nil:
    section.add "part", valid_589864
  var valid_589865 = query.getOrDefault("key")
  valid_589865 = validateParameter(valid_589865, JString, required = false,
                                 default = nil)
  if valid_589865 != nil:
    section.add "key", valid_589865
  var valid_589866 = query.getOrDefault("prettyPrint")
  valid_589866 = validateParameter(valid_589866, JBool, required = false,
                                 default = newJBool(true))
  if valid_589866 != nil:
    section.add "prettyPrint", valid_589866
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

proc call*(call_589868: Call_YoutubePlaylistItemsInsert_589855; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a resource to a playlist.
  ## 
  let valid = call_589868.validator(path, query, header, formData, body)
  let scheme = call_589868.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589868.url(scheme.get, call_589868.host, call_589868.base,
                         call_589868.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589868, url, valid)

proc call*(call_589869: Call_YoutubePlaylistItemsInsert_589855; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## youtubePlaylistItemsInsert
  ## Adds a resource to a playlist.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589870 = newJObject()
  var body_589871 = newJObject()
  add(query_589870, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589870, "fields", newJString(fields))
  add(query_589870, "quotaUser", newJString(quotaUser))
  add(query_589870, "alt", newJString(alt))
  add(query_589870, "oauth_token", newJString(oauthToken))
  add(query_589870, "userIp", newJString(userIp))
  add(query_589870, "part", newJString(part))
  add(query_589870, "key", newJString(key))
  if body != nil:
    body_589871 = body
  add(query_589870, "prettyPrint", newJBool(prettyPrint))
  result = call_589869.call(nil, query_589870, nil, nil, body_589871)

var youtubePlaylistItemsInsert* = Call_YoutubePlaylistItemsInsert_589855(
    name: "youtubePlaylistItemsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/playlistItems",
    validator: validate_YoutubePlaylistItemsInsert_589856, base: "/youtube/v3",
    url: url_YoutubePlaylistItemsInsert_589857, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistItemsList_589818 = ref object of OpenApiRestCall_588466
proc url_YoutubePlaylistItemsList_589820(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubePlaylistItemsList_589819(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a collection of playlist items that match the API request parameters. You can retrieve all of the playlist items in a specified playlist or retrieve one or more playlist items by their unique IDs.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   playlistId: JString
  ##             : The playlistId parameter specifies the unique ID of the playlist for which you want to retrieve playlist items. Note that even though this is an optional parameter, every request to retrieve playlist items must specify a value for either the id parameter or the playlistId parameter.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of one or more unique playlist item IDs.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   videoId: JString
  ##          : The videoId parameter specifies that the request should return only the playlist items that contain the specified video.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more playlistItem resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a playlistItem resource, the snippet property contains numerous fields, including the title, description, position, and resourceId properties. As such, if you set part=snippet, the API response will contain all of those properties.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589821 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589821 = validateParameter(valid_589821, JString, required = false,
                                 default = nil)
  if valid_589821 != nil:
    section.add "onBehalfOfContentOwner", valid_589821
  var valid_589822 = query.getOrDefault("playlistId")
  valid_589822 = validateParameter(valid_589822, JString, required = false,
                                 default = nil)
  if valid_589822 != nil:
    section.add "playlistId", valid_589822
  var valid_589823 = query.getOrDefault("fields")
  valid_589823 = validateParameter(valid_589823, JString, required = false,
                                 default = nil)
  if valid_589823 != nil:
    section.add "fields", valid_589823
  var valid_589824 = query.getOrDefault("pageToken")
  valid_589824 = validateParameter(valid_589824, JString, required = false,
                                 default = nil)
  if valid_589824 != nil:
    section.add "pageToken", valid_589824
  var valid_589825 = query.getOrDefault("quotaUser")
  valid_589825 = validateParameter(valid_589825, JString, required = false,
                                 default = nil)
  if valid_589825 != nil:
    section.add "quotaUser", valid_589825
  var valid_589826 = query.getOrDefault("id")
  valid_589826 = validateParameter(valid_589826, JString, required = false,
                                 default = nil)
  if valid_589826 != nil:
    section.add "id", valid_589826
  var valid_589827 = query.getOrDefault("alt")
  valid_589827 = validateParameter(valid_589827, JString, required = false,
                                 default = newJString("json"))
  if valid_589827 != nil:
    section.add "alt", valid_589827
  var valid_589828 = query.getOrDefault("oauth_token")
  valid_589828 = validateParameter(valid_589828, JString, required = false,
                                 default = nil)
  if valid_589828 != nil:
    section.add "oauth_token", valid_589828
  var valid_589829 = query.getOrDefault("userIp")
  valid_589829 = validateParameter(valid_589829, JString, required = false,
                                 default = nil)
  if valid_589829 != nil:
    section.add "userIp", valid_589829
  var valid_589830 = query.getOrDefault("videoId")
  valid_589830 = validateParameter(valid_589830, JString, required = false,
                                 default = nil)
  if valid_589830 != nil:
    section.add "videoId", valid_589830
  var valid_589831 = query.getOrDefault("maxResults")
  valid_589831 = validateParameter(valid_589831, JInt, required = false,
                                 default = newJInt(5))
  if valid_589831 != nil:
    section.add "maxResults", valid_589831
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589832 = query.getOrDefault("part")
  valid_589832 = validateParameter(valid_589832, JString, required = true,
                                 default = nil)
  if valid_589832 != nil:
    section.add "part", valid_589832
  var valid_589833 = query.getOrDefault("key")
  valid_589833 = validateParameter(valid_589833, JString, required = false,
                                 default = nil)
  if valid_589833 != nil:
    section.add "key", valid_589833
  var valid_589834 = query.getOrDefault("prettyPrint")
  valid_589834 = validateParameter(valid_589834, JBool, required = false,
                                 default = newJBool(true))
  if valid_589834 != nil:
    section.add "prettyPrint", valid_589834
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589835: Call_YoutubePlaylistItemsList_589818; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of playlist items that match the API request parameters. You can retrieve all of the playlist items in a specified playlist or retrieve one or more playlist items by their unique IDs.
  ## 
  let valid = call_589835.validator(path, query, header, formData, body)
  let scheme = call_589835.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589835.url(scheme.get, call_589835.host, call_589835.base,
                         call_589835.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589835, url, valid)

proc call*(call_589836: Call_YoutubePlaylistItemsList_589818; part: string;
          onBehalfOfContentOwner: string = ""; playlistId: string = "";
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          id: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; videoId: string = ""; maxResults: int = 5; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## youtubePlaylistItemsList
  ## Returns a collection of playlist items that match the API request parameters. You can retrieve all of the playlist items in a specified playlist or retrieve one or more playlist items by their unique IDs.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   playlistId: string
  ##             : The playlistId parameter specifies the unique ID of the playlist for which you want to retrieve playlist items. Note that even though this is an optional parameter, every request to retrieve playlist items must specify a value for either the id parameter or the playlistId parameter.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of one or more unique playlist item IDs.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   videoId: string
  ##          : The videoId parameter specifies that the request should return only the playlist items that contain the specified video.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more playlistItem resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a playlistItem resource, the snippet property contains numerous fields, including the title, description, position, and resourceId properties. As such, if you set part=snippet, the API response will contain all of those properties.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589837 = newJObject()
  add(query_589837, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589837, "playlistId", newJString(playlistId))
  add(query_589837, "fields", newJString(fields))
  add(query_589837, "pageToken", newJString(pageToken))
  add(query_589837, "quotaUser", newJString(quotaUser))
  add(query_589837, "id", newJString(id))
  add(query_589837, "alt", newJString(alt))
  add(query_589837, "oauth_token", newJString(oauthToken))
  add(query_589837, "userIp", newJString(userIp))
  add(query_589837, "videoId", newJString(videoId))
  add(query_589837, "maxResults", newJInt(maxResults))
  add(query_589837, "part", newJString(part))
  add(query_589837, "key", newJString(key))
  add(query_589837, "prettyPrint", newJBool(prettyPrint))
  result = call_589836.call(nil, query_589837, nil, nil, nil)

var youtubePlaylistItemsList* = Call_YoutubePlaylistItemsList_589818(
    name: "youtubePlaylistItemsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/playlistItems",
    validator: validate_YoutubePlaylistItemsList_589819, base: "/youtube/v3",
    url: url_YoutubePlaylistItemsList_589820, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistItemsDelete_589872 = ref object of OpenApiRestCall_588466
proc url_YoutubePlaylistItemsDelete_589874(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubePlaylistItemsDelete_589873(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a playlist item.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube playlist item ID for the playlist item that is being deleted. In a playlistItem resource, the id property specifies the playlist item's ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589875 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589875 = validateParameter(valid_589875, JString, required = false,
                                 default = nil)
  if valid_589875 != nil:
    section.add "onBehalfOfContentOwner", valid_589875
  var valid_589876 = query.getOrDefault("fields")
  valid_589876 = validateParameter(valid_589876, JString, required = false,
                                 default = nil)
  if valid_589876 != nil:
    section.add "fields", valid_589876
  var valid_589877 = query.getOrDefault("quotaUser")
  valid_589877 = validateParameter(valid_589877, JString, required = false,
                                 default = nil)
  if valid_589877 != nil:
    section.add "quotaUser", valid_589877
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_589878 = query.getOrDefault("id")
  valid_589878 = validateParameter(valid_589878, JString, required = true,
                                 default = nil)
  if valid_589878 != nil:
    section.add "id", valid_589878
  var valid_589879 = query.getOrDefault("alt")
  valid_589879 = validateParameter(valid_589879, JString, required = false,
                                 default = newJString("json"))
  if valid_589879 != nil:
    section.add "alt", valid_589879
  var valid_589880 = query.getOrDefault("oauth_token")
  valid_589880 = validateParameter(valid_589880, JString, required = false,
                                 default = nil)
  if valid_589880 != nil:
    section.add "oauth_token", valid_589880
  var valid_589881 = query.getOrDefault("userIp")
  valid_589881 = validateParameter(valid_589881, JString, required = false,
                                 default = nil)
  if valid_589881 != nil:
    section.add "userIp", valid_589881
  var valid_589882 = query.getOrDefault("key")
  valid_589882 = validateParameter(valid_589882, JString, required = false,
                                 default = nil)
  if valid_589882 != nil:
    section.add "key", valid_589882
  var valid_589883 = query.getOrDefault("prettyPrint")
  valid_589883 = validateParameter(valid_589883, JBool, required = false,
                                 default = newJBool(true))
  if valid_589883 != nil:
    section.add "prettyPrint", valid_589883
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589884: Call_YoutubePlaylistItemsDelete_589872; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a playlist item.
  ## 
  let valid = call_589884.validator(path, query, header, formData, body)
  let scheme = call_589884.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589884.url(scheme.get, call_589884.host, call_589884.base,
                         call_589884.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589884, url, valid)

proc call*(call_589885: Call_YoutubePlaylistItemsDelete_589872; id: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubePlaylistItemsDelete
  ## Deletes a playlist item.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube playlist item ID for the playlist item that is being deleted. In a playlistItem resource, the id property specifies the playlist item's ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589886 = newJObject()
  add(query_589886, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589886, "fields", newJString(fields))
  add(query_589886, "quotaUser", newJString(quotaUser))
  add(query_589886, "id", newJString(id))
  add(query_589886, "alt", newJString(alt))
  add(query_589886, "oauth_token", newJString(oauthToken))
  add(query_589886, "userIp", newJString(userIp))
  add(query_589886, "key", newJString(key))
  add(query_589886, "prettyPrint", newJBool(prettyPrint))
  result = call_589885.call(nil, query_589886, nil, nil, nil)

var youtubePlaylistItemsDelete* = Call_YoutubePlaylistItemsDelete_589872(
    name: "youtubePlaylistItemsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/playlistItems",
    validator: validate_YoutubePlaylistItemsDelete_589873, base: "/youtube/v3",
    url: url_YoutubePlaylistItemsDelete_589874, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistsUpdate_589909 = ref object of OpenApiRestCall_588466
proc url_YoutubePlaylistsUpdate_589911(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubePlaylistsUpdate_589910(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies a playlist. For example, you could change a playlist's title, description, or privacy status.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that this method will override the existing values for mutable properties that are contained in any parts that the request body specifies. For example, a playlist's description is contained in the snippet part, which must be included in the request body. If the request does not specify a value for the snippet.description property, the playlist's existing description will be deleted.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589912 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589912 = validateParameter(valid_589912, JString, required = false,
                                 default = nil)
  if valid_589912 != nil:
    section.add "onBehalfOfContentOwner", valid_589912
  var valid_589913 = query.getOrDefault("fields")
  valid_589913 = validateParameter(valid_589913, JString, required = false,
                                 default = nil)
  if valid_589913 != nil:
    section.add "fields", valid_589913
  var valid_589914 = query.getOrDefault("quotaUser")
  valid_589914 = validateParameter(valid_589914, JString, required = false,
                                 default = nil)
  if valid_589914 != nil:
    section.add "quotaUser", valid_589914
  var valid_589915 = query.getOrDefault("alt")
  valid_589915 = validateParameter(valid_589915, JString, required = false,
                                 default = newJString("json"))
  if valid_589915 != nil:
    section.add "alt", valid_589915
  var valid_589916 = query.getOrDefault("oauth_token")
  valid_589916 = validateParameter(valid_589916, JString, required = false,
                                 default = nil)
  if valid_589916 != nil:
    section.add "oauth_token", valid_589916
  var valid_589917 = query.getOrDefault("userIp")
  valid_589917 = validateParameter(valid_589917, JString, required = false,
                                 default = nil)
  if valid_589917 != nil:
    section.add "userIp", valid_589917
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589918 = query.getOrDefault("part")
  valid_589918 = validateParameter(valid_589918, JString, required = true,
                                 default = nil)
  if valid_589918 != nil:
    section.add "part", valid_589918
  var valid_589919 = query.getOrDefault("key")
  valid_589919 = validateParameter(valid_589919, JString, required = false,
                                 default = nil)
  if valid_589919 != nil:
    section.add "key", valid_589919
  var valid_589920 = query.getOrDefault("prettyPrint")
  valid_589920 = validateParameter(valid_589920, JBool, required = false,
                                 default = newJBool(true))
  if valid_589920 != nil:
    section.add "prettyPrint", valid_589920
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

proc call*(call_589922: Call_YoutubePlaylistsUpdate_589909; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies a playlist. For example, you could change a playlist's title, description, or privacy status.
  ## 
  let valid = call_589922.validator(path, query, header, formData, body)
  let scheme = call_589922.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589922.url(scheme.get, call_589922.host, call_589922.base,
                         call_589922.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589922, url, valid)

proc call*(call_589923: Call_YoutubePlaylistsUpdate_589909; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## youtubePlaylistsUpdate
  ## Modifies a playlist. For example, you could change a playlist's title, description, or privacy status.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that this method will override the existing values for mutable properties that are contained in any parts that the request body specifies. For example, a playlist's description is contained in the snippet part, which must be included in the request body. If the request does not specify a value for the snippet.description property, the playlist's existing description will be deleted.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589924 = newJObject()
  var body_589925 = newJObject()
  add(query_589924, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589924, "fields", newJString(fields))
  add(query_589924, "quotaUser", newJString(quotaUser))
  add(query_589924, "alt", newJString(alt))
  add(query_589924, "oauth_token", newJString(oauthToken))
  add(query_589924, "userIp", newJString(userIp))
  add(query_589924, "part", newJString(part))
  add(query_589924, "key", newJString(key))
  if body != nil:
    body_589925 = body
  add(query_589924, "prettyPrint", newJBool(prettyPrint))
  result = call_589923.call(nil, query_589924, nil, nil, body_589925)

var youtubePlaylistsUpdate* = Call_YoutubePlaylistsUpdate_589909(
    name: "youtubePlaylistsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/playlists",
    validator: validate_YoutubePlaylistsUpdate_589910, base: "/youtube/v3",
    url: url_YoutubePlaylistsUpdate_589911, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistsInsert_589926 = ref object of OpenApiRestCall_588466
proc url_YoutubePlaylistsInsert_589928(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubePlaylistsInsert_589927(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a playlist.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_589929 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589929 = validateParameter(valid_589929, JString, required = false,
                                 default = nil)
  if valid_589929 != nil:
    section.add "onBehalfOfContentOwner", valid_589929
  var valid_589930 = query.getOrDefault("fields")
  valid_589930 = validateParameter(valid_589930, JString, required = false,
                                 default = nil)
  if valid_589930 != nil:
    section.add "fields", valid_589930
  var valid_589931 = query.getOrDefault("quotaUser")
  valid_589931 = validateParameter(valid_589931, JString, required = false,
                                 default = nil)
  if valid_589931 != nil:
    section.add "quotaUser", valid_589931
  var valid_589932 = query.getOrDefault("alt")
  valid_589932 = validateParameter(valid_589932, JString, required = false,
                                 default = newJString("json"))
  if valid_589932 != nil:
    section.add "alt", valid_589932
  var valid_589933 = query.getOrDefault("oauth_token")
  valid_589933 = validateParameter(valid_589933, JString, required = false,
                                 default = nil)
  if valid_589933 != nil:
    section.add "oauth_token", valid_589933
  var valid_589934 = query.getOrDefault("userIp")
  valid_589934 = validateParameter(valid_589934, JString, required = false,
                                 default = nil)
  if valid_589934 != nil:
    section.add "userIp", valid_589934
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589935 = query.getOrDefault("part")
  valid_589935 = validateParameter(valid_589935, JString, required = true,
                                 default = nil)
  if valid_589935 != nil:
    section.add "part", valid_589935
  var valid_589936 = query.getOrDefault("key")
  valid_589936 = validateParameter(valid_589936, JString, required = false,
                                 default = nil)
  if valid_589936 != nil:
    section.add "key", valid_589936
  var valid_589937 = query.getOrDefault("prettyPrint")
  valid_589937 = validateParameter(valid_589937, JBool, required = false,
                                 default = newJBool(true))
  if valid_589937 != nil:
    section.add "prettyPrint", valid_589937
  var valid_589938 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_589938 = validateParameter(valid_589938, JString, required = false,
                                 default = nil)
  if valid_589938 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_589938
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

proc call*(call_589940: Call_YoutubePlaylistsInsert_589926; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a playlist.
  ## 
  let valid = call_589940.validator(path, query, header, formData, body)
  let scheme = call_589940.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589940.url(scheme.get, call_589940.host, call_589940.base,
                         call_589940.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589940, url, valid)

proc call*(call_589941: Call_YoutubePlaylistsInsert_589926; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubePlaylistsInsert
  ## Creates a playlist.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_589942 = newJObject()
  var body_589943 = newJObject()
  add(query_589942, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589942, "fields", newJString(fields))
  add(query_589942, "quotaUser", newJString(quotaUser))
  add(query_589942, "alt", newJString(alt))
  add(query_589942, "oauth_token", newJString(oauthToken))
  add(query_589942, "userIp", newJString(userIp))
  add(query_589942, "part", newJString(part))
  add(query_589942, "key", newJString(key))
  if body != nil:
    body_589943 = body
  add(query_589942, "prettyPrint", newJBool(prettyPrint))
  add(query_589942, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_589941.call(nil, query_589942, nil, nil, body_589943)

var youtubePlaylistsInsert* = Call_YoutubePlaylistsInsert_589926(
    name: "youtubePlaylistsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/playlists",
    validator: validate_YoutubePlaylistsInsert_589927, base: "/youtube/v3",
    url: url_YoutubePlaylistsInsert_589928, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistsList_589887 = ref object of OpenApiRestCall_588466
proc url_YoutubePlaylistsList_589889(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubePlaylistsList_589888(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a collection of playlists that match the API request parameters. For example, you can retrieve all playlists that the authenticated user owns, or you can retrieve one or more playlists by their unique IDs.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: JBool
  ##       : Set this parameter's value to true to instruct the API to only return playlists owned by the authenticated user.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of the YouTube playlist ID(s) for the resource(s) that are being retrieved. In a playlist resource, the id property specifies the playlist's YouTube playlist ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more playlist resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a playlist resource, the snippet property contains properties like author, title, description, tags, and timeCreated. As such, if you set part=snippet, the API response will contain all of those properties.
  ##   channelId: JString
  ##            : This value indicates that the API should only return the specified channel's playlists.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   hl: JString
  ##     : The hl parameter should be used for filter out the properties that are not in the given language. Used for the snippet part.
  section = newJObject()
  var valid_589890 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589890 = validateParameter(valid_589890, JString, required = false,
                                 default = nil)
  if valid_589890 != nil:
    section.add "onBehalfOfContentOwner", valid_589890
  var valid_589891 = query.getOrDefault("mine")
  valid_589891 = validateParameter(valid_589891, JBool, required = false, default = nil)
  if valid_589891 != nil:
    section.add "mine", valid_589891
  var valid_589892 = query.getOrDefault("fields")
  valid_589892 = validateParameter(valid_589892, JString, required = false,
                                 default = nil)
  if valid_589892 != nil:
    section.add "fields", valid_589892
  var valid_589893 = query.getOrDefault("pageToken")
  valid_589893 = validateParameter(valid_589893, JString, required = false,
                                 default = nil)
  if valid_589893 != nil:
    section.add "pageToken", valid_589893
  var valid_589894 = query.getOrDefault("quotaUser")
  valid_589894 = validateParameter(valid_589894, JString, required = false,
                                 default = nil)
  if valid_589894 != nil:
    section.add "quotaUser", valid_589894
  var valid_589895 = query.getOrDefault("id")
  valid_589895 = validateParameter(valid_589895, JString, required = false,
                                 default = nil)
  if valid_589895 != nil:
    section.add "id", valid_589895
  var valid_589896 = query.getOrDefault("alt")
  valid_589896 = validateParameter(valid_589896, JString, required = false,
                                 default = newJString("json"))
  if valid_589896 != nil:
    section.add "alt", valid_589896
  var valid_589897 = query.getOrDefault("oauth_token")
  valid_589897 = validateParameter(valid_589897, JString, required = false,
                                 default = nil)
  if valid_589897 != nil:
    section.add "oauth_token", valid_589897
  var valid_589898 = query.getOrDefault("userIp")
  valid_589898 = validateParameter(valid_589898, JString, required = false,
                                 default = nil)
  if valid_589898 != nil:
    section.add "userIp", valid_589898
  var valid_589899 = query.getOrDefault("maxResults")
  valid_589899 = validateParameter(valid_589899, JInt, required = false,
                                 default = newJInt(5))
  if valid_589899 != nil:
    section.add "maxResults", valid_589899
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589900 = query.getOrDefault("part")
  valid_589900 = validateParameter(valid_589900, JString, required = true,
                                 default = nil)
  if valid_589900 != nil:
    section.add "part", valid_589900
  var valid_589901 = query.getOrDefault("channelId")
  valid_589901 = validateParameter(valid_589901, JString, required = false,
                                 default = nil)
  if valid_589901 != nil:
    section.add "channelId", valid_589901
  var valid_589902 = query.getOrDefault("key")
  valid_589902 = validateParameter(valid_589902, JString, required = false,
                                 default = nil)
  if valid_589902 != nil:
    section.add "key", valid_589902
  var valid_589903 = query.getOrDefault("prettyPrint")
  valid_589903 = validateParameter(valid_589903, JBool, required = false,
                                 default = newJBool(true))
  if valid_589903 != nil:
    section.add "prettyPrint", valid_589903
  var valid_589904 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_589904 = validateParameter(valid_589904, JString, required = false,
                                 default = nil)
  if valid_589904 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_589904
  var valid_589905 = query.getOrDefault("hl")
  valid_589905 = validateParameter(valid_589905, JString, required = false,
                                 default = nil)
  if valid_589905 != nil:
    section.add "hl", valid_589905
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589906: Call_YoutubePlaylistsList_589887; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of playlists that match the API request parameters. For example, you can retrieve all playlists that the authenticated user owns, or you can retrieve one or more playlists by their unique IDs.
  ## 
  let valid = call_589906.validator(path, query, header, formData, body)
  let scheme = call_589906.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589906.url(scheme.get, call_589906.host, call_589906.base,
                         call_589906.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589906, url, valid)

proc call*(call_589907: Call_YoutubePlaylistsList_589887; part: string;
          onBehalfOfContentOwner: string = ""; mine: bool = false; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; id: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 5; channelId: string = ""; key: string = "";
          prettyPrint: bool = true; onBehalfOfContentOwnerChannel: string = "";
          hl: string = ""): Recallable =
  ## youtubePlaylistsList
  ## Returns a collection of playlists that match the API request parameters. For example, you can retrieve all playlists that the authenticated user owns, or you can retrieve one or more playlists by their unique IDs.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: bool
  ##       : Set this parameter's value to true to instruct the API to only return playlists owned by the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of the YouTube playlist ID(s) for the resource(s) that are being retrieved. In a playlist resource, the id property specifies the playlist's YouTube playlist ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more playlist resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a playlist resource, the snippet property contains properties like author, title, description, tags, and timeCreated. As such, if you set part=snippet, the API response will contain all of those properties.
  ##   channelId: string
  ##            : This value indicates that the API should only return the specified channel's playlists.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   hl: string
  ##     : The hl parameter should be used for filter out the properties that are not in the given language. Used for the snippet part.
  var query_589908 = newJObject()
  add(query_589908, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589908, "mine", newJBool(mine))
  add(query_589908, "fields", newJString(fields))
  add(query_589908, "pageToken", newJString(pageToken))
  add(query_589908, "quotaUser", newJString(quotaUser))
  add(query_589908, "id", newJString(id))
  add(query_589908, "alt", newJString(alt))
  add(query_589908, "oauth_token", newJString(oauthToken))
  add(query_589908, "userIp", newJString(userIp))
  add(query_589908, "maxResults", newJInt(maxResults))
  add(query_589908, "part", newJString(part))
  add(query_589908, "channelId", newJString(channelId))
  add(query_589908, "key", newJString(key))
  add(query_589908, "prettyPrint", newJBool(prettyPrint))
  add(query_589908, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  add(query_589908, "hl", newJString(hl))
  result = call_589907.call(nil, query_589908, nil, nil, nil)

var youtubePlaylistsList* = Call_YoutubePlaylistsList_589887(
    name: "youtubePlaylistsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/playlists",
    validator: validate_YoutubePlaylistsList_589888, base: "/youtube/v3",
    url: url_YoutubePlaylistsList_589889, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistsDelete_589944 = ref object of OpenApiRestCall_588466
proc url_YoutubePlaylistsDelete_589946(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubePlaylistsDelete_589945(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a playlist.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube playlist ID for the playlist that is being deleted. In a playlist resource, the id property specifies the playlist's ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589947 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589947 = validateParameter(valid_589947, JString, required = false,
                                 default = nil)
  if valid_589947 != nil:
    section.add "onBehalfOfContentOwner", valid_589947
  var valid_589948 = query.getOrDefault("fields")
  valid_589948 = validateParameter(valid_589948, JString, required = false,
                                 default = nil)
  if valid_589948 != nil:
    section.add "fields", valid_589948
  var valid_589949 = query.getOrDefault("quotaUser")
  valid_589949 = validateParameter(valid_589949, JString, required = false,
                                 default = nil)
  if valid_589949 != nil:
    section.add "quotaUser", valid_589949
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_589950 = query.getOrDefault("id")
  valid_589950 = validateParameter(valid_589950, JString, required = true,
                                 default = nil)
  if valid_589950 != nil:
    section.add "id", valid_589950
  var valid_589951 = query.getOrDefault("alt")
  valid_589951 = validateParameter(valid_589951, JString, required = false,
                                 default = newJString("json"))
  if valid_589951 != nil:
    section.add "alt", valid_589951
  var valid_589952 = query.getOrDefault("oauth_token")
  valid_589952 = validateParameter(valid_589952, JString, required = false,
                                 default = nil)
  if valid_589952 != nil:
    section.add "oauth_token", valid_589952
  var valid_589953 = query.getOrDefault("userIp")
  valid_589953 = validateParameter(valid_589953, JString, required = false,
                                 default = nil)
  if valid_589953 != nil:
    section.add "userIp", valid_589953
  var valid_589954 = query.getOrDefault("key")
  valid_589954 = validateParameter(valid_589954, JString, required = false,
                                 default = nil)
  if valid_589954 != nil:
    section.add "key", valid_589954
  var valid_589955 = query.getOrDefault("prettyPrint")
  valid_589955 = validateParameter(valid_589955, JBool, required = false,
                                 default = newJBool(true))
  if valid_589955 != nil:
    section.add "prettyPrint", valid_589955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589956: Call_YoutubePlaylistsDelete_589944; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a playlist.
  ## 
  let valid = call_589956.validator(path, query, header, formData, body)
  let scheme = call_589956.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589956.url(scheme.get, call_589956.host, call_589956.base,
                         call_589956.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589956, url, valid)

proc call*(call_589957: Call_YoutubePlaylistsDelete_589944; id: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubePlaylistsDelete
  ## Deletes a playlist.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube playlist ID for the playlist that is being deleted. In a playlist resource, the id property specifies the playlist's ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589958 = newJObject()
  add(query_589958, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_589958, "fields", newJString(fields))
  add(query_589958, "quotaUser", newJString(quotaUser))
  add(query_589958, "id", newJString(id))
  add(query_589958, "alt", newJString(alt))
  add(query_589958, "oauth_token", newJString(oauthToken))
  add(query_589958, "userIp", newJString(userIp))
  add(query_589958, "key", newJString(key))
  add(query_589958, "prettyPrint", newJBool(prettyPrint))
  result = call_589957.call(nil, query_589958, nil, nil, nil)

var youtubePlaylistsDelete* = Call_YoutubePlaylistsDelete_589944(
    name: "youtubePlaylistsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/playlists",
    validator: validate_YoutubePlaylistsDelete_589945, base: "/youtube/v3",
    url: url_YoutubePlaylistsDelete_589946, schemes: {Scheme.Https})
type
  Call_YoutubeSearchList_589959 = ref object of OpenApiRestCall_588466
proc url_YoutubeSearchList_589961(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeSearchList_589960(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns a collection of search results that match the query parameters specified in the API request. By default, a search result set identifies matching video, channel, and playlist resources, but you can also configure queries to only retrieve a specific type of resource.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   safeSearch: JString
  ##             : The safeSearch parameter indicates whether the search results should include restricted content as well as standard content.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   publishedAfter: JString
  ##                 : The publishedAfter parameter indicates that the API response should only contain resources created after the specified time. The value is an RFC 3339 formatted date-time value (1970-01-01T00:00:00Z).
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   relevanceLanguage: JString
  ##                    : The relevanceLanguage parameter instructs the API to return search results that are most relevant to the specified language. The parameter value is typically an ISO 639-1 two-letter language code. However, you should use the values zh-Hans for simplified Chinese and zh-Hant for traditional Chinese. Please note that results in other languages will still be returned if they are highly relevant to the search query term.
  ##   alt: JString
  ##      : Data format for the response.
  ##   forContentOwner: JBool
  ##                  : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The forContentOwner parameter restricts the search to only retrieve resources owned by the content owner specified by the onBehalfOfContentOwner parameter. The user must be authenticated using a CMS account linked to the specified content owner and onBehalfOfContentOwner must be provided.
  ##   forMine: JBool
  ##          : The forMine parameter restricts the search to only retrieve videos owned by the authenticated user. If you set this parameter to true, then the type parameter's value must also be set to video.
  ##   videoCaption: JString
  ##               : The videoCaption parameter indicates whether the API should filter video search results based on whether they have captions. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   videoDefinition: JString
  ##                  : The videoDefinition parameter lets you restrict a search to only include either high definition (HD) or standard definition (SD) videos. HD videos are available for playback in at least 720p, though higher resolutions, like 1080p, might also be available. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   topicId: JString
  ##          : The topicId parameter indicates that the API response should only contain resources associated with the specified topic. The value identifies a Freebase topic ID.
  ##   type: JString
  ##       : The type parameter restricts a search query to only retrieve a particular type of resource. The value is a comma-separated list of resource types.
  ##   order: JString
  ##        : The order parameter specifies the method that will be used to order resources in the API response.
  ##   videoDuration: JString
  ##                : The videoDuration parameter filters video search results based on their duration. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   locationRadius: JString
  ##                 : The locationRadius parameter, in conjunction with the location parameter, defines a circular geographic area.
  ## 
  ## The parameter value must be a floating point number followed by a measurement unit. Valid measurement units are m, km, ft, and mi. For example, valid parameter values include 1500m, 5km, 10000ft, and 0.75mi. The API does not support locationRadius parameter values larger than 1000 kilometers.
  ## 
  ## Note: See the definition of the location parameter for more information.
  ##   forDeveloper: JBool
  ##               : The forDeveloper parameter restricts the search to only retrieve videos uploaded via the developer's application or website. The API server uses the request's authorization credentials to identify the developer. Therefore, a developer can restrict results to videos uploaded through the developer's own app or website but not to videos uploaded through other apps or sites.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   videoType: JString
  ##            : The videoType parameter lets you restrict a search to a particular type of videos. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   eventType: JString
  ##            : The eventType parameter restricts a search to broadcast events. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   location: JString
  ##           : The location parameter, in conjunction with the locationRadius parameter, defines a circular geographic area and also restricts a search to videos that specify, in their metadata, a geographic location that falls within that area. The parameter value is a string that specifies latitude/longitude coordinates e.g. (37.42307,-122.08427).
  ## 
  ## 
  ## - The location parameter value identifies the point at the center of the area.
  ## - The locationRadius parameter specifies the maximum distance that the location associated with a video can be from that point for the video to still be included in the search results.The API returns an error if your request specifies a value for the location parameter but does not also specify a value for the locationRadius parameter.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more search resource properties that the API response will include. Set the parameter value to snippet.
  ##   q: JString
  ##    : The q parameter specifies the query term to search for.
  ## 
  ## Your request can also use the Boolean NOT (-) and OR (|) operators to exclude videos or to find videos that are associated with one of several search terms. For example, to search for videos matching either "boating" or "sailing", set the q parameter value to boating|sailing. Similarly, to search for videos matching either "boating" or "sailing" but not "fishing", set the q parameter value to boating|sailing -fishing. Note that the pipe character must be URL-escaped when it is sent in your API request. The URL-escaped value for the pipe character is %7C.
  ##   channelId: JString
  ##            : The channelId parameter indicates that the API response should only contain resources created by the channel
  ##   regionCode: JString
  ##             : The regionCode parameter instructs the API to return search results for the specified country. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   relatedToVideoId: JString
  ##                   : The relatedToVideoId parameter retrieves a list of videos that are related to the video that the parameter value identifies. The parameter value must be set to a YouTube video ID and, if you are using this parameter, the type parameter must be set to video.
  ##   videoDimension: JString
  ##                 : The videoDimension parameter lets you restrict a search to only retrieve 2D or 3D videos. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   videoLicense: JString
  ##               : The videoLicense parameter filters search results to only include videos with a particular license. YouTube lets video uploaders choose to attach either the Creative Commons license or the standard YouTube license to each of their videos. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   videoSyndicated: JString
  ##                  : The videoSyndicated parameter lets you to restrict a search to only videos that can be played outside youtube.com. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   publishedBefore: JString
  ##                  : The publishedBefore parameter indicates that the API response should only contain resources created before the specified time. The value is an RFC 3339 formatted date-time value (1970-01-01T00:00:00Z).
  ##   channelType: JString
  ##              : The channelType parameter lets you restrict a search to a particular type of channel.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   videoEmbeddable: JString
  ##                  : The videoEmbeddable parameter lets you to restrict a search to only videos that can be embedded into a webpage. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   videoCategoryId: JString
  ##                  : The videoCategoryId parameter filters video search results based on their category. If you specify a value for this parameter, you must also set the type parameter's value to video.
  section = newJObject()
  var valid_589962 = query.getOrDefault("onBehalfOfContentOwner")
  valid_589962 = validateParameter(valid_589962, JString, required = false,
                                 default = nil)
  if valid_589962 != nil:
    section.add "onBehalfOfContentOwner", valid_589962
  var valid_589963 = query.getOrDefault("safeSearch")
  valid_589963 = validateParameter(valid_589963, JString, required = false,
                                 default = newJString("moderate"))
  if valid_589963 != nil:
    section.add "safeSearch", valid_589963
  var valid_589964 = query.getOrDefault("fields")
  valid_589964 = validateParameter(valid_589964, JString, required = false,
                                 default = nil)
  if valid_589964 != nil:
    section.add "fields", valid_589964
  var valid_589965 = query.getOrDefault("publishedAfter")
  valid_589965 = validateParameter(valid_589965, JString, required = false,
                                 default = nil)
  if valid_589965 != nil:
    section.add "publishedAfter", valid_589965
  var valid_589966 = query.getOrDefault("quotaUser")
  valid_589966 = validateParameter(valid_589966, JString, required = false,
                                 default = nil)
  if valid_589966 != nil:
    section.add "quotaUser", valid_589966
  var valid_589967 = query.getOrDefault("pageToken")
  valid_589967 = validateParameter(valid_589967, JString, required = false,
                                 default = nil)
  if valid_589967 != nil:
    section.add "pageToken", valid_589967
  var valid_589968 = query.getOrDefault("relevanceLanguage")
  valid_589968 = validateParameter(valid_589968, JString, required = false,
                                 default = nil)
  if valid_589968 != nil:
    section.add "relevanceLanguage", valid_589968
  var valid_589969 = query.getOrDefault("alt")
  valid_589969 = validateParameter(valid_589969, JString, required = false,
                                 default = newJString("json"))
  if valid_589969 != nil:
    section.add "alt", valid_589969
  var valid_589970 = query.getOrDefault("forContentOwner")
  valid_589970 = validateParameter(valid_589970, JBool, required = false, default = nil)
  if valid_589970 != nil:
    section.add "forContentOwner", valid_589970
  var valid_589971 = query.getOrDefault("forMine")
  valid_589971 = validateParameter(valid_589971, JBool, required = false, default = nil)
  if valid_589971 != nil:
    section.add "forMine", valid_589971
  var valid_589972 = query.getOrDefault("videoCaption")
  valid_589972 = validateParameter(valid_589972, JString, required = false,
                                 default = newJString("any"))
  if valid_589972 != nil:
    section.add "videoCaption", valid_589972
  var valid_589973 = query.getOrDefault("videoDefinition")
  valid_589973 = validateParameter(valid_589973, JString, required = false,
                                 default = newJString("any"))
  if valid_589973 != nil:
    section.add "videoDefinition", valid_589973
  var valid_589974 = query.getOrDefault("topicId")
  valid_589974 = validateParameter(valid_589974, JString, required = false,
                                 default = nil)
  if valid_589974 != nil:
    section.add "topicId", valid_589974
  var valid_589975 = query.getOrDefault("type")
  valid_589975 = validateParameter(valid_589975, JString, required = false,
                                 default = newJString("video,channel,playlist"))
  if valid_589975 != nil:
    section.add "type", valid_589975
  var valid_589976 = query.getOrDefault("order")
  valid_589976 = validateParameter(valid_589976, JString, required = false,
                                 default = newJString("relevance"))
  if valid_589976 != nil:
    section.add "order", valid_589976
  var valid_589977 = query.getOrDefault("videoDuration")
  valid_589977 = validateParameter(valid_589977, JString, required = false,
                                 default = newJString("any"))
  if valid_589977 != nil:
    section.add "videoDuration", valid_589977
  var valid_589978 = query.getOrDefault("oauth_token")
  valid_589978 = validateParameter(valid_589978, JString, required = false,
                                 default = nil)
  if valid_589978 != nil:
    section.add "oauth_token", valid_589978
  var valid_589979 = query.getOrDefault("locationRadius")
  valid_589979 = validateParameter(valid_589979, JString, required = false,
                                 default = nil)
  if valid_589979 != nil:
    section.add "locationRadius", valid_589979
  var valid_589980 = query.getOrDefault("forDeveloper")
  valid_589980 = validateParameter(valid_589980, JBool, required = false, default = nil)
  if valid_589980 != nil:
    section.add "forDeveloper", valid_589980
  var valid_589981 = query.getOrDefault("userIp")
  valid_589981 = validateParameter(valid_589981, JString, required = false,
                                 default = nil)
  if valid_589981 != nil:
    section.add "userIp", valid_589981
  var valid_589982 = query.getOrDefault("videoType")
  valid_589982 = validateParameter(valid_589982, JString, required = false,
                                 default = newJString("any"))
  if valid_589982 != nil:
    section.add "videoType", valid_589982
  var valid_589983 = query.getOrDefault("eventType")
  valid_589983 = validateParameter(valid_589983, JString, required = false,
                                 default = newJString("completed"))
  if valid_589983 != nil:
    section.add "eventType", valid_589983
  var valid_589984 = query.getOrDefault("location")
  valid_589984 = validateParameter(valid_589984, JString, required = false,
                                 default = nil)
  if valid_589984 != nil:
    section.add "location", valid_589984
  var valid_589985 = query.getOrDefault("maxResults")
  valid_589985 = validateParameter(valid_589985, JInt, required = false,
                                 default = newJInt(5))
  if valid_589985 != nil:
    section.add "maxResults", valid_589985
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_589986 = query.getOrDefault("part")
  valid_589986 = validateParameter(valid_589986, JString, required = true,
                                 default = nil)
  if valid_589986 != nil:
    section.add "part", valid_589986
  var valid_589987 = query.getOrDefault("q")
  valid_589987 = validateParameter(valid_589987, JString, required = false,
                                 default = nil)
  if valid_589987 != nil:
    section.add "q", valid_589987
  var valid_589988 = query.getOrDefault("channelId")
  valid_589988 = validateParameter(valid_589988, JString, required = false,
                                 default = nil)
  if valid_589988 != nil:
    section.add "channelId", valid_589988
  var valid_589989 = query.getOrDefault("regionCode")
  valid_589989 = validateParameter(valid_589989, JString, required = false,
                                 default = nil)
  if valid_589989 != nil:
    section.add "regionCode", valid_589989
  var valid_589990 = query.getOrDefault("key")
  valid_589990 = validateParameter(valid_589990, JString, required = false,
                                 default = nil)
  if valid_589990 != nil:
    section.add "key", valid_589990
  var valid_589991 = query.getOrDefault("relatedToVideoId")
  valid_589991 = validateParameter(valid_589991, JString, required = false,
                                 default = nil)
  if valid_589991 != nil:
    section.add "relatedToVideoId", valid_589991
  var valid_589992 = query.getOrDefault("videoDimension")
  valid_589992 = validateParameter(valid_589992, JString, required = false,
                                 default = newJString("2d"))
  if valid_589992 != nil:
    section.add "videoDimension", valid_589992
  var valid_589993 = query.getOrDefault("videoLicense")
  valid_589993 = validateParameter(valid_589993, JString, required = false,
                                 default = newJString("any"))
  if valid_589993 != nil:
    section.add "videoLicense", valid_589993
  var valid_589994 = query.getOrDefault("videoSyndicated")
  valid_589994 = validateParameter(valid_589994, JString, required = false,
                                 default = newJString("any"))
  if valid_589994 != nil:
    section.add "videoSyndicated", valid_589994
  var valid_589995 = query.getOrDefault("publishedBefore")
  valid_589995 = validateParameter(valid_589995, JString, required = false,
                                 default = nil)
  if valid_589995 != nil:
    section.add "publishedBefore", valid_589995
  var valid_589996 = query.getOrDefault("channelType")
  valid_589996 = validateParameter(valid_589996, JString, required = false,
                                 default = newJString("any"))
  if valid_589996 != nil:
    section.add "channelType", valid_589996
  var valid_589997 = query.getOrDefault("prettyPrint")
  valid_589997 = validateParameter(valid_589997, JBool, required = false,
                                 default = newJBool(true))
  if valid_589997 != nil:
    section.add "prettyPrint", valid_589997
  var valid_589998 = query.getOrDefault("videoEmbeddable")
  valid_589998 = validateParameter(valid_589998, JString, required = false,
                                 default = newJString("any"))
  if valid_589998 != nil:
    section.add "videoEmbeddable", valid_589998
  var valid_589999 = query.getOrDefault("videoCategoryId")
  valid_589999 = validateParameter(valid_589999, JString, required = false,
                                 default = nil)
  if valid_589999 != nil:
    section.add "videoCategoryId", valid_589999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590000: Call_YoutubeSearchList_589959; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of search results that match the query parameters specified in the API request. By default, a search result set identifies matching video, channel, and playlist resources, but you can also configure queries to only retrieve a specific type of resource.
  ## 
  let valid = call_590000.validator(path, query, header, formData, body)
  let scheme = call_590000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590000.url(scheme.get, call_590000.host, call_590000.base,
                         call_590000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590000, url, valid)

proc call*(call_590001: Call_YoutubeSearchList_589959; part: string;
          onBehalfOfContentOwner: string = ""; safeSearch: string = "moderate";
          fields: string = ""; publishedAfter: string = ""; quotaUser: string = "";
          pageToken: string = ""; relevanceLanguage: string = ""; alt: string = "json";
          forContentOwner: bool = false; forMine: bool = false;
          videoCaption: string = "any"; videoDefinition: string = "any";
          topicId: string = ""; `type`: string = "video,channel,playlist";
          order: string = "relevance"; videoDuration: string = "any";
          oauthToken: string = ""; locationRadius: string = "";
          forDeveloper: bool = false; userIp: string = ""; videoType: string = "any";
          eventType: string = "completed"; location: string = ""; maxResults: int = 5;
          q: string = ""; channelId: string = ""; regionCode: string = ""; key: string = "";
          relatedToVideoId: string = ""; videoDimension: string = "2d";
          videoLicense: string = "any"; videoSyndicated: string = "any";
          publishedBefore: string = ""; channelType: string = "any";
          prettyPrint: bool = true; videoEmbeddable: string = "any";
          videoCategoryId: string = ""): Recallable =
  ## youtubeSearchList
  ## Returns a collection of search results that match the query parameters specified in the API request. By default, a search result set identifies matching video, channel, and playlist resources, but you can also configure queries to only retrieve a specific type of resource.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   safeSearch: string
  ##             : The safeSearch parameter indicates whether the search results should include restricted content as well as standard content.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   publishedAfter: string
  ##                 : The publishedAfter parameter indicates that the API response should only contain resources created after the specified time. The value is an RFC 3339 formatted date-time value (1970-01-01T00:00:00Z).
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   relevanceLanguage: string
  ##                    : The relevanceLanguage parameter instructs the API to return search results that are most relevant to the specified language. The parameter value is typically an ISO 639-1 two-letter language code. However, you should use the values zh-Hans for simplified Chinese and zh-Hant for traditional Chinese. Please note that results in other languages will still be returned if they are highly relevant to the search query term.
  ##   alt: string
  ##      : Data format for the response.
  ##   forContentOwner: bool
  ##                  : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The forContentOwner parameter restricts the search to only retrieve resources owned by the content owner specified by the onBehalfOfContentOwner parameter. The user must be authenticated using a CMS account linked to the specified content owner and onBehalfOfContentOwner must be provided.
  ##   forMine: bool
  ##          : The forMine parameter restricts the search to only retrieve videos owned by the authenticated user. If you set this parameter to true, then the type parameter's value must also be set to video.
  ##   videoCaption: string
  ##               : The videoCaption parameter indicates whether the API should filter video search results based on whether they have captions. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   videoDefinition: string
  ##                  : The videoDefinition parameter lets you restrict a search to only include either high definition (HD) or standard definition (SD) videos. HD videos are available for playback in at least 720p, though higher resolutions, like 1080p, might also be available. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   topicId: string
  ##          : The topicId parameter indicates that the API response should only contain resources associated with the specified topic. The value identifies a Freebase topic ID.
  ##   type: string
  ##       : The type parameter restricts a search query to only retrieve a particular type of resource. The value is a comma-separated list of resource types.
  ##   order: string
  ##        : The order parameter specifies the method that will be used to order resources in the API response.
  ##   videoDuration: string
  ##                : The videoDuration parameter filters video search results based on their duration. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   locationRadius: string
  ##                 : The locationRadius parameter, in conjunction with the location parameter, defines a circular geographic area.
  ## 
  ## The parameter value must be a floating point number followed by a measurement unit. Valid measurement units are m, km, ft, and mi. For example, valid parameter values include 1500m, 5km, 10000ft, and 0.75mi. The API does not support locationRadius parameter values larger than 1000 kilometers.
  ## 
  ## Note: See the definition of the location parameter for more information.
  ##   forDeveloper: bool
  ##               : The forDeveloper parameter restricts the search to only retrieve videos uploaded via the developer's application or website. The API server uses the request's authorization credentials to identify the developer. Therefore, a developer can restrict results to videos uploaded through the developer's own app or website but not to videos uploaded through other apps or sites.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   videoType: string
  ##            : The videoType parameter lets you restrict a search to a particular type of videos. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   eventType: string
  ##            : The eventType parameter restricts a search to broadcast events. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   location: string
  ##           : The location parameter, in conjunction with the locationRadius parameter, defines a circular geographic area and also restricts a search to videos that specify, in their metadata, a geographic location that falls within that area. The parameter value is a string that specifies latitude/longitude coordinates e.g. (37.42307,-122.08427).
  ## 
  ## 
  ## - The location parameter value identifies the point at the center of the area.
  ## - The locationRadius parameter specifies the maximum distance that the location associated with a video can be from that point for the video to still be included in the search results.The API returns an error if your request specifies a value for the location parameter but does not also specify a value for the locationRadius parameter.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more search resource properties that the API response will include. Set the parameter value to snippet.
  ##   q: string
  ##    : The q parameter specifies the query term to search for.
  ## 
  ## Your request can also use the Boolean NOT (-) and OR (|) operators to exclude videos or to find videos that are associated with one of several search terms. For example, to search for videos matching either "boating" or "sailing", set the q parameter value to boating|sailing. Similarly, to search for videos matching either "boating" or "sailing" but not "fishing", set the q parameter value to boating|sailing -fishing. Note that the pipe character must be URL-escaped when it is sent in your API request. The URL-escaped value for the pipe character is %7C.
  ##   channelId: string
  ##            : The channelId parameter indicates that the API response should only contain resources created by the channel
  ##   regionCode: string
  ##             : The regionCode parameter instructs the API to return search results for the specified country. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   relatedToVideoId: string
  ##                   : The relatedToVideoId parameter retrieves a list of videos that are related to the video that the parameter value identifies. The parameter value must be set to a YouTube video ID and, if you are using this parameter, the type parameter must be set to video.
  ##   videoDimension: string
  ##                 : The videoDimension parameter lets you restrict a search to only retrieve 2D or 3D videos. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   videoLicense: string
  ##               : The videoLicense parameter filters search results to only include videos with a particular license. YouTube lets video uploaders choose to attach either the Creative Commons license or the standard YouTube license to each of their videos. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   videoSyndicated: string
  ##                  : The videoSyndicated parameter lets you to restrict a search to only videos that can be played outside youtube.com. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   publishedBefore: string
  ##                  : The publishedBefore parameter indicates that the API response should only contain resources created before the specified time. The value is an RFC 3339 formatted date-time value (1970-01-01T00:00:00Z).
  ##   channelType: string
  ##              : The channelType parameter lets you restrict a search to a particular type of channel.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   videoEmbeddable: string
  ##                  : The videoEmbeddable parameter lets you to restrict a search to only videos that can be embedded into a webpage. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   videoCategoryId: string
  ##                  : The videoCategoryId parameter filters video search results based on their category. If you specify a value for this parameter, you must also set the type parameter's value to video.
  var query_590002 = newJObject()
  add(query_590002, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_590002, "safeSearch", newJString(safeSearch))
  add(query_590002, "fields", newJString(fields))
  add(query_590002, "publishedAfter", newJString(publishedAfter))
  add(query_590002, "quotaUser", newJString(quotaUser))
  add(query_590002, "pageToken", newJString(pageToken))
  add(query_590002, "relevanceLanguage", newJString(relevanceLanguage))
  add(query_590002, "alt", newJString(alt))
  add(query_590002, "forContentOwner", newJBool(forContentOwner))
  add(query_590002, "forMine", newJBool(forMine))
  add(query_590002, "videoCaption", newJString(videoCaption))
  add(query_590002, "videoDefinition", newJString(videoDefinition))
  add(query_590002, "topicId", newJString(topicId))
  add(query_590002, "type", newJString(`type`))
  add(query_590002, "order", newJString(order))
  add(query_590002, "videoDuration", newJString(videoDuration))
  add(query_590002, "oauth_token", newJString(oauthToken))
  add(query_590002, "locationRadius", newJString(locationRadius))
  add(query_590002, "forDeveloper", newJBool(forDeveloper))
  add(query_590002, "userIp", newJString(userIp))
  add(query_590002, "videoType", newJString(videoType))
  add(query_590002, "eventType", newJString(eventType))
  add(query_590002, "location", newJString(location))
  add(query_590002, "maxResults", newJInt(maxResults))
  add(query_590002, "part", newJString(part))
  add(query_590002, "q", newJString(q))
  add(query_590002, "channelId", newJString(channelId))
  add(query_590002, "regionCode", newJString(regionCode))
  add(query_590002, "key", newJString(key))
  add(query_590002, "relatedToVideoId", newJString(relatedToVideoId))
  add(query_590002, "videoDimension", newJString(videoDimension))
  add(query_590002, "videoLicense", newJString(videoLicense))
  add(query_590002, "videoSyndicated", newJString(videoSyndicated))
  add(query_590002, "publishedBefore", newJString(publishedBefore))
  add(query_590002, "channelType", newJString(channelType))
  add(query_590002, "prettyPrint", newJBool(prettyPrint))
  add(query_590002, "videoEmbeddable", newJString(videoEmbeddable))
  add(query_590002, "videoCategoryId", newJString(videoCategoryId))
  result = call_590001.call(nil, query_590002, nil, nil, nil)

var youtubeSearchList* = Call_YoutubeSearchList_589959(name: "youtubeSearchList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/search",
    validator: validate_YoutubeSearchList_589960, base: "/youtube/v3",
    url: url_YoutubeSearchList_589961, schemes: {Scheme.Https})
type
  Call_YoutubeSponsorsList_590003 = ref object of OpenApiRestCall_588466
proc url_YoutubeSponsorsList_590005(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeSponsorsList_590004(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lists sponsors for a channel.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies the sponsor resource parts that the API response will include. Supported values are id and snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The filter parameter specifies which channel sponsors to return.
  section = newJObject()
  var valid_590006 = query.getOrDefault("fields")
  valid_590006 = validateParameter(valid_590006, JString, required = false,
                                 default = nil)
  if valid_590006 != nil:
    section.add "fields", valid_590006
  var valid_590007 = query.getOrDefault("pageToken")
  valid_590007 = validateParameter(valid_590007, JString, required = false,
                                 default = nil)
  if valid_590007 != nil:
    section.add "pageToken", valid_590007
  var valid_590008 = query.getOrDefault("quotaUser")
  valid_590008 = validateParameter(valid_590008, JString, required = false,
                                 default = nil)
  if valid_590008 != nil:
    section.add "quotaUser", valid_590008
  var valid_590009 = query.getOrDefault("alt")
  valid_590009 = validateParameter(valid_590009, JString, required = false,
                                 default = newJString("json"))
  if valid_590009 != nil:
    section.add "alt", valid_590009
  var valid_590010 = query.getOrDefault("oauth_token")
  valid_590010 = validateParameter(valid_590010, JString, required = false,
                                 default = nil)
  if valid_590010 != nil:
    section.add "oauth_token", valid_590010
  var valid_590011 = query.getOrDefault("userIp")
  valid_590011 = validateParameter(valid_590011, JString, required = false,
                                 default = nil)
  if valid_590011 != nil:
    section.add "userIp", valid_590011
  var valid_590012 = query.getOrDefault("maxResults")
  valid_590012 = validateParameter(valid_590012, JInt, required = false,
                                 default = newJInt(5))
  if valid_590012 != nil:
    section.add "maxResults", valid_590012
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_590013 = query.getOrDefault("part")
  valid_590013 = validateParameter(valid_590013, JString, required = true,
                                 default = nil)
  if valid_590013 != nil:
    section.add "part", valid_590013
  var valid_590014 = query.getOrDefault("key")
  valid_590014 = validateParameter(valid_590014, JString, required = false,
                                 default = nil)
  if valid_590014 != nil:
    section.add "key", valid_590014
  var valid_590015 = query.getOrDefault("prettyPrint")
  valid_590015 = validateParameter(valid_590015, JBool, required = false,
                                 default = newJBool(true))
  if valid_590015 != nil:
    section.add "prettyPrint", valid_590015
  var valid_590016 = query.getOrDefault("filter")
  valid_590016 = validateParameter(valid_590016, JString, required = false,
                                 default = newJString("newest"))
  if valid_590016 != nil:
    section.add "filter", valid_590016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590017: Call_YoutubeSponsorsList_590003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists sponsors for a channel.
  ## 
  let valid = call_590017.validator(path, query, header, formData, body)
  let scheme = call_590017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590017.url(scheme.get, call_590017.host, call_590017.base,
                         call_590017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590017, url, valid)

proc call*(call_590018: Call_YoutubeSponsorsList_590003; part: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 5; key: string = ""; prettyPrint: bool = true;
          filter: string = "newest"): Recallable =
  ## youtubeSponsorsList
  ## Lists sponsors for a channel.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies the sponsor resource parts that the API response will include. Supported values are id and snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The filter parameter specifies which channel sponsors to return.
  var query_590019 = newJObject()
  add(query_590019, "fields", newJString(fields))
  add(query_590019, "pageToken", newJString(pageToken))
  add(query_590019, "quotaUser", newJString(quotaUser))
  add(query_590019, "alt", newJString(alt))
  add(query_590019, "oauth_token", newJString(oauthToken))
  add(query_590019, "userIp", newJString(userIp))
  add(query_590019, "maxResults", newJInt(maxResults))
  add(query_590019, "part", newJString(part))
  add(query_590019, "key", newJString(key))
  add(query_590019, "prettyPrint", newJBool(prettyPrint))
  add(query_590019, "filter", newJString(filter))
  result = call_590018.call(nil, query_590019, nil, nil, nil)

var youtubeSponsorsList* = Call_YoutubeSponsorsList_590003(
    name: "youtubeSponsorsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/sponsors",
    validator: validate_YoutubeSponsorsList_590004, base: "/youtube/v3",
    url: url_YoutubeSponsorsList_590005, schemes: {Scheme.Https})
type
  Call_YoutubeSubscriptionsInsert_590045 = ref object of OpenApiRestCall_588466
proc url_YoutubeSubscriptionsInsert_590047(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeSubscriptionsInsert_590046(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a subscription for the authenticated user's channel.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590048 = query.getOrDefault("fields")
  valid_590048 = validateParameter(valid_590048, JString, required = false,
                                 default = nil)
  if valid_590048 != nil:
    section.add "fields", valid_590048
  var valid_590049 = query.getOrDefault("quotaUser")
  valid_590049 = validateParameter(valid_590049, JString, required = false,
                                 default = nil)
  if valid_590049 != nil:
    section.add "quotaUser", valid_590049
  var valid_590050 = query.getOrDefault("alt")
  valid_590050 = validateParameter(valid_590050, JString, required = false,
                                 default = newJString("json"))
  if valid_590050 != nil:
    section.add "alt", valid_590050
  var valid_590051 = query.getOrDefault("oauth_token")
  valid_590051 = validateParameter(valid_590051, JString, required = false,
                                 default = nil)
  if valid_590051 != nil:
    section.add "oauth_token", valid_590051
  var valid_590052 = query.getOrDefault("userIp")
  valid_590052 = validateParameter(valid_590052, JString, required = false,
                                 default = nil)
  if valid_590052 != nil:
    section.add "userIp", valid_590052
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_590053 = query.getOrDefault("part")
  valid_590053 = validateParameter(valid_590053, JString, required = true,
                                 default = nil)
  if valid_590053 != nil:
    section.add "part", valid_590053
  var valid_590054 = query.getOrDefault("key")
  valid_590054 = validateParameter(valid_590054, JString, required = false,
                                 default = nil)
  if valid_590054 != nil:
    section.add "key", valid_590054
  var valid_590055 = query.getOrDefault("prettyPrint")
  valid_590055 = validateParameter(valid_590055, JBool, required = false,
                                 default = newJBool(true))
  if valid_590055 != nil:
    section.add "prettyPrint", valid_590055
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

proc call*(call_590057: Call_YoutubeSubscriptionsInsert_590045; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a subscription for the authenticated user's channel.
  ## 
  let valid = call_590057.validator(path, query, header, formData, body)
  let scheme = call_590057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590057.url(scheme.get, call_590057.host, call_590057.base,
                         call_590057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590057, url, valid)

proc call*(call_590058: Call_YoutubeSubscriptionsInsert_590045; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeSubscriptionsInsert
  ## Adds a subscription for the authenticated user's channel.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_590059 = newJObject()
  var body_590060 = newJObject()
  add(query_590059, "fields", newJString(fields))
  add(query_590059, "quotaUser", newJString(quotaUser))
  add(query_590059, "alt", newJString(alt))
  add(query_590059, "oauth_token", newJString(oauthToken))
  add(query_590059, "userIp", newJString(userIp))
  add(query_590059, "part", newJString(part))
  add(query_590059, "key", newJString(key))
  if body != nil:
    body_590060 = body
  add(query_590059, "prettyPrint", newJBool(prettyPrint))
  result = call_590058.call(nil, query_590059, nil, nil, body_590060)

var youtubeSubscriptionsInsert* = Call_YoutubeSubscriptionsInsert_590045(
    name: "youtubeSubscriptionsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/subscriptions",
    validator: validate_YoutubeSubscriptionsInsert_590046, base: "/youtube/v3",
    url: url_YoutubeSubscriptionsInsert_590047, schemes: {Scheme.Https})
type
  Call_YoutubeSubscriptionsList_590020 = ref object of OpenApiRestCall_588466
proc url_YoutubeSubscriptionsList_590022(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeSubscriptionsList_590021(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns subscription resources that match the API request criteria.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: JBool
  ##       : Set this parameter's value to true to retrieve a feed of the authenticated user's subscriptions.
  ##   forChannelId: JString
  ##               : The forChannelId parameter specifies a comma-separated list of channel IDs. The API response will then only contain subscriptions matching those channels.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of the YouTube subscription ID(s) for the resource(s) that are being retrieved. In a subscription resource, the id property specifies the YouTube subscription ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   mySubscribers: JBool
  ##                : Set this parameter's value to true to retrieve a feed of the subscribers of the authenticated user in no particular order.
  ##   order: JString
  ##        : The order parameter specifies the method that will be used to sort resources in the API response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more subscription resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a subscription resource, the snippet property contains other properties, such as a display title for the subscription. If you set part=snippet, the API response will also contain all of those nested properties.
  ##   channelId: JString
  ##            : The channelId parameter specifies a YouTube channel ID. The API will only return that channel's subscriptions.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   myRecentSubscribers: JBool
  ##                      : Set this parameter's value to true to retrieve a feed of the subscribers of the authenticated user in reverse chronological order (newest first).
  section = newJObject()
  var valid_590023 = query.getOrDefault("onBehalfOfContentOwner")
  valid_590023 = validateParameter(valid_590023, JString, required = false,
                                 default = nil)
  if valid_590023 != nil:
    section.add "onBehalfOfContentOwner", valid_590023
  var valid_590024 = query.getOrDefault("mine")
  valid_590024 = validateParameter(valid_590024, JBool, required = false, default = nil)
  if valid_590024 != nil:
    section.add "mine", valid_590024
  var valid_590025 = query.getOrDefault("forChannelId")
  valid_590025 = validateParameter(valid_590025, JString, required = false,
                                 default = nil)
  if valid_590025 != nil:
    section.add "forChannelId", valid_590025
  var valid_590026 = query.getOrDefault("fields")
  valid_590026 = validateParameter(valid_590026, JString, required = false,
                                 default = nil)
  if valid_590026 != nil:
    section.add "fields", valid_590026
  var valid_590027 = query.getOrDefault("pageToken")
  valid_590027 = validateParameter(valid_590027, JString, required = false,
                                 default = nil)
  if valid_590027 != nil:
    section.add "pageToken", valid_590027
  var valid_590028 = query.getOrDefault("quotaUser")
  valid_590028 = validateParameter(valid_590028, JString, required = false,
                                 default = nil)
  if valid_590028 != nil:
    section.add "quotaUser", valid_590028
  var valid_590029 = query.getOrDefault("id")
  valid_590029 = validateParameter(valid_590029, JString, required = false,
                                 default = nil)
  if valid_590029 != nil:
    section.add "id", valid_590029
  var valid_590030 = query.getOrDefault("alt")
  valid_590030 = validateParameter(valid_590030, JString, required = false,
                                 default = newJString("json"))
  if valid_590030 != nil:
    section.add "alt", valid_590030
  var valid_590031 = query.getOrDefault("mySubscribers")
  valid_590031 = validateParameter(valid_590031, JBool, required = false, default = nil)
  if valid_590031 != nil:
    section.add "mySubscribers", valid_590031
  var valid_590032 = query.getOrDefault("order")
  valid_590032 = validateParameter(valid_590032, JString, required = false,
                                 default = newJString("relevance"))
  if valid_590032 != nil:
    section.add "order", valid_590032
  var valid_590033 = query.getOrDefault("oauth_token")
  valid_590033 = validateParameter(valid_590033, JString, required = false,
                                 default = nil)
  if valid_590033 != nil:
    section.add "oauth_token", valid_590033
  var valid_590034 = query.getOrDefault("userIp")
  valid_590034 = validateParameter(valid_590034, JString, required = false,
                                 default = nil)
  if valid_590034 != nil:
    section.add "userIp", valid_590034
  var valid_590035 = query.getOrDefault("maxResults")
  valid_590035 = validateParameter(valid_590035, JInt, required = false,
                                 default = newJInt(5))
  if valid_590035 != nil:
    section.add "maxResults", valid_590035
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_590036 = query.getOrDefault("part")
  valid_590036 = validateParameter(valid_590036, JString, required = true,
                                 default = nil)
  if valid_590036 != nil:
    section.add "part", valid_590036
  var valid_590037 = query.getOrDefault("channelId")
  valid_590037 = validateParameter(valid_590037, JString, required = false,
                                 default = nil)
  if valid_590037 != nil:
    section.add "channelId", valid_590037
  var valid_590038 = query.getOrDefault("key")
  valid_590038 = validateParameter(valid_590038, JString, required = false,
                                 default = nil)
  if valid_590038 != nil:
    section.add "key", valid_590038
  var valid_590039 = query.getOrDefault("prettyPrint")
  valid_590039 = validateParameter(valid_590039, JBool, required = false,
                                 default = newJBool(true))
  if valid_590039 != nil:
    section.add "prettyPrint", valid_590039
  var valid_590040 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_590040 = validateParameter(valid_590040, JString, required = false,
                                 default = nil)
  if valid_590040 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_590040
  var valid_590041 = query.getOrDefault("myRecentSubscribers")
  valid_590041 = validateParameter(valid_590041, JBool, required = false, default = nil)
  if valid_590041 != nil:
    section.add "myRecentSubscribers", valid_590041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590042: Call_YoutubeSubscriptionsList_590020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns subscription resources that match the API request criteria.
  ## 
  let valid = call_590042.validator(path, query, header, formData, body)
  let scheme = call_590042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590042.url(scheme.get, call_590042.host, call_590042.base,
                         call_590042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590042, url, valid)

proc call*(call_590043: Call_YoutubeSubscriptionsList_590020; part: string;
          onBehalfOfContentOwner: string = ""; mine: bool = false;
          forChannelId: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; id: string = ""; alt: string = "json";
          mySubscribers: bool = false; order: string = "relevance";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 5;
          channelId: string = ""; key: string = ""; prettyPrint: bool = true;
          onBehalfOfContentOwnerChannel: string = "";
          myRecentSubscribers: bool = false): Recallable =
  ## youtubeSubscriptionsList
  ## Returns subscription resources that match the API request criteria.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: bool
  ##       : Set this parameter's value to true to retrieve a feed of the authenticated user's subscriptions.
  ##   forChannelId: string
  ##               : The forChannelId parameter specifies a comma-separated list of channel IDs. The API response will then only contain subscriptions matching those channels.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of the YouTube subscription ID(s) for the resource(s) that are being retrieved. In a subscription resource, the id property specifies the YouTube subscription ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   mySubscribers: bool
  ##                : Set this parameter's value to true to retrieve a feed of the subscribers of the authenticated user in no particular order.
  ##   order: string
  ##        : The order parameter specifies the method that will be used to sort resources in the API response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more subscription resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a subscription resource, the snippet property contains other properties, such as a display title for the subscription. If you set part=snippet, the API response will also contain all of those nested properties.
  ##   channelId: string
  ##            : The channelId parameter specifies a YouTube channel ID. The API will only return that channel's subscriptions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   myRecentSubscribers: bool
  ##                      : Set this parameter's value to true to retrieve a feed of the subscribers of the authenticated user in reverse chronological order (newest first).
  var query_590044 = newJObject()
  add(query_590044, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_590044, "mine", newJBool(mine))
  add(query_590044, "forChannelId", newJString(forChannelId))
  add(query_590044, "fields", newJString(fields))
  add(query_590044, "pageToken", newJString(pageToken))
  add(query_590044, "quotaUser", newJString(quotaUser))
  add(query_590044, "id", newJString(id))
  add(query_590044, "alt", newJString(alt))
  add(query_590044, "mySubscribers", newJBool(mySubscribers))
  add(query_590044, "order", newJString(order))
  add(query_590044, "oauth_token", newJString(oauthToken))
  add(query_590044, "userIp", newJString(userIp))
  add(query_590044, "maxResults", newJInt(maxResults))
  add(query_590044, "part", newJString(part))
  add(query_590044, "channelId", newJString(channelId))
  add(query_590044, "key", newJString(key))
  add(query_590044, "prettyPrint", newJBool(prettyPrint))
  add(query_590044, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  add(query_590044, "myRecentSubscribers", newJBool(myRecentSubscribers))
  result = call_590043.call(nil, query_590044, nil, nil, nil)

var youtubeSubscriptionsList* = Call_YoutubeSubscriptionsList_590020(
    name: "youtubeSubscriptionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/subscriptions",
    validator: validate_YoutubeSubscriptionsList_590021, base: "/youtube/v3",
    url: url_YoutubeSubscriptionsList_590022, schemes: {Scheme.Https})
type
  Call_YoutubeSubscriptionsDelete_590061 = ref object of OpenApiRestCall_588466
proc url_YoutubeSubscriptionsDelete_590063(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeSubscriptionsDelete_590062(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube subscription ID for the resource that is being deleted. In a subscription resource, the id property specifies the YouTube subscription ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590064 = query.getOrDefault("fields")
  valid_590064 = validateParameter(valid_590064, JString, required = false,
                                 default = nil)
  if valid_590064 != nil:
    section.add "fields", valid_590064
  var valid_590065 = query.getOrDefault("quotaUser")
  valid_590065 = validateParameter(valid_590065, JString, required = false,
                                 default = nil)
  if valid_590065 != nil:
    section.add "quotaUser", valid_590065
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_590066 = query.getOrDefault("id")
  valid_590066 = validateParameter(valid_590066, JString, required = true,
                                 default = nil)
  if valid_590066 != nil:
    section.add "id", valid_590066
  var valid_590067 = query.getOrDefault("alt")
  valid_590067 = validateParameter(valid_590067, JString, required = false,
                                 default = newJString("json"))
  if valid_590067 != nil:
    section.add "alt", valid_590067
  var valid_590068 = query.getOrDefault("oauth_token")
  valid_590068 = validateParameter(valid_590068, JString, required = false,
                                 default = nil)
  if valid_590068 != nil:
    section.add "oauth_token", valid_590068
  var valid_590069 = query.getOrDefault("userIp")
  valid_590069 = validateParameter(valid_590069, JString, required = false,
                                 default = nil)
  if valid_590069 != nil:
    section.add "userIp", valid_590069
  var valid_590070 = query.getOrDefault("key")
  valid_590070 = validateParameter(valid_590070, JString, required = false,
                                 default = nil)
  if valid_590070 != nil:
    section.add "key", valid_590070
  var valid_590071 = query.getOrDefault("prettyPrint")
  valid_590071 = validateParameter(valid_590071, JBool, required = false,
                                 default = newJBool(true))
  if valid_590071 != nil:
    section.add "prettyPrint", valid_590071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590072: Call_YoutubeSubscriptionsDelete_590061; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a subscription.
  ## 
  let valid = call_590072.validator(path, query, header, formData, body)
  let scheme = call_590072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590072.url(scheme.get, call_590072.host, call_590072.base,
                         call_590072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590072, url, valid)

proc call*(call_590073: Call_YoutubeSubscriptionsDelete_590061; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## youtubeSubscriptionsDelete
  ## Deletes a subscription.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube subscription ID for the resource that is being deleted. In a subscription resource, the id property specifies the YouTube subscription ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_590074 = newJObject()
  add(query_590074, "fields", newJString(fields))
  add(query_590074, "quotaUser", newJString(quotaUser))
  add(query_590074, "id", newJString(id))
  add(query_590074, "alt", newJString(alt))
  add(query_590074, "oauth_token", newJString(oauthToken))
  add(query_590074, "userIp", newJString(userIp))
  add(query_590074, "key", newJString(key))
  add(query_590074, "prettyPrint", newJBool(prettyPrint))
  result = call_590073.call(nil, query_590074, nil, nil, nil)

var youtubeSubscriptionsDelete* = Call_YoutubeSubscriptionsDelete_590061(
    name: "youtubeSubscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/subscriptions",
    validator: validate_YoutubeSubscriptionsDelete_590062, base: "/youtube/v3",
    url: url_YoutubeSubscriptionsDelete_590063, schemes: {Scheme.Https})
type
  Call_YoutubeSuperChatEventsList_590075 = ref object of OpenApiRestCall_588466
proc url_YoutubeSuperChatEventsList_590077(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeSuperChatEventsList_590076(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists Super Chat events for a channel.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies the superChatEvent resource parts that the API response will include. Supported values are id and snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   hl: JString
  ##     : The hl parameter instructs the API to retrieve localized resource metadata for a specific application language that the YouTube website supports. The parameter value must be a language code included in the list returned by the i18nLanguages.list method.
  ## 
  ## If localized resource details are available in that language, the resource's snippet.localized object will contain the localized values. However, if localized details are not available, the snippet.localized object will contain resource details in the resource's default language.
  section = newJObject()
  var valid_590078 = query.getOrDefault("fields")
  valid_590078 = validateParameter(valid_590078, JString, required = false,
                                 default = nil)
  if valid_590078 != nil:
    section.add "fields", valid_590078
  var valid_590079 = query.getOrDefault("pageToken")
  valid_590079 = validateParameter(valid_590079, JString, required = false,
                                 default = nil)
  if valid_590079 != nil:
    section.add "pageToken", valid_590079
  var valid_590080 = query.getOrDefault("quotaUser")
  valid_590080 = validateParameter(valid_590080, JString, required = false,
                                 default = nil)
  if valid_590080 != nil:
    section.add "quotaUser", valid_590080
  var valid_590081 = query.getOrDefault("alt")
  valid_590081 = validateParameter(valid_590081, JString, required = false,
                                 default = newJString("json"))
  if valid_590081 != nil:
    section.add "alt", valid_590081
  var valid_590082 = query.getOrDefault("oauth_token")
  valid_590082 = validateParameter(valid_590082, JString, required = false,
                                 default = nil)
  if valid_590082 != nil:
    section.add "oauth_token", valid_590082
  var valid_590083 = query.getOrDefault("userIp")
  valid_590083 = validateParameter(valid_590083, JString, required = false,
                                 default = nil)
  if valid_590083 != nil:
    section.add "userIp", valid_590083
  var valid_590084 = query.getOrDefault("maxResults")
  valid_590084 = validateParameter(valid_590084, JInt, required = false,
                                 default = newJInt(5))
  if valid_590084 != nil:
    section.add "maxResults", valid_590084
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_590085 = query.getOrDefault("part")
  valid_590085 = validateParameter(valid_590085, JString, required = true,
                                 default = nil)
  if valid_590085 != nil:
    section.add "part", valid_590085
  var valid_590086 = query.getOrDefault("key")
  valid_590086 = validateParameter(valid_590086, JString, required = false,
                                 default = nil)
  if valid_590086 != nil:
    section.add "key", valid_590086
  var valid_590087 = query.getOrDefault("prettyPrint")
  valid_590087 = validateParameter(valid_590087, JBool, required = false,
                                 default = newJBool(true))
  if valid_590087 != nil:
    section.add "prettyPrint", valid_590087
  var valid_590088 = query.getOrDefault("hl")
  valid_590088 = validateParameter(valid_590088, JString, required = false,
                                 default = nil)
  if valid_590088 != nil:
    section.add "hl", valid_590088
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590089: Call_YoutubeSuperChatEventsList_590075; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists Super Chat events for a channel.
  ## 
  let valid = call_590089.validator(path, query, header, formData, body)
  let scheme = call_590089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590089.url(scheme.get, call_590089.host, call_590089.base,
                         call_590089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590089, url, valid)

proc call*(call_590090: Call_YoutubeSuperChatEventsList_590075; part: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 5; key: string = ""; prettyPrint: bool = true; hl: string = ""): Recallable =
  ## youtubeSuperChatEventsList
  ## Lists Super Chat events for a channel.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies the superChatEvent resource parts that the API response will include. Supported values are id and snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   hl: string
  ##     : The hl parameter instructs the API to retrieve localized resource metadata for a specific application language that the YouTube website supports. The parameter value must be a language code included in the list returned by the i18nLanguages.list method.
  ## 
  ## If localized resource details are available in that language, the resource's snippet.localized object will contain the localized values. However, if localized details are not available, the snippet.localized object will contain resource details in the resource's default language.
  var query_590091 = newJObject()
  add(query_590091, "fields", newJString(fields))
  add(query_590091, "pageToken", newJString(pageToken))
  add(query_590091, "quotaUser", newJString(quotaUser))
  add(query_590091, "alt", newJString(alt))
  add(query_590091, "oauth_token", newJString(oauthToken))
  add(query_590091, "userIp", newJString(userIp))
  add(query_590091, "maxResults", newJInt(maxResults))
  add(query_590091, "part", newJString(part))
  add(query_590091, "key", newJString(key))
  add(query_590091, "prettyPrint", newJBool(prettyPrint))
  add(query_590091, "hl", newJString(hl))
  result = call_590090.call(nil, query_590091, nil, nil, nil)

var youtubeSuperChatEventsList* = Call_YoutubeSuperChatEventsList_590075(
    name: "youtubeSuperChatEventsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/superChatEvents",
    validator: validate_YoutubeSuperChatEventsList_590076, base: "/youtube/v3",
    url: url_YoutubeSuperChatEventsList_590077, schemes: {Scheme.Https})
type
  Call_YoutubeThumbnailsSet_590092 = ref object of OpenApiRestCall_588466
proc url_YoutubeThumbnailsSet_590094(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeThumbnailsSet_590093(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads a custom video thumbnail to YouTube and sets it for a video.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   videoId: JString (required)
  ##          : The videoId parameter specifies a YouTube video ID for which the custom video thumbnail is being provided.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590095 = query.getOrDefault("onBehalfOfContentOwner")
  valid_590095 = validateParameter(valid_590095, JString, required = false,
                                 default = nil)
  if valid_590095 != nil:
    section.add "onBehalfOfContentOwner", valid_590095
  var valid_590096 = query.getOrDefault("fields")
  valid_590096 = validateParameter(valid_590096, JString, required = false,
                                 default = nil)
  if valid_590096 != nil:
    section.add "fields", valid_590096
  var valid_590097 = query.getOrDefault("quotaUser")
  valid_590097 = validateParameter(valid_590097, JString, required = false,
                                 default = nil)
  if valid_590097 != nil:
    section.add "quotaUser", valid_590097
  var valid_590098 = query.getOrDefault("alt")
  valid_590098 = validateParameter(valid_590098, JString, required = false,
                                 default = newJString("json"))
  if valid_590098 != nil:
    section.add "alt", valid_590098
  var valid_590099 = query.getOrDefault("oauth_token")
  valid_590099 = validateParameter(valid_590099, JString, required = false,
                                 default = nil)
  if valid_590099 != nil:
    section.add "oauth_token", valid_590099
  var valid_590100 = query.getOrDefault("userIp")
  valid_590100 = validateParameter(valid_590100, JString, required = false,
                                 default = nil)
  if valid_590100 != nil:
    section.add "userIp", valid_590100
  assert query != nil, "query argument is necessary due to required `videoId` field"
  var valid_590101 = query.getOrDefault("videoId")
  valid_590101 = validateParameter(valid_590101, JString, required = true,
                                 default = nil)
  if valid_590101 != nil:
    section.add "videoId", valid_590101
  var valid_590102 = query.getOrDefault("key")
  valid_590102 = validateParameter(valid_590102, JString, required = false,
                                 default = nil)
  if valid_590102 != nil:
    section.add "key", valid_590102
  var valid_590103 = query.getOrDefault("prettyPrint")
  valid_590103 = validateParameter(valid_590103, JBool, required = false,
                                 default = newJBool(true))
  if valid_590103 != nil:
    section.add "prettyPrint", valid_590103
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590104: Call_YoutubeThumbnailsSet_590092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads a custom video thumbnail to YouTube and sets it for a video.
  ## 
  let valid = call_590104.validator(path, query, header, formData, body)
  let scheme = call_590104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590104.url(scheme.get, call_590104.host, call_590104.base,
                         call_590104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590104, url, valid)

proc call*(call_590105: Call_YoutubeThumbnailsSet_590092; videoId: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeThumbnailsSet
  ## Uploads a custom video thumbnail to YouTube and sets it for a video.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   videoId: string (required)
  ##          : The videoId parameter specifies a YouTube video ID for which the custom video thumbnail is being provided.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_590106 = newJObject()
  add(query_590106, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_590106, "fields", newJString(fields))
  add(query_590106, "quotaUser", newJString(quotaUser))
  add(query_590106, "alt", newJString(alt))
  add(query_590106, "oauth_token", newJString(oauthToken))
  add(query_590106, "userIp", newJString(userIp))
  add(query_590106, "videoId", newJString(videoId))
  add(query_590106, "key", newJString(key))
  add(query_590106, "prettyPrint", newJBool(prettyPrint))
  result = call_590105.call(nil, query_590106, nil, nil, nil)

var youtubeThumbnailsSet* = Call_YoutubeThumbnailsSet_590092(
    name: "youtubeThumbnailsSet", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/thumbnails/set",
    validator: validate_YoutubeThumbnailsSet_590093, base: "/youtube/v3",
    url: url_YoutubeThumbnailsSet_590094, schemes: {Scheme.Https})
type
  Call_YoutubeVideoAbuseReportReasonsList_590107 = ref object of OpenApiRestCall_588466
proc url_YoutubeVideoAbuseReportReasonsList_590109(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeVideoAbuseReportReasonsList_590108(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of abuse reasons that can be used for reporting abusive videos.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter specifies the videoCategory resource parts that the API response will include. Supported values are id and snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   hl: JString
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
  section = newJObject()
  var valid_590110 = query.getOrDefault("fields")
  valid_590110 = validateParameter(valid_590110, JString, required = false,
                                 default = nil)
  if valid_590110 != nil:
    section.add "fields", valid_590110
  var valid_590111 = query.getOrDefault("quotaUser")
  valid_590111 = validateParameter(valid_590111, JString, required = false,
                                 default = nil)
  if valid_590111 != nil:
    section.add "quotaUser", valid_590111
  var valid_590112 = query.getOrDefault("alt")
  valid_590112 = validateParameter(valid_590112, JString, required = false,
                                 default = newJString("json"))
  if valid_590112 != nil:
    section.add "alt", valid_590112
  var valid_590113 = query.getOrDefault("oauth_token")
  valid_590113 = validateParameter(valid_590113, JString, required = false,
                                 default = nil)
  if valid_590113 != nil:
    section.add "oauth_token", valid_590113
  var valid_590114 = query.getOrDefault("userIp")
  valid_590114 = validateParameter(valid_590114, JString, required = false,
                                 default = nil)
  if valid_590114 != nil:
    section.add "userIp", valid_590114
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_590115 = query.getOrDefault("part")
  valid_590115 = validateParameter(valid_590115, JString, required = true,
                                 default = nil)
  if valid_590115 != nil:
    section.add "part", valid_590115
  var valid_590116 = query.getOrDefault("key")
  valid_590116 = validateParameter(valid_590116, JString, required = false,
                                 default = nil)
  if valid_590116 != nil:
    section.add "key", valid_590116
  var valid_590117 = query.getOrDefault("prettyPrint")
  valid_590117 = validateParameter(valid_590117, JBool, required = false,
                                 default = newJBool(true))
  if valid_590117 != nil:
    section.add "prettyPrint", valid_590117
  var valid_590118 = query.getOrDefault("hl")
  valid_590118 = validateParameter(valid_590118, JString, required = false,
                                 default = newJString("en_US"))
  if valid_590118 != nil:
    section.add "hl", valid_590118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590119: Call_YoutubeVideoAbuseReportReasonsList_590107;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of abuse reasons that can be used for reporting abusive videos.
  ## 
  let valid = call_590119.validator(path, query, header, formData, body)
  let scheme = call_590119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590119.url(scheme.get, call_590119.host, call_590119.base,
                         call_590119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590119, url, valid)

proc call*(call_590120: Call_YoutubeVideoAbuseReportReasonsList_590107;
          part: string; fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; hl: string = "en_US"): Recallable =
  ## youtubeVideoAbuseReportReasonsList
  ## Returns a list of abuse reasons that can be used for reporting abusive videos.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter specifies the videoCategory resource parts that the API response will include. Supported values are id and snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   hl: string
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
  var query_590121 = newJObject()
  add(query_590121, "fields", newJString(fields))
  add(query_590121, "quotaUser", newJString(quotaUser))
  add(query_590121, "alt", newJString(alt))
  add(query_590121, "oauth_token", newJString(oauthToken))
  add(query_590121, "userIp", newJString(userIp))
  add(query_590121, "part", newJString(part))
  add(query_590121, "key", newJString(key))
  add(query_590121, "prettyPrint", newJBool(prettyPrint))
  add(query_590121, "hl", newJString(hl))
  result = call_590120.call(nil, query_590121, nil, nil, nil)

var youtubeVideoAbuseReportReasonsList* = Call_YoutubeVideoAbuseReportReasonsList_590107(
    name: "youtubeVideoAbuseReportReasonsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/videoAbuseReportReasons",
    validator: validate_YoutubeVideoAbuseReportReasonsList_590108,
    base: "/youtube/v3", url: url_YoutubeVideoAbuseReportReasonsList_590109,
    schemes: {Scheme.Https})
type
  Call_YoutubeVideoCategoriesList_590122 = ref object of OpenApiRestCall_588466
proc url_YoutubeVideoCategoriesList_590124(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeVideoCategoriesList_590123(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of categories that can be associated with YouTube videos.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of video category IDs for the resources that you are retrieving.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter specifies the videoCategory resource properties that the API response will include. Set the parameter value to snippet.
  ##   regionCode: JString
  ##             : The regionCode parameter instructs the API to return the list of video categories available in the specified country. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   hl: JString
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
  section = newJObject()
  var valid_590125 = query.getOrDefault("fields")
  valid_590125 = validateParameter(valid_590125, JString, required = false,
                                 default = nil)
  if valid_590125 != nil:
    section.add "fields", valid_590125
  var valid_590126 = query.getOrDefault("quotaUser")
  valid_590126 = validateParameter(valid_590126, JString, required = false,
                                 default = nil)
  if valid_590126 != nil:
    section.add "quotaUser", valid_590126
  var valid_590127 = query.getOrDefault("id")
  valid_590127 = validateParameter(valid_590127, JString, required = false,
                                 default = nil)
  if valid_590127 != nil:
    section.add "id", valid_590127
  var valid_590128 = query.getOrDefault("alt")
  valid_590128 = validateParameter(valid_590128, JString, required = false,
                                 default = newJString("json"))
  if valid_590128 != nil:
    section.add "alt", valid_590128
  var valid_590129 = query.getOrDefault("oauth_token")
  valid_590129 = validateParameter(valid_590129, JString, required = false,
                                 default = nil)
  if valid_590129 != nil:
    section.add "oauth_token", valid_590129
  var valid_590130 = query.getOrDefault("userIp")
  valid_590130 = validateParameter(valid_590130, JString, required = false,
                                 default = nil)
  if valid_590130 != nil:
    section.add "userIp", valid_590130
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_590131 = query.getOrDefault("part")
  valid_590131 = validateParameter(valid_590131, JString, required = true,
                                 default = nil)
  if valid_590131 != nil:
    section.add "part", valid_590131
  var valid_590132 = query.getOrDefault("regionCode")
  valid_590132 = validateParameter(valid_590132, JString, required = false,
                                 default = nil)
  if valid_590132 != nil:
    section.add "regionCode", valid_590132
  var valid_590133 = query.getOrDefault("key")
  valid_590133 = validateParameter(valid_590133, JString, required = false,
                                 default = nil)
  if valid_590133 != nil:
    section.add "key", valid_590133
  var valid_590134 = query.getOrDefault("prettyPrint")
  valid_590134 = validateParameter(valid_590134, JBool, required = false,
                                 default = newJBool(true))
  if valid_590134 != nil:
    section.add "prettyPrint", valid_590134
  var valid_590135 = query.getOrDefault("hl")
  valid_590135 = validateParameter(valid_590135, JString, required = false,
                                 default = newJString("en_US"))
  if valid_590135 != nil:
    section.add "hl", valid_590135
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590136: Call_YoutubeVideoCategoriesList_590122; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of categories that can be associated with YouTube videos.
  ## 
  let valid = call_590136.validator(path, query, header, formData, body)
  let scheme = call_590136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590136.url(scheme.get, call_590136.host, call_590136.base,
                         call_590136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590136, url, valid)

proc call*(call_590137: Call_YoutubeVideoCategoriesList_590122; part: string;
          fields: string = ""; quotaUser: string = ""; id: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          regionCode: string = ""; key: string = ""; prettyPrint: bool = true;
          hl: string = "en_US"): Recallable =
  ## youtubeVideoCategoriesList
  ## Returns a list of categories that can be associated with YouTube videos.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of video category IDs for the resources that you are retrieving.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter specifies the videoCategory resource properties that the API response will include. Set the parameter value to snippet.
  ##   regionCode: string
  ##             : The regionCode parameter instructs the API to return the list of video categories available in the specified country. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   hl: string
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
  var query_590138 = newJObject()
  add(query_590138, "fields", newJString(fields))
  add(query_590138, "quotaUser", newJString(quotaUser))
  add(query_590138, "id", newJString(id))
  add(query_590138, "alt", newJString(alt))
  add(query_590138, "oauth_token", newJString(oauthToken))
  add(query_590138, "userIp", newJString(userIp))
  add(query_590138, "part", newJString(part))
  add(query_590138, "regionCode", newJString(regionCode))
  add(query_590138, "key", newJString(key))
  add(query_590138, "prettyPrint", newJBool(prettyPrint))
  add(query_590138, "hl", newJString(hl))
  result = call_590137.call(nil, query_590138, nil, nil, nil)

var youtubeVideoCategoriesList* = Call_YoutubeVideoCategoriesList_590122(
    name: "youtubeVideoCategoriesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/videoCategories",
    validator: validate_YoutubeVideoCategoriesList_590123, base: "/youtube/v3",
    url: url_YoutubeVideoCategoriesList_590124, schemes: {Scheme.Https})
type
  Call_YoutubeVideosUpdate_590165 = ref object of OpenApiRestCall_588466
proc url_YoutubeVideosUpdate_590167(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeVideosUpdate_590166(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates a video's metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. For example, a video's privacy setting is contained in the status part. As such, if your request is updating a private video, and the request's part parameter value includes the status part, the video's privacy setting will be updated to whatever value the request body specifies. If the request body does not specify a value, the existing privacy setting will be removed and the video will revert to the default privacy setting.
  ## 
  ## In addition, not all parts contain properties that can be set when inserting or updating a video. For example, the statistics object encapsulates statistics that YouTube calculates for a video and does not contain values that you can set or modify. If the parameter value specifies a part that does not contain mutable values, that part will still be included in the API response.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590168 = query.getOrDefault("onBehalfOfContentOwner")
  valid_590168 = validateParameter(valid_590168, JString, required = false,
                                 default = nil)
  if valid_590168 != nil:
    section.add "onBehalfOfContentOwner", valid_590168
  var valid_590169 = query.getOrDefault("fields")
  valid_590169 = validateParameter(valid_590169, JString, required = false,
                                 default = nil)
  if valid_590169 != nil:
    section.add "fields", valid_590169
  var valid_590170 = query.getOrDefault("quotaUser")
  valid_590170 = validateParameter(valid_590170, JString, required = false,
                                 default = nil)
  if valid_590170 != nil:
    section.add "quotaUser", valid_590170
  var valid_590171 = query.getOrDefault("alt")
  valid_590171 = validateParameter(valid_590171, JString, required = false,
                                 default = newJString("json"))
  if valid_590171 != nil:
    section.add "alt", valid_590171
  var valid_590172 = query.getOrDefault("oauth_token")
  valid_590172 = validateParameter(valid_590172, JString, required = false,
                                 default = nil)
  if valid_590172 != nil:
    section.add "oauth_token", valid_590172
  var valid_590173 = query.getOrDefault("userIp")
  valid_590173 = validateParameter(valid_590173, JString, required = false,
                                 default = nil)
  if valid_590173 != nil:
    section.add "userIp", valid_590173
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_590174 = query.getOrDefault("part")
  valid_590174 = validateParameter(valid_590174, JString, required = true,
                                 default = nil)
  if valid_590174 != nil:
    section.add "part", valid_590174
  var valid_590175 = query.getOrDefault("key")
  valid_590175 = validateParameter(valid_590175, JString, required = false,
                                 default = nil)
  if valid_590175 != nil:
    section.add "key", valid_590175
  var valid_590176 = query.getOrDefault("prettyPrint")
  valid_590176 = validateParameter(valid_590176, JBool, required = false,
                                 default = newJBool(true))
  if valid_590176 != nil:
    section.add "prettyPrint", valid_590176
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

proc call*(call_590178: Call_YoutubeVideosUpdate_590165; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a video's metadata.
  ## 
  let valid = call_590178.validator(path, query, header, formData, body)
  let scheme = call_590178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590178.url(scheme.get, call_590178.host, call_590178.base,
                         call_590178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590178, url, valid)

proc call*(call_590179: Call_YoutubeVideosUpdate_590165; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## youtubeVideosUpdate
  ## Updates a video's metadata.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. For example, a video's privacy setting is contained in the status part. As such, if your request is updating a private video, and the request's part parameter value includes the status part, the video's privacy setting will be updated to whatever value the request body specifies. If the request body does not specify a value, the existing privacy setting will be removed and the video will revert to the default privacy setting.
  ## 
  ## In addition, not all parts contain properties that can be set when inserting or updating a video. For example, the statistics object encapsulates statistics that YouTube calculates for a video and does not contain values that you can set or modify. If the parameter value specifies a part that does not contain mutable values, that part will still be included in the API response.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_590180 = newJObject()
  var body_590181 = newJObject()
  add(query_590180, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_590180, "fields", newJString(fields))
  add(query_590180, "quotaUser", newJString(quotaUser))
  add(query_590180, "alt", newJString(alt))
  add(query_590180, "oauth_token", newJString(oauthToken))
  add(query_590180, "userIp", newJString(userIp))
  add(query_590180, "part", newJString(part))
  add(query_590180, "key", newJString(key))
  if body != nil:
    body_590181 = body
  add(query_590180, "prettyPrint", newJBool(prettyPrint))
  result = call_590179.call(nil, query_590180, nil, nil, body_590181)

var youtubeVideosUpdate* = Call_YoutubeVideosUpdate_590165(
    name: "youtubeVideosUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/videos",
    validator: validate_YoutubeVideosUpdate_590166, base: "/youtube/v3",
    url: url_YoutubeVideosUpdate_590167, schemes: {Scheme.Https})
type
  Call_YoutubeVideosInsert_590182 = ref object of OpenApiRestCall_588466
proc url_YoutubeVideosInsert_590184(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeVideosInsert_590183(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Uploads a video to YouTube and optionally sets the video's metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   notifySubscribers: JBool
  ##                    : The notifySubscribers parameter indicates whether YouTube should send a notification about the new video to users who subscribe to the video's channel. A parameter value of True indicates that subscribers will be notified of newly uploaded videos. However, a channel owner who is uploading many videos might prefer to set the value to False to avoid sending a notification about each new video to the channel's subscribers.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   autoLevels: JBool
  ##             : The autoLevels parameter indicates whether YouTube should automatically enhance the video's lighting and color.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that not all parts contain properties that can be set when inserting or updating a video. For example, the statistics object encapsulates statistics that YouTube calculates for a video and does not contain values that you can set or modify. If the parameter value specifies a part that does not contain mutable values, that part will still be included in the API response.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   stabilize: JBool
  ##            : The stabilize parameter indicates whether YouTube should adjust the video to remove shaky camera motions.
  section = newJObject()
  var valid_590185 = query.getOrDefault("onBehalfOfContentOwner")
  valid_590185 = validateParameter(valid_590185, JString, required = false,
                                 default = nil)
  if valid_590185 != nil:
    section.add "onBehalfOfContentOwner", valid_590185
  var valid_590186 = query.getOrDefault("fields")
  valid_590186 = validateParameter(valid_590186, JString, required = false,
                                 default = nil)
  if valid_590186 != nil:
    section.add "fields", valid_590186
  var valid_590187 = query.getOrDefault("notifySubscribers")
  valid_590187 = validateParameter(valid_590187, JBool, required = false,
                                 default = newJBool(true))
  if valid_590187 != nil:
    section.add "notifySubscribers", valid_590187
  var valid_590188 = query.getOrDefault("quotaUser")
  valid_590188 = validateParameter(valid_590188, JString, required = false,
                                 default = nil)
  if valid_590188 != nil:
    section.add "quotaUser", valid_590188
  var valid_590189 = query.getOrDefault("alt")
  valid_590189 = validateParameter(valid_590189, JString, required = false,
                                 default = newJString("json"))
  if valid_590189 != nil:
    section.add "alt", valid_590189
  var valid_590190 = query.getOrDefault("autoLevels")
  valid_590190 = validateParameter(valid_590190, JBool, required = false, default = nil)
  if valid_590190 != nil:
    section.add "autoLevels", valid_590190
  var valid_590191 = query.getOrDefault("oauth_token")
  valid_590191 = validateParameter(valid_590191, JString, required = false,
                                 default = nil)
  if valid_590191 != nil:
    section.add "oauth_token", valid_590191
  var valid_590192 = query.getOrDefault("userIp")
  valid_590192 = validateParameter(valid_590192, JString, required = false,
                                 default = nil)
  if valid_590192 != nil:
    section.add "userIp", valid_590192
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_590193 = query.getOrDefault("part")
  valid_590193 = validateParameter(valid_590193, JString, required = true,
                                 default = nil)
  if valid_590193 != nil:
    section.add "part", valid_590193
  var valid_590194 = query.getOrDefault("key")
  valid_590194 = validateParameter(valid_590194, JString, required = false,
                                 default = nil)
  if valid_590194 != nil:
    section.add "key", valid_590194
  var valid_590195 = query.getOrDefault("prettyPrint")
  valid_590195 = validateParameter(valid_590195, JBool, required = false,
                                 default = newJBool(true))
  if valid_590195 != nil:
    section.add "prettyPrint", valid_590195
  var valid_590196 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_590196 = validateParameter(valid_590196, JString, required = false,
                                 default = nil)
  if valid_590196 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_590196
  var valid_590197 = query.getOrDefault("stabilize")
  valid_590197 = validateParameter(valid_590197, JBool, required = false, default = nil)
  if valid_590197 != nil:
    section.add "stabilize", valid_590197
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

proc call*(call_590199: Call_YoutubeVideosInsert_590182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads a video to YouTube and optionally sets the video's metadata.
  ## 
  let valid = call_590199.validator(path, query, header, formData, body)
  let scheme = call_590199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590199.url(scheme.get, call_590199.host, call_590199.base,
                         call_590199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590199, url, valid)

proc call*(call_590200: Call_YoutubeVideosInsert_590182; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          notifySubscribers: bool = true; quotaUser: string = ""; alt: string = "json";
          autoLevels: bool = false; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true;
          onBehalfOfContentOwnerChannel: string = ""; stabilize: bool = false): Recallable =
  ## youtubeVideosInsert
  ## Uploads a video to YouTube and optionally sets the video's metadata.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   notifySubscribers: bool
  ##                    : The notifySubscribers parameter indicates whether YouTube should send a notification about the new video to users who subscribe to the video's channel. A parameter value of True indicates that subscribers will be notified of newly uploaded videos. However, a channel owner who is uploading many videos might prefer to set the value to False to avoid sending a notification about each new video to the channel's subscribers.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   autoLevels: bool
  ##             : The autoLevels parameter indicates whether YouTube should automatically enhance the video's lighting and color.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that not all parts contain properties that can be set when inserting or updating a video. For example, the statistics object encapsulates statistics that YouTube calculates for a video and does not contain values that you can set or modify. If the parameter value specifies a part that does not contain mutable values, that part will still be included in the API response.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   stabilize: bool
  ##            : The stabilize parameter indicates whether YouTube should adjust the video to remove shaky camera motions.
  var query_590201 = newJObject()
  var body_590202 = newJObject()
  add(query_590201, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_590201, "fields", newJString(fields))
  add(query_590201, "notifySubscribers", newJBool(notifySubscribers))
  add(query_590201, "quotaUser", newJString(quotaUser))
  add(query_590201, "alt", newJString(alt))
  add(query_590201, "autoLevels", newJBool(autoLevels))
  add(query_590201, "oauth_token", newJString(oauthToken))
  add(query_590201, "userIp", newJString(userIp))
  add(query_590201, "part", newJString(part))
  add(query_590201, "key", newJString(key))
  if body != nil:
    body_590202 = body
  add(query_590201, "prettyPrint", newJBool(prettyPrint))
  add(query_590201, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  add(query_590201, "stabilize", newJBool(stabilize))
  result = call_590200.call(nil, query_590201, nil, nil, body_590202)

var youtubeVideosInsert* = Call_YoutubeVideosInsert_590182(
    name: "youtubeVideosInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/videos",
    validator: validate_YoutubeVideosInsert_590183, base: "/youtube/v3",
    url: url_YoutubeVideosInsert_590184, schemes: {Scheme.Https})
type
  Call_YoutubeVideosList_590139 = ref object of OpenApiRestCall_588466
proc url_YoutubeVideosList_590141(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeVideosList_590140(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns a list of videos that match the API request parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   locale: JString
  ##         : DEPRECATED
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ## 
  ## Note: This parameter is supported for use in conjunction with the myRating and chart parameters, but it is not supported for use in conjunction with the id parameter.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   maxHeight: JInt
  ##            : The maxHeight parameter specifies a maximum height of the embedded player. If maxWidth is provided, maxHeight may not be reached in order to not violate the width request.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of the YouTube video ID(s) for the resource(s) that are being retrieved. In a video resource, the id property specifies the video's ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   maxWidth: JInt
  ##           : The maxWidth parameter specifies a maximum width of the embedded player. If maxHeight is provided, maxWidth may not be reached in order to not violate the height request.
  ##   myRating: JString
  ##           : Set this parameter's value to like or dislike to instruct the API to only return videos liked or disliked by the authenticated user.
  ##   chart: JString
  ##        : The chart parameter identifies the chart that you want to retrieve.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ## 
  ## Note: This parameter is supported for use in conjunction with the myRating and chart parameters, but it is not supported for use in conjunction with the id parameter.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more video resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a video resource, the snippet property contains the channelId, title, description, tags, and categoryId properties. As such, if you set part=snippet, the API response will contain all of those properties.
  ##   regionCode: JString
  ##             : The regionCode parameter instructs the API to select a video chart available in the specified region. This parameter can only be used in conjunction with the chart parameter. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   hl: JString
  ##     : The hl parameter instructs the API to retrieve localized resource metadata for a specific application language that the YouTube website supports. The parameter value must be a language code included in the list returned by the i18nLanguages.list method.
  ## 
  ## If localized resource details are available in that language, the resource's snippet.localized object will contain the localized values. However, if localized details are not available, the snippet.localized object will contain resource details in the resource's default language.
  ##   videoCategoryId: JString
  ##                  : The videoCategoryId parameter identifies the video category for which the chart should be retrieved. This parameter can only be used in conjunction with the chart parameter. By default, charts are not restricted to a particular category.
  section = newJObject()
  var valid_590142 = query.getOrDefault("onBehalfOfContentOwner")
  valid_590142 = validateParameter(valid_590142, JString, required = false,
                                 default = nil)
  if valid_590142 != nil:
    section.add "onBehalfOfContentOwner", valid_590142
  var valid_590143 = query.getOrDefault("locale")
  valid_590143 = validateParameter(valid_590143, JString, required = false,
                                 default = nil)
  if valid_590143 != nil:
    section.add "locale", valid_590143
  var valid_590144 = query.getOrDefault("fields")
  valid_590144 = validateParameter(valid_590144, JString, required = false,
                                 default = nil)
  if valid_590144 != nil:
    section.add "fields", valid_590144
  var valid_590145 = query.getOrDefault("pageToken")
  valid_590145 = validateParameter(valid_590145, JString, required = false,
                                 default = nil)
  if valid_590145 != nil:
    section.add "pageToken", valid_590145
  var valid_590146 = query.getOrDefault("quotaUser")
  valid_590146 = validateParameter(valid_590146, JString, required = false,
                                 default = nil)
  if valid_590146 != nil:
    section.add "quotaUser", valid_590146
  var valid_590147 = query.getOrDefault("maxHeight")
  valid_590147 = validateParameter(valid_590147, JInt, required = false, default = nil)
  if valid_590147 != nil:
    section.add "maxHeight", valid_590147
  var valid_590148 = query.getOrDefault("id")
  valid_590148 = validateParameter(valid_590148, JString, required = false,
                                 default = nil)
  if valid_590148 != nil:
    section.add "id", valid_590148
  var valid_590149 = query.getOrDefault("alt")
  valid_590149 = validateParameter(valid_590149, JString, required = false,
                                 default = newJString("json"))
  if valid_590149 != nil:
    section.add "alt", valid_590149
  var valid_590150 = query.getOrDefault("maxWidth")
  valid_590150 = validateParameter(valid_590150, JInt, required = false, default = nil)
  if valid_590150 != nil:
    section.add "maxWidth", valid_590150
  var valid_590151 = query.getOrDefault("myRating")
  valid_590151 = validateParameter(valid_590151, JString, required = false,
                                 default = newJString("dislike"))
  if valid_590151 != nil:
    section.add "myRating", valid_590151
  var valid_590152 = query.getOrDefault("chart")
  valid_590152 = validateParameter(valid_590152, JString, required = false,
                                 default = newJString("mostPopular"))
  if valid_590152 != nil:
    section.add "chart", valid_590152
  var valid_590153 = query.getOrDefault("oauth_token")
  valid_590153 = validateParameter(valid_590153, JString, required = false,
                                 default = nil)
  if valid_590153 != nil:
    section.add "oauth_token", valid_590153
  var valid_590154 = query.getOrDefault("userIp")
  valid_590154 = validateParameter(valid_590154, JString, required = false,
                                 default = nil)
  if valid_590154 != nil:
    section.add "userIp", valid_590154
  var valid_590155 = query.getOrDefault("maxResults")
  valid_590155 = validateParameter(valid_590155, JInt, required = false,
                                 default = newJInt(5))
  if valid_590155 != nil:
    section.add "maxResults", valid_590155
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_590156 = query.getOrDefault("part")
  valid_590156 = validateParameter(valid_590156, JString, required = true,
                                 default = nil)
  if valid_590156 != nil:
    section.add "part", valid_590156
  var valid_590157 = query.getOrDefault("regionCode")
  valid_590157 = validateParameter(valid_590157, JString, required = false,
                                 default = nil)
  if valid_590157 != nil:
    section.add "regionCode", valid_590157
  var valid_590158 = query.getOrDefault("key")
  valid_590158 = validateParameter(valid_590158, JString, required = false,
                                 default = nil)
  if valid_590158 != nil:
    section.add "key", valid_590158
  var valid_590159 = query.getOrDefault("prettyPrint")
  valid_590159 = validateParameter(valid_590159, JBool, required = false,
                                 default = newJBool(true))
  if valid_590159 != nil:
    section.add "prettyPrint", valid_590159
  var valid_590160 = query.getOrDefault("hl")
  valid_590160 = validateParameter(valid_590160, JString, required = false,
                                 default = nil)
  if valid_590160 != nil:
    section.add "hl", valid_590160
  var valid_590161 = query.getOrDefault("videoCategoryId")
  valid_590161 = validateParameter(valid_590161, JString, required = false,
                                 default = newJString("0"))
  if valid_590161 != nil:
    section.add "videoCategoryId", valid_590161
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590162: Call_YoutubeVideosList_590139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of videos that match the API request parameters.
  ## 
  let valid = call_590162.validator(path, query, header, formData, body)
  let scheme = call_590162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590162.url(scheme.get, call_590162.host, call_590162.base,
                         call_590162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590162, url, valid)

proc call*(call_590163: Call_YoutubeVideosList_590139; part: string;
          onBehalfOfContentOwner: string = ""; locale: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; maxHeight: int = 0;
          id: string = ""; alt: string = "json"; maxWidth: int = 0;
          myRating: string = "dislike"; chart: string = "mostPopular";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 5;
          regionCode: string = ""; key: string = ""; prettyPrint: bool = true;
          hl: string = ""; videoCategoryId: string = "0"): Recallable =
  ## youtubeVideosList
  ## Returns a list of videos that match the API request parameters.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   locale: string
  ##         : DEPRECATED
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ## 
  ## Note: This parameter is supported for use in conjunction with the myRating and chart parameters, but it is not supported for use in conjunction with the id parameter.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   maxHeight: int
  ##            : The maxHeight parameter specifies a maximum height of the embedded player. If maxWidth is provided, maxHeight may not be reached in order to not violate the width request.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of the YouTube video ID(s) for the resource(s) that are being retrieved. In a video resource, the id property specifies the video's ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   maxWidth: int
  ##           : The maxWidth parameter specifies a maximum width of the embedded player. If maxHeight is provided, maxWidth may not be reached in order to not violate the height request.
  ##   myRating: string
  ##           : Set this parameter's value to like or dislike to instruct the API to only return videos liked or disliked by the authenticated user.
  ##   chart: string
  ##        : The chart parameter identifies the chart that you want to retrieve.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ## 
  ## Note: This parameter is supported for use in conjunction with the myRating and chart parameters, but it is not supported for use in conjunction with the id parameter.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more video resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a video resource, the snippet property contains the channelId, title, description, tags, and categoryId properties. As such, if you set part=snippet, the API response will contain all of those properties.
  ##   regionCode: string
  ##             : The regionCode parameter instructs the API to select a video chart available in the specified region. This parameter can only be used in conjunction with the chart parameter. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   hl: string
  ##     : The hl parameter instructs the API to retrieve localized resource metadata for a specific application language that the YouTube website supports. The parameter value must be a language code included in the list returned by the i18nLanguages.list method.
  ## 
  ## If localized resource details are available in that language, the resource's snippet.localized object will contain the localized values. However, if localized details are not available, the snippet.localized object will contain resource details in the resource's default language.
  ##   videoCategoryId: string
  ##                  : The videoCategoryId parameter identifies the video category for which the chart should be retrieved. This parameter can only be used in conjunction with the chart parameter. By default, charts are not restricted to a particular category.
  var query_590164 = newJObject()
  add(query_590164, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_590164, "locale", newJString(locale))
  add(query_590164, "fields", newJString(fields))
  add(query_590164, "pageToken", newJString(pageToken))
  add(query_590164, "quotaUser", newJString(quotaUser))
  add(query_590164, "maxHeight", newJInt(maxHeight))
  add(query_590164, "id", newJString(id))
  add(query_590164, "alt", newJString(alt))
  add(query_590164, "maxWidth", newJInt(maxWidth))
  add(query_590164, "myRating", newJString(myRating))
  add(query_590164, "chart", newJString(chart))
  add(query_590164, "oauth_token", newJString(oauthToken))
  add(query_590164, "userIp", newJString(userIp))
  add(query_590164, "maxResults", newJInt(maxResults))
  add(query_590164, "part", newJString(part))
  add(query_590164, "regionCode", newJString(regionCode))
  add(query_590164, "key", newJString(key))
  add(query_590164, "prettyPrint", newJBool(prettyPrint))
  add(query_590164, "hl", newJString(hl))
  add(query_590164, "videoCategoryId", newJString(videoCategoryId))
  result = call_590163.call(nil, query_590164, nil, nil, nil)

var youtubeVideosList* = Call_YoutubeVideosList_590139(name: "youtubeVideosList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/videos",
    validator: validate_YoutubeVideosList_590140, base: "/youtube/v3",
    url: url_YoutubeVideosList_590141, schemes: {Scheme.Https})
type
  Call_YoutubeVideosDelete_590203 = ref object of OpenApiRestCall_588466
proc url_YoutubeVideosDelete_590205(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeVideosDelete_590204(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes a YouTube video.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube video ID for the resource that is being deleted. In a video resource, the id property specifies the video's ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590206 = query.getOrDefault("onBehalfOfContentOwner")
  valid_590206 = validateParameter(valid_590206, JString, required = false,
                                 default = nil)
  if valid_590206 != nil:
    section.add "onBehalfOfContentOwner", valid_590206
  var valid_590207 = query.getOrDefault("fields")
  valid_590207 = validateParameter(valid_590207, JString, required = false,
                                 default = nil)
  if valid_590207 != nil:
    section.add "fields", valid_590207
  var valid_590208 = query.getOrDefault("quotaUser")
  valid_590208 = validateParameter(valid_590208, JString, required = false,
                                 default = nil)
  if valid_590208 != nil:
    section.add "quotaUser", valid_590208
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_590209 = query.getOrDefault("id")
  valid_590209 = validateParameter(valid_590209, JString, required = true,
                                 default = nil)
  if valid_590209 != nil:
    section.add "id", valid_590209
  var valid_590210 = query.getOrDefault("alt")
  valid_590210 = validateParameter(valid_590210, JString, required = false,
                                 default = newJString("json"))
  if valid_590210 != nil:
    section.add "alt", valid_590210
  var valid_590211 = query.getOrDefault("oauth_token")
  valid_590211 = validateParameter(valid_590211, JString, required = false,
                                 default = nil)
  if valid_590211 != nil:
    section.add "oauth_token", valid_590211
  var valid_590212 = query.getOrDefault("userIp")
  valid_590212 = validateParameter(valid_590212, JString, required = false,
                                 default = nil)
  if valid_590212 != nil:
    section.add "userIp", valid_590212
  var valid_590213 = query.getOrDefault("key")
  valid_590213 = validateParameter(valid_590213, JString, required = false,
                                 default = nil)
  if valid_590213 != nil:
    section.add "key", valid_590213
  var valid_590214 = query.getOrDefault("prettyPrint")
  valid_590214 = validateParameter(valid_590214, JBool, required = false,
                                 default = newJBool(true))
  if valid_590214 != nil:
    section.add "prettyPrint", valid_590214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590215: Call_YoutubeVideosDelete_590203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a YouTube video.
  ## 
  let valid = call_590215.validator(path, query, header, formData, body)
  let scheme = call_590215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590215.url(scheme.get, call_590215.host, call_590215.base,
                         call_590215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590215, url, valid)

proc call*(call_590216: Call_YoutubeVideosDelete_590203; id: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeVideosDelete
  ## Deletes a YouTube video.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube video ID for the resource that is being deleted. In a video resource, the id property specifies the video's ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_590217 = newJObject()
  add(query_590217, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_590217, "fields", newJString(fields))
  add(query_590217, "quotaUser", newJString(quotaUser))
  add(query_590217, "id", newJString(id))
  add(query_590217, "alt", newJString(alt))
  add(query_590217, "oauth_token", newJString(oauthToken))
  add(query_590217, "userIp", newJString(userIp))
  add(query_590217, "key", newJString(key))
  add(query_590217, "prettyPrint", newJBool(prettyPrint))
  result = call_590216.call(nil, query_590217, nil, nil, nil)

var youtubeVideosDelete* = Call_YoutubeVideosDelete_590203(
    name: "youtubeVideosDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/videos",
    validator: validate_YoutubeVideosDelete_590204, base: "/youtube/v3",
    url: url_YoutubeVideosDelete_590205, schemes: {Scheme.Https})
type
  Call_YoutubeVideosGetRating_590218 = ref object of OpenApiRestCall_588466
proc url_YoutubeVideosGetRating_590220(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeVideosGetRating_590219(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the ratings that the authorized user gave to a list of specified videos.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies a comma-separated list of the YouTube video ID(s) for the resource(s) for which you are retrieving rating data. In a video resource, the id property specifies the video's ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590221 = query.getOrDefault("onBehalfOfContentOwner")
  valid_590221 = validateParameter(valid_590221, JString, required = false,
                                 default = nil)
  if valid_590221 != nil:
    section.add "onBehalfOfContentOwner", valid_590221
  var valid_590222 = query.getOrDefault("fields")
  valid_590222 = validateParameter(valid_590222, JString, required = false,
                                 default = nil)
  if valid_590222 != nil:
    section.add "fields", valid_590222
  var valid_590223 = query.getOrDefault("quotaUser")
  valid_590223 = validateParameter(valid_590223, JString, required = false,
                                 default = nil)
  if valid_590223 != nil:
    section.add "quotaUser", valid_590223
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_590224 = query.getOrDefault("id")
  valid_590224 = validateParameter(valid_590224, JString, required = true,
                                 default = nil)
  if valid_590224 != nil:
    section.add "id", valid_590224
  var valid_590225 = query.getOrDefault("alt")
  valid_590225 = validateParameter(valid_590225, JString, required = false,
                                 default = newJString("json"))
  if valid_590225 != nil:
    section.add "alt", valid_590225
  var valid_590226 = query.getOrDefault("oauth_token")
  valid_590226 = validateParameter(valid_590226, JString, required = false,
                                 default = nil)
  if valid_590226 != nil:
    section.add "oauth_token", valid_590226
  var valid_590227 = query.getOrDefault("userIp")
  valid_590227 = validateParameter(valid_590227, JString, required = false,
                                 default = nil)
  if valid_590227 != nil:
    section.add "userIp", valid_590227
  var valid_590228 = query.getOrDefault("key")
  valid_590228 = validateParameter(valid_590228, JString, required = false,
                                 default = nil)
  if valid_590228 != nil:
    section.add "key", valid_590228
  var valid_590229 = query.getOrDefault("prettyPrint")
  valid_590229 = validateParameter(valid_590229, JBool, required = false,
                                 default = newJBool(true))
  if valid_590229 != nil:
    section.add "prettyPrint", valid_590229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590230: Call_YoutubeVideosGetRating_590218; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the ratings that the authorized user gave to a list of specified videos.
  ## 
  let valid = call_590230.validator(path, query, header, formData, body)
  let scheme = call_590230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590230.url(scheme.get, call_590230.host, call_590230.base,
                         call_590230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590230, url, valid)

proc call*(call_590231: Call_YoutubeVideosGetRating_590218; id: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeVideosGetRating
  ## Retrieves the ratings that the authorized user gave to a list of specified videos.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies a comma-separated list of the YouTube video ID(s) for the resource(s) for which you are retrieving rating data. In a video resource, the id property specifies the video's ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_590232 = newJObject()
  add(query_590232, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_590232, "fields", newJString(fields))
  add(query_590232, "quotaUser", newJString(quotaUser))
  add(query_590232, "id", newJString(id))
  add(query_590232, "alt", newJString(alt))
  add(query_590232, "oauth_token", newJString(oauthToken))
  add(query_590232, "userIp", newJString(userIp))
  add(query_590232, "key", newJString(key))
  add(query_590232, "prettyPrint", newJBool(prettyPrint))
  result = call_590231.call(nil, query_590232, nil, nil, nil)

var youtubeVideosGetRating* = Call_YoutubeVideosGetRating_590218(
    name: "youtubeVideosGetRating", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/videos/getRating",
    validator: validate_YoutubeVideosGetRating_590219, base: "/youtube/v3",
    url: url_YoutubeVideosGetRating_590220, schemes: {Scheme.Https})
type
  Call_YoutubeVideosRate_590233 = ref object of OpenApiRestCall_588466
proc url_YoutubeVideosRate_590235(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeVideosRate_590234(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Add a like or dislike rating to a video or remove a rating from a video.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube video ID of the video that is being rated or having its rating removed.
  ##   alt: JString
  ##      : Data format for the response.
  ##   rating: JString (required)
  ##         : Specifies the rating to record.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590236 = query.getOrDefault("fields")
  valid_590236 = validateParameter(valid_590236, JString, required = false,
                                 default = nil)
  if valid_590236 != nil:
    section.add "fields", valid_590236
  var valid_590237 = query.getOrDefault("quotaUser")
  valid_590237 = validateParameter(valid_590237, JString, required = false,
                                 default = nil)
  if valid_590237 != nil:
    section.add "quotaUser", valid_590237
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_590238 = query.getOrDefault("id")
  valid_590238 = validateParameter(valid_590238, JString, required = true,
                                 default = nil)
  if valid_590238 != nil:
    section.add "id", valid_590238
  var valid_590239 = query.getOrDefault("alt")
  valid_590239 = validateParameter(valid_590239, JString, required = false,
                                 default = newJString("json"))
  if valid_590239 != nil:
    section.add "alt", valid_590239
  var valid_590240 = query.getOrDefault("rating")
  valid_590240 = validateParameter(valid_590240, JString, required = true,
                                 default = newJString("dislike"))
  if valid_590240 != nil:
    section.add "rating", valid_590240
  var valid_590241 = query.getOrDefault("oauth_token")
  valid_590241 = validateParameter(valid_590241, JString, required = false,
                                 default = nil)
  if valid_590241 != nil:
    section.add "oauth_token", valid_590241
  var valid_590242 = query.getOrDefault("userIp")
  valid_590242 = validateParameter(valid_590242, JString, required = false,
                                 default = nil)
  if valid_590242 != nil:
    section.add "userIp", valid_590242
  var valid_590243 = query.getOrDefault("key")
  valid_590243 = validateParameter(valid_590243, JString, required = false,
                                 default = nil)
  if valid_590243 != nil:
    section.add "key", valid_590243
  var valid_590244 = query.getOrDefault("prettyPrint")
  valid_590244 = validateParameter(valid_590244, JBool, required = false,
                                 default = newJBool(true))
  if valid_590244 != nil:
    section.add "prettyPrint", valid_590244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590245: Call_YoutubeVideosRate_590233; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a like or dislike rating to a video or remove a rating from a video.
  ## 
  let valid = call_590245.validator(path, query, header, formData, body)
  let scheme = call_590245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590245.url(scheme.get, call_590245.host, call_590245.base,
                         call_590245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590245, url, valid)

proc call*(call_590246: Call_YoutubeVideosRate_590233; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          rating: string = "dislike"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeVideosRate
  ## Add a like or dislike rating to a video or remove a rating from a video.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube video ID of the video that is being rated or having its rating removed.
  ##   alt: string
  ##      : Data format for the response.
  ##   rating: string (required)
  ##         : Specifies the rating to record.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_590247 = newJObject()
  add(query_590247, "fields", newJString(fields))
  add(query_590247, "quotaUser", newJString(quotaUser))
  add(query_590247, "id", newJString(id))
  add(query_590247, "alt", newJString(alt))
  add(query_590247, "rating", newJString(rating))
  add(query_590247, "oauth_token", newJString(oauthToken))
  add(query_590247, "userIp", newJString(userIp))
  add(query_590247, "key", newJString(key))
  add(query_590247, "prettyPrint", newJBool(prettyPrint))
  result = call_590246.call(nil, query_590247, nil, nil, nil)

var youtubeVideosRate* = Call_YoutubeVideosRate_590233(name: "youtubeVideosRate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/videos/rate",
    validator: validate_YoutubeVideosRate_590234, base: "/youtube/v3",
    url: url_YoutubeVideosRate_590235, schemes: {Scheme.Https})
type
  Call_YoutubeVideosReportAbuse_590248 = ref object of OpenApiRestCall_588466
proc url_YoutubeVideosReportAbuse_590250(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeVideosReportAbuse_590249(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Report abuse for a video.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590251 = query.getOrDefault("onBehalfOfContentOwner")
  valid_590251 = validateParameter(valid_590251, JString, required = false,
                                 default = nil)
  if valid_590251 != nil:
    section.add "onBehalfOfContentOwner", valid_590251
  var valid_590252 = query.getOrDefault("fields")
  valid_590252 = validateParameter(valid_590252, JString, required = false,
                                 default = nil)
  if valid_590252 != nil:
    section.add "fields", valid_590252
  var valid_590253 = query.getOrDefault("quotaUser")
  valid_590253 = validateParameter(valid_590253, JString, required = false,
                                 default = nil)
  if valid_590253 != nil:
    section.add "quotaUser", valid_590253
  var valid_590254 = query.getOrDefault("alt")
  valid_590254 = validateParameter(valid_590254, JString, required = false,
                                 default = newJString("json"))
  if valid_590254 != nil:
    section.add "alt", valid_590254
  var valid_590255 = query.getOrDefault("oauth_token")
  valid_590255 = validateParameter(valid_590255, JString, required = false,
                                 default = nil)
  if valid_590255 != nil:
    section.add "oauth_token", valid_590255
  var valid_590256 = query.getOrDefault("userIp")
  valid_590256 = validateParameter(valid_590256, JString, required = false,
                                 default = nil)
  if valid_590256 != nil:
    section.add "userIp", valid_590256
  var valid_590257 = query.getOrDefault("key")
  valid_590257 = validateParameter(valid_590257, JString, required = false,
                                 default = nil)
  if valid_590257 != nil:
    section.add "key", valid_590257
  var valid_590258 = query.getOrDefault("prettyPrint")
  valid_590258 = validateParameter(valid_590258, JBool, required = false,
                                 default = newJBool(true))
  if valid_590258 != nil:
    section.add "prettyPrint", valid_590258
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

proc call*(call_590260: Call_YoutubeVideosReportAbuse_590248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Report abuse for a video.
  ## 
  let valid = call_590260.validator(path, query, header, formData, body)
  let scheme = call_590260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590260.url(scheme.get, call_590260.host, call_590260.base,
                         call_590260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590260, url, valid)

proc call*(call_590261: Call_YoutubeVideosReportAbuse_590248;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## youtubeVideosReportAbuse
  ## Report abuse for a video.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_590262 = newJObject()
  var body_590263 = newJObject()
  add(query_590262, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_590262, "fields", newJString(fields))
  add(query_590262, "quotaUser", newJString(quotaUser))
  add(query_590262, "alt", newJString(alt))
  add(query_590262, "oauth_token", newJString(oauthToken))
  add(query_590262, "userIp", newJString(userIp))
  add(query_590262, "key", newJString(key))
  if body != nil:
    body_590263 = body
  add(query_590262, "prettyPrint", newJBool(prettyPrint))
  result = call_590261.call(nil, query_590262, nil, nil, body_590263)

var youtubeVideosReportAbuse* = Call_YoutubeVideosReportAbuse_590248(
    name: "youtubeVideosReportAbuse", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/videos/reportAbuse",
    validator: validate_YoutubeVideosReportAbuse_590249, base: "/youtube/v3",
    url: url_YoutubeVideosReportAbuse_590250, schemes: {Scheme.Https})
type
  Call_YoutubeWatermarksSet_590264 = ref object of OpenApiRestCall_588466
proc url_YoutubeWatermarksSet_590266(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeWatermarksSet_590265(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads a watermark image to YouTube and sets it for a channel.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   channelId: JString (required)
  ##            : The channelId parameter specifies the YouTube channel ID for which the watermark is being provided.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590267 = query.getOrDefault("onBehalfOfContentOwner")
  valid_590267 = validateParameter(valid_590267, JString, required = false,
                                 default = nil)
  if valid_590267 != nil:
    section.add "onBehalfOfContentOwner", valid_590267
  var valid_590268 = query.getOrDefault("fields")
  valid_590268 = validateParameter(valid_590268, JString, required = false,
                                 default = nil)
  if valid_590268 != nil:
    section.add "fields", valid_590268
  var valid_590269 = query.getOrDefault("quotaUser")
  valid_590269 = validateParameter(valid_590269, JString, required = false,
                                 default = nil)
  if valid_590269 != nil:
    section.add "quotaUser", valid_590269
  var valid_590270 = query.getOrDefault("alt")
  valid_590270 = validateParameter(valid_590270, JString, required = false,
                                 default = newJString("json"))
  if valid_590270 != nil:
    section.add "alt", valid_590270
  var valid_590271 = query.getOrDefault("oauth_token")
  valid_590271 = validateParameter(valid_590271, JString, required = false,
                                 default = nil)
  if valid_590271 != nil:
    section.add "oauth_token", valid_590271
  var valid_590272 = query.getOrDefault("userIp")
  valid_590272 = validateParameter(valid_590272, JString, required = false,
                                 default = nil)
  if valid_590272 != nil:
    section.add "userIp", valid_590272
  assert query != nil,
        "query argument is necessary due to required `channelId` field"
  var valid_590273 = query.getOrDefault("channelId")
  valid_590273 = validateParameter(valid_590273, JString, required = true,
                                 default = nil)
  if valid_590273 != nil:
    section.add "channelId", valid_590273
  var valid_590274 = query.getOrDefault("key")
  valid_590274 = validateParameter(valid_590274, JString, required = false,
                                 default = nil)
  if valid_590274 != nil:
    section.add "key", valid_590274
  var valid_590275 = query.getOrDefault("prettyPrint")
  valid_590275 = validateParameter(valid_590275, JBool, required = false,
                                 default = newJBool(true))
  if valid_590275 != nil:
    section.add "prettyPrint", valid_590275
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

proc call*(call_590277: Call_YoutubeWatermarksSet_590264; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads a watermark image to YouTube and sets it for a channel.
  ## 
  let valid = call_590277.validator(path, query, header, formData, body)
  let scheme = call_590277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590277.url(scheme.get, call_590277.host, call_590277.base,
                         call_590277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590277, url, valid)

proc call*(call_590278: Call_YoutubeWatermarksSet_590264; channelId: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## youtubeWatermarksSet
  ## Uploads a watermark image to YouTube and sets it for a channel.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   channelId: string (required)
  ##            : The channelId parameter specifies the YouTube channel ID for which the watermark is being provided.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_590279 = newJObject()
  var body_590280 = newJObject()
  add(query_590279, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_590279, "fields", newJString(fields))
  add(query_590279, "quotaUser", newJString(quotaUser))
  add(query_590279, "alt", newJString(alt))
  add(query_590279, "oauth_token", newJString(oauthToken))
  add(query_590279, "userIp", newJString(userIp))
  add(query_590279, "channelId", newJString(channelId))
  add(query_590279, "key", newJString(key))
  if body != nil:
    body_590280 = body
  add(query_590279, "prettyPrint", newJBool(prettyPrint))
  result = call_590278.call(nil, query_590279, nil, nil, body_590280)

var youtubeWatermarksSet* = Call_YoutubeWatermarksSet_590264(
    name: "youtubeWatermarksSet", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/watermarks/set",
    validator: validate_YoutubeWatermarksSet_590265, base: "/youtube/v3",
    url: url_YoutubeWatermarksSet_590266, schemes: {Scheme.Https})
type
  Call_YoutubeWatermarksUnset_590281 = ref object of OpenApiRestCall_588466
proc url_YoutubeWatermarksUnset_590283(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeWatermarksUnset_590282(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a channel's watermark image.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   channelId: JString (required)
  ##            : The channelId parameter specifies the YouTube channel ID for which the watermark is being unset.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590284 = query.getOrDefault("onBehalfOfContentOwner")
  valid_590284 = validateParameter(valid_590284, JString, required = false,
                                 default = nil)
  if valid_590284 != nil:
    section.add "onBehalfOfContentOwner", valid_590284
  var valid_590285 = query.getOrDefault("fields")
  valid_590285 = validateParameter(valid_590285, JString, required = false,
                                 default = nil)
  if valid_590285 != nil:
    section.add "fields", valid_590285
  var valid_590286 = query.getOrDefault("quotaUser")
  valid_590286 = validateParameter(valid_590286, JString, required = false,
                                 default = nil)
  if valid_590286 != nil:
    section.add "quotaUser", valid_590286
  var valid_590287 = query.getOrDefault("alt")
  valid_590287 = validateParameter(valid_590287, JString, required = false,
                                 default = newJString("json"))
  if valid_590287 != nil:
    section.add "alt", valid_590287
  var valid_590288 = query.getOrDefault("oauth_token")
  valid_590288 = validateParameter(valid_590288, JString, required = false,
                                 default = nil)
  if valid_590288 != nil:
    section.add "oauth_token", valid_590288
  var valid_590289 = query.getOrDefault("userIp")
  valid_590289 = validateParameter(valid_590289, JString, required = false,
                                 default = nil)
  if valid_590289 != nil:
    section.add "userIp", valid_590289
  assert query != nil,
        "query argument is necessary due to required `channelId` field"
  var valid_590290 = query.getOrDefault("channelId")
  valid_590290 = validateParameter(valid_590290, JString, required = true,
                                 default = nil)
  if valid_590290 != nil:
    section.add "channelId", valid_590290
  var valid_590291 = query.getOrDefault("key")
  valid_590291 = validateParameter(valid_590291, JString, required = false,
                                 default = nil)
  if valid_590291 != nil:
    section.add "key", valid_590291
  var valid_590292 = query.getOrDefault("prettyPrint")
  valid_590292 = validateParameter(valid_590292, JBool, required = false,
                                 default = newJBool(true))
  if valid_590292 != nil:
    section.add "prettyPrint", valid_590292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590293: Call_YoutubeWatermarksUnset_590281; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a channel's watermark image.
  ## 
  let valid = call_590293.validator(path, query, header, formData, body)
  let scheme = call_590293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590293.url(scheme.get, call_590293.host, call_590293.base,
                         call_590293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590293, url, valid)

proc call*(call_590294: Call_YoutubeWatermarksUnset_590281; channelId: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeWatermarksUnset
  ## Deletes a channel's watermark image.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   channelId: string (required)
  ##            : The channelId parameter specifies the YouTube channel ID for which the watermark is being unset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_590295 = newJObject()
  add(query_590295, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_590295, "fields", newJString(fields))
  add(query_590295, "quotaUser", newJString(quotaUser))
  add(query_590295, "alt", newJString(alt))
  add(query_590295, "oauth_token", newJString(oauthToken))
  add(query_590295, "userIp", newJString(userIp))
  add(query_590295, "channelId", newJString(channelId))
  add(query_590295, "key", newJString(key))
  add(query_590295, "prettyPrint", newJBool(prettyPrint))
  result = call_590294.call(nil, query_590295, nil, nil, nil)

var youtubeWatermarksUnset* = Call_YoutubeWatermarksUnset_590281(
    name: "youtubeWatermarksUnset", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/watermarks/unset",
    validator: validate_YoutubeWatermarksUnset_590282, base: "/youtube/v3",
    url: url_YoutubeWatermarksUnset_590283, schemes: {Scheme.Https})
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
